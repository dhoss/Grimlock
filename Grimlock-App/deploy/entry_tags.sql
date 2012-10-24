-- Deploy entry_tags
-- requires: entries

BEGIN;

-- XXX Add DDLs here.
CREATE TABLE grimlock.entry_tags(
  id SERIAL NOT NULL PRIMARY KEY,
  name VARCHAR(200),
  entry INT NOT NULL REFERENCES grimlock.entries(id)
);

COMMIT;
