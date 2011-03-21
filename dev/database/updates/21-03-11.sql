-- Function: rules_insert_after_trigger()

-- DROP FUNCTION rules_insert_after_trigger();

CREATE OR REPLACE FUNCTION rules_insert_after_trigger()
  RETURNS trigger AS
$BODY$DECLARE
    arg_path ltree;
    arg_term_name varchar;
BEGIN

    IF NEW.section = 'domain' THEN
        EXECUTE ' DELETE FROM cache_access WHERE type=''domain'' AND member=''' ||NEW.member|| ''' AND path ~ (''00000000000000000000000000000000'')::lquery; ';
        EXECUTE '
            INSERT INTO cache_access("type", path, binding, member, terms)
            VALUES (
                ''domain'', ''00000000000000000000000000000000''::ltree, ''00000000-0000-0000-0000-000000000000'', ''' ||NEW.member|| ''',
                ARRAY(
                    SELECT DISTINCT (((a2.section::text || ''.''::text) || a2.subsection::text) || ''.''::text) || a2.term::text AS term
                    FROM map_member_to_rule a1, view_rules a2
                    WHERE a2.id = a1.term AND a2.section = ''domain'' AND a1.member = ''' ||NEW.member|| '''
                )
           );
        ';
    END IF;

    IF NEW.section = 'editions' OR NEW.section = 'catalog' THEN
        EXECUTE 'SELECT m.path FROM ' || NEW.section || ' AS m WHERE m.id = $1'
            INTO arg_path USING NEW.binding;
        EXECUTE 'SELECT term_text FROM view_rules WHERE id = $1'
            INTO arg_term_name USING NEW.term;
    END IF;

    IF NEW.section = 'editions' THEN
        IF arg_path IS NOT null AND arg_term_name IS NOT NULL THEN
            EXECUTE 'DELETE FROM cache_access WHERE type=''' ||NEW.section|| ''' AND member=''' ||NEW.member|| ''' AND path ~ (''' || arg_path::text || '.*'')::lquery; ';
            EXECUTE 'DELETE FROM cache_visibility WHERE type=''' ||NEW.section|| ''' AND member=''' ||NEW.member|| ''' AND term LIKE ''' ||arg_term_name|| '''; ';
            EXECUTE '
                INSERT INTO cache_access
                    SELECT ''' ||NEW.section|| ''' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(
                        SELECT DISTINCT a2.section::text || ''.''::text || a2.subsection::text || ''.''::text || a2.term::text AS term
                        FROM map_member_to_rule a1, view_rules a2
                        WHERE a2.id = a1.term AND a2.section = ''' ||NEW.section|| ''' AND a1.member = t2.id AND (a1.binding IN ( SELECT id FROM ' ||NEW.section|| ' WHERE path @> t1.path))
                    ) AS terms
                FROM ' ||NEW.section|| ' t1, members t2
                WHERE t2.id=''' ||NEW.member|| ''' AND t1.path ~ (''' || arg_path::text || '.*'')::lquery ORDER BY t1.path;
            ';
            EXECUTE '
                INSERT INTO cache_visibility
                    SELECT ''' ||NEW.section|| ''' AS type, ''' ||NEW.member|| ''' as member, ''' ||arg_term_name|| ''' AS term, ''' ||NEW.term|| ''' as termid,
                    ARRAY(
                        SELECT id FROM ' ||NEW.section|| ' WHERE
                            path @> ARRAY( SELECT path from map_member_to_rule t1, ' ||NEW.section|| ' t2 WHERE t2.id = t1.binding AND t1.member=''' ||NEW.member|| ''' AND t1.term = ''' ||NEW.term|| ''')
                        ) as parents,
                        ARRAY(
                            SELECT id FROM ' ||NEW.section|| ' WHERE
                                path <@ ARRAY( SELECT path from map_member_to_rule t1, ' ||NEW.section|| ' t2 WHERE t2.id = t1.binding AND t1.member=''' ||NEW.member|| ''' AND t1.term = ''' ||NEW.term|| ''')
                        ) as childrens
            ';
        END IF;
    END IF;

    IF NEW.section = 'catalog' THEN
        IF arg_path IS NOT null AND arg_term_name IS NOT NULL THEN
            EXECUTE 'DELETE FROM cache_access WHERE type=''' ||NEW.section|| ''' AND member=''' ||NEW.member|| ''' AND path ~ (''' || arg_path::text || '.*'')::lquery; ';
            EXECUTE 'DELETE FROM cache_visibility WHERE type=''' ||NEW.section|| ''' AND member=''' ||NEW.member|| ''' AND term LIKE ''' ||arg_term_name|| ':' ||NEW.area|| ''' ';
            EXECUTE '
                INSERT INTO cache_access
                    SELECT ''' ||NEW.section|| ''' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(
                        SELECT DISTINCT a2.section::text || ''.''::text || a2.subsection::text || ''.''::text || a2.term::text || '':''::text || a1.area AS term
                        FROM map_member_to_rule a1, view_rules a2
                        WHERE a2.id = a1.term AND a2.section = ''' ||NEW.section|| ''' AND a1.member = ''' ||NEW.member|| ''' AND (a1.binding IN ( SELECT id FROM ' ||NEW.section|| ' WHERE path @> t1.path))
                    ) AS terms
                FROM ' ||NEW.section|| ' t1, members t2
                WHERE t2.id=''' ||NEW.member|| ''' AND t1.path ~ (''' || arg_path::text || '.*'')::lquery ORDER BY t1.path;
            ';
            EXECUTE '
                INSERT INTO cache_visibility
                    SELECT ''' ||NEW.section|| ''' AS type, ''' ||NEW.member|| ''' as member, ''' ||arg_term_name|| '''||'':''||''' ||NEW.area|| ''' AS term, ''' ||NEW.term|| ''' as termid,
                    ARRAY(
                        SELECT id FROM ' ||NEW.section|| ' WHERE
                            path @> ARRAY( SELECT path from map_member_to_rule t1, ' ||NEW.section|| ' t2 WHERE t2.id = t1.binding AND t1.member=''' ||NEW.member|| ''' AND t1.term = ''' ||NEW.term|| ''' AND t1.area = ''' ||NEW.area|| ''' )
                        ) as parents,
                        ARRAY(
                            SELECT id FROM ' ||NEW.section|| ' WHERE
                                path <@ ARRAY( SELECT path from map_member_to_rule t1, ' ||NEW.section|| ' t2 WHERE t2.id = t1.binding AND t1.member=''' ||NEW.member|| ''' AND t1.term = ''' ||NEW.term|| ''' AND t1.area = ''' ||NEW.area|| ''' )
                        ) as childrens
            ';
        END IF;
    END IF;

    RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- Function: rules_delete_after_trigger()

