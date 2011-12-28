-- Convert schema '/Users/dhoss/web-devel/Grimlock/script/../dbicdh/_source/deploy/3/001-auto.yml' to '/Users/dhoss/web-devel/Grimlock/script/../dbicdh/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE entries ADD COLUMN display_title character varying(200) NOT NULL;

;
ALTER TABLE entries ADD CONSTRAINT "entries_display_title" UNIQUE (display_title);

;

COMMIT;

