CREATE TABLE users (
	user_id bigint,
	login text,
	password text,
	email text,
	lang text,
	registration_date int,
	last_connection int,
	cek text,
	double_auth boolean,
	auth_code text
	PRIMARY KEY (user_id)
)

CREATE TABLE files (
	file_id bigint,
	id_owner bigint,
	folder_id bigint,
	name text,
	size bigint,
	last_modification int,
	favorite boolean,
	trash boolean,
	expires int,
	dk text,
	PRIMARY KEY ((file_id, id_owner, folder_id), last_modification)
) WITH CLUSTERING (last_modification DESC)

CREATE TABLE folders (
	folder_id bigint,
	id_owner bigint,
	name text,
	size bigint,
	parent bigint,
	trash boolean,
	path text,
	PRIMARY KEY ((folder_id, id_owner), folder_id)
) WITH CLUSTERING (folder_id DESC)

CREATE TABLE storage (
	user_id bigint,
	user_quota bigint,
	size_stored bigint,
	PRIMARY KEY (user_id)
)

CREATE TABLE storage_plans (
	id int,
	size bigint,
	price float,
	currency text,
	duration int,
	product_id text,
	PRIMARY KEY (id)
)

-- we need to remove the rows, not making it explicit with "removed"

CREATE TABLE upgrade (
	id_user bigint,
	txn_id text,
	size bigint,
	price float,
	currency text,
	start text,
	end text,
	removed boolean,
	most_popular boolean,
	PRIMARY KEY (id_user)
)

CREATE TABLE user_lostpass (
	id_user bigint,
	val_key text,
	expire int,
	PRIMARY KEY (id_user)
)

CREATE TABLE user_validation (
	id_user bigint,
	val_key text,
	PRIMARY KEY (id_user)
)

CREATE TABLE comments (
	file_id bigint,
	user_id bigint,
	added_date timestamp,
	ct text,
	PRIMARY KEY ((file_id, user_id, added_date), added_date)
) WITH CLUSTERING (added_date DESC)
