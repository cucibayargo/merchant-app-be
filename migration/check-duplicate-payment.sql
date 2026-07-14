-- ============================================================
-- check-duplicate-payment.sql
--
-- READ-ONLY. Finds duplicated payment rows. Changes nothing — safe on prod.
--
--   psql "$POSTGRES_CONNECTION_STRING" -f migration/check-duplicate-payment.sql
--
-- Two independent notions of "duplicate":
--   A. Same invoice_id on >1 payment row.
--      invoice_id is used as a lookup/update key (getPaymentByInvoiceId,
--      updatePayment WHERE invoice_id = ...), so duplicates make those hit the
--      wrong row or update several at once.
--   B. Same transaction_id on >1 payment row.
--      A transaction should have a single payment; >1 means a double-inserted
--      payment for one order.
-- ============================================================

-- ------------------------------------------------------------
-- A. Duplicate invoice_id
-- ------------------------------------------------------------

-- A1. Summary
SELECT 'duplicate invoice_id' AS check,
       COUNT(*)                     AS duplicate_groups,
       COALESCE(SUM(copies), 0)     AS rows_involved,
       COALESCE(SUM(copies - 1), 0) AS excess_rows
FROM (
    SELECT COUNT(*) AS copies
    FROM payment
    WHERE invoice_id IS NOT NULL
    GROUP BY invoice_id
    HAVING COUNT(*) > 1
) d;

-- A2. List: every payment row that shares its invoice_id with another.
SELECT
    p.invoice_id,
    p.id,
    p.transaction_id,
    p.outlet_id,
    p.status,
    p.total_amount_due,
    p.payment_received,
    p.created_at
FROM payment p
JOIN (
    SELECT invoice_id
    FROM payment
    WHERE invoice_id IS NOT NULL
    GROUP BY invoice_id
    HAVING COUNT(*) > 1
) dup ON dup.invoice_id = p.invoice_id
ORDER BY p.invoice_id, p.created_at, p.id;


-- ------------------------------------------------------------
-- B. Duplicate transaction_id (more than one payment per transaction)
-- ------------------------------------------------------------

-- B1. Summary
SELECT 'multiple payments per transaction' AS check,
       COUNT(*)                     AS transactions_with_dupes,
       COALESCE(SUM(copies), 0)     AS payment_rows_involved,
       COALESCE(SUM(copies - 1), 0) AS excess_rows
FROM (
    SELECT COUNT(*) AS copies
    FROM payment
    WHERE transaction_id IS NOT NULL
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
) d;

-- B2. List: every payment row whose transaction_id has more than one payment.
SELECT
    p.transaction_id,
    p.id,
    p.invoice_id,
    p.outlet_id,
    p.status,
    p.total_amount_due,
    p.payment_received,
    p.created_at
FROM payment p
JOIN (
    SELECT transaction_id
    FROM payment
    WHERE transaction_id IS NOT NULL
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
) dup ON dup.transaction_id = p.transaction_id
ORDER BY p.transaction_id, p.created_at, p.id;
