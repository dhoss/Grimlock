-- Revert add_math_path_to_entries

BEGIN;

-- XXX Add DDLs here.
ALTER TABLE grimlock.entries DROP COLUMN parent_id;
ALTER TABLE grimlock.entries DROP COLUMN parent_path;
COMMIT;

DROP INDEX IF EXISTS entry_parent_idx;
DROP INDEX IF EXISTS entry_parent_path_idx;
