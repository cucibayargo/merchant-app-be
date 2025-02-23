import Joi from "joi";

export const emailSupportSchema = Joi.object({
  title: Joi.string().required().messages({
      'string.empty': 'Judul wajib diisi',
  }),
  message: Joi.string().required().messages({
      'string.empty': 'Pesan wajib diisi',
  }),
});

export interface SheetData {
  title: string;
  message: string;
  email: string;
  status: string;
}