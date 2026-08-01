
-- CREATE TEMP Table (Source Table)
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM
    data_jobs.job_postings_fact AS jpf 
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles AS r 
    ON jpf.job_title_short = r.role_name;


-- -- UPDATE Statement
-- /*
-- Basic UPDATE syntax:

--     UPDATE target_table
--     SET column1 = new_value1,
--         column2 = new_value2
--     WHERE condition;
-- */
-- UPDATE main.priority_jobs_snapshot AS tgt
-- SET 
--     priority_lvl = src.priority_lvl,
--     updated_at = src.updated_at
-- FROM src_priority_jobs AS src
-- WHERE tgt.job_id = src.job_id
--     AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;
     
-- -- INSERT Statement
-- INSERT INTO main.priority_jobs_snapshot (
--     job_id,              
--     job_title_short,     
--     company_name,        
--     job_posted_date,     
--     salary_year_avg,     
--     priority_lvl,        
--     updated_at
-- )
-- SELECT
--     src.job_id,              
--     src.job_title_short,     
--     src.company_name,        
--     src.job_posted_date,     
--     src.salary_year_avg,     
--     src.priority_lvl,        
--     src.updated_at
-- FROM src_priority_jobs AS src
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM main.priority_jobs_snapshot AS tgt
--     WHERE tgt.job_id = src.job_id 
-- );

-- -- DELETE Statement
-- /*
-- Basic pattern:

--     DELETE FROM table_name
--     WHERE condition;
-- */
-- DELETE FROM main.priority_jobs_snapshot AS tgt
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM src_priority_jobs AS src
--     WHERE src.job_id = tgt.job_id 
-- );

--MERGE INTO
MERGE INTO main.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id

--INSERT & UPDATE
WHEN MATCHED AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl THEN
    UPDATE SET
        priority_lvl = src.priority_lvl,
        updated_at = src.updated_at 

WHEN NOT MATCHED THEN
    INSERT(
    job_id,              
    job_title_short,     
    company_name,        
    job_posted_date,     
    salary_year_avg,     
    priority_lvl,        
    updated_at
)
VALUES(
    src.job_id,              
    src.job_title_short,     
    src.company_name,        
    src.job_posted_date,     
    src.salary_year_avg,     
    src.priority_lvl,        
    src.updated_at
)

--DELETE
WHEN NOT MATCHED BY SOURCE THEN DELETE;

-- Final Check Query
SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;

-- CTAs for Creating Table
CREATE OR REPLACE TABLE priority_jobs_snapshot AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd. name AS company_name,
    jpf.job_posted_date,
    jpf. salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP AS updated_at
FROM
    data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs. company_dim AS cd
    ON jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles AS r
    ON jpf.job_title_short = r.role_name;


-- .read Lessons/1.24/priority_jobs_snapshot.sql


