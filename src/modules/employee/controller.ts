import bcrypt from "bcrypt";
import pool from "../../database/postgres";
import { Employee, EmployeePayload, EmployeeUpdatePayload } from "./types";

export async function createEmployee(payload: EmployeePayload, merchantId: string): Promise<Employee> {
  const client = await pool.connect();
  try {
    const passwordHash = await bcrypt.hash(payload.password, 10);

    const result = await client.query(
      `
      INSERT INTO employees (merchant_id, outlet_id, name, email, phone_number, password, is_active)
      VALUES ($1, NULLIF($2, '')::uuid, $3, $4, NULLIF($5, ''), $6, COALESCE($7, true))
      RETURNING id, merchant_id, outlet_id, name, email, phone_number, is_active, created_at, updated_at, last_login_at
      `,
      [
        merchantId,
        payload.outlet_id || null,
        payload.name,
        payload.email,
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
      SELECT e.id, e.merchant_id, e.outlet_id, e.name, e.email, e.phone_number, e.is_active, e.created_at, e.updated_at, e.last_login_at,
             COALESCE(json_agg(ep.permission_code) FILTER (WHERE ep.permission_code IS NOT NULL), '[]') AS permissions
      FROM employees e
      LEFT JOIN employee_permissions ep ON ep.employee_id = e.id
      WHERE e.id = $1 AND e.merchant_id = $2
      GROUP BY e.id
      LIMIT 1
      `,
      [id, merchantId]
    );

    return result.rows[0] || null;
  } finally {
    client.release();
  }
}

export async function listEmployees(merchantId: string): Promise<Employee[]> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT e.id, e.merchant_id, e.outlet_id, e.name, e.email, e.phone_number, e.is_active, e.created_at, e.updated_at, e.last_login_at,
             COALESCE(json_agg(ep.permission_code) FILTER (WHERE ep.permission_code IS NOT NULL), '[]') AS permissions
      FROM employees e
      LEFT JOIN employee_permissions ep ON ep.employee_id = e.id
      WHERE e.merchant_id = $1
      GROUP BY e.id
      ORDER BY e.created_at DESC
      `,
      [merchantId]
    );

    return result.rows;
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
        name = COALESCE($2, name),
        email = COALESCE($3, email),
        phone_number = COALESCE(NULLIF($4, ''), phone_number),
        password = $5,
        is_active = COALESCE($6, is_active),
        updated_at = now()
      WHERE id = $7
        AND merchant_id = $8
      RETURNING id, merchant_id, outlet_id, name, email, phone_number, is_active, created_at, updated_at, last_login_at
      `,
      [
        payload.outlet_id,
        payload.name,
        payload.email,
        payload.phone_number,
        passwordHash,
        payload.is_active,
        id,
        merchantId,
      ]
    );

    return result.rows[0] || null;
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

export async function assignEmployeePermissions(
  employeeId: string,
  permissions: string[],
  merchantId: string
): Promise<string[]> {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    const employee = await client.query(
      `SELECT id FROM employees WHERE id = $1 AND merchant_id = $2 LIMIT 1`,
      [employeeId, merchantId]
    );

    if (!employee.rows[0]) {
      throw new Error("Karyawan tidak ditemukan.");
    }

    await client.query(`DELETE FROM employee_permissions WHERE employee_id = $1`, [employeeId]);

    if (permissions.length > 0) {
      const values: string[] = [];
      const params: string[] = [employeeId];

      permissions.forEach((permission, idx) => {
        values.push(`($1, $${idx + 2})`);
        params.push(permission);
      });

      await client.query(
        `
        INSERT INTO employee_permissions (employee_id, permission_code)
        VALUES ${values.join(",")}
        ON CONFLICT DO NOTHING
        `,
        params
      );
    }

    await client.query("COMMIT");
    return permissions;
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  } finally {
    client.release();
  }
}

export async function getEmployeePermissions(employeeId: string, merchantId: string): Promise<string[]> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT ep.permission_code
      FROM employee_permissions ep
      JOIN employees e ON e.id = ep.employee_id
      WHERE ep.employee_id = $1
        AND e.merchant_id = $2
      ORDER BY ep.permission_code ASC
      `,
      [employeeId, merchantId]
    );

    return result.rows.map((row) => row.permission_code);
  } finally {
    client.release();
  }
}

export async function authenticateEmployee(email: string): Promise<(Employee & { password: string }) | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT *
      FROM employees
      WHERE email = $1
        AND is_active = true
      LIMIT 1
      `,
      [email]
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
