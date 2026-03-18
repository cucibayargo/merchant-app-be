CREATE TABLE discounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('percentage', 'amount')),
    value NUMERIC(14) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_discounts_merchant_id ON discounts (merchant_id);

ALTER TABLE transaction
ADD COLUMN discount_id UUID REFERENCES discounts(id) ON DELETE SET NULL,
ADD COLUMN discount_amount NUMERIC(14,2) NOT NULL DEFAULT 0;

ALTER TABLE payment
ADD COLUMN payment_method VARCHAR(50);
ALTER TABLE payment
ADD COLUMN payment_at DATE;