import { PoolClient } from "pg";
import pool from "../../database/postgres";
import { User, UserDetail } from "../auth/types";
import supabase from "../../database/supabase";
import Mailjet from 'node-mailjet';
import { getInvoiceResponse, InvoiceDetails, setPlanInput, updateInvoiceInput, verifyInvoiceResponse } from "./types";
import { createSubscriptions, getSubsPlanByCode, getSubsPlanById } from "../auth/controller";
import jwt from 'jsonwebtoken';

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
      `SELECT 
        users.id,
        users.name,
        users.email,
        users.phone_number,
        users.logo,
        users.address,
        app_subscriptions.end_date AS subscription_end,
        app_plans.name AS plan_name
      FROM users 
      LEFT JOIN app_subscriptions ON app_subscriptions.user_id = users.id
      LEFT JOIN app_plans ON app_plans.id = app_subscriptions.plan_id
      WHERE users.id = $1`,
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
        users.id, 
        users.email,
        app_plans.code
      FROM users 
      LEFT JOIN app_subscriptions 
      ON app_subscriptions.user_id = users.id
      LEFT JOIN app_plans 
      ON app_subscriptions.plan_id = app_plans.id`
    );

    // Filter users with subscriptions ending in the next 5 days
    const soonExpiringSubscriptions = result.rows.filter((row) => {
      const endDate = new Date(row.end_date);
      const diffDays = Math.ceil((endDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
      return diffDays === 5;
    });

    const justExpiredSubscriptions = result.rows.filter((row) => {
      const endDate = new Date(row.end_date); // Parse the end date from the row
      const now = new Date(); // Current date

      // Set both dates to midnight for accurate day comparison
      endDate.setHours(0, 0, 0, 0);
      now.setHours(0, 0, 0, 0);

      // Calculate the difference in days
      const diffDays = Math.ceil((now.getTime() - endDate.getTime()) / (1000 * 60 * 60 * 24));

      // Check if the subscription expired exactly 1 day ago
      return diffDays === 1;
    });

    console.log(`Just expired subscriptions: ${justExpiredSubscriptions.length}`);
    console.log(soonExpiringSubscriptions);

    // Send email notifications for just expired subscriptions
    await Promise.all(
      justExpiredSubscriptions.map(async (user) => {
        try {
          console.log(`Sending email expired notification to: ${user.email}, end date: ${user.end_date}, plan: ${user.code}`);
          await sendEmailNotificationExpiredAccount(user.email, user.end_date, user.code);
        } catch (error) {
          console.error(`Error processing user ${user.id}:`, error);
        }
      })
    );

    console.log(`Subscriptions expiring soon: ${soonExpiringSubscriptions.length}`);
    console.log(soonExpiringSubscriptions);

    if (soonExpiringSubscriptions.length === 0) {
      console.log('No subscriptions expiring in the next 5 days.');
      return;
    }

    // Send email notifications for expiring subscriptions
    await Promise.all(
      soonExpiringSubscriptions.map(async (user) => {
        try {
          console.log(`Creating invoice for user: ${user.id}, plan: ${user.code}`);
          const token = jwt.sign(
            { email: user.email }, // Payload
            process.env.JWT_SECRET as string, // Secret key
            { expiresIn: '7d' } // Token expiration time (7 days in this example)
          );        
          await createInvoice({
            user_id: user.id,
            plan_code: user.code,
            token: token
          });
          console.log(`Sending email notification to: ${user.email}, end date: ${user.end_date}, plan: ${user.code}`);
          await sendEmailNotification(user.email, user.end_date, user.code, token);
        } catch (error) {
          console.error(`Error processing user ${user.id}:`, error);
        }
      })
    );



    console.log('Email notifications sent successfully for expiring subscriptions.');
  } catch (error) {
    console.error('Error checking user subscriptions:', error);
  } finally {
    client.release();
  }
}

/**
 * Handles invoice transfer uploads.
 * @param userId - The ID of the authenticated user.
 * @param note - The note provided by the user.
 * @param invoice_id - The invoice ID associated with the transaction.
 * @param filePath - The file path of the uploaded file.
 */
export const uploadTransactionFile = async (
  userId: string,
  note: string,
  invoice_id: string,
  filePath: string,
  fileUrl: string
) => {
  const client = await pool.connect();
  try {
    // Insert the transaction record
    const result = await client.query(
      `INSERT INTO app_transactions (user_id, file, note) VALUES ($1, $2, $3) RETURNING *`,
      [userId, filePath, note]
    );

    // Update the invoice status to 'Menunggu Konfirmasi'
    const updateInvoice = await client.query(
      `UPDATE app_invoices SET status = 'Menunggu Konfirmasi' WHERE invoice_id = $1 RETURNING *`,
      [invoice_id]
    );

    // If no rows were updated in the invoice, handle it
    if (updateInvoice.rowCount === 0) {
      throw new Error(`Invoice with ID ${invoice_id} not found.`);
    }

    const userDetailQuery = `
      SELECT 
        u.name, 
        u.email, 
        u.phone_number, 
        t.end_date
      FROM users u
      INNER JOIN app_subscriptions t ON u.id = t.user_id
      WHERE u.id = $1
    `;

    const queryResult = await client.query(userDetailQuery, [userId]);
    const userDetail = queryResult.rows[0];

    if (!userDetail) {
      throw new Error(`User with ID ${userId} not found.`);
    }

    await sendPayemntNotification(
      userDetail.email,
      userDetail.end_date,
      invoice_id,
      userDetail.name,
      userDetail.phone_number,
      fileUrl
    );

    return true; // Successfully processed
  } catch (error) {
    console.error("Error handling transaction file upload:", error);
    throw new Error("An error occurred while uploading the transaction file.");
  } finally {
    client.release();
  }
}

/**
 * Retrieve invoice details by user ID.
 * @param invoiceId - The ID of the user whose invoice details are to be retrieved.
 * @returns A promise resolving to invoice details or null if not found.
 */
export async function getInvoiceDetails(
  invoiceId?: string
): Promise<InvoiceDetails | null> {
  if (!invoiceId) {
    throw new Error("Invoice Id dibutuhkan");
  }

  const client = await pool.connect();

  try {
    const query = `
      SELECT 
        i.id,
        i.amount,
        i.status,
        i.due_date,
        i.created_at AS invoice_created_at,
        i.invoice_id,
        p.name AS plan_name,
        p.code AS plan_code,
        p.duration AS plan_duration,
        p.price AS plan_price
      FROM app_invoices i
      LEFT JOIN app_subscriptions s ON s.user_id = i.user_id AND s.plan_id = i.plan_id
      LEFT JOIN app_plans p ON p.id = s.plan_id
      WHERE i.invoice_id = $1
    `;
    const { rows } = await client.query(query, [invoiceId]);
    return rows[0] || null;
  } catch (error) {
    console.error("Error retrieving invoice details:", error);
    throw new Error("Failed to retrieve invoice details.");
  } finally {
    client.release();
  }
}

/**
 * Retrieve invoices history.
 * @returns A promise resolving to an array of invoice details or null if no data is found.
 */
export async function getInvoices(): Promise<InvoiceDetails[] | null> {
  const client = await pool.connect();

  try {
    const query = `
      SELECT 
        i.id,
        i.invoice_id,
        i.amount,
        i.status,
        i.due_date,
        i.created_at AS invoice_created_at,
        p.name AS plan_name,
        p.code AS plan_code,
        p.duration AS plan_duration,
        p.price AS plan_price
      FROM app_invoices i
      LEFT JOIN app_subscriptions s ON s.user_id = i.user_id AND s.plan_id = i.plan_id
      LEFT JOIN app_plans p ON p.id = s.plan_id
    `;

    const { rows } = await client.query(query);

    if (rows.length === 0) {
      return null;
    }

    return rows;
  } catch (error) {
    console.error("Error retrieving invoice details:", error);
    throw new Error("Failed to retrieve invoice details.");
  } finally {
    client.release();
  }
}

/**
 * Add a new Plan to the database.
 * @param planDetail - The plan details including user_id and plan_code.
 * @returns {Promise<boolean>} - A promise that resolves to true if the plan is set successfully, otherwise false.
 */
export async function setUserPlan(planDetail: Omit<setPlanInput, 'id'>): Promise<boolean> {
  const client = await pool.connect();
  try {
    const { user_id, plan_code } = planDetail;
    const subscriptionPlan = await getSubsPlanByCode(plan_code);

    if (!subscriptionPlan) {
      throw new Error("Paket Aplikasi Tidak ditemukan.");
    }

    // Check if the user already has this plan active
    const checkSubscriptionQuery = `
      SELECT 1
      FROM app_subscriptions 
      WHERE plan_id = $1 AND user_id = $2
      LIMIT 1
    `;
    const { rowCount } = await client.query(checkSubscriptionQuery, [subscriptionPlan.id, user_id]);

    if (rowCount && rowCount > 0) {
      throw new Error("Subscription sudah digunakan");
    }

    // Remove existing subscriptions for the user (if any)
    const deleteSubscriptionQuery = `
      DELETE FROM app_subscriptions WHERE user_id = $1
    `;
    await client.query(deleteSubscriptionQuery, [user_id]);

    // Insert new subscription
    const insertSubscriptionQuery = `
      INSERT INTO app_subscriptions (user_id, plan_id, start_date, end_date)
      VALUES ($1, $2, $3, $4)
    `;
    const startDate = new Date().toISOString();
    const endDate = new Date(Date.now()).toISOString();

    await client.query(insertSubscriptionQuery, [user_id, subscriptionPlan.id, startDate, endDate]);

    await createInvoice(planDetail)
    return true;
  } catch (error) {
    console.error("Error setting user plan:", error);
    return false;
  } finally {
    client.release();
  }
}

/**
 * Add a new Invoice to the database.
 * @param planDetail - The plan details including user_id and plan_code.
 * @returns {Promise<boolean>} - A promise that resolves to true if the plan is set successfully, otherwise false.
 */
export async function createInvoice(planDetail: Omit<setPlanInput, 'id'>): Promise<boolean> {
  const client = await pool.connect();
  try {
    const { user_id, plan_code, token } = planDetail;
    const subscriptionPlan = await getSubsPlanByCode(plan_code);

    if (!subscriptionPlan) {
      throw new Error("Paket Aplikasi Tidak ditemukan.");
    }

    // Check if the user already has this plan active
    const checkSubscriptionQuery = `
     SELECT 1
     FROM app_subscriptions 
     WHERE plan_id = $1 AND user_id = $2
     LIMIT 1
   `;
    const { rows } = await client.query(checkSubscriptionQuery, [subscriptionPlan.id, user_id]);

    // Generate the invoice ID with prefix CBG- and current timestamp in milliseconds
    const invoiceId = `CBG-${Date.now()}`;

    // Insert new invoice
    const insertSubscriptionQuery = `
      INSERT INTO app_invoices (user_id, plan_id, amount, status, due_date, invoice_id, token)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
    `;
    await client.query(insertSubscriptionQuery, [user_id, subscriptionPlan.id, subscriptionPlan.price, "Menunggu Pembayaran", rows[0]?.end_date, invoiceId, token]);

    return true;
  } catch (error) {
    console.error("Error setting user plan:", error);
    return false;
  } finally {
    client.release();
  }
}

/**
 * Add a new Invoice to the database.
 * @param planDetail - The plan details including user_id and plan_code.
 * @returns {Promise<boolean>} - A promise that resolves to true if the plan is set successfully, otherwise false.
 */
export async function updateInvoice(planDetail: Omit<updateInvoiceInput, 'id'>): Promise<boolean> {
  const client = await pool.connect();
  try {
    const { invoice_id, status } = planDetail;

    // Retrieve the invoice based on the provided invoice_id
    const getInvoiceQuery = `
      SELECT plan_id, user_id, users.email
      FROM app_invoices
      LEFT JOIN users ON users.id = app_invoices.user_id
      WHERE invoice_id = $1
      LIMIT 1
    `;
    const invoiceResult = await client.query(getInvoiceQuery, [invoice_id]);

    // If no invoice is found, handle the error
    if (invoiceResult.rowCount === 0) {
      throw new Error(`Invoice with ID ${invoice_id} not found.`);
    }

    const invoice = invoiceResult.rows[0];

    // Update the invoice status
    const updateInvoiceQuery = `
      UPDATE app_invoices SET status = $2 WHERE invoice_id = $1 RETURNING *
    `;
    const updateInvoiceResult = await client.query(updateInvoiceQuery, [invoice_id, status]);

    // If no rows were updated in the invoice, handle it
    if (updateInvoiceResult.rowCount === 0) {
      throw new Error(`Invoice with ID ${invoice_id} not found.`);
    }

    // Process further actions based on the status
    switch (status) {
      case "Diterima":
        const subscriptionPlan = await getSubsPlanById(invoice.plan_id);

        if (!subscriptionPlan) {
          throw new Error("Paket Aplikasi Tidak ditemukan.");
        }

        // Get new plan details
        const getMainPlan = `
          SELECT id
          FROM app_plans
          WHERE code = 'berlangganan'
          LIMIT 1
        `;
        const newMainPlanResult = await client.query(getMainPlan);
        const newMainPlan = newMainPlanResult.rows[0];

        // Check if the user already has this plan active
        const checkSubscriptionQuery = `
          SELECT * 
          FROM app_subscriptions 
          WHERE plan_id = $1 AND user_id = $2
          LIMIT 1
        `;
        const subscriptionResult = await client.query(checkSubscriptionQuery, [subscriptionPlan.id, invoice.user_id]);

        if (subscriptionResult.rowCount === 0) {
          throw new Error("User does not have an active subscription for this plan.");
        }

        const subscription = subscriptionResult.rows[0];

        // Update the subscription end date
        const newEndDate = new Date(subscription.end_date);
        newEndDate.setMonth(newEndDate.getMonth() + 1);

        const updateSubscriptionQuery = `
          UPDATE app_subscriptions 
          SET end_date = $3, plan_id = $4
          WHERE plan_id = $1 AND user_id = $2 
          RETURNING *
        `;
        await client.query(updateSubscriptionQuery, [invoice.plan_id, invoice.user_id, newEndDate, newMainPlan.id]);

        // Send email notification for accepted status
        await sendInvoiceApproved(invoice.email, newEndDate.toISOString());
        break;

      case "Ditolak":
        // Send email notification for canceled status
        await sendInvoiceCancelled(invoice.email);
        break;

      default:
        // Handle other statuses if needed
        break;
    }

    return true;
  } catch (error) {
    console.error("Error updating invoice:", error);
    return false;
  } finally {
    client.release();
  }
}

/**
 * Add a new Invoice to the database.
 * @param planDetail - The plan details including user_id and plan_code.
 * @returns {Promise<boolean>} - A promise that resolves to true if the plan is set successfully, otherwise false.
 */
export async function verifyInvoiceValid(token: string): Promise<verifyInvoiceResponse | null> {
  const client = await pool.connect();
  try {
    // Verify the JWT token
    const decoded = await verifyJwt(token);
    const userDetail = `
      SELECT name, users.id as user_id, app_invoices.status, app_invoices.invoice_id
      FROM users 
      LEFT JOIN app_invoices ON users.id = app_invoices.user_id
      WHERE email = $1
    `;
    const result = await client.query(userDetail, [decoded.email]);

    if (!decoded) {
      throw new Error('Token is invalid or expired.');
    }

    return { ...result.rows[0], valid: true };
  } catch (error) {
    console.error('Error verifying invoice:', error);
    return null;
  }
}

/**
 * Get Invoice By User Id
 * @param userId.
 * @returns {Promise<string>} - A promise that resolves to InvoiceResponseObject if the plan is set successfully, otherwise null.
 */
export async function getInvoiceByUserId(userId: string): Promise<getInvoiceResponse | null> {
  const client = await pool.connect();
  try {
    const query = `
      SELECT invoice_id, token
      FROM app_invoices 
      WHERE user_id = $1
      ORDER BY created_at DESC 
      LIMIT 1
    `;
    const result = await client.query(query, [userId]);

    return { invoice: result?.rows[0]?.invoice_id, token: result?.rows[0]?.token}
  } catch (error) {
    console.error('Error verifying invoice:', error);
    return null;
  }
}

/**
 * Verifies the JWT token and checks if it's expired.
 * @param token - The JWT token.
 * @returns {Promise<any | null>} - The decoded token if valid, otherwise null.
 */
async function verifyJwt(token: string): Promise<any | null> {
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET as string);
    return decoded;
  } catch (error) {
    console.error('JWT verification failed:', error);
    return null;
  }
}

/**
 * Send an email notification when the subscription is accepted.
 * @param email - The user's email address.
 * @param endDate - The new end date of the subscription.
 */
const sendInvoiceApproved = async (email: string, endDate: string): Promise<void> => {
  const mailjet = Mailjet.apiConnect(
    process.env.MAILJET_API_KEY as string,
    process.env.MAILJET_API_SECRET as string,
    { options: { timeout: 20000 } }
  );

  const options: Intl.DateTimeFormatOptions = { year: "numeric", month: "long", day: "numeric" };
  const formattedEndDate = new Intl.DateTimeFormat("id-ID", options).format(new Date(endDate));

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
        Subject: 'Detail Masa Aktif Langganan Anda',
        HTMLPart: `
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
                          <h1 style="color: #333333;">Detail Langganan Anda</h1>
                          <p style="font-size: 16px; color: #555555;">
                            Email: <strong>${email}</strong>
                          </p>
                          <p style="font-size: 16px; color: #555555;">
                            Masa Aktif Hingga: <strong>${formattedEndDate}</strong>
                          </p>
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
 * Send a cancellation email when the subscription is canceled.
 * @param email - The user's email address.
 */
