/*
    This function calculates the total amount due and itemized costs for a given order.
    
    Input Parameters:
    - p_order_id: The ID of the order for which the total amount due is calculated.
    
    Output:
    - Total Amount Due: The total amount due for the specified order, including item costs, taxes, and any additional charges.
    
    Purpose:
    Calculate the total amount due for the specified order, including item costs, taxes, and any additional charges.
    */
    CREATE OR REPLACE FUNCTION calculatetotalamountdue (
    p_order_id IN NUMBER
) RETURN NUMBER AS
    v_total_amount NUMBER := 0;
    v_order_status VARCHAR2(20);
BEGIN
    -- Check the order status
    SELECT order_status INTO v_order_status
    FROM orders
    WHERE order_id = p_order_id;
    
    -- Check if the order status is not pending
    IF v_order_status <> 'Pending' THEN
        -- Calculate itemized costs for the specified order
        SELECT SUM(od.quantity * od.price_per_item)
        INTO v_total_amount
        FROM order_details od
        WHERE od.order_id = p_order_id;

        dbms_output.put_line('Total amount due for order ' || p_order_id || ': $' || v_total_amount);
        
        -- Update the orders table with the total amount due
        UPDATE orders
        SET order_amount = v_total_amount
        WHERE order_id = p_order_id;
        
        -- Commit the transaction
        COMMIT;
        
        -- Return the total amount due
        RETURN v_total_amount;
    ELSE
        dbms_output.put_line('Order status is Pending. Total amount due cannot be calculated.');
        RETURN NULL; -- Return NULL when the order status is pending
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Order ID ' || p_order_id || ' not found.');
        RETURN NULL;
    WHEN OTHERS THEN
        -- Rollback the transaction if an error occurs
        ROLLBACK;
        RAISE;
END calculatetotalamountdue;
/
    
set serveroutput on;
-- Execute the calculatetotalamountdue function
DECLARE
    v_total_amount NUMBER;
BEGIN
    v_total_amount := calculatetotalamountdue(p_order_id => 21); -- Specify the order ID
END;
/
