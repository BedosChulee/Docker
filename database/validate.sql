-- PostgreSQL Database Validation Script
-- This script validates the database setup, table structure, constraints, and sample data

\echo '=== Starting Database Validation ==='
\echo ''

-- 1. Validate table structure
\echo '1. Validating table structure...'

-- Check if users table exists with correct columns
\echo '   Checking users table structure:'
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'users' 
ORDER BY ordinal_position;

-- Check if posts table exists with correct columns
\echo '   Checking posts table structure:'
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'posts' 
ORDER BY ordinal_position;

-- Verify primary keys
\echo '   Checking primary key constraints:'
SELECT 
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY' 
    AND tc.table_name IN ('users', 'posts')
ORDER BY tc.table_name;

-- Verify unique constraints
\echo '   Checking unique constraints:'
SELECT 
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'UNIQUE' 
    AND tc.table_name IN ('users', 'posts')
ORDER BY tc.table_name;

\echo ''

-- 2. Test foreign key constraints
\echo '2. Testing foreign key constraints...'

-- Check foreign key constraint exists
\echo '   Checking foreign key constraint definition:'
SELECT 
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu 
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name = 'posts';

-- Test foreign key constraint enforcement
\echo '   Testing foreign key constraint enforcement:'
\echo '   Attempting to insert post with invalid user_id (should fail):'

-- This should fail due to foreign key constraint
BEGIN;
DO $$
BEGIN
    INSERT INTO posts (title, content, user_id) VALUES ('Test Post', 'This should fail', 999);
    RAISE EXCEPTION 'Foreign key constraint test failed - invalid user_id was accepted';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'SUCCESS: Foreign key constraint properly rejected invalid user_id';
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Unexpected error during foreign key test: %', SQLERRM;
END $$;
ROLLBACK;

-- Test valid foreign key insertion
\echo '   Testing valid foreign key insertion:'
BEGIN;
INSERT INTO posts (title, content, user_id) VALUES ('Valid Test Post', 'This should work', 1);
\echo '   SUCCESS: Valid foreign key insertion accepted';
ROLLBACK;

\echo ''

-- 3. Verify sample data integrity
\echo '3. Verifying sample data integrity...'

-- Check user count
\echo '   Checking user count (should be 3):'
SELECT COUNT(*) as user_count FROM users;

-- Check post count
\echo '   Checking post count (should be 10):'
SELECT COUNT(*) as post_count FROM posts;

-- Verify all posts have valid user associations
\echo '   Verifying all posts have valid user associations:'
SELECT 
    COUNT(*) as posts_with_valid_users
FROM posts p
JOIN users u ON p.user_id = u.id;

-- Check for orphaned posts (should be 0)
\echo '   Checking for orphaned posts (should be 0):'
SELECT 
    COUNT(*) as orphaned_posts
FROM posts p
LEFT JOIN users u ON p.user_id = u.id
WHERE u.id IS NULL;

-- Verify user email uniqueness
\echo '   Verifying user email uniqueness:'
SELECT 
    email,
    COUNT(*) as count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Check data types and constraints
\echo '   Verifying data integrity:'
SELECT 
    'users' as table_name,
    COUNT(*) as total_rows,
    COUNT(CASE WHEN name IS NOT NULL AND name != '' THEN 1 END) as valid_names,
    COUNT(CASE WHEN email IS NOT NULL AND email != '' THEN 1 END) as valid_emails,
    COUNT(CASE WHEN created_at IS NOT NULL THEN 1 END) as valid_created_at,
    COUNT(CASE WHEN updated_at IS NOT NULL THEN 1 END) as valid_updated_at
FROM users

UNION ALL

SELECT 
    'posts' as table_name,
    COUNT(*) as total_rows,
    COUNT(CASE WHEN title IS NOT NULL AND title != '' THEN 1 END) as valid_titles,
    COUNT(CASE WHEN user_id IS NOT NULL THEN 1 END) as valid_user_ids,
    COUNT(CASE WHEN created_at IS NOT NULL THEN 1 END) as valid_created_at,
    COUNT(CASE WHEN updated_at IS NOT NULL THEN 1 END) as valid_updated_at
FROM posts;

-- Verify relationships work correctly
\echo '   Testing join relationships:'
SELECT 
    u.name as user_name,
    COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.name
ORDER BY u.name;

-- Check indexes exist
\echo '   Verifying indexes exist:'
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes 
WHERE tablename IN ('users', 'posts')
ORDER BY tablename, indexname;

\echo ''
\echo '=== Database Validation Complete ==='