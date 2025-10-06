ALTER TABLE transaction_item ADD COLUMN  duration_id uuid;
ALTER TABLE transaction DROP COLUMN duration_id;