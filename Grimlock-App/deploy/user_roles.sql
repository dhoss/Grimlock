-- Deploy user_roles
-- requires: users
-- requires: roles

BEGIN;

-- XXX Add DDLs here.
CREATE TABLE grimlock.user_roles(
  "user" INT NOT NULL REFERENCES grimlock.users(id) ON DELETE CASCADE,
  role INT NOT NULL REFERENCES grimlock.roles(id) ON DELETE CASCADE,
  PRIMARY KEY("user", role)  
);

COMMIT;
