-- MOTHERDUCK SETUP:
-- Run this file from a DuckDB session with MotherDuck access.
-- The md:data_jobs path reconnects to the existing MotherDuck database.
ATTACH IF NOT EXISTS 'md:data_jobs' AS data_jobs;

-- STEP 1: List databases attached to the current DuckDB session.
SELECT '01 - Reloading and listing the data_jobs database' AS step;
SHOW DATABASES;

-- STEP 2: Select the reloaded data_jobs database.
USE data_jobs;

-- STEP 3: Join job postings with company details.

-- Inspect the structure of the job-postings fact table.
SELECT '03a - Describing job_postings_fact' AS step;
DESCRIBE job_postings_fact;

-- Inspect the structure of the company dimension table.
SELECT '03b - Describing company_dim' AS step;
DESCRIBE company_dim;

-- Preview job postings together with their company details.
SELECT '03c - Previewing joined job and company data' AS step;
SELECT
	jpf.job_id,
	jpf.job_title_short,
	jpf.job_title,
	jpf.job_location,
	jpf.job_work_from_home,
	jpf.salary_year_avg,
	jpf.company_id,
	cd.name AS company_name
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
	ON jpf.company_id = cd.company_id
LIMIT 10;
