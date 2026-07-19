
-- priority roles - Table Load

CREATE OR REPLACE TABLE staging.priority_roles(
    role_id      INTEGER PRIMARY KEY,
    role_name    VARCHAR,
    priority_lvl INTEGER
);

INSERT INTO staging.priority_roles(role_id, role_name, priority_lvl)
VALUES
    (1, 'Data Engineer',        2),
    (2, 'Senior Data Engineer', 1),
    (3, 'Software Engineer',    3);


SELECT * FROM staging.priority_roles;

-- .read Lessons/1.24/priority_roles.sql



/* Notes
====================================================
CTAS vs MERGE
WHEN TO REBUILD INSTEAD
====================================================

CTAS = CREATE TABLE AS SELECT

Purpose:
- Rebuilds an entire table from a query result.
- Best when rewriting the whole dataset is faster or simpler.

MERGE:
- Updates existing rows and inserts new rows.
- Best for incremental changes.


====================================================
SCENARIO DECISION GUIDE
====================================================


1. SMALL TABLE (<10M ROWS)
----------------------------------------------------
Best Choice:
CTAS

Why:
- Rebuilding the entire table is usually fast.
- Simpler SQL logic.
- Avoids complex update conditions.

Example:

CREATE OR REPLACE TABLE target_table AS
SELECT *
FROM source_table;


====================================================

2. LARGE TABLE, <10% ROWS CHANGED
----------------------------------------------------
Best Choice:
MERGE

Why:
- Only modifies changed records.
- Avoids scanning and rewriting the entire table.
- More efficient for incremental updates.

Example:

MERGE INTO target_table AS tgt
USING source_table AS src
ON tgt.id = src.id

WHEN MATCHED THEN
    UPDATE SET ...

WHEN NOT MATCHED THEN
    INSERT ...


====================================================

3. LARGE TABLE, >50% ROWS CHANGED
----------------------------------------------------
Best Choice:
CTAS

Why:
- A large portion of the table needs updating.
- Rebuilding the whole table may be faster than many MERGE operations.
- Reduces update overhead.

Example:

CREATE OR REPLACE TABLE target_table AS
SELECT *
FROM source_table;


====================================================

4. NEED ATOMICITY
(UPSERT + DELETE)
----------------------------------------------------
Best Choice:
MERGE

Why:
- Handles multiple actions in one transaction.
- Ensures consistency between source and target.

Operations:
- UPDATE matched rows
- INSERT new rows
- DELETE missing rows


====================================================

5. LIVE TRAFFIC / NO DOWNTIME
----------------------------------------------------
Best Choice:
MERGE

Why:
- Updates the existing table directly.
- Avoids replacing the entire table.
- Reduces disruption to users and applications.


====================================================

6. INCREMENTAL CDC / STREAMING DATA
(Change Data Capture)
----------------------------------------------------
Best Choice:
MERGE

Why:
- Designed for continuous data updates.
- Processes only new or changed records.
- Common pattern in data pipelines.


====================================================
SUMMARY TABLE
====================================================

| Scenario                        | Best Choice | Reason                     |
|---------------------------------|-------------|----------------------------|
| Small table (<10M rows)          | CTAS        | Simple and fast             |
| Large table, <10% changed        | MERGE       | Updates only changed data   |
| Large table, >50% changed        | CTAS        | Rewrite is more efficient   |
| Need upsert + delete atomicity   | MERGE       | Single transaction          |
| Live traffic / no downtime       | MERGE       | In-place updates            |
| Incremental CDC / streaming      | MERGE       | Built for continuous loads  |

====================================================
RULE OF THUMB
====================================================

Use CTAS when:
- You can rebuild the table easily.
- Many rows changed.
- Simplicity matters.

Use MERGE when:
- You only have partial changes.
- You need upsert logic.
- You need continuous updates.
*/