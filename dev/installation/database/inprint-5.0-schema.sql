--
-- PostgreSQL database dump
--

-- Dumped from database version 8.4.5
-- Dumped by pg_dump version 9.0.1
-- Started on 2010-12-06 10:14:13

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 507 (class 2612 OID 16386)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- TOC entry 384 (class 0 OID 0)
-- Name: lquery; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE lquery;


--
-- TOC entry 8 (class 1255 OID 78145)
-- Dependencies: 3 384
-- Name: lquery_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lquery_in(cstring) RETURNS lquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_in';


--
-- TOC entry 20 (class 1255 OID 78146)
-- Dependencies: 3 384
-- Name: lquery_out(lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lquery_out(lquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_out';


--
-- TOC entry 383 (class 1247 OID 78144)
-- Dependencies: 3 8 20
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
-- TOC entry 387 (class 0 OID 0)
-- Name: ltree; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree;


--
-- TOC entry 21 (class 1255 OID 78149)
-- Dependencies: 3 387
-- Name: ltree_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_in(cstring) RETURNS ltree
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_in';


--
-- TOC entry 22 (class 1255 OID 78150)
-- Dependencies: 3 387
-- Name: ltree_out(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_out(ltree) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_out';


--
-- TOC entry 386 (class 1247 OID 78148)
-- Dependencies: 3 22 21
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
-- TOC entry 390 (class 0 OID 0)
-- Name: ltree_gist; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree_gist;


--
-- TOC entry 23 (class 1255 OID 78153)
-- Dependencies: 3 390
-- Name: ltree_gist_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gist_in(cstring) RETURNS ltree_gist
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_in';


--
-- TOC entry 24 (class 1255 OID 78154)
-- Dependencies: 3 390
-- Name: ltree_gist_out(ltree_gist); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gist_out(ltree_gist) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_out';


--
-- TOC entry 389 (class 1247 OID 78152)
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
-- TOC entry 393 (class 0 OID 0)
-- Name: ltxtquery; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltxtquery;


--
-- TOC entry 25 (class 1255 OID 78157)
-- Dependencies: 3 393
-- Name: ltxtq_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_in(cstring) RETURNS ltxtquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_in';


--
-- TOC entry 26 (class 1255 OID 78158)
-- Dependencies: 3 393
-- Name: ltxtq_out(ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_out(ltxtquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_out';


--
-- TOC entry 392 (class 1247 OID 78156)
-- Dependencies: 26 3 25
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
-- TOC entry 27 (class 1255 OID 78160)
-- Dependencies: 385 3 388
-- Name: _lt_q_regex(ltree[], lquery[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _lt_q_regex(ltree[], lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_regex';


--
-- TOC entry 28 (class 1255 OID 78161)
-- Dependencies: 388 3 385
-- Name: _lt_q_rregex(lquery[], ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _lt_q_rregex(lquery[], ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_rregex';


--
-- TOC entry 29 (class 1255 OID 78162)
-- Dependencies: 383 3 386 388
-- Name: _ltq_extract_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_extract_regex(ltree[], lquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_extract_regex';


--
-- TOC entry 30 (class 1255 OID 78163)
-- Dependencies: 388 3 383
-- Name: _ltq_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_regex(ltree[], lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_regex';


--
-- TOC entry 31 (class 1255 OID 78164)
-- Dependencies: 383 3 388
-- Name: _ltq_rregex(lquery, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_rregex(lquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_rregex';


--
-- TOC entry 32 (class 1255 OID 78165)
-- Dependencies: 3
-- Name: _ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_compress';


--
-- TOC entry 33 (class 1255 OID 78166)
-- Dependencies: 3
-- Name: _ltree_consistent(internal, internal, smallint, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_consistent(internal, internal, smallint, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_consistent';


--
-- TOC entry 34 (class 1255 OID 78167)
-- Dependencies: 388 3 386 386
-- Name: _ltree_extract_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_extract_isparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_isparent';


--
-- TOC entry 35 (class 1255 OID 78168)
-- Dependencies: 388 3 386 386
-- Name: _ltree_extract_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_extract_risparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_risparent';


--
-- TOC entry 36 (class 1255 OID 78169)
-- Dependencies: 388 3 386
-- Name: _ltree_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_isparent(ltree[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_isparent';


--
-- TOC entry 37 (class 1255 OID 78170)
-- Dependencies: 3
-- Name: _ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_penalty';


--
-- TOC entry 38 (class 1255 OID 78171)
-- Dependencies: 3
-- Name: _ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_picksplit';


--
-- TOC entry 39 (class 1255 OID 78172)
-- Dependencies: 386 3 388
-- Name: _ltree_r_isparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_r_isparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_isparent';


--
-- TOC entry 40 (class 1255 OID 78173)
-- Dependencies: 386 3 388
-- Name: _ltree_r_risparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_r_risparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_risparent';


--
-- TOC entry 41 (class 1255 OID 78174)
-- Dependencies: 388 3 386
-- Name: _ltree_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_risparent(ltree[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_risparent';


--
-- TOC entry 42 (class 1255 OID 78175)
-- Dependencies: 3
-- Name: _ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_same';


--
-- TOC entry 43 (class 1255 OID 78176)
-- Dependencies: 3
-- Name: _ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_union(internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_union';


--
-- TOC entry 44 (class 1255 OID 78177)
-- Dependencies: 388 392 3
-- Name: _ltxtq_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_exec(ltree[], ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_exec';


--
-- TOC entry 45 (class 1255 OID 78178)
-- Dependencies: 3 392 388 386
-- Name: _ltxtq_extract_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_extract_exec(ltree[], ltxtquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_extract_exec';


--
-- TOC entry 46 (class 1255 OID 78179)
-- Dependencies: 3 388 392
-- Name: _ltxtq_rexec(ltxtquery, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_rexec(ltxtquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_rexec';


--
-- TOC entry 94 (class 1255 OID 78746)
-- Dependencies: 507 3
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
-- TOC entry 95 (class 1255 OID 78745)
-- Dependencies: 3 507
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
-- TOC entry 99 (class 1255 OID 78744)
-- Dependencies: 507 3
-- Name: access_update_after_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION access_update_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    arg_type varchar; 
BEGIN
    arg_type := TG_ARGV[0];

    -- DELETE RULES FOR OLD POSITION

     EXECUTE ' DELETE FROM cache_access WHERE path ~ (''' || OLD.path::text || '.*'')::lquery; ';

    -- CREATE RULES FOR NEW POSITION

    IF arg_type = 'editions' THEN 
        EXECUTE '
            INSERT INTO cache_access
                SELECT ''editions'' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY( 
                    SELECT DISTINCT (((a2.section::text || ''.''::text) || a2.subsection::text) || ''.''::text) || a2.term::text AS term
                    FROM map_member_to_rule a1, rules a2
                    WHERE a2.id = a1.term AND a2.section = ''' ||arg_type|| ''' AND a1.member = t2.id AND (a1.binding IN ( SELECT id FROM editions WHERE path @> t1.path))
                ) AS terms
                FROM editions t1, members t2
                WHERE t1.path ~ (''' || NEW.path::text || '.*'')::lquery ORDER BY t1.path;';
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
                WHERE t1.path ~ (''' || NEW.path::text || '.*'')::lquery ORDER BY t1.path;';
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
-- TOC entry 47 (class 1255 OID 78183)
-- Dependencies: 3
-- Name: digest(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION digest(text, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_digest';


--
-- TOC entry 98 (class 1255 OID 144838)
-- Dependencies: 507 3
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
-- TOC entry 48 (class 1255 OID 78184)
-- Dependencies: 386 3 386
-- Name: index(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION index(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


--
-- TOC entry 49 (class 1255 OID 78185)
-- Dependencies: 386 3 386
-- Name: index(ltree, ltree, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION index(ltree, ltree, integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


--
-- TOC entry 50 (class 1255 OID 78186)
-- Dependencies: 386 3 388
-- Name: lca(ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree[]) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lca';


--
-- TOC entry 51 (class 1255 OID 78187)
-- Dependencies: 386 3 386 386
-- Name: lca(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 52 (class 1255 OID 78188)
-- Dependencies: 386 3 386 386 386
-- Name: lca(ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 53 (class 1255 OID 78189)
-- Dependencies: 386 3 386 386 386 386
-- Name: lca(ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 54 (class 1255 OID 78190)
-- Dependencies: 386 3 386 386 386 386 386
-- Name: lca(ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 55 (class 1255 OID 78191)
-- Dependencies: 3 386 386 386 386 386 386 386
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 56 (class 1255 OID 78192)
-- Dependencies: 386 386 3 386 386 386 386 386 386
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 57 (class 1255 OID 78193)
-- Dependencies: 386 3 386 386 386 386 386 386 386 386
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 58 (class 1255 OID 78194)
-- Dependencies: 386 3 385
-- Name: lt_q_regex(ltree, lquery[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lt_q_regex(ltree, lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_regex';


--
-- TOC entry 59 (class 1255 OID 78195)
-- Dependencies: 385 3 386
-- Name: lt_q_rregex(lquery[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lt_q_rregex(lquery[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_rregex';


--
-- TOC entry 60 (class 1255 OID 78196)
-- Dependencies: 3 383 386
-- Name: ltq_regex(ltree, lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltq_regex(ltree, lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_regex';


--
-- TOC entry 61 (class 1255 OID 78197)
-- Dependencies: 383 3 386
-- Name: ltq_rregex(lquery, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltq_rregex(lquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_rregex';


--
-- TOC entry 62 (class 1255 OID 78198)
-- Dependencies: 3 386
-- Name: ltree2text(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree2text(ltree) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree2text';


--
-- TOC entry 63 (class 1255 OID 78199)
-- Dependencies: 386 3 386 386
-- Name: ltree_addltree(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_addltree(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addltree';


--
-- TOC entry 64 (class 1255 OID 78200)
-- Dependencies: 386 3 386
-- Name: ltree_addtext(ltree, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_addtext(ltree, text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addtext';


--
-- TOC entry 65 (class 1255 OID 78201)
-- Dependencies: 386 3 386
-- Name: ltree_cmp(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_cmp(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_cmp';


--
-- TOC entry 66 (class 1255 OID 78202)
-- Dependencies: 3
-- Name: ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_compress';


--
-- TOC entry 67 (class 1255 OID 78203)
-- Dependencies: 3
-- Name: ltree_consistent(internal, internal, smallint, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_consistent(internal, internal, smallint, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_consistent';


--
-- TOC entry 68 (class 1255 OID 78204)
-- Dependencies: 3
-- Name: ltree_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_decompress';


--
-- TOC entry 69 (class 1255 OID 78205)
-- Dependencies: 386 3 386
-- Name: ltree_eq(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_eq(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_eq';


--
-- TOC entry 70 (class 1255 OID 78206)
-- Dependencies: 386 3 386
-- Name: ltree_ge(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_ge(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ge';


--
-- TOC entry 71 (class 1255 OID 78207)
-- Dependencies: 386 3 386
-- Name: ltree_gt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_gt';


--
-- TOC entry 72 (class 1255 OID 78208)
-- Dependencies: 386 3 386
-- Name: ltree_isparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_isparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_isparent';


--
-- TOC entry 73 (class 1255 OID 78209)
-- Dependencies: 386 3 386
-- Name: ltree_le(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_le(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_le';


--
-- TOC entry 74 (class 1255 OID 78210)
-- Dependencies: 386 3 386
-- Name: ltree_lt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_lt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_lt';


--
-- TOC entry 75 (class 1255 OID 78211)
-- Dependencies: 386 3 386
-- Name: ltree_ne(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_ne(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ne';


--
-- TOC entry 76 (class 1255 OID 78212)
-- Dependencies: 3
-- Name: ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_penalty';


--
-- TOC entry 77 (class 1255 OID 78213)
-- Dependencies: 3
-- Name: ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_picksplit';


--
-- TOC entry 78 (class 1255 OID 78214)
-- Dependencies: 386 386 3
-- Name: ltree_risparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_risparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_risparent';


--
-- TOC entry 79 (class 1255 OID 78215)
-- Dependencies: 3
-- Name: ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_same';


--
-- TOC entry 80 (class 1255 OID 78216)
-- Dependencies: 386 3 386
-- Name: ltree_textadd(text, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_textadd(text, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_textadd';


--
-- TOC entry 81 (class 1255 OID 78217)
-- Dependencies: 3
-- Name: ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_union(internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_union';


--
-- TOC entry 82 (class 1255 OID 78218)
-- Dependencies: 3
-- Name: ltreeparentsel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltreeparentsel(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltreeparentsel';


--
-- TOC entry 83 (class 1255 OID 78219)
-- Dependencies: 386 3 392
-- Name: ltxtq_exec(ltree, ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_exec(ltree, ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_exec';


--
-- TOC entry 84 (class 1255 OID 78220)
-- Dependencies: 392 386 3
-- Name: ltxtq_rexec(ltxtquery, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_rexec(ltxtquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_rexec';


--
-- TOC entry 85 (class 1255 OID 78221)
-- Dependencies: 3 386
-- Name: nlevel(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION nlevel(ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'nlevel';


--
-- TOC entry 97 (class 1255 OID 78769)
-- Dependencies: 3 507
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
        /*
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
        */
    END IF;

    IF OLD.section = 'catalog' THEN
        /*
        EXECUTE 'DELETE FROM cache_access WHERE type=''' ||OLD.section|| ''' AND member=''' ||OLD.member|| ''' AND path ~ (''' || arg_path::text || '.*'')::lquery ';
        EXECUTE 'DELETE FROM cache_visibility WHERE type=''' ||OLD.section|| ''' AND member=''' ||OLD.member|| ''' AND term LIKE ''' ||arg_term_name|| ':' ||OLD.area|| ''' ';
        
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
-- TOC entry 96 (class 1255 OID 78762)
-- Dependencies: 3 507
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
-- TOC entry 86 (class 1255 OID 78222)
-- Dependencies: 386 386 3
-- Name: subltree(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subltree(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subltree';


--
-- TOC entry 88 (class 1255 OID 78224)
-- Dependencies: 386 386 3
-- Name: subpath(ltree, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subpath(ltree, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


--
-- TOC entry 87 (class 1255 OID 78223)
-- Dependencies: 386 386 3
-- Name: subpath(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subpath(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


--
-- TOC entry 89 (class 1255 OID 78225)
-- Dependencies: 386 3
-- Name: text2ltree(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION text2ltree(text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'text2ltree';


--
-- TOC entry 90 (class 1255 OID 78226)
-- Dependencies: 3 507
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
-- TOC entry 91 (class 1255 OID 78227)
-- Dependencies: 3 507
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
-- TOC entry 92 (class 1255 OID 78228)
-- Dependencies: 507 3
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
-- TOC entry 93 (class 1255 OID 78229)
-- Dependencies: 3
-- Name: uuid_generate_v4(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION uuid_generate_v4() RETURNS uuid
    LANGUAGE c STRICT
    AS '$libdir/uuid-ossp', 'uuid_generate_v4';


--
-- TOC entry 1212 (class 2617 OID 78232)
-- Dependencies: 386 74 3 386
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
-- TOC entry 1215 (class 2617 OID 78233)
-- Dependencies: 386 386 73 3
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
-- TOC entry 1213 (class 2617 OID 78235)
-- Dependencies: 386 3 75 386
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
-- TOC entry 1218 (class 2617 OID 78237)
-- Dependencies: 3 386 386 78 82
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
-- TOC entry 1220 (class 2617 OID 78239)
-- Dependencies: 39 386 3 388
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
-- TOC entry 1222 (class 2617 OID 78241)
-- Dependencies: 41 3 388 386
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
-- TOC entry 1221 (class 2617 OID 78234)
-- Dependencies: 386 3 69 386
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
-- TOC entry 1214 (class 2617 OID 78230)
-- Dependencies: 386 3 71 386
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
-- TOC entry 1217 (class 2617 OID 78231)
-- Dependencies: 70 3 386 386
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
-- TOC entry 1226 (class 2617 OID 78242)
-- Dependencies: 58 385 3 386
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
-- TOC entry 1224 (class 2617 OID 78243)
-- Dependencies: 386 3 385 59
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
-- TOC entry 1228 (class 2617 OID 78244)
-- Dependencies: 27 385 388 3
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
-- TOC entry 1227 (class 2617 OID 78245)
-- Dependencies: 388 28 3 385
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
-- TOC entry 1229 (class 2617 OID 78246)
-- Dependencies: 388 3 386 35 386
-- Name: ?<@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?<@ (
    PROCEDURE = _ltree_extract_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


--
-- TOC entry 1230 (class 2617 OID 78247)
-- Dependencies: 392 3 386 45 388
-- Name: ?@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?@ (
    PROCEDURE = _ltxtq_extract_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery
);


--
-- TOC entry 1231 (class 2617 OID 78248)
-- Dependencies: 386 388 3 34 386
-- Name: ?@>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?@> (
    PROCEDURE = _ltree_extract_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


--
-- TOC entry 1232 (class 2617 OID 78249)
-- Dependencies: 383 388 3 386 29
-- Name: ?~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?~ (
    PROCEDURE = _ltq_extract_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery
);


--
-- TOC entry 1235 (class 2617 OID 78250)
-- Dependencies: 83 3 386 392
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
-- TOC entry 1233 (class 2617 OID 78251)
-- Dependencies: 392 3 84 386
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
-- TOC entry 1237 (class 2617 OID 78252)
-- Dependencies: 388 392 3 44
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
-- TOC entry 1236 (class 2617 OID 78253)
-- Dependencies: 388 392 3 46
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
-- TOC entry 1216 (class 2617 OID 78236)
-- Dependencies: 82 3 386 72 386
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
-- TOC entry 1219 (class 2617 OID 78238)
-- Dependencies: 3 388 36 386
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
-- TOC entry 1238 (class 2617 OID 78240)
-- Dependencies: 386 388 40 3
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
-- TOC entry 1239 (class 2617 OID 78255)
-- Dependencies: 78 386 3 386
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
-- TOC entry 1241 (class 2617 OID 78257)
-- Dependencies: 388 3 386 39
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
-- TOC entry 1242 (class 2617 OID 78259)
-- Dependencies: 386 41 3 388
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
-- TOC entry 1244 (class 2617 OID 78260)
-- Dependencies: 385 386 58 3
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
-- TOC entry 1243 (class 2617 OID 78261)
-- Dependencies: 386 385 3 59
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
-- TOC entry 1247 (class 2617 OID 78262)
-- Dependencies: 27 385 388 3
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
-- TOC entry 1245 (class 2617 OID 78263)
-- Dependencies: 385 388 28 3
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
-- TOC entry 1249 (class 2617 OID 78264)
-- Dependencies: 3 392 386 83
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
-- TOC entry 1248 (class 2617 OID 78265)
-- Dependencies: 392 84 386 3
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
-- TOC entry 1252 (class 2617 OID 78266)
-- Dependencies: 3 388 392 44
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
-- TOC entry 1250 (class 2617 OID 78267)
-- Dependencies: 3 392 388 46
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
-- TOC entry 1253 (class 2617 OID 78254)
-- Dependencies: 72 386 386 3
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
-- TOC entry 1223 (class 2617 OID 78256)
-- Dependencies: 388 36 386 3
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
-- TOC entry 1225 (class 2617 OID 78258)
-- Dependencies: 386 388 40 3
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
-- TOC entry 1240 (class 2617 OID 78268)
-- Dependencies: 3 386 60 383
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
-- TOC entry 1234 (class 2617 OID 78269)
-- Dependencies: 386 3 383 61
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
-- TOC entry 1251 (class 2617 OID 78270)
-- Dependencies: 30 3 388 383
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
-- TOC entry 1246 (class 2617 OID 78271)
-- Dependencies: 31 388 383 3
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
-- TOC entry 1254 (class 2617 OID 78272)
-- Dependencies: 386 3 386 386 63
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addltree,
    LEFTARG = ltree,
    RIGHTARG = ltree
);


--
-- TOC entry 1255 (class 2617 OID 78273)
-- Dependencies: 386 3 386 64
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addtext,
    LEFTARG = ltree,
    RIGHTARG = text
);


--
-- TOC entry 1256 (class 2617 OID 78274)
-- Dependencies: 3 386 386 80
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_textadd,
    LEFTARG = text,
    RIGHTARG = ltree
);


--
-- TOC entry 1258 (class 2617 OID 78275)
-- Dependencies: 386 60 383 3
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
-- TOC entry 1257 (class 2617 OID 78276)
-- Dependencies: 61 3 383 386
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
-- TOC entry 1260 (class 2617 OID 78277)
-- Dependencies: 383 3 388 30
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
-- TOC entry 1259 (class 2617 OID 78278)
-- Dependencies: 31 388 383 3
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
-- TOC entry 1372 (class 2616 OID 78280)
-- Dependencies: 389 388 1481 3
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
-- TOC entry 1373 (class 2616 OID 78297)
-- Dependencies: 389 386 1482 3
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
-- TOC entry 1374 (class 2616 OID 78319)
-- Dependencies: 1483 386 3
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
-- TOC entry 1781 (class 1259 OID 144768)
-- Dependencies: 2141 2143 2144 3
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
-- TOC entry 1780 (class 1259 OID 144766)
-- Dependencies: 3 1781
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ad_advertisers_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2268 (class 0 OID 0)
-- Dependencies: 1780
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ad_advertisers_serialnum_seq OWNED BY ad_advertisers.serialnum;


--
-- TOC entry 1779 (class 1259 OID 144749)
-- Dependencies: 2134 2135 2136 2137 2138 2139 2140 3
-- Name: ad_modules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ad_modules (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    place uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    amount integer DEFAULT 1 NOT NULL,
    volume double precision DEFAULT 0 NOT NULL,
    w integer DEFAULT 0 NOT NULL,
    h integer DEFAULT 0 NOT NULL,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


--
-- TOC entry 1778 (class 1259 OID 144738)
-- Dependencies: 2131 2132 2133 3
-- Name: ad_places; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ad_places (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


--
-- TOC entry 1783 (class 1259 OID 144796)
-- Dependencies: 2145 2147 2148 3
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
-- TOC entry 1782 (class 1259 OID 144794)
-- Dependencies: 3 1783
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ad_requests_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2269 (class 0 OID 0)
-- Dependencies: 1782
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ad_requests_serialnum_seq OWNED BY ad_requests.serialnum;


--
-- TOC entry 1749 (class 1259 OID 78326)
-- Dependencies: 2075 2076 2077 3
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
-- TOC entry 1768 (class 1259 OID 78891)
-- Dependencies: 3 386
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
-- TOC entry 1750 (class 1259 OID 78335)
-- Dependencies: 2078 2079 2080 386 3
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
-- TOC entry 1751 (class 1259 OID 78360)
-- Dependencies: 2081 2082 2083 386 3
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
-- TOC entry 1765 (class 1259 OID 78657)
-- Dependencies: 2110 3
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
-- TOC entry 1757 (class 1259 OID 78439)
-- Dependencies: 2090 2091 2092 3
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
-- TOC entry 1766 (class 1259 OID 78701)
-- Dependencies: 2111 2112 3
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
-- TOC entry 1767 (class 1259 OID 78720)
-- Dependencies: 1878 386 3
-- Name: cache_rules; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cache_rules AS
    (SELECT 'edition' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(SELECT DISTINCT (((((a2.section)::text || '.'::text) || (a2.subsection)::text) || '.'::text) || (a2.term)::text) AS term FROM map_member_to_rule a1, rules a2 WHERE (((a2.id = a1.term) AND (a1.member = t2.id)) AND (a1.binding IN (SELECT editions.id FROM editions WHERE (editions.path @> t1.path))))) AS terms FROM editions t1, members t2 ORDER BY t1.path) UNION (SELECT 'catalog' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(SELECT DISTINCT (((((a2.section)::text || '.'::text) || (a2.subsection)::text) || '.'::text) || (a2.term)::text) AS term FROM map_member_to_rule a1, rules a2 WHERE (((a2.id = a1.term) AND (a1.member = t2.id)) AND (a1.binding IN (SELECT catalog.id FROM catalog WHERE (catalog.path @> t1.path))))) AS terms FROM catalog t1, members t2 ORDER BY t1.path);


--
-- TOC entry 1769 (class 1259 OID 78920)
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
-- TOC entry 1784 (class 1259 OID 210063)
-- Dependencies: 2149 2150 2151 2152 2153 2154 2155 2156 2157 2158 2159 3
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
-- TOC entry 1785 (class 1259 OID 210088)
-- Dependencies: 2160 2161 2162 3
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
-- TOC entry 1791 (class 1259 OID 210181)
-- Dependencies: 2168 2169 2170 2171 2172 2173 3
-- Name: fascicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fascicles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    base_edition uuid NOT NULL,
    edition uuid NOT NULL,
    variation uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    manager uuid,
    begindate timestamp(6) with time zone,
    enddate timestamp(6) with time zone,
    is_system boolean DEFAULT false NOT NULL,
    is_enabled boolean DEFAULT false NOT NULL,
    is_blocked boolean DEFAULT false NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1774 (class 1259 OID 144476)
-- Dependencies: 2117 2118 2119 3
-- Name: fascicles_index; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fascicles_index (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    page uuid NOT NULL,
    headline uuid NOT NULL,
    place uuid NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1776 (class 1259 OID 144494)
-- Dependencies: 2125 2126 2127 3
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
-- TOC entry 1777 (class 1259 OID 144540)
-- Dependencies: 2128 2129 2130 3
-- Name: fascicles_map_holes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fascicles_map_holes (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    place uuid NOT NULL,
    module uuid NOT NULL,
    page uuid,
    entity uuid,
    x integer,
    y integer,
    h integer,
    w integer,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


--
-- TOC entry 1786 (class 1259 OID 210108)
-- Dependencies: 2163 2164 2165 3
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
-- TOC entry 1775 (class 1259 OID 144484)
-- Dependencies: 2120 2121 2122 2123 2124 3
-- Name: fascicles_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fascicles_pages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    headline uuid,
    place uuid,
    seqnum integer,
    w integer DEFAULT 0 NOT NULL,
    h integer DEFAULT 0 NOT NULL,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


--
-- TOC entry 1752 (class 1259 OID 78386)
-- Dependencies: 2084 2085 3
-- Name: history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE history (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    item uuid NOT NULL,
    color character varying,
    weight character varying,
    branch uuid NOT NULL,
    branch_shortcut character varying,
    stage uuid NOT NULL,
    stage_shortcut character varying,
    sender uuid NOT NULL,
    sender_shortcut character varying,
    sender_edition uuid NOT NULL,
    sender_edition_shortcut character varying,
    sender_catalog uuid NOT NULL,
    sender_catalog_shortcut character varying,
    receiver uuid NOT NULL,
    receiver_shortcut character varying,
    receiver_edition uuid NOT NULL,
    receiver_edition_shortcut character varying,
    receiver_catalog uuid NOT NULL,
    receiver_catalog_shortcut character varying,
    created timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1772 (class 1259 OID 78994)
-- Dependencies: 2113 2114 2115 3
-- Name: index; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE index (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    variation character varying NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1773 (class 1259 OID 79015)
-- Dependencies: 2116 3
-- Name: index_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE index_mapping (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    entity uuid NOT NULL,
    parent uuid NOT NULL,
    child uuid NOT NULL
);


--
-- TOC entry 1753 (class 1259 OID 78394)
-- Dependencies: 2086 2087 3
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
-- TOC entry 1754 (class 1259 OID 78418)
-- Dependencies: 2088 3
-- Name: map_member_to_catalog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_member_to_catalog (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    catalog uuid NOT NULL
);


--
-- TOC entry 1755 (class 1259 OID 78429)
-- Dependencies: 2089 3
-- Name: map_principals_to_stages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_principals_to_stages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    stage uuid NOT NULL,
    catalog uuid NOT NULL,
    principal uuid NOT NULL
);


--
-- TOC entry 1756 (class 1259 OID 78433)
-- Dependencies: 3
-- Name: map_role_to_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_role_to_rule (
    role uuid NOT NULL,
    rule uuid NOT NULL,
    mode character varying NOT NULL
);


--
-- TOC entry 1758 (class 1259 OID 78448)
-- Dependencies: 2093 3
-- Name: migration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE migration (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    mtype character varying NOT NULL,
    oldid uuid NOT NULL,
    newid uuid NOT NULL
);


--
-- TOC entry 1759 (class 1259 OID 78455)
-- Dependencies: 2094 3
-- Name: options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying NOT NULL
);


--
-- TOC entry 1787 (class 1259 OID 210157)
-- Dependencies: 2166 2167 3
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
-- TOC entry 1760 (class 1259 OID 78470)
-- Dependencies: 2095 2096 2097 3
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
-- TOC entry 1761 (class 1259 OID 78479)
-- Dependencies: 2098 2099 2100 3
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
-- TOC entry 1762 (class 1259 OID 78502)
-- Dependencies: 2101 2102 2103 3
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
-- TOC entry 1763 (class 1259 OID 78511)
-- Dependencies: 2104 2105 2106 3
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
-- TOC entry 1764 (class 1259 OID 78520)
-- Dependencies: 2107 2108 2109 3
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
-- TOC entry 1788 (class 1259 OID 210167)
-- Dependencies: 1881 3
-- Name: view_principals; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_principals AS
    SELECT t1.id, 'member' AS type, t2.title, t2.shortcut, t2.job_position AS description FROM members t1, profiles t2 WHERE (t1.id = t2.id) UNION SELECT catalog.id, 'group' AS type, catalog.title, catalog.shortcut, catalog.description FROM catalog;


--
-- TOC entry 1789 (class 1259 OID 210171)
-- Dependencies: 1882 3
-- Name: view_assignments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_assignments AS
    SELECT t1.id, t1.catalog, t5.shortcut AS catalog_shortcut, t6.type AS principal_type, t1.principal, t6.shortcut AS principal_shortcut, t2.id AS branch, t2.shortcut AS branch_shortcut, t1.stage, t3.shortcut AS stage_shortcut, t4.id AS readiness, t4.shortcut AS readiness_shortcut, t4.weight AS progress, t4.color FROM map_principals_to_stages t1, branches t2, stages t3, readiness t4, catalog t5, view_principals t6 WHERE (((((t2.id = t3.branch) AND (t3.id = t1.stage)) AND (t4.id = t3.readiness)) AND (t5.id = t1.catalog)) AND (t6.id = t1.principal));


--
-- TOC entry 1790 (class 1259 OID 210175)
-- Dependencies: 1883 3
-- Name: view_members; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_members AS
    SELECT t1.id, t1.login, t1.password, t2.title, t2.shortcut, t2.job_position, ARRAY(SELECT map_member_to_catalog.catalog FROM map_member_to_catalog WHERE (map_member_to_catalog.member = t1.id)) AS catalog FROM members t1, profiles t2 WHERE (t1.id = t2.id);


--
-- TOC entry 1771 (class 1259 OID 78933)
-- Dependencies: 1880 3
-- Name: view_rules; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_rules AS
    SELECT rules.id, rules.term, rules.section, rules.subsection, rules.icon, rules.title, rules.description, rules.sortorder, (((((rules.section)::text || '.'::text) || (rules.subsection)::text) || '.'::text) || (rules.term)::text) AS term_text FROM rules;


--
-- TOC entry 1770 (class 1259 OID 78928)
-- Dependencies: 1879 386 3
-- Name: view_rules_old; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_rules_old AS
    (SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, '00000000000000000000000000000000'::ltree AS path, ARRAY['00000000-0000-0000-0000-000000000000'::uuid] AS childrens FROM map_member_to_rule t1, rules t2 WHERE (((t1.section)::text = 'domain'::text) AND (t2.id = t1.term)) UNION SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, t3.path, ARRAY(SELECT catalog.id FROM catalog WHERE (catalog.path ~ (((t3.path)::text || '.*'::text))::lquery)) AS childrens FROM map_member_to_rule t1, rules t2, editions t3 WHERE ((((t1.section)::text = 'editions'::text) AND (t2.id = t1.term)) AND (t3.id = t1.binding))) UNION SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, t3.path, ARRAY(SELECT catalog.id FROM catalog WHERE (catalog.path ~ (((t3.path)::text || '.*'::text))::lquery)) AS childrens FROM map_member_to_rule t1, rules t2, catalog t3 WHERE ((((t1.section)::text = 'catalog'::text) AND (t2.id = t1.term)) AND (t3.id = t1.binding));


--
-- TOC entry 2142 (class 2604 OID 144772)
-- Dependencies: 1780 1781 1781
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ad_advertisers ALTER COLUMN serialnum SET DEFAULT nextval('ad_advertisers_serialnum_seq'::regclass);


--
-- TOC entry 2146 (class 2604 OID 144800)
-- Dependencies: 1783 1782 1783
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ad_requests ALTER COLUMN serialnum SET DEFAULT nextval('ad_requests_serialnum_seq'::regclass);


--
-- TOC entry 2233 (class 2606 OID 144779)
-- Dependencies: 1781 1781
-- Name: ad_advertisers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_advertisers
    ADD CONSTRAINT ad_advertisers_pkey PRIMARY KEY (id);


--
-- TOC entry 2231 (class 2606 OID 144763)
-- Dependencies: 1779 1779
-- Name: ad_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_modules
    ADD CONSTRAINT ad_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2229 (class 2606 OID 144748)
-- Dependencies: 1778 1778
-- Name: ad_places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_places
    ADD CONSTRAINT ad_places_pkey PRIMARY KEY (id);


--
-- TOC entry 2235 (class 2606 OID 144807)
-- Dependencies: 1783 1783
-- Name: ad_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_requests
    ADD CONSTRAINT ad_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 2211 (class 2606 OID 78898)
-- Dependencies: 1768 1768 1768 1768
-- Name: cache_access_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_access
    ADD CONSTRAINT cache_access_pkey PRIMARY KEY (type, member, binding);


--
-- TOC entry 2213 (class 2606 OID 78927)
-- Dependencies: 1769 1769 1769 1769
-- Name: cache_visibility_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_visibility
    ADD CONSTRAINT cache_visibility_pkey PRIMARY KEY (type, member, term);


--
-- TOC entry 2177 (class 2606 OID 78551)
-- Dependencies: 1750 1750
-- Name: catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY catalog
    ADD CONSTRAINT catalog_pkey PRIMARY KEY (id);


--
-- TOC entry 2175 (class 2606 OID 78553)
-- Dependencies: 1749 1749
-- Name: chains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY branches
    ADD CONSTRAINT chains_pkey PRIMARY KEY (id);


--
-- TOC entry 2237 (class 2606 OID 210081)
-- Dependencies: 1784 1784
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- TOC entry 2239 (class 2606 OID 210098)
-- Dependencies: 1785 1785
-- Name: editions_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions_options
    ADD CONSTRAINT editions_options_pkey PRIMARY KEY (id);


--
-- TOC entry 2179 (class 2606 OID 78557)
-- Dependencies: 1751 1751
-- Name: editions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions
    ADD CONSTRAINT editions_pkey PRIMARY KEY (id);


--
-- TOC entry 2221 (class 2606 OID 144483)
-- Dependencies: 1774 1774
-- Name: fascicles_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_index
    ADD CONSTRAINT fascicles_index_pkey PRIMARY KEY (id);


--
-- TOC entry 2225 (class 2606 OID 144501)
-- Dependencies: 1776 1776
-- Name: fascicles_map_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 2227 (class 2606 OID 144547)
-- Dependencies: 1777 1777
-- Name: fascicles_map_holes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_holes
    ADD CONSTRAINT fascicles_map_holes_pkey PRIMARY KEY (id);


--
-- TOC entry 2241 (class 2606 OID 210118)
-- Dependencies: 1786 1786
-- Name: fascicles_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_options
    ADD CONSTRAINT fascicles_options_pkey PRIMARY KEY (id);


--
-- TOC entry 2223 (class 2606 OID 144493)
-- Dependencies: 1775 1775
-- Name: fascicles_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 2245 (class 2606 OID 210194)
-- Dependencies: 1791 1791
-- Name: fascicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_pkey PRIMARY KEY (id);


--
-- TOC entry 2181 (class 2606 OID 78563)
-- Dependencies: 1752 1752
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- TOC entry 2217 (class 2606 OID 79026)
-- Dependencies: 1773 1773 1773 1773
-- Name: index_mapping_entity_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY index_mapping
    ADD CONSTRAINT index_mapping_entity_key UNIQUE (entity, parent, child);


--
-- TOC entry 2219 (class 2606 OID 79024)
-- Dependencies: 1773 1773
-- Name: index_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY index_mapping
    ADD CONSTRAINT index_mapping_pkey PRIMARY KEY (id);


--
-- TOC entry 2215 (class 2606 OID 79006)
-- Dependencies: 1772 1772 1772 1772
-- Name: index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY index
    ADD CONSTRAINT index_pkey PRIMARY KEY (id, edition, variation);


--
-- TOC entry 2183 (class 2606 OID 78565)
-- Dependencies: 1753 1753
-- Name: logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 2185 (class 2606 OID 78573)
-- Dependencies: 1754 1754 1754
-- Name: map_member_to_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_pkey PRIMARY KEY (member, catalog);


--
-- TOC entry 2207 (class 2606 OID 78665)
-- Dependencies: 1765 1765
-- Name: map_member_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_rule
    ADD CONSTRAINT map_member_to_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 2187 (class 2606 OID 78577)
-- Dependencies: 1755 1755 1755 1755
-- Name: map_principals_to_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_principals_to_stages
    ADD CONSTRAINT map_principals_to_stages_pkey PRIMARY KEY (id, stage, principal);


--
-- TOC entry 2189 (class 2606 OID 78579)
-- Dependencies: 1756 1756 1756 1756
-- Name: map_role_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_pkey PRIMARY KEY (role, rule, mode);


--
-- TOC entry 2191 (class 2606 OID 78583)
-- Dependencies: 1757 1757
-- Name: member_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY members
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- TOC entry 2243 (class 2606 OID 210166)
-- Dependencies: 1787 1787
-- Name: member_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT member_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 2201 (class 2606 OID 78585)
-- Dependencies: 1762 1762
-- Name: member_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT member_session_pkey PRIMARY KEY (id);


--
-- TOC entry 2193 (class 2606 OID 78587)
-- Dependencies: 1758 1758
-- Name: migration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY migration
    ADD CONSTRAINT migration_pkey PRIMARY KEY (id);


--
-- TOC entry 2195 (class 2606 OID 78589)
-- Dependencies: 1759 1759
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- TOC entry 2199 (class 2606 OID 78591)
-- Dependencies: 1761 1761
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 2209 (class 2606 OID 78710)
-- Dependencies: 1766 1766
-- Name: rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- TOC entry 2203 (class 2606 OID 78597)
-- Dependencies: 1763 1763
-- Name: stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- TOC entry 2205 (class 2606 OID 78599)
-- Dependencies: 1764 1764
-- Name: state_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- TOC entry 2197 (class 2606 OID 78601)
-- Dependencies: 1760 1760
-- Name: statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY readiness
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- TOC entry 2252 (class 2620 OID 78759)
-- Dependencies: 1750 94
-- Name: catalog_access_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_access_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_delete_after_trigger('catalog');


--
-- TOC entry 2253 (class 2620 OID 78760)
-- Dependencies: 1750 95
-- Name: catalog_access_insert_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_access_insert_after
    AFTER INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_insert_after_trigger('catalog');


--
-- TOC entry 2254 (class 2620 OID 78761)
-- Dependencies: 1750 99
-- Name: catalog_access_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_access_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_update_after_trigger('catalog');


--
-- TOC entry 2249 (class 2620 OID 78604)
-- Dependencies: 90 1750
-- Name: catalog_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- TOC entry 2250 (class 2620 OID 78605)
-- Dependencies: 1750 91
-- Name: catalog_insert_before; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_insert_before
    BEFORE INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- TOC entry 2251 (class 2620 OID 78606)
-- Dependencies: 92 1750
-- Name: catalog_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- TOC entry 2260 (class 2620 OID 78768)
-- Dependencies: 1751 94
-- Name: editions_access_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_access_delete_after
    AFTER DELETE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_delete_after_trigger('editions');


--
-- TOC entry 2259 (class 2620 OID 78766)
-- Dependencies: 95 1751
-- Name: editions_access_insert_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_access_insert_after
    AFTER INSERT ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_insert_after_trigger('editions');


--
-- TOC entry 2258 (class 2620 OID 78765)
-- Dependencies: 99 1751
-- Name: editions_access_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_access_update_after
    AFTER UPDATE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_update_after_trigger('editions');


--
-- TOC entry 2255 (class 2620 OID 78607)
-- Dependencies: 90 1751
-- Name: editions_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_delete_after
    AFTER DELETE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- TOC entry 2256 (class 2620 OID 78608)
-- Dependencies: 1751 91
-- Name: editions_insert_before; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_insert_before
    BEFORE INSERT ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- TOC entry 2257 (class 2620 OID 78609)
-- Dependencies: 92 1751
-- Name: editions_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_update_after
    AFTER UPDATE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- TOC entry 2263 (class 2620 OID 144843)
-- Dependencies: 98 1776
-- Name: fascicles_map_documents_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_documents_update_after
    AFTER INSERT OR UPDATE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_update_after_trigger();


--
-- TOC entry 2262 (class 2620 OID 78771)
-- Dependencies: 1765 97
-- Name: rules_mapping_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER rules_mapping_delete_after
    AFTER DELETE ON map_member_to_rule
    FOR EACH ROW
    EXECUTE PROCEDURE rules_delete_after_trigger();


--
-- TOC entry 2261 (class 2620 OID 78764)
-- Dependencies: 96 1765
-- Name: rules_mapping_insert_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER rules_mapping_insert_after
    AFTER INSERT ON map_member_to_rule
    FOR EACH ROW
    EXECUTE PROCEDURE rules_insert_after_trigger();


--
-- TOC entry 2248 (class 2606 OID 78899)
-- Dependencies: 1768 2190 1757
-- Name: cache_access_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_access
    ADD CONSTRAINT cache_access_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2246 (class 2606 OID 78610)
-- Dependencies: 2190 1754 1757
-- Name: map_member_to_catalog_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2247 (class 2606 OID 78615)
-- Dependencies: 1761 2198 1756
-- Name: map_role_to_rule_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_role_fkey FOREIGN KEY (role) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2010-12-06 10:14:14

--
-- PostgreSQL database dump complete
--

