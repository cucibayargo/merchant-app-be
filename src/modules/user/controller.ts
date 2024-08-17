import pool from "../../database/postgres";
import { User } from "../auth/types";

/**
 * Update the user's profile with the logo URL.
 * @param userId - The ID of the user.
 * @param logoUrl - The URL of the user's logo.
 * @returns A promise that resolves when the profile is updated.
 */
export async function updateUserProfile(userId: string, logoUrl: string): Promise<void> {
  const client = await pool.connect();
  try {
    const query = 'UPDATE users SET logo = $1 WHERE id = $2';
    await client.query(query, [logoUrl, userId]);
  } finally {
    client.release();
  }
}

/**
 * Retrieve user details by ID.
 * @param id - The ID of the user to retrieve.
 * @returns A promise that resolves to the user details or null if not found.
 */
export async function getUserDetails(id: string): Promise<User | null> {
    const client = await pool.connect();
    try {
      const result = await client.query('SELECT * FROM users WHERE id = $1', [id]);
      return result.rows[0] || null;
    } finally {
      client.release();
    }
  }
  
  /**
   * Update user details by ID.
   * @param id - The ID of the user to update.
   * @param userData - The updated user data, including optional logo field.
   * @returns A promise that resolves to the updated user or null if not found.
   */
  export async function updateUserDetails(id: string, userData: Partial<User>): Promise<User | null> {
    const client = await pool.connect();
    const { name, email, phone_number, address, logo } = userData;
  
    // Ensure required fields are provided
    if (!name || !email) {
      throw new Error('Name and email are required');
    }
  
    try {
      const result = await client.query(
        'UPDATE users SET name = $1, email = $2, phone_number = $3, address = $4, logo = $5 WHERE id = $6 RETURNING *',
        [name, email, phone_number, address, logo, id]
      );
      return result.rows[0] || null;
    } finally {
      client.release();
    }
  }