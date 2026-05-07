import pool from "../../database/postgres";
import { Plan } from "./types";

export async function getPlanList(): Promise<Plan[]> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `
      SELECT id, name, code, price, created_at, features
      FROM app_plans
      ORDER BY price ASC
      `
    );

    return result.rows;
  } finally {
    client.release();
  }
}
