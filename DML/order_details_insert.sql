SET serveroutput ON;

DECLARE
    v_constraint_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_constraint_violation, -1);
BEGIN
    -- Insert data into the Order_details table
    BEGIN
        INSERT INTO Order_details (item_count, order_id, item_id, price_per_item, quantity)
        VALUES (2.0, 123456, 1, 15.99, 1);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate order_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Order_details (item_count, order_id, item_id, price_per_item, quantity)
        VALUES (1.8, 654321, 2, 20.50, 3);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate order_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO Order_details (item_count, order_id, item_id, price_per_item, quantity)
        VALUES (4.2, 987654, 3, 8.75, 2);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate order_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO Order_details (item_count, order_id, item_id, price_per_item, quantity)
        VALUES (3.2, 234567, 4, 12.99, 2);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate order_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO Order_details (item_count, order_id, item_id, price_per_item, quantity)
        VALUES (5.5, 324511, 5, 9.75, 3);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate order_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    -- Commit the transaction
    COMMIT;
END;
/
