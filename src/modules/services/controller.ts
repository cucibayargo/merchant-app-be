import pool from "../../database/postgres";
import { Service, ServiceDurationDetail } from "./types";

/**
 * Fetches all services with their IDs, names, and optional prices from the database.
 * 
 * @param {string} [merchantId] - The merchant ID to filter services by.
 * @param {string | null} [durationId] - The duration ID to filter associated service prices.
 * @returns {Promise<{ id: number, name: string, price?: number }[]>} - 
 * @param {string | null} filter - A string to filter services by name.
 * A promise resolving to an array of services with IDs, names, and optional prices.
 */
export async function getAllServices(
  merchantId?: string, 
  durationId?: string | null,
  filter?: string | null
): Promise<{ id: number, name: string, price?: number }[]> {
  const client = await pool.connect();

  try {
    // Query to fetch service details, including optional pricing for a given duration.
    const query = `
      SELECT 
        service.id, 
        service.name, 
        service_duration.price
      FROM service
      LEFT JOIN service_duration 
        ON service.id = service_duration.service
      WHERE 
        ($1::text IS NULL OR service.name ILIKE '%' || $1 || '%') AND
        service.merchant_id = $2 AND
        service_duration.duration::text = $3
      ORDER BY service.created_at DESC
    `;

    const params = [filter, merchantId, durationId];
    const result = await client.query(query, params);

    return result.rows;
  } catch (error) {
    console.error("Error fetching services:", error);
    throw error; // Re-throw error for handling by the caller.
  } finally {
    client.release(); // Ensure the database client is released.
  }
}

/**
 * Retrieve all services with their IDs, names, and optional prices from the database.
 * @param {string | null} filter - A string to filter services by name.
 * @param {string | undefined} merchantId - The ID of the merchant to filter services.
 * @param {number} [page=1] - The page number for pagination.
 * @param {number} [limit=10] - The maximum number of services per page.
 * @returns {Promise<{ services: { id: number, name: string, price?: number }[], totalCount: number }>} 
 * - A promise that resolves to an object containing services and the total count.
 */
export async function getServices(
  filter: string | null, 
  merchantId?: string, 
  page: number = 1,
  limit: number = 10
): Promise<{ services: { id: number, name: string, price?: number }[], totalCount: number }> {
  const client = await pool.connect();
  try {
    // Base query for services
    const baseQuery = `
      FROM service
      WHERE ($1::text IS NULL OR service.name ILIKE '%' || $1 || '%') 
        AND service.merchant_id = $2
    `;

    // Query for total count
    const countQuery = `
      SELECT COUNT(*) AS total_count
      ${baseQuery}
    `;
    const countResult = await client.query(countQuery, [filter, merchantId]);
    const totalCount = parseInt(countResult.rows[0].total_count, 10);

    // Calculate offset for pagination
    const offset = (page - 1) * limit;

    // Query for services with pagination
    const dataQuery = `
      SELECT service.id, service.name
      ${baseQuery}
      ORDER BY service.created_at DESC
      LIMIT $3 OFFSET $4
    `;
    const dataResult = await client.query(dataQuery, [filter, merchantId, limit, offset]);

    return {
      services: dataResult.rows,
      totalCount,
    };
  } catch (error) {
    console.error("Error fetching services:", error);
    throw error;
  } finally {
    client.release();
  }
}

/**
 * Retrieve a service by its ID, along with its associated durations, from the database.
 * @param {number} serviceId - The ID of the service to retrieve.
 * @returns {Promise<Service | null>} - A promise that resolves to the service with durations or null if not found.
 */
