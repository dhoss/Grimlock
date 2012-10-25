-- Revert sessions

BEGIN;

-- XXX Add DDLs here.
DROP TABLE grimlock.sessions;

COMMIT;
