/* Drop unnecessary tables */

DROP TABLE rss;
DROP TABLE rss_feeds;
DROP TABLE rss_feeds_mapping;
DROP TABLE rss_feeds_options;
DROP TABLE fascicles_map_requests;

/* Create new table */

DROP TABLE fascicles_requests_new;
DROP TABLE fascicles_map_requests;
ALTER TABLE fascicles_requests DROP CONSTRAINT fascicles_requests_fascicle_fkey;
ALTER TABLE fascicles_requests DROP CONSTRAINT fascicles_requests_pkey;

CREATE TABLE "public"."fascicles_requests_new" (
	"id" uuid DEFAULT uuid_generate_v4() NOT NULL,
	"serialnum" int4 DEFAULT nextval('fascicles_requests_serialnum_seq'::regclass) NOT NULL,
	"edition" uuid NOT NULL,
	"fascicle" uuid NOT NULL,
	"shortcut" varchar NOT NULL,
	"description" varchar,
	"advertiser" uuid NOT NULL,
	"advertiser_shortcut" varchar NOT NULL,
	"place" uuid NOT NULL,
	"place_shortcut" varchar NOT NULL,
	"manager" uuid NOT NULL,
	"manager_shortcut" varchar NOT NULL,

	"tmpl_module" uuid NOT NULL,
	"tmpl_module_shortcut" varchar NOT NULL,

	"page" int4,
	"pages" varchar,

	"status" varchar NOT NULL,
	"payment" varchar NOT NULL,
	"readiness" varchar NOT NULL,
	"squib" varchar NOT NULL,
	"check_status" varchar DEFAULT 'new'::character varying NOT NULL,
	"anothers_layout" bool DEFAULT false NOT NULL,
	"imposed" bool DEFAULT false NOT NULL,

	"amount" int4 DEFAULT 1 NOT NULL,
	"area" float8 DEFAULT 0 NOT NULL,

	"w" varchar DEFAULT '1/1'::character varying NOT NULL,
	"h" varchar DEFAULT '1/1'::character varying NOT NULL,

	"width" float4 DEFAULT 0 NOT NULL,
	"height" float4 DEFAULT 0 NOT NULL,
	"fwidth" float4 DEFAULT 0 NOT NULL,
	"fheight" float4 DEFAULT 0 NOT NULL,

	"created" timestamptz DEFAULT now(),
	"updated" timestamptz DEFAULT now()
);

CREATE TABLE "public"."fascicles_map_requests" (
	"id" uuid DEFAULT uuid_generate_v4() NOT NULL,
	"edition" uuid NOT NULL,
	"fascicle" uuid NOT NULL,
	"request" uuid NOT NULL,
	"page" uuid NOT NULL,
	"x" varchar DEFAULT '1/1'::character varying NOT NULL,
	"y" varchar DEFAULT '1/1'::character varying NOT NULL,
	"created" timestamptz DEFAULT now(),
	"updated" timestamptz DEFAULT now()
);

/* Import data */

INSERT INTO fascicles_requests_new(
	id, 
	serialnum, 
	edition, 
	fascicle, 
	shortcut, 
	description, 
	advertiser, 
	advertiser_shortcut, 
	place, 
	place_shortcut, 
	manager, 
	manager_shortcut, 
  tmpl_module, 
	tmpl_module_shortcut, 
	page, 
	pages, 
	status, 
	payment, 
	readiness, 
  squib, 
	check_status, 
	anothers_layout, 
	imposed, 
	amount, 
	area, 
  w, 
	h, 
	width, 
	height, 
	fwidth, 
	fheight, 
	created, 
	updated)

SELECT 
	request.id, 
	request.serialnum, 
	request.edition, 
	request.fascicle, 
	request.shortcut, 
	request.description, 
	request.advertiser, 
	request.advertiser_shortcut, 
	request.place, 
	request.place_shortcut, 
	request.manager, 
	request.manager_shortcut, 
	request.origin, 
  request.origin_shortcut, 
	request.firstpage, 
	request.pages, 
	request.status, 
	request.payment, 
  request.readiness, 
	request.squib, 
	request.check_status, 
	request.anothers_layout, 
  request.imposed,
	module.amount,
	module.area,
	module.w,
	module.h,
	module.width, 
	module.height, 
	module.fwidth, 
	module.fheight,
	request.created, 
	request.updated
FROM 
	fascicles_requests 		as request, 
	fascicles_modules 		as module
WHERE 1=1
	AND request."module" = module.id;

INSERT INTO fascicles_map_requests(
	edition, 
	fascicle, 
	request, 
	page, 
	x, 
	y, 
	created, 
	updated)

SELECT 
	request.edition,
	request.fascicle,
	request.id,
	"mapping".page,
	"mapping".x,
	"mapping".y,
	"mapping".created,
	"mapping".updated
FROM 
	fascicles_requests 		as request, 
	fascicles_modules 		as module,
	fascicles_map_modules as mapping
WHERE 1=1
	AND request."module" = module.id
	AND request."module" = mapping.module;

/* Rename tables */

ALTER TABLE fascicles_requests RENAME TO fascicles_requests_old;
ALTER TABLE fascicles_requests_new RENAME TO fascicles_requests;
ALTER TABLE fascicles_map_modules RENAME TO fascicles_map_modules_old;

ALTER TABLE fascicles_requests
  ADD CONSTRAINT fascicles_requests_pkey PRIMARY KEY(id);

ALTER TABLE fascicles_requests
  ADD CONSTRAINT fascicles_requests_fascicle_fkey FOREIGN KEY (fascicle)
      REFERENCES fascicles (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE fascicles_map_requests
  ADD CONSTRAINT fascicles_map_requests_pkey PRIMARY KEY(id);

/* Clean database */