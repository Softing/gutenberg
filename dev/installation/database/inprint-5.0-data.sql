-------------------------------------------------------------------------------------------------
-- System Rules
-------------------------------------------------------------------------------------------------

-- Domain

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('2fde426b-ed30-4376-9a7b-25278e8f104a', 'domain', 'login', 'allowed', 10, 'Can log in to the program', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6406ad57-c889-47c5-acc6-0cd552e9cf5e', 'domain', 'configuration', 'view', 20, 'Can view the configuration', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('e55d9548-36fe-4e51-bec2-663235b5383e', 'domain', 'departments', 'manage', 30, 'Can manage departments', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('32e0bb97-2bae-4ce8-865e-cdf0edb3fd93', 'domain', 'employees', 'manage', 40, 'Can manage employees', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('2a3cae11-23ea-41c3-bdb8-d3dfdc0d486a', 'domain', 'editions', 'manage', 50, 'Can manage editions', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('086993e0-56aa-441f-8eaf-437c1c5c9691', 'domain', 'exchange', 'manage', 60, 'Can manage the exchange', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('9d057494-c2c6-41f5-9276-74b33b55c6e3', 'domain', 'roles', 'manage', 70, 'Can manage roles', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('aa4e74ad-116e-4bb2-a910-899c4f288f40', 'domain', 'readiness', 'manage', 80, 'Can manage the readiness', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('9a756e9c-243a-4f5e-b814-fe3d1162a5e9', 'domain', 'index', 'manage', 90, 'Can manage the index', 'key', '');

-- Editions Rules

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('76323a53-1c22-4ff4-8f19-5e43d5aa0bd4', 'editions', 'calendar', 'view', 10, 'Can view calendar', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('0eecba74-ca40-4b8d-a710-03382483b0f4', 'editions', 'calendar', 'manage', 10, 'Can manage the calendar', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('2d34dbb9-db14-4fe8-a2c8-9a57e328b0b5', 'editions', 'layouts', 'view', 20, 'Can view layouts', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('ed9580be-1f36-45d1-9b60-36a2a85e5589', 'editions', 'layouts', 'manage', 20, 'Can manage layouts', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('133743df-52ab-4277-b320-3ede5222cb12', 'editions', 'documents', 'work', 30, 'Can view documents', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('52dc7f72-2057-43c0-831d-55e458d84f39', 'editions', 'documents', 'assign', 40, 'Can assign the fascicle', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('331895b6-5bbf-4222-a3a4-570b02c2aebe', 'editions', 'index', 'manage', 50, 'Can manage the index', 'key', '');

-- Catalog Rules

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f', 'catalog', 'documents', 'view', 10, 'Can view documents', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('ee992171-d275-4d24-8def-7ff02adec408', 'catalog', 'documents', 'create', 20, 'Can create documents', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6033984a-a762-4392-b086-a8d2cdac4221', 'catalog', 'documents', 'assign', 30, 'Can assign the editor', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('3040f8e1-051c-4876-8e8e-0ca4910e7e45', 'catalog', 'documents', 'delete', 40, 'Can delete documents', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('beba3e8d-86e5-4e98-b3eb-368da28dba5f', 'catalog', 'documents', 'recover', 50, 'Can recover documents', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('5b27108a-2108-4846-a0a8-3c369f873590', 'catalog', 'documents', 'update', 60, 'Can edit the profile', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('bff78ebf-2cba-466e-9e3c-89f13a0882fc', 'catalog', 'files', 'work', 70, 'Can work with files', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('f4ad42ed-b46b-4b4e-859f-1b69b918a64a', 'catalog', 'files', 'add', 80, 'Can add files', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('fe9cd446-2f4b-4844-9b91-5092c0cabece', 'catalog', 'files', 'delete', 90, 'Can delete files', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('d782679e-3f0a-4499-bda6-8c2600a3e761', 'catalog', 'documents', 'capture', 100, 'Can capture documents', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('b946bd84-93fc-4a70-b325-d23c2804b2e9', 'catalog', 'documents', 'transfer', 110, 'Can transfer documents', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('b7adafe9-2d5b-44f3-aa87-681fd48466fa', 'catalog', 'documents', 'move', 120, 'Can move documents', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6d590a90-58a1-447f-b5ad-e3c62f80a2ef', 'catalog', 'documents', 'briefcase', 130, 'Can put in a briefcase', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6d590a90-58a1-447f-b5ad-b0582b64571a', 'catalog', 'documents', 'discuss', 140, 'Can discuss the documents', 'key', '');

-------------------------------------------------------------------------------------------------
-- Defaults
-------------------------------------------------------------------------------------------------

INSERT INTO catalog (id, path, title, shortcut, description, type, capables, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000000000000000000000000000', 'Publishing House', 'Publishing House', 'Publishing House', 'ou', '{default}', now(), now());

INSERT INTO editions (id, path, title, shortcut, description, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000000000000000000000000000', 'All editions', 'All editions', 'All editions', now(), now());

INSERT INTO fascicles(id, edition, parent, title, shortcut, description, manager, variation, deadline, advert_deadline, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'Briefcase', 'Briefcase', 'Briefcase', null, '00000000-0000-0000-0000-000000000000', now(), now(), now(), now());

INSERT INTO fascicles(id, edition, parent, title, shortcut, description, manager, variation, deadline, advert_deadline, created, updated)
    VALUES ('99999999-9999-9999-9999-999999999999', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'Recycle bin', 'Recycle bin', 'Recycle bin', null, '00000000-0000-0000-0000-000000000000', now(), now(), now(), now());

INSERT INTO branches(id, edition, mtype, title, shortcut, description, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'Default branch', 'Default', 'This is default branch for everything', now(), now());

INSERT INTO readiness(id, color, weight, title, shortcut, description, created, updated)
	VALUES ('00000000-0000-0000-0000-000000000000', 'cc0033', 0, 'Default readiness' , 'Default', 'This is default readiness', now(), now());

INSERT INTO stages(id, branch, readiness, weight, title, shortcut, description, created, updated)
	VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 0, 'Default stage' , 'Default', 'This is default stage', now(), now());

UPDATE fascicles SET deadline='2020-01-01 16:23:10+03'
 	WHERE id = '00000000-0000-0000-0000-000000000000';
	
UPDATE fascicles SET deadline='2020-01-01 16:23:10+03'
 	WHERE id = '99999999-9999-9999-9999-999999999999';
	
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

-- Member

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

INSERT INTO map_member_to_rule VALUES ('2f96242b-5c76-4418-afcb-4b2e75f95b48', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '6406ad57-c889-47c5-acc6-0cd552e9cf5e');
INSERT INTO map_member_to_rule VALUES ('8c0bf266-a93d-4a46-930a-0c6ec558fa75', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '32e0bb97-2bae-4ce8-865e-cdf0edb3fd93');
INSERT INTO map_member_to_rule VALUES ('10f41d8a-46a5-4f2d-824d-321243b92bc0', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '086993e0-56aa-441f-8eaf-437c1c5c9691');
INSERT INTO map_member_to_rule VALUES ('1c6d1f3d-c4ad-4a2a-95d8-f0bb4637cc31', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', 'e55d9548-36fe-4e51-bec2-663235b5383e');
INSERT INTO map_member_to_rule VALUES ('b1421263-33cb-4b0a-a19c-c8706ef4db29', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '2a3cae11-23ea-41c3-bdb8-d3dfdc0d486a');
INSERT INTO map_member_to_rule VALUES ('1697b7ce-aa5b-4719-9acf-687f4d6ebb1e', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '2fde426b-ed30-4376-9a7b-25278e8f104a');
INSERT INTO map_member_to_rule VALUES ('2b50ec94-3936-4e2b-801a-129724c2bbe4', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', 'aa4e74ad-116e-4bb2-a910-899c4f288f40');
INSERT INTO map_member_to_rule VALUES ('72b48332-3ac3-4bed-bb51-34636d8eb47b', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '9d057494-c2c6-41f5-9276-74b33b55c6e3');
INSERT INTO map_member_to_rule VALUES ('7f8d0427-0ddc-46df-ae05-45cff1592a31', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '0eecba74-ca40-4b8d-a710-03382483b0f4');
INSERT INTO map_member_to_rule VALUES ('2be8ca5e-1d1d-4337-8daf-853e07ec0d16', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '76323a53-1c22-4ff4-8f19-5e43d5aa0bd4');
INSERT INTO map_member_to_rule VALUES ('e6ea08e6-6b70-4207-a32e-2a00082bd603', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', 'ed9580be-1f36-45d1-9b60-36a2a85e5589');
INSERT INTO map_member_to_rule VALUES ('1ef9bea1-20b8-48f4-a1f7-938bc64e8232', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '2d34dbb9-db14-4fe8-a2c8-9a57e328b0b5');
INSERT INTO map_member_to_rule VALUES ('bc4dc623-ad04-4607-8aca-fec1e5e048d4', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '133743df-52ab-4277-b320-3ede5222cb12');
INSERT INTO map_member_to_rule VALUES ('cf119771-88f6-4340-b90d-dc2dec5e972f', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'editions', 'edition', '00000000-0000-0000-0000-000000000000', '52dc7f72-2057-43c0-831d-55e458d84f39');
INSERT INTO map_member_to_rule VALUES ('263dc904-04a9-4dde-b45f-fc42e53d2633', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f');
INSERT INTO map_member_to_rule VALUES ('86f06119-51b1-4b88-90d6-039b8a3653b5', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'ee992171-d275-4d24-8def-7ff02adec408');
INSERT INTO map_member_to_rule VALUES ('35fbc95c-c2a2-469e-a073-1409404fbc7b', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', '6033984a-a762-4392-b086-a8d2cdac4221');
INSERT INTO map_member_to_rule VALUES ('3a9cf6b6-fe97-475d-9402-cf8a7f7529b9', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', '3040f8e1-051c-4876-8e8e-0ca4910e7e45');
INSERT INTO map_member_to_rule VALUES ('9fdfc627-6d8b-4386-99ac-36b25a0cbbfa', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'beba3e8d-86e5-4e98-b3eb-368da28dba5f');
INSERT INTO map_member_to_rule VALUES ('13a27a73-11d2-4f76-b254-2ba4c3f38b59', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', '5b27108a-2108-4846-a0a8-3c369f873590');
INSERT INTO map_member_to_rule VALUES ('efec22ec-5699-41aa-b1dd-1bafa1c6da2a', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'bff78ebf-2cba-466e-9e3c-89f13a0882fc');
INSERT INTO map_member_to_rule VALUES ('fcb7b6b1-8ac5-407b-9f78-469291682078', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'f4ad42ed-b46b-4b4e-859f-1b69b918a64a');
INSERT INTO map_member_to_rule VALUES ('1338097b-70a8-4bfd-ab36-bd52f60cc5eb', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'fe9cd446-2f4b-4844-9b91-5092c0cabece');
INSERT INTO map_member_to_rule VALUES ('84ed5cd1-5c9c-4b50-a873-10db89598491', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'd782679e-3f0a-4499-bda6-8c2600a3e761');
INSERT INTO map_member_to_rule VALUES ('57f60583-1fb6-4e4f-8c16-4b3c13c7500d', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'b946bd84-93fc-4a70-b325-d23c2804b2e9');
INSERT INTO map_member_to_rule VALUES ('d1c6f391-2ede-403c-8dc9-af5987993645', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', 'b7adafe9-2d5b-44f3-aa87-681fd48466fa');
INSERT INTO map_member_to_rule VALUES ('66c7862c-1e65-4042-abad-bfbf52d60225', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', '6d590a90-58a1-447f-b5ad-e3c62f80a2ef');
INSERT INTO map_member_to_rule VALUES ('4c134f39-ebbb-4fd4-99cf-522ca5fc38b2', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'catalog', 'member', '00000000-0000-0000-0000-000000000000', '6d590a90-58a1-447f-b5ad-b0582b64571a');

-------------------------------------------------------------------------------------------------
-- i18n Russian - Common
-------------------------------------------------------------------------------------------------

UPDATE catalog SET title = 'Издательский дом', shortcut = 'Издательский дом', description = 'Издательский дом'
	WHERE id = '00000000-0000-0000-0000-000000000000';

UPDATE editions SET title = 'Все издания', shortcut = 'Все издания', description = 'Все издания'
 	WHERE id = '00000000-0000-0000-0000-000000000000';

UPDATE fascicles SET title = 'Портфель', shortcut = 'Портфель', description = 'Портфель'
 	WHERE id = '00000000-0000-0000-0000-000000000000';

UPDATE fascicles SET title = 'Корзина', shortcut = 'Корзина', description = 'Корзина'
 	WHERE id = '99999999-9999-9999-9999-999999999999';

UPDATE documents SET fascicle_shortcut = 'Портфель'
 	WHERE fascicle = '00000000-0000-0000-0000-000000000000';

UPDATE documents SET fascicle_shortcut = 'Корзина'
 	WHERE fascicle = '99999999-9999-9999-9999-999999999999';

UPDATE branches  SET title = 'Ветвь по умолчанию', shortcut = 'По умолчанию', description = 'Это ветвь по умолчанию' WHERE id = '00000000-0000-0000-0000-000000000000';
UPDATE readiness SET title = 'Готовность по умолчанию', shortcut = 'По умолчанию', description = 'Это готовность по умолчанию' WHERE id = '00000000-0000-0000-0000-000000000000';
UPDATE stages       SET title = 'Ступень по умолчанию', shortcut = 'По умолчанию', description = 'Это ступень по умолчанию' WHERE id = '00000000-0000-0000-0000-000000000000';

UPDATE options SET option_value = 'Издательский дом' WHERE option_name = 'default.workgroup.name';
UPDATE options SET option_value = 'Все издания'      WHERE option_name = 'default.edition.name';

-------------------------------------------------------------------------------------------------
-- i18n Russian - Rules
-------------------------------------------------------------------------------------------------

UPDATE rules SET sortorder=10, title = 'Может входит в программу' WHERE id = '2fde426b-ed30-4376-9a7b-25278e8f104a';
UPDATE rules SET sortorder=20, title = 'Может просматривать конфигурацию' WHERE id = '6406ad57-c889-47c5-acc6-0cd552e9cf5e';
UPDATE rules SET sortorder=30, title = 'Может управлять отделами' WHERE id = 'e55d9548-36fe-4e51-bec2-663235b5383e';
UPDATE rules SET sortorder=40, title = 'Может управлять сотрудниками' WHERE id = '32e0bb97-2bae-4ce8-865e-cdf0edb3fd93';
UPDATE rules SET sortorder=50, title = 'Может управлять изданиями' WHERE id = '2a3cae11-23ea-41c3-bdb8-d3dfdc0d486a';
UPDATE rules SET sortorder=60, title = 'Может управлять движением' WHERE id = '086993e0-56aa-441f-8eaf-437c1c5c9691';
UPDATE rules SET sortorder=70, title = 'Может управлять ролями' WHERE id = '9d057494-c2c6-41f5-9276-74b33b55c6e3';
UPDATE rules SET sortorder=80, title = 'Может управлять готовностью' WHERE id = 'aa4e74ad-116e-4bb2-a910-899c4f288f40';
UPDATE rules SET sortorder=10, title = 'Может управлять рубрикатором' WHERE id = '9a756e9c-243a-4f5e-b814-fe3d1162a5e9';

-- Editions Rules

UPDATE rules SET sortorder=10, title = 'Может просматривать календарь' WHERE id = '76323a53-1c22-4ff4-8f19-5e43d5aa0bd4';
UPDATE rules SET sortorder=20, title = 'Может управлять календарем' WHERE id = '0eecba74-ca40-4b8d-a710-03382483b0f4';
UPDATE rules SET sortorder=30, title = 'Может просматривать полосы' WHERE id = '2d34dbb9-db14-4fe8-a2c8-9a57e328b0b5';
UPDATE rules SET sortorder=40, title = 'Может управлять полосами' WHERE id = 'ed9580be-1f36-45d1-9b60-36a2a85e5589';
UPDATE rules SET sortorder=50, title = 'Может просматривать материалы' WHERE id = '133743df-52ab-4277-b320-3ede5222cb12';
UPDATE rules SET sortorder=60, title = 'Может назначать выпуск' WHERE id = '52dc7f72-2057-43c0-831d-55e458d84f39';
UPDATE rules SET sortorder=70, title = 'Может управлять рубрикатором' WHERE id = '331895b6-5bbf-4222-a3a4-570b02c2aebe';

-- Catalog Rules

UPDATE rules SET sortorder=10, title = 'Может просматривать материалы' WHERE id = 'ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f';
UPDATE rules SET sortorder=20, title = 'Может создавать материалы' WHERE id = 'ee992171-d275-4d24-8def-7ff02adec408';
UPDATE rules SET sortorder=30, title = 'Может назначать в отдел' WHERE id = '6033984a-a762-4392-b086-a8d2cdac4221';
UPDATE rules SET sortorder=40, title = 'Может удалять материалы' WHERE id = '3040f8e1-051c-4876-8e8e-0ca4910e7e45';
UPDATE rules SET sortorder=50, title = 'Может восстанавливать материалы' WHERE id = 'beba3e8d-86e5-4e98-b3eb-368da28dba5f';
UPDATE rules SET sortorder=60, title = 'Может редактировать профиль материала' WHERE id = '5b27108a-2108-4846-a0a8-3c369f873590';
UPDATE rules SET sortorder=70, title = 'Может работать с файлами материала' WHERE id = 'bff78ebf-2cba-466e-9e3c-89f13a0882fc';
UPDATE rules SET sortorder=80, title = 'Мжет добавлять файлы в материал' WHERE id = 'f4ad42ed-b46b-4b4e-859f-1b69b918a64a';
UPDATE rules SET sortorder=90, title = 'Может удалять материалы' WHERE id = 'fe9cd446-2f4b-4844-9b91-5092c0cabece';
UPDATE rules SET sortorder=100, title = 'Может захватывать материалы' WHERE id = 'd782679e-3f0a-4499-bda6-8c2600a3e761';
UPDATE rules SET sortorder=110, title = 'Может передавать материалы другим сотрудникам' WHERE id = 'b946bd84-93fc-4a70-b325-d23c2804b2e9';
UPDATE rules SET sortorder=120, title = 'Может перемещать материалы между выпусками' WHERE id = 'b7adafe9-2d5b-44f3-aa87-681fd48466fa';
UPDATE rules SET sortorder=130, title = 'Может перемещать материалы в портфель' WHERE id = '6d590a90-58a1-447f-b5ad-e3c62f80a2ef';
UPDATE rules SET sortorder=140, title = 'Может учавствовать в обсуждении материалов' WHERE id = '6d590a90-58a1-447f-b5ad-b0582b64571a';
