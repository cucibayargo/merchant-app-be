-- ============================================================
-- v16.sql — Fix duplicate transaction "order" values
--
-- Root cause
-- ----------
-- set_order_for_transaction() assigned the order with `SELECT COUNT(*) + 1`.
-- That is not safe and produces duplicates three different ways:
--
--   1. Multi-row INSERT batches (the sync inserts 500 rows per statement):
--      a BEFORE INSERT ... FOR EACH ROW trigger runs the COUNT against the
--      statement snapshot, so rows inserted earlier in the SAME statement are
--      not visible yet. Every row in one batch sees the same count and gets an
--      IDENTICAL order value.
--   2. Concurrent inserts: two transactions read the same committed count
--      before either commits, so both write count+1.
--   3. Soft-deletes: the `deleted_at IS NULL` filter shrinks the count, so the
--      next insert re-uses an order value a live row already holds.
--
-- Fix
-- ---
-- Replace the count-based trigger with an atomic per-scope counter, repair the
-- existing duplicates by renumbering, and add a partial unique index as a guard.
--
-- Scope = COALESCE(outlet_id, merchant_id) — an outlet-scoped counter when the
-- transaction belongs to an outlet, otherwise merchant-scoped. This matches the
-- IF/ELSE branches of the original trigger.
--
-- Idempotent and safe to re-run.
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. Per-scope monotonic counter
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS transaction_order_seq (
    scope_key  text   PRIMARY KEY,   -- COALESCE(outlet_id, merchant_id) as text
    last_order bigint NOT NULL DEFAULT 0
);

