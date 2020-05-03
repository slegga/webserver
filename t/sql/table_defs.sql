drop table IF EXISTS sessions;
create table sessions(sid TEXT PRIMARY KEY, username TEXT, groups TEXT, status TEXT, expires INTEGER);
