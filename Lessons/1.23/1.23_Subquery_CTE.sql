/*
==================================================
SUBQUERIES vs CTEs (Common Table Expressions)
==================================================

SUBQUERY
--------------------------------------------------
Definition:
- A query nested inside another query

Syntax:

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE job_title_short = 'Data Engineer'
) AS data_engineer_jobs;


Characteristics:
- Exists only within the query
- Can be harder to read when nested
- Good for simple, one-time operations
- Must give the subquery an alias


==================================================

CTE (Common Table Expression)
--------------------------------------------------
Definition:
- A temporary named result set created using WITH

Syntax:

WITH data_engineer_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE job_title_short = 'Data Engineer'
)

SELECT *
FROM data_engineer_jobs;


Characteristics:
- Improves readability
- Easier to debug
- Can be referenced multiple times
- Great for complex queries
- Exists only during query execution


==================================================
COMPARISON
==================================================

Feature               Subquery          CTE
--------------------------------------------------
Defined with          (SELECT ...)      WITH
Readability           Lower             Higher
Reusable              No                Yes
Best for              Simple queries    Complex queries
Debugging             Harder            Easier
Reference             Once              Multiple times


==================================================
SUMMARY
==================================================

Subquery
- Nested inside another query.
- Best for simple, one-time logic.

CTE
- Named temporary result set.
- Better for readability and complex SQL.
- Can be reused within the same query.

==================================================
*/



-- 1. Subquery Demo--

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
)
LIMIT 10;


SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
)
LIMIT 10;


SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
        OR salary_hour_avg IS NOT NULL
) AS valid_salries
LIMIT 10;


-- 2. CTE  Demo--

WITH valid_salaries AS (
    SELECT *
        FROM job_postings_fact
        WHERE salary_year_avg IS NOT NULL
            OR salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salaries;




-- 1. Subquery --


-- Scenario 1 - Subquery in 'SELECT'
-- Show each job's salary next to the overall market median:
SELECT
    job_title_short,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
    ) AS market_median_salary
FROM job_postings_fact
LIMIT 10;


SELECT
    job_title_short,
    salary_year_avg,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
    ) AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;



-- * Scenario 2 - Subquery in FROM
-- Stage only jobs that are remote before aggregating to determine the remote median salary per job:
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
    ) AS market_median_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
LIMIT 10;


SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
    ) AS market_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) clean_jobs
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
LIMIT 10;

-- prob w market median salary is nested not effect outer

SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) clean_jobs
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
LIMIT 10;

-- outer WHERE no needed anymore
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) clean_jobs
GROUP BY job_title_short
LIMIT 10;



-- Scenario 3 - Subquery in'HAVING
-- Keep only job titles whose median salary is above the overall median:
SELECT
    job_title_short,
    MEDIAN(salary_year_avg) AS median_salary,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
    ) AS market_remote_median_salary
FROM (
    SELECT
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
) clean_jobs
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) > (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)
LIMIT 10;


-- 2. CTE --

/*
==================================================
CTE (Common Table Expression) NOTES
==================================================

Definition:
- A temporary named result set created using the WITH clause.
- Exists only during the execution of a single query.

WITH Clause:
- Used to define one or more CTEs.
- Must appear at the beginning of the query.

A CTE can be referenced in:

1. FROM
   - Used like a regular table.

2. JOIN
   - Joined with other tables or CTEs.

3. Other CTEs
   - Later CTEs can reference earlier CTEs.

4. Main Statement
   - SELECT
   - INSERT
   - UPDATE
   - DELETE
   - MERGE (if supported)

Benefits:
- Improves readability.
- Simplifies complex queries.
- Breaks large queries into logical steps.
- Can be referenced multiple times within the same query.
- Easier to debug and maintain.

Lifetime:
- Exists only while the query is executing.
- Automatically disappears after the query finishes.

==================================================
Example
==================================================

WITH data_engineer_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE job_title_short = 'Data Engineer'
)

SELECT *
FROM data_engineer_jobs;

==================================================
*/

