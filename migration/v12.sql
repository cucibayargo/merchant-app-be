ALTER TABLE transaction_item
ALTER COLUMN duration_length TYPE DOUBLE PRECISION
USING duration_length::DOUBLE PRECISION;
