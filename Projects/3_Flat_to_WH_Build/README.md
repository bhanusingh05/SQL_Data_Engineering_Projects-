# Flat Data to Star Schema

A documented transformation pattern for converting a flat job-postings source into the normalized model used by the EDA project.

![Data model](../../Resources/data_model.svg)

## Problem

Flat source files are convenient to export but difficult to analyze when company attributes are repeated and skills are stored as an embedded list. The target model separates facts, dimensions, and the many-to-many job-to-skill relationship.

## Transformation Plan

1. Stage the raw source in `job_postings_flat`.
2. Deduplicate companies into `company_dim`.
3. Split and deduplicate skills into `skills_dim`.
4. Populate `job_postings_fact` with a company foreign key.
5. Populate `skills_job_dim` as the bridge table.
6. Validate row counts and unmatched keys.

The source table and embedded-list delimiter vary by ingestion system, so the final parsing expression must be adapted to the actual raw schema. The included portfolio work documents the target design and validation contract without pretending that a source file is present in this repository.

## Data Modeling Skills

- Star schema design and grain definition
- Dimension deduplication
- Surrogate-key generation with window functions
- Many-to-many bridge-table modeling
- Referential-integrity and completeness checks
