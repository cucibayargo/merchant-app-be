-- ============================================================
-- 01-old-db-tracking.sql
--
-- RUN ONCE on the OLD database (v1..v6) before starting the sync.
--
-- The old base tables only have `created_at` — no `updated_at`,
-- no `deleted_at`. A created_at-only sync would miss EDITS
-- (transaction.status -> completed, subscription renewals, customer
-- edits, ...) and DELETES. This script adds the change-tracking the
-- sync job needs, additively and non-destructively:
--
--   1. Adds a nullable `updated_at` column to every synced table.
--   2. A BEFORE UPDATE trigger stamps `updated_at = now()` on every edit.
--   3. A `sync_deletions` audit table + AFTER DELETE trigger records
--      hard-deleted row ids so the sync can replay them on v2.
--
-- Re-runnable: every step is guarded (IF NOT EXISTS / CREATE OR REPLACE).
-- Nothing here changes existing data or application behaviour.
-- ============================================================

-- ------------------------------------------------------------
-- Trigger functions + audit table (must exist before CREATE TRIGGER
-- below, since Postgres resolves the function at trigger-creation time).
-- ------------------------------------------------------------

-- Stamps updated_at on both INSERT and UPDATE so EVERY row carries a
-- single, indexable change-time the sync can watermark on. (A BEFORE
-- UPDATE-only trigger would leave freshly inserted rows with a NULL
-- updated_at.)
CREATE OR REPLACE FUNCTION sync_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Audit table of hard-deleted rows, drained by the sync job.
-- row_id is TEXT so it can hold either a uuid or a bigint id (e.g. expenses.id
-- is a BIGSERIAL), depending on the source table.
CREATE TABLE IF NOT EXISTS sync_deletions (
    id          bigserial PRIMARY KEY,
    table_name  text        NOT NULL,
    row_id      text        NOT NULL,
    deleted_at  timestamptz NOT NULL DEFAULT now()
);

-- Migrate an older run's uuid column to text, if present. Idempotent.
ALTER TABLE sync_deletions ALTER COLUMN row_id TYPE text USING row_id::text;

CREATE INDEX IF NOT EXISTS idx_sync_deletions_pending
    ON sync_deletions (id);

CREATE OR REPLACE FUNCTION sync_track_delete()
RETURNS TRIGGER AS $$
BEGIN
    -- Store the id as text so uuid and bigint keys both work.
    INSERT INTO sync_deletions (table_name, row_id)
    VALUES (TG_TABLE_NAME, OLD.id::text);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


-- ------------------------------------------------------------
-- Attach tracking to every synced table.
-- Keep this list in sync with TABLES in the sync job.
-- ------------------------------------------------------------
DO $$
DECLARE
    t text;
    has_created_at boolean;
    tracked_tables text[] := ARRAY[
        'users',
        'customer',
        'service',
        'duration',
        'service_duration',
        'note',
        'transaction',
        'transaction_item',
        'payment',
        'expenses',
        'discounts',
        'printed_devices',
        'app_subscriptions',
        'app_transactions',
        'users_signup',
        'user_referral'
    ];
BEGIN
    FOREACH t IN ARRAY tracked_tables
    LOOP
        -- Skip tables that don't exist in this database (defensive).
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.tables
            WHERE table_schema = 'public' AND table_name = t
        ) THEN
            RAISE NOTICE 'skipping % (table not found)', t;
            CONTINUE;
        END IF;

        -- 1. Add updated_at if missing.
        EXECUTE format(
            'ALTER TABLE public.%I ADD COLUMN IF NOT EXISTS updated_at timestamptz',
            t
        );

        -- Backfill so existing rows have a sensible value. Prefer
        -- created_at, but some tables (e.g. printed_devices) don't have it,
        -- so fall back to now(). Only touches rows where it is still NULL,
        -- so it is cheap on reruns.
        SELECT EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'public'
              AND table_name = t
              AND column_name = 'created_at'
        ) INTO has_created_at;

        IF has_created_at THEN
            EXECUTE format(
                'UPDATE public.%I SET updated_at = created_at WHERE updated_at IS NULL',
                t
            );
        ELSE
            EXECUTE format(
                'UPDATE public.%I SET updated_at = now() WHERE updated_at IS NULL',
                t
            );
        END IF;

        -- Index updated_at so the watermark scan is cheap on large tables.
        EXECUTE format(
            'CREATE INDEX IF NOT EXISTS idx_%I_updated_at ON public.%I (updated_at)',
            t, t
        );

        -- 2. BEFORE INSERT OR UPDATE trigger to stamp updated_at on every write.
        EXECUTE format('DROP TRIGGER IF EXISTS trg_sync_set_updated_at ON public.%I', t);
        EXECUTE format(
            'CREATE TRIGGER trg_sync_set_updated_at
               BEFORE INSERT OR UPDATE ON public.%I
               FOR EACH ROW EXECUTE FUNCTION sync_set_updated_at()',
            t
        );

        -- 3. AFTER DELETE trigger to record hard deletes.
        EXECUTE format('DROP TRIGGER IF EXISTS trg_sync_track_delete ON public.%I', t);
        EXECUTE format(
            'CREATE TRIGGER trg_sync_track_delete
               AFTER DELETE ON public.%I
               FOR EACH ROW EXECUTE FUNCTION sync_track_delete()',
            t
        );

        RAISE NOTICE 'tracking enabled on %', t;
    END LOOP;
END $$;
