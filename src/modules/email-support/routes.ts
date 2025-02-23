import express, { Request, Response } from "express";
import { emailSupportSchema, SheetData } from "./types";
import { sendToSheet } from "./controller";
import { AuthenticatedRequest } from "../../middlewares";
import { getUserDetails } from "../user/controller";

const router = express.Router();


/**
 * @swagger
 * tags:
 *   name: Email Support
 *   description: Email Support APIs
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     EmailRequestBody:
 *       type: object
 *       required:
 *           - title
 *           - message
 *       properties:
 *         title:
 *           type: string
 *           description: Email title
 *           example: "Need some help"
 *         message:
 *           type: string
 *           description: Email message body
 *           example: "Aplikasi ini sangat sangat bagus"
 *     EmailResponse:
 *       type: object
 *       properties:
 *         status:
 *           type: string
 *           example: "success"
 *         message:
 *           type: string
 *           example: "Email support submitted successfully."
 */

/**
 * @swagger
 * /email-support:
 *   post:
 *     summary: Send an Email
 *     description: Send a new email support
 *     tags: [Email Support]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/EmailRequestBody'
 *     responses:
 *       201:
 *         description: Email sended successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/EmailResponse'
 *       400:
 *         description: Bad request, invalid input
 */


router.post("/", async (req: AuthenticatedRequest, res: Response) => {
    const { error, value } = emailSupportSchema.validate(req.body, { abortEarly: false });

    if (error) {
        return res.status(400).json({
            errors: error.details.map(err => ({
            type: 'field',
            msg: err.message,
            path: err.path[0],
            location: 'body'
            }))
        });
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