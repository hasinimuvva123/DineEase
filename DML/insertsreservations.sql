SET SERVEROUTPUT ON;
DECLARE
    v_constraint_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_constraint_violation, -1);
BEGIN
    -- Insert data into the Reservations table
    BEGIN
        INSERT INTO reservations (reservation_id, reservation_date, reservation_time, reservation_status, customer_id)
        VALUES (7, TO_DATE('2024-03-14', 'YYYY-MM-DD'), TIMESTAMP '2024-03-14 15:30:00', 'Confirmed', 207);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate reservation_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO reservations (reservation_id, reservation_date, reservation_time, reservation_status, customer_id)
        VALUES (12, TO_DATE('2024-03-15', 'YYYY-MM-DD'), TIMESTAMP '2024-03-17 17:30:00', 'Pending', 205);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate reservation_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO reservations (reservation_id, reservation_date, reservation_time, reservation_status, customer_id)
        VALUES (16, TO_DATE('2024-03-16', 'YYYY-MM-DD'), TIMESTAMP '2024-03-16 18:00:00', 'Pending', 203);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate reservation_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO reservations (reservation_id, reservation_date, reservation_time, reservation_status, customer_id)
        VALUES (15, TO_DATE('2024-03-17', 'YYYY-MM-DD'),TIMESTAMP '2024-03-21 19:30:00', 'Confirmed', 201);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate reservation_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO reservations (reservation_id, reservation_date, reservation_time, reservation_status, customer_id)
        VALUES (11, TO_DATE('2024-03-18', 'YYYY-MM-DD'), TIMESTAMP '2024-03-18 10:30:00', 'Confirmed', 202);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate reservation_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    -- Commit the transaction
    COMMIT;
END;
/
