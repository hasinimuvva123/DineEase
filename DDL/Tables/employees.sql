set SERVEROUTPUT on;

DECLARE
    -- variable to store the count of existing employees table
    table_exists NUMBER;
BEGIN
     -- Check if the employees table already exists
    SELECT
        COUNT(*)
    INTO table_exists
    FROM
        user_tables
    WHERE
        table_name = 'EMPLOYEES';
    
     -- If employees table does not exist, create it        
    IF table_exists = 0 THEN
        EXECUTE IMMEDIATE '
        CREATE TABLE EMPLOYEES (
            employee_id INTEGER NOT NULL,
            fname       VARCHAR2(25),
            lname       VARCHAR2(25),
            street      VARCHAR2(255),
            city        VARCHAR2(100),
            state       VARCHAR2(100),
            zip         VARCHAR2(10),
            country     VARCHAR2(100),
            salary      NUMBER(10, 2),
            gender      CHAR(1),
            ssn         VARCHAR2(11),
            start_date  DATE,
            end_date    DATE,
            role  VARCHAR2(45),
            CONSTRAINT employees_pk PRIMARY KEY (employee_id)
        )';
        dbms_output.put_line('EMPLOYEES table created successfully.');
    ELSE
         -- If EMPLOYEES table already exists, inform the user
        dbms_output.put_line('EMPLOYEES table already exists.');
    END IF;
    
-- Exception handling block to catch any errors during table creation
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating table EMPLOYEES: ' || sqlerrm);
END;
/