import express from "express";
import { AuthenticatedRequest, requireOwner } from "../../middlewares";
import {
  createOutlet,
  deleteOutlet,
  getOutletById,
  isOutletCodeExists,
  listOutlets,
  updateOutlet,
} from "./controller";
import { initServiceAndDuration } from "../auth/controller";
import { outletSchema } from "./types";
import { formatJoiError } from "../../utils";

const router = express.Router();

router.get("/", async (req: AuthenticatedRequest, res) => {
  const filter = req.query.filter as string | null;
  const page = parseInt((req.query.page as string) || "1", 10);
  const limit = parseInt((req.query.limit as string) || "10", 10);

  if (isNaN(page) || page < 1 || isNaN(limit) || limit < 1) {
    return res.status(400).json({ message: "Invalid page or limit values" });
  }

  try {
    const { outlets, totalCount } = await listOutlets(req.userId as string, filter, page, limit);
    const isFirstPage = page === 1;
    const isLastPage = page * limit >= totalCount;

    return res.status(200).json({ outlets, totalCount, isFirstPage, isLastPage });
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.get("/:id", async (req: AuthenticatedRequest, res) => {
  try {
    const outlet = await getOutletById(req.params.id, req.userId as string);
    if (!outlet) {
      return res.status(404).json({ message: "Outlet tidak ditemukan." });
    }

    return res.status(200).json(outlet);
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.post("/", requireOwner, async (req: AuthenticatedRequest, res) => {
  const { error, value } = outletSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ message: formatJoiError(error) });
  }

  try {
    const code = (value.code || "").trim();
    if (code) {
      const codeExists = await isOutletCodeExists(req.userId as string, code);
      if (codeExists) {
        return res.status(400).json({ message: "Kode outlet sudah digunakan." });
      }
      value.code = code;
    }

    const outlet = await createOutlet(value, req.userId as string);

    await initServiceAndDuration(req.userId as string, outlet.id);

    return res.status(201).json(outlet);
  } catch (error) {
    const err = error as Error & { code?: string };
    if (err.code === "23505") {
      return res.status(400).json({ message: "Kode outlet sudah digunakan." });
    }
    return res.status(500).json({ message: err.message });
  }
});

router.put("/:id", requireOwner, async (req: AuthenticatedRequest, res) => {
  const { error, value } = outletSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ message: formatJoiError(error) });
  }

  try {
    const outlet = await updateOutlet(req.params.id, value, req.userId as string);
    if (!outlet) {
      return res.status(404).json({ message: "Outlet tidak ditemukan." });
    }

    return res.status(200).json(outlet);
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.delete("/:id", requireOwner, async (req: AuthenticatedRequest, res) => {
  try {
    const deleted = await deleteOutlet(req.params.id, req.userId as string);
    if (!deleted) {
      return res.status(404).json({ message: "Outlet tidak ditemukan." });
    }

    return res.status(200).json({ message: "Outlet berhasil dihapus." });
  } catch (error) {
    const err = error as Error;
    return res.status(400).json({ message: err.message });
  }
});

export default router;
