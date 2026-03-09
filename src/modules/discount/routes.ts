import express from "express";
import { AuthenticatedRequest } from "../../middlewares";
import { formatJoiError } from "../../utils";
import {
  createDiscount,
  deleteDiscount,
  getDiscountById,
  listDiscounts,
  updateDiscount,
} from "./controller";
import { discountSchema, discountUpdateSchema } from "./types";

const router = express.Router();

// GET /discounts
router.get("/", async (req: AuthenticatedRequest, res) => {
  const filter = (req.query.filter as string) || null;
  const page = parseInt((req.query.page as string) || "1", 10);
  const limit = parseInt((req.query.limit as string) || "100", 10);

  if (isNaN(page) || page < 1 || isNaN(limit) || limit < 1) {
    return res.status(400).json({ message: "Invalid page or limit values" });
  }

  try {
    const { data, totalCount } = await listDiscounts(
      req.userId as string,
      page,
      limit,
      filter
    );
    const isFirstPage = page === 1;
    const isLastPage = page * limit >= totalCount;

    res.status(200).json({
      discounts: data,
      totalCount,
      isFirstPage,
      isLastPage,
    });
  } catch (error) {
    console.error("Error listing discounts:", error);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

// GET /discounts/:id
router.get("/:id", async (req: AuthenticatedRequest, res) => {
  try {
    const discount = await getDiscountById(req.params.id, req.userId as string);
    if (!discount) {
      return res.status(404).json({ message: "Diskon tidak ditemukan." });
    }

    res.status(200).json(discount);
  } catch (error) {
    console.error("Error getting discount:", error);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

// POST /discounts
router.post("/", async (req: AuthenticatedRequest, res) => {
  const { error, value } = discountSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ message: formatJoiError(error) });
  }

  try {
    await createDiscount(value, req.userId as string);
    res.status(201).json({
      status: "success",
      message: "Diskon berhasil dibuat",
    });
  } catch (err) {
    console.error("Error creating discount:", err);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

// PUT /discounts/:id
router.put("/:id", async (req: AuthenticatedRequest, res) => {
  const { error, value } = discountUpdateSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ message: formatJoiError(error) });
  }

  try {
    const discount = await updateDiscount(req.params.id, req.userId as string, value);
    if (!discount) {
      return res.status(404).json({ message: "Diskon tidak ditemukan." });
    }

    res.status(200).json({ message: "Diskon berhasil diperbarui." });
  } catch (err) {
    console.error("Error updating discount:", err);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

// DELETE /discounts/:id
router.delete("/:id", async (req: AuthenticatedRequest, res) => {
  try {
    const deleted = await deleteDiscount(req.params.id, req.userId as string);
    if (!deleted) {
      return res.status(404).json({ message: "Diskon tidak ditemukan." });
    }

    res.status(200).json({ message: "Diskon berhasil dihapus." });
  } catch (err) {
    console.error("Error deleting discount:", err);
    res.status(500).json({ message: "Terjadi kesalahan pada server." });
  }
});

export default router;
