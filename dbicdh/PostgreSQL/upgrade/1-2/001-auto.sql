-- Convert schema '/Users/dhoss/web-devel/Grimlock/script/../dbicdh/_source/deploy/1/001-auto.yml' to '/Users/dhoss/web-devel/Grimlock/script/../dbicdh/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "sessions" (
  "sessoinid" character(72) NOT NULL,
  "session_data" text NOT NULL,
  "expires" integer NOT NULL,
  PRIMARY KEY ("sessoinid")
);

;

COMMIT;

