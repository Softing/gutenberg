-- Uninsall Rss Plugin

DELETE FROM plugins.menu   WHERE plugin='rss';
DELETE FROM plugins.routes WHERE plugin='rss';
DELETE FROM plugins.rules  WHERE plugin='rss';
