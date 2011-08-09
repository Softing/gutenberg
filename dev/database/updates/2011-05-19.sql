CREATE TABLE "public"."cache_access" (
"id" uuid DEFAULT uuid_generate_v4() NOT NULL,
"member" uuid NOT NULL,
"binding" uuid NOT NULL,
"termkey" varchar NOT NULL,
"enabled" bool DEFAULT false NOT NULL,
CONSTRAINT "cache_access_pkey" PRIMARY KEY ("id")
);

DROP INDEX 		"public"."documents_edition_idx";
CREATE INDEX 	"documents_edition_idx" ON "public"."documents" ("edition");

DROP INDEX 		"public"."documents_workgroup_idx";
CREATE INDEX 	"documents_workgroup_idx" ON "public"."documents" ("workgroup");

DROP INDEX 		"public"."documents_fascicle_idx";
CREATE INDEX 	"documents_fascicle_idx" ON "public"."documents" ("fascicle");

DROP INDEX 		"public"."documents_edition_workgroup_fascicle_idx";
CREATE INDEX 	"documents_edition_workgroup_fascicle_idx" ON "public"."documents" ("edition", "workgroup", "fascicle");

DROP INDEX 		"public"."documents_edition_workgroup_idx";
CREATE INDEX 	"documents_edition_workgroup_idx" ON "public"."documents" ("edition", "workgroup");

