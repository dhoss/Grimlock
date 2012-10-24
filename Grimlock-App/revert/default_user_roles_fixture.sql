-- Revert default_user_roles_fixture

BEGIN;

-- XXX Add DDLs here.
DELETE FROM grimlock.roles WHERE name='admin';
DELETE FROM grimlock.roles WHERE name='user';

COMMIT;
