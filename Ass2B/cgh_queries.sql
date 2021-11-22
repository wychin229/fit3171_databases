/*****PLEASE ENTER YOUR DETAILS BELOW*****/
/*cgh_queries.sql*/

/*Student ID: 29975239*/
/*Student Name: Chin Wen Yuan*/
/*Tutorial No: 02, Friday 12pm*/

/* Comments for your marker:




*/


/*
    Q1
    List the doctor title, first name, last name and contact phone number for all doctors who specialise
    in the area of "ORTHOPEDIC SURGERY" (this is the specialisation description). Order the list by
    the doctors' last name and within this, if two doctors have the same last name, order them by their
    respective first names.
*/
/* PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* ENSURE that your query is formatted and has a semicolon*/
/* (;) at the end of this answer*/
SELECT
    d.doctor_title,
    d.doctor_fname,
    d.doctor_lname,
    d.doctor_phone
FROM
         cgh.doctor d
    JOIN cgh.doctor_speciality s
    ON d.doctor_id = s.doctor_id
WHERE
    s.spec_code = (
        SELECT
            spec_code
        FROM
            cgh.speciality
        WHERE
            lower(spec_description) = lower('ORTHOPEDIC SURGERY')
    )
ORDER BY
    doctor_lname,
    doctor_fname;

/*
    Q2
     List the item code, item description, item stock and the cost centre title which provides these items
    for all items which have a stock greater than 50 items and include the word 'disposable' in their item
    description. Order the output by the item code
*/
/* PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* ENSURE that your query is formatted and has a semicolon (;)*/
/* at the end of this answer*/
SELECT
    i.item_code,
    i.item_description,
    i.item_stock,
    c.cc_title
FROM
         cgh.item i
    JOIN cgh.costcentre c
    ON i.cc_code = c.cc_code
WHERE
        i.item_stock > 50
    AND lower(i.item_description) LIKE '%disposable%'
ORDER BY
    i.item_code;

/*
    Q3
    List the patient id, patient's full name as a single column called 'Patient Name', admission date
    and time and the supervising doctor's full name (including title) as a single column called 'Doctor
    Name' for all those patients admitted between 10 AM on 11th of September and 6 PM on the 14th of
    September 2021 (inclusive). Order the output by the admission time with the earliest admission first
*/
/* PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* ENSURE that your query is formatted and has a semicolon (;)*/
/* at the end of this answer*/
SELECT
    p.patient_id,
    p.patient_fname
    || ','
    || p.patient_lname     AS "Patient Name",
    a.adm_date_time,
    d.doctor_title
    || ' '
    || d.doctor_fname
    || ' '
    || d.doctor_lname      AS "Doctor Name"
FROM
         cgh.patient p
    JOIN cgh.admission    a
    ON p.patient_id = a.patient_id
    JOIN cgh.doctor       d
    ON a.doctor_id = d.doctor_id
WHERE
        a.adm_date_time >= TO_DATE('2021-09-11 10:00:00', 'YYYY-MM-DD HH24:MI:SS')
    AND a.adm_date_time <= TO_DATE('2021-09-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS')
ORDER BY
    a.adm_date_time;

/*
    Q4
    List the procedure code, name, description, and standard cost where the procedure is less
    expensive than the average procedure standard cost. The output must show the most expensive
    procedure first. The procedure standard cost must be displayed with two decimal points and a
    leading $ symbol, for example as $120.54
*/
/* PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* ENSURE that your query is formatted and has a semicolon (;)*/
/* at the end of this answer*/
SELECT
    proc_code,
    proc_name,
    proc_description,
    '$'
    || to_char(round(proc_std_cost, 2), '990.00')
FROM
    cgh.procedure
WHERE
    proc_std_cost < (
        SELECT
            AVG(proc_std_cost)
        FROM
            cgh.procedure
    )
ORDER BY
    proc_std_cost DESC;

/*
    Q5
     List the patient id, last name, first name, date of birth and the number of times the patient has
    been admitted to the hospital where the number of admissions is greater than 2. The output should
    show patients with the most number of admissions first and for patients with the same number of
    admissions, show the patients in their date of birth order
*/
/* PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* ENSURE that your query is formatted and has a semicolon (;)*/
/* at the end of this answer*/
SELECT
    p.patient_id,
    p.patient_lname,
    p.patient_fname,
    p.patient_dob,
    COUNT(*) AS admitcount
FROM
         cgh.patient p
    JOIN cgh.admission a
    ON p.patient_id = a.patient_id
GROUP BY
    p.patient_id,
    p.patient_lname,
    p.patient_fname,
    p.patient_dob
HAVING
    COUNT(*) > 2
ORDER BY
    COUNT(*) DESC,
    p.patient_dob;

/*
    Q6
    List the admission number, patient id, first name, last name and the length of their stay in the
    hospital for all patients who have been discharged and who were in the hospital longer than the
    average stay for all discharged patients. The length of stay must be shown in the form 10 days 2.0
    hrs where hours are rounded to one decimal digit. The output must be ordered by admission
    number
*/
/* PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* ENSURE that your query is formatted and has a semicolon (;)*/
/* at the end of this answer*/
SELECT
    a.adm_no,
    p.patient_id,
    p.patient_fname,
    p.patient_lname,
    trunc(a.adm_discharge - a.adm_date_time)
    || ' days '
    || round(((a.adm_discharge - a.adm_date_time) - trunc(a.adm_discharge - a.adm_date_time)) *
    60,
             1)
    || ' hours' AS "length_of_stay"
