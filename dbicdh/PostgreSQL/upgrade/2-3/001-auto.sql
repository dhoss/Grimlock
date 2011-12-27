-- Convert schema '/Users/dhoss/web-devel/Grimlock/script/../dbicdh/_source/deploy/2/001-auto.yml' to '/Users/dhoss/web-devel/Grimlock/script/../dbicdh/_source/deploy/3/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE entries ADD CONSTRAINT "entries_title" UNIQUE (title);

;

COMMIT;

