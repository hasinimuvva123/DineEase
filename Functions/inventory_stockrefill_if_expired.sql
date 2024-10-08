CREATE OR REPLACE FUNCTION RefillStock(Item_ID IN NUMBER) RETURN VARCHAR2 IS
    v_current_status VARCHAR2(10);
    v_current_quantity NUMBER;
BEGIN
    -- Retrieve the current status and quantity of the item
    SELECT Item_Status, Quantity INTO v_current_status, v_current_quantity
    FROM Inventory
    WHERE Item_ID = RefillStock.Item_ID;

    -- Check if the item status is 'expired' and quantity is less than 20
    IF v_current_status = 'expired' AND v_current_quantity < 20 THEN
        -- Refill stock by adding 23 to the quantity (3 for expiration and 20 for low quantity) and updating the status
        UPDATE Inventory
        SET Quantity = v_current_quantity + 23,
            Item_Status = 'FRESH',
            Date_of_Purchase = SYSDATE
        WHERE Item_ID = RefillStock.Item_ID;

        -- Return a message indicating the stock refill
        RETURN 'Stock for item ' || Item_ID || ' has been automatically refilled and updated.';
    END IF;

    -- Check if the item status is 'expired'
    IF v_current_status = 'expired' THEN
        -- Refill stock by adding 3 to the quantity and updating the status
        UPDATE Inventory
        SET Quantity = v_current_quantity + 3,
            Item_Status = 'FRESH',
            Date_of_Purchase = SYSDATE
        WHERE Item_ID = RefillStock.Item_ID;

        -- Return a message indicating the stock refill
        RETURN 'Stock for item ' || Item_ID || ' has been automatically refilled and updated.';
    END IF;

    -- Check if the quantity is below a certain threshold (e.g., 20)
    IF v_current_quantity < 20 THEN
        -- Refill stock by adding 20 to the quantity and updating the date of purchase
        UPDATE Inventory
        SET Quantity = v_current_quantity + 20,
            Item_Status = 'FRESH',
            Date_of_Purchase = SYSDATE
        WHERE Item_ID = RefillStock.Item_ID;

        -- Return a message indicating the stock update
        RETURN 'Stock for item ' || Item_ID || ' has been updated to maintain sufficient quantity.';
    END IF;

    -- If neither condition is met, return a message indicating that no refill is needed
    RETURN 'Stock for item ' || Item_ID || ' is sufficient. No refill needed.';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle the case when the item with the specified ID does not exist
        RETURN 'Item with ID ' || Item_ID || ' not found in inventory.';
END;
/
--execution of refill stock
DECLARE
    v_message VARCHAR2(100);
BEGIN
    v_message := RefillStock(6); -- Replace 123 with the actual Item_ID
    DBMS_OUTPUT.PUT_LINE(v_message);
END;
/
commit;

select * from inventory;