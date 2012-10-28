-- Revert grimlock_test_user

BEGIN;

DROP USER grimlock_test CASCADE;

COMMIT;
