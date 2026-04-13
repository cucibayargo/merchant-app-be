import pool from "../../database/postgres";
import { Role, RolePayload, RoleUpdatePayload } from "./types";

export async function createRole(payload: RolePayload, merchantId: string): Promise<Role> {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    const result = await client.query(
      `
      INSERT INTO employee_roles (merchant_id, name)
      VALUES ($1, $2)
      RETURNING id, merchant_id, name, created_at, updated_at
      `,
      [merchantId, payload.name]
    );

    const role = result.rows[0];

    if (payload.permissions && payload.permissions.length > 0) {
      const values: string[] = [];
      const params: string[] = [role.id];
      payload.permissions.forEach((permission, idx) => {
        values.push(`($1, $${idx + 2})`);
        params.push(permission);
      });
      await client.query(
        `
        INSERT INTO employee_role_permissions (role_id, permission_code)
        VALUES ${values.join(",")}
        ON CONFLICT DO NOTHING
        `,
        params
      );
    }

    await client.query("COMMIT");
    role.permissions = payload.permissions || [];
    return role;
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  } finally {
    client.release();
  }
}

export async function listRoles(merchantId: string): Promise<Role[]> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT er.id, er.merchant_id, er.name, er.created_at, er.updated_at,
             COALESCE(json_agg(erp.permission_code ORDER BY erp.permission_code)
               FILTER (WHERE erp.permission_code IS NOT NULL), '[]') AS permissions
      FROM employee_roles er
      LEFT JOIN employee_role_permissions erp ON erp.role_id = er.id
      WHERE er.merchant_id = $1
      GROUP BY er.id
      ORDER BY er.created_at DESC
      `,
      [merchantId]
    );
    return result.rows;
  } finally {
    client.release();
  }
}

export async function getRoleById(id: string, merchantId: string): Promise<Role | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT er.id, er.merchant_id, er.name, er.created_at, er.updated_at,
             COALESCE(json_agg(erp.permission_code ORDER BY erp.permission_code)
               FILTER (WHERE erp.permission_code IS NOT NULL), '[]') AS permissions
      FROM employee_roles er
      LEFT JOIN employee_role_permissions erp ON erp.role_id = er.id
      WHERE er.id = $1 AND er.merchant_id = $2
      GROUP BY er.id
      LIMIT 1
      `,
      [id, merchantId]
    );
    return result.rows[0] || null;
  } finally {
    client.release();
  }
}

export async function updateRole(
  id: string,
  payload: RoleUpdatePayload,
  merchantId: string
): Promise<Role | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      UPDATE employee_roles
      SET name = COALESCE($1, name), updated_at = now()
      WHERE id = $2 AND merchant_id = $3
      RETURNING id
      `,
      [payload.name, id, merchantId]
    );
    if (!result.rows[0]) return null;
    return getRoleById(id, merchantId);
  } finally {
    client.release();
  }
}

export async function deleteRole(id: string, merchantId: string): Promise<boolean> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `DELETE FROM employee_roles WHERE id = $1 AND merchant_id = $2 RETURNING id`,
      [id, merchantId]
    );
    return (result.rowCount || 0) > 0;
  } finally {
    client.release();
  }
}

export async function setRolePermissions(
  roleId: string,
  permissions: string[],
  merchantId: string
): Promise<string[]> {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    const role = await client.query(
      `SELECT id FROM employee_roles WHERE id = $1 AND merchant_id = $2 LIMIT 1`,
      [roleId, merchantId]
    );
    if (!role.rows[0]) throw new Error("Role tidak ditemukan.");

    await client.query(`DELETE FROM employee_role_permissions WHERE role_id = $1`, [roleId]);

    if (permissions.length > 0) {
      const values: string[] = [];
      const params: string[] = [roleId];
      permissions.forEach((permission, idx) => {
        values.push(`($1, $${idx + 2})`);
        params.push(permission);
      });
      await client.query(
        `
        INSERT INTO employee_role_permissions (role_id, permission_code)
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
