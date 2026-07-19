 
 -- .read Lessons/1.21/1.21_DDL_DML_Pt1.sql
 
 USE data_jobs;

 DROP DATABASE IF EXISTS jobs_mart;
 
 CREATE DATABASE IF NOT EXISTS jobs_mart;

-- IF rerun command above will be error bc aldy exist

 SHOW DATABASES;

-- DROP DB

-- DROP DATABASE IF EXISTS jobs_mart;

-- CREATE SCHEMA

SELECT *
FROM information_schema.schemata;

USE jobs_mart;

CREATE SCHEMA IF NOT EXISTS staging;

-- DROP SCHEMA staging;


-- CREATE TABLE

/*
Notes:

    . CREATE TABLE defines a new table and its columns.

    . You can scope it to a schema with schema_name. table_name

CREATE TABLE IF NOT EXISTS table_name
    id_column INTEGER PRIMARY KEY,
    column_name2 datatype,
    column_name3 datatype,
    foreign_key_column datatype,
    FOREIGN KEY (foreign_key_column) REFERENCES parent_table
(

*/

/*
CREATE TABLE prefrerred_roles (
    role_id INTEGER,
    role_name VARCHAR
);
*/

CREATE TABLE IF NOT EXISTS staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);


SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';


-- DROP TABLE

-- DROP TABLE IF EXISTS staging.preferred_roles;

-- INSERT INTO -- --

/*
. INSERT INTO adds new rows to a table.

. VALUES lets you insert one or many rows at once.

Basic pattern:

    INSERT INTO table_name (col1, col2, ... )
    VALUES (val1, val2, ... );
*/

INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Software Engineer');


SELECT *
FROM staging.preferred_roles;

-- INSERT --
-- ALTER TABLE

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

--ALTER TABLE staging.preferred_roles
--DROP COLUMN preferred_role;


-- UPDATE --

/*
- UPDATE changes existing rows.

- SET defines the new values.

- WHERE controls which rows to change.

    UPDATE table_name
    SET column_name = value
    WHERE some_condition;
*/

UPDATE staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id = 1 OR role_id=2;

UPDATE staging.preferred_roles
SET preferred_role = FALSE
WHERE role_id = 3;


--ALTER TABLE (RENAME TABLE / RENAME COLUMN / ALTER COLUMN)

-- change/rename table name

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;

-- rename column
ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

-- change value
ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

-- update
UPDATE staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3;

SELECT *
FROM staging.priority_roles;
