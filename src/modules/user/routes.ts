import express, { Request, Response } from "express";
import multer from "multer";
import {
  checkUserSubscriptions,
  createInvoice,
  deleteTempFiles,
  deleteUser,
  getInvoiceByUserId,
  getInvoiceDetails,
  getInvoices,
  getLastUserSubscription,
  getUserDetails,
  saveOfflineUser,
  setUserPlan,
  TriggerSupabaseCloud,
  updateInvoice,
  updateUserDetails,
  uploadTransactionFile,
  verifyInvoiceValid,
} from "./controller"; // Assuming you have this function
import supabase from "../../database/supabase";
import { AuthenticatedRequest } from "../../middlewares";
import { createSubscriptions, getSubsPlanByCode, getSubsPlanById } from "../auth/controller";

const router = express.Router();

// Multer configuration
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 }, // Limit file size to 5MB
});



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
      console.log(error);
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

router.get("/details", async (req: AuthenticatedRequest, res: Response) => {
  const userId = req.userId;

  try {
    const user = await getUserDetails(userId);
    if (user) {
      console.log("Subscription End:", user.subscription_end); 

      const endDate = new Date(user.subscription_end as string);
      const now = new Date();

      endDate.setHours(0, 0, 0, 0);
      now.setHours(0, 0, 0, 0);
      const diffDays = Math.floor((endDate.getTime() - now.getTime()) / (1000 * 60 * 60 * 24)); // Use Math.floor
      console.log("Diff Days:", diffDays); 

      user.isInExpiry = diffDays <= 5; 
      res.json(user);
    } else {
      res.status(404).json({ message: "User tidak ditemukan" });
    }
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});


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
        console.log(moveError);
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
    console.log(error)
    const err = error as Error;
    res.status(500).json({ message: 'Terjadi kesalahan server.' });
  }
});

router.get("/delete-temp-files", async (req: AuthenticatedRequest, res: Response) => {
  try {
    await deleteTempFiles();
    res.status(200).json({ message: "Files already deleted" });
  } catch (error) {
    const err = error as Error;
    res.status(500).json({ message: err.message });
  }
});

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


router.post(
  "/upload-subscriptions-invoice",
  upload.single("file"),
  async (req: AuthenticatedRequest, res: Response) => {
    try {
      const { note, referral_points, user_id, plan_id } = req.body;

      // Validate required fields
      if (!user_id) {
        return res.status(400).json({ message: "User ID diperlukan" });
      }

      let invoiceDetail = await getInvoiceByUserId(user_id);

      if (plan_id != invoiceDetail?.plan_code || !invoiceDetail) {
        const subscriptionPlan = await getSubsPlanByCode(plan_id);
        if (!subscriptionPlan) {
          return res
            .status(400)
            .json({ message: "Paket Aplikasi Tidak ditemukan." });
        }

        await createSubscriptions({
          user_id: user_id,
          plan_id: subscriptionPlan.id,
          price: subscriptionPlan.price,
          start_date: new Date().toISOString(),
          end_date: new Date().toISOString(),
          status: "pending"
        });

        const invoiceResponse = await createInvoice({
          user_id: user_id,
          plan_code: subscriptionPlan.code,
          withReferralPoint: false
        });
        
        invoiceDetail = await getInvoiceByUserId(user_id);
        if (!invoiceDetail?.invoice_id) {
          return res.status(403).json({ message: "Invoice Belum ada silahkan hubungi admin" });
        }
      }

      const refPoints = Number(referral_points) || 0;
      const hasFile = !!req.file;
      const exceedsAmount = refPoints > invoiceDetail?.amount;

      // Validate: either file or valid referral points required
      if (!hasFile && exceedsAmount) {
        return res.status(400).json({ message: "Tidak ada file yang diunggah" });
      }

      let fileUrl = "";
      
      // Upload file if provided
      if (hasFile && req.file) {
        const { originalname, buffer, mimetype } = req.file;
        const fileName = `${Date.now()}_${originalname}`;
        const filePath = `invoice/${fileName}`;

        const { error: uploadError } = await supabase.storage
          .from("app_transactions")
          .upload(filePath, buffer, { contentType: mimetype });

        if (uploadError) {
          console.error("Upload error:", uploadError);
          return res.status(500).json({ message: "Gagal mengunggah file" });
        }

        const { data } = supabase.storage
          .from("app_transactions")
          .getPublicUrl(filePath);
        
        fileUrl = data.publicUrl;
      }

      // Cap referral points at invoice amount
      const finalRefPoints = Math.min(refPoints, invoiceDetail.amount);

      await uploadTransactionFile(
        invoiceDetail.user_id,
        note,
        invoiceDetail.invoice_id,
        fileUrl ? `invoice/${Date.now()}_${req.file?.originalname}` : "",
        fileUrl,
        finalRefPoints
      );

      res.status(200).json({
        message: "Bukti pembayaran berhasil dimasukan",
        file: fileUrl,
        invoice_number: invoiceDetail.invoice_id,
      });
    } catch (err) {
      console.error("Upload subscription invoice error:", err);
      res.status(500).json({ message: "Terjadi kesalahan server." });
    }
  }
);

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

router.post(
  "/invoice-update",
  async (req: AuthenticatedRequest, res: Response) => {
    const token = req.headers["cron-job-token"];
    if (token !== process.env.crToken) {
      return res.status(403).json({ message: "Forbidden: Invalid token" });
    }

    const { invoice_id, status } = req.body;

    // Validasi input
    if (!invoice_id) {
      return res.status(400).json({ message: "ID faktur diperlukan." });
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
        return res.status(200).json({ name: verifyInvoiceResponse?.name, status: verifyInvoiceResponse?.status, amount: verifyInvoiceResponse?.amount, plan: verifyInvoiceResponse?.plan});
      }

      res.status(404).json({ message: "Invoice Sudah Kedaluarsa." });
    } catch (error) {
      console.error("Error validate invoice:", error);
      res.status(500).json({ message: "Terjadi kesalahan pada server." });
    }
  }
);

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

router.get("/trigger-supabase-cloud", async (req: AuthenticatedRequest, res: Response) => {
    const token = req.headers["cron-job-token"];
    if (token !== process.env.crToken) {
      return res.status(403).json({ message: "Forbidden: Invalid token" });
    }

    try {
      const success = await TriggerSupabaseCloud();

      if (success) {
        return res.status(200).json({ message: "Success connect into supabase cloud" });
      }

      res.status(404).json({ message: "Failed to connect into database" });
    } catch (error) {
      console.error("Error memperbarui faktur:", error);
      res.status(500).json({ message: "Terjadi kesalahan saat memperbarui faktur." });
    }
  }
);

router.get("/delete/:id", async (req: AuthenticatedRequest, res: Response) => {
  const { id } = req.params;

  try {
    const success = await deleteUser(id);

    if (success) {
      return res.status(200).json({ message: "Successfully deleted user." });
    }

    res.status(404).json({ message: "User not found or failed to delete from the database." });
  } catch (error) {
    console.error("Error deleting user:", error);
    res.status(500).json({ message: "An error occurred while deleting the user." });
  }
});


router.post(
  "/save-offline-user",
   async (req: AuthenticatedRequest, res: Response) => {
    const offlineUser = req.body;

    try {
      await saveOfflineUser(offlineUser);
      res.status(200).json({ message: "Menyimpan user offline berhasil" });
    } catch (error) {
      console.error("Save Offline:", error);
      res.status(500).json({ message: "Gagal menyimpan user offline" });
    }
  }
);
export default router;
