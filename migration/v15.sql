-- ============================================================
-- v15.sql — Migrate existing users to new plan structure
--
-- Old plans (1bulan/3bulan/6bulan/12bulan) → new 'basic' plan
-- Old 'gratis' → new 'gratis' plan
-- end_date is recalculated from start_date + original plan duration
-- ============================================================

DO $$
DECLARE
    v_basic_plan_id  UUID;
    v_gratis_plan_id UUID;
BEGIN
    -- Get new plan IDs added in v14 (most recently inserted, to avoid collision with old 'gratis')
    SELECT id INTO v_basic_plan_id
    FROM app_plans
    WHERE code = 'basic'
    ORDER BY created_at DESC
    LIMIT 1;

    SELECT id INTO v_gratis_plan_id
    FROM app_plans
    WHERE code = 'gratis'
    ORDER BY created_at DESC
    LIMIT 1;

    IF v_basic_plan_id IS NULL THEN
        RAISE EXCEPTION 'New basic plan not found. Ensure v14 migration ran first.';
    END IF;

    IF v_gratis_plan_id IS NULL THEN
        RAISE EXCEPTION 'New gratis plan not found. Ensure v14 migration ran first.';
    END IF;

    -- -------------------------------------------------------
    -- 1. Migrate paid plan subscriptions → basic
    --    Duration is derived from old plan code since the
    --    duration column was dropped in v14.
    -- -------------------------------------------------------
    UPDATE app_subscriptions s
    SET
        plan_id        = v_basic_plan_id,
        end_date       = s.start_date + (
            CASE p.code
                WHEN '1bulan'  THEN 30
                WHEN '3bulan'  THEN 90
                WHEN '6bulan'  THEN 180
                WHEN '12bulan' THEN 360
                ELSE 30
            END
        ),
        duration       = jsonb_build_object(
            'days', CASE p.code
                WHEN '1bulan'  THEN 30
                WHEN '3bulan'  THEN 90
                WHEN '6bulan'  THEN 180
                WHEN '12bulan' THEN 360
                ELSE 30
            END,
            'original_plan_code', p.code
        )
    FROM app_plans p
    WHERE s.plan_id = p.id
      AND p.code IN ('1bulan', '3bulan', '6bulan', '12bulan');

    -- -------------------------------------------------------
    -- 2. Migrate old gratis subscriptions → new gratis plan
    --    14-day duration per original gratis plan definition
    -- -------------------------------------------------------
    UPDATE app_subscriptions s
    SET
        plan_id  = v_gratis_plan_id,
        end_date = s.start_date + 14,
        duration = jsonb_build_object(
            'days', 14,
            'original_plan_code', p.code
        )
    FROM app_plans p
    WHERE s.plan_id = p.id
      AND p.code = 'gratis'
      AND p.id <> v_gratis_plan_id; -- only old gratis, not the new one

    -- -------------------------------------------------------
    -- 3. Remove old plans that have been fully migrated
    -- -------------------------------------------------------
    DELETE FROM app_plans
    WHERE code IN ('1bulan', '3bulan', '6bulan', '12bulan');

    -- Remove the old duplicate gratis plan (the older one)
    DELETE FROM app_plans
    WHERE code = 'gratis'
      AND id <> v_gratis_plan_id;

    RAISE NOTICE 'Migration complete. basic plan id: %, gratis plan id: %',
        v_basic_plan_id, v_gratis_plan_id;
END $$;
