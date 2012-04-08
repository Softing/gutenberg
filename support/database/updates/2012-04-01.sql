/* Requests update */

ALTER TABLE fascicles_requests DROP COLUMN IF EXISTS "group_id";
ALTER TABLE fascicles_requests ADD COLUMN "group_id" VARCHAR ;

UPDATE fascicles_requests SET group_id = id;

ALTER TABLE fascicles_requests ALTER COLUMN "group_id" SET NOT NULL;
ALTER TABLE fascicles_requests ALTER COLUMN "group_id" SET DEFAULT uuid_generate_v4();

ALTER TABLE fascicles_requests DROP COLUMN IF EXISTS "fs_folder";
ALTER TABLE fascicles_requests ADD COLUMN "fs_folder" VARCHAR ;
UPDATE fascicles_requests SET fs_folder = '/datastore/requests/' || to_char(created, 'YYYY-MM') || '/' || id;

ALTER TABLE fascicles_requests ALTER COLUMN "fs_folder" SET NOT NULL;

/* Documents update */

ALTER TABLE documents DROP COLUMN IF EXISTS "group_id";
ALTER TABLE documents ADD COLUMN "group_id" VARCHAR ;

UPDATE documents SET group_id = id;

ALTER TABLE documents ALTER COLUMN "group_id" SET NOT NULL;
ALTER TABLE documents ALTER COLUMN "group_id" SET DEFAULT uuid_generate_v4();

ALTER TABLE documents DROP COLUMN IF EXISTS "fs_folder";
ALTER TABLE documents ADD COLUMN "fs_folder" VARCHAR ;

UPDATE documents SET group_id = copygroup;
UPDATE documents SET fs_folder = '/datastore/documents/' || to_char(created, 'YYYY-MM') || '/' || id;

ALTER TABLE documents ALTER COLUMN "fs_folder" SET NOT NULL;
