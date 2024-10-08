DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the view exists
    SELECT COUNT(*)
    INTO v_count
    FROM user_views
    WHERE view_name = 'RESERVATION_DETAILS';

    -- Drop the view if it exists
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW RESERVATION_DETAILS';
    END IF;

    -- Recreate the view
    EXECUTE IMMEDIATE '
    CREATE VIEW RESERVATION_DETAILS AS
    SELECT reservation_id, reservation_date,reservation_time, reservation_status, customer_id
    FROM reservations';
END;
/
