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
SELECT
	jpf.*,
	cd.*
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd
	ON jpf.company_id = cd.company_id;
