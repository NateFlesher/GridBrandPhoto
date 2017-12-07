DROP TABLE IF EXISTS "tbl_users";
CREATE TABLE "tbl_users" (
	`id`	INTEGER NOT NULL PRIMARY KEY,
    `email`	TEXT NOT NULL,
    `email_verified`	INTEGER,
    `mobile`	TEXT,
    `mobile_verified`	INTEGER,
	`fullname`	TEXT,
	`country`	TEXT,
	`profession`	TEXT,
	`skype`	TEXT,
	`location`	TEXT,
	`web`	TEXT,
    `note`	TEXT,
    `avatar_url`	TEXT,
    `cover_url`	TEXT,
	`money_amount`	REAL,
    `cycle_amount`	REAL,
    `reset_password_flag`	INTEGER,
	`created_time`	INTEGER,
	`updated_time`	INTEGER
);

DROP TABLE IF EXISTS "tbl_cycles";
CREATE TABLE `tbl_cycles` (
    `id`	INTEGER NOT NULL,
    `user_id`	INTEGER NOT NULL,
    `title`	TEXT,
    `photo_url`	TEXT,
    `note`	TEXT,
    `data`	BLOB,
    `magic`	INTEGER,
    `counting`	INTEGER,
    `price_unit`	TEXT,
    `price`	REAL,
    `category_id`	INTEGER NOT NULL,
    `created_time`	INTEGER NOT NULL,
    `updated_time`	INTEGER NOT NULL,
PRIMARY KEY(`id`)
);

DROP TABLE IF EXISTS "tbl_messages";
CREATE TABLE `tbl_messages` (
	`id`	INTEGER NOT NULL,
	`from_user_id`	INTEGER NOT NULL,
	`to_user_id`	INTEGER NOT NULL,
	`message`	TEXT,
    `deleted`	INTEGER,
    `updated`	INTEGER,
	`created_time`	INTEGER NOT NULL,
	`updated_time`	INTEGER NOT NULL,
	PRIMARY KEY(`id`)
);

DROP TABLE IF EXISTS "tbl_saved_cycles";
CREATE TABLE `tbl_saved_cycles` (
    `id`	INTEGER NOT NULL,
    `user_id`	INTEGER NOT NULL,
    `cycle_id`	INTEGER NOT NULL,
    `created_time`	INTEGER NOT NULL,
    `updated_time`	INTEGER NOT NULL,
PRIMARY KEY(`id`)
);

DROP TABLE IF EXISTS "tbl_categories";
CREATE TABLE `tbl_categories` (
    `id`	INTEGER NOT NULL,
    `title`	TEXT,
    `icon_url`	TEXT,
    `note`	TEXT,
    `created_time`	INTEGER NOT NULL,
    `updated_time`	INTEGER NOT NULL,
PRIMARY KEY(`id`)
);


DROP TABLE IF EXISTS "tbl_tags";
CREATE TABLE `tbl_tags` (
    `id`	INTEGER NOT NULL,
    `title`	TEXT,
    `note`	TEXT,
    `created_time`	INTEGER NOT NULL,
    `updated_time`	INTEGER NOT NULL,
PRIMARY KEY(`id`)
);


DROP TABLE IF EXISTS "tbl_cycle_tags";
CREATE TABLE `tbl_cycle_tags` (
    `id`	INTEGER NOT NULL,
    `cycle_id`	INTEGER NOT NULL,
    `tag_id`	INTEGER NOT NULL,
    `created_time`	INTEGER NOT NULL,
    `updated_time`	INTEGER NOT NULL,
PRIMARY KEY(`id`)
);

DROP TABLE IF EXISTS "tbl_notifications";
CREATE TABLE `tbl_notifications` (
`id`	INTEGER NOT NULL,
`from_user_id`	INTEGER NOT NULL,
`to_user_id`	INTEGER NOT NULL,
`cycle_id`	INTEGER NOT NULL,
`note`	TEXT,
`type`	INTEGER,
`read`	INTEGER,
`created_time`	INTEGER NOT NULL,
`updated_time`	INTEGER NOT NULL,
PRIMARY KEY(`id`)
);
