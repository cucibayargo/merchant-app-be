import express, { Request, Response } from "express";
import multer from "multer";
import {
  checkUserSubscriptions,
  deleteTempFiles,
  getInvoiceByUserId,
  getInvoiceDetails,
  getInvoices,
  getUserDetails,
  setUserPlan,
  updateInvoice,
  updateUserDetails,
  uploadTransactionFile,
  verifyInvoiceValid,
} from "./controller"; // Assuming you have this function
import supabase from "../../database/supabase";
import { AuthenticatedRequest } from "../../middlewares";

const router = express.Router();

// Multer configuration
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 }, // Limit file size to 5MB
});

/**
 * @swagger
 * tags:
 *   name: User
 *   description: User management APIs
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     User:
 *       type: object
 *       required:
 *         - name
 *         - email
 *       properties:
 *         name:
 *           type: string
 *           description: Name of the user
 *           example: "John Doe"
 *         email:
 *           type: string
 *           description: Email address of the user
 *           example: "john.doe@example.com"
 *         phone_number:
 *           type: string
 *           nullable: true
 *           description: Phone number of the user (nullable)
 *           example: "+12345678901"
 *         address:
 *           type: string
 *           nullable: true
 *           description: Address of the user (nullable)
 *           example: "123 Main St, Springfield"
 *         logo:
 *           type: string
 *           nullable: true
 *           description: URL of the user's logo (nullable)
 *           example: "https://example.com/logo.png"
 *     UserRequestBody:
 *       type: object
 *       required:
 *         - name
 *         - email
 *       properties:
 *         name:
 *           type: string
 *           description: Name of the user
 *           example: "John Doe"
 *         email:
 *           type: string
 *           description: Email address of the user
 *           example: "john.doe@example.com"
 *         phone_number:
 *           type: string
 *           nullable: true
 *           description: Phone number of the user (nullable)
 *           example: "+12345678901"
 *         address:
 *           type: string
 *           nullable: true
 *           description: Address of the user (nullable)
 *           example: "123 Main St, Springfield"
 *     Invoice:
 *       type: object
 *       required:
 *         - invoice_id
 *         - user_id
 *         - status
 *         - plan_id
 *       properties:
 *         invoice_id:
 *           type: string
 *           description: ID faktur yang akan diperbarui
 *           example: "INV123456"
 *         user_id:
 *           type: string
 *           description: ID pengguna yang terkait dengan faktur
 *           example: "USR7890"
 *         status:
 *           type: string
 *           description: Status dari faktur
 *           example: "Dibayar"
 *         plan_id:
 *           type: string
 *           description: ID rencana langganan yang terkait dengan faktur
 *           example: "PLAN001"
 *         created_at:
 *           type: string
 *           format: date-time
 *           description: Tanggal dan waktu faktur dibuat
 *           example: "2024-08-10T10:15:30Z"
 *         updated_at:
 *           type: string
 *           format: date-time
 *           description: Tanggal dan waktu faktur terakhir diperbarui
 *           example: "2024-08-12T12:30:45Z"
 */

/**
 * @swagger
 * /user/upload-logo:
 *   post:
 *     summary: Uploads a temporary logo file
 *     description: Uploads a logo file to Supabase Storage and returns the file path.
 *     tags: [User]
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               file:
 *                 type: string
 *                 format: binary
 *                 description: The logo file to upload
 *     responses:
 *       '200':
 *         description: File uploaded successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 filePath:
 *                   type: string
 *                   description: The path of the uploaded file in Supabase Storage
 *       '400':
 *         description: Tidak ada file yang diunggah
 *       '500':
 *         description: Gagal mengunggah file
 */
router.post("/upload-logo", upload.single("file"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "Tidak ada file yang diunggah" });
    }

    const file = req.file;
    const { originalname, buffer } = file;
    const fileName = `${Date.now()}_${originalname}`;

    // Upload to Supabase
    const { error } = await supabase.storage
      .from("logos")
      .upload(`temp/${fileName}`, buffer, {
        contentType: file.mimetype,
      });

    if (error) {
      return res
        .status(500)
        .json({ message: "Gagal mengunggah file" });
    }

    // Respond with file details
    res.status(200).json({ filePath: `temp/${fileName}` });
  } catch (message: any) {
    res
      .status(500)
      .json({ message: "Terjadi kesalahan server." });
  }
});

