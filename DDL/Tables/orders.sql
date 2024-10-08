set SERVEROUTPUT on;

DECLARE
    -- variable to store the count of existing ORDERS table
    table_exists NUMBER;
BEGIN
    -- Check if the ORDERS table already exists
    SELECT
        COUNT(*)
    INTO table_exists
    FROM
        user_tables
    WHERE
        table_name = 'ORDERS';
    
     -- If ORDERS table does not exist, create it    
    IF table_exists = 0 THEN
        EXECUTE IMMEDIATE '
        CREATE TABLE ORDERS (
    order_id     INTEGER NOT NULL,
    order_date   DATE,
    order_amount NUMBER(10, 2),
    order_type   VARCHAR2(45),
    order_status VARCHAR2(45),
    employee_id  INTEGER NOT NULL,
    customer_id  INTEGER NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY ( order_id )
        )';
        dbms_output.put_line('ORDERS table created successfully.');
    ELSE
        -- If ORDERS table already exists, inform the user
        dbms_output.put_line('ORDERS table already exists.');
    END IF;

-- Exception handling block to catch any errors during table creation
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating table ORDERS: ' || sqlerrm);
END;
/
