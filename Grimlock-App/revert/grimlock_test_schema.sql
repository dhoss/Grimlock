-- Revert grimlock_test_schema

BEGIN;

DROP SCHEMA grimlock_test CASCADE;

COMMIT;
