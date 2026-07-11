# HEADING
## HEADING 2
### HEADING 3

Normal text  
**Bold  Test**.  
*Italic Text*  
`This is code`  

- Bullet 1  
- Bullet 2  


1. number 1
2. number 2  


[Link Text](https://google.com)
![Alt text from Cloud/Internet](https://github.com/lukebarousse/SQL_Data_Engineering_Course/raw/main/Resources/images/1_1_Project1_EDA.png)  



![Prpject 1 Overview_Alt text Local - copy realative path - need ..](../Images\1_1_Project1_EDA.png)  



```sql
SELECT
    sd.skills,
    COUNT(jpf.*) AS demand_count
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
ORDER BY
    demand_count DESC
LIMIT 10;

```  


[Markdown Cheat Sheet](https://www.markdownguide.org/cheat-sheet/)
