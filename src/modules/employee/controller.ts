import bcrypt from "bcrypt";
import pool from "../../database/postgres";
import { Employee, EmployeePayload, EmployeeUpdatePayload } from "./types";

export async function createEmployee(payload: EmployeePayload, merchantId: string): Promise<Employee> {
  const client = await pool.connect();
  try {
    const passwordHash = await bcrypt.hash(payload.password, 10);

    const result = await client.query(
      `
      INSERT INTO employees (merchant_id, outlet_id, role_id, name, username, phone_number, password, is_active)
      VALUES ($1, NULLIF($2, '')::uuid, NULLIF($3, '')::uuid, $4, $5, NULLIF($6, ''), $7, COALESCE($8, true))
      RETURNING id, merchant_id, outlet_id, role_id, name, username, phone_number, is_active, created_at, updated_at, last_login_at
      `,
      [
        merchantId,
        payload.outlet_id || null,
        payload.role_id || null,
        payload.name,
        payload.username,
        payload.phone_number || null,
        passwordHash,
        payload.is_active,
      ]
    );

    return result.rows[0];
  } finally {
    client.release();
  }
}

export async function getEmployeeById(id: string, merchantId: string): Promise<Employee | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT e.id, e.merchant_id, e.outlet_id, e.role_id, e.name, e.username, e.phone_number, e.is_active, e.created_at, e.updated_at, e.last_login_at,
             CASE WHEN er.id IS NOT NULL THEN
               json_build_object(
                 'id', er.id,
                 'name', er.name,
                 'permissions', COALESCE(
                   (SELECT json_agg(erp.permission_code ORDER BY erp.permission_code)
                    FROM employee_role_permissions erp
                    WHERE erp.role_id = er.id), '[]'::json
                 )
               )
             ELSE NULL END AS role
      FROM employees e
      LEFT JOIN employee_roles er ON er.id = e.role_id
      WHERE e.id = $1 AND e.merchant_id = $2
      LIMIT 1
      `,
      [id, merchantId]
    );

    return result.rows[0] || null;
  } finally {
    client.release();
  }
}

export async function listEmployees(
  merchantId: string,
  filter: string | null,
  outletId: string | null,
  roleId: string | null,
  page: number = 1,
  limit: number = 10
): Promise<{ employees: Employee[]; totalCount: number }> {
  const client = await pool.connect();
  try {
    const offset = (page - 1) * limit;

    const result = await client.query(
      `
      SELECT e.id, e.merchant_id, e.outlet_id, e.role_id, e.name, e.username, e.phone_number, e.is_active, e.created_at, e.updated_at, e.last_login_at,
             CASE WHEN er.id IS NOT NULL THEN
               json_build_object(
                 'id', er.id,
                 'name', er.name,
                 'permissions', COALESCE(
                   (SELECT json_agg(erp.permission_code ORDER BY erp.permission_code)
                    FROM employee_role_permissions erp
                    WHERE erp.role_id = er.id), '[]'::json
                 )
               )
             ELSE NULL END AS role
      FROM employees e
      LEFT JOIN employee_roles er ON er.id = e.role_id
      WHERE e.merchant_id = $1
        AND ($2::uuid IS NULL OR e.outlet_id = $2)
        AND ($3::uuid IS NULL OR e.role_id = $3)
        AND (
          $4::text IS NULL
          OR e.name ILIKE '%' || $4 || '%'
          OR e.username ILIKE '%' || $4 || '%'
          OR COALESCE(e.phone_number, '') ILIKE '%' || $4 || '%'
          OR COALESCE(er.name, '') ILIKE '%' || $4 || '%'
        )
      ORDER BY e.created_at DESC
      LIMIT $5 OFFSET $6
      `,
      [merchantId, outletId, roleId, filter, limit, offset]
    );

    const countResult = await client.query(
      `
      SELECT COUNT(*) AS total_count
      FROM employees e
      LEFT JOIN employee_roles er ON er.id = e.role_id
      WHERE e.merchant_id = $1
        AND ($2::uuid IS NULL OR e.outlet_id = $2)
        AND ($3::uuid IS NULL OR e.role_id = $3)
        AND (
          $4::text IS NULL
          OR e.name ILIKE '%' || $4 || '%'
          OR e.username ILIKE '%' || $4 || '%'
          OR COALESCE(e.phone_number, '') ILIKE '%' || $4 || '%'
          OR COALESCE(er.name, '') ILIKE '%' || $4 || '%'
        )
      `,
      [merchantId, outletId, roleId, filter]
    );

    return {
      employees: result.rows,
      totalCount: parseInt(countResult.rows[0].total_count, 10),
    };
  } finally {
    client.release();
  }
}

export async function updateEmployee(
  id: string,
  payload: EmployeeUpdatePayload,
  merchantId: string
): Promise<Employee | null> {
  const client = await pool.connect();
  try {
    const existing = await client.query(
      `SELECT * FROM employees WHERE id = $1 AND merchant_id = $2 LIMIT 1`,
      [id, merchantId]
    );

    if (!existing.rows[0]) {
      return null;
    }

    const current = existing.rows[0];
    const passwordHash = payload.password
      ? await bcrypt.hash(payload.password, 10)
      : current.password;

    const result = await client.query(
      `
      UPDATE employees
      SET
        outlet_id = COALESCE(NULLIF($1, '')::uuid, outlet_id),
        role_id = CASE WHEN $2::text IS NOT NULL THEN NULLIF($2, '')::uuid ELSE role_id END,
        name = COALESCE($3, name),
        username = COALESCE($4, username),
        phone_number = COALESCE(NULLIF($5, ''), phone_number),
        password = $6,
        is_active = COALESCE($7, is_active),
        updated_at = now()
      WHERE id = $8
        AND merchant_id = $9
      RETURNING id
      `,
      [
        payload.outlet_id,
        payload.role_id !== undefined ? (payload.role_id || null) : null,
        payload.name,
        payload.username,
        payload.phone_number,
        passwordHash,
        payload.is_active,
        id,
        merchantId,
      ]
    );

    if (!result.rows[0]) return null;
    return getEmployeeById(id, merchantId);
  } finally {
    client.release();
  }
}

export async function updateEmployeePassword(
  id: string,
  oldPassword: string,
  newPassword: string,
  merchantId: string
): Promise<{ success: boolean; error?: "not_found" | "wrong_password" }> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `SELECT password FROM employees WHERE id = $1 AND merchant_id = $2 LIMIT 1`,
      [id, merchantId]
    );

    if (!result.rows[0]) return { success: false, error: "not_found" };

    const isMatch = await bcrypt.compare(oldPassword, result.rows[0].password);
    if (!isMatch) return { success: false, error: "wrong_password" };

    const newHash = await bcrypt.hash(newPassword, 10);
    await client.query(
      `UPDATE employees SET password = $1, updated_at = now() WHERE id = $2 AND merchant_id = $3`,
      [newHash, id, merchantId]
    );

    return { success: true };
  } finally {
    client.release();
  }
}

export async function deleteEmployee(id: string, merchantId: string): Promise<boolean> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `DELETE FROM employees WHERE id = $1 AND merchant_id = $2 RETURNING id`,
      [id, merchantId]
    );

    return (result.rowCount || 0) > 0;
  } finally {
    client.release();
  }
}

export async function assignRoleToEmployee(
  employeeId: string,
  roleId: string | null,
  merchantId: string
): Promise<Employee | null> {
  const client = await pool.connect();
  try {
    if (roleId) {
      const role = await client.query(
        `SELECT id FROM employee_roles WHERE id = $1 AND merchant_id = $2 LIMIT 1`,
        [roleId, merchantId]
      );
      if (!role.rows[0]) throw new Error("Role tidak ditemukan.");
    }

    const result = await client.query(
      `UPDATE employees SET role_id = $1, updated_at = now()
       WHERE id = $2 AND merchant_id = $3 RETURNING id`,
      [roleId, employeeId, merchantId]
    );

    if (!result.rows[0]) return null;
    return getEmployeeById(employeeId, merchantId);
  } finally {
    client.release();
  }
}

export async function getEmployeePermissions(employeeId: string, merchantId: string): Promise<string[]> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT erp.permission_code
      FROM employee_role_permissions erp
      JOIN employee_roles er ON er.id = erp.role_id
      JOIN employees e ON e.role_id = er.id
      WHERE e.id = $1
        AND e.merchant_id = $2
      ORDER BY erp.permission_code ASC
      `,
      [employeeId, merchantId]
    );

    return result.rows.map((row) => row.permission_code);
  } finally {
    client.release();
  }
}

export async function authenticateEmployee(username: string): Promise<(Employee & { password: string }) | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT *
      FROM employees
      WHERE username = $1
        AND is_active = true
      LIMIT 1
      `,
      [username]
    );

    return result.rows[0] || null;
  } finally {
    client.release();
  }
}

export async function touchEmployeeLastLogin(employeeId: string): Promise<void> {
  const client = await pool.connect();
  try {
    await client.query(
      `UPDATE employees SET last_login_at = now(), updated_at = now() WHERE id = $1`,
      [employeeId]
    );
  } finally {
    client.release();
  }
}
