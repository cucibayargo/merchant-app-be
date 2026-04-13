import express from "express";
import { PrintedDevice, printedDeviceSchema } from "./types";
import {
  getAllPrintedDevices,
  getPrintedDeviceById,
  addPrintedDevice,
  updatePrintedDevice,
  deletePrintedDevice,
} from "./controller";
import { AuthenticatedRequest, resolveOutletId } from "../../middlewares";
import { formatJoiError } from "../../utils";

const router = express.Router();



router.get("/", async (req: AuthenticatedRequest, res) => {
  try {
    const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
    if (!outletId) {
      return res.status(400).json({ message: "Outlet wajib dipilih." });
    }

    const devices = await getAllPrintedDevices(req.userId as string, outletId);
    res.json(devices);
  } catch (error) {
    const message = error instanceof Error ? error.message : "Terjadi kesalahan server";
    res.status(500).json({ message });
  }
});

router.get("/:id", async (req: AuthenticatedRequest, res) => {
  try {
    const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
    if (!outletId) {
      return res.status(400).json({ message: "Outlet wajib dipilih." });
    }

    const device = await getPrintedDeviceById(req.params.id, req.userId as string, outletId);
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
    const outletId = resolveOutletId(req, value.outlet_id);
    if (!outletId) {
      return res.status(400).json({ message: "Outlet wajib dipilih." });
    }

    const newDevice = await addPrintedDevice({ ...value, user_id: req.userId, outlet_id: outletId });
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
    const outletId = resolveOutletId(req, req.body?.outlet_id || (req.query.outlet_id as string | undefined));
    if (!outletId) {
      return res.status(400).json({ message: "Outlet wajib dipilih." });
    }

    const updated = await updatePrintedDevice(req.params.id, req.userId as string, outletId, req.body);
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

router.delete("/:id", async (req: AuthenticatedRequest, res) => {
  try {
    const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
    if (!outletId) {
      return res.status(400).json({ message: "Outlet wajib dipilih." });
    }

    await deletePrintedDevice(req.params.id, req.userId as string, outletId);
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
