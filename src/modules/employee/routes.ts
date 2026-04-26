import express from "express";
import { AuthenticatedRequest, requireOwner } from "../../middlewares";
import {
  assignRoleToEmployee,
  createEmployee,
  deleteEmployee,
  getEmployeeById,
  getEmployeePermissions,
  listEmployees,
  updateEmployee,
  updateEmployeePassword,
} from "./controller";
import {
  employeeSchema,
  employeeUpdatePasswordSchema,
  employeeUpdateSchema,
  roleAssignSchema,
} from "./types";
import { formatJoiError } from "../../utils";

const router = express.Router();

router.get("/", requireOwner, async (req: AuthenticatedRequest, res) => {
  const filter = req.query.filter as string | null;
  const outletId = (req.query.outlet_id as string) || null;
  const roleId = (req.query.role_id as string) || null; 
  const page = parseInt((req.query.page as string) || "1", 10);
  const limit = parseInt((req.query.limit as string) || "10", 10);

  if (isNaN(page) || page < 1 || isNaN(limit) || limit < 1) {
    return res.status(400).json({ message: "Invalid page or limit values" });
  }

  try {
    const { employees, totalCount } = await listEmployees(
      req.userId as string,
      filter,
      outletId,
      roleId,
      page,
      limit
    );
    const isFirstPage = page === 1;
    const isLastPage = page * limit >= totalCount;

    return res.status(200).json({ employees, totalCount, isFirstPage, isLastPage });
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.get("/:id", requireOwner, async (req: AuthenticatedRequest, res) => {
  try {
    const employee = await getEmployeeById(req.params.id, req.userId as string);
    if (!employee) {
      return res.status(404).json({ message: "Karyawan tidak ditemukan." });
    }

    return res.status(200).json(employee);
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.post("/", requireOwner, async (req: AuthenticatedRequest, res) => {
  const { error, value } = employeeSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ message: formatJoiError(error) });
  }

  try {
    const employee = await createEmployee(value, req.userId as string);
    return res.status(201).json(employee);
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.put("/:id", async (req: AuthenticatedRequest, res) => {
  const { error, value } = employeeUpdateSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ message: formatJoiError(error) });
  }

  try {
    const employee = await updateEmployee(req.params.id, value, req.userId as string);
    if (!employee) {
      return res.status(404).json({ message: "Karyawan tidak ditemukan." });
    }

    return res.status(200).json(employee);
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.put("/:id/password", async (req: AuthenticatedRequest, res) => {
  const { error, value } = employeeUpdatePasswordSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ message: formatJoiError(error) });
  }

  try {
    const result = await updateEmployeePassword(
      req.params.id,
      value.old_password,
      value.new_password,
      req.userId as string
    );

    if (!result.success) {
      if (result.error === "not_found") {
        return res.status(404).json({ message: "Karyawan tidak ditemukan." });
      }
      return res.status(400).json({ message: "Password lama tidak sesuai." });
    }

    return res.status(200).json({ message: "Password berhasil diperbarui." });
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.delete("/:id", requireOwner, async (req: AuthenticatedRequest, res) => {
  try {
    const deleted = await deleteEmployee(req.params.id, req.userId as string);
    if (!deleted) {
      return res.status(404).json({ message: "Karyawan tidak ditemukan." });
    }

    return res.status(200).json({ message: "Karyawan berhasil dihapus." });
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.get("/:id/permissions", requireOwner, async (req: AuthenticatedRequest, res) => {
  try {
    const permissions = await getEmployeePermissions(req.params.id, req.userId as string);
    return res.status(200).json({ permissions });
  } catch (error) {
    const err = error as Error;
    return res.status(500).json({ message: err.message });
  }
});

router.put("/:id/role", requireOwner, async (req: AuthenticatedRequest, res) => {
  const { error, value } = roleAssignSchema.validate(req.body, { abortEarly: false });
  if (error) {
    return res.status(400).json({ message: formatJoiError(error) });
  }

  try {
    const employee = await assignRoleToEmployee(
      req.params.id,
      value.role_id || null,
      req.userId as string
    );
    if (!employee) {
      return res.status(404).json({ message: "Karyawan tidak ditemukan." });
    }
    return res.status(200).json(employee);
  } catch (error) {
    const err = error as Error;
    return res.status(400).json({ message: err.message });
  }
});

export default router;
