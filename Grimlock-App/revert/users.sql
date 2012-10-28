-- Revert users

BEGIN;

-- XXX Add DDLs here.
DROP TABLE grimlock.users CASCADE;

COMMIT;
