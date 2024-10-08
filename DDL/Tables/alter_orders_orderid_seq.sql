-- Create sequence for auto-generating order_id
CREATE SEQUENCE order_id_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Modify the ORDERS table to use the sequence for order_id
ALTER TABLE ORDERS
MODIFY order_id DEFAULT ORDER_ID_SEQ.NEXTVAL;

