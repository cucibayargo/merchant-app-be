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
} from "./controller";
import {
  employeeSchema,
  employeeUpdateSchema,
  roleAssignSchema,
} from "./types";
import { formatJoiError } from "../../utils";

const router = express.Router();

router.get("/", requireOwner, async (req: AuthenticatedRequest, res) => {
  try {
    const employees = await listEmployees(req.userId as string);
    return res.status(200).json(employees);
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

router.put("/:id", requireOwner, async (req: AuthenticatedRequest, res) => {
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
