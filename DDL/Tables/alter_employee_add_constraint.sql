ALTER TABLE employees 
ADD CONSTRAINT unique_ssn UNIQUE (ssn);

ALTER TABLE employees 
ADD CONSTRAINT check_gender CHECK (gender IN ('M', 'F'));


ALTER TABLE employees 
MODIFY (fname NOT NULL, role NOT NULL);
