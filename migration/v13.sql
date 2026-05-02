ALTER TABLE users DROP COLUMN IF EXISTS phone_number;
ALTER TABLE users DROP COLUMN IF EXISTS address;
ALTER TABLE users_signup DROP COLUMN IF EXISTS phone_number;

ALTER TABLE transaction
ADD COLUMN created_by_id UUID,
ADD COLUMN created_by_name VARCHAR(225);

ALTER TABLE users ADD COLUMN nickname varchar(255);
