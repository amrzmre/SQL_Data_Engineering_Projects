-- ==========================================
-- Array Intro

-- duckdb.org/docs/stable/sql/functions/array
-- ==========================================
SELECT [1, 2, 3];

SELECT ['pyhton', 'sql', 'r'] AS skills_array;


SELECT 'python' AS skill 
UNION ALL 
SELECT 'sql'
UNION ALL 
SELECT 'r';

-- ARRAY
WITH skills AS (
    SELECT 'python' AS skill 
    UNION ALL 
    SELECT 'sql'
    UNION ALL 
    SELECT 'r'
)
SELECT ARRAY(skill) AS skills_array 
FROM skills;


-- ARRAY_AGG
WITH skills AS (
    SELECT 'python' AS skill 
    UNION ALL 
    SELECT 'sql'
    UNION ALL 
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills 
    FROM skills
)
SELECT
    skills
FROM skills_array;

-- access by using index but the output not in order
WITH skills AS (
    SELECT 'python' AS skill 
    UNION ALL 
    SELECT 'sql'
    UNION ALL 
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills 
    FROM skills
)
SELECT
    skills [1] AS first_skill
FROM skills_array;

--correct way
WITH skills AS (
    SELECT 'python' AS skill 
    UNION ALL 
    SELECT 'sql'
    UNION ALL 
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills 
    FROM skills
)
SELECT
    skills [1] AS first_skill,
    skills [2] AS second_skill,
    skills [3] AS third_skill
FROM skills_array;


-- ==========================================
-- Struct Intro

-- duckdb.org/docs/stable/sql/functions/struct
-- ==========================================
SELECT { skills: 'pyhton', type: 'programming' } AS skill_struct;


-- struct_pack
SELECT 
    STRUCT_PACK(
        skill := 'python',
        type := 'programming'
    ) AS s;

-- access
WITH skill_struct AS(
SELECT 
    STRUCT_PACK(
        skill := 'python',
        type := 'programming'
    ) AS s
)
SELECT
    *
FROM skill_struct;


-- dot donation
WITH skill_struct AS(
SELECT 
    STRUCT_PACK(
        skill := 'python',
        type := 'programming'
    ) AS s
)
SELECT
    s.skill,
    s.type
FROM skill_struct;
------------------------------


WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL 
    SELECT 'sql', 'query_language'
    UNION ALL 
    SELECT 'r', 'programming'
)
SELECT
    STRUCT_PACK(
        skill := skills,
        type := types
    )
FROM skill_table;


-- ==========================================
-- Array of Structs
-- ==========================================
SELECT [
    { skill: 'python', type: 'programming' },
    { skill: 'sql', type: 'query_language' }
] AS skills_array_of_structs;
------------------------


WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL 
    SELECT 'sql', 'query_language'
    UNION ALL 
    SELECT 'r', 'programming'
)
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := skills,
            type := types
        )
    )
FROM skill_table;

--access
WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL 
    SELECT 'sql', 'query_language'
    UNION ALL 
    SELECT 'r', 'programming'
), skills_array_struct AS (
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := skills,
            type := types
        )
    ) array_struct
FROM skill_table
)
SELECT
    array_struct [1],
    array_struct [2],
    array_struct [3]
FROM skills_array_struct;

--access inside
WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL 
    SELECT 'sql', 'query_language'
    UNION ALL 
    SELECT 'r', 'programming'
), skills_array_struct AS (
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := skills,
            type := types
        )
    ) array_struct
FROM skill_table
)
SELECT
    array_struct [1].skill,
    array_struct [2].type,
    array_struct [3]
FROM skills_array_struct;


-- ==========================================
-- Map Intro

-- duckdb.org/docs/stable/sql/data_types/map
-- ==========================================
SELECT MAP { 'skill': 'python', 'type': 'programming'};

-- access values
WITH skill_map AS (
    SELECT MAP { 'skill': 'python', 'type': 'programming'} AS skill_type
)
SELECT
--    *
    skill_type['skill'],
    skill_type['type']
FROM skill_map;

/*
MAP vs ARRAY<STRUCT>

Both MAP and ARRAY<STRUCT> store collections of related data.
They serve different purposes.

Feature              | ARRAY<STRUCT>                  | MAP
---------------------+-------------------------------+------------------------
Shape                | List of records                | Key-value pairs
Access               | UNNEST(array)                  | map['key']
Order                | Yes                            | No
Best for             | Analysis, relationships        | Lookups, metadata
Joins & filters      | Natural                        | Awkward
Analytics use        | Strong                         | Limited


ARRAY<STRUCT>

- Stores multiple records with different fields.
- Good for analytical queries.
- Can be expanded using UNNEST().
- Maintains order.

Example:

[
  {name: 'SQL', level: 'Advanced'},
  {name: 'Python', level: 'Intermediate'}
]


MAP

- Stores data as key-value pairs.
- Used for quick lookups.
- Access values using a key.
- Does not maintain order.

Example:

{
  'SQL': 'Advanced',
  'Python': 'Intermediate'
}


Summary:

ARRAY<STRUCT>
→ Best for analysis and relationships.

MAP
→ Best for simple lookups and metadata.
*/


