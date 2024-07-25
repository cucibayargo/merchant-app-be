import pool from "../../database/postgres";
import { Customer } from "./types";

export async function GetCustomers() {
  const client = await pool.connect();
  try {
    const res = await client.query("SELECT * FROM customer");
    return res.rows;
  } finally {
    client.release();
  }
}

/**
 * Add a new customer to the database
 * @param customer - The customer data to add
 * @returns The created customer
 */
export async function addCustomer(customer: Omit<Customer, 'id'>): Promise<Customer> {
  const client = await pool.connect();
  try {
    const { name, phone_number, email, address, gender } = customer;
    const query = `
      INSERT INTO customer (name, phone_number, email, address, gender)
      VALUES ($1, $2, $3, $4, $5) RETURNING *;
    `;
    const values = [name, phone_number, email || null, address, gender];
    const result = await client.query(query, values);
    return result.rows[0];
  } finally {
    client.release();
  }
}

/**
 * Update an existing customer in the database
 * @param id - The ID of the customer to update
 * @param customer - The updated customer data
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
