ALTER TABLE transaction_item
ADD COLUMN duration_id UUID,
ADD COLUMN duration_name VARCHAR(100),
ADD COLUMN duration_length INTEGER,
ADD COLUMN duration_length_type VARCHAR(50),
ADD COLUMN estimated_date timestamp;

ALTER TABLE transaction
DROP COLUMN IF EXISTS duration_id,
DROP COLUMN IF EXISTS duration_name,
DROP COLUMN IF EXISTS duration_length,
DROP COLUMN IF EXISTS duration_length_type,
DROP COLUMN IF EXISTS estimated_date;
