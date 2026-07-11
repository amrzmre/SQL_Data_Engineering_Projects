/*
Question: What are the most optimal skills for data engineers-balancing both demand
and salary?

. Create a ranking column that combines demand count and median salary to identify
the most valuable skills.

. Focus only on remote Data Engineer positions with specified annual salaries.

· Why?

    . This approach highlights skills that balance market demand and financial reward.
    It weights core skills appropriately, rather than letting rare, outlier skills distort the
    results.
*/


SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    COUNT(jpf.salary_year_avg) AS corrected_demand_count
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    median_salary DESC
LIMIT 25;


SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.salary_year_avg) AS demand_count
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    median_salary DESC
LIMIT 25;




--ranking column

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.salary_year_avg) AS demand_count,
    MEDIAN(jpf.salary_year_avg) * COUNT(jpf.salary_year_avg) AS optimal_score
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;


-- could list aliases, but only allow certain db, so dont use it
/*
SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.salary_year_avg) AS demand_count,
    MEDIAN(jpf.salary_year_avg) * COUNT(jpf.salary_year_avg) AS optimal_score,
    median_salary * demand_count
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;

*/


SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.salary_year_avg) AS demand_count,
    MEDIAN(jpf.salary_year_avg) * COUNT(jpf.salary_year_avg) AS optimal_score
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;

/*
Key Insights from the Data:
    
    -The Core Duo: Python (1,133) and SQL (1,128) lead the pack by a wide margin, 
    establishing themselves as foundational pillars for any data engineering role.

    -Cloud Dominance: AWS is the leading cloud provider with 783 mentions, 
    followed by Azure (475) and GCP (196).

   -Big Data & Data Warehousing: Spark (503) and Snowflake (438) continue to 
    show robust enterprise demand for data processing and warehousing solutions.

    -Orchestration & Streaming: Airflow (386) remains the dominant workflow orchestration tool,
    while Kafka (292) leads for real-time streaming pipelines.

-exponential growth of skills ranked (low to high)

┌────────────┬───────────────┬──────────────┬─────────────────┐
│   skills   │ median_salary │ demand_count │  optimal_score  │
│  varchar   │    double     │    int64     │     double      │
├────────────┼───────────────┼──────────────┼─────────────────┤
│ python     │      135000.0 │         1133 │     152955000.0 │
│ sql        │      130000.0 │         1128 │     146640000.0 │
│ aws        │      137320.0 │          783 │  107521804.6875 │
│ spark      │      140000.0 │          503 │      70420000.0 │
│ azure      │      128000.0 │          475 │      60800000.0 │
│ snowflake  │      135500.0 │          438 │      59349000.0 │
│ airflow    │      150000.0 │          386 │      57900000.0 │
│ kafka      │      145000.0 │          292 │      42340000.0 │
│ java       │      135000.0 │          303 │      40905000.0 │
│ redshift   │      130000.0 │          274 │      35620000.0 │
│ terraform  │      184000.0 │          193 │      35512000.0 │
│ databricks │      132750.0 │          266 │      35311500.0 │
│ scala      │      137290.0 │          247 │ 33910749.640625 │
│ git        │      140000.0 │          208 │      29120000.0 │
│ hadoop     │      135000.0 │          198 │      26730000.0 │
│ gcp        │      136000.0 │          196 │      26656000.0 │
│ nosql      │      134415.0 │          193 │      25942095.0 │
│ kubernetes │      150500.0 │          147 │      22123500.0 │
│ pyspark    │      140000.0 │          152 │      21280000.0 │
│ docker     │      135000.0 │          144 │      19440000.0 │
│ tableau    │      115000.0 │          164 │      18860000.0 │
│ mongodb    │      135750.0 │          136 │      18462000.0 │
│ r          │      134775.0 │          133 │      17925075.0 │
│ github     │      135000.0 │          127 │      17145000.0 │
│ sql server │      120000.0 │          139 │      16680000.0 │
├────────────┴───────────────┴──────────────┴─────────────────┤
│ 25 rows                                           4 columns │


*/


/*
there's function could use to smooth line out (exponential growth)

Natural Log
    - great compressing large values. that python & sql dont dominate.
    - note that the scale is going the change when we apply,
    but the order not going to
    - so it's better option
*/


