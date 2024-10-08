-- Create Customer Order Details View
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the view exists
    SELECT COUNT(*)
    INTO v_count
    FROM user_views
    WHERE view_name = 'CUSTOMER_ORDER_DETAILS';

    -- Drop the view if it exists
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW CUSTOMER_ORDER_DETAILS';
    END IF;

    -- Recreate the view
    EXECUTE IMMEDIATE '
    CREATE VIEW CUSTOMER_ORDER_DETAILS AS
    SELECT o.order_id, o.order_date, o.order_amount, o.order_type, o.order_status, c.customer_id, c.phone_number, c.reservation_id
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id';
END;
/
--SELECT * FROM CUSTOMER_ORDER_DETAILS;
