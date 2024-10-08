ALTER TABLE reservations
ADD CONSTRAINT unique_reservation_customer
UNIQUE (reservation_id, customer_id);

ALTER TABLE reservations
ADD CONSTRAINT fk_customer_id
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);
