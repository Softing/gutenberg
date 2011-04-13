DROP TABLE fascicles_options;

DROP FUNCTION access_delete_after_trigger() CASCADE;
DROP FUNCTION access_insert_after_trigger() CASCADE;
DROP FUNCTION access_update_after_trigger() CASCADE;
DROP FUNCTION rules_delete_after_trigger() CASCADE;
DROP FUNCTION rules_insert_after_trigger() CASCADE;
DROP TABLE cache_access;
DROP TABLE cache_visibility;

-- Insert editions rules

DELETE FROM rules WHERE id = '9d057494-c2c6-41f5-9276-74b33b55c6e3';
UPDATE rules SET sortorder = 70 WHERE id = 'aa4e74ad-116e-4bb2-a910-899c4f288f40';

DELETE FROM rules WHERE section = 'editions';

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('e6ecbbda-a3c2-49de-ab4a-df127bd467a6', 'editions', 'calendar', 'view', 10, 'Can view calendar', 'calendar-day', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('63bd8ded-a884-4b5f-95f2-2797fb3ad6bb', 'editions', 'template', 'view', 20, 'Can view templates', 'puzzle', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('2f585b7b-bfa8-4a9f-a33b-74771ce0e89b', 'editions', 'template', 'manage', 30, 'Can manage templates', 'puzzle--pencil', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('09584423-a443-4f1c-b5e2-8c1a27a932b4', 'editions', 'fascicle', 'view', 40, 'Can view fascicles', 'blue-folder', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('901b9596-fb88-412c-b89a-945d162b0992', 'editions', 'fascicle', 'manage', 50, 'Can manage fascicles', 'blue-folder--pencil', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6ae65650-6837-4fca-a948-80ed6a565e25', 'editions', 'attachment', 'view', 60, 'Can view attachments', 'folder', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('ed8eac8e-370d-463c-a7ee-39ed5ee04a3f', 'editions', 'attachment', 'manage', 70, 'Can manage attachments', 'folder--pencil', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('30f27d95-c935-4940-b1db-e1e381fd061f', 'editions', 'advert', 'view', 80, 'Can view advertising', 'money', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('2b6a5a8a-390f-4dae-909b-fcc93c5740fd', 'editions', 'advert', 'manage', 90, 'Can manage advertising', 'money--pencil', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('133743df-52ab-4277-b320-3ede5222cb12', 'editions', 'documents', 'work', 100, 'Can manage documents', 'document-word', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('52dc7f72-2057-43c0-831d-55e458d84f39', 'editions', 'documents', 'assign', 110, 'Can assign fascicle', 'document-word', '');

-- Insert documents rules

DELETE FROM rules WHERE section = 'catalog';

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f', 'catalog', 'documents', 'view', 10, 'Can view materials', 'document', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('ee992171-d275-4d24-8def-7ff02adec408', 'catalog', 'documents', 'create', 20, 'Can create materials', 'document--plus', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('3040f8e1-051c-4876-8e8e-0ca4910e7e45', 'catalog', 'documents', 'delete', 30, 'Can delete materials', 'bin', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('beba3e8d-86e5-4e98-b3eb-368da28dba5f', 'catalog', 'documents', 'recover', 40, 'Can recover materials', 'bin--arrow', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('5b27108a-2108-4846-a0a8-3c369f873590', 'catalog', 'documents', 'update', 50, 'Can edit the profile', 'card--pencil', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6d590a90-58a1-447f-b5ad-b0582b64571a', 'catalog', 'documents', 'discuss', 60, 'Can discuss the materials', 'balloon-left', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6033984a-a762-4392-b086-a8d2cdac4221', 'catalog', 'documents', 'assign', 70, 'Can assign the editor', 'user-business', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('6d590a90-58a1-447f-b5ad-e3c62f80a2ef', 'catalog', 'documents', 'briefcase', 80, 'Can put in a briefcase', 'briefcase', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('d782679e-3f0a-4499-bda6-8c2600a3e761', 'catalog', 'documents', 'capture', 90, 'Can capture materials', 'hand', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('b946bd84-93fc-4a70-b325-d23c2804b2e9', 'catalog', 'documents', 'transfer', 100, 'Can transfer materials', 'document-import', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('b7adafe9-2d5b-44f3-aa87-681fd48466fa', 'catalog', 'documents', 'move', 110, 'Can move materials', 'blue-folder-import', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('bff78ebf-2cba-466e-9e3c-89f13a0882fc', 'catalog', 'documents', 'fedit', 120, 'Can work with files', 'disk', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('f4ad42ed-b46b-4b4e-859f-1b69b918a64a', 'catalog', 'documents', 'fadd', 130, 'Can add files', 'disk--plus', '');

INSERT INTO rules(id, section, subsection, term, sortorder, title, icon, description)
VALUES ('fe9cd446-2f4b-4844-9b91-5092c0cabece', 'catalog', 'documents', 'fdelete', 140, 'Can delete files', 'disk--minus', '');

-- Update translation

UPDATE rules SET title = 'Может входит в программу' 		WHERE id = '2fde426b-ed30-4376-9a7b-25278e8f104a';
UPDATE rules SET title = 'Может просматривать конфигурацию' WHERE id = '6406ad57-c889-47c5-acc6-0cd552e9cf5e';
UPDATE rules SET title = 'Может управлять отделами' 		WHERE id = 'e55d9548-36fe-4e51-bec2-663235b5383e';
UPDATE rules SET title = 'Может управлять сотрудниками' 	WHERE id = '32e0bb97-2bae-4ce8-865e-cdf0edb3fd93';
UPDATE rules SET title = 'Может управлять изданиями' 		WHERE id = '2a3cae11-23ea-41c3-bdb8-d3dfdc0d486a';
UPDATE rules SET title = 'Может управлять движением' 		WHERE id = '086993e0-56aa-441f-8eaf-437c1c5c9691';
UPDATE rules SET title = 'Может управлять ролями' 			WHERE id = '9d057494-c2c6-41f5-9276-74b33b55c6e3';
UPDATE rules SET title = 'Может управлять готовностью' 		WHERE id = 'aa4e74ad-116e-4bb2-a910-899c4f288f40';
UPDATE rules SET title = 'Может управлять рубрикатором' 	WHERE id = '9a756e9c-243a-4f5e-b814-fe3d1162a5e9';

-- Editions Rules

UPDATE rules SET title = 'Может просматривать календарь' 	WHERE id = 'e6ecbbda-a3c2-49de-ab4a-df127bd467a6';
UPDATE rules SET title = 'Может просматривать шаблоны' 		WHERE id = '63bd8ded-a884-4b5f-95f2-2797fb3ad6bb';
UPDATE rules SET title = 'Может управлять шаблонами' 		WHERE id = '2f585b7b-bfa8-4a9f-a33b-74771ce0e89b';
UPDATE rules SET title = 'Может просматривать выпуск' 		WHERE id = '09584423-a443-4f1c-b5e2-8c1a27a932b4';
UPDATE rules SET title = 'Может управлять выпусками' 		WHERE id = '901b9596-fb88-412c-b89a-945d162b0992';
UPDATE rules SET title = 'Может просматривать вкладки' 		WHERE id = '6ae65650-6837-4fca-a948-80ed6a565e25';
UPDATE rules SET title = 'Может управлять вкладками' 		WHERE id = 'ed8eac8e-370d-463c-a7ee-39ed5ee04a3f';
UPDATE rules SET title = 'Может просматривать рекламу' 		WHERE id = '30f27d95-c935-4940-b1db-e1e381fd061f';
UPDATE rules SET title = 'Может управлять рекламой' 		WHERE id = '2b6a5a8a-390f-4dae-909b-fcc93c5740fd';
UPDATE rules SET title = 'Может работать с материалами' 	WHERE id = '133743df-52ab-4277-b320-3ede5222cb12';
UPDATE rules SET title = 'Может назначать выпуск'	 		WHERE id = '52dc7f72-2057-43c0-831d-55e458d84f39';

-- Catalog Rules

UPDATE rules SET title = 'Может просматривать материалы' 	WHERE id = 'ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f';
UPDATE rules SET title = 'Может создавать материалы' 		WHERE id = 'ee992171-d275-4d24-8def-7ff02adec408';
UPDATE rules SET title = 'Может назначать отдел' 			WHERE id = '6033984a-a762-4392-b086-a8d2cdac4221';
UPDATE rules SET title = 'Может удалять материалы' 			WHERE id = '3040f8e1-051c-4876-8e8e-0ca4910e7e45';
UPDATE rules SET title = 'Может восстанавливать материалы' 	WHERE id = 'beba3e8d-86e5-4e98-b3eb-368da28dba5f';
UPDATE rules SET title = 'Может редактировать профиль'		WHERE id = '5b27108a-2108-4846-a0a8-3c369f873590';
UPDATE rules SET title = 'Может работать с файлами' 		WHERE id = 'bff78ebf-2cba-466e-9e3c-89f13a0882fc';
UPDATE rules SET title = 'Может добавлять файлы' 			WHERE id = 'f4ad42ed-b46b-4b4e-859f-1b69b918a64a';
UPDATE rules SET title = 'Может удалять файлы' 				WHERE id = 'fe9cd446-2f4b-4844-9b91-5092c0cabece';
UPDATE rules SET title = 'Может захватывать материалы'		WHERE id = 'd782679e-3f0a-4499-bda6-8c2600a3e761';
UPDATE rules SET title = 'Может передавать материалы' 		WHERE id = 'b946bd84-93fc-4a70-b325-d23c2804b2e9';
UPDATE rules SET title = 'Может перемещать материалы' 		WHERE id = 'b7adafe9-2d5b-44f3-aa87-681fd48466fa';
UPDATE rules SET title = 'Может перемещать в портфель' 		WHERE id = '6d590a90-58a1-447f-b5ad-e3c62f80a2ef';
UPDATE rules SET title = 'Может учавствовать в обсуждении' 	WHERE id = '6d590a90-58a1-447f-b5ad-b0582b64571a';