/**
 * @swagger
 * /user/details:
 *   get:
 *     summary: Retrieve user details
 *     description: Fetches the details of a user by their ID.
 *     tags: [User]
 *     responses:
 *       '200':
 *         description: User details retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/User'
 *       '404':
 *         description: User tidak ditemukan
 */
router.get("/details", async (req: AuthenticatedRequest, res: Response) => {
  const userId = req.userId;

  try {
    const user = await getUserDetails(userId);
    if (user) {
      const now = new Date();
      const endDate = new Date(user?.subscription_end as string);
      const diffDays = Math.ceil((endDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
      user.isInExpiry = diffDays == 5;
    }
    if (user) {
      res.json(user);
    } else {
      res.status(404).json({ message: "User tidak ditemukan" });
    }
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});

/**
 * @swagger
 * /user/{id}:
 *   put:
 *     summary: Update user details and optionally submit logo
 *     description: Updates user details including optional logo upload. If a logo file path is provided, it will be moved from temporary to final location.
 *     tags: [User]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         description: The ID of the user to update.
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 description: Name of the user
 *               email:
 *                 type: string
 *                 description: Email address of the user
 *               phone_number:
 *                 type: string
 *                 description: Phone number of the user
 *               address:
 *                 type: string
 *                 description: Address of the user
 *               logo:
 *                 type: string
 *                 description: Path of the uploaded logo in Supabase Storage
 *     responses:
 *       '200':
 *         description: Rincian pengguna berhasil diperbarui
 *       '400':
 *         description: Missing required fields or invalid input
 *       '404':
 *         description: Pengguna tidak ditemukan
 *       '500':
 *         description: Failed to update user details or process logo
 */
router.put('/:id', async (req: Request, res: Response) => {
  const { id } = req.params;
  const { name, email, phone_number, address, logo } = req.body;

  // Validate required fields
  if (!name || !email) {
    return res.status(400).json({ message: 'Nama dan email diperlukan' });
  }

  try {
    // Update user details (excluding logo initially)
    const updatedUser = await updateUserDetails(id, { name, email, phone_number, address });

    if (!updatedUser) {
      return res.status(404).json({ message: 'Pengguna tidak ditemukan' });
    }

    if (logo) {
      // Process logo if provided
      const fileName = logo.split('/').pop();
      const newLogoPath = `logos/${id}/${fileName}`;

      // Move the logo from the temporary location to the final location
      const { error: moveError } = await supabase.storage
        .from('logos')
        .move(logo, newLogoPath);

      if (moveError) {
        return res.status(500).json({ message: 'Gagal memindahkan file logo' });
      }

      // Clean up the original temporary logo file if it was successfully moved
      const { error: deleteError } = await supabase.storage
        .from('logos')
        .remove([logo]);

      if (deleteError) {
        return res.status(500).json({ message: 'Gagal menghapus file logo sementara' });
      }

      // Get the public URL for the new logo
      const { data } = supabase.storage
        .from('logos')
        .getPublicUrl(newLogoPath);

      // Access the public URL
      const publicURL = data?.publicUrl;

      if (!publicURL) {
        return res.status(500).json({ message: 'Gagal mengambil URL publik untuk logo' });
      }

      // Update user profile with the new logo URL
      await updateUserDetails(id, { logo: publicURL });
      updatedUser.logo = publicURL; // Update the user object with the new logo URL
    }

    res.status(200).json({ message: 'Rincian pengguna berhasil diperbarui', user: updatedUser });
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: 'Terjadi kesalahan server.' });
  }
});

/**
 * @swagger
 * /user/delete-temp-files:
 *   get:
 *     summary: Delete temporary files
 *     description: Deletes all files in the temporary storage folder. Requires a valid secret token in the request header.
 *     tags: [User]
 *     parameters:
 *       - in: header
 *         name: cron-job-token
 *         required: true
 *         description: The secret token required to authorize the request.
 *         schema:
 *           type: string
 *           example: "d5f811"
 *     responses:
 *       '200':
 *         description: Files deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Files already deleted"
 *       '403':
 *         description: Forbidden Invalid token
 *       '500':
 *         description: Error deleting files
 */
router.get("/delete-temp-files", async (req: AuthenticatedRequest, res: Response) => {
  try {
    await deleteTempFiles();
    res.status(200).json({ message: "Files already deleted" });
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});

/**
 * @swagger
 * /user/check-subscriptions:
 *   get:
 *     summary: Check user subscriptions
 *     description: Checks user subscriptions and sends email notifications for those expiring soon.
 *     tags: [User]
 *     parameters:
 *       - in: header
 *         name: cron-job-token
 *         required: true
 *         description: The secret token required to authorize the request.
 *         schema:
 *           type: string
 *           example: "d5f811"
 *     responses:
 *       '200':
 *         description: Subscriptions checked successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Subscriptions checked and notifications sent"
 *       '403':
 *         description: Forbidden Invalid token
 *       '500':
 *         description: Error checking subscriptions
 */
router.get("/check-subscriptions", async (req: AuthenticatedRequest, res: Response) => {
  try {
    const token = req.headers["cron-job-token"];
    if (token !== process.env.crToken) {
      return res.status(403).json({ message: "Forbidden: Invalid token" });
    }

    await checkUserSubscriptions();
    res.status(200).json({ message: "Subscriptions checked and notifications sent" });
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});

/**
 * @swagger
 * /user/upload-subscriptions-invoice:
 *   post:
 *     summary: Uploads a subscription invoice file
 *     description: Uploads an invoice file to Supabase Storage and returns the file path.
 *     tags: [User]
 *     parameters:
 *       - in: header
 *         name: invoice-token
 *         required: true
 *         schema:
 *           type: string
 *         description: Token for validating access to upload the subscription invoice.
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               file:
 *                 type: string
 *                 format: binary
 *                 description: The subscription invoice file to upload
 *               note:
 *                 type: string
 *                 description: Optional note to associate with the invoice
 *               invoice_id:
 *                 type: string
 *                 description: The ID of the invoice associated with the file
 *     responses:
 *       '200':
 *         description: File uploaded successfully and transaction recorded
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   description: Success message confirming the file upload
 *       '400':
 *         description: Bad request - missing file or required fields
 *       '403':
 *         description: Forbidden - invalid token
 *       '500':
 *         description: Failed to upload file or process the transaction
 */

router.post(
  "/upload-subscriptions-invoice",
  upload.single("file"),
  async (req: AuthenticatedRequest, res: Response) => {
    try {
      const token = req.headers["invoice-token"] as string;

      // Validate the token
      if (!token || !(await verifyInvoiceValid(token))) {
        return res.status(403).json({ message: "Forbidden: Invalid token" });
      }

      if (!req.file) {
        return res.status(400).json({ message: "Tidak ada file yang diunggah" });
      }

      const { originalname, buffer, mimetype } = req.file;
      const fileName = `${Date.now()}_${originalname}`;
      const userId = req.userId; // Assumed that req.userId is set correctly by middleware
      const { note, invoice_id } = req.body;

      // Validate if the required fields are provided
      if (!invoice_id) {
        return res.status(400).json({ message: "Invoice ID diperlukan." });
      }

      const { error: uploadError } = await supabase.storage
        .from("app_transactions")
        .upload(`invoice/${fileName}`, buffer, {
          contentType: mimetype,
        });

      if (uploadError) {
        console.error("Gagal mengunggah file ke Supabase Storage:", uploadError);
        return res.status(500).json({ message: "Gagal mengunggah file" });
      }

      const { data: publicUrlData } = supabase.storage
        .from("app_transactions")
        .getPublicUrl(`invoice/${fileName}`);

      // Optionally save transaction record with userId and file path
      await uploadTransactionFile(
        userId as string,
        note,
        invoice_id,
        `invoice/${fileName}`,
        publicUrlData.publicUrl
      );

      // Respond with success message
      res.status(200).json({ message: "Bukti pembayaran berhasil dimasukan" });
    } catch (err) {
      console.error(err); // Log the error for debugging
      res.status(500).json({ message: "Terjadi kesalahan server." });
    }
  }
);

/**
 * @swagger
 * /user/invoice/{invoiceId}:
 *   get:
 *     summary: Retrieve user invoice details
 *     description: Fetches the invoice details of a user by their invoice ID.
 *     tags: [User]
 *     parameters:
 *       - in: path
 *         name: invoiceId
 *         required: true
 *         schema:
 *           type: string
 *         description: The ID of the invoice to retrieve.
 *       - in: header
 *         name: invoice-token
 *         required: true
 *         schema:
 *           type: string
 *         description: Token for validating access to the invoice.
 *     responses:
 *       '200':
 *         description: User invoice details retrieved successfully.
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UserInvoice'
 *       '400':
 *         description: Invalid or missing invoice ID.
 *       '403':
 *         description: Forbidden: Invalid token.
 *       '404':
 *         description: Invoice not found.
 *       '500':
 *         description: Internal server error.
 */
router.get(
  "/invoice/:invoiceId",
  async (req: AuthenticatedRequest, res: Response) => {
    try {
      const token = req.headers["invoice-token"] as string;

      // Validate the token
      if (!token || !(await verifyInvoiceValid(token))) {
        return res.status(403).json({ message: "Forbidden: Invalid token" });
      }
  
      const { invoiceId } = req.params;

      // Validate the invoiceId
      if (!invoiceId) {
        return res.status(400).json({ message: "Invalid or missing invoice ID." });
      }

      // Fetch invoice details
      const invoice = await getInvoiceDetails(invoiceId);

      if (!invoice) {
        return res.status(404).json({ message: "Invoice not found." });
      }

      // Return the invoice details
      res.status(200).json(invoice);
    } catch (error) {
      console.error("Error fetching invoice details:", error);
      res.status(500).json({
        message: "An error occurred while retrieving invoice details.",
      });
    }
  }
);

/**
 * @swagger
 * /user/invoices:
 *   get:
 *     summary: Retrieve all user invoices
 *     description: Fetches the details of all invoices for a user.
 *     tags: [User]
 *     responses:
 *       '200':
 *         description: Tagihan berhasil diambil
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Invoice'
 *       '404':
 *         description: Tidak ada tagihan ditemukan
 *       '500':
 *         description: Terjadi kesalahan pada server
 */
router.get(
  "/invoices",
  async (req: AuthenticatedRequest, res: Response) => {
    try {
      const invoices = await getInvoices();

      if (!invoices || invoices.length === 0) {
        return res.status(404).json({ message: "Tidak ada tagihan ditemukan." });
      }

      res.status(200).json(invoices);
    } catch (error) {
      console.error("Error fetching invoice details:", error);
      res
        .status(500)
        .json({ message: "Terjadi kesalahan saat mengambil detail tagihan." });
    }
  }
);


/**
 * @swagger
 * /user/plan:
 *   post:
 *     summary: Set a new plan for the user
 *     description: Assign a new plan to a user based on the provided plan code.
 *     tags: [User]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               plan_code:
 *                 type: string
 *                 description: The code of the plan to be assigned to the user.
 *     responses:
 *       '200':
 *         description: Rencana pengguna berhasil diatur
 *       '400':
 *         description: Input tidak valid atau data tidak lengkap
 *       '404':
 *         description: Rencana tidak ditemukan
 *       '500':
 *         description: Terjadi kesalahan pada server
 */
router.post(
  "/plan",
  async (req: AuthenticatedRequest, res: Response) => {
    const userId = req.userId;
    const { plan_code } = req.body;

    if (!userId || !plan_code) {
      return res.status(400).json({ message: "ID pengguna dan Kode Rencana diperlukan." });
    }

    try {
      const success = await setUserPlan({ user_id: userId, plan_code, token: "" });

      if (success) {
        return res.status(200).json({ message: "Rencana pengguna berhasil diatur." });
      }

      res.status(404).json({ message: "Rencana tidak ditemukan atau langganan sudah ada." });
    } catch (error) {
      console.error("Error setting user plan:", error);
      res.status(500).json({ message: "Terjadi kesalahan saat mengatur rencana pengguna." });
    }
  }
);

/**
 * @swagger
 * /user/invoice-update:
 *   post:
 *     summary: Perbarui faktur untuk pengguna
 *     description: Perbarui faktur untuk pengguna berdasarkan ID faktur yang diberikan.
 *     tags: [User]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               status:
 *                 type: string
 *                 description: Diterima atau Ditolak
 *               invoice_id:
 *                 type: string
 *                 description: ID faktur yang akan diperbarui.
 *     responses:
 *       '200':
 *         description: Faktur berhasil diperbarui
 *       '400':
 *         description: Input tidak valid atau data tidak lengkap
 *       '404':
 *         description: Faktur tidak ditemukan
 *       '500':
 *         description: Terjadi kesalahan pada server saat memperbarui faktur
 */
router.post(
  "/invoice-update",
  async (req: AuthenticatedRequest, res: Response) => {
    const token = req.headers["cron-job-token"];
    if (token !== process.env.CRON_JOB_SECRET) {
      return res.status(403).json({ message: "Forbidden: Invalid token" });
    }

    const userId = req.userId;
    const { invoice_id, status } = req.body;

    // Validasi input
    if (!userId || !invoice_id) {
      return res.status(400).json({ message: "ID pengguna dan ID faktur diperlukan." });
    }

    try {
      // Mengasumsikan `updateInvoice` adalah fungsi untuk memperbarui faktur
      const success = await updateInvoice({ invoice_id, status });

      if (success) {
        return res.status(200).json({ message: "Faktur berhasil diperbarui." });
      }

      res.status(404).json({ message: "Faktur tidak ditemukan atau pembaruan gagal." });
    } catch (error) {
      console.error("Error memperbarui faktur:", error);
      res.status(500).json({ message: "Terjadi kesalahan saat memperbarui faktur." });
    }
  }
);

/**
 * @swagger
 * /user/verify-invoice:
 *   post:
 *     summary: Validate Invoice Token
 *     description: Perbarui faktur untuk pengguna berdasarkan ID faktur yang diberikan.
 *     tags: [User]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               token:
 *                 type: string
 *                 description: JWT TOKEN
 *     responses:
 *       '200':
 *         description: Successfully
 *       '400':
 *         description: Error
 *       '500':
 *         description: Server Error
 */
router.post(
  "/verify-invoice",
  async (req: AuthenticatedRequest, res: Response) => {
    const { token } = req.body;

    // Validasi input
    if (!token) {
      return res.status(400).json({ message: "Token diperlukan." });
    }

    try {
      const verifyInvoiceResponse = await verifyInvoiceValid(token);

      if (verifyInvoiceResponse?.valid) {
        return res.status(200).json({ message: "Invoice Masih Bisa Digunakan.", name: verifyInvoiceResponse?.name, status: verifyInvoiceResponse?.status });
      }

      res.status(404).json({ message: "Invoice Sudah Kedaluarsa." });
    } catch (error) {
      console.error("Error validate invoice:", error);
      res.status(500).json({ message: "Terjadi kesalahan pada server." });
    }
  }
);

/**
 * @swagger
 * /user/get-invoice:
 *   get:
 *     summary: Retrieve invoice ID
 *     description: Fetches the invoice ID of a user by their ID.
 *     tags: [User]
 *     responses:
 *       '200':
 *         description: Invoice ID details retrieved successfully
 *         content:
 *           application/json:
 *           schema:
 *             type: object
 *             properties:
 *               token:
 *                 type: string
 *                 description: Invoice ID
 *       '404':
 *         description: Invoice tidak ditemukan
 */
router.get("/get-invoice", async (req: AuthenticatedRequest, res: Response) => {
  const userId = req.userId as string;

  try {
    const data = await getInvoiceByUserId(userId);
    if (data?.invoice) {
      res.json(data);
    } else {
      res.status(404).json({ message: "Invoice tidak ditemukan" });
    }
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});

export default router;
