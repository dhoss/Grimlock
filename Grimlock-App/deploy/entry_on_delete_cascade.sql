-- Deploy entry_on_delete_cascade
-- requires: users

BEGIN;

ALTER TABLE grimlock.entries 
  DROP CONSTRAINT entries_owner_fkey;
ALTER TABLE grimlock.entries 
  ADD CONSTRAINT entries_owner_fkey
      FOREIGN KEY (owner) REFERENCES grimlock.users(id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
  DEFERRABLE;

COMMIT;
