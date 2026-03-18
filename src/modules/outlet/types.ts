import Joi from "joi";

export interface Outlet {
  id: string;
  merchant_id: string;
  code: string | null;
  name: string;
  address: string | null;
  phone_number: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface OutletPayload {
  code?: string | null;
  name: string;
  address?: string | null;
  phone_number?: string | null;
  is_active?: boolean;
}

export const outletSchema = Joi.object<OutletPayload>({
  code: Joi.string().max(20).allow(null, ""),
  name: Joi.string().max(255).required(),
  address: Joi.string().allow(null, ""),
  phone_number: Joi.string().max(50).allow(null, ""),
  is_active: Joi.boolean().optional(),
});