-- MERGE INTO
/*
        ====================================================
        MERGE STATEMENT
        ====================================================

        Purpose:
        - Combines INSERT, UPDATE, and DELETE operations into one statement.
        - Compares a source table with a target table using a matching condition.

        Syntax:

        MERGE INTO target_table AS tgt
        USING source_table AS src
        ON tgt.key_column = src.key_column

        WHEN MATCHED THEN
            UPDATE

        WHEN NOT MATCHED THEN
            INSERT

        WHEN NOT MATCHED BY SOURCE THEN
            DELETE


        ====================================================
        MERGE COMPONENTS
        ====================================================

        1. TARGET TABLE
        ----------------------------------------------------
        The table that receives changes.

        Example:
        MERGE INTO main.customer AS tgt

        Alias:
        tgt = target table


        2. SOURCE TABLE
        ----------------------------------------------------
        The table containing new or updated data.

        Example:
        USING staging.customer_updates AS src

        Alias:
        src = source table


        3. MATCH CONDITION
        ----------------------------------------------------
        Defines how rows are compared between source and target.

        Example:
        ON tgt.customer_id = src.customer_id


        ====================================================
        MERGE OPERATIONS
        ====================================================

        1. MATCHED ROWS
        ----------------------------------------------------
        Condition:
        Source row matches existing target row.

        Comparison:
        tgt.key_column = src.key_column

        Action:
        - UPDATE existing rows
        - Keep target row and apply changes


        2. UNMATCHED INCOMING ROWS
        ----------------------------------------------------
        Condition:
        Source row exists but no matching target row.

        Comparison:
        src.key_column does not exist in target table.

        Action:
        - INSERT new rows into target table


        3. UNMATCHED EXISTING ROWS
        ----------------------------------------------------
        Condition:
        Target row exists but no matching source row.

        Comparison:
        tgt.key_column does not exist in source table.

        Action:
        - DELETE old rows from target table

        ====================================================
        MERGE FLOW
        ====================================================

        SOURCE TABLE
            |
            v
        Compare using ON condition
            |
            +-----------------------------+
            |                             |
        MATCHED                    UNMATCHED
            |                             |
        UPDATE                    INSERT NEW ROW
            |
            |
        UNMATCHED EXISTING
            |
        DELETE OLD ROW

        ====================================================
*/



-- UPDATE / INSERT /DELETE - Refresher

/*
==================================================
UPDATE, INSERT & DELETE
Source vs Target Table
==================================================

Scenario

Source Table (src_priority_jobs)
        │
        ▼
Target Table (priority_jobs_snapshot)

Compare records using the primary key (e.g., job_id).

==================================================
Row Matching Logic
==================================================

                 Target Table
        ┌──────────────────────────────┐
        │ Existing Records             │
        └──────────────────────────────┘

          Source            Target

        Unmatched          Unmatched
        Incoming           Existing
          Rows               Rows
             \               /
              \             /
               \  Matched  /
                \   Rows  /
                 \       /

==================================================
1. INSERT
==================================================

Condition:
- Row exists in Source.
- Row does NOT exist in Target.

Action:
- Add the new record to the target table.

Example:

INSERT INTO priority_jobs_snapshot (...)
SELECT ...
FROM src_priority_jobs AS src
WHERE NOT EXISTS (
    SELECT 1
    FROM priority_jobs_snapshot AS tgt
    WHERE src.job_id = tgt.job_id
);

Result:
✔ New records are inserted.

==================================================
2. UPDATE
==================================================

Condition:
- Row exists in both Source and Target.

Action:
- Update the existing record in the target table.

Example:

UPDATE priority_jobs_snapshot AS tgt
SET
    salary_year_avg = src.salary_year_avg,
    priority_lvl    = src.priority_lvl,
    updated_at      = CURRENT_TIMESTAMP
FROM src_priority_jobs AS src
WHERE tgt.job_id = src.job_id;

Result:
✔ Existing records are refreshed.

==================================================
3. DELETE
==================================================

Condition:
- Row exists in Target.
- Row no longer exists in Source.

Action:
- Remove obsolete records from the target table.

Example:

DELETE FROM priority_jobs_snapshot AS tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM src_priority_jobs AS src
    WHERE src.job_id = tgt.job_id
);

Result:
✔ Stale records are removed.

==================================================
Visual Summary
==================================================

Source Table                      Target Table

(Unmatched Incoming)
        INSERT
           │
           ▼

      (Matched Rows)
         UPDATE

           ▲
           │
        DELETE
(Unmatched Existing)

==================================================
Comparison
==================================================

Row Status                     Action
--------------------------------------------------
Source only                    INSERT
Source + Target                UPDATE
Target only                    DELETE

==================================================
Typical ETL Workflow
==================================================

Step 1
Update existing records.

Step 2
Insert new records.

Step 3
Delete obsolete records (optional).

This process synchronizes the target table with
the latest data from the source table.

==================================================
Memory Aid
==================================================

Source Only
→ INSERT

Both Tables
→ UPDATE

Target Only
→ DELETE

==================================================
*/
