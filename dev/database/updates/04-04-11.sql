ALTER TABLE map_member_to_rule ADD COLUMN termkey character varying;

UPDATE map_member_to_rule set termkey = ( 
SELECT rules.section ||'.'|| rules.subsection ||'.'|| rules.term || ':' || mapper.area 
FROM map_member_to_rule as mapper, rules WHERE mapper.term = rules.id AND mapper.id = map_member_to_rule.id);

ALTER TABLE map_member_to_rule ALTER COLUMN termkey SET NOT NULL;
