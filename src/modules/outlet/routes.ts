import express from "express";
import { AuthenticatedRequest, requireOwner } from "../../middlewares";
import {
  createOutlet,
  deleteOutlet,
  getOutletById,
  listOutlets,
  updateOutlet,
} from "./controller";
import { initServiceAndDuration } from "../auth/controller";
import { outletSchema } from "./types";
import { formatJoiError } from "../../utils";

const router = express.Router();

router.get("/", requireOwner, async (req: AuthenticatedRequest, res) => {
  try {
    const outlets = await listOutlets(req.userId as string);
    return res.status(200).json({ outlets });
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.get("/:id", requireOwner, async (req: AuthenticatedRequest, res) => {
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
    const outlet = await createOutlet(value, req.userId as string);

    await initServiceAndDuration(req.userId as string, outlet.id);

    return res.status(201).json(outlet);
  } catch (error) {
    const err = error as Error;
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
