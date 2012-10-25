-- Deploy sessions
-- requires: users

BEGIN;

-- XXX Add DDLs here.
CREATE TABLE grimlock.sessions (
  id CHAR(72) PRIMARY KEY,
  session_data TEXT,
  expires INTEGER
);

COMMIT;
