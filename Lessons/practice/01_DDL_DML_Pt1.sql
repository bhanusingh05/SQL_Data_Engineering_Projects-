-- LESSON: DDL AND DML, PART 1
-- Topic: databases, schemas, tables, and basic data changes in DuckDB
--
-- DuckDB works with a database file and schemas inside that database. Unlike
-- some cloud warehouses, CREATE DATABASE and USE are not needed here. The
-- following script therefore creates and manages a staging schema directly.

-- ---------------------------------------------------------------------------
-- 1. DISCOVER THE CURRENT CATALOG
-- ---------------------------------------------------------------------------

-- List schemas available in the connected DuckDB database.
SELECT
    catalog_name,
    schema_name
FROM information_schema.schemata
ORDER BY schema_name;

-- Confirm whether the staging schema already exists.
SELECT
    schema_name
FROM information_schema.schemata
WHERE schema_name = 'staging';

-- ---------------------------------------------------------------------------
-- 2. CREATE THE STAGING SCHEMA
-- ---------------------------------------------------------------------------

-- IF NOT EXISTS makes this setup safe to run more than once.
CREATE SCHEMA IF NOT EXISTS staging;

-- ---------------------------------------------------------------------------
-- 3. CREATE A TABLE WITH DDL
-- ---------------------------------------------------------------------------

-- Use the correct spelling: preferred_role.
CREATE TABLE IF NOT EXISTS staging.preferred_role (
    role_id INTEGER,
    role VARCHAR
);

-- Inspect the table definition through information_schema.
SELECT
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'staging'
ORDER BY table_name;

-- ---------------------------------------------------------------------------
-- 4. INSERT AND READ ROWS WITH DML
-- ---------------------------------------------------------------------------

INSERT INTO staging.preferred_role (role_id, role)
VALUES
    (1, 'Data Engineer'),
    (2, 'Analytics Engineer'),
    (3, 'Data Analyst');

SELECT
    role_id,
    role
FROM staging.preferred_role
ORDER BY role_id;

-- Update one existing row using its key.
UPDATE staging.preferred_role
SET role = 'Senior Data Engineer'
WHERE role_id = 1;

-- Delete one row using its key.
DELETE FROM staging.preferred_role
WHERE role_id = 3;

-- Confirm the final table contents after the DML operations.
SELECT
    role_id,
    role
FROM staging.preferred_role
ORDER BY role_id;

-- ---------------------------------------------------------------------------
-- 5. CLEAN UP THE PRACTICE OBJECT
-- ---------------------------------------------------------------------------

-- Drop only the table created by this lesson. Keep the staging schema available
-- for later practice files.
DROP TABLE IF EXISTS staging.preferred_role;

-- Verify that the practice table has been removed.
SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'staging'
ORDER BY table_name;