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
        table_name = 'ITEMS';

    IF table_exists = 0 THEN
        EXECUTE IMMEDIATE '
        CREATE TABLE ITEMS (
    item_id    INTEGER NOT NULL,
    item_name  VARCHAR2(100), -- Adjusted length to accommodate longer names
    item_price NUMBER(10,2), -- Adjusted data type to NUMBER for precise pricing
    invoice_id VARCHAR2(50) NOT NULL,
    CONSTRAINT items_pk PRIMARY KEY (item_id)
--    CONSTRAINT invoice_fk FOREIGN KEY (invoice_id) REFERENCES invoices (invoice_id)
        )';
        dbms_output.put_line('ITEMS table created successfully.');
    ELSE
        dbms_output.put_line('ITEMS table already exists.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating table ITEMS: ' || sqlerrm);
END;