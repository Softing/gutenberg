/*
Inprint 5.0 DEMO database
Date: 2011-02-22 21:06:19
*/

BEGIN;

-- ----------------------------
-- Records of fascicles
-- ----------------------------

INSERT INTO fascicles( id, edition, parent, fastype, variation, shortcut, description, circulation, pnum, anum, manager, enabled, archived, flagdoc, flagadv, datedoc, dateadv, dateprint, dateout, created, updated)
    VALUES ('99999999-9999-9999-9999-999999999999', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'system', '00000000-0000-0000-0000-000000000000', 'Корзина', 'Корзина', 0, 0, 0, null, true, false, 'bydate', 'bydate', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', now(), now());

INSERT INTO fascicles( id, edition, parent, fastype, variation, shortcut, description, circulation, pnum, anum, manager, enabled, archived, flagdoc, flagadv, datedoc, dateadv, dateprint, dateout, created, updated)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'system', '00000000-0000-0000-0000-000000000000', 'Портфель', 'Портфель', 0, 0, 0, null, true, false, 'bydate', 'bydate', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', '2020-01-01 00:00:00+00', now(), now());


COMMIT;
