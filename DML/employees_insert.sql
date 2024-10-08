set serveroutput on;
DECLARE
    v_gender_too_long EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_gender_too_long, -12899); -- Value too large for column error code

    v_constraint_violation_pk EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_constraint_violation_pk, -1); -- Primary key violation error code

    v_constraint_violation_unique EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_constraint_violation_unique, -2299); -- Unique constraint violation error code
    
BEGIN
    -- Insert data into the Employees table
    BEGIN
        INSERT INTO EMPLOYEES (employee_id, fname, lname, street, city, state, zip, country, salary, gender, ssn, start_date, end_date, role)
        VALUES (101, 'Geet', 'Acharya', '123 Washington St', 'Boston', 'Massachusetts', '01235', 'USA', 50000.00, 'F', '123-45-6789', TO_DATE('2024-01-01', 'YYYY-MM-DD'), NULL, 'Manager');
    EXCEPTION
        WHEN v_constraint_violation_pk THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate employee_id found. Skipping insertion.');
        WHEN v_gender_too_long THEN
            DBMS_OUTPUT.PUT_LINE('Value too large for Gender. Skipping insertion.');
        WHEN v_constraint_violation_unique THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate ssn found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO EMPLOYEES (employee_id, fname, lname, street, city, state, zip, country, salary, gender, ssn, start_date, end_date, role)
        VALUES (102, 'Emily', 'Watt', '456 Elm St', 'Jersey City', 'New Jersey', '07302', 'USA', 45000.00, 'F', '987-65-4321', TO_DATE('2024-02-01', 'YYYY-MM-DD'), NULL, 'Cashier');
    EXCEPTION
        WHEN v_constraint_violation_pk THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate employee_id found. Skipping insertion.');
        WHEN v_gender_too_long THEN
            DBMS_OUTPUT.PUT_LINE('Value too large for Gender. Skipping insertion.');
        WHEN v_constraint_violation_unique THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate ssn found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO EMPLOYEES (employee_id, fname, lname, street, city, state, zip, country, salary, gender, ssn, start_date, end_date, role)
        VALUES (103, 'Dough', 'Heffernen', '456 Brokline Ave', 'Hillsborough', 'New York', '06782', 'USA', 35000.00, 'M', '987-65-8321', TO_DATE('2024-01-15', 'YYYY-MM-DD'), NULL, 'Service_crew');
    EXCEPTION
        WHEN v_constraint_violation_pk THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate employee_id found. Skipping insertion.');
        WHEN v_gender_too_long THEN
            DBMS_OUTPUT.PUT_LINE('Value too large for Gender. Skipping insertion.');
        WHEN v_constraint_violation_unique THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate ssn found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO EMPLOYEES (employee_id, fname, lname, street, city, state, zip, country, salary, gender, ssn, start_date, end_date, role)
        VALUES (104, 'Carry', 'Heffernen', '406 Amory St', 'Cambridge', 'Massachusetts', '07302', 'USA', 35000.00, 'F', '897-65-7321', TO_DATE('2024-02-05', 'YYYY-MM-DD'), NULL, 'Service_crew');
    EXCEPTION
        WHEN v_constraint_violation_pk THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate employee_id found. Skipping insertion.');
        WHEN v_gender_too_long THEN
            DBMS_OUTPUT.PUT_LINE('Value too large for Gender. Skipping insertion.');
        WHEN v_constraint_violation_unique THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate ssn found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO EMPLOYEES (employee_id, fname, lname, street, city, state, zip, country, salary, gender, ssn, start_date, end_date, role)
        VALUES (105, 'Ross', 'Geller', '456 Elm St', 'Lowell', 'Massachusetts', '07302', 'USA', 40000.00, 'M', '387-65-4121', TO_DATE('2024-01-01', 'YYYY-MM-DD'), NULL, 'Kitchen_crew');
    EXCEPTION
        WHEN v_constraint_violation_pk THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate employee_id found. Skipping insertion.');
        WHEN v_gender_too_long THEN
            DBMS_OUTPUT.PUT_LINE('Value too large for Gender. Skipping insertion.');
        WHEN v_constraint_violation_unique THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate ssn found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    -- Commit the transaction
    COMMIT;
END;
/
