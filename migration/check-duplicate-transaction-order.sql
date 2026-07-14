-- ============================================================
-- check-duplicate-transaction-order.sql
--
-- READ-ONLY. Reports transactions that share the same "order" within their
-- scope (COALESCE(outlet_id, merchant_id)). Changes nothing — safe on prod.
--
--   psql "$POSTGRES_CONNECTION_STRING" -f migration/check-duplicate-transaction-order.sql
--
-- Scope matches set_order_for_transaction(): outlet_id when set, else merchant_id.
-- Only LIVE rows (deleted_at IS NULL) are checked — soft-deleted rows are
-- excluded from ordering.
-- ============================================================

-- 1. Summary: how many duplicate (scope, order) groups and rows exist.
SELECT
    COUNT(*)                        AS duplicate_groups,
    COALESCE(SUM(copies), 0)        AS rows_involved,
    COALESCE(SUM(copies - 1), 0)    AS excess_rows   -- rows that need renumbering
FROM (
    SELECT COUNT(*) AS copies
    FROM transaction
    WHERE deleted_at IS NULL
    GROUP BY COALESCE(outlet_id::text, merchant_id::text), "order"
    HAVING COUNT(*) > 1
) d;

-- 2. Per-scope breakdown: which outlets/merchants are affected, worst first.
SELECT
    COALESCE(outlet_id::text, merchant_id::text) AS scope_key,
    CASE WHEN outlet_id IS NOT NULL THEN 'outlet' ELSE 'merchant' END AS scope_type,
    COUNT(*)                        AS duplicate_groups,
    SUM(copies)                     AS rows_involved
FROM (
    SELECT outlet_id, merchant_id, "order", COUNT(*) AS copies
    FROM transaction
    WHERE deleted_at IS NULL
    GROUP BY outlet_id, merchant_id, "order"
    HAVING COUNT(*) > 1
) g
GROUP BY 1, 2
ORDER BY rows_involved DESC, duplicate_groups DESC
LIMIT 100;

-- 3. Full detail: every colliding transaction (id + order), newest scopes first.
--    Comment out if the result set is too large; use section 2 to target scopes.
SELECT
    COALESCE(t.outlet_id::text, t.merchant_id::text) AS scope_key,
    t."order",
    t.id,
    t.merchant_id,
    t.outlet_id,
    t.created_at
FROM transaction t
JOIN (
    SELECT outlet_id, merchant_id, "order"
    FROM transaction
    WHERE deleted_at IS NULL
    GROUP BY outlet_id, merchant_id, "order"
    HAVING COUNT(*) > 1
) dup
  ON  t."order" = dup."order"
  AND t.deleted_at IS NULL
  AND t.outlet_id  IS NOT DISTINCT FROM dup.outlet_id
  AND t.merchant_id IS NOT DISTINCT FROM dup.merchant_id
ORDER BY scope_key, t."order", t.created_at, t.id;
