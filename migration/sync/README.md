# Old (v1..v6) → v2 data sync

Keeps the **v2** database continuously up to date with the still-live **old**
database while both run in parallel. Because the user-level migration only
*added* tables/columns and kept the same UUID primary keys, rows are matched by
`id` and upserted.

## Files

| File | Where it runs | When |
|---|---|---|
| `01-old-db-tracking.sql` | **OLD** DB | once, before first sync |
| `../../src/scripts/sync-old-to-v2.ts` | worker → reads OLD, writes v2 | every run |
| `../../src/scripts/sync-scheduler.ts` | worker | always-on (cron) |

## Setup (one time)

1. **Enable change tracking on the OLD DB** (additive, non-destructive — adds an
   `updated_at` column + triggers and a `sync_deletions` audit table):

   ```bash
   psql "$OLD_POSTGRES_CONNECTION_STRING" -f migration/sync/01-old-db-tracking.sql
   ```

2. **Confirm the v2 plan structure exists** (the user-level migration already
   inserted `basic` / `gratis` plans). The subscription remap needs them.

3. **Set env vars** (the worker needs both DBs):

   ```
   OLD_POSTGRES_CONNECTION_STRING=postgres://…   # source (old v1..v6)
   POSTGRES_CONNECTION_STRING=postgres://…       # target (v2, same var the app uses)
   SYNC_TRIGGER_TOKEN=<long-random-secret>       # required for the /internal/sync endpoint
   SYNC_BATCH_SIZE=500                            # optional
   SYNC_CRON=*/5 * * * *                          # optional, standalone-worker interval
   ```

## Running

There are two ways to drive it. Pick one.

### A) HTTP endpoint + external cron (recommended on Cloud Run, free)

The API already deployed on Cloud Run exposes a token-guarded trigger:

```
GET|POST  https://<your-service>/internal/sync?token=<SYNC_TRIGGER_TOKEN>
#          or send the token as the  x-sync-token  header
```

It runs **one sync pass synchronously** and returns a JSON summary
(`200 ok`, `409 skipped` if another run holds the lock, `401` bad token).
No always-on worker needed — Cloud Run scales to zero and the cron ping wakes it.

Setup:

1. Add env vars to the Cloud Run **service** (same service as the API):
   `OLD_POSTGRES_CONNECTION_STRING`, and a strong random `SYNC_TRIGGER_TOKEN`.
   (`POSTGRES_CONNECTION_STRING` is already set for the app.)
2. Raise the service **request timeout** to cover a worst-case run, e.g. 600s:
   `gcloud run services update <svc> --timeout=600`.
3. Point a free scheduler at the URL every N minutes:
   - **Google Cloud Scheduler** (free tier = 3 jobs):
     ```bash
     gcloud scheduler jobs create http sync-old-to-v2 \
       --schedule="*/5 * * * *" \
       --uri="https://<your-service>/internal/sync?token=<TOKEN>" \
       --http-method=POST \
       --attempt-deadline=600s
     ```
   - or **cron-job.org** (see step-by-step below).

> Run the **first (full backfill)** pass manually with `npm run sync:once` — it can
> be long and is better not gated by an HTTP timeout. After that, the endpoint
> only ever does quick incremental passes.

#### cron-job.org step-by-step

1. Sign up (free) at https://cron-job.org and open **Cronjobs → Create cronjob**.
2. **Title:** `sync-old-to-v2`
3. **URL:** `https://<your-service>/internal/sync`
4. **Schedule:** every 5 minutes (`Every 5 minutes`, or custom `*/5 * * * *`).
5. **Request method:** `POST` (GET also works).
6. **Headers** (Advanced → Headers): add
   `x-sync-token: <SYNC_TRIGGER_TOKEN>` — prefer this over `?token=` so the
   secret isn't stored in the URL/history.
7. Save. Optionally enable failure notifications.

Notes:
- cron-job.org waits ~30s for a response on the free plan. Incremental runs are
  well under that. If a busy run ever exceeds it, cron-job.org marks that ping
  failed and drops the connection — harmless: the run is idempotent and the next
  tick resumes from the last watermark.
- The endpoint returns `200` for both `ok` and `skipped`, so the dashboard stays
  green; only `401` (bad token) / `500` (real error) show red.

### B) Standalone worker (if you prefer a long-running process)

```bash
npm run sync:once     # single pass, then exit
npm run sync:watch    # loop forever on SYNC_CRON (its own always-on worker)
npm run sync:once:prod / npm run sync:watch:prod   # built (dist) equivalents
```

Either way, the **first run does the full initial backfill** (watermark starts
at epoch); every run after that is incremental. A Postgres advisory lock means
the endpoint and a worker can even coexist without double-running.

## How a run works

For each table, FK-parent-first:

1. Read the watermark from `v2.sync_state`.
2. Pull old rows where `updated_at > watermark` (minus a 2s overlap),
   keyset-paginated by `(updated_at, id)`.
3. Upsert into v2 on the columns **common to both schemas with matching types**
   (introspected at runtime), via `INSERT … ON CONFLICT (id) DO UPDATE`.
4. Advance the watermark per batch (resumable).

Then: create a default `OTL-001` outlet for any new merchant and backfill
`outlet_id` on child rows; remap subscriptions to the new plan structure; replay
hard deletes from `sync_deletions`.

## Design decisions & assumptions

- **Idempotent.** Upserts + a watermark overlap mean a crashed/re-run pass is
  safe. Re-running the whole thing never duplicates.
- **Change detection = `updated_at`.** The OLD base tables had no `updated_at`,
  so `01-old-db-tracking.sql` adds it plus a `BEFORE INSERT OR UPDATE` trigger.
  **Edits made before that script runs are invisible** — run it before the
  parallel period begins.
- **Columns are introspected, not hardcoded**, so schema drift between old and
  v2 (dropped `users.phone_number/address`, `app_invoices.user_id` being
  `bigint` vs `uuid`, etc.) is handled automatically: mismatched-type or
  missing columns are simply skipped.
- **Not copied:** `updated_at` (sync artifact), `sequence_id` (SERIAL/UNIQUE —
  v2 regenerates), `transaction."order"` (set by a v2 INSERT trigger). ⇒
  display sequence numbers may differ between the two systems. If you need them
  identical, remove them from `GLOBAL_EXCLUDE` and load with triggers disabled.
- **`app_plans` is NOT synced.** v2 owns its own plan rows; the old plan rows
  were deleted by the migration. Subscriptions are remapped instead:
  `1bulan/3bulan/6bulan/12bulan → basic`, `gratis → gratis`, with `end_date` and
  `duration` recomputed exactly like migration v15.
- **Direction is one-way (old → v2).** Rows created/edited *on v2* are never
  pushed back to old. Fine for a read-mostly parallel run; if v2 also takes
  writes to the same rows, the old edit wins on the next sync (last-writer =
  old). Decide your write ownership accordingly.
- **Deletes** rely on the `sync_deletions` audit table. Only hard `DELETE`s are
  captured; if the old app soft-deletes (`is_deleted = true`), that flows
  through as a normal column update instead.

## Operational notes

- Safe to run the scheduler on a single instance only (the mutex prevents
  overlap within a process, but two processes would double-scan — harmless but
  wasteful).
- `sync_deletions` on the old DB grows unbounded; periodically
  `DELETE FROM sync_deletions WHERE id <= <last processed cursor>` — find the
  cursor in `v2.sync_state` where `table_name = '__deletions__'`.
- To force a full re-sync of one table:
  `DELETE FROM sync_state WHERE table_name = '<table>';` then run once.
