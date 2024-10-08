SET SERVEROUTPUT ON;
DECLARE
    v_constraint_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_constraint_violation, -1);

BEGIN
    -- Insert data into the Service_Reviews table
    BEGIN
        INSERT INTO Service_Reviews (service_rating, comments, review_id, order_id, satisfaction_rate)
        VALUES (4.5, 'Great service, very helpful staff!', 1, 123456, 0.9);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate review_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Service_Reviews (service_rating, comments, review_id, order_id, satisfaction_rate)
        VALUES (3.8, 'The service was satisfactory.', 2, 654321, 0.7);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate review_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Service_Reviews (service_rating, comments, review_id, order_id, satisfaction_rate)
        VALUES (5.0, 'Excellent service, highly recommend!', 3, 987654, 0.95);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate review_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Service_Reviews (service_rating, comments, review_id, order_id, satisfaction_rate)
        VALUES (2.5, 'Disappointed with the service quality.', 4, 234567, 0.5);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate review_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Service_Reviews (service_rating, comments, review_id, order_id, satisfaction_rate)
        VALUES (2.5, 'ok with the service quality.', 5, 324511, 0.6);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate review_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    -- Commit the transaction
    COMMIT;
END;
/
