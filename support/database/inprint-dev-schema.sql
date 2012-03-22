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
-- Name: plugins; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA plugins;


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- Name: lquery; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE lquery;


--
-- Name: lquery_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lquery_in(cstring) RETURNS lquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_in';


--
-- Name: lquery_out(lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lquery_out(lquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'lquery_out';


--
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
-- Name: ltree; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree;


--
-- Name: ltree_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_in(cstring) RETURNS ltree
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_in';


--
-- Name: ltree_out(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_out(ltree) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_out';


--
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
-- Name: ltree_gist; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltree_gist;


--
-- Name: ltree_gist_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gist_in(cstring) RETURNS ltree_gist
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_in';


--
-- Name: ltree_gist_out(ltree_gist); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gist_out(ltree_gist) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltree_gist_out';


--
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
-- Name: ltxtquery; Type: SHELL TYPE; Schema: public; Owner: -
--

CREATE TYPE ltxtquery;


--
-- Name: ltxtq_in(cstring); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_in(cstring) RETURNS ltxtquery
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_in';


--
-- Name: ltxtq_out(ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_out(ltxtquery) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/ltree', 'ltxtq_out';


--
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
-- Name: _lt_q_regex(ltree[], lquery[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _lt_q_regex(ltree[], lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_regex';


--
-- Name: _lt_q_rregex(lquery[], ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _lt_q_rregex(lquery[], ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lt_q_rregex';


--
-- Name: _ltq_extract_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_extract_regex(ltree[], lquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_extract_regex';


--
-- Name: _ltq_regex(ltree[], lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_regex(ltree[], lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_regex';


--
-- Name: _ltq_rregex(lquery, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltq_rregex(lquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltq_rregex';


--
-- Name: _ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_compress';


--
-- Name: _ltree_consistent(internal, internal, smallint, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_consistent(internal, internal, smallint, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_consistent';


--
-- Name: _ltree_extract_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_extract_isparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_isparent';


--
-- Name: _ltree_extract_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_extract_risparent(ltree[], ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_extract_risparent';


--
-- Name: _ltree_isparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_isparent(ltree[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_isparent';


--
-- Name: _ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_penalty';


--
-- Name: _ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_picksplit';


--
-- Name: _ltree_r_isparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_r_isparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_isparent';


--
-- Name: _ltree_r_risparent(ltree, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_r_risparent(ltree, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_r_risparent';


--
-- Name: _ltree_risparent(ltree[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_risparent(ltree[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_risparent';


--
-- Name: _ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_same';


--
-- Name: _ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltree_union(internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltree_union';


--
-- Name: _ltxtq_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_exec(ltree[], ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_exec';


--
-- Name: _ltxtq_extract_exec(ltree[], ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_extract_exec(ltree[], ltxtquery) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_extract_exec';


--
-- Name: _ltxtq_rexec(ltxtquery, ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION _ltxtq_rexec(ltxtquery, ltree[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_ltxtq_rexec';


--
-- Name: digest(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION digest(text, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_digest';


--
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
-- Name: index(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION index(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


--
-- Name: index(ltree, ltree, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION index(ltree, ltree, integer) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_index';


--
-- Name: lca(ltree[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree[]) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', '_lca';


--
-- Name: lca(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- Name: lca(ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- Name: lca(ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- Name: lca(ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- Name: lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lca(ltree, ltree, ltree, ltree, ltree, ltree, ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lca';


--
-- Name: lt_q_regex(ltree, lquery[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lt_q_regex(ltree, lquery[]) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_regex';


--
-- Name: lt_q_rregex(lquery[], ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lt_q_rregex(lquery[], ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'lt_q_rregex';


--
-- Name: ltq_regex(ltree, lquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltq_regex(ltree, lquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_regex';


--
-- Name: ltq_rregex(lquery, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltq_rregex(lquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltq_rregex';


--
-- Name: ltree2text(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree2text(ltree) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree2text';


--
-- Name: ltree_addltree(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_addltree(ltree, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addltree';


--
-- Name: ltree_addtext(ltree, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_addtext(ltree, text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_addtext';


--
-- Name: ltree_cmp(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_cmp(ltree, ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_cmp';


--
-- Name: ltree_compress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_compress';


--
-- Name: ltree_consistent(internal, internal, smallint, oid, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_consistent(internal, internal, smallint, oid, internal) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_consistent';


--
-- Name: ltree_decompress(internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_decompress';


--
-- Name: ltree_eq(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_eq(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_eq';


--
-- Name: ltree_ge(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_ge(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ge';


--
-- Name: ltree_gt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_gt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_gt';


--
-- Name: ltree_isparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_isparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_isparent';


--
-- Name: ltree_le(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_le(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_le';


--
-- Name: ltree_lt(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_lt(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_lt';


--
-- Name: ltree_ne(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_ne(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_ne';


--
-- Name: ltree_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_penalty';


--
-- Name: ltree_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_picksplit';


--
-- Name: ltree_risparent(ltree, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_risparent(ltree, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_risparent';


--
-- Name: ltree_same(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_same(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_same';


--
-- Name: ltree_textadd(text, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_textadd(text, ltree) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_textadd';


--
-- Name: ltree_union(internal, internal); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltree_union(internal, internal) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltree_union';


--
-- Name: ltreeparentsel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltreeparentsel(internal, oid, internal, integer) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltreeparentsel';


--
-- Name: ltxtq_exec(ltree, ltxtquery); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_exec(ltree, ltxtquery) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_exec';


--
-- Name: ltxtq_rexec(ltxtquery, ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ltxtq_rexec(ltxtquery, ltree) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'ltxtq_rexec';


--
-- Name: nlevel(ltree); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION nlevel(ltree) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'nlevel';


--
-- Name: subltree(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subltree(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subltree';


--
-- Name: subpath(ltree, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subpath(ltree, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


--
-- Name: subpath(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION subpath(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


--
-- Name: text2ltree(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION text2ltree(text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'text2ltree';


--
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
-- Name: uuid_generate_v4(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION uuid_generate_v4() RETURNS uuid
    LANGUAGE c STRICT
    AS '$libdir/uuid-ossp', 'uuid_generate_v4';


--
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
-- Name: ?<@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?<@ (
    PROCEDURE = _ltree_extract_risparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


--
-- Name: ?@; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?@ (
    PROCEDURE = _ltxtq_extract_exec,
    LEFTARG = ltree[],
    RIGHTARG = ltxtquery
);


--
-- Name: ?@>; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?@> (
    PROCEDURE = _ltree_extract_isparent,
    LEFTARG = ltree[],
    RIGHTARG = ltree
);


--
-- Name: ?~; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR ?~ (
    PROCEDURE = _ltq_extract_regex,
    LEFTARG = ltree[],
    RIGHTARG = lquery
);


--
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
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addltree,
    LEFTARG = ltree,
    RIGHTARG = ltree
);


--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_addtext,
    LEFTARG = ltree,
    RIGHTARG = text
);


--
-- Name: ||; Type: OPERATOR; Schema: public; Owner: -
--

CREATE OPERATOR || (
    PROCEDURE = ltree_textadd,
    LEFTARG = text,
    RIGHTARG = ltree
);


--
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
-- Name: gist__ltree_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY gist__ltree_ops USING gist;


--
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
-- Name: gist_ltree_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY gist_ltree_ops USING gist;


--
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
-- Name: ltree_ops; Type: OPERATOR FAMILY; Schema: public; Owner: -
--

CREATE OPERATOR FAMILY ltree_ops USING btree;


--
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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: l18n; Type: TABLE; Schema: plugins; Owner: -; Tablespace: 
--

CREATE TABLE l18n (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    plugin character varying NOT NULL,
    l18n_language character varying NOT NULL,
    l18n_original character varying NOT NULL,
    l18n_translation character varying NOT NULL
);


--
-- Name: menu; Type: TABLE; Schema: plugins; Owner: -; Tablespace: 
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
-- Name: routes; Type: TABLE; Schema: plugins; Owner: -; Tablespace: 
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
-- Name: rules; Type: TABLE; Schema: plugins; Owner: -; Tablespace: 
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
-- Name: ad_advertisers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ad_advertisers (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    edition uuid NOT NULL,
    serialnum integer NOT NULL,
    title character varying,
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
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ad_advertisers_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ad_advertisers_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ad_advertisers_serialnum_seq OWNED BY ad_advertisers.serialnum;


--
-- Name: ad_index; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: ad_modules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    updated timestamp(0) with time zone DEFAULT now(),
    check_width real DEFAULT 0 NOT NULL,
    check_height real DEFAULT 0 NOT NULL,
    check_width_float real DEFAULT 0 NOT NULL,
    check_height_float real DEFAULT 0 NOT NULL
);


--
-- Name: ad_pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: ad_places; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: ad_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ad_requests_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ad_requests_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ad_requests_serialnum_seq OWNED BY ad_requests.serialnum;


--
-- Name: branches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: cache_downloads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: cache_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    updated timestamp(6) with time zone DEFAULT now() NOT NULL,
    file_color character varying,
    file_resolution integer DEFAULT 0 NOT NULL,
    file_width real DEFAULT 0 NOT NULL,
    file_height real DEFAULT 0 NOT NULL
);


--
-- Name: cache_hotsave; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: cache_versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: catalog; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: editions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: editions_options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: fascicles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    doc_enabled boolean DEFAULT false NOT NULL,
    adv_enabled boolean DEFAULT false,
    deleted boolean DEFAULT false NOT NULL,
    num integer DEFAULT 0 NOT NULL,
    anum integer DEFAULT 0 NOT NULL,
    tmpl uuid,
    tmpl_shortcut character varying DEFAULT ''::character varying
);


--
-- Name: fascicles_indx_headlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: fascicles_indx_rubrics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: fascicles_map_documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: fascicles_map_modules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: fascicles_map_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: fascicles_modules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    updated timestamp(0) with time zone DEFAULT now(),
    check_width real DEFAULT 0 NOT NULL,
    check_height real DEFAULT 0 NOT NULL,
    check_width_float real DEFAULT 0 NOT NULL,
    check_height_float real DEFAULT 0 NOT NULL
);


--
-- Name: fascicles_pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: fascicles_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
    squib character varying NOT NULL,
    check_status character varying DEFAULT 'new'::character varying NOT NULL,
    anothers_layout boolean DEFAULT false NOT NULL,
    imposed boolean DEFAULT false NOT NULL
);


--
-- Name: fascicles_requests_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fascicles_requests_comments (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    entity uuid NOT NULL,
    member uuid NOT NULL,
    member_shortcut character varying NOT NULL,
    check_status character varying NOT NULL,
    fulltext character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- Name: fascicles_requests_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fascicles_requests_files (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    fpath character varying NOT NULL,
    fname character varying NOT NULL,
    forname character varying NOT NULL,
    fextension character varying NOT NULL,
    fmime character varying NOT NULL,
    fdigest character varying NOT NULL,
    fthumbnail character varying,
    fdescription character varying,
    fsize integer DEFAULT 0 NOT NULL,
    flength integer DEFAULT 0 NOT NULL,
    fcolor character varying,
    fresolution integer DEFAULT 0 NOT NULL,
    fwidth real DEFAULT 0 NOT NULL,
    fheight real DEFAULT 0 NOT NULL,
    fexists boolean DEFAULT true NOT NULL,
    fimpose boolean DEFAULT true NOT NULL,
    fstatus character varying,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- Name: fascicles_requests_serialnum_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fascicles_requests_serialnum_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: fascicles_requests_serialnum_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fascicles_requests_serialnum_seq OWNED BY fascicles_requests.serialnum;


--
-- Name: fascicles_tmpl_index; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: fascicles_tmpl_modules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: fascicles_tmpl_pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: fascicles_tmpl_places; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: history; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: indx_headlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: indx_rubrics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: indx_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE indx_tags (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    title character varying NOT NULL,
    description character varying,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- Name: logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: map_member_to_catalog; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE map_member_to_catalog (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    catalog uuid NOT NULL
);


--
-- Name: map_member_to_rule; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: map_principals_to_stages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE map_principals_to_stages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    stage uuid NOT NULL,
    catalog uuid NOT NULL,
    principal uuid NOT NULL
);


--
-- Name: map_role_to_rule; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE map_role_to_rule (
    role uuid NOT NULL,
    rule uuid NOT NULL,
    mode character varying NOT NULL
);


--
-- Name: members; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE members (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    login character varying NOT NULL,
    password character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- Name: migration; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE migration (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    mtype character varying NOT NULL,
    oldid uuid NOT NULL,
    newid uuid NOT NULL
);


--
-- Name: options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying NOT NULL
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: readiness; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: rss; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: rss_feeds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: rss_feeds_mapping; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rss_feeds_mapping (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    feed uuid NOT NULL,
    nature character varying NOT NULL,
    tag uuid NOT NULL
);


--
-- Name: rss_feeds_options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rss_feeds_options (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    feed uuid NOT NULL,
    option_name character varying NOT NULL,
    option_value character varying NOT NULL
);


--
-- Name: rules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    member uuid NOT NULL,
    ipaddress character varying NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL,
    updated timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: stages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: state; Type: TABLE; Schema: public; Owner: -; Tablespace: 
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
-- Name: view_principals; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_principals AS
    SELECT t1.id, 'member' AS type, t2.title, t2.shortcut, t2.job_position AS description FROM members t1, profiles t2 WHERE (t1.id = t2.id) UNION SELECT catalog.id, 'group' AS type, catalog.title, catalog.shortcut, catalog.description FROM catalog;


--
-- Name: view_assignments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_assignments AS
    SELECT t1.id, t1.catalog, t5.shortcut AS catalog_shortcut, t6.type AS principal_type, t1.principal, t6.shortcut AS principal_shortcut, t2.id AS branch, t2.shortcut AS branch_shortcut, t1.stage, t3.shortcut AS stage_shortcut, t4.id AS readiness, t4.shortcut AS readiness_shortcut, t4.weight AS progress, t4.color FROM map_principals_to_stages t1, branches t2, stages t3, readiness t4, catalog t5, view_principals t6 WHERE (((((t2.id = t3.branch) AND (t3.id = t1.stage)) AND (t4.id = t3.readiness)) AND (t5.id = t1.catalog)) AND (t6.id = t1.principal));


--
-- Name: view_rules; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW view_rules AS
    SELECT rules.id, 'system' AS plugin, rules.term, rules.section, rules.subsection, (((((rules.section)::text || '.'::text) || (rules.subsection)::text) || '.'::text) || (rules.term)::text) AS termkey, rules.icon, rules.title, rules.description, rules.sortorder, true AS enabled FROM rules UNION SELECT rules.id, rules.plugin, rules.rule_term AS term, rules.rule_section AS section, rules.rule_subsection AS subsection, (((((rules.rule_section)::text || '.'::text) || (rules.rule_subsection)::text) || '.'::text) || (rules.rule_term)::text) AS termkey, rules.rule_icon AS icon, rules.rule_title AS title, rules.rule_description AS description, rules.rule_sortorder AS sortorder, rules.rule_enabled AS enabled FROM plugins.rules;


--
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ad_advertisers ALTER COLUMN serialnum SET DEFAULT nextval('ad_advertisers_serialnum_seq'::regclass);


--
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ad_requests ALTER COLUMN serialnum SET DEFAULT nextval('ad_requests_serialnum_seq'::regclass);


--
-- Name: serialnum; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE fascicles_requests ALTER COLUMN serialnum SET DEFAULT nextval('fascicles_requests_serialnum_seq'::regclass);


SET search_path = plugins, pg_catalog;

--
-- Name: l18n_l18n_original_key; Type: CONSTRAINT; Schema: plugins; Owner: -; Tablespace: 
--

ALTER TABLE ONLY l18n
    ADD CONSTRAINT l18n_l18n_original_key UNIQUE (l18n_original);


--
-- Name: l18n_pkey; Type: CONSTRAINT; Schema: plugins; Owner: -; Tablespace: 
--

ALTER TABLE ONLY l18n
    ADD CONSTRAINT l18n_pkey PRIMARY KEY (id);


--
-- Name: menu_pkey; Type: CONSTRAINT; Schema: plugins; Owner: -; Tablespace: 
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (id);


--
-- Name: menu_plugin_key; Type: CONSTRAINT; Schema: plugins; Owner: -; Tablespace: 
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_plugin_key UNIQUE (plugin, menu_section, menu_id);


--
-- Name: routes_pkey; Type: CONSTRAINT; Schema: plugins; Owner: -; Tablespace: 
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: routes_plugin_key; Type: CONSTRAINT; Schema: plugins; Owner: -; Tablespace: 
--

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_plugin_key UNIQUE (plugin, route_url);


--
-- Name: rules_pkey; Type: CONSTRAINT; Schema: plugins; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- Name: rules_plugin_key; Type: CONSTRAINT; Schema: plugins; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_plugin_key UNIQUE (plugin, rule_term);


SET search_path = public, pg_catalog;

--
-- Name: ad_advertisers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ad_advertisers
    ADD CONSTRAINT ad_advertisers_pkey PRIMARY KEY (id);


--
-- Name: ad_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ad_index
    ADD CONSTRAINT ad_index_pkey PRIMARY KEY (id);


--
-- Name: ad_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ad_modules
    ADD CONSTRAINT ad_modules_pkey PRIMARY KEY (id);


--
-- Name: ad_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ad_pages
    ADD CONSTRAINT ad_pages_pkey PRIMARY KEY (id);


--
-- Name: ad_places_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ad_places
    ADD CONSTRAINT ad_places_pkey PRIMARY KEY (id);


--
-- Name: ad_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ad_requests
    ADD CONSTRAINT ad_requests_pkey PRIMARY KEY (id);


--
-- Name: cache_downloads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cache_downloads
    ADD CONSTRAINT cache_downloads_pkey PRIMARY KEY (id);


--
-- Name: cache_files_entity_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cache_files
    ADD CONSTRAINT cache_files_entity_key UNIQUE (file_path, file_name);


--
-- Name: cache_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cache_files
    ADD CONSTRAINT cache_files_pkey PRIMARY KEY (id);


--
-- Name: cache_hotsave_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cache_hotsave
    ADD CONSTRAINT cache_hotsave_pkey PRIMARY KEY (id);


--
-- Name: cache_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cache_versions
    ADD CONSTRAINT cache_versions_pkey PRIMARY KEY (id);


--
-- Name: catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY catalog
    ADD CONSTRAINT catalog_pkey PRIMARY KEY (id);


--
-- Name: chains_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY branches
    ADD CONSTRAINT chains_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: editions_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY editions_options
    ADD CONSTRAINT editions_options_pkey PRIMARY KEY (id);


--
-- Name: editions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY editions
    ADD CONSTRAINT editions_pkey PRIMARY KEY (id);


--
-- Name: fascicles_indx_headlines_edition_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_edition_key UNIQUE (edition, fascicle, tag);


--
-- Name: fascicles_indx_headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_pkey PRIMARY KEY (id);


--
-- Name: fascicles_indx_rubrics_edition_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_edition_key UNIQUE (edition, fascicle, headline, tag);


--
-- Name: fascicles_indx_rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_pkey PRIMARY KEY (id);


--
-- Name: fascicles_map_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_pkey PRIMARY KEY (id);


--
-- Name: fascicles_map_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_pkey PRIMARY KEY (id);


--
-- Name: fascicles_map_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_map_requests
    ADD CONSTRAINT fascicles_map_requests_pkey PRIMARY KEY (id);


--
-- Name: fascicles_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_pkey PRIMARY KEY (id);


--
-- Name: fascicles_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_pkey PRIMARY KEY (id);


--
-- Name: fascicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_pkey PRIMARY KEY (id);


--
-- Name: fascicles_requests_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_requests_comments
    ADD CONSTRAINT fascicles_requests_comments_pkey PRIMARY KEY (id);


--
-- Name: fascicles_requests_files_fpath_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_requests_files
    ADD CONSTRAINT fascicles_requests_files_fpath_key UNIQUE (fpath, fname);


--
-- Name: fascicles_requests_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_requests_files
    ADD CONSTRAINT fascicles_requests_files_pkey PRIMARY KEY (id);


--
-- Name: fascicles_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_requests
    ADD CONSTRAINT fascicles_requests_pkey PRIMARY KEY (id);


--
-- Name: fascicles_tmpl_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_tmpl_index
    ADD CONSTRAINT fascicles_tmpl_index_pkey PRIMARY KEY (id);


--
-- Name: fascicles_tmpl_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_pkey PRIMARY KEY (id);


--
-- Name: fascicles_tmpl_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_tmpl_pages
    ADD CONSTRAINT fascicles_tmpl_pages_pkey PRIMARY KEY (id);


--
-- Name: fascicles_tmpl_places_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fascicles_tmpl_places
    ADD CONSTRAINT fascicles_tmpl_places_pkey PRIMARY KEY (id);


--
-- Name: history_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- Name: indx_headlines_edition_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_edition_key UNIQUE (edition, tag);


--
-- Name: indx_headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_pkey PRIMARY KEY (id);


--
-- Name: indx_rubrics_edition_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_edition_key UNIQUE (edition, headline, tag);


--
-- Name: indx_rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_pkey PRIMARY KEY (id);


--
-- Name: indx_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY indx_tags
    ADD CONSTRAINT indx_tags_pkey PRIMARY KEY (id);


--
-- Name: logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: map_member_to_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_pkey PRIMARY KEY (member, catalog);


--
-- Name: map_member_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY map_member_to_rule
    ADD CONSTRAINT map_member_to_rule_pkey PRIMARY KEY (id);


--
-- Name: map_principals_to_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY map_principals_to_stages
    ADD CONSTRAINT map_principals_to_stages_pkey PRIMARY KEY (id, stage, principal);


--
-- Name: map_role_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_pkey PRIMARY KEY (role, rule, mode);


--
-- Name: member_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY members
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: member_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT member_profiles_pkey PRIMARY KEY (id);


--
-- Name: member_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT member_session_pkey PRIMARY KEY (id);


--
-- Name: migration_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY migration
    ADD CONSTRAINT migration_pkey PRIMARY KEY (id);


--
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: rss_feeds_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rss_feeds_mapping
    ADD CONSTRAINT rss_feeds_mapping_pkey PRIMARY KEY (id);


--
-- Name: rss_feeds_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rss_feeds_options
    ADD CONSTRAINT rss_feeds_options_pkey PRIMARY KEY (id);


--
-- Name: rss_feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rss_feeds
    ADD CONSTRAINT rss_feeds_pkey PRIMARY KEY (id);


--
-- Name: rss_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rss
    ADD CONSTRAINT rss_pkey PRIMARY KEY (id);


--
-- Name: rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rules
    ADD CONSTRAINT rules_pkey PRIMARY KEY (id);


--
-- Name: stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- Name: state_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- Name: statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY readiness
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: fki_; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_ ON fascicles_pages USING btree (origin);


--
-- Name: catalog_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- Name: catalog_insert_before; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_insert_before
    BEFORE INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- Name: catalog_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER catalog_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- Name: editions_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_delete_after
    AFTER DELETE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_delete_after_trigger();


--
-- Name: editions_insert_before; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_insert_before
    BEFORE INSERT ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_insert_before_trigger();


--
-- Name: editions_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER editions_update_after
    AFTER UPDATE ON editions
    FOR EACH ROW
    EXECUTE PROCEDURE tree_update_after_trigger();


--
-- Name: fascicles_map_documents_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_documents_delete_after
    AFTER DELETE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_delete_after_trigger();


--
-- Name: fascicles_map_documents_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_documents_update_after
    AFTER INSERT OR UPDATE ON fascicles_map_documents
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_documents_update_after_trigger();


--
-- Name: fascicles_map_modules_delete_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_modules_delete_after
    AFTER DELETE ON fascicles_map_modules
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_modules_delete_after_trigger();


--
-- Name: fascicles_map_modules_update_after; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER fascicles_map_modules_update_after
    AFTER INSERT OR UPDATE ON fascicles_map_modules
    FOR EACH ROW
    EXECUTE PROCEDURE fascicles_map_modules_update_after_trigger();


--
-- Name: cache_downloads_document_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_downloads
    ADD CONSTRAINT cache_downloads_document_fkey FOREIGN KEY (document) REFERENCES documents(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cache_downloads_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cache_downloads
    ADD CONSTRAINT cache_downloads_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_indx_headlines_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_headlines
    ADD CONSTRAINT fascicles_indx_headlines_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_indx_rubrics_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_indx_rubrics_headline_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_indx_rubrics
    ADD CONSTRAINT fascicles_indx_rubrics_headline_fkey FOREIGN KEY (headline) REFERENCES fascicles_indx_headlines(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_map_documents_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_entity_fkey FOREIGN KEY (entity) REFERENCES documents(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_map_documents_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_map_documents_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_documents
    ADD CONSTRAINT fascicles_map_documents_page_fkey FOREIGN KEY (page) REFERENCES fascicles_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_map_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_map_modules_module_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_module_fkey FOREIGN KEY (module) REFERENCES fascicles_modules(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_map_modules_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_modules
    ADD CONSTRAINT fascicles_map_modules_page_fkey FOREIGN KEY (page) REFERENCES fascicles_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_map_requests_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_map_requests
    ADD CONSTRAINT fascicles_map_requests_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_modules_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_origin_fkey FOREIGN KEY (origin) REFERENCES fascicles_tmpl_modules(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_modules_place_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_modules
    ADD CONSTRAINT fascicles_modules_place_fkey FOREIGN KEY (place) REFERENCES fascicles_tmpl_places(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_pages_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_pages_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_pages
    ADD CONSTRAINT fascicles_pages_origin_fkey FOREIGN KEY (origin) REFERENCES fascicles_tmpl_pages(id) ON DELETE RESTRICT;


--
-- Name: fascicles_requests_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_requests
    ADD CONSTRAINT fascicles_requests_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_tmpl_index_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_index
    ADD CONSTRAINT fascicles_tmpl_index_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_tmpl_modules_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_tmpl_modules_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_modules
    ADD CONSTRAINT fascicles_tmpl_modules_page_fkey FOREIGN KEY (page) REFERENCES fascicles_tmpl_pages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fascicles_tmpl_pages_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_pages
    ADD CONSTRAINT fascicles_tmpl_pages_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fascicles_tmpl_places_fascicle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fascicles_tmpl_places
    ADD CONSTRAINT fascicles_tmpl_places_fascicle_fkey FOREIGN KEY (fascicle) REFERENCES fascicles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: indx_headlines_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_headlines
    ADD CONSTRAINT indx_headlines_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: indx_rubrics_edition_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_edition_fkey FOREIGN KEY (edition) REFERENCES editions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: indx_rubrics_headline_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY indx_rubrics
    ADD CONSTRAINT indx_rubrics_headline_fkey FOREIGN KEY (headline) REFERENCES indx_headlines(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: map_member_to_catalog_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: map_role_to_rule_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_role_fkey FOREIGN KEY (role) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

