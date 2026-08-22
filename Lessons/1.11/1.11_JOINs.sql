SELECT 
    jpf.*,
    cd.*
FROM 
    job_postings_fact As jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
    limit 10;

SELECT 
    jpf.job_id,
    jpf.job_title_short,
    jpf.company_id,
    cd.company_id
FROM 
    job_postings_fact As jpf
LEFT JOIN company_dim AS cd
    ON jpf.company_id = cd.company_id
    limit 10;