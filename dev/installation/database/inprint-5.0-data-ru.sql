-- Inprint Content 5.0
-- Copyright(c) 2001-2010, Softing, LLC.
-- licensing@softing.ru
-- http://softing.ru/license

-------------------------------------------------------------------------------------------------
-- i18n Russian - Common
-------------------------------------------------------------------------------------------------

UPDATE catalog SET title = 'Издательский дом', shortcut = 'Издательский дом', description = 'Издательский дом'
	WHERE id = '00000000-0000-0000-0000-000000000000';

UPDATE editions SET title = 'Все издания', shortcut = 'Все издания', description = 'Все издания'
 	WHERE id = '00000000-0000-0000-0000-000000000000';

UPDATE fascicles SET shortcut = 'Портфель', description = 'Портфель'
 	WHERE id = '00000000-0000-0000-0000-000000000000';

UPDATE fascicles SET shortcut = 'Корзина', description = 'Корзина'
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

UPDATE rules SET title = 'Может входит в программу' 		WHERE id = '2fde426b-ed30-4376-9a7b-25278e8f104a';
UPDATE rules SET title = 'Может просматривать конфигурацию' WHERE id = '6406ad57-c889-47c5-acc6-0cd552e9cf5e';
UPDATE rules SET title = 'Может управлять отделами' 		WHERE id = 'e55d9548-36fe-4e51-bec2-663235b5383e';
UPDATE rules SET title = 'Может управлять сотрудниками' 	WHERE id = '32e0bb97-2bae-4ce8-865e-cdf0edb3fd93';
UPDATE rules SET title = 'Может управлять изданиями' 		WHERE id = '2a3cae11-23ea-41c3-bdb8-d3dfdc0d486a';
UPDATE rules SET title = 'Может управлять движением' 		WHERE id = '086993e0-56aa-441f-8eaf-437c1c5c9691';
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
UPDATE rules SET title = 'Может назначать выпуск' 			WHERE id = '52dc7f72-2057-43c0-831d-55e458d84f39';

-- Catalog Rules

UPDATE rules SET title = 'Может просматривать материалы' 	WHERE id = 'ac0a0d95-c4d3-4bd7-93c3-cc0fc230936f';
UPDATE rules SET title = 'Может создавать материалы' 		WHERE id = 'ee992171-d275-4d24-8def-7ff02adec408';
UPDATE rules SET title = 'Может назначать отдел'			WHERE id = '6033984a-a762-4392-b086-a8d2cdac4221';
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
UPDATE rules SET title = 'Может участвовать в обсуждении' 	WHERE id = '6d590a90-58a1-447f-b5ad-b0582b64571a';