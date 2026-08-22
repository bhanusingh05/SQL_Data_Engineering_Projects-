select 
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
from 
    job_postings_fact
limit 10;  

select * from company_dim limit 10;

select * from information_schema.tables;