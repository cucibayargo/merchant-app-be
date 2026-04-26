import Joi from "joi";

export const AVAILABLE_PERMISSIONS = [
  "transaction.read",
  "transaction.create",
  "transaction.update",
  "transaction.delete",
  "report.read",
  "customer.read",
  "customer.create",
  "customer.update",
  "customer.delete",
  "service.read",
  "service.create",
  "service.update",
  "service.delete",
  "duration.read",
  "duration.create",
  "duration.update",
  "duration.delete",
  "discount.read",
  "discount.create",
  "discount.update",
  "discount.delete",
  "expanse.read",
  "expanse.create",
  "expanse.update",
  "expanse.delete",
  "note.read",
  "note.update",
] as const;

export type PermissionCode = (typeof AVAILABLE_PERMISSIONS)[number];

export interface Employee {
  id: string;
  merchant_id: string;
  outlet_id: string | null;
  role_id: string | null;
  name: string;
  username: string;
  phone_number: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  last_login_at: string | null;
  role?: { id: string; name: string; permissions: string[] } | null;
}

export interface EmployeePayload {
  outlet_id?: string | null;
  role_id?: string | null;
  name: string;
  username: string;
  phone_number?: string | null;
  password: string;
  is_active?: boolean;
}

export interface EmployeeUpdatePayload {
  outlet_id?: string | null;
  role_id?: string | null;
  name?: string;
  username?: string;
  phone_number?: string | null;
  password?: string;
  old_password?: string;
  is_active?: boolean;
}

export const employeeSchema = Joi.object<EmployeePayload>({
  outlet_id: Joi.string().uuid().allow(null, ""),
  role_id: Joi.string().uuid().allow(null, ""),
  name: Joi.string().max(255).required(),
  username: Joi.string().max(255).required(),
  phone_number: Joi.string().max(50).allow(null, ""),
  password: Joi.string().min(6).required(),
  is_active: Joi.boolean().optional(),
});

export const employeeUpdateSchema = Joi.object<EmployeeUpdatePayload>({
  outlet_id: Joi.string().uuid().allow(null, ""),
  role_id: Joi.string().uuid().allow(null, ""),
  name: Joi.string().max(255),
  username: Joi.string().max(255),
  phone_number: Joi.string().max(50).allow(null, ""),
  password: Joi.string(),
  is_active: Joi.boolean(),
}).min(1);

export interface EmployeeUpdatePasswordPayload {
  old_password: string;
  password: string;
}

export const employeeUpdatePasswordSchema = Joi.object<EmployeeUpdatePasswordPayload>({
  old_password: Joi.string().required(),
  password: Joi.string().required(),
});

export const roleAssignSchema = Joi.object({
  role_id: Joi.string().uuid().allow(null, "").required(),
});

export const employeeLoginSchema = Joi.object({
  username: Joi.string().required(),
  password: Joi.string().required(),
});
