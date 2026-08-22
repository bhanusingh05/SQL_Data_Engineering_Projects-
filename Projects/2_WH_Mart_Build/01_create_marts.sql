-- PROJECT 2: BUILD REUSABLE ANALYTICAL MARTS
-- Run against the normalized source tables in the project database.

DROP TABLE IF EXISTS skills_demand_mart;
CREATE TABLE skills_demand_mart AS
SELECT
    sd.skill_id,
    sd.skills,
    jpf.job_title_short,
    jpf.job_work_from_home,
    COUNT(*) AS posting_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
GROUP BY sd.skill_id, sd.skills, jpf.job_title_short, jpf.job_work_from_home;

DROP TABLE IF EXISTS salary_benchmark_mart;
CREATE TABLE salary_benchmark_mart AS
SELECT
    sd.skill_id,
    sd.skills,
    jpf.job_title_short,
    COUNT(*) AS posting_count,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    ROUND(AVG(jpf.salary_year_avg), 0) AS average_salary
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skill_id, sd.skills, jpf.job_title_short;

DROP TABLE IF EXISTS company_hiring_mart;
CREATE TABLE company_hiring_mart AS
SELECT
    cd.company_id,
    cd.name AS company_name,
    jpf.job_title_short,
    COUNT(*) AS posting_count,
    COUNT(jpf.salary_year_avg) AS postings_with_salary
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
GROUP BY cd.company_id, cd.name, jpf.job_title_short;
