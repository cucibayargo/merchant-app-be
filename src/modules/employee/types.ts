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
  "expanse.read",
  "expanse.create",
  "expanse.update",
  "expanse.delete",
] as const;

export type PermissionCode = (typeof AVAILABLE_PERMISSIONS)[number];

export interface Employee {
  id: string;
  merchant_id: string;
  outlet_id: string | null;
  name: string;
  email: string;
  phone_number: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
  last_login_at: string | null;
  permissions?: string[];
}

export interface EmployeePayload {
  outlet_id?: string | null;
  name: string;
  email: string;
  phone_number?: string | null;
  password: string;
  is_active?: boolean;
}

export interface EmployeeUpdatePayload {
  outlet_id?: string | null;
  name?: string;
  email?: string;
  phone_number?: string | null;
  password?: string;
  is_active?: boolean;
}

export const employeeSchema = Joi.object<EmployeePayload>({
  outlet_id: Joi.string().uuid().allow(null, ""),
  name: Joi.string().max(255).required(),
  email: Joi.string().email(),
  phone_number: Joi.string().max(50).allow(null, ""),
  password: Joi.string().min(6).required(),
  is_active: Joi.boolean().optional(),
});

export const employeeUpdateSchema = Joi.object<EmployeeUpdatePayload>({
  outlet_id: Joi.string().uuid().allow(null, ""),
  name: Joi.string().max(255),
  email: Joi.string().email(),
  phone_number: Joi.string().max(50).allow(null, ""),
  password: Joi.string().min(6),
  is_active: Joi.boolean(),
}).min(1);

export const permissionAssignmentSchema = Joi.object({
  permissions: Joi.array()
    .items(Joi.string().valid(...AVAILABLE_PERMISSIONS))
    .required(),
});

export const employeeLoginSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().required(),
});
