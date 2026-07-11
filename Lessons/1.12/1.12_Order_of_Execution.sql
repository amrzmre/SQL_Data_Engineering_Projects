SELECT
LIMIT 10
FROM job_postings_fact;

-- Final Example Pt. 1

/*
Find the top 10 companies for postings jobs
They must have >3000 postings
Limit this to only US jobs
*/


SELECT
    cd.name AS company_name,
    COUNT(jps.*) AS postings_count
FROM job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
GROUP BY cd.name;



SELECT
    cd.name AS company_name,
    COUNT(jps.*) AS postings_count
FROM job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name;


SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS postings_count
FROM job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name;


SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS postings_count
FROM job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000;



SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY posting_count DESC;




SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY posting_count DESC
LIMIT 10;



-- Final Example Pt. 2

/*
use keywoords to explain and explain analyze to see what the steps are

1. EXPLAIN
2. EXPLAIN ANALYZE
*/

--EXPLAIN

EXPLAIN
SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY posting_count DESC
LIMIT 10;

-- EXPLAIN ANALYZE

EXPLAIN ANALYZE
SELECT
    cd.name AS company_name,
    COUNT(jpf.job_id) AS posting_count
FROM job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY posting_count DESC
LIMIT 10;