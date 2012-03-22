-- Inprint Content 5.0
-- Copyright(c) 2001-2010, Softing, LLC.
-- licensing@softing.ru
-- http://softing.ru/license

-------------------------------------------------------------------------------------------------
-- Domain rules
-------------------------------------------------------------------------------------------------

INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('b7adafe9-2d5b-44f3-aa87-681fd48466fa', 'move', 'catalog', 'documents', 'blue-folder-import', 'Может перемещать материалы', '', 110);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('2fde426b-ed30-4376-9a7b-25278e8f104a', 'allowed', 'domain', 'login', 'key', 'Может входит в программу', '', 10);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('6406ad57-c889-47c5-acc6-0cd552e9cf5e', 'view', 'domain', 'configuration', 'key', 'Может просматривать конфигурацию', '', 20);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('e55d9548-36fe-4e51-bec2-663235b5383e', 'manage', 'domain', 'departments', 'key', 'Может управлять отделами', '', 30);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('32e0bb97-2bae-4ce8-865e-cdf0edb3fd93', 'manage', 'domain', 'employees', 'key', 'Может управлять сотрудниками', '', 40);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('2a3cae11-23ea-41c3-bdb8-d3dfdc0d486a', 'manage', 'domain', 'editions', 'key', 'Может управлять изданиями', '', 50);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('086993e0-56aa-441f-8eaf-437c1c5c9691', 'manage', 'domain', 'exchange', 'key', 'Может управлять движением', '', 60);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('aa4e74ad-116e-4bb2-a910-899c4f288f40', 'manage', 'domain', 'readiness', 'key', 'Может управлять готовностью', '', 70);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('9a756e9c-243a-4f5e-b814-fe3d1162a5e9', 'manage', 'domain', 'index', 'key', 'Может управлять рубрикатором', '', 10);

-------------------------------------------------------------------------------------------------
-- Edition rules
-------------------------------------------------------------------------------------------------

INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('e6ecbbda-a3c2-49de-ab4a-df127bd467a6', 'view', 'editions', 'calendar', 'calendar-day', 'Может просматривать календарь', '', 10);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('63bd8ded-a884-4b5f-95f2-2797fb3ad6bb', 'view', 'editions', 'template', 'puzzle', 'Может просматривать шаблоны', '', 20);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('2f585b7b-bfa8-4a9f-a33b-74771ce0e89b', 'manage', 'editions', 'template', 'puzzle--pencil', 'Может управлять шаблонами', '', 30);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('09584423-a443-4f1c-b5e2-8c1a27a932b4', 'view', 'editions', 'fascicle', 'blue-folder', 'Может просматривать выпуск', '', 40);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('901b9596-fb88-412c-b89a-945d162b0992', 'manage', 'editions', 'fascicle', 'blue-folder--pencil', 'Может управлять выпусками', '', 50);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('6ae65650-6837-4fca-a948-80ed6a565e25', 'view', 'editions', 'attachment', 'folder', 'Может просматривать вкладки', '', 60);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('ed8eac8e-370d-463c-a7ee-39ed5ee04a3f', 'manage', 'editions', 'attachment', 'folder--pencil', 'Может управлять вкладками', '', 70);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('30f27d95-c935-4940-b1db-e1e381fd061f', 'view', 'editions', 'advert', 'money', 'Может просматривать рекламу', '', 80);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('2b6a5a8a-390f-4dae-909b-fcc93c5740fd', 'manage', 'editions', 'advert', 'money--pencil', 'Может управлять рекламой', '', 90);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('133743df-52ab-4277-b320-3ede5222cb12', 'work', 'editions', 'documents', 'document-word', 'Может работать с материалами', '', 100);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('52dc7f72-2057-43c0-831d-55e458d84f39', 'assign', 'editions', 'documents', 'document-word', 'Может назначать выпуск', '', 110);

-------------------------------------------------------------------------------------------------
-- Catalog rules
-------------------------------------------------------------------------------------------------

INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f', 'view', 'catalog', 'documents', 'document', 'Может просматривать материалы', '', 10);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('ee992171-d275-4d24-8def-7ff02adec408', 'create', 'catalog', 'documents', 'document--plus', 'Может создавать материалы', '', 20);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('6033984a-a762-4392-b086-a8d2cdac4221', 'assign', 'catalog', 'documents', 'user-business', 'Может назначать отдел', '', 70);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('3040f8e1-051c-4876-8e8e-0ca4910e7e45', 'delete', 'catalog', 'documents', 'bin', 'Может удалять материалы', '', 30);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('beba3e8d-86e5-4e98-b3eb-368da28dba5f', 'recover', 'catalog', 'documents', 'bin--arrow', 'Может восстанавливать материалы', '', 40);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('5b27108a-2108-4846-a0a8-3c369f873590', 'update', 'catalog', 'documents', 'card--pencil', 'Может редактировать профиль', '', 50);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('bff78ebf-2cba-466e-9e3c-89f13a0882fc', 'fedit', 'catalog', 'documents', 'disk', 'Может работать с файлами', '', 120);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('f4ad42ed-b46b-4b4e-859f-1b69b918a64a', 'fadd', 'catalog', 'documents', 'disk--plus', 'Может добавлять файлы', '', 130);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('fe9cd446-2f4b-4844-9b91-5092c0cabece', 'fdelete', 'catalog', 'documents', 'disk--minus', 'Может удалять файлы', '', 140);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('d782679e-3f0a-4499-bda6-8c2600a3e761', 'capture', 'catalog', 'documents', 'hand', 'Может захватывать материалы', '', 90);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('b946bd84-93fc-4a70-b325-d23c2804b2e9', 'transfer', 'catalog', 'documents', 'document-import', 'Может передавать материалы', '', 100);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('6d590a90-58a1-447f-b5ad-e3c62f80a2ef', 'briefcase', 'catalog', 'documents', 'briefcase', 'Может перемещать в портфель', '', 80);
INSERT INTO rules (id, term, section, subsection, icon, title, description, sortorder) VALUES ('6d590a90-58a1-447f-b5ad-b0582b64571a', 'discuss', 'catalog', 'documents', 'balloon-left', 'Может учавствовать в обсуждении', '', 60);
