import Joi from "joi";

export interface Note {
    id: string
    notes: string
    outlet_id?: string | null
}

export const noteSchema = Joi.object({
    outlet_id: Joi.string().uuid().optional(),
    notes: Joi.string().required().messages({
        'string.empty': 'Catatan wajib diisi',
    }),
});
