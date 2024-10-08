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
    CREATE OR REPLACE FUNCTION placeorderforfood (
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
                dbms_output.put_line('Customer does not exist.');
              -- raise_application_error(-20101, 'Customer does not exist.');
               RETURN 0;
            END IF;
    
            -- Check if order type is valid
            IF p_order_type NOT IN ( 'Reservation', 'Dine-in', 'Delivery', 'Walk-in', 'Online' ) THEN
                dbms_output.put_line('Invalid order type. Please select from: "Reservation", "Dine-in", "Delivery", "Walk-in", "Online".');
                --raise_application_error(-20002, 'Invalid order type. Please select from: "Reservation", "Dine-in", "Delivery", "Walk-in", "Online".');
                 RETURN 0;
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
                        dbms_output.put_line('Quantity not specified for item: ' || v_item_name);
                        --raise_application_error(-20004, 'Quantity not specified for item: ' || v_item_name);
                        return 0;
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
                            dbms_output.put_line('Invalid item name: ' || v_item_name || 'Please check our menu');
                            RETURN 0; 
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
    /
    
    
    
    
-- Execute the placeorderforfood function   
set serveroutput on;
    
DECLARE
    v_order_id NUMBER;
BEGIN
    v_order_id := placeorderforfood(p_customer_id => 228, p_order_type => 'Dine-in', --'Reservation', 'Dine-in', 'Delivery', 'Walk-in', 'Online' 
     p_selected_items => 'panipuri-1' -- Specify the selected items in the format 'item_name-quantity', also can list more items with comma ","
    );
    -- Output the order ID
    dbms_output.put_line('Order ID: ' || v_order_id);
END;
/

--select * from customers;
--select * from orders order by 2 desc;
--select * from order_details order by 1 desc ;
--select * from items;

--SELECT *
--FROM ALL_OBJECTS
--WHERE OBJECT_TYPE = 'PACKAGE' AND OWNER='RESTAURANT_ADMIN';