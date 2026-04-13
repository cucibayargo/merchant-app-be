import express from "express";
import { AuthenticatedRequest, requireOwner } from "../../middlewares";
import {
  createRole,
  deleteRole,
  getRoleById,
  listRoles,
  setRolePermissions,
  updateRole,
} from "./controller";
import { rolePermissionSchema, roleSchema, roleUpdateSchema } from "./types";
import { formatJoiError } from "../../utils";
import { AVAILABLE_PERMISSIONS } from "../employee/types";

const router = express.Router();

router.get("/permissions/catalog", (_req, res) => {
  return res.status(200).json({ permissions: AVAILABLE_PERMISSIONS });
});

router.get("/", requireOwner, async (req: AuthenticatedRequest, res) => {
  const filter = req.query.filter as string | null;
  const page = parseInt((req.query.page as string) || "1", 10);
  const limit = parseInt((req.query.limit as string) || "10", 10);

  if (isNaN(page) || page < 1 || isNaN(limit) || limit < 1) {
    return res.status(400).json({ message: "Invalid page or limit values" });
  }

  try {
    const { roles, totalCount } = await listRoles(req.userId as string, filter, page, limit);
    const isFirstPage = page === 1;
    const isLastPage = page * limit >= totalCount;

    return res.status(200).json({ roles, totalCount, isFirstPage, isLastPage });
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.get("/:id", requireOwner, async (req: AuthenticatedRequest, res) => {
  try {
    const role = await getRoleById(req.params.id, req.userId as string);
    if (!role) return res.status(404).json({ message: "Role tidak ditemukan." });
    return res.status(200).json(role);
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.post("/", requireOwner, async (req: AuthenticatedRequest, res) => {
  const { error, value } = roleSchema.validate(req.body, { abortEarly: false });
  if (error) return res.status(400).json({ message: formatJoiError(error) });

  try {
    const role = await createRole(value, req.userId as string);
    return res.status(201).json(role);
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.put("/:id", requireOwner, async (req: AuthenticatedRequest, res) => {
  const { error, value } = roleUpdateSchema.validate(req.body, { abortEarly: false });
  if (error) return res.status(400).json({ message: formatJoiError(error) });

  try {
    const role = await updateRole(req.params.id, value, req.userId as string);
    if (!role) return res.status(404).json({ message: "Role tidak ditemukan." });
    return res.status(200).json(role);
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.delete("/:id", requireOwner, async (req: AuthenticatedRequest, res) => {
  try {
    const deleted = await deleteRole(req.params.id, req.userId as string);
    if (!deleted) return res.status(404).json({ message: "Role tidak ditemukan." });
    return res.status(200).json({ message: "Role berhasil dihapus." });
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.put("/:id/permissions", requireOwner, async (req: AuthenticatedRequest, res) => {
  const { error, value } = rolePermissionSchema.validate(req.body, { abortEarly: false });
  if (error) return res.status(400).json({ message: formatJoiError(error) });

  try {
    const permissions = await setRolePermissions(
      req.params.id,
      value.permissions,
      req.userId as string
    );
    return res.status(200).json({ permissions });
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

export default router;
