-- ddl/init.sql
CREATE DATABASE IF NOT EXISTS events_db;

CREATE TABLE IF NOT EXISTS events_db.events (
  id UUID,
  timestamp DateTime,
  user_id String,
  action String,
  payload String
) ENGINE = MergeTree
PARTITION BY toYYYYMM(timestamp)
ORDER BY (timestamp);
