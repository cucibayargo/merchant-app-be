import pool from "../../database/postgres";
import { Outlet, OutletPayload } from "./types";

export async function listOutlets(
  merchantId: string,
  filter: string | null,
  page: number = 1,
  limit: number = 10
): Promise<{ outlets: Outlet[]; totalCount: number }> {
  const client = await pool.connect();
  try {
    const offset = (page - 1) * limit;

    const result = await client.query(
      `
      SELECT *
      FROM outlets
      WHERE merchant_id = $1
        AND deleted_at IS NULL
        AND (
          $2::text IS NULL
          OR name ILIKE '%' || $2 || '%'
          OR COALESCE(code, '') ILIKE '%' || $2 || '%'
          OR COALESCE(address, '') ILIKE '%' || $2 || '%'
          OR COALESCE(phone_number, '') ILIKE '%' || $2 || '%'
        )
      ORDER BY created_at DESC
      LIMIT $3 OFFSET $4
      `,
      [merchantId, filter, limit, offset]
    );

    const countResult = await client.query(
      `
      SELECT COUNT(*) AS total_count
      FROM outlets
      WHERE merchant_id = $1
        AND deleted_at IS NULL
        AND (
          $2::text IS NULL
          OR name ILIKE '%' || $2 || '%'
          OR COALESCE(code, '') ILIKE '%' || $2 || '%'
          OR COALESCE(address, '') ILIKE '%' || $2 || '%'
          OR COALESCE(phone_number, '') ILIKE '%' || $2 || '%'
        )
      `,
      [merchantId, filter]
    );

    return {
      outlets: result.rows,
      totalCount: parseInt(countResult.rows[0].total_count, 10),
    };
  } finally {
    client.release();
  }
}

export async function getOutletById(id: string, merchantId: string): Promise<Outlet | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT *
      FROM outlets
      WHERE id = $1
        AND merchant_id = $2
        AND deleted_at IS NULL
      LIMIT 1
      `,
      [id, merchantId]
    );

    return result.rows[0] || null;
  } finally {
    client.release();
  }
}

export async function createOutlet(payload: OutletPayload, merchantId: string): Promise<Outlet> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      INSERT INTO outlets (merchant_id, code, name, address, phone_number, is_active)
      VALUES ($1, NULLIF($2, ''), $3, NULLIF($4, ''), NULLIF($5, ''), COALESCE($6, true))
      RETURNING *
      `,
      [
        merchantId,
        payload.code || null,
        payload.name,
        payload.address || null,
        payload.phone_number || null,
        payload.is_active,
      ]
    );

    return result.rows[0];
  } finally {
    client.release();
  }
}

export async function isOutletCodeExists(merchantId: string, code: string): Promise<boolean> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT 1
      FROM outlets
      WHERE merchant_id = $1
        AND code = $2
      LIMIT 1
      `,
      [merchantId, code]
    );

    return (result.rowCount || 0) > 0;
  } finally {
    client.release();
  }
}

export async function updateOutlet(
  id: string,
  payload: OutletPayload,
  merchantId: string
): Promise<Outlet | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      UPDATE outlets
      SET
        code = COALESCE(NULLIF($1, ''), code),
        name = COALESCE($2, name),
        address = COALESCE(NULLIF($3, ''), address),
        phone_number = COALESCE(NULLIF($4, ''), phone_number),
        is_active = COALESCE($5, is_active),
        updated_at = now()
      WHERE id = $6
        AND merchant_id = $7
        AND deleted_at IS NULL
      RETURNING *
      `,
      [
        payload.code,
        payload.name,
        payload.address,
        payload.phone_number,
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

export async function deleteOutlet(id: string, merchantId: string): Promise<boolean> {
  const client = await pool.connect();
  try {
    const checkActiveTransactions = await client.query(
      `
      SELECT 1
      FROM transaction
      WHERE outlet_id = $1
        AND deleted_at IS NULL
      LIMIT 1
      `,
      [id]
    );

    if (checkActiveTransactions.rowCount) {
      throw new Error("Outlet masih memiliki transaksi aktif.");
    }

    const result = await client.query(
      `
      UPDATE outlets
      SET deleted_at = now(), updated_at = now(), is_active = false
      WHERE id = $1
        AND merchant_id = $2
        AND deleted_at IS NULL
      RETURNING id
      `,
      [id, merchantId]
    );

    return (result.rowCount || 0) > 0;
  } finally {
    client.release();
  }
}

export async function getDefaultOutletId(merchantId: string): Promise<string | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT id
      FROM outlets
      WHERE merchant_id = $1
        AND is_active = true
        AND deleted_at IS NULL
      ORDER BY created_at ASC
      LIMIT 1
      `,
      [merchantId]
    );

    return result.rows[0]?.id || null;
  } finally {
    client.release();
  }
}
