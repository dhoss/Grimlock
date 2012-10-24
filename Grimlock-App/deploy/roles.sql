-- Deploy roles
-- requires: appschema

BEGIN;

-- XXX Add DDLs here.
CREATE TABLE grimlock.roles (
id serial NOT NULL PRIMARY KEY,
name varchar(255) NOT NULL UNIQUE
);

COMMIT;
