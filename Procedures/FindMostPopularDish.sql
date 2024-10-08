CREATE OR REPLACE PROCEDURE FindMostPopularDish(
    p_start_date IN DATE,
    p_end_date   IN DATE
) AS
    v_item_id    ITEMS.item_id%TYPE;
    v_item_name  ITEMS.item_name%TYPE;
    v_total_orders NUMBER;
BEGIN
    SELECT item_id, item_name, COUNT(*) INTO v_item_id, v_item_name, v_total_orders
    FROM (
        SELECT od.item_id, i.item_name
        FROM Payments p
        JOIN ORDER_DETAILS od ON p.order_id = od.order_id
        JOIN ITEMS i ON od.item_id = i.item_id
        WHERE TRUNC(p.payment_date) BETWEEN TRUNC(p_start_date) AND TRUNC(p_end_date)
    )
    GROUP BY item_id, item_name
    ORDER BY COUNT(*) DESC
    FETCH FIRST 1 ROW ONLY;
 
    DBMS_OUTPUT.PUT_LINE('The most popular dish between ' || TO_CHAR(p_start_date, 'DD-MON-YYYY') || ' and ' || TO_CHAR(p_end_date, 'DD-MON-YYYY') || ' was: ' || v_item_name || ' with ' || v_total_orders || ' orders.');
END FindMostPopularDish;
/


BEGIN
    FindMostPopularDish(TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-01-31', 'YYYY-MM-DD'));
END;
/







