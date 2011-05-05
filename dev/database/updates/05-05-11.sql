DROP VIEW cache_rules;
DROP VIEW view_members;
DROP VIEW view_rules;
DROP VIEW view_rules_old;

CREATE VIEW "public"."view_rules" AS 
		SELECT rules.id, 'system' AS plugin, rules.term, rules.section, rules.subsection, 
			rules.section || '.' || rules.subsection || '.' || rules.term AS termkey, 
			rules.icon, rules.title, rules.description, rules.sortorder, true AS enabled 
		FROM rules 	
	UNION 
		SELECT rules.id, rules.plugin, rules.rule_term AS term, rules.rule_section AS section, rules.rule_subsection AS subsection, 
			rules.rule_section || '.' || rules.rule_subsection || '.' || rules.rule_term AS termkey, 
			rules.rule_icon AS icon, rules.rule_title AS title, rules.rule_description AS description, rules.rule_sortorder AS sortorder, rules.rule_enabled AS enabled 
		FROM plugins.rules;

