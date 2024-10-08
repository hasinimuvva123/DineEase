set serveroutput on;
DECLARE
    v_constraint_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_constraint_violation, -1);
    
BEGIN
    -- Insert data into the Customers table
    BEGIN
        INSERT INTO Customers (customer_id, phone_number, reservation_id, street, city, state, zip, country)
        VALUES (203, '1234567890', 101, '123 Main St', 'Cityville', 'Stateville', '12345', 'Countryland');
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate customer_id/phone_number found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Customers (customer_id, phone_number, reservation_id, street, city, state, zip, country)
        VALUES (201, '9876543210', 102, '456 Oak St', 'Townville', 'Stateville', '54321', 'Countryland');
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate customer_id/phone_number found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    BEGIN
        INSERT INTO Customers (customer_id, phone_number, reservation_id, street, city, state, zip, country)
        VALUES (205, '2345678923', 105, '123 Washington St', 'Boston', 'Massachusetts', '12342', 'US');
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate customer_id/phone_number found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
     BEGIN
        INSERT INTO Customers (customer_id, phone_number, reservation_id, street, city, state, zip, country)
        VALUES (202, '1234543231', 103, '151 Alphonso St', 'Dallas', 'Texas', '43567', 'US');
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate customer_id/phone_number found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
     BEGIN
        INSERT INTO Customers (customer_id, phone_number, reservation_id, street, city, state, zip, country)
        VALUES (207, '8765908761', 104, '986 Oak St', 'Jersey City', 'New Jersey', '12311', 'United States');
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate customer_id/phone_number found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
     BEGIN
        INSERT INTO Customers (customer_id, phone_number, reservation_id, street, city, state, zip, country)
        VALUES (204, '2345678923', 105, '123 Washington St', 'Boston', 'Massachusetts', '12342', 'US');
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate customer_id/phone_number found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    -- Commit the transaction
    COMMIT;
END;
/
