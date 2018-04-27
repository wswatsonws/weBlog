CREATE TABLE users (
	id 			serial	PRIMARY KEY,
	password	text,
	email		text 	UNIQUE,
	name		text	UNIQUE,
	gender		int,
	posts		int	default 0,
	followers	int	default 0,
	followings	int	default 0
);

CREATE TABLE posts (
	id			serial	PRIMARY KEY,
	user_id		int	REFERENCES users,
	repost_id	int	REFERENCES posts,
	content		text not null,
	create_at	timestamp	NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
);

CREATE TABLE comments (
	id			serial	PRIMARY KEY,
	user_id		int	REFERENCES users,
	post_id		int	REFERENCES posts,
	comment_id	int	REFERENCES comments,
	content		text not null,
	create_at	timestamp	NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
);

CREATE TABLE follows (
	user_id		int	REFERENCES users,
	fan_id		int	REFERENCES users,
	UNIQUE(user_id,fan_id)
);

CREATE TABLE favorates (
	user_id		int	REFERENCES users,
	post_id		int	REFERENCES posts,
	create_at	timestamp	NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
	UNIQUE(user_id,post_id)
);

CREATE TABLE likeposts (
	user_id		int	REFERENCES users,
	post_id		int	REFERENCES posts,
	UNIQUE(user_id,post_id)
);

CREATE TABLE likecmts (
	user_id		int	REFERENCES users,
	comment_id	int	REFERENCES comments,
	UNIQUE(user_id,comment_id)
);


CREATE FUNCTION post_count() RETURNS TRIGGER AS $post_table$
	BEGIN
		UPDATE users SET posts=posts+1 WHERE id=new.user_id;
		RETURN NEW;
	END;
$post_table$ LANGUAGE plpgsql;

CREATE TRIGGER posts_counter AFTER INSERT ON posts
FOR EACH ROW EXECUTE PROCEDURE post_count()


