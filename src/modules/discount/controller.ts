import pool from "../../database/postgres";
import { Discount } from "./types";

export async function listDiscounts(
  merchant_id: string,
  page: number = 1,
  limit: number = 10,
  filter: string | null = null
): Promise<{ data: Discount[]; totalCount: number }> {
  const client = await pool.connect();
  try {
    const offset = (page - 1) * limit;

    const query = `
      SELECT id, merchant_id, name, type, value::double precision AS value, COALESCE(description, '') AS description, is_active, created_at, updated_at
      FROM discounts
      WHERE merchant_id = $1
        AND ($2::text IS NULL OR name ILIKE '%' || $2 || '%')
      ORDER BY created_at DESC
      LIMIT $3 OFFSET $4
    `;
    const countQuery = `
      SELECT COUNT(*) AS total_count
      FROM discounts
      WHERE merchant_id = $1
        AND ($2::text IS NULL OR name ILIKE '%' || $2 || '%')
    `;

    const [result, countResult] = await Promise.all([
      client.query(query, [merchant_id, filter, limit, offset]),
      client.query(countQuery, [merchant_id, filter]),
    ]);

    return {
      data: result.rows,
      totalCount: Number(countResult.rows?.[0]?.total_count || 0),
    };
  } finally {
    client.release();
  }
}

export async function getDiscountById(
  id: string,
  merchant_id: string
): Promise<Discount | null> {
  const client = await pool.connect();
  try {
    const { rows } = await client.query(
      `SELECT id, merchant_id, name, type, value::double precision AS value, COALESCE(description, '') AS description, is_active, created_at, updated_at
       FROM discounts WHERE id = $1 AND merchant_id = $2`,
      [id, merchant_id]
    );
    return rows[0] || null;
  } finally {
    client.release();
  }
}

export async function getDiscountByIdOnly(id: string): Promise<Discount | null> {
  const client = await pool.connect();
  try {
    const { rows } = await client.query(
      `SELECT id, merchant_id, name, type, value::double precision AS value, COALESCE(description, '') AS description, is_active, created_at, updated_at
       FROM discounts WHERE id = $1`,
      [id]
    );
    return rows[0] || null;
  } finally {
    client.release();
  }
}

export async function createDiscount(
  payload: Omit<Discount, "id" | "created_at" | "updated_at">,
  merchant_id: string
): Promise<Discount> {
  const client = await pool.connect();
  try {
    const { rows } = await client.query(
      `INSERT INTO discounts (merchant_id, name, type, value, description, is_active)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING id, merchant_id, name, type, value::double precision AS value, description, is_active, created_at, updated_at`,
      [
        merchant_id,
        payload.name,
        payload.type,
        payload.value,
        payload.description ?? null,
        payload.is_active ?? true,
      ]
    );
    return rows[0];
  } finally {
    client.release();
  }
}

export async function updateDiscount(
  id: string,
  merchant_id: string,
  payload: Partial<Omit<Discount, "id" | "merchant_id" | "created_at" | "updated_at">>
): Promise<Discount | null> {
  const client = await pool.connect();
  try {
    const fields: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (payload.name !== undefined) { fields.push(`name = $${idx++}`); values.push(payload.name); }
    if (payload.type !== undefined) { fields.push(`type = $${idx++}`); values.push(payload.type); }
    if (payload.value !== undefined) { fields.push(`value = $${idx++}`); values.push(payload.value); }
    if (payload.description !== undefined) { fields.push(`description = $${idx++}`); values.push(payload.description); }
    if (payload.is_active !== undefined) { fields.push(`is_active = $${idx++}`); values.push(payload.is_active); }

    if (fields.length === 0) return getDiscountById(id, merchant_id);

    fields.push(`updated_at = NOW()`);
    values.push(id, merchant_id);

    const { rows } = await client.query(
      `UPDATE discounts SET ${fields.join(", ")}
       WHERE id = $${idx++} AND merchant_id = $${idx++}
       RETURNING id, merchant_id, name, type, value::double precision AS value, description, is_active, created_at, updated_at`,
      values
    );
    return rows[0] || null;
  } finally {
    client.release();
  }
}

export async function deleteDiscount(
  id: string,
  merchant_id: string
): Promise<boolean> {
  const client = await pool.connect();
  try {
    const { rowCount } = await client.query(
      `DELETE FROM discounts WHERE id = $1 AND merchant_id = $2`,
      [id, merchant_id]
    );
    return (rowCount ?? 0) > 0;
  } finally {
    client.release();
  }
}

/**
 * Calculate the discount amount given the subtotal and discount record.
 */
export function calculateDiscountAmount(
  subtotal: number,
  discount: Pick<Discount, "type" | "value">
): number {
  if (discount.type === "percentage") {
    return Math.min(subtotal, (subtotal * discount.value) / 100);
  }
  return Math.min(subtotal, discount.value);
}
