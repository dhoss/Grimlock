-- Deploy user_on_delete_cascade
-- requires: user_roles

BEGIN;

ALTER TABLE grimlock.user_roles
  DROP CONSTRAINT user_roles_role_fkey,
  ADD CONSTRAINT user_roles_role_fkey 
    FOREIGN KEY (role)
    REFERENCES grimlock.roles (id) 
    ON DELETE CASCADE;

ALTER TABLE grimlock.user_roles
  DROP CONSTRAINT user_roles_user_fkey,
  ADD CONSTRAINT user_roles_user_fkey
    FOREIGN KEY ("user")
    REFERENCES grimlock.users
    ON DELETE CASCADE;

COMMIT;
