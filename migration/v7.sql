CREATE TABLE outlets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sequence_id BIGSERIAL,
    code VARCHAR(20),
    name VARCHAR(255) NOT NULL,
    address TEXT,
    phone_number VARCHAR(50),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    UNIQUE (merchant_id, code)
);

CREATE INDEX idx_outlets_merchant_id ON outlets (merchant_id);

ALTER TABLE customer ADD COLUMN outlet_id UUID REFERENCES outlets(id) ON DELETE SET NULL;
ALTER TABLE duration ADD COLUMN outlet_id UUID REFERENCES outlets(id) ON DELETE SET NULL;
ALTER TABLE note ADD COLUMN outlet_id UUID REFERENCES outlets(id) ON DELETE SET NULL;
ALTER TABLE payment ADD COLUMN outlet_id UUID REFERENCES outlets(id) ON DELETE SET NULL;
ALTER TABLE service ADD COLUMN outlet_id UUID REFERENCES outlets(id) ON DELETE SET NULL;
ALTER TABLE transaction ADD COLUMN outlet_id UUID REFERENCES outlets(id) ON DELETE SET NULL;
ALTER TABLE expenses ADD COLUMN outlet_id UUID REFERENCES outlets(id) ON DELETE SET NULL;
ALTER TABLE discounts ADD COLUMN outlet_id UUID REFERENCES outlets(id) ON DELETE SET NULL;

CREATE INDEX idx_customer_outlet_id ON customer (outlet_id);
CREATE INDEX idx_duration_outlet_id ON duration (outlet_id);
CREATE INDEX idx_note_outlet_id ON note (outlet_id);
CREATE INDEX idx_payment_outlet_id ON payment (outlet_id);
CREATE INDEX idx_service_outlet_id ON service (outlet_id);
CREATE INDEX idx_transaction_outlet_id ON transaction (outlet_id);
CREATE INDEX idx_expenses_outlet_id ON expenses (outlet_id);
CREATE INDEX idx_discounts_outlet_id ON discounts (outlet_id);

INSERT INTO outlets (merchant_id, code, name, address, phone_number)
SELECT
    u.id,
    'OTL-001',
    COALESCE(NULLIF(u.name, ''), 'Outlet Utama'),
    u.address,
    u.phone_number
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM outlets o WHERE o.merchant_id = u.id
);

UPDATE customer c
SET outlet_id = o.id
FROM outlets o
WHERE o.merchant_id = c.merchant_id AND c.outlet_id IS NULL;

UPDATE duration d
SET outlet_id = o.id
FROM outlets o
WHERE o.merchant_id = d.merchant_id AND d.outlet_id IS NULL;

UPDATE note n
SET outlet_id = o.id
FROM outlets o
WHERE o.merchant_id = n.merchant_id AND n.outlet_id IS NULL;

UPDATE service s
SET outlet_id = o.id
FROM outlets o
WHERE o.merchant_id = s.merchant_id AND s.outlet_id IS NULL;

UPDATE transaction t
SET outlet_id = o.id
FROM outlets o
WHERE o.merchant_id = t.merchant_id AND t.outlet_id IS NULL;

UPDATE payment p
SET outlet_id = t.outlet_id
FROM transaction t
WHERE p.transaction_id = t.id
  AND p.outlet_id IS NULL;

UPDATE expenses e
SET outlet_id = o.id
FROM outlets o
WHERE o.merchant_id = e.merchant_id AND e.outlet_id IS NULL;

UPDATE discounts d
SET outlet_id = o.id
FROM outlets o
WHERE o.merchant_id = d.merchant_id AND d.outlet_id IS NULL;

ALTER TABLE payment DROP COLUMN IF EXISTS merchant_id;

CREATE OR REPLACE FUNCTION set_order_for_transaction()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.outlet_id IS NOT NULL THEN
    NEW."order" := (
      SELECT COUNT(*) + 1
      FROM transaction
      WHERE outlet_id = NEW.outlet_id
        AND deleted_at IS NULL
    );
  ELSE
    NEW."order" := (
      SELECT COUNT(*) + 1
      FROM transaction
      WHERE merchant_id = NEW.merchant_id
        AND deleted_at IS NULL
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TABLE IF EXISTS employee_permissions;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    outlet_id UUID REFERENCES outlets(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50),
    password VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    last_login_at TIMESTAMP WITH TIME ZONE NULL,
    UNIQUE (merchant_id, email)
);

CREATE INDEX idx_employees_merchant_id ON employees (merchant_id);
CREATE INDEX idx_employees_outlet_id ON employees (outlet_id);

CREATE TABLE employee_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    permission_code VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    UNIQUE (employee_id, permission_code)
);

CREATE INDEX idx_employee_permissions_employee_id ON employee_permissions (employee_id);

INSERT INTO employee_permissions (employee_id, permission_code)
SELECT e.id, p.permission_code
FROM employees e
CROSS JOIN (
    VALUES
      ('transaction.read'),
      ('transaction.create'),
      ('transaction.update'),
      ('transaction.delete'),
      ('report.read'),
      ('customer.read'),
      ('customer.create'),
      ('customer.update'),
      ('customer.delete'),
      ('service.read'),
      ('service.create'),
      ('service.update'),
      ('service.delete'),
      ('duration.read'),
      ('duration.create'),
      ('duration.update'),
      ('duration.delete'),
      ('expanse.read'),
      ('expanse.create'),
      ('expanse.update'),
      ('expanse.delete')
) AS p(permission_code)
ON CONFLICT DO NOTHING;
