-- LESSON 05: RELATIONAL JOINS
-- Goal: combine normalized tables without losing or multiplying the wrong rows.

-- INNER JOIN keeps only postings that have a matching company.
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name
FROM job_postings_fact AS jpf
INNER JOIN company_dim AS cd ON jpf.company_id = cd.company_id
LIMIT 20;

-- LEFT JOIN is useful when checking whether dimension coverage is complete.
SELECT
    COUNT(*) AS total_postings,
    COUNT(cd.company_id) AS matched_companies,
    COUNT(*) - COUNT(cd.company_id) AS unmatched_companies
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id;

-- The bridge table represents a many-to-many relationship: one job can list
-- many skills, and one skill can occur in many jobs.
SELECT
    jpf.job_id,
    cd.name AS company_name,
    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
LIMIT 30;

-- Practice: find companies with at least five Data Engineer postings.
