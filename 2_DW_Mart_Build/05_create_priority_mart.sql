-- Step 5: Mart - Create priority roles mart

DROP SCHEMA IF EXISTS priority_mart CASCADE;
--CASCADE for drop the schema if have tables in it

CREATE SCHEMA priority_mart;

-------------------------------------

-- Priority roles table
SELECT '=== Loading Roles for Priority Mart ===' AS info;
CREATE  TABLE priority_mart.priority_roles (
    role_id         INTEGER     PRIMARY KEY,
    role_name       VARCHAR,
    priority_lvl    INTEGER
);

INSERT INTO priority_mart.priority_roles (role_id, role_name, priority_lvl)
VALUES
    (1, 'Data Engineer', 2),
    (2, 'Senior Data Engineer', 1),
    (3, 'Software Engineer', 3);

SELECT * FROM priority_mart.priority_roles;
------------------------------------------------

-- priority_jobs_snapshot - Initial Load --
SELECT '=== Loading Snapshot for Priority Mart ===' AS info;
CREATE OR REPLACE TABLE priority_mart.priority_jobs_snapshot (
    job_id              INTEGER PRIMARY KEY,
    job_title_short     VARCHAR,
    company_name        VARCHAR,
    job_posted_date     TIMESTAMP,
    salary_year_avg     DOUBLE,
    priority_lvl        INTEGER,
    updated_at          TIMESTAMP
);

INSERT INTO priority_mart.priority_jobs_snapshot (
    job_id,              
    job_title_short,     
    company_name,        
    job_posted_date,     
    salary_year_avg,     
    priority_lvl,        
    updated_at          
)
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP
FROM
    job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN priority_mart.priority_roles AS r 
    ON jpf.job_title_short = r.role_name;

-- Data Validation
SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_mart.priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;


















/* ============================================================
   PRIORITY MART WORKFLOW

   Source:
   Data Warehouse Layer

   Process:
   Extract job postings + company information
   Join with priority roles mapping
   MERGE into priority jobs snapshot

   Frequency:
   priority_roles = Updated Daily
   priority_jobs_snapshot = Incrementally Updated
============================================================ */


/* ============================================================
   DATA WAREHOUSE
============================================================ */


/*
Table: job_postings_fact

Purpose:
Contains raw job posting details.

Primary Key:
    job_id

Foreign Key:
    company_id

Columns:
    job_id
    company_id
    job_title_short
    job_title
    job_location
    job_via
    job_schedule_type
    job_work_from_home
    search_location
    job_posted_date
    job_no_degree_mention
    job_health_insurance
    job_country
    salary_rate
    salary_year_avg
    salary_hour_avg
*/


/*
Table: company_dim

Purpose:
Stores company information.

Primary Key:
    company_id

Columns:
    company_id
    name
    link
    link_google
    thumbnail
*/


/* ============================================================
   PRIORITY ROLE MAPPING
============================================================ */


/*
Table: priority_roles

Purpose:
Stores job roles that are considered priority.

Updated:
Daily

Primary Key:
    role_id

Columns:
    role_id
    role_name
    priority_lvl
*/


/* ============================================================
   DATA MART
============================================================ */


/*
Table: priority_jobs_snapshot

Purpose:
Stores filtered priority job postings.

Update Method:
Incremental Update using MERGE

Primary Key:
    job_id

Columns:
    job_id
    job_title_short
    company_name
    job_posted_date
    salary_year_avg
    priority_lvl
    updated_at
*/


/* ============================================================
   ETL WORKFLOW
============================================================ */


/*
Step 1:
Extract job posting data

Source:
    job_postings_fact


Step 2:
Join company information

job_postings_fact.company_id
        |
        |
        v
company_dim.company_id


Step 3:
Match job roles with priority_roles

job_title_short
        |
        |
        v
priority_roles.role_name


Step 4:
MERGE data into priority_jobs_snapshot

Logic:

IF job_id exists:
    UPDATE existing record

IF job_id does not exist:
    INSERT new record


Step 5:
Update timestamp

updated_at = current timestamp
*/


/* ============================================================
   SQL FLOW

job_postings_fact
        |
        |
        +----------------+
        |                |
        v                v
 company_dim     priority_roles
        |                |
        +--------+-------+
                 |
                 v
      priority_jobs_snapshot

              MERGE

      Incrementally Updated
============================================================ */