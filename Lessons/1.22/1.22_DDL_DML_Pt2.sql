/*
DDL & DML- REFRESHER
SQL Language Categories

    1. DDL (Data Definition Language)
    --------------------------------------------------
        Purpose:
        Defines and modifies database structure.

        Affects:
        Schema objects such as tables, views, indexes, etc.

        Examples:
        CREATE
        ALTER
        DROP
        TRUNCATE

        Transaction Behavior:
        Auto-commits by default.
        Changes are usually permanent.

        Usage Frequency:
        Mainly used during database setup or schema updates.

        Example Query:
        CREATE TABLE employees (
            id INT,
            name TEXT
        );


        2. DML (Data Manipulation Language)
        --------------------------------------------------
        Purpose:
        Manages and manipulates data inside tables.

        Affects:
        Actual records (rows) in tables.

        Examples:
        INSERT
        UPDATE
        DELETE
        SELECT

        Transaction Behavior:
        Can be rolled back when part of a transaction.

        Usage Frequency:
        Used daily for working with data.

        Example Query:
        INSERT INTO employees VALUES
        (1, 'Luke');

*/


/*

-- CTAS vs VIEW vs TEMP TABLE --

==================================================
1. CTAS (CREATE TABLE AS SELECT)
==================================================

    Purpose:
    Creates a new physical table from a query result.

    Syntax:
    CREATE [OR REPLACE] TABLE table_name AS (
        SELECT ...
    );

    Storage:
    - Physical table
    - Stored on disk
    - Contains actual data

    Behavior:
    - Snapshot created at creation time
    - Data does not automatically update when source tables change
    - Fast reads because data is already stored

    Example:

    CREATE TABLE employee_backup AS
    SELECT *
    FROM employees;


==================================================
2. VIEW
==================================================

    Purpose:
    Creates a virtual table based on a stored query.

    Syntax:
    CREATE [OR REPLACE] VIEW view_name AS (
        SELECT ...
    );

    Storage:
    - Virtual table
    - Does not store data
    - Stores only the query definition

    Behavior:
    - Query runs every time the view is accessed
    - Always reflects the latest source table data
    - Can be slower because it recomputes results

    Example:

    CREATE VIEW employee_view AS
    SELECT *
    FROM employees;


==================================================
3. TEMP TABLE (TEMPORARY TABLE)
==================================================

    Purpose:
    Creates a temporary workspace table for short-term use.

    Syntax:
    CREATE [OR REPLACE] TEMP TABLE table_name AS (
        SELECT ...
    );

    Storage:
    - Materialized data
    - Stored temporarily during a session

    Behavior:
    - Exists only within the current session
    - Automatically deleted when disconnected
    - Useful for debugging, staging, and intermediate calculations

    Example:

    CREATE TEMP TABLE employee_temp AS
    SELECT *
    FROM employees;


==================================================
SUMMARY
==================================================

    CTAS:
    Persistent snapshot
    ↓
    Stores data permanently
    ↓
    Best for creating new datasets


    VIEW:
    Always live
    ↓
    Stores query only
    ↓
    Best for reusable queries


    TEMP TABLE:
    Ephemeral workspace
    ↓
    Temporary stored data
    ↓
    Best for intermediate analysis
*/


-- .read Lessons/1.21/1.21_DDL_DML_Pt2.sql

-- CTAS --

CREATE OR REPLACE TABLE staging.job_postings_flat AS 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.company_id,
    cd.name                 AS company_name,
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id;


SELECT COUNT(*)
FROM staging.job_postings_flat;

SELECT *
FROM staging.job_postings_flat
LIMIT 10;

-- VIEW --

CREATE OR REPLACE VIEW staging.priority_jobs_flat_view AS
SELECT
    jpf.*
FROM staging.job_postings_flat AS jpf
JOIN staging.priority_roles AS r 
    ON jpf.job_title_short = r.role_name
WHERE r.priority_lvl = 1;

SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM staging.priority_jobs_flat_view
GROUP BY job_title_short
ORDER BY job_count DESC;


-- CREATE TEMP TABLE --

CREATE TEMPORARY TABLE senior_jobs_flat_temp AS
SELECT *
FROM staging.priority_jobs_flat_view
WHERE job_title_short = 'Senior Data Engineer';

SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM senior_jobs_flat_temp
GROUP BY job_title_short
ORDER BY job_count DESC;





--- DELETE ---

/*
==================================================
DELETE vs TRUNCATE vs DROP TABLE
==================================================

1. DELETE
--------------------------------------------------
    Purpose:
    - Remove specific rows from a table

    Syntax:
    DELETE FROM table_name
    WHERE condition;

    Characteristics:
    - Keeps table schema
    - Supports WHERE clause
    - Can delete selected rows
    - Slower for large tables
    - Best for targeted row removal


    Example:
    DELETE FROM employees
    WHERE employee_id = 101;


==================================================

2. TRUNCATE
--------------------------------------------------
    Purpose:
    - Remove all rows from a table quickly

    Syntax:
    TRUNCATE TABLE table_name;

    Characteristics:
    - Keeps table schema
    - Removes all rows
    - No WHERE clause
    - Faster than DELETE
    - Resets table to empty state


    Example:
    TRUNCATE TABLE employees;


==================================================

3. DROP TABLE
--------------------------------------------------
    Purpose:
    - Remove the entire table object

    Syntax:
    DROP TABLE table_name;

    Characteristics:
    - Removes table schema and data
    - Deletes the table object
    - Breaks dependencies
    - Table must be recreated before use


    Example:
    DROP TABLE employees;


==================================================

SUMMARY
==================================================

DELETE   -> Remove selected rows
TRUNCATE -> Remove all rows quickly
DROP     -> Remove entire table

==================================================
*/


-- DELETE --

SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.priority_jobs_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;

DELETE FROM staging.job_postings_flat
WHERE job_posted_date < '2024-01-01';

SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.priority_jobs_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;


-- TRUNCATE --

TRUNCATE TABLE staging.job_postings_flat;

INSERT INTO staging.job_postings_flat
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.company_id,
    cd.name                 AS company_name,
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
WHERE job_posted_date >= '2024-01-01';

SELECT COUNT(*) FROM staging.job_postings_flat;
SELECT COUNT(*) FROM staging.priority_jobs_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;