-- CTE Examp lel
-- Compare how much more (or less) remote roles pay compared to onsite roles for each job title.
-- Use a CTE to calculate the median salary by title and work arrangement, then compare those medians.

SELECT
    job_title_short,
    job_work_from_home,
    MEDIAN(salary_year_avg) AS market_median_salary
FROM job_postings_fact
GROUP BY
    job_title_short,
    job_work_from_home;


SELECT
    job_title_short,
    job_work_from_home,
    MEDIAN(salary_year_avg) AS market_median_salary
FROM job_postings_fact
WHERE job_country = 'United States'
GROUP BY
    job_title_short,
    job_work_from_home;

-- have decimal, more readable add ::INT
SELECT
    job_title_short,
    job_work_from_home,
    MEDIAN(salary_year_avg)::INT AS market_median_salary
FROM job_postings_fact
WHERE job_country = 'United States'
GROUP BY
    job_title_short,
    job_work_from_home;


WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY
        job_title_short,
        job_work_from_home
)

SELECT
    job_title_short,
    median_salary
FROM title_median;

-- but must focus on remote job
WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY
        job_title_short,
        job_work_from_home
)

SELECT
    r.job_title_short,
    r.median_salary
FROM title_median AS r
WHERE r.job_work_from_home = TRUE;


--------------------------

-- then bring on-site job, use JOIN
WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY
        job_title_short,
        job_work_from_home
)

SELECT
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary
FROM title_median AS r
INNER JOIN title_median o 
    ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE;



-- next calculate remote premium, by subtrating the onsite salary from the remote median
WITH title_median AS (
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN(salary_year_avg)::INT AS median_salary
    FROM job_postings_fact
    WHERE job_country = 'United States'
    GROUP BY
        job_title_short,
        job_work_from_home
)