-- DROP FUNCTION rules_delete_after_trigger();

CREATE OR REPLACE FUNCTION rules_delete_after_trigger()
  RETURNS trigger AS
$BODY$DECLARE
    arg_path ltree;
    arg_term_name varchar;
BEGIN

    IF OLD.section = 'editions' OR OLD.section = 'catalog' THEN
        EXECUTE 'SELECT m.path FROM ' || OLD.section || ' AS m WHERE m.id = $1'
            INTO arg_path USING OLD.binding;
        EXECUTE 'SELECT term_text FROM view_rules WHERE id = $1'
            INTO arg_term_name USING OLD.term;
    END IF;

    IF OLD.section = 'editions' THEN
        IF arg_path IS NOT null AND arg_term_name IS NOT NULL THEN
            EXECUTE 'DELETE FROM cache_access WHERE type=''' ||OLD.section|| ''' AND member=''' ||OLD.member|| ''' AND path ~ (''' || arg_path::text || '.*'')::lquery ';
            EXECUTE 'DELETE FROM cache_visibility WHERE type=''' ||OLD.section|| ''' AND member=''' ||OLD.member|| ''' AND term LIKE ''' ||arg_term_name|| ''' ';
        END IF;
    END IF;

    IF OLD.section = 'catalog' THEN
        IF arg_path IS NOT null AND arg_term_name IS NOT NULL THEN
            EXECUTE 'DELETE FROM cache_access WHERE type=''' ||OLD.section|| ''' AND member=''' ||OLD.member|| ''' AND path ~ (''' || arg_path::text || '.*'')::lquery ';
            EXECUTE 'DELETE FROM cache_visibility WHERE type=''' ||OLD.section|| ''' AND member=''' ||OLD.member|| ''' AND term LIKE ''' ||arg_term_name|| ':' ||OLD.area|| ''' ';
        END IF;
    END IF;

    RETURN OLD;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- View: view_rules

-- DROP VIEW view_rules;

CREATE OR REPLACE VIEW view_rules AS
    SELECT rules.id, 'system' AS plugin, rules.term, rules.section, rules.subsection, rules.icon, rules.title, rules.description, rules.sortorder, true AS enabled, (((rules.section::text || '.'::text) || rules.subsection::text) || '.'::text) || rules.term::text AS term_text
    FROM rules
UNION
    SELECT rules.id, rules.plugin, rules.rule_term AS term, rules.rule_section AS section, rules.rule_subsection AS subsection, rules.rule_icon AS icon, rules.rule_title AS title, rules.rule_description AS description, rules.rule_sortorder AS sortorder, rules.rule_enabled AS enabled, (((rules.rule_section::text || '.'::text) || rules.rule_subsection::text) || '.'::text) || rules.rule_term::text AS term_text
    FROM plugins.rules;

COMMENT ON VIEW "public"."view_rules" IS NULL;

-- Index: rss_feeds_id_key

-- DROP INDEX rss_feeds_id_key;

CREATE UNIQUE INDEX rss_feeds_id_key
    ON rss_feeds
    USING btree
    (id);

-- Foreign Key: rss_feeds_mapping_feed_fkey

-- ALTER TABLE rss_feeds_mapping DROP CONSTRAINT rss_feeds_mapping_feed_fkey;

ALTER TABLE rss_feeds_mapping
    ADD CONSTRAINT rss_feeds_mapping_feed_fkey FOREIGN KEY (feed)
        REFERENCES rss_feeds (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE;
