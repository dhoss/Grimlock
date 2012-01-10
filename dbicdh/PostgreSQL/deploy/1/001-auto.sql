-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Tue Jan 10 16:08:38 2012
-- 
;
--
-- Table: roles
--
CREATE TABLE "roles" (
  "roleid" serial NOT NULL,
  "name" character varying(50) NOT NULL,
  PRIMARY KEY ("roleid"),
  CONSTRAINT "roles_name" UNIQUE ("name")
);

;
--
-- Table: sessions
--
CREATE TABLE "sessions" (
  "sessionid" character(72) NOT NULL,
  "session_data" text,
  "expires" integer,
  PRIMARY KEY ("sessionid")
);

;
--
-- Table: users
--
CREATE TABLE "users" (
  "userid" serial NOT NULL,
  "name" character varying(200) NOT NULL,
  "password" character(60) NOT NULL,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp,
  "email" character varying(255),
  PRIMARY KEY ("userid"),
  CONSTRAINT "users_email" UNIQUE ("email"),
  CONSTRAINT "users_name" UNIQUE ("name")
);

;
--
-- Table: entries
--
CREATE TABLE "entries" (
  "entryid" serial NOT NULL,
  "title" character varying(200) NOT NULL,
  "display_title" character varying(200) NOT NULL,
  "path" character varying(255),
  "parent" bigint,
  "body" text NOT NULL,
  "author" integer NOT NULL,
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp,
  PRIMARY KEY ("entryid"),
  CONSTRAINT "entries_display_title" UNIQUE ("display_title"),
  CONSTRAINT "entries_title" UNIQUE ("title")
);
CREATE INDEX "entries_idx_author" on "entries" ("author");
CREATE INDEX "entries_idx_parent" on "entries" ("parent");
CREATE INDEX "tree_data" on "entries" ("parent");

;
--
-- Table: user_roles
--
CREATE TABLE "user_roles" (
  "userid" integer NOT NULL,
  "roleid" integer NOT NULL,
  PRIMARY KEY ("userid", "roleid")
);
CREATE INDEX "user_roles_idx_roleid" on "user_roles" ("roleid");
CREATE INDEX "user_roles_idx_userid" on "user_roles" ("userid");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "entries" ADD FOREIGN KEY ("author")
  REFERENCES "users" ("userid") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "entries" ADD FOREIGN KEY ("parent")
  REFERENCES "entries" ("entryid") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "user_roles" ADD FOREIGN KEY ("roleid")
  REFERENCES "roles" ("roleid") DEFERRABLE;

;
ALTER TABLE "user_roles" ADD FOREIGN KEY ("userid")
  REFERENCES "users" ("userid") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

