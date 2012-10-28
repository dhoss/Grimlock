-- Deploy add_grimlock_user
-- requires: appschema

BEGIN;

CREATE USER grimlock WITH PASSWORD 'grimlock king';

COMMIT;
