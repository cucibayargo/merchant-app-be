import express, { Request, Response } from "express";
import multer from "multer";
import {
  deleteTempFiles,
  getUserDetails,
  updateUserDetails,
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
        return res.status(500).json({ message: 'Gagal menghapus file logo sementara'});
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
    res.status(500).json({ message: 'Terjadi kesalahan server.'});
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


export default router;
