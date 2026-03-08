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



router.get("/", async (req: AuthenticatedRequest, res) => {
  try {
    const devices = await getAllPrintedDevices(req.userId as string);
    res.json(devices);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Terjadi kesalahan server";
    res.status(500).json({ message });
  }
});

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

router.post("/", async (req: AuthenticatedRequest, res) => {
  const { error, value } = printedDeviceSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ message: formatJoiError(error) });
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

router.put("/:id", async (req: AuthenticatedRequest, res) => {
  const { error } = printedDeviceSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ message: formatJoiError(error) });
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
