/*****PLEASE ENTER YOUR DETAILS BELOW*****/
/*cgh_triggers.sql*/

/*Student ID: 29975239*/
/*Student Name: Chin Wen Yuan*/
/*Tutorial No: 02, Friday 12pm*/

/* Comments for your marker:




*/


/*
    Trigger1
    CHG, from now on, would like to implement a new requirement that the gap between the
    cost charged to a patient for a procedure carried out during their admission and the standard
    procedure cost must be within the range of plus or minus 20%. 
    For example, if a procedure's standard cost is $100, the performing doctor or technician must not 
    charge the patient lower than $80 or more than $120 for that procedure. If the admission procedure 
    cost is outside the 20% range, the trigger should prevent the action. 
    Code a single trigger to enforce this requirement.
*/
/*Please copy your trigger code with a slash(/) followed by an empty line after this line*/
CREATE OR REPLACE TRIGGER adprc_pat_cost_trig BEFORE
    INSERT ON adm_prc
    FOR EACH ROW
DECLARE
    lower_bound  NUMBER;
    upper_bound  NUMBER;
BEGIN
    SELECT
        proc_std_cost - ( proc_std_cost * 0.2 )
    INTO lower_bound
    FROM
        procedure
    WHERE
        proc_code = :new.proc_code;

    SELECT
        proc_std_cost + ( proc_std_cost * 0.2 )
    INTO upper_bound
    FROM
        procedure
    WHERE
        proc_code = :new.proc_code;
    /* check if it matches the requirement*/
    IF ( :new.adprc_pat_cost > upper_bound ) THEN
        raise_application_error(-20000,
                               'exceed range of plus or minus 20% of procedure standard cost');
    END IF;

    IF ( :new.adprc_pat_cost < lower_bound ) THEN
        raise_application_error(-20000,
                               'exceed range of plus or minus 20% of procedure standard cost');
    END IF;

    dbms_output.put_line('The admission procedure cost is within acceptable range.');
END;
/

/*Test Harness for Trigger1*/
/*Please copy SQL statements for Test Harness after this line*/
/* Test Harness*/
SET PAGESIZE 30;

SET SERVEROUTPUT ON;

--SET ECHO ON;

/* Prior state*/
SELECT
    *
FROM
    adm_prc;

/* Test trigger*/
/* more than plus 20% range*/
INSERT INTO adm_prc (
    adprc_no,
    adprc_date_time,
    adprc_pat_cost,
    adprc_items_cost,
    adm_no,
    proc_code
) VALUES (
    1030,
    TO_DATE('08/JUL/2021  04:00:00 PM', 'DD/MON/YYYY  HH12:MI:SS AM'),
    150,
    0,
    100010,
    32266
);
/* within range*/
INSERT INTO adm_prc (
    adprc_no,
    adprc_date_time,
    adprc_pat_cost,
    adprc_items_cost,
    adm_no,
    proc_code
) VALUES (
    1030,
    TO_DATE('08/JUL/2021  04:00:00 PM', 'DD/MON/YYYY  HH12:MI:SS AM'),
    70,
    0,
    100010,
    32266
);
/* less than minus 20% range*/
INSERT INTO adm_prc (
    adprc_no,
    adprc_date_time,
    adprc_pat_cost,
    adprc_items_cost,
    adm_no,
    proc_code
) VALUES (
    1030,
    TO_DATE('08/JUL/2021  04:00:00 PM', 'DD/MON/YYYY  HH12:MI:SS AM'),
    30,
    0,
    100010,
    32266
);
/* Post state*/

SELECT
    *
FROM
    adm_prc;

/* Undo changes*/
ROLLBACK;

--SET ECHO OFF;

