-- Create Current Inventory Status View
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if the view exists
    SELECT COUNT(*)
    INTO v_count
    FROM user_views
    WHERE view_name = 'CURRENT_INVENTORY_STATUS';

    -- Drop the view if it exists
    IF v_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP VIEW CURRENT_INVENTORY_STATUS';
    END IF;

    -- Recreate the view
    EXECUTE IMMEDIATE '
    CREATE VIEW CURRENT_INVENTORY_STATUS AS
    SELECT iv.item_id,i.item_name,iv.quantity
    FROM inventory iv JOIN items i on iv.item_id=i.item_id';
    
    
END;
/

