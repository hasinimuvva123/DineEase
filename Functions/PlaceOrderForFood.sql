/**
 * This function enables customers to place orders for food items by specifying the item names and quantities.
 * It takes the following input parameters:
 * - p_customer_id: The ID of the customer placing the order.
 * - p_order_type: The type of the order, which can be one of the following: 'Reservation', 'Dine-in', 'Delivery', 'Walk-in'.
 * - p_selected_items: A string containing selected items and their quantities in the format "item_name-quantity".
 * 
 * For each selected item, the function retrieves the item ID and price based on the provided item name from the 'items' table.
 * It then inserts the items into the 'Order_details' table with the specified quantity, associated with the customer's ID and order type, with a pending status.
 * An employee is randomly assigned to handle the order.
 * The function returns the order ID.
 */
 
CREATE OR REPLACE FUNCTION PlaceOrderForFood (
    p_customer_id IN NUMBER,
    p_order_type IN VARCHAR2,
    p_selected_items IN VARCHAR2
) RETURN NUMBER AS
    v_order_id NUMBER;
    v_employee_id NUMBER;
    v_customer_count NUMBER;
BEGIN
    -- Begin transaction
    BEGIN
        -- Check if customer ID exists
        SELECT COUNT(*) INTO v_customer_count
        FROM Customers
        WHERE customer_id = p_customer_id;

        IF v_customer_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20101, 'Customer does not exist.');
        END IF;

        -- Check if order type is valid
        IF p_order_type NOT IN ('Reservation', 'Dine-in', 'Delivery', 'Walk-in') THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid order type. Please select from: "Reservation", "Dine-in", "Delivery", "Walk-in".' );
        END IF;

        -- Generate order ID using sequence
        SELECT order_id_seq.NEXTVAL INTO v_order_id FROM DUAL;

         -- Assign an employee to the order based on the least number of assigned orders
        SELECT employee_id INTO v_employee_id
        FROM (
            SELECT e.employee_id, COUNT(o.employee_id) AS order_count
            FROM employees e
            LEFT JOIN orders o ON e.employee_id = o.employee_id
            GROUP BY e.employee_id
            ORDER BY COUNT(o.employee_id)
        )
        WHERE ROWNUM = 1;

        -- Insert the order into the Orders table with status as "Pending" and the assigned employee
        INSERT INTO Orders (order_id, order_date, order_type, order_status, employee_id, customer_id)
        VALUES (v_order_id, SYSDATE, p_order_type, 'Pending', v_employee_id, p_customer_id);

        -- Parse selected items and insert into Order_Detail table
        FOR item IN (
            SELECT regexp_substr(p_selected_items, '[^,]+', 1, level) AS selected_item
            FROM dual
            CONNECT BY regexp_substr(p_selected_items, '[^,]+', 1, level) IS NOT NULL
        ) LOOP
            -- Parse selected item details (item_name-quantity)
            DECLARE
                v_item_name VARCHAR2(100);
                v_quantity NUMBER;
                v_item_id NUMBER;
                v_item_price NUMBER;
                v_item_count NUMBER;
            BEGIN
                -- Assuming selected items format: "item_name1-quantity1, item_name2-quantity2, ..."
                v_item_name := TRIM(REGEXP_SUBSTR(item.selected_item, '[^-]+', 1, 1));
                v_quantity := TO_NUMBER(REGEXP_SUBSTR(item.selected_item, '[^-]+', 1, 2));

                -- Check if item name exists
                SELECT COUNT(*) INTO v_item_count
                FROM items
                WHERE item_name = v_item_name;

                IF v_item_count = 0 THEN
                    RAISE_APPLICATION_ERROR(-20003, 'Invalid item name: ' || v_item_name);
                END IF;

                -- Retrieve item ID and price
                SELECT item_id, item_price INTO v_item_id, v_item_price
                FROM items
                WHERE item_name = v_item_name;

                -- Check if quantity is specified
                IF v_quantity IS NULL THEN
                    RAISE_APPLICATION_ERROR(-20004, 'Quantity not specified for item: ' || v_item_name);
                END IF;

                -- Insert into Order_Detail table
                INSERT INTO Order_Details (order_id, item_id, quantity, price_per_item, item_count)
                VALUES (v_order_id, v_item_id, v_quantity, v_item_price, v_quantity * v_item_price);
            EXCEPTION
                WHEN OTHERS THEN
                    RAISE;
            END;
        END LOOP;
        -- Commit the transaction
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback the transaction if an error occurs
            ROLLBACK;
            RAISE;
    END;

    -- Return the order ID
    RETURN v_order_id;
END;
/


/**Execute the function*/
set serveroutput on;

DECLARE
    v_order_id NUMBER;
BEGIN
    -- Call the function PlaceOrderForFood with the required parameters
    v_order_id := PlaceOrderForFood(
                    p_customer_id => 201,
                    p_order_type => 'Dine-in',
                    p_selected_items => 'Biryani-1, burito-3' -- Specify the selected items in the format 'item_name-quantity'
                );
    -- Output the order ID
    DBMS_OUTPUT.PUT_LINE('Order ID: ' || v_order_id);
END;
/

