GRANT MANAGER_ROLE TO RESTAURANT_MANAGER;
GRANT CUSTOMER_ROLE TO RESTAURANT_CUSTOMER;
GRANT KITCHEN_CREW_ROLE TO RESTAURANT_KITCHENCREW;
GRANT CASHIER_ROLE TO RESTAURANT_CASHIER;
GRANT SERVICE_CREW_ROLE TO RESTAURANT_SERVICECREW;

----------------PLACE ORDER---------------
-- Grant execute permission to the MANAGER role
GRANT EXECUTE ON placeorderforfood TO MANAGER_ROLE;

-- Grant execute permission to the CUSTOMER role
GRANT EXECUTE ON placeorderforfood TO CUSTOMER_ROLE;

----------------PREPARE FOOD---------------
-- Grant execute permission to the MANAGER role
GRANT EXECUTE ON preparedishesfororder TO MANAGER_ROLE;

-- Grant execute permission to the KITCHEN_CREW role
GRANT EXECUTE ON preparedishesfororder TO KITCHEN_CREW_ROLE;

----------------CALCULATE TOTAL AMOUNT DUE---------------
-- Grant execute permission to the MANAGER role
GRANT EXECUTE ON calculatetotalamountdue TO MANAGER_ROLE;

-- Grant execute permission to the CASHIER role
GRANT EXECUTE ON calculatetotalamountdue TO CASHIER_ROLE;


----------------UPDATE ORDER STATUS---------------
-- Grant execute permission to the MANAGER role
GRANT EXECUTE ON updateorderstatus TO MANAGER_ROLE;

-- Grant execute permission to the SERVICE_CREW role
GRANT EXECUTE ON updateorderstatus TO SERVICE_CREW_ROLE;

----------------PROCESS PAYMENT---------------
-- Grant execute permission to the MANAGER role
GRANT EXECUTE ON processpayment TO MANAGER_ROLE;

-- Grant execute permission to the CASHIER role
GRANT EXECUTE ON processpayment TO CASHIER_ROLE;

------------------CANCEL ORDER----------------
-- Grant execute permission to the CUSTOMER role
GRANT EXECUTE ON cancelorder TO CUSTOMER_ROLE;

-- Grant execute permission to the MANAGER role
GRANT EXECUTE ON cancelorder TO MANAGER_ROLE;

-- Grant execute permission to the SERVICE_CREW role
GRANT EXECUTE ON cancelorder TO SERVICE_CREW_ROLE;

------------------TRACK ORDER----------------
-- Grant execute permission to the MANAGER role
GRANT EXECUTE ON trackorderprogress TO MANAGER_ROLE;

-- Grant execute permission to the SERVICE_CREW role
GRANT EXECUTE ON trackorderprogress TO SERVICE_CREW_ROLE;

-- Grant execute permission to the CASHIER role
GRANT EXECUTE ON trackorderprogress TO CASHIER_ROLE;

-- Grant execute permission to the CASHIER role
GRANT EXECUTE ON trackorderprogress TO CUSTOMER_ROLE;


--SYNONYMS:
CREATE PUBLIC SYNONYM cust FOR restaurant_admin.customers;
CREATE PUBLIC SYNONYM ordr FOR restaurant_admin.orders;
CREATE PUBLIC SYNONYM ordr_det FOR restaurant_admin.order_details;
CREATE PUBLIC SYNONYM itm FOR restaurant_admin.items;
CREATE PUBLIC SYNONYM inv FOR restaurant_admin.inventory;

GRANT SELECT ON cust TO customer_role;
GRANT SELECT ON ordr TO kitchen_crew_role;




