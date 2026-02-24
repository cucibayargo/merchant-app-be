import pool from "../../database/postgres";
import { ExpansePayload, ExpanseRecord } from "./types";

export async function createExpanse(payload: ExpansePayload, merchant_id: string): Promise<boolean> {
  const client = await pool.connect();
  try {
    const query = `
      INSERT INTO expenses (merchant_id, total, description, date)
      VALUES ($1, $2, $3, $4)
      RETURNING id, total, description, date
    `;

    await client.query(query, [merchant_id, payload.total, payload.description, payload.date]);
    return true
  } finally {
    client.release();
  }
}

export async function listExpanse(
  merchant_id: string,
  page: number = 1,
  limit: number = 10,
  filter: string | null = null
): Promise<{ expanses: ExpanseRecord[]; totalCount: number }> {
  const client = await pool.connect();
  try {
    const offset = (page - 1) * limit;

    const query = `
      SELECT id, total, description, date
      FROM expenses
      WHERE merchant_id = $1
        AND ($2::text IS NULL OR description ILIKE '%' || $2 || '%')
      ORDER BY date DESC, id DESC
      LIMIT $3 OFFSET $4
    `;

    const countQuery = `
      SELECT COUNT(*) AS total_count
      FROM expenses
      WHERE merchant_id = $1
        AND ($2::text IS NULL OR description ILIKE '%' || $2 || '%')
    `;

    const [result, countResult] = await Promise.all([
      client.query(query, [merchant_id, filter, limit, offset]),
      client.query(countQuery, [merchant_id, filter]),
    ]);

    const expanses = result.rows.map((row) => ({
      id: Number(row.id),
      total: Number(row.total),
      description: row.description,
      date: row.date,
    }));

    return {
      expanses,
      totalCount: Number(countResult.rows?.[0]?.total_count || 0),
    };
  } finally {
    client.release();
  }
}

export async function getExpanseById(id: number, merchant_id: string): Promise<ExpanseRecord | null> {
  const client = await pool.connect();
  try {
    const query = `
      SELECT id, total, description, date
      FROM expenses
      WHERE id = $1 AND merchant_id = $2
      LIMIT 1
    `;

    const result = await client.query(query, [id, merchant_id]);
    if (!result.rows.length) {
      return null;
    }

    const row = result.rows[0];
    return {
      id: Number(row.id),
      total: Number(row.total),
      description: row.description,
      date: row.date,
    };
  } finally {
    client.release();
  }
}

export async function updateExpanse(id: number, payload: ExpansePayload, merchant_id: string): Promise<ExpanseRecord | null> {
  const client = await pool.connect();
  try {
    const query = `
      UPDATE expenses
      SET total = $1,
          description = $2,
          date = $3
      WHERE id = $4 AND merchant_id = $5
      RETURNING id, total, description, date
    `;

    const result = await client.query(query, [payload.total, payload.description, payload.date, id, merchant_id]);
    if (!result.rows.length) {
      return null;
    }

    const row = result.rows[0];
    return {
      id: Number(row.id),
      total: Number(row.total),
      description: row.description,
      date: row.date,
    };
  } finally {
    client.release();
  }
}

export async function deleteExpanse(id: number, merchant_id: string): Promise<boolean> {
  const client = await pool.connect();
  try {
    const query = `DELETE FROM expenses WHERE id = $1 AND merchant_id = $2 RETURNING id`;
    const result = await client.query(query, [id, merchant_id]);
    return result.rows.length > 0;
  } finally {
    client.release();
  }
}