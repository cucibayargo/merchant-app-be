import pool from "../../database/postgres";
import { SignUpInput, SignUpTokenInput, User } from "./types";
import bcrypt from "bcrypt";

/**
 * Retrieve a user by their email.
 * @param email - The email of the user to retrieve.
 * @returns {Promise<User | null>} - A promise that resolves to the user if found, or null if not found.
 */
export async function getUserByEmail(email: string): Promise<User | null> {
  const client = await pool.connect();
  try {
    const res = await client.query('SELECT * FROM users WHERE email = $1', [email]);
    return res.rows[0] || null;
  } finally {
    client.release();
  }
}

/**
 * Retrieve a App Plans by subscriotion code.
 * @param code - The code of the plan to retrieve.
 * @returns {Promise<string | null>} - A promise that resolves to the user if found, or null if not found.
 */
export async function getSubsPlanByCode(code: string): Promise<string | null> {
  const client = await pool.connect();
  try {
    const res = await client.query('SELECT * FROM app_plans WHERE code = $1', [code]);
    return res.rows[0]?.id || null;
  } finally {
    client.release();
  }
}

/**
 * Add a new user to the database.
 * @param user - The user data to add. Excludes 'id' as it's auto-generated.
 * @returns {Promise<User>} - A promise that resolves to the newly created user.
 */
export async function addUser(user: Omit<SignUpInput, 'id'>): Promise<User> {
  const client = await pool.connect();
  try {
    const { name, email, password, phone_number, oauth, status} = user;
    const query = `
      INSERT INTO users (name, email, password, phone_number, oauth, status)
      VALUES ($1, $2, $3, $4, $5, $6) RETURNING *;
    `;
    const values = [name, email, password, phone_number, oauth, status];
    const result = await client.query(query, values);
    return result.rows[0];
  } finally {
    client.release();
  }
}


/**
 * Change the user's password.
 * @param email - The user's email.
 * @param currentPassword - The user's current password.
 * @param newPassword - The new password to set.
 * @returns A promise that resolves if the password was successfully changed.
 */
export async function changeUserPassword(email: string, currentPassword: string, newPassword: string): Promise<void> {
    const client = await pool.connect();
    try {
      const userQuery = 'SELECT password FROM users WHERE email = $1';
      const res = await client.query(userQuery, [email]);
  
      if (res.rows.length === 0) {
        throw new Error('User not found.');
      }
  
      const user = res.rows[0];
      const validPassword = await bcrypt.compare(currentPassword, user.password);
      if (!validPassword) {
        throw new Error('Current password is incorrect.');
      }
  
      const hashedNewPassword = await bcrypt.hash(newPassword, 10);
      const updateQuery = 'UPDATE users SET password = $1 WHERE email = $2';
      await client.query(updateQuery, [hashedNewPassword, email]);
    } finally {
      client.release();
    }
  }
  
export async function addUserSignUpToken(payload: Omit<SignUpTokenInput, 'id'>): Promise<void> {
  const client = await pool.connect();
  try {
    const { name, email, phone_number, token, status, subscription_plan} = payload;
    const query = `
      INSERT INTO users_signup (name, email, phone_number, token, status, subscription_plan)
      VALUES ($1, $2, $3, $4, $5, $6);
    `;
    const values = [name, email, phone_number, token, status, subscription_plan];
    await client.query(query, values);
  } finally {
    client.release();
  }
}

export async function validateToken(email: string, token: string): Promise<boolean> {
  const client = await pool.connect();
  try {
    const query = `
      SELECT token 
      FROM users_signup 
      WHERE email = $1 AND token = $2;
    `;
    const result = await client.query(query, [email, token]);

    // Check if any rows were returned
    return result.rows.length > 0;
  } finally {
    client.release();
  }
}

export async function updateUserSignupStatus(email: string, token: string, userId: string): Promise<void> {
  const client = await pool.connect();
  try {
    const query = `
      UPDATE users_signup
      SET status = 'signed', user_id = $1
      WHERE email = $2 AND token = $3;
    `;
    await client.query(query, [userId, email, token]);
  } finally {
    client.release();
  }
}