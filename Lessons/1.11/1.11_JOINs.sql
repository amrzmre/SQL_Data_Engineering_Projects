-- LEFT JOIN --

SELECT
    jpf.*,
    cd.*
FROM
    job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


/* not recomendded  */
SELECT
    job_id,
    job_title_short,
    name AS company_name,
    job_location
FROM
    job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;

--if add company_id in SELECT, will be ambiguous

SELECT
    job_id,
    job_title_short,
    name AS company_name,
    company_id
    job_location
FROM
    job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;

--correct way

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


-- let's see how many jobs are returned when LEFT JOIN

SELECT
    COUNT(*)
FROM
    job_postings_fact;

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id


-- RIGHT JOIN --

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf 
RIGHT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


-- INNER JOIN --

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf 
INNER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;

-- INNER JOIN = JOIN

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf 
JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;


-- FULL OUTER JOIN --

SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name AS company_name,
    jpf.job_location
FROM
    job_postings_fact AS jpf 
FULL OUTER JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
LIMIT 10;

-- FULL OUTER JOIN = FULL JOIN


-- Final Example Skill JOIN's --

-- 1. look top 10 rows of each

SELECT *
FROM skills_job_dim
LIMIT 10;

SELECT *
FROM skills_dim
LIMIT 10;

/*
so from job_postings_fact,
we need to connect to the skills_dim table
into skilss_job_dim table


* note: unlike company_dim table,
        there are some jobs w/o associated skill,
        there's no skills required for it,
*/ 

-- 2. Figuring out what type of JOIN's for this

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
--    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
LIMIT 10;


SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
LIMIT 10;

-- below most common type JOINs encountering

/* LEFT JOIN
let's think about what case we want to use this
LEFT JOINS and used evertime we want to preserve all
the  values from job_postings_fact table, regardless
if have an associated skill
*/

/* INNER JOIN
only returned matching values that exist in both
table A and table B.
so in this case, job_postings_fact that dont
have an associated skill won't appear.
*/

SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
LIMIT 10;