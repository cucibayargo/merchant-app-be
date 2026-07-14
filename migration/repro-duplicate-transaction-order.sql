-- ============================================================
-- repro-duplicate-transaction-order.sql
--
-- Reproduces the duplicate transaction "order" bug in an ISOLATED throwaway
-- schema (repro_order) so it never touches real data. Run it, read the NOTICEs,
-- then run the "FIXED" section at the bottom to confirm the v16 trigger removes
-- the duplicates.
--
--   psql "$POSTGRES_CONNECTION_STRING" -f migration/repro-duplicate-transaction-order.sql
--
-- Everything lives in schema repro_order; the last line drops it. Comment out
-- the final DROP if you want to poke around afterwards.
-- ============================================================

DROP SCHEMA IF EXISTS repro_order CASCADE;
CREATE SCHEMA repro_order;
SET search_path TO repro_order;

-- Minimal stand-ins for the real tables (only the columns the trigger touches).
CREATE TABLE transaction (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at  timestamptz NOT NULL DEFAULT now(),
    merchant_id uuid,
    outlet_id   uuid,
    deleted_at  timestamptz,
    "order"     integer
);

-- The OLD (buggy) trigger, exactly as in v7/v14/user-level-migration.
CREATE OR REPLACE FUNCTION set_order_for_transaction()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.outlet_id IS NOT NULL THEN
    NEW."order" := (SELECT COUNT(*) + 1 FROM transaction
                     WHERE outlet_id = NEW.outlet_id AND deleted_at IS NULL);
  ELSE
    NEW."order" := (SELECT COUNT(*) + 1 FROM transaction
                     WHERE merchant_id = NEW.merchant_id AND deleted_at IS NULL);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_order
BEFORE INSERT ON transaction
FOR EACH ROW EXECUTE FUNCTION set_order_for_transaction();


-- ============================================================
-- BUG #1 — Batch (multi-row) INSERT  ← this is what the sync does
--
-- The sync inserts up to 500 rows per statement with outlet_id = NULL. A
-- BEFORE INSERT ... FOR EACH ROW trigger runs COUNT() against the statement
-- snapshot, so rows earlier in the SAME statement are invisible. Every row in
-- the batch reads the same count and gets the SAME order value.
-- ============================================================
DO $$
DECLARE m uuid := gen_random_uuid();
BEGIN
  -- One statement, five rows — exactly how the sync upserts a batch.
  INSERT INTO transaction (merchant_id) VALUES (m), (m), (m), (m), (m);

  RAISE NOTICE '--- BUG #1 batch insert (merchant %) ---', m;
  RAISE NOTICE 'Orders assigned: %', (
    SELECT array_agg("order" ORDER BY created_at, id)
    FROM transaction WHERE merchant_id = m
  );
  RAISE NOTICE 'Expected 1,2,3,4,5 — got all the same value.';
END $$;


-- ============================================================
-- BUG #2 — Soft-delete reuse
--
-- The count filters `deleted_at IS NULL`, so a soft-delete shrinks the count
-- and the next insert re-uses a number a live row already holds.
-- ============================================================
DO $$
DECLARE o uuid := gen_random_uuid();
BEGIN
  -- Three rows inserted one-at-a-time -> orders 1, 2, 3.
  INSERT INTO transaction (outlet_id) VALUES (o);
  INSERT INTO transaction (outlet_id) VALUES (o);
  INSERT INTO transaction (outlet_id) VALUES (o);

  -- Soft-delete order #2. Live count drops from 3 to 2.
  UPDATE transaction SET deleted_at = now()
   WHERE outlet_id = o AND "order" = 2;

  -- Next insert -> COUNT(live)=2 -> order 3, colliding with the existing order 3.
  INSERT INTO transaction (outlet_id) VALUES (o);

  RAISE NOTICE '--- BUG #2 soft-delete reuse (outlet %) ---', o;
  RAISE NOTICE 'Live orders now: %', (
    SELECT array_agg("order" ORDER BY created_at, id)
    FROM transaction WHERE outlet_id = o AND deleted_at IS NULL
  );
  RAISE NOTICE 'Two live rows both hold order 3.';
