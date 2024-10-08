CREATE TABLE Payments (
    payment_id          INTEGER PRIMARY KEY,
    order_id            INTEGER NOT NULL,
    payment_amount      NUMBER(10, 2) NOT NULL,
    payment_method      VARCHAR2(20) NOT NULL,
    payment_status      VARCHAR2(20) NOT NULL,
    payment_date        DATE, 
    CONSTRAINT fk_pay_order_id FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE SEQUENCE payment_id_seq;

ALTER TABLE Payments
ADD (
    total_payment_amount NUMBER,
    change_returned NUMBER,
    actual_order_amount NUMBER,
    payment_date DATE 
);

ALTER TABLE PAYMENTS
DROP COLUMN payment_amount;

ALTER TABLE Payments
ADD CONSTRAINT unique_pay_order_id UNIQUE (order_id);
