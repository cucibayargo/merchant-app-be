-- ============================================================
-- v14.sql — Combined migrations v7 through v13
-- ============================================================


-- ============================================================
-- v7: Outlets, employee tables, and multi-outlet support
-- ============================================================

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


-- ============================================================
-- v8: Replace email with username in employees table
-- ============================================================

ALTER TABLE employees ADD COLUMN username VARCHAR(255);

UPDATE employees SET username = split_part(email, '@', 1) WHERE username IS NULL;

ALTER TABLE employees DROP COLUMN IF EXISTS email;

ALTER TABLE employees ALTER COLUMN username SET NOT NULL;
ALTER TABLE employees ADD CONSTRAINT employees_merchant_id_username_key UNIQUE (merchant_id, username);

CREATE INDEX IF NOT EXISTS idx_employees_username ON employees (username);


-- ============================================================
-- v9: Add outlet_id to printed_devices
-- ============================================================

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


-- ============================================================
-- v10: Employee roles and role-based permissions
-- ============================================================

CREATE TABLE employee_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    UNIQUE (merchant_id, name)
);

CREATE INDEX idx_employee_roles_merchant_id ON employee_roles (merchant_id);

CREATE TABLE employee_role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL REFERENCES employee_roles(id) ON DELETE CASCADE,
    permission_code VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    UNIQUE (role_id, permission_code)
);

CREATE INDEX idx_employee_role_permissions_role_id ON employee_role_permissions (role_id);

ALTER TABLE employees ADD COLUMN role_id UUID REFERENCES employee_roles(id) ON DELETE SET NULL;

CREATE INDEX idx_employees_role_id ON employees (role_id);

INSERT INTO employee_roles (merchant_id, name)
SELECT DISTINCT e.merchant_id, 'Karyawan'
FROM employees e
ON CONFLICT DO NOTHING;

INSERT INTO employee_role_permissions (role_id, permission_code)
SELECT DISTINCT er.id, ep.permission_code
FROM employee_roles er
JOIN employees e ON e.merchant_id = er.merchant_id
JOIN employee_permissions ep ON ep.employee_id = e.id
WHERE er.name = 'Karyawan'
ON CONFLICT DO NOTHING;

UPDATE employees e
SET role_id = er.id
FROM employee_roles er
WHERE er.merchant_id = e.merchant_id
  AND er.name = 'Karyawan';

DROP TABLE IF EXISTS employee_permissions;


-- ============================================================
-- v11: Fix app_invoices.user_id type and add columns to app_transactions
-- ============================================================

ALTER TABLE app_invoices DROP COLUMN user_id;
ALTER TABLE app_invoices ADD COLUMN user_id uuid;

ALTER TABLE app_transactions ADD COLUMN file character varying;
ALTER TABLE app_transactions ADD COLUMN note text;


-- ============================================================
-- v12: Change transaction_item.duration_length to DOUBLE PRECISION
-- ============================================================

ALTER TABLE transaction_item
ALTER COLUMN duration_length TYPE DOUBLE PRECISION
USING duration_length::DOUBLE PRECISION;


-- ============================================================
-- v13: Drop phone/address from users, add transaction creator fields
-- ============================================================

ALTER TABLE users DROP COLUMN IF EXISTS phone_number;
ALTER TABLE users DROP COLUMN IF EXISTS address;
ALTER TABLE users_signup DROP COLUMN IF EXISTS phone_number;

ALTER TABLE transaction
ADD COLUMN created_by_id UUID,
ADD COLUMN created_by_name VARCHAR(225);

ALTER TABLE users ADD COLUMN nickname varchar(255);


-- ============================================================
-- New Plan
ALTER TABLE public.app_plans DROP COLUMN IF EXISTS duration;
ALTER TABLE public.app_plans ADD COLUMN features jsonb;
INSERT INTO public.app_plans (name, code, price, features)
VALUES
(
  'Basic',
  'basic',
  29900,
  '[
    "1 Outlet",
    "Membuat order tak terbatas",
    "Mengelola data layanan",
    "Mengelola data pelanggan",
    "Laporan layanan",
    "Laporan pelanggan",
    "Laporan penjualan",
    "Laporan pengeluaran"
  ]'::jsonb
),
(
  'Pro',
  'pro',
  45000,
  '[
    "Semua fitur Basic",
    "1 Outlet",
    "Mengelola data karyawan",
    "Login karyawan"
  ]'::jsonb
),
(
  'Enterprise',
  'enterprise',
  50000,
  '[
    "Semua fitur Pro",
    "Multi outlet",
    "Akses ke semua fitur",
    "Layanan support prioritas"
  ]'::jsonb
);