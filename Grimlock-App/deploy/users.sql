-- Deploy users
-- requires: appschema

BEGIN;

-- XXX Add DDLs here.
CREATE TABLE grimlock.users (
  id         serial       not null primary key,
  name       varchar(255) not null,
  password   char(59)     not null, 
  created_on timestamptz  not null default now(),
  updated_on timestamptz
);
COMMIT;