export async function getServiceById(serviceId: string): Promise<Service | null> {
  const client = await pool.connect();
  try {
    const query = `
      SELECT service.id AS id,
             service.name AS name,
             service.unit AS unit,
             service_duration.id AS duration_id,
             service_duration.duration,
             duration.name AS duration_name,
             service_duration.price
      FROM service
      LEFT JOIN service_duration ON service.id = service_duration.service
      LEFT JOIN duration ON service_duration.duration = duration.id
      WHERE service.id = $1
      ORDER BY service.created_at DESC
    `;

    const result = await client.query(query, [serviceId]);
    if (result.rows.length === 0) {
      return null; // Service not found
    }

    const service: Service = {
      id: result.rows[0].id,
      name: result.rows[0].name,
      unit: result.rows[0].unit,
      durations: [],
    };

    result.rows.forEach(row => {
      if (row.duration_id) {
        service.durations.push({
          id: row.duration_id,
          duration: row.duration,
          duration_name: row.duration_name,
          price: row.price,
        });
      }
    });

    return service;
  } finally {
    client.release();
  }
}

/**
 * Add a new service to the database.
 * @param service - The service data to add.
 * @returns {Promise<Service>} - A promise that resolves to the newly created service.
 */
export async function addService(service: Omit<Service, 'id'>, merchant_id?: string): Promise<Service> {
  const client = await pool.connect();
  try {
    const { name, unit, durations } = service;
    const query = `
      INSERT INTO service (name, unit, merchant_id)
      VALUES ($1, $2, $3) RETURNING id;
    `;
    const values = [name, unit, merchant_id];
    const result = await client.query(query, values);
    const newServiceId = result.rows[0].id;

    // Insert service durations
    const durationQueries = durations.map(duration => {
      return {
        text: `
          INSERT INTO service_duration (service, duration, price)
          VALUES ($1, $2, $3);
        `,
        values: [newServiceId, duration.duration, duration.price],
      };
    });

    for (const query of durationQueries) {
      await client.query(query.text, query.values);
    }

    return {
      id: newServiceId,
      name,
      unit,
      durations,
    };
  } finally {
    client.release();
  }
}

/**
 * Update an existing service in the database.
 * @param id - The ID of the service to update.
 * @param service - The updated service data.
 * @returns {Promise<Service>} - A promise that resolves to the updated service.
 */
export async function updateService(id: string, service: Omit<Service, 'id'>): Promise<Service> {
  const client = await pool.connect();
  try {
    const { name, unit, durations } = service;

    // Update the service
    const updateServiceQuery = `
      UPDATE service
      SET name = $1, unit = $2
      WHERE id = $3 RETURNING id;
    `;
    const updateServiceValues = [name, unit, id];
    await client.query(updateServiceQuery, updateServiceValues);

    // Remove existing durations and add new ones
    await client.query('DELETE FROM service_duration WHERE service = $1;', [id]);

    const durationQueries = durations.map(duration => {
      return {
        text: `
          INSERT INTO service_duration (service, duration, price)
          VALUES ($1, $2, $3);
        `,
        values: [id, duration.duration, duration.price],
      };
    });

    for (const query of durationQueries) {
      await client.query(query.text, query.values);
    }

    return {
      id,
      name,
      unit,
      durations,
    };
  } finally {
    client.release();
  }
}

/**
 * Delete a service from the database.
 * @param id - The ID of the service to delete.
 */
export async function deleteService(id: string): Promise<void> {
  const client = await pool.connect();
  try {
    // Delete service durations
    await client.query('DELETE FROM service_duration WHERE service = $1;', [id]);

    // Delete the service
    await client.query('DELETE FROM service WHERE id = $1;', [id]);
  } finally {
    client.release();
  }
}


export async function getServiceDurationDetail(service: string, duration: string): Promise<ServiceDurationDetail> {
  const client = await pool.connect();
  try {
    const query = `
      SELECT
        service.name,
        service.unit,
        service.id,
        service_duration.price
      FROM service
      LEFT JOIN service_duration ON service_duration.service = service.id 
      WHERE service.id = $1 AND service_duration.duration = $2
    `
     const result = await client.query(query, [service, duration]);
     return result?.rows?.[0];
  } finally {
    client.release();
  }
}