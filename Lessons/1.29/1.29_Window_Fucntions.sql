-- Count Rows - Aggregation Only
SELECT
    COUNT(*)
FROM
    job_postings_fact;


-- Count Rows - Wondow Function
SELECT
    job_id
    COUNT(*) OVER ()
FROM
    job_postings_fact

/*
Why are window functions important for
Data Engineers?

They let you add context without destroying rows -
which is basically the job.

    - Pipelines need row-level data

    - Aggregates collapse rows

    - Window functions keep rows AND add insight

-- ==========================================
-- WINDOW FUNCTIONS
-- Perform calculations across related rows
-- without collapsing the result set
-- ==========================================

-- Syntax

SELECT
    column_1,
    window_function() OVER (
        PARTITION BY column_name
        ORDER BY column_name
    ) AS window_column_alias
FROM table_name;

-- PARTITION BY
-- Splits rows into groups

-- ORDER BY
-- Defines the order within each group

-- Common Window Functions
-- ROW_NUMBER()
-- RANK()
-- DENSE_RANK()
-- LAG()
-- LEAD()
-- SUM()
-- AVG()
-- COUNT()
-- MIN()
-- MAX()


-- ==========================================
-- TYPES OF WINDOW FUNCTIONS
-- ==========================================

-- 1. AGGREGATE
-- Calculate a value across rows
-- in each window

-- AVG()    : Average value
-- MAX()    : Maximum value
-- MIN()    : Minimum value
-- SUM()    : Total value
-- COUNT()  : Number of rows

-- 2. ROW & RANK
-- Assign row numbers or rankings

-- ROW_NUMBER()  : Unique row number
-- RANK()        : Rank, skips ties
-- DENSE_RANK()  : Rank, no skipped values
-- PERCENT_RANK(): Relative rank (0 to 1)
-- NTILE(n)      : Split rows into n groups

-- 3. NAVIGATION
-- Access values from other rows

-- LAG()         : Previous row
-- LEAD()        : Next row
-- FIRST_VALUE() : First value
-- LAST_VALUE()  : Last value
-- NTH_VALUE()   : Nth value

*/

/*
-- ==========================================
-- PARTITION BY
-- ==========================================

Window Function: AVG() OVER (PARTITION BY)

Sample Data

job_id | job_title_short | salary_hour_avg
-------+-----------------+----------------
101    | Data Analyst    | 60
102    | Data Engineer   | 95
103    | Data Analyst    | 40
104    | Data Analyst    | 50
105    | Data Engineer   | 105

Calculation

Data Analyst
(60 + 40 + 50) / 3 = 50

Data Engineer
(95 + 105) / 2 = 100

Result

job_id | job_title_short | salary_hour_avg | avg_hourly_by_title
-------+-----------------+-----------------+---------------------
101    | Data Analyst    | 60              | 50
102    | Data Engineer   | 95              | 100
103    | Data Analyst    | 40              | 50
104    | Data Analyst    | 50              | 50
105    | Data Engineer   | 105             | 100
*/


-- SELECT
--     AVG(salary_hour_avg )
-- FROM
--     job_postings_fact;


-- SELECT
--     job_id,
--     job_title_short,
--     salary_hour_avg,
--     AVG(salary_hour_avg) OVER ()
-- FROM 
--     job_postings_fact;


SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY  job_title_short
    )
FROM 
    job_postings_fact
ORDER BY 
    RANDOM()
LIMIT 10;


SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short, company_id
    )
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY 
    RANDOM()
LIMIT 10;


/*
-- ==========================================
-- ORDER BY
-- ==========================================

Window Function: RANK() OVER (ORDER BY)

Sample Data

job_id | job_title_short | salary_hour_avg
-------+-----------------+----------------
101    | Data Analyst    | 60
102    | Data Engineer   | 95
103    | Data Analyst    | 40
104    | Data Analyst    | 50
105    | Data Engineer   | 50

Calculation

Salary Ranking (Highest to Lowest)

95  -> Rank 1
60  -> Rank 2
50  -> Rank 3
50  -> Rank 3
40  -> Rank 5

Result

job_id | job_title_short | salary_hour_avg | rank_hourly_salary
-------+-----------------+-----------------+--------------------
101    | Data Analyst    | 60              | 2
102    | Data Engineer   | 95              | 1
103    | Data Analyst    | 40              | 5
104    | Data Analyst    | 50              | 3
105    | Data Engineer   | 50              | 3

Final Output (ORDER BY job_title_short, job_id)

job_id | job_title_short | salary_hour_avg | rank_hourly_salary
-------+-----------------+-----------------+--------------------
101    | Data Analyst    | 60              | 2
103    | Data Analyst    | 40              | 5
104    | Data Analyst    | 50              | 3
102    | Data Engineer   | 95              | 1
105    | Data Engineer   | 50              | 3
*/

-- SELECT
--     job_id,
--     job_title_short,
--     salary_hour_avg,
--     RANK() OVER (
--         ORDER BY salary_hour_avg DESC
--     ) AS rank_hourly_salary
-- FROM job_postings_fact
-- ORDER BY
--     job_title_short,
--     job_id;


