import pool from "../../database/postgres";
import { Plan } from "./types";

export async function getPlanList(): Promise<Plan[]> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT id, name, code, price, duration, created_at
      FROM app_plans
      ORDER BY duration ASC
      `
    );

    return result.rows;
  } finally {
    client.release();
  }
}
