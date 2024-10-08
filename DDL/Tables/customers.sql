set SERVEROUTPUT on;

DECLARE
    -- variable to store the count of existing customers table
    customers_exists NUMBER;
BEGIN
    -- Check if the customers table already exists
    SELECT 
        COUNT(*) INTO customers_exists
    FROM
        user_tables
    WHERE
        table_name = 'CUSTOMERS';
        
    -- If customers table does not exist, create it    
    IF customers_exists = 0 THEN
        EXECUTE IMMEDIATE '
        CREATE TABLE Customers (
            customer_id    INTEGER NOT NULL,
            phone_number   VARCHAR2(20),
            reservation_id NUMBER NOT NULL,
            street         VARCHAR2(255),
            city           VARCHAR2(100),
            state          VARCHAR2(100),
            zip            VARCHAR2(10),
            country        VARCHAR2(100),
            CONSTRAINT customer_pk PRIMARY KEY (customer_id)
        )';
        dbms_output.put_line('Customers table created successfully.');
    ELSE
        -- If customers table already exists, inform the user
        dbms_output.put_line('Customers table already exists.');
    END IF;

-- Exception handling block to catch any errors during table creation
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating table Customers: ' || sqlerrm);
END;
/

-- Add unique constraint on phone_number column
BEGIN
    -- Attempt to add the unique constraint
    EXECUTE IMMEDIATE 'ALTER TABLE Customers ADD CONSTRAINT unique_phone_number UNIQUE (phone_number)';
    dbms_output.put_line('Unique constraint added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle error if the constraint already exists or any other error occurs
        dbms_output.put_line('Unique constraint already exists');
END;
