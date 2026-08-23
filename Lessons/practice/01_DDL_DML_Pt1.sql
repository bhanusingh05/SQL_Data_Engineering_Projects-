-- HOW TO RUN IN DUCKDB:
-- 1. Start DuckDB in the jobs_mart database: duckdb jobs_mart.duckdb
-- 2. Run this file: .read Lessons/practice/01_DDL_DML_Pt1.sql
--
-- DuckDB database-lifecycle equivalent:
-- ATTACH opens or creates an attached database; DETACH removes it from the
-- current session. DETACH does not delete a database file from disk.
ATTACH IF NOT EXISTS ':memory:' AS practice_db;

-- Show the active jobs_mart database and the temporary practice database.
SHOW DATABASES;

-- jobs_mart is already the active database because it was selected when
-- DuckDB started. Remove only the temporary database from the session.
DETACH practice_db;

SHOW DATABASES;

-- ---------------------------------------------------------------------------
-- 1. DISCOVER THE CURRENT CATALOG
-- ---------------------------------------------------------------------------

-- List databases attached to the current DuckDB session.
SELECT
    database_name,
    path
FROM duckdb_databases()
ORDER BY database_name;

-- List schemas available in the connected database.
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

-- Rebuild only this lesson's schema so the script is safe to rerun and does
-- not duplicate the demonstration rows.
DROP SCHEMA IF EXISTS staging CASCADE;

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
-- 5. UPSERT DATA WITH MERGE
-- ---------------------------------------------------------------------------

-- Create a small source table containing one existing role and one new role.
CREATE TABLE staging.preferred_role_updates (
    role_id INTEGER,
    role VARCHAR
);

INSERT INTO staging.preferred_role_updates (role_id, role)
VALUES
    (1, 'Lead Data Engineer'),
    (4, 'Analytics Engineer');

-- MERGE updates the matching role and inserts the new role in one statement.
MERGE INTO staging.preferred_role AS target
USING staging.preferred_role_updates AS source
    ON target.role_id = source.role_id
WHEN MATCHED THEN
    UPDATE SET role = source.role
WHEN NOT MATCHED THEN
    INSERT (role_id, role)
    VALUES (source.role_id, source.role);

SELECT
    role_id,
    role
FROM staging.preferred_role
ORDER BY role_id;

-- ---------------------------------------------------------------------------
-- 6. CLEAN UP THE PRACTICE OBJECTS
-- ---------------------------------------------------------------------------

DROP TABLE IF EXISTS staging.preferred_role;
DROP TABLE IF EXISTS staging.preferred_role_updates;

-- Verify that the practice table has been removed.
SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'staging'
ORDER BY table_name;