CREATE TABLE app_invoices (
    user_id bigint,
    transaction_id bigint,
    amount numeric,
    status character varying,
    due_date date,
    invoice_date date,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE app_plans (
    name character varying,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    code character varying NOT NULL,
    price double precision,
    duration integer,
    created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE app_subscriptions (
    start_date date,
    end_date date,
    status character varying,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    user_id uuid,
    plan_id uuid
);

CREATE TABLE app_transactions (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    user_id uuid,
    subscription_id uuid,
    amount numeric,
    transaction_date timestamp without time zone,
    payment_method character varying,
    status character varying
);

CREATE TABLE customer (
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    merchant_id uuid,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    name character varying,
    address character varying,
    phone_number character varying,
    email character varying,
    gender character varying
);

CREATE TABLE duration (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    duration double precision,
    merchant_id uuid,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    name character varying,
    type character varying
);

CREATE TABLE note (
    merchant_id uuid,
    notes text,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE payment (
    merchant_id uuid,
    status character varying,
    invoice_id character varying,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    change_given double precision,
    total_amount_due double precision,
    payment_received double precision,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    transaction_id uuid
);

CREATE TABLE service (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    unit character varying,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    merchant_id uuid,
    name character varying
);

CREATE TABLE service_duration (
    service uuid NOT NULL DEFAULT gen_random_uuid(),
    price double precision NOT NULL,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    duration uuid NOT NULL DEFAULT gen_random_uuid()
);

CREATE TABLE transaction (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    customer_id uuid,
    duration_id uuid,
    duration_length double precision,
    completed_at timestamp without time zone,
    ready_to_pick_up_at timestamp without time zone,
    merchant_id uuid,
    customer_name character varying,
    customer_address text,
    duration_name character varying,
    duration_length_type character varying,
    status character varying,
    customer_email character varying,
    customer_phone_number character varying
);

CREATE TABLE transaction_item (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    service_id uuid,
    qty double precision,
    service_unit character varying,
    transaction_id uuid,
    service_name character varying,
    price double precision
);

CREATE TABLE users (
    token character varying,
    logo character varying,
    address character varying,
    password character varying,
    status character varying,
    oauth boolean,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    name character varying,
    email character varying,
    phone_number character varying
);

CREATE TABLE users_signup (
    name character varying,
    email character varying,
    phone_number character varying,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    token character varying,
    status character varying,
    user_id uuid,
    subscription_plan uuid,
    id uuid NOT NULL DEFAULT gen_random_uuid()
);
