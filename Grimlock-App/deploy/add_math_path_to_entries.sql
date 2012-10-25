-- Deploy add_math_path_to_entries
-- requires: entries

BEGIN;
-- XXX Add DDLs here.
ALTER TABLE grimlock.entries ADD COLUMN parent_id INT;
ALTER TABLE grimlock.entries ADD COLUMN parent_path VARCHAR(255);
COMMIT;

CREATE INDEX CONCURRENTLY entry_parent_idx ON grimlock.entries(id, parent_id); 
CREATE INDEX CONCURRENTLY entry_parent_path_idx ON grimlock.entries(id, parent_path);
