CREATE OR REPLACE PACKAGE BODY ordermanagement AS
    /*
    This function enables customers to place orders for food items by specifying the item names and quantities.
    It takes the following input parameters:
    - p_customer_id: The ID of the customer placing the order.
    - p_order_type: The type of the order, which can be one of the following: 'Reservation', 'Dine-in', 'Delivery', 'Walk-in'.
    - p_selected_items: A string containing selected items and their quantities in the format "item_name-quantity".
    
    For each selected item, the function retrieves the item ID and price based on the provided item name from the 'items' table.
    It then inserts the items into the 'Order_details' table with the specified quantity, associated with the customer's ID and order type, with a pending status.
    It checks if there's an open order for the customer with the same order type for the current date.
        If not, it generates a new order ID and inserts a new order into the orders table with status as "Pending".
    An employee is randomly(with least orders) assigned to handle the order.
    The function returns the order ID.
    */
    FUNCTION placeorderforfood (
        p_customer_id    IN NUMBER,
        p_order_type     IN VARCHAR2,
        p_selected_items IN VARCHAR2
    ) RETURN NUMBER AS
        v_order_id       NUMBER;
        v_employee_id    NUMBER;
        v_customer_count NUMBER;
        v_order_count    NUMBER;
        v_selected_items VARCHAR2(4000);
    BEGIN
        -- Begin transaction
        v_selected_items := upper(p_selected_items);
        BEGIN
            -- Check if customer ID exists
            SELECT
                COUNT(*)
            INTO v_customer_count
            FROM
                customers
            WHERE
                customer_id = p_customer_id;

            IF v_customer_count = 0 THEN
                raise_application_error(-20101, 'Customer does not exist.');
            END IF;
    
            -- Check if order type is valid
            IF p_order_type NOT IN ( 'Reservation', 'Dine-in', 'Delivery', 'Walk-in', 'Online' ) THEN
                raise_application_error(-20002, 'Invalid order type. Please select from: "Reservation", "Dine-in", "Delivery", "Walk-in", "Online".'
                );
            END IF;

            IF p_order_type = 'Reservation' THEN
            -- Check if customer has a reservation
                SELECT
                    COUNT(*)
                INTO v_order_count
                FROM
                    reservations
                WHERE
                        customer_id = p_customer_id
                    AND reservation_date = trunc(sysdate)
                    AND reservation_status = 'Confirmed';

                IF v_order_count = 0 THEN
                -- No reservation found, display message and return 0
                    dbms_output.put_line('Oops! You do not have a reservation for today.');
                    RETURN 0;
                END IF;
            END IF;

            -- Check if there is an open order for the customer with the same order type
            SELECT
                COUNT(*)
            INTO v_order_count
            FROM
                orders
            WHERE
                    customer_id = p_customer_id
                AND trunc(order_date) = trunc(sysdate)
                AND order_type = p_order_type
                AND order_status IN ( 'Pending', 'Processing' );

            IF v_order_count = 0 THEN
                -- No open order, generate new order ID and insert new order
                dbms_output.put_line('NEW ORDER');
                -- Generate order ID using sequence
                SELECT
                    order_id_seq.NEXTVAL
                INTO v_order_id
                FROM
                    dual;
    
                -- Assign an employee to the order based on the least number of assigned orders
                SELECT
                    employee_id
                INTO v_employee_id
                FROM
                    (
                        SELECT
                            e.employee_id,
                            COUNT(o.employee_id) AS order_count
                        FROM
                            employees e
                            LEFT JOIN orders    o ON e.employee_id = o.employee_id
                        GROUP BY
                            e.employee_id
                        ORDER BY
                            COUNT(o.employee_id)
                    )
                WHERE
                    ROWNUM = 1;
    
                -- Insert the order into the Orders table with status as "Pending" and the assigned employee
                INSERT INTO orders (
                    order_id,
                    order_date,
                    order_type,
                    order_status,
                    employee_id,
                    customer_id
                ) VALUES (
                    v_order_id,
                    sysdate,
                    p_order_type,
                    'Pending',
                    v_employee_id,
                    p_customer_id
                );

            ELSE
                -- There is an open order, retrieve the order ID
                SELECT
                    order_id
                INTO v_order_id
                FROM
                    orders
                WHERE
                        customer_id = p_customer_id
                    AND trunc(order_date) = trunc(sysdate)
                    AND order_type = p_order_type
                    AND order_status IN ( 'Pending', 'Processing' );
                    
                -- Update the order status to "Pending"
                UPDATE orders
                SET
                    order_status = 'Pending'
                WHERE
                    order_id = v_order_id;

            END IF;
            
            
    
            -- Parse selected items and insert into Order_Detail table
            FOR item IN (
                SELECT
                    regexp_substr(v_selected_items, '[^,]+', 1, level) AS selected_item
                FROM
                    dual
                CONNECT BY
                    regexp_substr(v_selected_items, '[^,]+', 1, level) IS NOT NULL
            ) LOOP
                -- Parse selected item details (item_name-quantity)
                DECLARE
                    v_item_name  VARCHAR2(100);
                    v_quantity   NUMBER;
                    v_item_id    NUMBER;
                    v_item_price NUMBER;
                    v_item_count NUMBER;
                BEGIN
                    -- selected items format: "item_name1-quantity1, item_name2-quantity2, ..."
                    v_item_name := trim(regexp_substr(item.selected_item, '[^-]+', 1, 1));

                    v_quantity := TO_NUMBER ( regexp_substr(item.selected_item, '[^-]+', 1, 2) );
    
                    -- Check if item name exists
                    SELECT
                        COUNT(*)
                    INTO v_item_count
                    FROM
                        items
                    WHERE
                        item_name = v_item_name;

                    IF v_item_count = 0 THEN
                        raise_application_error(-20003, 'Invalid item name: ' || v_item_name);
                    END IF;
    
                    -- Retrieve item ID and price
                    SELECT
                        item_id,
                        item_price
                    INTO
                        v_item_id,
                        v_item_price
                    FROM
                        items
                    WHERE
                        item_name = v_item_name;
    
                    -- Check if quantity is specified
                    IF v_quantity IS NULL THEN
                        raise_application_error(-20004, 'Quantity not specified for item: ' || v_item_name);
                    END IF;
    
                    -- Check if the item is already in the order_details for this order
                    SELECT
                        COUNT(*)
                    INTO v_item_count
                    FROM
                        order_details
                    WHERE
                            order_id = v_order_id
                        AND item_id = v_item_id;

                    IF v_item_count > 0 THEN
                        -- Item already exists in the order, update quantity
                        UPDATE order_details
                        SET
                            quantity = quantity + v_quantity
                        WHERE
                                order_id = v_order_id
                            AND item_id = v_item_id;

                    ELSE
                        -- Item doesn't exist in the order, insert into order_details
                        INSERT INTO order_details (
                            order_id,
                            item_id,
                            price_per_item,
                            quantity
                        ) VALUES (
                            v_order_id,
                            v_item_id,
                            v_item_price,
                            v_quantity
                        );

                    END IF;

                EXCEPTION
                    WHEN OTHERS THEN
                        -- Handle other exceptions
                        IF sqlcode = -20003 THEN
                            -- Invalid item name error
                            dbms_output.put_line('Error: Invalid item name: ' || v_item_name);
                            -- Continue to the next item in the loop
                            CONTINUE;
                        ELSE
                            -- Handle other exceptions
                            dbms_output.put_line('Error: ' || sqlerrm);
                            -- Optionally, handle the error in a different way
                            -- Reraise the exception
                            RAISE;
                        END IF;
                END;
            END LOOP;
    
            -- Commit the transaction
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || sqlerrm);
                -- Rollback the transaction if an error occurs
                ROLLBACK;
        END;
    
        -- Return the order ID
        RETURN v_order_id;
    END placeorderforfood;
    
    /*
    This procedure prepares dishes for an order by updating inventory and order status.
    
    Input:
    - P_ORDER_ID: The ID of the order for which dishes are to be prepared.
    
    Exceptions:
    - NO_DATA_FOUND: Raised if the specified order ID is not found.
    - OTHERS: Handles any other exceptions and raises an error.
    */
    PROCEDURE preparedishesfororder (
        p_order_id IN NUMBER
    ) AS

        v_order_status    VARCHAR2(20);
        v_remaining_items NUMBER;
        v_item_name       VARCHAR2(100);
        v_quantity        NUMBER;
        v_item_id         NUMBER; -- Declare item_id here
    BEGIN
        -- Check if the order exists
        SELECT
            order_status
        INTO v_order_status
        FROM
            orders
        WHERE
            order_id = p_order_id;
    
        -- Check if the order status is valid for preparing dishes
        IF v_order_status = 'Pending' THEN
            -- Update the order status to 'Processing' as the kitchen crew starts working on it
            UPDATE orders
            SET
                order_status = 'Processing'
            WHERE
                order_id = p_order_id;
            
            -- Update inventory for all items associated with the order ID
            FOR item IN (
                SELECT
                    o.quantity   AS order_quantity,
                    i.item_name,
                    inv.quantity AS inventory_quantity,
                    i.item_id -- Include item_id
                FROM
                         order_details o
                    JOIN items     i ON o.item_id = i.item_id
                    JOIN inventory inv ON i.item_id = inv.item_id
                WHERE
                    o.order_id = p_order_id
            ) LOOP
                -- Fetch values from the loop variables
                v_item_name := item.item_name;
                v_quantity := item.order_quantity;
                v_item_id := item.item_id; -- Assign item_id
                
                -- Check if the quantity is positive
                IF v_quantity <= 0 THEN
                    dbms_output.put_line('Refill the stock with ' || v_item_name);
                ELSE
                    -- Update inventory table
                    UPDATE inventory
                    SET
                        quantity = quantity - item.order_quantity
                    WHERE
                        item_id = v_item_id; -- Use v_item_id
                    -- Commit the transaction
                    COMMIT;
                    dbms_output.put_line('Cooking in progress.');
                END IF;

            END LOOP;
    
            -- DBMS output stating the work is done
            dbms_output.put_line('All dishes for Order '
                                 || p_order_id
                                 || ' are in preparation.');
        ELSE
            raise_application_error(-20001, 'Cannot prepare dishes for order '
                                            || p_order_id
                                            || '. Order status is not Pending.');
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20002, 'Order ID '
                                            || p_order_id
                                            || ' not found.');
        WHEN OTHERS THEN
            -- Handle exceptions if any
            dbms_output.put_line('Error occurred while preparing dishes: ' || sqlerrm);
            ROLLBACK; -- Rollback the transaction
    END preparedishesfororder;


    /*
    This function calculates the total amount due and itemized costs for a given order.
    
    Input Parameters:
    - p_order_id: The ID of the order for which the total amount due is calculated.
    
    Output:
    - Total Amount Due: The total amount due for the specified order, including item costs, taxes, and any additional charges.
    
    Purpose:
    Calculate the total amount due for the specified order, including item costs, taxes, and any additional charges.
    */
    FUNCTION calculatetotalamountdue (
        p_order_id IN NUMBER
    ) RETURN NUMBER AS
        v_total_amount NUMBER := 0;
    BEGIN
            -- Calculate itemized costs for the specified order
        SELECT
            SUM(od.quantity * od.price_per_item)
        INTO v_total_amount
        FROM
            order_details od
        WHERE
            od.order_id = p_order_id;

        dbms_output.put_line('Total amount due for order '
                             || p_order_id
                             || ': $'
                             || v_total_amount);
            
            -- Update the orders table with the total amount due
        UPDATE orders
        SET
            order_amount = v_total_amount
        WHERE
            order_id = p_order_id;
            
            -- Commit the transaction
        COMMIT;
        
            -- Return the total amount due
        RETURN v_total_amount;
    EXCEPTION
        WHEN OTHERS THEN
                -- Rollback the transaction if an error occurs
            ROLLBACK;
            RAISE;
    END calculatetotalamountdue;
    
    /*
    This stored procedure updates the status of an order in the 'Orders' table to indicate that it has been provided to the kitchen crew.
    
    Input:
    - p_order_id: The ID of the order to be updated.
    
    Exceptions:
    - NO_DATA_FOUND: Raised if the specified order ID is not found.
    - OTHERS: Handles any other exceptions and raises an error indicating that an error occurred while updating the order status.
    */

    PROCEDURE updateorderstatus (
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
    
    
    /*
    This procedure processes payments for orders, updating payment information in the Payments table and the status of the order in the Orders table. 
    It also calculates and returns change if the payment amount exceeds the total amount due.
    */
    PROCEDURE processpayment (
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
    
    /*
    This procedure updates the status of an order in the 'Orders' table to indicate that it has been cancelled.
    
    Input:
    - p_order_id: The ID of the order to be cancelled.
    
    Exceptions:
    - NO_DATA_FOUND: Raised if the specified order ID is not found.
    - OTHERS: Handles any other exceptions and raises an error indicating that an error occurred while cancelling the order.
    */
    PROCEDURE cancelorder (
        p_order_id IN NUMBER
    ) AS
        v_order_status VARCHAR2(20);
    BEGIN
            -- Check if the order exists and retrieve its status
        SELECT
            order_status
        INTO v_order_status
        FROM
            orders
        WHERE
            order_id = p_order_id;
            
            -- Check if the order status allows cancellation
        IF v_order_status = 'Pending' THEN
                -- Update the order status to 'Cancelled'
            UPDATE orders
            SET
                order_status = 'Cancelled'
            WHERE
                order_id = p_order_id;

            COMMIT;
            dbms_output.put_line('Order with ID '
                                 || p_order_id
                                 || ' has been successfully cancelled.');
        ELSE
        -- Custom message for order status other than 'Pending'
            dbms_output.put_line('Cannot cancel order. Order with ID '
                                 || p_order_id
                                 || ' is already '
                                 || v_order_status);
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            raise_application_error(-20005, 'Order ID '
                                            || p_order_id
                                            || ' not found.');
        WHEN OTHERS THEN
                -- Handle any other exceptions
            ROLLBACK;
            raise_application_error(-20006, 'Error cancelling order: ' || sqlerrm);
    END cancelorder;
    
    /*
    This procedure updates the status of an order in the 'Orders' table to indicate that it has been provided to the kitchen crew.
    
    Input:
    - p_order_id: The ID of the order to be updated.
    
    Exceptions:
    - NO_DATA_FOUND: Raised if the specified order ID is not found.
    - OTHERS: Handles any other exceptions and raises an error indicating that an error occurred while updating the order status.
    */
    PROCEDURE trackorderprogress (
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

END ordermanagement;
/