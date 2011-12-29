-- Convert schema '/Users/dhoss/web-devel/Grimlock/script/../dbicdh/_source/deploy/4/001-auto.yml' to '/Users/dhoss/web-devel/Grimlock/script/../dbicdh/_source/deploy/5/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE entries ADD COLUMN path character varying(255);

;
ALTER TABLE entries ADD COLUMN parent bigserial;

;
CREATE INDEX entries_idx_parent on entries (parent);

;
CREATE INDEX tree_data on entries (parent);

;
ALTER TABLE entries ADD FOREIGN KEY (parent)
  REFERENCES entries (entryid) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;

COMMIT;

