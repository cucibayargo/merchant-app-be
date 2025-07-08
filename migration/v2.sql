CREATE TABLE user_referral (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    user_id uuid,
    referred_user_id uuid,
    referral_reward numeric,
    PRIMARY KEY (id)
);

ALTER TABLE users ADD COLUMN referral_points NUMERIC DEFAULT 0;
ALTER TABLE users ADD COLUMN referral_points_redeemed NUMERIC DEFAULT 0;
ALTER TABLE users ADD COLUMN referral_code VARCHAR(255);

CREATE OR REPLACE FUNCTION update_user_referral_points()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Add reward to both users
        UPDATE users
        SET referral_points = COALESCE(referral_points, 0) + COALESCE(NEW.referral_reward, 0)
        WHERE id IN (NEW.user_id, NEW.referred_user_id);

    ELSIF TG_OP = 'UPDATE' THEN
        -- Update reward for both users safely
        UPDATE users
        SET referral_points = GREATEST(
            COALESCE(referral_points, 0) 
            - COALESCE(OLD.referral_reward, 0)
            + COALESCE(NEW.referral_reward, 0), 
        0)
        WHERE id IN (NEW.user_id, NEW.referred_user_id);

    ELSIF TG_OP = 'DELETE' THEN
        -- Subtract reward but prevent going below zero
        UPDATE users
        SET referral_points = GREATEST(
            COALESCE(referral_points, 0) - COALESCE(OLD.referral_reward, 0),
        0)
        WHERE id IN (OLD.user_id, OLD.referred_user_id);
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_update_user_referral_points
AFTER INSERT OR UPDATE OR DELETE ON user_referral
FOR EACH ROW
EXECUTE FUNCTION update_user_referral_points();

CREATE OR REPLACE FUNCTION generate_referral_code(length INT DEFAULT 5)
RETURNS TEXT AS $$
DECLARE
    chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; -- Excludes confusing chars
    result TEXT := '';
    i INT := 0;
BEGIN
    WHILE i < length LOOP
        result := result || substr(chars, (random() * length(chars) + 1)::INT, 1);
        i := i + 1;
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    u RECORD;
    code TEXT;
BEGIN
    FOR u IN SELECT id FROM users WHERE referral_code IS NULL LOOP
        LOOP
            code := generate_referral_code(5);

            -- Ensure code is unique
            EXIT WHEN NOT EXISTS (
                SELECT 1 FROM users WHERE referral_code = code
            );
        END LOOP;

        UPDATE users
        SET referral_code = code
        WHERE id = u.id;
    END LOOP;
END;
$$;
