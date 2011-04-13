--
-- PostgreSQL database dump
--

-- Started on 2011-04-12 13:07:59 MSD

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 5 (class 2615 OID 18855)
-- Name: plugins; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA plugins;


--
-- TOC entry 575 (class 2612 OID 18858)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- TOC entry 383 (class 0 OID 0)
-- Name: lquery; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE lquery;


--
-- TOC entry 20 (class 1255 OID 18860)
-- Dependencies: 7 383
-- Name: lquery_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lquery_in(cstring) RETURNS lquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_in';


--
-- TOC entry 21 (class 1255 OID 18861)
-- Dependencies: 7 383
-- Name: lquery_out(lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lquery_out(lquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_out';


--
-- TOC entry 382 (class 1247 OID 18859)
-- Dependencies: 7 21 20
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
-- TOC entry 386 (class 0 OID 0)
-- Name: ltree; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree;


--
-- TOC entry 22 (class 1255 OID 18864)
-- Dependencies: 7 386
-- Name: ltree_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_in(cstring) RETURNS ltree
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_in';


--
-- TOC entry 23 (class 1255 OID 18865)
-- Dependencies: 7 386
-- Name: ltree_out(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_out(ltree) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_out';


--
-- TOC entry 385 (class 1247 OID 18863)
-- Dependencies: 22 23 7
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
-- TOC entry 389 (class 0 OID 0)
-- Name: ltree_gist; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree_gist;


--
-- TOC entry 24 (class 1255 OID 18868)
-- Dependencies: 7 389
-- Name: ltree_gist_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gist_in(cstring) RETURNS ltree_gist
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_in';


--
-- TOC entry 25 (class 1255 OID 18869)
-- Dependencies: 7 389
-- Name: ltree_gist_out(ltree_gist); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gist_out(ltree_gist) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_out';


--
-- TOC entry 388 (class 1247 OID 18867)
-- Dependencies: 24 25 7
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
-- TOC entry 392 (class 0 OID 0)
-- Name: ltxtquery; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltxtquery;


--
-- TOC entry 26 (class 1255 OID 18872)
-- Dependencies: 7 392
-- Name: ltxtq_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_in(cstring) RETURNS ltxtquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_in';


--
-- TOC entry 27 (class 1255 OID 18873)
-- Dependencies: 7 392
-- Name: ltxtq_out(ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_out(ltxtquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_out';


--
-- TOC entry 391 (class 1247 OID 18871)
-- Dependencies: 26 27 7
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
-- TOC entry 28 (class 1255 OID 18875)
-- Dependencies: 387 7 384
-- Name: _lt_q_regex(ltree[], lquery[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _lt_q_regex(ltree[], lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_regex';


--
-- TOC entry 29 (class 1255 OID 18876)
-- Dependencies: 387 7 384
-- Name: _lt_q_rregex(lquery[], ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _lt_q_rregex(lquery[], ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_rregex';


--
-- TOC entry 30 (class 1255 OID 18877)
-- Dependencies: 382 385 7 387
-- Name: _ltq_extract_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_extract_regex(ltree[], lquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_extract_regex';


--
-- TOC entry 31 (class 1255 OID 18878)
-- Dependencies: 7 382 387
-- Name: _ltq_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_regex(ltree[], lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_regex';


--
-- TOC entry 32 (class 1255 OID 18879)
-- Dependencies: 387 382 7
-- Name: _ltq_rregex(lquery, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_rregex(lquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_rregex';


--
-- TOC entry 33 (class 1255 OID 18880)
-- Dependencies: 7
-- Name: _ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_compress';


--
-- TOC entry 34 (class 1255 OID 18881)
-- Dependencies: 7
-- Name: _ltree_consistent(internal, internal, smallint, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_consistent(internal, internal, smallint, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_consistent';


--
-- TOC entry 35 (class 1255 OID 18882)
-- Dependencies: 385 387 385 7
-- Name: _ltree_extract_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_extract_isparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_isparent';


--
-- TOC entry 36 (class 1255 OID 18883)
-- Dependencies: 385 7 387 385
-- Name: _ltree_extract_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_extract_risparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_risparent';


--
-- TOC entry 37 (class 1255 OID 18884)
-- Dependencies: 7 387 385
-- Name: _ltree_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_isparent(ltree[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_isparent';


--
-- TOC entry 38 (class 1255 OID 18885)
-- Dependencies: 7
-- Name: _ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_penalty';


--
-- TOC entry 39 (class 1255 OID 18886)
-- Dependencies: 7
-- Name: _ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_picksplit';


--
-- TOC entry 40 (class 1255 OID 18887)
-- Dependencies: 7 385 387
-- Name: _ltree_r_isparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_r_isparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_isparent';


--
-- TOC entry 41 (class 1255 OID 18888)
-- Dependencies: 7 385 387
-- Name: _ltree_r_risparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_r_risparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_risparent';


--
-- TOC entry 42 (class 1255 OID 18889)
-- Dependencies: 7 387 385
-- Name: _ltree_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_risparent(ltree[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_risparent';


--
-- TOC entry 43 (class 1255 OID 18890)
-- Dependencies: 7
-- Name: _ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_same';


--
-- TOC entry 44 (class 1255 OID 18891)
-- Dependencies: 7
-- Name: _ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_union(internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_union';


--
-- TOC entry 45 (class 1255 OID 18892)
-- Dependencies: 7 391 387
-- Name: _ltxtq_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_exec(ltree[], ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_exec';


--
-- TOC entry 46 (class 1255 OID 18893)
-- Dependencies: 7 387 391 385
-- Name: _ltxtq_extract_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_extract_exec(ltree[], ltxtquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_extract_exec';


--
-- TOC entry 47 (class 1255 OID 18894)
-- Dependencies: 387 7 391
-- Name: _ltxtq_rexec(ltxtquery, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_rexec(ltxtquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_rexec';


--
-- TOC entry 48 (class 1255 OID 18898)
-- Dependencies: 7
-- Name: digest(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION digest(text, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_digest';


--
-- TOC entry 49 (class 1255 OID 18899)
-- Dependencies: 7 575
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
-- TOC entry 50 (class 1255 OID 18900)
-- Dependencies: 7 575
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
-- TOC entry 51 (class 1255 OID 18901)
-- Dependencies: 7 575
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
-- TOC entry 52 (class 1255 OID 18902)
-- Dependencies: 7 575
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
-- TOC entry 53 (class 1255 OID 18903)
-- Dependencies: 7 385 385
-- Name: index(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION index(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


--
-- TOC entry 54 (class 1255 OID 18904)
-- Dependencies: 7 385 385
-- Name: index(ltree, ltree, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION index(ltree, ltree, integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


--
-- TOC entry 55 (class 1255 OID 18905)
-- Dependencies: 7 385 387
-- Name: lca(ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree[]) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lca';


--
-- TOC entry 56 (class 1255 OID 18906)
-- Dependencies: 385 7 385 385
-- Name: lca(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 57 (class 1255 OID 18907)
-- Dependencies: 385 385 7 385 385
-- Name: lca(ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 58 (class 1255 OID 18908)
-- Dependencies: 7 385 385 385 385 385
-- Name: lca(ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 59 (class 1255 OID 18909)
-- Dependencies: 385 7 385 385 385 385 385
-- Name: lca(ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 60 (class 1255 OID 18910)
-- Dependencies: 385 385 7 385 385 385 385 385
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 61 (class 1255 OID 18911)
-- Dependencies: 385 7 385 385 385 385 385 385 385
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 62 (class 1255 OID 18912)
-- Dependencies: 385 385 385 385 7 385 385 385 385 385
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- TOC entry 63 (class 1255 OID 18913)
-- Dependencies: 7 384 385
-- Name: lt_q_regex(ltree, lquery[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lt_q_regex(ltree, lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_regex';


--
-- TOC entry 64 (class 1255 OID 18914)
-- Dependencies: 384 7 385
-- Name: lt_q_rregex(lquery[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lt_q_rregex(lquery[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_rregex';


--
-- TOC entry 65 (class 1255 OID 18915)
-- Dependencies: 7 382 385
-- Name: ltq_regex(ltree, lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltq_regex(ltree, lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_regex';


--
-- TOC entry 66 (class 1255 OID 18916)
-- Dependencies: 385 382 7
-- Name: ltq_rregex(lquery, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltq_rregex(lquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_rregex';


--
-- TOC entry 67 (class 1255 OID 18917)
-- Dependencies: 385 7
-- Name: ltree2text(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree2text(ltree) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree2text';


--
-- TOC entry 68 (class 1255 OID 18918)
-- Dependencies: 385 7 385 385
-- Name: ltree_addltree(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_addltree(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addltree';


--
-- TOC entry 69 (class 1255 OID 18919)
-- Dependencies: 385 385 7
-- Name: ltree_addtext(ltree, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_addtext(ltree, text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addtext';


--
-- TOC entry 70 (class 1255 OID 18920)
-- Dependencies: 385 385 7
-- Name: ltree_cmp(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_cmp(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_cmp';


--
-- TOC entry 71 (class 1255 OID 18921)
-- Dependencies: 7
-- Name: ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_compress';


--
-- TOC entry 72 (class 1255 OID 18922)
-- Dependencies: 7
-- Name: ltree_consistent(internal, internal, smallint, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_consistent(internal, internal, smallint, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_consistent';


--
-- TOC entry 73 (class 1255 OID 18923)
-- Dependencies: 7
-- Name: ltree_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_decompress';


--
-- TOC entry 74 (class 1255 OID 18924)
-- Dependencies: 385 385 7
-- Name: ltree_eq(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_eq(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_eq';


--
-- TOC entry 75 (class 1255 OID 18925)
-- Dependencies: 385 7 385
-- Name: ltree_ge(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_ge(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ge';


--
-- TOC entry 76 (class 1255 OID 18926)
-- Dependencies: 385 7 385
-- Name: ltree_gt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_gt';


--
-- TOC entry 77 (class 1255 OID 18927)
-- Dependencies: 385 385 7
-- Name: ltree_isparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_isparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_isparent';


--
-- TOC entry 78 (class 1255 OID 18928)
-- Dependencies: 385 385 7
-- Name: ltree_le(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_le(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_le';


--
-- TOC entry 79 (class 1255 OID 18929)
-- Dependencies: 385 385 7
-- Name: ltree_lt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_lt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_lt';


--
-- TOC entry 80 (class 1255 OID 18930)
-- Dependencies: 385 385 7
-- Name: ltree_ne(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_ne(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ne';


--
-- TOC entry 81 (class 1255 OID 18931)
-- Dependencies: 7
-- Name: ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_penalty';


--
-- TOC entry 82 (class 1255 OID 18932)
-- Dependencies: 7
-- Name: ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_picksplit';


--
-- TOC entry 83 (class 1255 OID 18933)
-- Dependencies: 7 385 385
-- Name: ltree_risparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_risparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_risparent';


--
-- TOC entry 84 (class 1255 OID 18934)
-- Dependencies: 7
-- Name: ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_same';


--
-- TOC entry 85 (class 1255 OID 18935)
-- Dependencies: 385 385 7
-- Name: ltree_textadd(text, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_textadd(text, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_textadd';


--
-- TOC entry 86 (class 1255 OID 18936)
-- Dependencies: 7
-- Name: ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_union(internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_union';


--
-- TOC entry 87 (class 1255 OID 18937)
-- Dependencies: 7
-- Name: ltreeparentsel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltreeparentsel(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltreeparentsel';


--
-- TOC entry 88 (class 1255 OID 18938)
-- Dependencies: 385 7 391
-- Name: ltxtq_exec(ltree, ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_exec(ltree, ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_exec';


--
-- TOC entry 89 (class 1255 OID 18939)
-- Dependencies: 385 7 391
-- Name: ltxtq_rexec(ltxtquery, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_rexec(ltxtquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_rexec';


--
-- TOC entry 90 (class 1255 OID 18940)
-- Dependencies: 385 7
-- Name: nlevel(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION nlevel(ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'nlevel';


--
-- TOC entry 91 (class 1255 OID 18943)
-- Dependencies: 385 7 385
-- Name: subltree(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subltree(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subltree';


--
-- TOC entry 92 (class 1255 OID 18944)
-- Dependencies: 385 385 7
-- Name: subpath(ltree, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subpath(ltree, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


--
-- TOC entry 93 (class 1255 OID 18945)
-- Dependencies: 385 7 385
-- Name: subpath(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subpath(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


--
-- TOC entry 94 (class 1255 OID 18946)
-- Dependencies: 385 7
-- Name: text2ltree(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION text2ltree(text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'text2ltree';


--
-- TOC entry 95 (class 1255 OID 18947)
-- Dependencies: 575 7
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
-- TOC entry 96 (class 1255 OID 18948)
-- Dependencies: 7 575
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
-- TOC entry 97 (class 1255 OID 18949)
-- Dependencies: 575 7
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
-- TOC entry 98 (class 1255 OID 18950)
-- Dependencies: 7
-- Name: uuid_generate_v4(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION uuid_generate_v4() RETURNS uuid
    LANGUAGE c STRICT
    AS '$libdir/uuid-ossp', 'uuid_generate_v4';


--
-- TOC entry 1280 (class 2617 OID 18953)
-- Dependencies: 385 385 7 79
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
-- TOC entry 1281 (class 2617 OID 18954)
-- Dependencies: 385 78 7 385
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
-- TOC entry 1284 (class 2617 OID 18956)
-- Dependencies: 7 80 385 385
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
-- TOC entry 1286 (class 2617 OID 18958)
-- Dependencies: 385 385 7 83 87
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
-- TOC entry 1287 (class 2617 OID 18960)
-- Dependencies: 385 7 387 40
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
-- TOC entry 1289 (class 2617 OID 18962)
-- Dependencies: 42 385 387 7
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
-- TOC entry 1288 (class 2617 OID 18955)
-- Dependencies: 74 385 385 7
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
-- TOC entry 1290 (class 2617 OID 18951)
-- Dependencies: 76 7 385 385
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
-- TOC entry 1283 (class 2617 OID 18952)
-- Dependencies: 7 385 385 75
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
-- TOC entry 1293 (class 2617 OID 18963)
-- Dependencies: 64 7 384 385
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
-- TOC entry 1291 (class 2617 OID 18964)
-- Dependencies: 7 385 384 63
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
-- TOC entry 1296 (class 2617 OID 18965)
-- Dependencies: 7 384 387 29
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
-- TOC entry 1294 (class 2617 OID 18966)
-- Dependencies: 28 387 384 7
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
-- TOC entry 1297 (class 2617 OID 18967)
-- Dependencies: 385 36 387 7 385
-- Name: ?<@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?<@ (
    PROCEDURE = _ltree_extract_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


--
-- TOC entry 1298 (class 2617 OID 18968)
-- Dependencies: 7 387 46 391 385
-- Name: ?@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?@ (
    PROCEDURE = _ltxtq_extract_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery
);


--
-- TOC entry 1299 (class 2617 OID 18969)
-- Dependencies: 7 35 385 385 387
-- Name: ?@>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?@> (
    PROCEDURE = _ltree_extract_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


--
-- TOC entry 1300 (class 2617 OID 18970)
-- Dependencies: 7 30 387 382 385
-- Name: ?~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?~ (
    PROCEDURE = _ltq_extract_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery
);


--
-- TOC entry 1302 (class 2617 OID 18971)
-- Dependencies: 391 385 89 7
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
-- TOC entry 1301 (class 2617 OID 18972)
-- Dependencies: 88 7 385 391
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
-- TOC entry 1305 (class 2617 OID 18973)
-- Dependencies: 7 391 387 47
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
-- TOC entry 1303 (class 2617 OID 18974)
-- Dependencies: 7 45 391 387
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
-- TOC entry 1282 (class 2617 OID 18957)
-- Dependencies: 385 385 87 7 77
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
-- TOC entry 1285 (class 2617 OID 18959)
-- Dependencies: 385 37 387 7
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
-- TOC entry 1306 (class 2617 OID 18961)
-- Dependencies: 385 41 7 387
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
-- TOC entry 1307 (class 2617 OID 18976)
-- Dependencies: 7 385 385 83
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
-- TOC entry 1308 (class 2617 OID 18978)
-- Dependencies: 387 7 385 40
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
-- TOC entry 1309 (class 2617 OID 18980)
-- Dependencies: 7 42 385 387
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
-- TOC entry 1312 (class 2617 OID 18981)
-- Dependencies: 64 384 7 385
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
-- TOC entry 1310 (class 2617 OID 18982)
-- Dependencies: 7 63 385 384
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
-- TOC entry 1314 (class 2617 OID 18983)
-- Dependencies: 384 387 7 29
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
-- TOC entry 1313 (class 2617 OID 18984)
-- Dependencies: 7 384 28 387
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
-- TOC entry 1317 (class 2617 OID 18985)
-- Dependencies: 7 391 385 89
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
-- TOC entry 1315 (class 2617 OID 18986)
-- Dependencies: 385 391 88 7
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
-- TOC entry 1319 (class 2617 OID 18987)
-- Dependencies: 7 391 387 47
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
-- TOC entry 1318 (class 2617 OID 18988)
-- Dependencies: 45 7 387 391
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
-- TOC entry 1320 (class 2617 OID 18975)
-- Dependencies: 385 385 7 77
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
-- TOC entry 1292 (class 2617 OID 18977)
-- Dependencies: 7 385 387 37
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
-- TOC entry 1295 (class 2617 OID 18979)
-- Dependencies: 387 7 385 41
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
-- TOC entry 1311 (class 2617 OID 18989)
-- Dependencies: 385 7 382 66
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
-- TOC entry 1304 (class 2617 OID 18990)
-- Dependencies: 65 382 385 7
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
-- TOC entry 1321 (class 2617 OID 18991)
-- Dependencies: 7 32 387 382
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
-- TOC entry 1316 (class 2617 OID 18992)
-- Dependencies: 7 382 31 387
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
-- TOC entry 1322 (class 2617 OID 18993)
-- Dependencies: 385 7 385 68 385
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addltree,
    LEFTARG = ltree,
    RIGHTARG = ltree
);


--
-- TOC entry 1323 (class 2617 OID 18994)
-- Dependencies: 385 7 69 385
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addtext,
    LEFTARG = ltree,
    RIGHTARG = text
);


--
-- TOC entry 1324 (class 2617 OID 18995)
-- Dependencies: 85 385 385 7
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_textadd,
    LEFTARG = text,
    RIGHTARG = ltree
);


--
-- TOC entry 1326 (class 2617 OID 18996)
-- Dependencies: 66 382 7 385
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
-- TOC entry 1325 (class 2617 OID 18997)
-- Dependencies: 65 385 7 382
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
-- TOC entry 1328 (class 2617 OID 18998)
-- Dependencies: 382 32 387 7
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
-- TOC entry 1327 (class 2617 OID 18999)
-- Dependencies: 387 31 382 7
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
-- TOC entry 1549 (class 2753 OID 19000)
-- Dependencies: 7
-- Name: gist__ltree_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY gist__ltree_ops USING gist;


--
-- TOC entry 1440 (class 2616 OID 19001)
-- Dependencies: 388 7 1549 387
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
-- TOC entry 1550 (class 2753 OID 19017)
-- Dependencies: 7
-- Name: gist_ltree_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY gist_ltree_ops USING gist;


--
-- TOC entry 1441 (class 2616 OID 19018)
-- Dependencies: 1550 388 7 385
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
-- TOC entry 1551 (class 2753 OID 19039)
-- Dependencies: 7
-- Name: ltree_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY ltree_ops USING btree;


--
-- TOC entry 1442 (class 2616 OID 19040)
-- Dependencies: 385 1551 7
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


SET search_path = plugins, pg_catalog;

SET default_with_oids = false;

--
-- TOC entry 1817 (class 1259 OID 19047)
-- Dependencies: 2166 5
-- Name: l18n; Type: TABLE; Schema: plugins; Owner: -
--

CREATE TABLE l18n (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    plugin character varying NOT NULL,
    l18n_language character varying NOT NULL,
    l18n_original character varying NOT NULL,
    l18n_translation character varying NOT NULL
);


--
-- TOC entry 1818 (class 1259 OID 19054)
-- Dependencies: 2167 2168 2169 5
-- Name: menu; Type: TABLE; Schema: plugins; Owner: -
--

CREATE TABLE menu (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    plugin character varying NOT NULL,
    menu_section character varying NOT NULL,
    menu_id character varying NOT NULL,
    menu_sortorder integer DEFAULT 0 NOT NULL,
    menu_enabled boolean DEFAULT false NOT NULL
);


--
-- TOC entry 1819 (class 1259 OID 19063)
-- Dependencies: 2170 2171 2172 5
-- Name: routes; Type: TABLE; Schema: plugins; Owner: -
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


--
-- TOC entry 1820 (class 1259 OID 19072)
-- Dependencies: 2173 2174 2175 5
-- Name: rules; Type: TABLE; Schema: plugins; Owner: -
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


SET search_path = public, pg_catalog;

--
-- TOC entry 1821 (class 1259 OID 19081)
-- Dependencies: 2176 2177 2178 7
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
-- TOC entry 1822 (class 1259 OID 19090)
-- Dependencies: 1821 7
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ad_advertisers_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 2546 (class 0 OID 0)
-- Dependencies: 1822
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ad_advertisers_serialnum_seq OWNED BY ad_advertisers.serialnum;


--
-- TOC entry 1823 (class 1259 OID 19092)
-- Dependencies: 2180 2181 2182 7
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
-- TOC entry 1824 (class 1259 OID 19101)
-- Dependencies: 2183 2184 2185 2186 2187 2188 2189 2190 2191 7
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
-- TOC entry 1825 (class 1259 OID 19116)
-- Dependencies: 2192 2193 2194 2195 7
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
-- TOC entry 1826 (class 1259 OID 19126)
-- Dependencies: 2196 2197 2198 7
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
-- TOC entry 1827 (class 1259 OID 19135)
-- Dependencies: 2199 2200 2201 7
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
-- TOC entry 1828 (class 1259 OID 19144)
-- Dependencies: 7 1827
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ad_requests_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 2547 (class 0 OID 0)
-- Dependencies: 1828
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ad_requests_serialnum_seq OWNED BY ad_requests.serialnum;


--
-- TOC entry 1829 (class 1259 OID 19146)
-- Dependencies: 2203 2204 2205 7
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
-- TOC entry 1830 (class 1259 OID 19161)
-- Dependencies: 2206 2207 2208 7
-- Name: cache_downloads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cache_downloads (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    document uuid NOT NULL,
    file uuid NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- TOC entry 1831 (class 1259 OID 19167)
-- Dependencies: 2209 2210 2211 2212 2213 2214 2215 7
-- Name: cache_files; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1832 (class 1259 OID 19180)
-- Dependencies: 2216 2217 7
-- Name: cache_hotsave; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1833 (class 1259 OID 19188)
-- Dependencies: 2218 2219 2220 7 385
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
-- TOC entry 1834 (class 1259 OID 19197)
-- Dependencies: 2221 2222 2223 385 7
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
-- TOC entry 1835 (class 1259 OID 19206)
-- Dependencies: 2224 7
-- Name: map_member_to_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_member_to_rule (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    section character varying NOT NULL,
    area character varying NOT NULL,
    binding uuid NOT NULL,
    term uuid NOT NULL,
    termkey character varying
);


--
-- TOC entry 1836 (class 1259 OID 19213)
-- Dependencies: 2225 2226 2227 7
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
-- TOC entry 1837 (class 1259 OID 19222)
-- Dependencies: 2228 2229 7
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
-- TOC entry 1838 (class 1259 OID 19230)
-- Dependencies: 1969 7 385
-- Name: cache_rules; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cache_rules AS
    (SELECT 'edition' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(SELECT DISTINCT (((((a2.section)::text || '.'::text) || (a2.subsection)::text) || '.'::text) || (a2.term)::text) AS term FROM map_member_to_rule a1, rules a2 WHERE (((a2.id = a1.term) AND (a1.member = t2.id)) AND (a1.binding IN (SELECT editions.id FROM editions WHERE (editions.path @> t1.path))))) AS terms FROM editions t1, members t2 ORDER BY t1.path) UNION (SELECT 'catalog' AS type, t1.path, t1.id AS binding, t2.id AS member, ARRAY(SELECT DISTINCT (((((a2.section)::text || '.'::text) || (a2.subsection)::text) || '.'::text) || (a2.term)::text) AS term FROM map_member_to_rule a1, rules a2 WHERE (((a2.id = a1.term) AND (a1.member = t2.id)) AND (a1.binding IN (SELECT catalog.id FROM catalog WHERE (catalog.path @> t1.path))))) AS terms FROM catalog t1, members t2 ORDER BY t1.path);


--
-- TOC entry 1839 (class 1259 OID 19235)
-- Dependencies: 2230 2231 7
-- Name: cache_versions; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1840 (class 1259 OID 19249)
-- Dependencies: 2232 2233 2234 7 385
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
-- TOC entry 1841 (class 1259 OID 19258)
-- Dependencies: 2235 2236 2237 2238 2239 2240 2241 2242 2243 2244 2245 2246 2247 7
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


--
-- TOC entry 1842 (class 1259 OID 19277)
-- Dependencies: 2248 2249 2250 7
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
-- TOC entry 1843 (class 1259 OID 19286)
-- Dependencies: 2251 2252 2253 2254 2255 2256 2257 2258 2259 2260 2261 2262 2263 2264 7
-- Name: fascicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fascicles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    parent uuid NOT NULL,
    fastype character varying DEFAULT 'issue'::character varying,
    variation uuid DEFAULT uuid_generate_v4() NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    circulation integer DEFAULT 0,
    manager uuid,
    enabled boolean DEFAULT false NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    doc_date timestamp(6) with time zone,
    adv_date timestamp(6) with time zone,
    print_date timestamp(6) with time zone,
    release_date timestamp(6) with time zone,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL,
    num integer DEFAULT 0 NOT NULL,
    anum integer DEFAULT 0 NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    adv_enabled boolean DEFAULT false,
    doc_enabled boolean DEFAULT false NOT NULL,
    tmpl uuid,
    tmpl_shortcut character varying DEFAULT ''::character varying
);


--
-- TOC entry 1844 (class 1259 OID 19306)
-- Dependencies: 2265 2266 2267 2268 7
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
-- TOC entry 1845 (class 1259 OID 19316)
-- Dependencies: 2269 2270 2271 2272 7
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
-- TOC entry 1846 (class 1259 OID 19326)
-- Dependencies: 2273 2274 2275 7
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
-- TOC entry 1847 (class 1259 OID 19332)
-- Dependencies: 2276 2277 2278 2279 7
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
-- TOC entry 1848 (class 1259 OID 19342)
-- Dependencies: 2280 2281 2282 7
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
-- TOC entry 1849 (class 1259 OID 19348)
-- Dependencies: 2283 2284 2285 2286 2287 7
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
-- TOC entry 1850 (class 1259 OID 19359)
-- Dependencies: 2288 2289 2290 7
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
-- TOC entry 1851 (class 1259 OID 19368)
-- Dependencies: 2291 2292 2293 7
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
-- TOC entry 1852 (class 1259 OID 19377)
-- Dependencies: 2294 2295 2296 2297 2298 2299 2300 2301 2302 7
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
-- TOC entry 1853 (class 1259 OID 19392)
-- Dependencies: 1852 7
-- Name: fascicles_requests_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fascicles_requests_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- TOC entry 2548 (class 0 OID 0)
-- Dependencies: 1853
-- Name: fascicles_requests_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fascicles_requests_serialnum_seq OWNED BY fascicles_requests.serialnum;


--
-- TOC entry 1854 (class 1259 OID 19394)
-- Dependencies: 2304 2305 2306 7
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
-- TOC entry 1855 (class 1259 OID 19403)
-- Dependencies: 2307 2308 2309 2310 2311 2312 2313 2314 2315 7
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
-- TOC entry 1856 (class 1259 OID 19418)
-- Dependencies: 2316 2317 2318 2319 7
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
-- TOC entry 1857 (class 1259 OID 19428)
-- Dependencies: 2320 2321 2322 7
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
-- TOC entry 1858 (class 1259 OID 19437)
-- Dependencies: 2323 2324 7
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
-- TOC entry 1859 (class 1259 OID 19445)
-- Dependencies: 2325 2326 2327 2328 7
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
-- TOC entry 1860 (class 1259 OID 19455)
-- Dependencies: 2329 2330 2331 2332 7
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
-- TOC entry 1861 (class 1259 OID 19465)
-- Dependencies: 2333 2334 2335 7
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
-- TOC entry 1862 (class 1259 OID 19474)
-- Dependencies: 2336 2337 7
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
-- TOC entry 1863 (class 1259 OID 19482)
-- Dependencies: 2338 7
-- Name: map_member_to_catalog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_member_to_catalog (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    catalog uuid NOT NULL
);


--
-- TOC entry 1864 (class 1259 OID 19486)
-- Dependencies: 2339 7
-- Name: map_principals_to_stages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_principals_to_stages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    stage uuid NOT NULL,
    catalog uuid NOT NULL,
    principal uuid NOT NULL
);


--
-- TOC entry 1865 (class 1259 OID 19490)
-- Dependencies: 7
-- Name: map_role_to_rule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE map_role_to_rule (
    role uuid NOT NULL,
    rule uuid NOT NULL,
    mode character varying NOT NULL
);


--
-- TOC entry 1866 (class 1259 OID 19496)
-- Dependencies: 2340 7
-- Name: migration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE migration (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    mtype character varying NOT NULL,
    oldid uuid NOT NULL,
    newid uuid NOT NULL
);


--
-- TOC entry 1867 (class 1259 OID 19503)
-- Dependencies: 2341 7
-- Name: options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying NOT NULL
);


--
-- TOC entry 1868 (class 1259 OID 19510)
-- Dependencies: 2342 2343 7
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
-- TOC entry 1869 (class 1259 OID 19518)
-- Dependencies: 2344 2345 2346 7
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
-- TOC entry 1870 (class 1259 OID 19527)
-- Dependencies: 2347 2348 2349 7
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
-- TOC entry 1871 (class 1259 OID 19536)
-- Dependencies: 2350 2351 2352 2353 7
-- Name: rss; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1872 (class 1259 OID 19546)
-- Dependencies: 2354 2355 2356 2357 7
-- Name: rss_feeds; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 1873 (class 1259 OID 19556)
-- Dependencies: 2358 7
-- Name: rss_feeds_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rss_feeds_mapping (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    feed uuid NOT NULL,
    nature character varying NOT NULL,
    tag uuid NOT NULL
);


--
-- TOC entry 1874 (class 1259 OID 19563)
-- Dependencies: 2359 7
-- Name: rss_feeds_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE rss_feeds_options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    feed uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying NOT NULL
);


--
-- TOC entry 1875 (class 1259 OID 19570)
-- Dependencies: 2360 2361 2362 7
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
-- TOC entry 1876 (class 1259 OID 19579)
-- Dependencies: 2363 2364 2365 7
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
-- TOC entry 1877 (class 1259 OID 19588)
-- Dependencies: 2366 2367 2368 7
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
-- TOC entry 1878 (class 1259 OID 19597)
-- Dependencies: 1970 7
-- Name: view_principals; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_principals AS
    SELECT t1.id, 'member' AS type, t2.title, t2.shortcut, t2.job_position AS description FROM members t1, profiles t2 WHERE (t1.id = t2.id) UNION SELECT catalog.id, 'group' AS type, catalog.title, catalog.shortcut, catalog.description FROM catalog;


--
-- TOC entry 1879 (class 1259 OID 19601)
-- Dependencies: 1971 7
-- Name: view_assignments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_assignments AS
    SELECT t1.id, t1.catalog, t5.shortcut AS catalog_shortcut, t6.type AS principal_type, t1.principal, t6.shortcut AS principal_shortcut, t2.id AS branch, t2.shortcut AS branch_shortcut, t1.stage, t3.shortcut AS stage_shortcut, t4.id AS readiness, t4.shortcut AS readiness_shortcut, t4.weight AS progress, t4.color FROM map_principals_to_stages t1, branches t2, stages t3, readiness t4, catalog t5, view_principals t6 WHERE (((((t2.id = t3.branch) AND (t3.id = t1.stage)) AND (t4.id = t3.readiness)) AND (t5.id = t1.catalog)) AND (t6.id = t1.principal));


--
-- TOC entry 1880 (class 1259 OID 19605)
-- Dependencies: 1972 7
-- Name: view_members; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_members AS
    SELECT t1.id, t1.login, t1.password, t2.title, t2.shortcut, t2.job_position, ARRAY(SELECT map_member_to_catalog.catalog FROM map_member_to_catalog WHERE (map_member_to_catalog.member = t1.id)) AS catalog FROM members t1, profiles t2 WHERE (t1.id = t2.id);


--
-- TOC entry 1881 (class 1259 OID 19609)
-- Dependencies: 1973 7
-- Name: view_rules; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_rules AS
    SELECT rules.id, rules.term, rules.section, rules.subsection, rules.icon, rules.title, rules.description, rules.sortorder, (((((rules.section)::text || '.'::text) || (rules.subsection)::text) || '.'::text) || (rules.term)::text) AS term_text FROM rules;


--
-- TOC entry 1882 (class 1259 OID 19613)
-- Dependencies: 1974 385 7
-- Name: view_rules_old; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_rules_old AS
    (SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, '00000000000000000000000000000000'::ltree AS path, ARRAY['00000000-0000-0000-0000-000000000000'::uuid] AS childrens FROM map_member_to_rule t1, rules t2 WHERE (((t1.section)::text = 'domain'::text) AND (t2.id = t1.term)) UNION SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, t3.path, ARRAY(SELECT catalog.id FROM catalog WHERE (catalog.path ~ (((t3.path)::text || '.*'::text))::lquery)) AS childrens FROM map_member_to_rule t1, rules t2, editions t3 WHERE ((((t1.section)::text = 'editions'::text) AND (t2.id = t1.term)) AND (t3.id = t1.binding))) UNION SELECT t2.id, t1.member, t2.section, t2.subsection, t2.term, t1.area, t1.binding, t3.path, ARRAY(SELECT catalog.id FROM catalog WHERE (catalog.path ~ (((t3.path)::text || '.*'::text))::lquery)) AS childrens FROM map_member_to_rule t1, rules t2, catalog t3 WHERE ((((t1.section)::text = 'catalog'::text) AND (t2.id = t1.term)) AND (t3.id = t1.binding));


--
-- TOC entry 2179 (class 2604 OID 19618)
-- Dependencies: 1822 1821
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ad_advertisers ALTER COLUMN serialnum SET DEFAULT nextval('ad_advertisers_serialnum_seq'::regclass);


--
-- TOC entry 2202 (class 2604 OID 19619)
-- Dependencies: 1828 1827
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ad_requests ALTER COLUMN serialnum SET DEFAULT nextval('ad_requests_serialnum_seq'::regclass);


--
-- TOC entry 2303 (class 2604 OID 19620)
-- Dependencies: 1853 1852
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE fascicles_requests ALTER COLUMN serialnum SET DEFAULT nextval('fascicles_requests_serialnum_seq'::regclass);


SET search_path = plugins, pg_catalog;

--
-- TOC entry 2370 (class 2606 OID 19622)
-- Dependencies: 1817 1817
-- Name: l18n_l18n_original_key; Type: CONSTRAINT; Schema: plugins; Owner: -
--

ALTER TABLE ONLY l18n
    ADD CONSTRAINT l18n_l18n_original_key UNIQUE (l18n_original);


--
-- TOC entry 2372 (class 2606 OID 19624)
-- Dependencies: 1817 1817
-- Name: l18n_pkey; Type: CONSTRAINT; Schema: plugins; Owner: -
--

ALTER TABLE ONLY l18n
    ADD CONSTRAINT l18n_pkey PRIMARY KEY (id);


--
-- TOC entry 2374 (class 2606 OID 19626)
-- Dependencies: 1818 1818
-- Name: menu_pkey; Type: CONSTRAINT; Schema: plugins; Owner: -
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (id);


--
-- TOC entry 2376 (class 2606 OID 19628)
-- Dependencies: 1818 1818 1818 1818
-- Name: menu_plugin_key; Type: CONSTRAINT; Schema: plugins; Owner: -
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_plugin_key UNIQUE (plugin, menu_section, menu_id);


--
-- TOC entry 2378 (class 2606 OID 19630)
-- Dependencies: 1819 1819
-- Name: routes_pkey; Type: CONSTRAINT; Schema: plugins; Owner: -
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- TOC entry 2380 (class 2606 OID 19632)
-- Dependencies: 1819 1819 1819
-- Name: routes_plugin_key; Type: CONSTRAINT; Schema: plugins; Owner: -
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_plugin_key UNIQUE (plugin, route_url);


--
-- TOC entry 2382 (class 2606 OID 19634)
-- Dependencies: 1820 1820
-- Name: rules_pkey; Type: CONSTRAINT; Schema: plugins; Owner: -
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- TOC entry 2384 (class 2606 OID 19636)
-- Dependencies: 1820 1820 1820
-- Name: rules_plugin_key; Type: CONSTRAINT; Schema: plugins; Owner: -
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_plugin_key UNIQUE (plugin, rule_term);


SET search_path = public, pg_catalog;

--
-- TOC entry 2386 (class 2606 OID 19638)
-- Dependencies: 1821 1821
-- Name: ad_advertisers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_advertisers
    ADD CONSTRAINT ad_advertisers_pkey PRIMARY KEY (id);


--
-- TOC entry 2388 (class 2606 OID 19640)
-- Dependencies: 1823 1823
-- Name: ad_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_index
    ADD CONSTRAINT ad_index_pkey PRIMARY KEY (id);


--
-- TOC entry 2390 (class 2606 OID 19642)
-- Dependencies: 1824 1824
-- Name: ad_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_modules
    ADD CONSTRAINT ad_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2392 (class 2606 OID 19644)
-- Dependencies: 1825 1825
-- Name: ad_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_pages
    ADD CONSTRAINT ad_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 2394 (class 2606 OID 19646)
-- Dependencies: 1826 1826
-- Name: ad_places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_places
    ADD CONSTRAINT ad_places_pkey PRIMARY KEY (id);


--
-- TOC entry 2396 (class 2606 OID 19648)
-- Dependencies: 1827 1827
-- Name: ad_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ad_requests
    ADD CONSTRAINT ad_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 2400 (class 2606 OID 19652)
-- Dependencies: 1830 1830
-- Name: cache_downloads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_downloads
    ADD CONSTRAINT cache_downloads_pkey PRIMARY KEY (id);


--
-- TOC entry 2402 (class 2606 OID 19654)
-- Dependencies: 1831 1831 1831
-- Name: cache_files_entity_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_files
    ADD CONSTRAINT cache_files_entity_key UNIQUE (file_path, file_name);


--
-- TOC entry 2404 (class 2606 OID 19656)
-- Dependencies: 1831 1831
-- Name: cache_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_files
    ADD CONSTRAINT cache_files_pkey PRIMARY KEY (id);


--
-- TOC entry 2406 (class 2606 OID 19658)
-- Dependencies: 1832 1832
-- Name: cache_hotsave_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_hotsave
    ADD CONSTRAINT cache_hotsave_pkey PRIMARY KEY (id);


--
-- TOC entry 2418 (class 2606 OID 19660)
-- Dependencies: 1839 1839
-- Name: cache_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_versions
    ADD CONSTRAINT cache_versions_pkey PRIMARY KEY (id);


--
-- TOC entry 2408 (class 2606 OID 19664)
-- Dependencies: 1833 1833
-- Name: catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY catalog
    ADD CONSTRAINT catalog_pkey PRIMARY KEY (id);


--
-- TOC entry 2398 (class 2606 OID 19666)
-- Dependencies: 1829 1829
-- Name: chains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY branches
    ADD CONSTRAINT chains_pkey PRIMARY KEY (id);


--
-- TOC entry 2420 (class 2606 OID 19668)
-- Dependencies: 1840 1840
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- TOC entry 2422 (class 2606 OID 19670)
-- Dependencies: 1841 1841
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- TOC entry 2424 (class 2606 OID 19672)
-- Dependencies: 1842 1842
-- Name: editions_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions_options
    ADD CONSTRAINT editions_options_pkey PRIMARY KEY (id);


--
-- TOC entry 2410 (class 2606 OID 19674)
-- Dependencies: 1834 1834
-- Name: editions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions
    ADD CONSTRAINT editions_pkey PRIMARY KEY (id);


--
-- TOC entry 2428 (class 2606 OID 19676)
-- Dependencies: 1844 1844 1844 1844
-- Name: fascicles_indx_headlines_edition_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_edition_key UNIQUE (edition, fascicle, tag);


--
-- TOC entry 2430 (class 2606 OID 19678)
-- Dependencies: 1844 1844
-- Name: fascicles_indx_headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_pkey PRIMARY KEY (id);


--
-- TOC entry 2432 (class 2606 OID 19680)
-- Dependencies: 1845 1845 1845 1845 1845
-- Name: fascicles_indx_rubrics_edition_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_edition_key UNIQUE (edition, fascicle, headline, tag);


--
-- TOC entry 2434 (class 2606 OID 19682)
-- Dependencies: 1845 1845
-- Name: fascicles_indx_rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_pkey PRIMARY KEY (id);


--
-- TOC entry 2436 (class 2606 OID 19684)
-- Dependencies: 1846 1846
-- Name: fascicles_map_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 2438 (class 2606 OID 19686)
-- Dependencies: 1847 1847
-- Name: fascicles_map_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2440 (class 2606 OID 19688)
-- Dependencies: 1848 1848
-- Name: fascicles_map_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_requests
    ADD CONSTRAINT fascicles_map_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 2442 (class 2606 OID 19690)
-- Dependencies: 1849 1849
-- Name: fascicles_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2444 (class 2606 OID 19692)
-- Dependencies: 1850 1850
-- Name: fascicles_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_options
    ADD CONSTRAINT fascicles_options_pkey PRIMARY KEY (id);


--
-- TOC entry 2446 (class 2606 OID 19694)
-- Dependencies: 1851 1851
-- Name: fascicles_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 2426 (class 2606 OID 19696)
-- Dependencies: 1843 1843
-- Name: fascicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_pkey PRIMARY KEY (id);


--
-- TOC entry 2449 (class 2606 OID 19698)
-- Dependencies: 1852 1852
-- Name: fascicles_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_requests
    ADD CONSTRAINT fascicles_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 2451 (class 2606 OID 19700)
-- Dependencies: 1854 1854
-- Name: fascicles_tmpl_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_index
    ADD CONSTRAINT fascicles_tmpl_index_pkey PRIMARY KEY (id);


--
-- TOC entry 2453 (class 2606 OID 19702)
-- Dependencies: 1855 1855
-- Name: fascicles_tmpl_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2455 (class 2606 OID 19704)
-- Dependencies: 1856 1856
-- Name: fascicles_tmpl_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_pages
    ADD CONSTRAINT fascicles_tmpl_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 2457 (class 2606 OID 19706)
-- Dependencies: 1857 1857
-- Name: fascicles_tmpl_places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_places
    ADD CONSTRAINT fascicles_tmpl_places_pkey PRIMARY KEY (id);


--
-- TOC entry 2459 (class 2606 OID 19708)
-- Dependencies: 1858 1858
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- TOC entry 2461 (class 2606 OID 19710)
-- Dependencies: 1859 1859 1859
-- Name: indx_headlines_edition_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_edition_key UNIQUE (edition, tag);


--
-- TOC entry 2463 (class 2606 OID 19712)
-- Dependencies: 1859 1859
-- Name: indx_headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_pkey PRIMARY KEY (id);


--
-- TOC entry 2465 (class 2606 OID 19714)
-- Dependencies: 1860 1860 1860 1860
-- Name: indx_rubrics_edition_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_edition_key UNIQUE (edition, headline, tag);


--
-- TOC entry 2467 (class 2606 OID 19716)
-- Dependencies: 1860 1860
-- Name: indx_rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_pkey PRIMARY KEY (id);


--
-- TOC entry 2469 (class 2606 OID 19718)
-- Dependencies: 1861 1861
-- Name: indx_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_tags
    ADD CONSTRAINT indx_tags_pkey PRIMARY KEY (id);


--
-- TOC entry 2471 (class 2606 OID 19720)
-- Dependencies: 1862 1862
-- Name: logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 2473 (class 2606 OID 19722)
-- Dependencies: 1863 1863 1863
-- Name: map_member_to_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_pkey PRIMARY KEY (member, catalog);


--
-- TOC entry 2412 (class 2606 OID 19724)
-- Dependencies: 1835 1835
-- Name: map_member_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_rule
    ADD CONSTRAINT map_member_to_rule_pkey PRIMARY KEY (id);


--
-- TOC entry 2475 (class 2606 OID 19726)
-- Dependencies: 1864 1864 1864 1864
-- Name: map_principals_to_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_principals_to_stages
    ADD CONSTRAINT map_principals_to_stages_pkey PRIMARY KEY (id, stage, principal);


--
-- TOC entry 2477 (class 2606 OID 19728)
-- Dependencies: 1865 1865 1865 1865
-- Name: map_role_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_pkey PRIMARY KEY (role, rule, mode);


--
-- TOC entry 2414 (class 2606 OID 19730)
-- Dependencies: 1836 1836
-- Name: member_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY members
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- TOC entry 2483 (class 2606 OID 19732)
-- Dependencies: 1868 1868
-- Name: member_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT member_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 2497 (class 2606 OID 19734)
-- Dependencies: 1875 1875
-- Name: member_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT member_session_pkey PRIMARY KEY (id);


--
-- TOC entry 2479 (class 2606 OID 19736)
-- Dependencies: 1866 1866
-- Name: migration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY migration
    ADD CONSTRAINT migration_pkey PRIMARY KEY (id);


--
-- TOC entry 2481 (class 2606 OID 19738)
-- Dependencies: 1867 1867
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- TOC entry 2487 (class 2606 OID 19740)
-- Dependencies: 1870 1870
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 2493 (class 2606 OID 19742)
-- Dependencies: 1873 1873
-- Name: rss_feeds_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rss_feeds_mapping
    ADD CONSTRAINT rss_feeds_mapping_pkey PRIMARY KEY (id);


--
-- TOC entry 2495 (class 2606 OID 19744)
-- Dependencies: 1874 1874
-- Name: rss_feeds_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rss_feeds_options
    ADD CONSTRAINT rss_feeds_options_pkey PRIMARY KEY (id);


--
-- TOC entry 2491 (class 2606 OID 19746)
-- Dependencies: 1872 1872
-- Name: rss_feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rss_feeds
    ADD CONSTRAINT rss_feeds_pkey PRIMARY KEY (id);


--
-- TOC entry 2489 (class 2606 OID 19748)
-- Dependencies: 1871 1871
-- Name: rss_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rss
    ADD CONSTRAINT rss_pkey PRIMARY KEY (id);


--
-- TOC entry 2416 (class 2606 OID 19750)
-- Dependencies: 1837 1837
-- Name: rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- TOC entry 2499 (class 2606 OID 19752)
-- Dependencies: 1876 1876
-- Name: stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- TOC entry 2501 (class 2606 OID 19754)
-- Dependencies: 1877 1877
-- Name: state_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- TOC entry 2485 (class 2606 OID 19756)
-- Dependencies: 1869 1869
-- Name: statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY readiness
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- TOC entry 2447 (class 1259 OID 19757)
-- Dependencies: 1851
-- Name: fki_; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_ ON fascicles_pages USING btree (origin);


--
-- TOC entry 2532 (class 2620 OID 19761)
-- Dependencies: 95 1833
-- Name: catalog_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- TOC entry 2533 (class 2620 OID 19762)
-- Dependencies: 96 1833
-- Name: catalog_insert_before; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_insert_before
    BEFORE INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- TOC entry 2534 (class 2620 OID 19763)
-- Dependencies: 97 1833
-- Name: catalog_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- TOC entry 2535 (class 2620 OID 19767)
-- Dependencies: 1834 95
-- Name: editions_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_delete_after
    AFTER DELETE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- TOC entry 2536 (class 2620 OID 19768)
-- Dependencies: 96 1834
-- Name: editions_insert_before; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_insert_before
    BEFORE INSERT ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- TOC entry 2537 (class 2620 OID 19769)
-- Dependencies: 97 1834
-- Name: editions_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_update_after
    AFTER UPDATE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- TOC entry 2538 (class 2620 OID 19770)
-- Dependencies: 1846 49
-- Name: fascicles_map_documents_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_documents_delete_after
    AFTER DELETE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_delete_after_trigger();


--
-- TOC entry 2539 (class 2620 OID 19771)
-- Dependencies: 1846 50
-- Name: fascicles_map_documents_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_documents_update_after
    AFTER INSERT OR UPDATE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_update_after_trigger();


--
-- TOC entry 2540 (class 2620 OID 19772)
-- Dependencies: 1847 51
-- Name: fascicles_map_modules_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_modules_delete_after
    AFTER DELETE ON fascicles_map_modules
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_modules_delete_after_trigger();


--
-- TOC entry 2541 (class 2620 OID 19773)
-- Dependencies: 1847 52
-- Name: fascicles_map_modules_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_modules_update_after
    AFTER INSERT OR UPDATE ON fascicles_map_modules
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_modules_update_after_trigger();


--
-- TOC entry 2502 (class 2606 OID 19781)
-- Dependencies: 1830 1841 2421
-- Name: cache_downloads_document_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_downloads
    ADD CONSTRAINT cache_downloads_document_fkey FOREIGN KEY (document) REFERENCES documents(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2503 (class 2606 OID 19786)
-- Dependencies: 1830 1836 2413
-- Name: cache_downloads_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_downloads
    ADD CONSTRAINT cache_downloads_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2504 (class 2606 OID 19791)
-- Dependencies: 1843 1834 2409
-- Name: fascicles_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2505 (class 2606 OID 19796)
-- Dependencies: 1844 1843 2425
-- Name: fascicles_indx_headlines_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2506 (class 2606 OID 19801)
-- Dependencies: 1845 1843 2425
-- Name: fascicles_indx_rubrics_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2507 (class 2606 OID 19806)
-- Dependencies: 1845 1844 2429
-- Name: fascicles_indx_rubrics_headline_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_headline_fkey FOREIGN KEY (headline) REFERENCES fascicles_indx_headlines(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2508 (class 2606 OID 19811)
-- Dependencies: 1846 1841 2421
-- Name: fascicles_map_documents_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_entity_fkey FOREIGN KEY (entity) REFERENCES documents(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2509 (class 2606 OID 19816)
-- Dependencies: 1846 1843 2425
-- Name: fascicles_map_documents_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2510 (class 2606 OID 19821)
-- Dependencies: 1846 1851 2445
-- Name: fascicles_map_documents_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_page_fkey FOREIGN KEY (page) REFERENCES fascicles_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2511 (class 2606 OID 19826)
-- Dependencies: 1847 1843 2425
-- Name: fascicles_map_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2512 (class 2606 OID 19831)
-- Dependencies: 1847 1849 2441
-- Name: fascicles_map_modules_module_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_module_fkey FOREIGN KEY (module) REFERENCES fascicles_modules(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2513 (class 2606 OID 19836)
-- Dependencies: 1851 1847 2445
-- Name: fascicles_map_modules_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_page_fkey FOREIGN KEY (page) REFERENCES fascicles_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2514 (class 2606 OID 19841)
-- Dependencies: 2425 1848 1843
-- Name: fascicles_map_requests_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_requests
    ADD CONSTRAINT fascicles_map_requests_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2515 (class 2606 OID 19846)
-- Dependencies: 2425 1849 1843
-- Name: fascicles_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2516 (class 2606 OID 19851)
-- Dependencies: 1855 2452 1849
-- Name: fascicles_modules_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_origin_fkey FOREIGN KEY (origin) REFERENCES fascicles_tmpl_modules(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2517 (class 2606 OID 19856)
-- Dependencies: 1857 1849 2456
-- Name: fascicles_modules_place_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_place_fkey FOREIGN KEY (place) REFERENCES fascicles_tmpl_places(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2518 (class 2606 OID 19861)
-- Dependencies: 2425 1843 1850
-- Name: fascicles_options_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_options
    ADD CONSTRAINT fascicles_options_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2519 (class 2606 OID 19866)
-- Dependencies: 2425 1851 1843
-- Name: fascicles_pages_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2520 (class 2606 OID 19871)
-- Dependencies: 2454 1851 1856
-- Name: fascicles_pages_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_origin_fkey FOREIGN KEY (origin) REFERENCES fascicles_tmpl_pages(id) ON DELETE RESTRICT;


--
-- TOC entry 2521 (class 2606 OID 19876)
-- Dependencies: 2425 1843 1852
-- Name: fascicles_requests_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_requests
    ADD CONSTRAINT fascicles_requests_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2522 (class 2606 OID 19881)
-- Dependencies: 1854 1843 2425
-- Name: fascicles_tmpl_index_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_index
    ADD CONSTRAINT fascicles_tmpl_index_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2523 (class 2606 OID 19886)
-- Dependencies: 2425 1843 1855
-- Name: fascicles_tmpl_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2524 (class 2606 OID 19891)
-- Dependencies: 2454 1856 1855
-- Name: fascicles_tmpl_modules_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_page_fkey FOREIGN KEY (page) REFERENCES fascicles_tmpl_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2525 (class 2606 OID 19896)
-- Dependencies: 2425 1856 1843
-- Name: fascicles_tmpl_pages_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_pages
    ADD CONSTRAINT fascicles_tmpl_pages_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2526 (class 2606 OID 19901)
-- Dependencies: 1857 2425 1843
-- Name: fascicles_tmpl_places_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_places
    ADD CONSTRAINT fascicles_tmpl_places_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2527 (class 2606 OID 19906)
-- Dependencies: 1859 2409 1834
-- Name: indx_headlines_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2528 (class 2606 OID 19911)
-- Dependencies: 2409 1860 1834
-- Name: indx_rubrics_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2529 (class 2606 OID 19916)
-- Dependencies: 1860 2462 1859
-- Name: indx_rubrics_headline_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_headline_fkey FOREIGN KEY (headline) REFERENCES indx_headlines(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2530 (class 2606 OID 19921)
-- Dependencies: 2413 1863 1836
-- Name: map_member_to_catalog_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2531 (class 2606 OID 19926)
-- Dependencies: 2486 1865 1870
-- Name: map_role_to_rule_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_role_fkey FOREIGN KEY (role) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2011-04-12 13:07:59 MSD

--
-- PostgreSQL database dump complete
--

