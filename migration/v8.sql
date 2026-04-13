-- Migration v8: Replace email with username in employees table

-- Add username column (initially nullable to allow backfill)
ALTER TABLE employees ADD COLUMN username VARCHAR(255);

-- Backfill: use the part before @ in existing emails as username (if any)
UPDATE employees SET username = split_part(email, '@', 1) WHERE username IS NULL;

-- Drop the old email column
ALTER TABLE employees DROP COLUMN IF EXISTS email;

-- Make username NOT NULL and unique per merchant
ALTER TABLE employees ALTER COLUMN username SET NOT NULL;
ALTER TABLE employees ADD CONSTRAINT employees_merchant_id_username_key UNIQUE (merchant_id, username);

CREATE INDEX IF NOT EXISTS idx_employees_username ON employees (username);
