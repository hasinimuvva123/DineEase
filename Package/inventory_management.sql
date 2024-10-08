CREATE OR REPLACE PACKAGE InventoryManagement AS
    FUNCTION RefillStock(Item_ID IN NUMBER) RETURN VARCHAR2;
END InventoryManagement;
/
