import Joi from "joi";
import { AVAILABLE_PERMISSIONS, PermissionCode } from "../employee/types";

export interface Role {
  id: string;
  merchant_id: string;
  name: string;
  created_at: string;
  updated_at: string;
  permissions?: PermissionCode[];
}

export interface RolePayload {
  name: string;
  permissions?: PermissionCode[];
}

export interface RoleUpdatePayload {
  name?: string;
}

export const roleSchema = Joi.object<RolePayload>({
  name: Joi.string().max(255).required(),
  permissions: Joi.array()
    .items(Joi.string().valid(...AVAILABLE_PERMISSIONS))
    .optional(),
});

export const roleUpdateSchema = Joi.object<RoleUpdatePayload>({
  name: Joi.string().max(255),
}).min(1);

export const rolePermissionSchema = Joi.object({
  permissions: Joi.array()
    .items(Joi.string().valid(...AVAILABLE_PERMISSIONS))
    .required(),
});
