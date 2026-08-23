-- HOW TO RUN IN DUCKDB:
-- .read Lessons/practice/02_DDL_DML_Pt2.sql
-- The source tables are expected in the attached data_jobs database.

SELECT '01 - Preparing the staging schema' AS step;
CREATE SCHEMA IF NOT EXISTS staging;

-- Preview job postings together with their company details.
SELECT '02 - Previewing joined job and company data' AS step;
SELECT
	jpf.job_id,
	jpf.job_title_short,
	jpf.job_title,
	jpf.job_location,
	jpf.job_work_from_home,
	jpf.salary_year_avg,
	jpf.company_id,
	cd.name AS company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
	ON jpf.company_id = cd.company_id
LIMIT 10;


-- 03 - Rebuild the flattened table with CTAS.
SELECT '03 - Rebuilding job_postings_flat' AS step;

CREATE OR REPLACE TABLE staging.job_postings_flat AS
SELECT
	jpf.job_id,
	jpf.job_title_short,
	jpf.job_title,
	jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
	jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
	jpf.salary_year_avg,
	jpf.salary_hour_avg,
	jpf.company_id,
	cd.name AS company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
	ON jpf.company_id = cd.company_id;


SELECT COUNT(*) AS flattened_row_count
FROM staging.job_postings_flat;



-- 04 - Rebuild a view containing only priority roles.
SELECT '04 - Rebuilding the priority jobs view' AS step;

create or replace view staging.priority_jobs_flat_view as
SELECT jpf.*
from staging.job_postings_flat as jpf
join staging.priority_roles AS r
on jpf.job_title_short = r.role_name
where r.priority_lvl = 1;

SELECT COUNT(*) AS priority_view_row_count
FROM staging.priority_jobs_flat_view;


SELECT
	job_title_short,
	COUNT(*) AS posting_count
from staging.priority_jobs_flat_view
group by job_title_short
ORDER BY posting_count DESC;




-- 05 - Rebuild a temporary analysis table for senior roles.
SELECT '05 - Rebuilding the senior jobs temporary table' AS step;

CREATE OR REPLACE TEMPORARY TABLE senior_jobs_flat_temp AS
SELECT *
FROM staging.priority_jobs_flat_view
where job_title_short = 'Senior Data Engineer';

SELECT *
FROM senior_jobs_flat_temp;

SELECT COUNT(*) AS senior_jobs_temp_row_count
FROM senior_jobs_flat_temp;

-- ---------------------------------------------------------------------------
-- 6. FINAL ROW-COUNT SUMMARY
-- ---------------------------------------------------------------------------

SELECT '06 - Counting rows in all tables and analysis objects' AS step;

SELECT
	'data_jobs.job_postings_fact' AS table_name,
	COUNT(*) AS row_count
FROM data_jobs.job_postings_fact

UNION ALL

SELECT
	'data_jobs.company_dim' AS table_name,
	COUNT(*) AS row_count
FROM data_jobs.company_dim

UNION ALL

SELECT
	'staging.job_postings_flat' AS table_name,
	COUNT(*) AS row_count
FROM staging.job_postings_flat

UNION ALL

SELECT
	'staging.priority_jobs_flat_view' AS table_name,
	COUNT(*) AS row_count
FROM staging.priority_jobs_flat_view

UNION ALL

SELECT
	'senior_jobs_flat_temp' AS table_name,
	COUNT(*) AS row_count
FROM senior_jobs_flat_temp

ORDER BY table_name;

-- ---------------------------------------------------------------------------
-- 7. DELETE RECENT ROWS FROM THE FLAT TABLE
-- ---------------------------------------------------------------------------

SELECT '07 - Preparing to delete rows posted after 2024-01-01' AS step;

-- Preview the number of rows affected before changing the table.
SELECT COUNT(*) AS rows_to_delete
FROM staging.job_postings_flat
WHERE job_posted_date > DATE '2024-01-01';

-- Delete only from the derived flat table. The source fact table is preserved.
DELETE FROM staging.job_postings_flat
WHERE job_posted_date > DATE '2024-01-01';

SELECT '07a - Flat table after DELETE' AS step;
SELECT COUNT(*) AS remaining_flat_rows
FROM staging.job_postings_flat;

-- ---------------------------------------------------------------------------
-- 8. TRUNCATE AND RELOAD THE FLAT TABLE
-- ---------------------------------------------------------------------------

SELECT '08 - Comparing the flat table before TRUNCATE' AS step;
SELECT COUNT(*) AS rows_before_truncate
FROM staging.job_postings_flat;

-- TRUNCATE removes every row but keeps the table definition.
TRUNCATE TABLE staging.job_postings_flat;

SELECT '08a - Comparing the flat table after TRUNCATE' AS step;
SELECT COUNT(*) AS rows_after_truncate
FROM staging.job_postings_flat;

-- Reload only recent postings from the source fact and company tables.
INSERT INTO staging.job_postings_flat (
	job_id,
	job_title_short,
	job_title,
	job_location,
	job_via,
	job_schedule_type,
	job_work_from_home,
	search_location,
	job_posted_date,
	job_no_degree_mention,
	job_health_insurance,
	job_country,
	salary_rate,
	salary_year_avg,
	salary_hour_avg,
	company_id,
	company_name
)
SELECT
	jpf.job_id,
	jpf.job_title_short,
	jpf.job_title,
	jpf.job_location,
	jpf.job_via,
	jpf.job_schedule_type,
	jpf.job_work_from_home,
	jpf.search_location,
	jpf.job_posted_date,
	jpf.job_no_degree_mention,
	jpf.job_health_insurance,
	jpf.job_country,
	jpf.salary_rate,
	jpf.salary_year_avg,
	jpf.salary_hour_avg,
	jpf.company_id,
	cd.name AS company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
	ON jpf.company_id = cd.company_id
WHERE jpf.job_posted_date > DATE '2024-01-01';

SELECT '08b - Comparing the flat table after INSERT' AS step;
SELECT COUNT(*) AS rows_after_insert
FROM staging.job_postings_flat;

SELECT
	job_id,
	job_title_short,
	job_posted_date,
	company_name
FROM staging.job_postings_flat
ORDER BY job_posted_date DESC NULLS LAST
LIMIT 10;

-- ---------------------------------------------------------------------------
-- 9. CREATE, DISPLAY, DROP, AND VERIFY A SAMPLE TABLE
-- ---------------------------------------------------------------------------

SELECT '09 - Creating a sample table' AS step;

-- Drop first so this demonstration is safe to rerun.
DROP TABLE IF EXISTS staging.sample_cleanup_table;

CREATE TABLE staging.sample_cleanup_table (
	sample_id INTEGER,
	sample_name VARCHAR
);

INSERT INTO staging.sample_cleanup_table (sample_id, sample_name)
VALUES
	(1, 'TRUNCATE demonstration'),
	(2, 'DROP TABLE demonstration');

SELECT *
FROM staging.sample_cleanup_table
ORDER BY sample_id;

SELECT '09a - Dropping the sample table' AS step;
DROP TABLE IF EXISTS staging.sample_cleanup_table;

-- Querying the catalog instead of selecting from the dropped table avoids an
-- error while proving that the table no longer exists.
SELECT
	table_schema,
	table_name
FROM information_schema.tables
WHERE table_schema = 'staging'
  AND table_name = 'sample_cleanup_table';
