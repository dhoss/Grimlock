-- Revert add_grimlock_user

BEGIN;

DROP USER grimlock;

COMMIT;
