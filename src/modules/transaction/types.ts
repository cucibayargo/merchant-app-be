const Joi = require("joi");

/** Satu lembar karpet yang diukur merchant (meter). */
export interface CarpetDimension {
  length: number;
  width: number;
}

interface TransactionItemDetail {
  service: string;
  service_name: string;
  qty: number;
  duration: string;
  dimensions?: CarpetDimension[] | null;
}

export interface Transaction {
  id: string;
  outlet_id?: string;
  customer: string;
  customer_name: string;
  duration_name: string;
  status: "Diproses" | "Selesai" | "Siap Diambil";
  items?: TransactionItemDetail[];
  total?: number;
  note?: string;
  discount_id?: string;
  employee_id?: string;
  user_id?: string;
  created_at?: string | Date;
}
export interface TransactionData {
  id: string;
  customer: string;
  payment_status: string;
  invoice: string;
  status: "Diproses" | "Selesai" | "Siap Diambil";
  created_at: Date;
  estimated_date: Date;
  ready_to_pick_up_at: Date | null;
  completed_at: Date | null;
}

export interface ServiceDetail {
  service_id: string;
  service_name: string;
  price: number;
  quantity: number;
  dimensions?: CarpetDimension[] | null;
}

export interface TransactionDetails {
  id: string;
  customer: string;
  customer_name: string;
  customer_phone_number: string;
  duration_name: string;
  subtotal: number;
  discount_id: string | null;
  discount_name: string | null;
  discount_type: string | null;
  discount_value: number | null;
  discount_amount: number;
  total: number;
  payment_id: number;
  payment_status: string;
  payment_method: string;
  invoice: string;
  services: ServiceDetail[];
  created_by_name: string;
}

export const transactionSchema = Joi.object({
  outlet_id: Joi.string().uuid().optional(),
  customer: Joi.string().uuid().required(),
  note: Joi.string().allow(''),
  status: Joi.string().valid("Diproses", "Selesai", "Siap Diambil", "Dibatalkan").required(),
  discount_id: Joi.string().uuid().allow(null, '').optional(),
  created_at: Joi.date().iso().optional(),
  items: Joi.array()
    .items(
      Joi.object({
        service: Joi.string().uuid().required(),
        duration: Joi.string().uuid().required(),
        qty: Joi.number().required(),
        // Layanan cuci karpet: daftar ukuran lembar karpet. qty dihitung ulang
        // dari daftar ini di controller, jadi field ini yang jadi acuan harga.
        // Optional supaya build app lama (tanpa dimensions) tetap jalan.
        dimensions: Joi.array()
          .items(
            Joi.object({
              length: Joi.number().greater(0).max(1000).precision(2).required().messages({
                'number.base': 'Panjang harus berupa angka',
                'number.greater': 'Panjang harus lebih dari 0',
                'number.max': 'Panjang terlalu besar',
                'any.required': 'Panjang wajib diisi',
              }),
              width: Joi.number().greater(0).max(1000).precision(2).required().messages({
                'number.base': 'Lebar harus berupa angka',
                'number.greater': 'Lebar harus lebih dari 0',
                'number.max': 'Lebar terlalu besar',
                'any.required': 'Lebar wajib diisi',
              }),
            })
          )
          .min(1)
          .max(200)
          .optional()
          .messages({
            'array.base': 'Ukuran karpet harus berupa array',
            'array.min': 'Minimal 1 ukuran karpet wajib diisi',
            'array.max': 'Ukuran karpet maksimal 200 lembar',
          }),
      })
    )
    .required(),
});

export const transactionUpdateSchema = Joi.object({
  status: Joi.string().required(),
});

interface InvoiceMerchant {
  name: string;
  logo: string;
  address: string;
  note: string | null;
}

interface InvoiceCustomer {
  name: string;
  address: string;
  phone_number: string;
  email: string;
}

interface InvoiceService {
  service_name: string;
  price: number;
  quantity: number;
  total_price: number;
}

interface InvoiceTransaction {
  entry_date: string; // or Date, depending on how you handle dates
  ready_to_pickup_date: string | null; // nullable if not always available
  completed_date: string | null;
  duration: string;
  services: InvoiceService[];
  subtotal: number;
  discount_name: string | null;
  discount_type: string | null;
  discount_value: number | null;
  discount_amount: number;
  total_price: number;
  payment_received: number;
  change_given: number;
}

export interface InvoiceDetails {
  merchant: InvoiceMerchant;
  customer: InvoiceCustomer;
  transaction: Transaction;
}

export interface TransactionQuery {
  text: string;
  values: any[];
}
