CREATE TABLE expenses (
    id BIGSERIAL PRIMARY KEY,
    merchant_id uuid NOT NULL,
    total NUMERIC(14,2) NOT NULL,
    description TEXT NOT NULL,
    date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_expenses_merchant_date ON expenses (merchant_id, date);