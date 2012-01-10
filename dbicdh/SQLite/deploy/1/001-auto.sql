-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Tue Jan 10 16:12:44 2012
-- 

;
BEGIN TRANSACTION;
--
-- Table: roles
--
CREATE TABLE roles (
  roleid INTEGER PRIMARY KEY NOT NULL,
  name varchar(50) NOT NULL
);
CREATE UNIQUE INDEX roles_name ON roles (name);
--
-- Table: sessions
--
CREATE TABLE sessions (
  sessionid char(72) NOT NULL,
  session_data text,
  expires int,
  PRIMARY KEY (sessionid)
);
--
-- Table: users
--
CREATE TABLE users (
  userid INTEGER PRIMARY KEY NOT NULL,
  name varchar(200) NOT NULL,
  password char(60) NOT NULL,
  created_at datetime NOT NULL,
  updated_at datetime,
  email varchar(255)
);
CREATE UNIQUE INDEX users_email ON users (email);
CREATE UNIQUE INDEX users_name ON users (name);
--
-- Table: entries
--
CREATE TABLE entries (
  entryid INTEGER PRIMARY KEY NOT NULL,
  title varchar(200) NOT NULL,
  display_title varchar(200) NOT NULL,
  path varchar(255),
  parent bigint,
  body text NOT NULL,
  author int NOT NULL,
  created_at datetime NOT NULL,
  updated_at datetime,
  FOREIGN KEY(author) REFERENCES users(userid),
  FOREIGN KEY(parent) REFERENCES entries(entryid)
);
CREATE INDEX entries_idx_author ON entries (author);
CREATE INDEX entries_idx_parent ON entries (parent);
CREATE INDEX tree_data ON entries (parent);
CREATE UNIQUE INDEX entries_display_title ON entries (display_title);
CREATE UNIQUE INDEX entries_title ON entries (title);
--
-- Table: user_roles
--
CREATE TABLE user_roles (
  userid int NOT NULL,
  roleid int NOT NULL,
  PRIMARY KEY (userid, roleid),
  FOREIGN KEY(roleid) REFERENCES roles(roleid),
  FOREIGN KEY(userid) REFERENCES users(userid)
);
CREATE INDEX user_roles_idx_roleid ON user_roles (roleid);
CREATE INDEX user_roles_idx_userid ON user_roles (userid);
COMMIT