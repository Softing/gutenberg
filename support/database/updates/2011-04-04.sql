ALTER TABLE map_member_to_rule ADD COLUMN termkey character varying;

UPDATE map_member_to_rule set area='domain' where section='domain';
UPDATE map_member_to_rule set area='edition' where section='editions';

UPDATE map_member_to_rule set termkey = ( 
SELECT rules.section ||'.'|| rules.subsection ||'.'|| rules.term || ':' || mapper.area 
FROM map_member_to_rule as mapper, rules WHERE mapper.term = rules.id AND mapper.id = map_member_to_rule.id);

DELETE FROM map_member_to_rule WHERE termkey is null;

--

ALTER TABLE fascicles DROP COLUMN pnum;

ALTER TABLE fascicles ADD COLUMN num integer;
UPDATE fascicles SET num = 0;
ALTER TABLE fascicles ALTER COLUMN num SET NOT NULL;
ALTER TABLE fascicles ALTER COLUMN num SET DEFAULT 0;

--

ALTER TABLE fascicles DROP COLUMN anum;

ALTER TABLE fascicles ADD COLUMN anum integer;
UPDATE fascicles SET anum = 0;
ALTER TABLE fascicles ALTER COLUMN anum SET NOT NULL;
ALTER TABLE fascicles ALTER COLUMN anum SET DEFAULT 0;

--

ALTER TABLE fascicles ADD COLUMN deleted boolean;
ALTER TABLE fascicles ALTER COLUMN deleted SET DEFAULT false;
UPDATE fascicles SET deleted = false;
ALTER TABLE fascicles ALTER COLUMN deleted SET NOT NULL;

--

ALTER TABLE fascicles DROP COLUMN flagadv;

ALTER TABLE fascicles ADD COLUMN adv_enabled boolean;
UPDATE fascicles SET adv_enabled = true;
ALTER TABLE fascicles ALTER COLUMN adv_enabled SET DEFAULT false;

--

ALTER TABLE fascicles DROP COLUMN flagdoc;

ALTER TABLE fascicles ADD COLUMN doc_enabled boolean;
UPDATE fascicles SET doc_enabled = true;
ALTER TABLE fascicles ALTER COLUMN doc_enabled SET DEFAULT false;
ALTER TABLE fascicles ALTER COLUMN doc_enabled SET NOT NULL;
--

ALTER TABLE fascicles RENAME COLUMN datedoc   TO doc_date;
ALTER TABLE fascicles RENAME COLUMN dateadv   TO adv_date;
ALTER TABLE fascicles RENAME COLUMN dateprint TO print_date;
ALTER TABLE fascicles RENAME COLUMN dateout   TO release_date;

--


ALTER TABLE fascicles ADD COLUMN "tmpl" uuid;
ALTER TABLE fascicles ADD COLUMN tmpl_shortcut character varying;
ALTER TABLE fascicles ALTER COLUMN tmpl_shortcut SET DEFAULT ''::character varying;
