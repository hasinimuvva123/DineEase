/*This view presents historical information about orders.*/

-- Create Order History View
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the view exists
    SELECT
        COUNT(*)
    INTO v_count
    FROM
        user_views
    WHERE
        view_name = 'ORDER_HISTORY';

    -- Drop the view if it exists
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW ORDER_HISTORY';
    END IF;

    -- Recreate the view
    EXECUTE IMMEDIATE '
   CREATE OR REPLACE VIEW order_history AS
SELECT
    o.order_id,
    o.order_date,
    o.order_amount,
    o.order_status,
    e.fname || '' '' || e.lname AS employee_name,
    c.customer_id,
    c.phone_number,
    c.street AS customer_street,
    c.city AS customer_city,
    c.state AS customer_state,
    c.zip AS customer_zip,
    c.country AS customer_country
FROM
    orders o
JOIN
    employees e ON o.employee_id = e.employee_id
JOIN
    customers c ON o.customer_id = c.customer_id';
END;
/
--SELECT * FROM ORDER_HISTORY;