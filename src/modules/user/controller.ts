import { PoolClient } from "pg";
import pool from "../../database/postgres";
import { User, UserDetail } from "../auth/types";
import supabase from "../../database/supabase";
import Mailjet from 'node-mailjet';

/**
 * Update the user's profile with the logo URL.
 * @param userId - The ID of the user.
 * @param logoUrl - The URL of the user's logo.
 * @returns A promise that resolves when the profile is updated.
 */
export async function updateUserProfile(
  userId: string,
  logoUrl: string
): Promise<void> {
  const client = await pool.connect();
  try {
    const query = "UPDATE users SET logo = $1 WHERE id = $2";
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
export async function getUserDetails(id?: string): Promise<User | null> {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `SELECT id,name,email,phone_number,logo,address FROM users WHERE id = $1`,
      [id]
    );
    return result.rows[0] || null;
  } finally {
    client.release();
  }
}

/**
 * Update user details by ID.
 * @param id - The ID of the user to update.
 * @param userData - The updated user data, including optional fields.
 * @returns A promise that resolves to the updated user or null if not found.
 */
export async function updateUserDetails(
  id: string,
  userData: Partial<User>
): Promise<UserDetail | null> {
  const client: PoolClient = await pool.connect();

  try {
    // Dynamically build the SQL query and parameters based on provided fields
    const setClauses = [];
    const params: any[] = [];
    let index = 1;

    if (userData.name) {
      setClauses.push(`name = $${index++}`);
      params.push(userData.name);
    }

    if (userData.status) {
      setClauses.push(`status = $${index++}`);
      params.push(userData.status);
    }

    if (userData.email) {
      setClauses.push(`email = $${index++}`);
      params.push(userData.email);
    }

    if (userData.phone_number) {
      setClauses.push(`phone_number = $${index++}`);
      params.push(userData.phone_number);
    }

    if (userData.address) {
      setClauses.push(`address = $${index++}`);
      params.push(userData.address);
    }

    if (userData.logo) {
      setClauses.push(`logo = $${index++}`);
      params.push(userData.logo);
    }

    // Add the ID to the parameters
    params.push(id);

    // Construct the final SQL query
    const query = `
        UPDATE users
        SET ${setClauses.join(", ")}
        WHERE id = $${index}
        RETURNING *
      `;

    // Execute the query
    const result = await client.query(query, params);

    const userDatail: UserDetail = {
      id: result.rows[0].id,
      name: result.rows[0].name,
      email: result.rows[0].email,
      phone_number: result.rows[0].phone_number,
      logo: result.rows[0].logo,
      address: result.rows[0].address,
    };
    return result.rows[0] ? userDatail : null;
  } finally {
    client.release();
  }
}

export async function deleteTempFiles() {
  const currentDate = new Date().toLocaleString('id-ID', { timeZone: 'Asia/Jakarta' });
  console.log(`Cron job started at ${currentDate}`);
  try {
    const { data, error } = await supabase.storage
      .from('logos') // Bucket name
      .list('temp', { limit: 1000 });

    if (error) {
      console.error('Error fetching temp folder files:', error.message);
      return;
    }

    if (data?.length) {
      const deletePromises = data.map((file) =>
        supabase.storage.from('logos').remove([`temp/${file.name}`])
      );
      await Promise.all(deletePromises);
      console.log('All files deleted from temp folder');
    } else {
      console.log('No files in temp folder to delete');
    }
  } catch (error) {
    console.error('Error deleting files:', error);
  }
}
export async function checkUserSubscriptions(): Promise<void> {
  const client = await pool.connect();
  try {
    const now = new Date();
    const result = await client.query(
      `SELECT 
        app_subscriptions.end_date, 
        users.name, 
        users.email 
      FROM users 
      LEFT JOIN app_subscriptions 
      ON app_subscriptions.user_id = users.id`
    );

    // Filter users with subscriptions ending in the next 5 days
    const soonExpiringSubscriptions = result.rows.filter((row) => {
      const endDate = new Date(row.end_date);
      const diffDays = Math.ceil((endDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
      return diffDays == 5;
    });

    // Send email notifications for expiring subscriptions
    await Promise.all(
      soonExpiringSubscriptions.map((user) =>
        sendEmailNotification(user.email, user.end_date)
      )
    );

    console.log('Email notifications sent successfully for expiring subscriptions.');
  } catch (error) {
    console.error('Error checking user subscriptions:', error);
  } finally {
    client.release();
  }
}

const sendEmailNotification = async (email: string, endDate: string): Promise<void> => {
  const mailjet = Mailjet.apiConnect(
    process.env.MAILJET_API_KEY as string,
    process.env.MAILJET_API_SECRET as string,
    { options: { timeout: 20000 } }
  );

  const verificationUrl = `https://example.com/verify?email=${encodeURIComponent(email)}`;
  const emailData = {
    Messages: [
      {
        From: {
          Email: 'no-reply@cucibayargo.com',
          Name: 'Cucibayargo',
        },
        To: [
          {
            Email: email,
          },
        ],
        Subject: 'Langganan Anda Akan Segera Berakhir!',
        HTMLPart: `
          <html>
            <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;">
              <table align="center" width="100%" cellpadding="0" cellspacing="0" style="max-width: 600px; background-color: #f4f4f4; padding: 40px 0;">
                <tr>
                  <td>
                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="max-width: 600px; background-color: #ffffff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
                      <tr>
                        <td style="text-align: center;">
                          <img src="https://example.com/logo.png" alt="Cucibayargo" style="width: 150px; margin-bottom: 20px;" />
                        </td>
                      </tr>
                      <tr>
                        <td style="text-align: center; padding: 20px;">
                          <h1 style="color: #333333;">Langganan Anda Akan Segera Berakhir</h1>
                          <p style="font-size: 16px; color: #555555;">
                            Langganan Anda akan berakhir pada <strong>${endDate}</strong>. Jangan lupa untuk memperpanjang langganan Anda sebelum tanggal tersebut agar tetap dapat menikmati layanan kami.
                          </p>
                          <a href="${verificationUrl}" style="background-color: #007bff; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-size: 16px; display: inline-block; margin-top: 20px;">Perpanjang Sekarang</a>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding: 20px; text-align: center; color: #999999; font-size: 12px;">
                          Jika Anda merasa menerima email ini karena kesalahan, abaikan saja.
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </body>
          </html>`,
      },
    ],
  };

  try {
    const response = await mailjet.post('send', { version: 'v3.1' }).request(emailData);
    console.log(`Email sent to ${email} with response:`, response.body);
  } catch (error) {
    console.error(`Failed to send email to ${email}:`, error);
  }
};

/**
 * Handles invoice transfer uploads.
 * @param userId - The ID of the authenticated user.
 * @param note - The note provided by the user.
 * @param filePath - The file path of the uploaded file.
 */
export const uploadTransactionFile = async (
  userId: string,
  note: string,
  filePath: string
) => {
  try {
    const result = await pool.query(
      `INSERT INTO app_transactions (user_id, file, note) VALUES ($1, $2, $3) RETURNING *`,
      [userId, filePath, note]
    );
    return { success: true, transaction: result.rows[0] };
  } catch (error) {
    throw error;
  }
};