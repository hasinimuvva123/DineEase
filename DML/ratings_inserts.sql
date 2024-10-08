SET serveroutput ON;

DECLARE
    v_constraint_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_constraint_violation, -1);
BEGIN
    -- Insert data into the Ratings table
    BEGIN
        INSERT INTO Ratings (food_rating, review_id, item_id)
        VALUES (4.5, 3, 1);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate review_id/item_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Ratings (food_rating, review_id, item_id)
        VALUES (3.8, 4, 2);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate review_id/item_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
    
    BEGIN
        INSERT INTO Ratings (food_rating, review_id, item_id)
        VALUES (4.2, 2, 3);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate review_id/item_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Ratings (food_rating, review_id, item_id)
        VALUES (4.0, 5, 4);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate review_id/item_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO Ratings (food_rating, review_id, item_id)
        VALUES (4.6, 1, 5);
    EXCEPTION
        WHEN v_constraint_violation THEN
            DBMS_OUTPUT.PUT_LINE('Duplicate review_id/item_id found. Skipping insertion.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;

    -- Commit the transaction
    COMMIT;
END;
/














