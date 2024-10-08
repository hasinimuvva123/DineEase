SET serveroutput ON;

DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the view EMPLOYEE_PERFORMANCE_MONITORING exists
    SELECT COUNT(*)
    INTO v_count
    FROM user_views
    WHERE view_name = 'EMPLOYEE_PERFORMANCE_MONITORING';

    -- Drop the view EMPLOYEE_PERFORMANCE_MONITORING if it exists
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW EMPLOYEE_PERFORMANCE_MONITORING';
    END IF;

    -- Create the view EMPLOYEE_PERFORMANCE_MONITORING
    EXECUTE IMMEDIATE '
    CREATE VIEW EMPLOYEE_PERFORMANCE_MONITORING AS
    SELECT employee_id, fname || '' '' || lname AS employee_name
    FROM employees';

    DBMS_OUTPUT.PUT_LINE('EMPLOYEE_PERFORMANCE_MONITORING view created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
--select * from EMPLOYEE_PERFORMANCE_MONITORING;