-- ORDER BY - Ranking hourly salary
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        ORDER BY salary_hour_avg DESC
    ) AS rank_salary_hour_avg
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC
LIMIT 10;


/*
-- ==========================================
-- PARTITION BY & ORDER BY
-- ==========================================

Window Function: Running AVG() OVER (PARTITION BY + ORDER BY)

Sample Data

job_posted_date | job_title_short | salary_hour_avg
----------------+-----------------+----------------
01-01-2025      | Data Analyst    | 60
02-01-2025      | Data Engineer   | 95
03-01-2025      | Data Analyst    | 40
04-01-2025      | Data Analyst    | 50
05-01-2025      | Data Engineer   | 105


Calculation

Data Analyst

01-01-2025
60 / 1 = 60

03-01-2025
(60 + 40) / 2 = 50

04-01-2025
(60 + 40 + 50) / 3 = 50


Data Engineer

02-01-2025
95 / 1 = 95

05-01-2025
(95 + 105) / 2 = 100


Result

job_posted_date | job_title_short | salary_hour_avg | running_avg_hourly_by_title
----------------+-----------------+-----------------+-----------------------------
01-01-2025      | Data Analyst    | 60              | 60
03-01-2025      | Data Analyst    | 40              | 50
04-01-2025      | Data Analyst    | 50              | 50
02-01-2025      | Data Engineer   | 95              | 95
05-01-2025      | Data Engineer   | 105             | 100


PARTITION BY
- Separates calculation by job title.
- Data Analyst and Data Engineer have separate averages.

ORDER BY
- Creates a running calculation based on job posting date.
- Each row includes the current row and previous rows.
*/

-- SELECT
--     job_posted_date,
--     job_title_short,
--     salary_hour_avg,
--     AVG(salary_hour_avg) OVER (
--         PARTITION BY job_title_short
--         ORDER BY job_posted_date
--     ) AS running_avg_hourly_by_title
-- FROM job_postings_fact
-- ORDER BY
--     job_title_short,
--     job_posted_date;


-- SELECT
--     job_posted_date,
--     job_title_short,
--     salary_hour_avg,
--     AVG(salary_hour_avg) OVER (
--         PARTITION BY job_title_short
--         ORDER BY job_posted_date
--     ) running_salary_hour_avg
-- FROM 
--     job_postings_fact
-- WHERE
--     salary_hour_avg IS NOT NULL
-- ORDER BY 
--     job_title_short,
--     job_posted_date
-- LIMIT 10;

-- PARTITION BY & ORDER BY - Running Average Hourly Salary
SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) running_salary_hour_avg
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL AND
    job_title_short = 'Data Engineer'
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 10;


-- PARTITION BY & ORDER BY - Ranking by job_title_short
SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        PARTITION BY  job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_salary_hour_avg
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC,
    job_title_short
LIMIT 10;


-- ==========================================
-- AGGREGATE
-- ==========================================
SELECT
    job_posted_date,
    job_title_short,
    salary_hour_avg,
--  AVG/MAX/MIN/SUM
    SUM(salary_hour_avg) OVER (
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) running_salary_hour_avg
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL AND
    job_title_short = 'Data Engineer'
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 10;



-- ==========================================
-- ROW & RANK
-- ==========================================

-- Ranking Functions - RANK() vs DENSE_RANK
-- SELECT
--     job_id,
--     job_title_short,
--     salary_hour_avg,
--     DENSE_RANK() OVER (
--         ORDER BY salary_hour_avg DESC
--     ) AS rank_salary_hour_avg
-- FROM 
--     job_postings_fact
-- WHERE
--     salary_hour_avg IS NOT NULL
-- ORDER BY
--     salary_hour_avg DESC
-- LIMIT 140;

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        ORDER BY salary_hour_avg DESC
    ) AS rank_salary_hour_avg
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC
LIMIT 140;


-- ROW_NUMBER() - Providing a new job_id
SELECT 
    *,
    ROW_NUMBER() OVER (
        ORDER BY job_posted_date
    )
FROM
    job_postings_fact
ORDER BY
    job_posted_date
LIMIT 20;


SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    ROW_NUMBER() OVER (
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM 
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    rank_hourly_salary
LIMIT 140;


-- ==========================================
-- Navigation Functions
-- ==========================================

-- LAG() - Time Based Comparison of Company Yearly Salary

-- SELECT
--     job_id,
--     company_id,
--     job_title,
--     job_title_short,
--     job_posted_date,
--     salary_year_avg,
--     LAG(salary_year_avg) OVER (
--         PARTITION BY company_id
--         ORDER BY job_posted_date
--     ) AS previous_postings_salary
-- FROM
--     job_postings_fact
-- WHERE salary_year_avg IS NOT NULL
-- ORDER BY company_id, job_posted_date
-- LIMIT 60;

--LAG()
SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_postings_salary,
    salary_year_avg - LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;

--LEAD()
SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS next_postings_salary,
    salary_year_avg - LEAD(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;

-- MOSTLY USE LAG(), NOT LEAD()