SELECT
    r.job_title_short,
    r.median_salary AS remote_median_salary,
    o.median_salary AS onsite_median_salary,
    (r.median_salary - o.median_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median o 
    ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
    AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC;



--- FINAL EXAMPLE ---
-- Existence Filtering --

/*
==================================================
WHERE EXISTS
==================================================

Definition:
- Returns rows from the outer query only if the subquery
  finds at least one matching row.

Purpose:
- Check whether matching records exist.
- Filters rows based on the existence of related data.

Syntax:

SELECT *
FROM source_table AS src
WHERE EXISTS (
    SELECT 1
    FROM target_table AS tgt
    WHERE src.job_id = tgt.job_id
);

==================================================
How It Works
==================================================

1. Read one row from the outer query.

2. Execute the subquery.

3. If the subquery finds at least one matching row,
   EXISTS returns TRUE.

4. If no match is found,
   EXISTS returns FALSE.

5. Repeat for every row in the outer query.

==================================================
Example
==================================================

Source Table

job_id   job_title_short
------   ----------------
101      Data Analyst
102      Data Engineer
103      Data Scientist

Target Table

job_id   job_title_short
------   ----------------
101      Data Analyst
104      Software Engineer

Query

SELECT *
FROM source_table AS src
WHERE EXISTS (
    SELECT 1
    FROM target_table AS tgt
    WHERE src.job_id = tgt.job_id
);

Result

job_id   job_title_short
------   ----------------
101      Data Analyst

==================================================
Notes
==================================================

- EXISTS returns TRUE if the subquery returns one or
  more rows.

- SELECT 1 is commonly used because EXISTS only checks
  whether a row exists. The selected value is ignored.

- Stops searching after finding the first match,
  making it efficient for large tables.

- Commonly used with correlated subqueries.

==================================================
EXISTS vs INNER JOIN
==================================================

EXISTS
- Used to test whether a match exists.
- Returns rows from the outer table only.
- Ignores duplicate matching rows.
- Often more efficient for existence checks.

INNER JOIN
- Combines columns from both tables.
- Returns one row for every matching pair.
- Duplicate matches produce duplicate rows.

==================================================
SUMMARY
==================================================

EXISTS
→ "Does a matching row exist?"

INNER JOIN
→ "Return matching rows from both tables."

==================================================
*/

/*
==================================================
WHERE NOT EXISTS
==================================================

Definition:
- Returns rows from the outer query only if the subquery
  finds NO matching rows.

Purpose:
- Find records that do not have a related record
  in another table.

Syntax:

SELECT *
FROM source_table AS src
WHERE NOT EXISTS (
    SELECT 1
    FROM target_table AS tgt
    WHERE src.job_id = tgt.job_id
);

==================================================
How It Works
==================================================

1. Read one row from the outer query.

2. Execute the subquery.

3. If the subquery finds a matching row,
   NOT EXISTS returns FALSE.

4. If no matching row is found,
   NOT EXISTS returns TRUE.

5. Repeat for every row in the outer query.

==================================================
Example
==================================================

Source Table

job_id   job_title_short
------   ----------------
101      Data Analyst
102      Data Engineer
103      Data Scientist

Target Table

job_id   job_title_short
------   ----------------
101      Data Analyst
104      Software Engineer

Query

SELECT *
FROM source_table AS src
WHERE NOT EXISTS (
    SELECT 1
    FROM target_table AS tgt
    WHERE src.job_id = tgt.job_id
);

Result

job_id   job_title_short
------   ----------------
102      Data Engineer
103      Data Scientist

==================================================
Notes
==================================================

- NOT EXISTS returns TRUE only if the subquery
  returns zero rows.

- SELECT 1 is used because the returned value
  is ignored. Only the existence of rows matters.

- Often used to find:
  • Missing records
  • Unmatched rows
  • Orphan records

==================================================
EXISTS vs NOT EXISTS
==================================================

EXISTS
- Keeps rows with at least one match.
- Returns matching records.

NOT EXISTS
- Keeps rows with no match.
- Returns unmatched records.

==================================================
Comparison
==================================================

EXISTS
→ "Does a matching row exist?"

NOT EXISTS
→ "Does no matching row exist?"

==================================================
Example
==================================================

EXISTS

SELECT *
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM departments d
    WHERE e.department_id = d.department_id
);

Returns:
Employees assigned to a valid department.


NOT EXISTS

SELECT *
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM departments d
    WHERE e.department_id = d.department_id
);

Returns:
Employees not assigned to any valid department.

==================================================
SUMMARY
==================================================

EXISTS
→ Keep rows that have a match.

NOT EXISTS
→ Keep rows that do not have a match.

==================================================
*/

SELECT *
FROM range(3) AS src(key);

SELECT *
FROM range(2) AS tgt(key);


-- WHERE EXISTS (keep rows w a match in target)
SELECT *
FROM range(3) AS src(key)
WHERE EXISTS (
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key = src.key
);

-- WHERE EXISTS (keep rows w no match in target)
SELECT *
FROM range(3) AS src(key)
WHERE NOT EXISTS (
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key = src.key
);


--- FINAL EXAMPLE
-- Indentify job postings that have no associated skills before loading them into a data mart

SELECT *
FROM job_postings_fact
ORDER BY job_id
LIMIT 10;

SELECT *
FROM skills_job_dim
ORDER BY job_id
LIMIT 40;


SELECT *
FROM job_postings_fact AS tgt
WHERE NOT EXISTS (
    SELECT 1    
    FROM skills_job_dim AS src 
    WHERE tgt.job_id = src.job_id 
)
ORDER BY job_id;


SELECT *
FROM job_postings_fact AS tgt
WHERE EXISTS (
    SELECT 1    
    FROM skills_job_dim AS src 
    WHERE tgt.job_id = src.job_id 
)
ORDER BY job_id;

