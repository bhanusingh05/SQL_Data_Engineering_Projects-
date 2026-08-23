-- STEP 1: List databases attached to the current DuckDB session.
SELECT '01 - Listing attached databases' AS step;
SHOW DATABASES;

-- STEP 2: Go back to the data_jobs database for the analysis query.
USE data_jobs;

-- STEP 3: Join job postings with company details.
select jpf.*, cd.* from job_postings_fact as jpf
left join company_dim as cd on jpf.company_id = cd.company_id;
