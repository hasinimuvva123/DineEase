/*
    This procedure processes payments for orders, updating payment information in the Payments table and the status of the order in the Orders table. 
    It also calculates and returns change if the payment amount exceeds the total amount due.
    */
    CREATE OR REPLACE PROCEDURE processpayment (
        p_order_id       IN NUMBER,
        p_payment_amount IN NUMBER,
        p_payment_method IN VARCHAR2,
        p_payment_status IN VARCHAR2,
        p_change         OUT NUMBER
    ) AS
        v_total_due      NUMBER;
        v_payment_exists NUMBER; -- Flag to check if payment exists
        v_remaining_due  NUMBER;
    BEGIN
     -- Check if payment for the order ID already exists
        BEGIN
            SELECT
                COUNT(*)
            INTO v_payment_exists
            FROM
                payments
            WHERE
                order_id = p_order_id;

        EXCEPTION
            WHEN no_data_found THEN
                dbms_output.put_line('No payment found for order ID ' || p_order_id);
                RETURN; -- Exit the procedure
        END;

        -- Check if the order ID exists
        BEGIN
            SELECT
                order_amount
            INTO v_total_due
            FROM
                orders
            WHERE
                order_id = p_order_id;

        EXCEPTION
            WHEN no_data_found THEN
                dbms_output.put_line('Order ID '
                                     || p_order_id
                                     || ' not found.');
                p_change := 0;
                RETURN; -- Exit the procedure
        END;

        IF v_payment_exists > 0 THEN
            dbms_output.put_line('Order amount for order ID '
                                 || p_order_id
                                 || ' is already cleared.');
            p_change := 0;
            RETURN; -- Exit the procedure
        END IF;

    -- Retrieve the total amount due for the order
        SELECT
            order_amount
        INTO v_total_due
        FROM
            orders
        WHERE
            order_id = p_order_id;

    -- Check if the payment amount is less than or equal to 0
        IF p_payment_amount <= 0 THEN
            dbms_output.put_line('Invalid payment amount.');
            p_change := 0; -- Set change to 0
            RETURN; -- Exit 
        END IF;

     -- Check if the payment amount is less than the total amount due
        IF p_payment_amount < v_total_due THEN
            v_remaining_due := v_total_due - p_payment_amount;
            dbms_output.put_line('Insufficient payment amount. Please provide an additional $'
                                 || v_remaining_due
                                 || '.');
            p_change := 0; -- Set change to 0
            RETURN; -- Exit the procedure gracefully
        END IF;

    -- Calculate change if the payment amount exceeds the total amount due
        IF p_payment_amount > v_total_due THEN
            p_change := p_payment_amount - v_total_due;
            dbms_output.put_line('Change Due: ' || p_change);
        ELSE
            p_change := 0;
        END IF;

    -- Begin transaction
        BEGIN
        -- Insert payment information into the Payments table
            INSERT INTO payments (
                payment_id,
                order_id,
                payment_method,
                payment_status,
                total_payment_amount,
                change_returned,
                actual_order_amount,
                payment_date
            ) VALUES (
                payment_id_seq.NEXTVAL, -- Get the next payment ID
                p_order_id,
                p_payment_method,
                p_payment_status,
                p_payment_amount, -- Total payment amount
                p_change, -- Insert the calculated change
                v_total_due, -- Insert the total due amount
                sysdate
            );
        
        -- Update the Orders table with the status 'Paid'
            UPDATE orders
            SET
                order_status = 'Paid'
            WHERE
                order_id = p_order_id;
        
        -- Commit the transaction
            COMMIT;
        EXCEPTION
            WHEN no_data_found THEN
                dbms_output.put_line('Order ID '
                                     || p_order_id
                                     || ' not found.');
                ROLLBACK; -- Rollback the transaction if an error occurs
            WHEN dup_val_on_index THEN
            -- Rollback the transaction if an error occurs
                ROLLBACK;
                dbms_output.put_line('Order '
                                     || p_order_id
                                     || ' is already paid.');
            WHEN OTHERS THEN
            -- Rollback the transaction if an error occurs
                ROLLBACK;
                dbms_output.put_line('An error occurred: ' || sqlerrm);
        END;

    END processpayment;
    /
    
    
    --EXECUTION
    SET SERVEROUTPUT ON;
    -- Execute the processpayment procedure
DECLARE
    v_change NUMBER;
BEGIN
    processpayment(p_order_id => 17, -- Specify the order ID
     p_payment_amount => 100, -- Specify the payment amount
     p_payment_method => 'Cash', -- Specify the payment method
     p_payment_status => 'Paid', -- Specify the payment status
     p_change => v_change -- Output parameter for change
    );

    dbms_output.put_line('Change: ' || v_change);
END;
/
