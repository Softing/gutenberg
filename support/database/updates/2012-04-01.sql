ALTER TABLE fascicles_requests DROP COLUMN IF EXISTS "group_id";
ALTER TABLE fascicles_requests ADD COLUMN "group_id" VARCHAR ;

UPDATE fascicles_requests SET group_id = id;

ALTER TABLE fascicles_requests ALTER COLUMN "group_id" SET NOT NULL;
ALTER TABLE fascicles_requests ALTER COLUMN "group_id" SET DEFAULT uuid_generate_v4();

ALTER TABLE fascicles_requests DROP COLUMN IF EXISTS "fs_folder";
ALTER TABLE fascicles_requests ADD COLUMN "fs_folder" VARCHAR ;
UPDATE fascicles_requests SET fs_folder = '/' || to_char(created, 'YYYY-MM') || '/' || id;

ALTER TABLE fascicles_requests ALTER COLUMN "fs_folder" SET NOT NULL;

