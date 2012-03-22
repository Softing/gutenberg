-- Inprint Content 5.0
-- Copyright(c) 2001-2010, Softing, LLC.
-- licensing@softing.ru
-- http://softing.ru/license

-------------------------------------------------------------------------------------------------
-- Defaults
-------------------------------------------------------------------------------------------------

INSERT INTO catalog (id, path, title, shortcut, description, type, capables, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000000000000000000000000000', 'Publishing House', 'Publishing House', 'Publishing House', 'ou', '{default}', now(), now());

INSERT INTO editions (id, path, title, shortcut, description, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000000000000000000000000000', 'All editions', 'All editions', 'All editions', now(), now());

INSERT INTO fascicles( id, edition, parent, fastype, variation, shortcut, description, circulation, pnum, anum, manager, enabled, archived, flagdoc, flagadv, datedoc, dateadv, dateprint, dateout, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'system', '00000000-0000-0000-0000-000000000000', 'Briefcase', 'Briefcase', 0, 0, 0, null, true, false, 'bydate', 'bydate', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', now(), now());

INSERT INTO fascicles( id, edition, parent, fastype, variation, shortcut, description, circulation, pnum, anum, manager, enabled, archived, flagdoc, flagadv, datedoc, dateadv, dateprint, dateout, created, updated)
    VALUES ('99999999-9999-9999-9999-999999999999', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'system', '00000000-0000-0000-0000-000000000000', 'Recycle bin', 'Recycle bin', 0, 0, 0, null, true, false, 'bydate', 'bydate', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', now(), now());

INSERT INTO branches(id, edition, mtype, title, shortcut, description, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'Default branch', 'Default', 'This is default branch for everything', now(), now());

INSERT INTO readiness(id, color, weight, title, shortcut, description, created, updated)
	VALUES ('00000000-0000-0000-0000-000000000000', 'cc0033', 0, 'Default readiness' , 'Default', 'This is default readiness', now(), now());

INSERT INTO stages(id, branch, readiness, weight, title, shortcut, description, created, updated)
	VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 0, 'Default stage' , 'Default', 'This is default stage', now(), now());

-------------------------------------------------------------------------------------------------
-- Rubrication
-------------------------------------------------------------------------------------------------

-- Tags

INSERT INTO indx_tags(id, title, description, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '--', '--', now(), now());

-- Rubricator
	
INSERT INTO indx_headlines(id, edition, tag, title, description, bydefault, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '--', '--', true, now(), now());
	
INSERT INTO indx_rubrics(id, edition, headline, tag, title, description, bydefault, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '--', '--', true, now(), now());

-- Briefcase rubricator

INSERT INTO fascicles_indx_headlines(id, edition, fascicle, tag, bydefault, title, description, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', true, '--', '--', now(), now());

INSERT INTO fascicles_indx_rubrics(id, edition, fascicle, headline, tag, title, description, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '--', '--', now(), now());
	
-------------------------------------------------------------------------------------------------
-- Default user
-------------------------------------------------------------------------------------------------

INSERT INTO members(id, "login", "password", created, updated)
	VALUES ('39d40812-fc54-4342-9b98-e1c1f4222d22','root','4813494d137e1631bba301d5acab6e7bb7aa74ce1185d456565ef51d737677b2', now(), now());

-- Mappings 

INSERT INTO map_member_to_catalog(id, member, catalog)
    VALUES ('c293a89e-e044-41e6-a267-dbefba39a450', '39d40812-fc54-4342-9b98-e1c1f4222d22', '00000000-0000-0000-0000-000000000000');

-- Profile

INSERT INTO profiles 
	VALUES ('39d40812-fc54-4342-9b98-e1c1f4222d22', 'root', 'root', 'root', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, now(), now());

-- Options

INSERT INTO options 
	VALUES ('a3624a17-8591-454c-a80c-eefc94a01ad2', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'default.edition', '00000000-0000-0000-0000-000000000000');

INSERT INTO options 
	VALUES ('57c21607-96bd-44b9-8c49-8f3e3797ed2c', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'default.edition.name', 'All editions');

INSERT INTO options 
	VALUES ('171cf766-0899-4f80-ae25-812394d6e213', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'default.workgroup', '00000000-0000-0000-0000-000000000000');

INSERT INTO options 
	VALUES ('99ae8c4f-599b-4e01-bdb5-be0f191b3c24', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'default.workgroup.name', 'Publishing House');

-- Rules

INSERT INTO map_member_to_rule VALUES ('2f96242b-5c76-4418-afcb-4b2e75f95b48', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain',   'domain',  '00000000-0000-0000-0000-000000000000', '6406ad57-c889-47c5-acc6-0cd552e9cf5e');
INSERT INTO map_member_to_rule VALUES ('8c0bf266-a93d-4a46-930a-0c6ec558fa75', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain',   'domain',  '00000000-0000-0000-0000-000000000000', '32e0bb97-2bae-4ce8-865e-cdf0edb3fd93');
INSERT INTO map_member_to_rule VALUES ('10f41d8a-46a5-4f2d-824d-321243b92bc0', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain',   'domain',  '00000000-0000-0000-0000-000000000000', '086993e0-56aa-441f-8eaf-437c1c5c9691');
INSERT INTO map_member_to_rule VALUES ('1c6d1f3d-c4ad-4a2a-95d8-f0bb4637cc31', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain',   'domain',  '00000000-0000-0000-0000-000000000000', 'e55d9548-36fe-4e51-bec2-663235b5383e');
INSERT INTO map_member_to_rule VALUES ('b1421263-33cb-4b0a-a19c-c8706ef4db29', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain',   'domain',  '00000000-0000-0000-0000-000000000000', '2a3cae11-23ea-41c3-bdb8-d3dfdc0d486a');
INSERT INTO map_member_to_rule VALUES ('1697b7ce-aa5b-4719-9acf-687f4d6ebb1e', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain',   'domain',  '00000000-0000-0000-0000-000000000000', '2fde426b-ed30-4376-9a7b-25278e8f104a');
INSERT INTO map_member_to_rule VALUES ('2b50ec94-3936-4e2b-801a-129724c2bbe4', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain',   'domain',  '00000000-0000-0000-0000-000000000000', 'aa4e74ad-116e-4bb2-a910-899c4f288f40');
INSERT INTO map_member_to_rule VALUES ('72b48332-3ac3-4bed-bb51-34636d8eb47b', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain',   'domain',  '00000000-0000-0000-0000-000000000000', '9d057494-c2c6-41f5-9276-74b33b55c6e3');
INSERT INTO map_member_to_rule VALUES ('7f8d0427-0ddc-46df-ae05-45cff1592a31', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '0eecba74-ca40-4b8d-a710-03382483b0f4');
INSERT INTO map_member_to_rule VALUES ('2be8ca5e-1d1d-4337-8daf-853e07ec0d16', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '76323a53-1c22-4ff4-8f19-5e43d5aa0bd4');
INSERT INTO map_member_to_rule VALUES ('e6ea08e6-6b70-4207-a32e-2a00082bd603', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', 'ed9580be-1f36-45d1-9b60-36a2a85e5589');
INSERT INTO map_member_to_rule VALUES ('1ef9bea1-20b8-48f4-a1f7-938bc64e8232', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '2d34dbb9-db14-4fe8-a2c8-9a57e328b0b5');
INSERT INTO map_member_to_rule VALUES ('bc4dc623-ad04-4607-8aca-fec1e5e048d4', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '133743df-52ab-4277-b320-3ede5222cb12');
INSERT INTO map_member_to_rule VALUES ('cf119771-88f6-4340-b90d-dc2dec5e972f', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '52dc7f72-2057-43c0-831d-55e458d84f39');
INSERT INTO map_member_to_rule VALUES ('263dc904-04a9-4dde-b45f-fc42e53d2633', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', 'ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f');
INSERT INTO map_member_to_rule VALUES ('86f06119-51b1-4b88-90d6-039b8a3653b5', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', 'ee992171-d275-4d24-8def-7ff02adec408');
INSERT INTO map_member_to_rule VALUES ('35fbc95c-c2a2-469e-a073-1409404fbc7b', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', '6033984a-a762-4392-b086-a8d2cdac4221');
INSERT INTO map_member_to_rule VALUES ('3a9cf6b6-fe97-475d-9402-cf8a7f7529b9', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', '3040f8e1-051c-4876-8e8e-0ca4910e7e45');
INSERT INTO map_member_to_rule VALUES ('9fdfc627-6d8b-4386-99ac-36b25a0cbbfa', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', 'beba3e8d-86e5-4e98-b3eb-368da28dba5f');
INSERT INTO map_member_to_rule VALUES ('13a27a73-11d2-4f76-b254-2ba4c3f38b59', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', '5b27108a-2108-4846-a0a8-3c369f873590');
INSERT INTO map_member_to_rule VALUES ('efec22ec-5699-41aa-b1dd-1bafa1c6da2a', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', 'bff78ebf-2cba-466e-9e3c-89f13a0882fc');
INSERT INTO map_member_to_rule VALUES ('fcb7b6b1-8ac5-407b-9f78-469291682078', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', 'f4ad42ed-b46b-4b4e-859f-1b69b918a64a');
INSERT INTO map_member_to_rule VALUES ('1338097b-70a8-4bfd-ab36-bd52f60cc5eb', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', 'fe9cd446-2f4b-4844-9b91-5092c0cabece');
INSERT INTO map_member_to_rule VALUES ('84ed5cd1-5c9c-4b50-a873-10db89598491', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', 'd782679e-3f0a-4499-bda6-8c2600a3e761');
INSERT INTO map_member_to_rule VALUES ('57f60583-1fb6-4e4f-8c16-4b3c13c7500d', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', 'b946bd84-93fc-4a70-b325-d23c2804b2e9');
INSERT INTO map_member_to_rule VALUES ('d1c6f391-2ede-403c-8dc9-af5987993645', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', 'b7adafe9-2d5b-44f3-aa87-681fd48466fa');
INSERT INTO map_member_to_rule VALUES ('66c7862c-1e65-4042-abad-bfbf52d60225', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', '6d590a90-58a1-447f-b5ad-e3c62f80a2ef');
INSERT INTO map_member_to_rule VALUES ('4c134f39-ebbb-4fd4-99cf-522ca5fc38b2', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog',  'member',  '00000000-0000-0000-0000-000000000000', '6d590a90-58a1-447f-b5ad-b0582b64571a');

UPDATE map_member_to_rule SET termkey = ( SELECT termkey FROM view_rules WHERE view_rules.id = map_member_to_rule.term) || ':' || area;
