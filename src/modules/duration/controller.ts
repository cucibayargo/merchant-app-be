import pool from "../../database/postgres";
import { Duration, DurationType } from "./types";

export async function getDurations(): Promise<Duration[]> {
  const client = await pool.connect();
  try {
    const res = await client.query("SELECT * FROM duration");
    return res.rows;
  } finally {
    client.release();
  }
}

export async function getDurationById(id: string): Promise<Duration | null> {
  const client = await pool.connect();
  try {
    const res = await client.query("SELECT * FROM duration WHERE id = $1", [id]);
    return res.rows[0] || null;
  } finally {
    client.release();
  }
}

export async function addDuration(duration: Omit<Duration, 'id'>): Promise<Duration> {
  const client = await pool.connect();
  try {
    const { name, duration: value, type } = duration;
    const query = `
      INSERT INTO duration (name, duration, type)
      VALUES ($1, $2, $3) RETURNING *;
    `;
    const values = [name, value, type];
    const result = await client.query(query, values);
    return result.rows[0];
  } finally {
    client.release();
  }
}

export async function updateDuration(id: string, duration: Omit<Duration, 'id'>): Promise<Duration> {
  const client = await pool.connect();
  try {
    const { name, duration: value, type } = duration;
    const query = `
      UPDATE duration
      SET name = $1, duration = $2, type = $3
      WHERE id = $4 RETURNING *;
    `;
    const values = [name, value, type, id];
    const result = await client.query(query, values);
    return result.rows[0];
  } finally {
    client.release();
  }
}

export async function deleteDuration(id: string): Promise<void> {
  const client = await pool.connect();
  try {
    await client.query("DELETE FROM duration WHERE id = $1", [id]);
  } finally {
    client.release();
  }
}
