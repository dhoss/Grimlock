-- Deploy entries
-- requires: users

BEGIN;

-- XXX Add DDLs here.
CREATE TABLE grimlock.entries (
  id         SERIAL       NOT NULL PRIMARY KEY,
  title      VARCHAR(255) NOT NULL UNIQUE,
  body       TEXT         NOT NULL,
  created_on TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_on TIMESTAMPTZ,
  owner      INT          NOT NULL REFERENCES grimlock.users(id)
);

COMMIT;
