DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the view exists
    SELECT COUNT(*)
    INTO v_count
    FROM user_views
    WHERE view_name = 'ITEM_RATINGS_ANALYSIS';

    -- Drop the view if it exists
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW ITEM_RATINGS_ANALYSIS';
    END IF;

    -- Recreate the view
    EXECUTE IMMEDIATE '
    CREATE VIEW ITEM_RATINGS_ANALYSIS AS
    SELECT item_id, AVG(food_rating) AS avg_rating
    FROM Ratings
    GROUP BY item_id';

    DBMS_OUTPUT.PUT_LINE('Item Ratings Analysis view created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/