FROM
         cgh.admission a
    JOIN cgh.patient p
    ON a.patient_id = p.patient_id
WHERE
    a.adm_discharge IS NOT NULL
    AND a.adm_discharge - a.adm_date_time > (
        SELECT
            AVG(adm_discharge - adm_date_time)
        FROM
            cgh.admission
        WHERE
            adm_discharge IS NOT NULL
    )
ORDER BY
    a.adm_no;

/*
    Q7
    Given a doctor may charge more or less than the standard charge for a procedure carried out
    during an admission procedure, the hospital administration is interested in finding out what variations
    on the standard price have been charged. The hospital terms the difference between the average
    actual charged procedure cost which has been charged to patients for all such procedures which
    have been carried out the procedure standard cost as the "Procedure Price Differential". 
    
    For all procedures which have been carried out on an admission determine the procedure price differential.
    
    The list should show the procedure code, name, description, standard time, standard cost and the
    procedure price differential in procedure code order.
    
    For example procedure 15509 "X-ray, Right knee" has a standard cost of $70.00, it may have been
    charged to admissions on average across all procedures carried out for $75.00 - the price differential
    here will be 75 - 70 that is a price differential +5.00 If the average charge had been say 63.10 the
    price differential will be -6.90
*/
/* PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* ENSURE that your query is formatted and has a semicolon (;)*/
/* at the end of this answer*/
SELECT
    a.proc_code,
    p.proc_name,
    p.proc_description,
    p.proc_time,
    p.proc_std_cost,
    '$'
    || to_char(round(AVG(a.adprc_pat_cost) - p.proc_std_cost, 2), '990.00') AS "Procedure Price Differential"
FROM
         cgh.procedure p
    JOIN cgh.adm_prc a
    ON p.proc_code = a.proc_code
GROUP BY
    a.proc_code,
    p.proc_name,
    p.proc_description,
    p.proc_time,
    p.proc_std_cost
ORDER BY
    a.proc_code;

/*
    Q8
    For every procedure, list the items which have been used and the maximum number of those
    items used when the procedure was carried out on an admission. Your list must show the procedure
    code, procedure name, item code and item description and the maximum quantity of this item used
    for the given procedure
*/
/* PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* ENSURE that your query is formatted and has a semicolon (;)*/
/* at the end of this answer*/
/*CASE WHEN MAX(t.it_qty_used) IS NOT NULL THEN TO_CHAR(MAX(t.it_qty_used)) ELSE '---' END AS MaxQuantity*/
SELECT
    p.proc_code,
    p.proc_name,
    nvl(i.item_code, '---')                              AS "ITEM_CODE",
    nvl(i.item_description, '---')                       AS "ITEM_DESCRIPTION",
    nvl(to_char(MAX(t.it_qty_used)), '---')              AS "Max Quantity Used"
FROM
    cgh.procedure         p
    LEFT OUTER JOIN cgh.adm_prc           a
    ON a.proc_code = p.proc_code
    LEFT OUTER JOIN cgh.item_treatment    t
    ON a.adprc_no = t.adprc_no
    LEFT OUTER JOIN cgh.item              i
    ON t.item_code = i.item_code
GROUP BY
    p.proc_code,
    p.proc_name,
    i.item_code,
    i.item_description
ORDER BY
    p.proc_name,
    i.item_code;

/*
    Q9b (FIT3171 only)
    Find the ninth most expensive procedure/s for a procedure carried out on an admission
*/
/* PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE*/
/* ENSURE that your query is formatted and has a semicolon (;)*/
/* at the end of this answer*/
WITH ranked AS (
    SELECT
        a.adprc_no,
        to_char(round(a.adprc_pat_cost + a.adprc_items_cost, 2), '990.00')              AS "TOTALCOST",
        RANK()
        OVER(
            ORDER BY a.adprc_pat_cost + a.adprc_items_cost DESC
        )                                                                               price_rank
    FROM
        cgh.adm_prc a
    ORDER BY
        a.adprc_pat_cost + a.adprc_items_cost DESC
)
SELECT
    a.adprc_no,
    a.proc_code,
    a.adm_no,
    (
        SELECT
            patient_id
        FROM
            cgh.admission
        WHERE
            adm_no = a.adm_no
    )                                                                               AS "PATIENT_ID",
    to_char(a.adprc_date_time, 'YYYY-MM-DD HH24:MI:SS')                             AS "ADPRC_DATE_TIME",
    to_char(round(a.adprc_pat_cost + a.adprc_items_cost, 2), '990.00')              AS "TOTALCOST"
FROM
         ranked r
    JOIN cgh.adm_prc a
    ON r.adprc_no = a.adprc_no
WHERE
    price_rank = 9
ORDER BY
    a.adprc_no;