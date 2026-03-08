import express, { Request, Response } from "express";
import { emailSupportSchema, SheetData } from "./types";
import { sendToSheet } from "./controller";
import { AuthenticatedRequest } from "../../middlewares";
import { getUserDetails } from "../user/controller";
import { formatJoiError } from "../../utils";

const router = express.Router();






router.post("/", async (req: AuthenticatedRequest, res: Response) => {
    const { error, value } = emailSupportSchema.validate(req.body, { abortEarly: false });
    if (error) {
      const message = formatJoiError(error);
      return res.status(400).json({ message: message });
    }

    const userDetail = await getUserDetails(req.userId);
    const { title, message } = req.body;

    const data: SheetData = {
        title: title,
        message: message,
        email: userDetail?.email || "",
        status: "Pending",
    };
  
    console.log(data);
    
    await sendToSheet(data).catch((error) => {
        const err = error as Error;
        console.log(err.message);
        res.status(500).json({ message: "Aplikasi mengalami gangguan. Silakan kontak kami langsung melalui support@cucibayargo.com." });
    });
    
    res.status(200).json({
        status: "success",
        message: "Email dukungan telah berhasil dikirim",
      })
});

export default router;