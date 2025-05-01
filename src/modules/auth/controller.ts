import pool from "../../database/postgres";
import {
  SignUpInput,
  SignUpTokenInput,
  SubscriptionInput,
  SubscriptionPlan,
  User,
} from "./types";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import Mailjet from "node-mailjet";

/**
 * Retrieve a user by their email.
 * @param email - The email of the user to retrieve.
 * @returns {Promise<User | null>} - A promise that resolves to the user if found, or null if not found.
 */
export async function getUserByEmail(email: string): Promise<User | null> {
  const client = await pool.connect();
  try {
    const res = await client.query(
      `
      SELECT 
        users.*,
        app_plans.code as plan_code,
        app_subscriptions.start_date as subscription_start,
        app_subscriptions.end_date as subscription_end
      FROM users 
      LEFT JOIN app_subscriptions ON app_subscriptions.user_id = users.id 
      LEFT JOIN app_plans ON app_plans.id = app_subscriptions.plan_id 
      WHERE users.email = $1
      `,
      [email]
    );
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
export async function getSubsPlanByCode(
  code: string
): Promise<SubscriptionPlan> {
  const client = await pool.connect();
  try {
    const res = await client.query("SELECT * FROM app_plans WHERE code = $1", [
      code,
    ]);
    return res.rows[0] || null;
  } finally {
    client.release();
  }
}

export async function getUserPlanPrice(
  user_id: string
): Promise<{price: number} | null> {
  const client = await pool.connect();
  try {
    const res = await client.query(`
      SELECT user_plan_price as price FROM app_subscriptions 
      WHERE user_id = $1`, [
      user_id,
    ]);
    return res.rows[0] || null;
  } finally {
    client.release();
  }
}

/**
 * Retrieve a App Plans by subscriotion id.
 * @param id - The id of the plan to retrieve.
 * @returns {Promise<string | null>} - A promise that resolves to the user if found, or null if not found.
 */
export async function getSubsPlanById(id: string): Promise<SubscriptionPlan> {
  const client = await pool.connect();
  try {
    const res = await client.query("SELECT * FROM app_plans WHERE id = $1", [
      id,
    ]);
    return res.rows[0] || null;
  } finally {
    client.release();
  }
}

export async function verifySignupToken(token: string): Promise<boolean> {
  const client = await pool.connect();
  try {
    const res = await client.query(
      `SELECT 
        CASE WHEN status = 'signed' THEN false ELSE true END AS is_valid
      FROM users_signup WHERE token = $1 LIMIT 1`,
      [token]
    );
    if (res.rowCount === 0) {
      return false; // Token not found
    }
    

    return res.rows[0].is_valid;
  } finally {
    client.release();
  }
}

/**
 * Add a new user to the database.
 * @param user - The user data to add. Excludes 'id' as it's auto-generated.
 * @returns {Promise<User>} - A promise that resolves to the newly created user.
 */
export async function addUser(user: Omit<SignUpInput, "id">): Promise<User> {
  const client = await pool.connect();
  try {
    const { name, email, password, phone_number, oauth, status } = user;
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
 * Add User Subscription
 */
export async function createSubscriptions(
  user: Omit<SubscriptionInput, "id">
): Promise<User> {
  const client = await pool.connect();
  try {
    const { start_date, end_date, user_id, plan_id, price } = user;
    const query = `
      INSERT INTO app_subscriptions (start_date, end_date, user_id, plan_id, user_plan_price)
      VALUES ($1, $2, $3, $4, $5) RETURNING *;
    `;
    const values = [start_date, end_date, user_id, plan_id, price];
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
export async function changeUserPassword(
  email: string,
  currentPassword: string,
  newPassword: string
): Promise<void> {
  const client = await pool.connect();
  try {
    const userQuery = "SELECT password FROM users WHERE email = $1";
    const res = await client.query(userQuery, [email]);

    if (res.rows.length === 0) {
      throw new Error("User not found.");
    }

    const user = res.rows[0];
    const validPassword = await bcrypt.compare(currentPassword, user.password);
    if (!validPassword) {
      throw new Error("Password tidak sesuai. Silakan coba lagi.");
    }

    const hashedNewPassword = await bcrypt.hash(newPassword, 10);
    const updateQuery = "UPDATE users SET password = $1 WHERE email = $2";
    await client.query(updateQuery, [hashedNewPassword, email]);
  } finally {
    client.release();
  }
}

export async function addUserSignUpToken(
  payload: Omit<SignUpTokenInput, "id">
): Promise<void> {
  const client = await pool.connect();
  try {
    const { name, email, phone_number, token, status, subscription_plan } =
      payload;
    const query = `
      INSERT INTO users_signup (name, email, phone_number, token, status, subscription_plan)
      VALUES ($1, $2, $3, $4, $5, $6);
    `;
    const values = [
      name,
      email,
      phone_number,
      token,
      status,
      subscription_plan,
    ];
    await client.query(query, values);
  } finally {
    client.release();
  }
}

export async function validateToken(
  email: string,
  token: string
): Promise<boolean> {
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

export async function updateUserSignupStatus(
  email: string,
  token: string,
  userId: string
): Promise<void> {
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

export const notifyUserToPaySubscription = async (
  email: string
): Promise<void> => {
  const mailjet = Mailjet.apiConnect(
    process.env.MAILJET_API_KEY as string,
    process.env.MAILJET_API_SECRET as string,
    { options: { timeout: 20000 } }
  );

  // Generate JWT token for payment confirmation
  const token = jwt.sign(
    { email }, // Payload
    process.env.JWT_SECRET as string, // Secret key
    { expiresIn: "7d" } // Token expiration time (7 days in this example)
  );

  // Calculate payment deadline (5 days from now)
  const paymentDeadline = new Date();
  paymentDeadline.setDate(paymentDeadline.getDate() + 5);
  const formattedDeadline = paymentDeadline.toLocaleDateString("id-ID", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  const paymentUrl = `https://${process.env.APP_URL}/complete-payment?token=${encodeURIComponent(
    token
  )}`;

  const emailSubject = `Pendaftaran Berlangganan - Pembayaran Dibutuhkan`;
  const emailBody = `
    <html>
      <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;">
        <table align="center" width="100%" cellpadding="0" cellspacing="0" style="max-width: 600px; background-color: #f4f4f4; padding: 40px 0;">
          <tr>
            <td>
              <table align="center" width="100%" cellpadding="0" cellspacing="0" style="max-width: 600px; background-color: #ffffff; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);">
                <tr>
                  <td style="text-align: center;">
                    <img src="https://sbuysfjktbupqjyoujht.supabase.co/storage/v1/object/sign/asset/logo-B3sUIac6.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJhc3NldC9sb2dvLUIzc1VJYWM2LnBuZyIsImlhdCI6MTczMjM3Nzk1NSwiZXhwIjozMzA5MTc3OTU1fQ.81ldrpdW5_BYGJglW6bwmMk6Dmi0x1vNBwy44dmZfGM&t=2024-11-23T16%3A05%3A55.422Z" alt="Cucibayargo" style="width: 150px; margin-bottom: 20px;" />
                  </td>
                </tr>
                <tr>
                  <td style="text-align: center; padding: 20px;">
                    <h1 style="color: #333333;">Pembayaran Dibutuhkan</h1>
                    <p style="font-size: 16px; color: #555555;">
                      Terima kasih telah mendaftar ke paket <strong>Berlangganan</strong>. Untuk melanjutkan, Anda perlu menyelesaikan pembayaran sebelum <strong>${formattedDeadline}</strong>.
                    </p>
                    <a href="${paymentUrl}" style="background-color: #007bff; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-size: 16px; display: inline-block; margin-top: 20px;">Selesaikan Pembayaran</a>
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
    </html>`;

  const emailData = {
    Messages: [
      {
        From: {
          Email: "no-reply@cucibayargo.com",
          Name: "Cucibayargo",
        },
        To: [
          {
            Email: email,
          },
        ],
        Subject: emailSubject,
        HTMLPart: emailBody,
      },
    ],
  };

  try {
    const response = await mailjet
      .post("send", { version: "v3.1" })
      .request(emailData);
    console.log(
      `Payment notification sent to ${email} with response:`,
      response.body
    );
  } catch (error) {
    console.error(`Failed to send payment notification to ${email}:`, error);
  }
};

export async function initServiceAndDuration(
  merchant_id: string
): Promise<boolean> {
  const client = await pool.connect();
  try {
    const query = `
        WITH inserted_durations AS (
            INSERT INTO duration (duration, name, type, merchant_id) VALUES
            (3, 'Reguler', 'Hari', $1),
            (1, 'Express', 'Hari', $1),
            (6, 'Kilat', 'Jam', $1)
            RETURNING id, name
        ),
        inserted_services AS (
            INSERT INTO service (unit, name, merchant_id) VALUES
            ('KG', 'Kiloan - Cuci, Setrika', $1),
            ('KG', 'Kiloan - Cuci', $1),
            ('PCS', 'Jas', $1),
            ('PCS', 'Boneka', $1),
            ('PCS', 'Bedcover', $1),
            ('PCS', 'Selimut', $1)
            RETURNING id, name
        )
        INSERT INTO service_duration (price, duration, service) VALUES
        (6000, (SELECT id FROM inserted_durations WHERE name = 'Reguler'), (SELECT id FROM inserted_services WHERE name = 'Kiloan - Cuci, Setrika')),
        (8000, (SELECT id FROM inserted_durations WHERE name = 'Express'), (SELECT id FROM inserted_services WHERE name = 'Kiloan - Cuci, Setrika')),
        (12000, (SELECT id FROM inserted_durations WHERE name = 'Kilat'), (SELECT id FROM inserted_services WHERE name = 'Kiloan - Cuci, Setrika')),

        (4000, (SELECT id FROM inserted_durations WHERE name = 'Reguler'), (SELECT id FROM inserted_services WHERE name = 'Kiloan - Cuci')),
        (6000, (SELECT id FROM inserted_durations WHERE name = 'Express'), (SELECT id FROM inserted_services WHERE name = 'Kiloan - Cuci')),
        (8000, (SELECT id FROM inserted_durations WHERE name = 'Kilat'), (SELECT id FROM inserted_services WHERE name = 'Kiloan - Cuci')),

        (20000, (SELECT id FROM inserted_durations WHERE name = 'Reguler'), (SELECT id FROM inserted_services WHERE name = 'Jas')),
        (25000, (SELECT id FROM inserted_durations WHERE name = 'Express'), (SELECT id FROM inserted_services WHERE name = 'Jas')),
        (30000, (SELECT id FROM inserted_durations WHERE name = 'Kilat'), (SELECT id FROM inserted_services WHERE name = 'Jas')),

        (30000, (SELECT id FROM inserted_durations WHERE name = 'Reguler'), (SELECT id FROM inserted_services WHERE name = 'Boneka')),
        (20000, (SELECT id FROM inserted_durations WHERE name = 'Express'), (SELECT id FROM inserted_services WHERE name = 'Boneka')),
        (10000, (SELECT id FROM inserted_durations WHERE name = 'Kilat'), (SELECT id FROM inserted_services WHERE name = 'Boneka')),

        (5000, (SELECT id FROM inserted_durations WHERE name = 'Reguler'), (SELECT id FROM inserted_services WHERE name = 'Bedcover')),
        (10000, (SELECT id FROM inserted_durations WHERE name = 'Express'), (SELECT id FROM inserted_services WHERE name = 'Bedcover')),
        (15000, (SELECT id FROM inserted_durations WHERE name = 'Kilat'), (SELECT id FROM inserted_services WHERE name = 'Bedcover')),

        (5000, (SELECT id FROM inserted_durations WHERE name = 'Reguler'), (SELECT id FROM inserted_services WHERE name = 'Selimut')),
        (10000, (SELECT id FROM inserted_durations WHERE name = 'Express'), (SELECT id FROM inserted_services WHERE name = 'Selimut')),
        (15000, (SELECT id FROM inserted_durations WHERE name = 'Kilat'), (SELECT id FROM inserted_services WHERE name = 'Selimut'));
      `;
    const result = await client.query(query, [merchant_id]);

    // Check if any rows were returned
    return result.rows.length > 0;
  } finally {
    client.release();
  }
}
