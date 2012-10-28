-- Revert entry_tags

BEGIN;

DROP TABLE grimlock.entry_tags;
COMMIT;
