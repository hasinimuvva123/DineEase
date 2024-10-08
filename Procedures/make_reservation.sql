CREATE OR REPLACE PROCEDURE make_reservation (
    p_customer_id IN reservations.customer_id%TYPE,
    p_reservation_date IN reservations.reservation_date%TYPE
)
AS
    v_reservation_id reservations.reservation_id%TYPE;
BEGIN
    -- Generate a unique reservation ID
    SELECT MAX(reservation_id) + 1 INTO v_reservation_id FROM reservations;

    -- Insert the new reservation into the reservations table
    INSERT INTO reservations (reservation_id, reservation_date, reservation_time, reservation_status, customer_id)
    VALUES (v_reservation_id, p_reservation_date, SYSDATE,'Confirmed', p_customer_id);

    -- Update the customer table with the reservation ID
    UPDATE customers
    SET reservation_id = v_reservation_id
    WHERE customer_id = p_customer_id;

    -- Commit the transaction
    COMMIT;
    
    -- Output success message
    DBMS_OUTPUT.PUT_LINE('Reservation successfully made with ID: ' || v_reservation_id);
EXCEPTION
    WHEN OTHERS THEN
        -- Output error message
        DBMS_OUTPUT.PUT_LINE('Error making reservation: ' || SQLERRM);
END;
/

---Execute the procedure

BEGIN
    make_reservation(p_customer_id => 207, p_reservation_date => TO_DATE('2024-04-12', 'YYYY-MM-DD'));
END;
/
