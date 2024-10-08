/*
    This procedure updates the status of an order in the 'Orders' table to indicate that it has been provided to the kitchen crew.
    
    Input:
    - p_order_id: The ID of the order to be updated.
    
    Exceptions:
    - NO_DATA_FOUND: Raised if the specified order ID is not found.
    - OTHERS: Handles any other exceptions and raises an error indicating that an error occurred while updating the order status.
    */
    CREATE OR REPLACE PROCEDURE trackorderprogress (
        p_order_id IN NUMBER
    ) AS
        v_order_status VARCHAR2(50);
        v_order_amount NUMBER;
    BEGIN
            -- Retrieve the current status of the order
        SELECT
            order_status,
            order_amount
        INTO
            v_order_status,
            v_order_amount
        FROM
            orders
        WHERE
            order_id = p_order_id;

        IF ( v_order_status = 'Completed' ) THEN
            dbms_output.put_line('Order ID: '
                                 || p_order_id
                                 || ', Current Status: '
                                 || v_order_status
                                 || ', Amount Due: $'
                                 || v_order_amount);

        ELSE
            -- Display the current status
            dbms_output.put_line('Order ID: '
                                 || p_order_id
                                 || ', Current Status: '
                                 || v_order_status);
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
                -- Custom message for order not found
            dbms_output.put_line('Order ID '
                                 || p_order_id
                                 || ' not found.');
        WHEN OTHERS THEN
                -- Custom message for other errors
            dbms_output.put_line('An error occurred while tracking the order status.');
    END trackorderprogress;
    /
    
    --EXECUTION
    SET SERVEROUTPUT ON;
    -- Execute the trackorderprogress procedure
BEGIN
    trackorderprogress(p_order_id => 17); -- Specify the order ID
END;
/