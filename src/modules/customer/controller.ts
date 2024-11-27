import pool from "../../database/postgres";
import { Customer } from "./types";

/**
 * Retrieve all customers from the database.
 * @returns {Promise<Customer[]>} - A promise that resolves to an array of customers.
 */
export async function GetCustomers(
  filter: string | null,
  merchant_id: string,
  page: number = 1,
  limit: number = 10
): Promise<{ customers: Customer[]; totalCount: number }> {
  const client = await pool.connect();
  try {
    const offset = (page - 1) * limit;

    // Query for customers with pagination
    const query = `
      SELECT *
      FROM customer
      WHERE (($1::text IS NULL OR customer.name ILIKE '%' || $1 || '%')
          OR ($1::text IS NULL OR customer.phone_number ILIKE '%' || $1 || '%')
          OR ($1::text IS NULL OR customer.email ILIKE '%' || $1 || '%'))
        AND merchant_id = $2
      ORDER BY created_at DESC
      LIMIT $3 OFFSET $4
    `;
    const customersResult = await client.query(query, [filter, merchant_id, limit, offset]);

    // Query for total count
    const countQuery = `
      SELECT COUNT(*) AS total_count
      FROM customer
      WHERE (($1::text IS NULL OR customer.name ILIKE '%' || $1 || '%')
          OR ($1::text IS NULL OR customer.phone_number ILIKE '%' || $1 || '%')
          OR ($1::text IS NULL OR customer.email ILIKE '%' || $1 || '%'))
        AND merchant_id = $2
    `;
    const countResult = await client.query(countQuery, [filter, merchant_id]);

    const totalCount = parseInt(countResult.rows[0].total_count, 10);

    return {
      customers: customersResult.rows,
      totalCount,
    };
  } finally {
    client.release();
  }
}


/**
 * Retrieve a customer by ID from the database.
 * @param id - The ID of the customer to retrieve.
 * @returns {Promise<Customer | null>} - A promise that resolves to the customer, or null if not found.
 */
export async function getCustomerById(id: string): Promise<Customer | null> {
  const client = await pool.connect();
  try {
    const res = await client.query("SELECT * FROM customer WHERE id = $1", [id]);
    return res.rows.length > 0 ? res.rows[0] : null;
  } finally {
    client.release();
  }
}

/**
 * Add a new customer to the database.
 * @param customer - The customer data to add. Excludes 'id' as it's auto-generated.
 * @returns {Promise<Customer>} - A promise that resolves to the newly created customer.
 */
export async function addCustomer(customer: Omit<Customer, 'id'>, merchant_id: string): Promise<Customer> {
  const client = await pool.connect();
  try {
    const { name, phone_number, email, address, gender } = customer;
    const query = `
      INSERT INTO customer (name, phone_number, email, address, gender, merchant_id)
      VALUES ($1, $2, $3, $4, $5, $6) RETURNING *;
    `;
    const values = [name, phone_number, email || null, address, gender, merchant_id];
    const result = await client.query(query, values);
    return result.rows[0];
  } finally {
    client.release();
  }
}

/**
 * Update an existing customer in the database.
 * @param id - The ID of the customer to update.
 * @param customer - The updated customer data. Excludes 'id' as it's the identifier for the update.
 * @returns {Promise<Customer>} - A promise that resolves to the updated customer.
 */
export async function updateCustomer(id: string, customer: Omit<Customer, 'id'>): Promise<Customer> {
  const client = await pool.connect();
  try {
    const { name, phone_number, email, address, gender } = customer;
    const query = `
      UPDATE customer
      SET name = $1, phone_number = $2, email = $3, address = $4, gender = $5
      WHERE id = $6 RETURNING *;
    `;
    const values = [name, phone_number, email || null, address, gender, id];
    const result = await client.query(query, values);
    return result.rows[0];
  } finally {
    client.release();
  }
}

/**
 * Delete a customer by ID from the database.
 * @param id - The ID of the customer to delete.
 * @returns {Promise<boolean>} - A promise that resolves to true if the customer was deleted, or false if not found.
 */
export async function deleteCustomer(id: string): Promise<boolean> {
  const client = await pool.connect();
  try {
    const res = await client.query("DELETE FROM customer WHERE id = $1 RETURNING *", [id]);
    return res.rows.length > 0;
  } finally {
    client.release();
  }
}
