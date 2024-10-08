DECLARE
  ITEM_ID NUMBER;
  v_Return VARCHAR2(200);
BEGIN
  ITEM_ID := NULL;

  v_Return := INVENTORYMANAGEMENT.REFILLSTOCK(
    ITEM_ID => ITEM_ID
  );
  /* Legacy output: 
DBMS_OUTPUT.PUT_LINE('v_Return = ' || v_Return);
*/ 
  :v_Return := v_Return;
--rollback; 
END;
