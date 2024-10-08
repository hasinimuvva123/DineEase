
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the view exists
    SELECT COUNT(*)
    INTO v_count
    FROM user_views
    WHERE view_name = 'TOTAL_AMOUNT_DUE';

    -- Drop the view if it exists
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW TOTAL_AMOUNT_DUE';
    END IF;

    -- Recreate the view
    EXECUTE IMMEDIATE '
    CREATE OR REPLACE VIEW TOTAL_AMOUNT_DUE AS
    SELECT
        o.order_id,
        o.order_date,
        SUM(i.item_price * od.quantity) AS total_amount_due
    FROM
        orders o
    JOIN
        order_details od ON o.order_id = od.order_id
    JOIN
        items i ON od.item_id = i.item_id
    GROUP BY
        o.order_id,
        o.order_date';
END;
/
