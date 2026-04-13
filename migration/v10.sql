-- Create employee_roles table
CREATE TABLE employee_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    UNIQUE (merchant_id, name)
);

CREATE INDEX idx_employee_roles_merchant_id ON employee_roles (merchant_id);

-- Create employee_role_permissions table
CREATE TABLE employee_role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL REFERENCES employee_roles(id) ON DELETE CASCADE,
    permission_code VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    UNIQUE (role_id, permission_code)
);

CREATE INDEX idx_employee_role_permissions_role_id ON employee_role_permissions (role_id);

-- Add role_id column to employees
ALTER TABLE employees ADD COLUMN role_id UUID REFERENCES employee_roles(id) ON DELETE SET NULL;

CREATE INDEX idx_employees_role_id ON employees (role_id);

-- Migrate: create a default "Karyawan" role for every merchant that already has employees
INSERT INTO employee_roles (merchant_id, name)
SELECT DISTINCT e.merchant_id, 'Karyawan'
FROM employees e
ON CONFLICT DO NOTHING;

-- Migrate: copy all distinct direct permissions into the default role
INSERT INTO employee_role_permissions (role_id, permission_code)
SELECT DISTINCT er.id, ep.permission_code
FROM employee_roles er
JOIN employees e ON e.merchant_id = er.merchant_id
JOIN employee_permissions ep ON ep.employee_id = e.id
WHERE er.name = 'Karyawan'
ON CONFLICT DO NOTHING;

-- Migrate: assign the default role to every employee
UPDATE employees e
SET role_id = er.id
FROM employee_roles er
WHERE er.merchant_id = e.merchant_id
  AND er.name = 'Karyawan';

-- Drop the old direct-permission table
DROP TABLE IF EXISTS employee_permissions;
