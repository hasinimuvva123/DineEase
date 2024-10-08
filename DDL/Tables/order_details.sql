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
        table_name = 'ORDER_DETAILS';
        
    IF table_exists = 0 THEN
        EXECUTE IMMEDIATE '
       CREATE TABLE ORDER_DETAILS (
    order_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    price_per_item FLOAT NOT NULL,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES Items(item_id)
        )';
        dbms_output.put_line('ORDER_DETAILS table created successfully.');
    ELSE
        dbms_output.put_line('ORDER_DETAILS table already exists.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating table Order_details: ' || sqlerrm);
END;
