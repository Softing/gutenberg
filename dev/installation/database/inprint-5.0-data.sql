-------------------------------------------------------------------------------------------------
-- Domain Rules
-------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------
-- Documents Rules
-------------------------------------------------------------------------------------------------

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f', 'catalog', 'documents', 'view', 10, 'Can view materials', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('ee992171-d275-4d24-8def-7ff02adec408', 'catalog', 'documents', 'create', 20, 'Can create materials', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6033984a-a762-4392-b086-a8d2cdac4221', 'catalog', 'documents', 'assign', 30, 'Can assign the editor', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('3040f8e1-051c-4876-8e8e-0ca4910e7e45', 'catalog', 'documents', 'delete', 40, 'Can delete materials', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('beba3e8d-86e5-4e98-b3eb-368da28dba5f', 'catalog', 'documents', 'recover', 50, 'Can recover materials', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('5b27108a-2108-4846-a0a8-3c369f873590', 'catalog', 'documents', 'update', 60, 'Can edit the profile', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('bff78ebf-2cba-466e-9e3c-89f13a0882fc', 'catalog', 'files', 'work', 70, 'Can work with files', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('f4ad42ed-b46b-4b4e-859f-1b69b918a64a', 'catalog', 'files', 'add', 80, 'Can add files', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('fe9cd446-2f4b-4844-9b91-5092c0cabece', 'catalog', 'files', 'delete', 90, 'Can delete files', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('d782679e-3f0a-4499-bda6-8c2600a3e761', 'catalog', 'documents', 'capture', 100, 'Can capture materials', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('b946bd84-93fc-4a70-b325-d23c2804b2e9', 'catalog', 'documents', 'transfer', 110, 'Can transfer materials', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('b7adafe9-2d5b-44f3-aa87-681fd48466fa', 'catalog', 'documents', 'move', 120, 'Can move materials', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6d590a90-58a1-447f-b5ad-e3c62f80a2ef', 'catalog', 'documents', 'briefcase', 130, 'Can put in a briefcase', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6d590a90-58a1-447f-b5ad-b0582b64571a', 'catalog', 'documents', 'discuss', 140, 'Can discuss the materials', 'key', '');

-------------------------------------------------------------------------------------------------
-- Editions Rules
-------------------------------------------------------------------------------------------------

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('76323a53-1c22-4ff4-8f19-5e43d5aa0bd4', 'editions', 'calendar', 'view', 10, 'Can view calendar', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('0eecba74-ca40-4b8d-a710-03382483b0f4', 'editions', 'calendar', 'manage', 10, 'Can manage the calendar', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('2d34dbb9-db14-4fe8-a2c8-9a57e328b0b5', 'editions', 'layouts', 'view', 20, 'Can view layouts', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('ed9580be-1f36-45d1-9b60-36a2a85e5589', 'editions', 'layouts', 'manage', 20, 'Can manage layouts', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('133743df-52ab-4277-b320-3ede5222cb12', 'editions', 'documents', 'work', 30, 'Can work with documents', 'key', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('52dc7f72-2057-43c0-831d-55e458d84f39', 'editions', 'documents', 'assign', 40, 'Can assign the fascicle', 'key', '');

-------------------------------------------------------------------------------------------------
-- Defaults
-------------------------------------------------------------------------------------------------

INSERT INTO catalog (id, path, title, shortcut, description, type, capables, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000000000000000000000000000', 'Издательский Дом', 'ИД ЗР', 'Издательский дом', 'ou', '{default}', now(), now());

INSERT INTO editions (id, path, title, shortcut, description, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000000000000000000000000000', 'Все издания', 'Все издания', 'Все издания', now(), now());
	
INSERT INTO fascicles(id, base_edition, edition, variation, title, shortcut, description, is_system, is_enabled, is_blocked, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'Портфель', 'Портфель', 'Портфель материалов', true, true, false, now(), now());

INSERT INTO fascicles(id, base_edition, edition, variation, title, shortcut, description, is_system, is_enabled, is_blocked, created, updated)
    VALUES ('99999999-9999-9999-9999-999999999999', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'Корзина', 'Корзина', 'Корзина материалов', true, true, false, now(), now());

INSERT INTO members(id, "login", "password", created, updated)
	VALUES ('39d40812-fc54-4342-9b98-e1c1f4222d22','root','4813494d137e1631bba301d5acab6e7bb7aa74ce1185d456565ef51d737677b2', now(), now());

INSERT INTO map_member_to_catalog(id, member, catalog)
    VALUES ('c293a89e-e044-41e6-a267-dbefba39a450', '39d40812-fc54-4342-9b98-e1c1f4222d22', '00000000-0000-0000-0000-000000000000');

-------------------------------------------------------------------------------------------------
-- Default user
-------------------------------------------------------------------------------------------------
	
INSERT INTO map_member_to_rule(id, member, section, area, binding, term)
    VALUES ('2f96242b-5c76-4418-afcb-4b2e75f95b48', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '6406ad57-c889-47c5-acc6-0cd552e9cf5e');
INSERT INTO map_member_to_rule(id, member, section, area, binding, term)
    VALUES ('8c0bf266-a93d-4a46-930a-0c6ec558fa75', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '32e0bb97-2bae-4ce8-865e-cdf0edb3fd93');
INSERT INTO map_member_to_rule(id, member, section, area, binding, term)
    VALUES ('10f41d8a-46a5-4f2d-824d-321243b92bc0', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '086993e0-56aa-441f-8eaf-437c1c5c9691');
INSERT INTO map_member_to_rule(id, member, section, area, binding, term)
    VALUES ('1c6d1f3d-c4ad-4a2a-95d8-f0bb4637cc31', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', 'e55d9548-36fe-4e51-bec2-663235b5383e');
INSERT INTO map_member_to_rule(id, member, section, area, binding, term)
    VALUES ('b1421263-33cb-4b0a-a19c-c8706ef4db29', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '2a3cae11-23ea-41c3-bdb8-d3dfdc0d486a');
INSERT INTO map_member_to_rule(id, member, section, area, binding, term)
    VALUES ('1697b7ce-aa5b-4719-9acf-687f4d6ebb1e', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '2fde426b-ed30-4376-9a7b-25278e8f104a');
INSERT INTO map_member_to_rule(id, member, section, area, binding, term)
    VALUES ('2b50ec94-3936-4e2b-801a-129724c2bbe4', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', 'aa4e74ad-116e-4bb2-a910-899c4f288f40');
INSERT INTO map_member_to_rule(id, member, section, area, binding, term)
    VALUES ('72b48332-3ac3-4bed-bb51-34636d8eb47b', '39d40812-fc54-4342-9b98-e1c1f4222d22', 'domain', 'domain', '00000000-0000-0000-0000-000000000000', '9d057494-c2c6-41f5-9276-74b33b55c6e3');




