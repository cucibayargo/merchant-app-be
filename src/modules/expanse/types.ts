import Joi from "joi";

export interface ExpansePayload {
  total: number;
  description: string;
  date: string;
}

export interface ExpanseRecord {
  id: number;
  total: number;
  description: string;
  date: string;
}

export const expanseSchema = Joi.object({
  total: Joi.number().min(0).required().messages({
    "number.base": "total harus berupa angka.",
    "number.min": "total tidak boleh negatif.",
    "any.required": "total wajib diisi.",
  }),
  description: Joi.string().trim().required().messages({
    "string.base": "description harus berupa teks.",
    "string.empty": "description wajib diisi.",
    "any.required": "description wajib diisi.",
  }),
  date: Joi.string().required().messages({
    "string.base": "date harus berupa teks tanggal.",
    "string.empty": "date wajib diisi.",
    "any.required": "date wajib diisi.",
  }),
});