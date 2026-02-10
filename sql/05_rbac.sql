-- =========================================================
-- # RBAC: Role Based Access Control
-- # Goal: Create a secure user for Reporting/BI Tools
-- =========================================================

-- 1. Create a Read-Only Role (Group)
-- This role cannot create tables or modify data
CREATE ROLE read_only_role;

-- 2. Grant Connection Permission
GRANT CONNECT ON DATABASE retail_dwh TO read_only_role;

-- 3. Grant Usage on Schema
GRANT USAGE ON SCHEMA public TO read_only_role;

-- 4. Grant SELECT on ALL Tables (Present & Future)
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_only_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO read_only_role;

-- =========================================================
-- # CREATE USER for BI Tool (Superset/Tableau)
-- =========================================================
-- Create specific user
CREATE USER bi_viewer WITH PASSWORD 'bi_password_123';

-- Assign the Read-Only Role to this user
GRANT read_only_role TO bi_viewer;

-- =========================================================
-- # VERIFICATION
-- # Check permissions (optional query)
-- =========================================================
-- SELECT grantee, privilege_type 
-- FROM information_schema.role_table_grants 
-- WHERE grantee = 'bi_viewer';

# 6.1 Generate bi_viewer user permission
docker compose exec postgres psql -U admin -d retail_dwh -f /docker-entrypoint-initdb.d/05_rbac.sql