/*
    Trigger2
    When a patient is discharged, the discharge date and time value is added into the
    patient’s admission entry. Once added, the discharge date and time cannot be changed. Code a
    single trigger that:
    ? check that the discharge date and time is valid, ie. it cannot be before the admission date
    time or, if any, the last admission procedure’s start date and time (you may ignore the
    procedure’s duration), and
    ? automatically calculate the value of admission total cost. The admission total cost is the total
    of patient costs and item costs of all procedures related to the admission plus the admin cost.
    The admin cost is $50 flat for all patients. When the patient did not undergo any procedure,
    then they will be charged for the admin cost only
*/
/*Please copy your trigger code with a slash(/) followed by an empty line after this line*/
CREATE OR REPLACE TRIGGER discharge_trig BEFORE
    UPDATE ON admission
    FOR EACH ROW
DECLARE
    latest_adprc_date_time  DATE;
    proc_charge             NUMBER;
    item_charge             NUMBER;
BEGIN
    SELECT
        MAX(adprc_date_time)
    INTO latest_adprc_date_time
    FROM
        adm_prc
    WHERE
        adm_no = :old.adm_no;

    /* check if it matches the requirement*/
    /* check if already discharged */
    IF ( :old.adm_discharge IS NOT NULL ) THEN
        raise_application_error(-20002, 'patient already discharged.');
    END IF;
        
    /* valid date and time*/
    IF ( :new.adm_discharge < :old.adm_date_time ) THEN
        raise_application_error(-20000,
                               'invalid date and time : earlier than admission date.');
    END IF;

    IF ( latest_adprc_date_time IS NOT NULL ) THEN
        IF ( :new.adm_discharge < latest_adprc_date_time ) THEN
            raise_application_error(-20001,
                                   'invalid date and time : earlier than latest procedure start date and time.');
        END IF;
    END IF;
    
    /* Calculate the admission total cost */
    BEGIN
        SELECT
            adprc_pat_cost
        INTO proc_charge
        FROM
            adm_prc
        WHERE
            adm_no = :old.adm_no;

    EXCEPTION
        WHEN no_data_found THEN
            proc_charge := 0;
    END;

    BEGIN
        SELECT
            adprc_items_cost
        INTO item_charge
        FROM
            adm_prc
        WHERE
            adm_no = :old.adm_no;

    EXCEPTION
        WHEN no_data_found THEN
            item_charge := 0;
    END;

    :new.adm_total_cost := proc_charge + item_charge + 50;
    dbms_output.put_line('Value of total cost: ' || :new.adm_total_cost);
END;
/

/*Test Harness for Trigger2*/
/*Please copy SQL statements for Test Harness after this line*/
/* Test Harness*/
SET PAGESIZE 30;

SET SERVEROUTPUT ON;

--SET ECHO ON;

/* Prior state*/
SELECT
    *
FROM
    admission;

SELECT
    *
FROM
    adm_prc;
/* Test trigger*/
/* invalid date (earlier than admission date)*/
UPDATE admission
SET
    adm_discharge = TO_DATE('2021-10-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    adm_total_cost = 0
WHERE
    adm_no = 100280;
/* valid date */
UPDATE admission
SET
    adm_discharge = TO_DATE('2021-10-14 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    adm_total_cost = 0
WHERE
    adm_no = 100280;
/* invalid date (before latest procedure start date)*/
INSERT INTO admission (
    adm_no,
    adm_date_time,
    adm_discharge,
    adm_total_cost
) VALUES (
    100290,
    TO_DATE('2021-10-14 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    NULL,
    NULL
);

INSERT INTO adm_prc (
    adprc_no,
    adprc_date_time,
    adprc_pat_cost,
    adprc_items_cost,
    adm_no,
    proc_code
) VALUES (
    1070,
    TO_DATE('2021-10-15  16:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    80,
    0,
    100290,
    32266
);

UPDATE admission
SET
    adm_discharge = TO_DATE('2021-10-15 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
    adm_total_cost = 0
WHERE
    adm_no = 100290;
/* Post state*/
SELECT
    *
FROM
    admission;

SELECT
    *
FROM
    adm_prc;
/* Undo changes*/
ROLLBACK;

--SET ECHO OFF;