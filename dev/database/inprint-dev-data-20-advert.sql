/*
Inprint 5.0 DEMO database
Date: 2011-02-22 21:06:19
*/

BEGIN;

-- ----------------------------
-- Records of ad_advertisers
-- ----------------------------
INSERT INTO "ad_advertisers" ("id", "edition", "serialnum", "title", "shortcut", "description", "address", "contact", "phones", "inn", "kpp", "bank", "rs", "ks", "bik", "created", "updated") VALUES ('44d2fdfe-b28f-4c67-80c7-e609bfdce267', '57ea720b-39fb-4e96-bcb6-ae3ebf6d474b', 2, 'Genser', 'Genser', 'Genser', '', '', '', '', '', '', '', '', '', '2011-2-28 11:15:59', '2011-2-28 11:15:59');
INSERT INTO "ad_advertisers" ("id", "edition", "serialnum", "title", "shortcut", "description", "address", "contact", "phones", "inn", "kpp", "bank", "rs", "ks", "bik", "created", "updated") VALUES ('5344c537-04f2-408c-bdef-d80f80a07b8a', '57ea720b-39fb-4e96-bcb6-ae3ebf6d474b', 1, 'СОРОКИН', 'СОРОКИН', 'СОРОКИН', '', '', '', '', '', '', '', '', '', '2011-2-28 11:14:42', '2011-2-28 11:14:42');

-- ----------------------------
-- Records of ad_index
-- ----------------------------

-- ----------------------------
-- Records of ad_modules
-- ----------------------------
INSERT INTO "ad_modules" ("id", "edition", "page", "title", "description", "amount", "area", "x", "y", "w", "h", "created", "updated") VALUES ('0a9b159d-3d86-454f-a54a-ef8a7e6df8da', '57ea720b-39fb-4e96-bcb6-ae3ebf6d474b', '1c26a3cf-e145-4cfb-aabc-50381cb9eaa0', '1/1', '1/1', 1, 1, '0/1', '0/1', '1/1', '1/1', '2011-2-28 11:39:14', '2011-2-28 11:39:14');
INSERT INTO "ad_modules" ("id", "edition", "page", "title", "description", "amount", "area", "x", "y", "w", "h", "created", "updated") VALUES ('252f077e-48dc-4de1-94e9-1cba49927049', '57ea720b-39fb-4e96-bcb6-ae3ebf6d474b', '1c26a3cf-e145-4cfb-aabc-50381cb9eaa0', '2/1', '2/1', 2, 2, '0/1', '0/1', '1/1', '1/1', '2011-2-28 11:39:26', '2011-2-28 11:39:26');
INSERT INTO "ad_modules" ("id", "edition", "page", "title", "description", "amount", "area", "x", "y", "w", "h", "created", "updated") VALUES ('b5ce4e80-4b4a-427e-8f10-681ccc7107a0', '57ea720b-39fb-4e96-bcb6-ae3ebf6d474b', '1c26a3cf-e145-4cfb-aabc-50381cb9eaa0', '1/2 гор', '1/2 гор', 1, 0.5, '0/1', '1/2', '1/1', '1/2', '2011-2-28 11:39:49', '2011-2-28 11:39:49');
INSERT INTO "ad_modules" ("id", "edition", "page", "title", "description", "amount", "area", "x", "y", "w", "h", "created", "updated") VALUES ('f7a3c593-87f8-4620-88bc-51a0853cfb9a', '57ea720b-39fb-4e96-bcb6-ae3ebf6d474b', '1c26a3cf-e145-4cfb-aabc-50381cb9eaa0', '1/2 верт', '1/2 верт', 1, 0.5, '1/2', '0/1', '1/2', '1/1', '2011-2-28 11:40:02', '2011-2-28 11:40:02');

-- ----------------------------
-- Records of ad_pages
-- ----------------------------
INSERT INTO "ad_pages" ("id", "edition", "title", "description", "bydefault", "w", "h", "created", "updated") VALUES ('1c26a3cf-e145-4cfb-aabc-50381cb9eaa0', '57ea720b-39fb-4e96-bcb6-ae3ebf6d474b', '6x6', '6x6', 't', '{1/6,2/6,3/6,4/6,5/6}', '{1/6,2/6,3/6,4/6,5/6}', '2011-2-28 11:38:47', '2011-2-28 11:38:47');

-- ----------------------------
-- Records of ad_places
-- ----------------------------

COMMIT;