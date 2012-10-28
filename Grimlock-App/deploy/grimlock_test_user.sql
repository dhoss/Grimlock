-- Deploy grimlock_test_user
-- requires: grimlock_test_schema

BEGIN;

CREATE USER grimlock_test WITH PASSWORD 'grimlock king!';

COMMIT;
