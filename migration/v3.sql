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

CREATE TABLE printed_devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,                   -- relasi ke tabel users (foreign key optional)
    device_name VARCHAR(255) NOT NULL,       -- nama asli device
    alias_name VARCHAR(255),                 -- nama yang diinput oleh user
    device_id VARCHAR(255) NOT NULL,  -- bisa berupa MAC address printer
    is_active BOOLEAN DEFAULT FALSE,         -- hanya 1 device yang boleh true
    last_connected_at TIMESTAMP              -- waktu terakhir device terkoneksi
);
