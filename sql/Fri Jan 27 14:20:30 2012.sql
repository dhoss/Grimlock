-- Convert schema 'c040455291b2b29e4367f30ec826912ef01e514e' to 'index':;

BEGIN;

ALTER TABLE entries ADD COLUMN published integer NOT NULL;


COMMIT;

