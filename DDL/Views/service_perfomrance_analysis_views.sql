SET serveroutput ON;

DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the view SALES_PERFORMANCE_ANALYSIS exists
    SELECT COUNT(*)
    INTO v_count
    FROM user_views
    WHERE view_name = 'SALES_PERFORMANCE_ANALYSIS';

    -- Drop the view SALES_PERFORMANCE_ANALYSIS if it exists
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW SALES_PERFORMANCE_ANALYSIS';
    END IF;

    -- Recreate the view SALES_PERFORMANCE_ANALYSIS
    EXECUTE IMMEDIATE '
    CREATE VIEW SALES_PERFORMANCE_ANALYSIS AS
    SELECT order_date, SUM(order_amount) AS total_sales
    FROM orders
    GROUP BY order_date';
    
    DBMS_OUTPUT.PUT_LINE('SALES_PERFORMANCE_ANALYSIS view created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
--select * from SALES_PERFORMANCE_ANALYSIS