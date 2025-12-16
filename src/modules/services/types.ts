import Joi from "joi";
// Define the Duration type
export interface Duration {
  id: string;
  duration: number; // Duration in minutes
  duration_name: string; // Name of the duration
  price: number; // Price for the duration
}

// Define the Service type
export interface Service {
  id: string;
  name: string;
  unit: string; // Unit of measurement
  durations: Duration[];
}

export interface ServiceDurationDetail {
  id: string;
  name: string;
  unit: string;
  price: number;
}

export const serviceSchema = Joi.object({
  name: Joi.string().required().messages({
    'string.empty': 'Nama wajib diisi',
    'any.required': 'Nama wajib diisi',
  }),

  unit: Joi.string().required().messages({
    'string.empty': 'Satuan wajib diisi',
    'any.required': 'Satuan wajib diisi',
  }),

  durations: Joi.array()
    .items(
      Joi.object({
        duration: Joi.string().required().messages({
          'string.empty': 'Durasi wajib diisi',
          'any.required': 'Durasi wajib diisi',
        }),
        price: Joi.number().integer().min(0).required().messages({
          'number.base': 'Harga harus berupa angka',
          'number.integer': 'Harga harus berupa bilangan bulat',
          'number.min': 'Harga tidak boleh kurang dari 0',
          'any.required': 'Harga wajib diisi',
        }),
      })
    )
    .min(1)
    .required()
    .messages({
      'array.base': 'Durasi harus berupa array',
      'array.min': 'Durasi wajib diisi minimal 1',
      'any.required': 'Durasi wajib diisi',
    }),
});
