const Joi = require("joi");

export interface Discount {
  id: string;
  merchant_id: string;
  outlet_id?: string | null;
  name: string;
  type: "percentage" | "amount";
  value: number;
  description?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export const discountSchema = Joi.object({
  outlet_id: Joi.string().uuid().optional(),
  name: Joi.string().required(),
  type: Joi.string().valid("percentage", "amount").required(),
  value: Joi.number().positive().required(),
  description: Joi.string().allow("", null).optional(),
  is_active: Joi.boolean().optional(),
});

export const discountUpdateSchema = Joi.object({
  outlet_id: Joi.string().uuid().optional(),
  name: Joi.string().optional(),
  type: Joi.string().valid("percentage", "amount").optional(),
  value: Joi.number().positive().optional(),
  description: Joi.string().allow("", null).optional(),
  is_active: Joi.boolean().optional(),
});
