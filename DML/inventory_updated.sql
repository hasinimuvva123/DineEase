select * from inventory;
UPDATE inventory
SET QUANTITY = 
    CASE 
        WHEN QUANTITY < 0 THEN 0
        ELSE QUANTITY
    END,
    ITEM_STATUS = 
    CASE 
        WHEN DATE_OF_PURCHASE < (SYSDATE - 5) THEN 'expired'
        ELSE 'fresh'
    END;   
commit;



