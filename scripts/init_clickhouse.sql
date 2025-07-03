CREATE TABLE IF NOT EXISTS events
(
timestamp DateTime64(3),
user_id String,
action String,
payload String
)
ENGINE = MergeTree
ORDER BY (timestamp);