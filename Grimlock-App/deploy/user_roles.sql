-- Deploy user_roles
-- requires: users
-- requires: roles

BEGIN;

-- XXX Add DDLs here.
CREATE TABLE grimlock.user_roles(
  "user" INT NOT NULL REFERENCES grimlock.users(id),
  role INT NOT NULL REFERENCES grimlock.roles(id),
  PRIMARY KEY("user", role)  
);

COMMIT;
