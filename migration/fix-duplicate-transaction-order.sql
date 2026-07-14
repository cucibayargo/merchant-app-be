-- ============================================================
-- fix-duplicate-transaction-order.sql
--
-- Standalone repair for duplicate transaction "order" values.
--
-- Run this any time you find duplicate order numbers (e.g. on a database that
-- was populated before v16.sql, or after a sync run that used the old trigger).
-- It is idempotent — running it when there is nothing to fix is a no-op.
--
--   psql "$POSTGRES_CONNECTION_STRING" -f migration/fix-duplicate-transaction-order.sql
--
-- What it does:
--   1. Reports how many duplicate (scope, order) groups exist.
--   2. Renumbers every LIVE transaction within its scope by creation order,
--      guaranteeing 1..N with no gaps or duplicates.
--   3. Re-seeds transaction_order_seq (if that table exists) so the next insert
--      continues cleanly from the new max.
--
-- Scope = COALESCE(outlet_id, merchant_id), matching set_order_for_transaction().
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- 1. Report duplicates before repair (visible in psql output)
-- ------------------------------------------------------------
DO $$
DECLARE
  v_groups bigint;
  v_rows   bigint;
BEGIN
  SELECT COUNT(*), COALESCE(SUM(cnt), 0)
    INTO v_groups, v_rows
  FROM (
    SELECT COUNT(*) AS cnt
    FROM transaction
    WHERE deleted_at IS NULL
    GROUP BY COALESCE(outlet_id::text, merchant_id::text), "order"
    HAVING COUNT(*) > 1
  ) d;

  RAISE NOTICE 'Before repair: % duplicate (scope, order) groups covering % rows',
    v_groups, v_rows;
END $$;

-- ------------------------------------------------------------
-- 2. Renumber EVERY transaction (live + soft-deleted) per scope by creation
--    order, giving each a globally-unique order per scope. Deleted rows are
--    included so their order (which feeds payment.invoice_id, regenerated in
--    step 2b) never clashes with a live one.
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
--     Format mirrors generateInvoiceId() in
--     src/modules/transaction/controller.ts: INV-{outlet.sequence_id||0}.{order}
--     Only new-format invoices (INV-<seq>.<order>, containing a '.') are
--     touched; legacy invoices like 'INV-71503202613' are left as-is.
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
-- 3. Re-seed the per-scope counter if the table exists
--    (only relevant after v16.sql has created transaction_order_seq)
-- ------------------------------------------------------------
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'transaction_order_seq'
  ) THEN
    -- Seed from the highest order EVER assigned in the scope, including
    -- soft-deleted rows, so a deleted invoice number is never recycled.
    INSERT INTO transaction_order_seq (scope_key, last_order)
    SELECT
        COALESCE(outlet_id::text, merchant_id::text),
        MAX("order")
    FROM transaction
    WHERE COALESCE(outlet_id::text, merchant_id::text) IS NOT NULL
    GROUP BY COALESCE(outlet_id::text, merchant_id::text)
    ON CONFLICT (scope_key)
    DO UPDATE SET last_order = GREATEST(
      transaction_order_seq.last_order, EXCLUDED.last_order
    );
    RAISE NOTICE 'transaction_order_seq re-seeded.';
  ELSE
    RAISE NOTICE 'transaction_order_seq not found — run v16.sql to install the counter trigger.';
  END IF;
END $$;

-- ------------------------------------------------------------
-- 4. Verify no duplicates remain
-- ------------------------------------------------------------
DO $$
DECLARE
  v_groups bigint;
BEGIN
  SELECT COUNT(*)
    INTO v_groups
  FROM (
    SELECT 1
    FROM transaction
    WHERE deleted_at IS NULL
    GROUP BY COALESCE(outlet_id::text, merchant_id::text), "order"
    HAVING COUNT(*) > 1
  ) d;

  IF v_groups > 0 THEN
    RAISE EXCEPTION 'Repair failed: % duplicate groups still remain', v_groups;
  END IF;
  RAISE NOTICE 'After repair: 0 duplicate groups. OK.';
END $$;

COMMIT;
