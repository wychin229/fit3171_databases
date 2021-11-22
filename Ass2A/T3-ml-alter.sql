--****PLEASE ENTER YOUR DETAILS BELOW****
--T3-ml-alter.sql

--Student ID: 29975239
--Student Name: Chin Wen Yuan
--Tutorial No: 02, Friday 12pm

/* Comments for your marker:
In Task 3c, a new table containing all managers of each branch, 
f_man_id is the id of the manager who manages Fiction collection
while r_man_id is the id of the manager who manages Reference collection.


*/

-- 3 (a)
ALTER TABLE book_copy ADD (
    bc_condition VARCHAR2(1) DEFAULT 'G',
    CONSTRAINT ck_bc_condition CHECK ( bc_condition IN ( 'D','L','G' ))
);

COMMENT ON COLUMN book_copy.bc_condition IS
    'Book copy condition, damaged (D), lost (L) or good (G)';

UPDATE book_copy SET bc_condition = 'L' WHERE
    branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395601655')
    AND book_call_no = '005.74 C824C';
    
COMMIT;

-- 3 (b)
ALTER TABLE loan ADD (
    loan_return_branch NUMBER(2)
);

COMMENT ON COLUMN loan.loan_return_branch IS
    'Branch code that the book was returned to';
    
UPDATE loan SET loan_return_branch = branch_code WHERE
    loan_actual_return_date IS NOT NULL;

COMMIT;

-- 3 (c)
-- create a new table that stores all manager in a branch
DROP TABLE manager_list PURGE;

CREATE TABLE manager_list AS SELECT branch_code,man_id FROM branch;
-- pk for the new table
ALTER TABLE manager_list ADD CONSTRAINT ml_pk PRIMARY KEY ( branch_code );
-- drop the man_id fk in branch TABLE
ALTER TABLE branch DROP CONSTRAINT manager_branch;
-- fk for the new table
ALTER TABLE manager_list
    ADD CONSTRAINT ml_fk FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );
        
-- move all the previous data to the new table
ALTER TABLE manager_list ADD (
    r_man_id NUMBER(2),
    f_man_id NUMBER(2)
);
UPDATE manager_list SET f_man_id = man_id, r_man_id = man_id;
-- drop the copied man_id
ALTER TABLE manager_list DROP COLUMN man_id;
-- set the columns to be mandatory
ALTER TABLE manager_list MODIFY ( 
    r_man_id NOT NULL,
    f_man_id NOT NULL
);

-- drop the man_id column in branch TABLE
ALTER TABLE branch DROP COLUMN man_id;

-- update NATHAN to manage Fiction collection for Clayton
UPDATE manager_list SET f_man_id = 12 WHERE branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120');
COMMIT;