-- ------------------------------------------------------------
-- 2. Repair existing duplicates
--    Renumber EVERY transaction (live AND soft-deleted) within its scope by
--    creation order, so each row gets a globally-unique order per scope.
--
--    Deleted rows are included on purpose: their order feeds payment.invoice_id
--    (regenerated in step 2b), and a deleted invoice number must not clash with
--    a live one. This leaves gaps in the live sequence where deletions happened
--    — which is the correct invoice behavior (a voided number isn't recycled).
-- ------------------------------------------------------------
WITH renumbered AS (
    SELECT
        id,
        ROW_NUMBER() OVER (
            PARTITION BY COALESCE(outlet_id::text, merchant_id::text)
            ORDER BY created_at ASC, id ASC
        ) AS new_order
    FROM transaction
)
UPDATE transaction t
SET "order" = r.new_order
FROM renumbered r
WHERE t.id = r.id
  AND t."order" IS DISTINCT FROM r.new_order;

-- ------------------------------------------------------------
-- 2b. Regenerate payment.invoice_id to match the repaired order.
--     invoice_id is a stored string built from the transaction's order at
--     creation time, so renumbering above would otherwise leave it stale.
--     Format mirrors generateInvoiceId() in
--     src/modules/transaction/controller.ts: INV-{outlet.sequence_id||0}.{order}
--     with order left-padded to 4 digits. Keep the two in sync if that changes.
--
--     ONLY new-format invoices (INV-<seq>.<order>, which always contain a '.')
--     are regenerated. Legacy invoices like 'INV-71503202613' are NOT derived
--     from order and are left exactly as-is.
--
--     NOTE: this does NOT deduplicate payments that share a transaction_id
--     (two payment rows for one order) — that is a separate double-insert issue.
--     See check-duplicate-payment.sql, section B.
-- ------------------------------------------------------------
UPDATE payment p
SET invoice_id = 'INV-' || COALESCE(o.sequence_id::text, '0')
              || '.' || lpad(t."order"::text, 4, '0')
FROM transaction t
LEFT JOIN outlets o ON o.id = t.outlet_id
WHERE p.transaction_id = t.id
  AND p.invoice_id LIKE 'INV-%.%'          -- new-format only; skip legacy invoices
  AND p.invoice_id IS DISTINCT FROM
      'INV-' || COALESCE(o.sequence_id::text, '0') || '.' || lpad(t."order"::text, 4, '0');

-- ------------------------------------------------------------
-- 3. Seed the counter from the repaired data
--    last_order = highest order EVER assigned in the scope, including
--    soft-deleted rows. Counting deleted rows too means a deleted (e.g. the
--    highest) invoice number is never handed out again — invoice numbers are
--    never recycled, even for a deleted order.
-- ------------------------------------------------------------
INSERT INTO transaction_order_seq (scope_key, last_order)
SELECT
    COALESCE(outlet_id::text, merchant_id::text) AS scope_key,
    MAX("order")                                 AS last_order
FROM transaction
WHERE COALESCE(outlet_id::text, merchant_id::text) IS NOT NULL
GROUP BY COALESCE(outlet_id::text, merchant_id::text)
ON CONFLICT (scope_key)
DO UPDATE SET last_order = GREATEST(transaction_order_seq.last_order, EXCLUDED.last_order);

-- ------------------------------------------------------------
-- 4. Replace the trigger function with an atomic counter
--    The INSERT ... ON CONFLICT DO UPDATE ... RETURNING takes a row lock on the
--    scope's counter row, so:
--      - concurrent inserts serialize (no race),
--      - each row in a multi-row batch gets its own increment (no batch dupes),
--      - numbers are never re-used after a soft-delete (monotonic, not counted).
--
--    Scope resolution (per-outlet):
--      - If outlet_id is set, scope by it (native v2 inserts always set it).
--      - If outlet_id is NULL (the sync inserts rows before the outlet backfill
--        assigns one), resolve the merchant's PRIMARY outlet — the same one the
--        backfill will later assign — and scope by that, so the order the row
--        eventually carries under its outlet is already unique. Falls back to
--        merchant_id only when the merchant has no outlet yet (a brand-new
--        merchant on its first sync pass; the sync then reseeds the counter
--        after creating the outlet — see sync-old-to-v2.ts applyOutletBackfill).
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION set_order_for_transaction()
RETURNS TRIGGER AS $$
DECLARE
  v_scope text;
  v_next  bigint;
BEGIN
  v_scope := COALESCE(
    NEW.outlet_id::text,
    (
      -- Merchant's primary outlet = earliest live outlet by sequence_id,
      -- matching the backfill's DISTINCT ON (merchant_id) ... ORDER BY sequence_id.
      SELECT o.id::text
      FROM outlets o
      WHERE o.merchant_id = NEW.merchant_id
        AND o.deleted_at IS NULL
      ORDER BY o.sequence_id ASC
      LIMIT 1
    ),
    NEW.merchant_id::text
  );

  IF v_scope IS NULL THEN
    -- Nothing to scope by; leave order unset.
    RETURN NEW;
  END IF;

  INSERT INTO transaction_order_seq (scope_key, last_order)
  VALUES (v_scope, 1)
  ON CONFLICT (scope_key)
  DO UPDATE SET last_order = transaction_order_seq.last_order + 1
  RETURNING last_order INTO v_next;

  NEW."order" := v_next;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger definition is unchanged (BEFORE INSERT FOR EACH ROW); recreated here
-- so a database that never had it still gets it.
DROP TRIGGER IF EXISTS trigger_set_order ON transaction;
CREATE TRIGGER trigger_set_order
BEFORE INSERT ON transaction
FOR EACH ROW
EXECUTE FUNCTION set_order_for_transaction();

-- ------------------------------------------------------------
-- 5. Guard: a live transaction's order must be unique within its scope.
--    Plain (non-concurrent) index so it runs inside this transaction — required
--    by SQL runners that wrap the whole script in one transaction block. It
--    takes a brief write lock on `transaction` while building; run in a
--    maintenance window. Step 2 (the renumber) must have removed all dupes
--    first, or index creation fails.
--
--    For a very large table where you cannot afford the write lock, DELETE this
--    statement, run the rest of v16.sql, then build the index separately in a
--    session that is NOT inside a transaction:
--      CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS idx_transaction_order_unique
--        ON transaction (COALESCE(outlet_id, merchant_id), "order")
--        WHERE deleted_at IS NULL;
-- ------------------------------------------------------------
CREATE UNIQUE INDEX IF NOT EXISTS idx_transaction_order_unique
  ON transaction (COALESCE(outlet_id, merchant_id), "order")
  WHERE deleted_at IS NULL;

COMMIT;
