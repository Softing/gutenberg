CREATE TABLE "public"."cache_downloads" (
	"id" uuid NOT NULL DEFAULT uuid_generate_v4(),
	"member" uuid NOT NULL,
	"document" uuid NOT NULL,
	"file" uuid NOT NULL,
	"created" timestamp(6) WITH TIME ZONE NOT NULL DEFAULT now(),
	"updated" timestamp(6) WITH TIME ZONE NOT NULL DEFAULT now(),
	CONSTRAINT "cache_downloads_pkey" PRIMARY KEY ("id"),
	CONSTRAINT "cache_downloads_document_fkey" FOREIGN KEY ("document") REFERENCES "public"."documents" ("id") ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE,
	CONSTRAINT "cache_downloads_member_fkey" FOREIGN KEY ("member") REFERENCES "public"."members" ("id") ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE INITIALLY IMMEDIATE
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."cache_downloads" OWNER TO "inprint";