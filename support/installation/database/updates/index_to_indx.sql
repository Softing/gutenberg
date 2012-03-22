delete from indx_rubrics;
delete from indx_headlines;
delete from fascicles_indx_rubrics;
delete from fascicles_indx_headlines;

INSERT INTO indx_headlines(id, edition, title, shortcut, description, created, updated)
    VALUES ( '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '--', '--', '--', now(), now());

INSERT INTO indx_headlines(id, edition, title, shortcut, description, created, updated)
    SELECT id, edition, title, shortcut, description, created, updated FROM index WHERE nature = 'headline';

INSERT INTO indx_rubrics(id, edition, headline, title, shortcut, description, created, updated)
    SELECT id, edition, parent, title, shortcut, description, created, updated FROM index t1 WHERE nature = 'rubric'
    AND t1.parent IN ( SELECT t2.id FROM index t2 WHERE t2.id=t1.parent );

UPDATE indx_headlines SET bydefault = true WHERE shortcut = '--';
UPDATE indx_rubrics SET bydefault = true WHERE shortcut = '--';


