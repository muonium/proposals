CREATE TABLE user_by_id (
	user_id uuid,
	login text,
	password text,
	email text,
	lang text,
	registration_date date,
	last_connection date,
	cek text,
	pks tuple<text, text>,
	pkb_fingerprint text,
	double_auth tinyint,
	auth_code text,
	PRIMARY KEY (user_id)
);
CREATE INDEX ON user_by_id (last_connection);

-- update login: delete and re-insert
CREATE TABLE user_by_login (
	user_id uuid,
	login text,
	PRIMARY KEY (login)
);

-- update mail: delete and re-insert
CREATE TABLE user_by_email (
	user_id uuid,
	email text,
	PRIMARY KEY (email)
);

-- order by name -> client side, file rename/update -> use id instead, flags: favorite, trash...
CREATE TABLE files (
	file_id uuid,
	owner_id uuid,
	owner_login text,
	folder_id uuid,
	updated_at timestamp,
	name text,
	size bigint,
	path text,
	tree set<uuid>,
	flags set<text>,
	dk text,
	lek map<uuid, text>,
	dk_asym map<uuid, text>,
	PRIMARY KEY (file_id, owner_id)
);
CREATE INDEX ON files (folder_id);
CREATE INDEX ON files (tree);
CREATE INDEX ON files (flags);

CREATE MATERIALIZED VIEW recent_files AS
	SELECT file_id, owner_id, folder_id, updated_at, name, size, path, tree, flags, dk, lek, dk_asym FROM files
	WHERE file_id IS NOT NULL AND owner_id IS NOT NULL AND updated_at IS NOT NULL
	PRIMARY KEY (file_id, owner_id, updated_at)
	WITH CLUSTERING ORDER BY (updated_at DESC);

-- check updated_at before deleting a file
CREATE TABLE not_completed_files (
	file_id uuid,
	owner_id uuid,
	updated_at timestamp,
	name text,
	path text,
	PRIMARY KEY (file_id, owner_id)
);

-- order by name -> client side, folder rename -> use id instead, flags: favorite, trash...
CREATE TABLE folders (
	folder_id uuid,
	owner_id uuid,
	parent uuid,
	updated_at timestamp,
	name text,
	size bigint,
	path text,
	tree set<uuid>,
	flags set<text>,
	PRIMARY KEY (folder_id, owner_id)
);
CREATE INDEX ON folders (parent);
CREATE INDEX ON folders (tree);
CREATE INDEX ON folders (flags);

CREATE TABLE storage (
	user_id uuid,
	user_quota bigint,
	size_stored bigint,
	PRIMARY KEY (user_id)
);

CREATE TABLE storage_plans (
	product_id text,
	size bigint,
	price float,
	currency text,
	duration int,
	most_popular boolean,
	PRIMARY KEY (product_id)
);

-- select end before updating, when it expires or cancel -> delete row
CREATE TABLE current_upgrade (
	user_id uuid,
	txn_id text,
	size bigint,
	price float,
	currency text,
	start timestamp,
	end timestamp,
	PRIMARY KEY (user_id, end)
);

CREATE TABLE upgrades (
	user_id uuid,
	txn_id text,
	size bigint,
	price float,
	currency text,
	start timestamp,
	end timestamp,
	removed boolean,
	PRIMARY KEY (user_id)
);

CREATE TABLE user_lostpass (
	user_id uuid,
	val_key text,
	expire timestamp,
	PRIMARY KEY (user_id)
);

CREATE TABLE user_validation (
	user_id uuid,
	val_key text,
	PRIMARY KEY (user_id)
);

-- ct means content
CREATE TABLE comments (
	comment_id uuid,
	file_id uuid,
	user_id uuid,
	added_date timestamp,
	ct text,
	PRIMARY KEY (comment_id, added_date, file_id)
) WITH CLUSTERING ORDER BY (added_date DESC);

CREATE TABLE shared_with (
	file_id uuid,
	users set<uuid>,
	PRIMARY KEY (file_id)
);

CREATE TABLE contacts (
	user_id uuid,
	contacts set<uuid>,
	PRIMARY KEY (user_id)
);

CREATE TABLE organizations (
	org_id uuid,
	name text,
	nb_users int,
	cek text,
	PRIMARY KEY (org_id)
);

--table for non-private sub-users'
--keys
CREATE TABLE org_keys (
	user_id uuid,
	cek text,
	pks tuple<text, text>,
	PRIMARY KEY (user_id)
);
