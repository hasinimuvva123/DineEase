SET SERVEROUTPUT ON;

DECLARE
    inventory_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO inventory_count
    FROM user_tables
    WHERE table_name = 'INVENTORY';
        
    IF inventory_count = 0 THEN
        EXECUTE IMMEDIATE '
            CREATE TABLE Inventory (
                invoice_id VARCHAR2(50) PRIMARY KEY,
                quantity INTEGER,
                date_of_purchase DATE,
                item_id INTEGER NOT NULL,
                FOREIGN KEY (item_id) REFERENCES items(item_id)
            )';

        dbms_output.put_line('Inventory table created successfully.');

    ELSE
        dbms_output.put_line('Inventory table already exists.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating table Inventory: ' || sqlerrm);
END;

