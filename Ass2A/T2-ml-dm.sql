--****PLEASE ENTER YOUR DETAILS BELOW****
--T2-ml-dm.sql

--Student ID: 29975239
--Student Name: Chin Wen Yuan
--Tutorial No:02, Friday 12pm

/* Comments for your marker:



*/

-- 2 (b) (i)
INSERT INTO book_detail VALUES (
    '005.74 C824C',
    'Database Systems: Design, Implementation, and Management',
    'R',
    793,
    TO_DATE('2019', 'YYYY'),
    13
);

INSERT INTO book_copy VALUES (
    (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120'),
    (SELECT MAX(bc_id) FROM book_copy WHERE branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120'))+1,
    120,
    'N',
    '005.74 C824C');

UPDATE branch SET branch_count_books = branch_count_books + 1 WHERE branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120');

INSERT INTO book_copy VALUES (
    (SELECT branch_code FROM branch WHERE branch_contact_no = '0395601655'),
    (SELECT MAX(bc_id) FROM book_copy WHERE branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395601655'))+1,
    120,
    'N',
    '005.74 C824C');

UPDATE branch SET branch_count_books = branch_count_books + 1 WHERE branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395601655');

INSERT INTO book_copy VALUES (
    (SELECT branch_code FROM branch WHERE branch_contact_no = '0395461253'),
    (SELECT MAX(bc_id) FROM book_copy WHERE branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395461253'))+1,
    120,
    'N',
    '005.74 C824C');

UPDATE branch SET branch_count_books = branch_count_books + 1 WHERE branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395461253');

COMMIT;

-- 2 (b) (ii)
DROP SEQUENCE bor_no_seq;

DROP SEQUENCE reserve_id_seq;

CREATE SEQUENCE bor_no_seq START WITH 100 INCREMENT BY 1;

CREATE SEQUENCE reserve_id_seq START WITH 100 INCREMENT BY 1;

-- 2 (b) (iii)
-- add new borrower
INSERT INTO borrower VALUES (
    bor_no_seq.NEXTVAL,
    'Ada',
    'Lovelace',
    '9 Joker Street',
    'Gotham City',
    '9000',
    (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120')
);
-- place new reservation
INSERT INTO reserve VALUES (
    reserve_id_seq.NEXTVAL,
    (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120'),
    (SELECT bc_id FROM book_copy WHERE branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120') AND book_call_no = '005.74 C824C'),
    TO_DATE('2021-09-14 15:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    bor_no_seq.CURRVAL
);

COMMIT;
-- 2 (b) (iv)
INSERT INTO loan VALUES (
    (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120'),
    (SELECT bc_id FROM book_copy WHERE branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120') AND book_call_no = '005.74 C824C'),
    (SELECT TO_DATE('2021-09-14 12:30:00', 'YYYY-MM-DD HH24:MI:SS')+7 as LoanDate FROM dual), 
    (SELECT TO_DATE('2021-09-14', 'YYYY-MM-DD')+21 as LoadDeadline FROM dual),
    NULL,
    (SELECT bor_no FROM borrower WHERE bor_fname = 'Ada' AND bor_lname = 'Lovelace')
);

-- delete the reservation 
DELETE FROM reserve WHERE 
    reserve_date_time_placed = TO_DATE('2021-09-14 15:30:00', 'YYYY-MM-DD HH24:MI:SS') AND 
    branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120') AND
    bor_no = (SELECT bor_no FROM borrower WHERE bor_fname = 'Ada' AND bor_lname = 'Lovelace') AND
    bc_id = (SELECT bc_id FROM book_copy WHERE branch_code = (SELECT branch_code FROM branch WHERE branch_contact_no = '0395413120') AND book_call_no = '005.74 C824C');
    
COMMIT;
