CREATE TABLE app_invoices (
    user_id bigint,
    transaction_id bigint,
    amount numeric,
    status character varying,
    due_date date,
    invoice_date date,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (id)
);

CREATE TABLE app_plans (
    name character varying,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    code character varying NOT NULL,
    price double precision,
    duration integer,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (id)
);

CREATE TABLE app_subscriptions (
    start_date date,
    end_date date,
    status character varying,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    user_id uuid,
    plan_id uuid,
    PRIMARY KEY (id)
);

CREATE TABLE app_transactions (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    user_id uuid,
    subscription_id uuid,
    amount numeric,
    transaction_date timestamp without time zone,
    payment_method character varying,
    status character varying,
    PRIMARY KEY (id)
);

CREATE TABLE customer (
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    merchant_id uuid,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    name character varying,
    address character varying,
    phone_number character varying,
    email character varying,
    gender character varying,
    PRIMARY KEY (id)
);

CREATE TABLE duration (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    duration double precision,
    merchant_id uuid,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    name character varying,
    type character varying,
    PRIMARY KEY (id)
);

CREATE TABLE note (
    merchant_id uuid,
    notes text,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    PRIMARY KEY (id)
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
    transaction_id uuid,
    PRIMARY KEY (id)
);

CREATE TABLE service (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    unit character varying,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    merchant_id uuid,
    name character varying,
    PRIMARY KEY (id)
);

CREATE TABLE service_duration (
    service uuid NOT NULL DEFAULT gen_random_uuid(),
    price double precision NOT NULL,
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    duration uuid NOT NULL DEFAULT gen_random_uuid(),
    PRIMARY KEY (id)
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
    customer_phone_number character varying,
    PRIMARY KEY (id)
);

CREATE TABLE transaction_item (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    service_id uuid,
    qty double precision,
    service_unit character varying,
    transaction_id uuid,
    service_name character varying,
    price double precision,
    PRIMARY KEY (id)
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
    phone_number character varying,
    PRIMARY KEY (id)
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
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    PRIMARY KEY (id)
);

ALTER TABLE transaction ADD COLUMN order integer;
-- Create the function that will handle the logic
CREATE OR REPLACE FUNCTION set_order_for_transaction()
RETURNS TRIGGER AS $$
BEGIN
  -- Calculate the count of transactions for the same merchant_id
  NEW.order := (
    SELECT COUNT(*) + 1
    FROM transaction
    WHERE merchant_id = NEW.merchant_id
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger that calls the function
CREATE TRIGGER trigger_set_order
BEFORE INSERT ON transaction
FOR EACH ROW
EXECUTE FUNCTION set_order_for_transaction();

ALTER TABLE users
ADD COLUMN sequence_id SERIAL UNIQUE;

ALTER TABLE app_invoices ADD COLUMN invoice_id character varying;
ALTER TABLE app_invoices ADD COLUMN plan_id uuid;
ALTER TABLE app_transactions ADD COLUMN invoice_id character varying;
ALTER TABLE app_invoices DROP COLUMN transaction_id;
ALTER TABLE app_invoices DROP COLUMN invoice_date;
ALTER TABLE "transaction" ADD COLUMN estimated_date TIMESTAMP;