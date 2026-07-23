-- ============================================================
-- list-duplicate-invoice-with-deleted.sql
--
-- READ-ONLY. Lists every payment whose invoice_id is shared by more than one
-- payment row, alongside whether the linked transaction is soft-deleted — so
-- you can see the "duplicated with a deleted transaction" cases after a reorder.
-- Changes nothing.
--
--   psql "$POSTGRES_CONNECTION_STRING" -f migration/list-duplicate-invoice-with-deleted.sql
-- ============================================================

SELECT
    p.invoice_id,
    p.id                          AS payment_id,
    p.transaction_id,
    (t.id IS NULL)                AS transaction_missing,     -- payment has no matching transaction
    (t.deleted_at IS NOT NULL)    AS transaction_deleted,
    t.deleted_at                  AS transaction_deleted_at,
    t."order"                     AS transaction_order,
    p.outlet_id,
    p.status,
    p.created_at                  AS payment_created_at
FROM payment p
LEFT JOIN transaction t ON t.id = p.transaction_id
WHERE p.invoice_id IN (
    SELECT invoice_id
    FROM payment
    WHERE invoice_id IS NOT NULL
    GROUP BY invoice_id
    HAVING COUNT(*) > 1
)
ORDER BY p.invoice_id,
         (t.deleted_at IS NOT NULL),   -- live rows first, deleted rows after
         p.created_at,
         p.id;
