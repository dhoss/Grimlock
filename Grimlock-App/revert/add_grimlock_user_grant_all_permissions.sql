-- Revert add_grimlock_user_grant_all_permissions

BEGIN;

REVOKE ALL PERMISSIONS TO USER grimlock;
COMMIT;
