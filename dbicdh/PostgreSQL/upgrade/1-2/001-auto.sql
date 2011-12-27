-- Convert schema '/Users/dhoss/web-devel/Grimlock/script/../dbicdh/_source/deploy/1/001-auto.yml' to '/Users/dhoss/web-devel/Grimlock/script/../dbicdh/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE sessions ALTER COLUMN expires DROP NOT NULL;

;

COMMIT;

