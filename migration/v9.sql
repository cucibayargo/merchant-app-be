ALTER TABLE printed_devices
ADD COLUMN IF NOT EXISTS outlet_id UUID REFERENCES outlets(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_printed_devices_outlet_id ON printed_devices (outlet_id);

UPDATE printed_devices pd
SET outlet_id = o.id
FROM outlets o
WHERE o.merchant_id = pd.user_id
  AND pd.outlet_id IS NULL
  AND o.deleted_at IS NULL
  AND o.is_active = true;
