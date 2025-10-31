import express from "express";
import { PrintedDevice, printedDeviceSchema } from "./types";
import {
  getAllPrintedDevices,
  getPrintedDeviceById,
  addPrintedDevice,
  updatePrintedDevice,
  deletePrintedDevice,
} from "./controller";
import { AuthenticatedRequest } from "../../middlewares";
import { formatJoiError } from "../../utils";

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: PrintedDevices
 *   description: Printer management APIs
 */

/**
 * @swagger
 * components:
 *   schemas:
 *     PrintedDevice:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           description: Unique UUID of the printer device
 *           example: "b341b48b-5c44-4a41-b2e0-24c3b88a1c83"
 *         user_id:
 *           type: string
 *           description: User ID that owns this printer
 *           example: "1a45ef12-1234-5678-9abc-1234567890ab"
 *         device_name:
 *           type: string
 *           description: Actual hardware device name
 *           example: "Epson Thermal Printer"
 *         alias_name:
 *           type: string
 *           description: Custom name given by user
 *           example: "Printer Kasir"
 *         device_id:
 *           type: string
 *           description: Device identifier (MAC address or serial)
 *           example: "00:1B:44:11:3A:B7"
 *         is_active:
 *           type: boolean
 *           description: Whether this printer is currently active
 *           example: true
 *         last_connected_at:
 *           type: string
 *           format: date-time
 *           description: Last time printer connected
 */

/**
 * @swagger
 * /printed-devices:
 *   get:
 *     summary: Get all printed devices for the logged-in user
 *     tags: [PrintedDevices]
 *     responses:
 *       200:
 *         description: List of printed devices
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/PrintedDevice'
 */
router.get("/", async (req: AuthenticatedRequest, res) => {
  try {
    const devices = await getAllPrintedDevices(req.userId as string);
    res.json(devices);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Terjadi kesalahan server";
    res.status(500).json({ message });
  }
});

/**
 * @swagger
 * /printed-devices/{id}:
 *   get:
 *     summary: Get a printed device by ID
 *     tags: [PrintedDevices]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: UUID of the printer device
 *     responses:
 *       200:
 *         description: Printer found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/PrintedDevice'
 *       404:
 *         description: Printer not found
 */
router.get("/:id", async (req, res) => {
  try {
    const device = await getPrintedDeviceById(req.params.id);
    if (!device) {
      return res.status(404).json({ message: "Printer tidak ditemukan" });
    }
    res.json(device);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Terjadi kesalahan server";
    res.status(500).json({ message });
  }
});

/**
 * @swagger
 * /printed-devices:
 *   post:
 *     summary: Add a new printed device
 *     tags: [PrintedDevices]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/PrintedDevice'
 *     responses:
 *       201:
 *         description: Printer added successfully
 *       400:
 *         description: Invalid input
 */
router.post("/", async (req: AuthenticatedRequest, res) => {
  const { error, value } = printedDeviceSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ error: formatJoiError(error) });
  }

  try {
    const newDevice = await addPrintedDevice({ ...value, user_id: req.userId });
    res.status(201).json({
      status: "success",
      message: "Printer berhasil ditambahkan",
      data: newDevice,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Terjadi kesalahan server";
    res.status(500).json({ message });
  }
});

/**
 * @swagger
 * /printed-devices/{id}:
 *   put:
 *     summary: Update an existing printed device
 *     tags: [PrintedDevices]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: UUID of the printer device
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/PrintedDevice'
 *     responses:
 *       200:
 *         description: Printer updated successfully
 *       400:
 *         description: Invalid request
 *       404:
 *         description: Printer not found
 */
router.put("/:id", async (req: AuthenticatedRequest, res) => {
  const { error } = printedDeviceSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ error: formatJoiError(error) });
  }

  try {
    const updated = await updatePrintedDevice(req.params.id, req.body);
    res.json({ status: "success", message: "Printer berhasil diperbarui", data: updated });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message.includes("not found")) {
        res.status(404).json({ message: "Printer tidak ditemukan" });
      } else {
        res.status(500).json({ message: error.message });
      }
    } else {
      res.status(500).json({ message: "Terjadi kesalahan server" });
    }
  }
});

/**
 * @swagger
 * /printed-devices/{id}:
 *   delete:
 *     summary: Delete a printed device by ID
 *     tags: [PrintedDevices]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Printer deleted successfully
 *       404:
 *         description: Printer not found
 */
router.delete("/:id", async (req, res) => {
  try {
    await deletePrintedDevice(req.params.id);
    res.json({ status: "success", message: "Printer berhasil dihapus" });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message.includes("not found")) {
        res.status(404).json({ message: "Printer tidak ditemukan" });
      } else {
        res.status(500).json({ message: error.message });
      }
    } else {
      res.status(500).json({ message: "Terjadi kesalahan server" });
    }
  }
});

export default router;
