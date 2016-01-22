DROP TABLE IF EXISTS comment_comment;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS disc;
DROP TABLE IF EXISTS topic_user;
DROP TABLE IF EXISTS topic;
DROP TABLE IF EXISTS forum_user;

CREATE TABLE forum_user(
  id	SERIAL PRIMARY KEY,
  username	VARCHAR UNIQUE NOT NULL,
  password_digest	VARCHAR NOT NULL,
  email	 VARCHAR UNIQUE NOT NULL,
  fname VARCHAR,
  lname VARCHAR,
  gender CHAR(1),
  phone VARCHAR,
  img_url VARCHAR DEFAULT 'http://images.clipartpanda.com/question-mark-black-and-white-Icon-round-Question_mark.jpg',
  CHECK( gender = 'F' OR gender = 'M' OR gender = NULL )
);

CREATE TABLE topic(
  id	SERIAL PRIMARY KEY,
  name	VARCHAR UNIQUE NOT NULL,
  description	VARCHAR NOT NULL,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  edit_time TIMESTAMP,
  topic_rate INTEGER NOT NULL DEFAULT 0,
  img_url VARCHAR DEFAULT 'http://images.clipartpanda.com/question-mark-black-and-white-Icon-round-Question_mark.jpg',
  user_id INTEGER REFERENCES forum_user(id)
);

CREATE TABLE topic_user(
  user_id INTEGER REFERENCES forum_user(id),
  topic_id INTEGER REFERENCES topic(id)
);

CREATE TABLE disc(
  id	SERIAL PRIMARY KEY,
  name	VARCHAR NOT NULL,
  description	VARCHAR NOT NULL,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  edit_time TIMESTAMP,
  topic_rate INTEGER NOT NULL DEFAULT 0,
  img_url VARCHAR DEFAULT 'http://images.clipartpanda.com/question-mark-black-and-white-Icon-round-Question_mark.jpg',
  user_id INTEGER REFERENCES forum_user(id),
  topic_id INTEGER REFERENCES topic(id)
);

CREATE TABLE comment(
  id	SERIAL PRIMARY KEY,
  description	VARCHAR NOT NULL,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  edit_time TIMESTAMP,
  img_url VARCHAR,
  user_id INTEGER REFERENCES forum_user(id),
  disc_id INTEGER REFERENCES disc(id)
);

CREATE TABLE comment_comment(
  pcomm_id INTEGER REFERENCES comment(id),
  chcomm_id INTEGER REFERENCES comment(id)
);

