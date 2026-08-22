-- LESSON 03: FILTERING AND CASE LOGIC
-- Goal: build an explicit, reviewable population for analysis.

-- ILIKE makes title matching case-insensitive in DuckDB.
SELECT
    job_id,
    job_title,
    job_title_short,
    job_location
FROM job_postings_fact
WHERE job_title ILIKE '%data engineer%'
  AND job_work_from_home = TRUE
LIMIT 25;

-- CASE converts raw values into business-friendly categories.
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg IS NULL THEN 'Salary not provided'
        WHEN salary_year_avg >= 150000 THEN 'High salary'
        WHEN salary_year_avg >= 100000 THEN 'Mid salary'
        ELSE 'Below 100K'
    END AS salary_band
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer';

-- BETWEEN is inclusive at both ends; document that choice in analysis notes.
SELECT
    job_id,
    job_title_short,
    salary_year_avg
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
  AND salary_year_avg BETWEEN 100000 AND 150000
ORDER BY salary_year_avg DESC;

-- Practice: create a remote-only flag with CASE and count each category.
