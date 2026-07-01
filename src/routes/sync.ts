/**
 * Internal sync trigger endpoint.
 *
 * Lets an external scheduler (Google Cloud Scheduler, cron-job.org, …) run one
 * old->v2 sync pass by hitting a URL on the already-deployed Cloud Run service.
 *
 * Protected by a shared secret in the `SYNC_TRIGGER_TOKEN` env var, passed
 * either as `?token=…` or the `x-sync-token` header.
 *
 * IMPORTANT (Cloud Run): the handler runs the sync SYNCHRONOUSLY and only
 * responds when it finishes, because Cloud Run throttles CPU outside of a
 * request. Set the Cloud Run request timeout (and the scheduler's timeout)
 * comfortably above a worst-case run — e.g. 600s. Incremental runs finish in
 * seconds; the first (full backfill) run may be long, so trigger that one
 * manually via `npm run sync:once` instead of the endpoint.
 *
 * Responses: 200 {status:"ok"} on a completed run, 200 {status:"skipped"} when
 * another run holds the lock (normal — keeps cron monitors green), 401 on a bad
 * token, 500 on failure. Runs are idempotent + resumable, so if the scheduler
 * times out and drops the connection mid-run, the next tick just continues.
 *
 * Mounted OUTSIDE the user-auth middleware (see src/api.ts).
 */

import { Router, Request, Response } from "express";
import { runSyncOnce } from "../scripts/sync-old-to-v2";

const router = Router();

function isAuthorized(req: Request): boolean {
  const expected = process.env.SYNC_TRIGGER_TOKEN;
  if (!expected) return false; // fail closed if not configured
  const provided =
    (req.query.token as string | undefined) ||
    (req.headers["x-sync-token"] as string | undefined);
  return provided === expected;
}

async function handle(req: Request, res: Response) {
  if (!isAuthorized(req)) {
    return res.status(401).json({ status: "unauthorized" });
  }
  try {
    const summary = await runSyncOnce();
    // 200 for both a completed run AND a skipped one (another run holds the
    // lock) — "skipped" is normal, so keep cron monitors green. Only real
    // failures (401/500) are non-2xx.
    return res.status(200).json({
      status: summary.skipped ? "skipped" : "ok",
      ...summary,
    });
  } catch (err: any) {
    console.error("[sync-endpoint] failed", err);
    return res
      .status(500)
      .json({ status: "error", message: err?.message ?? "sync failed" });
  }
}

// GET is convenient for simple cron hubs; POST is available too.
router.get("/sync", handle);
router.post("/sync", handle);

export default router;
