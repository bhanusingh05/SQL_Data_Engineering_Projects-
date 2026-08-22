-- LESSON 01: SQL FOUNDATIONS
-- Goal: inspect a fact table before making assumptions about the data.

-- Select only the columns needed for a first sample.
SELECT
    job_id,
    job_title_short,
    job_location,
    job_work_from_home,
    salary_year_avg
FROM job_postings_fact
LIMIT 10;

-- Aliases make result sets easier to read for analysts and downstream users.
SELECT
    job_title_short AS role,
    job_location AS location,
    salary_year_avg AS annual_salary
FROM job_postings_fact
WHERE job_work_from_home = TRUE
LIMIT 10;

-- DISTINCT answers a quick categorical question without aggregation.
SELECT DISTINCT job_title_short
FROM job_postings_fact
ORDER BY job_title_short;

-- Practice: replace the title column with another categorical field and explain
-- what the result tells you about the data model.
