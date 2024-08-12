const Joi = require('joi');

export interface User {
    name: string;
    email: string;
    oauth: boolean;
    token?: string;
    phone_number?: string;
    logo?: string;
    address?: string;
    created_at: string; // ISO date string
    updated_at: string; // ISO date string
    id: string; // UUID v4
}
  
export interface LoginInput {
    password: string;
    email: string;
}

export const LoginSchema = Joi.object({
    password: Joi.string()
        .required()
        .messages({
            'string.empty': 'Password harus diisi.',
            'any.required': 'Password harus diisi.'
        }),
    email: Joi.string()
        .email()
        .required()
        .messages({
            'string.email': 'Alamat email tidak valid.',
            'any.required': 'Alamat email harus diisi.'
        }),
});

export interface SignUpInput {
    password: string;
    email: string;
    name: string;
    phone_number?: string;
}

export const SignUpSchema = Joi.object({
    password: Joi.string()
        .required()
        .messages({
            'string.empty': 'Password harus diisi.',
            'any.required': 'Password harus diisi.'
        }),
    name: Joi.string()
        .min(1)
        .max(255)
        .required()
        .messages({
            'string.empty': 'Nama harus diisi.',
            'string.min': 'Nama harus memiliki setidaknya {#limit} karakter.',
            'string.max': 'Nama tidak boleh lebih dari {#limit} karakter.',
            'any.required': 'Nama harus diisi.'
        }),
    email: Joi.string()
        .email()
        .required()
        .messages({
            'string.email': 'Alamat email tidak valid.',
            'any.required': 'Alamat email harus diisi.'
        }),
    phone_number: Joi.string()
        .optional()
        .messages({
            'string.base': 'Nomor telepon harus berupa string.'
        }),
});
