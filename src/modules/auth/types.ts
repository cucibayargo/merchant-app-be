import { JwtPayload } from "jsonwebtoken";

const Joi = require('joi');

export interface User {
    name: string;
    email: string;
    oauth: boolean;
    password: string;
    token?: string;
    phone_number?: string;
    logo?: string;
    address?: string;
    created_at: string; // ISO date string
    updated_at: string; // ISO date string
    id: string; // UUID v4
    status?: string
}

export interface UserDetail {
    name: string;
    email: string;
    phone_number?: string;
    logo?: string;
    address?: string;
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
    password?: string;
    email: string;
    name: string;
    phone_number?: string;
    oauth?: boolean;
    status?: string;
}

export const SignUpSchema = Joi.object({
    password: Joi.string()
        .required()
        .messages({
            'string.empty': 'Password harus diisi.',
            'any.required': 'Password harus diisi.'
        }),
    token: Joi.string()
        .required()
        .messages({
            'string.empty': 'Token harus diisi.',
            'any.required': 'Token harus diisi.'
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
    phone_number: Joi.string().pattern(/^[+]?[0-9]{10,15}$/).required().messages({
        'string.pattern.base': 'Nomor telepon tidak valid',
        }),
});

export interface SignUpTokenInput {
    email: string;
    name: string;
    phone_number?: string;
    subscription_plan?: string;
    token?: string;
    status?: "signed" | "unsigned"
}

export const SignUpTokenSchema = Joi.object({
    name: Joi.string()
            .required()
            .messages({
                'string.empty': 'Nama harus diisi.',
                'any.required': 'Nama harus diisi.'
            }),
    subscription_plan: Joi.string(),
    email: Joi.string()
            .email()
            .required()
            .messages({
                'string.email': 'Alamat email tidak valid.',
                'any.required': 'Alamat email harus diisi.'
            }),
    phone_number: Joi.string().pattern(/^[+]?[0-9]{10,15}$/).required().messages({
        'string.pattern.base': 'Nomor telepon tidak valid',
        }),
})

export const ChangePasswordSchema = Joi.object({
    email: Joi.string().email().required(),
    currentPassword: Joi.string().required(),
    newPassword: Joi.string().min(6).required(),
});

export interface CustomJwtPayload extends JwtPayload {
    id: string;
}

// Define an interface for the email options (for TypeScript typing)
export interface MailOptions {
    from: string;
    to: string;
    subject: string;
    text: string;
    html: string;
}

export interface SubscriptionPlan {
    name: string;
    id: string;
    code: string;
    price: number;
    duration: number;
    created_at: string;
}