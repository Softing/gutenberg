--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plugins; Type: SCHEMA; Schema: -; Owner: inprint
--

CREATE SCHEMA plugins;


ALTER SCHEMA plugins OWNER TO inprint;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: inprint
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO inprint;

SET search_path = public, pg_catalog;

--
-- Name: lquery; Type: SHELL TYPE; Schema: public; Owner: inprint
--

CREATE TYPE lquery;


--
-- Name: lquery_in(cstring); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lquery_in(cstring) RETURNS lquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_in';


ALTER FUNCTION public.lquery_in(cstring) OWNER TO inprint;

--
-- Name: lquery_out(lquery); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lquery_out(lquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_out';


ALTER FUNCTION public.lquery_out(lquery) OWNER TO inprint;

--
-- Name: lquery; Type: TYPE; Schema: public; Owner: inprint
--

CREATE TYPE lquery (
    INTERNALLENGTH = variable,
    INPUT = lquery_in,
    OUTPUT = lquery_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE public.lquery OWNER TO inprint;

--
-- Name: ltree; Type: SHELL TYPE; Schema: public; Owner: inprint
--

CREATE TYPE ltree;


--
-- Name: ltree_in(cstring); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_in(cstring) RETURNS ltree
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_in';


ALTER FUNCTION public.ltree_in(cstring) OWNER TO inprint;

--
-- Name: ltree_out(ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_out(ltree) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_out';


ALTER FUNCTION public.ltree_out(ltree) OWNER TO inprint;

--
-- Name: ltree; Type: TYPE; Schema: public; Owner: inprint
--

CREATE TYPE ltree (
    INTERNALLENGTH = variable,
    INPUT = ltree_in,
    OUTPUT = ltree_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE public.ltree OWNER TO inprint;

--
-- Name: ltree_gist; Type: SHELL TYPE; Schema: public; Owner: inprint
--

CREATE TYPE ltree_gist;


--
-- Name: ltree_gist_in(cstring); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_gist_in(cstring) RETURNS ltree_gist
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_in';


ALTER FUNCTION public.ltree_gist_in(cstring) OWNER TO inprint;

--
-- Name: ltree_gist_out(ltree_gist); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_gist_out(ltree_gist) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_out';


ALTER FUNCTION public.ltree_gist_out(ltree_gist) OWNER TO inprint;

--
-- Name: ltree_gist; Type: TYPE; Schema: public; Owner: inprint
--

CREATE TYPE ltree_gist (
    INTERNALLENGTH = variable,
    INPUT = ltree_gist_in,
    OUTPUT = ltree_gist_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.ltree_gist OWNER TO inprint;

--
-- Name: ltxtquery; Type: SHELL TYPE; Schema: public; Owner: inprint
--

CREATE TYPE ltxtquery;


--
-- Name: ltxtq_in(cstring); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltxtq_in(cstring) RETURNS ltxtquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_in';


ALTER FUNCTION public.ltxtq_in(cstring) OWNER TO inprint;

--
-- Name: ltxtq_out(ltxtquery); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltxtq_out(ltxtquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_out';


ALTER FUNCTION public.ltxtq_out(ltxtquery) OWNER TO inprint;

--
-- Name: ltxtquery; Type: TYPE; Schema: public; Owner: inprint
--

CREATE TYPE ltxtquery (
    INTERNALLENGTH = variable,
    INPUT = ltxtq_in,
    OUTPUT = ltxtq_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


ALTER TYPE public.ltxtquery OWNER TO inprint;

--
-- Name: _lt_q_regex(ltree[], lquery[]); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _lt_q_regex(ltree[], lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_regex';


ALTER FUNCTION public._lt_q_regex(ltree[], lquery[]) OWNER TO inprint;

--
-- Name: _lt_q_rregex(lquery[], ltree[]); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _lt_q_rregex(lquery[], ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_rregex';


ALTER FUNCTION public._lt_q_rregex(lquery[], ltree[]) OWNER TO inprint;

--
-- Name: _ltq_extract_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltq_extract_regex(ltree[], lquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_extract_regex';


ALTER FUNCTION public._ltq_extract_regex(ltree[], lquery) OWNER TO inprint;

--
-- Name: _ltq_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltq_regex(ltree[], lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_regex';


ALTER FUNCTION public._ltq_regex(ltree[], lquery) OWNER TO inprint;

--
-- Name: _ltq_rregex(lquery, ltree[]); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltq_rregex(lquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_rregex';


ALTER FUNCTION public._ltq_rregex(lquery, ltree[]) OWNER TO inprint;

--
-- Name: _ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_compress';


ALTER FUNCTION public._ltree_compress(internal) OWNER TO inprint;

--
-- Name: _ltree_consistent(internal, internal, smallint, oid, internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_consistent(internal, internal, smallint, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_consistent';


ALTER FUNCTION public._ltree_consistent(internal, internal, smallint, oid, internal) OWNER TO inprint;

--
-- Name: _ltree_extract_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_extract_isparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_isparent';


ALTER FUNCTION public._ltree_extract_isparent(ltree[], ltree) OWNER TO inprint;

--
-- Name: _ltree_extract_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_extract_risparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_risparent';


ALTER FUNCTION public._ltree_extract_risparent(ltree[], ltree) OWNER TO inprint;

--
-- Name: _ltree_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_isparent(ltree[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_isparent';


ALTER FUNCTION public._ltree_isparent(ltree[], ltree) OWNER TO inprint;

--
-- Name: _ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_penalty';


ALTER FUNCTION public._ltree_penalty(internal, internal, internal) OWNER TO inprint;

--
-- Name: _ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_picksplit';


ALTER FUNCTION public._ltree_picksplit(internal, internal) OWNER TO inprint;

--
-- Name: _ltree_r_isparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_r_isparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_isparent';


ALTER FUNCTION public._ltree_r_isparent(ltree, ltree[]) OWNER TO inprint;

--
-- Name: _ltree_r_risparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_r_risparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_risparent';


ALTER FUNCTION public._ltree_r_risparent(ltree, ltree[]) OWNER TO inprint;

--
-- Name: _ltree_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_risparent(ltree[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_risparent';


ALTER FUNCTION public._ltree_risparent(ltree[], ltree) OWNER TO inprint;

--
-- Name: _ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_same';


ALTER FUNCTION public._ltree_same(internal, internal, internal) OWNER TO inprint;

--
-- Name: _ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltree_union(internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_union';


ALTER FUNCTION public._ltree_union(internal, internal) OWNER TO inprint;

--
-- Name: _ltxtq_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltxtq_exec(ltree[], ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_exec';


ALTER FUNCTION public._ltxtq_exec(ltree[], ltxtquery) OWNER TO inprint;

--
-- Name: _ltxtq_extract_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltxtq_extract_exec(ltree[], ltxtquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_extract_exec';


ALTER FUNCTION public._ltxtq_extract_exec(ltree[], ltxtquery) OWNER TO inprint;

--
-- Name: _ltxtq_rexec(ltxtquery, ltree[]); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION _ltxtq_rexec(ltxtquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_rexec';


ALTER FUNCTION public._ltxtq_rexec(ltxtquery, ltree[]) OWNER TO inprint;

--
-- Name: access_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION access_delete_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    arg_type varchar; 
BEGIN
    arg_type := TG_ARGV[0];

    EXECUTE ' DELETE FROM cache_access WHERE type=''' ||arg_type|| ''' AND  path ~ (''' || OLD.path::text || '.*'')::lquery; ';

    EXECUTE ' DELETE FROM cache_access WHERE array_dims(terms) is null ';

    RETURN OLD;
END;
$$;


ALTER FUNCTION public.access_delete_after_trigger() OWNER TO inprint;

--
-- Name: access_insert_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION access_insert_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    arg_type varchar; 
BEGIN

    arg_type := TG_ARGV[0];

    --RAISE EXCEPTION '%', arg_type;

    EXECUTE ' DELETE FROM cache_access WHERE type=''' ||arg_type|| ''' AND binding=''' ||NEW.id|| '''; ';
    
    IF arg_type = 'editions' THEN 
        EXECUTE '
            INSERT INTO cache_access
                SELECT ''editions'' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY( 
                    SELECT DISTINCT (((a2.section::text || ''.''::text) || a2.subsection::text) || ''.''::text) || a2.term::text AS term
                    FROM map_member_to_rule a1, rules a2
                    WHERE a2.id = a1.term AND a2.section = ''' ||arg_type|| ''' AND a1.member = t2.id AND (a1.binding IN ( SELECT id FROM editions WHERE path @> t1.path))
                ) AS terms
                FROM editions t1, members t2
                WHERE t1.id = ''' ||NEW.id|| ''' ORDER BY t1.path;';
    END IF;

    IF arg_type = 'catalog' THEN 
        EXECUTE '
            INSERT INTO cache_access
                SELECT ''catalog'' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY( 
                    SELECT DISTINCT a2.section::text || ''.''::text || a2.subsection::text || ''.''::text || a2.term::text || '':''::text || a1.area AS term
                    FROM map_member_to_rule a1, rules a2
                    WHERE a2.id = a1.term AND a2.section = ''catalog'' AND a1.member = t2.id AND (a1.binding IN ( SELECT id FROM catalog WHERE path @> t1.path))
                ) AS terms
                FROM catalog t1, members t2
                WHERE t1.id = ''' ||NEW.id|| ''' ORDER BY t1.path;';
    END IF;

    EXECUTE ' DELETE FROM cache_access WHERE array_dims(terms) is null ';
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.access_insert_after_trigger() OWNER TO inprint;

--
-- Name: access_update_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION access_update_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    arg_type varchar;
		arecords RECORD;
BEGIN
	
	arg_type := TG_ARGV[0];

	EXECUTE ' DELETE FROM cache_access WHERE type=''' ||arg_type|| ''' AND binding=''' ||NEW.id|| '''; ';

	-- CREATE RULES FOR NEW POSITION

    IF arg_type = 'editions' THEN 
			
			FOR arecords IN 
				SELECT 
					'editions' AS type, 
					t1.path, 
					t1.id AS binding, 
					t2.id AS member, 
					ARRAY( 
							SELECT DISTINCT (((a2.section::text || '.'::text) || a2.subsection::text) || '.'::text) || a2.term::text AS term
              FROM map_member_to_rule a1, rules a2
              WHERE a2.id = a1.term AND a2.section = 'editions' AND a1.member = t2.id AND (a1.binding IN ( SELECT id FROM editions WHERE path @> t1.path))
					) AS terms
					FROM editions t1, members t2
					WHERE t1.path ~ (NEW.path::text || '.*')::lquery ORDER BY t1.path
			LOOP
						DELETE FROM cache_access WHERE type='editions' AND path=arecords.path AND binding=arecords.binding AND member=arecords.member;
						INSERT INTO cache_access (type, path, binding, member, terms) VALUES ('editions', arecords.path, arecords.binding, arecords.member, arecords.terms);
			END LOOP;

    END IF;

    IF arg_type = 'catalog' THEN 

			FOR arecords IN 
				SELECT 
					'catalog' AS type, 
					t1.path, 
					t1.id AS binding, 
					t2.id AS member, 
					ARRAY( 
							SELECT DISTINCT a2.section::text || '.'::text || a2.subsection::text || '.'::text || a2.term::text || ':'::text || a1.area AS term
							FROM map_member_to_rule a1, rules a2
							WHERE a2.id = a1.term AND a2.section = 'catalog' AND a1.member = t2.id AND (a1.binding IN ( SELECT id FROM catalog WHERE path @> t1.path))
					) AS terms
				FROM catalog t1, members t2 
				WHERE t1.path ~ ( NEW.path::text || '.*')::lquery ORDER BY t1.path 
			LOOP
						DELETE FROM cache_access WHERE type='catalog' AND path=arecords.path AND binding=arecords.binding AND member=arecords.member;
						INSERT INTO cache_access (type, path, binding, member, terms) VALUES ('catalog', arecords.path, arecords.binding, arecords.member, arecords.terms);
			END LOOP;

    END IF;

    EXECUTE ' DELETE FROM cache_access WHERE array_dims(terms) is null ';

    EXECUTE '
        UPDATE cache_visibility t1 
            SET parents = ARRAY(
                    SELECT t2.id FROM ' ||arg_type|| ' t2 WHERE (
                        ARRAY(
                            SELECT t3.id FROM ' ||arg_type|| ' t3 WHERE 
                                t3.path ~ ((t2.path::text || ''.*''::text)::lquery)) 
                                && 
                                ARRAY(select t4.binding from map_member_to_rule t4 WHERE member=t1.member AND term=t1.termid )
                    )
                ) 
            WHERE ''' ||NEW.id|| ''' = ANY(t1.parents)
    ';
    
    return NEW;
END;
$$;


ALTER FUNCTION public.access_update_after_trigger() OWNER TO inprint;

--
-- Name: digest(text, text); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION digest(text, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_digest';


ALTER FUNCTION public.digest(text, text) OWNER TO inprint;

--
-- Name: fascicles_map_documents_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION fascicles_map_documents_delete_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    arg_seqnums integer[]; 
BEGIN

    EXECUTE 'SELECT ARRAY(
                SELECT t2.seqnum
                FROM fascicles_map_documents t1, fascicles_pages t2 
                WHERE t2.id = t1.page AND t1.fascicle = $1 AND t1.entity = $2
                ORDER BY t2.seqnum
            );'
        INTO arg_seqnums USING OLD.fascicle, OLD.entity;

    --RAISE EXCEPTION '%', arg_seqnums;

    EXECUTE 'UPDATE documents SET pages=array_to_string($1, '','') WHERE id=$2'
        USING arg_seqnums, OLD.entity;

    EXECUTE 'UPDATE documents SET firstpage=$1 WHERE id=$2'
        USING arg_seqnums[1], OLD.entity;
    
    return OLD;
END;
$_$;


ALTER FUNCTION public.fascicles_map_documents_delete_after_trigger() OWNER TO inprint;

--
-- Name: fascicles_map_documents_update_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION fascicles_map_documents_update_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    arg_seqnums integer[]; 
BEGIN

    EXECUTE 'SELECT ARRAY(
                SELECT t2.seqnum
                FROM fascicles_map_documents t1, fascicles_pages t2 
                WHERE t2.id = t1.page AND t1.fascicle = $1 AND t1.entity = $2
                ORDER BY t2.seqnum
            );'
        INTO arg_seqnums USING NEW.fascicle, NEW.entity;

    --RAISE EXCEPTION '%', arg_seqnums;

    EXECUTE 'UPDATE documents SET pages=array_to_string($1, '','') WHERE id=$2'
        USING arg_seqnums, NEW.entity;

    EXECUTE 'UPDATE documents SET firstpage=$1 WHERE id=$2'
        USING arg_seqnums[1], NEW.entity;
    
    return NEW;
END;
$_$;


ALTER FUNCTION public.fascicles_map_documents_update_after_trigger() OWNER TO inprint;

--
-- Name: fascicles_map_modules_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION fascicles_map_modules_delete_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    arg_seqnums integer[]; 
BEGIN

    EXECUTE 'SELECT ARRAY(
                SELECT t2.seqnum
                FROM fascicles_map_modules t1, fascicles_pages t2 
                WHERE t2.id = t1.page AND t1.fascicle = $1 AND t1.module = $2
                ORDER BY t2.seqnum
            );'
        INTO arg_seqnums USING OLD.fascicle, OLD.module;

    EXECUTE 'UPDATE fascicles_requests SET pages=array_to_string($1, '','') WHERE module=$2'
        USING arg_seqnums, OLD.module;

    EXECUTE 'UPDATE fascicles_requests SET firstpage=$1 WHERE module=$2'
        USING arg_seqnums[1], OLD.module;
    
    return OLD;
END;
$_$;


ALTER FUNCTION public.fascicles_map_modules_delete_after_trigger() OWNER TO inprint;

--
-- Name: fascicles_map_modules_update_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION fascicles_map_modules_update_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    arg_seqnums integer[]; 
BEGIN

    EXECUTE 'SELECT ARRAY(
                SELECT t2.seqnum
                FROM fascicles_map_modules t1, fascicles_pages t2 
                WHERE t2.id = t1.page AND t1.fascicle = $1 AND t1.module = $2
                ORDER BY t2.seqnum
            );'
        INTO arg_seqnums USING NEW.fascicle, NEW.module;
        
    EXECUTE 'UPDATE fascicles_requests SET pages=array_to_string($1, '','') WHERE module=$2'
        USING arg_seqnums, NEW.module;

    EXECUTE 'UPDATE fascicles_requests SET firstpage=$1 WHERE module=$2'
        USING arg_seqnums[1], NEW.module;
    
    return NEW;
END;
$_$;


ALTER FUNCTION public.fascicles_map_modules_update_after_trigger() OWNER TO inprint;

--
-- Name: index(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION index(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


ALTER FUNCTION public.index(ltree, ltree) OWNER TO inprint;

--
-- Name: index(ltree, ltree, integer); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION index(ltree, ltree, integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


ALTER FUNCTION public.index(ltree, ltree, integer) OWNER TO inprint;

--
-- Name: lca(ltree[]); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lca(ltree[]) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lca';


ALTER FUNCTION public.lca(ltree[]) OWNER TO inprint;

--
-- Name: lca(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lca(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


ALTER FUNCTION public.lca(ltree, ltree) OWNER TO inprint;

--
-- Name: lca(ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lca(ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


ALTER FUNCTION public.lca(ltree, ltree, ltree) OWNER TO inprint;

--
-- Name: lca(ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


ALTER FUNCTION public.lca(ltree, ltree, ltree, ltree) OWNER TO inprint;

--
-- Name: lca(ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


ALTER FUNCTION public.lca(ltree, ltree, ltree, ltree, ltree) OWNER TO inprint;

--
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


ALTER FUNCTION public.lca(ltree, ltree, ltree, ltree, ltree, ltree) OWNER TO inprint;

--
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


ALTER FUNCTION public.lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree) OWNER TO inprint;

--
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


ALTER FUNCTION public.lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree) OWNER TO inprint;

--
-- Name: lt_q_regex(ltree, lquery[]); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lt_q_regex(ltree, lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_regex';


ALTER FUNCTION public.lt_q_regex(ltree, lquery[]) OWNER TO inprint;

--
-- Name: lt_q_rregex(lquery[], ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION lt_q_rregex(lquery[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_rregex';


ALTER FUNCTION public.lt_q_rregex(lquery[], ltree) OWNER TO inprint;

--
-- Name: ltq_regex(ltree, lquery); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltq_regex(ltree, lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_regex';


ALTER FUNCTION public.ltq_regex(ltree, lquery) OWNER TO inprint;

--
-- Name: ltq_rregex(lquery, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltq_rregex(lquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_rregex';


ALTER FUNCTION public.ltq_rregex(lquery, ltree) OWNER TO inprint;

--
-- Name: ltree2text(ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree2text(ltree) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree2text';


ALTER FUNCTION public.ltree2text(ltree) OWNER TO inprint;

--
-- Name: ltree_addltree(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_addltree(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addltree';


ALTER FUNCTION public.ltree_addltree(ltree, ltree) OWNER TO inprint;

--
-- Name: ltree_addtext(ltree, text); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_addtext(ltree, text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addtext';


ALTER FUNCTION public.ltree_addtext(ltree, text) OWNER TO inprint;

--
-- Name: ltree_cmp(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_cmp(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_cmp';


ALTER FUNCTION public.ltree_cmp(ltree, ltree) OWNER TO inprint;

--
-- Name: ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_compress';


ALTER FUNCTION public.ltree_compress(internal) OWNER TO inprint;

--
-- Name: ltree_consistent(internal, internal, smallint, oid, internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_consistent(internal, internal, smallint, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_consistent';


ALTER FUNCTION public.ltree_consistent(internal, internal, smallint, oid, internal) OWNER TO inprint;

--
-- Name: ltree_decompress(internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_decompress';


ALTER FUNCTION public.ltree_decompress(internal) OWNER TO inprint;

--
-- Name: ltree_eq(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_eq(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_eq';


ALTER FUNCTION public.ltree_eq(ltree, ltree) OWNER TO inprint;

--
-- Name: ltree_ge(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_ge(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ge';


ALTER FUNCTION public.ltree_ge(ltree, ltree) OWNER TO inprint;

--
-- Name: ltree_gt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_gt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_gt';


ALTER FUNCTION public.ltree_gt(ltree, ltree) OWNER TO inprint;

--
-- Name: ltree_isparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_isparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_isparent';


ALTER FUNCTION public.ltree_isparent(ltree, ltree) OWNER TO inprint;

--
-- Name: ltree_le(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_le(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_le';


ALTER FUNCTION public.ltree_le(ltree, ltree) OWNER TO inprint;

--
-- Name: ltree_lt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_lt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_lt';


ALTER FUNCTION public.ltree_lt(ltree, ltree) OWNER TO inprint;

--
-- Name: ltree_ne(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_ne(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ne';


ALTER FUNCTION public.ltree_ne(ltree, ltree) OWNER TO inprint;

--
-- Name: ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_penalty';


ALTER FUNCTION public.ltree_penalty(internal, internal, internal) OWNER TO inprint;

--
-- Name: ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_picksplit';


ALTER FUNCTION public.ltree_picksplit(internal, internal) OWNER TO inprint;

--
-- Name: ltree_risparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_risparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_risparent';


ALTER FUNCTION public.ltree_risparent(ltree, ltree) OWNER TO inprint;

--
-- Name: ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_same';


ALTER FUNCTION public.ltree_same(internal, internal, internal) OWNER TO inprint;

--
-- Name: ltree_textadd(text, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_textadd(text, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_textadd';


ALTER FUNCTION public.ltree_textadd(text, ltree) OWNER TO inprint;

--
-- Name: ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltree_union(internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_union';


ALTER FUNCTION public.ltree_union(internal, internal) OWNER TO inprint;

--
-- Name: ltreeparentsel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltreeparentsel(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltreeparentsel';


ALTER FUNCTION public.ltreeparentsel(internal, oid, internal, integer) OWNER TO inprint;

--
-- Name: ltxtq_exec(ltree, ltxtquery); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltxtq_exec(ltree, ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_exec';


ALTER FUNCTION public.ltxtq_exec(ltree, ltxtquery) OWNER TO inprint;

--
-- Name: ltxtq_rexec(ltxtquery, ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION ltxtq_rexec(ltxtquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_rexec';


ALTER FUNCTION public.ltxtq_rexec(ltxtquery, ltree) OWNER TO inprint;

--
-- Name: nlevel(ltree); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION nlevel(ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'nlevel';


ALTER FUNCTION public.nlevel(ltree) OWNER TO inprint;

--
-- Name: rules_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION rules_delete_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    arg_path ltree;
    arg_term_name varchar;
BEGIN

    IF OLD.section = 'editions' OR OLD.section = 'catalog' THEN
        EXECUTE 'SELECT m.path FROM ' || OLD.section || ' AS m WHERE m.id = $1'
            INTO arg_path USING OLD.binding;
        EXECUTE 'SELECT section||''.''||subsection||''.''||term FROM rules WHERE id = $1'
            INTO arg_term_name USING OLD.term;
    END IF;

    

    IF OLD.section = 'editions' THEN    
    
        EXECUTE 'DELETE FROM cache_access WHERE type=''' ||OLD.section|| ''' AND member=''' ||OLD.member|| ''' AND path ~ (''' || arg_path::text || '.*'')::lquery ';
        EXECUTE 'DELETE FROM cache_visibility WHERE type=''' ||OLD.section|| ''' AND member=''' ||OLD.member|| ''' AND term LIKE ''' ||arg_term_name|| ''' ';
        
        EXECUTE '
            INSERT INTO cache_access
                SELECT ''' ||OLD.section|| ''' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY( 
                    SELECT DISTINCT a2.section::text || ''.''::text || a2.subsection::text || ''.''::text || a2.term::text AS term
                    FROM map_member_to_rule a1, rules a2
                    WHERE a2.id = a1.term AND a2.section = ''' ||OLD.section|| ''' AND a1.member = t2.id AND (a1.binding IN ( SELECT id FROM ' ||OLD.section|| ' WHERE path @> t1.path))
                ) AS terms
                FROM ' ||OLD.section|| ' t1, members t2
                WHERE t2.id=''' ||OLD.member|| ''' AND t1.path ~ (''' || arg_path::text || '.*'')::lquery ORDER BY t1.path;
        ';
        
        EXECUTE '
            INSERT INTO cache_visibility
                SELECT ''' ||OLD.section|| ''' AS type, ''' ||OLD.member|| ''' as member, ''' ||arg_term_name|| ''' AS term, ''' ||OLD.term|| ''' as termid,
                ARRAY( 
                    SELECT id FROM ' ||OLD.section|| ' WHERE 
                        path @> ARRAY( SELECT path from map_member_to_rule t1, ' ||OLD.section|| ' t2 WHERE t2.id = t1.binding AND t1.member=''' ||OLD.member|| ''' AND t1.term = ''' ||OLD.term|| ''')
                ) as parents,
                ARRAY( 
                    SELECT id FROM ' ||OLD.section|| ' WHERE 
                        path <@ ARRAY( SELECT path from map_member_to_rule t1, ' ||OLD.section|| ' t2 WHERE t2.id = t1.binding AND t1.member=''' ||OLD.member|| ''' AND t1.term = ''' ||OLD.term|| ''')
                ) as childrens
        ';
        
    END IF;

    IF OLD.section = 'catalog' THEN
        
        EXECUTE 'DELETE FROM cache_access WHERE type=''' ||OLD.section|| ''' AND member=''' ||OLD.member|| ''' AND path ~ (''' || arg_path::text || '.*'')::lquery ';
        EXECUTE 'DELETE FROM cache_visibility WHERE type=''' ||OLD.section|| ''' AND member=''' ||OLD.member|| ''' AND term LIKE ''' ||arg_term_name|| ':' ||OLD.area|| ''' ';
        
        /*
        EXECUTE '
            INSERT INTO cache_access
                SELECT ''' ||OLD.section|| ''' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY( 
                    SELECT DISTINCT a2.section::text || ''.''::text || a2.subsection::text || ''.''::text || a2.term::text || '':''::text || a1.area AS term
                    FROM map_member_to_rule a1, rules a2
                    WHERE a2.id = a1.term AND a2.section = ''' ||OLD.section|| ''' AND a1.member = ''' ||OLD.member|| ''' AND (a1.binding IN ( SELECT id FROM ' ||OLD.section|| ' WHERE path @> t1.path))
                ) AS terms
                FROM ' ||OLD.section|| ' t1, members t2
                WHERE t2.id=''' ||OLD.member|| ''' AND t1.path ~ (''' || arg_path::text || '.*'')::lquery ORDER BY t1.path;
        ';
        
        EXECUTE '
            INSERT INTO cache_visibility
                SELECT ''' ||OLD.section|| ''' AS type, ''' ||OLD.member|| ''' as member, ''' ||arg_term_name|| '''||'':''||''' ||OLD.area|| ''' AS term, ''' ||OLD.term|| ''' as termid,
                ARRAY( 
                    SELECT id FROM ' ||OLD.section|| ' WHERE 
                        path @> ARRAY( 
                            SELECT path from map_member_to_rule t1, ' ||OLD.section|| ' t2 
                            WHERE t2.id = t1.binding AND t1.member=''' ||OLD.member|| ''' AND t1.term = ''' ||OLD.term|| ''' AND t1.area = ''' ||OLD.area|| '''
                        )
                ) as parents,
                ARRAY( 
                    SELECT id FROM ' ||OLD.section|| ' WHERE 
                        path <@ ARRAY( 
                            SELECT path from map_member_to_rule t1, ' ||OLD.section|| ' t2 
                            WHERE t2.id = t1.binding AND t1.member=''' ||OLD.member|| ''' AND t1.term = ''' ||OLD.term|| ''' AND t1.area = ''' ||OLD.area|| '''
                        )
                ) as childrens
        ';
        */
    END IF;

    RETURN OLD;    
END;
$_$;


ALTER FUNCTION public.rules_delete_after_trigger() OWNER TO inprint;

--
-- Name: rules_insert_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION rules_insert_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
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
                    FROM map_member_to_rule a1, rules a2
                    WHERE a2.id = a1.term AND a2.section = ''domain'' AND a1.member = ''' ||NEW.member|| '''
                )
           );
        ';
    
    END IF;

    IF NEW.section = 'editions' OR NEW.section = 'catalog' THEN

        EXECUTE 'SELECT m.path FROM ' || NEW.section || ' AS m WHERE m.id = $1'
            INTO arg_path USING NEW.binding;
        EXECUTE 'SELECT section||''.''||subsection||''.''||term FROM rules WHERE id = $1'
            INTO arg_term_name USING NEW.term;
    END IF;

    IF NEW.section = 'editions' THEN

        EXECUTE 'DELETE FROM cache_access WHERE type=''' ||NEW.section|| ''' AND member=''' ||NEW.member|| ''' AND path ~ (''' || arg_path::text || '.*'')::lquery; ';
        EXECUTE 'DELETE FROM cache_visibility WHERE type=''' ||NEW.section|| ''' AND member=''' ||NEW.member|| ''' AND term LIKE ''' ||arg_term_name|| '''; ';
    
        EXECUTE '
            INSERT INTO cache_access
                SELECT ''' ||NEW.section|| ''' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY( 
                    SELECT DISTINCT a2.section::text || ''.''::text || a2.subsection::text || ''.''::text || a2.term::text AS term
                    FROM map_member_to_rule a1, rules a2
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

    IF NEW.section = 'catalog' THEN

        EXECUTE 'DELETE FROM cache_access WHERE type=''' ||NEW.section|| ''' AND member=''' ||NEW.member|| ''' AND path ~ (''' || arg_path::text || '.*'')::lquery; ';
        EXECUTE 'DELETE FROM cache_visibility WHERE type=''' ||NEW.section|| ''' AND member=''' ||NEW.member|| ''' AND term LIKE ''' ||arg_term_name|| ':' ||NEW.area|| ''' ';
    
        EXECUTE '
            INSERT INTO cache_access
                SELECT ''' ||NEW.section|| ''' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY( 
                    SELECT DISTINCT a2.section::text || ''.''::text || a2.subsection::text || ''.''::text || a2.term::text || '':''::text || a1.area AS term
                    FROM map_member_to_rule a1, rules a2
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
                        path @> ARRAY( 
                            SELECT path from map_member_to_rule t1, ' ||NEW.section|| ' t2 
                            WHERE t2.id = t1.binding AND t1.member=''' ||NEW.member|| ''' AND t1.term = ''' ||NEW.term|| ''' AND t1.area = ''' ||NEW.area|| '''
                        )
                ) as parents,
                ARRAY( 
                    SELECT id FROM ' ||NEW.section|| ' WHERE 
                        path <@ ARRAY( 
                            SELECT path from map_member_to_rule t1, ' ||NEW.section|| ' t2 
                            WHERE t2.id = t1.binding AND t1.member=''' ||NEW.member|| ''' AND t1.term = ''' ||NEW.term|| ''' AND t1.area = ''' ||NEW.area|| '''
                        )
                ) as childrens
        ';
        
    END IF;
    
    RETURN NEW;
    
END;
$_$;


ALTER FUNCTION public.rules_insert_after_trigger() OWNER TO inprint;

--
-- Name: subltree(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION subltree(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subltree';


ALTER FUNCTION public.subltree(ltree, integer, integer) OWNER TO inprint;

--
-- Name: subpath(ltree, integer); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION subpath(ltree, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


ALTER FUNCTION public.subpath(ltree, integer) OWNER TO inprint;

--
-- Name: subpath(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION subpath(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


ALTER FUNCTION public.subpath(ltree, integer, integer) OWNER TO inprint;

--
-- Name: text2ltree(text); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION text2ltree(text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'text2ltree';


ALTER FUNCTION public.text2ltree(text) OWNER TO inprint;

--
-- Name: tree_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION tree_delete_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    EXECUTE ' DELETE FROM ' || TG_TABLE_NAME || ' WHERE path ~ (''' || OLD.path::text || '.*{1}'')::lquery; ';
    RETURN OLD; 
END;
$$;


ALTER FUNCTION public.tree_delete_after_trigger() OWNER TO inprint;

--
-- Name: tree_insert_before_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION tree_insert_before_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
	new_id		ltree;
	new_path	ltree;
BEGIN

	new_id := replace(NEW.id::text, '-',  '');
        
	IF NEW.path IS NOT NULL THEN
	-- передан, какой-то материализованный путь
	-- обрезаем в материализованном пути id вставляемого узла, если он есть
		new_path := CASE WHEN new_id::text = subpath(NEW.path, -1, 1)::text
		THEN subpath(NEW.path, 0, -1)
		ELSE NEW.path
	END;
	
	-- проверяем существование родителя
        EXECUTE 'SELECT mp.path FROM ' || TG_TABLE_NAME || ' AS mp WHERE mp.path = $1 OR replace(mp.id::text, ''-'',  '''') = $2'
	INTO new_path USING new_path, new_path::text;
	
	-- родителя не нашли
        IF new_path IS NULL OR new_path = '' THEN
            NEW.path := new_id;
	
	-- родителя нашли
        ELSE
            NEW.path := new_path || new_id;
        END IF;
    ELSE
        NEW.path := new_id;
    END IF;
    RETURN NEW;
END;
$_$;


ALTER FUNCTION public.tree_insert_before_trigger() OWNER TO inprint;

--
-- Name: tree_update_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION tree_update_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
	tid     ltree;  
	new_id	ltree;
BEGIN

	new_id := replace(NEW.id::text, '-',  '');

	-- Принудительно запрещаем изменять ID
	NEW.id := OLD.id;

	-- Приводим NULL значение материализованного пути к ID
	NEW.path := CASE WHEN NEW.path IS NULL 
		THEN new_id::text
		ELSE NEW.path::text 
	END;

	-- Есть ли у нас изменения материализованного пути
	IF NEW.path <> OLD.path THEN

		-- Проверяем что новое значение материализованного пути
		-- лежит не пределах подчинения и что на его конце ID
		IF NEW.path ~ ('*.' || new_id::text || '.*{1,}')::lquery 
		   OR NEW.path ~ ('*.!' || new_id::text)::lquery
		THEN
			RAISE EXCEPTION 'Bad path! id = %', new_id;
		END IF;

		-- Если уровень больше 1 то стоит проверить родителя
		IF nlevel(NEW.path) > 1 THEN
			EXECUTE 'SELECT replace(m.id::text, ''-'',  '''') FROM ' ||TG_TABLE_NAME|| ' AS m 
				WHERE m.path = subpath($1, 0, nlevel($2) - 1)'
			INTO tid USING NEW.path, NEW.path;
			IF tid IS NULL THEN
				RAISE EXCEPTION  'Bad path2!';
			END IF;
		END IF;

		-- Обновляем детей узла следующего уровня
		EXECUTE 'UPDATE ' ||TG_TABLE_NAME|| ' SET path = '''|| NEW.path::text || '''::ltree || replace(id::text, ''-'', '''') WHERE path ~ (''' || OLD.path::text || '.*{1}'')::lquery';
	END IF;

	RETURN NEW;
END;
$_$;


ALTER FUNCTION public.tree_update_after_trigger() OWNER TO inprint;

--
-- Name: uuid_generate_v4(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION uuid_generate_v4() RETURNS uuid
    LANGUAGE c STRICT
    AS '$libdir/uuid-ossp', 'uuid_generate_v4';


ALTER FUNCTION public.uuid_generate_v4() OWNER TO inprint;

--
-- Name: <; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR < (
    PROCEDURE = ltree_lt,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.< (ltree, ltree) OWNER TO inprint;

--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR <= (
    PROCEDURE = ltree_le,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<= (ltree, ltree) OWNER TO inprint;

--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR <> (
    PROCEDURE = ltree_ne,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (ltree, ltree) OWNER TO inprint;

--
-- Name: <@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR <@ (
    PROCEDURE = ltree_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = @>,
    RESTRICT = ltreeparentsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (ltree, ltree) OWNER TO inprint;

--
-- Name: <@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR <@ (
    PROCEDURE = _ltree_r_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (ltree, ltree[]) OWNER TO inprint;

--
-- Name: <@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR <@ (
    PROCEDURE = _ltree_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.<@ (ltree[], ltree) OWNER TO inprint;

--
-- Name: =; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR = (
    PROCEDURE = ltree_eq,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (ltree, ltree) OWNER TO inprint;

--
-- Name: >; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR > (
    PROCEDURE = ltree_gt,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.> (ltree, ltree) OWNER TO inprint;

--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR >= (
    PROCEDURE = ltree_ge,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.>= (ltree, ltree) OWNER TO inprint;

--
-- Name: ?; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ? (
    PROCEDURE = lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree,
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.? (lquery[], ltree) OWNER TO inprint;

--
-- Name: ?; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ? (
    PROCEDURE = lt_q_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery[],
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.? (ltree, lquery[]) OWNER TO inprint;

--
-- Name: ?; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ? (
    PROCEDURE = _lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree[],
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.? (lquery[], ltree[]) OWNER TO inprint;

--
-- Name: ?; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ? (
    PROCEDURE = _lt_q_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery[],
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.? (ltree[], lquery[]) OWNER TO inprint;

--
-- Name: ?<@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ?<@ (
    PROCEDURE = _ltree_extract_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


ALTER OPERATOR public.?<@ (ltree[], ltree) OWNER TO inprint;

--
-- Name: ?@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ?@ (
    PROCEDURE = _ltxtq_extract_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery
);


ALTER OPERATOR public.?@ (ltree[], ltxtquery) OWNER TO inprint;

--
-- Name: ?@>; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ?@> (
    PROCEDURE = _ltree_extract_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


ALTER OPERATOR public.?@> (ltree[], ltree) OWNER TO inprint;

--
-- Name: ?~; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ?~ (
    PROCEDURE = _ltq_extract_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery
);


ALTER OPERATOR public.?~ (ltree[], lquery) OWNER TO inprint;

--
-- Name: @; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR @ (
    PROCEDURE = ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (ltxtquery, ltree) OWNER TO inprint;

--
-- Name: @; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR @ (
    PROCEDURE = ltxtq_exec,
    LEFTARG = ltree,
    RIGHTARG = ltxtquery,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (ltree, ltxtquery) OWNER TO inprint;

--
-- Name: @; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR @ (
    PROCEDURE = _ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree[],
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (ltxtquery, ltree[]) OWNER TO inprint;

--
-- Name: @; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR @ (
    PROCEDURE = _ltxtq_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@ (ltree[], ltxtquery) OWNER TO inprint;

--
-- Name: @>; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR @> (
    PROCEDURE = ltree_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = <@,
    RESTRICT = ltreeparentsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (ltree, ltree) OWNER TO inprint;

--
-- Name: @>; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR @> (
    PROCEDURE = _ltree_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (ltree[], ltree) OWNER TO inprint;

--
-- Name: @>; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR @> (
    PROCEDURE = _ltree_r_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.@> (ltree, ltree[]) OWNER TO inprint;

--
-- Name: ^<@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^<@ (
    PROCEDURE = ltree_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = ^@>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^<@ (ltree, ltree) OWNER TO inprint;

--
-- Name: ^<@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^<@ (
    PROCEDURE = _ltree_r_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = ^@>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^<@ (ltree, ltree[]) OWNER TO inprint;

--
-- Name: ^<@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^<@ (
    PROCEDURE = _ltree_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = ^@>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^<@ (ltree[], ltree) OWNER TO inprint;

--
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^? (
    PROCEDURE = lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree,
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^? (lquery[], ltree) OWNER TO inprint;

--
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^? (
    PROCEDURE = lt_q_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery[],
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^? (ltree, lquery[]) OWNER TO inprint;

--
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^? (
    PROCEDURE = _lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree[],
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^? (lquery[], ltree[]) OWNER TO inprint;

--
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^? (
    PROCEDURE = _lt_q_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery[],
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^? (ltree[], lquery[]) OWNER TO inprint;

--
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^@ (
    PROCEDURE = ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree,
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@ (ltxtquery, ltree) OWNER TO inprint;

--
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^@ (
    PROCEDURE = ltxtq_exec,
    LEFTARG = ltree,
    RIGHTARG = ltxtquery,
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@ (ltree, ltxtquery) OWNER TO inprint;

--
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^@ (
    PROCEDURE = _ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree[],
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@ (ltxtquery, ltree[]) OWNER TO inprint;

--
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^@ (
    PROCEDURE = _ltxtq_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery,
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@ (ltree[], ltxtquery) OWNER TO inprint;

--
-- Name: ^@>; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^@> (
    PROCEDURE = ltree_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = ^<@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@> (ltree, ltree) OWNER TO inprint;

--
-- Name: ^@>; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^@> (
    PROCEDURE = _ltree_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = ^<@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@> (ltree[], ltree) OWNER TO inprint;

--
-- Name: ^@>; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^@> (
    PROCEDURE = _ltree_r_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = ^<@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^@> (ltree, ltree[]) OWNER TO inprint;

--
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^~ (
    PROCEDURE = ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree,
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^~ (lquery, ltree) OWNER TO inprint;

--
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^~ (
    PROCEDURE = ltq_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery,
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^~ (ltree, lquery) OWNER TO inprint;

--
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^~ (
    PROCEDURE = _ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree[],
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^~ (lquery, ltree[]) OWNER TO inprint;

--
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ^~ (
    PROCEDURE = _ltq_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery,
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.^~ (ltree[], lquery) OWNER TO inprint;

--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addltree,
    LEFTARG = ltree,
    RIGHTARG = ltree
);


ALTER OPERATOR public.|| (ltree, ltree) OWNER TO inprint;

--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addtext,
    LEFTARG = ltree,
    RIGHTARG = text
);


ALTER OPERATOR public.|| (ltree, text) OWNER TO inprint;

--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR || (
    PROCEDURE = ltree_textadd,
    LEFTARG = text,
    RIGHTARG = ltree
);


ALTER OPERATOR public.|| (text, ltree) OWNER TO inprint;

--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ~ (
    PROCEDURE = ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (lquery, ltree) OWNER TO inprint;

--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ~ (
    PROCEDURE = ltq_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (ltree, lquery) OWNER TO inprint;

--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ~ (
    PROCEDURE = _ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree[],
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (lquery, ltree[]) OWNER TO inprint;

--
-- Name: ~; Type: OPERATOR; Schema: public; Owner: inprint
--

CREATE OPERATOR ~ (
    PROCEDURE = _ltq_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


ALTER OPERATOR public.~ (ltree[], lquery) OWNER TO inprint;

--
-- Name: gist__ltree_ops; Type: OPERATOR CLASS; Schema: public; Owner: inprint
--

CREATE OPERATOR CLASS gist__ltree_ops
    DEFAULT FOR TYPE ltree[] USING gist AS
    STORAGE ltree_gist ,
    OPERATOR 10 <@(ltree[],ltree) ,
    OPERATOR 11 @>(ltree,ltree[]) ,
    OPERATOR 12 ~(ltree[],lquery) ,
    OPERATOR 13 ~(lquery,ltree[]) ,
    OPERATOR 14 @(ltree[],ltxtquery) ,
    OPERATOR 15 @(ltxtquery,ltree[]) ,
    OPERATOR 16 ?(ltree[],lquery[]) ,
    OPERATOR 17 ?(lquery[],ltree[]) ,
    FUNCTION 1 _ltree_consistent(internal,internal,smallint,oid,internal) ,
    FUNCTION 2 _ltree_union(internal,internal) ,
    FUNCTION 3 _ltree_compress(internal) ,
    FUNCTION 4 ltree_decompress(internal) ,
    FUNCTION 5 _ltree_penalty(internal,internal,internal) ,
    FUNCTION 6 _ltree_picksplit(internal,internal) ,
    FUNCTION 7 _ltree_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist__ltree_ops USING gist OWNER TO inprint;

--
-- Name: gist_ltree_ops; Type: OPERATOR CLASS; Schema: public; Owner: inprint
--

CREATE OPERATOR CLASS gist_ltree_ops
    DEFAULT FOR TYPE ltree USING gist AS
    STORAGE ltree_gist ,
    OPERATOR 1 <(ltree,ltree) ,
    OPERATOR 2 <=(ltree,ltree) ,
    OPERATOR 3 =(ltree,ltree) ,
    OPERATOR 4 >=(ltree,ltree) ,
    OPERATOR 5 >(ltree,ltree) ,
    OPERATOR 10 @>(ltree,ltree) ,
    OPERATOR 11 <@(ltree,ltree) ,
    OPERATOR 12 ~(ltree,lquery) ,
    OPERATOR 13 ~(lquery,ltree) ,
    OPERATOR 14 @(ltree,ltxtquery) ,
    OPERATOR 15 @(ltxtquery,ltree) ,
    OPERATOR 16 ?(ltree,lquery[]) ,
    OPERATOR 17 ?(lquery[],ltree) ,
    FUNCTION 1 ltree_consistent(internal,internal,smallint,oid,internal) ,
    FUNCTION 2 ltree_union(internal,internal) ,
    FUNCTION 3 ltree_compress(internal) ,
    FUNCTION 4 ltree_decompress(internal) ,
    FUNCTION 5 ltree_penalty(internal,internal,internal) ,
    FUNCTION 6 ltree_picksplit(internal,internal) ,
    FUNCTION 7 ltree_same(internal,internal,internal);


ALTER OPERATOR CLASS public.gist_ltree_ops USING gist OWNER TO inprint;

--
-- Name: ltree_ops; Type: OPERATOR CLASS; Schema: public; Owner: inprint
--

CREATE OPERATOR CLASS ltree_ops
    DEFAULT FOR TYPE ltree USING btree AS
    OPERATOR 1 <(ltree,ltree) ,
    OPERATOR 2 <=(ltree,ltree) ,
    OPERATOR 3 =(ltree,ltree) ,
    OPERATOR 4 >=(ltree,ltree) ,
    OPERATOR 5 >(ltree,ltree) ,
    FUNCTION 1 ltree_cmp(ltree,ltree);


ALTER OPERATOR CLASS public.ltree_ops USING btree OWNER TO inprint;

SET search_path = plugins, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: l18n; Type: TABLE; Schema: plugins; Owner: inprint; Tablespace: 
--

CREATE TABLE l18n (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    plugin character varying NOT NULL,
    l18n_language character varying NOT NULL,
    l18n_original character varying NOT NULL,
    l18n_translation character varying NOT NULL
);


ALTER TABLE plugins.l18n OWNER TO inprint;

--
-- Name: menu; Type: TABLE; Schema: plugins; Owner: inprint; Tablespace: 
--

CREATE TABLE menu (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    plugin character varying NOT NULL,
    menu_section character varying NOT NULL,
    menu_id character varying NOT NULL,
    menu_sortorder integer DEFAULT 0 NOT NULL,
    menu_enabled boolean DEFAULT false NOT NULL
);


ALTER TABLE plugins.menu OWNER TO inprint;

--
-- Name: routes; Type: TABLE; Schema: plugins; Owner: inprint; Tablespace: 
--

CREATE TABLE routes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    plugin character varying NOT NULL,
    route_url character varying NOT NULL,
    route_controller character varying NOT NULL,
    route_action character varying NOT NULL,
    route_name character varying,
    route_enabled boolean DEFAULT false NOT NULL,
    route_authentication boolean DEFAULT true NOT NULL
);


ALTER TABLE plugins.routes OWNER TO inprint;

--
-- Name: rules; Type: TABLE; Schema: plugins; Owner: inprint; Tablespace: 
--

CREATE TABLE rules (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    plugin character varying NOT NULL,
    rule_term character varying NOT NULL,
    rule_section character varying,
    rule_subsection character varying,
    rule_icon character varying NOT NULL,
    rule_title character varying NOT NULL,
    rule_description character varying NOT NULL,
    rule_sortorder integer DEFAULT 0 NOT NULL,
    rule_enabled boolean DEFAULT false NOT NULL
);


ALTER TABLE plugins.rules OWNER TO inprint;

SET search_path = public, pg_catalog;

--
-- Name: ad_advertisers; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE ad_advertisers (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    serialnum integer NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    address character varying,
    contact character varying,
    phones character varying,
    inn character varying,
    kpp character varying,
    bank character varying,
    rs character varying,
    ks character varying,
    bik character varying,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.ad_advertisers OWNER TO inprint;

--
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: inprint
--

CREATE SEQUENCE ad_advertisers_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ad_advertisers_serialnum_seq OWNER TO inprint;

--
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: inprint
--

ALTER SEQUENCE ad_advertisers_serialnum_seq OWNED BY ad_advertisers.serialnum;


--
-- Name: ad_index; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE ad_index (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    place uuid NOT NULL,
    nature character varying NOT NULL,
    entity uuid NOT NULL,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.ad_index OWNER TO inprint;

--
-- Name: ad_modules; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE ad_modules (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    page uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    amount integer DEFAULT 1 NOT NULL,
    area double precision DEFAULT 0 NOT NULL,
    x character varying DEFAULT '1/1'::character varying NOT NULL,
    y character varying DEFAULT '1/1'::character varying NOT NULL,
    w character varying DEFAULT '1/1'::character varying NOT NULL,
    h character varying DEFAULT '1/1'::character varying NOT NULL,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.ad_modules OWNER TO inprint;

--
-- Name: ad_pages; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE ad_pages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    bydefault boolean DEFAULT false NOT NULL,
    w character varying[],
    h character varying[],
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.ad_pages OWNER TO inprint;

--
-- Name: ad_places; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE ad_places (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.ad_places OWNER TO inprint;

--
-- Name: ad_requests; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE ad_requests (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    serialnum integer NOT NULL,
    edition uuid NOT NULL,
    advertiser uuid NOT NULL,
    manager uuid,
    fascicle uuid NOT NULL,
    place uuid,
    module uuid,
    title character varying NOT NULL,
    shortcut character varying,
    description character varying,
    status character varying,
    payment character varying,
    readiness character varying,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.ad_requests OWNER TO inprint;

--
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: inprint
--

CREATE SEQUENCE ad_requests_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ad_requests_serialnum_seq OWNER TO inprint;

--
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: inprint
--

ALTER SEQUENCE ad_requests_serialnum_seq OWNED BY ad_requests.serialnum;


--
-- Name: branches; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE branches (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    mtype character varying,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.branches OWNER TO inprint;

--
-- Name: cache_access; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE cache_access (
    type character varying NOT NULL,
    path ltree,
    binding uuid NOT NULL,
    member uuid NOT NULL,
    terms text[]
);


ALTER TABLE public.cache_access OWNER TO inprint;

--
-- Name: cache_files; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE cache_files (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    file_path character varying NOT NULL,
    file_name character varying NOT NULL,
    file_extension character varying NOT NULL,
    file_mime character varying NOT NULL,
    file_digest character varying NOT NULL,
    file_thumbnail character varying,
    file_description character varying,
    file_size integer DEFAULT 0 NOT NULL,
    file_length integer DEFAULT 0 NOT NULL,
    file_meta character varying,
    file_exists boolean DEFAULT true NOT NULL,
    file_published boolean DEFAULT false NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cache_files OWNER TO inprint;

--
-- Name: cache_hotsave; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE cache_hotsave (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    hotsave_origin character varying NOT NULL,
    hotsave_path character varying NOT NULL,
    hotsave_branch uuid NOT NULL,
    hotsave_branch_shortcut character varying NOT NULL,
    hotsave_stage uuid NOT NULL,
    hotsave_stage_shortcut character varying NOT NULL,
    hotsave_color character varying NOT NULL,
    hotsave_creator uuid NOT NULL,
    hotsave_creator_shortcut character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cache_hotsave OWNER TO inprint;

--
-- Name: catalog; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE catalog (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    path ltree,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    type character varying NOT NULL,
    capables character varying[] NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.catalog OWNER TO inprint;

--
-- Name: editions; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE editions (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    path ltree,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.editions OWNER TO inprint;

--
-- Name: map_member_to_rule; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE map_member_to_rule (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    section character varying NOT NULL,
    area character varying NOT NULL,
    binding uuid NOT NULL,
    term uuid NOT NULL
);


ALTER TABLE public.map_member_to_rule OWNER TO inprint;

--
-- Name: members; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE members (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    login character varying NOT NULL,
    password character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.members OWNER TO inprint;

--
-- Name: rules; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE rules (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    term character varying NOT NULL,
    section character varying,
    subsection character varying,
    icon character varying NOT NULL,
    title character varying NOT NULL,
    description character varying NOT NULL,
    sortorder integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.rules OWNER TO inprint;

--
-- Name: cache_rules; Type: VIEW; Schema: public; Owner: inprint
--

CREATE VIEW cache_rules AS
    (SELECT 'edition' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(SELECT DISTINCT (((((a2.section)::text || '.'::text) || (a2.subsection)::text) || '.'::text) || (a2.term)::text) AS term FROM map_member_to_rule a1, rules a2 WHERE (((a2.id = a1.term) AND (a1.member = t2.id)) AND (a1.binding IN (SELECT editions.id FROM editions WHERE (editions.path @> t1.path))))) AS terms FROM editions t1, members t2 ORDER BY t1.path) UNION (SELECT 'catalog' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(SELECT DISTINCT (((((a2.section)::text || '.'::text) || (a2.subsection)::text) || '.'::text) || (a2.term)::text) AS term FROM map_member_to_rule a1, rules a2 WHERE (((a2.id = a1.term) AND (a1.member = t2.id)) AND (a1.binding IN (SELECT catalog.id FROM catalog WHERE (catalog.path @> t1.path))))) AS terms FROM catalog t1, members t2 ORDER BY t1.path);


ALTER TABLE public.cache_rules OWNER TO inprint;

--
-- Name: cache_versions; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE cache_versions (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    version_origin character varying NOT NULL,
    version_path character varying NOT NULL,
    version_branch uuid NOT NULL,
    version_branch_shortcut character varying NOT NULL,
    version_stage uuid NOT NULL,
    version_stage_shortcut character varying NOT NULL,
    version_color character varying NOT NULL,
    version_creator uuid NOT NULL,
    version_creator_shortcut character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cache_versions OWNER TO inprint;

--
-- Name: cache_visibility; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE cache_visibility (
    type character varying NOT NULL,
    member uuid NOT NULL,
    term character varying NOT NULL,
    termid uuid NOT NULL,
    parents uuid[],
    childrens uuid[]
);


ALTER TABLE public.cache_visibility OWNER TO inprint;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE comments (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    entity uuid NOT NULL,
    path ltree,
    member uuid NOT NULL,
    member_shortcut character varying NOT NULL,
    stage uuid NOT NULL,
    stage_shortcut character varying NOT NULL,
    stage_color character varying NOT NULL,
    fulltext character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.comments OWNER TO inprint;

--
-- Name: documents; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE documents (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    creator uuid NOT NULL,
    creator_shortcut character varying NOT NULL,
    holder uuid NOT NULL,
    holder_shortcut character varying NOT NULL,
    manager uuid NOT NULL,
    manager_shortcut character varying NOT NULL,
    edition uuid NOT NULL,
    edition_shortcut character varying NOT NULL,
    ineditions uuid[],
    copygroup uuid,
    movegroup uuid,
    maingroup uuid NOT NULL,
    maingroup_shortcut character varying NOT NULL,
    workgroup uuid NOT NULL,
    workgroup_shortcut character varying NOT NULL,
    inworkgroups uuid[],
    fascicle uuid NOT NULL,
    fascicle_shortcut character varying NOT NULL,
    fascicle_blocked boolean DEFAULT false NOT NULL,
    headline uuid,
    headline_shortcut character varying,
    rubric uuid,
    rubric_shortcut character varying,
    branch uuid NOT NULL,
    branch_shortcut character varying NOT NULL,
    stage uuid NOT NULL,
    stage_shortcut character varying NOT NULL,
    readiness uuid NOT NULL,
    readiness_shortcut character varying NOT NULL,
    color character varying NOT NULL,
    progress integer DEFAULT 0 NOT NULL,
    title character varying NOT NULL,
    author character varying,
    pages character varying,
    firstpage integer,
    filepath character varying,
    pdate timestamp(6) with time zone,
    fdate timestamp(6) with time zone,
    ldate timestamp(6) with time zone,
    psize integer DEFAULT 0,
    rsize integer DEFAULT 0,
    images integer DEFAULT 0,
    files integer DEFAULT 0,
    islooked boolean DEFAULT false NOT NULL,
    isopen boolean DEFAULT false NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL,
    uploaded timestamp(6) with time zone DEFAULT now() NOT NULL,
    moved timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.documents OWNER TO inprint;

--
-- Name: editions_options; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE editions_options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.editions_options OWNER TO inprint;

--
-- Name: fascicles; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    parent uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    manager uuid,
    variation uuid NOT NULL,
    deadline timestamp(6) with time zone,
    advert_deadline timestamp(6) with time zone,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL,
    enabled boolean DEFAULT false NOT NULL
);


ALTER TABLE public.fascicles OWNER TO inprint;

--
-- Name: fascicles_indx_headlines; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_indx_headlines (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    tag uuid NOT NULL,
    bydefault boolean DEFAULT false NOT NULL,
    title character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.fascicles_indx_headlines OWNER TO inprint;

--
-- Name: fascicles_indx_rubrics; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_indx_rubrics (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    headline uuid NOT NULL,
    tag uuid NOT NULL,
    title character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL,
    bydefault boolean DEFAULT false NOT NULL
);


ALTER TABLE public.fascicles_indx_rubrics OWNER TO inprint;

--
-- Name: fascicles_map_documents; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_map_documents (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    page uuid,
    entity uuid,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.fascicles_map_documents OWNER TO inprint;

--
-- Name: fascicles_map_modules; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_map_modules (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    module uuid NOT NULL,
    page uuid,
    placed boolean DEFAULT false NOT NULL,
    x character varying,
    y character varying,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.fascicles_map_modules OWNER TO inprint;

--
-- Name: fascicles_map_requests; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_map_requests (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    page uuid,
    entity uuid,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.fascicles_map_requests OWNER TO inprint;

--
-- Name: fascicles_modules; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_modules (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    place uuid NOT NULL,
    origin uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    amount integer DEFAULT 1 NOT NULL,
    w character varying,
    h character varying,
    area double precision DEFAULT 0 NOT NULL,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.fascicles_modules OWNER TO inprint;

--
-- Name: fascicles_options; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.fascicles_options OWNER TO inprint;

--
-- Name: fascicles_pages; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_pages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    origin uuid NOT NULL,
    headline uuid,
    seqnum integer,
    w character varying[],
    h character varying[],
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.fascicles_pages OWNER TO inprint;

--
-- Name: fascicles_requests; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_requests (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    serialnum integer NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    advertiser uuid NOT NULL,
    advertiser_shortcut character varying NOT NULL,
    place uuid NOT NULL,
    place_shortcut character varying NOT NULL,
    manager uuid NOT NULL,
    manager_shortcut character varying NOT NULL,
    amount integer DEFAULT 1 NOT NULL,
    origin uuid NOT NULL,
    origin_shortcut character varying NOT NULL,
    origin_area double precision DEFAULT 0 NOT NULL,
    origin_x character varying DEFAULT '1/1'::character varying NOT NULL,
    origin_y character varying DEFAULT '1/1'::character varying NOT NULL,
    origin_w character varying DEFAULT '1/1'::character varying NOT NULL,
    origin_h character varying DEFAULT '1/1'::character varying NOT NULL,
    module uuid,
    pages character varying,
    firstpage integer,
    shortcut character varying NOT NULL,
    description character varying,
    status character varying NOT NULL,
    payment character varying NOT NULL,
    readiness character varying NOT NULL,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now(),
    squib character varying NOT NULL
);


ALTER TABLE public.fascicles_requests OWNER TO inprint;

--
-- Name: fascicles_requests_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: inprint
--

CREATE SEQUENCE fascicles_requests_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.fascicles_requests_serialnum_seq OWNER TO inprint;

--
-- Name: fascicles_requests_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: inprint
--

ALTER SEQUENCE fascicles_requests_serialnum_seq OWNED BY fascicles_requests.serialnum;


--
-- Name: fascicles_tmpl_index; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_tmpl_index (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    place uuid NOT NULL,
    nature character varying NOT NULL,
    entity uuid NOT NULL,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.fascicles_tmpl_index OWNER TO inprint;

--
-- Name: fascicles_tmpl_modules; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_tmpl_modules (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    origin uuid NOT NULL,
    fascicle uuid NOT NULL,
    page uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    amount integer DEFAULT 1 NOT NULL,
    area double precision DEFAULT 0 NOT NULL,
    x character varying DEFAULT '1/1'::character varying NOT NULL,
    y character varying DEFAULT '1/1'::character varying NOT NULL,
    w character varying DEFAULT '1/1'::character varying NOT NULL,
    h character varying DEFAULT '1/1'::character varying NOT NULL,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.fascicles_tmpl_modules OWNER TO inprint;

--
-- Name: fascicles_tmpl_pages; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_tmpl_pages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    origin uuid NOT NULL,
    fascicle uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    bydefault boolean DEFAULT false NOT NULL,
    w character varying[],
    h character varying[],
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.fascicles_tmpl_pages OWNER TO inprint;

--
-- Name: fascicles_tmpl_places; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles_tmpl_places (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    origin uuid NOT NULL,
    fascicle uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


ALTER TABLE public.fascicles_tmpl_places OWNER TO inprint;

--
-- Name: history; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE history (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    entity uuid NOT NULL,
    operation character varying NOT NULL,
    color character varying NOT NULL,
    weight character varying NOT NULL,
    branch uuid NOT NULL,
    branch_shortcut character varying NOT NULL,
    stage uuid NOT NULL,
    stage_shortcut character varying NOT NULL,
    sender uuid NOT NULL,
    sender_shortcut character varying NOT NULL,
    sender_catalog uuid NOT NULL,
    sender_catalog_shortcut character varying NOT NULL,
    destination uuid NOT NULL,
    destination_shortcut character varying NOT NULL,
    destination_catalog uuid NOT NULL,
    destination_catalog_shortcut character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.history OWNER TO inprint;

--
-- Name: indx_headlines; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE indx_headlines (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    tag uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    bydefault boolean DEFAULT false NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.indx_headlines OWNER TO inprint;

--
-- Name: indx_rubrics; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE indx_rubrics (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    headline uuid NOT NULL,
    tag uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL,
    bydefault boolean DEFAULT false NOT NULL
);


ALTER TABLE public.indx_rubrics OWNER TO inprint;

--
-- Name: indx_tags; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE indx_tags (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    title character varying NOT NULL,
    description character varying,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.indx_tags OWNER TO inprint;

--
-- Name: logs; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE logs (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    initiator uuid NOT NULL,
    initiator_login character varying NOT NULL,
    initiator_shortcut character varying NOT NULL,
    initiator_position character varying NOT NULL,
    entity uuid NOT NULL,
    entity_type character varying NOT NULL,
    message character varying NOT NULL,
    message_type character varying NOT NULL,
    message_variables character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.logs OWNER TO inprint;

--
-- Name: map_member_to_catalog; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE map_member_to_catalog (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    catalog uuid NOT NULL
);


ALTER TABLE public.map_member_to_catalog OWNER TO inprint;

--
-- Name: map_principals_to_stages; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE map_principals_to_stages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    stage uuid NOT NULL,
    catalog uuid NOT NULL,
    principal uuid NOT NULL
);


ALTER TABLE public.map_principals_to_stages OWNER TO inprint;

--
-- Name: map_role_to_rule; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE map_role_to_rule (
    role uuid NOT NULL,
    rule uuid NOT NULL,
    mode character varying NOT NULL
);


ALTER TABLE public.map_role_to_rule OWNER TO inprint;

--
-- Name: migration; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE migration (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    mtype character varying NOT NULL,
    oldid uuid NOT NULL,
    newid uuid NOT NULL
);


ALTER TABLE public.migration OWNER TO inprint;

--
-- Name: options; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying NOT NULL
);


ALTER TABLE public.options OWNER TO inprint;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE profiles (
    id uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    job_position character varying NOT NULL,
    email character varying,
    icq character varying,
    skype character varying,
    jabber character varying,
    phone_work character varying,
    phone_mobile character varying,
    mobile character varying,
    address character varying,
    about character varying,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.profiles OWNER TO inprint;

--
-- Name: readiness; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE readiness (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    color character varying NOT NULL,
    weight smallint NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.readiness OWNER TO inprint;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE roles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.roles OWNER TO inprint;

--
-- Name: rss; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE rss (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    document uuid NOT NULL,
    link character varying NOT NULL,
    title character varying NOT NULL,
    description character varying NOT NULL,
    fulltext character varying,
    published boolean DEFAULT false NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rss OWNER TO inprint;

--
-- Name: rss_feeds; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE rss_feeds (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    url character varying NOT NULL,
    title character varying NOT NULL,
    description character varying NOT NULL,
    published boolean DEFAULT false NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rss_feeds OWNER TO inprint;

--
-- Name: rss_feeds_mapping; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE rss_feeds_mapping (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    feed uuid NOT NULL,
    nature character varying NOT NULL,
    tag uuid NOT NULL
);


ALTER TABLE public.rss_feeds_mapping OWNER TO inprint;

--
-- Name: rss_feeds_options; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE rss_feeds_options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    feed uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying NOT NULL
);


ALTER TABLE public.rss_feeds_options OWNER TO inprint;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE sessions (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    ipaddress character varying NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL,
    updated timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sessions OWNER TO inprint;

--
-- Name: stages; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE stages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    branch uuid NOT NULL,
    readiness uuid NOT NULL,
    weight smallint NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.stages OWNER TO inprint;

--
-- Name: state; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE state (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    param character varying NOT NULL,
    value character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.state OWNER TO inprint;

--
-- Name: view_principals; Type: VIEW; Schema: public; Owner: inprint
--

CREATE VIEW view_principals AS
    SELECT t1.id, 'member' AS type, t2.title, t2.shortcut, t2.job_position AS description FROM members t1, profiles t2 WHERE (t1.id = t2.id) UNION SELECT catalog.id, 'group' AS type, catalog.title, catalog.shortcut, catalog.description FROM catalog;


ALTER TABLE public.view_principals OWNER TO inprint;

--
-- Name: view_assignments; Type: VIEW; Schema: public; Owner: inprint
--

CREATE VIEW view_assignments AS
    SELECT t1.id, t1.catalog, t5.shortcut AS catalog_shortcut, t6.type AS principal_type, t1.principal, t6.shortcut AS principal_shortcut, t2.id AS branch, t2.shortcut AS branch_shortcut, t1.stage, t3.shortcut AS stage_shortcut, t4.id AS readiness, t4.shortcut AS readiness_shortcut, t4.weight AS progress, t4.color FROM map_principals_to_stages t1, branches t2, stages t3, readiness t4, catalog t5, view_principals t6 WHERE (((((t2.id = t3.branch) AND (t3.id = t1.stage)) AND (t4.id = t3.readiness)) AND (t5.id = t1.catalog)) AND (t6.id = t1.principal));


ALTER TABLE public.view_assignments OWNER TO inprint;

--
-- Name: view_members; Type: VIEW; Schema: public; Owner: inprint
--

CREATE VIEW view_members AS
    SELECT t1.id, t1.login, t1.password, t2.title, t2.shortcut, t2.job_position, ARRAY(SELECT map_member_to_catalog.catalog FROM map_member_to_catalog WHERE (map_member_to_catalog.member = t1.id)) AS catalog FROM members t1, profiles t2 WHERE (t1.id = t2.id);


ALTER TABLE public.view_members OWNER TO inprint;

--
-- Name: view_rules; Type: VIEW; Schema: public; Owner: inprint
--

CREATE VIEW view_rules AS
    SELECT rules.id, rules.term, rules.section, rules.subsection, rules.icon, rules.title, rules.description, rules.sortorder, (((((rules.section)::text || '.'::text) || (rules.subsection)::text) || '.'::text) || (rules.term)::text) AS term_text FROM rules;


ALTER TABLE public.view_rules OWNER TO inprint;

--
-- Name: view_rules_old; Type: VIEW; Schema: public; Owner: inprint
--

CREATE VIEW view_rules_old AS
    (SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, '00000000000000000000000000000000'::ltree AS path, ARRAY['00000000-0000-0000-0000-000000000000'::uuid] AS childrens FROM map_member_to_rule t1, rules t2 WHERE (((t1.section)::text = 'domain'::text) AND (t2.id = t1.term)) UNION SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, t3.path, ARRAY(SELECT catalog.id FROM catalog WHERE (catalog.path ~ (((t3.path)::text || '.*'::text))::lquery)) AS childrens FROM map_member_to_rule t1, rules t2, editions t3 WHERE ((((t1.section)::text = 'editions'::text) AND (t2.id = t1.term)) AND (t3.id = t1.binding))) UNION SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, t3.path, ARRAY(SELECT catalog.id FROM catalog WHERE (catalog.path ~ (((t3.path)::text || '.*'::text))::lquery)) AS childrens FROM map_member_to_rule t1, rules t2, catalog t3 WHERE ((((t1.section)::text = 'catalog'::text) AND (t2.id = t1.term)) AND (t3.id = t1.binding));


ALTER TABLE public.view_rules_old OWNER TO inprint;

--
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: inprint
--

ALTER TABLE ad_advertisers ALTER COLUMN serialnum SET DEFAULT nextval('ad_advertisers_serialnum_seq'::regclass);


--
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: inprint
--

ALTER TABLE ad_requests ALTER COLUMN serialnum SET DEFAULT nextval('ad_requests_serialnum_seq'::regclass);


--
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: inprint
--

ALTER TABLE fascicles_requests ALTER COLUMN serialnum SET DEFAULT nextval('fascicles_requests_serialnum_seq'::regclass);


SET search_path = plugins, pg_catalog;

--
-- Name: l18n_l18n_original_key; Type: CONSTRAINT; Schema: plugins; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY l18n
    ADD CONSTRAINT l18n_l18n_original_key UNIQUE (l18n_original);


--
-- Name: l18n_pkey; Type: CONSTRAINT; Schema: plugins; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY l18n
    ADD CONSTRAINT l18n_pkey PRIMARY KEY (id);


--
-- Name: menu_pkey; Type: CONSTRAINT; Schema: plugins; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (id);


--
-- Name: menu_plugin_key; Type: CONSTRAINT; Schema: plugins; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_plugin_key UNIQUE (plugin, menu_section, menu_id);


--
-- Name: routes_pkey; Type: CONSTRAINT; Schema: plugins; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: routes_plugin_key; Type: CONSTRAINT; Schema: plugins; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_plugin_key UNIQUE (plugin, route_url);


--
-- Name: rules_pkey; Type: CONSTRAINT; Schema: plugins; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- Name: rules_plugin_key; Type: CONSTRAINT; Schema: plugins; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_plugin_key UNIQUE (plugin, rule_term);


SET search_path = public, pg_catalog;

--
-- Name: ad_advertisers_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY ad_advertisers
    ADD CONSTRAINT ad_advertisers_pkey PRIMARY KEY (id);


--
-- Name: ad_index_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY ad_index
    ADD CONSTRAINT ad_index_pkey PRIMARY KEY (id);


--
-- Name: ad_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY ad_modules
    ADD CONSTRAINT ad_modules_pkey PRIMARY KEY (id);


--
-- Name: ad_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY ad_pages
    ADD CONSTRAINT ad_pages_pkey PRIMARY KEY (id);


--
-- Name: ad_places_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY ad_places
    ADD CONSTRAINT ad_places_pkey PRIMARY KEY (id);


--
-- Name: ad_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY ad_requests
    ADD CONSTRAINT ad_requests_pkey PRIMARY KEY (id);


--
-- Name: cache_access_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY cache_access
    ADD CONSTRAINT cache_access_pkey PRIMARY KEY (type, member, binding);


--
-- Name: cache_files_entity_key; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY cache_files
    ADD CONSTRAINT cache_files_entity_key UNIQUE (file_path, file_name);


--
-- Name: cache_files_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY cache_files
    ADD CONSTRAINT cache_files_pkey PRIMARY KEY (id);


--
-- Name: cache_hotsave_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY cache_hotsave
    ADD CONSTRAINT cache_hotsave_pkey PRIMARY KEY (id);


--
-- Name: cache_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY cache_versions
    ADD CONSTRAINT cache_versions_pkey PRIMARY KEY (id);


--
-- Name: cache_visibility_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY cache_visibility
    ADD CONSTRAINT cache_visibility_pkey PRIMARY KEY (type, member, term);


--
-- Name: catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY catalog
    ADD CONSTRAINT catalog_pkey PRIMARY KEY (id);


--
-- Name: chains_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY branches
    ADD CONSTRAINT chains_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: editions_options_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY editions_options
    ADD CONSTRAINT editions_options_pkey PRIMARY KEY (id);


--
-- Name: editions_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY editions
    ADD CONSTRAINT editions_pkey PRIMARY KEY (id);


--
-- Name: fascicles_indx_headlines_edition_key; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_edition_key UNIQUE (edition, fascicle, tag);


--
-- Name: fascicles_indx_headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_pkey PRIMARY KEY (id);


--
-- Name: fascicles_indx_rubrics_edition_key; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_edition_key UNIQUE (edition, fascicle, headline, tag);


--
-- Name: fascicles_indx_rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_pkey PRIMARY KEY (id);


--
-- Name: fascicles_map_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_pkey PRIMARY KEY (id);


--
-- Name: fascicles_map_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_pkey PRIMARY KEY (id);


--
-- Name: fascicles_map_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_map_requests
    ADD CONSTRAINT fascicles_map_requests_pkey PRIMARY KEY (id);


--
-- Name: fascicles_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_pkey PRIMARY KEY (id);


--
-- Name: fascicles_options_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_options
    ADD CONSTRAINT fascicles_options_pkey PRIMARY KEY (id);


--
-- Name: fascicles_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_pkey PRIMARY KEY (id);


--
-- Name: fascicles_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_pkey PRIMARY KEY (id);


--
-- Name: fascicles_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_requests
    ADD CONSTRAINT fascicles_requests_pkey PRIMARY KEY (id);


--
-- Name: fascicles_tmpl_index_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_tmpl_index
    ADD CONSTRAINT fascicles_tmpl_index_pkey PRIMARY KEY (id);


--
-- Name: fascicles_tmpl_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_pkey PRIMARY KEY (id);


--
-- Name: fascicles_tmpl_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_tmpl_pages
    ADD CONSTRAINT fascicles_tmpl_pages_pkey PRIMARY KEY (id);


--
-- Name: fascicles_tmpl_places_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles_tmpl_places
    ADD CONSTRAINT fascicles_tmpl_places_pkey PRIMARY KEY (id);


--
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- Name: indx_headlines_edition_key; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_edition_key UNIQUE (edition, tag);


--
-- Name: indx_headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_pkey PRIMARY KEY (id);


--
-- Name: indx_rubrics_edition_key; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_edition_key UNIQUE (edition, headline, tag);


--
-- Name: indx_rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_pkey PRIMARY KEY (id);


--
-- Name: indx_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY indx_tags
    ADD CONSTRAINT indx_tags_pkey PRIMARY KEY (id);


--
-- Name: logs_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: map_member_to_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_pkey PRIMARY KEY (member, catalog);


--
-- Name: map_member_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_member_to_rule
    ADD CONSTRAINT map_member_to_rule_pkey PRIMARY KEY (id);


--
-- Name: map_principals_to_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_principals_to_stages
    ADD CONSTRAINT map_principals_to_stages_pkey PRIMARY KEY (id, stage, principal);


--
-- Name: map_role_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_pkey PRIMARY KEY (role, rule, mode);


--
-- Name: member_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY members
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: member_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT member_profiles_pkey PRIMARY KEY (id);


--
-- Name: member_session_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT member_session_pkey PRIMARY KEY (id);


--
-- Name: migration_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY migration
    ADD CONSTRAINT migration_pkey PRIMARY KEY (id);


--
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: rss_feeds_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY rss_feeds_mapping
    ADD CONSTRAINT rss_feeds_mapping_pkey PRIMARY KEY (id);


--
-- Name: rss_feeds_options_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY rss_feeds_options
    ADD CONSTRAINT rss_feeds_options_pkey PRIMARY KEY (id);


--
-- Name: rss_feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY rss_feeds
    ADD CONSTRAINT rss_feeds_pkey PRIMARY KEY (id);


--
-- Name: rss_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY rss
    ADD CONSTRAINT rss_pkey PRIMARY KEY (id);


--
-- Name: rules_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- Name: stages_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- Name: state_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- Name: statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY readiness
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: fki_; Type: INDEX; Schema: public; Owner: inprint; Tablespace: 
--

CREATE INDEX fki_ ON fascicles_pages USING btree (origin);


--
-- Name: catalog_access_delete_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER catalog_access_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_delete_after_trigger('catalog');


--
-- Name: catalog_access_insert_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER catalog_access_insert_after
    AFTER INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_insert_after_trigger('catalog');


--
-- Name: catalog_access_update_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER catalog_access_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_update_after_trigger('catalog');


--
-- Name: catalog_delete_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER catalog_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- Name: catalog_insert_before; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER catalog_insert_before
    BEFORE INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- Name: catalog_update_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER catalog_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- Name: editions_access_delete_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER editions_access_delete_after
    AFTER DELETE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_delete_after_trigger('editions');


--
-- Name: editions_access_insert_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER editions_access_insert_after
    AFTER INSERT ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_insert_after_trigger('editions');


--
-- Name: editions_access_update_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER editions_access_update_after
    AFTER UPDATE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_update_after_trigger('editions');


--
-- Name: editions_delete_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER editions_delete_after
    AFTER DELETE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- Name: editions_insert_before; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER editions_insert_before
    BEFORE INSERT ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- Name: editions_update_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER editions_update_after
    AFTER UPDATE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- Name: fascicles_map_documents_delete_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER fascicles_map_documents_delete_after
    AFTER DELETE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_delete_after_trigger();


--
-- Name: fascicles_map_documents_update_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER fascicles_map_documents_update_after
    AFTER INSERT OR UPDATE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_update_after_trigger();


--
-- Name: fascicles_map_modules_delete_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER fascicles_map_modules_delete_after
    AFTER DELETE ON fascicles_map_modules
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_modules_delete_after_trigger();


--
-- Name: fascicles_map_modules_update_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER fascicles_map_modules_update_after
    AFTER INSERT OR UPDATE ON fascicles_map_modules
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_modules_update_after_trigger();


--
-- Name: rules_mapping_delete_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER rules_mapping_delete_after
    AFTER DELETE ON map_member_to_rule
    FOR EACH ROW
    EXECUTE PROCEDURE rules_delete_after_trigger();


--
-- Name: rules_mapping_insert_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER rules_mapping_insert_after
    AFTER INSERT ON map_member_to_rule
    FOR EACH ROW
    EXECUTE PROCEDURE rules_insert_after_trigger();


--
-- Name: cache_access_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY cache_access
    ADD CONSTRAINT cache_access_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_indx_headlines_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_indx_rubrics_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_indx_rubrics_headline_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_headline_fkey FOREIGN KEY (headline) REFERENCES fascicles_indx_headlines(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_map_documents_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_entity_fkey FOREIGN KEY (entity) REFERENCES documents(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_map_documents_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_map_documents_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_page_fkey FOREIGN KEY (page) REFERENCES fascicles_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_map_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_map_modules_module_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_module_fkey FOREIGN KEY (module) REFERENCES fascicles_modules(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_map_modules_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_page_fkey FOREIGN KEY (page) REFERENCES fascicles_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_map_requests_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_map_requests
    ADD CONSTRAINT fascicles_map_requests_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_modules_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_origin_fkey FOREIGN KEY (origin) REFERENCES fascicles_tmpl_modules(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_modules_place_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_place_fkey FOREIGN KEY (place) REFERENCES fascicles_tmpl_places(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_options_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_options
    ADD CONSTRAINT fascicles_options_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_pages_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_pages_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_origin_fkey FOREIGN KEY (origin) REFERENCES fascicles_tmpl_pages(id) ON DELETE RESTRICT;


--
-- Name: fascicles_requests_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_requests
    ADD CONSTRAINT fascicles_requests_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_tmpl_index_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_tmpl_index
    ADD CONSTRAINT fascicles_tmpl_index_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_tmpl_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_tmpl_modules_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_page_fkey FOREIGN KEY (page) REFERENCES fascicles_tmpl_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_tmpl_pages_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_tmpl_pages
    ADD CONSTRAINT fascicles_tmpl_pages_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_tmpl_places_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY fascicles_tmpl_places
    ADD CONSTRAINT fascicles_tmpl_places_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: indx_headlines_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: indx_rubrics_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: indx_rubrics_headline_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_headline_fkey FOREIGN KEY (headline) REFERENCES indx_headlines(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: map_member_to_catalog_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: map_role_to_rule_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_role_fkey FOREIGN KEY (role) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

