-- Revert roles

BEGIN;

-- XXX Add DDLs here.
DROP TABLE grimlock.roles;

COMMIT;
