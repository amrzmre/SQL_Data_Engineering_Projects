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