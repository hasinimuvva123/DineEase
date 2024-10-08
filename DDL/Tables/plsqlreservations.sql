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
        table_name = 'RESERVATIONS';
        
    IF table_exists = 0 THEN
        EXECUTE IMMEDIATE '
        CREATE TABLE RESERVATIONS (
             reservation_id     NUMBER NOT NULL,
             reservation_date   DATE,
             reservation_time   TIMESTAMP, 
             reservation_status VARCHAR2(25),
             customer_id        INTEGER NOT NULL,
             CONSTRAINT reservations_pk PRIMARY KEY (reservation_id)
        )';
        dbms_output.put_line('RESERVATIONS table created successfully.');
    ELSE
        dbms_output.put_line('RESERVATIONS table already exists.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error creating table RESERVATIONS: ' || sqlerrm);
END;