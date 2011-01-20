--
-- PostgreSQL database dump
--

-- Dumped from database version 8.4.5
-- Dumped by pg_dump version 9.0.1
-- Started on 2011-01-20 17:20:15

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 553 (class 2612 OID 16386)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- TOC entry 387 (class 0 OID 0)
-- Name: lquery; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE lquery;


--
-- TOC entry 8 (class 1255 OID 294683)
-- Dependencies: 3 387
-- Name: lquery_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lquery_in(cstring) RETURNS lquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_in';


--
-- TOC entry 20 (class 1255 OID 294684)
-- Dependencies: 3 387
-- Name: lquery_out(lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lquery_out(lquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_out';


--
-- TOC entry 386 (class 1247 OID 294682)
-- Dependencies: 20 8 3
-- Name: lquery; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE lquery (
    INTERNALLENGTH = variable,
    INPUT = lquery_in,
    OUTPUT = lquery_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


--
-- TOC entry 390 (class 0 OID 0)
-- Name: ltree; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree;


--
-- TOC entry 21 (class 1255 OID 294687)
-- Dependencies: 3 390
-- Name: ltree_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_in(cstring) RETURNS ltree
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_in';


--
-- TOC entry 22 (class 1255 OID 294688)
-- Dependencies: 3 390
-- Name: ltree_out(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_out(ltree) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_out';


--
-- TOC entry 389 (class 1247 OID 294686)
-- Dependencies: 21 22 3
-- Name: ltree; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree (
    INTERNALLENGTH = variable,
    INPUT = ltree_in,
    OUTPUT = ltree_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


--
-- TOC entry 393 (class 0 OID 0)
-- Name: ltree_gist; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree_gist;


--
-- TOC entry 23 (class 1255 OID 294691)
-- Dependencies: 3 393
-- Name: ltree_gist_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gist_in(cstring) RETURNS ltree_gist
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_in';


--
-- TOC entry 24 (class 1255 OID 294692)
-- Dependencies: 3 393
-- Name: ltree_gist_out(ltree_gist); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gist_out(ltree_gist) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_out';


--
-- TOC entry 392 (class 1247 OID 294690)
-- Dependencies: 23 3 24
-- Name: ltree_gist; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree_gist (
    INTERNALLENGTH = variable,
    INPUT = ltree_gist_in,
    OUTPUT = ltree_gist_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


--
-- TOC entry 396 (class 0 OID 0)
-- Name: ltxtquery; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltxtquery;


--
-- TOC entry 25 (class 1255 OID 294695)
-- Dependencies: 3 396
-- Name: ltxtq_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_in(cstring) RETURNS ltxtquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_in';


--
-- TOC entry 26 (class 1255 OID 294696)
-- Dependencies: 3 396
-- Name: ltxtq_out(ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_out(ltxtquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_out';


--
-- TOC entry 395 (class 1247 OID 294694)
-- Dependencies: 3 25 26
-- Name: ltxtquery; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE ltxtquery (
    INTERNALLENGTH = variable,
    INPUT = ltxtq_in,
    OUTPUT = ltxtq_out,
    ALIGNMENT = int4,
    STORAGE = extended
);


--
-- TOC entry 27 (class 1255 OID 294698)
-- Dependencies: 3 391 388
-- Name: _lt_q_regex(ltree[], lquery[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _lt_q_regex(ltree[], lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_regex';


--
-- TOC entry 28 (class 1255 OID 294699)
-- Dependencies: 391 388 3
-- Name: _lt_q_rregex(lquery[], ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _lt_q_rregex(lquery[], ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_rregex';


--
-- TOC entry 29 (class 1255 OID 294700)
-- Dependencies: 386 3 389 391
-- Name: _ltq_extract_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_extract_regex(ltree[], lquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_extract_regex';


--
-- TOC entry 30 (class 1255 OID 294701)
-- Dependencies: 386 391 3
-- Name: _ltq_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_regex(ltree[], lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_regex';


--
-- TOC entry 31 (class 1255 OID 294702)
-- Dependencies: 3 391 386
-- Name: _ltq_rregex(lquery, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_rregex(lquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_rregex';


--
-- TOC entry 32 (class 1255 OID 294703)
-- Dependencies: 3
-- Name: _ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_compress';


--
-- TOC entry 33 (class 1255 OID 294704)
-- Dependencies: 3
-- Name: _ltree_consistent(internal, internal, smallint, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_consistent(internal, internal, smallint, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_consistent';


--
-- TOC entry 34 (class 1255 OID 294705)
-- Dependencies: 389 3 391 389
-- Name: _ltree_extract_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_extract_isparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_isparent';


--
-- TOC entry 35 (class 1255 OID 294706)
-- Dependencies: 3 389 391 389
-- Name: _ltree_extract_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_extract_risparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_risparent';


--
-- TOC entry 36 (class 1255 OID 294707)
-- Dependencies: 3 391 389
-- Name: _ltree_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_isparent(ltree[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_isparent';


--
-- TOC entry 37 (class 1255 OID 294708)
-- Dependencies: 3
-- Name: _ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_penalty';


--
-- TOC entry 38 (class 1255 OID 294709)
-- Dependencies: 3
-- Name: _ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_picksplit';


--
-- TOC entry 39 (class 1255 OID 294710)
-- Dependencies: 3 389 391
-- Name: _ltree_r_isparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_r_isparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_isparent';


--
-- TOC entry 40 (class 1255 OID 294711)
-- Dependencies: 391 3 389
-- Name: _ltree_r_risparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_r_risparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_risparent';


--
-- TOC entry 41 (class 1255 OID 294712)
-- Dependencies: 391 3 389
-- Name: _ltree_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_risparent(ltree[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_risparent';


--
-- TOC entry 42 (class 1255 OID 294713)
-- Dependencies: 3
-- Name: _ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_same';


--
-- TOC entry 43 (class 1255 OID 294714)
-- Dependencies: 3
-- Name: _ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_union(internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_union';


--
-- TOC entry 44 (class 1255 OID 294715)
-- Dependencies: 391 3 395
-- Name: _ltxtq_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_exec(ltree[], ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_exec';


--
-- TOC entry 45 (class 1255 OID 294716)
-- Dependencies: 395 3 389 391
-- Name: _ltxtq_extract_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_extract_exec(ltree[], ltxtquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_extract_exec';


--
-- TOC entry 46 (class 1255 OID 294717)
-- Dependencies: 395 391 3
-- Name: _ltxtq_rexec(ltxtquery, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_rexec(ltxtquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_rexec';


--
-- TOC entry 47 (class 1255 OID 294718)
-- Dependencies: 3 553
-- Name: access_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 48 (class 1255 OID 294719)
-- Dependencies: 553 3
-- Name: access_insert_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 102 (class 1255 OID 294720)
-- Dependencies: 3 553
-- Name: access_update_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 49 (class 1255 OID 294721)
-- Dependencies: 3
-- Name: digest(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION digest(text, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_digest';


--
-- TOC entry 50 (class 1255 OID 294722)
-- Dependencies: 553 3
-- Name: fascicles_map_documents_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 51 (class 1255 OID 294723)
-- Dependencies: 553 3
-- Name: fascicles_map_documents_update_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 52 (class 1255 OID 294724)
-- Dependencies: 553 3
-- Name: fascicles_map_modules_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 53 (class 1255 OID 294725)
-- Dependencies: 553 3
-- Name: fascicles_map_modules_update_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 54 (class 1255 OID 294726)
-- Dependencies: 389 389 3
-- Name: index(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION index(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


--
-- TOC entry 55 (class 1255 OID 294727)
-- Dependencies: 389 389 3
-- Name: index(ltree, ltree, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION index(ltree, ltree, integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


--
-- TOC entry 56 (class 1255 OID 294728)
-- Dependencies: 389 391 3
-- Name: lca(ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree[]) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lca';


--
-- TOC entry 57 (class 1255 OID 294729)
-- Dependencies: 389 389 3 389
-- Name: lca(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 58 (class 1255 OID 294730)
-- Dependencies: 389 389 389 3 389
-- Name: lca(ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 59 (class 1255 OID 294731)
-- Dependencies: 389 389 389 389 389 3
-- Name: lca(ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 60 (class 1255 OID 294732)
-- Dependencies: 389 3 389 389 389 389 389
-- Name: lca(ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 61 (class 1255 OID 294733)
-- Dependencies: 389 3 389 389 389 389 389 389
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 62 (class 1255 OID 294734)
-- Dependencies: 3 389 389 389 389 389 389 389 389
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 63 (class 1255 OID 294735)
-- Dependencies: 389 389 389 389 389 389 389 389 389 3
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 64 (class 1255 OID 294736)
-- Dependencies: 3 388 389
-- Name: lt_q_regex(ltree, lquery[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lt_q_regex(ltree, lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_regex';


--
-- TOC entry 65 (class 1255 OID 294737)
-- Dependencies: 3 389 388
-- Name: lt_q_rregex(lquery[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lt_q_rregex(lquery[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_rregex';


--
-- TOC entry 66 (class 1255 OID 294738)
-- Dependencies: 389 386 3
-- Name: ltq_regex(ltree, lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltq_regex(ltree, lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_regex';


--
-- TOC entry 67 (class 1255 OID 294739)
-- Dependencies: 3 386 389
-- Name: ltq_rregex(lquery, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltq_rregex(lquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_rregex';


--
-- TOC entry 68 (class 1255 OID 294740)
-- Dependencies: 389 3
-- Name: ltree2text(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree2text(ltree) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree2text';


--
-- TOC entry 69 (class 1255 OID 294741)
-- Dependencies: 389 389 3 389
-- Name: ltree_addltree(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_addltree(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addltree';


--
-- TOC entry 70 (class 1255 OID 294742)
-- Dependencies: 389 3 389
-- Name: ltree_addtext(ltree, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_addtext(ltree, text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addtext';


--
-- TOC entry 71 (class 1255 OID 294743)
-- Dependencies: 3 389 389
-- Name: ltree_cmp(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_cmp(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_cmp';


--
-- TOC entry 72 (class 1255 OID 294744)
-- Dependencies: 3
-- Name: ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_compress';


--
-- TOC entry 73 (class 1255 OID 294745)
-- Dependencies: 3
-- Name: ltree_consistent(internal, internal, smallint, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_consistent(internal, internal, smallint, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_consistent';


--
-- TOC entry 74 (class 1255 OID 294746)
-- Dependencies: 3
-- Name: ltree_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_decompress';


--
-- TOC entry 75 (class 1255 OID 294747)
-- Dependencies: 3 389 389
-- Name: ltree_eq(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_eq(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_eq';


--
-- TOC entry 76 (class 1255 OID 294748)
-- Dependencies: 3 389 389
-- Name: ltree_ge(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_ge(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ge';


--
-- TOC entry 77 (class 1255 OID 294749)
-- Dependencies: 3 389 389
-- Name: ltree_gt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_gt';


--
-- TOC entry 78 (class 1255 OID 294750)
-- Dependencies: 389 389 3
-- Name: ltree_isparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_isparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_isparent';


--
-- TOC entry 79 (class 1255 OID 294751)
-- Dependencies: 3 389 389
-- Name: ltree_le(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_le(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_le';


--
-- TOC entry 80 (class 1255 OID 294752)
-- Dependencies: 3 389 389
-- Name: ltree_lt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_lt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_lt';


--
-- TOC entry 81 (class 1255 OID 294753)
-- Dependencies: 3 389 389
-- Name: ltree_ne(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_ne(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ne';


--
-- TOC entry 82 (class 1255 OID 294754)
-- Dependencies: 3
-- Name: ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_penalty';


--
-- TOC entry 83 (class 1255 OID 294755)
-- Dependencies: 3
-- Name: ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_picksplit';


--
-- TOC entry 84 (class 1255 OID 294756)
-- Dependencies: 3 389 389
-- Name: ltree_risparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_risparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_risparent';


--
-- TOC entry 85 (class 1255 OID 294757)
-- Dependencies: 3
-- Name: ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_same';


--
-- TOC entry 86 (class 1255 OID 294758)
-- Dependencies: 3 389 389
-- Name: ltree_textadd(text, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_textadd(text, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_textadd';


--
-- TOC entry 87 (class 1255 OID 294759)
-- Dependencies: 3
-- Name: ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_union(internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_union';


--
-- TOC entry 88 (class 1255 OID 294760)
-- Dependencies: 3
-- Name: ltreeparentsel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltreeparentsel(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltreeparentsel';


--
-- TOC entry 89 (class 1255 OID 294761)
-- Dependencies: 3 389 395
-- Name: ltxtq_exec(ltree, ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_exec(ltree, ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_exec';


--
-- TOC entry 90 (class 1255 OID 294762)
-- Dependencies: 3 395 389
-- Name: ltxtq_rexec(ltxtquery, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_rexec(ltxtquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_rexec';


--
-- TOC entry 91 (class 1255 OID 294763)
-- Dependencies: 3 389
-- Name: nlevel(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION nlevel(ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'nlevel';


--
-- TOC entry 101 (class 1255 OID 294764)
-- Dependencies: 3 553
-- Name: rules_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 92 (class 1255 OID 294765)
-- Dependencies: 553 3
-- Name: rules_insert_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 93 (class 1255 OID 294766)
-- Dependencies: 3 389 389
-- Name: subltree(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subltree(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subltree';


--
-- TOC entry 94 (class 1255 OID 294767)
-- Dependencies: 389 3 389
-- Name: subpath(ltree, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subpath(ltree, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


--
-- TOC entry 95 (class 1255 OID 294768)
-- Dependencies: 389 389 3
-- Name: subpath(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subpath(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


--
-- TOC entry 96 (class 1255 OID 294769)
-- Dependencies: 3 389
-- Name: text2ltree(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION text2ltree(text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'text2ltree';


--
-- TOC entry 97 (class 1255 OID 294770)
-- Dependencies: 553 3
-- Name: tree_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tree_delete_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    EXECUTE ' DELETE FROM ' || TG_TABLE_NAME || ' WHERE path ~ (''' || OLD.path::text || '.*{1}'')::lquery; ';
    RETURN OLD; 
END;
$$;


--
-- TOC entry 98 (class 1255 OID 294771)
-- Dependencies: 3 553
-- Name: tree_insert_before_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 99 (class 1255 OID 294772)
-- Dependencies: 553 3
-- Name: tree_update_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
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


--
-- TOC entry 100 (class 1255 OID 294773)
-- Dependencies: 3
-- Name: uuid_generate_v4(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION uuid_generate_v4() RETURNS uuid
    LANGUAGE c STRICT
    AS '$libdir/uuid-ossp', 'uuid_generate_v4';


--
-- TOC entry 1258 (class 2617 OID 294776)
-- Dependencies: 389 3 389 80
-- Name: <; Type: OPERATOR; Schema: public; Owner: -
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


--
-- TOC entry 1261 (class 2617 OID 294777)
-- Dependencies: 3 389 79 389
-- Name: <=; Type: OPERATOR; Schema: public; Owner: -
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


--
-- TOC entry 1259 (class 2617 OID 294779)
-- Dependencies: 3 389 389 81
-- Name: <>; Type: OPERATOR; Schema: public; Owner: -
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


--
-- TOC entry 1264 (class 2617 OID 294781)
-- Dependencies: 3 389 88 84 389
-- Name: <@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <@ (
    PROCEDURE = ltree_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = @>,
    RESTRICT = ltreeparentsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1266 (class 2617 OID 294783)
-- Dependencies: 389 3 391 39
-- Name: <@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <@ (
    PROCEDURE = _ltree_r_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1268 (class 2617 OID 294785)
-- Dependencies: 3 41 389 391
-- Name: <@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR <@ (
    PROCEDURE = _ltree_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = @>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1267 (class 2617 OID 294778)
-- Dependencies: 3 389 389 75
-- Name: =; Type: OPERATOR; Schema: public; Owner: -
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


--
-- TOC entry 1260 (class 2617 OID 294774)
-- Dependencies: 77 3 389 389
-- Name: >; Type: OPERATOR; Schema: public; Owner: -
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


--
-- TOC entry 1263 (class 2617 OID 294775)
-- Dependencies: 389 76 389 3
-- Name: >=; Type: OPERATOR; Schema: public; Owner: -
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


--
-- TOC entry 1272 (class 2617 OID 294786)
-- Dependencies: 64 388 3 389
-- Name: ?; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ? (
    PROCEDURE = lt_q_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery[],
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1270 (class 2617 OID 294787)
-- Dependencies: 65 389 388 3
-- Name: ?; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ? (
    PROCEDURE = lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree,
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1274 (class 2617 OID 294788)
-- Dependencies: 27 388 3 391
-- Name: ?; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ? (
    PROCEDURE = _lt_q_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery[],
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1273 (class 2617 OID 294789)
-- Dependencies: 3 391 28 388
-- Name: ?; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ? (
    PROCEDURE = _lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree[],
    COMMUTATOR = ?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1275 (class 2617 OID 294790)
-- Dependencies: 391 35 389 3 389
-- Name: ?<@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?<@ (
    PROCEDURE = _ltree_extract_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


--
-- TOC entry 1276 (class 2617 OID 294791)
-- Dependencies: 395 3 389 45 391
-- Name: ?@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?@ (
    PROCEDURE = _ltxtq_extract_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery
);


--
-- TOC entry 1277 (class 2617 OID 294792)
-- Dependencies: 389 3 389 391 34
-- Name: ?@>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?@> (
    PROCEDURE = _ltree_extract_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


--
-- TOC entry 1278 (class 2617 OID 294793)
-- Dependencies: 29 386 391 3 389
-- Name: ?~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?~ (
    PROCEDURE = _ltq_extract_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery
);


--
-- TOC entry 1281 (class 2617 OID 294794)
-- Dependencies: 395 389 3 89
-- Name: @; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @ (
    PROCEDURE = ltxtq_exec,
    LEFTARG = ltree,
    RIGHTARG = ltxtquery,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1279 (class 2617 OID 294795)
-- Dependencies: 90 3 395 389
-- Name: @; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @ (
    PROCEDURE = ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1283 (class 2617 OID 294796)
-- Dependencies: 395 391 44 3
-- Name: @; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @ (
    PROCEDURE = _ltxtq_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery,
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1282 (class 2617 OID 294797)
-- Dependencies: 395 46 391 3
-- Name: @; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @ (
    PROCEDURE = _ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree[],
    COMMUTATOR = @,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1262 (class 2617 OID 294780)
-- Dependencies: 389 88 78 3 389
-- Name: @>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @> (
    PROCEDURE = ltree_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = <@,
    RESTRICT = ltreeparentsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1265 (class 2617 OID 294782)
-- Dependencies: 3 389 36 391
-- Name: @>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @> (
    PROCEDURE = _ltree_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1284 (class 2617 OID 294784)
-- Dependencies: 389 40 391 3
-- Name: @>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR @> (
    PROCEDURE = _ltree_r_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = <@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1285 (class 2617 OID 294799)
-- Dependencies: 389 3 84 389
-- Name: ^<@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^<@ (
    PROCEDURE = ltree_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = ^@>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1287 (class 2617 OID 294801)
-- Dependencies: 3 39 391 389
-- Name: ^<@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^<@ (
    PROCEDURE = _ltree_r_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = ^@>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1288 (class 2617 OID 294803)
-- Dependencies: 389 3 41 391
-- Name: ^<@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^<@ (
    PROCEDURE = _ltree_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = ^@>,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1290 (class 2617 OID 294804)
-- Dependencies: 388 3 64 389
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^? (
    PROCEDURE = lt_q_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery[],
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1289 (class 2617 OID 294805)
-- Dependencies: 65 389 388 3
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^? (
    PROCEDURE = lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree,
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1293 (class 2617 OID 294806)
-- Dependencies: 3 27 388 391
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^? (
    PROCEDURE = _lt_q_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery[],
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1291 (class 2617 OID 294807)
-- Dependencies: 3 388 391 28
-- Name: ^?; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^? (
    PROCEDURE = _lt_q_rregex,
    LEFTARG = lquery[],
    RIGHTARG = ltree[],
    COMMUTATOR = ^?,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1295 (class 2617 OID 294808)
-- Dependencies: 389 89 3 395
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^@ (
    PROCEDURE = ltxtq_exec,
    LEFTARG = ltree,
    RIGHTARG = ltxtquery,
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1294 (class 2617 OID 294809)
-- Dependencies: 90 3 395 389
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^@ (
    PROCEDURE = ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree,
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1298 (class 2617 OID 294810)
-- Dependencies: 395 44 3 391
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^@ (
    PROCEDURE = _ltxtq_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery,
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1296 (class 2617 OID 294811)
-- Dependencies: 3 395 391 46
-- Name: ^@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^@ (
    PROCEDURE = _ltxtq_rexec,
    LEFTARG = ltxtquery,
    RIGHTARG = ltree[],
    COMMUTATOR = ^@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1299 (class 2617 OID 294798)
-- Dependencies: 3 389 389 78
-- Name: ^@>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^@> (
    PROCEDURE = ltree_isparent,
    LEFTARG = ltree,
    RIGHTARG = ltree,
    COMMUTATOR = ^<@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1269 (class 2617 OID 294800)
-- Dependencies: 36 3 389 391
-- Name: ^@>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^@> (
    PROCEDURE = _ltree_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree,
    COMMUTATOR = ^<@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1271 (class 2617 OID 294802)
-- Dependencies: 40 391 389 3
-- Name: ^@>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^@> (
    PROCEDURE = _ltree_r_risparent,
    LEFTARG = ltree,
    RIGHTARG = ltree[],
    COMMUTATOR = ^<@,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1286 (class 2617 OID 294812)
-- Dependencies: 3 66 386 389
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^~ (
    PROCEDURE = ltq_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery,
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1280 (class 2617 OID 294813)
-- Dependencies: 389 67 3 386
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^~ (
    PROCEDURE = ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree,
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1297 (class 2617 OID 294814)
-- Dependencies: 3 30 386 391
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^~ (
    PROCEDURE = _ltq_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery,
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1292 (class 2617 OID 294815)
-- Dependencies: 391 3 386 31
-- Name: ^~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ^~ (
    PROCEDURE = _ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree[],
    COMMUTATOR = ^~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1300 (class 2617 OID 294816)
-- Dependencies: 3 69 389 389 389
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addltree,
    LEFTARG = ltree,
    RIGHTARG = ltree
);


--
-- TOC entry 1301 (class 2617 OID 294817)
-- Dependencies: 3 389 70 389
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addtext,
    LEFTARG = ltree,
    RIGHTARG = text
);


--
-- TOC entry 1302 (class 2617 OID 294818)
-- Dependencies: 3 86 389 389
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_textadd,
    LEFTARG = text,
    RIGHTARG = ltree
);


--
-- TOC entry 1304 (class 2617 OID 294819)
-- Dependencies: 389 66 3 386
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = ltq_regex,
    LEFTARG = ltree,
    RIGHTARG = lquery,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1303 (class 2617 OID 294820)
-- Dependencies: 3 67 389 386
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1306 (class 2617 OID 294821)
-- Dependencies: 3 391 30 386
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = _ltq_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery,
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1305 (class 2617 OID 294822)
-- Dependencies: 3 386 391 31
-- Name: ~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ~ (
    PROCEDURE = _ltq_rregex,
    LEFTARG = lquery,
    RIGHTARG = ltree[],
    COMMUTATOR = ~,
    RESTRICT = contsel,
    JOIN = contjoinsel
);


--
-- TOC entry 1418 (class 2616 OID 294824)
-- Dependencies: 3 1527 391 392
-- Name: gist__ltree_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
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


--
-- TOC entry 1419 (class 2616 OID 294841)
-- Dependencies: 389 392 1528 3
-- Name: gist_ltree_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
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


--
-- TOC entry 1420 (class 2616 OID 294863)
-- Dependencies: 389 3 1529
-- Name: ltree_ops; Type: OPERATOR CLASS; Schema: public; Owner: -
--

CREATE OPERATOR CLASS ltree_ops
    DEFAULT FOR TYPE ltree USING btree AS
    OPERATOR 1 <(ltree,ltree) ,
    OPERATOR 2 <=(ltree,ltree) ,
    OPERATOR 3 =(ltree,ltree) ,
    OPERATOR 4 >=(ltree,ltree) ,
    OPERATOR 5 >(ltree,ltree) ,
    FUNCTION 1 ltree_cmp(ltree,ltree);


SET default_with_oids = false;

--
-- TOC entry 1795 (class 1259 OID 294870)
-- Dependencies: 2135 2136 2137 3
-- Name: ad_advertisers; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1796 (class 1259 OID 294879)
-- Dependencies: 1795 3
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ad_advertisers_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2452 (class 0 OID 0)
-- Dependencies: 1796
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ad_advertisers_serialnum_seq OWNED BY ad_advertisers.serialnum;


--
-- TOC entry 1797 (class 1259 OID 294881)
-- Dependencies: 2139 2140 2141 3
-- Name: ad_index; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1798 (class 1259 OID 294890)
-- Dependencies: 2142 2143 2144 2145 2146 2147 2148 2149 2150 3
-- Name: ad_modules; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1799 (class 1259 OID 294905)
-- Dependencies: 2151 2152 2153 2154 3
-- Name: ad_pages; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1800 (class 1259 OID 294915)
-- Dependencies: 2155 2156 2157 3
-- Name: ad_places; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ad_places (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


--
-- TOC entry 1801 (class 1259 OID 294924)
-- Dependencies: 2158 2159 2160 3
-- Name: ad_requests; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1802 (class 1259 OID 294933)
-- Dependencies: 3 1801
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ad_requests_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2453 (class 0 OID 0)
-- Dependencies: 1802
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ad_requests_serialnum_seq OWNED BY ad_requests.serialnum;


--
-- TOC entry 1803 (class 1259 OID 294935)
-- Dependencies: 2162 2163 2164 3
-- Name: branches; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1804 (class 1259 OID 294944)
-- Dependencies: 3 389
-- Name: cache_access; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_access (
    type character varying NOT NULL,
    path ltree,
    binding uuid NOT NULL,
    member uuid NOT NULL,
    terms text[]
);


--
-- TOC entry 1805 (class 1259 OID 294950)
-- Dependencies: 2165 2166 2167 3 389
-- Name: catalog; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1806 (class 1259 OID 294959)
-- Dependencies: 2168 2169 2170 389 3
-- Name: editions; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1807 (class 1259 OID 294968)
-- Dependencies: 2171 3
-- Name: map_member_to_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_member_to_rule (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    section character varying NOT NULL,
    area character varying NOT NULL,
    binding uuid NOT NULL,
    term uuid NOT NULL
);


--
-- TOC entry 1808 (class 1259 OID 294975)
-- Dependencies: 2172 2173 2174 3
-- Name: members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE members (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    login character varying NOT NULL,
    password character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1809 (class 1259 OID 294984)
-- Dependencies: 2175 2176 3
-- Name: rules; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1810 (class 1259 OID 294992)
-- Dependencies: 1938 389 3
-- Name: cache_rules; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cache_rules AS
    (SELECT 'edition' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(SELECT DISTINCT (((((a2.section)::text || '.'::text) || (a2.subsection)::text) || '.'::text) || (a2.term)::text) AS term FROM map_member_to_rule a1, rules a2 WHERE (((a2.id = a1.term) AND (a1.member = t2.id)) AND (a1.binding IN (SELECT editions.id FROM editions WHERE (editions.path @> t1.path))))) AS terms FROM editions t1, members t2 ORDER BY t1.path) UNION (SELECT 'catalog' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(SELECT DISTINCT (((((a2.section)::text || '.'::text) || (a2.subsection)::text) || '.'::text) || (a2.term)::text) AS term FROM map_member_to_rule a1, rules a2 WHERE (((a2.id = a1.term) AND (a1.member = t2.id)) AND (a1.binding IN (SELECT catalog.id FROM catalog WHERE (catalog.path @> t1.path))))) AS terms FROM catalog t1, members t2 ORDER BY t1.path);


--
-- TOC entry 1811 (class 1259 OID 294997)
-- Dependencies: 3
-- Name: cache_visibility; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_visibility (
    type character varying NOT NULL,
    member uuid NOT NULL,
    term character varying NOT NULL,
    termid uuid NOT NULL,
    parents uuid[],
    childrens uuid[]
);


--
-- TOC entry 1812 (class 1259 OID 295003)
-- Dependencies: 2177 2178 2179 389 3
-- Name: comments; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1813 (class 1259 OID 295012)
-- Dependencies: 2180 2181 2182 2183 2184 2185 2186 2187 2188 2189 2190 3
-- Name: documents; Type: TABLE; Schema: public; Owner: -
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
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1814 (class 1259 OID 295029)
-- Dependencies: 2191 2192 2193 3
-- Name: editions_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE editions_options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1815 (class 1259 OID 295038)
-- Dependencies: 2194 2195 2196 2197 3
-- Name: fascicles; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1816 (class 1259 OID 295047)
-- Dependencies: 2198 2199 2200 2201 3
-- Name: fascicles_indx_headlines; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1817 (class 1259 OID 295057)
-- Dependencies: 2202 2203 2204 2205 3
-- Name: fascicles_indx_rubrics; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1818 (class 1259 OID 295067)
-- Dependencies: 2206 2207 2208 3
-- Name: fascicles_map_documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1819 (class 1259 OID 295073)
-- Dependencies: 2209 2210 2211 2212 3
-- Name: fascicles_map_modules; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1820 (class 1259 OID 295083)
-- Dependencies: 2213 2214 2215 3
-- Name: fascicles_map_requests; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1821 (class 1259 OID 295089)
-- Dependencies: 2216 2217 2218 2219 2220 3
-- Name: fascicles_modules; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1822 (class 1259 OID 295100)
-- Dependencies: 2221 2222 2223 3
-- Name: fascicles_options; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1823 (class 1259 OID 295109)
-- Dependencies: 2224 2225 2226 3
-- Name: fascicles_pages; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1824 (class 1259 OID 295118)
-- Dependencies: 2227 2228 2229 2230 2231 2232 2233 2234 2235 3
-- Name: fascicles_requests; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1825 (class 1259 OID 295133)
-- Dependencies: 3 1824
-- Name: fascicles_requests_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fascicles_requests_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2454 (class 0 OID 0)
-- Dependencies: 1825
-- Name: fascicles_requests_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fascicles_requests_serialnum_seq OWNED BY fascicles_requests.serialnum;


--
-- TOC entry 1826 (class 1259 OID 295135)
-- Dependencies: 2237 2238 2239 3
-- Name: fascicles_tmpl_index; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1827 (class 1259 OID 295144)
-- Dependencies: 2240 2241 2242 2243 2244 2245 2246 2247 2248 3
-- Name: fascicles_tmpl_modules; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1828 (class 1259 OID 295159)
-- Dependencies: 2249 2250 2251 2252 3
-- Name: fascicles_tmpl_pages; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1829 (class 1259 OID 295169)
-- Dependencies: 2253 2254 2255 3
-- Name: fascicles_tmpl_places; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1830 (class 1259 OID 295178)
-- Dependencies: 2256 2257 3
-- Name: history; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1831 (class 1259 OID 295186)
-- Dependencies: 2258 2259 2260 2261 3
-- Name: indx_headlines; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1832 (class 1259 OID 295196)
-- Dependencies: 2262 2263 2264 2265 3
-- Name: indx_rubrics; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1833 (class 1259 OID 295206)
-- Dependencies: 2266 2267 2268 3
-- Name: indx_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE indx_tags (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    title character varying NOT NULL,
    description character varying,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1834 (class 1259 OID 295215)
-- Dependencies: 2269 2270 3
-- Name: logs; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1835 (class 1259 OID 295223)
-- Dependencies: 2271 3
-- Name: map_member_to_catalog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_member_to_catalog (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    catalog uuid NOT NULL
);


--
-- TOC entry 1836 (class 1259 OID 295227)
-- Dependencies: 2272 3
-- Name: map_principals_to_stages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_principals_to_stages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    stage uuid NOT NULL,
    catalog uuid NOT NULL,
    principal uuid NOT NULL
);


--
-- TOC entry 1837 (class 1259 OID 295231)
-- Dependencies: 3
-- Name: map_role_to_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_role_to_rule (
    role uuid NOT NULL,
    rule uuid NOT NULL,
    mode character varying NOT NULL
);


--
-- TOC entry 1838 (class 1259 OID 295237)
-- Dependencies: 2273 3
-- Name: migration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE migration (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    mtype character varying NOT NULL,
    oldid uuid NOT NULL,
    newid uuid NOT NULL
);


--
-- TOC entry 1839 (class 1259 OID 295244)
-- Dependencies: 2274 3
-- Name: options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying NOT NULL
);


--
-- TOC entry 1840 (class 1259 OID 295251)
-- Dependencies: 2275 2276 3
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1841 (class 1259 OID 295259)
-- Dependencies: 2277 2278 2279 3
-- Name: readiness; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1842 (class 1259 OID 295268)
-- Dependencies: 2280 2281 2282 3
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1851 (class 1259 OID 295607)
-- Dependencies: 2292 2293 2294 2295 3
-- Name: rss; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rss (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    document uuid NOT NULL,
    link character varying NOT NULL,
    title character varying NOT NULL,
    description character varying NOT NULL,
    fulltext character varying NOT NULL,
    published boolean DEFAULT false NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1843 (class 1259 OID 295277)
-- Dependencies: 2283 2284 2285 3
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sessions (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    ipaddress character varying NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL,
    updated timestamp with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1844 (class 1259 OID 295286)
-- Dependencies: 2286 2287 2288 3
-- Name: stages; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1845 (class 1259 OID 295295)
-- Dependencies: 2289 2290 2291 3
-- Name: state; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE state (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    param character varying NOT NULL,
    value character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1846 (class 1259 OID 295304)
-- Dependencies: 1939 3
-- Name: view_principals; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_principals AS
    SELECT t1.id, 'member' AS type, t2.title, t2.shortcut, t2.job_position AS description FROM members t1, profiles t2 WHERE (t1.id = t2.id) UNION SELECT catalog.id, 'group' AS type, catalog.title, catalog.shortcut, catalog.description FROM catalog;


--
-- TOC entry 1847 (class 1259 OID 295308)
-- Dependencies: 1940 3
-- Name: view_assignments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_assignments AS
    SELECT t1.id, t1.catalog, t5.shortcut AS catalog_shortcut, t6.type AS principal_type, t1.principal, t6.shortcut AS principal_shortcut, t2.id AS branch, t2.shortcut AS branch_shortcut, t1.stage, t3.shortcut AS stage_shortcut, t4.id AS readiness, t4.shortcut AS readiness_shortcut, t4.weight AS progress, t4.color FROM map_principals_to_stages t1, branches t2, stages t3, readiness t4, catalog t5, view_principals t6 WHERE (((((t2.id = t3.branch) AND (t3.id = t1.stage)) AND (t4.id = t3.readiness)) AND (t5.id = t1.catalog)) AND (t6.id = t1.principal));


--
-- TOC entry 1848 (class 1259 OID 295312)
-- Dependencies: 1941 3
-- Name: view_members; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_members AS
    SELECT t1.id, t1.login, t1.password, t2.title, t2.shortcut, t2.job_position, ARRAY(SELECT map_member_to_catalog.catalog FROM map_member_to_catalog WHERE (map_member_to_catalog.member = t1.id)) AS catalog FROM members t1, profiles t2 WHERE (t1.id = t2.id);


--
-- TOC entry 1849 (class 1259 OID 295316)
-- Dependencies: 1942 3
-- Name: view_rules; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_rules AS
    SELECT rules.id, rules.term, rules.section, rules.subsection, rules.icon, rules.title, rules.description, rules.sortorder, (((((rules.section)::text || '.'::text) || (rules.subsection)::text) || '.'::text) || (rules.term)::text) AS term_text FROM rules;


--
-- TOC entry 1850 (class 1259 OID 295320)
-- Dependencies: 1943 389 3
-- Name: view_rules_old; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_rules_old AS
    (SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, '00000000000000000000000000000000'::ltree AS path, ARRAY['00000000-0000-0000-0000-000000000000'::uuid] AS childrens FROM map_member_to_rule t1, rules t2 WHERE (((t1.section)::text = 'domain'::text) AND (t2.id = t1.term)) UNION SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, t3.path, ARRAY(SELECT catalog.id FROM catalog WHERE (catalog.path ~ (((t3.path)::text || '.*'::text))::lquery)) AS childrens FROM map_member_to_rule t1, rules t2, editions t3 WHERE ((((t1.section)::text = 'editions'::text) AND (t2.id = t1.term)) AND (t3.id = t1.binding))) UNION SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, t3.path, ARRAY(SELECT catalog.id FROM catalog WHERE (catalog.path ~ (((t3.path)::text || '.*'::text))::lquery)) AS childrens FROM map_member_to_rule t1, rules t2, catalog t3 WHERE ((((t1.section)::text = 'catalog'::text) AND (t2.id = t1.term)) AND (t3.id = t1.binding));


--
-- TOC entry 2138 (class 2604 OID 295325)
-- Dependencies: 1796 1795
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ad_advertisers ALTER COLUMN serialnum SET DEFAULT nextval('ad_advertisers_serialnum_seq'::regclass);


--
-- TOC entry 2161 (class 2604 OID 295326)
-- Dependencies: 1802 1801
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ad_requests ALTER COLUMN serialnum SET DEFAULT nextval('ad_requests_serialnum_seq'::regclass);


--
-- TOC entry 2236 (class 2604 OID 295327)
-- Dependencies: 1825 1824
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE fascicles_requests ALTER COLUMN serialnum SET DEFAULT nextval('fascicles_requests_serialnum_seq'::regclass);


--
-- TOC entry 2297 (class 2606 OID 295329)
-- Dependencies: 1795 1795
-- Name: ad_advertisers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_advertisers
    ADD CONSTRAINT ad_advertisers_pkey PRIMARY KEY (id);


--
-- TOC entry 2299 (class 2606 OID 295331)
-- Dependencies: 1797 1797
-- Name: ad_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_index
    ADD CONSTRAINT ad_index_pkey PRIMARY KEY (id);


--
-- TOC entry 2301 (class 2606 OID 295333)
-- Dependencies: 1798 1798
-- Name: ad_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_modules
    ADD CONSTRAINT ad_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2303 (class 2606 OID 295335)
-- Dependencies: 1799 1799
-- Name: ad_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_pages
    ADD CONSTRAINT ad_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 2305 (class 2606 OID 295337)
-- Dependencies: 1800 1800
-- Name: ad_places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_places
    ADD CONSTRAINT ad_places_pkey PRIMARY KEY (id);


--
-- TOC entry 2307 (class 2606 OID 295339)
-- Dependencies: 1801 1801
-- Name: ad_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_requests
    ADD CONSTRAINT ad_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 2311 (class 2606 OID 295341)
-- Dependencies: 1804 1804 1804 1804
-- Name: cache_access_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_access
    ADD CONSTRAINT cache_access_pkey PRIMARY KEY (type, member, binding);


--
-- TOC entry 2323 (class 2606 OID 295343)
-- Dependencies: 1811 1811 1811 1811
-- Name: cache_visibility_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_visibility
    ADD CONSTRAINT cache_visibility_pkey PRIMARY KEY (type, member, term);


--
-- TOC entry 2313 (class 2606 OID 295345)
-- Dependencies: 1805 1805
-- Name: catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY catalog
    ADD CONSTRAINT catalog_pkey PRIMARY KEY (id);


--
-- TOC entry 2309 (class 2606 OID 295347)
-- Dependencies: 1803 1803
-- Name: chains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY branches
    ADD CONSTRAINT chains_pkey PRIMARY KEY (id);


--
-- TOC entry 2325 (class 2606 OID 295349)
-- Dependencies: 1812 1812
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- TOC entry 2327 (class 2606 OID 295351)
-- Dependencies: 1813 1813
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- TOC entry 2329 (class 2606 OID 295353)
-- Dependencies: 1814 1814
-- Name: editions_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions_options
    ADD CONSTRAINT editions_options_pkey PRIMARY KEY (id);


--
-- TOC entry 2315 (class 2606 OID 295355)
-- Dependencies: 1806 1806
-- Name: editions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions
    ADD CONSTRAINT editions_pkey PRIMARY KEY (id);


--
-- TOC entry 2333 (class 2606 OID 371246)
-- Dependencies: 1816 1816 1816 1816
-- Name: fascicles_indx_headlines_edition_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_edition_key UNIQUE (edition, fascicle, tag);


--
-- TOC entry 2335 (class 2606 OID 295357)
-- Dependencies: 1816 1816
-- Name: fascicles_indx_headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_pkey PRIMARY KEY (id);


--
-- TOC entry 2337 (class 2606 OID 371248)
-- Dependencies: 1817 1817 1817 1817 1817
-- Name: fascicles_indx_rubrics_edition_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_edition_key UNIQUE (edition, fascicle, headline, tag);


--
-- TOC entry 2339 (class 2606 OID 295359)
-- Dependencies: 1817 1817
-- Name: fascicles_indx_rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_pkey PRIMARY KEY (id);


--
-- TOC entry 2341 (class 2606 OID 295361)
-- Dependencies: 1818 1818
-- Name: fascicles_map_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 2343 (class 2606 OID 295363)
-- Dependencies: 1819 1819
-- Name: fascicles_map_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2345 (class 2606 OID 295365)
-- Dependencies: 1820 1820
-- Name: fascicles_map_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_requests
    ADD CONSTRAINT fascicles_map_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 2347 (class 2606 OID 295367)
-- Dependencies: 1821 1821
-- Name: fascicles_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2349 (class 2606 OID 295369)
-- Dependencies: 1822 1822
-- Name: fascicles_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_options
    ADD CONSTRAINT fascicles_options_pkey PRIMARY KEY (id);


--
-- TOC entry 2351 (class 2606 OID 295371)
-- Dependencies: 1823 1823
-- Name: fascicles_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 2331 (class 2606 OID 295373)
-- Dependencies: 1815 1815
-- Name: fascicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_pkey PRIMARY KEY (id);


--
-- TOC entry 2354 (class 2606 OID 295375)
-- Dependencies: 1824 1824
-- Name: fascicles_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_requests
    ADD CONSTRAINT fascicles_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 2356 (class 2606 OID 295377)
-- Dependencies: 1826 1826
-- Name: fascicles_tmpl_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_index
    ADD CONSTRAINT fascicles_tmpl_index_pkey PRIMARY KEY (id);


--
-- TOC entry 2358 (class 2606 OID 295379)
-- Dependencies: 1827 1827
-- Name: fascicles_tmpl_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2360 (class 2606 OID 295381)
-- Dependencies: 1828 1828
-- Name: fascicles_tmpl_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_pages
    ADD CONSTRAINT fascicles_tmpl_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 2362 (class 2606 OID 295383)
-- Dependencies: 1829 1829
-- Name: fascicles_tmpl_places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_places
    ADD CONSTRAINT fascicles_tmpl_places_pkey PRIMARY KEY (id);


--
-- TOC entry 2364 (class 2606 OID 295385)
-- Dependencies: 1830 1830
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- TOC entry 2366 (class 2606 OID 371250)
-- Dependencies: 1831 1831 1831
-- Name: indx_headlines_edition_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_edition_key UNIQUE (edition, tag);


--
-- TOC entry 2368 (class 2606 OID 295387)
-- Dependencies: 1831 1831
-- Name: indx_headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_pkey PRIMARY KEY (id);


--
-- TOC entry 2370 (class 2606 OID 371252)
-- Dependencies: 1832 1832 1832 1832
-- Name: indx_rubrics_edition_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_edition_key UNIQUE (edition, headline, tag);


--
-- TOC entry 2372 (class 2606 OID 295389)
-- Dependencies: 1832 1832
-- Name: indx_rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_pkey PRIMARY KEY (id);


--
-- TOC entry 2374 (class 2606 OID 295391)
-- Dependencies: 1833 1833
-- Name: indx_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_tags
    ADD CONSTRAINT indx_tags_pkey PRIMARY KEY (id);


--
-- TOC entry 2376 (class 2606 OID 295393)
-- Dependencies: 1834 1834
-- Name: logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 2378 (class 2606 OID 295395)
-- Dependencies: 1835 1835 1835
-- Name: map_member_to_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_pkey PRIMARY KEY (member, catalog);


--
-- TOC entry 2317 (class 2606 OID 295397)
-- Dependencies: 1807 1807
-- Name: map_member_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_rule
    ADD CONSTRAINT map_member_to_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 2380 (class 2606 OID 295399)
-- Dependencies: 1836 1836 1836 1836
-- Name: map_principals_to_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_principals_to_stages
    ADD CONSTRAINT map_principals_to_stages_pkey PRIMARY KEY (id, stage, principal);


--
-- TOC entry 2382 (class 2606 OID 295401)
-- Dependencies: 1837 1837 1837 1837
-- Name: map_role_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_pkey PRIMARY KEY (role, rule, mode);


--
-- TOC entry 2319 (class 2606 OID 295403)
-- Dependencies: 1808 1808
-- Name: member_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY members
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- TOC entry 2388 (class 2606 OID 295405)
-- Dependencies: 1840 1840
-- Name: member_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT member_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 2394 (class 2606 OID 295407)
-- Dependencies: 1843 1843
-- Name: member_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT member_session_pkey PRIMARY KEY (id);


--
-- TOC entry 2384 (class 2606 OID 295409)
-- Dependencies: 1838 1838
-- Name: migration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY migration
    ADD CONSTRAINT migration_pkey PRIMARY KEY (id);


--
-- TOC entry 2386 (class 2606 OID 295411)
-- Dependencies: 1839 1839
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- TOC entry 2392 (class 2606 OID 295413)
-- Dependencies: 1842 1842
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 2400 (class 2606 OID 295618)
-- Dependencies: 1851 1851
-- Name: rss_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rss
    ADD CONSTRAINT rss_pkey PRIMARY KEY (id);


--
-- TOC entry 2321 (class 2606 OID 295415)
-- Dependencies: 1809 1809
-- Name: rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- TOC entry 2396 (class 2606 OID 295417)
-- Dependencies: 1844 1844
-- Name: stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- TOC entry 2398 (class 2606 OID 295419)
-- Dependencies: 1845 1845
-- Name: state_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- TOC entry 2390 (class 2606 OID 295421)
-- Dependencies: 1841 1841
-- Name: statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY readiness
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- TOC entry 2352 (class 1259 OID 295422)
-- Dependencies: 1823
-- Name: fki_; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_ ON fascicles_pages USING btree (origin);


--
-- TOC entry 2430 (class 2620 OID 295423)
-- Dependencies: 47 1805
-- Name: catalog_access_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_access_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_delete_after_trigger('catalog');


--
-- TOC entry 2431 (class 2620 OID 295424)
-- Dependencies: 48 1805
-- Name: catalog_access_insert_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_access_insert_after
    AFTER INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_insert_after_trigger('catalog');


--
-- TOC entry 2432 (class 2620 OID 295425)
-- Dependencies: 102 1805
-- Name: catalog_access_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_access_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_update_after_trigger('catalog');


--
-- TOC entry 2433 (class 2620 OID 295426)
-- Dependencies: 97 1805
-- Name: catalog_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- TOC entry 2434 (class 2620 OID 295427)
-- Dependencies: 1805 98
-- Name: catalog_insert_before; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_insert_before
    BEFORE INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- TOC entry 2435 (class 2620 OID 295428)
-- Dependencies: 1805 99
-- Name: catalog_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- TOC entry 2436 (class 2620 OID 295429)
-- Dependencies: 47 1806
-- Name: editions_access_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_access_delete_after
    AFTER DELETE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_delete_after_trigger('editions');


--
-- TOC entry 2437 (class 2620 OID 295430)
-- Dependencies: 1806 48
-- Name: editions_access_insert_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_access_insert_after
    AFTER INSERT ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_insert_after_trigger('editions');


--
-- TOC entry 2438 (class 2620 OID 295431)
-- Dependencies: 1806 102
-- Name: editions_access_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_access_update_after
    AFTER UPDATE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_update_after_trigger('editions');


--
-- TOC entry 2439 (class 2620 OID 295432)
-- Dependencies: 1806 97
-- Name: editions_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_delete_after
    AFTER DELETE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- TOC entry 2440 (class 2620 OID 295433)
-- Dependencies: 1806 98
-- Name: editions_insert_before; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_insert_before
    BEFORE INSERT ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- TOC entry 2441 (class 2620 OID 295434)
-- Dependencies: 1806 99
-- Name: editions_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_update_after
    AFTER UPDATE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- TOC entry 2444 (class 2620 OID 295435)
-- Dependencies: 50 1818
-- Name: fascicles_map_documents_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_documents_delete_after
    AFTER DELETE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_delete_after_trigger();


--
-- TOC entry 2445 (class 2620 OID 295436)
-- Dependencies: 51 1818
-- Name: fascicles_map_documents_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_documents_update_after
    AFTER INSERT OR UPDATE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_update_after_trigger();


--
-- TOC entry 2446 (class 2620 OID 295437)
-- Dependencies: 1819 52
-- Name: fascicles_map_modules_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_modules_delete_after
    AFTER DELETE ON fascicles_map_modules
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_modules_delete_after_trigger();


--
-- TOC entry 2447 (class 2620 OID 295438)
-- Dependencies: 1819 53
-- Name: fascicles_map_modules_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_modules_update_after
    AFTER INSERT OR UPDATE ON fascicles_map_modules
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_modules_update_after_trigger();


--
-- TOC entry 2442 (class 2620 OID 295439)
-- Dependencies: 1807 101
-- Name: rules_mapping_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER rules_mapping_delete_after
    AFTER DELETE ON map_member_to_rule
    FOR EACH ROW
    EXECUTE PROCEDURE rules_delete_after_trigger();


--
-- TOC entry 2443 (class 2620 OID 295440)
-- Dependencies: 1807 92
-- Name: rules_mapping_insert_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER rules_mapping_insert_after
    AFTER INSERT ON map_member_to_rule
    FOR EACH ROW
    EXECUTE PROCEDURE rules_insert_after_trigger();


--
-- TOC entry 2401 (class 2606 OID 295441)
-- Dependencies: 2318 1808 1804
-- Name: cache_access_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_access
    ADD CONSTRAINT cache_access_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2402 (class 2606 OID 295446)
-- Dependencies: 2314 1815 1806
-- Name: fascicles_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2403 (class 2606 OID 295451)
-- Dependencies: 1815 1816 2330
-- Name: fascicles_indx_headlines_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2404 (class 2606 OID 295456)
-- Dependencies: 1815 2330 1817
-- Name: fascicles_indx_rubrics_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2405 (class 2606 OID 295461)
-- Dependencies: 1817 2334 1816
-- Name: fascicles_indx_rubrics_headline_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_headline_fkey FOREIGN KEY (headline) REFERENCES fascicles_indx_headlines(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2406 (class 2606 OID 295466)
-- Dependencies: 1818 1813 2326
-- Name: fascicles_map_documents_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_entity_fkey FOREIGN KEY (entity) REFERENCES documents(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2407 (class 2606 OID 295471)
-- Dependencies: 1815 1818 2330
-- Name: fascicles_map_documents_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2408 (class 2606 OID 295476)
-- Dependencies: 1823 2350 1818
-- Name: fascicles_map_documents_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_page_fkey FOREIGN KEY (page) REFERENCES fascicles_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2409 (class 2606 OID 295481)
-- Dependencies: 1819 1815 2330
-- Name: fascicles_map_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2410 (class 2606 OID 295486)
-- Dependencies: 2346 1821 1819
-- Name: fascicles_map_modules_module_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_module_fkey FOREIGN KEY (module) REFERENCES fascicles_modules(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2411 (class 2606 OID 295491)
-- Dependencies: 1823 2350 1819
-- Name: fascicles_map_modules_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_page_fkey FOREIGN KEY (page) REFERENCES fascicles_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2412 (class 2606 OID 295496)
-- Dependencies: 1820 1815 2330
-- Name: fascicles_map_requests_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_requests
    ADD CONSTRAINT fascicles_map_requests_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2413 (class 2606 OID 295501)
-- Dependencies: 1821 1815 2330
-- Name: fascicles_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2414 (class 2606 OID 295506)
-- Dependencies: 1821 2357 1827
-- Name: fascicles_modules_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_origin_fkey FOREIGN KEY (origin) REFERENCES fascicles_tmpl_modules(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2415 (class 2606 OID 295511)
-- Dependencies: 2361 1821 1829
-- Name: fascicles_modules_place_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_place_fkey FOREIGN KEY (place) REFERENCES fascicles_tmpl_places(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2416 (class 2606 OID 295516)
-- Dependencies: 1822 1815 2330
-- Name: fascicles_options_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_options
    ADD CONSTRAINT fascicles_options_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2417 (class 2606 OID 295521)
-- Dependencies: 1815 2330 1823
-- Name: fascicles_pages_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2418 (class 2606 OID 295526)
-- Dependencies: 2359 1823 1828
-- Name: fascicles_pages_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_origin_fkey FOREIGN KEY (origin) REFERENCES fascicles_tmpl_pages(id) ON DELETE RESTRICT;


--
-- TOC entry 2419 (class 2606 OID 295531)
-- Dependencies: 1824 2330 1815
-- Name: fascicles_requests_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_requests
    ADD CONSTRAINT fascicles_requests_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2420 (class 2606 OID 295536)
-- Dependencies: 2330 1815 1826
-- Name: fascicles_tmpl_index_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_index
    ADD CONSTRAINT fascicles_tmpl_index_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2421 (class 2606 OID 295541)
-- Dependencies: 1827 2330 1815
-- Name: fascicles_tmpl_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2422 (class 2606 OID 295546)
-- Dependencies: 2359 1827 1828
-- Name: fascicles_tmpl_modules_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_page_fkey FOREIGN KEY (page) REFERENCES fascicles_tmpl_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2423 (class 2606 OID 295551)
-- Dependencies: 1815 2330 1828
-- Name: fascicles_tmpl_pages_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_pages
    ADD CONSTRAINT fascicles_tmpl_pages_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2424 (class 2606 OID 295556)
-- Dependencies: 2330 1829 1815
-- Name: fascicles_tmpl_places_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_places
    ADD CONSTRAINT fascicles_tmpl_places_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2425 (class 2606 OID 295561)
-- Dependencies: 2314 1831 1806
-- Name: indx_headlines_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2426 (class 2606 OID 295566)
-- Dependencies: 1806 1832 2314
-- Name: indx_rubrics_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2427 (class 2606 OID 295571)
-- Dependencies: 1832 2367 1831
-- Name: indx_rubrics_headline_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_headline_fkey FOREIGN KEY (headline) REFERENCES indx_headlines(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2428 (class 2606 OID 295576)
-- Dependencies: 1808 2318 1835
-- Name: map_member_to_catalog_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2429 (class 2606 OID 295581)
-- Dependencies: 2391 1837 1842
-- Name: map_role_to_rule_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_role_fkey FOREIGN KEY (role) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2011-01-20 17:20:16

--
-- PostgreSQL database dump complete
--

