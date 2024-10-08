 /*
    This stored procedure updates the status of an order in the 'Orders' table to indicate that it has been provided to the kitchen crew.
    
    Input:
    - p_order_id: The ID of the order to be updated.
    
    Exceptions:
    - NO_DATA_FOUND: Raised if the specified order ID is not found.
    - OTHERS: Handles any other exceptions and raises an error indicating that an error occurred while updating the order status.
    */

    CREATE OR REPLACE PROCEDURE updateorderstatus (
        p_order_id   IN NUMBER,
        p_new_status IN VARCHAR2
    ) AS
    BEGIN
                -- Update the order status to the new status provided
        UPDATE orders
        SET
            order_status = p_new_status
        WHERE
            order_id = p_order_id;
        -- Check if any rows were affected by the update
        IF SQL%rowcount > 0 THEN
            dbms_output.put_line('Order status updated successfully.');
        ELSE
            dbms_output.put_line('No order found with ID: ' || p_order_id);
        END IF;

        COMMIT; -- Commit the transaction
    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20002, 'Order ID not found.');
        WHEN OTHERS THEN
            ROLLBACK; -- Rollback the transaction
            raise_application_error(-20003, 'An error occurred while updating the order status.');
    END updateorderstatus;
    /
    
    
SET SERVEROUTPUT ON;    
    -- Execute the updateorderstatus procedure
BEGIN
    updateorderstatus(p_order_id => 21, -- Specify the order ID
     p_new_status => 'Payment Due' -- Specify the new status as 'Payment Due'
    );
END;
/