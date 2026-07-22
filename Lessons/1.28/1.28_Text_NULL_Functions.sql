-- ==========================================
-- TEXT FUNCTIONS
-- Work with and manipulate text values
-- ==========================================

-- LENGTH & COUNT
-- Count the number of characters

SELECT LENGTH('SQL');          -- 3
SELECT CHAR_LENGTH('SQL');     -- 3


-- CASE CONVERSION
-- Convert text to upper/lower case

SELECT UPPER('sql');           -- SQL
SELECT LOWER('SQL');           -- sql

-- SUBSTRING / EXTRACTION
-- Extract part of a string

SELECT LEFT('SQL', 2);         -- SQ
SELECT RIGHT('SQL', 2);        -- QL
SELECT SUBSTRING('SQL', 2, 3); -- Q

-- CONCATENATION
-- Join strings together

SELECT CONCAT('SQL', '-', 'Functions');
-- SQL-Functions

SELECT 'SQL' || '-' || 'Functions';
-- SQL-Functions

-- TRIMMING
-- Remove leading/trailing spaces

SELECT TRIM(' SQL ');          -- SQL
SELECT LTRIM(' SQL ');         -- SQL
SELECT RTRIM('SQL ');          -- SQL

-- REPLACEMENT
-- Replace text or patterns

SELECT REPLACE('SQL', 'Q', '_');
-- S_L

SELECT REGEXP_REPLACE(
    'SQL',
    '[A-Z]+',
    'sql'
);
-- sql


SELECT REGEXP_REPLACE(
    'data.nerd@gmail.com',
    '^.*(@)',
    '\1'
);


-- Final Example

-- Final Example - Cleanup this using Text Functions
WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact 
)

SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE 'scientist%' THEN 'Data Scientist'
        WHEN job_title_clean LIKE '%data%'
         AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        ELSE 'Other'
    END AS job_title_category
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;



-- ==========================================
-- NULL FUNCTIONS
-- Handle NULL (missing) values
-- ==========================================

-- NULLIF
-- Returns NULL if two values are equal.
-- Syntax:
-- NULLIF(expression1, expression2)

-- Flow:
-- expression1 == expression2 ?
-- Yes -> NULL
-- No  -> expression1

SELECT NULLIF(10, 10);             -- NULL
SELECT NULLIF(10, 20);             -- 10
SELECT NULLIF('apple', 'orange');  -- apple

SELECT
    salary_year_avg,
    salary_hour_avg
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
ORDER BY salary_year_avg
LIMIT 10;


SELECT
    NULLIF(salary_year_avg, 0),
    NULLIF(salary_hour_avg, 0)
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;

SELECT
    MEDIAN(NULLIF(salary_year_avg, 0)),
    MEDIAN(NULLIF(salary_hour_avg, 0))
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;



-- COALESCE
-- Returns the first non-NULL value.
-- Syntax:
-- COALESCE(value1, value2, ..., valueN)

-- Flow:
-- value1 -> NULL?
-- Yes -> Check value2
-- Yes -> Check value3
-- Continue until first non-NULL value

SELECT COALESCE(NULL, 'A', 'B');          -- A
SELECT COALESCE(NULL, NULL, 100);         -- 100
SELECT COALESCE('First', NULL, 'Second'); -- First

SELECT COALESCE(0, 1, 2);
SELECT COALESCE(NULL, 1, 2);
SELECT COALESCE(NULL, NULL, 2);

SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080)
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;


-- Final Example - Simplify with Coalesce
-- WITH salaries AS (
-- SELECT
--     job_title_short,
--     salary_year_avg,
--     salary_hour_avg,
--     CASE
--         WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
--         WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg * 2080
--         ELSE NULL
--     END AS standardized_salary
-- FROM job_postings_fact
-- )
SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 75000 THEN 'Low'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 150000 THEN 'Mid'
        ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;