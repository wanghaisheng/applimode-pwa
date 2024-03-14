DROP TABLE IF EXISTS posts;
CREATE VIRTUAL TABLE posts USING fts5(pid, body, tokenize='porter unicode61');
