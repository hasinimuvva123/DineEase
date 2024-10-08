set SERVEROUTPUT on;

DECLARE
    table_exists NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO table_exists
    FROM
        user_tables
    WHERE
        table_name = 'SERVICE_REVIEWS';
        
    IF table_exists = 0 THEN
        EXECUTE IMMEDIATE '
       CREATE TABLE SERVICE_REVIEWS (
    service_rating FLOAT,
    comments VARCHAR2(1000),
    review_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    satisfaction_rate FLOAT,
    CONSTRAINT service_review_pk PRIMARY KEY (review_id),
    CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        )';
        dbms_output.put_line('SERVICE_REVIEWS table created successfully.');
    ELSE
        dbms_output.put_line('SERVICE_REVIEWS table already exists.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating table SERVICE_REVIEWS: ' || sqlerrm);
END;