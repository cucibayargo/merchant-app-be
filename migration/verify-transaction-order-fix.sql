-- ============================================================
-- verify-transaction-order-fix.sql
--
-- READ-ONLY. Run AFTER v16.sql to confirm the repair held. Every check should
-- report 0. Changes nothing — safe on prod.
--
--   psql "$POSTGRES_CONNECTION_STRING" -f migration/verify-transaction-order-fix.sql
--
-- Legacy invoices (INV-71503202613, no '.') are intentionally excluded from the
-- invoice_id checks — they are not derived from order and were left untouched.
-- ============================================================

-- 1. No live transaction shares an order within its scope.
SELECT 'duplicate live transaction order' AS check, COUNT(*) AS bad_groups
FROM (
    SELECT 1
    FROM transaction
    WHERE deleted_at IS NULL
    GROUP BY COALESCE(outlet_id::text, merchant_id::text), "order"
    HAVING COUNT(*) > 1
) d;

-- 2. No two payments share a new-format invoice_id.
SELECT 'duplicate new-format invoice_id' AS check, COUNT(*) AS bad_groups
FROM (
    SELECT 1
    FROM payment
    WHERE invoice_id LIKE 'INV-%.%'
    GROUP BY invoice_id
    HAVING COUNT(*) > 1
) d;

-- 3. Every new-format payment.invoice_id equals what generateInvoiceId() would
--    now produce from its transaction's order (i.e. stored string is in sync).
SELECT 'invoice_id out of sync with order' AS check, COUNT(*) AS bad_rows
FROM payment p
JOIN transaction t ON t.id = p.transaction_id
LEFT JOIN outlets o ON o.id = t.outlet_id
WHERE p.invoice_id LIKE 'INV-%.%'
  AND p.invoice_id <> 'INV-' || COALESCE(o.sequence_id::text, '0')
                    || '.' || lpad(t."order"::text, 4, '0');

-- 4. The counter is at least the max order in every scope (never hands out a
--    number already in use). bad_scopes should be 0.
SELECT 'counter behind max order' AS check, COUNT(*) AS bad_scopes
FROM (
    SELECT COALESCE(outlet_id::text, merchant_id::text) AS scope_key,
           MAX("order") AS max_order
    FROM transaction
    WHERE COALESCE(outlet_id::text, merchant_id::text) IS NOT NULL
    GROUP BY COALESCE(outlet_id::text, merchant_id::text)
) m
LEFT JOIN transaction_order_seq s ON s.scope_key = m.scope_key
WHERE COALESCE(s.last_order, 0) < m.max_order;
