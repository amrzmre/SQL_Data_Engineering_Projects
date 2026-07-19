SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';

DESCRIBE job_postings_fact;


DESCRIBE
SELECT
    job_title_short,
    salary_year_avg
FROM
    job_postings_fact;



/*
Castings

Casting refers to the operation of converting a value in a 
particular data type to the corresponding value in another data
type. Casting can occur either implicitly or explicitly. 
The syntax described here performs an explicit cast. More
information on casting can be found on the typecasting page.

*/

SELECT CAST(123 AS VARCHAR);

SELECT CAST('123DEF' AS INTEGER);

SELECT CAST('123' AS INTEGER);


-- e.g,

SELECT
    job_id, -- "more" unique identifier
    job_work_from_home, -- from boolean to numeric value
    job_posted_date, -- from timestamp to date only
    salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
LIMIT 10;

I

SELECT
    job_id, -- "more" unique identifier
    CAST(job_work_from_home AS INT) AS job_work_from_home, -- from boolean to numeric value
    CAST(job_posted_date AS DATE) AS job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10, 0)) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


SELECT
    job_id,
    company_id, -- "more" unique identifier
    CAST(job_work_from_home AS INT) AS job_work_from_home, -- from boolean to numeric value
    CAST(job_posted_date AS DATE) AS job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10, 0)) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


-- combine job_id with company_id
-- append one to other


SELECT
    CAST(job_id AS VARCHAR),
    CAST(company_id AS VARCHAR), -- "more" unique identifier
    CAST(job_work_from_home AS INT) AS job_work_from_home, -- from boolean to numeric value
    CAST(job_posted_date AS DATE) AS job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10, 0)) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


/*
arg1 || arg2

Description Concatenates two strings, lists, or blobs. 
Any NULL input results in NULL. See also concat(arg1, arg2,.)
and list concat(list1, list2, .. ).

*/

SELECT
    CAST(job_id AS VARCHAR) ||'-'|| CAST(company_id AS VARCHAR), -- "more" unique identifier
    CAST(job_work_from_home AS INT) AS job_work_from_home, -- from boolean to numeric value
    CAST(job_posted_date AS DATE) AS job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10, 0)) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

-- another operator ::

SELECT
    job_id::VARCHAR ||'-'|| company_id AS VARCHAR, -- "more" unique identifier
    job_work_from_home::INT AS job_work_from_home, -- from boolean to numeric value
    job_posted_date::DATE AS job_posted_date, -- from timestamp to date only
    salary_year_avg::DECIMAL(10, 0) AS salary_year_avg -- from double to no decimal places
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;


--must be explicit
 
-- INT + DECIMAL

SELECT 3 + 5.5;

SELECT (3 + 5.5)::INT;
