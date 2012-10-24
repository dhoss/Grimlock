-- Deploy default_user_roles_fixture
-- requires: users
-- requires: roles
-- requires: user_roles

BEGIN;

-- XXX Add DDLs here.
INSERT INTO grimlock.roles(name) VALUES ('admin'), ('user');

COMMIT;
