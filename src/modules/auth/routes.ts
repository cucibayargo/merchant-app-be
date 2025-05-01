import express from "express";
import {
  ChangePasswordSchema,
  CustomJwtPayload,
  LoginSchema,
  SignUpSchema,
  SignUpTokenSchema,
} from "./types";
import {
  addUser,
  addUserSignUpToken,
  changeUserPassword,
  createSubscriptions,
  getSubsPlanByCode,
  getUserByEmail,
  initServiceAndDuration,
  notifyUserToPaySubscription,
  updateUserSignupStatus,
  validateToken,
  verifySignupToken,
} from "./controller";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { createInvoice, getUserDetails, updateUserDetails } from "../user/controller";
import * as dotenv from "dotenv";
import crypto from "crypto";
import disposableDomains from "disposable-email-domains";
import Mailjet from "node-mailjet";
import { valid } from "joi";

const router = express.Router();
dotenv.config();

function isDisposableEmail(email: string): boolean {
  const domain = email.split("@")[1];
  return disposableDomains.includes(domain);
}

const sendEmailRegistration = async (
  registrationEmail: string,
  verificationToken: string
) => {
  const verificationUrl = `https://${process.env.API_URL}/${
    process.env.NODE_ENV === "production" ? "v1" : "api"
  }/auth/verify-email?token=${verificationToken}`;

  // Initialize the Mailjet client with your API keys
  const mailjet = Mailjet.apiConnect(
    process.env.MAILJET_API_KEY as string,
    process.env.MAILJET_API_SECRET as string,
    { options: { timeout: 20000 } }
  );

  const emailData = {
    Messages: [
      {
        From: {
          Email: "no-reply@cucibayargo.com",
          Name: "Cucibayargo",
        },
        To: [
          {
            Email: registrationEmail,
          },
        ],
        Subject: "Verifikasi Alamat Email Anda",
        TextPart: `Silakan verifikasi alamat email Anda dengan mengklik tautan berikut: ${verificationUrl}`,
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
                          <h1 style="color: #333333;">Verifikasi Alamat Email Anda</h1>
                          <p style="font-size: 16px; color: #555555;">Silakan verifikasi alamat email Anda dengan mengklik tautan di bawah ini.</p>
                          <a href="${verificationUrl}" style="background-color: #007bff; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-size: 16px; display: inline-block; margin-top: 20px;">Verifikasi Email</a>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding: 20px; text-align: center; color: #999999; font-size: 12px;">
                          Jika Anda tidak mendaftarkan email ini, abaikan email ini.
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
    const response = await mailjet
      .post("send", { version: "v3.1" })
      .request(emailData);
    console.log("Verification email sent successfully:", response.body);
  } catch (error) {
    console.error("Error sending verification email:", error);
  }
};

const sendSignUpLink = async (
  registrationEmail: string,
  params:
    | string
    | string[][]
    | Record<string, string>
    | URLSearchParams
    | undefined
) => {
  const queryParams = new URLSearchParams(params).toString();
  const verificationUrl = `https://${process.env.APP_URL}/register?${queryParams}`;

  const mailjet = Mailjet.apiConnect(
    process.env.MAILJET_API_KEY as string,
    process.env.MAILJET_API_SECRET as string,
    { options: { timeout: 20000 } }
  );

  const emailData = {
    Messages: [
      {
        From: {
          Email: "no-reply@cucibayargo.com",
          Name: "Cucibayargo",
        },
        To: [
          {
            Email: registrationEmail,
          },
        ],
        Subject: "Link Pendaftaran Cucibayargo",
        TextPart: `Silakan klik link untuk melakukan pendaftaran: ${verificationUrl}`,
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
                          <h1 style="color: #333333;">Selamat Datang di Cucibayargo!</h1>
                          <p style="font-size: 16px; color: #555555;">Terima kasih telah mendaftar. Silakan klik tombol di bawah ini untuk melanjutkan pendaftaran Anda.</p>
                          <a href="${verificationUrl}" style="background-color: #007bff; color: #ffffff; padding: 12px 24px; text-decoration: none; border-radius: 5px; font-size: 16px; display: inline-block; margin-top: 20px;">Daftar Sekarang</a>
                        </td>
                      </tr>
                      <tr>
                        <td style="padding: 20px; text-align: center; color: #999999; font-size: 12px;">
                          Jika Anda tidak mendaftar di Cucibayargo, abaikan email ini.
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
    const response = await mailjet
      .post("send", { version: "v3.1" })
      .request(emailData);
    console.log("Verification email sent successfully:", response.body);
  } catch (error) {
    console.error("Error sending verification email:", error);
  }
};

const sendAdminNotification = async (registrationEmail: string) => {
  const mailjet = Mailjet.apiConnect(
    process.env.MAILJET_API_KEY as string,
    process.env.MAILJET_API_SECRET as string,
    { options: { timeout: 20000 } }
  );

  const emailData = {
    Messages: [
      {
        From: {
          Email: "no-reply@cucibayargo.com",
          Name: "Cucibayargo System",
        },
        To: [
          {
            Email: "laundryapps225@gmail.com",
          },
        ],
        Subject: "Notifikasi Pendaftaran Baru",
        TextPart: `Pengguna baru telah mendaftar dengan email: ${registrationEmail}`,
        HTMLPart: `
          <html>
            <body style="font-family: Arial, sans-serif;">
              <p>Halo Admin,</p>
              <p>Pengguna baru telah mendaftar di Cucibayargo.</p>
              <p><strong>Email:</strong> ${registrationEmail}</p>
              <p><strong>Waktu:</strong> ${new Date().toLocaleString("id-ID", { timeZone: "Asia/Jakarta" })}</p>
            </body>
          </html>
        `,
      },
    ],
  };

  try {
    const response = await mailjet
      .post("send", { version: "v3.1" })
      .request(emailData);
    console.log("Admin notification email sent successfully:", response.body);
  } catch (error) {
    console.error("Error sending admin notification email:", error);
  }
};

/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: Authentication APIs
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     User:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           description: User's unique identifier
 *         name:
 *           type: string
 *           description: User's name
 *         email:
 *           type: string
 *           description: User's email address
 *         oauth:
 *           type: boolean
 *           description: Whether the user is authenticated via OAuth
 *         token:
 *           type: string
 *           description: Authentication token for the user
 *         phone_number:
 *           type: string
 *           description: User's phone number
 *         logo:
 *           type: string
 *           description: URL to the user's logo or profile picture
 *         address:
 *           type: string
 *           description: User's address
 *         created_at:
 *           type: string
 *           format: date-time
 *           description: Timestamp of when the user was created
 *         updated_at:
 *           type: string
 *           format: date-time
 *           description: Timestamp of when the user was last updated
 */

/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: Logs in a user
 *     description: Logs in a user with credentials
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 description: User's email address
 *               password:
 *                 type: string
 *                 description: User's password
 *             required:
 *               - email
 *               - password
 *     responses:
 *       '200':
 *         description: Successful login
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Login berhasil."
 *       '401':
 *         description: Unauthorized, invalid credentials
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Email tidak ditemukan"
 */
router.post("/login", async (req, res) => {
  const { error } = LoginSchema.validate(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

  const { email, password } = req.body;

  try {
    const user = await getUserByEmail(email);
    if (!user) {
      return res.status(400).json({ message: "Email tidak ditemukan" });
    }

    // Validate Expires user subscription
    const subscriptionEnd = new Date(user.subscription_end || "");
    if (isNaN(subscriptionEnd.getTime())) {
      return res.status(400).json({
        message:
          "Tanggal berakhir langganan tidak valid. Harap hubungi administrator.",
      });
    }

    if (subscriptionEnd.getTime() <= Date.now()) {
      return res.status(400).json({
        message:
          "Langganan Anda telah berakhir. Harap bayar tagihan atau hubungi administrator.",
      });
    }

    if (user.status === "pending") {
      return res
        .status(400)
        .json({ message: "Tolong lakukan verifikasi email terlebih dahulu" });
    }

    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(400).json({ message: "Password salah." });
    }

    const token = jwt.sign(
      { id: user.id, subscription_end: user.subscription_end },
      "secret_key",
      { expiresIn: "7d" }
    );

    // res.clearCookie("auth_token", {
    //   // domain: ".cucibayargo.com",
    //   path: "/",
    //   httpOnly: true,
    //   secure: true,
    //   sameSite: "strict",
    // });

    res.cookie("auth_token", token, {
      httpOnly: true,
      secure: true,
      sameSite: "none",
      maxAge: 7 * 24 * 60 * 60 * 1000, // 2 days
    });

    res.status(200).json({ message: "Login berhasil." });
  } catch (err: any) {
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

/**
 * @swagger
 * /auth/logout:
 *   post:
 *     summary: Logs out a user
 *     description: Logs out a user and invalidates their session or token
 *     tags: [Auth]
 *     responses:
 *       '200':
 *         description: Successful logout
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Logout berhasil."
 *       '500':
 *         description: Server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Terjadi kesalahan pada server."
 */
router.post("/logout", async (req, res) => {
  try {
    // Clear the authentication cookie
    res.cookie("auth_token", "", {
      httpOnly: true,
      secure: true,
      sameSite: "none",
      expires: new Date(0),
    });
    res.status(200).json({ message: "Logout berhasil." });
  } catch (err: any) {
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

/**
 * @swagger
 * /auth/signup:
 *   post:
 *     summary: Signs up a new user
 *     description: Creates a new user account
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 description: User's email address
 *               phone_number:
 *                 type: string
 *                 description: User's phone number
 *               name:
 *                 type: string
 *                 description: User's name
 *               token:
 *                 type: string
 *                 description: Unique Signup Token
 *               password:
 *                 type: string
 *                 description: User's password
 *             required:
 *               - email
 *               - phone_number
 *               - name
 *               - password
 *     responses:
 *       '201':
 *         description: User successfully created
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Signup berhasil."
 *       '400':
 *         description: Bad request, invalid input
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Email sudah digunakan."
 */
router.post("/signup", async (req, res) => {
  const { error } = SignUpSchema.validate(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

  const { name, email, password, phone_number, token, subscription_plan } =
    req.body;

  try {
    if (isDisposableEmail(email)) {
      return res.status(400).json({
        message: "Email tidak sesuai. Tolong gunakan alamat email yang valid.",
      });
    }

    const existingUser = await getUserByEmail(email);
    if (existingUser) {
      return res.status(400).json({ message: "Email sudah digunakan." });
    }

    const isValidToken = await validateToken(email, token);
    if (!isValidToken) {
      return res.status(400).json({ message: "Invalid or expired token." });
    }

    const subscriptionPlan = await getSubsPlanByCode(subscription_plan);
    if (!subscriptionPlan) {
      return res
        .status(400)
        .json({ message: "Paket Aplikasi Tidak ditemukan." });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await addUser({
      name,
      email,
      password: hashedPassword,
      phone_number,
      status: "verified",
    });

    await updateUserSignupStatus(email, token, newUser.id);

    if (subscriptionPlan.code !== "gratis") {
      await createSubscriptions({
        user_id: newUser.id,
        plan_id: subscriptionPlan.id,
        price: subscriptionPlan.price,
        start_date: new Date().toISOString(),
        end_date: new Date(Date.now()).toISOString(),
      });

      const invoiceId = await createInvoice({
        user_id: newUser.id,
        plan_code: subscriptionPlan.code,
        token: token
      });
      notifyUserToPaySubscription(email, invoiceId);
    } else {
      await createSubscriptions({
        user_id: newUser.id,
        plan_id: subscriptionPlan.id,
        start_date: new Date().toISOString(),
        price: subscriptionPlan.price,
        end_date: new Date(
          Date.now() + subscriptionPlan.duration * 24 * 60 * 60 * 1000
        ).toISOString(),
      });
    }

    // Create Default Service and Duration
    await initServiceAndDuration(newUser.id);

    // Generate verification token
    // const verificationToken = jwt.sign({ id: newUser.id }, "verification_secret_key", {
    //   expiresIn: "1d",
    // });

    // Send verification email
    // await sendEmailRegistration(email, verificationToken);

    res.status(201).json({
      message: "Daftar akun berhasil, silakan login untuk melanjutkan.",
    });
  } catch (err: any) {
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

router.get("/verify-token", async (req, res) => { 
  const token = req.query.token;
  if (!token) {
    return res.status(400).json({ message: "Token tidak ditemukan." });
  }

  const isValid = await verifySignupToken(token as string);
  res.status(200).json({
    valid: isValid,
    message: isValid
      ? "Token masih valid dan bisa digunakan."
      : "Token tidak valid atau sudah digunakan.",
  });  
})

/**
 * @swagger
 * /auth/signup/token:
 *   post:
 *     summary: Generate a signup link and send to the user's email
 *     description: Validates the user's input and checks if the email is already in use. If valid, creates a signup link and sends it to the user's email.
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - email
 *               - phone_number
 *             properties:
 *               name:
 *                 type: string
 *                 description: The user's full name
 *                 example: John Doe
 *               subscription_plan:
 *                 type: string
 *                 description: The subscription plan code picking by user
 *                 example: paket1
 *               email:
 *                 type: string
 *                 description: The user's email address
 *                 example: johndoe@example.com
 *               phone_number:
 *                 type: string
 *                 description: The user's phone number
 *                 example: +1234567890
 *     responses:
 *       201:
 *         description: Signup link has been created and sent to the user's email
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Link pendaftaran telah dibuat. Silahkan cek email anda untuk melanjutkan.
 *       400:
 *         description: Invalid input or email already in use
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Email sudah digunakan.
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Terjadi kesalahan pada server.
 */
router.post("/signup/token", async (req, res) => {
  const { error } = SignUpTokenSchema.validate(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

  const { name, email, phone_number, subscription_plan } = req.body;
  try {
    if (isDisposableEmail(email)) {
      return res.status(400).json({
        message: "Email tidak sesuai. Tolong gunakan alamat email yang valid.",
      });
    }

    const existingUser = await getUserByEmail(email);
    if (existingUser) {
      return res.status(400).json({ message: "Email sudah digunakan." });
    }

    let subscriptionPlan = null;
    if (subscription_plan) {
      subscriptionPlan = await getSubsPlanByCode(subscription_plan);
      if (!subscriptionPlan) {
        return res
          .status(400)
          .json({ message: "Paket Aplikasi Tidak ditemukan." });
      }
    }

    // Generate a unique token using SHA256 hash
    const signupToken = crypto
      .createHash("sha256")
      .update(email + Date.now().toString())
      .digest("hex");

    const userDetail = {
      name,
      email,
      phone_number,
      token: signupToken,
      subscription_plan: subscriptionPlan ? subscriptionPlan.id : undefined,
    };

    // Save the signup token and user details in the database
    await addUserSignUpToken(userDetail);

    // Send the signup email with the generated token
    await sendSignUpLink(email, {
      token: signupToken,
      email,
      phone_number,
      name,
      subscription_plan: subscriptionPlan ? subscriptionPlan.code : "",
    });

    if (process.env.NODE_ENV === "production") {
      await sendEmailRegistration(email, signupToken);
    }

    res.status(201).json({
      message:
        "Link pendaftaran telah dibuat. Silahkan cek email anda untuk melanjutkan.",
    });
  } catch (err: any) {
    console.log(err);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

/**
 * @swagger
 * /auth/change-password:
 *   post:
 *     summary: Changes the user's password
 *     description: Allows a user to change their password
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 description: User's email address
 *               currentPassword:
 *                 type: string
 *                 description: User's current password
 *               newPassword:
 *                 type: string
 *                 description: User's new password
 *             required:
 *               - email
 *               - currentPassword
 *               - newPassword
 *     responses:
 *       '200':
 *         description: Password successfully changed
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Password updated successfully."
 *       '400':
 *         description: Bad request, invalid input
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Current password is incorrect."
 *       '401':
 *         description: Unauthorized, invalid credentials
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Current password is incorrect."
 */
router.post("/change-password", async (req, res) => {
  const { error } = ChangePasswordSchema.validate(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

  const { email, currentPassword, newPassword } = req.body;

  try {
    await changeUserPassword(email, currentPassword, newPassword);
    res.status(200).json({ message: "Password berhasil diperbarui." });
  } catch (err: any) {
    res.status(400).json({ message: err.message });
  }
});

/**
 * @swagger
 * /auth/google:
 *   get:
 *     summary: Initiates Google OAuth authentication
 *     description: Redirects to Google for authentication
 *     tags: [Auth]
 *     responses:
 *       '302':
 *         description: Redirects to Google for authentication
 */
// router.get("/google", passport.authenticate("google", { scope: ["profile", "email"] }));

/**
 * @swagger
 * /auth/google/callback:
 *   get:
 *     summary: Handles Google OAuth callback
 *     description: Handles the callback from Google after authentication
 *     tags: [Auth]
 *     responses:
 *       '302':
 *         description: Redirects to the frontend application with an authentication token
 *       '500':
 *         description: Terjadi kesalahan server
 */
// router.get("/google/callback", passport.authenticate("google", { session: false }), (req, res) => {
//   if (req.user) {
//     const user = req.user as any;
//     const token = jwt.sign({ id: user.id }, "secret_key", {
//       expiresIn: "2d",
//     });
//     res.cookie("auth_token", token, { httpOnly: true, sameSite: 'none', secure: true});
//     res.redirect("https://store.cucibayargo.com/login-google");
//   } else {
//     res.status(500).json({ message: "Authentication failed" });
//   }
// });

/**
 * @swagger
 * /auth/verify-email:
 *   get:
 *     summary: Verify user email
 *     tags: [Auth]
 *     description: Validates the email verification token and updates the user's status to 'verified'.
 *     parameters:
 *       - in: query
 *         name: token
 *         required: true
 *         schema:
 *           type: string
 *         description: The email verification token
 *     responses:
 *       200:
 *         description: Email verified successfully.
 *       400:
 *         description: Invalid or expired verification link.
 *       500:
 *         description: Terjadi kesalahan server.
 */
router.get("/verify-email", async (req, res) => {
  const { token } = req.query;

  // Check if token is a string
  if (typeof token !== "string") {
    return res.status(400).json({ message: "Token verifikasi tidak sesuai." });
  }

  try {
    const jwtSecret = "verification_secret_key"; // Use the same secret as in the signup endpoint
    const decoded = jwt.verify(token, jwtSecret) as CustomJwtPayload;
    if (!decoded.id) {
      return res.status(400).json({ message: "Salah Link Verifikasi." });
    }

    const userId = decoded.id;

    const user = await getUserDetails(userId);
    if (!user || user.status === "verified") {
      return res.status(400).json({
        message: "Salah Link Verifikasi atau email sudah terverifikasi.",
      });
    }

    // Update user status to 'verified'
    await updateUserDetails(userId, { status: "verified" });

    res.redirect(`https://${process.env.APP_URL}/`);
  } catch (err: any) {
    res.status(400).json({ message: "Link verifikasi sudah kedaluarsa." });
  }
});

export default router;
