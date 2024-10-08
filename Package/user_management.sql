
CREATE OR REPLACE PACKAGE user_management AS

  -- Procedure to create a new customer

  PROCEDURE create_customer(

    p_phone_number IN VARCHAR2,

    p_street IN VARCHAR2,

    p_city IN VARCHAR2,

    p_state IN VARCHAR2,

    p_zip IN VARCHAR2,

    p_country IN VARCHAR2,

    p_reservation_id IN NUMBER DEFAULT NULL

  );

  -- Procedure to delete a customer

  PROCEDURE delete_customer(

    p_customer_id IN NUMBER

  );

  -- Procedure to update customer phone number and address

  PROCEDURE update_customer_details(

    p_customer_id IN NUMBER,

    p_phone_number IN VARCHAR2,

    p_street IN VARCHAR2,

    p_city IN VARCHAR2,

    p_state IN VARCHAR2,

    p_zip IN VARCHAR2,

    p_country IN VARCHAR2

  );

END user_management;
 
CREATE OR REPLACE PACKAGE BODY user_management AS
 
  -- Procedure to create a new customer
 
  PROCEDURE create_customer(
 
    p_phone_number IN VARCHAR2,
 
    p_street IN VARCHAR2,
 
    p_city IN VARCHAR2,
 
    p_state IN VARCHAR2,
 
    p_zip IN VARCHAR2,
 
    p_country IN VARCHAR2,
 
    p_reservation_id IN NUMBER DEFAULT NULL
 
  ) AS
 
    l_customer_id NUMBER;
 
  BEGIN
 
    -- Check if the customer already exists based on phone number
 
    BEGIN
 
      SELECT customer_id INTO l_customer_id
 
      FROM Customers
 
      WHERE phone_number = p_phone_number;

      -- If customer already exists, inform the user and exit
 
      DBMS_OUTPUT.PUT_LINE('Customer already exists with ID ' || l_customer_id);
 
      RETURN;
 
    EXCEPTION
 
      WHEN NO_DATA_FOUND THEN
 
        -- Continue to create a new customer
 
        NULL;
 
    END;

    -- Generate the next value for customer_id using the sequence
 
    SELECT customer_id_seq.NEXTVAL INTO l_customer_id FROM DUAL;

    -- Insert the new customer into the Customers table
 
    INSERT INTO Customers (customer_id, phone_number, reservation_id, street, city, state, zip, country)
 
    VALUES (l_customer_id, p_phone_number, NVL(p_reservation_id, -1), p_street, p_city, p_state, p_zip, p_country);

    -- Commit the transaction
 
    COMMIT;

    -- Print a success message
 
    DBMS_OUTPUT.PUT_LINE('New customer with ID ' || l_customer_id || ' created successfully.');
 
  EXCEPTION
 
    WHEN OTHERS THEN
 
        -- Print an error message if an exception occurs
 
        DBMS_OUTPUT.PUT_LINE('Error creating customer: ' || SQLERRM);
 
  END create_customer;

  -- Procedure to delete a customer
 
  PROCEDURE delete_customer(
 
    p_customer_id IN NUMBER
 
  ) AS
 
  BEGIN
 
    -- Delete the customer with the specified customer_id
 
    BEGIN
 
      DELETE FROM Customers
 
      WHERE customer_id = p_customer_id;

      -- Commit the transaction
 
      COMMIT;

      -- Print a success message
 
      DBMS_OUTPUT.PUT_LINE('Customer with ID ' || p_customer_id || ' deleted successfully.');
 
    EXCEPTION
 
      WHEN NO_DATA_FOUND THEN
 
          -- Handle the case when no customer with the specified ID is found
 
          DBMS_OUTPUT.PUT_LINE('Customer with ID ' || p_customer_id || ' not found.');
 
      WHEN OTHERS THEN
 
          -- Print an error message if an exception occurs
 
          IF SQLCODE = -2292 THEN
 
            DBMS_OUTPUT.PUT_LINE('Error deleting customer: Child records found.');
 
          ELSE
 
            DBMS_OUTPUT.PUT_LINE('Error deleting customer: ' || SQLERRM);
 
          END IF;
 
    END;
 
  END delete_customer;

  -- Procedure to update customer phone number and address
 
  PROCEDURE update_customer_details(
 
    p_customer_id IN NUMBER,
 
    p_phone_number IN VARCHAR2,
 
    p_street IN VARCHAR2,
 
    p_city IN VARCHAR2,
 
    p_state IN VARCHAR2,
 
    p_zip IN VARCHAR2,
 
    p_country IN VARCHAR2
 
  ) AS
 
  BEGIN
 
    -- Update the customer details
 
    UPDATE Customers
 
    SET phone_number = p_phone_number,
 
        street = p_street,
 
        city = p_city,
 
        state = p_state,
 
        zip = p_zip,
 
        country = p_country
 
    WHERE customer_id = p_customer_id;

    -- Commit the transaction
 
    COMMIT;

    -- Print a success message
 
    DBMS_OUTPUT.PUT_LINE('Customer with ID ' || p_customer_id || ' details updated successfully.');
 
  EXCEPTION
 
    WHEN NO_DATA_FOUND THEN
 
        -- Handle the case when no customer with the specified ID is found
 
        DBMS_OUTPUT.PUT_LINE('Customer with ID ' || p_customer_id || ' not found.');
 
    WHEN OTHERS THEN
 
        -- Print an error message if an exception occurs
 
        DBMS_OUTPUT.PUT_LINE('Error updating customer details: ' || SQLERRM);
 
  END update_customer_details;
 
END user_management;
 
 
 
set serveroutput on;

--Execution of create_customer

BEGIN

  user_management.create_customer(

    p_phone_number => '6172929875',

    p_street => '123 Elm St',

    p_city => 'Boston',

    p_state => 'Massachusetts',

    p_zip => '02456',

    p_country => 'United States'

  );

END;

/
 
--Execution of delete_customer

EXEC user_management.delete_customer(207);
 
--Execution of update customer

BEGIN

  user_management.update_customer_details(

    p_customer_id => 208, -- Specify the customer ID

    p_phone_number => '6172929875', -- Specify the new phone number

    p_street => '123 Main St', -- Specify the new street

    p_city => 'NewYork', -- Specify the new citya

    p_state => 'NY', -- Specify the new state

    p_zip => '12345', -- Specify the new ZIP code

    p_country => 'US' -- Specify the new country

  );

END;

