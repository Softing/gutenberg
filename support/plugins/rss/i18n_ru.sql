-- Inprint Content 5.0 
-- Copyright(c) 2001-2011, Softing, LLC. 
-- licensing@softing.ru 
-- http://softing.ru/license

-- Package: RSS Plugin, RU Locale
-- Version: 1.0

UPDATE plugins.rules SET rule_sortorder=1000, rule_title = 'Может редактировать RSS' WHERE id = 'b98fb3fd-2593-44c8-bcd8-12da48693ef7';

DELETE FROM plugins.l18n WHERE plugin='rss' AND l18n_language='ru';

INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'RSS feeds', 'RSS ленты');

INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'Access denide', 'Доступ запрещен');

INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'Please, select document', 'Пожалуйста, выберите материал');

INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'Publish', 'Опубликовать');

INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'Unpublish', 'Снять с публикации');

INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'Show', 'Показать');

INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'Show all', 'Показать все');
    
INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'Show with RSS', 'Показать с RSS');

INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'Show without RSS', 'Показать без RSS');

INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'Feeds', 'Ленты');

INSERT INTO plugins.l18n (plugin, l18n_language, l18n_original, l18n_translation)
    VALUES ('rss', 'ru', 'Default feed', 'Лента по умолчанию');

INSERT INTO plugins_rss.rss_feeds(id, url, title, description, published, created, updated)                                                                                                 
    VALUES ('00000000-0000-0000-0000-000000000000', 'default', 'По умолчанию', 'По умолчанию', true, now(), now());