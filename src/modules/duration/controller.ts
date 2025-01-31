import pool from "../../database/postgres";
import { Duration, DurationType } from "./types";


/**
 * Retrieve all durations from the database with optional pagination.
 * @param {boolean | undefined} hasService - A flag to include only durations linked to a service.
 * @param {string | undefined} merchant_id - The ID of the merchant to filter durations.
 * @returns {Promise<Duration[]>} - A promise that resolves to an object containing durations and the total count.
 */
export async function getAllDurations(
  hasService?: boolean,
  merchant_id?: string
): Promise<Duration[]> {
  const client = await pool.connect();
  try {
    // Base query for durations
    let baseQuery = `
      FROM duration 
      LEFT JOIN service_duration ON duration.id = service_duration.duration
      WHERE merchant_id = $1
    `;

    if (hasService) {
      baseQuery += ` AND service_duration.id IS NOT NULL`;
    }

    // Query to get durations with pagination
    const dataQuery = `
      SELECT duration.*
      ${baseQuery}
      GROUP BY duration.id
      ORDER BY duration.created_at DESC
    `;
    const dataParams = [merchant_id];

    // Run the query for durations
    const dataResult = await client.query(dataQuery, dataParams);

    // Return the durations and total count
    return dataResult.rows;
  } catch (error) {
    console.error("Error fetching durations:", error);
    throw error;
  } finally {
    client.release();
  }
}

/**
 * Retrieve all durations from the database with optional pagination.
 * @param {string | null} filter - A string to filter durations by name, duration, or type.
 * @param {boolean | undefined} hasService - A flag to include only durations linked to a service.
 * @param {string | undefined} merchant_id - The ID of the merchant to filter durations.
 * @param {number} [page=1] - The page number for pagination.
 * @param {number} [limit=10] - The number of durations per page.
 * @returns {Promise<{ durations: Duration[], totalCount: number }>} - A promise that resolves to an object containing durations and the total count.
 */
export async function getDurations(
  filter: string | null,
  hasService?: boolean,
  merchant_id?: string,
  page: number = 1,
  limit: number = 10
): Promise<{ durations: Duration[], totalCount: number }> {
  const client = await pool.connect();
  try {
    // Base query for durations
    let baseQuery = `
      FROM duration 
      LEFT JOIN service_duration ON duration.id = service_duration.duration
      WHERE (($1::text IS NULL OR duration.name ILIKE '%' || $1 || '%')
        OR ($1::text IS NULL OR duration.duration::text ILIKE '%' || $1 || '%')
        OR ($1::text IS NULL OR duration.type::text ILIKE '%' || $1 || '%'))
        AND merchant_id = $2
    `;

    if (hasService) {
      baseQuery += ` AND service_duration.id IS NOT NULL`;
    }

    // Query for total count
    const countQuery = `
      SELECT COUNT(DISTINCT duration.id) AS total_count
      ${baseQuery}
    `;
    const countResult = await client.query(countQuery, [filter, merchant_id]);
    const totalCount = parseInt(countResult.rows[0].total_count, 10);

    // Pagination logic
    const offset = (page - 1) * limit;

    // Query for durations
    const dataQuery = `
      SELECT duration.*
      ${baseQuery}
      GROUP BY duration.id
      ORDER BY duration.created_at DESC
      LIMIT $3 OFFSET $4
    `;
    const dataParams = [filter, merchant_id, limit, offset];
    const dataResult = await client.query(dataQuery, dataParams);

    return {
      durations: dataResult.rows,
      totalCount,
    };
  } catch (error) {
    console.error("Error fetching durations:", error);
    throw error;
  } finally {
    client.release();
  }
}

/**
 * Retrieve a specific duration by its ID.
 * @param id - The ID of the duration to retrieve.
 * @returns {Promise<Duration | null>} - A promise that resolves to the duration if found, or null if not found.
 */
export async function getDurationById(id: string): Promise<Duration | null> {
  const client = await pool.connect();
  try {
    const res = await client.query("SELECT * FROM duration WHERE id = $1", [id]);
    return res.rows[0] || null;
  } finally {
    client.release();
  }
}

/**
 * Add a new duration to the database.
 * @param duration - The duration data to add. Excludes 'id' as it's auto-generated.
 * @returns {Promise<Duration>} - A promise that resolves to the newly created duration.
 */
export async function addDuration(duration: Omit<Duration, 'id'>, merchant_id?: string): Promise<Duration> {
  const client = await pool.connect();
  try {
    const { name, duration: value, type } = duration;
    const query = `
      INSERT INTO duration (name, duration, type, merchant_id)
      VALUES ($1, $2, $3, $4) RETURNING *;
    `;
    const values = [name, value, type, merchant_id];
    const result = await client.query(query, values);
    return result.rows[0];
  } finally {
    client.release();
  }
}

/**
 * Update an existing duration in the database.
 * @param id - The ID of the duration to update.
 * @param duration - The updated duration data. Excludes 'id' as it's the identifier for the update.
 * @returns {Promise<Duration>} - A promise that resolves to the updated duration.
 */
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

/**
 * Delete a duration from the database by its ID.
 * @param id - The ID of the duration to delete.
 * @returns {Promise<void>} - A promise that resolves when the deletion is complete.
 */
export async function deleteDuration(id: string): Promise<void> {
  const client = await pool.connect();
  try {
    const query = `
      SELECT * FROM service_duration WHERE duration = $1
    `;
    const services = await client.query(query, [id]);

    if (services.rowCount !== null && services.rowCount > 0) {
      throw new Error("Durasi sedang digunakan oleh layanan");
    } else {
      await client.query("DELETE FROM duration WHERE id = $1", [id]);
    }
  } finally {
    client.release();
  }
}
