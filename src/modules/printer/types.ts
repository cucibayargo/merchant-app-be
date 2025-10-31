import Joi from "joi";

export interface PrintedDevice {
  id: string;
  user_id: string;
  device_name: string;
  alias_name?: string | null;
  device_id: string;
  is_active: boolean;
  last_connected_at?: string | null;
}

export const printedDeviceSchema = Joi.object({
  device_name: Joi.string().required().messages({
    "string.empty": "Nama perangkat tidak boleh kosong",
  }),
  alias_name: Joi.string().allow(null, ""),
  device_id: Joi.string().required().messages({
    "string.empty": "Device ID tidak boleh kosong",
  }),
  is_active: Joi.boolean().default(false)
});
