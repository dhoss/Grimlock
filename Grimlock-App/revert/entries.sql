-- Revert entries

BEGIN;

DROP TABLE grimlock.entries CASCADE;

COMMIT;
