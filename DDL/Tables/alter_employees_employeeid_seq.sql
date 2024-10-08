-- Create a sequence to generate values for the employee_id column
CREATE SEQUENCE employee_id_seq START WITH 1 INCREMENT BY 1;

-- Modify the EMPLOYEES table to use the sequence for generating values for the employee_id column
ALTER TABLE EMPLOYEES
MODIFY (employee_id DEFAULT employee_id_seq.NEXTVAL);
