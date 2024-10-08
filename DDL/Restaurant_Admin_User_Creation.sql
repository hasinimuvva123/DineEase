/** 
''' This is done by ADMIN USER to create a resturant_admin for this project'''
**/

set serveroutput on;
Declare
    user_exists NUMBER;
    grant_error EXCEPTION;
BEGIN
    -- Check if the user already exists
    SELECT COUNT(*)
    INTO user_exists
    FROM all_users
    WHERE username = 'RESTAURANT_ADMIN';

    IF user_exists = 0 THEN
        -- Create the user if it doesn't exist
        EXECUTE IMMEDIATE 'CREATE USER restaurant_admin IDENTIFIED BY DineEase2024';
        DBMS_OUTPUT.PUT_LINE('User created successfully.');
    ELSE
        -- User already exists, inform the user
        DBMS_OUTPUT.PUT_LINE('User already exists.');
    END IF;

    BEGIN
        -- User already exists, inform the user
        EXECUTE IMMEDIATE 'GRANT CONNECT TO restaurant_admin';
        EXECUTE IMMEDIATE 'GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER, CREATE USER TO restaurant_admin WITH ADMIN OPTION';
        EXECUTE IMMEDIATE 'GRANT CONNECT TO restaurant_admin WITH ADMIN OPTION';
        EXECUTE IMMEDIATE 'GRANT CREATE ROLE TO restaurant_admin WITH ADMIN OPTION';
        EXECUTE IMMEDIATE 'GRANT UNLIMITED TABLESPACE TO restaurant_admin';
        EXECUTE IMMEDIATE 'GRANT CREATE VIEW TO restaurant_admin';
    EXCEPTION
        WHEN grant_error THEN
            NULL; -- Ignore if the user already has the privilege
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
