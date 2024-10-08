CREATE OR REPLACE PACKAGE ordermanagement AS

    FUNCTION placeorderforfood (
        p_customer_id    IN NUMBER,
        p_order_type     IN VARCHAR2,
        p_selected_items IN VARCHAR2
    ) RETURN NUMBER;

    PROCEDURE preparedishesfororder (
        p_order_id IN NUMBER
    );

    FUNCTION calculatetotalamountdue (
        p_order_id IN NUMBER
    ) RETURN NUMBER;

    PROCEDURE updateorderstatus (
        p_order_id   IN NUMBER,
        p_new_status IN VARCHAR2
    );

    PROCEDURE cancelorder (
        p_order_id IN NUMBER
    );

    PROCEDURE trackorderprogress (
        p_order_id IN NUMBER
    );

    PROCEDURE processpayment (
        p_order_id       IN NUMBER,
        p_payment_amount IN NUMBER,
        p_payment_method IN VARCHAR2,
        p_payment_status IN VARCHAR2,
        p_change         OUT NUMBER
    );

END ordermanagement;
/