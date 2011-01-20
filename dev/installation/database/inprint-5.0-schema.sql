--
-- PostgreSQL database dump
--

-- Dumped from database version 8.4.5
-- Dumped by pg_dump version 9.0.1
-- Started on 2010-12-23 01:24:18

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 535 (class 2612 OID 16386)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- TOC entry 385 (class 0 OID 0)
-- Name: lquery; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE lquery;


--
-- TOC entry 8 (class 1255 OID 78145)
-- Dependencies: 3 385
-- Name: lquery_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lquery_in(cstring) RETURNS lquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_in';


--
-- TOC entry 20 (class 1255 OID 78146)
-- Dependencies: 3 385
-- Name: lquery_out(lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lquery_out(lquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_out';


--
-- TOC entry 384 (class 1247 OID 78144)
-- Dependencies: 8 3 20
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
-- TOC entry 388 (class 0 OID 0)
-- Name: ltree; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree;


--
-- TOC entry 21 (class 1255 OID 78149)
-- Dependencies: 3 388
-- Name: ltree_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_in(cstring) RETURNS ltree
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_in';


--
-- TOC entry 22 (class 1255 OID 78150)
-- Dependencies: 3 388
-- Name: ltree_out(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_out(ltree) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_out';


--
-- TOC entry 387 (class 1247 OID 78148)
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
-- TOC entry 391 (class 0 OID 0)
-- Name: ltree_gist; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree_gist;


--
-- TOC entry 23 (class 1255 OID 78153)
-- Dependencies: 3 391
-- Name: ltree_gist_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gist_in(cstring) RETURNS ltree_gist
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_in';


--
-- TOC entry 24 (class 1255 OID 78154)
-- Dependencies: 3 391
-- Name: ltree_gist_out(ltree_gist); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gist_out(ltree_gist) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_out';


--
-- TOC entry 390 (class 1247 OID 78152)
-- Dependencies: 3 24 23
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
-- TOC entry 394 (class 0 OID 0)
-- Name: ltxtquery; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltxtquery;


--
-- TOC entry 25 (class 1255 OID 78157)
-- Dependencies: 3 394
-- Name: ltxtq_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_in(cstring) RETURNS ltxtquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_in';


--
-- TOC entry 26 (class 1255 OID 78158)
-- Dependencies: 3 394
-- Name: ltxtq_out(ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_out(ltxtquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_out';


--
-- TOC entry 393 (class 1247 OID 78156)
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
-- TOC entry 27 (class 1255 OID 78160)
-- Dependencies: 386 389 3
-- Name: _lt_q_regex(ltree[], lquery[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _lt_q_regex(ltree[], lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_regex';


--
-- TOC entry 28 (class 1255 OID 78161)
-- Dependencies: 386 389 3
-- Name: _lt_q_rregex(lquery[], ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _lt_q_rregex(lquery[], ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_rregex';


--
-- TOC entry 29 (class 1255 OID 78162)
-- Dependencies: 387 384 389 3
-- Name: _ltq_extract_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_extract_regex(ltree[], lquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_extract_regex';


--
-- TOC entry 30 (class 1255 OID 78163)
-- Dependencies: 3 389 384
-- Name: _ltq_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_regex(ltree[], lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_regex';


--
-- TOC entry 31 (class 1255 OID 78164)
-- Dependencies: 384 3 389
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
-- Dependencies: 387 389 387 3
-- Name: _ltree_extract_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_extract_isparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_isparent';


--
-- TOC entry 35 (class 1255 OID 78168)
-- Dependencies: 3 387 389 387
-- Name: _ltree_extract_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_extract_risparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_risparent';


--
-- TOC entry 36 (class 1255 OID 78169)
-- Dependencies: 389 387 3
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
-- Dependencies: 387 389 3
-- Name: _ltree_r_isparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_r_isparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_isparent';


--
-- TOC entry 40 (class 1255 OID 78173)
-- Dependencies: 389 387 3
-- Name: _ltree_r_risparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_r_risparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_risparent';


--
-- TOC entry 41 (class 1255 OID 78174)
-- Dependencies: 387 389 3
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
-- Dependencies: 3 393 389
-- Name: _ltxtq_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_exec(ltree[], ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_exec';


--
-- TOC entry 45 (class 1255 OID 78178)
-- Dependencies: 393 389 387 3
-- Name: _ltxtq_extract_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_extract_exec(ltree[], ltxtquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_extract_exec';


--
-- TOC entry 46 (class 1255 OID 78179)
-- Dependencies: 389 3 393
-- Name: _ltxtq_rexec(ltxtquery, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_rexec(ltxtquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_rexec';


--
-- TOC entry 94 (class 1255 OID 78746)
-- Dependencies: 535 3
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
-- Dependencies: 535 3
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
-- Dependencies: 3 535
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
-- TOC entry 100 (class 1255 OID 211311)
-- Dependencies: 535 3
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
-- TOC entry 98 (class 1255 OID 144838)
-- Dependencies: 3 535
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
-- Dependencies: 387 387 3
-- Name: index(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION index(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


--
-- TOC entry 49 (class 1255 OID 78185)
-- Dependencies: 3 387 387
-- Name: index(ltree, ltree, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION index(ltree, ltree, integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


--
-- TOC entry 50 (class 1255 OID 78186)
-- Dependencies: 389 387 3
-- Name: lca(ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree[]) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lca';


--
-- TOC entry 51 (class 1255 OID 78187)
-- Dependencies: 387 387 3 387
-- Name: lca(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 52 (class 1255 OID 78188)
-- Dependencies: 3 387 387 387 387
-- Name: lca(ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 53 (class 1255 OID 78189)
-- Dependencies: 3 387 387 387 387 387
-- Name: lca(ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 54 (class 1255 OID 78190)
-- Dependencies: 387 387 387 387 387 3 387
-- Name: lca(ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 55 (class 1255 OID 78191)
-- Dependencies: 387 387 3 387 387 387 387 387
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 56 (class 1255 OID 78192)
-- Dependencies: 387 3 387 387 387 387 387 387 387
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 57 (class 1255 OID 78193)
-- Dependencies: 387 3 387 387 387 387 387 387 387 387
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 58 (class 1255 OID 78194)
-- Dependencies: 3 387 386
-- Name: lt_q_regex(ltree, lquery[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lt_q_regex(ltree, lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_regex';


--
-- TOC entry 59 (class 1255 OID 78195)
-- Dependencies: 386 3 387
-- Name: lt_q_rregex(lquery[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lt_q_rregex(lquery[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_rregex';


--
-- TOC entry 60 (class 1255 OID 78196)
-- Dependencies: 384 387 3
-- Name: ltq_regex(ltree, lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltq_regex(ltree, lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_regex';


--
-- TOC entry 61 (class 1255 OID 78197)
-- Dependencies: 387 3 384
-- Name: ltq_rregex(lquery, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltq_rregex(lquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_rregex';


--
-- TOC entry 62 (class 1255 OID 78198)
-- Dependencies: 3 387
-- Name: ltree2text(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree2text(ltree) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree2text';


--
-- TOC entry 63 (class 1255 OID 78199)
-- Dependencies: 387 3 387 387
-- Name: ltree_addltree(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_addltree(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addltree';


--
-- TOC entry 64 (class 1255 OID 78200)
-- Dependencies: 387 387 3
-- Name: ltree_addtext(ltree, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_addtext(ltree, text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addtext';


--
-- TOC entry 65 (class 1255 OID 78201)
-- Dependencies: 3 387 387
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
-- Dependencies: 387 387 3
-- Name: ltree_eq(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_eq(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_eq';


--
-- TOC entry 70 (class 1255 OID 78206)
-- Dependencies: 387 3 387
-- Name: ltree_ge(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_ge(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ge';


--
-- TOC entry 71 (class 1255 OID 78207)
-- Dependencies: 387 3 387
-- Name: ltree_gt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_gt';


--
-- TOC entry 72 (class 1255 OID 78208)
-- Dependencies: 3 387 387
-- Name: ltree_isparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_isparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_isparent';


--
-- TOC entry 73 (class 1255 OID 78209)
-- Dependencies: 387 3 387
-- Name: ltree_le(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_le(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_le';


--
-- TOC entry 74 (class 1255 OID 78210)
-- Dependencies: 387 3 387
-- Name: ltree_lt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_lt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_lt';


--
-- TOC entry 75 (class 1255 OID 78211)
-- Dependencies: 387 3 387
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
-- Dependencies: 387 3 387
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
-- Dependencies: 3 387 387
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
-- Dependencies: 393 387 3
-- Name: ltxtq_exec(ltree, ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_exec(ltree, ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_exec';


--
-- TOC entry 84 (class 1255 OID 78220)
-- Dependencies: 3 387 393
-- Name: ltxtq_rexec(ltxtquery, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_rexec(ltxtquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_rexec';


--
-- TOC entry 85 (class 1255 OID 78221)
-- Dependencies: 3 387
-- Name: nlevel(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION nlevel(ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'nlevel';


--
-- TOC entry 97 (class 1255 OID 78769)
-- Dependencies: 535 3
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
-- Dependencies: 535 3
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
-- Dependencies: 387 3 387
-- Name: subltree(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subltree(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subltree';


--
-- TOC entry 88 (class 1255 OID 78224)
-- Dependencies: 3 387 387
-- Name: subpath(ltree, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subpath(ltree, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


--
-- TOC entry 87 (class 1255 OID 78223)
-- Dependencies: 3 387 387
-- Name: subpath(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subpath(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


--
-- TOC entry 89 (class 1255 OID 78225)
-- Dependencies: 3 387
-- Name: text2ltree(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION text2ltree(text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'text2ltree';


--
-- TOC entry 90 (class 1255 OID 78226)
-- Dependencies: 535 3
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
-- Dependencies: 3 535
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
-- Dependencies: 535 3
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
-- TOC entry 1240 (class 2617 OID 78232)
-- Dependencies: 387 3 74 387
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
-- TOC entry 1243 (class 2617 OID 78233)
-- Dependencies: 387 387 3 73
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
-- TOC entry 1241 (class 2617 OID 78235)
-- Dependencies: 75 387 3 387
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
-- TOC entry 1246 (class 2617 OID 78237)
-- Dependencies: 387 3 387 78 82
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
-- TOC entry 1248 (class 2617 OID 78239)
-- Dependencies: 39 3 387 389
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
-- TOC entry 1250 (class 2617 OID 78241)
-- Dependencies: 387 3 389 41
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
-- TOC entry 1249 (class 2617 OID 78234)
-- Dependencies: 69 387 3 387
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
-- TOC entry 1242 (class 2617 OID 78230)
-- Dependencies: 387 387 3 71
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
-- TOC entry 1245 (class 2617 OID 78231)
-- Dependencies: 70 387 3 387
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
-- TOC entry 1254 (class 2617 OID 78242)
-- Dependencies: 386 58 3 387
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
-- TOC entry 1252 (class 2617 OID 78243)
-- Dependencies: 3 59 387 386
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
-- TOC entry 1256 (class 2617 OID 78244)
-- Dependencies: 27 3 389 386
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
-- TOC entry 1255 (class 2617 OID 78245)
-- Dependencies: 389 28 3 386
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
-- TOC entry 1257 (class 2617 OID 78246)
-- Dependencies: 387 35 3 389 387
-- Name: ?<@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?<@ (
    PROCEDURE = _ltree_extract_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


--
-- TOC entry 1258 (class 2617 OID 78247)
-- Dependencies: 389 393 387 45 3
-- Name: ?@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?@ (
    PROCEDURE = _ltxtq_extract_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery
);


--
-- TOC entry 1259 (class 2617 OID 78248)
-- Dependencies: 389 387 34 3 387
-- Name: ?@>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?@> (
    PROCEDURE = _ltree_extract_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


--
-- TOC entry 1260 (class 2617 OID 78249)
-- Dependencies: 384 389 3 29 387
-- Name: ?~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?~ (
    PROCEDURE = _ltq_extract_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery
);


--
-- TOC entry 1263 (class 2617 OID 78250)
-- Dependencies: 83 3 387 393
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
-- TOC entry 1261 (class 2617 OID 78251)
-- Dependencies: 84 3 393 387
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
-- TOC entry 1265 (class 2617 OID 78252)
-- Dependencies: 393 44 389 3
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
-- TOC entry 1264 (class 2617 OID 78253)
-- Dependencies: 46 389 393 3
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
-- TOC entry 1244 (class 2617 OID 78236)
-- Dependencies: 387 3 82 72 387
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
-- TOC entry 1247 (class 2617 OID 78238)
-- Dependencies: 3 387 389 36
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
-- TOC entry 1266 (class 2617 OID 78240)
-- Dependencies: 389 3 387 40
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
-- TOC entry 1267 (class 2617 OID 78255)
-- Dependencies: 78 3 387 387
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
-- TOC entry 1269 (class 2617 OID 78257)
-- Dependencies: 39 3 387 389
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
-- TOC entry 1270 (class 2617 OID 78259)
-- Dependencies: 41 3 389 387
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
-- TOC entry 1272 (class 2617 OID 78260)
-- Dependencies: 58 3 387 386
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
-- TOC entry 1271 (class 2617 OID 78261)
-- Dependencies: 3 386 387 59
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
-- TOC entry 1275 (class 2617 OID 78262)
-- Dependencies: 27 3 389 386
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
-- TOC entry 1273 (class 2617 OID 78263)
-- Dependencies: 3 28 389 386
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
-- TOC entry 1277 (class 2617 OID 78264)
-- Dependencies: 83 3 387 393
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
-- TOC entry 1276 (class 2617 OID 78265)
-- Dependencies: 3 84 387 393
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
-- TOC entry 1280 (class 2617 OID 78266)
-- Dependencies: 393 44 3 389
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
-- TOC entry 1278 (class 2617 OID 78267)
-- Dependencies: 389 3 393 46
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
-- TOC entry 1281 (class 2617 OID 78254)
-- Dependencies: 387 72 387 3
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
-- TOC entry 1251 (class 2617 OID 78256)
-- Dependencies: 3 36 387 389
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
-- TOC entry 1253 (class 2617 OID 78258)
-- Dependencies: 387 3 389 40
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
-- TOC entry 1268 (class 2617 OID 78268)
-- Dependencies: 3 60 384 387
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
-- TOC entry 1262 (class 2617 OID 78269)
-- Dependencies: 387 384 3 61
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
-- TOC entry 1279 (class 2617 OID 78270)
-- Dependencies: 384 3 389 30
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
-- TOC entry 1274 (class 2617 OID 78271)
-- Dependencies: 389 31 3 384
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
-- TOC entry 1282 (class 2617 OID 78272)
-- Dependencies: 63 387 387 387 3
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addltree,
    LEFTARG = ltree,
    RIGHTARG = ltree
);


--
-- TOC entry 1283 (class 2617 OID 78273)
-- Dependencies: 387 64 387 3
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addtext,
    LEFTARG = ltree,
    RIGHTARG = text
);


--
-- TOC entry 1284 (class 2617 OID 78274)
-- Dependencies: 387 80 3 387
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_textadd,
    LEFTARG = text,
    RIGHTARG = ltree
);


--
-- TOC entry 1286 (class 2617 OID 78275)
-- Dependencies: 387 60 384 3
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
-- TOC entry 1285 (class 2617 OID 78276)
-- Dependencies: 61 384 3 387
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
-- TOC entry 1288 (class 2617 OID 78277)
-- Dependencies: 3 389 30 384
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
-- TOC entry 1287 (class 2617 OID 78278)
-- Dependencies: 384 3 389 31
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
-- TOC entry 1400 (class 2616 OID 78280)
-- Dependencies: 3 1509 389 390
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
-- TOC entry 1401 (class 2616 OID 78297)
-- Dependencies: 1510 390 387 3
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
-- TOC entry 1402 (class 2616 OID 78319)
-- Dependencies: 1511 387 3
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
-- TOC entry 1802 (class 1259 OID 144768)
-- Dependencies: 2153 2155 2156 3
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
-- TOC entry 1801 (class 1259 OID 144766)
-- Dependencies: 1802 3
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ad_advertisers_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2365 (class 0 OID 0)
-- Dependencies: 1801
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ad_advertisers_serialnum_seq OWNED BY ad_advertisers.serialnum;


--
-- TOC entry 1822 (class 1259 OID 211738)
-- Dependencies: 2224 2225 2226 3
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
-- TOC entry 1817 (class 1259 OID 211411)
-- Dependencies: 2197 2198 2199 2200 2201 2202 2203 2204 2205 3
-- Name: ad_modules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ad_modules (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    page uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
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
-- TOC entry 1825 (class 1259 OID 211772)
-- Dependencies: 2234 2235 2236 2237 3
-- Name: ad_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ad_pages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    bydefault boolean DEFAULT false NOT NULL,
    w character varying[],
    h character varying[],
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


--
-- TOC entry 1818 (class 1259 OID 211428)
-- Dependencies: 2206 2207 2208 3
-- Name: ad_places; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ad_places (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


--
-- TOC entry 1804 (class 1259 OID 144796)
-- Dependencies: 2157 2159 2160 3
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
-- TOC entry 1803 (class 1259 OID 144794)
-- Dependencies: 1804 3
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ad_requests_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2366 (class 0 OID 0)
-- Dependencies: 1803
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ad_requests_serialnum_seq OWNED BY ad_requests.serialnum;


--
-- TOC entry 1777 (class 1259 OID 78326)
-- Dependencies: 2111 2112 2113 3
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
-- TOC entry 1795 (class 1259 OID 78891)
-- Dependencies: 3 387
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
-- TOC entry 1778 (class 1259 OID 78335)
-- Dependencies: 2114 2115 2116 387 3
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
-- TOC entry 1779 (class 1259 OID 78360)
-- Dependencies: 2117 2118 2119 387 3
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
-- TOC entry 1792 (class 1259 OID 78657)
-- Dependencies: 2144 3
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
-- TOC entry 1784 (class 1259 OID 78439)
-- Dependencies: 2124 2125 2126 3
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
-- TOC entry 1793 (class 1259 OID 78701)
-- Dependencies: 2145 2146 3
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
-- TOC entry 1794 (class 1259 OID 78720)
-- Dependencies: 1914 3 387
-- Name: cache_rules; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cache_rules AS
    (SELECT 'edition' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(SELECT DISTINCT (((((a2.section)::text || '.'::text) || (a2.subsection)::text) || '.'::text) || (a2.term)::text) AS term FROM map_member_to_rule a1, rules a2 WHERE (((a2.id = a1.term) AND (a1.member = t2.id)) AND (a1.binding IN (SELECT editions.id FROM editions WHERE (editions.path @> t1.path))))) AS terms FROM editions t1, members t2 ORDER BY t1.path) UNION (SELECT 'catalog' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(SELECT DISTINCT (((((a2.section)::text || '.'::text) || (a2.subsection)::text) || '.'::text) || (a2.term)::text) AS term FROM map_member_to_rule a1, rules a2 WHERE (((a2.id = a1.term) AND (a1.member = t2.id)) AND (a1.binding IN (SELECT catalog.id FROM catalog WHERE (catalog.path @> t1.path))))) AS terms FROM catalog t1, members t2 ORDER BY t1.path);


--
-- TOC entry 1796 (class 1259 OID 78920)
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
-- TOC entry 1816 (class 1259 OID 211300)
-- Dependencies: 2194 2195 2196 387 3
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
-- TOC entry 1805 (class 1259 OID 210063)
-- Dependencies: 2161 2162 2163 2164 2165 2166 2167 2168 2169 2170 2171 3
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
-- TOC entry 1806 (class 1259 OID 210088)
-- Dependencies: 2172 2173 2174 3
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
-- TOC entry 1812 (class 1259 OID 210181)
-- Dependencies: 2180 2181 2182 2183 2184 2185 3
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
-- TOC entry 1799 (class 1259 OID 144476)
-- Dependencies: 2147 2148 2149 3
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
-- TOC entry 1800 (class 1259 OID 144494)
-- Dependencies: 2150 2151 2152 3
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
-- TOC entry 1826 (class 1259 OID 211784)
-- Dependencies: 2238 2239 2240 2241 3
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
-- TOC entry 1827 (class 1259 OID 211796)
-- Dependencies: 2242 2243 2244 2245 2246 3
-- Name: fascicles_modules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fascicles_modules (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    place uuid NOT NULL,
    origin uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    amount integer DEFAULT 1 NOT NULL,
    w character varying,
    h character varying,
    area double precision DEFAULT 0 NOT NULL,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


--
-- TOC entry 1807 (class 1259 OID 210108)
-- Dependencies: 2175 2176 2177 3
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
-- TOC entry 1821 (class 1259 OID 211631)
-- Dependencies: 2221 2222 2223 3
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
-- TOC entry 1823 (class 1259 OID 211749)
-- Dependencies: 2227 2228 2229 3
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
-- TOC entry 1820 (class 1259 OID 211611)
-- Dependencies: 2212 2213 2214 2215 2216 2217 2218 2219 2220 3
-- Name: fascicles_tmpl_modules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fascicles_tmpl_modules (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    origin uuid NOT NULL,
    fascicle uuid NOT NULL,
    page uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
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
-- TOC entry 1824 (class 1259 OID 211760)
-- Dependencies: 2230 2231 2232 2233 3
-- Name: fascicles_tmpl_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fascicles_tmpl_pages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    origin uuid NOT NULL,
    fascicle uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    bydefault boolean DEFAULT false NOT NULL,
    w character varying[],
    h character varying[],
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


--
-- TOC entry 1819 (class 1259 OID 211589)
-- Dependencies: 2209 2210 2211 3
-- Name: fascicles_tmpl_places; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fascicles_tmpl_places (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    origin uuid NOT NULL,
    fascicle uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    created timestamp(0) with time zone DEFAULT now(),
    updated timestamp(0) with time zone DEFAULT now()
);


--
-- TOC entry 1815 (class 1259 OID 211290)
-- Dependencies: 2192 2193 3
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
-- TOC entry 1813 (class 1259 OID 210251)
-- Dependencies: 2186 2187 2188 3
-- Name: index; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE index (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    nature character varying NOT NULL,
    parent uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1814 (class 1259 OID 210262)
-- Dependencies: 2189 2190 2191 3
-- Name: index_fascicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE index_fascicles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    fascicle uuid NOT NULL,
    origin uuid NOT NULL,
    nature character varying NOT NULL,
    parent uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1780 (class 1259 OID 78394)
-- Dependencies: 2120 2121 3
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
-- TOC entry 1781 (class 1259 OID 78418)
-- Dependencies: 2122 3
-- Name: map_member_to_catalog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_member_to_catalog (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    catalog uuid NOT NULL
);


--
-- TOC entry 1782 (class 1259 OID 78429)
-- Dependencies: 2123 3
-- Name: map_principals_to_stages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_principals_to_stages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    stage uuid NOT NULL,
    catalog uuid NOT NULL,
    principal uuid NOT NULL
);


--
-- TOC entry 1783 (class 1259 OID 78433)
-- Dependencies: 3
-- Name: map_role_to_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_role_to_rule (
    role uuid NOT NULL,
    rule uuid NOT NULL,
    mode character varying NOT NULL
);


--
-- TOC entry 1785 (class 1259 OID 78448)
-- Dependencies: 2127 3
-- Name: migration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE migration (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    mtype character varying NOT NULL,
    oldid uuid NOT NULL,
    newid uuid NOT NULL
);


--
-- TOC entry 1786 (class 1259 OID 78455)
-- Dependencies: 2128 3
-- Name: options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying NOT NULL
);


--
-- TOC entry 1808 (class 1259 OID 210157)
-- Dependencies: 2178 2179 3
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
-- TOC entry 1787 (class 1259 OID 78470)
-- Dependencies: 2129 2130 2131 3
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
-- TOC entry 1788 (class 1259 OID 78479)
-- Dependencies: 2132 2133 2134 3
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
-- TOC entry 1789 (class 1259 OID 78502)
-- Dependencies: 2135 2136 2137 3
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
-- TOC entry 1790 (class 1259 OID 78511)
-- Dependencies: 2138 2139 2140 3
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
-- TOC entry 1791 (class 1259 OID 78520)
-- Dependencies: 2141 2142 2143 3
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
-- TOC entry 1809 (class 1259 OID 210167)
-- Dependencies: 1917 3
-- Name: view_principals; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_principals AS
    SELECT t1.id, 'member' AS type, t2.title, t2.shortcut, t2.job_position AS description FROM members t1, profiles t2 WHERE (t1.id = t2.id) UNION SELECT catalog.id, 'group' AS type, catalog.title, catalog.shortcut, catalog.description FROM catalog;


--
-- TOC entry 1810 (class 1259 OID 210171)
-- Dependencies: 1918 3
-- Name: view_assignments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_assignments AS
    SELECT t1.id, t1.catalog, t5.shortcut AS catalog_shortcut, t6.type AS principal_type, t1.principal, t6.shortcut AS principal_shortcut, t2.id AS branch, t2.shortcut AS branch_shortcut, t1.stage, t3.shortcut AS stage_shortcut, t4.id AS readiness, t4.shortcut AS readiness_shortcut, t4.weight AS progress, t4.color FROM map_principals_to_stages t1, branches t2, stages t3, readiness t4, catalog t5, view_principals t6 WHERE (((((t2.id = t3.branch) AND (t3.id = t1.stage)) AND (t4.id = t3.readiness)) AND (t5.id = t1.catalog)) AND (t6.id = t1.principal));


--
-- TOC entry 1811 (class 1259 OID 210175)
-- Dependencies: 1919 3
-- Name: view_members; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_members AS
    SELECT t1.id, t1.login, t1.password, t2.title, t2.shortcut, t2.job_position, ARRAY(SELECT map_member_to_catalog.catalog FROM map_member_to_catalog WHERE (map_member_to_catalog.member = t1.id)) AS catalog FROM members t1, profiles t2 WHERE (t1.id = t2.id);


--
-- TOC entry 1798 (class 1259 OID 78933)
-- Dependencies: 1916 3
-- Name: view_rules; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_rules AS
    SELECT rules.id, rules.term, rules.section, rules.subsection, rules.icon, rules.title, rules.description, rules.sortorder, (((((rules.section)::text || '.'::text) || (rules.subsection)::text) || '.'::text) || (rules.term)::text) AS term_text FROM rules;


--
-- TOC entry 1797 (class 1259 OID 78928)
-- Dependencies: 1915 387 3
-- Name: view_rules_old; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_rules_old AS
    (SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, '00000000000000000000000000000000'::ltree AS path, ARRAY['00000000-0000-0000-0000-000000000000'::uuid] AS childrens FROM map_member_to_rule t1, rules t2 WHERE (((t1.section)::text = 'domain'::text) AND (t2.id = t1.term)) UNION SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, t3.path, ARRAY(SELECT catalog.id FROM catalog WHERE (catalog.path ~ (((t3.path)::text || '.*'::text))::lquery)) AS childrens FROM map_member_to_rule t1, rules t2, editions t3 WHERE ((((t1.section)::text = 'editions'::text) AND (t2.id = t1.term)) AND (t3.id = t1.binding))) UNION SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, t3.path, ARRAY(SELECT catalog.id FROM catalog WHERE (catalog.path ~ (((t3.path)::text || '.*'::text))::lquery)) AS childrens FROM map_member_to_rule t1, rules t2, catalog t3 WHERE ((((t1.section)::text = 'catalog'::text) AND (t2.id = t1.term)) AND (t3.id = t1.binding));


--
-- TOC entry 2154 (class 2604 OID 144772)
-- Dependencies: 1801 1802 1802
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ad_advertisers ALTER COLUMN serialnum SET DEFAULT nextval('ad_advertisers_serialnum_seq'::regclass);


--
-- TOC entry 2158 (class 2604 OID 144800)
-- Dependencies: 1803 1804 1804
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ad_requests ALTER COLUMN serialnum SET DEFAULT nextval('ad_requests_serialnum_seq'::regclass);


--
-- TOC entry 2290 (class 2606 OID 144779)
-- Dependencies: 1802 1802
-- Name: ad_advertisers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_advertisers
    ADD CONSTRAINT ad_advertisers_pkey PRIMARY KEY (id);


--
-- TOC entry 2323 (class 2606 OID 211748)
-- Dependencies: 1822 1822
-- Name: ad_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_index
    ADD CONSTRAINT ad_index_pkey PRIMARY KEY (id);


--
-- TOC entry 2312 (class 2606 OID 211427)
-- Dependencies: 1817 1817
-- Name: ad_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_modules
    ADD CONSTRAINT ad_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2329 (class 2606 OID 211783)
-- Dependencies: 1825 1825
-- Name: ad_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_pages
    ADD CONSTRAINT ad_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 2314 (class 2606 OID 211438)
-- Dependencies: 1818 1818
-- Name: ad_places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_places
    ADD CONSTRAINT ad_places_pkey PRIMARY KEY (id);


--
-- TOC entry 2292 (class 2606 OID 144807)
-- Dependencies: 1804 1804
-- Name: ad_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_requests
    ADD CONSTRAINT ad_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 2282 (class 2606 OID 78898)
-- Dependencies: 1795 1795 1795 1795
-- Name: cache_access_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_access
    ADD CONSTRAINT cache_access_pkey PRIMARY KEY (type, member, binding);


--
-- TOC entry 2284 (class 2606 OID 78927)
-- Dependencies: 1796 1796 1796 1796
-- Name: cache_visibility_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_visibility
    ADD CONSTRAINT cache_visibility_pkey PRIMARY KEY (type, member, term);


--
-- TOC entry 2250 (class 2606 OID 78551)
-- Dependencies: 1778 1778
-- Name: catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY catalog
    ADD CONSTRAINT catalog_pkey PRIMARY KEY (id);


--
-- TOC entry 2248 (class 2606 OID 78553)
-- Dependencies: 1777 1777
-- Name: chains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY branches
    ADD CONSTRAINT chains_pkey PRIMARY KEY (id);


--
-- TOC entry 2310 (class 2606 OID 211310)
-- Dependencies: 1816 1816
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- TOC entry 2294 (class 2606 OID 210081)
-- Dependencies: 1805 1805
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- TOC entry 2296 (class 2606 OID 210098)
-- Dependencies: 1806 1806
-- Name: editions_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions_options
    ADD CONSTRAINT editions_options_pkey PRIMARY KEY (id);


--
-- TOC entry 2252 (class 2606 OID 78557)
-- Dependencies: 1779 1779
-- Name: editions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions
    ADD CONSTRAINT editions_pkey PRIMARY KEY (id);


--
-- TOC entry 2286 (class 2606 OID 144483)
-- Dependencies: 1799 1799
-- Name: fascicles_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_index
    ADD CONSTRAINT fascicles_index_pkey PRIMARY KEY (id);


--
-- TOC entry 2288 (class 2606 OID 144501)
-- Dependencies: 1800 1800
-- Name: fascicles_map_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 2331 (class 2606 OID 211795)
-- Dependencies: 1826 1826
-- Name: fascicles_map_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2333 (class 2606 OID 211808)
-- Dependencies: 1827 1827
-- Name: fascicles_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2298 (class 2606 OID 210118)
-- Dependencies: 1807 1807
-- Name: fascicles_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_options
    ADD CONSTRAINT fascicles_options_pkey PRIMARY KEY (id);


--
-- TOC entry 2320 (class 2606 OID 211641)
-- Dependencies: 1821 1821
-- Name: fascicles_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 2302 (class 2606 OID 210194)
-- Dependencies: 1812 1812
-- Name: fascicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_pkey PRIMARY KEY (id);


--
-- TOC entry 2325 (class 2606 OID 211759)
-- Dependencies: 1823 1823
-- Name: fascicles_tmpl_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_index
    ADD CONSTRAINT fascicles_tmpl_index_pkey PRIMARY KEY (id);


--
-- TOC entry 2318 (class 2606 OID 211627)
-- Dependencies: 1820 1820
-- Name: fascicles_tmpl_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2327 (class 2606 OID 211771)
-- Dependencies: 1824 1824
-- Name: fascicles_tmpl_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_pages
    ADD CONSTRAINT fascicles_tmpl_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 2316 (class 2606 OID 211599)
-- Dependencies: 1819 1819
-- Name: fascicles_tmpl_places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_places
    ADD CONSTRAINT fascicles_tmpl_places_pkey PRIMARY KEY (id);


--
-- TOC entry 2308 (class 2606 OID 211299)
-- Dependencies: 1815 1815
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- TOC entry 2306 (class 2606 OID 210272)
-- Dependencies: 1814 1814 1814 1814 1814
-- Name: index_fascicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY index_fascicles
    ADD CONSTRAINT index_fascicles_pkey PRIMARY KEY (id, edition, fascicle, origin);


--
-- TOC entry 2304 (class 2606 OID 210261)
-- Dependencies: 1813 1813
-- Name: index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY index
    ADD CONSTRAINT index_pkey PRIMARY KEY (id);


--
-- TOC entry 2254 (class 2606 OID 78565)
-- Dependencies: 1780 1780
-- Name: logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 2256 (class 2606 OID 78573)
-- Dependencies: 1781 1781 1781
-- Name: map_member_to_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_pkey PRIMARY KEY (member, catalog);


--
-- TOC entry 2278 (class 2606 OID 78665)
-- Dependencies: 1792 1792
-- Name: map_member_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_rule
    ADD CONSTRAINT map_member_to_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 2258 (class 2606 OID 78577)
-- Dependencies: 1782 1782 1782 1782
-- Name: map_principals_to_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_principals_to_stages
    ADD CONSTRAINT map_principals_to_stages_pkey PRIMARY KEY (id, stage, principal);


--
-- TOC entry 2260 (class 2606 OID 78579)
-- Dependencies: 1783 1783 1783 1783
-- Name: map_role_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_pkey PRIMARY KEY (role, rule, mode);


--
-- TOC entry 2262 (class 2606 OID 78583)
-- Dependencies: 1784 1784
-- Name: member_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY members
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- TOC entry 2300 (class 2606 OID 210166)
-- Dependencies: 1808 1808
-- Name: member_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT member_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 2272 (class 2606 OID 78585)
-- Dependencies: 1789 1789
-- Name: member_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT member_session_pkey PRIMARY KEY (id);


--
-- TOC entry 2264 (class 2606 OID 78587)
-- Dependencies: 1785 1785
-- Name: migration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY migration
    ADD CONSTRAINT migration_pkey PRIMARY KEY (id);


--
-- TOC entry 2266 (class 2606 OID 78589)
-- Dependencies: 1786 1786
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- TOC entry 2270 (class 2606 OID 78591)
-- Dependencies: 1788 1788
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 2280 (class 2606 OID 78710)
-- Dependencies: 1793 1793
-- Name: rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- TOC entry 2274 (class 2606 OID 78597)
-- Dependencies: 1790 1790
-- Name: stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- TOC entry 2276 (class 2606 OID 78599)
-- Dependencies: 1791 1791
-- Name: state_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- TOC entry 2268 (class 2606 OID 78601)
-- Dependencies: 1787 1787
-- Name: statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY readiness
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- TOC entry 2321 (class 1259 OID 211821)
-- Dependencies: 1821
-- Name: fki_; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_ ON fascicles_pages USING btree (origin);


--
-- TOC entry 2348 (class 2620 OID 78759)
-- Dependencies: 94 1778
-- Name: catalog_access_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_access_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_delete_after_trigger('catalog');


--
-- TOC entry 2349 (class 2620 OID 78760)
-- Dependencies: 95 1778
-- Name: catalog_access_insert_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_access_insert_after
    AFTER INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_insert_after_trigger('catalog');


--
-- TOC entry 2350 (class 2620 OID 78761)
-- Dependencies: 99 1778
-- Name: catalog_access_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_access_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE access_update_after_trigger('catalog');


--
-- TOC entry 2345 (class 2620 OID 78604)
-- Dependencies: 1778 90
-- Name: catalog_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- TOC entry 2346 (class 2620 OID 78605)
-- Dependencies: 1778 91
-- Name: catalog_insert_before; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_insert_before
    BEFORE INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- TOC entry 2347 (class 2620 OID 78606)
-- Dependencies: 1778 92
-- Name: catalog_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- TOC entry 2356 (class 2620 OID 78768)
-- Dependencies: 1779 94
-- Name: editions_access_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_access_delete_after
    AFTER DELETE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_delete_after_trigger('editions');


--
-- TOC entry 2355 (class 2620 OID 78766)
-- Dependencies: 1779 95
-- Name: editions_access_insert_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_access_insert_after
    AFTER INSERT ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_insert_after_trigger('editions');


--
-- TOC entry 2354 (class 2620 OID 78765)
-- Dependencies: 1779 99
-- Name: editions_access_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_access_update_after
    AFTER UPDATE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE access_update_after_trigger('editions');


--
-- TOC entry 2351 (class 2620 OID 78607)
-- Dependencies: 90 1779
-- Name: editions_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_delete_after
    AFTER DELETE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- TOC entry 2352 (class 2620 OID 78608)
-- Dependencies: 91 1779
-- Name: editions_insert_before; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_insert_before
    BEFORE INSERT ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- TOC entry 2353 (class 2620 OID 78609)
-- Dependencies: 92 1779
-- Name: editions_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_update_after
    AFTER UPDATE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- TOC entry 2360 (class 2620 OID 211314)
-- Dependencies: 1800 100
-- Name: fascicles_map_documents_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_documents_delete_after
    AFTER DELETE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_delete_after_trigger();


--
-- TOC entry 2359 (class 2620 OID 144843)
-- Dependencies: 1800 98
-- Name: fascicles_map_documents_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_documents_update_after
    AFTER INSERT OR UPDATE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_update_after_trigger();


--
-- TOC entry 2358 (class 2620 OID 78771)
-- Dependencies: 1792 97
-- Name: rules_mapping_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER rules_mapping_delete_after
    AFTER DELETE ON map_member_to_rule
    FOR EACH ROW
    EXECUTE PROCEDURE rules_delete_after_trigger();


--
-- TOC entry 2357 (class 2620 OID 78764)
-- Dependencies: 96 1792
-- Name: rules_mapping_insert_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER rules_mapping_insert_after
    AFTER INSERT ON map_member_to_rule
    FOR EACH ROW
    EXECUTE PROCEDURE rules_insert_after_trigger();


--
-- TOC entry 2336 (class 2606 OID 78899)
-- Dependencies: 1795 1784 2261
-- Name: cache_access_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_access
    ADD CONSTRAINT cache_access_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2337 (class 2606 OID 211832)
-- Dependencies: 1805 2293 1800
-- Name: fascicles_map_documents_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_entity_fkey FOREIGN KEY (entity) REFERENCES documents(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2338 (class 2606 OID 211867)
-- Dependencies: 1800 2319 1821
-- Name: fascicles_map_documents_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_page_fkey FOREIGN KEY (page) REFERENCES fascicles_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2342 (class 2606 OID 211862)
-- Dependencies: 1826 2332 1827
-- Name: fascicles_map_modules_module_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_module_fkey FOREIGN KEY (module) REFERENCES fascicles_modules(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2341 (class 2606 OID 211857)
-- Dependencies: 1821 2319 1826
-- Name: fascicles_map_modules_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_page_fkey FOREIGN KEY (page) REFERENCES fascicles_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2343 (class 2606 OID 211847)
-- Dependencies: 1820 2317 1827
-- Name: fascicles_modules_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_origin_fkey FOREIGN KEY (origin) REFERENCES fascicles_tmpl_modules(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2344 (class 2606 OID 211852)
-- Dependencies: 1827 2315 1819
-- Name: fascicles_modules_place_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_place_fkey FOREIGN KEY (place) REFERENCES fascicles_tmpl_places(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2340 (class 2606 OID 211816)
-- Dependencies: 1821 1824 2326
-- Name: fascicles_pages_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_origin_fkey FOREIGN KEY (origin) REFERENCES fascicles_tmpl_pages(id) ON DELETE RESTRICT;


--
-- TOC entry 2339 (class 2606 OID 211827)
-- Dependencies: 1820 2326 1824
-- Name: fascicles_tmpl_modules_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_page_fkey FOREIGN KEY (page) REFERENCES fascicles_tmpl_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2334 (class 2606 OID 78610)
-- Dependencies: 1781 2261 1784
-- Name: map_member_to_catalog_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2335 (class 2606 OID 78615)
-- Dependencies: 1788 2269 1783
-- Name: map_role_to_rule_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_role_fkey FOREIGN KEY (role) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2010-12-23 01:24:19

--
-- PostgreSQL database dump complete
--

