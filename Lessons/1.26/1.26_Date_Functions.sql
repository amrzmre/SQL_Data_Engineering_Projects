/*
DATE/TIME

Timestamps and time-based data

DATE                2025-11-02
TIME                15:30:00
TIMESTAMP           2025-11-02 15:30:00
TIMESTAMPTZ         2025-11-02 15:30:00+00
*/

SELECT 
    job_posted_date,
    job_posted_date::DATE AS date,
    job_posted_date::TIME AS time,
    job_posted_date::TIMESTAMP AS timestamp,
    job_posted_date::TIMESTAMPTZ AS timestampz
FROM job_postings_fact
LIMIT 10;


/*
link doc: duckdb.org/docs/stable/sql/functions/datepart

-- ==========================================
-- EXTRACT
-- Gets a specific part from a date/time value
-- (YEAR, MONTH, DAY, HOUR, etc.)
-- ==========================================

SELECT
    EXTRACT(part FROM column_name)
FROM table_name;

*/
SELECT 
    job_posted_date,
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    EXTRACT(DAY FROM job_posted_date) AS job_posted_day
FROM job_postings_fact
LIMIT 10;



SELECT 
    EXTRACT(YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT(MONTH FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
    EXTRACT(YEAR FROM job_posted_date),
    EXTRACT(MONTH FROM job_posted_date)
ORDER BY
    job_posted_year,
    job_posted_month;

-- DATE_TRUNC
SELECT 
    DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
    DATE_TRUNC('month', job_posted_date)
ORDER BY
    job_posted_month;

-- if want specific year
SELECT 
    DATE_TRUNC('month', job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Engineer' AND
    DATE_TRUNC('year', job_posted_date) = '2024-01-01'
--    EXTRACT(YEAR FROM job_posted_date) = 2024
GROUP BY
    DATE_TRUNC('month', job_posted_date)
ORDER BY
    job_posted_month;



/*
-- ==========================================
-- DATE_TRUNC
-- Truncates a date/timestamp to a specified
-- precision (YEAR, MONTH, DAY, HOUR, etc.)
-- Returns the start of the selected time unit
-- ==========================================

SELECT
    DATE_TRUNC('precision', date_time)
FROM table_name;

*/

SELECT 
    job_posted_date,
    DATE_TRUNC('month', job_posted_date) AS job_posted_month
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;


SELECT
    job_posted_date,
    DATE_TRUNC('year', job_posted_date) AS truncated_year,
    DATE_TRUNC('quarter', job_posted_date) AS truncated_quarter,
    DATE_TRUNC('month', job_posted_date) AS truncated_month,
    DATE_TRUNC('week', job_posted_date) AS truncated_week,
    DATE_TRUNC('day', job_posted_date) AS truncated_day,
    DATE_TRUNC('hour', job_posted_date) AS truncated_hour
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;


/*
-- ==========================================
-- AT TIME ZONE
-- Converts a timestamp to the specified
-- time zone
-- ==========================================

SELECT
    column_name AT TIME ZONE 'UTC'
FROM table_name;

*/
SELECT
    '2026-01-01 00:00:00+00'::TIMESTAMPTZ AT TIME ZONE 'EST';


SELECT 
    job_posted_date
FROM 
    job_postings_fact 
LIMIT 10;


/*
-- ==========================================
-- AT TIME ZONE (TIMESTAMP)
-- Assumes the timestamp is in the machine's
-- local time zone, then converts it
-- ==========================================

SELECT
    column_name AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM table_name;

*/
SELECT
    job_title_short,
    job_location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM 
    job_postings_fact
WHERE
    job_location LIKE 'New York, NY';


--what time locally posted
SELECT
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS job_posted_hour,
    COUNT(job_id)
FROM 
    job_postings_fact
WHERE
    job_location LIKE 'New York, NY'
GROUP BY
    EXTRACT(HOUR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')
ORDER BY 
    job_posted_hour;
