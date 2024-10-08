set serveroutput on;
--Execution of create_customer
BEGIN
  user_management.create_customer(
    p_phone_number => '1234554321',
    p_street => '131 Washington St',
    p_city => 'Boston',
    p_state => 'Massachusetts',
    p_zip => '02456',
    p_country => 'United States'
  );
END;
/

---New customer with ID 228 created successfully.

--Execution of delete_customer
EXEC user_management.delete_customer(207); 

select * from items;
insert into items
values(11,'PIZZA',25,'INV-2024200');

select * from inventory;


select * from orders order by 2 desc;
select * from order_details ;


select * from inventory; --where item_id=11;

select * from items;
insert into inventory
values('INV-2024200',50,'09-Apr-2024',11)
SELECT
                o.quantity,
                o.item_id,
                i.invoice_id,
                i.item_name
                --inv.quantity
            FROM
                     order_details o
                JOIN items     i ON o.item_id = i.item_id
                --JOIN inventory inv ON i.item_id = inv.item_id
            WHERE
                o.order_id = 18;