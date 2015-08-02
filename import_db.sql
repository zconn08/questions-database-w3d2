DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER,
  body TEXT,
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Joe', 'Smith'),('John','Williams'),('George','Sanders'),('Kobe','Bryant');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Meaning of Life',"What is the meaning of life?",2),
  ('Coding',"How do I code?",3),
  ('Directions',"How do I get to the market?",2),
  ('Bars',"What are the best bars in the city?",1);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (4,2),
  (4,1),
  (3,1);

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (1,null,4,'get buckets'),
  (2,null,1, 'learn ruby'),
  (1,1,3, 'lol');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (4, 1),
  (3, 1),
  (2, 4);