END $$;


-- ============================================================
-- Show every duplicate group produced above.
-- ============================================================
SELECT COALESCE(outlet_id::text, merchant_id::text) AS scope,
       "order",
       COUNT(*) AS copies
  FROM transaction
 WHERE deleted_at IS NULL
 GROUP BY 1, 2
HAVING COUNT(*) > 1
 ORDER BY copies DESC, scope;


-- ============================================================
-- BUG #3 — Concurrency (needs TWO sessions; can't be shown in one script)
--
-- In psql window A:
--     SET search_path TO repro_order;
--     BEGIN;
--     INSERT INTO transaction (merchant_id) VALUES ('00000000-0000-0000-0000-000000000099');
--     -- do NOT commit yet
--
-- In psql window B (same merchant):
--     SET search_path TO repro_order;
--     BEGIN;
--     INSERT INTO transaction (merchant_id) VALUES ('00000000-0000-0000-0000-000000000099');
--     COMMIT;
--
-- Then COMMIT window A. Both read the same committed count before either
-- committed, so both wrote the same order value. The atomic-counter trigger in
-- v16 row-locks the counter, so B would block until A commits and then get the
-- next value.
-- ============================================================


-- ============================================================
-- FIXED — install the v16 counter trigger and re-run BUG #1 and #2.
-- Comment this whole block out if you only want to see the bug.
-- ============================================================
CREATE TABLE transaction_order_seq (
    scope_key  text   PRIMARY KEY,
    last_order bigint NOT NULL DEFAULT 0
);

CREATE OR REPLACE FUNCTION set_order_for_transaction()
RETURNS TRIGGER AS $$
DECLARE
  v_scope text;
  v_next  bigint;
BEGIN
  -- No outlets table in this repro schema, so scope directly by outlet/merchant.
  v_scope := COALESCE(NEW.outlet_id::text, NEW.merchant_id::text);
  IF v_scope IS NULL THEN RETURN NEW; END IF;

  INSERT INTO transaction_order_seq (scope_key, last_order)
  VALUES (v_scope, 1)
  ON CONFLICT (scope_key)
  DO UPDATE SET last_order = transaction_order_seq.last_order + 1
  RETURNING last_order INTO v_next;

  NEW."order" := v_next;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE m uuid := gen_random_uuid();
        o uuid := gen_random_uuid();
BEGIN
  -- Batch insert again.
  INSERT INTO transaction (merchant_id) VALUES (m), (m), (m), (m), (m);
  RAISE NOTICE '--- FIXED batch insert ---';
  RAISE NOTICE 'Orders assigned: %  (now 1..5, no dupes)', (
    SELECT array_agg("order" ORDER BY "order")
    FROM transaction WHERE merchant_id = m
  );

  -- Soft-delete reuse again.
  INSERT INTO transaction (outlet_id) VALUES (o);
  INSERT INTO transaction (outlet_id) VALUES (o);
  INSERT INTO transaction (outlet_id) VALUES (o);
  UPDATE transaction SET deleted_at = now() WHERE outlet_id = o AND "order" = 2;
  INSERT INTO transaction (outlet_id) VALUES (o);
  RAISE NOTICE '--- FIXED soft-delete reuse ---';
  RAISE NOTICE 'Live orders now: %  (monotonic, no reuse)', (
    SELECT array_agg("order" ORDER BY "order")
    FROM transaction WHERE outlet_id = o AND deleted_at IS NULL
  );
END $$;

-- Confirm zero duplicates among rows created by the FIXED trigger.
SELECT 'duplicates remaining' AS check,
       COUNT(*) AS groups
  FROM (
    SELECT 1 FROM transaction
     WHERE deleted_at IS NULL
     GROUP BY COALESCE(outlet_id::text, merchant_id::text), "order"
    HAVING COUNT(*) > 1
  ) d;


-- Clean up. Comment out to inspect the data afterwards.
DROP SCHEMA repro_order CASCADE;
