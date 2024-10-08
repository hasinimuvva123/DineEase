--select * from customers;
--select * from orders order by 2 desc;
--select * from order_details order by 1 desc ;
--select * from items;

set serveroutput on;
-- Execute the placeorderforfood function
DECLARE
    v_order_id NUMBER;
BEGIN
    v_order_id := ordermanagement.placeorderforfood(p_customer_id => 228, p_order_type => 'Dine-in', --'Reservation', 'Dine-in', 'Delivery', 'Walk-in', 'Online' 
     p_selected_items => 'panipuri-1' -- Specify the selected items in the format 'item_name-quantity', also can list more items with comma ","
    );
    -- Output the order ID
    dbms_output.put_line('Order ID: ' || v_order_id);
END;
/

set serveroutput on;
-- Execute the preparedishesfororder procedure
BEGIN
    ordermanagement.preparedishesfororder(p_order_id => 21); -- Specify the order ID
END;
/

-- Execute the calculatetotalamountdue function
DECLARE
    v_total_amount NUMBER;
BEGIN
    v_total_amount := ordermanagement.calculatetotalamountdue(p_order_id => 21); -- Specify the order ID
END;
/

-- Execute the updateorderstatus procedure
BEGIN
    ordermanagement.updateorderstatus(p_order_id => 21, -- Specify the order ID
     p_new_status => 'Payment Due' -- Specify the new status as 'Payment Due'
    );
END;
/

--select * from orders order by 1 desc;

-- Execute the processpayment procedure
DECLARE
    v_change NUMBER;
BEGIN
    ordermanagement.processpayment(p_order_id => 17, -- Specify the order ID
     p_payment_amount => 100, -- Specify the payment amount
     p_payment_method => 'Cash', -- Specify the payment method
     p_payment_status => 'Paid', -- Specify the payment status
     p_change => v_change -- Output parameter for change
    );

    dbms_output.put_line('Change: ' || v_change);
END;
/

-- Execute the trackorderprogress procedure
BEGIN
    ordermanagement.trackorderprogress(p_order_id => 17); -- Specify the order ID
END;
/

-- Execute the cancel order procedure
BEGIN
    ordermanagement.cancelorder(p_order_id => 17); -- Specify the order ID
END;
/