-- convert demand count to narutal log
-- have error in this query, have to value 1 or greater
SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.salary_year_avg) AS demand_count,
    LN(COUNT(jpf.salary_year_avg)) AS ln_demand_count,
    MEDIAN(jpf.salary_year_avg) * COUNT(jpf.salary_year_avg) AS optimal_score
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;


/*
-prob bc some of these skills have count of 0,
-need to remove the skills before stick to natural log
-bc order of execution (specifically, step  2 - WHERE to filter
step 3 GROUP BY to performs that aggregation)
*/


SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.salary_year_avg) AS demand_count,
    LN(COUNT(jpf.*)) AS ln_demand_count,
    MEDIAN(jpf.salary_year_avg) * COUNT(jpf.salary_year_avg) AS optimal_score
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;
-- NL perform bc no skills w/o associated salary
-- so no skills w count of les than zero


SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    LN(COUNT(jpf.*)) AS ln_demand_count,
    MEDIAN(jpf.salary_year_avg) * COUNT(jpf.*) AS optimal_score
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;


-- take LN(COUNT(jpf.*)) and replace in optimal score
SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    LN(COUNT(jpf.*)) AS ln_demand_count,
    MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)) AS optimal_score
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;


-- clean too many decimals (nl_demand_count)
-- no longer need demand_count anymore

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
--    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)) AS optimal_score
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;


-- convert optimal_score decimal as small as possible

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
--    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    (MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000 AS optimal_score
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;


-- do the round for optimal score

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
--    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000, 2) AS optimal_score
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    optimal_score DESC
LIMIT 25;

/*

Key Insights Summary:

    • Terraform has the highest salary potential ($184K), showing strong value 
    for cloud infrastructure and automation skills.

    • Python and SQL are the most essential skills due to the highest demand, 
    making them the foundation for data engineering careers.

    • Cloud platforms such as AWS, Azure, and GCP are critical because 
    modern data systems are increasingly cloud-based.

    • Airflow and Spark are highly valuable because companies need 
    engineers who can build and manage large-scale data pipelines.

    • Kafka represents a high-value specialization for real-time data processing,
    especially in large-scale systems.

    • Data engineering is becoming closer to software engineering, 
    with skills like Git, Docker, and Kubernetes becoming more relevant.

    • The strongest skill combination for career growth is:
    Python + SQL + AWS + Airflow + Spark + Terraform

    This combination provides the best balance of job demand, 
    salary potential, and industry relevance.

┌────────────┬───────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ ln_demand_count │ optimal_score │
│  varchar   │    double     │     double      │    double     │
├────────────┼───────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │             5.3 │          0.97 │
│ python     │      135000.0 │             7.0 │          0.95 │
│ aws        │      137320.0 │             6.7 │          0.91 │
│ sql        │      130000.0 │             7.0 │          0.91 │
│ airflow    │      150000.0 │             6.0 │          0.89 │
│ spark      │      140000.0 │             6.2 │          0.87 │
│ snowflake  │      135500.0 │             6.1 │          0.82 │
│ kafka      │      145000.0 │             5.7 │          0.82 │
│ azure      │      128000.0 │             6.2 │          0.79 │
│ java       │      135000.0 │             5.7 │          0.77 │
│ scala      │      137290.0 │             5.5 │          0.76 │
│ git        │      140000.0 │             5.3 │          0.75 │
│ kubernetes │      150500.0 │             5.0 │          0.75 │
│ databricks │      132750.0 │             5.6 │          0.74 │
│ redshift   │      130000.0 │             5.6 │          0.73 │
│ gcp        │      136000.0 │             5.3 │          0.72 │
│ nosql      │      134415.0 │             5.3 │          0.71 │
│ hadoop     │      135000.0 │             5.3 │          0.71 │
│ pyspark    │      140000.0 │             5.0 │           0.7 │
│ docker     │      135000.0 │             5.0 │          0.67 │
│ mongodb    │      135750.0 │             4.9 │          0.67 │
│ go         │      140000.0 │             4.7 │          0.66 │
│ r          │      134775.0 │             4.9 │          0.66 │
│ github     │      135000.0 │             4.8 │          0.65 │
│ bigquery   │      135000.0 │             4.8 │          0.65 │
├────────────┴───────────────┴─────────────────┴───────────────┤
│ 25 rows                                            4 columns │
└──────────────────────────────────────────────────────────────┘

*/
