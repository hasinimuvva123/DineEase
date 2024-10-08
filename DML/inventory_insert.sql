SET SERVEROUTPUT ON;

DECLARE
    v_constraint_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_constraint_violation, -1);
BEGIN
    -- Insert data into the Inventory table
    BEGIN
        INSERT INTO Inventory (invoice_id, quantity, date_of_purchase, item_id)
        VALUES ('INV-2024001', 3, TO_DATE('2024-03-19', 'YYYY-MM-DD'), 1);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate invoice_id/item_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Inventory (invoice_id, quantity, date_of_purchase, item_id)
        VALUES ('INV-2024002', 4, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 2);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate invoice_id/item_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO Inventory (invoice_id, quantity, date_of_purchase, item_id)
        VALUES ('INV-2024003', 2, TO_DATE('2024-03-21', 'YYYY-MM-DD'), 3);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate invoice_id/item_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Inventory (invoice_id, quantity, date_of_purchase, item_id)
        VALUES ('INV-2024004', 5, TO_DATE('2024-03-22', 'YYYY-MM-DD'), 4);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate invoice_id/item_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Inventory (invoice_id, quantity, date_of_purchase, item_id)
        VALUES ('INV-2024005', 1, TO_DATE('2024-03-23', 'YYYY-MM-DD'), 5);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate invoice_id/item_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    -- Commit the transaction
    COMMIT;
END;
/