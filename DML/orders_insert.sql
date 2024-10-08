DECLARE
    v_constraint_violation_pk EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_constraint_violation_pk, -1); -- Primary key violation error code
    
    v_employee_or_customer_null EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_employee_or_customer_null, -1400); -- ORA-01400: cannot insert NULL error code

BEGIN
    -- Inserting data into the ORDERS table
    BEGIN
        INSERT INTO ORDERS (order_id, order_date, order_amount, order_type, order_status, employee_id, customer_id)
        VALUES (123456, TO_DATE('2024-03-15', 'YYYY-MM-DD'), 100.00, 'Reservation', 'Pending', 101, 201);
    EXCEPTION
        WHEN v_constraint_violation_pk THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate order_id found. Skipping insertion.');
        WHEN v_employee_or_customer_null THEN
            DBMS_OUTPUT.PUT_LINE('Employee_id or Customer_id cannot be null. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO ORDERS (order_id, order_date, order_amount, order_type, order_status, employee_id, customer_id)
        VALUES (654321, TO_DATE('2024-03-16', 'YYYY-MM-DD'), 150.50, 'Dine-in', 'Completed', 102, 202);
    EXCEPTION
        WHEN v_constraint_violation_pk THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate order_id found. Skipping insertion.');
        WHEN v_employee_or_customer_null THEN
            DBMS_OUTPUT.PUT_LINE('Employee_id or Customer_id cannot be null. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO ORDERS (order_id, order_date, order_amount, order_type, order_status, employee_id, customer_id)
        VALUES (234567, TO_DATE('2024-03-17', 'YYYY-MM-DD'), 75.25, 'Reservation', 'Pending', 103, 203);
    EXCEPTION
        WHEN v_constraint_violation_pk THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate order_id found. Skipping insertion.');
        WHEN v_employee_or_customer_null THEN
            DBMS_OUTPUT.PUT_LINE('Employee_id or Customer_id cannot be null. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
     BEGIN
        INSERT INTO ORDERS (order_id, order_date, order_amount, order_type, order_status, employee_id, customer_id)
        VALUES (324511, TO_DATE('2024-03-18', 'YYYY-MM-DD'), 200.00, 'Delivery', 'Processing', 104, 204);
    EXCEPTION
        WHEN v_constraint_violation_pk THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate order_id found. Skipping insertion.');
        WHEN v_employee_or_customer_null THEN
            DBMS_OUTPUT.PUT_LINE('Employee_id or Customer_id cannot be null. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO ORDERS (order_id, order_date, order_amount, order_type, order_status, employee_id, customer_id)
        VALUES (987654, TO_DATE('2024-03-19', 'YYYY-MM-DD'), 50.75, 'Walk-in', 'Completed', 105, 205);
    EXCEPTION
        WHEN v_constraint_violation_pk THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate order_id found. Skipping insertion.');
        WHEN v_employee_or_customer_null THEN
            DBMS_OUTPUT.PUT_LINE('Employee_id or Customer_id cannot be null. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
END;
/
