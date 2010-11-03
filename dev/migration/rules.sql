DELETE FROM rules;

-- Domain

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('domain', 'control', 'all', 1, 'To control domain', '', '');

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('domain', 'control', 'employees', 2, 'To control employees', '', '');

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('domain', 'control', 'passwords', 3, 'To control passwords', '', '');

-- Organization

-- To view materials
-- Просматривать материалы

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'documents', 'view', 1, 'To view materials', '', '');

-- To create materials
-- Добавлять материалы

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'documents', 'create', 2, 'To create materials', '', '');

-- To assign the editor
-- Назначать редактора

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'documents', 'assign', 3, 'To assign the editor', '', '');

-- To delete materials
-- Удалять материалы

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'documents', 'delete', 4, 'To delete materials', '', '');

-- To recover materials
-- Восстанавливать материалы

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'documents', 'recover', 5, 'To recover materials', '', '');

-- To edit the logbook
-- Редактировать формуляр

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'profile', 'edit', 6, 'To edit the profile', '', '');

-- To work with files
-- Работать с файлами

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'files', 'work', 7, 'To work with files', '', '');

-- To add files
-- Добавлять файлы

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'files', 'add', 8, 'To add files', '', '');

-- To delete files
-- Удалять файлы

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'files', 'delete', 9, 'To delete files', '', '');

-- To capture materials
-- Захватывать материалы

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'documents', 'capture', 10, 'To capture materials', '', '');

-- To transfer materials
-- Передавать материалы

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'documents', 'transfer', 11, 'To transfer materials', '', '');

-- To move materials
-- Перемещать материалы

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'documents', 'move', 12, 'To move materials', '', '');

-- To put in a briefcase
-- Размещать в портфель

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('catalog', 'documents', 'briefcase', 13, 'To put in a briefcase', '', '');

-- Editions

-- To work with materials
-- Работать с материалами

INSERT INTO rules(section, subsection, term, sortorder, title, shortcut, description)
VALUES ('editions', 'work', 'documents', 1, 'To work with materials', '', '');

-- To control an exchange
-- Управлять обменом

-- To change configuration
-- Изменять компоновку

-- To breadboard release
-- Макетировать выпуск

-- To assign materials
-- Назначать материалы

-- To send on imposition
-- Отправлять на верстку

-- To view configuration
-- Просматривать компоновку

-- To remove from imposition
-- Снимать с верстки

-- To control a calendar
-- Управлять календарем

-- To view advertizing
-- Просматривать рекламу

-- To control requests
-- Управлять заявками

-- To control breadboard models
-- Управлять макетами

-- To control advertisers
-- Управлять рекламодателями

-- To state requests
-- Утверждать заявки

-- To state breadboard models
-- Утверждать макеты