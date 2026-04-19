-- Fix app_invoices.user_id column type from bigint to uuid to match users.id
-- Existing bigint values cannot be valid UUIDs, so we drop and re-add the column
ALTER TABLE app_invoices DROP COLUMN user_id;
ALTER TABLE app_invoices ADD COLUMN user_id uuid;

-- Add missing columns to app_transactions for file upload support
ALTER TABLE app_transactions ADD COLUMN file character varying;
ALTER TABLE app_transactions ADD COLUMN note text;
