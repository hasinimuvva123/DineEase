CREATE OR REPLACE PROCEDURE preparedishesfororder (
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
        dbms_output.put_line('Cannot prepare dishes for order '
                                        || p_order_id
                                        || '. Order status is not Pending.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Order ID '
                             || p_order_id
                             || ' not found.');
    WHEN OTHERS THEN
        -- Handle exceptions if any
        dbms_output.put_line('Error occurred while preparing dishes: ' || sqlerrm);
        ROLLBACK; -- Rollback the transaction
END preparedishesfororder;
/

--EXECUTION
set serveroutput on;
-- Execute the preparedishesfororder procedure
BEGIN
    preparedishesfororder(p_order_id => 21); -- Specify the order ID
END;
/