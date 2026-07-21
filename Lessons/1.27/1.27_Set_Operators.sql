/*
-- ==========================================
-- SET OPERATORS
-- Combine results from multiple SELECT queries
-- ==========================================

-- Example Tables
-- A: 1, 1, 2
-- B: 1, 1, 3

-- UNION
-- Combines results, removes duplicates
-- Result: 1, 2, 3

SELECT num FROM table_a
UNION
SELECT num FROM table_b;

-- UNION ALL
-- Combines results, keeps duplicates
-- Result: 1, 1, 2, 1, 1, 3

SELECT num FROM table_a
UNION ALL
SELECT num FROM table_b;

-- INTERSECT
-- Returns common rows, removes duplicates
-- Result: 1

SELECT num FROM table_a
INTERSECT
SELECT num FROM table_b;

-- INTERSECT ALL
-- Returns common rows, keeps duplicates
-- Result: 1, 1

SELECT num FROM table_a
INTERSECT ALL
SELECT num FROM table_b;

-- EXCEPT
-- Returns rows in A but not in B,
-- removes duplicates
-- Result: 2

SELECT num FROM table_a
EXCEPT
SELECT num FROM table_b;

-- EXCEPT ALL
-- Returns rows in A but not in B,
-- removes duplicates one-for-one
-- Result: 2

SELECT num FROM table_a
EXCEPT ALL
SELECT num FROM table_b;
*/


-- UNION 
SELECT UNNEST[1, 1, 1, 2];

SELECT UNNEST([1, 1, 1, 2])
UNION
SELECT UNNEST([1, 1, 3]);

SELECT UNNEST([1, 1, 1, 2])
UNION ALL
SELECT UNNEST([1, 1, 3]);


--INTERSECT
SELECT UNNEST([1, 1, 1, 2])
INTERSECT
SELECT UNNEST([1, 1, 3]);

SELECT UNNEST([1, 1, 1, 2])
INTERSECT ALL 
SELECT UNNEST([1, 1, 3]);


--EXCEPT
SELECT UNNEST([1, 1, 1, 2])
EXCEPT
SELECT UNNEST([1, 1, 3]);

SELECT UNNEST([1, 1, 1, 2])
EXCEPT ALL 
SELECT UNNEST([1, 1, 3]);


--Final Example

/*
==========================================================
Sample Data
==========================================================

2023 Job Postings

+--------+----------------------+-----------------+-------------------+-----------------+
| job_id | job_title_short      | job_posted_date | job_location      | salary_year_avg |
+--------+----------------------+-----------------+-------------------+-----------------+
| 101    | Data Analyst         | 2023-01-06      | Tampa, FL         | 45000           |
| 102    | Data Engineer        | 2023-01-07      | United States     | 100000          |
| 103    | Data Analyst         | 2023-01-13      | New York, NY      | 125000          |
| 104    | Data Scientist       | 2023-01-16      | Washington, DC    | 5000            |
| 105    | Data Engineer        | 2023-01-21      | Los Angeles, CA   | 110000          |
| 202    | Data Engineer        | 2023-01-22      | United States     | 150000          |
+--------+----------------------+-----------------+-------------------+-----------------+

2024 Job Postings

+--------+----------------------+-----------------+-------------------+-----------------+
| job_id | job_title_short      | job_posted_date | job_location      | salary_year_avg |
+--------+----------------------+-----------------+-------------------+-----------------+
| 201    | Data Engineer        | 2024-01-06      | United States     | 100000          |
| 202    | Software Engineer    | 2024-01-07      | New York, NY      | 125000          |
| 203    | Sr. Data Engineer    | 2024-01-12      | Bentonville, AR   | 100000          |
| 204    | Data Analyst         | 2024-01-13      | New York, NY      | 125000          |
| 205    | Data Analyst         | 2024-01-16      | New York, NY      | 150000          |
+--------+----------------------+-----------------+-------------------+-----------------+

Practice Questions

1. Which unique job postings appeared in either 2023 or 2024?
   (UNION)

2. Which job postings appeared across both years, counting duplicates?
   (UNION ALL)

3. Which job postings appeared in 2023 but not in 2024?
   (EXCEPT)

4. Which job postings appeared more times in 2023 than in 2024, one-for-one?
   (EXCEPT ALL)

5. Which job postings appeared in both 2023 and 2024?
   (INTERSECT)

6. Which job postings appeared in both years, preserving duplicate counts?
   (INTERSECT ALL)
==========================================================
*/

-- Create temporary table

--2023
CREATE TEMP TABLE jobs_2023 AS
--DESCRIBE 
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact 
WHERE EXTRACT(YEAR FROM job_posted_date) = 2023;



--2024
CREATE TEMP TABLE jobs_2024 AS
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact 
WHERE EXTRACT(YEAR FROM job_posted_date) = 2024;

SELECT * FROM jobs_2024;


-- 1. Which unique job postings appeared in either 2023 or 2024?
-- (UNION)
SELECT * FROM jobs_2023 
UNION
SELECT * FROM jobs_2024; 


SELECT COUNT(*) FROM jobs_2023 
UNION
SELECT COUNT(*) FROM jobs_2024; 


SELECT
    'jobs_2023' AS table_name,
    COUNT(*) AS record_count
FROM jobs_2023 
UNION
SELECT
    'jobs_2024' AS table_name,
    COUNT(*) AS record_counr
FROM jobs_2024; 



-- 2. Which job postings appeared across both years, counting duplicates?
-- (UNION ALL)
SELECT * FROM jobs_2023 
UNION ALL
SELECT * FROM jobs_2024; 


-- 3. Which job postings appeared in 2023 but not in 2024?
--   (EXCEPT)
SELECT * FROM jobs_2023 
EXCEPT
SELECT * FROM jobs_2024; 


-- 4. Which job postings appeared more times in 2023 than in 2024, one-for-one?
-- (EXCEPT ALL)
SELECT * FROM jobs_2023 
EXCEPT ALL
SELECT * FROM jobs_2024; 


-- 5. Which job postings appeared in both 2023 and 2024?
-- (INTERSECT)
SELECT * FROM jobs_2023 
INTERSECT
SELECT * FROM jobs_2024; 


-- 6. Which job postings appeared in both years, preserving duplicate counts?
--  (INTERSECT ALL)
SELECT * FROM jobs_2023 
INTERSECT ALL
SELECT * FROM jobs_2024; 
