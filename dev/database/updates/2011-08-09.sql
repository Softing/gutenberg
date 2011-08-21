DROP TABLE IF EXISTS rss;
DROP TABLE IF EXISTS rss_feeds;
DROP TABLE IF EXISTS rss_feeds_mapping;
DROP TABLE IF EXISTS rss_feeds_options;

DROP TABLE IF EXISTS map_role_to_rule;
DROP TABLE IF EXISTS roles;

DROP TABLE IF EXISTS migration;
DROP TABLE IF EXISTS editions_options;

DROP TABLE IF EXISTS cache_versions;
DROP TABLE IF EXISTS ad_requests;
DROP TABLE IF EXISTS fascicles_requests_files;

ALTER TABLE fascicles ADD COLUMN status character varying NOT NULL DEFAULT 'undefined';

UPDATE fascicles SET status='archive' WHERE archived = true;
UPDATE fascicles SET status='work' WHERE archived = false;


CREATE TABLE "public"."template" (
	"id" uuid DEFAULT uuid_generate_v4() NOT NULL,
	"edition" uuid NOT NULL,
	"shortcut" varchar NOT NULL,
	"description" varchar,
	"deleted" boolean NOT NULL DEFAULT false,
	"created" timestamptz(6) DEFAULT now() NOT NULL,
	"updated" timestamptz(6) DEFAULT now() NOT NULL,
	CONSTRAINT "template_pkey" PRIMARY KEY ("id"),
	CONSTRAINT "template_edition_fkey" FOREIGN KEY ("edition") REFERENCES "public"."editions" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE "public"."template_page" (
	"id" uuid DEFAULT uuid_generate_v4() NOT NULL,
	"edition" uuid NOT NULL,
	"template" uuid NOT NULL,
	"origin" uuid NOT NULL,
	"headline" uuid,
	"seqnum" int4,
	"width" varchar[],
	"height" varchar[],
	"created" timestamptz(6) DEFAULT now(),
	"updated" timestamptz(6) DEFAULT now(),
	CONSTRAINT "template_page_pkey" PRIMARY KEY ("id"),
	CONSTRAINT "template_page_template_fkey" FOREIGN KEY ("template") REFERENCES "public"."template" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT "template_page_origin_fkey" FOREIGN KEY ("origin") REFERENCES "public"."ad_pages" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION
);

/*
CREATE TABLE "public"."fascicles_ad" (
	"id" uuid DEFAULT uuid_generate_v4() NOT NULL,
	
	"edition" uuid NOT NULL,
	"fascicle" uuid NOT NULL,
	
	"shortcut" varchar NOT NULL,
	"description" varchar,
	
	"ad_serial" serial NOT NULL,
	"ad_place" uuid NOT NULL,
	"ad_advertiser" uuid NOT NULL,
	"ad_manager" uuid NOT NULL,
	"ad_status" varchar NOT NULL,
	"ad_paid" varchar NOT NULL,
	"ad_readiness" varchar NOT NULL,
	"ad_squib" varchar NOT NULL,
	"ad_check_status" varchar DEFAULT 'new' NOT NULL,
	"ad_anothers_layout" bool DEFAULT false NOT NULL,
	"ad_imposed" bool DEFAULT false NOT NULL,
	
	"cache_ad_advertiser" varchar NOT NULL,
	"cache_ad_place" varchar NOT NULL,
	"cache_ad_manager" varchar NOT NULL,
	"cache_ad_page" int4,
	"cache_ad_pages" varchar,
	
	"module_shortcut" varchar,
	"module_description" varchar,
	"module_area" float8 DEFAULT 0,
	"module_amount" int4 DEFAULT 1,
	"module_w" varchar,
	"module_h" varchar,
	"module_x" varchar,
	"module_y" varchar,
	"module_pw" float4 DEFAULT 0,
	"module_ph" float4 DEFAULT 0,
	"module_pfw" float4 DEFAULT 0,
	"module_pfh" float4 DEFAULT 0,
	
	"created" timestamptz(6) DEFAULT now() NOT NULL,
	"updated" timestamptz(6) DEFAULT now() NOT NULL,
	CONSTRAINT "fascicles_ad_pkey" PRIMARY KEY ("id")
);

INSERT INTO fascicles_ad
	id,
	edition, fascicle,
	shortcut, description,
	ad_serial, ad_place, ad_advertiser, ad_manager, ad_status, ad_paid, ad_readiness, ad_squib, ad_check_status, ad_anothers_layout, ad_imposed,
	cache_ad_advertiser, cache_ad_place, cache_ad_manager, cache_ad_page, cache_ad_pages,
	module_shortcut, module_description, module_area, module_amount, module_w, module_h, module_x, module_y, module_pw, module_ph, module_pfw, module_pfh, created, updated,
);


CREATE TABLE "public"."layout" (
"id" uuid DEFAULT uuid_generate_v4() NOT NULL,
"edition" uuid NOT NULL,
"fascicle" uuid NOT NULL,
"layout_version" uuid DEFAULT uuid_generate_v4() NOT NULL,
"is_active" bool DEFAULT false NOT NULL,
"created" timestamptz(6) DEFAULT now() NOT NULL,
"updated" timestamptz(6) DEFAULT now() NOT NULL,
CONSTRAINT "layout_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "public"."layout_content" (
"id" uuid DEFAULT uuid_generate_v4() NOT NULL,
"edition" uuid NOT NULL,
"fascicle" uuid NOT NULL,
"layout_version" uuid DEFAULT uuid_generate_v4() NOT NULL,
"content_type" varchar NOT NULL,
"content_parent" uuid NOT NULL,
"content_entity" uuid NOT NULL,
"created" timestamptz(6) DEFAULT now() NOT NULL,
"updated" timestamptz(6) DEFAULT now() NOT NULL,
CONSTRAINT "layout_content_pkey" PRIMARY KEY ("id")
);

-- Insert layouts

DELETE FROM layout;
INSERT INTO layout (edition, fascicle, is_active, created, updated) 
	SELECT edition, id, true, created, updated FROM fascicles;

-- Insert pages
	
DELETE FROM layout_content WHERE content_type = 'page';
INSERT INTO layout_content (edition, fascicle, layout_version, content_type, content_parent, content_entity, created, updated) 
	SELECT 
		t1.edition, 
		t1.fascicle, 
		( SELECT layout_version FROM layout l2 WHERE l2.fascicle = t1.fascicle ) as layout_version,
		'page',
		t1.fascicle, 
		t1.id,
		t1.created,
		t1.updated
	FROM fascicles_pages as t1;

-- Insert documents
	
DELETE FROM layout_content WHERE content_type = 'document';
INSERT INTO layout_content (edition, fascicle, layout_version, content_type, content_parent, content_entity, created, updated) 
	SELECT 
		t1.edition, 
		t1.fascicle, 
		( SELECT layout_version FROM layout l2 WHERE l2.fascicle = t1.fascicle ) as layout_version,
		'document',
		t1.page, 
		t1.entity,
		t1.created,
		t1.updated
	FROM fascicles_map_documents as t1;	
*/