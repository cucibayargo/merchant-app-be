import express from "express";
import { isValid, parseISO } from "date-fns";
import { AuthenticatedRequest, requirePermission, resolveOutletId } from "../../middlewares";
import { formatJoiError } from "../../utils";
import { createExpanse, deleteExpanse, getExpanseById, listExpanse, updateExpanse } from "./controller";
import { expanseSchema } from "./types";

const router = express.Router();

router.post("/", requirePermission("expanse.create"), async (req: AuthenticatedRequest, res) => {
  try {
    const { error, value } = expanseSchema.validate(req.body, { abortEarly: false });
    if (error) {
      return res.status(400).json({ message: formatJoiError(error) });
    }

    const parsedDate = parseISO(value.date);
    if (!isValid(parsedDate)) {
      return res.status(400).json({ message: "date harus format tanggal yang valid." });
    }

    const outletId = resolveOutletId(req, value.outlet_id);
    await createExpanse(value, req.userId as string, outletId);
    res.status(201).json({
      status: 'success',
      message: 'Pengeluaran berhasil dibuat'
    });
  } catch (error) {
    console.error("Error creating expanse:", error);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

router.get("/", requirePermission("expanse.read"), async (req: AuthenticatedRequest, res) => {
  const filter = req.query.filter as string | null;
  const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
  const page = parseInt(req.query.page as string || "1", 10);
  const limit = parseInt(req.query.limit as string || "10", 10);

  if (isNaN(page) || page < 1 || isNaN(limit) || limit < 1) {
    return res.status(400).json({ message: "Invalid page or limit values" });
  }

  try {
    const { expanses, totalCount } = await listExpanse(req.userId as string, page, limit, filter, outletId);
    const isFirstPage = page === 1;
    const isLastPage = page * limit >= totalCount;

    res.status(200).json({
      expanses,
      totalCount,
      isFirstPage,
      isLastPage,
    });
  } catch (error) {
    console.error("Error listing expanse:", error);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

router.get("/:id", requirePermission("expanse.read"), async (req: AuthenticatedRequest, res) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isInteger(id) || id <= 0) {
      return res.status(400).json({ message: "id tidak valid." });
    }

    const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
    const expanse = await getExpanseById(id, req.userId as string, outletId);
    if (!expanse) {
      return res.status(404).json({ message: "Data pengeluaran tidak ditemukan." });
    }

    res.status(200).json(expanse);
  } catch (error) {
    console.error("Error getting expanse detail:", error);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

router.delete("/:id", requirePermission("expanse.delete"), async (req: AuthenticatedRequest, res) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isInteger(id) || id <= 0) {
      return res.status(400).json({ message: "id tidak valid." });
    }

    const outletId = resolveOutletId(req, req.query.outlet_id as string | undefined);
    const deleted = await deleteExpanse(id, req.userId as string, outletId);
    if (!deleted) {
      return res.status(404).json({ message: "Data pengeluaran tidak ditemukan." });
    }

    res.status(200).json({ message: "Data pengeluaran berhasil dihapus." });
  } catch (error) {
    console.error("Error deleting expanse:", error);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

router.put("/:id", requirePermission("expanse.update"), async (req: AuthenticatedRequest, res) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isInteger(id) || id <= 0) {
      return res.status(400).json({ message: "id tidak valid." });
    }

    const { error, value } = expanseSchema.validate(req.body, { abortEarly: false });
    if (error) {
      return res.status(400).json({ message: formatJoiError(error) });
    }

    const parsedDate = parseISO(value.date);
    if (!isValid(parsedDate)) {
      return res.status(400).json({ message: "date harus format tanggal yang valid." });
    }

    const outletId = resolveOutletId(req, value.outlet_id || (req.query.outlet_id as string | undefined));
    const updated = await updateExpanse(id, value, req.userId as string, outletId);
    if (!updated) {
      return res.status(404).json({ message: "Data pengeluaran tidak ditemukan." });
    }

    res.status(200).json({ message: "Data pengeluaran berhasil diperbarui." });
  } catch (error) {
    console.error("Error updating expanse:", error);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

export default router;