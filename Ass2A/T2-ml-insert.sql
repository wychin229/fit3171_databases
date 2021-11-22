--****PLEASE ENTER YOUR DETAILS BELOW****
--T2-ml-insert.sql

--Student ID: 29975239
--Student Name: Chin Wen Yuan
--Tutorial No: 02, Friday 12pm

/* Comments for your marker:



*/

-- 2 (a) Load the BOOK_COPY, LOAN and RESERVE tables with your own
-- test data following the data requirements expressed in the brief
INSERT INTO book_copy VALUES (
    10,
    1,
    58,
    'Y',
    '005.756 G476F'
);

INSERT INTO book_copy VALUES (
    10,
    3,
    58,
    'N',
    '005.756 G476F'
);

INSERT INTO book_copy VALUES (
    10,
    4,
    45,
    'N',
    '112.6 S874D'
);

INSERT INTO book_copy VALUES (
    11,
    1,
    58,
    'Y',
    '005.756 G476F'
);

INSERT INTO book_copy VALUES (
    11,
    4,
    78,
    'N',
    '005.74 D691D'
);

INSERT INTO book_copy VALUES (
    11,
    11,
    45,
    'N',
    '112.6 S874D'
);

INSERT INTO book_copy VALUES (
    13,
    1,
    45,
    'N',
    '112.6 S874D'
);

INSERT INTO book_copy VALUES (
    13,
    4,
    58,
    'Y',
    '005.756 G476F'
);

INSERT INTO book_copy VALUES (
    13,
    7,
    78,
    'N',
    '005.74 D691D'
);

INSERT INTO book_copy VALUES (
    13,
    11,
    45,
    'N',
    '112.6 S874D'
);

-- update book count for branch
UPDATE branch SET branch_count_books = 3 WHERE branch_code = 10;
UPDATE branch SET branch_count_books = 3 WHERE branch_code = 11;
UPDATE branch SET branch_count_books = 4 WHERE branch_code = 13;

-- completed on time
INSERT INTO loan VALUES (
    10,
    3,
    TO_DATE('2021-06-02 15:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2021-06-16', 'YYYY-MM-DD'),
    TO_DATE('2021-06-14', 'YYYY-MM-DD'),
    1
);
-- completed late
INSERT INTO loan VALUES (
    10,
    4,
    TO_DATE('2021-06-02 17:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2021-06-16', 'YYYY-MM-DD'),
    TO_DATE('2021-06-17', 'YYYY-MM-DD'),
    1
);
-- completed on time
INSERT INTO loan VALUES (
    11,
    4,
    TO_DATE('2021-06-03 14:25:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2021-06-17', 'YYYY-MM-DD'),
    TO_DATE('2021-06-11', 'YYYY-MM-DD'),
    2
);
-- completed on time
INSERT INTO loan VALUES (
    11,
    4,
    TO_DATE('2021-06-15 17:20:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2021-06-29', 'YYYY-MM-DD'),
    TO_DATE('2021-06-23', 'YYYY-MM-DD'),
    3
);
-- still due
INSERT INTO loan VALUES (
    11,
    11,
    TO_DATE('2021-06-05 15:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2021-06-19', 'YYYY-MM-DD'),
    NULL,
    2
);
-- still due
INSERT INTO loan VALUES (
    11,
    4,
    TO_DATE('2021-07-03 12:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2021-07-17', 'YYYY-MM-DD'),
    NULL,
    3
);
-- completed on time
INSERT INTO loan VALUES (
    13,
    1,
    TO_DATE('2021-07-05 15:25:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2021-07-19', 'YYYY-MM-DD'),
    TO_DATE('2021-07-17', 'YYYY-MM-DD'),
    5
);
-- completed on time
INSERT INTO loan VALUES (
    13,
    11,
    TO_DATE('2021-07-07 18:20:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2021-07-21', 'YYYY-MM-DD'),
    TO_DATE('2021-07-18', 'YYYY-MM-DD'),
    5
);
-- completed late
INSERT INTO loan VALUES (
    13,
    1,
    TO_DATE('2021-08-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2021-08-15', 'YYYY-MM-DD'),
    TO_DATE('2021-08-16', 'YYYY-MM-DD'),
    5
);
-- completed on time
INSERT INTO loan VALUES (
    13,
    7,
    TO_DATE('2021-08-03 17:55:00', 'YYYY-MM-DD HH24:MI:SS'),
    TO_DATE('2021-08-17', 'YYYY-MM-DD'),
    TO_DATE('2021-08-15', 'YYYY-MM-DD'),
    5
);

-- not fulfilled Reservation
INSERT INTO reserve VALUES (
    1,
    11,
    4,
    TO_DATE('2021-09-01 12:55:00', 'YYYY-MM-DD HH24:MI:SS'),
    2
);

-- not fulfilled Reservation
INSERT INTO reserve VALUES (
    2,
    11,
    11,
    TO_DATE('2021-09-02 14:55:00', 'YYYY-MM-DD HH24:MI:SS'),
    3
);

COMMIT;