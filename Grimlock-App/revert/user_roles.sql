-- Revert user_roles

BEGIN;

-- XXX Add DDLs here.
DROP TABLE grimlock.user_roles;

COMMIT;