-- ==========================================
-- JSON

-- duckdb.org/docs/stable/data/json/json_fucntions
-- ==========================================
SELECT
    '{"skill":"python", "type":"programming"}':: JSON AS skill_json;

--alt
-- SELECT
--     TO_JSON('{"skill":"python", "type":"programming"}')AS skill_json;


-- transfer this into another datatype
WITH raw_skill_json AS (
SELECT
    '{"skill":"python", "type":"programming"}':: JSON AS skill_json
)
SELECT 
    skill_json 
FROM raw_skill_json;

--putting into struct
-- json_extract_string(json,path)
WITH raw_skill_json AS (
SELECT
    '{"skill":"python", "type":"programming"}':: JSON AS skill_json
)
SELECT
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
FROM raw_skill_json;

-- JSON to Array of Structs
WITH raw_json AS (
SELECT
'[
{"skill":"python","type":"programming"},
{"skill":"sql","type":"query_language"},
{"skill":"r","type":"programming"}
]':: JSON AS skills_json
)
SELECT
    ARRAY_AGG(
    STRUCT_PACK(
    skill := json_extract_string(e.value, '$.skill'),
    type := json_extract_string(e.value, '$. type')
    )
    ORDER BY json_extract_string(e.value, '$.skill')
    ) AS skills
FROM raw_json, json_each(skills_json) AS e;


-- ==========================================
-- Array - Final Example
-- ==========================================
-- Build a flat skill table for co-workers to access job 
-- titles, salary info, and skills in one table


/*
Database Schema: Job Postings Data Model

Table: job_postings_fact

| Column Name            | Key |
|------------------------|-----|
| job_id                | PK  |
| company_id            | FK  |
| job_title_short       |     |
| job_title             |     |
| job_location          |     |
| job_via               |     |
| job_schedule_type     |     |
| job_work_from_home    |     |
| search_location       |     |
| job_posted_date       |     |
| job_no_degree_mentioned |   |
| job_health_insurance  |     |
| job_country           |     |
| salary_rate           |     |
| salary_year_avg       |     |
| salary_hour_avg       |     |


Table: company_dim

| Column Name | Key |
|-------------|-----|
| company_id  | PK  |
| name        |     |
| link        |     |
| link_google |     |
| thumbnail   |     |


Table: skills_job_dim

| Column Name | Key   |
|-------------|-------|
| job_id      | PK/FK |
| skill_id    | PK/FK |


Table: skills_dim

| Column Name | Key |
|-------------|-----|
| skill_id    | PK  |
| skills      |     |
| type        |     |


Relationships

| From Table        | Column      | To Table        | Column      | Relationship |
|-------------------|-------------|-----------------|-------------|--------------|
| job_postings_fact | company_id  | company_dim     | company_id  | Many-to-One  |
| job_postings_fact | job_id      | skills_job_dim  | job_id      | One-to-Many  |
| skills_job_dim    | skill_id    | skills_dim      | skill_id    | Many-to-One  |


Schema Type

| Type              | Table             |
|-------------------|-------------------|
| Fact Table        | job_postings_fact |
| Dimension Table   | company_dim       |
| Dimension Table   | skills_dim        |
| Bridge Table      | skills_job_dim    |
*/

SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    sd.skills
FROM job_postings_fact AS jpf 
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id 
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id;

-- want skills within one array
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf 
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id 
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

--put this in temp table, then shift roles in how about analyzing those skills in an array

CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf 
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id 
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- From the perspective of a Data Analyst, analyze the median salary per skill

--example unnest below
-- WITH skills AS (
--     SELECT 'python' AS skill 
--     UNION ALL 
--     SELECT 'sql'
--     UNION ALL 
--     SELECT 'r'
-- ), skills_array AS (
--     SELECT ARRAY_AGG(skill ORDER BY skill) AS skills 
--     FROM skills
-- )
-- SELECT
-- -- unnest these values
--     UNNEST (skills)
-- FROM skills_array;
---------------------------------------------

CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf 
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id 
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- From the perspective of a Data Analyst, analyze the median salary per skill

WITH flat_skills AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM 
        job_skills_array 
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills 
GROUP BY skill;

/*
-- demostrated how put all of the skills within a single table
using array aggregation function

-- whoever downstream customer has the option then unnest these values
in order to do deeper insights on the skills, if they need to
*/


-- ==========================================
-- Array of Struct - Final Example
-- ==========================================
-- Build a flat skill & type table for co-workers to access job titles, salary info, skills, and type in one table

SELECT
    *
FROM
    skills_dim
LIMIT 20;
----------------

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_type
FROM job_postings_fact AS jpf 
LEFT JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id 
LEFT JOIN skills_dim AS sd 
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;

-- From the perspective of a Data Analyst, analyze the median salary per skill

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_type)
FROM 
    job_skills_array_struct;

--access inside the struct

WITH flat_skills AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_type).skill_type AS skill_type,
        UNNEST(skills_type).skill_name AS skill_name
    FROM 
        job_skills_array_struct
)
SELECT
    skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills 
GROUP BY skill_type;

/*
from table with a single row on job postings, then have the skill and type
inside of it.

then go forward and still analyze attributes about the skills
*/