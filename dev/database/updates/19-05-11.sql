CREATE TABLE "public"."cache_access" (
"id" uuid DEFAULT uuid_generate_v4() NOT NULL,
"member" uuid NOT NULL,
"binding" uuid NOT NULL,
"termkey" varchar NOT NULL,
"enabled" bool DEFAULT false NOT NULL,
CONSTRAINT "cache_access_pkey" PRIMARY KEY ("id")
);