const sendInvoiceCancelled = async (email: string): Promise<void> => {
  const mailjet = Mailjet.apiConnect(
    process.env.MAILJET_API_KEY as string,
    process.env.MAILJET_API_SECRET as string,
    { options: { timeout: 20000 } }
  );

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
        Subject: 'Langganan Anda Dibatalkan',
        HTMLPart: `
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
                          <h1 style="color: #333333;">Langganan Anda Dibatalkan</h1>
                          <p style="font-size: 16px; color: #555555;">
                            Kami menyesal memberitahukan Anda bahwa langganan Anda telah dibatalkan.
                          </p>
                          <p style="font-size: 16px; color: #555555;">
                            Jika Anda memiliki pertanyaan lebih lanjut, silakan hubungi admin kami melalui:
                          </p>
                          <p style="font-size: 16px; color: #555555;">
                            Nomor WhatsApp: <strong>085283811719</strong><br />
                            Email: <strong>support@cucibayargo.com</strong>
                          </p>
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
    console.error(`Failed to send cancellation email to ${email}:`, error);
  }
};


/**
 * Kirim notifikasi email ketika langganan diterima.
 * @param email - Alamat email pengguna.
 * @param endDate - Tanggal akhir masa aktif langganan.
 * @param invoiceId - ID Faktur.
 * @param userName - Nama pengguna.
 * @param userPhone - Nomor HP pengguna.
 * @param fileLink - Link file yang akan dilampirkan.
 */
const sendPayemntNotification = async (
  email: string,
  endDate: string,
  invoiceId: string,
  userName: string,
  userPhone: string,
  fileLink: string
): Promise<void> => {
  const mailjet = Mailjet.apiConnect(
    process.env.MAILJET_API_KEY as string,
    process.env.MAILJET_API_SECRET as string,
    { options: { timeout: 20000 } }
  );

  const options: Intl.DateTimeFormatOptions = { year: "numeric", month: "long", day: "numeric" };
  const formattedEndDate = new Intl.DateTimeFormat("id-ID", options).format(new Date(endDate));

  const emailData = {
    Messages: [
      {
        From: {
          Email: 'no-reply@cucibayargo.com',
          Name: 'Cucibayargo',
        },
        To: [
          {
            Email: 'support@cucibayargo.com',
          },
          {
            Email: 'laundryapps225@gmail.com',
          }
        ],
        Subject: 'Pembayaran Pengguna Baru: Mohon Verifikasi Segera',
        HTMLPart: `
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
                          <h1 style="color: #333333;">Detail Langganan Pengguna</h1>
                          <p style="font-size: 16px; color: #555555;">
                            <strong>ID Faktur:</strong> ${invoiceId}<br />
                            <strong>Nama:</strong> ${userName}<br />
                            <strong>Nomor HP:</strong> ${userPhone}<br />
                            <strong>Masa Aktif Hingga:</strong> ${formattedEndDate}
                          </p>
                          <p style="font-size: 16px; color: #555555;">
                            <a href="${fileLink}" style="color: #007bff; text-decoration: none;">Unduh File</a>
                          </p>
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
          </html>`
      },
    ],
  };

  try {
    const response = await mailjet.post('send', { version: 'v3.1' }).request(emailData);
    console.log(`Email berhasil dikirim ke support@cucibayargo.com dengan respon:`, response.body);
  } catch (error) {
    console.error(`Gagal mengirim email ke support@cucibayargo.com:`, error);
  }
};

const sendEmailNotification = async (
  email: string,
  endDate: string,
  planCode: string,
  token: string
): Promise<void> => {
  const mailjet = Mailjet.apiConnect(
    process.env.MAILJET_API_KEY as string,
    process.env.MAILJET_API_SECRET as string,
    { options: { timeout: 20000 } }
  );

  const options: Intl.DateTimeFormatOptions = { year: "numeric", month: "long", day: "numeric" };
  const formattedEndDate = new Intl.DateTimeFormat("id-ID", options).format(new Date(endDate));
  
  const verificationUrl = `https://store.cucibayargo.com/verify?token=${encodeURIComponent(token)}`;
  const isGratis = planCode === 'gratis';
  const emailSubject = isGratis
    ? 'Akun Gratis Anda Akan Ditutup'
    : 'Langganan Anda Akan Segera Berakhir!';
  const emailBody = isGratis
    ? `
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
                      <h1 style="color: #333333;">Akun Gratis Anda Akan Ditutup</h1>
                      <p style="font-size: 16px; color: #555555;">
                        Akun gratis Anda akan ditutup pada <strong>${formattedEndDate}</strong>. Untuk terus menggunakan layanan kami, silakan beralih ke paket berlangganan sebelum tanggal tersebut.
                      </p>
                      <a href="${verificationUrl}" style="background-color: #007bff; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-size: 16px; display: inline-block; margin-top: 20px;">Pilih Paket Berlangganan</a>
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
      </html>`
    : `
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
                      <h1 style="color: #333333;">Langganan Anda Akan Segera Berakhir</h1>
                      <p style="font-size: 16px; color: #555555;">
                        Langganan Anda akan berakhir pada <strong>${formattedEndDate}</strong>. Jangan lupa untuk memperpanjang langganan Anda sebelum tanggal tersebut agar tetap dapat menikmati layanan kami.
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
      </html>`;

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
        Subject: emailSubject,
        HTMLPart: emailBody,
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

const sendEmailNotificationExpiredAccount = async (
  email: string,
  endDate: string,
  planCode: string
): Promise<void> => {
  const mailjet = Mailjet.apiConnect(
    process.env.MAILJET_API_KEY as string,
    process.env.MAILJET_API_SECRET as string,
    { options: { timeout: 20000 } }
  );

  const options: Intl.DateTimeFormatOptions = { year: "numeric", month: "long", day: "numeric" };
  const formattedEndDate = new Intl.DateTimeFormat("id-ID", options).format(new Date(endDate));

  const waTemplate = encodeURIComponent(
    `Halo admin, saya dengan email ${email} ingin melakukan aktivasi akun. Mohon bantuannya.`
  );
  const whatsappUrl = `https://wa.me/6285283811719?text=${waTemplate}`;
  const isGratis = planCode === 'gratis';
  const emailSubject = isGratis
    ? 'Akun Gratis Anda Sudah Berakhir'
    : 'Langganan Anda Telah Berakhir!';
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
                      <h1 style="color: #333333;">${emailSubject}</h1>
                      <p style="font-size: 16px; color: #555555;">
                        Langganan Anda telah berakhir pada <strong>${formattedEndDate}</strong>. Silakan hubungi admin untuk melanjutkan aktivasi langganan Anda dengan mudah.
                      </p>
                      <a href="${whatsappUrl}" style="background-color: #25D366; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-size: 16px; display: inline-block; margin-top: 20px;">Chat Admin via WhatsApp</a>
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
          Email: 'no-reply@cucibayargo.com',
          Name: 'Cucibayargo',
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
    const response = await mailjet.post('send', { version: 'v3.1' }).request(emailData);
    console.log(`Email sent to ${email} with response:`, response.body);
  } catch (error) {
    console.error(`Failed to send email to ${email}:`, error);
  }
};

export async function TriggerSupabaseCloud(): Promise<boolean> {
  const client = await pool.connect();
  try {
    return true
  } catch (error) {
    console.error('Error connect into supabase cloud:', error);
    return false;
  }
}