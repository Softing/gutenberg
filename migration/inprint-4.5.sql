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
-- Name: catalog_delete_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION catalog_delete_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM catalog
        WHERE path ~ (OLD.path::text || '.*{1}')::lquery;
    RETURN OLD; 
END;
$$;


ALTER FUNCTION public.catalog_delete_after_trigger() OWNER TO inprint;

--
-- Name: catalog_insert_before_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION catalog_insert_before_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
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
        SELECT mp.path INTO new_path 
            FROM catalog AS mp
            WHERE mp.path = new_path OR replace(mp.id::text, '-',  '') = new_path::text;
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
$$;


ALTER FUNCTION public.catalog_insert_before_trigger() OWNER TO inprint;

--
-- Name: catalog_update_after_trigger(); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION catalog_update_after_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    tid         			 ltree;  
    new_id       ltree;
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
            IF 
                  NEW.path ~ ('*.' || new_id::text || '.*{1,}')::lquery OR
                  NEW.path ~ ('*.!' || new_id::text)::lquery
            THEN
                  RAISE EXCEPTION 'Bad path! id = %', new_id;
            END IF;

            -- Если уровень больше 1 то стоит проверить родителя
            IF nlevel(NEW.path) > 1 THEN

                  SELECT replace(m.id::text, '-',  '') INTO tid FROM catalog AS m 
                  WHERE m.path = subpath(NEW.path, 0, nlevel(NEW.path) - 1);

                  IF tid IS NULL THEN
                        RAISE EXCEPTION  'Bad path2!';
                  END IF;

            END IF;

            -- Обновляем детей узла следующего уровня
            UPDATE catalog
                  SET path = NEW.path || replace(id::text, '-',  '')
                  WHERE path ~ (OLD.path::text || '.*{1}')::lquery;
            END IF;

      RETURN NEW;
END;
$$;


ALTER FUNCTION public.catalog_update_after_trigger() OWNER TO inprint;

--
-- Name: digest(text, text); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION digest(text, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_digest';


ALTER FUNCTION public.digest(text, text) OWNER TO inprint;

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
-- Name: subltree(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION subltree(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subltree';


ALTER FUNCTION public.subltree(ltree, integer, integer) OWNER TO inprint;

--
-- Name: subpath(ltree, integer, integer); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION subpath(ltree, integer, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


ALTER FUNCTION public.subpath(ltree, integer, integer) OWNER TO inprint;

--
-- Name: subpath(ltree, integer); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION subpath(ltree, integer) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'subpath';


ALTER FUNCTION public.subpath(ltree, integer) OWNER TO inprint;

--
-- Name: text2ltree(text); Type: FUNCTION; Schema: public; Owner: inprint
--

CREATE FUNCTION text2ltree(text) RETURNS ltree
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/ltree', 'text2ltree';


ALTER FUNCTION public.text2ltree(text) OWNER TO inprint;

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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: branches; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE branches (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    catalog uuid NOT NULL,
    mtype character varying,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.branches OWNER TO inprint;

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
-- Name: documents; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE documents (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    creator uuid NOT NULL,
    holder uuid NOT NULL,
    manager uuid NOT NULL,
    creator_shortcut character varying NOT NULL,
    holder_shortcut character varying NOT NULL,
    manager_shortcut character varying NOT NULL,
    maingroup uuid NOT NULL,
    maingroup_shortcut character varying NOT NULL,
    ingroups uuid[],
    copygroup uuid,
    fascicle uuid NOT NULL,
    fascicle_shortcut character varying NOT NULL,
    headline uuid,
    headline_shortcut character varying,
    rubric uuid,
    rubric_shortcut character varying,
    branch uuid NOT NULL,
    branch_shortcut character varying NOT NULL,
    stage uuid NOT NULL,
    stage_shortcut character varying NOT NULL,
    color character varying NOT NULL,
    progress integer DEFAULT 0 NOT NULL,
    title character varying NOT NULL,
    author character varying,
    pdate timestamp(6) with time zone,
    psize integer DEFAULT 0,
    rdate timestamp(6) with time zone,
    rsize integer DEFAULT 0,
    images integer DEFAULT 0,
    files integer DEFAULT 0,
    islooked boolean DEFAULT false NOT NULL,
    isopen boolean DEFAULT false NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.documents OWNER TO inprint;

--
-- Name: fascicles; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE fascicles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    issystem boolean DEFAULT false NOT NULL,
    catalog uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying,
    begindate timestamp(6) with time zone,
    enddate timestamp(6) with time zone,
    enabled boolean DEFAULT false NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.fascicles OWNER TO inprint;

--
-- Name: headlines; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE headlines (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    fascicle uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.headlines OWNER TO inprint;

--
-- Name: map_documents_to_exchange; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE map_documents_to_exchange (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    document uuid NOT NULL,
    chain uuid NOT NULL,
    chain_nick character varying NOT NULL,
    stage uuid NOT NULL,
    stage_nick character varying NOT NULL,
    color character varying NOT NULL,
    progress integer DEFAULT 0 NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.map_documents_to_exchange OWNER TO inprint;

--
-- Name: map_documents_to_fascicles; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE map_documents_to_fascicles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    document uuid NOT NULL,
    fascicle uuid NOT NULL,
    fascicle_shortcut character varying NOT NULL,
    headline uuid NOT NULL,
    headline_shortcut character varying NOT NULL,
    rubric uuid NOT NULL,
    rubric_shortcut character varying NOT NULL,
    copygroup uuid
);


ALTER TABLE public.map_documents_to_fascicles OWNER TO inprint;

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
-- Name: map_member_to_rule; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE map_member_to_rule (
    member uuid NOT NULL,
    catalog uuid NOT NULL,
    rule uuid NOT NULL,
    mode character varying NOT NULL
);


ALTER TABLE public.map_member_to_rule OWNER TO inprint;

--
-- Name: map_principals_to_stages; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE map_principals_to_stages (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    stage uuid NOT NULL,
    princial uuid NOT NULL
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
-- Name: profiles; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE profiles (
    id uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    "position" character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.profiles OWNER TO inprint;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE roles (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    catalog uuid NOT NULL,
    name character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.roles OWNER TO inprint;

--
-- Name: rubrics; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE rubrics (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    fascicle uuid NOT NULL,
    parent uuid NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rubrics OWNER TO inprint;

--
-- Name: rules; Type: TABLE; Schema: public; Owner: inprint; Tablespace: 
--

CREATE TABLE rules (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    "group" character varying,
    rule character varying NOT NULL,
    name character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    sortorder integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.rules OWNER TO inprint;

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
    color character varying NOT NULL,
    weight smallint NOT NULL,
    title character varying NOT NULL,
    shortcut character varying NOT NULL,
    description character varying NOT NULL,
    created timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated timestamp(6) with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.stages OWNER TO inprint;

--
-- Name: view_members; Type: VIEW; Schema: public; Owner: inprint
--

CREATE VIEW view_members AS
    SELECT t1.id, t1.login, t1.password, t2.title, t2.shortcut, t2."position", ARRAY(SELECT map_member_to_catalog.catalog FROM map_member_to_catalog WHERE (map_member_to_catalog.member = t1.id)) AS catalog FROM members t1, profiles t2 WHERE (t1.id = t2.id);


ALTER TABLE public.view_members OWNER TO inprint;

--
-- Name: view_principals; Type: VIEW; Schema: public; Owner: inprint
--

CREATE VIEW view_principals AS
    SELECT t1.id, t2.title AS name, t2.shortcut, 'member' AS type FROM members t1, profiles t2 WHERE (t1.id = t2.id) UNION SELECT catalog.id, catalog.title AS name, catalog.shortcut, 'group' AS type FROM catalog;


ALTER TABLE public.view_principals OWNER TO inprint;

--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY branches (id, catalog, mtype, title, shortcut, description, created, updated) FROM stdin;
eed0c8a2-6bf8-1014-b3fa-01e8601ac163	9519ed9d-bce7-4048-9366-1ce62f2e428d	\N	Газета "За рулем"	ГЗР		2010-08-18 15:59:31.038+04	2010-08-18 15:59:31.038+04
eed47a37-6bf8-1014-b3fa-01e8601ac163	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	\N	Журнал Рейс	РЕЙС		2010-08-18 15:59:31.146+04	2010-08-18 15:59:31.146+04
eed745f4-6bf8-1014-b3fa-01e8601ac163	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	\N	МОТО	МОТО		2010-08-18 15:59:31.229+04	2010-08-18 15:59:31.229+04
eed89c46-6bf8-1014-b3fa-01e8601ac163	f2ef2670-6c3f-4516-876f-ffc46b8eb9e8	\N	Купи Авто	КА		2010-08-18 15:59:31.268+04	2010-08-18 15:59:31.268+04
eed90bdb-6bf8-1014-b3fa-01e8601ac163	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	\N	За рулем	ЗР		2010-08-18 15:59:31.282+04	2010-08-18 15:59:31.282+04
\.


--
-- Data for Name: catalog; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY catalog (id, path, title, shortcut, description, type, capables, created, updated) FROM stdin;
93b1e20c-fc07-4c41-8c9f-0cf810d434f0	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0	МОТО	МОТО	 	ou	{default}	2010-09-28 01:00:05.238804+04	2010-09-28 01:00:05.238804+04
17cebfa7-efa0-4ff7-a6fa-145a650889a4	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.17cebfa7efa04ff7a6fa145a650889a4	Управление	МОТО/Управление		ou	{default}	2010-09-28 01:00:05.243272+04	2010-09-28 01:00:05.243272+04
80e66420-469a-4882-b628-b42d2370c3a8	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.80e66420469a4882b628b42d2370c3a8	Туризм, спорт	МОТО/Туризм, спорт		ou	{default}	2010-09-28 01:00:05.245503+04	2010-09-28 01:00:05.245503+04
50f82f94-a384-4fcd-8d59-f9f55d7c0a54	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.50f82f94a3844fcd8d59f9f55d7c0a54	IT	МОТО/IT		ou	{default}	2010-09-28 01:00:05.2474+04	2010-09-28 01:00:05.2474+04
d3f585bb-6d3f-4d2a-99ca-43e2afccaf51	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.d3f585bb6d3f4d2a99ca43e2afccaf51	Корректорский	МОТО/Корректорский		ou	{default}	2010-09-28 01:00:05.249074+04	2010-09-28 01:00:05.249074+04
9be818fe-58e1-422d-b7cf-6405ee68affb	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.9be818fe58e1422db7cf6405ee68affb	ОХО	МОТО/ОХО		ou	{default}	2010-09-28 01:00:05.250899+04	2010-09-28 01:00:05.250899+04
bb82e390-6c91-4895-839e-724aca4b842e	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.bb82e3906c914895839e724aca4b842e	МЖ	МОТО/МЖ		ou	{default}	2010-09-28 01:00:05.25262+04	2010-09-28 01:00:05.25262+04
db6d8b30-16df-4ecd-be2f-c8194f94e1f4	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4	За рулем	ЗР	Журнал для автолюбителей и автопрофессионалов	ou	{default}	2010-09-28 01:00:05.193775+04	2010-09-28 01:00:05.193775+04
1683134b-ab43-494e-b727-4c07ef67e525	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.1683134bab43494eb7274c07ef67e525	КОРР	ЗР/КОРР	Корректура	ou	{default}	2010-09-28 01:00:05.197405+04	2010-09-28 01:00:05.197405+04
213d5326-df0b-4e32-ac39-3dea069a6e7d	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.213d5326df0b4e32ac393dea069a6e7d	ОАР	ЗР/ОАР	Авторынок	ou	{default}	2010-09-28 01:00:05.199501+04	2010-09-28 01:00:05.199501+04
83ac2bcd-2011-43fb-b5cc-cea3cdd17173	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.83ac2bcd201143fbb5cccea3cdd17173	ОМП	ЗР/ОМП	Международные проекты	ou	{default}	2010-09-28 01:00:05.20164+04	2010-09-28 01:00:05.20164+04
88067829-2bb5-43e0-8de7-7b234f971a0d	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.880678292bb543e08de77b234f971a0d	ОХО	ЗР/ОХО	Художественное оформление	ou	{default}	2010-09-28 01:00:05.20372+04	2010-09-28 01:00:05.20372+04
b389451d-5f5d-43c8-aae2-0cc8e8833a65	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.b389451d5f5d43c8aae20cc8e8833a65	ОЭ	ЗР/ОЭ	Эксплуатация	ou	{default}	2010-09-28 01:00:05.205754+04	2010-09-28 01:00:05.205754+04
4bb55d21-28fd-432e-9316-afcdeef6a78e	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.4bb55d2128fd432e9316afcdeef6a78e	Письма	ЗР/Письма	Корреспондентская сеть и письма	ou	{default}	2010-09-28 01:00:05.207854+04	2010-09-28 01:00:05.207854+04
2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.2d86ce4dd5f749c0b1124dfb9bf6fed9	УПР	ЗР/УПР	Управление	ou	{default}	2010-09-28 01:00:05.209905+04	2010-09-28 01:00:05.209905+04
15c6f56b-e8f5-4d9e-a698-09de205e05d6	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.15c6f56be8f54d9ea69809de205e05d6	АЖ	ЗР/АЖ	Авто-жизнь	ou	{default}	2010-09-28 01:00:05.214464+04	2010-09-28 01:00:05.214464+04
94bc80e1-0853-4e46-845c-ce4e591c78f8	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.94bc80e108534e46845cce4e591c78f8	ОСп	ЗР/ОСп	Спецпроекты	ou	{default}	2010-09-28 01:00:05.216684+04	2010-09-28 01:00:05.216684+04
46f7d566-d6f3-4f96-90dc-b41ce41f1c76	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.46f7d566d6f34f9690dcb41ce41f1c76	Я / IT	ЗР/Я / IT	Техническая поддержка	ou	{default}	2010-09-28 01:00:05.218763+04	2010-09-28 01:00:05.218763+04
dc328c99-e50e-4d40-ae3c-f19ee7630225	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.dc328c99e50e4d40ae3cf19ee7630225	Груз	ЗР/Груз	Отдел грузовиков	ou	{default}	2010-09-28 01:00:05.220788+04	2010-09-28 01:00:05.220788+04
e61b8693-19ca-4f51-9e8a-751972120263	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.e61b869319ca4f519e8a751972120263	Новости	ЗР/Новости	Новостной	ou	{default}	2010-09-28 01:00:05.223489+04	2010-09-28 01:00:05.223489+04
4cdd3b42-754a-472f-85fb-869baf06d8b7	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.4cdd3b42754a472f85fb869baf06d8b7	Рекламное бюро	ЗР/Рекламное бюро	 	ou	{default}	2010-09-28 01:00:05.226216+04	2010-09-28 01:00:05.226216+04
00f84872-99e7-4665-8bda-ba5db2154fd0	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.00f8487299e746658bdaba5db2154fd0	ОИ	ЗР/ОИ	Испытания	ou	{default}	2010-09-28 01:00:05.228968+04	2010-09-28 01:00:05.228968+04
d885bfdd-ada6-4f52-9b42-e5377b850365	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.d885bfddada64f529b42e5377b850365	ОНТ	ЗР/ОНТ	Наука и техника	ou	{default}	2010-09-28 01:00:05.231271+04	2010-09-28 01:00:05.231271+04
9f5ee5c5-c03b-4a23-94f0-ee3212353e5d	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.9f5ee5c5c03b4a2394f0ee3212353e5d	ОСТ	ЗР/ОСТ	Спорта и тюнинга	ou	{default}	2010-09-28 01:00:05.233109+04	2010-09-28 01:00:05.233109+04
a1f418f5-ac08-4aa4-964f-b7e1ece4e970	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.a1f418f5ac084aa4964fb7e1ece4e970	ФОТО	ЗР/ФОТО	Отдел фотографирования	ou	{default}	2010-09-28 01:00:05.234929+04	2010-09-28 01:00:05.234929+04
ab53db60-3142-4699-8b57-a83db930db6b	00000000000000000000000000000000.db6d8b3016df4ecdbe2fc8194f94e1f4.ab53db60314246998b57a83db930db6b	web-редакция	ЗР/web-редакция	Интернет-редакция	ou	{default}	2010-09-28 01:00:05.236828+04	2010-09-28 01:00:05.236828+04
90154d05-bead-49c8-ae28-ab55a8988aff	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.90154d05bead49c8ae28ab55a8988aff	НТИ	МОТО/НТИ		ou	{default}	2010-09-28 01:00:05.254291+04	2010-09-28 01:00:05.254291+04
5bfd9fa5-90c8-41f0-adff-8f74e5fd967d	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.5bfd9fa590c841f0adff8f74e5fd967d	ОЭ	МОТО/ОЭ		ou	{default}	2010-09-28 01:00:05.256118+04	2010-09-28 01:00:05.256118+04
e32e0735-f513-49c1-855f-6aff8aedf24d	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.e32e0735f51349c1855f6aff8aedf24d	ОИ	МОТО/ОИ		ou	{default}	2010-09-28 01:00:05.257858+04	2010-09-28 01:00:05.257858+04
e94920b3-cdcb-42cc-a1c9-706271466a79	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.e94920b3cdcb42cca1c9706271466a79	web-редакция	МОТО/web-редакция		ou	{default}	2010-09-28 01:00:05.259782+04	2010-09-28 01:00:05.259782+04
85e3fce3-9846-43f4-9f6b-be6a43e75cb8	00000000000000000000000000000000.93b1e20cfc074c418c9f0cf810d434f0.85e3fce3984643f49f6bbe6a43e75cb8	Рекламное Бюро	МОТО/Рекламное Бюро		ou	{default}	2010-09-28 01:00:05.261658+04	2010-09-28 01:00:05.261658+04
63c666d4-d8c1-41e1-b67d-27e4b262d7a3	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3	Журнал Рейс	РЕЙС		ou	{default}	2010-09-28 01:00:05.263351+04	2010-09-28 01:00:05.263351+04
9c9989ba-9df3-42c6-b570-858f4488604a	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.9c9989ba9df342c6b570858f4488604a	Руководство	РЕЙС/Руководство		ou	{default}	2010-09-28 01:00:05.266175+04	2010-09-28 01:00:05.266175+04
1e503f74-c03b-4858-812b-ab2fb7962013	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.1e503f74c03b4858812bab2fb7962013	Редакторы	РЕЙС/Редакторы		ou	{default}	2010-09-28 01:00:05.267874+04	2010-09-28 01:00:05.267874+04
b4e98951-2b31-4341-8cb9-0ace637890b4	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.b4e989512b3143418cb90ace637890b4	Верстка	РЕЙС/Верстка		ou	{default}	2010-09-28 01:00:05.269569+04	2010-09-28 01:00:05.269569+04
4ca62851-4aeb-4c8f-983e-66f75e0bb58e	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.4ca628514aeb4c8f983e66f75e0bb58e	Корректура	РЕЙС/Корректура		ou	{default}	2010-09-28 01:00:05.271709+04	2010-09-28 01:00:05.271709+04
783e5830-8daf-466a-9f16-69a430205432	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.783e58308daf466a9f1669a430205432	Рекламный	РЕЙС/Рекламный		ou	{default}	2010-09-28 01:00:05.274064+04	2010-09-28 01:00:05.274064+04
3d4c3b0b-e864-40b7-b545-a0875792dcb4	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.3d4c3b0be86440b7b545a0875792dcb4	2п	РЕЙС/2п		ou	{default}	2010-09-28 01:00:05.275838+04	2010-09-28 01:00:05.275838+04
50d42568-9c36-4575-b378-13435da8c336	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.50d425689c364575b37813435da8c336	4п	РЕЙС/4п		ou	{default}	2010-09-28 01:00:05.277758+04	2010-09-28 01:00:05.277758+04
760a27a7-e792-45ef-b6d7-9dc137eb5295	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.760a27a7e79245efb6d79dc137eb5295	3п	РЕЙС/3п		ou	{default}	2010-09-28 01:00:05.279883+04	2010-09-28 01:00:05.279883+04
09efe19c-e2de-4838-9312-17ad1496b800	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.09efe19ce2de4838931217ad1496b800	1п	РЕЙС/1п		ou	{default}	2010-09-28 01:00:05.28164+04	2010-09-28 01:00:05.28164+04
3ba05389-454e-4b10-bab1-40c956853d67	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.3ba05389454e4b10bab140c956853d67	5п	РЕЙС/5п		ou	{default}	2010-09-28 01:00:05.283592+04	2010-09-28 01:00:05.283592+04
5d1c46a8-f499-4217-a665-1c01c9237cfc	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.5d1c46a8f4994217a6651c01c9237cfc	6п	РЕЙС/6п		ou	{default}	2010-09-28 01:00:05.285468+04	2010-09-28 01:00:05.285468+04
fe5a6fe7-ab0f-47c4-9e5f-f7fbf13e20e6	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.fe5a6fe7ab0f47c49e5ff7fbf13e20e6	7п	РЕЙС/7п		ou	{default}	2010-09-28 01:00:05.287149+04	2010-09-28 01:00:05.287149+04
a9789003-dd50-4ff2-828e-353627566500	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.a9789003dd504ff2828e353627566500	8п	РЕЙС/8п		ou	{default}	2010-09-28 01:00:05.288804+04	2010-09-28 01:00:05.288804+04
b00921d0-b4b9-455a-b193-f4c08108e24e	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.b00921d0b4b9455ab193f4c08108e24e	9п	РЕЙС/9п		ou	{default}	2010-09-28 01:00:05.29051+04	2010-09-28 01:00:05.29051+04
35c243f1-80c5-4a72-a671-f8d67f09441e	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.35c243f180c54a72a671f8d67f09441e	10п	РЕЙС/10п		ou	{default}	2010-09-28 01:00:05.292242+04	2010-09-28 01:00:05.292242+04
7f9c1570-e913-470b-b3ff-62c727b0d57a	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.7f9c1570e913470bb3ff62c727b0d57a	11п	РЕЙС/11п		ou	{default}	2010-09-28 01:00:05.294583+04	2010-09-28 01:00:05.294583+04
9a46e688-aff8-4e61-bab4-463a870f1a68	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.9a46e688aff84e61bab4463a870f1a68	12п	РЕЙС/12п		ou	{default}	2010-09-28 01:00:05.296282+04	2010-09-28 01:00:05.296282+04
e03b03b8-f367-4fc3-8ff6-42d6dbf799d8	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.e03b03b8f3674fc38ff642d6dbf799d8	1/2	РЕЙС/1/2		ou	{default}	2010-09-28 01:00:05.297974+04	2010-09-28 01:00:05.297974+04
3885755a-8330-4dd8-af6c-2e3698cf6399	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.3885755a83304dd8af6c2e3698cf6399	1/4	РЕЙС/1/4		ou	{default}	2010-09-28 01:00:05.299625+04	2010-09-28 01:00:05.299625+04
60696bb8-04ed-4bf4-8348-ccc3caddb784	00000000000000000000000000000000.63c666d4d8c141e1b67d27e4b262d7a3.60696bb804ed4bf48348ccc3caddb784	1/3	РЕЙС/1/3		ou	{default}	2010-09-28 01:00:05.301926+04	2010-09-28 01:00:05.301926+04
9519ed9d-bce7-4048-9366-1ce62f2e428d	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d	Газета "За рулем"	ГЗР		ou	{default}	2010-09-28 01:00:05.3062+04	2010-09-28 01:00:05.3062+04
00000000-0000-0000-0000-000000000000	00000000000000000000000000000000	Издательский Дом	ИД ЗР	Издательский дом "За рулем"	ou	{default}	2010-08-03 19:01:13.77+04	2010-08-03 19:01:13.77+04
1765069b-234f-4adb-b12e-58502d05a940	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.1765069b234f4adbb12e58502d05a940	Тюнинг	ГЗР/Тюнинг		ou	{default}	2010-09-28 01:00:05.311725+04	2010-09-28 01:00:05.311725+04
2ac29a02-220a-4ae6-8b6a-4365333488b3	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.2ac29a02220a4ae68b6a4365333488b3	Городская жизнь	ГЗР/Городская жизнь		ou	{default}	2010-09-28 01:00:05.314106+04	2010-09-28 01:00:05.314106+04
86e5df0c-ca86-47a4-9754-d703c40f1683	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.86e5df0cca8647a49754d703c40f1683	Рынок, компоненты	ГЗР/Рынок, компоненты		ou	{default}	2010-09-28 01:00:05.31651+04	2010-09-28 01:00:05.31651+04
d9b49c33-de87-4f50-9a1e-4868c4d65411	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.d9b49c33de874f509a1e4868c4d65411	Оформление	ГЗР/Оформление		ou	{default}	2010-09-28 01:00:05.318748+04	2010-09-28 01:00:05.318748+04
2837fef0-7061-401e-b58a-9c1315c6eca2	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.2837fef07061401eb58a9c1315c6eca2	Сопровождение	ГЗР/Сопровождение		ou	{default}	2010-09-28 01:00:05.320813+04	2010-09-28 01:00:05.320813+04
4af74392-5f13-4a3f-8524-e298394fb647	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.4af743925f134a3f8524e298394fb647	Корректоры	ГЗР/Корректоры		ou	{default}	2010-09-28 01:00:05.323127+04	2010-09-28 01:00:05.323127+04
28f669b1-6e32-4274-85a2-32426f618669	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.28f669b16e32427485a232426f618669	Рук-во	ГЗР/Рук-во		ou	{default}	2010-09-28 01:00:05.326431+04	2010-09-28 01:00:05.326431+04
3cdad4d0-a9d7-45e4-b6af-fd329100edda	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.3cdad4d0a9d745e4b6affd329100edda	Регионы	ГЗР/Регионы		ou	{default}	2010-09-28 01:00:05.3292+04	2010-09-28 01:00:05.3292+04
1716f2db-eb40-4372-9e4c-9288170c2171	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.1716f2dbeb4043729e4c9288170c2171	Редакция	ГЗР/Редакция		ou	{default}	2010-09-28 01:00:05.331698+04	2010-09-28 01:00:05.331698+04
0d3017ff-e40b-4959-bfea-7e8b9679d5d0	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.0d3017ffe40b4959bfea7e8b9679d5d0	Автомобили	ГЗР/Автомобили		ou	{default}	2010-09-28 01:00:05.334211+04	2010-09-28 01:00:05.334211+04
4ff90351-9668-4ae6-9aaf-dab7a4d4c1a2	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.4ff9035196684ae69aafdab7a4d4c1a2	ТИПОГРАФИЯ	ГЗР/ТИПОГРАФИЯ		ou	{default}	2010-09-28 01:00:05.336792+04	2010-09-28 01:00:05.336792+04
f2ef2670-6c3f-4516-876f-ffc46b8eb9e8	00000000000000000000000000000000.f2ef26706c3f4516876fffc46b8eb9e8	Купи Авто	КА		ou	{default}	2010-09-28 01:00:05.341689+04	2010-09-28 01:00:05.341689+04
712077a7-3cc8-4357-a696-7799060fdf15	00000000000000000000000000000000.f2ef26706c3f4516876fffc46b8eb9e8.712077a73cc84357a6967799060fdf15	КА-Управление	КА/КА-Управление	 	ou	{default}	2010-09-28 01:00:05.344089+04	2010-09-28 01:00:05.344089+04
cf940ab4-bfa5-4b83-bf6a-6b5346f09081	00000000000000000000000000000000.f2ef26706c3f4516876fffc46b8eb9e8.cf940ab4bfa54b83bf6a6b5346f09081	КА-IT	КА/КА-IT	 	ou	{default}	2010-09-28 01:00:05.345805+04	2010-09-28 01:00:05.345805+04
5df88b9d-659c-4b96-b5f4-69e0122dee98	00000000000000000000000000000000.f2ef26706c3f4516876fffc46b8eb9e8.5df88b9d659c4b96b5f469e0122dee98	КА-ОХО	КА/КА-ОХО		ou	{default}	2010-09-28 01:00:05.347562+04	2010-09-28 01:00:05.347562+04
96baeee8-461c-470e-a82d-1ca192725241	00000000000000000000000000000000.f2ef26706c3f4516876fffc46b8eb9e8.96baeee8461c470ea82d1ca192725241	КА-Автомобильный	КА/КА-Автомобильный		ou	{default}	2010-09-28 01:00:05.349739+04	2010-09-28 01:00:05.349739+04
713d3e38-b5c2-498e-8ed6-26120cecda0e	00000000000000000000000000000000.f2ef26706c3f4516876fffc46b8eb9e8.713d3e38b5c2498e8ed626120cecda0e	КА-Корректорский	КА/КА-Корректорский		ou	{default}	2010-09-28 01:00:05.352251+04	2010-09-28 01:00:05.352251+04
89483c7b-b971-42a0-a131-d8a52d5fc939	00000000000000000000000000000000.9519ed9dbce7404893661ce62f2e428d.89483c7bb97142a0a131d8a52d5fc939	Новости	ГЗР/Новости		ou	{default}	2010-09-28 01:00:05.339153+04	2010-09-28 01:00:05.339153+04
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY documents (id, creator, holder, manager, creator_shortcut, holder_shortcut, manager_shortcut, maingroup, maingroup_shortcut, ingroups, copygroup, fascicle, fascicle_shortcut, headline, headline_shortcut, rubric, rubric_shortcut, branch, branch_shortcut, stage, stage_shortcut, color, progress, title, author, pdate, psize, rdate, rsize, images, files, islooked, isopen, created, updated) FROM stdin;
98da44c6-9114-4b58-9238-c15592d50e32	0a7b47c6-c882-45ac-be78-b7fdadea1656	88067829-2bb5-43e0-8de7-7b234f971a0d	0a7b47c6-c882-45ac-be78-b7fdadea1656	Федоров Д. С.	ОХО	Федоров Д. С.	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9	ЗР/УПР	{00000000-0000-0000-0000-000000000000,db6d8b30-16df-4ecd-be2f-c8194f94e1f4,2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9}	\N	deb6f461-5d5e-4302-87ea-7d446502b34e	09-2010	d425c1fc-200b-4cfe-b8a7-55f778210388	ч/ Анонс	00000000-0000-0000-0000-000000000000	Not found	eed90bdb-6bf8-1014-b3fa-01e8601ac163	За рулем	6c1d78bd-55f6-4765-8812-df2139a14db7	Верстка	00CCFF	90	анонс	аркуша	\N	0	\N	\N	0	0	t	f	2010-07-07 12:44:21+04	2010-08-04 16:57:28+04
\.


--
-- Data for Name: fascicles; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY fascicles (id, issystem, catalog, title, shortcut, description, begindate, enddate, enabled, created, updated) FROM stdin;
00000000-0000-0000-0000-000000000000	t	00000000-0000-0000-0000-000000000000	Портфель	Портфель документов		\N	\N	t	2010-09-19 03:09:41.525+04	2010-09-19 03:09:41.525+04
99999999-9999-9999-9999-999999999999	t	00000000-0000-0000-0000-000000000000	Корзина	Корзина для удаления		\N	\N	t	2010-09-19 03:09:41.534+04	2010-09-19 03:09:41.534+04
b732191b-638f-4f85-a1a3-f925934d555f	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Июль 11, 2008	Июль 11, 2008	Июль 11, 2008	2008-07-06 22:06:05+04	2008-07-11 00:00:00+04	f	2010-09-19 03:09:41.541+04	2010-09-19 03:09:41.541+04
bf24034e-5558-44be-a5a4-897b0441af41	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Июль 18, 2008	Июль 18, 2008	Июль 18, 2008	2008-07-07 10:05:21+04	2008-07-18 00:00:00+04	f	2010-09-19 03:09:41.793+04	2010-09-19 03:09:41.793+04
33c47ee6-90f0-4c9c-82a7-d1836ede0b16	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Август	Август	Август	2008-07-22 10:48:56+04	2008-07-31 00:00:00+04	f	2010-09-19 03:09:41.984+04	2010-09-19 03:09:41.984+04
8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	12-2008	12-2008	12-2008	2008-08-06 19:26:18+04	2008-11-09 23:59:59+03	f	2010-09-19 03:09:42.035+04	2010-09-19 03:09:42.035+04
42845691-6ded-449f-9a70-424a80f60dfb	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	11-2008	11-2008	11-2008	2008-08-04 23:33:37+04	2008-10-12 23:59:59+04	f	2010-09-19 03:09:42.079+04	2010-09-19 03:09:42.079+04
83c0ff44-8f9c-4d52-bc4a-1781f140a450	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	10-2008	10-2008	10-2008	2008-07-09 15:13:06+04	2008-09-08 23:59:59+04	f	2010-09-19 03:09:42.119+04	2010-09-19 03:09:42.119+04
35f75638-02d1-4e06-a29a-21e90f1cfde3	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	1-2009	1-2009	1-2009	2008-09-19 12:21:43+04	2008-12-03 23:59:59+03	f	2010-09-19 03:09:42.246+04	2010-09-19 03:09:42.246+04
b7f3aa1f-3443-43ea-8f25-280a00d24e35	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	2-2009	2-2009	2-2009	2008-10-13 14:45:22+04	2009-01-12 00:00:00+03	f	2010-09-19 03:09:42.281+04	2010-09-19 03:09:42.281+04
98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	3-2009	3-2009	3-2009	2008-11-10 20:54:17+03	2009-02-09 00:00:00+03	f	2010-09-19 03:09:42.312+04	2010-09-19 03:09:42.312+04
e398085f-1158-44fb-a179-927e56556e4e	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Фестиваль 4х4	Фестиваль 4х4	Фестиваль 4х4	2009-01-15 17:01:51+03	2009-02-10 23:59:59+03	f	2010-09-19 03:09:42.345+04	2010-09-19 03:09:42.345+04
78e8efb9-0d6a-4206-9ddc-350acbf3acc7	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	5-2009	5-2009	5-2009	2009-01-19 16:50:57+03	2009-04-09 00:00:00+04	f	2010-09-19 03:09:42.354+04	2010-09-19 03:09:42.354+04
4ce835c9-5c9d-4adb-92b3-ead02153f8f2	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	7-2009	7-2009	7-2009	2009-03-10 09:50:05+03	2009-06-09 00:00:00+04	f	2010-09-19 03:09:42.384+04	2010-09-19 03:09:42.384+04
66032704-2b7d-416c-98aa-aac5ad77dc64	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Мос-вкладка №5	Мос-вкладка №5	Мос-вкладка №5	2009-03-23 10:46:43+03	2009-04-05 23:59:59+04	f	2010-09-19 03:09:42.411+04	2010-09-19 03:09:42.411+04
cb899fea-facf-4eca-a529-04f6def0af78	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Мос-вкладка №6	Мос-вкладка №6	Мос-вкладка №6	2009-04-03 15:01:33+04	2009-05-07 00:00:00+04	f	2010-09-19 03:09:42.44+04	2010-09-19 03:09:42.44+04
b159dd0f-8bd7-4555-8319-2083556bb7f8	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#6	#6	#6	2009-04-06 13:32:53+04	2009-05-25 00:00:00+04	f	2010-09-19 03:09:42.451+04	2010-09-19 03:09:42.451+04
63446907-3389-42e1-9775-d651a9d7877e	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Мос вкладка 10	Мос вкладка 10	Мос вкладка 10	2009-08-06 16:39:17+04	2009-09-15 23:59:59+04	f	2010-09-19 03:09:42.471+04	2010-09-19 03:09:42.471+04
5e21447b-0295-42d8-8fd5-b9af45f1af20	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	#5 2009	#5 2009	#5 2009	2009-02-27 13:07:36+03	2009-04-06 23:59:59+04	f	2010-09-19 03:09:42.499+04	2010-09-19 03:09:42.499+04
35250213-05d7-4702-9d95-2f2be1812eb4	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Июль, 2009	Июль, 2009	Июль, 2009	2009-04-14 13:27:18+04	2009-06-08 23:59:59+04	f	2010-09-19 03:09:42.522+04	2010-09-19 03:09:42.522+04
c7141356-2836-4525-8465-53983cf09d20	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	Май 8, 2009	Май 8, 2009	Май 8, 2009	2009-03-30 00:50:14+04	2009-05-08 23:59:59+04	f	2010-09-19 03:09:42.547+04	2010-09-19 03:09:42.547+04
154a37c7-d12d-4e02-aabd-aeabcb0cb91b	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#7	#7	#7	2009-05-05 15:20:37+04	2009-06-18 00:00:00+04	f	2010-09-19 03:09:42.565+04	2010-09-19 03:09:42.565+04
f792f23a-5123-4854-b50d-7352c9d20245	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#9	#9	#9	2009-06-19 11:08:03+04	2009-08-20 00:00:00+04	f	2010-09-19 03:09:42.585+04	2010-09-19 03:09:42.585+04
70a3568d-7cdf-4ce1-9015-6cdd19972e06	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Июнь, 2009	Июнь, 2009	Июнь, 2009	2009-03-30 13:48:22+04	2009-05-11 23:59:59+04	f	2010-09-19 03:09:42.605+04	2010-09-19 03:09:42.605+04
de7bcae7-cdc7-4df3-b177-af801d15cac6	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	trash	trash	trash	\N	2009-06-12 23:59:59+04	f	2010-09-19 03:09:42.629+04	2010-09-19 03:09:42.629+04
c6deaf72-e508-4f5d-aeca-942786e29e03	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	6-2009	6-2009	6-2009	2009-02-10 21:21:03+03	2009-05-11 23:59:59+04	f	2010-09-19 03:09:42.639+04	2010-09-19 03:09:42.639+04
81f5a35c-f74f-4d47-97da-a045878a7091	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#1	#1	#1	2009-10-26 13:20:34+03	2009-12-19 00:00:00+03	f	2010-09-19 03:09:42.672+04	2010-09-19 03:09:42.672+04
08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	03-2010	03-2010	03-2010	2009-11-26 08:36:08+03	2010-02-08 23:59:59+03	f	2010-09-19 03:09:42.695+04	2010-09-19 03:09:42.695+04
43942374-48e0-4319-b644-e16c6f9154ac	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#8	#8	#8	2009-05-23 10:27:42+04	2009-07-23 00:00:00+04	f	2010-09-19 03:09:42.728+04	2010-09-19 03:09:42.728+04
b807f7cf-dcf2-42f0-93a6-3793c3e651a2	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	9-2009	9-2009	9-2009	2009-04-29 10:29:14+04	2009-08-12 23:59:59+04	f	2010-09-19 03:09:42.75+04	2010-09-19 03:09:42.75+04
08362519-7e72-4213-840a-4fc744c5a48e	f	9519ed9d-bce7-4048-9366-1ce62f2e428d	тест	тест	тест	2010-01-15 11:43:19+03	2010-01-21 00:00:00+03	f	2010-09-19 03:09:42.781+04	2010-09-19 03:09:42.781+04
534b9942-48ef-49d7-bbbd-b752ecfde409	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	11-2009	11-2009	11-2009	2009-05-13 13:42:59+04	2009-10-14 23:59:59+04	f	2010-09-19 03:09:42.799+04	2010-09-19 03:09:42.799+04
f8e1287c-5527-464a-9a7e-478110ff1f03	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Август, 2009	Август, 2009	Август, 2009	2009-06-02 14:56:57+04	2009-07-13 23:59:59+04	f	2010-09-19 03:09:42.829+04	2010-09-19 03:09:42.829+04
2d1808ce-bd9b-428e-ade9-b9aae2ce5c1b	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Мос-вкладка 11	Мос-вкладка 11	Мос-вкладка 11	2009-08-07 19:33:06+04	2009-10-13 00:00:00+04	f	2010-09-19 03:09:42.855+04	2010-09-19 03:09:42.855+04
9b29875c-f00b-4c86-93eb-759fa3420a20	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Мос-вкладка 7	Мос-вкладка 7	Мос-вкладка 7	2009-04-06 19:28:34+04	2009-06-07 23:59:59+04	f	2010-09-19 03:09:42.865+04	2010-09-19 03:09:42.865+04
020374f8-8db8-42a0-bb20-e2b5d3b67d04	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	8-2009	8-2009	8-2009	2009-03-18 09:47:00+03	2009-07-15 23:59:59+04	f	2010-09-19 03:09:42.894+04	2010-09-19 03:09:42.894+04
72a37221-8866-4172-b56c-793002d118f4	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Мос-вкладка 8	Мос-вкладка 8	Мос-вкладка 8	2009-06-04 17:26:36+04	2009-07-15 23:59:59+04	f	2010-09-19 03:09:42.925+04	2010-09-19 03:09:42.925+04
79678219-1369-4195-b6e7-9e2e6fd51957	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	12-2009	12-2009	12-2009	2009-05-13 13:43:00+04	2009-11-10 23:59:59+03	f	2010-09-19 03:09:42.954+04	2010-09-19 03:09:42.954+04
054bd40f-e181-4114-bf46-a346319da606	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#3	#3	#3	2009-12-10 16:59:47+03	2010-02-19 00:00:00+03	f	2010-09-19 03:09:42.987+04	2010-09-19 03:09:42.987+04
9b20caf1-5271-4f65-9184-f67515affdbe	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Сентября, 2009	Сентября, 2009	Сентября, 2009	2009-06-22 12:17:27+04	2009-08-10 23:59:59+04	f	2010-09-19 03:09:43.009+04	2010-09-19 03:09:43.009+04
ac18cceb-3153-49b2-a49c-298787543411	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	9-2008	9-2008	9-2008	2008-07-09 20:52:15+04	2008-08-12 23:59:59+04	f	2010-09-19 03:09:43.037+04	2010-09-19 03:09:43.037+04
8023615e-eaed-44fc-bcbb-ffd59378c811	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#10	#10	#10	2009-07-28 12:21:26+04	2009-09-24 23:59:59+04	f	2010-09-19 03:09:43.142+04	2010-09-19 03:09:43.142+04
ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	10-2009	10-2009	10-2009	2009-05-13 13:42:58+04	2009-09-15 23:59:59+04	f	2010-09-19 03:09:43.164+04	2010-09-19 03:09:43.164+04
e268fa39-f35e-4a81-940f-f20033d64836	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	01-2010	01-2010	01-2010	2009-09-22 10:13:11+04	2009-12-06 23:59:59+03	f	2010-09-19 03:09:43.197+04	2010-09-19 03:09:43.197+04
e9a80f9b-45b4-4681-9319-ecdd2812efd4	f	9519ed9d-bce7-4048-9366-1ce62f2e428d	Москва 3-2010	Москва 3-2010	Москва 3-2010	2010-01-21 13:43:02+03	2010-02-02 23:59:59+03	f	2010-09-19 03:09:43.228+04	2010-09-19 03:09:43.228+04
c536d8c3-33d6-44c5-b2e5-bcea671a070e	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#11	#11	#11	2009-08-21 14:30:46+04	2009-10-23 23:59:59+04	f	2010-09-19 03:09:43.247+04	2010-09-19 03:09:43.247+04
88f25a94-6e90-42ce-855c-526aa92b9a5d	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Март, 2010	Март, 2010	Март, 2010	2009-11-06 14:55:29+03	2010-02-15 23:59:59+03	f	2010-09-19 03:09:43.283+04	2010-09-19 03:09:43.283+04
08067592-b9eb-440b-8b98-e2491043ed39	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	Мос вкладка 9	Мос вкладка 9	Мос вкладка 9	2009-06-08 17:15:31+04	2009-08-09 23:59:59+04	f	2010-09-19 03:09:43.308+04	2010-09-19 03:09:43.308+04
5913ff51-4ee4-4941-96ac-565236937c2d	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#12	#12	#12	2009-09-11 13:10:02+04	2009-11-20 00:00:00+03	f	2010-09-19 03:09:43.341+04	2010-09-19 03:09:43.341+04
3b3b4951-c897-4626-9109-009ba3e9f9fd	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Октябрь , 2009	Октябрь , 2009	Октябрь , 2009	2009-06-22 12:17:28+04	2009-09-14 23:59:59+04	f	2010-09-19 03:09:43.367+04	2010-09-19 03:09:43.367+04
ee3ba207-a0ad-47f2-adf4-abf933619d15	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Декабрь, 2009	Декабрь, 2009	Декабрь, 2009	2009-06-22 12:17:28+04	2009-11-09 23:59:59+03	f	2010-09-19 03:09:43.393+04	2010-09-19 03:09:43.393+04
d62ba395-f854-43c4-8448-9508e72b3530	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#2	#2	#2	2009-11-05 17:39:21+03	2010-01-22 00:00:00+03	f	2010-09-19 03:09:43.42+04	2010-09-19 03:09:43.42+04
dcc8ce2d-df05-472c-ba52-7d79b442546d	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Ноябрь , 2009	Ноябрь , 2009	Ноябрь , 2009	2009-06-22 12:17:28+04	2009-10-12 23:59:59+04	f	2010-09-19 03:09:43.446+04	2010-09-19 03:09:43.446+04
44b2913d-bf64-4464-a079-aee6184b2d06	f	9519ed9d-bce7-4048-9366-1ce62f2e428d	3-2010(202)	3-2010(202)	3-2010(202)	2010-01-21 13:36:38+03	2010-02-03 00:00:00+03	f	2010-09-19 03:09:43.472+04	2010-09-19 03:09:43.472+04
6f932426-79d4-4631-8ccd-89c12ec6959f	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Январь, 2010	Январь, 2010	Январь, 2010	2009-06-22 12:17:29+04	2009-12-09 23:59:59+03	f	2010-09-19 03:09:43.496+04	2010-09-19 03:09:43.496+04
e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	f	9519ed9d-bce7-4048-9366-1ce62f2e428d	4-2010(203)	4-2010(203)	4-2010(203)	2010-01-22 15:26:45+03	2010-02-17 23:59:59+03	f	2010-09-19 03:09:43.524+04	2010-09-19 03:09:43.524+04
861454b0-4d5b-4bbe-b09c-c7b22093a525	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Февраль, 2010	Февраль, 2010	Февраль, 2010	2009-11-06 14:55:29+03	2010-01-15 23:59:59+03	f	2010-09-19 03:09:43.55+04	2010-09-19 03:09:43.55+04
93739a43-c4ef-43ca-81e2-a2b64ac44d56	f	9519ed9d-bce7-4048-9366-1ce62f2e428d	Москва 4-2010	Москва 4-2010	Москва 4-2010	2010-01-27 16:31:01+03	2010-02-17 00:00:00+03	f	2010-09-19 03:09:43.58+04	2010-09-19 03:09:43.58+04
750d111c-994c-46ca-888e-e2b4a8662887	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	4-2009	4-2009	4-2009	2008-12-03 22:50:42+03	2009-03-09 23:59:59+03	f	2010-09-19 03:09:43.603+04	2010-09-19 03:09:43.603+04
706f5f9c-5d90-4a15-9ddf-7a1939916b6c	f	9519ed9d-bce7-4048-9366-1ce62f2e428d	5-2010(204)	5-2010(204)	5-2010(204)	2010-02-09 14:22:24+03	2010-03-03 00:00:00+03	f	2010-09-19 03:09:43.637+04	2010-09-19 03:09:43.637+04
db776095-f67f-4e10-9acf-9e70e1fc83a8	f	9519ed9d-bce7-4048-9366-1ce62f2e428d	6-2010(205)	6-2010(205)	6-2010(205)	2010-02-09 14:22:23+03	2010-03-17 23:59:59+03	f	2010-09-19 03:09:43.661+04	2010-09-19 03:09:43.661+04
012fbccd-6b40-40b0-909a-7d07a1c0d224	f	9519ed9d-bce7-4048-9366-1ce62f2e428d	7-2010(206)	7-2010(206)	7-2010(206)	2010-02-09 14:22:24+03	2010-03-31 00:00:00+04	f	2010-09-19 03:09:43.684+04	2010-09-19 03:09:43.684+04
677e19ff-aaab-4a86-b61c-2f436de510a8	f	9519ed9d-bce7-4048-9366-1ce62f2e428d	Москва 6-2010	Москва 6-2010	Москва 6-2010	\N	2010-03-17 00:00:00+03	f	2010-09-19 03:09:43.707+04	2010-09-19 03:09:43.707+04
dbc81fc4-645c-4827-8e5b-46a527a27e25	f	9519ed9d-bce7-4048-9366-1ce62f2e428d	Москва 5-2010	Москва 5-2010	Москва 5-2010	2010-02-11 14:23:21+03	2010-03-03 00:00:00+03	f	2010-09-19 03:09:43.718+04	2010-09-19 03:09:43.718+04
90eb0213-95ca-427e-8f36-a5cbb0f51f24	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Апрель, 2010	Апрель, 2010	Апрель, 2010	2009-11-06 14:55:30+03	2010-03-14 23:59:59+03	f	2010-09-19 03:09:43.74+04	2010-09-19 03:09:43.74+04
f3e51f59-e3da-4533-a304-a7f5dbda5648	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	05-2010	05-2010	05-2010	2010-01-25 15:23:10+03	2010-04-15 00:00:00+04	f	2010-09-19 03:09:43.77+04	2010-09-19 03:09:43.77+04
2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#4	#4	#4	2010-01-22 11:42:53+03	2010-03-19 00:00:00+03	f	2010-09-19 03:09:43.807+04	2010-09-19 03:09:43.807+04
614a26eb-b7cb-47b3-a953-7ad6fe0557ba	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	02-2010	02-2010	02-2010	2009-11-02 00:00:00+03	2010-01-10 00:00:00+03	f	2010-09-19 03:09:43.832+04	2010-09-19 03:09:43.832+04
7760f777-bd78-4167-8647-c7d5f3232fc1	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	07-2010	07-2010	07-2010	2010-03-17 00:00:00+03	2010-06-12 00:00:00+04	f	2010-09-19 03:09:43.87+04	2010-09-19 03:09:43.87+04
0eac0aab-6534-4000-bd46-4f0e85c60847	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Май, 2010	Май, 2010	Май, 2010	2009-11-06 14:55:30+03	2010-04-16 00:00:00+04	f	2010-09-19 03:09:43.986+04	2010-09-19 03:09:43.986+04
58771368-ca78-49f1-95c2-35e2b9873c6c	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Июнь, 2010	Июнь, 2010	Июнь, 2010	2009-11-06 00:00:00+03	2010-06-16 00:00:00+04	f	2010-09-19 03:09:44.014+04	2010-09-19 03:09:44.014+04
d162b81c-94ef-425b-a04f-54818fffe63a	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#8	#8	#8	2010-05-24 00:00:00+04	2010-07-27 00:00:00+04	f	2010-09-19 03:09:44.04+04	2010-09-19 03:09:44.04+04
82e9f54e-d0a6-4f36-ad51-33a6067d38a8	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#7	#7	#7	2010-04-24 00:00:00+04	2010-06-25 00:00:00+04	f	2010-09-19 03:09:44.115+04	2010-09-19 03:09:44.115+04
64e1b37e-eb7a-4201-b427-bb210bdf3736	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	04-2010	04-2010	04-2010	2009-12-17 00:00:00+03	2010-03-19 00:00:00+03	f	2010-09-19 03:09:44.224+04	2010-09-19 03:09:44.224+04
9a96554f-2f94-4af5-9fd1-116736efc27a	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	08-2010	08-2010	08-2010	2010-05-04 00:00:00+04	2010-07-14 00:00:00+04	f	2010-09-19 03:09:44.259+04	2010-09-19 03:09:44.259+04
953eea94-1899-4aa1-bacb-7cb19bf373cb	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#5	#5	#5	2010-02-12 16:23:18+03	2010-04-23 00:00:00+04	f	2010-09-19 03:09:44.385+04	2010-09-19 03:09:44.385+04
848f7187-6099-459d-83b6-46213bc811db	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	06-2010	06-2010	06-2010	2010-02-24 09:10:51+03	2010-05-10 00:00:00+04	f	2010-09-19 03:09:44.411+04	2010-09-19 03:09:44.411+04
5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#10	#10	#10	2010-06-22 00:00:00+04	2010-09-24 00:00:00+04	t	2010-09-19 03:09:44.451+04	2010-09-19 03:09:44.451+04
4fd73209-568f-4349-9156-65714d0bdebe	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#6	#6	#6	2010-03-22 00:00:00+03	2010-05-24 00:00:00+04	f	2010-09-19 03:09:44.53+04	2010-09-19 03:09:44.53+04
deb6f461-5d5e-4302-87ea-7d446502b34e	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	09-2010	09-2010	09-2010	2010-05-04 00:00:00+04	2010-08-10 00:00:00+04	f	2010-09-19 03:09:45.008+04	2010-09-19 03:09:45.008+04
77c71b8e-b229-4794-8a53-01b79ea8ba1b	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	10-2010	10-2010	10-2010	2010-05-04 00:00:00+04	2010-09-14 00:00:00+04	f	2010-09-19 03:09:45.247+04	2010-09-19 03:09:45.247+04
4d0daad8-2c82-4d67-b75d-079300f89caf	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Июль, 2010	Июль, 2010	Июль, 2010	2009-11-06 00:00:00+03	2010-06-30 00:00:00+04	f	2010-09-19 03:09:45.487+04	2010-09-19 03:09:45.487+04
ac1d0ca1-06bb-4d74-89e5-1662a68475dd	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#11	#11	#11	2010-08-02 00:00:00+04	2010-10-26 00:00:00+04	t	2010-09-19 03:09:45.537+04	2010-09-19 03:09:45.537+04
d4b228d3-7067-49e8-b5b7-03ca7f752f0c	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Август, 2010	Август, 2010	Август, 2010	2010-06-03 00:00:00+04	2010-07-18 00:00:00+04	f	2010-09-19 03:09:45.677+04	2010-09-19 03:09:45.677+04
7c19709f-e8ff-42ee-ad81-3c4b5ed89901	f	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	11-2010	11-2010	11-2010	2010-07-15 00:00:00+04	2010-10-12 00:00:00+04	t	2010-09-19 03:09:46.099+04	2010-09-19 03:09:46.099+04
22abeebf-f805-4140-b1ac-52dd782b8362	f	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	#9	#9	#9	2010-06-22 00:00:00+04	2010-08-20 00:00:00+04	f	2010-09-19 03:09:46.336+04	2010-09-19 03:09:46.336+04
f9cfd971-ea52-47b3-90dd-6a31c03579db	f	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	Сентябрь, 2010	Сентябрь, 2010	Сентябрь, 2010	2010-07-13 00:00:00+04	2010-08-23 00:00:00+04	f	2010-09-19 03:09:46.483+04	2010-09-19 03:09:46.483+04
1718de7a-ce8e-44ba-8228-ceb1d22e56ae	f	f2ef2670-6c3f-4516-876f-ffc46b8eb9e8	test	test	test	2010-08-04 00:00:00+04	2010-08-21 00:00:00+04	f	2010-09-19 03:09:46.927+04	2010-09-19 03:09:46.927+04
\.


--
-- Data for Name: headlines; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY headlines (id, fascicle, title, shortcut, description, created, updated) FROM stdin;
00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:41.527+04	2010-09-19 03:09:41.527+04
00000000-0000-0000-0000-000000000000	b732191b-638f-4f85-a1a3-f925934d555f	Not found	Not found		2010-09-19 03:09:41.544+04	2010-09-19 03:09:41.544+04
8cb5c363-dac2-43c2-ae09-ad4dbcd7458e	b732191b-638f-4f85-a1a3-f925934d555f	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:41.554+04	2010-09-19 03:09:41.554+04
26ab045f-93fe-4d35-b283-ed00da71e494	b732191b-638f-4f85-a1a3-f925934d555f	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:41.558+04	2010-09-19 03:09:41.558+04
b360a445-11a2-4808-b8b3-e6906f1318b9	b732191b-638f-4f85-a1a3-f925934d555f	0/ Содержание	0/ Содержание		2010-09-19 03:09:41.561+04	2010-09-19 03:09:41.561+04
3405f2b6-09ad-4bc9-9601-6d6961fc1244	b732191b-638f-4f85-a1a3-f925934d555f	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:41.564+04	2010-09-19 03:09:41.564+04
f9deefeb-45a8-44e9-87ae-159c4a4c940a	b732191b-638f-4f85-a1a3-f925934d555f	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:41.566+04	2010-09-19 03:09:41.566+04
927a6296-4d93-482f-9565-b6e06d6d5b8b	b732191b-638f-4f85-a1a3-f925934d555f	б/ Курьер	б/ Курьер		2010-09-19 03:09:41.568+04	2010-09-19 03:09:41.568+04
bd8a8584-ad8c-4499-a744-85f3c5ce4ea5	b732191b-638f-4f85-a1a3-f925934d555f	к/ Спорт	к/ Спорт		2010-09-19 03:09:41.599+04	2010-09-19 03:09:41.599+04
58ba221c-0ddb-4c70-85ba-e0fc7f9c6d45	b732191b-638f-4f85-a1a3-f925934d555f	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:41.602+04	2010-09-19 03:09:41.602+04
eecfd453-1f5b-4bb2-b6d2-f1fb2f520a7b	b732191b-638f-4f85-a1a3-f925934d555f	з/ Экономика	з/ Экономика		2010-09-19 03:09:41.606+04	2010-09-19 03:09:41.606+04
5ef9dc0c-b62d-4965-904e-8deb1d0d81eb	b732191b-638f-4f85-a1a3-f925934d555f	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:41.608+04	2010-09-19 03:09:41.608+04
be34168b-d4db-444b-9441-e8ca9f269ec1	b732191b-638f-4f85-a1a3-f925934d555f	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:41.61+04	2010-09-19 03:09:41.61+04
7092d1f4-47e7-43e5-aed8-ba9d08d80417	b732191b-638f-4f85-a1a3-f925934d555f	д/ Техника	д/ Техника		2010-09-19 03:09:41.612+04	2010-09-19 03:09:41.612+04
b06d3ff9-fe3d-4cc6-823b-000cdf9f80ef	b732191b-638f-4f85-a1a3-f925934d555f	Реклама	Реклама		2010-09-19 03:09:41.614+04	2010-09-19 03:09:41.614+04
850766d7-ebca-4ab3-8b30-7545d80ed80b	b732191b-638f-4f85-a1a3-f925934d555f	м/ Без границ	м/ Без границ		2010-09-19 03:09:41.618+04	2010-09-19 03:09:41.618+04
97c3ce84-bf5c-4156-b136-af7f09e9f918	b732191b-638f-4f85-a1a3-f925934d555f	н/ Цены ЗР	н/ Цены ЗР		2010-09-19 03:09:41.62+04	2010-09-19 03:09:41.62+04
78f9aed3-33b0-448d-bb55-8c016d4934dd	b732191b-638f-4f85-a1a3-f925934d555f	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:41.622+04	2010-09-19 03:09:41.622+04
065eafab-a51e-416a-b5b4-52cef621ca36	b732191b-638f-4f85-a1a3-f925934d555f	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:41.624+04	2010-09-19 03:09:41.624+04
00000000-0000-0000-0000-000000000000	bf24034e-5558-44be-a5a4-897b0441af41	Not found	Not found		2010-09-19 03:09:41.795+04	2010-09-19 03:09:41.795+04
ad1b0e5a-934f-4157-b75c-8abe3937c204	bf24034e-5558-44be-a5a4-897b0441af41	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:41.806+04	2010-09-19 03:09:41.806+04
be3f0160-a47d-4664-82ec-d65546a98659	bf24034e-5558-44be-a5a4-897b0441af41	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:41.809+04	2010-09-19 03:09:41.809+04
5d2c6507-23bc-4b38-bc90-031a954ff82c	bf24034e-5558-44be-a5a4-897b0441af41	0/ Содержание	0/ Содержание		2010-09-19 03:09:41.811+04	2010-09-19 03:09:41.811+04
63c69a90-fa05-44f6-9a01-9a5b9210b8e9	bf24034e-5558-44be-a5a4-897b0441af41	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:41.813+04	2010-09-19 03:09:41.813+04
96d59f19-50ee-4a6a-ada0-d98816cded7f	bf24034e-5558-44be-a5a4-897b0441af41	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:41.815+04	2010-09-19 03:09:41.815+04
82d53ee6-b357-4ca2-ae1c-92f825bde72c	bf24034e-5558-44be-a5a4-897b0441af41	б/ Курьер	б/ Курьер		2010-09-19 03:09:41.818+04	2010-09-19 03:09:41.818+04
676df53e-f898-472e-ad92-44908006f78d	bf24034e-5558-44be-a5a4-897b0441af41	к/ Спорт	к/ Спорт		2010-09-19 03:09:41.82+04	2010-09-19 03:09:41.82+04
b492843e-2f9b-4453-95f4-bd2d7ed76f74	bf24034e-5558-44be-a5a4-897b0441af41	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:41.822+04	2010-09-19 03:09:41.822+04
49c34633-16e0-4579-9c82-fff3992c0922	bf24034e-5558-44be-a5a4-897b0441af41	з/ Экономика	з/ Экономика		2010-09-19 03:09:41.824+04	2010-09-19 03:09:41.824+04
83b65697-dab8-4c98-8ea1-db5c3a773c8d	bf24034e-5558-44be-a5a4-897b0441af41	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:41.826+04	2010-09-19 03:09:41.826+04
85d02f4d-5668-4833-b4db-eebc9398d2bb	bf24034e-5558-44be-a5a4-897b0441af41	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:41.828+04	2010-09-19 03:09:41.828+04
a699532f-5963-4731-a237-9b7b06ede8b9	bf24034e-5558-44be-a5a4-897b0441af41	д/ Техника	д/ Техника		2010-09-19 03:09:41.831+04	2010-09-19 03:09:41.831+04
6e9e8610-caed-45a1-b25a-71f40899a95c	bf24034e-5558-44be-a5a4-897b0441af41	Реклама	Реклама		2010-09-19 03:09:41.833+04	2010-09-19 03:09:41.833+04
22c27d6b-9d82-4a33-b12a-8327845f5cfd	bf24034e-5558-44be-a5a4-897b0441af41	м/ Без границ	м/ Без границ		2010-09-19 03:09:41.836+04	2010-09-19 03:09:41.836+04
e6780b1f-f8b8-4a77-9078-30e2da6b096f	bf24034e-5558-44be-a5a4-897b0441af41	н/ Цены ЗР	н/ Цены ЗР		2010-09-19 03:09:41.838+04	2010-09-19 03:09:41.838+04
0c218f5b-2e31-4715-8fe1-4017289048bc	bf24034e-5558-44be-a5a4-897b0441af41	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:41.84+04	2010-09-19 03:09:41.84+04
5a9dff27-55a4-41d2-98ec-c13201936eba	bf24034e-5558-44be-a5a4-897b0441af41	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:41.842+04	2010-09-19 03:09:41.842+04
00000000-0000-0000-0000-000000000000	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	Not found	Not found		2010-09-19 03:09:41.986+04	2010-09-19 03:09:41.986+04
fdcf5f95-821f-4166-8e43-276d6cec03b2	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	0/ Содержание	0/ Содержание		2010-09-19 03:09:41.991+04	2010-09-19 03:09:41.991+04
4c18fc13-b1a5-461e-b169-f29ae3c4b959	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	test1	test1		2010-09-19 03:09:41.993+04	2010-09-19 03:09:41.993+04
96cc7bcb-db43-4b75-a740-2ec2894b3076	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	test2	test2		2010-09-19 03:09:41.995+04	2010-09-19 03:09:41.995+04
1bfa0496-de72-4952-adc4-1984280a29b6	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	test3	test3		2010-09-19 03:09:41.997+04	2010-09-19 03:09:41.997+04
5b24ce1d-3327-4465-983f-c7c83d381874	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	test4	test4		2010-09-19 03:09:41.999+04	2010-09-19 03:09:41.999+04
67751601-3801-498e-8768-1ce14b8b9216	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	в НОВОСТИ	в НОВОСТИ		2010-09-19 03:09:42+04	2010-09-19 03:09:42+04
28daa9b1-1d73-4d9d-b3bc-5bdcf9e166e0	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	г Автомобили	г Автомобили		2010-09-19 03:09:42.001+04	2010-09-19 03:09:42.001+04
00000000-0000-0000-0000-000000000000	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	Not found	Not found		2010-09-19 03:09:42.037+04	2010-09-19 03:09:42.037+04
8573a458-8d80-4b90-bf9b-039c626c1e52	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.044+04	2010-09-19 03:09:42.044+04
4487f174-b2c3-41e6-a8c5-fcbb9c5ffbb2	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.046+04	2010-09-19 03:09:42.046+04
5046454a-3634-4584-bde6-257570dd9473	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.048+04	2010-09-19 03:09:42.048+04
c13b1473-03b8-4597-86d5-35adb854aaa7	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.049+04	2010-09-19 03:09:42.049+04
6a2a5ed4-5c2e-4634-9175-5a15a7f3a1e4	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.05+04	2010-09-19 03:09:42.05+04
84e1a7d8-c0b3-4dd4-9456-2d261616c1e3	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.052+04	2010-09-19 03:09:42.052+04
3032be8f-e767-474f-bb62-96d1381f341d	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.054+04	2010-09-19 03:09:42.054+04
0e5bfac2-ccf0-4f6a-a4f9-ae7500739e18	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.056+04	2010-09-19 03:09:42.056+04
0cd0b96a-92fc-49f2-8cf0-e5f70dbc51e4	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.057+04	2010-09-19 03:09:42.057+04
875ef036-7b12-49c7-baf0-588eab42c7e2	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.059+04	2010-09-19 03:09:42.059+04
3ff18476-b53b-4f70-bbdb-2968dabaac42	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.06+04	2010-09-19 03:09:42.06+04
15861b17-008e-4f43-9125-4f2e5a2ac8f4	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	д/ Техника	д/ Техника		2010-09-19 03:09:42.062+04	2010-09-19 03:09:42.062+04
a31bb35c-1d39-4645-b008-62f706253b23	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	Реклама	Реклама		2010-09-19 03:09:42.063+04	2010-09-19 03:09:42.063+04
7c6eb150-041b-48b1-b20d-97259924870e	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	м/ Без границ	м/ Без границ		2010-09-19 03:09:42.065+04	2010-09-19 03:09:42.065+04
7aae54d5-0b37-449a-9946-de3b4d355e4a	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	н/ Цены ЗР	н/ Цены ЗР		2010-09-19 03:09:42.067+04	2010-09-19 03:09:42.067+04
cd551667-3422-4b91-a000-47e45095420b	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.069+04	2010-09-19 03:09:42.069+04
624ecb99-cfa4-4f37-b6cb-cc33dc6c548e	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.07+04	2010-09-19 03:09:42.07+04
00000000-0000-0000-0000-000000000000	42845691-6ded-449f-9a70-424a80f60dfb	Not found	Not found		2010-09-19 03:09:42.082+04	2010-09-19 03:09:42.082+04
5c82ffb7-0bd6-48f5-904f-826b0ea98baf	42845691-6ded-449f-9a70-424a80f60dfb	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.088+04	2010-09-19 03:09:42.088+04
4f2991fd-8f3a-4156-a880-a735162be5e3	42845691-6ded-449f-9a70-424a80f60dfb	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.091+04	2010-09-19 03:09:42.091+04
793ad7cb-3390-4b50-86c7-9c34e3e3ee1c	42845691-6ded-449f-9a70-424a80f60dfb	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.093+04	2010-09-19 03:09:42.093+04
ec2473af-0950-486e-99c6-38d5c9a20f99	42845691-6ded-449f-9a70-424a80f60dfb	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.094+04	2010-09-19 03:09:42.094+04
c005c5f9-94c3-4077-a16e-ec6badecb20c	42845691-6ded-449f-9a70-424a80f60dfb	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.096+04	2010-09-19 03:09:42.096+04
34d819d7-3394-4f31-a0e1-98e8c646b2d1	42845691-6ded-449f-9a70-424a80f60dfb	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.098+04	2010-09-19 03:09:42.098+04
74439671-b593-4312-8325-e27f82889463	42845691-6ded-449f-9a70-424a80f60dfb	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.099+04	2010-09-19 03:09:42.099+04
9c4281ac-0750-4500-b7f6-642e86cf2288	42845691-6ded-449f-9a70-424a80f60dfb	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.1+04	2010-09-19 03:09:42.1+04
2eb83f51-3adf-4fac-b928-508589b804d6	42845691-6ded-449f-9a70-424a80f60dfb	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.102+04	2010-09-19 03:09:42.102+04
918ec615-acea-4eb0-9e2c-26550d113bef	42845691-6ded-449f-9a70-424a80f60dfb	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.104+04	2010-09-19 03:09:42.104+04
2a61ab78-b588-480d-a776-614e523e1aad	42845691-6ded-449f-9a70-424a80f60dfb	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.105+04	2010-09-19 03:09:42.105+04
8a5ce89e-1bf4-45e8-a42a-26f582625e11	42845691-6ded-449f-9a70-424a80f60dfb	д/ Техника	д/ Техника		2010-09-19 03:09:42.107+04	2010-09-19 03:09:42.107+04
c048ac28-9828-4408-bd98-ebc9ef093915	42845691-6ded-449f-9a70-424a80f60dfb	м/ Без границ	м/ Без границ		2010-09-19 03:09:42.108+04	2010-09-19 03:09:42.108+04
fc5fd7c1-3fe4-45ca-8223-150a9abf4d05	42845691-6ded-449f-9a70-424a80f60dfb	н/ Цены ЗР	н/ Цены ЗР		2010-09-19 03:09:42.11+04	2010-09-19 03:09:42.11+04
961cd185-7de4-4dfc-b8b1-a31968421af9	42845691-6ded-449f-9a70-424a80f60dfb	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.111+04	2010-09-19 03:09:42.111+04
48fbd223-d340-4a27-8d2f-880e2d01b3fe	42845691-6ded-449f-9a70-424a80f60dfb	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.113+04	2010-09-19 03:09:42.113+04
00000000-0000-0000-0000-000000000000	83c0ff44-8f9c-4d52-bc4a-1781f140a450	Not found	Not found		2010-09-19 03:09:42.12+04	2010-09-19 03:09:42.12+04
957dcb09-fa6c-4612-94cb-09a08c0001c0	83c0ff44-8f9c-4d52-bc4a-1781f140a450	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.127+04	2010-09-19 03:09:42.127+04
1382af38-d6fc-408d-b848-0e2f54682033	83c0ff44-8f9c-4d52-bc4a-1781f140a450	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.128+04	2010-09-19 03:09:42.128+04
41dc7ea2-5b0e-4cea-95f3-9364b547ba22	83c0ff44-8f9c-4d52-bc4a-1781f140a450	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.13+04	2010-09-19 03:09:42.13+04
beaa68cb-edf4-4911-aa17-61890bad5024	83c0ff44-8f9c-4d52-bc4a-1781f140a450	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.131+04	2010-09-19 03:09:42.131+04
f1120d4d-1c05-433c-9fe9-5928812078c4	83c0ff44-8f9c-4d52-bc4a-1781f140a450	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.133+04	2010-09-19 03:09:42.133+04
658eafa6-145e-4ff1-b700-c4d546675ea1	83c0ff44-8f9c-4d52-bc4a-1781f140a450	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.134+04	2010-09-19 03:09:42.134+04
2d1e5c05-caab-4d77-81e9-b716d422d648	83c0ff44-8f9c-4d52-bc4a-1781f140a450	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.135+04	2010-09-19 03:09:42.135+04
38b9e2ea-f4da-4a9d-ba9f-4421a50e7137	83c0ff44-8f9c-4d52-bc4a-1781f140a450	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.137+04	2010-09-19 03:09:42.137+04
2d90c725-01e5-437f-923f-0ad7f209de0c	83c0ff44-8f9c-4d52-bc4a-1781f140a450	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.139+04	2010-09-19 03:09:42.139+04
29c6dd29-a85a-4378-aa8b-b0eda0e31ce3	83c0ff44-8f9c-4d52-bc4a-1781f140a450	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.14+04	2010-09-19 03:09:42.14+04
efa0c041-d7bb-4d39-84ea-913d32035c09	83c0ff44-8f9c-4d52-bc4a-1781f140a450	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.141+04	2010-09-19 03:09:42.141+04
6806f197-9c0a-4227-b795-d1d7b9497404	83c0ff44-8f9c-4d52-bc4a-1781f140a450	д/ Техника	д/ Техника		2010-09-19 03:09:42.143+04	2010-09-19 03:09:42.143+04
3e27054e-dc0a-45ae-9d4e-78d2f0e05411	83c0ff44-8f9c-4d52-bc4a-1781f140a450	м/ Без границ	м/ Без границ		2010-09-19 03:09:42.144+04	2010-09-19 03:09:42.144+04
91121f19-5855-45d5-9551-450b157c3ed7	83c0ff44-8f9c-4d52-bc4a-1781f140a450	н/ Цены ЗР	н/ Цены ЗР		2010-09-19 03:09:42.146+04	2010-09-19 03:09:42.146+04
a1c45c85-d04c-4d03-86b1-6b5a8c1942b1	83c0ff44-8f9c-4d52-bc4a-1781f140a450	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.147+04	2010-09-19 03:09:42.147+04
bc784478-8b92-4e26-80c0-185aaf294efd	83c0ff44-8f9c-4d52-bc4a-1781f140a450	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.149+04	2010-09-19 03:09:42.149+04
00000000-0000-0000-0000-000000000000	35f75638-02d1-4e06-a29a-21e90f1cfde3	Not found	Not found		2010-09-19 03:09:42.247+04	2010-09-19 03:09:42.247+04
449028e1-c9c3-4043-85ee-d605c0de4971	35f75638-02d1-4e06-a29a-21e90f1cfde3	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.253+04	2010-09-19 03:09:42.253+04
ac2cf065-a189-414d-b48e-33691d7cf0c8	35f75638-02d1-4e06-a29a-21e90f1cfde3	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.255+04	2010-09-19 03:09:42.255+04
8426214d-6869-4117-9045-9f84b1d60eac	35f75638-02d1-4e06-a29a-21e90f1cfde3	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.256+04	2010-09-19 03:09:42.256+04
027fa645-4770-49af-825d-24aac27d7952	35f75638-02d1-4e06-a29a-21e90f1cfde3	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.258+04	2010-09-19 03:09:42.258+04
6790733f-093d-4a99-bd44-7790714a2fc8	35f75638-02d1-4e06-a29a-21e90f1cfde3	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.26+04	2010-09-19 03:09:42.26+04
dfdfafb5-285a-4f7e-84f8-0492a08912a6	35f75638-02d1-4e06-a29a-21e90f1cfde3	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.261+04	2010-09-19 03:09:42.261+04
8ac8bd25-9e3c-480b-877b-9d47c5d24193	35f75638-02d1-4e06-a29a-21e90f1cfde3	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.263+04	2010-09-19 03:09:42.263+04
252a8032-ad79-48f4-a10e-4efbf149e2c8	35f75638-02d1-4e06-a29a-21e90f1cfde3	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.264+04	2010-09-19 03:09:42.264+04
67cb5d16-f5c4-4836-b9a1-c8a00c0124b7	35f75638-02d1-4e06-a29a-21e90f1cfde3	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.265+04	2010-09-19 03:09:42.265+04
df7dcc78-c495-4519-a738-ad502c758b7a	35f75638-02d1-4e06-a29a-21e90f1cfde3	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.267+04	2010-09-19 03:09:42.267+04
fe7f9770-4529-47ec-aa73-29931c05b5e3	35f75638-02d1-4e06-a29a-21e90f1cfde3	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.269+04	2010-09-19 03:09:42.269+04
dfed8b16-acb0-4dcf-bebd-cc8dae95a2f4	35f75638-02d1-4e06-a29a-21e90f1cfde3	д/ Техника	д/ Техника		2010-09-19 03:09:42.27+04	2010-09-19 03:09:42.27+04
ec8cadc2-f90d-4bf9-9d7c-526132f880f8	35f75638-02d1-4e06-a29a-21e90f1cfde3	м/ Без границ	м/ Без границ		2010-09-19 03:09:42.272+04	2010-09-19 03:09:42.272+04
5e27d643-6fa4-48cd-91e5-29f391db3643	35f75638-02d1-4e06-a29a-21e90f1cfde3	н/ Цены ЗР	н/ Цены ЗР		2010-09-19 03:09:42.274+04	2010-09-19 03:09:42.274+04
f7b6d817-38a7-418e-b849-71e3d9425a14	35f75638-02d1-4e06-a29a-21e90f1cfde3	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.275+04	2010-09-19 03:09:42.275+04
717e9b7c-8150-4058-861d-312c0da6d4cb	35f75638-02d1-4e06-a29a-21e90f1cfde3	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.276+04	2010-09-19 03:09:42.276+04
00000000-0000-0000-0000-000000000000	b7f3aa1f-3443-43ea-8f25-280a00d24e35	Not found	Not found		2010-09-19 03:09:42.282+04	2010-09-19 03:09:42.282+04
4fe1a6b4-11c6-4d51-8cf6-c40851c53429	b7f3aa1f-3443-43ea-8f25-280a00d24e35	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.288+04	2010-09-19 03:09:42.288+04
dfc11d44-1863-4512-9be6-c193bdc931a7	b7f3aa1f-3443-43ea-8f25-280a00d24e35	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.289+04	2010-09-19 03:09:42.289+04
beb68927-aa7d-4d3b-bca6-7aa3c24bd12c	b7f3aa1f-3443-43ea-8f25-280a00d24e35	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.29+04	2010-09-19 03:09:42.29+04
0829f783-1dd0-406b-94a4-a90b5054daf7	b7f3aa1f-3443-43ea-8f25-280a00d24e35	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.292+04	2010-09-19 03:09:42.292+04
9607d901-6f93-43ee-bd7c-8cb58c4dd38c	b7f3aa1f-3443-43ea-8f25-280a00d24e35	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.293+04	2010-09-19 03:09:42.293+04
a05a6f27-d649-46f5-843b-11fa6811ed2a	b7f3aa1f-3443-43ea-8f25-280a00d24e35	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.294+04	2010-09-19 03:09:42.294+04
81b79b87-0f1d-460b-92cc-e8efe4850ba6	b7f3aa1f-3443-43ea-8f25-280a00d24e35	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.296+04	2010-09-19 03:09:42.296+04
e72bc55b-2d92-4eae-b4a7-ec63277cedd6	b7f3aa1f-3443-43ea-8f25-280a00d24e35	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.297+04	2010-09-19 03:09:42.297+04
c6214f4e-2c6a-4997-a21d-7cba72b4e2f4	b7f3aa1f-3443-43ea-8f25-280a00d24e35	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.298+04	2010-09-19 03:09:42.298+04
3e2268e7-d2f0-4878-8a98-9edd3ce457e2	b7f3aa1f-3443-43ea-8f25-280a00d24e35	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.3+04	2010-09-19 03:09:42.3+04
38f23467-5099-4667-a396-c7ef709b3a73	b7f3aa1f-3443-43ea-8f25-280a00d24e35	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.301+04	2010-09-19 03:09:42.301+04
af21e99e-7dcf-4c89-9adb-906ca0c2170c	b7f3aa1f-3443-43ea-8f25-280a00d24e35	д/ Техника	д/ Техника		2010-09-19 03:09:42.302+04	2010-09-19 03:09:42.302+04
f124e246-cc1b-48b1-993c-1db1a1eda9c7	b7f3aa1f-3443-43ea-8f25-280a00d24e35	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.303+04	2010-09-19 03:09:42.303+04
d0e1d4c6-da1e-4d64-8af1-028a326f6dd0	b7f3aa1f-3443-43ea-8f25-280a00d24e35	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.304+04	2010-09-19 03:09:42.304+04
4d7eac25-1fb7-4639-a013-d908ae42dff4	b7f3aa1f-3443-43ea-8f25-280a00d24e35	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.305+04	2010-09-19 03:09:42.305+04
b52395d8-6be0-4ca1-9dd4-3a17130820c3	b7f3aa1f-3443-43ea-8f25-280a00d24e35	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.307+04	2010-09-19 03:09:42.307+04
00000000-0000-0000-0000-000000000000	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	Not found	Not found		2010-09-19 03:09:42.313+04	2010-09-19 03:09:42.313+04
a33701e5-301e-463c-b1f6-3608b3493176	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.318+04	2010-09-19 03:09:42.318+04
870f2a07-1744-4d84-9f7b-23079218dde0	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.319+04	2010-09-19 03:09:42.319+04
40af3b0d-8140-4918-b84e-c829dc92f8c4	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.32+04	2010-09-19 03:09:42.32+04
64a5cb33-2953-4633-aa7e-749c557a924a	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.322+04	2010-09-19 03:09:42.322+04
6bff4eac-4855-434f-8f9d-ca26acc2e864	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.323+04	2010-09-19 03:09:42.323+04
e028f249-5bf9-4645-adf7-810efc4736d3	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.324+04	2010-09-19 03:09:42.324+04
218568a6-109f-4b66-b6a2-c67963e80fe3	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.326+04	2010-09-19 03:09:42.326+04
0d31f1cd-2b05-4a3e-ac26-d93e25bc40f3	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.327+04	2010-09-19 03:09:42.327+04
78e8856b-ff36-45b9-9973-f65fbe5b5bcb	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.328+04	2010-09-19 03:09:42.328+04
43a665d6-62a8-43c6-841b-587baa9810de	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.329+04	2010-09-19 03:09:42.329+04
3daed8d2-e0c0-4ced-abfe-b541f13527b7	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.331+04	2010-09-19 03:09:42.331+04
081a6f16-7ba5-4a96-b6eb-0eca753119e9	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	д/ Техника	д/ Техника		2010-09-19 03:09:42.332+04	2010-09-19 03:09:42.332+04
f82de515-a077-4c56-8005-efb9ba1931a2	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	м/ Без границ	м/ Без границ		2010-09-19 03:09:42.334+04	2010-09-19 03:09:42.334+04
2af7acce-208e-4e41-bd2b-f2f22a5d995f	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	н/ Цены ЗР	н/ Цены ЗР		2010-09-19 03:09:42.337+04	2010-09-19 03:09:42.337+04
bdc7b55f-cef5-48f6-a57a-46449ceee183	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.339+04	2010-09-19 03:09:42.339+04
cf7cd263-0eb6-41a8-bbb9-12e68ca6d480	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.34+04	2010-09-19 03:09:42.34+04
00000000-0000-0000-0000-000000000000	e398085f-1158-44fb-a179-927e56556e4e	Not found	Not found		2010-09-19 03:09:42.346+04	2010-09-19 03:09:42.346+04
fc56874d-bac6-462b-afe7-c1e8f83d5572	e398085f-1158-44fb-a179-927e56556e4e	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.35+04	2010-09-19 03:09:42.35+04
00000000-0000-0000-0000-000000000000	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	Not found	Not found		2010-09-19 03:09:42.356+04	2010-09-19 03:09:42.356+04
a2caddb1-ea8e-4c87-aa91-894c7ed1e4b7	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.36+04	2010-09-19 03:09:42.36+04
a1118aa3-1c1f-4381-bd44-da19a1bd1a05	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.361+04	2010-09-19 03:09:42.361+04
c97a7a38-72d9-448a-8fce-8887d6e806a9	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.363+04	2010-09-19 03:09:42.363+04
424e515d-ffd9-4358-aca3-320f3250dd59	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.364+04	2010-09-19 03:09:42.364+04
0eb5c5b2-8e13-485d-8982-81f4e9a08cbc	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.365+04	2010-09-19 03:09:42.365+04
e2ad1680-ca70-4be9-92be-7d6535973ee2	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.366+04	2010-09-19 03:09:42.366+04
2ef0b333-50fd-4320-9ed1-c5607f8e6f21	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.367+04	2010-09-19 03:09:42.367+04
2cdb6fd7-576b-4761-bff7-d808e34f239b	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.368+04	2010-09-19 03:09:42.368+04
8cd80d04-5260-44dd-8b3d-9d3b56758040	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.369+04	2010-09-19 03:09:42.369+04
e1ad1d07-2109-47b8-a61b-5cc8da3b73ff	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.371+04	2010-09-19 03:09:42.371+04
ff9f6c05-b5ee-4119-b841-ee940b5fa13e	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.372+04	2010-09-19 03:09:42.372+04
f9688ee6-9943-46e0-ba71-49e8b5261b0d	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	д/ Техника	д/ Техника		2010-09-19 03:09:42.373+04	2010-09-19 03:09:42.373+04
db0787a2-d4ce-4477-badd-a66836ac2252	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.374+04	2010-09-19 03:09:42.374+04
46936177-752c-4352-b394-3e7c0288bd46	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.375+04	2010-09-19 03:09:42.375+04
8c8d4cfa-8e3b-452e-acdf-ac399355fc5d	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.376+04	2010-09-19 03:09:42.376+04
81a9afc8-091a-4627-8273-bb374d9f744b	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.378+04	2010-09-19 03:09:42.378+04
7a3a57f8-ae4e-46a0-b5bb-c55f64cf353f	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	о/ Анонс	о/ Анонс		2010-09-19 03:09:42.379+04	2010-09-19 03:09:42.379+04
00000000-0000-0000-0000-000000000000	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	Not found	Not found		2010-09-19 03:09:42.385+04	2010-09-19 03:09:42.385+04
78afcc2b-540b-41ba-a09f-9c13323d3a20	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.389+04	2010-09-19 03:09:42.389+04
1a466b9f-6282-4147-a6a1-6224b34588d2	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.391+04	2010-09-19 03:09:42.391+04
b46c09fe-d40e-40c1-9f3b-82e35435b34d	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.392+04	2010-09-19 03:09:42.392+04
6c06e20d-2f52-4a77-8a54-0a4488c7747e	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.393+04	2010-09-19 03:09:42.393+04
3656d05b-b2bf-45cd-ba82-2a88d77eb325	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.394+04	2010-09-19 03:09:42.394+04
116e18b3-e8ba-4db6-b3cc-4c41bd165b55	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.395+04	2010-09-19 03:09:42.395+04
4b5351bc-88c9-466f-af8d-726859b42e19	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.396+04	2010-09-19 03:09:42.396+04
b95bade1-60f3-4019-94e9-8ffd698e4f8c	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.398+04	2010-09-19 03:09:42.398+04
11c099ea-5514-4beb-8b5d-98c3b1e85605	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.399+04	2010-09-19 03:09:42.399+04
7c8d983c-0587-436a-a175-f41dfd028941	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.4+04	2010-09-19 03:09:42.4+04
65247a10-eac8-403b-9e50-fbfaf22c062d	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.401+04	2010-09-19 03:09:42.401+04
a6c03712-3ca3-4463-bea3-c3c8a4c587fc	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	д/ Техника	д/ Техника		2010-09-19 03:09:42.402+04	2010-09-19 03:09:42.402+04
6bc542db-921b-41fd-92bc-1479f41696d5	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.403+04	2010-09-19 03:09:42.403+04
c1fbd000-a20d-4bf7-bdcd-1ac08dd7a5c1	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.404+04	2010-09-19 03:09:42.404+04
b50321c2-380f-444e-9236-ee47e92c6631	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.406+04	2010-09-19 03:09:42.406+04
7249388c-9dcc-49f4-af85-a2f3c7a87bdd	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.407+04	2010-09-19 03:09:42.407+04
00000000-0000-0000-0000-000000000000	66032704-2b7d-416c-98aa-aac5ad77dc64	Not found	Not found		2010-09-19 03:09:42.413+04	2010-09-19 03:09:42.413+04
2cf87957-2ca7-4339-ac92-dc090e05c697	66032704-2b7d-416c-98aa-aac5ad77dc64	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.417+04	2010-09-19 03:09:42.417+04
d9205f6b-4ca2-48a9-ac0b-b999ad0a62ef	66032704-2b7d-416c-98aa-aac5ad77dc64	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.418+04	2010-09-19 03:09:42.418+04
5869769a-2003-4f76-9b3c-5b4bafc08622	66032704-2b7d-416c-98aa-aac5ad77dc64	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.419+04	2010-09-19 03:09:42.419+04
993c7098-09f5-4b38-94bf-6a19b739049f	66032704-2b7d-416c-98aa-aac5ad77dc64	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.42+04	2010-09-19 03:09:42.42+04
a9d032b3-2112-4cc0-a3bf-9094caf548b6	66032704-2b7d-416c-98aa-aac5ad77dc64	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.421+04	2010-09-19 03:09:42.421+04
2af1e110-0b80-4507-98f5-138ed8020ad6	66032704-2b7d-416c-98aa-aac5ad77dc64	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.423+04	2010-09-19 03:09:42.423+04
f81fcffa-ffc6-46ad-970a-dc06dd48ef18	66032704-2b7d-416c-98aa-aac5ad77dc64	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.424+04	2010-09-19 03:09:42.424+04
2cac3ad4-cfa7-4bf2-9482-b1dc9481236e	66032704-2b7d-416c-98aa-aac5ad77dc64	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.425+04	2010-09-19 03:09:42.425+04
49bec8ab-2930-4be7-87e9-6c34c3e213ed	66032704-2b7d-416c-98aa-aac5ad77dc64	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.426+04	2010-09-19 03:09:42.426+04
89bccc84-c475-4fb4-a08b-d3eaf41b717c	66032704-2b7d-416c-98aa-aac5ad77dc64	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.427+04	2010-09-19 03:09:42.427+04
b32b0b23-fc48-418f-a688-64707976d981	66032704-2b7d-416c-98aa-aac5ad77dc64	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.428+04	2010-09-19 03:09:42.428+04
64a25f29-d647-4880-9cb6-04bbec8016cd	66032704-2b7d-416c-98aa-aac5ad77dc64	д/ Техника	д/ Техника		2010-09-19 03:09:42.429+04	2010-09-19 03:09:42.429+04
337d1397-0760-4f2d-8609-41320e397d8c	66032704-2b7d-416c-98aa-aac5ad77dc64	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.431+04	2010-09-19 03:09:42.431+04
bdfa0d88-4e93-4185-938d-177a4d4a56aa	66032704-2b7d-416c-98aa-aac5ad77dc64	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.432+04	2010-09-19 03:09:42.432+04
d64e62cd-f2d4-43d7-93e2-054a79e4e193	66032704-2b7d-416c-98aa-aac5ad77dc64	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.433+04	2010-09-19 03:09:42.433+04
4509e110-e51b-4726-b283-ca916b48c520	66032704-2b7d-416c-98aa-aac5ad77dc64	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.434+04	2010-09-19 03:09:42.434+04
00000000-0000-0000-0000-000000000000	cb899fea-facf-4eca-a529-04f6def0af78	Not found	Not found		2010-09-19 03:09:42.441+04	2010-09-19 03:09:42.441+04
f9f9d32a-c68a-4f5a-9608-08b5d654d9a3	cb899fea-facf-4eca-a529-04f6def0af78	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.445+04	2010-09-19 03:09:42.445+04
00000000-0000-0000-0000-000000000000	b159dd0f-8bd7-4555-8319-2083556bb7f8	Not found	Not found		2010-09-19 03:09:42.452+04	2010-09-19 03:09:42.452+04
f74fa03a-ca23-40df-8907-eb40f496bff1	b159dd0f-8bd7-4555-8319-2083556bb7f8	Без раздела	Без раздела		2010-09-19 03:09:42.456+04	2010-09-19 03:09:42.456+04
8184e9a0-4f15-4e9a-bdb7-ba742eaa6e31	b159dd0f-8bd7-4555-8319-2083556bb7f8	Экономика	Экономика		2010-09-19 03:09:42.457+04	2010-09-19 03:09:42.457+04
23118f23-ed96-461a-b53d-82059af22d86	b159dd0f-8bd7-4555-8319-2083556bb7f8	Содержание	Содержание		2010-09-19 03:09:42.458+04	2010-09-19 03:09:42.458+04
9313013a-61b5-419f-bc6c-716d89e6aa2e	b159dd0f-8bd7-4555-8319-2083556bb7f8	Главная тема	Главная тема		2010-09-19 03:09:42.459+04	2010-09-19 03:09:42.459+04
d53eb569-e2de-4e19-af89-9264a9629da9	b159dd0f-8bd7-4555-8319-2083556bb7f8	Спецпроект	Спецпроект		2010-09-19 03:09:42.46+04	2010-09-19 03:09:42.46+04
09035dc2-b8ba-44f3-9f55-5ab2bf2fe6a5	b159dd0f-8bd7-4555-8319-2083556bb7f8	Выставка	Выставка		2010-09-19 03:09:42.461+04	2010-09-19 03:09:42.461+04
a4082e57-5f1e-45ce-a518-1455a7bc21b4	b159dd0f-8bd7-4555-8319-2083556bb7f8	Автомобили	Автомобили		2010-09-19 03:09:42.462+04	2010-09-19 03:09:42.462+04
2f10f89d-dc5d-48d7-9d4a-c19ebcbf827f	b159dd0f-8bd7-4555-8319-2083556bb7f8	Спецтехника	Спецтехника		2010-09-19 03:09:42.463+04	2010-09-19 03:09:42.463+04
140bb7c1-1927-424c-b834-8392d9a42c25	b159dd0f-8bd7-4555-8319-2083556bb7f8	Автобаза	Автобаза		2010-09-19 03:09:42.465+04	2010-09-19 03:09:42.465+04
fe943f96-9285-4cfe-950c-008043d1b4ee	b159dd0f-8bd7-4555-8319-2083556bb7f8	Реклама	Реклама		2010-09-19 03:09:42.466+04	2010-09-19 03:09:42.466+04
00000000-0000-0000-0000-000000000000	63446907-3389-42e1-9775-d651a9d7877e	Not found	Not found		2010-09-19 03:09:42.473+04	2010-09-19 03:09:42.473+04
0ccc90bc-afd5-476a-8816-3519a55a02f9	63446907-3389-42e1-9775-d651a9d7877e	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.477+04	2010-09-19 03:09:42.477+04
ea5a204b-7c57-4ddb-912d-8918cf731bc2	63446907-3389-42e1-9775-d651a9d7877e	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.478+04	2010-09-19 03:09:42.478+04
d752b526-06ac-4fc3-ac7a-9f8088cf498f	63446907-3389-42e1-9775-d651a9d7877e	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.479+04	2010-09-19 03:09:42.479+04
214750df-52f9-4068-b851-d1a2be815bcc	63446907-3389-42e1-9775-d651a9d7877e	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.48+04	2010-09-19 03:09:42.48+04
c3b7f5f4-aad4-4fd7-a39b-144f1853e63a	63446907-3389-42e1-9775-d651a9d7877e	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.482+04	2010-09-19 03:09:42.482+04
db78b914-4b7f-483f-9ed9-8db9c9965fdb	63446907-3389-42e1-9775-d651a9d7877e	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.483+04	2010-09-19 03:09:42.483+04
3696a5ed-01e0-4b18-a79d-fd6955902a71	63446907-3389-42e1-9775-d651a9d7877e	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.484+04	2010-09-19 03:09:42.484+04
bec2c0c1-738f-405d-b951-7032238bd615	63446907-3389-42e1-9775-d651a9d7877e	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.485+04	2010-09-19 03:09:42.485+04
51d7dbe0-1178-4635-9e2a-d0cdbc2cda92	63446907-3389-42e1-9775-d651a9d7877e	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.486+04	2010-09-19 03:09:42.486+04
31c442e3-920b-47e8-94f2-7aa1ed4fda1f	63446907-3389-42e1-9775-d651a9d7877e	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.487+04	2010-09-19 03:09:42.487+04
8ac37180-9565-4feb-b6fe-b2b7d06b2384	63446907-3389-42e1-9775-d651a9d7877e	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.488+04	2010-09-19 03:09:42.488+04
a5b8991c-e406-4d9d-95e6-08db8fa711b7	63446907-3389-42e1-9775-d651a9d7877e	д/ Техника	д/ Техника		2010-09-19 03:09:42.49+04	2010-09-19 03:09:42.49+04
8b9d9b46-8d29-4d0a-a171-c7084de76646	63446907-3389-42e1-9775-d651a9d7877e	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.491+04	2010-09-19 03:09:42.491+04
aeb9987b-04a1-4617-8790-3716535e6f20	63446907-3389-42e1-9775-d651a9d7877e	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.492+04	2010-09-19 03:09:42.492+04
8f8f9618-26de-497d-842c-071c171c7c50	63446907-3389-42e1-9775-d651a9d7877e	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.493+04	2010-09-19 03:09:42.493+04
889fedfa-973c-42aa-9ef7-70d13ea99c23	63446907-3389-42e1-9775-d651a9d7877e	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.494+04	2010-09-19 03:09:42.494+04
00000000-0000-0000-0000-000000000000	5e21447b-0295-42d8-8fd5-b9af45f1af20	Not found	Not found		2010-09-19 03:09:42.5+04	2010-09-19 03:09:42.5+04
3c5a7923-1ddb-4a98-8452-85b9da9b0e80	5e21447b-0295-42d8-8fd5-b9af45f1af20	Раздел не указан	Раздел не указан		2010-09-19 03:09:42.505+04	2010-09-19 03:09:42.505+04
3d8c69cf-64b6-45e0-9a7e-75acb5eb2fa5	5e21447b-0295-42d8-8fd5-b9af45f1af20	История	История		2010-09-19 03:09:42.506+04	2010-09-19 03:09:42.506+04
2e26ce00-cdd0-4b99-833a-a36efda941ca	5e21447b-0295-42d8-8fd5-b9af45f1af20	Спорт	Спорт		2010-09-19 03:09:42.507+04	2010-09-19 03:09:42.507+04
40af7547-d287-4007-9b72-f22758945101	5e21447b-0295-42d8-8fd5-b9af45f1af20	Ремзона	Ремзона		2010-09-19 03:09:42.509+04	2010-09-19 03:09:42.509+04
3dcb71e3-b26a-47af-a490-da5d828818bc	5e21447b-0295-42d8-8fd5-b9af45f1af20	Мотоклуб	Мотоклуб		2010-09-19 03:09:42.51+04	2010-09-19 03:09:42.51+04
9a0c2f06-fb8f-478f-a2fe-80473b170015	5e21447b-0295-42d8-8fd5-b9af45f1af20	Рынок	Рынок		2010-09-19 03:09:42.511+04	2010-09-19 03:09:42.511+04
34c81ebf-94a1-454e-9d10-60edef754da1	5e21447b-0295-42d8-8fd5-b9af45f1af20	Реклама	Реклама		2010-09-19 03:09:42.512+04	2010-09-19 03:09:42.512+04
1a905155-78d2-4436-ac79-fb63de0aea18	5e21447b-0295-42d8-8fd5-b9af45f1af20	Обложка	Обложка		2010-09-19 03:09:42.513+04	2010-09-19 03:09:42.513+04
84229dda-b692-4d1f-8f7b-b0d6e5f34d6f	5e21447b-0295-42d8-8fd5-b9af45f1af20	Техника	Техника		2010-09-19 03:09:42.514+04	2010-09-19 03:09:42.514+04
11c4071f-ceca-4e5a-aabe-01701684b574	5e21447b-0295-42d8-8fd5-b9af45f1af20	Новости	Новости		2010-09-19 03:09:42.515+04	2010-09-19 03:09:42.515+04
caa9510e-3e4d-4755-99a5-49570a20c079	5e21447b-0295-42d8-8fd5-b9af45f1af20	Содержание	Содержание		2010-09-19 03:09:42.516+04	2010-09-19 03:09:42.516+04
8846e8b7-5b4d-4898-9ed8-fd36802e2901	5e21447b-0295-42d8-8fd5-b9af45f1af20	Анонс	Анонс		2010-09-19 03:09:42.517+04	2010-09-19 03:09:42.517+04
00000000-0000-0000-0000-000000000000	35250213-05d7-4702-9d95-2f2be1812eb4	Not found	Not found		2010-09-19 03:09:42.524+04	2010-09-19 03:09:42.524+04
b4d5f87b-d770-4a5d-950d-73eb24a79ed9	35250213-05d7-4702-9d95-2f2be1812eb4	Раздел не указан	Раздел не указан		2010-09-19 03:09:42.528+04	2010-09-19 03:09:42.528+04
82200dd2-ba9a-4a5e-b4bf-9e66c14766a7	35250213-05d7-4702-9d95-2f2be1812eb4	Новости	Новости		2010-09-19 03:09:42.53+04	2010-09-19 03:09:42.53+04
48e6ea99-a470-41f5-8590-e502d7d3fe68	35250213-05d7-4702-9d95-2f2be1812eb4	История	История		2010-09-19 03:09:42.531+04	2010-09-19 03:09:42.531+04
c22e1efc-2f95-41e2-8696-59dd0d86c4b6	35250213-05d7-4702-9d95-2f2be1812eb4	Спорт	Спорт		2010-09-19 03:09:42.532+04	2010-09-19 03:09:42.532+04
dfc6b4f3-2d06-4543-917c-03daf82ba5fd	35250213-05d7-4702-9d95-2f2be1812eb4	Ремзона	Ремзона		2010-09-19 03:09:42.533+04	2010-09-19 03:09:42.533+04
a9e590ca-6e60-471b-9e96-5ac1acb9dd49	35250213-05d7-4702-9d95-2f2be1812eb4	Мотоклуб	Мотоклуб		2010-09-19 03:09:42.534+04	2010-09-19 03:09:42.534+04
e4124896-6e0b-4740-9d13-d527a64f9e5d	35250213-05d7-4702-9d95-2f2be1812eb4	Рынок	Рынок		2010-09-19 03:09:42.536+04	2010-09-19 03:09:42.536+04
08040d2a-aff8-41b3-9536-b6ffb502c477	35250213-05d7-4702-9d95-2f2be1812eb4	Реклама	Реклама		2010-09-19 03:09:42.537+04	2010-09-19 03:09:42.537+04
0614b0bf-46ea-48e0-becd-3dcdeee9175c	35250213-05d7-4702-9d95-2f2be1812eb4	Обложка	Обложка		2010-09-19 03:09:42.538+04	2010-09-19 03:09:42.538+04
89c1ad06-e8b2-4bf4-94cf-39f4fe0099c0	35250213-05d7-4702-9d95-2f2be1812eb4	Техника	Техника		2010-09-19 03:09:42.539+04	2010-09-19 03:09:42.539+04
fb4528c9-bd47-4b74-8010-62104206378d	35250213-05d7-4702-9d95-2f2be1812eb4	Анонс	Анонс		2010-09-19 03:09:42.54+04	2010-09-19 03:09:42.54+04
e29d0893-d4e9-4073-b58a-ac86d523556c	35250213-05d7-4702-9d95-2f2be1812eb4	Содержание	Содержание		2010-09-19 03:09:42.541+04	2010-09-19 03:09:42.541+04
5faeaae7-784e-4368-860b-2c5ff244398f	35250213-05d7-4702-9d95-2f2be1812eb4	Тесты	Тесты		2010-09-19 03:09:42.542+04	2010-09-19 03:09:42.542+04
00000000-0000-0000-0000-000000000000	c7141356-2836-4525-8465-53983cf09d20	Not found	Not found		2010-09-19 03:09:42.548+04	2010-09-19 03:09:42.548+04
b6c8fda2-f61d-4745-925c-d784135dcb0f	c7141356-2836-4525-8465-53983cf09d20	Без раздела	Без раздела		2010-09-19 03:09:42.552+04	2010-09-19 03:09:42.552+04
588cd73c-b01f-4bb3-a87c-d1c53b8cc6df	c7141356-2836-4525-8465-53983cf09d20	Экономика	Экономика		2010-09-19 03:09:42.553+04	2010-09-19 03:09:42.553+04
ebb285c4-ad75-42e0-b56d-2397ec5225df	c7141356-2836-4525-8465-53983cf09d20	Содержание	Содержание		2010-09-19 03:09:42.554+04	2010-09-19 03:09:42.554+04
0bfeacba-3536-4c93-a23a-4a229c97eec4	c7141356-2836-4525-8465-53983cf09d20	Главная тема	Главная тема		2010-09-19 03:09:42.556+04	2010-09-19 03:09:42.556+04
6e3f554e-3a34-47a7-8451-30688414aab4	c7141356-2836-4525-8465-53983cf09d20	Спецпроект	Спецпроект		2010-09-19 03:09:42.557+04	2010-09-19 03:09:42.557+04
fc2c16bb-4680-4fb0-8df7-2bad29291b39	c7141356-2836-4525-8465-53983cf09d20	Выставка	Выставка		2010-09-19 03:09:42.558+04	2010-09-19 03:09:42.558+04
0613b417-39e8-43ce-8735-dead3bc9315b	c7141356-2836-4525-8465-53983cf09d20	Автомобили	Автомобили		2010-09-19 03:09:42.559+04	2010-09-19 03:09:42.559+04
29c95927-c4a2-4b43-822e-9db30069ea28	c7141356-2836-4525-8465-53983cf09d20	Спецтехника	Спецтехника		2010-09-19 03:09:42.56+04	2010-09-19 03:09:42.56+04
306dea2c-f862-4cee-ba99-42999133c04e	c7141356-2836-4525-8465-53983cf09d20	Автобаза	Автобаза		2010-09-19 03:09:42.561+04	2010-09-19 03:09:42.561+04
00000000-0000-0000-0000-000000000000	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Not found	Not found		2010-09-19 03:09:42.567+04	2010-09-19 03:09:42.567+04
fb14cc50-2d7d-4389-81b9-a98e9e582afa	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Без раздела	Без раздела		2010-09-19 03:09:42.571+04	2010-09-19 03:09:42.571+04
fcb024ea-c378-4ca3-b4bb-76da27b69dc8	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Экономика	Экономика		2010-09-19 03:09:42.572+04	2010-09-19 03:09:42.572+04
edd6c054-768d-4d9b-9427-af6a0407565f	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Содержание	Содержание		2010-09-19 03:09:42.573+04	2010-09-19 03:09:42.573+04
39e5a642-0605-4cf2-8ae7-02e357cbacf5	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Главная тема	Главная тема		2010-09-19 03:09:42.574+04	2010-09-19 03:09:42.574+04
8fa34d9e-0cd6-4b53-ab33-98e756f39b8f	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Спецпроект	Спецпроект		2010-09-19 03:09:42.575+04	2010-09-19 03:09:42.575+04
f1fd2677-48a3-44ce-9fad-e41712ab10c9	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Выставка	Выставка		2010-09-19 03:09:42.576+04	2010-09-19 03:09:42.576+04
7e3c2704-873b-4ec3-82fd-85d798f88cfb	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Автомобили	Автомобили		2010-09-19 03:09:42.578+04	2010-09-19 03:09:42.578+04
6abfa166-005b-4cf4-9642-ed16ab87fc32	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Спецтехника	Спецтехника		2010-09-19 03:09:42.579+04	2010-09-19 03:09:42.579+04
eadb0e09-588a-4f89-bbaa-438137aea2e8	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Автобаза	Автобаза		2010-09-19 03:09:42.58+04	2010-09-19 03:09:42.58+04
066ef7a8-22df-483a-9e60-0b464e09f8b1	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	Реклама	Реклама		2010-09-19 03:09:42.581+04	2010-09-19 03:09:42.581+04
00000000-0000-0000-0000-000000000000	f792f23a-5123-4854-b50d-7352c9d20245	Not found	Not found		2010-09-19 03:09:42.587+04	2010-09-19 03:09:42.587+04
f5d67195-ed8f-4c1b-bcfa-1d58f8275ac0	f792f23a-5123-4854-b50d-7352c9d20245	Автобаза	Автобаза		2010-09-19 03:09:42.59+04	2010-09-19 03:09:42.59+04
18ad08c6-c246-4480-8a5e-0b71052cc019	f792f23a-5123-4854-b50d-7352c9d20245	Без раздела	Без раздела		2010-09-19 03:09:42.592+04	2010-09-19 03:09:42.592+04
d271f972-49c3-46ff-8a43-7ba1dab45a88	f792f23a-5123-4854-b50d-7352c9d20245	Экономика	Экономика		2010-09-19 03:09:42.593+04	2010-09-19 03:09:42.593+04
4e41ea8a-288a-45bd-959d-9ae98b566212	f792f23a-5123-4854-b50d-7352c9d20245	Содержание	Содержание		2010-09-19 03:09:42.594+04	2010-09-19 03:09:42.594+04
a4f7f232-6ac0-4f8f-9191-af0fd3f958f5	f792f23a-5123-4854-b50d-7352c9d20245	Главная тема	Главная тема		2010-09-19 03:09:42.595+04	2010-09-19 03:09:42.595+04
7588c82d-4b43-4a7e-8693-43788d232098	f792f23a-5123-4854-b50d-7352c9d20245	Спецпроект	Спецпроект		2010-09-19 03:09:42.596+04	2010-09-19 03:09:42.596+04
ab4a85ed-b163-4e25-ade4-c39e2492d75f	f792f23a-5123-4854-b50d-7352c9d20245	Выставка	Выставка		2010-09-19 03:09:42.597+04	2010-09-19 03:09:42.597+04
ac1fb185-20ce-490f-8b2c-1731fc2ad33d	f792f23a-5123-4854-b50d-7352c9d20245	Автомобили	Автомобили		2010-09-19 03:09:42.598+04	2010-09-19 03:09:42.598+04
1c5093d7-3b6d-4d1e-8176-0560a17a726a	f792f23a-5123-4854-b50d-7352c9d20245	Спецтехника	Спецтехника		2010-09-19 03:09:42.599+04	2010-09-19 03:09:42.599+04
a3001937-5a01-4cb6-946d-197d5760d982	f792f23a-5123-4854-b50d-7352c9d20245	Реклама	Реклама		2010-09-19 03:09:42.6+04	2010-09-19 03:09:42.6+04
00000000-0000-0000-0000-000000000000	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Not found	Not found		2010-09-19 03:09:42.606+04	2010-09-19 03:09:42.606+04
1af82939-27ea-44c4-a7b2-1ff1f1a865de	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Раздел не указан	Раздел не указан		2010-09-19 03:09:42.611+04	2010-09-19 03:09:42.611+04
8a4dff37-3c03-47cd-b3cf-63ec1a00da2c	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Новости	Новости		2010-09-19 03:09:42.612+04	2010-09-19 03:09:42.612+04
a33ffba3-461e-4597-b243-59544d235d9c	70a3568d-7cdf-4ce1-9015-6cdd19972e06	История	История		2010-09-19 03:09:42.613+04	2010-09-19 03:09:42.613+04
8a1e654f-49c3-40b8-b8ee-edbce60bb94e	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Спорт	Спорт		2010-09-19 03:09:42.614+04	2010-09-19 03:09:42.614+04
445f752a-d528-4b1b-b937-126ea5b5fba7	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Ремзона	Ремзона		2010-09-19 03:09:42.615+04	2010-09-19 03:09:42.615+04
8c6ccbec-b404-418e-9210-12418db19d4a	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Мотоклуб	Мотоклуб		2010-09-19 03:09:42.617+04	2010-09-19 03:09:42.617+04
dce9d2f4-2283-4131-ac9c-f65b049c1606	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Рынок	Рынок		2010-09-19 03:09:42.618+04	2010-09-19 03:09:42.618+04
f0576f3d-f325-4ed4-a1e1-15627a1996d1	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Реклама	Реклама		2010-09-19 03:09:42.619+04	2010-09-19 03:09:42.619+04
6b8f4714-c749-48e2-8332-0227c32990c8	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Обложка	Обложка		2010-09-19 03:09:42.62+04	2010-09-19 03:09:42.62+04
54b0de2a-e8c5-4eb9-9725-5d61174d5d26	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Техника	Техника		2010-09-19 03:09:42.621+04	2010-09-19 03:09:42.621+04
fd6dbaed-dfdc-40c1-b026-efeebca2720b	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Содержание	Содержание		2010-09-19 03:09:42.622+04	2010-09-19 03:09:42.622+04
17b81e05-56fd-49f5-85ef-2e4169b97a9b	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Тесты	Тесты		2010-09-19 03:09:42.624+04	2010-09-19 03:09:42.624+04
5adca732-5dae-47c9-8728-eaf90c5f75b5	70a3568d-7cdf-4ce1-9015-6cdd19972e06	Анонс	Анонс		2010-09-19 03:09:42.625+04	2010-09-19 03:09:42.625+04
00000000-0000-0000-0000-000000000000	de7bcae7-cdc7-4df3-b177-af801d15cac6	Not found	Not found		2010-09-19 03:09:42.63+04	2010-09-19 03:09:42.63+04
00000000-0000-0000-0000-000000000000	c6deaf72-e508-4f5d-aeca-942786e29e03	Not found	Not found		2010-09-19 03:09:42.64+04	2010-09-19 03:09:42.64+04
0396ca82-a544-4ee6-9adf-a0feb0966bd5	c6deaf72-e508-4f5d-aeca-942786e29e03	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.645+04	2010-09-19 03:09:42.645+04
c875ae9e-e5f9-40d8-91ab-28a4bc287202	c6deaf72-e508-4f5d-aeca-942786e29e03	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.646+04	2010-09-19 03:09:42.646+04
1f6df157-eae9-459a-a202-0347c4e9496b	c6deaf72-e508-4f5d-aeca-942786e29e03	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.647+04	2010-09-19 03:09:42.647+04
45c5153d-441d-42a9-8dcb-a923443d9351	c6deaf72-e508-4f5d-aeca-942786e29e03	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.648+04	2010-09-19 03:09:42.648+04
f6435f2d-df68-40da-964e-9b1fd904b959	c6deaf72-e508-4f5d-aeca-942786e29e03	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.65+04	2010-09-19 03:09:42.65+04
d45c58db-0aa6-48e1-88f1-f828ba4ca428	c6deaf72-e508-4f5d-aeca-942786e29e03	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.651+04	2010-09-19 03:09:42.651+04
b2ebc120-ecfe-4336-95df-167790acc573	c6deaf72-e508-4f5d-aeca-942786e29e03	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.652+04	2010-09-19 03:09:42.652+04
4fc47d56-af94-47bf-b9e0-4348f7088eb3	c6deaf72-e508-4f5d-aeca-942786e29e03	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.653+04	2010-09-19 03:09:42.653+04
955e01c5-5b21-44d9-9b1c-06721e830928	c6deaf72-e508-4f5d-aeca-942786e29e03	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.654+04	2010-09-19 03:09:42.654+04
69861471-7ff8-459c-9db8-f770ca498624	c6deaf72-e508-4f5d-aeca-942786e29e03	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.655+04	2010-09-19 03:09:42.655+04
e676f416-9d29-41b6-9dd2-57dbd7711c0a	c6deaf72-e508-4f5d-aeca-942786e29e03	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.657+04	2010-09-19 03:09:42.657+04
7b5ef489-a90a-4e23-9e2f-2bc11848d7e1	c6deaf72-e508-4f5d-aeca-942786e29e03	д/ Техника	д/ Техника		2010-09-19 03:09:42.658+04	2010-09-19 03:09:42.658+04
b195b62f-eb46-4be0-984c-324a6346a9f0	c6deaf72-e508-4f5d-aeca-942786e29e03	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.659+04	2010-09-19 03:09:42.659+04
1e39af2c-bdb8-4cca-b855-7c0063a6ff19	c6deaf72-e508-4f5d-aeca-942786e29e03	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.66+04	2010-09-19 03:09:42.66+04
934edffe-f810-40a2-86c6-a0936f60fd38	c6deaf72-e508-4f5d-aeca-942786e29e03	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.661+04	2010-09-19 03:09:42.661+04
9594e95e-1d36-4941-9d6e-41c742750105	c6deaf72-e508-4f5d-aeca-942786e29e03	00/ ОБЛОЖКА	00/ ОБЛОЖКА		2010-09-19 03:09:42.662+04	2010-09-19 03:09:42.662+04
eacbc026-c850-4b18-81ed-5d64d338c4a2	c6deaf72-e508-4f5d-aeca-942786e29e03	о/ Анонс	о/ Анонс		2010-09-19 03:09:42.664+04	2010-09-19 03:09:42.664+04
79e90784-68a2-4660-855e-ef6b60e5414e	c6deaf72-e508-4f5d-aeca-942786e29e03	п/ афиша ЗР	п/ афиша ЗР		2010-09-19 03:09:42.665+04	2010-09-19 03:09:42.665+04
364efb20-64fd-45c0-b96b-c613f8280031	c6deaf72-e508-4f5d-aeca-942786e29e03	0/  гл.  редактора	0/  гл.  редактора		2010-09-19 03:09:42.666+04	2010-09-19 03:09:42.666+04
f7d3047d-f94e-41c4-9fb1-2a8f0f8c6190	c6deaf72-e508-4f5d-aeca-942786e29e03	и/рекламный блок	и/рекламный блок		2010-09-19 03:09:42.667+04	2010-09-19 03:09:42.667+04
00000000-0000-0000-0000-000000000000	81f5a35c-f74f-4d47-97da-a045878a7091	Not found	Not found		2010-09-19 03:09:42.673+04	2010-09-19 03:09:42.673+04
d201f46e-1b81-40d0-b9e7-2615f681f140	81f5a35c-f74f-4d47-97da-a045878a7091	Содержание	Содержание		2010-09-19 03:09:42.678+04	2010-09-19 03:09:42.678+04
2572bbb3-34b0-4068-be89-3fda3748925d	81f5a35c-f74f-4d47-97da-a045878a7091	Без раздела	Без раздела		2010-09-19 03:09:42.679+04	2010-09-19 03:09:42.679+04
97c70897-ddef-400b-b3ca-c0d82ed5f2c1	81f5a35c-f74f-4d47-97da-a045878a7091	Экономика	Экономика		2010-09-19 03:09:42.68+04	2010-09-19 03:09:42.68+04
9b96bcb3-75c8-4ea4-aa76-8184591aa90c	81f5a35c-f74f-4d47-97da-a045878a7091	Главная тема	Главная тема		2010-09-19 03:09:42.681+04	2010-09-19 03:09:42.681+04
e2ec1213-e0b6-4078-ab6f-a71c099b988f	81f5a35c-f74f-4d47-97da-a045878a7091	Спецпроект	Спецпроект		2010-09-19 03:09:42.683+04	2010-09-19 03:09:42.683+04
5f2b8f6b-e719-46ea-8bf5-c18d1b53985e	81f5a35c-f74f-4d47-97da-a045878a7091	Автомобили	Автомобили		2010-09-19 03:09:42.684+04	2010-09-19 03:09:42.684+04
c78cbcec-07d6-4422-9db4-a08db66e10ec	81f5a35c-f74f-4d47-97da-a045878a7091	Выставка	Выставка		2010-09-19 03:09:42.685+04	2010-09-19 03:09:42.685+04
678d6344-9dad-471e-a7f0-35061ddda1bd	81f5a35c-f74f-4d47-97da-a045878a7091	Спецтехника	Спецтехника		2010-09-19 03:09:42.686+04	2010-09-19 03:09:42.686+04
c476c151-ab0d-4716-8a8d-9e14432bd16f	81f5a35c-f74f-4d47-97da-a045878a7091	Автобаза	Автобаза		2010-09-19 03:09:42.687+04	2010-09-19 03:09:42.687+04
102c24c7-b47e-4aa2-93d6-40ce36540934	81f5a35c-f74f-4d47-97da-a045878a7091	Реклама	Реклама		2010-09-19 03:09:42.689+04	2010-09-19 03:09:42.689+04
00000000-0000-0000-0000-000000000000	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	Not found	Not found		2010-09-19 03:09:42.696+04	2010-09-19 03:09:42.696+04
e3aedc77-ba75-423c-ab4d-1ebe9e5d359f	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.701+04	2010-09-19 03:09:42.701+04
f58586f3-182b-429a-a68c-98e13df6b769	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	04/ НОВОСТИ	04/ НОВОСТИ		2010-09-19 03:09:42.702+04	2010-09-19 03:09:42.702+04
43ee9df6-90f1-4a38-b58b-2515379c93b3	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	03/ Содержание	03/ Содержание		2010-09-19 03:09:42.703+04	2010-09-19 03:09:42.703+04
48892ecb-4aec-46b8-b680-6dec1c001b00	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.704+04	2010-09-19 03:09:42.704+04
eda45330-3aa7-4626-b72a-6f4f2abbb491	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.706+04	2010-09-19 03:09:42.706+04
202c8ac0-950a-467c-969f-1d8fedcd4f6a	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.707+04	2010-09-19 03:09:42.707+04
5a1b6961-d822-41c2-b4c7-e176e0ec0df3	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.708+04	2010-09-19 03:09:42.708+04
a78e6fe6-30d1-48f3-9752-91deb9dea69b	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.709+04	2010-09-19 03:09:42.709+04
53650b54-09d7-45fa-8382-5e697bce226e	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.71+04	2010-09-19 03:09:42.71+04
0e5aefea-3b8b-48de-94b8-7b93801135ee	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.712+04	2010-09-19 03:09:42.712+04
ea2020d0-20c2-4aac-b27b-7e23fbc1b864	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.713+04	2010-09-19 03:09:42.713+04
09127c88-84be-4c8f-8b89-a1639544cb4d	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	д/ Техника	д/ Техника		2010-09-19 03:09:42.714+04	2010-09-19 03:09:42.714+04
7ce20128-985d-4250-90a2-0b588e8275cd	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:42.716+04	2010-09-19 03:09:42.716+04
fc912b97-e0ab-4721-a2ba-46387e1b47e3	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	ч/ Анонс	ч/ Анонс		2010-09-19 03:09:42.717+04	2010-09-19 03:09:42.717+04
813d78ff-a4c6-48d9-94db-0c3f0fc70fa9	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.718+04	2010-09-19 03:09:42.718+04
9341d5c3-bd2a-40fa-94fe-6a6835d57e5b	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.719+04	2010-09-19 03:09:42.719+04
e7149cb5-7660-4132-b322-b0204345f7db	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.72+04	2010-09-19 03:09:42.72+04
faf482b6-2f93-4a42-84fd-5b16e4d410ae	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	01/ ОБЛОЖКА	01/ ОБЛОЖКА		2010-09-19 03:09:42.722+04	2010-09-19 03:09:42.722+04
1404084c-5347-43d3-9266-74df15a74441	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	02/ Крупным планом	02/ Крупным планом		2010-09-19 03:09:42.723+04	2010-09-19 03:09:42.723+04
00000000-0000-0000-0000-000000000000	43942374-48e0-4319-b644-e16c6f9154ac	Not found	Not found		2010-09-19 03:09:42.729+04	2010-09-19 03:09:42.729+04
7d517e35-5dad-4222-9184-cb73bae2b924	43942374-48e0-4319-b644-e16c6f9154ac	Без раздела	Без раздела		2010-09-19 03:09:42.733+04	2010-09-19 03:09:42.733+04
919a2293-9eca-495e-ace4-3be3144c0d23	43942374-48e0-4319-b644-e16c6f9154ac	Экономика	Экономика		2010-09-19 03:09:42.735+04	2010-09-19 03:09:42.735+04
c3152856-502a-445b-8c42-f7be2a17f94d	43942374-48e0-4319-b644-e16c6f9154ac	Содержание	Содержание		2010-09-19 03:09:42.736+04	2010-09-19 03:09:42.736+04
8471aeba-8ad2-42d5-96c0-62c4c2de5d58	43942374-48e0-4319-b644-e16c6f9154ac	Главная тема	Главная тема		2010-09-19 03:09:42.737+04	2010-09-19 03:09:42.737+04
e66e6f04-efa7-4380-9f60-17f1a0ff4d1d	43942374-48e0-4319-b644-e16c6f9154ac	Спецпроект	Спецпроект		2010-09-19 03:09:42.738+04	2010-09-19 03:09:42.738+04
c38f81c3-9415-4af4-a3bd-fc190e7fdc60	43942374-48e0-4319-b644-e16c6f9154ac	Выставка	Выставка		2010-09-19 03:09:42.74+04	2010-09-19 03:09:42.74+04
25537cf7-42c9-43bf-a785-3311922b16ba	43942374-48e0-4319-b644-e16c6f9154ac	Автомобили	Автомобили		2010-09-19 03:09:42.741+04	2010-09-19 03:09:42.741+04
b3a57795-4183-4635-9077-084a21989810	43942374-48e0-4319-b644-e16c6f9154ac	Спецтехника	Спецтехника		2010-09-19 03:09:42.742+04	2010-09-19 03:09:42.742+04
eb2bd97b-276f-406f-a964-aecbf4583ee5	43942374-48e0-4319-b644-e16c6f9154ac	Автобаза	Автобаза		2010-09-19 03:09:42.744+04	2010-09-19 03:09:42.744+04
dcd9a464-492e-47b2-902d-90c701fd2367	43942374-48e0-4319-b644-e16c6f9154ac	Реклама	Реклама		2010-09-19 03:09:42.745+04	2010-09-19 03:09:42.745+04
00000000-0000-0000-0000-000000000000	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	Not found	Not found		2010-09-19 03:09:42.751+04	2010-09-19 03:09:42.751+04
73d99862-6663-4e4d-bc83-3e3c7370257e	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.756+04	2010-09-19 03:09:42.756+04
03ff5dde-f391-4fef-b9d6-78c744ad07fa	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.757+04	2010-09-19 03:09:42.757+04
a18586a8-1d93-47b5-a82c-70fd1231755e	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.758+04	2010-09-19 03:09:42.758+04
dcec495e-d658-4e08-8b47-a1382da1484c	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.759+04	2010-09-19 03:09:42.759+04
61b28828-cb5e-43d1-a956-0d3d0ff16c7d	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.761+04	2010-09-19 03:09:42.761+04
b56eba6f-d241-4ab8-997e-abed416927a8	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.762+04	2010-09-19 03:09:42.762+04
59c5ebb2-66ae-40a3-9852-32709de8b81b	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.763+04	2010-09-19 03:09:42.763+04
97a08130-5669-4dd2-bded-71cfbb2102c1	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.764+04	2010-09-19 03:09:42.764+04
5ba27f1f-bd04-457f-9302-5e857ad6c638	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.765+04	2010-09-19 03:09:42.765+04
79838061-e64d-4047-8cb1-334b6f8e4a35	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.767+04	2010-09-19 03:09:42.767+04
bc2fcfa2-4ebc-41c9-b5ba-2a4fcc2a8105	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.768+04	2010-09-19 03:09:42.768+04
efc1fba0-ccd4-4d85-b444-25845a482248	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	д/ Техника	д/ Техника		2010-09-19 03:09:42.769+04	2010-09-19 03:09:42.769+04
7159c96b-2df4-4319-b8db-3e708b32a3a1	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.77+04	2010-09-19 03:09:42.77+04
1da1d5fb-0c2a-4ba7-936a-555b2e17f9af	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.772+04	2010-09-19 03:09:42.772+04
416cf5d5-3206-4eff-b287-dc36d2285f67	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.774+04	2010-09-19 03:09:42.774+04
269a3b2d-dbdf-4c43-9c48-520c2dbdb312	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.775+04	2010-09-19 03:09:42.775+04
00000000-0000-0000-0000-000000000000	08362519-7e72-4213-840a-4fc744c5a48e	Not found	Not found		2010-09-19 03:09:42.782+04	2010-09-19 03:09:42.782+04
b3a9d1bb-e73d-4939-8e08-4c7bf921354d	08362519-7e72-4213-840a-4fc744c5a48e	Обложка	Обложка		2010-09-19 03:09:42.787+04	2010-09-19 03:09:42.787+04
bf5f733e-8b94-4e1f-9b1f-81e2c5589df5	08362519-7e72-4213-840a-4fc744c5a48e	ГОРОД И АВТОМОБИЛЬ	ГОРОД И АВТОМОБИЛЬ		2010-09-19 03:09:42.788+04	2010-09-19 03:09:42.788+04
7ff0c4e7-81c0-475b-9a08-04c9197ebf88	08362519-7e72-4213-840a-4fc744c5a48e	Содержание	Содержание		2010-09-19 03:09:42.789+04	2010-09-19 03:09:42.789+04
83cef119-756f-4109-9942-c859cc0b9927	08362519-7e72-4213-840a-4fc744c5a48e	Без рубрики	Без рубрики		2010-09-19 03:09:42.79+04	2010-09-19 03:09:42.79+04
dc71d948-2a6d-4f28-af2b-6a7427120a3a	08362519-7e72-4213-840a-4fc744c5a48e	ДЕТАЛИ, КОМПОНЕНТЫ	ДЕТАЛИ, КОМПОНЕНТЫ		2010-09-19 03:09:42.792+04	2010-09-19 03:09:42.792+04
f6831770-dcac-49a6-b7c5-622460250866	08362519-7e72-4213-840a-4fc744c5a48e	АВТОМОБИЛЬ	АВТОМОБИЛЬ		2010-09-19 03:09:42.793+04	2010-09-19 03:09:42.793+04
06278ea8-3a3d-4538-931e-f886b059111d	08362519-7e72-4213-840a-4fc744c5a48e	СЭКОНД-ХЕНД	СЭКОНД-ХЕНД		2010-09-19 03:09:42.794+04	2010-09-19 03:09:42.794+04
00000000-0000-0000-0000-000000000000	534b9942-48ef-49d7-bbbd-b752ecfde409	Not found	Not found		2010-09-19 03:09:42.8+04	2010-09-19 03:09:42.8+04
56e57bd3-c16c-43ee-942d-fd3a59e0a83a	534b9942-48ef-49d7-bbbd-b752ecfde409	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.805+04	2010-09-19 03:09:42.805+04
ca563871-5809-4f2a-bf1f-20b3fed5de17	534b9942-48ef-49d7-bbbd-b752ecfde409	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.806+04	2010-09-19 03:09:42.806+04
e2109777-ef91-46ed-afcb-25140bf67f4c	534b9942-48ef-49d7-bbbd-b752ecfde409	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.807+04	2010-09-19 03:09:42.807+04
a3bef759-fa49-4d9f-8860-147ada2bfde6	534b9942-48ef-49d7-bbbd-b752ecfde409	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.809+04	2010-09-19 03:09:42.809+04
6221d1ee-a0c5-488b-914f-4024e97bc30e	534b9942-48ef-49d7-bbbd-b752ecfde409	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.81+04	2010-09-19 03:09:42.81+04
e8445e97-87cb-4c99-ab9a-c16a4e38ae73	534b9942-48ef-49d7-bbbd-b752ecfde409	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.811+04	2010-09-19 03:09:42.811+04
39d2d01d-5de6-454e-8d41-9eaaf460c8dd	534b9942-48ef-49d7-bbbd-b752ecfde409	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.812+04	2010-09-19 03:09:42.812+04
3579923c-c736-4b7a-bf34-885c6fb30031	534b9942-48ef-49d7-bbbd-b752ecfde409	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.813+04	2010-09-19 03:09:42.813+04
ad88b925-1bf7-4855-a85a-11c38e1b65bf	534b9942-48ef-49d7-bbbd-b752ecfde409	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.815+04	2010-09-19 03:09:42.815+04
3f0fa79b-2ed8-4a2a-9aa2-da0dd74dc44f	534b9942-48ef-49d7-bbbd-b752ecfde409	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.816+04	2010-09-19 03:09:42.816+04
b8d70acf-54ce-449d-8a84-265c5883325f	534b9942-48ef-49d7-bbbd-b752ecfde409	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.817+04	2010-09-19 03:09:42.817+04
8f0fa94d-edbd-49bc-86a1-74faf7253ab8	534b9942-48ef-49d7-bbbd-b752ecfde409	д/ Техника	д/ Техника		2010-09-19 03:09:42.818+04	2010-09-19 03:09:42.818+04
3cda8ff8-353b-47c0-853c-43ff6f4d30ce	534b9942-48ef-49d7-bbbd-b752ecfde409	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.819+04	2010-09-19 03:09:42.819+04
639905f0-5bf7-4a95-b1b8-b7099b518bee	534b9942-48ef-49d7-bbbd-b752ecfde409	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.82+04	2010-09-19 03:09:42.82+04
13ddb521-d83e-4239-9971-4f910e88124d	534b9942-48ef-49d7-bbbd-b752ecfde409	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.822+04	2010-09-19 03:09:42.822+04
9479c2bd-a73c-4498-b447-efe80e20fc34	534b9942-48ef-49d7-bbbd-b752ecfde409	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.823+04	2010-09-19 03:09:42.823+04
87ccd97a-673b-49ab-99bd-7f837c656277	534b9942-48ef-49d7-bbbd-b752ecfde409	ц/ Рекламный блок	ц/ Рекламный блок		2010-09-19 03:09:42.824+04	2010-09-19 03:09:42.824+04
00000000-0000-0000-0000-000000000000	f8e1287c-5527-464a-9a7e-478110ff1f03	Not found	Not found		2010-09-19 03:09:42.83+04	2010-09-19 03:09:42.83+04
aa4d8125-e1bc-4f4c-9ece-60beb4c2490d	f8e1287c-5527-464a-9a7e-478110ff1f03	Раздел не указан	Раздел не указан		2010-09-19 03:09:42.835+04	2010-09-19 03:09:42.835+04
c543bb3b-971d-48a9-a976-e31db7558513	f8e1287c-5527-464a-9a7e-478110ff1f03	Новости	Новости		2010-09-19 03:09:42.836+04	2010-09-19 03:09:42.836+04
67e2fd05-90ce-413e-b860-7fd5f31d9ec4	f8e1287c-5527-464a-9a7e-478110ff1f03	История	История		2010-09-19 03:09:42.838+04	2010-09-19 03:09:42.838+04
d2231790-c7aa-4ad2-85a0-488e3afb2adc	f8e1287c-5527-464a-9a7e-478110ff1f03	Спорт	Спорт		2010-09-19 03:09:42.839+04	2010-09-19 03:09:42.839+04
9ea64980-72a6-434c-82f3-1302c885097f	f8e1287c-5527-464a-9a7e-478110ff1f03	Ремзона	Ремзона		2010-09-19 03:09:42.84+04	2010-09-19 03:09:42.84+04
b0f12141-f012-4676-af53-b092977e8beb	f8e1287c-5527-464a-9a7e-478110ff1f03	Мотоклуб	Мотоклуб		2010-09-19 03:09:42.841+04	2010-09-19 03:09:42.841+04
4b6eb679-d984-4ad5-9c8e-c2c89f3bd602	f8e1287c-5527-464a-9a7e-478110ff1f03	Рынок	Рынок		2010-09-19 03:09:42.842+04	2010-09-19 03:09:42.842+04
aff6151c-7c53-4bb9-bd46-77b989bad826	f8e1287c-5527-464a-9a7e-478110ff1f03	Реклама	Реклама		2010-09-19 03:09:42.844+04	2010-09-19 03:09:42.844+04
069e9327-ac25-4da9-bd31-9f00e9c17e94	f8e1287c-5527-464a-9a7e-478110ff1f03	Обложка	Обложка		2010-09-19 03:09:42.845+04	2010-09-19 03:09:42.845+04
e8a4f413-0aa8-45dc-8b7e-a6cf55f9a560	f8e1287c-5527-464a-9a7e-478110ff1f03	Анонс	Анонс		2010-09-19 03:09:42.846+04	2010-09-19 03:09:42.846+04
8cd4580e-72b2-4e32-9933-d53c22f71202	f8e1287c-5527-464a-9a7e-478110ff1f03	Тесты	Тесты		2010-09-19 03:09:42.847+04	2010-09-19 03:09:42.847+04
a6039521-7cfd-4106-a614-20d988123ce2	f8e1287c-5527-464a-9a7e-478110ff1f03	Техника	Техника		2010-09-19 03:09:42.848+04	2010-09-19 03:09:42.848+04
cb7a0c8b-0071-46c5-b649-9b93d5b06895	f8e1287c-5527-464a-9a7e-478110ff1f03	Содержание	Содержание		2010-09-19 03:09:42.849+04	2010-09-19 03:09:42.849+04
00000000-0000-0000-0000-000000000000	2d1808ce-bd9b-428e-ade9-b9aae2ce5c1b	Not found	Not found		2010-09-19 03:09:42.856+04	2010-09-19 03:09:42.856+04
126cc47b-1596-4113-87b9-bd57eb7cc894	2d1808ce-bd9b-428e-ade9-b9aae2ce5c1b	ф/ Мос-вкладка	ф/ Мос-вкладка		2010-09-19 03:09:42.86+04	2010-09-19 03:09:42.86+04
00000000-0000-0000-0000-000000000000	9b29875c-f00b-4c86-93eb-759fa3420a20	Not found	Not found		2010-09-19 03:09:42.867+04	2010-09-19 03:09:42.867+04
8cac740f-53c5-4196-830d-d9ec2958deab	9b29875c-f00b-4c86-93eb-759fa3420a20	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.871+04	2010-09-19 03:09:42.871+04
efbab48c-cda0-45c4-a72b-d5785784635f	9b29875c-f00b-4c86-93eb-759fa3420a20	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.872+04	2010-09-19 03:09:42.872+04
67ad10b7-5b87-4fef-ba55-23aa8607cc0c	9b29875c-f00b-4c86-93eb-759fa3420a20	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.874+04	2010-09-19 03:09:42.874+04
84a94541-daf5-43d1-876b-07657a7baff5	9b29875c-f00b-4c86-93eb-759fa3420a20	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.875+04	2010-09-19 03:09:42.875+04
b824ae8e-9dd7-47ef-b1f8-879844444522	9b29875c-f00b-4c86-93eb-759fa3420a20	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.876+04	2010-09-19 03:09:42.876+04
ac730861-4894-4290-b717-aac49bfc35d2	9b29875c-f00b-4c86-93eb-759fa3420a20	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.877+04	2010-09-19 03:09:42.877+04
8100e3ce-1bdb-41da-9114-4bd4a396a15e	9b29875c-f00b-4c86-93eb-759fa3420a20	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.878+04	2010-09-19 03:09:42.878+04
00401739-b15f-4ffe-becc-94b0d6af8dd1	9b29875c-f00b-4c86-93eb-759fa3420a20	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.88+04	2010-09-19 03:09:42.88+04
0d8cae13-e9f2-4814-82a0-3b5af32f3737	9b29875c-f00b-4c86-93eb-759fa3420a20	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.881+04	2010-09-19 03:09:42.881+04
e77b08a3-ce31-4edd-b5d1-86735caf6cfd	9b29875c-f00b-4c86-93eb-759fa3420a20	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.882+04	2010-09-19 03:09:42.882+04
3dc56b9c-727a-4185-828e-9978c34c8a51	9b29875c-f00b-4c86-93eb-759fa3420a20	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.883+04	2010-09-19 03:09:42.883+04
dbe59e6d-2a7d-4a74-89d2-7bd14793d2a4	9b29875c-f00b-4c86-93eb-759fa3420a20	д/ Техника	д/ Техника		2010-09-19 03:09:42.884+04	2010-09-19 03:09:42.884+04
26f396a7-13d6-4949-9c33-37524a6883c4	9b29875c-f00b-4c86-93eb-759fa3420a20	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.885+04	2010-09-19 03:09:42.885+04
bf6ca8f4-2391-4085-a6d4-727d3f548670	9b29875c-f00b-4c86-93eb-759fa3420a20	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.887+04	2010-09-19 03:09:42.887+04
8cb95792-2afc-4fcb-8e4b-e27f809b3c64	9b29875c-f00b-4c86-93eb-759fa3420a20	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.888+04	2010-09-19 03:09:42.888+04
47d251aa-3c8a-4588-93d3-436298e1c8db	9b29875c-f00b-4c86-93eb-759fa3420a20	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.889+04	2010-09-19 03:09:42.889+04
00000000-0000-0000-0000-000000000000	020374f8-8db8-42a0-bb20-e2b5d3b67d04	Not found	Not found		2010-09-19 03:09:42.895+04	2010-09-19 03:09:42.895+04
05d1b1bc-24e1-4039-8ee5-e282eef829ce	020374f8-8db8-42a0-bb20-e2b5d3b67d04	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.9+04	2010-09-19 03:09:42.9+04
4b7afea0-5a31-4b9d-bda4-72adf4b1da7b	020374f8-8db8-42a0-bb20-e2b5d3b67d04	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.902+04	2010-09-19 03:09:42.902+04
1bebd803-0578-4409-8567-bd5e54d193e6	020374f8-8db8-42a0-bb20-e2b5d3b67d04	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.903+04	2010-09-19 03:09:42.903+04
7d6557fa-ac96-4fc3-8a3a-4471e0aaccaa	020374f8-8db8-42a0-bb20-e2b5d3b67d04	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.904+04	2010-09-19 03:09:42.904+04
33bd8296-33c4-4bdd-8200-83ec4146eace	020374f8-8db8-42a0-bb20-e2b5d3b67d04	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.905+04	2010-09-19 03:09:42.905+04
4af0937b-e0ca-4dc7-9680-d1e82bb2f5c6	020374f8-8db8-42a0-bb20-e2b5d3b67d04	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.907+04	2010-09-19 03:09:42.907+04
3c725dc3-c122-49af-8b7b-652d610bd33b	020374f8-8db8-42a0-bb20-e2b5d3b67d04	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.908+04	2010-09-19 03:09:42.908+04
11f1c6ee-6109-4d38-a74e-aaebb306feef	020374f8-8db8-42a0-bb20-e2b5d3b67d04	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.909+04	2010-09-19 03:09:42.909+04
3f29b353-d2b5-4f11-9607-ab03bdcc0707	020374f8-8db8-42a0-bb20-e2b5d3b67d04	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.91+04	2010-09-19 03:09:42.91+04
a6cb93a3-103a-4366-aac8-f4aa9000ae53	020374f8-8db8-42a0-bb20-e2b5d3b67d04	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.911+04	2010-09-19 03:09:42.911+04
93122d0a-d74c-4847-8755-63dcd86bf0e4	020374f8-8db8-42a0-bb20-e2b5d3b67d04	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.913+04	2010-09-19 03:09:42.913+04
92c97808-2eaf-496c-ac75-ba811cbab417	020374f8-8db8-42a0-bb20-e2b5d3b67d04	д/ Техника	д/ Техника		2010-09-19 03:09:42.914+04	2010-09-19 03:09:42.914+04
eb7d5a9f-b06a-41d6-beaa-f9b6980b5408	020374f8-8db8-42a0-bb20-e2b5d3b67d04	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.915+04	2010-09-19 03:09:42.915+04
3a25e64e-2cde-44cc-9482-e7962ee055f5	020374f8-8db8-42a0-bb20-e2b5d3b67d04	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.916+04	2010-09-19 03:09:42.916+04
60cf283e-9f3e-4a24-8afc-d06a59a1ea91	020374f8-8db8-42a0-bb20-e2b5d3b67d04	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.917+04	2010-09-19 03:09:42.917+04
1783b041-3ce2-4970-802e-1227aaa935bc	020374f8-8db8-42a0-bb20-e2b5d3b67d04	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.919+04	2010-09-19 03:09:42.919+04
e2daac30-aeae-40c3-8893-7609a8fb3f0c	020374f8-8db8-42a0-bb20-e2b5d3b67d04	0/Главный редактор	0/Главный редактор		2010-09-19 03:09:42.92+04	2010-09-19 03:09:42.92+04
00000000-0000-0000-0000-000000000000	72a37221-8866-4172-b56c-793002d118f4	Not found	Not found		2010-09-19 03:09:42.926+04	2010-09-19 03:09:42.926+04
46471694-4453-4036-9297-e2e36ffa3475	72a37221-8866-4172-b56c-793002d118f4	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.931+04	2010-09-19 03:09:42.931+04
27d7c702-de32-4c8a-ad85-69d73b6d4580	72a37221-8866-4172-b56c-793002d118f4	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.932+04	2010-09-19 03:09:42.932+04
3b920d72-1748-4157-bf39-cfe21bc87a9d	72a37221-8866-4172-b56c-793002d118f4	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.934+04	2010-09-19 03:09:42.934+04
b5adf25f-19c3-4cd8-9495-c9a5b9671e49	72a37221-8866-4172-b56c-793002d118f4	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.935+04	2010-09-19 03:09:42.935+04
3df9c379-05bd-434c-a93f-a7715dd5c7f0	72a37221-8866-4172-b56c-793002d118f4	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.936+04	2010-09-19 03:09:42.936+04
ea0c4076-99d7-4140-a41c-ae90a10b9bf5	72a37221-8866-4172-b56c-793002d118f4	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.937+04	2010-09-19 03:09:42.937+04
1265f209-8fa1-49e6-9db6-5c5c9fdb7e5c	72a37221-8866-4172-b56c-793002d118f4	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.938+04	2010-09-19 03:09:42.938+04
2795ef55-330b-4e22-b23d-13b38ad97ed5	72a37221-8866-4172-b56c-793002d118f4	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.94+04	2010-09-19 03:09:42.94+04
a6526a54-4362-4646-9c08-da530294fe80	ee3ba207-a0ad-47f2-adf4-abf933619d15	Рынок	Рынок		2010-09-19 03:09:43.407+04	2010-09-19 03:09:43.407+04
0081bb56-5757-4d9c-a5a5-3b48e4bac798	72a37221-8866-4172-b56c-793002d118f4	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.941+04	2010-09-19 03:09:42.941+04
b95eb7f6-c7b4-4839-87b9-100143c66425	72a37221-8866-4172-b56c-793002d118f4	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.942+04	2010-09-19 03:09:42.942+04
a4c2eb35-72cc-4317-a5be-e68e42ae5364	72a37221-8866-4172-b56c-793002d118f4	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.943+04	2010-09-19 03:09:42.943+04
5f2b4096-d7ab-4706-8f97-e1b51a3cb731	72a37221-8866-4172-b56c-793002d118f4	д/ Техника	д/ Техника		2010-09-19 03:09:42.944+04	2010-09-19 03:09:42.944+04
4b446641-3956-4c2b-a86c-65416b45158f	72a37221-8866-4172-b56c-793002d118f4	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.945+04	2010-09-19 03:09:42.945+04
168daa11-d71c-4f55-b8ff-5be32bd9be33	72a37221-8866-4172-b56c-793002d118f4	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.947+04	2010-09-19 03:09:42.947+04
e4182d00-0208-441f-90f1-4ad8557870ad	72a37221-8866-4172-b56c-793002d118f4	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.948+04	2010-09-19 03:09:42.948+04
44fcb3ca-06fc-4cd6-be68-6e91b73574a2	72a37221-8866-4172-b56c-793002d118f4	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.949+04	2010-09-19 03:09:42.949+04
00000000-0000-0000-0000-000000000000	79678219-1369-4195-b6e7-9e2e6fd51957	Not found	Not found		2010-09-19 03:09:42.956+04	2010-09-19 03:09:42.956+04
fed4960b-7ca4-4b2a-9773-c00325b4d1ab	79678219-1369-4195-b6e7-9e2e6fd51957	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:42.96+04	2010-09-19 03:09:42.96+04
bb5efb85-4559-480f-b21a-0cfbebed6ca6	79678219-1369-4195-b6e7-9e2e6fd51957	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:42.961+04	2010-09-19 03:09:42.961+04
8052b59e-0774-4914-a0f0-d8660335af89	79678219-1369-4195-b6e7-9e2e6fd51957	0/ Содержание	0/ Содержание		2010-09-19 03:09:42.962+04	2010-09-19 03:09:42.962+04
920f6d61-ec5c-41dd-941e-902b8a0e8047	79678219-1369-4195-b6e7-9e2e6fd51957	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:42.964+04	2010-09-19 03:09:42.964+04
b2ceb5a8-5213-4cfc-a807-95eeb0aa962f	79678219-1369-4195-b6e7-9e2e6fd51957	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:42.965+04	2010-09-19 03:09:42.965+04
a5300765-268d-4212-9fb4-bb1a829f637d	79678219-1369-4195-b6e7-9e2e6fd51957	б/ Курьер	б/ Курьер		2010-09-19 03:09:42.966+04	2010-09-19 03:09:42.966+04
49e401cf-8a4c-46c5-81df-a224a7053a71	79678219-1369-4195-b6e7-9e2e6fd51957	к/ Спорт	к/ Спорт		2010-09-19 03:09:42.967+04	2010-09-19 03:09:42.967+04
0ac5969c-2f88-421f-92e0-2393a6313478	79678219-1369-4195-b6e7-9e2e6fd51957	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:42.968+04	2010-09-19 03:09:42.968+04
90214c7d-f393-4760-8eca-77837f49ee40	79678219-1369-4195-b6e7-9e2e6fd51957	з/ Экономика	з/ Экономика		2010-09-19 03:09:42.97+04	2010-09-19 03:09:42.97+04
f1a6fb21-89a7-4180-88ca-01325c5b7e7f	79678219-1369-4195-b6e7-9e2e6fd51957	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:42.971+04	2010-09-19 03:09:42.971+04
c7ae6371-81c0-48d3-b376-b079974f7e3d	79678219-1369-4195-b6e7-9e2e6fd51957	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:42.972+04	2010-09-19 03:09:42.972+04
af7b7212-e670-413d-b329-06c84cf1d9cb	79678219-1369-4195-b6e7-9e2e6fd51957	д/ Техника	д/ Техника		2010-09-19 03:09:42.973+04	2010-09-19 03:09:42.973+04
ed1db4cf-e0a1-4021-9373-bf5d581d465c	79678219-1369-4195-b6e7-9e2e6fd51957	н/ Без границ	н/ Без границ		2010-09-19 03:09:42.975+04	2010-09-19 03:09:42.975+04
e8dfb23a-ffce-4c2c-b833-b0b320c0e061	79678219-1369-4195-b6e7-9e2e6fd51957	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:42.976+04	2010-09-19 03:09:42.976+04
46df7fba-cc62-4226-9385-bff08f67fddc	79678219-1369-4195-b6e7-9e2e6fd51957	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:42.977+04	2010-09-19 03:09:42.977+04
22a4de26-1147-47f6-8cdc-915da224e86a	79678219-1369-4195-b6e7-9e2e6fd51957	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:42.978+04	2010-09-19 03:09:42.978+04
629c6472-6f7a-4089-9e1b-8332ed3a0470	79678219-1369-4195-b6e7-9e2e6fd51957	ц/ Рекламный блок	ц/ Рекламный блок		2010-09-19 03:09:42.979+04	2010-09-19 03:09:42.979+04
799f5540-d749-4f0f-b161-9dbaaa414113	79678219-1369-4195-b6e7-9e2e6fd51957	ч/ анонс	ч/ анонс		2010-09-19 03:09:42.981+04	2010-09-19 03:09:42.981+04
420f32ed-a4ac-4d19-846f-4b8c5e150792	79678219-1369-4195-b6e7-9e2e6fd51957	0/ Крупным планом	0/ Крупным планом		2010-09-19 03:09:42.982+04	2010-09-19 03:09:42.982+04
00000000-0000-0000-0000-000000000000	054bd40f-e181-4114-bf46-a346319da606	Not found	Not found		2010-09-19 03:09:42.988+04	2010-09-19 03:09:42.988+04
83caa7e7-15bb-4dd4-9545-e303b16c1ca7	054bd40f-e181-4114-bf46-a346319da606	Содержание	Содержание		2010-09-19 03:09:42.992+04	2010-09-19 03:09:42.992+04
79860746-c862-454f-868b-064cc5d05365	054bd40f-e181-4114-bf46-a346319da606	Без раздела	Без раздела		2010-09-19 03:09:42.994+04	2010-09-19 03:09:42.994+04
93d5d580-333b-4c17-927d-f27a087722d2	054bd40f-e181-4114-bf46-a346319da606	Экономика	Экономика		2010-09-19 03:09:42.995+04	2010-09-19 03:09:42.995+04
c4088516-f40a-4977-a0e9-fd8fc8e40c7e	054bd40f-e181-4114-bf46-a346319da606	Главная тема	Главная тема		2010-09-19 03:09:42.996+04	2010-09-19 03:09:42.996+04
e6c67929-c2d3-486d-a76b-e178322e69dd	054bd40f-e181-4114-bf46-a346319da606	Спецпроект	Спецпроект		2010-09-19 03:09:42.997+04	2010-09-19 03:09:42.997+04
d39d68f2-3153-4ca7-af70-de242f808f66	054bd40f-e181-4114-bf46-a346319da606	Автомобили	Автомобили		2010-09-19 03:09:42.999+04	2010-09-19 03:09:42.999+04
3241b246-fd6a-427f-9a93-46c43a4ff9e0	054bd40f-e181-4114-bf46-a346319da606	Выставка	Выставка		2010-09-19 03:09:43+04	2010-09-19 03:09:43+04
304ca247-01a3-4efb-8f7a-ae61a141265c	054bd40f-e181-4114-bf46-a346319da606	Спецтехника	Спецтехника		2010-09-19 03:09:43.001+04	2010-09-19 03:09:43.001+04
60b9eb23-3594-485e-9386-12bb71e95256	054bd40f-e181-4114-bf46-a346319da606	Автобаза	Автобаза		2010-09-19 03:09:43.002+04	2010-09-19 03:09:43.002+04
bb20b2b0-d3ed-4296-a696-c7ae2b0b8679	054bd40f-e181-4114-bf46-a346319da606	Реклама	Реклама		2010-09-19 03:09:43.003+04	2010-09-19 03:09:43.003+04
00000000-0000-0000-0000-000000000000	9b20caf1-5271-4f65-9184-f67515affdbe	Not found	Not found		2010-09-19 03:09:43.01+04	2010-09-19 03:09:43.01+04
1eb2b53a-293b-4d61-9de4-ab25024d372c	9b20caf1-5271-4f65-9184-f67515affdbe	Раздел не указан	Раздел не указан		2010-09-19 03:09:43.014+04	2010-09-19 03:09:43.014+04
cadb4c47-dde3-4c69-b270-edc39e33ecf5	9b20caf1-5271-4f65-9184-f67515affdbe	Новости	Новости		2010-09-19 03:09:43.015+04	2010-09-19 03:09:43.015+04
9d716e88-5efb-4305-a121-3d0a89faf234	9b20caf1-5271-4f65-9184-f67515affdbe	История	История		2010-09-19 03:09:43.017+04	2010-09-19 03:09:43.017+04
d23ed50c-d3d6-45fd-97d3-6ee4ff21fb5e	9b20caf1-5271-4f65-9184-f67515affdbe	Спорт	Спорт		2010-09-19 03:09:43.018+04	2010-09-19 03:09:43.018+04
8bb3a3a6-7ac3-4dad-a6c2-e4ad254c388a	9b20caf1-5271-4f65-9184-f67515affdbe	Ремзона	Ремзона		2010-09-19 03:09:43.019+04	2010-09-19 03:09:43.019+04
bb151030-a996-4fc9-831a-cfe38420da46	9b20caf1-5271-4f65-9184-f67515affdbe	Мотоклуб	Мотоклуб		2010-09-19 03:09:43.02+04	2010-09-19 03:09:43.02+04
c0776aa2-02b8-45f9-b314-5d05e9404d43	9b20caf1-5271-4f65-9184-f67515affdbe	Рынок	Рынок		2010-09-19 03:09:43.021+04	2010-09-19 03:09:43.021+04
6f3ced67-2dd6-4890-ad30-e7f94dbf75ac	9b20caf1-5271-4f65-9184-f67515affdbe	Реклама	Реклама		2010-09-19 03:09:43.023+04	2010-09-19 03:09:43.023+04
09817660-a6fd-4cd6-8b24-1154e478ec0f	9b20caf1-5271-4f65-9184-f67515affdbe	Обложка	Обложка		2010-09-19 03:09:43.024+04	2010-09-19 03:09:43.024+04
af1b8893-1ed3-4bfc-bb93-929736d95163	9b20caf1-5271-4f65-9184-f67515affdbe	Анонс	Анонс		2010-09-19 03:09:43.025+04	2010-09-19 03:09:43.025+04
e50783d3-d534-4875-a87e-5defa54f37b9	9b20caf1-5271-4f65-9184-f67515affdbe	Тесты	Тесты		2010-09-19 03:09:43.028+04	2010-09-19 03:09:43.028+04
d776f99f-539d-4eaa-a65d-6371fb04bb74	9b20caf1-5271-4f65-9184-f67515affdbe	Техника	Техника		2010-09-19 03:09:43.03+04	2010-09-19 03:09:43.03+04
c0f993b8-5d6f-4d99-bd3a-7b49cc54c741	9b20caf1-5271-4f65-9184-f67515affdbe	Содержание	Содержание		2010-09-19 03:09:43.031+04	2010-09-19 03:09:43.031+04
00000000-0000-0000-0000-000000000000	ac18cceb-3153-49b2-a49c-298787543411	Not found	Not found		2010-09-19 03:09:43.038+04	2010-09-19 03:09:43.038+04
91cd4517-8358-47e9-a014-eb16abc110fb	ac18cceb-3153-49b2-a49c-298787543411	?????	?????		2010-09-19 03:09:43.043+04	2010-09-19 03:09:43.043+04
04b41e7f-76da-46e6-a505-3c4492af1953	ac18cceb-3153-49b2-a49c-298787543411	а ОБЛОЖКА	а ОБЛОЖКА		2010-09-19 03:09:43.044+04	2010-09-19 03:09:43.044+04
21d2a564-d3d1-47f5-b393-5b370e80d383	ac18cceb-3153-49b2-a49c-298787543411	б Содержание	б Содержание		2010-09-19 03:09:43.046+04	2010-09-19 03:09:43.046+04
951422c0-43dc-4300-b8cd-111434d9f345	ac18cceb-3153-49b2-a49c-298787543411	в НОВОСТИ	в НОВОСТИ		2010-09-19 03:09:43.047+04	2010-09-19 03:09:43.047+04
28a750a3-b9e6-4fc1-8ab5-dd997d2aaa7f	ac18cceb-3153-49b2-a49c-298787543411	г Автомобили	г Автомобили		2010-09-19 03:09:43.048+04	2010-09-19 03:09:43.048+04
5cbe4a25-d534-484a-8207-7a8077c91f68	ac18cceb-3153-49b2-a49c-298787543411	д Курьер	д Курьер		2010-09-19 03:09:43.049+04	2010-09-19 03:09:43.049+04
3194276d-af0a-49c1-a854-bb559a5905ef	ac18cceb-3153-49b2-a49c-298787543411	е Авторынок	е Авторынок		2010-09-19 03:09:43.05+04	2010-09-19 03:09:43.05+04
c4f6e1b0-dcad-4efd-8d90-52088b5ec1d9	ac18cceb-3153-49b2-a49c-298787543411	ж Компоненты	ж Компоненты		2010-09-19 03:09:43.051+04	2010-09-19 03:09:43.051+04
718ab83f-9f68-448c-9cf0-e260f26729dd	ac18cceb-3153-49b2-a49c-298787543411	и Техника	и Техника		2010-09-19 03:09:43.053+04	2010-09-19 03:09:43.053+04
d6bdff3e-c03c-47db-b956-7ac6c614c7e3	ac18cceb-3153-49b2-a49c-298787543411	к Ремонт и сервис	к Ремонт и сервис		2010-09-19 03:09:43.054+04	2010-09-19 03:09:43.054+04
bb1f14aa-cd7f-4a13-87b3-784ed75f6777	ac18cceb-3153-49b2-a49c-298787543411	л Безопасность	л Безопасность		2010-09-19 03:09:43.055+04	2010-09-19 03:09:43.055+04
55513856-f1c0-45b4-87fe-d36902888f91	ac18cceb-3153-49b2-a49c-298787543411	м Экономика	м Экономика		2010-09-19 03:09:43.056+04	2010-09-19 03:09:43.056+04
941fc721-6ebb-4011-9d6e-f33bb125a6e0	ac18cceb-3153-49b2-a49c-298787543411	н Грузовики	н Грузовики		2010-09-19 03:09:43.058+04	2010-09-19 03:09:43.058+04
f148fc25-9044-4824-b03a-77b4e9a8697d	ac18cceb-3153-49b2-a49c-298787543411	о Спорт	о Спорт		2010-09-19 03:09:43.059+04	2010-09-19 03:09:43.059+04
b7ef184e-647a-403e-853c-9ea298d5c171	ac18cceb-3153-49b2-a49c-298787543411	п Тюнинг	п Тюнинг		2010-09-19 03:09:43.06+04	2010-09-19 03:09:43.06+04
e774c7cd-0b2b-4fe9-baca-fe3002db03d2	ac18cceb-3153-49b2-a49c-298787543411	р Без границ	р Без границ		2010-09-19 03:09:43.061+04	2010-09-19 03:09:43.061+04
929b2e7a-80cb-436a-9a5b-d58aa9089dac	ac18cceb-3153-49b2-a49c-298787543411	с Цены ЗР	с Цены ЗР		2010-09-19 03:09:43.062+04	2010-09-19 03:09:43.062+04
10db917a-87aa-4c49-aa17-1e547083aa6e	ac18cceb-3153-49b2-a49c-298787543411	0 Реклама	0 Реклама		2010-09-19 03:09:43.064+04	2010-09-19 03:09:43.064+04
56e531da-20ca-4fbc-8130-4263ef3932c7	ac18cceb-3153-49b2-a49c-298787543411	т ГРАН-ПРИ	т ГРАН-ПРИ		2010-09-19 03:09:43.065+04	2010-09-19 03:09:43.065+04
00000000-0000-0000-0000-000000000000	8023615e-eaed-44fc-bcbb-ffd59378c811	Not found	Not found		2010-09-19 03:09:43.143+04	2010-09-19 03:09:43.143+04
9e8de73e-3503-4bb2-b75a-3d6d70094474	8023615e-eaed-44fc-bcbb-ffd59378c811	Содержание	Содержание		2010-09-19 03:09:43.148+04	2010-09-19 03:09:43.148+04
f01f473a-600b-42fb-9809-e27a0558b90a	8023615e-eaed-44fc-bcbb-ffd59378c811	Без раздела	Без раздела		2010-09-19 03:09:43.149+04	2010-09-19 03:09:43.149+04
c5c99b31-2519-45f2-b8f7-6a4cc1cf6d39	8023615e-eaed-44fc-bcbb-ffd59378c811	Экономика	Экономика		2010-09-19 03:09:43.15+04	2010-09-19 03:09:43.15+04
81edb15b-ac80-4128-9b78-c83c2a28fe16	8023615e-eaed-44fc-bcbb-ffd59378c811	Главная тема	Главная тема		2010-09-19 03:09:43.151+04	2010-09-19 03:09:43.151+04
6b50e801-7fe3-49b0-9d9d-47153ed2d445	8023615e-eaed-44fc-bcbb-ffd59378c811	Спецпроект	Спецпроект		2010-09-19 03:09:43.153+04	2010-09-19 03:09:43.153+04
c7836792-cd1f-4f64-828b-9e3980bc2ecf	8023615e-eaed-44fc-bcbb-ffd59378c811	Автомобили	Автомобили		2010-09-19 03:09:43.154+04	2010-09-19 03:09:43.154+04
d4042761-ec7a-46ca-a768-d75ff24bbe4a	8023615e-eaed-44fc-bcbb-ffd59378c811	Выставка	Выставка		2010-09-19 03:09:43.155+04	2010-09-19 03:09:43.155+04
321948d8-6098-4963-b115-50f72b549c2a	8023615e-eaed-44fc-bcbb-ffd59378c811	Спецтехника	Спецтехника		2010-09-19 03:09:43.157+04	2010-09-19 03:09:43.157+04
63ca2023-47ee-4c8a-b858-ecad344aa38a	8023615e-eaed-44fc-bcbb-ffd59378c811	Автобаза	Автобаза		2010-09-19 03:09:43.158+04	2010-09-19 03:09:43.158+04
d4364bc6-c4b8-4f40-a78a-f18c3c7b63b1	8023615e-eaed-44fc-bcbb-ffd59378c811	Реклама	Реклама		2010-09-19 03:09:43.159+04	2010-09-19 03:09:43.159+04
00000000-0000-0000-0000-000000000000	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	Not found	Not found		2010-09-19 03:09:43.165+04	2010-09-19 03:09:43.165+04
d29bbd51-6d18-4c5f-a5a3-7858c3c29ed9	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:43.17+04	2010-09-19 03:09:43.17+04
81f2a744-f5e9-4108-ba05-03efc8417863	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:43.171+04	2010-09-19 03:09:43.171+04
8ea3bb25-dac9-4ca7-ada5-230425bd1e05	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:43.172+04	2010-09-19 03:09:43.172+04
d2a3dda7-4e91-45ee-bbc7-875122b934b0	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	б/ Курьер	б/ Курьер		2010-09-19 03:09:43.173+04	2010-09-19 03:09:43.173+04
709e2530-70c2-4a04-8561-a4198c4058bd	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	к/ Спорт	к/ Спорт		2010-09-19 03:09:43.175+04	2010-09-19 03:09:43.175+04
d48a15c8-db63-43bc-a509-90a8585af404	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:43.176+04	2010-09-19 03:09:43.176+04
c66b49dc-58d4-48bf-8e44-2cced8201e99	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	з/ Экономика	з/ Экономика		2010-09-19 03:09:43.177+04	2010-09-19 03:09:43.177+04
a16e29a2-1616-4bcc-8aba-8aab4f0d5a4e	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:43.178+04	2010-09-19 03:09:43.178+04
8cb56e19-c083-4d17-821f-dbf38baae6b3	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:43.179+04	2010-09-19 03:09:43.179+04
21229e92-e2e2-4607-8a7e-12af5b1d47b4	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	д/ Техника	д/ Техника		2010-09-19 03:09:43.181+04	2010-09-19 03:09:43.181+04
35a23881-cc65-4611-ae60-e9ec6fab7a9b	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	н/ Без границ	н/ Без границ		2010-09-19 03:09:43.182+04	2010-09-19 03:09:43.182+04
251620eb-d8fa-48f8-ad31-d712583cce42	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:43.183+04	2010-09-19 03:09:43.183+04
15266ba5-e247-4688-acd2-68ce1cada727	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:43.185+04	2010-09-19 03:09:43.185+04
d9d237e3-45d6-4965-a770-3d14286eac01	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:43.186+04	2010-09-19 03:09:43.186+04
7c70b9a5-bdf9-4896-838f-dd89f2549eac	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	3/ НОВОСТИ	3/ НОВОСТИ		2010-09-19 03:09:43.187+04	2010-09-19 03:09:43.187+04
fbaf356f-8630-4695-9ab5-5c36c1f1f816	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	о/ Гран при ЗР	о/ Гран при ЗР		2010-09-19 03:09:43.188+04	2010-09-19 03:09:43.188+04
f3fb90aa-f3b5-4a39-b1e9-413e22aa7eb1	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	1/ Крупным планом	1/ Крупным планом		2010-09-19 03:09:43.19+04	2010-09-19 03:09:43.19+04
6a8926ee-8c79-4c66-a7ab-2dcf149af49f	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	2/ Содержание	2/ Содержание		2010-09-19 03:09:43.191+04	2010-09-19 03:09:43.191+04
12730627-81f3-4efa-8faa-3374545c2669	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	ц/ Рекламный блок	ц/ Рекламный блок		2010-09-19 03:09:43.192+04	2010-09-19 03:09:43.192+04
00000000-0000-0000-0000-000000000000	e268fa39-f35e-4a81-940f-f20033d64836	Not found	Not found		2010-09-19 03:09:43.199+04	2010-09-19 03:09:43.199+04
72701db0-0556-42ff-ab92-dee8172f9f12	e268fa39-f35e-4a81-940f-f20033d64836	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:43.203+04	2010-09-19 03:09:43.203+04
8669871c-703a-4e96-982b-c61ec8e10b24	e268fa39-f35e-4a81-940f-f20033d64836	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:43.204+04	2010-09-19 03:09:43.204+04
42b3abf4-c7ab-4b81-9a67-dd6f1a9a7099	e268fa39-f35e-4a81-940f-f20033d64836	0/ Содержание	0/ Содержание		2010-09-19 03:09:43.205+04	2010-09-19 03:09:43.205+04
d727df65-6512-479f-8422-102e74701d5a	e268fa39-f35e-4a81-940f-f20033d64836	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:43.207+04	2010-09-19 03:09:43.207+04
bf115b1a-3bef-40f3-9ff6-8b1b5c496464	e268fa39-f35e-4a81-940f-f20033d64836	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:43.208+04	2010-09-19 03:09:43.208+04
ef6eac3e-d64c-460d-9ae3-6030466df923	e268fa39-f35e-4a81-940f-f20033d64836	б/ Курьер	б/ Курьер		2010-09-19 03:09:43.209+04	2010-09-19 03:09:43.209+04
209407f4-166c-4d3e-ac6d-71050dcf4510	e268fa39-f35e-4a81-940f-f20033d64836	к/ Спорт	к/ Спорт		2010-09-19 03:09:43.21+04	2010-09-19 03:09:43.21+04
5305cdce-3a48-4db5-84f2-ca62d3b99fcb	e268fa39-f35e-4a81-940f-f20033d64836	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:43.212+04	2010-09-19 03:09:43.212+04
7f0ce698-76e4-45aa-afb3-10ea436a0904	e268fa39-f35e-4a81-940f-f20033d64836	з/ Экономика	з/ Экономика		2010-09-19 03:09:43.213+04	2010-09-19 03:09:43.213+04
c78d2a78-91c9-45fa-a41b-0f90d038ae0e	e268fa39-f35e-4a81-940f-f20033d64836	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:43.214+04	2010-09-19 03:09:43.214+04
200873fc-6e0c-453e-ba93-fd7ddf969549	e268fa39-f35e-4a81-940f-f20033d64836	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:43.215+04	2010-09-19 03:09:43.215+04
b0d359ad-dd3c-414e-a17f-108a6c764b61	e268fa39-f35e-4a81-940f-f20033d64836	д/ Техника	д/ Техника		2010-09-19 03:09:43.216+04	2010-09-19 03:09:43.216+04
990c27e2-c3f8-43fb-93a4-d7ba57b4cb97	e268fa39-f35e-4a81-940f-f20033d64836	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:43.218+04	2010-09-19 03:09:43.218+04
17e3f8d6-6cff-4891-9dfb-28b4a8ed77a7	e268fa39-f35e-4a81-940f-f20033d64836	н/ Без границ	н/ Без границ		2010-09-19 03:09:43.219+04	2010-09-19 03:09:43.219+04
062cde3e-3c34-4045-9fdc-4aa78b65ec81	e268fa39-f35e-4a81-940f-f20033d64836	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:43.22+04	2010-09-19 03:09:43.22+04
a8746897-b555-42c7-bb3e-d0179395ac23	e268fa39-f35e-4a81-940f-f20033d64836	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:43.221+04	2010-09-19 03:09:43.221+04
bd4e35ba-d566-4327-8308-937705583f2c	e268fa39-f35e-4a81-940f-f20033d64836	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:43.223+04	2010-09-19 03:09:43.223+04
00000000-0000-0000-0000-000000000000	e9a80f9b-45b4-4681-9319-ecdd2812efd4	Not found	Not found		2010-09-19 03:09:43.229+04	2010-09-19 03:09:43.229+04
dfe09883-1116-481b-b707-14ec2e3a423e	e9a80f9b-45b4-4681-9319-ecdd2812efd4	Без рубрики	Без рубрики		2010-09-19 03:09:43.234+04	2010-09-19 03:09:43.234+04
26bc0b46-f9a8-4534-bcea-22f4a2d149a3	e9a80f9b-45b4-4681-9319-ecdd2812efd4	Реклама	Реклама		2010-09-19 03:09:43.235+04	2010-09-19 03:09:43.235+04
37c57ce7-34e9-43fc-ba0d-d978fb4ddb9a	e9a80f9b-45b4-4681-9319-ecdd2812efd4	Новости дилеров	Новости дилеров		2010-09-19 03:09:43.236+04	2010-09-19 03:09:43.236+04
effa6cbd-8bfe-4b73-be35-bc5614df19a5	e9a80f9b-45b4-4681-9319-ecdd2812efd4	Трафик	Трафик		2010-09-19 03:09:43.238+04	2010-09-19 03:09:43.238+04
83ff2716-c558-4991-b55f-1d61cde6014a	e9a80f9b-45b4-4681-9319-ecdd2812efd4	Права	Права		2010-09-19 03:09:43.239+04	2010-09-19 03:09:43.239+04
32e5aa7e-5066-4dee-9a56-c49172fcd763	e9a80f9b-45b4-4681-9319-ecdd2812efd4	Актуально	Актуально		2010-09-19 03:09:43.24+04	2010-09-19 03:09:43.24+04
c8205d2f-fab5-4412-8f2b-33670d0fe7b6	e9a80f9b-45b4-4681-9319-ecdd2812efd4	Обложка	Обложка		2010-09-19 03:09:43.241+04	2010-09-19 03:09:43.241+04
b76d058e-e9fb-442e-b973-77da5bea06f1	e9a80f9b-45b4-4681-9319-ecdd2812efd4	Городские новости	Городские новости		2010-09-19 03:09:43.243+04	2010-09-19 03:09:43.243+04
00000000-0000-0000-0000-000000000000	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Not found	Not found		2010-09-19 03:09:43.248+04	2010-09-19 03:09:43.248+04
c70ea7af-7c5c-49ae-82ba-0f9eb9e0be2a	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Без раздела	Без раздела		2010-09-19 03:09:43.253+04	2010-09-19 03:09:43.253+04
da6f629a-5008-4f2a-80f5-263efc3f11f6	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Экономика	Экономика		2010-09-19 03:09:43.254+04	2010-09-19 03:09:43.254+04
e113bf61-4cdc-43e7-9344-48950f574e7f	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Содержание	Содержание		2010-09-19 03:09:43.269+04	2010-09-19 03:09:43.269+04
c80dcc10-ef28-4e73-a71b-f697b2006bdd	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Главная тема	Главная тема		2010-09-19 03:09:43.27+04	2010-09-19 03:09:43.27+04
1e15eb25-849f-44d4-ad66-7da87a4fead4	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Автобаза	Автобаза		2010-09-19 03:09:43.272+04	2010-09-19 03:09:43.272+04
78176a85-778b-4b21-9708-2799709e140d	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Спецпроект	Спецпроект		2010-09-19 03:09:43.273+04	2010-09-19 03:09:43.273+04
61309fd2-4e18-4201-b358-14ccdd4c8fd1	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Выставка	Выставка		2010-09-19 03:09:43.274+04	2010-09-19 03:09:43.274+04
48677d83-218c-4c0a-82b7-a401fc50fba0	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Автомобили	Автомобили		2010-09-19 03:09:43.275+04	2010-09-19 03:09:43.275+04
ecb05678-7c0f-41d4-8647-e97e1f33ce7a	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Спецтехника	Спецтехника		2010-09-19 03:09:43.276+04	2010-09-19 03:09:43.276+04
c258d3ce-933c-4474-884d-410a54a841f3	c536d8c3-33d6-44c5-b2e5-bcea671a070e	Реклама	Реклама		2010-09-19 03:09:43.278+04	2010-09-19 03:09:43.278+04
00000000-0000-0000-0000-000000000000	88f25a94-6e90-42ce-855c-526aa92b9a5d	Not found	Not found		2010-09-19 03:09:43.284+04	2010-09-19 03:09:43.284+04
5ab63cbd-f19b-4835-83a2-b5ee3f971adc	88f25a94-6e90-42ce-855c-526aa92b9a5d	Раздел не указан	Раздел не указан		2010-09-19 03:09:43.289+04	2010-09-19 03:09:43.289+04
65b2ee96-4a82-4a1a-9531-f0343d8139ca	88f25a94-6e90-42ce-855c-526aa92b9a5d	Тесты	Тесты		2010-09-19 03:09:43.29+04	2010-09-19 03:09:43.29+04
9bd19014-acbd-4264-ac85-28aacc5a9297	88f25a94-6e90-42ce-855c-526aa92b9a5d	Новости	Новости		2010-09-19 03:09:43.291+04	2010-09-19 03:09:43.291+04
df3288e8-bc9b-4ae7-a11e-fd8a1962e385	88f25a94-6e90-42ce-855c-526aa92b9a5d	Анонс	Анонс		2010-09-19 03:09:43.292+04	2010-09-19 03:09:43.292+04
ca8cd78f-b8e8-4485-9eb5-7e6233656af8	88f25a94-6e90-42ce-855c-526aa92b9a5d	История	История		2010-09-19 03:09:43.293+04	2010-09-19 03:09:43.293+04
a2614ae3-ef49-40f5-8af6-1cacdcb5515c	88f25a94-6e90-42ce-855c-526aa92b9a5d	Спорт	Спорт		2010-09-19 03:09:43.294+04	2010-09-19 03:09:43.294+04
f5eab52f-a5a5-4d20-8a61-951c325efff1	88f25a94-6e90-42ce-855c-526aa92b9a5d	Ремзона	Ремзона		2010-09-19 03:09:43.296+04	2010-09-19 03:09:43.296+04
f45a8525-03bc-4b77-9d7f-506c089b081e	88f25a94-6e90-42ce-855c-526aa92b9a5d	Мотоклуб	Мотоклуб		2010-09-19 03:09:43.297+04	2010-09-19 03:09:43.297+04
90a496de-0686-4d02-b18e-7bdf36865694	88f25a94-6e90-42ce-855c-526aa92b9a5d	Рынок	Рынок		2010-09-19 03:09:43.298+04	2010-09-19 03:09:43.298+04
11ef2b21-57ce-444d-87d1-c8e79bd096a8	88f25a94-6e90-42ce-855c-526aa92b9a5d	Реклама	Реклама		2010-09-19 03:09:43.299+04	2010-09-19 03:09:43.299+04
f5e7ca96-3cb7-47f4-afe0-b938a8531181	88f25a94-6e90-42ce-855c-526aa92b9a5d	Обложка	Обложка		2010-09-19 03:09:43.3+04	2010-09-19 03:09:43.3+04
912eb3f6-8984-4e02-8e16-9c0085468519	88f25a94-6e90-42ce-855c-526aa92b9a5d	Техника	Техника		2010-09-19 03:09:43.301+04	2010-09-19 03:09:43.301+04
14dbbbdc-076d-4c23-ba56-42865effd119	88f25a94-6e90-42ce-855c-526aa92b9a5d	Содержание	Содержание		2010-09-19 03:09:43.303+04	2010-09-19 03:09:43.303+04
00000000-0000-0000-0000-000000000000	08067592-b9eb-440b-8b98-e2491043ed39	Not found	Not found		2010-09-19 03:09:43.309+04	2010-09-19 03:09:43.309+04
265cff05-b0a1-4647-b69e-4ad62262280f	08067592-b9eb-440b-8b98-e2491043ed39	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:43.314+04	2010-09-19 03:09:43.314+04
65c0c711-dd27-4f92-b9c3-1b49a501e1fe	08067592-b9eb-440b-8b98-e2491043ed39	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:43.315+04	2010-09-19 03:09:43.315+04
79dcb638-8b03-490b-9b68-5d69a6f1b5b1	08067592-b9eb-440b-8b98-e2491043ed39	0/ Содержание	0/ Содержание		2010-09-19 03:09:43.316+04	2010-09-19 03:09:43.316+04
df1cb320-c5a9-456b-872d-1b8360304405	08067592-b9eb-440b-8b98-e2491043ed39	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:43.318+04	2010-09-19 03:09:43.318+04
84d79fe2-e664-4460-a1bd-b6a40357f672	08067592-b9eb-440b-8b98-e2491043ed39	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:43.319+04	2010-09-19 03:09:43.319+04
d5ca9f19-a3ab-450d-876b-5fedabec829a	08067592-b9eb-440b-8b98-e2491043ed39	б/ Курьер	б/ Курьер		2010-09-19 03:09:43.32+04	2010-09-19 03:09:43.32+04
126d37d2-e6e9-40ee-886b-703c0e1eefcc	08067592-b9eb-440b-8b98-e2491043ed39	к/ Спорт	к/ Спорт		2010-09-19 03:09:43.322+04	2010-09-19 03:09:43.322+04
59068892-0f5c-41fd-80a9-bf2f990944d3	08067592-b9eb-440b-8b98-e2491043ed39	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:43.323+04	2010-09-19 03:09:43.323+04
dbd6e54d-173c-4f90-a073-604394645827	08067592-b9eb-440b-8b98-e2491043ed39	з/ Экономика	з/ Экономика		2010-09-19 03:09:43.324+04	2010-09-19 03:09:43.324+04
cba778ed-cf18-45b2-b3ca-b31b0c5cf60f	08067592-b9eb-440b-8b98-e2491043ed39	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:43.325+04	2010-09-19 03:09:43.325+04
8baad76a-0d9e-4006-a6a5-eabe6db30011	08067592-b9eb-440b-8b98-e2491043ed39	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:43.327+04	2010-09-19 03:09:43.327+04
69e37c8d-b329-462e-8d31-52cc1dc00a0c	08067592-b9eb-440b-8b98-e2491043ed39	д/ Техника	д/ Техника		2010-09-19 03:09:43.328+04	2010-09-19 03:09:43.328+04
a71126e7-a416-4b29-9ed8-0a3ea349b90b	08067592-b9eb-440b-8b98-e2491043ed39	н/ Без границ	н/ Без границ		2010-09-19 03:09:43.329+04	2010-09-19 03:09:43.329+04
75935af0-8b0f-49c5-9d85-3283f9601f9f	08067592-b9eb-440b-8b98-e2491043ed39	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:43.331+04	2010-09-19 03:09:43.331+04
99949413-3d4c-485a-9288-e19eec59817c	08067592-b9eb-440b-8b98-e2491043ed39	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:43.332+04	2010-09-19 03:09:43.332+04
7d166781-de04-4730-bf1f-ff79497b4345	08067592-b9eb-440b-8b98-e2491043ed39	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:43.333+04	2010-09-19 03:09:43.333+04
00000000-0000-0000-0000-000000000000	5913ff51-4ee4-4941-96ac-565236937c2d	Not found	Not found		2010-09-19 03:09:43.343+04	2010-09-19 03:09:43.343+04
72a3e03f-9ddb-4b5b-94cf-5b18eda498e7	5913ff51-4ee4-4941-96ac-565236937c2d	Содержание	Содержание		2010-09-19 03:09:43.348+04	2010-09-19 03:09:43.348+04
a52e80e5-8e4a-48be-afac-048da91e1e8c	5913ff51-4ee4-4941-96ac-565236937c2d	Без раздела	Без раздела		2010-09-19 03:09:43.349+04	2010-09-19 03:09:43.349+04
16a99a06-e857-41a9-bcba-bd85217ae502	5913ff51-4ee4-4941-96ac-565236937c2d	Экономика	Экономика		2010-09-19 03:09:43.351+04	2010-09-19 03:09:43.351+04
6973dd45-ea6d-4419-8c7b-d79ac7ca846e	5913ff51-4ee4-4941-96ac-565236937c2d	Главная тема	Главная тема		2010-09-19 03:09:43.352+04	2010-09-19 03:09:43.352+04
ada6e796-251a-4e66-bf81-371928a61706	5913ff51-4ee4-4941-96ac-565236937c2d	Спецпроект	Спецпроект		2010-09-19 03:09:43.353+04	2010-09-19 03:09:43.353+04
885c6ee4-a785-4618-b208-285b8459d86e	5913ff51-4ee4-4941-96ac-565236937c2d	Автомобили	Автомобили		2010-09-19 03:09:43.354+04	2010-09-19 03:09:43.354+04
245c7f6d-0cb7-4154-af57-afa03eaea51a	5913ff51-4ee4-4941-96ac-565236937c2d	Выставка	Выставка		2010-09-19 03:09:43.356+04	2010-09-19 03:09:43.356+04
e44bfb8b-41e1-479c-a47a-9fe862a52a84	5913ff51-4ee4-4941-96ac-565236937c2d	Спецтехника	Спецтехника		2010-09-19 03:09:43.357+04	2010-09-19 03:09:43.357+04
7034bc1e-6a85-458b-91b0-e261ea3d758c	5913ff51-4ee4-4941-96ac-565236937c2d	Автобаза	Автобаза		2010-09-19 03:09:43.358+04	2010-09-19 03:09:43.358+04
28ecfac6-5fdb-47c7-b26f-f68d24ff463c	5913ff51-4ee4-4941-96ac-565236937c2d	Реклама	Реклама		2010-09-19 03:09:43.359+04	2010-09-19 03:09:43.359+04
00000000-0000-0000-0000-000000000000	3b3b4951-c897-4626-9109-009ba3e9f9fd	Not found	Not found		2010-09-19 03:09:43.369+04	2010-09-19 03:09:43.369+04
22a580df-90ed-436c-8d14-6de1aecb5494	3b3b4951-c897-4626-9109-009ba3e9f9fd	Раздел не указан	Раздел не указан		2010-09-19 03:09:43.373+04	2010-09-19 03:09:43.373+04
e1f882c8-46ec-4182-98ca-c6fc70b7bcff	3b3b4951-c897-4626-9109-009ba3e9f9fd	Новости	Новости		2010-09-19 03:09:43.375+04	2010-09-19 03:09:43.375+04
d562e4ac-5ef7-4ebc-8b43-37aad12de671	3b3b4951-c897-4626-9109-009ba3e9f9fd	История	История		2010-09-19 03:09:43.376+04	2010-09-19 03:09:43.376+04
1c85f675-9dc2-4fdf-85bf-e9d40cef67f7	3b3b4951-c897-4626-9109-009ba3e9f9fd	Спорт	Спорт		2010-09-19 03:09:43.377+04	2010-09-19 03:09:43.377+04
bc15ae7a-8ba3-48e5-9564-a7b1c5994cc7	3b3b4951-c897-4626-9109-009ba3e9f9fd	Ремзона	Ремзона		2010-09-19 03:09:43.378+04	2010-09-19 03:09:43.378+04
b9cd1c30-37de-42c7-ba1d-b553e2e217da	3b3b4951-c897-4626-9109-009ba3e9f9fd	Мотоклуб	Мотоклуб		2010-09-19 03:09:43.38+04	2010-09-19 03:09:43.38+04
9fbe1023-f8b3-42ed-9254-50d54b7bd361	3b3b4951-c897-4626-9109-009ba3e9f9fd	Рынок	Рынок		2010-09-19 03:09:43.381+04	2010-09-19 03:09:43.381+04
7b532a6a-e207-49c2-a4c5-f2f5a05e222d	3b3b4951-c897-4626-9109-009ba3e9f9fd	Реклама	Реклама		2010-09-19 03:09:43.382+04	2010-09-19 03:09:43.382+04
337f428f-c9d7-4dab-b9e8-ff7ae90910b2	3b3b4951-c897-4626-9109-009ba3e9f9fd	Обложка	Обложка		2010-09-19 03:09:43.383+04	2010-09-19 03:09:43.383+04
9dbc791b-bd6b-46bc-8446-7221ce32e1f8	3b3b4951-c897-4626-9109-009ba3e9f9fd	Анонс	Анонс		2010-09-19 03:09:43.384+04	2010-09-19 03:09:43.384+04
90b3355c-ec39-4549-ab3f-d1e37fe1468d	3b3b4951-c897-4626-9109-009ba3e9f9fd	Тесты	Тесты		2010-09-19 03:09:43.386+04	2010-09-19 03:09:43.386+04
c916fe08-8150-466f-8af2-b1e39beda6eb	3b3b4951-c897-4626-9109-009ba3e9f9fd	Техника	Техника		2010-09-19 03:09:43.387+04	2010-09-19 03:09:43.387+04
efa4c22d-27ca-4bbc-9b27-c88a7c3eee1f	3b3b4951-c897-4626-9109-009ba3e9f9fd	Содержание	Содержание		2010-09-19 03:09:43.388+04	2010-09-19 03:09:43.388+04
00000000-0000-0000-0000-000000000000	ee3ba207-a0ad-47f2-adf4-abf933619d15	Not found	Not found		2010-09-19 03:09:43.394+04	2010-09-19 03:09:43.394+04
e9410883-65b0-4314-82a1-764f076b6868	ee3ba207-a0ad-47f2-adf4-abf933619d15	Раздел не указан	Раздел не указан		2010-09-19 03:09:43.399+04	2010-09-19 03:09:43.399+04
d6140e40-893a-4d73-b481-449765ebe09c	ee3ba207-a0ad-47f2-adf4-abf933619d15	Новости	Новости		2010-09-19 03:09:43.4+04	2010-09-19 03:09:43.4+04
3b81dbfc-622b-4114-afd8-df5989a7d214	ee3ba207-a0ad-47f2-adf4-abf933619d15	История	История		2010-09-19 03:09:43.402+04	2010-09-19 03:09:43.402+04
a33de2ae-b0b6-4cd7-8ce2-97eb158c78ce	ee3ba207-a0ad-47f2-adf4-abf933619d15	Спорт	Спорт		2010-09-19 03:09:43.403+04	2010-09-19 03:09:43.403+04
69c52600-f247-4500-abb9-3a8e270874b4	ee3ba207-a0ad-47f2-adf4-abf933619d15	Ремзона	Ремзона		2010-09-19 03:09:43.404+04	2010-09-19 03:09:43.404+04
f3be8d5e-7ed8-4992-bd3e-3f40bf635391	ee3ba207-a0ad-47f2-adf4-abf933619d15	Мотоклуб	Мотоклуб		2010-09-19 03:09:43.405+04	2010-09-19 03:09:43.405+04
014748ff-6783-4148-8aeb-bda577ac7913	ee3ba207-a0ad-47f2-adf4-abf933619d15	Реклама	Реклама		2010-09-19 03:09:43.408+04	2010-09-19 03:09:43.408+04
5d59ad14-15b4-4440-b682-70793cbb338a	ee3ba207-a0ad-47f2-adf4-abf933619d15	Обложка	Обложка		2010-09-19 03:09:43.409+04	2010-09-19 03:09:43.409+04
11c583fb-35ea-474d-965c-be9fedb17e5b	ee3ba207-a0ad-47f2-adf4-abf933619d15	Анонс	Анонс		2010-09-19 03:09:43.41+04	2010-09-19 03:09:43.41+04
7a0e0ecf-1148-49c5-827f-210fdb7903a1	ee3ba207-a0ad-47f2-adf4-abf933619d15	Тесты	Тесты		2010-09-19 03:09:43.411+04	2010-09-19 03:09:43.411+04
a0b8c6bb-38a2-473f-960e-9a7ee39047ae	ee3ba207-a0ad-47f2-adf4-abf933619d15	Техника	Техника		2010-09-19 03:09:43.412+04	2010-09-19 03:09:43.412+04
51796791-0a92-4585-bd07-ab44a61167c1	ee3ba207-a0ad-47f2-adf4-abf933619d15	Содержание	Содержание		2010-09-19 03:09:43.414+04	2010-09-19 03:09:43.414+04
00000000-0000-0000-0000-000000000000	d62ba395-f854-43c4-8448-9508e72b3530	Not found	Not found		2010-09-19 03:09:43.422+04	2010-09-19 03:09:43.422+04
d7b70e66-279b-4615-8e3e-3b47511ecf3a	d62ba395-f854-43c4-8448-9508e72b3530	Содержание	Содержание		2010-09-19 03:09:43.426+04	2010-09-19 03:09:43.426+04
f4c43d0e-397b-49ac-90a9-115bb3cc419e	d62ba395-f854-43c4-8448-9508e72b3530	Без раздела	Без раздела		2010-09-19 03:09:43.428+04	2010-09-19 03:09:43.428+04
30815766-9a27-4e04-9b12-b35f59024e6b	d62ba395-f854-43c4-8448-9508e72b3530	Экономика	Экономика		2010-09-19 03:09:43.429+04	2010-09-19 03:09:43.429+04
586b3eab-0d66-4ee5-a249-a86cb49130bd	d62ba395-f854-43c4-8448-9508e72b3530	Главная тема	Главная тема		2010-09-19 03:09:43.431+04	2010-09-19 03:09:43.431+04
0dfb1fef-fd7f-4f7b-95ab-d87f34b343b6	d62ba395-f854-43c4-8448-9508e72b3530	Спецпроект	Спецпроект		2010-09-19 03:09:43.432+04	2010-09-19 03:09:43.432+04
ddb4c519-c60d-43d2-9d97-921ff9b81335	d62ba395-f854-43c4-8448-9508e72b3530	Автомобили	Автомобили		2010-09-19 03:09:43.434+04	2010-09-19 03:09:43.434+04
41ede980-4420-4fc8-babf-5b1cf5808105	d62ba395-f854-43c4-8448-9508e72b3530	Выставка	Выставка		2010-09-19 03:09:43.436+04	2010-09-19 03:09:43.436+04
708a9b71-417a-46e9-9a6f-ebb57701dbc6	d62ba395-f854-43c4-8448-9508e72b3530	Спецтехника	Спецтехника		2010-09-19 03:09:43.437+04	2010-09-19 03:09:43.437+04
38f16369-a1ff-4076-ab7e-7e737e518926	d62ba395-f854-43c4-8448-9508e72b3530	Автобаза	Автобаза		2010-09-19 03:09:43.438+04	2010-09-19 03:09:43.438+04
7164dca7-461e-4932-bb25-dabc5b81059b	d62ba395-f854-43c4-8448-9508e72b3530	Реклама	Реклама		2010-09-19 03:09:43.439+04	2010-09-19 03:09:43.439+04
00000000-0000-0000-0000-000000000000	dcc8ce2d-df05-472c-ba52-7d79b442546d	Not found	Not found		2010-09-19 03:09:43.448+04	2010-09-19 03:09:43.448+04
abd095f8-f90d-44bc-bf1d-9e002fdf23ce	dcc8ce2d-df05-472c-ba52-7d79b442546d	Раздел не указан	Раздел не указан		2010-09-19 03:09:43.453+04	2010-09-19 03:09:43.453+04
714cbef9-2c4f-4ba7-861a-ecb034887d33	dcc8ce2d-df05-472c-ba52-7d79b442546d	Новости	Новости		2010-09-19 03:09:43.454+04	2010-09-19 03:09:43.454+04
74647328-a200-47e1-aea7-8ef05fe31ec7	dcc8ce2d-df05-472c-ba52-7d79b442546d	История	История		2010-09-19 03:09:43.455+04	2010-09-19 03:09:43.455+04
8fee3f02-afd1-4083-a545-7ed40aa688ad	dcc8ce2d-df05-472c-ba52-7d79b442546d	Спорт	Спорт		2010-09-19 03:09:43.457+04	2010-09-19 03:09:43.457+04
1b606c82-d6ec-406a-bc2d-8143762fce30	dcc8ce2d-df05-472c-ba52-7d79b442546d	Ремзона	Ремзона		2010-09-19 03:09:43.458+04	2010-09-19 03:09:43.458+04
b16728e6-60db-45a8-94aa-7c0f31875033	dcc8ce2d-df05-472c-ba52-7d79b442546d	Мотоклуб	Мотоклуб		2010-09-19 03:09:43.459+04	2010-09-19 03:09:43.459+04
f4fe1460-6bf8-4a71-afd1-dacf63bd8183	dcc8ce2d-df05-472c-ba52-7d79b442546d	Рынок	Рынок		2010-09-19 03:09:43.46+04	2010-09-19 03:09:43.46+04
ec09b96a-3cd2-4092-ba77-b820b29cd757	dcc8ce2d-df05-472c-ba52-7d79b442546d	Реклама	Реклама		2010-09-19 03:09:43.462+04	2010-09-19 03:09:43.462+04
c9acb91f-7089-4191-b134-1a0d11455064	dcc8ce2d-df05-472c-ba52-7d79b442546d	Обложка	Обложка		2010-09-19 03:09:43.463+04	2010-09-19 03:09:43.463+04
cb94c50e-a9c9-4474-87a6-e932d7776200	dcc8ce2d-df05-472c-ba52-7d79b442546d	Анонс	Анонс		2010-09-19 03:09:43.464+04	2010-09-19 03:09:43.464+04
9ccfb0a3-fdaf-426b-81e5-d2d6fdf3c5df	dcc8ce2d-df05-472c-ba52-7d79b442546d	Тесты	Тесты		2010-09-19 03:09:43.465+04	2010-09-19 03:09:43.465+04
2bbe41d5-f7cd-42c6-b842-08f1d1f32bb7	dcc8ce2d-df05-472c-ba52-7d79b442546d	Техника	Техника		2010-09-19 03:09:43.466+04	2010-09-19 03:09:43.466+04
763c8df9-214a-4b8c-a5ea-e4680d47c695	dcc8ce2d-df05-472c-ba52-7d79b442546d	Содержание	Содержание		2010-09-19 03:09:43.467+04	2010-09-19 03:09:43.467+04
00000000-0000-0000-0000-000000000000	44b2913d-bf64-4464-a079-aee6184b2d06	Not found	Not found		2010-09-19 03:09:43.474+04	2010-09-19 03:09:43.474+04
329781db-f5d0-437b-af29-cfa87d65f2d4	44b2913d-bf64-4464-a079-aee6184b2d06	Содержание	Содержание		2010-09-19 03:09:43.478+04	2010-09-19 03:09:43.478+04
0c79eed6-4400-4804-ab44-5896bd7cd1b4	44b2913d-bf64-4464-a079-aee6184b2d06	Без рубрики	Без рубрики		2010-09-19 03:09:43.48+04	2010-09-19 03:09:43.48+04
8d1513a5-698f-497d-868a-b3e1884b1091	44b2913d-bf64-4464-a079-aee6184b2d06	Город и автомобиль	Город и автомобиль		2010-09-19 03:09:43.481+04	2010-09-19 03:09:43.481+04
6580df00-fe65-45cb-a063-986dda6c85d6	44b2913d-bf64-4464-a079-aee6184b2d06	Реклама	Реклама		2010-09-19 03:09:43.482+04	2010-09-19 03:09:43.482+04
5a6b3325-0792-4769-9c62-b701af6c6f8e	44b2913d-bf64-4464-a079-aee6184b2d06	3. Детали, компоненты	3. Детали, компоненты		2010-09-19 03:09:43.483+04	2010-09-19 03:09:43.483+04
821bbfc9-61cd-4f94-bd28-c031fcfdff7a	44b2913d-bf64-4464-a079-aee6184b2d06	0. Обложка	0. Обложка		2010-09-19 03:09:43.485+04	2010-09-19 03:09:43.485+04
96f96761-8b34-4bf6-9bf6-241065a84e98	44b2913d-bf64-4464-a079-aee6184b2d06	2. Авто с пробегом	2. Авто с пробегом		2010-09-19 03:09:43.486+04	2010-09-19 03:09:43.486+04
a323f03b-a91c-433c-8e95-944fa22ccc49	44b2913d-bf64-4464-a079-aee6184b2d06	4. Тюнинг	4. Тюнинг		2010-09-19 03:09:43.487+04	2010-09-19 03:09:43.487+04
6ff750a8-2ca8-408f-95b5-45ef2502ae1d	44b2913d-bf64-4464-a079-aee6184b2d06	5. Ретро	5. Ретро		2010-09-19 03:09:43.488+04	2010-09-19 03:09:43.488+04
b52d2eb1-e4cd-4669-af07-c336d9e369bc	44b2913d-bf64-4464-a079-aee6184b2d06	6. Спорт	6. Спорт		2010-09-19 03:09:43.489+04	2010-09-19 03:09:43.489+04
0af31968-ff29-46cc-a6b0-dde9a9c30684	44b2913d-bf64-4464-a079-aee6184b2d06	1. Автомобиль	1. Автомобиль		2010-09-19 03:09:43.491+04	2010-09-19 03:09:43.491+04
00000000-0000-0000-0000-000000000000	6f932426-79d4-4631-8ccd-89c12ec6959f	Not found	Not found		2010-09-19 03:09:43.497+04	2010-09-19 03:09:43.497+04
893a8baf-305a-4ce1-b6c2-c7d9718eee4b	6f932426-79d4-4631-8ccd-89c12ec6959f	Раздел не указан	Раздел не указан		2010-09-19 03:09:43.502+04	2010-09-19 03:09:43.502+04
9139432f-e299-4a09-8a62-80dbb0873d47	6f932426-79d4-4631-8ccd-89c12ec6959f	Новости	Новости		2010-09-19 03:09:43.503+04	2010-09-19 03:09:43.503+04
73f6eaa4-df32-4e89-8b7a-45429bc894e4	6f932426-79d4-4631-8ccd-89c12ec6959f	История	История		2010-09-19 03:09:43.504+04	2010-09-19 03:09:43.504+04
077a47f4-298d-4835-b698-4e78edfddd8b	6f932426-79d4-4631-8ccd-89c12ec6959f	Спорт	Спорт		2010-09-19 03:09:43.505+04	2010-09-19 03:09:43.505+04
24adc5e1-9edf-4479-a3e7-957094dfe638	6f932426-79d4-4631-8ccd-89c12ec6959f	Ремзона	Ремзона		2010-09-19 03:09:43.507+04	2010-09-19 03:09:43.507+04
cf9ea2c5-649b-47f1-9fbf-d641d7a3f402	6f932426-79d4-4631-8ccd-89c12ec6959f	Мотоклуб	Мотоклуб		2010-09-19 03:09:43.508+04	2010-09-19 03:09:43.508+04
2f6f8bc8-f1dc-4539-a655-07e88526b29c	6f932426-79d4-4631-8ccd-89c12ec6959f	Рынок	Рынок		2010-09-19 03:09:43.509+04	2010-09-19 03:09:43.509+04
b3e81c1a-2272-412f-b6cb-9307b20f886c	6f932426-79d4-4631-8ccd-89c12ec6959f	Реклама	Реклама		2010-09-19 03:09:43.51+04	2010-09-19 03:09:43.51+04
c90f91d4-d8ff-4dff-8b50-7703679cd54b	6f932426-79d4-4631-8ccd-89c12ec6959f	Обложка	Обложка		2010-09-19 03:09:43.512+04	2010-09-19 03:09:43.512+04
ce75b18d-c1b6-4cca-8e16-c52f4e68eccd	6f932426-79d4-4631-8ccd-89c12ec6959f	Анонс	Анонс		2010-09-19 03:09:43.513+04	2010-09-19 03:09:43.513+04
8b98c84f-47d0-43a3-9e52-87435b6793d8	6f932426-79d4-4631-8ccd-89c12ec6959f	Тесты	Тесты		2010-09-19 03:09:43.514+04	2010-09-19 03:09:43.514+04
538bc3a2-ac04-476f-8e46-2049c33dca51	6f932426-79d4-4631-8ccd-89c12ec6959f	Техника	Техника		2010-09-19 03:09:43.515+04	2010-09-19 03:09:43.515+04
be053a39-f7d7-440a-b74f-f6006c67e7ac	6f932426-79d4-4631-8ccd-89c12ec6959f	Содержание	Содержание		2010-09-19 03:09:43.516+04	2010-09-19 03:09:43.516+04
00000000-0000-0000-0000-000000000000	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	Not found	Not found		2010-09-19 03:09:43.526+04	2010-09-19 03:09:43.526+04
d1f8caa1-5688-4183-a0aa-9aa14e0de9b3	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	0. Обложка	0. Обложка		2010-09-19 03:09:43.53+04	2010-09-19 03:09:43.53+04
4d92ab14-958e-47ba-987a-37c8d64aaf45	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	Содержание	Содержание		2010-09-19 03:09:43.531+04	2010-09-19 03:09:43.531+04
9882077c-8cda-4986-a285-7965fd66336a	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	Город и автомобиль	Город и автомобиль		2010-09-19 03:09:43.533+04	2010-09-19 03:09:43.533+04
57390d2a-45bb-4662-9359-5c25ee2ed3c3	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	Без рубрики	Без рубрики		2010-09-19 03:09:43.534+04	2010-09-19 03:09:43.534+04
e371d2fc-c2a4-457e-a9b8-f8d0675e197c	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	3. Детали, компоненты	3. Детали, компоненты		2010-09-19 03:09:43.536+04	2010-09-19 03:09:43.536+04
981048c9-8341-49af-bb31-85d6464751e5	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	1. Автомобиль	1. Автомобиль		2010-09-19 03:09:43.537+04	2010-09-19 03:09:43.537+04
e1edcb6a-58e4-470c-8770-48f2ac1adde8	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	6. Спорт	6. Спорт		2010-09-19 03:09:43.539+04	2010-09-19 03:09:43.539+04
a43a2dd7-29ea-4031-a4ae-faa34ce2325a	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	5. Ретро	5. Ретро		2010-09-19 03:09:43.54+04	2010-09-19 03:09:43.54+04
ba634467-5a4b-4896-940a-716324c90929	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	4. Тюнинг	4. Тюнинг		2010-09-19 03:09:43.541+04	2010-09-19 03:09:43.541+04
14fe3c62-2b87-4ec9-939b-69a0cd718bdc	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	2. Авто с пробегом	2. Авто с пробегом		2010-09-19 03:09:43.545+04	2010-09-19 03:09:43.545+04
00000000-0000-0000-0000-000000000000	861454b0-4d5b-4bbe-b09c-c7b22093a525	Not found	Not found		2010-09-19 03:09:43.552+04	2010-09-19 03:09:43.552+04
d4b12535-b882-46ee-a1b0-b4694f693041	861454b0-4d5b-4bbe-b09c-c7b22093a525	Раздел не указан	Раздел не указан		2010-09-19 03:09:43.556+04	2010-09-19 03:09:43.556+04
6a377321-ef25-4436-8226-92fcdafd196a	861454b0-4d5b-4bbe-b09c-c7b22093a525	Тесты	Тесты		2010-09-19 03:09:43.558+04	2010-09-19 03:09:43.558+04
a2eed1a6-169a-42bd-8d8b-4aabb1e2d4aa	861454b0-4d5b-4bbe-b09c-c7b22093a525	Новости	Новости		2010-09-19 03:09:43.559+04	2010-09-19 03:09:43.559+04
f4299524-4fff-4f30-8505-81ed65fd80eb	861454b0-4d5b-4bbe-b09c-c7b22093a525	Анонс	Анонс		2010-09-19 03:09:43.56+04	2010-09-19 03:09:43.56+04
2e418669-b3b0-44dc-9400-61f2db88b14a	861454b0-4d5b-4bbe-b09c-c7b22093a525	История	История		2010-09-19 03:09:43.561+04	2010-09-19 03:09:43.561+04
f5ff0883-11ed-44c5-b03a-0034f4c502ba	861454b0-4d5b-4bbe-b09c-c7b22093a525	Спорт	Спорт		2010-09-19 03:09:43.562+04	2010-09-19 03:09:43.562+04
4a0dc608-3257-4278-ae93-da39aa07ee60	861454b0-4d5b-4bbe-b09c-c7b22093a525	Ремзона	Ремзона		2010-09-19 03:09:43.564+04	2010-09-19 03:09:43.564+04
a6690577-632e-4f49-b380-89c6d0464071	861454b0-4d5b-4bbe-b09c-c7b22093a525	Мотоклуб	Мотоклуб		2010-09-19 03:09:43.565+04	2010-09-19 03:09:43.565+04
910f961f-62da-414e-8625-bd86794af3b8	861454b0-4d5b-4bbe-b09c-c7b22093a525	Рынок	Рынок		2010-09-19 03:09:43.566+04	2010-09-19 03:09:43.566+04
6aed5e44-a6ac-40fc-a040-28a5b6868895	861454b0-4d5b-4bbe-b09c-c7b22093a525	Реклама	Реклама		2010-09-19 03:09:43.568+04	2010-09-19 03:09:43.568+04
2ebb5091-3c1c-4647-9020-c30b667f611a	861454b0-4d5b-4bbe-b09c-c7b22093a525	Обложка	Обложка		2010-09-19 03:09:43.569+04	2010-09-19 03:09:43.569+04
0c68eaba-9508-41d1-babf-44114681bd8e	861454b0-4d5b-4bbe-b09c-c7b22093a525	Техника	Техника		2010-09-19 03:09:43.57+04	2010-09-19 03:09:43.57+04
74b706aa-2a28-4ae6-8dd7-cbc57e26771e	861454b0-4d5b-4bbe-b09c-c7b22093a525	Содержание	Содержание		2010-09-19 03:09:43.571+04	2010-09-19 03:09:43.571+04
00000000-0000-0000-0000-000000000000	93739a43-c4ef-43ca-81e2-a2b64ac44d56	Not found	Not found		2010-09-19 03:09:43.581+04	2010-09-19 03:09:43.581+04
003a8ab5-05f8-4ce9-8ba8-0e4afc27d4e8	93739a43-c4ef-43ca-81e2-a2b64ac44d56	0. Обложка	0. Обложка		2010-09-19 03:09:43.586+04	2010-09-19 03:09:43.586+04
378bea5f-257a-4dd7-9ae5-8d1f84049795	93739a43-c4ef-43ca-81e2-a2b64ac44d56	Новости дилеров	Новости дилеров		2010-09-19 03:09:43.587+04	2010-09-19 03:09:43.587+04
f09bacff-5499-44b9-aadf-d84c5141a518	93739a43-c4ef-43ca-81e2-a2b64ac44d56	Актуально	Актуально		2010-09-19 03:09:43.589+04	2010-09-19 03:09:43.589+04
a2a35691-a427-48c3-9db2-b5ae83368e42	93739a43-c4ef-43ca-81e2-a2b64ac44d56	Реклама	Реклама		2010-09-19 03:09:43.59+04	2010-09-19 03:09:43.59+04
159d618c-40a7-4596-a67d-608dd610aa12	93739a43-c4ef-43ca-81e2-a2b64ac44d56	Без рубрики	Без рубрики		2010-09-19 03:09:43.591+04	2010-09-19 03:09:43.591+04
a21fd899-33ae-4c0f-96cd-591b1a5d67dd	93739a43-c4ef-43ca-81e2-a2b64ac44d56	Права	Права		2010-09-19 03:09:43.593+04	2010-09-19 03:09:43.593+04
1d38e3bc-143b-4e97-b41b-04ffb3906dc3	93739a43-c4ef-43ca-81e2-a2b64ac44d56	Городские новости	Городские новости		2010-09-19 03:09:43.594+04	2010-09-19 03:09:43.594+04
4f891707-e52c-4a5c-b443-c9f14df0c8c6	93739a43-c4ef-43ca-81e2-a2b64ac44d56	Трафик	Трафик		2010-09-19 03:09:43.595+04	2010-09-19 03:09:43.595+04
00000000-0000-0000-0000-000000000000	750d111c-994c-46ca-888e-e2b4a8662887	Not found	Not found		2010-09-19 03:09:43.604+04	2010-09-19 03:09:43.604+04
ddd9fff3-988b-4e5b-95c5-0a6c71e10fa2	750d111c-994c-46ca-888e-e2b4a8662887	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:43.609+04	2010-09-19 03:09:43.609+04
3225438e-7e29-4f34-87de-55e6d833eca0	750d111c-994c-46ca-888e-e2b4a8662887	1/ НОВОСТИ	1/ НОВОСТИ		2010-09-19 03:09:43.61+04	2010-09-19 03:09:43.61+04
a101d050-3554-4cea-91c0-a6befdacd598	750d111c-994c-46ca-888e-e2b4a8662887	0/ Содержание	0/ Содержание		2010-09-19 03:09:43.612+04	2010-09-19 03:09:43.612+04
86500126-b899-4662-9570-6701ca9f4989	750d111c-994c-46ca-888e-e2b4a8662887	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:43.614+04	2010-09-19 03:09:43.614+04
ff89bd89-112f-423f-b0b8-4a64fa5ce15f	750d111c-994c-46ca-888e-e2b4a8662887	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:43.615+04	2010-09-19 03:09:43.615+04
2b664bd0-8640-40ff-9346-cf563fef15d0	750d111c-994c-46ca-888e-e2b4a8662887	б/ Курьер	б/ Курьер		2010-09-19 03:09:43.616+04	2010-09-19 03:09:43.616+04
70c4a711-61c9-4950-99e0-36f62588e83a	750d111c-994c-46ca-888e-e2b4a8662887	к/ Спорт	к/ Спорт		2010-09-19 03:09:43.617+04	2010-09-19 03:09:43.617+04
789bc34b-6983-497c-86a7-0eb3bd395b9c	750d111c-994c-46ca-888e-e2b4a8662887	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:43.619+04	2010-09-19 03:09:43.619+04
8d97484e-6f1b-48d0-aaee-051e8d509b15	750d111c-994c-46ca-888e-e2b4a8662887	з/ Экономика	з/ Экономика		2010-09-19 03:09:43.62+04	2010-09-19 03:09:43.62+04
8a60f0ec-15cb-4344-a4b9-e081df9b2756	750d111c-994c-46ca-888e-e2b4a8662887	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:43.621+04	2010-09-19 03:09:43.621+04
23789ff2-5f2c-4afe-af9e-57e5e0820581	750d111c-994c-46ca-888e-e2b4a8662887	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:43.623+04	2010-09-19 03:09:43.623+04
5cbe60f1-dc6f-43cc-9446-61f38d6b2849	750d111c-994c-46ca-888e-e2b4a8662887	д/ Техника	д/ Техника		2010-09-19 03:09:43.625+04	2010-09-19 03:09:43.625+04
0782b98c-dff0-4c32-a0d1-a96d9807e732	750d111c-994c-46ca-888e-e2b4a8662887	н/ Без границ	н/ Без границ		2010-09-19 03:09:43.626+04	2010-09-19 03:09:43.626+04
492b92de-3128-4ada-8978-387e79366cce	750d111c-994c-46ca-888e-e2b4a8662887	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:43.627+04	2010-09-19 03:09:43.627+04
f47f6623-db7e-41f6-a4c7-a7fda205dab8	750d111c-994c-46ca-888e-e2b4a8662887	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:43.628+04	2010-09-19 03:09:43.628+04
429a7d38-ab13-45c6-8a73-00097c34ecf0	750d111c-994c-46ca-888e-e2b4a8662887	0/ ОБЛОЖКА	0/ ОБЛОЖКА		2010-09-19 03:09:43.629+04	2010-09-19 03:09:43.629+04
dc3eb7fe-151a-4d40-ab29-2880113993c9	750d111c-994c-46ca-888e-e2b4a8662887	и/ рекламный блок	и/ рекламный блок		2010-09-19 03:09:43.631+04	2010-09-19 03:09:43.631+04
dd568842-cf8a-40b0-b05b-9b0e470a27de	750d111c-994c-46ca-888e-e2b4a8662887	о/ Анонс	о/ Анонс		2010-09-19 03:09:43.632+04	2010-09-19 03:09:43.632+04
00000000-0000-0000-0000-000000000000	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	Not found	Not found		2010-09-19 03:09:43.638+04	2010-09-19 03:09:43.638+04
ea93c8b5-9798-406a-94b7-bc11aeca3400	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	0. Обложка	0. Обложка		2010-09-19 03:09:43.643+04	2010-09-19 03:09:43.643+04
e84ba06b-297e-4bbf-b37c-bb334b47ad1f	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	Содержание	Содержание		2010-09-19 03:09:43.644+04	2010-09-19 03:09:43.644+04
311f7d85-2df2-4629-8d5c-105d8cccd839	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	Город и автомобиль	Город и автомобиль		2010-09-19 03:09:43.646+04	2010-09-19 03:09:43.646+04
73e1d2c0-8b5d-448e-8988-5dba0280443b	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	Без рубрики	Без рубрики		2010-09-19 03:09:43.647+04	2010-09-19 03:09:43.647+04
170a4349-e9e5-4e7d-9c87-a70eb068c067	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	3. Детали, компоненты	3. Детали, компоненты		2010-09-19 03:09:43.648+04	2010-09-19 03:09:43.648+04
d5353046-418e-4cf0-9967-50da2cbcd6e8	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	1. Автомобиль	1. Автомобиль		2010-09-19 03:09:43.65+04	2010-09-19 03:09:43.65+04
5e722f65-5455-47aa-8431-225269f81f9c	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	6. Спорт	6. Спорт		2010-09-19 03:09:43.651+04	2010-09-19 03:09:43.651+04
ae8b079e-523e-473f-8912-c2f81d19f09e	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	5. Ретро	5. Ретро		2010-09-19 03:09:43.652+04	2010-09-19 03:09:43.652+04
294508f9-7cbb-4159-8712-258f4641d7a5	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	4. Тюнинг	4. Тюнинг		2010-09-19 03:09:43.653+04	2010-09-19 03:09:43.653+04
7fb8083f-3a69-4424-b619-1e740966e16e	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	2. Авто с пробегом	2. Авто с пробегом		2010-09-19 03:09:43.654+04	2010-09-19 03:09:43.654+04
00000000-0000-0000-0000-000000000000	db776095-f67f-4e10-9acf-9e70e1fc83a8	Not found	Not found		2010-09-19 03:09:43.662+04	2010-09-19 03:09:43.662+04
2d390b68-a220-440c-9f40-3042a5133589	db776095-f67f-4e10-9acf-9e70e1fc83a8	0. Обложка	0. Обложка		2010-09-19 03:09:43.667+04	2010-09-19 03:09:43.667+04
9ff4f139-1a8e-4037-b96d-a14201f16701	db776095-f67f-4e10-9acf-9e70e1fc83a8	Содержание	Содержание		2010-09-19 03:09:43.669+04	2010-09-19 03:09:43.669+04
e1f2dc02-63d1-41e3-9147-f7c997d4fce2	db776095-f67f-4e10-9acf-9e70e1fc83a8	Город и автомобиль	Город и автомобиль		2010-09-19 03:09:43.67+04	2010-09-19 03:09:43.67+04
80e797de-2bdb-4173-8948-c418bb5317cf	db776095-f67f-4e10-9acf-9e70e1fc83a8	Без рубрики	Без рубрики		2010-09-19 03:09:43.672+04	2010-09-19 03:09:43.672+04
453fbe45-41ef-437a-ac7d-56e3da0b1edc	db776095-f67f-4e10-9acf-9e70e1fc83a8	3. Детали, компоненты	3. Детали, компоненты		2010-09-19 03:09:43.673+04	2010-09-19 03:09:43.673+04
acbcfba9-8fce-41c7-8dbf-38e30f3c0cde	db776095-f67f-4e10-9acf-9e70e1fc83a8	1. Автомобиль	1. Автомобиль		2010-09-19 03:09:43.674+04	2010-09-19 03:09:43.674+04
ea02e1ef-8f29-42a3-8b57-c985fd3cf728	db776095-f67f-4e10-9acf-9e70e1fc83a8	6. Спорт	6. Спорт		2010-09-19 03:09:43.675+04	2010-09-19 03:09:43.675+04
4ca741be-1762-4042-94d3-3ef1e8071baf	db776095-f67f-4e10-9acf-9e70e1fc83a8	5. Ретро	5. Ретро		2010-09-19 03:09:43.676+04	2010-09-19 03:09:43.676+04
1cbf4f00-bd63-4759-9242-b5c7c047bca6	db776095-f67f-4e10-9acf-9e70e1fc83a8	4. Тюнинг	4. Тюнинг		2010-09-19 03:09:43.677+04	2010-09-19 03:09:43.677+04
423b3532-1ebf-49bf-ad1f-232310c481d1	db776095-f67f-4e10-9acf-9e70e1fc83a8	2. Авто с пробегом	2. Авто с пробегом		2010-09-19 03:09:43.679+04	2010-09-19 03:09:43.679+04
00000000-0000-0000-0000-000000000000	012fbccd-6b40-40b0-909a-7d07a1c0d224	Not found	Not found		2010-09-19 03:09:43.685+04	2010-09-19 03:09:43.685+04
c33ec98e-1be2-4ed2-a871-14ad880993fe	012fbccd-6b40-40b0-909a-7d07a1c0d224	0. Обложка	0. Обложка		2010-09-19 03:09:43.69+04	2010-09-19 03:09:43.69+04
6166be63-2f71-4b3c-a9e4-551a6ca1a4a8	012fbccd-6b40-40b0-909a-7d07a1c0d224	Содержание	Содержание		2010-09-19 03:09:43.691+04	2010-09-19 03:09:43.691+04
9466d4bf-41ff-4ee3-846e-040e7a126c15	012fbccd-6b40-40b0-909a-7d07a1c0d224	Город и автомобиль	Город и автомобиль		2010-09-19 03:09:43.692+04	2010-09-19 03:09:43.692+04
1c29ece1-85ce-42d0-bb06-4c95dd921724	012fbccd-6b40-40b0-909a-7d07a1c0d224	Без рубрики	Без рубрики		2010-09-19 03:09:43.694+04	2010-09-19 03:09:43.694+04
00000000-0000-0000-0000-000000000000	848f7187-6099-459d-83b6-46213bc811db	Not found	Not found		2010-09-19 03:09:44.413+04	2010-09-19 03:09:44.413+04
77a60a53-c40a-404a-ae73-79170de5ee20	012fbccd-6b40-40b0-909a-7d07a1c0d224	3. Детали, компоненты	3. Детали, компоненты		2010-09-19 03:09:43.695+04	2010-09-19 03:09:43.695+04
f857c2b0-0648-485a-b161-75311b839d7b	012fbccd-6b40-40b0-909a-7d07a1c0d224	1. Автомобиль	1. Автомобиль		2010-09-19 03:09:43.696+04	2010-09-19 03:09:43.696+04
cccdc628-d48d-4434-94b3-5b132ae8a18d	012fbccd-6b40-40b0-909a-7d07a1c0d224	6. Спорт	6. Спорт		2010-09-19 03:09:43.698+04	2010-09-19 03:09:43.698+04
1522b01c-36cb-4602-9170-1c5f7ffbb840	012fbccd-6b40-40b0-909a-7d07a1c0d224	5. Ретро	5. Ретро		2010-09-19 03:09:43.699+04	2010-09-19 03:09:43.699+04
f8a85534-45ca-4144-8642-64555c197899	012fbccd-6b40-40b0-909a-7d07a1c0d224	4. Тюнинг	4. Тюнинг		2010-09-19 03:09:43.701+04	2010-09-19 03:09:43.701+04
ac2a83ac-0142-4d05-8b3a-5a75ebfb631c	012fbccd-6b40-40b0-909a-7d07a1c0d224	2. Авто с пробегом	2. Авто с пробегом		2010-09-19 03:09:43.702+04	2010-09-19 03:09:43.702+04
00000000-0000-0000-0000-000000000000	677e19ff-aaab-4a86-b61c-2f436de510a8	Not found	Not found		2010-09-19 03:09:43.708+04	2010-09-19 03:09:43.708+04
00000000-0000-0000-0000-000000000000	dbc81fc4-645c-4827-8e5b-46a527a27e25	Not found	Not found		2010-09-19 03:09:43.719+04	2010-09-19 03:09:43.719+04
bc6ea2e8-846e-491a-ba15-b230ae438653	dbc81fc4-645c-4827-8e5b-46a527a27e25	0. Обложка	0. Обложка		2010-09-19 03:09:43.724+04	2010-09-19 03:09:43.724+04
64501ef9-5716-4325-ac18-1641f2157f27	dbc81fc4-645c-4827-8e5b-46a527a27e25	Новости дилеров	Новости дилеров		2010-09-19 03:09:43.725+04	2010-09-19 03:09:43.725+04
07fd46b3-fef1-4b3b-b7f5-afeb6a1c5efb	dbc81fc4-645c-4827-8e5b-46a527a27e25	Актуально	Актуально		2010-09-19 03:09:43.727+04	2010-09-19 03:09:43.727+04
0dab187f-27fb-407b-96c2-aae4c218531b	dbc81fc4-645c-4827-8e5b-46a527a27e25	Реклама	Реклама		2010-09-19 03:09:43.728+04	2010-09-19 03:09:43.728+04
edd6d7d8-9f8c-4a70-b720-e630d43231a8	dbc81fc4-645c-4827-8e5b-46a527a27e25	Без рубрики	Без рубрики		2010-09-19 03:09:43.73+04	2010-09-19 03:09:43.73+04
fc16639a-b1db-4d14-9521-f8c27438df32	dbc81fc4-645c-4827-8e5b-46a527a27e25	Права	Права		2010-09-19 03:09:43.731+04	2010-09-19 03:09:43.731+04
3043d18f-c2f4-4d4b-bd29-bec9ecd311b0	dbc81fc4-645c-4827-8e5b-46a527a27e25	Городские новости	Городские новости		2010-09-19 03:09:43.732+04	2010-09-19 03:09:43.732+04
8b999a17-7353-4ac6-a98a-c185ed9f5982	dbc81fc4-645c-4827-8e5b-46a527a27e25	Трафик	Трафик		2010-09-19 03:09:43.733+04	2010-09-19 03:09:43.733+04
00000000-0000-0000-0000-000000000000	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Not found	Not found		2010-09-19 03:09:43.742+04	2010-09-19 03:09:43.742+04
024d3123-ed20-4662-8885-23e579a4ce1b	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Раздел не указан	Раздел не указан		2010-09-19 03:09:43.747+04	2010-09-19 03:09:43.747+04
2df067e3-cde8-4b84-934c-097fcd985660	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Тесты	Тесты		2010-09-19 03:09:43.748+04	2010-09-19 03:09:43.748+04
ddae2c43-e614-4bb1-a6a6-1f48e77c5014	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Новости	Новости		2010-09-19 03:09:43.75+04	2010-09-19 03:09:43.75+04
775fd83f-2275-4d35-a0ff-9735612cd037	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Анонс	Анонс		2010-09-19 03:09:43.751+04	2010-09-19 03:09:43.751+04
0dc77d5a-6fce-4a5f-af7a-0567f14c1cf9	90eb0213-95ca-427e-8f36-a5cbb0f51f24	История	История		2010-09-19 03:09:43.752+04	2010-09-19 03:09:43.752+04
954a86fa-0578-49ce-ab41-0d65fa95ee1e	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Спорт	Спорт		2010-09-19 03:09:43.754+04	2010-09-19 03:09:43.754+04
853dc413-aa7f-475d-9a2e-3dfb90293b9d	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Ремзона	Ремзона		2010-09-19 03:09:43.755+04	2010-09-19 03:09:43.755+04
598796c4-331e-40bd-a3ca-32607a4110a5	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Мотоклуб	Мотоклуб		2010-09-19 03:09:43.756+04	2010-09-19 03:09:43.756+04
8a77dee3-a6a1-4725-ae24-f74a503fa71f	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Рынок	Рынок		2010-09-19 03:09:43.757+04	2010-09-19 03:09:43.757+04
1e263f75-e6a6-41cb-ac02-f6d4bec8e5e6	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Реклама	Реклама		2010-09-19 03:09:43.759+04	2010-09-19 03:09:43.759+04
dc999c6c-3ab3-4984-912e-2d852a99351c	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Обложка	Обложка		2010-09-19 03:09:43.76+04	2010-09-19 03:09:43.76+04
daf1cd33-5530-4526-86c6-689d922b55d1	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Техника	Техника		2010-09-19 03:09:43.761+04	2010-09-19 03:09:43.761+04
ec449840-fb12-4091-9a2d-27ef82113a37	90eb0213-95ca-427e-8f36-a5cbb0f51f24	Содержание	Содержание		2010-09-19 03:09:43.762+04	2010-09-19 03:09:43.762+04
00000000-0000-0000-0000-000000000000	f3e51f59-e3da-4533-a304-a7f5dbda5648	Not found	Not found		2010-09-19 03:09:43.772+04	2010-09-19 03:09:43.772+04
a20f3fc3-3c2d-4ae7-b9fc-231e568da646	f3e51f59-e3da-4533-a304-a7f5dbda5648	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:43.777+04	2010-09-19 03:09:43.777+04
18810ca4-93a7-4975-9736-08c19a215e9c	f3e51f59-e3da-4533-a304-a7f5dbda5648	04/ НОВОСТИ	04/ НОВОСТИ		2010-09-19 03:09:43.779+04	2010-09-19 03:09:43.779+04
8722b89f-1a38-447b-9df7-ae4764d469a0	f3e51f59-e3da-4533-a304-a7f5dbda5648	03/ Содержание	03/ Содержание		2010-09-19 03:09:43.78+04	2010-09-19 03:09:43.78+04
6fc1a904-337b-4c70-9d0a-d71b06d8dbf8	f3e51f59-e3da-4533-a304-a7f5dbda5648	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:43.782+04	2010-09-19 03:09:43.782+04
6cbc32f4-7a95-4451-9f34-885086f2be6d	f3e51f59-e3da-4533-a304-a7f5dbda5648	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:43.783+04	2010-09-19 03:09:43.783+04
3af475ac-e571-4685-bed1-cf89bc0bf798	f3e51f59-e3da-4533-a304-a7f5dbda5648	б/ Курьер	б/ Курьер		2010-09-19 03:09:43.784+04	2010-09-19 03:09:43.784+04
f7132e4f-6ccb-4aef-aae7-13b3088500da	f3e51f59-e3da-4533-a304-a7f5dbda5648	к/ Спорт	к/ Спорт		2010-09-19 03:09:43.786+04	2010-09-19 03:09:43.786+04
db93bb29-71fa-41f6-b61b-0a08607d6f95	f3e51f59-e3da-4533-a304-a7f5dbda5648	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:43.787+04	2010-09-19 03:09:43.787+04
011ad105-1dd6-49de-bbf8-901e175791fd	f3e51f59-e3da-4533-a304-a7f5dbda5648	з/ Экономика	з/ Экономика		2010-09-19 03:09:43.788+04	2010-09-19 03:09:43.788+04
4b94260c-9488-411c-b5e1-6f9970c8e74a	f3e51f59-e3da-4533-a304-a7f5dbda5648	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:43.789+04	2010-09-19 03:09:43.789+04
efcca742-fedb-4587-86d9-137f27376bc1	f3e51f59-e3da-4533-a304-a7f5dbda5648	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:43.791+04	2010-09-19 03:09:43.791+04
97a2f207-6cfd-4f37-b461-71c3bbd49eab	f3e51f59-e3da-4533-a304-a7f5dbda5648	д/ Техника	д/ Техника		2010-09-19 03:09:43.792+04	2010-09-19 03:09:43.792+04
7e68f834-d843-4a18-86dd-91e4ee3c0acf	f3e51f59-e3da-4533-a304-a7f5dbda5648	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:43.793+04	2010-09-19 03:09:43.793+04
5baa103f-271a-4fc1-9df9-8718ddda2af5	f3e51f59-e3da-4533-a304-a7f5dbda5648	ч/ Анонс	ч/ Анонс		2010-09-19 03:09:43.794+04	2010-09-19 03:09:43.794+04
623d7476-db1a-4508-a8de-543228da086a	f3e51f59-e3da-4533-a304-a7f5dbda5648	н/ Без границ	н/ Без границ		2010-09-19 03:09:43.796+04	2010-09-19 03:09:43.796+04
d2732447-e629-4233-b4cb-73fce2664859	f3e51f59-e3da-4533-a304-a7f5dbda5648	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:43.797+04	2010-09-19 03:09:43.797+04
3514ba25-f73a-4072-ae69-c61d1a2a91be	f3e51f59-e3da-4533-a304-a7f5dbda5648	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:43.798+04	2010-09-19 03:09:43.798+04
5f8dedd5-782e-4832-9694-b7b274c62a3c	f3e51f59-e3da-4533-a304-a7f5dbda5648	01/ ОБЛОЖКА	01/ ОБЛОЖКА		2010-09-19 03:09:43.799+04	2010-09-19 03:09:43.799+04
b7636401-67b3-4ad5-a057-6f69df4e9e2c	f3e51f59-e3da-4533-a304-a7f5dbda5648	02/ Крупным планом	02/ Крупным планом		2010-09-19 03:09:43.8+04	2010-09-19 03:09:43.8+04
00000000-0000-0000-0000-000000000000	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Not found	Not found		2010-09-19 03:09:43.808+04	2010-09-19 03:09:43.808+04
ece9d815-d7f0-4a94-a12f-260151c4c1e0	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Содержание	Содержание		2010-09-19 03:09:43.813+04	2010-09-19 03:09:43.813+04
5e343c70-7052-4ff1-8330-f1773f0661b3	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Без раздела	Без раздела		2010-09-19 03:09:43.814+04	2010-09-19 03:09:43.814+04
be6fb206-63ac-476a-a305-a1e50e60d71f	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Экономика	Экономика		2010-09-19 03:09:43.816+04	2010-09-19 03:09:43.816+04
d0b4b5c3-9c16-4ea4-9400-833050050fbc	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Главная тема	Главная тема		2010-09-19 03:09:43.817+04	2010-09-19 03:09:43.817+04
fc4e37f7-a3da-4a0a-af1c-675ad4151763	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Спецпроект	Спецпроект		2010-09-19 03:09:43.819+04	2010-09-19 03:09:43.819+04
7b7f9261-74dc-4b6d-87ce-1199f8eff76b	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Автомобили	Автомобили		2010-09-19 03:09:43.82+04	2010-09-19 03:09:43.82+04
66590455-c937-4fbb-994b-557dfc2b1078	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Выставка	Выставка		2010-09-19 03:09:43.821+04	2010-09-19 03:09:43.821+04
ffd964a3-c3d9-4d3e-99bc-c4b31a940029	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Спецтехника	Спецтехника		2010-09-19 03:09:43.823+04	2010-09-19 03:09:43.823+04
345f5dda-6224-45bd-8242-73a9adb8f853	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Автобаза	Автобаза		2010-09-19 03:09:43.824+04	2010-09-19 03:09:43.824+04
05804718-7534-40f2-a4ee-2a23531a0225	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	Реклама	Реклама		2010-09-19 03:09:43.825+04	2010-09-19 03:09:43.825+04
00000000-0000-0000-0000-000000000000	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	Not found	Not found		2010-09-19 03:09:43.833+04	2010-09-19 03:09:43.833+04
c265a8be-24b4-4f54-aa09-d5a5889db2e9	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:43.839+04	2010-09-19 03:09:43.839+04
3a536fdb-ab86-4dd6-87ff-dfd976c5c75d	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	04/ НОВОСТИ	04/ НОВОСТИ		2010-09-19 03:09:43.84+04	2010-09-19 03:09:43.84+04
2fd0234b-c1a1-46ba-827c-7a2ed0d8e2c7	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	03/ Содержание	03/ Содержание		2010-09-19 03:09:43.842+04	2010-09-19 03:09:43.842+04
e59d0918-fa9a-42dd-a946-92c9e114facd	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:43.843+04	2010-09-19 03:09:43.843+04
a59f9311-aa38-4e47-90cc-962b51d7750b	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:43.846+04	2010-09-19 03:09:43.846+04
e98a693c-c366-4d0a-b96b-730630b4206b	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	б/ Курьер	б/ Курьер		2010-09-19 03:09:43.847+04	2010-09-19 03:09:43.847+04
cc52589e-2084-455a-baa5-4d7d173eb827	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	к/ Спорт	к/ Спорт		2010-09-19 03:09:43.85+04	2010-09-19 03:09:43.85+04
b5da01b8-c720-4786-8118-0b710872382a	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:43.851+04	2010-09-19 03:09:43.851+04
57da69ea-5331-45ca-8bfe-9ea546d794c3	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	з/ Экономика	з/ Экономика		2010-09-19 03:09:43.852+04	2010-09-19 03:09:43.852+04
2f2a8f60-132a-4544-8d2d-5f6713ceeb2a	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:43.853+04	2010-09-19 03:09:43.853+04
f117003a-af02-4a15-b2dd-670fea7585de	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:43.855+04	2010-09-19 03:09:43.855+04
5d9c3b24-00ad-4ddd-a162-fdf4c9391fe6	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	д/ Техника	д/ Техника		2010-09-19 03:09:43.856+04	2010-09-19 03:09:43.856+04
9467432b-3272-46e1-9758-a9e217985db7	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:43.857+04	2010-09-19 03:09:43.857+04
b0f67c5b-4580-4770-a60c-261221b31a32	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	ч/ Анонс	ч/ Анонс		2010-09-19 03:09:43.858+04	2010-09-19 03:09:43.858+04
7fe1937f-cdf4-423c-b0d5-debc65015f3f	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	н/ Без границ	н/ Без границ		2010-09-19 03:09:43.86+04	2010-09-19 03:09:43.86+04
805ae3c3-4d58-4b99-b8c1-e2464aca74e9	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:43.861+04	2010-09-19 03:09:43.861+04
d0f1a720-9c82-4eba-baeb-68b5b8f0ba3a	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:43.862+04	2010-09-19 03:09:43.862+04
2eb5bb30-e21e-41d3-962a-06a8baf14d69	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	01/ ОБЛОЖКА	01/ ОБЛОЖКА		2010-09-19 03:09:43.864+04	2010-09-19 03:09:43.864+04
7d6655b1-5e20-446e-bfc1-40a507505582	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	02/ Крупным планом	02/ Крупным планом		2010-09-19 03:09:43.865+04	2010-09-19 03:09:43.865+04
00000000-0000-0000-0000-000000000000	7760f777-bd78-4167-8647-c7d5f3232fc1	Not found	Not found		2010-09-19 03:09:43.872+04	2010-09-19 03:09:43.872+04
d25eb967-aaee-4522-8b4d-c57459b2b2c3	7760f777-bd78-4167-8647-c7d5f3232fc1	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:43.877+04	2010-09-19 03:09:43.877+04
6d6bc60f-bb2d-4ecb-a054-7a1aa84590df	7760f777-bd78-4167-8647-c7d5f3232fc1	04/ НОВОСТИ	04/ НОВОСТИ		2010-09-19 03:09:43.878+04	2010-09-19 03:09:43.878+04
475378d1-4bbe-456b-b7b3-48e9ecb1e429	7760f777-bd78-4167-8647-c7d5f3232fc1	03/ Содержание	03/ Содержание		2010-09-19 03:09:43.879+04	2010-09-19 03:09:43.879+04
9da05598-4d4d-4c01-ae52-94d4aec5ab61	7760f777-bd78-4167-8647-c7d5f3232fc1	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:43.881+04	2010-09-19 03:09:43.881+04
fa8a94b3-a957-4036-ba56-2c2a5c2a65cb	7760f777-bd78-4167-8647-c7d5f3232fc1	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:43.882+04	2010-09-19 03:09:43.882+04
67c17bab-a09d-48e6-95e0-f9d772427ef6	7760f777-bd78-4167-8647-c7d5f3232fc1	б/ Курьер	б/ Курьер		2010-09-19 03:09:43.883+04	2010-09-19 03:09:43.883+04
71f4a649-192b-406a-bc82-75f6f0494aba	7760f777-bd78-4167-8647-c7d5f3232fc1	к/ Спорт	к/ Спорт		2010-09-19 03:09:43.884+04	2010-09-19 03:09:43.884+04
0ac9530d-fedf-4a93-a31a-3a1f1f14e6f8	7760f777-bd78-4167-8647-c7d5f3232fc1	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:43.886+04	2010-09-19 03:09:43.886+04
839c2d0a-179c-4e17-91e4-0b8238067717	7760f777-bd78-4167-8647-c7d5f3232fc1	з/ Экономика	з/ Экономика		2010-09-19 03:09:43.887+04	2010-09-19 03:09:43.887+04
e4427615-97ce-4667-b71f-71cf1419b0f4	7760f777-bd78-4167-8647-c7d5f3232fc1	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:43.888+04	2010-09-19 03:09:43.888+04
0917c949-6585-48ec-9539-b5c6d7efea35	7760f777-bd78-4167-8647-c7d5f3232fc1	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:43.889+04	2010-09-19 03:09:43.889+04
ec20904a-365f-4199-a89b-f177d68c2251	7760f777-bd78-4167-8647-c7d5f3232fc1	д/ Техника	д/ Техника		2010-09-19 03:09:43.891+04	2010-09-19 03:09:43.891+04
6d91e81d-f496-40a1-b94d-bebf1bddf947	7760f777-bd78-4167-8647-c7d5f3232fc1	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:43.892+04	2010-09-19 03:09:43.892+04
cfecc941-b192-41a9-8410-b04d2e0e15e7	7760f777-bd78-4167-8647-c7d5f3232fc1	ч/ Анонс	ч/ Анонс		2010-09-19 03:09:43.893+04	2010-09-19 03:09:43.893+04
029a3c27-aaf4-4650-88ac-f547a20998f2	7760f777-bd78-4167-8647-c7d5f3232fc1	н/ Без границ	н/ Без границ		2010-09-19 03:09:43.894+04	2010-09-19 03:09:43.894+04
1dbed8e5-81e6-480e-9f0c-1b62818f3234	7760f777-bd78-4167-8647-c7d5f3232fc1	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:43.895+04	2010-09-19 03:09:43.895+04
40c2a7d0-313c-43a2-afbd-d499f33145b0	7760f777-bd78-4167-8647-c7d5f3232fc1	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:43.896+04	2010-09-19 03:09:43.896+04
878b1264-9590-4160-9bb9-691af0edd2fa	7760f777-bd78-4167-8647-c7d5f3232fc1	01/ ОБЛОЖКА	01/ ОБЛОЖКА		2010-09-19 03:09:43.898+04	2010-09-19 03:09:43.898+04
55f47ec1-68c7-49df-a95e-b438bc48bab4	7760f777-bd78-4167-8647-c7d5f3232fc1	02/ Крупным планом	02/ Крупным планом		2010-09-19 03:09:43.899+04	2010-09-19 03:09:43.899+04
27d038db-2d36-462a-b4d5-d078932deaee	7760f777-bd78-4167-8647-c7d5f3232fc1	test3	test3		2010-09-19 03:09:43.9+04	2010-09-19 03:09:43.9+04
00000000-0000-0000-0000-000000000000	0eac0aab-6534-4000-bd46-4f0e85c60847	Not found	Not found		2010-09-19 03:09:43.987+04	2010-09-19 03:09:43.987+04
83094210-2a3e-407f-a6c1-de9ea353665e	0eac0aab-6534-4000-bd46-4f0e85c60847	Раздел не указан	Раздел не указан		2010-09-19 03:09:43.992+04	2010-09-19 03:09:43.992+04
0aa2c942-3d38-45af-9545-7256a3bf4c84	0eac0aab-6534-4000-bd46-4f0e85c60847	Тесты	Тесты		2010-09-19 03:09:43.993+04	2010-09-19 03:09:43.993+04
1cf3f24d-f2e2-4332-a19a-d32331e22dc2	0eac0aab-6534-4000-bd46-4f0e85c60847	Новости	Новости		2010-09-19 03:09:43.995+04	2010-09-19 03:09:43.995+04
7c47b5a0-074a-4d01-a711-86241306ed03	0eac0aab-6534-4000-bd46-4f0e85c60847	Анонс	Анонс		2010-09-19 03:09:43.996+04	2010-09-19 03:09:43.996+04
7d5905de-c993-4d61-a5f7-fbc08ac5e7ff	0eac0aab-6534-4000-bd46-4f0e85c60847	История	История		2010-09-19 03:09:43.997+04	2010-09-19 03:09:43.997+04
2f239d88-d755-477e-b564-2b008c63abf2	0eac0aab-6534-4000-bd46-4f0e85c60847	Спорт	Спорт		2010-09-19 03:09:43.998+04	2010-09-19 03:09:43.998+04
0bbf0950-b279-4c8d-8956-2137f1d96780	0eac0aab-6534-4000-bd46-4f0e85c60847	Ремзона	Ремзона		2010-09-19 03:09:43.999+04	2010-09-19 03:09:43.999+04
eb0f184a-94cb-40c3-b49d-9da862ce3b1b	0eac0aab-6534-4000-bd46-4f0e85c60847	Мотоклуб	Мотоклуб		2010-09-19 03:09:44.001+04	2010-09-19 03:09:44.001+04
a3d0dd78-2312-4ddf-a185-9e6ed8b4e0ac	0eac0aab-6534-4000-bd46-4f0e85c60847	Рынок	Рынок		2010-09-19 03:09:44.002+04	2010-09-19 03:09:44.002+04
fef2ee0a-c07d-41c2-bd67-764f263c866c	0eac0aab-6534-4000-bd46-4f0e85c60847	Реклама	Реклама		2010-09-19 03:09:44.003+04	2010-09-19 03:09:44.003+04
34a9e883-9aaf-46fc-a218-10afaae15f4a	0eac0aab-6534-4000-bd46-4f0e85c60847	Обложка	Обложка		2010-09-19 03:09:44.005+04	2010-09-19 03:09:44.005+04
ba2391e2-9307-48b3-943c-b5ae961519f6	0eac0aab-6534-4000-bd46-4f0e85c60847	Техника	Техника		2010-09-19 03:09:44.006+04	2010-09-19 03:09:44.006+04
79d65235-2e67-4ecf-b966-a17727c058f5	0eac0aab-6534-4000-bd46-4f0e85c60847	Содержание	Содержание		2010-09-19 03:09:44.007+04	2010-09-19 03:09:44.007+04
00000000-0000-0000-0000-000000000000	58771368-ca78-49f1-95c2-35e2b9873c6c	Not found	Not found		2010-09-19 03:09:44.017+04	2010-09-19 03:09:44.017+04
c7f29ec5-b3a5-4a44-aea7-1a448382da5e	58771368-ca78-49f1-95c2-35e2b9873c6c	Тесты	Тесты		2010-09-19 03:09:44.022+04	2010-09-19 03:09:44.022+04
e50b8dc6-750e-49d4-9dac-2065258c3a2a	58771368-ca78-49f1-95c2-35e2b9873c6c	Новости	Новости		2010-09-19 03:09:44.023+04	2010-09-19 03:09:44.023+04
21f4f3a7-d335-43fe-8177-0da25303df41	58771368-ca78-49f1-95c2-35e2b9873c6c	Анонс	Анонс		2010-09-19 03:09:44.024+04	2010-09-19 03:09:44.024+04
8983fc35-2cda-4aac-88b6-d889d90465fc	58771368-ca78-49f1-95c2-35e2b9873c6c	Спорт	Спорт		2010-09-19 03:09:44.026+04	2010-09-19 03:09:44.026+04
c135a712-cfaa-4675-baa2-0ab27dfad593	58771368-ca78-49f1-95c2-35e2b9873c6c	Ремзона	Ремзона		2010-09-19 03:09:44.027+04	2010-09-19 03:09:44.027+04
3556f4ab-ea46-4422-a3ef-1cfe4028858d	58771368-ca78-49f1-95c2-35e2b9873c6c	Мотоклуб	Мотоклуб		2010-09-19 03:09:44.028+04	2010-09-19 03:09:44.028+04
87acbea2-ee39-42bc-8b62-1d91cf173672	58771368-ca78-49f1-95c2-35e2b9873c6c	Рынок	Рынок		2010-09-19 03:09:44.029+04	2010-09-19 03:09:44.029+04
36bafe07-b7a1-44b3-aa7b-0fb6f62e3d75	58771368-ca78-49f1-95c2-35e2b9873c6c	Реклама	Реклама		2010-09-19 03:09:44.031+04	2010-09-19 03:09:44.031+04
591bfe86-3377-4e63-af49-c5e20ed0e880	58771368-ca78-49f1-95c2-35e2b9873c6c	Обложка	Обложка		2010-09-19 03:09:44.032+04	2010-09-19 03:09:44.032+04
2db34dbf-d004-4585-a06c-64336097ef2d	58771368-ca78-49f1-95c2-35e2b9873c6c	Техника	Техника		2010-09-19 03:09:44.033+04	2010-09-19 03:09:44.033+04
e8341867-f49a-4040-a74c-28cdf0fa57dd	58771368-ca78-49f1-95c2-35e2b9873c6c	Содержание	Содержание		2010-09-19 03:09:44.034+04	2010-09-19 03:09:44.034+04
00000000-0000-0000-0000-000000000000	d162b81c-94ef-425b-a04f-54818fffe63a	Not found	Not found		2010-09-19 03:09:44.041+04	2010-09-19 03:09:44.041+04
e590b10b-dc3b-4ed3-9462-9e31fb389c3b	d162b81c-94ef-425b-a04f-54818fffe63a	Содержание	Содержание		2010-09-19 03:09:44.045+04	2010-09-19 03:09:44.045+04
e41422e2-3425-4a4b-b566-6a725dcd3954	d162b81c-94ef-425b-a04f-54818fffe63a	Без раздела	Без раздела		2010-09-19 03:09:44.047+04	2010-09-19 03:09:44.047+04
baec765f-ba6e-4aaf-9de6-306cc414a319	d162b81c-94ef-425b-a04f-54818fffe63a	Экономика	Экономика		2010-09-19 03:09:44.048+04	2010-09-19 03:09:44.048+04
48846653-af42-48d0-9c16-fb163f0cb676	d162b81c-94ef-425b-a04f-54818fffe63a	Главная тема	Главная тема		2010-09-19 03:09:44.05+04	2010-09-19 03:09:44.05+04
6a02e89a-8f0b-484d-b42e-633d4e5073fd	d162b81c-94ef-425b-a04f-54818fffe63a	Спецпроект	Спецпроект		2010-09-19 03:09:44.051+04	2010-09-19 03:09:44.051+04
42f74d43-a1ca-49bd-9b1c-751792f030a9	d162b81c-94ef-425b-a04f-54818fffe63a	Автомобили	Автомобили		2010-09-19 03:09:44.052+04	2010-09-19 03:09:44.052+04
ede45639-f357-45af-beeb-ec7bb9f4edf7	d162b81c-94ef-425b-a04f-54818fffe63a	Выставка	Выставка		2010-09-19 03:09:44.054+04	2010-09-19 03:09:44.054+04
fa35ae85-ad7c-42a3-a75b-037d3c5932a7	d162b81c-94ef-425b-a04f-54818fffe63a	Спецтехника	Спецтехника		2010-09-19 03:09:44.055+04	2010-09-19 03:09:44.055+04
690e36e6-3d1b-4cce-ad2a-0377d65b704c	d162b81c-94ef-425b-a04f-54818fffe63a	Автобаза	Автобаза		2010-09-19 03:09:44.056+04	2010-09-19 03:09:44.056+04
24425340-9c9e-4713-be7b-3d7cae0a79e1	d162b81c-94ef-425b-a04f-54818fffe63a	Реклама	Реклама		2010-09-19 03:09:44.057+04	2010-09-19 03:09:44.057+04
884611cb-2e83-4f39-835e-16326f1f715a	d162b81c-94ef-425b-a04f-54818fffe63a	РЕКЛАМА	РЕКЛАМА		2010-09-19 03:09:44.058+04	2010-09-19 03:09:44.058+04
00000000-0000-0000-0000-000000000000	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Not found	Not found		2010-09-19 03:09:44.116+04	2010-09-19 03:09:44.116+04
f48ab548-68fb-4de7-97e5-804b73bb5d07	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Содержание	Содержание		2010-09-19 03:09:44.121+04	2010-09-19 03:09:44.121+04
6fb01421-e032-45bd-ae92-e3a70d88c17b	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Без раздела	Без раздела		2010-09-19 03:09:44.122+04	2010-09-19 03:09:44.122+04
98c237aa-441e-49a3-997d-0bc22fba07cd	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Экономика	Экономика		2010-09-19 03:09:44.124+04	2010-09-19 03:09:44.124+04
7fed92fc-7240-44ff-8a5e-edf3a0d6f01c	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Главная тема	Главная тема		2010-09-19 03:09:44.125+04	2010-09-19 03:09:44.125+04
9fe45981-f5cc-4b90-b853-935fce2e7b5d	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Спецпроект	Спецпроект		2010-09-19 03:09:44.127+04	2010-09-19 03:09:44.127+04
0c99a13e-1529-4130-ba6b-c3e88fe6f6f9	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Автомобили	Автомобили		2010-09-19 03:09:44.128+04	2010-09-19 03:09:44.128+04
74d1ca89-29b5-4d04-a7c3-efb19f6ba812	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Выставка	Выставка		2010-09-19 03:09:44.129+04	2010-09-19 03:09:44.129+04
6a3b1f9c-c4b8-4f3f-9738-69dde90f98a0	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Спецтехника	Спецтехника		2010-09-19 03:09:44.131+04	2010-09-19 03:09:44.131+04
af9350e0-bd10-4a84-b3f6-fe48097afa39	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Автобаза	Автобаза		2010-09-19 03:09:44.132+04	2010-09-19 03:09:44.132+04
ab6cb02d-7f16-4362-a0e1-adfc11e3870d	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	Реклама	Реклама		2010-09-19 03:09:44.133+04	2010-09-19 03:09:44.133+04
fe21b723-4e02-470d-a5b6-8b40b877d394	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	РЕКЛАМА	РЕКЛАМА		2010-09-19 03:09:44.134+04	2010-09-19 03:09:44.134+04
00000000-0000-0000-0000-000000000000	64e1b37e-eb7a-4201-b427-bb210bdf3736	Not found	Not found		2010-09-19 03:09:44.225+04	2010-09-19 03:09:44.225+04
e9071818-0f52-4a8b-a003-34e9849e24de	64e1b37e-eb7a-4201-b427-bb210bdf3736	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:44.23+04	2010-09-19 03:09:44.23+04
edf0c78e-a525-4bec-8278-bcbcdfb6bf2d	64e1b37e-eb7a-4201-b427-bb210bdf3736	04/ НОВОСТИ	04/ НОВОСТИ		2010-09-19 03:09:44.233+04	2010-09-19 03:09:44.233+04
19844c2b-89a3-4410-a922-761a13a4c5cb	64e1b37e-eb7a-4201-b427-bb210bdf3736	03/ Содержание	03/ Содержание		2010-09-19 03:09:44.234+04	2010-09-19 03:09:44.234+04
7cb7e532-6bf7-47d8-883e-ac4c626ae83a	64e1b37e-eb7a-4201-b427-bb210bdf3736	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:44.236+04	2010-09-19 03:09:44.236+04
4fa1826e-01e4-4e57-9ffb-a4440bd297b2	64e1b37e-eb7a-4201-b427-bb210bdf3736	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:44.237+04	2010-09-19 03:09:44.237+04
127f79ed-47f3-4224-ae55-632fc4bc484e	64e1b37e-eb7a-4201-b427-bb210bdf3736	б/ Курьер	б/ Курьер		2010-09-19 03:09:44.238+04	2010-09-19 03:09:44.238+04
71215522-650f-4154-93df-e030d15138ae	64e1b37e-eb7a-4201-b427-bb210bdf3736	к/ Спорт	к/ Спорт		2010-09-19 03:09:44.239+04	2010-09-19 03:09:44.239+04
7de47d31-ac4a-451f-bcef-429625dbaa67	64e1b37e-eb7a-4201-b427-bb210bdf3736	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:44.24+04	2010-09-19 03:09:44.24+04
3579b2f7-f2ab-4407-b509-60b078a6cbc7	64e1b37e-eb7a-4201-b427-bb210bdf3736	з/ Экономика	з/ Экономика		2010-09-19 03:09:44.242+04	2010-09-19 03:09:44.242+04
ef3d091d-9b42-4d01-b6f1-d13aaa015447	64e1b37e-eb7a-4201-b427-bb210bdf3736	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:44.243+04	2010-09-19 03:09:44.243+04
029f1972-5422-47e6-9466-f7fa4a24329b	64e1b37e-eb7a-4201-b427-bb210bdf3736	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:44.244+04	2010-09-19 03:09:44.244+04
ee613dad-7e8f-4ec6-82e9-705d262f47de	64e1b37e-eb7a-4201-b427-bb210bdf3736	д/ Техника	д/ Техника		2010-09-19 03:09:44.245+04	2010-09-19 03:09:44.245+04
a4a130dc-8579-4165-b9c9-afdeea694d29	64e1b37e-eb7a-4201-b427-bb210bdf3736	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:44.247+04	2010-09-19 03:09:44.247+04
4b5038b2-13ee-4c97-ab8e-5af42c2b6eb6	64e1b37e-eb7a-4201-b427-bb210bdf3736	ч/ Анонс	ч/ Анонс		2010-09-19 03:09:44.248+04	2010-09-19 03:09:44.248+04
65970174-e7d9-41ea-b429-4e70c671bc2d	64e1b37e-eb7a-4201-b427-bb210bdf3736	н/ Без границ	н/ Без границ		2010-09-19 03:09:44.249+04	2010-09-19 03:09:44.249+04
9e93327a-66bc-4923-a3f2-7685827026e4	64e1b37e-eb7a-4201-b427-bb210bdf3736	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:44.25+04	2010-09-19 03:09:44.25+04
92bd7c7e-c6ba-414a-9e99-2c446b3a98d1	64e1b37e-eb7a-4201-b427-bb210bdf3736	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:44.251+04	2010-09-19 03:09:44.251+04
63c52313-4f09-4470-a39a-0a59199e2049	64e1b37e-eb7a-4201-b427-bb210bdf3736	01/ ОБЛОЖКА	01/ ОБЛОЖКА		2010-09-19 03:09:44.253+04	2010-09-19 03:09:44.253+04
485557a5-e122-4595-ac1c-76dd1af786e4	64e1b37e-eb7a-4201-b427-bb210bdf3736	02/ Крупным планом	02/ Крупным планом		2010-09-19 03:09:44.254+04	2010-09-19 03:09:44.254+04
00000000-0000-0000-0000-000000000000	9a96554f-2f94-4af5-9fd1-116736efc27a	Not found	Not found		2010-09-19 03:09:44.261+04	2010-09-19 03:09:44.261+04
84c0b23a-5226-4f5d-aea6-37814b16acb2	9a96554f-2f94-4af5-9fd1-116736efc27a	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:44.267+04	2010-09-19 03:09:44.267+04
79c94867-3a67-40e0-a59e-418359848584	9a96554f-2f94-4af5-9fd1-116736efc27a	04/ НОВОСТИ	04/ НОВОСТИ		2010-09-19 03:09:44.268+04	2010-09-19 03:09:44.268+04
1af12d5a-cf86-42f1-9b6d-8e83bc4da217	9a96554f-2f94-4af5-9fd1-116736efc27a	03/ Содержание	03/ Содержание		2010-09-19 03:09:44.269+04	2010-09-19 03:09:44.269+04
f3d23ac4-37ba-40d4-8d29-757ab49f4254	9a96554f-2f94-4af5-9fd1-116736efc27a	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:44.271+04	2010-09-19 03:09:44.271+04
40d73146-9c34-4922-bbe0-4b5db48abaac	9a96554f-2f94-4af5-9fd1-116736efc27a	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:44.272+04	2010-09-19 03:09:44.272+04
863e779a-7509-40ea-a747-630de989704f	9a96554f-2f94-4af5-9fd1-116736efc27a	б/ Курьер	б/ Курьер		2010-09-19 03:09:44.273+04	2010-09-19 03:09:44.273+04
2c184627-cf2a-4a51-a316-862cd1e0c7f9	9a96554f-2f94-4af5-9fd1-116736efc27a	к/ Спорт	к/ Спорт		2010-09-19 03:09:44.274+04	2010-09-19 03:09:44.274+04
f2abaa89-6f33-435b-925d-93af0728fb5d	9a96554f-2f94-4af5-9fd1-116736efc27a	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:44.276+04	2010-09-19 03:09:44.276+04
e09438f1-3500-46ec-8926-32cc24cf31d5	9a96554f-2f94-4af5-9fd1-116736efc27a	з/ Экономика	з/ Экономика		2010-09-19 03:09:44.277+04	2010-09-19 03:09:44.277+04
b36704d7-c62e-4e23-8662-273ea35f4823	9a96554f-2f94-4af5-9fd1-116736efc27a	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:44.278+04	2010-09-19 03:09:44.278+04
0b9650bc-9d77-46ae-b128-9d9d77c65f2a	9a96554f-2f94-4af5-9fd1-116736efc27a	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:44.279+04	2010-09-19 03:09:44.279+04
6d3c3995-8e36-4873-9fb3-5a331b6a8357	9a96554f-2f94-4af5-9fd1-116736efc27a	д/ Техника	д/ Техника		2010-09-19 03:09:44.28+04	2010-09-19 03:09:44.28+04
bb51ecd3-22a3-482e-8010-ad3d79bac21c	9a96554f-2f94-4af5-9fd1-116736efc27a	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:44.282+04	2010-09-19 03:09:44.282+04
d7a6a0f9-034c-45f1-a5da-64872d8c0837	9a96554f-2f94-4af5-9fd1-116736efc27a	ч/ Анонс	ч/ Анонс		2010-09-19 03:09:44.283+04	2010-09-19 03:09:44.283+04
92c67604-3f1b-4316-8a8a-5f90e0291e0e	9a96554f-2f94-4af5-9fd1-116736efc27a	н/ Без границ	н/ Без границ		2010-09-19 03:09:44.284+04	2010-09-19 03:09:44.284+04
d8de4cce-b4a1-435a-bf70-c5c2f22a767f	9a96554f-2f94-4af5-9fd1-116736efc27a	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:44.285+04	2010-09-19 03:09:44.285+04
164a233a-4882-43e4-9636-d1089985909b	9a96554f-2f94-4af5-9fd1-116736efc27a	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:44.286+04	2010-09-19 03:09:44.286+04
25473b9e-ef6c-4c7f-a5fd-a1c9b2fcb376	9a96554f-2f94-4af5-9fd1-116736efc27a	01/ ОБЛОЖКА	01/ ОБЛОЖКА		2010-09-19 03:09:44.287+04	2010-09-19 03:09:44.287+04
8376b5b5-f46f-476b-812a-e605a23ec8e5	9a96554f-2f94-4af5-9fd1-116736efc27a	02/ Крупным планом	02/ Крупным планом		2010-09-19 03:09:44.289+04	2010-09-19 03:09:44.289+04
00000000-0000-0000-0000-000000000000	953eea94-1899-4aa1-bacb-7cb19bf373cb	Not found	Not found		2010-09-19 03:09:44.386+04	2010-09-19 03:09:44.386+04
f5ac7c36-ac3c-4492-973d-8b516f13abca	953eea94-1899-4aa1-bacb-7cb19bf373cb	Содержание	Содержание		2010-09-19 03:09:44.391+04	2010-09-19 03:09:44.391+04
5bd66d2f-2d98-4a7a-8e3f-1b016be74340	953eea94-1899-4aa1-bacb-7cb19bf373cb	Без раздела	Без раздела		2010-09-19 03:09:44.392+04	2010-09-19 03:09:44.392+04
b9edd57a-f5fa-429a-8b9a-225d53153eab	953eea94-1899-4aa1-bacb-7cb19bf373cb	Экономика	Экономика		2010-09-19 03:09:44.394+04	2010-09-19 03:09:44.394+04
ca06ecbf-3abb-4833-ad35-f8f78244c727	953eea94-1899-4aa1-bacb-7cb19bf373cb	Главная тема	Главная тема		2010-09-19 03:09:44.396+04	2010-09-19 03:09:44.396+04
ab817fc7-13d9-4ec5-aa0b-f9c4528773f9	953eea94-1899-4aa1-bacb-7cb19bf373cb	Спецпроект	Спецпроект		2010-09-19 03:09:44.397+04	2010-09-19 03:09:44.397+04
2672361a-6e98-4291-abba-e9e401448068	953eea94-1899-4aa1-bacb-7cb19bf373cb	Автомобили	Автомобили		2010-09-19 03:09:44.399+04	2010-09-19 03:09:44.399+04
153422f8-f19e-4f1b-8a62-87cc2be54ff4	953eea94-1899-4aa1-bacb-7cb19bf373cb	Выставка	Выставка		2010-09-19 03:09:44.401+04	2010-09-19 03:09:44.401+04
47a017f0-eb7f-433a-b759-2952653d4a84	953eea94-1899-4aa1-bacb-7cb19bf373cb	Спецтехника	Спецтехника		2010-09-19 03:09:44.402+04	2010-09-19 03:09:44.402+04
99535657-8b98-4102-b933-c403fb9979ae	953eea94-1899-4aa1-bacb-7cb19bf373cb	Автобаза	Автобаза		2010-09-19 03:09:44.403+04	2010-09-19 03:09:44.403+04
502c5588-0808-4059-81e0-46de4153fad6	953eea94-1899-4aa1-bacb-7cb19bf373cb	Реклама	Реклама		2010-09-19 03:09:44.404+04	2010-09-19 03:09:44.404+04
1b5a55d1-f75d-4425-b55c-1de6eefa9dc0	953eea94-1899-4aa1-bacb-7cb19bf373cb	РЕКЛАМА	РЕКЛАМА		2010-09-19 03:09:44.406+04	2010-09-19 03:09:44.406+04
9100185a-01b1-4267-ba7a-54a1d7458708	848f7187-6099-459d-83b6-46213bc811db	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:44.42+04	2010-09-19 03:09:44.42+04
5a929401-bb69-4e0f-866d-47de48a97151	848f7187-6099-459d-83b6-46213bc811db	04/ НОВОСТИ	04/ НОВОСТИ		2010-09-19 03:09:44.423+04	2010-09-19 03:09:44.423+04
8f2a20b1-df6e-4f68-9c84-4c28c8c6ffef	848f7187-6099-459d-83b6-46213bc811db	03/ Содержание	03/ Содержание		2010-09-19 03:09:44.424+04	2010-09-19 03:09:44.424+04
e16a3e92-fad4-497d-a67a-d1144f5d45cd	848f7187-6099-459d-83b6-46213bc811db	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:44.425+04	2010-09-19 03:09:44.425+04
c0def467-107d-42d5-9446-4606bd943669	848f7187-6099-459d-83b6-46213bc811db	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:44.426+04	2010-09-19 03:09:44.426+04
322fa50b-e558-4af4-bf79-5cd91023e043	848f7187-6099-459d-83b6-46213bc811db	б/ Курьер	б/ Курьер		2010-09-19 03:09:44.428+04	2010-09-19 03:09:44.428+04
88223066-1eca-4641-af14-0ee65fbe574e	848f7187-6099-459d-83b6-46213bc811db	к/ Спорт	к/ Спорт		2010-09-19 03:09:44.429+04	2010-09-19 03:09:44.429+04
e694c80c-c96e-4913-a8bc-b6ce61b7889c	848f7187-6099-459d-83b6-46213bc811db	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:44.43+04	2010-09-19 03:09:44.43+04
506a2068-a496-447d-bbea-e630c0485dbd	848f7187-6099-459d-83b6-46213bc811db	з/ Экономика	з/ Экономика		2010-09-19 03:09:44.432+04	2010-09-19 03:09:44.432+04
3d4af50e-81a3-4dbf-8bd1-bbfb77158dd5	848f7187-6099-459d-83b6-46213bc811db	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:44.433+04	2010-09-19 03:09:44.433+04
a3d3ea3e-ee8a-4573-af95-b40769b27ae0	848f7187-6099-459d-83b6-46213bc811db	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:44.434+04	2010-09-19 03:09:44.434+04
b45815fb-bd67-4242-94f3-2c512e8ea06a	848f7187-6099-459d-83b6-46213bc811db	д/ Техника	д/ Техника		2010-09-19 03:09:44.435+04	2010-09-19 03:09:44.435+04
46e53bf1-a82e-4aff-9d5c-f7cd8a9ef579	848f7187-6099-459d-83b6-46213bc811db	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:44.437+04	2010-09-19 03:09:44.437+04
dde7241a-9771-4819-a41c-4b94d5a2a08a	848f7187-6099-459d-83b6-46213bc811db	ч/ Анонс	ч/ Анонс		2010-09-19 03:09:44.438+04	2010-09-19 03:09:44.438+04
5a824b7e-85e0-435a-9e95-5457525488e7	848f7187-6099-459d-83b6-46213bc811db	н/ Без границ	н/ Без границ		2010-09-19 03:09:44.439+04	2010-09-19 03:09:44.439+04
3c2ebac2-27d8-4c83-b72e-fd93620b7f7e	848f7187-6099-459d-83b6-46213bc811db	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:44.441+04	2010-09-19 03:09:44.441+04
c1bb127f-1293-4a62-b2c5-bc17a246b073	848f7187-6099-459d-83b6-46213bc811db	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:44.442+04	2010-09-19 03:09:44.442+04
53ad1520-8872-4c43-ab77-16514a547bed	848f7187-6099-459d-83b6-46213bc811db	01/ ОБЛОЖКА	01/ ОБЛОЖКА		2010-09-19 03:09:44.444+04	2010-09-19 03:09:44.444+04
9cfbe5f8-b57d-4532-a532-dd6b6fb64a13	848f7187-6099-459d-83b6-46213bc811db	02/ Крупным планом	02/ Крупным планом		2010-09-19 03:09:44.445+04	2010-09-19 03:09:44.445+04
00000000-0000-0000-0000-000000000000	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Not found	Not found		2010-09-19 03:09:44.453+04	2010-09-19 03:09:44.453+04
c1180561-c8be-4ebd-9c61-d2fe5795aa3f	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Содержание	Содержание		2010-09-19 03:09:44.458+04	2010-09-19 03:09:44.458+04
92dcac68-8932-4fe8-847f-8924887dad55	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Без раздела	Без раздела		2010-09-19 03:09:44.459+04	2010-09-19 03:09:44.459+04
2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Экономика	Экономика		2010-09-19 03:09:44.46+04	2010-09-19 03:09:44.46+04
c15a3c2e-1697-4770-b664-826453fa3493	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Главная тема	Главная тема		2010-09-19 03:09:44.462+04	2010-09-19 03:09:44.462+04
8498c445-7385-419d-a3b0-7abb98985570	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Спецпроект	Спецпроект		2010-09-19 03:09:44.463+04	2010-09-19 03:09:44.463+04
b6dbf50d-f7f4-4db9-aa1a-f3904cf5a8bd	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Автомобили	Автомобили		2010-09-19 03:09:44.464+04	2010-09-19 03:09:44.464+04
4839c5cf-d937-4eec-8726-d9da6b85f2c1	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Выставка	Выставка		2010-09-19 03:09:44.466+04	2010-09-19 03:09:44.466+04
97591d66-3306-4a4f-bc4c-f8239c13bef4	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Спецтехника	Спецтехника		2010-09-19 03:09:44.467+04	2010-09-19 03:09:44.467+04
4900f4c3-8320-4768-8eea-cd638024e55f	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Автобаза	Автобаза		2010-09-19 03:09:44.468+04	2010-09-19 03:09:44.468+04
405b1013-6768-478d-b76f-04b6c309ed21	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	Реклама	Реклама		2010-09-19 03:09:44.47+04	2010-09-19 03:09:44.47+04
c7f82e39-a182-47b7-ab70-e165983276a9	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	РЕКЛАМА	РЕКЛАМА		2010-09-19 03:09:44.471+04	2010-09-19 03:09:44.471+04
00000000-0000-0000-0000-000000000000	4fd73209-568f-4349-9156-65714d0bdebe	Not found	Not found		2010-09-19 03:09:44.532+04	2010-09-19 03:09:44.532+04
fad23503-d904-43fa-a2c6-b054cf586a11	4fd73209-568f-4349-9156-65714d0bdebe	Содержание	Содержание		2010-09-19 03:09:44.536+04	2010-09-19 03:09:44.536+04
3dceba44-835f-4e61-ae8b-432b17dd1d88	4fd73209-568f-4349-9156-65714d0bdebe	Без раздела	Без раздела		2010-09-19 03:09:44.538+04	2010-09-19 03:09:44.538+04
8b3afe82-7559-4a77-89a3-6e2537bfac24	4fd73209-568f-4349-9156-65714d0bdebe	Экономика	Экономика		2010-09-19 03:09:44.583+04	2010-09-19 03:09:44.583+04
362273a6-e024-4140-b05b-cf67751f0aca	4fd73209-568f-4349-9156-65714d0bdebe	Главная тема	Главная тема		2010-09-19 03:09:44.694+04	2010-09-19 03:09:44.694+04
121906d7-2654-4696-8c7a-edc71f8ea6be	4fd73209-568f-4349-9156-65714d0bdebe	Спецпроект	Спецпроект		2010-09-19 03:09:44.717+04	2010-09-19 03:09:44.717+04
9090d8ed-c1a5-4485-aa81-9daa9f64dfa4	4fd73209-568f-4349-9156-65714d0bdebe	Автомобили	Автомобили		2010-09-19 03:09:44.776+04	2010-09-19 03:09:44.776+04
750f1d2e-4577-4f77-aaa6-dae0482c0a0d	4fd73209-568f-4349-9156-65714d0bdebe	Выставка	Выставка		2010-09-19 03:09:44.838+04	2010-09-19 03:09:44.838+04
e9430941-6430-47bc-a7fa-663e5c8995d2	4fd73209-568f-4349-9156-65714d0bdebe	Спецтехника	Спецтехника		2010-09-19 03:09:44.878+04	2010-09-19 03:09:44.878+04
dee64700-8926-4862-b3f3-2eeb0977884a	4fd73209-568f-4349-9156-65714d0bdebe	Автобаза	Автобаза		2010-09-19 03:09:44.881+04	2010-09-19 03:09:44.881+04
c0435eff-effb-4ddb-8b24-3a16510cd59a	4fd73209-568f-4349-9156-65714d0bdebe	Реклама	Реклама		2010-09-19 03:09:44.885+04	2010-09-19 03:09:44.885+04
00000000-0000-0000-0000-000000000000	deb6f461-5d5e-4302-87ea-7d446502b34e	Not found	Not found		2010-09-19 03:09:45.011+04	2010-09-19 03:09:45.011+04
f4bf3c8f-c871-47a6-87ec-3b1ac02efaf7	deb6f461-5d5e-4302-87ea-7d446502b34e	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:45.021+04	2010-09-19 03:09:45.021+04
84ce2e11-c775-4dfc-bec9-850c8d3d4907	deb6f461-5d5e-4302-87ea-7d446502b34e	04/ НОВОСТИ	04/ НОВОСТИ		2010-09-19 03:09:45.025+04	2010-09-19 03:09:45.025+04
1435102d-5bba-40ee-9447-663dc679e414	deb6f461-5d5e-4302-87ea-7d446502b34e	03/ Содержание	03/ Содержание		2010-09-19 03:09:45.027+04	2010-09-19 03:09:45.027+04
323a61c7-7f4f-4420-98cb-f81f738429cb	deb6f461-5d5e-4302-87ea-7d446502b34e	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:45.029+04	2010-09-19 03:09:45.029+04
43af09f0-7048-408c-a14e-6d8d59d1047f	deb6f461-5d5e-4302-87ea-7d446502b34e	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:45.031+04	2010-09-19 03:09:45.031+04
c83a2c61-e04b-4b03-a3ab-28d015e03191	deb6f461-5d5e-4302-87ea-7d446502b34e	б/ Курьер	б/ Курьер		2010-09-19 03:09:45.033+04	2010-09-19 03:09:45.033+04
4680df93-0152-4eb3-94c9-cade3c40ca62	deb6f461-5d5e-4302-87ea-7d446502b34e	к/ Спорт	к/ Спорт		2010-09-19 03:09:45.036+04	2010-09-19 03:09:45.036+04
bedca5b1-626d-41ba-8bcb-96348e378fc9	deb6f461-5d5e-4302-87ea-7d446502b34e	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:45.038+04	2010-09-19 03:09:45.038+04
0a68a814-8601-49ed-abf1-e5a70edb4d37	deb6f461-5d5e-4302-87ea-7d446502b34e	з/ Экономика	з/ Экономика		2010-09-19 03:09:45.04+04	2010-09-19 03:09:45.04+04
efc0e899-d41a-4d2d-9842-db9d55ff4c73	deb6f461-5d5e-4302-87ea-7d446502b34e	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:45.042+04	2010-09-19 03:09:45.042+04
d350724e-f8c9-4beb-adf3-34b41ec58686	deb6f461-5d5e-4302-87ea-7d446502b34e	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:45.044+04	2010-09-19 03:09:45.044+04
138a5506-66e9-4af0-8aae-93644e46f615	deb6f461-5d5e-4302-87ea-7d446502b34e	д/ Техника	д/ Техника		2010-09-19 03:09:45.047+04	2010-09-19 03:09:45.047+04
e987e8b1-800d-4602-a6e8-8d5e57d803e2	deb6f461-5d5e-4302-87ea-7d446502b34e	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:45.05+04	2010-09-19 03:09:45.05+04
d425c1fc-200b-4cfe-b8a7-55f778210388	deb6f461-5d5e-4302-87ea-7d446502b34e	ч/ Анонс	ч/ Анонс		2010-09-19 03:09:45.052+04	2010-09-19 03:09:45.052+04
bdb3e129-2b43-40cc-a901-ccfd847c5aea	deb6f461-5d5e-4302-87ea-7d446502b34e	н/ Без границ	н/ Без границ		2010-09-19 03:09:45.054+04	2010-09-19 03:09:45.054+04
b7841eb2-2507-4ea9-a0ca-edc8f4c6bc7d	deb6f461-5d5e-4302-87ea-7d446502b34e	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:45.057+04	2010-09-19 03:09:45.057+04
c1dae0ac-e163-40c0-896f-3cd3c32ec8d5	deb6f461-5d5e-4302-87ea-7d446502b34e	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:45.06+04	2010-09-19 03:09:45.06+04
93b65bbb-2461-4b7e-87e5-bc28dfa9378c	deb6f461-5d5e-4302-87ea-7d446502b34e	01/ ОБЛОЖКА	01/ ОБЛОЖКА		2010-09-19 03:09:45.062+04	2010-09-19 03:09:45.062+04
a21a453d-edad-44ed-af73-5feb7f1e0df3	deb6f461-5d5e-4302-87ea-7d446502b34e	02/ Крупным планом	02/ Крупным планом		2010-09-19 03:09:45.064+04	2010-09-19 03:09:45.064+04
00000000-0000-0000-0000-000000000000	77c71b8e-b229-4794-8a53-01b79ea8ba1b	Not found	Not found		2010-09-19 03:09:45.249+04	2010-09-19 03:09:45.249+04
e323f336-eab2-44de-8049-5f8a56a5d937	77c71b8e-b229-4794-8a53-01b79ea8ba1b	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:45.259+04	2010-09-19 03:09:45.259+04
8090d985-f9dc-4fc0-a14a-4e1ad634dad4	77c71b8e-b229-4794-8a53-01b79ea8ba1b	04/ НОВОСТИ	04/ НОВОСТИ		2010-09-19 03:09:45.261+04	2010-09-19 03:09:45.261+04
b7017600-89c5-4b70-b655-82db747a84d1	77c71b8e-b229-4794-8a53-01b79ea8ba1b	03/ Содержание	03/ Содержание		2010-09-19 03:09:45.263+04	2010-09-19 03:09:45.263+04
f702193a-3878-42dd-98a9-3e69d98ad545	77c71b8e-b229-4794-8a53-01b79ea8ba1b	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:45.266+04	2010-09-19 03:09:45.266+04
fd46de01-5fdd-4d5e-91cf-bebf0c776bd6	77c71b8e-b229-4794-8a53-01b79ea8ba1b	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:45.269+04	2010-09-19 03:09:45.269+04
6e075652-2c8e-4493-a658-a3a053776bb5	77c71b8e-b229-4794-8a53-01b79ea8ba1b	б/ Курьер	б/ Курьер		2010-09-19 03:09:45.272+04	2010-09-19 03:09:45.272+04
ac712d3c-e001-4c5b-a8a9-346b437d14dd	77c71b8e-b229-4794-8a53-01b79ea8ba1b	к/ Спорт	к/ Спорт		2010-09-19 03:09:45.274+04	2010-09-19 03:09:45.274+04
a39fcaf1-c958-4c76-a50a-3706bfda0bfd	77c71b8e-b229-4794-8a53-01b79ea8ba1b	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:45.277+04	2010-09-19 03:09:45.277+04
626ae9d4-5033-4244-93cf-429b6a745a22	77c71b8e-b229-4794-8a53-01b79ea8ba1b	з/ Экономика	з/ Экономика		2010-09-19 03:09:45.28+04	2010-09-19 03:09:45.28+04
86b79f79-009d-44c7-a01b-c2da7797645e	77c71b8e-b229-4794-8a53-01b79ea8ba1b	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:45.283+04	2010-09-19 03:09:45.283+04
911d696a-8b50-440e-a892-7c2e5f5894b3	77c71b8e-b229-4794-8a53-01b79ea8ba1b	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:45.285+04	2010-09-19 03:09:45.285+04
8d522137-a83e-4917-9f10-99493216cc22	77c71b8e-b229-4794-8a53-01b79ea8ba1b	д/ Техника	д/ Техника		2010-09-19 03:09:45.287+04	2010-09-19 03:09:45.287+04
a6ffaa0b-bdcd-40b5-b5f8-1871054ade86	77c71b8e-b229-4794-8a53-01b79ea8ba1b	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:45.29+04	2010-09-19 03:09:45.29+04
e3675ba8-3338-4a5f-9b37-7bbb1a57918e	77c71b8e-b229-4794-8a53-01b79ea8ba1b	ч/ Анонс	ч/ Анонс		2010-09-19 03:09:45.293+04	2010-09-19 03:09:45.293+04
d95ff646-0a86-416b-8e72-fac5d8f659b0	77c71b8e-b229-4794-8a53-01b79ea8ba1b	н/ Без границ	н/ Без границ		2010-09-19 03:09:45.296+04	2010-09-19 03:09:45.296+04
61f1e946-acab-4ad2-834e-c2a67119c3d0	77c71b8e-b229-4794-8a53-01b79ea8ba1b	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:45.299+04	2010-09-19 03:09:45.299+04
602a5640-a481-455d-92c8-b1a02ae2b013	77c71b8e-b229-4794-8a53-01b79ea8ba1b	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:45.301+04	2010-09-19 03:09:45.301+04
976aed97-510b-453f-8762-b0d8b81672b0	77c71b8e-b229-4794-8a53-01b79ea8ba1b	01/ ОБЛОЖКА	01/ ОБЛОЖКА		2010-09-19 03:09:45.304+04	2010-09-19 03:09:45.304+04
8b4a165f-8b54-491d-ba9e-e37ec2d3573d	77c71b8e-b229-4794-8a53-01b79ea8ba1b	02/ Крупным планом	02/ Крупным планом		2010-09-19 03:09:45.306+04	2010-09-19 03:09:45.306+04
00000000-0000-0000-0000-000000000000	4d0daad8-2c82-4d67-b75d-079300f89caf	Not found	Not found		2010-09-19 03:09:45.49+04	2010-09-19 03:09:45.49+04
153ad2df-6762-4a12-a7d3-e0e2fb8bf6ba	4d0daad8-2c82-4d67-b75d-079300f89caf	Тесты	Тесты		2010-09-19 03:09:45.499+04	2010-09-19 03:09:45.499+04
2f2801ee-325c-4e7a-b1d3-5dedca44693f	4d0daad8-2c82-4d67-b75d-079300f89caf	Новости	Новости		2010-09-19 03:09:45.502+04	2010-09-19 03:09:45.502+04
445bbe1a-6a87-421a-830a-2eb5903abcc4	4d0daad8-2c82-4d67-b75d-079300f89caf	Анонс	Анонс		2010-09-19 03:09:45.505+04	2010-09-19 03:09:45.505+04
dc89d761-b607-416e-b499-0f4bad397938	4d0daad8-2c82-4d67-b75d-079300f89caf	Спорт	Спорт		2010-09-19 03:09:45.508+04	2010-09-19 03:09:45.508+04
5d6e90b8-5a3e-4620-9317-f5d103eb5189	4d0daad8-2c82-4d67-b75d-079300f89caf	Ремзона	Ремзона		2010-09-19 03:09:45.51+04	2010-09-19 03:09:45.51+04
9cd98a05-7f53-4cee-8f6b-b0ce07790cce	4d0daad8-2c82-4d67-b75d-079300f89caf	Мотоклуб	Мотоклуб		2010-09-19 03:09:45.513+04	2010-09-19 03:09:45.513+04
a2c1291e-b0cc-4bdf-8b2c-d15d2614fe4d	4d0daad8-2c82-4d67-b75d-079300f89caf	Рынок	Рынок		2010-09-19 03:09:45.515+04	2010-09-19 03:09:45.515+04
de4416e3-03c1-4c54-90b0-cc7122b87f46	4d0daad8-2c82-4d67-b75d-079300f89caf	Реклама	Реклама		2010-09-19 03:09:45.518+04	2010-09-19 03:09:45.518+04
6a7a818c-3985-4846-98b7-e12d020bc3dc	4d0daad8-2c82-4d67-b75d-079300f89caf	Обложка	Обложка		2010-09-19 03:09:45.521+04	2010-09-19 03:09:45.521+04
767c356a-1e10-420e-8042-4fe6fe50c641	4d0daad8-2c82-4d67-b75d-079300f89caf	Техника	Техника		2010-09-19 03:09:45.524+04	2010-09-19 03:09:45.524+04
45345cd5-5101-4ad4-8233-341996f8319c	4d0daad8-2c82-4d67-b75d-079300f89caf	Содержание	Содержание		2010-09-19 03:09:45.526+04	2010-09-19 03:09:45.526+04
00000000-0000-0000-0000-000000000000	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Not found	Not found		2010-09-19 03:09:45.539+04	2010-09-19 03:09:45.539+04
0fbb54be-1f8d-4cbc-a12f-bfc4ee7c4ecb	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Содержание	Содержание		2010-09-19 03:09:45.548+04	2010-09-19 03:09:45.548+04
56f1d118-9adb-455e-b2b4-05555b5df9b0	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Без раздела	Без раздела		2010-09-19 03:09:45.55+04	2010-09-19 03:09:45.55+04
433f2ecf-29d0-485c-a661-6d421393a6ab	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Экономика	Экономика		2010-09-19 03:09:45.553+04	2010-09-19 03:09:45.553+04
3b26b98f-d6de-4c65-ae4e-6f8a5246fdef	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Главная тема	Главная тема		2010-09-19 03:09:45.555+04	2010-09-19 03:09:45.555+04
e03a5e75-d22e-4556-9b78-0c424174ef2b	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Спецпроект	Спецпроект		2010-09-19 03:09:45.557+04	2010-09-19 03:09:45.557+04
820c6a18-31f3-4c99-858c-2400be659868	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Автомобили	Автомобили		2010-09-19 03:09:45.56+04	2010-09-19 03:09:45.56+04
190a8909-4b62-4156-88f1-cd03127248c9	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Выставка	Выставка		2010-09-19 03:09:45.562+04	2010-09-19 03:09:45.562+04
2ab354de-c90b-4f22-bafa-1f4c279b1fc1	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Спецтехника	Спецтехника		2010-09-19 03:09:45.564+04	2010-09-19 03:09:45.564+04
3b6aab29-9455-4d6e-9ef1-7349ed99d760	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Автобаза	Автобаза		2010-09-19 03:09:45.566+04	2010-09-19 03:09:45.566+04
6844a2ce-b1c2-4ac7-b7b1-0c28bc833370	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	Реклама	Реклама		2010-09-19 03:09:45.568+04	2010-09-19 03:09:45.568+04
270f9cca-54f2-4ea0-a654-1dab72a3766c	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	РЕКЛАМА	РЕКЛАМА		2010-09-19 03:09:45.571+04	2010-09-19 03:09:45.571+04
00000000-0000-0000-0000-000000000000	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Not found	Not found		2010-09-19 03:09:45.679+04	2010-09-19 03:09:45.679+04
c7d33019-1db4-49ad-96ee-d3b27552d57f	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Тесты	Тесты		2010-09-19 03:09:45.689+04	2010-09-19 03:09:45.689+04
c746aa30-2c98-4668-a02b-7267a7ee0540	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Новости	Новости		2010-09-19 03:09:45.691+04	2010-09-19 03:09:45.691+04
c2f3d19c-a1dd-47df-964b-3c992c61f04e	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Анонс	Анонс		2010-09-19 03:09:45.693+04	2010-09-19 03:09:45.693+04
83b34a08-73a5-44cd-9f97-c57a20db6648	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Спорт	Спорт		2010-09-19 03:09:45.695+04	2010-09-19 03:09:45.695+04
78b6e77d-e1fb-4224-a74a-a3f691adaacd	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Ремзона	Ремзона		2010-09-19 03:09:45.697+04	2010-09-19 03:09:45.697+04
d05524ab-e7d6-4285-afb8-b9317c398ee2	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Мотоклуб	Мотоклуб		2010-09-19 03:09:45.7+04	2010-09-19 03:09:45.7+04
631c8042-611c-426e-8e2c-aa0fd11e005a	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Рынок	Рынок		2010-09-19 03:09:45.702+04	2010-09-19 03:09:45.702+04
f8b86c52-a170-4676-bd36-b564a24a2f13	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Реклама	Реклама		2010-09-19 03:09:45.704+04	2010-09-19 03:09:45.704+04
e0fa098e-20a4-4ecb-a8b5-9fbc86b2bc9e	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Обложка	Обложка		2010-09-19 03:09:45.706+04	2010-09-19 03:09:45.706+04
110cdb57-6129-4e50-b04c-cdcc0e71a75b	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Техника	Техника		2010-09-19 03:09:45.708+04	2010-09-19 03:09:45.708+04
771775c6-64e3-4693-bb2f-6f188fa71858	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	Содержание	Содержание		2010-09-19 03:09:45.711+04	2010-09-19 03:09:45.711+04
00000000-0000-0000-0000-000000000000	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	Not found	Not found		2010-09-19 03:09:46.103+04	2010-09-19 03:09:46.103+04
ac5e0f3f-3f3b-4176-9282-0c87c23a34af	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	а/ Автомобили	а/ Автомобили		2010-09-19 03:09:46.113+04	2010-09-19 03:09:46.113+04
131dc6ea-4699-46a2-9b1a-6f8ff6fed023	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	04/ НОВОСТИ	04/ НОВОСТИ		2010-09-19 03:09:46.116+04	2010-09-19 03:09:46.116+04
a2fbfa32-232b-4927-b78a-f3fb3bd22a13	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	03/ Содержание	03/ Содержание		2010-09-19 03:09:46.118+04	2010-09-19 03:09:46.118+04
5d73ddb0-0793-4dd0-816f-183a42b04809	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	г/ Компоненты	г/ Компоненты		2010-09-19 03:09:46.12+04	2010-09-19 03:09:46.12+04
d1e58723-8fb3-4c12-9a6b-d42fb65b7146	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	в/ Авторынок	в/ Авторынок		2010-09-19 03:09:46.123+04	2010-09-19 03:09:46.123+04
7646d5e4-17bb-4c54-b37d-6a50dbddd746	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	б/ Курьер	б/ Курьер		2010-09-19 03:09:46.127+04	2010-09-19 03:09:46.127+04
25367a60-c3b4-4d0e-b546-33969f2eb274	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	к/ Спорт	к/ Спорт		2010-09-19 03:09:46.13+04	2010-09-19 03:09:46.13+04
963ba0c7-4a37-41d8-9eb6-51bcca9b3e93	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	и/ Грузовики	и/ Грузовики		2010-09-19 03:09:46.132+04	2010-09-19 03:09:46.132+04
81906f37-5c85-4976-96ac-1065e098b2b9	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	з/ Экономика	з/ Экономика		2010-09-19 03:09:46.135+04	2010-09-19 03:09:46.135+04
48691883-3e2c-4c99-bdf0-a50d76360d5a	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	ж/ Безопасность	ж/ Безопасность		2010-09-19 03:09:46.138+04	2010-09-19 03:09:46.138+04
b292500a-44a6-47a8-81c0-e851c7c4f7ba	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	е/ Ремонт и сервис	е/ Ремонт и сервис		2010-09-19 03:09:46.141+04	2010-09-19 03:09:46.141+04
47fc49d6-0f71-4707-a016-51b04dfc031b	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	д/ Техника	д/ Техника		2010-09-19 03:09:46.143+04	2010-09-19 03:09:46.143+04
da6aec65-6659-4cfc-8ed1-778c75a24277	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	х/ Рекламный блок	х/ Рекламный блок		2010-09-19 03:09:46.146+04	2010-09-19 03:09:46.146+04
cfbb16e3-d049-465a-95b2-efa1f6d1e9e1	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	ч/ Анонс	ч/ Анонс		2010-09-19 03:09:46.148+04	2010-09-19 03:09:46.148+04
7dd64509-85ee-4934-b143-f6e6dc70a40b	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	н/ Без границ	н/ Без границ		2010-09-19 03:09:46.151+04	2010-09-19 03:09:46.151+04
d5bee9c7-89bf-49f7-8816-044155108288	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	м/ Цены ЗР	м/ Цены ЗР		2010-09-19 03:09:46.154+04	2010-09-19 03:09:46.154+04
1e07cba9-556d-45b9-b37d-bf17e1f79668	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	л/ Тюнинг	л/ Тюнинг		2010-09-19 03:09:46.156+04	2010-09-19 03:09:46.156+04
6abff0ed-f038-4978-8ad7-b58f6e749665	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	01/ ОБЛОЖКА	01/ ОБЛОЖКА		2010-09-19 03:09:46.158+04	2010-09-19 03:09:46.158+04
caf19ec9-9b43-426c-b885-53865637d452	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	02/ Крупным планом	02/ Крупным планом		2010-09-19 03:09:46.16+04	2010-09-19 03:09:46.16+04
00000000-0000-0000-0000-000000000000	22abeebf-f805-4140-b1ac-52dd782b8362	Not found	Not found		2010-09-19 03:09:46.339+04	2010-09-19 03:09:46.339+04
ae062038-bdd5-4c18-b2de-c0d7e7c160a5	22abeebf-f805-4140-b1ac-52dd782b8362	Содержание	Содержание		2010-09-19 03:09:46.348+04	2010-09-19 03:09:46.348+04
291959bf-e1ec-45e4-8f6f-9f544899579a	22abeebf-f805-4140-b1ac-52dd782b8362	Без раздела	Без раздела		2010-09-19 03:09:46.351+04	2010-09-19 03:09:46.351+04
90686def-fb0f-43a3-8311-4e1055751ea5	22abeebf-f805-4140-b1ac-52dd782b8362	Экономика	Экономика		2010-09-19 03:09:46.354+04	2010-09-19 03:09:46.354+04
cab32586-3786-438e-bde1-ff803dab20ba	22abeebf-f805-4140-b1ac-52dd782b8362	Главная тема	Главная тема		2010-09-19 03:09:46.356+04	2010-09-19 03:09:46.356+04
90e25c98-9a2c-4ac5-ade5-09b26f50f64a	22abeebf-f805-4140-b1ac-52dd782b8362	Спецпроект	Спецпроект		2010-09-19 03:09:46.358+04	2010-09-19 03:09:46.358+04
32e780fc-d474-4313-b1b8-e2ec54539f6b	22abeebf-f805-4140-b1ac-52dd782b8362	Автомобили	Автомобили		2010-09-19 03:09:46.36+04	2010-09-19 03:09:46.36+04
b178635b-0394-4ecf-8a74-4e990257981a	22abeebf-f805-4140-b1ac-52dd782b8362	Выставка	Выставка		2010-09-19 03:09:46.362+04	2010-09-19 03:09:46.362+04
859451a9-8f1f-45fc-bec0-167bf0484cb3	22abeebf-f805-4140-b1ac-52dd782b8362	Спецтехника	Спецтехника		2010-09-19 03:09:46.365+04	2010-09-19 03:09:46.365+04
ce2260cd-0340-4ccd-9a7f-7cd62ed960d4	22abeebf-f805-4140-b1ac-52dd782b8362	Автобаза	Автобаза		2010-09-19 03:09:46.368+04	2010-09-19 03:09:46.368+04
7abc9cba-e4e8-4253-b3d7-a0b4a7365a0e	22abeebf-f805-4140-b1ac-52dd782b8362	Реклама	Реклама		2010-09-19 03:09:46.37+04	2010-09-19 03:09:46.37+04
a73dd3d8-5358-4036-87e1-798955c279bb	22abeebf-f805-4140-b1ac-52dd782b8362	РЕКЛАМА	РЕКЛАМА		2010-09-19 03:09:46.372+04	2010-09-19 03:09:46.372+04
00000000-0000-0000-0000-000000000000	f9cfd971-ea52-47b3-90dd-6a31c03579db	Not found	Not found		2010-09-19 03:09:46.486+04	2010-09-19 03:09:46.486+04
622c810d-ffda-4431-aaf2-62ef1790edd1	f9cfd971-ea52-47b3-90dd-6a31c03579db	Тесты	Тесты		2010-09-19 03:09:46.496+04	2010-09-19 03:09:46.496+04
4d546462-8b4c-412f-8875-d872ad2b302b	f9cfd971-ea52-47b3-90dd-6a31c03579db	Новости	Новости		2010-09-19 03:09:46.499+04	2010-09-19 03:09:46.499+04
cb2e3a60-ae1f-4a2f-8f1c-da137440ab57	f9cfd971-ea52-47b3-90dd-6a31c03579db	Анонс	Анонс		2010-09-19 03:09:46.502+04	2010-09-19 03:09:46.502+04
c7d45ef4-8cc9-441f-a080-fcccac6a1aed	f9cfd971-ea52-47b3-90dd-6a31c03579db	Спорт	Спорт		2010-09-19 03:09:46.504+04	2010-09-19 03:09:46.504+04
53c0806f-d4be-4c59-b0a3-9260a7a52ae6	f9cfd971-ea52-47b3-90dd-6a31c03579db	Ремзона	Ремзона		2010-09-19 03:09:46.507+04	2010-09-19 03:09:46.507+04
a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	f9cfd971-ea52-47b3-90dd-6a31c03579db	Мотоклуб	Мотоклуб		2010-09-19 03:09:46.51+04	2010-09-19 03:09:46.51+04
383fee1c-42b2-409d-a765-8fdb81d16226	f9cfd971-ea52-47b3-90dd-6a31c03579db	Рынок	Рынок		2010-09-19 03:09:46.512+04	2010-09-19 03:09:46.512+04
4fabb976-2a51-4a09-ba03-2c40e29fa501	f9cfd971-ea52-47b3-90dd-6a31c03579db	Реклама	Реклама		2010-09-19 03:09:46.515+04	2010-09-19 03:09:46.515+04
87744131-498d-4a3c-aa4d-bae4029bb131	f9cfd971-ea52-47b3-90dd-6a31c03579db	Обложка	Обложка		2010-09-19 03:09:46.517+04	2010-09-19 03:09:46.517+04
fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	f9cfd971-ea52-47b3-90dd-6a31c03579db	Техника	Техника		2010-09-19 03:09:46.519+04	2010-09-19 03:09:46.519+04
5072bfcb-5f3a-495c-91ef-308be4de27a3	f9cfd971-ea52-47b3-90dd-6a31c03579db	Содержание	Содержание		2010-09-19 03:09:46.522+04	2010-09-19 03:09:46.522+04
00000000-0000-0000-0000-000000000000	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Not found	Not found		2010-09-19 03:09:46.929+04	2010-09-19 03:09:46.929+04
c95ec982-de90-4403-a30d-50385a778dcf	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Обложка	Обложка		2010-09-19 03:09:46.942+04	2010-09-19 03:09:46.942+04
26c5d707-294b-4ec4-99d5-a4d841be32ed	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Реклама	Реклама		2010-09-19 03:09:46.944+04	2010-09-19 03:09:46.944+04
88a3bc1e-e639-490e-a46b-950bd7c49b41	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Автомобили с пробегом	Автомобили с пробегом		2010-09-19 03:09:46.946+04	2010-09-19 03:09:46.946+04
152b8e08-1410-4e37-b463-5d5bd87d8425	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Авторынок	Авторынок		2010-09-19 03:09:46.949+04	2010-09-19 03:09:46.949+04
51fecfa1-5a40-445f-903a-6ba7bded9029	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Автосалоны	Автосалоны		2010-09-19 03:09:46.951+04	2010-09-19 03:09:46.951+04
ae6e90a7-0d38-4247-861a-ad5523018442	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Берем в кредит	Берем в кредит		2010-09-19 03:09:46.954+04	2010-09-19 03:09:46.954+04
7c3b0ce0-dad3-4901-90d1-4daa1b95c859	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Близнецы	Близнецы		2010-09-19 03:09:46.957+04	2010-09-19 03:09:46.957+04
ebbb47b9-eaca-408b-ac53-a7cb1225776b	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Вам пакет	Вам пакет		2010-09-19 03:09:46.959+04	2010-09-19 03:09:46.959+04
ced4245f-9319-4881-87e8-a408bea24a2f	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Вести с колес	Вести с колес		2010-09-19 03:09:46.961+04	2010-09-19 03:09:46.961+04
9874e977-0c22-4367-b3dc-2228f88e0d27	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Все модели российского рынка	Все модели российского рынка		2010-09-19 03:09:46.965+04	2010-09-19 03:09:46.965+04
2d072dcd-bc77-443d-94bc-7f2912473335	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Высшая проба	Высшая проба		2010-09-19 03:09:46.968+04	2010-09-19 03:09:46.968+04
7a8aead2-06e9-4246-bacc-8ded2df4c044	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Где купить	Где купить		2010-09-19 03:09:46.97+04	2010-09-19 03:09:46.97+04
8d9d3053-e607-4be0-a1ae-96041b54eb80	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Глаз да глаз	Глаз да глаз		2010-09-19 03:09:46.973+04	2010-09-19 03:09:46.973+04
26fffedc-bff4-4fd2-9e18-d45563877687	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	День за днем	День за днем		2010-09-19 03:09:46.975+04	2010-09-19 03:09:46.975+04
a218738e-b74a-4d95-b9d3-2ce179bda367	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Есть вариант	Есть вариант		2010-09-19 03:09:46.977+04	2010-09-19 03:09:46.977+04
efbfc315-1e45-40cf-9eff-c5bf45992b03	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Как это работает	Как это работает		2010-09-19 03:09:46.98+04	2010-09-19 03:09:46.98+04
e02d46c4-ef2c-450e-939c-678d415c85a0	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Каталог покупателя	Каталог покупателя		2010-09-19 03:09:46.983+04	2010-09-19 03:09:46.983+04
92827bb7-c66a-408e-819a-e50e270415c2	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Купи дешевле	Купи дешевле		2010-09-19 03:09:46.985+04	2010-09-19 03:09:46.985+04
d652813b-0fd8-4eb0-93cf-199cf4cd08e6	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Либо-либо	Либо-либо		2010-09-19 03:09:46.987+04	2010-09-19 03:09:46.987+04
bcc7f3bf-872c-4739-b89e-50c588e6f2f7	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Место рождения	Место рождения		2010-09-19 03:09:46.99+04	2010-09-19 03:09:46.99+04
7f854c72-6403-4673-96cd-33bb47f24302	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Музыкальный магазин	Музыкальный магазин		2010-09-19 03:09:46.992+04	2010-09-19 03:09:46.992+04
205decc6-cff0-48ba-8bdf-d6c50396eb51	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	На новенького	На новенького		2010-09-19 03:09:46.995+04	2010-09-19 03:09:46.995+04
9f36fcdb-1b8a-4842-a712-9cbcbc3c585d	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Новости дилеров	Новости дилеров		2010-09-19 03:09:46.997+04	2010-09-19 03:09:46.997+04
699e1ac8-d302-43cb-a17f-39ee1a82b81b	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	По деньгам	По деньгам		2010-09-19 03:09:46.999+04	2010-09-19 03:09:46.999+04
41bf9c0b-b70b-4fe5-826c-b4e3542f24fd	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Покупаем автомобиль	Покупаем автомобиль		2010-09-19 03:09:47.001+04	2010-09-19 03:09:47.001+04
ea7e4330-bde3-4232-9ee0-82db06818cb2	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Правильный выбор	Правильный выбор		2010-09-19 03:09:47.004+04	2010-09-19 03:09:47.004+04
60096d22-956c-473c-80a5-07471002072e	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Представляем салон	Представляем салон		2010-09-19 03:09:47.006+04	2010-09-19 03:09:47.006+04
1b2678f8-9d18-4412-9be7-3227f0d8a496	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Приценись	Приценись		2010-09-19 03:09:47.009+04	2010-09-19 03:09:47.009+04
73eeb9a5-66a2-4e82-a1ed-51cbae259294	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Против всех	Против всех		2010-09-19 03:09:47.012+04	2010-09-19 03:09:47.012+04
a4c516d5-c13f-4e12-abaa-dd582001d9a0	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Прямой контакт	Прямой контакт		2010-09-19 03:09:47.014+04	2010-09-19 03:09:47.014+04
a45dcb86-e4c8-48ef-89fa-b20b906a96d1	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Самый-самый	Самый-самый		2010-09-19 03:09:47.016+04	2010-09-19 03:09:47.016+04
2b97a7c8-0441-4f6e-b001-5696fd461760	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Семь раз отмерь	Семь раз отмерь		2010-09-19 03:09:47.018+04	2010-09-19 03:09:47.018+04
e66c25ee-e488-49b6-a114-b927f71bd18b	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Сколько стоит километр	Сколько стоит километр		2010-09-19 03:09:47.021+04	2010-09-19 03:09:47.021+04
59c048a7-6ebc-4b43-8793-34f558f81c7a	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Событие	Событие		2010-09-19 03:09:47.023+04	2010-09-19 03:09:47.023+04
273c60ad-5612-4e08-9335-72c07117f275	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Страховой случай	Страховой случай		2010-09-19 03:09:47.025+04	2010-09-19 03:09:47.025+04
1b17a18d-6f0f-4e84-8979-348278bdebf2	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Строим под себя	Строим под себя		2010-09-19 03:09:47.028+04	2010-09-19 03:09:47.028+04
77c5ed36-8ed7-4ac0-b35c-981b1f9fbb9d	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Тарифы КАСКО	Тарифы КАСКО		2010-09-19 03:09:47.031+04	2010-09-19 03:09:47.031+04
6f3cc708-bd68-4d67-a2d9-8516bcb59cc2	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Товар лицом	Товар лицом		2010-09-19 03:09:47.034+04	2010-09-19 03:09:47.034+04
73bc70b1-1d8b-4df9-a51c-246e3425b2be	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Торговый ряд	Торговый ряд		2010-09-19 03:09:47.036+04	2010-09-19 03:09:47.036+04
59c2c4b6-b8c2-4aa4-b16d-cc40421d812a	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Три года не возраст	Три года не возраст		2010-09-19 03:09:47.038+04	2010-09-19 03:09:47.038+04
51122bdf-36a5-459e-9d7d-f7ae44962a43	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Тюннинг	Тюннинг		2010-09-19 03:09:47.04+04	2010-09-19 03:09:47.04+04
3a1d92b6-9e2f-4da3-a2d2-a667b5d69b76	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	У барьера	У барьера		2010-09-19 03:09:47.042+04	2010-09-19 03:09:47.042+04
838b5e11-96ce-47de-a60f-58c05b26edd0	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Хиты вторичного рынка	Хиты вторичного рынка		2010-09-19 03:09:47.045+04	2010-09-19 03:09:47.045+04
59011160-b07d-4ee1-ae8b-363940bcce4b	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Цены в салонах	Цены в салонах		2010-09-19 03:09:47.048+04	2010-09-19 03:09:47.048+04
0483e92a-581f-4055-ae36-435f59097ac6	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	Шоу-рум	Шоу-рум		2010-09-19 03:09:47.05+04	2010-09-19 03:09:47.05+04
\.


--
-- Data for Name: map_documents_to_exchange; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY map_documents_to_exchange (id, document, chain, chain_nick, stage, stage_nick, color, progress, created) FROM stdin;
\.


--
-- Data for Name: map_documents_to_fascicles; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY map_documents_to_fascicles (id, document, fascicle, fascicle_shortcut, headline, headline_shortcut, rubric, rubric_shortcut, copygroup) FROM stdin;
\.


--
-- Data for Name: map_member_to_catalog; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY map_member_to_catalog (id, member, catalog) FROM stdin;
0aa76f79-f749-4592-82c9-0f808d68d92e	ee2259cf-4da2-4336-bb83-7b7bba626de5	0d3017ff-e40b-4959-bfea-7e8b9679d5d0
0cf976f6-de1f-491b-b6a6-34ff4267063e	d62fb09d-f4da-4561-8e1f-4c7d4ca5f65a	0d3017ff-e40b-4959-bfea-7e8b9679d5d0
8011e589-0182-4618-80ae-95882f7d54e8	1d6dcd3a-a919-426a-a896-a0e6d127c2ea	2ac29a02-220a-4ae6-8b6a-4365333488b3
a1e3c601-7b02-48dd-94c6-7bd38225e848	d62fb09d-f4da-4561-8e1f-4c7d4ca5f65a	2ac29a02-220a-4ae6-8b6a-4365333488b3
e5ad2287-d127-4a7f-9c9e-b2ddd9436fc1	9f2f4b11-7eab-46c8-9f8b-c117a4a9efed	2ac29a02-220a-4ae6-8b6a-4365333488b3
030cec51-1ab4-4617-a94b-ada1291480d9	a80159b2-1289-4c68-9801-655192aa7a49	4af74392-5f13-4a3f-8524-e298394fb647
72f0896b-de6c-41ec-877d-1c85e95da5c3	c2d15d41-d069-46ad-9bd5-fb9f96ae2509	4af74392-5f13-4a3f-8524-e298394fb647
d6c2a252-867b-4741-a349-487bcc7add51	74bd326c-df70-4880-8e24-99a244b2cc61	4af74392-5f13-4a3f-8524-e298394fb647
12391744-98a7-49f6-85f6-aa1e69992180	bfd1515f-ad99-47f6-80cd-3aaf0df63ca2	89483c7b-b971-42a0-a131-d8a52d5fc939
10bb7697-8fbf-4e9d-8bb9-0929303f6b00	046a7805-8dd7-4f9e-a21b-45dbc9b9c78e	89483c7b-b971-42a0-a131-d8a52d5fc939
a581187f-c85d-482a-9d0a-d86e3658586e	60380170-8ece-40db-b3de-320e11bcf365	d9b49c33-de87-4f50-9a1e-4868c4d65411
fbd0418b-01f9-4b29-b24f-eac1371d9da9	bf67a730-cb01-443d-848d-0d8c3b9f9d22	d9b49c33-de87-4f50-9a1e-4868c4d65411
ff1df7db-96d6-4451-ba06-032822952599	04bff9ee-7671-4e9a-bb89-12387c7ad932	d9b49c33-de87-4f50-9a1e-4868c4d65411
2baa89a2-7f16-4dfd-a677-93a118d089b3	0e5db04a-3fca-4d81-b38d-adb1ac00f74a	d9b49c33-de87-4f50-9a1e-4868c4d65411
f729ce7d-60a9-4db1-b6aa-267fb2600a95	22355bc0-4134-4a76-a49e-3d4e77ea7c3f	d9b49c33-de87-4f50-9a1e-4868c4d65411
937f98cb-c3e8-49ae-9ca3-ec50cbc77a9b	191e7e82-1f84-44d6-afd6-88c7fa5dc697	d9b49c33-de87-4f50-9a1e-4868c4d65411
0f6e50cf-4483-42da-aac6-d89684d39c7c	f68a5200-6383-4e3a-8d7f-608bad97ad70	3cdad4d0-a9d7-45e4-b6af-fd329100edda
bcc83190-d586-42fe-868e-49a482b3cd52	089d2f8c-e623-4195-b7b1-e5bd5c3f5f3e	3cdad4d0-a9d7-45e4-b6af-fd329100edda
0b5a877e-19e7-4866-be14-5f638093ac7b	894ca299-93f5-4f56-b415-f12f3cc22383	3cdad4d0-a9d7-45e4-b6af-fd329100edda
a680ea2a-7e8a-4eea-bca8-cc7a6ee9fa7e	7434e003-6b61-4736-bab5-6bfcd1d09e7f	3cdad4d0-a9d7-45e4-b6af-fd329100edda
d756affd-77a4-4585-8c4b-b0e25201eba8	e3234892-467c-4009-b4e8-f77e989d81fb	1716f2db-eb40-4372-9e4c-9288170c2171
282ae8ed-4779-4135-ae43-bdaa4c520f2a	201b8bb4-e560-4548-a55c-d9f8bad1c17e	1716f2db-eb40-4372-9e4c-9288170c2171
b87a6416-9b63-4310-a930-0c5f8354e258	9e5eb564-da2c-46a5-a08b-9626467f885a	1716f2db-eb40-4372-9e4c-9288170c2171
f2fdc2bb-2d73-4c8a-982b-346fa418c30d	f2ee7c59-2462-486d-a989-917dda16fac5	28f669b1-6e32-4274-85a2-32426f618669
90a354b9-a5bb-4089-bc88-e79329863469	d62fb09d-f4da-4561-8e1f-4c7d4ca5f65a	28f669b1-6e32-4274-85a2-32426f618669
c615bb5a-3f69-4403-8c00-8af17f0194fd	37245b73-0c9f-4a71-86db-7fcfd0ebcda8	28f669b1-6e32-4274-85a2-32426f618669
a36e98f0-a5eb-4aec-91ec-32fea9f6523c	14257ad1-cdd2-4eeb-addb-2670fe7cc7ee	86e5df0c-ca86-47a4-9754-d703c40f1683
b8f21fd9-f115-482f-909a-b89f11069bf7	d62fb09d-f4da-4561-8e1f-4c7d4ca5f65a	86e5df0c-ca86-47a4-9754-d703c40f1683
ca74e71f-a263-443b-bf0e-03afad9cdd86	c72e677e-feed-4b25-9104-556ae5c3d2f6	86e5df0c-ca86-47a4-9754-d703c40f1683
aaa6f087-a50b-46b0-a416-058b23bbdbfb	85d8bd4f-e9d9-47e5-8f8d-dcfeb5eb6639	86e5df0c-ca86-47a4-9754-d703c40f1683
54b4a029-4af9-4eca-9904-a1df1c2fff1b	9e5eb564-da2c-46a5-a08b-9626467f885a	2837fef0-7061-401e-b58a-9c1315c6eca2
1ccbb42d-2922-4634-86e7-b1623f4a2c5b	d62fb09d-f4da-4561-8e1f-4c7d4ca5f65a	1765069b-234f-4adb-b12e-58502d05a940
83399b16-544d-4f95-bbc0-664af271e098	b17c817d-f19f-4cea-9eaa-fba4ef84e9d8	1765069b-234f-4adb-b12e-58502d05a940
09e4ca71-6ca3-4eb5-a818-0cb9463d8520	36db93a2-525f-482f-98bc-b7ea5634241a	b4e98951-2b31-4341-8cb9-0ace637890b4
612b166b-ac62-4438-9218-855a2471b3ef	8740b2c1-0e83-498b-9866-1023cc943399	b4e98951-2b31-4341-8cb9-0ace637890b4
a9033739-ed04-465d-bad2-ab2034501927	3eeacaa6-bd8e-416a-a4f2-7542b7345276	4ca62851-4aeb-4c8f-983e-66f75e0bb58e
77f5808f-eb0f-4afb-ad39-9a2b4ea41cf5	e630c359-10b1-45c1-96f7-153f449ffcaa	1e503f74-c03b-4858-812b-ab2fb7962013
0a04c89d-8513-4292-9048-85186d936cc0	bfbcbf9e-61ad-43e7-9e5f-4e72d522981e	1e503f74-c03b-4858-812b-ab2fb7962013
dbcff1e0-3c67-42fc-a0fb-cf994d7dddfb	3a32d534-dd27-45a1-b6fd-b8841825c91b	1e503f74-c03b-4858-812b-ab2fb7962013
2656c886-7530-4d7d-9a64-7be9a21c3269	b366e89e-6ddc-4681-96e9-69fe3917ba3f	1e503f74-c03b-4858-812b-ab2fb7962013
6d3eed5f-e60d-4f7f-8a0d-8bdd25b0e7f9	df7afcd2-1daa-4ee3-abf9-8294192b3880	783e5830-8daf-466a-9f16-69a430205432
682f2f6d-af1a-4b28-b16f-593bbab639c5	ff09c497-a5f9-443d-b77f-5a25663d2100	9c9989ba-9df3-42c6-b570-858f4488604a
f57ac9d4-d84d-491a-8477-449b0ba92c4a	b1c0524c-7568-4aae-bfb1-a57b1b71eba0	9c9989ba-9df3-42c6-b570-858f4488604a
2219aed5-3bd9-4e10-a0ed-b4fb7278c504	0c9025a7-6c59-4b3e-a79d-2388321ac4f0	ab53db60-3142-4699-8b57-a83db930db6b
00869ee0-63d3-478c-80c8-3713475f922e	afe06e6c-552b-4b30-b13c-f9b8515cc252	ab53db60-3142-4699-8b57-a83db930db6b
c7937b50-fa39-4f62-9a84-8005180ca1a4	e3b448b8-9d9a-4ccd-bfbb-1742f8c818c8	ab53db60-3142-4699-8b57-a83db930db6b
b5d5142d-6ed1-4f28-8140-68a874b4adf2	ecb1a1a2-43c8-459c-bdf7-5b1770b80c23	ab53db60-3142-4699-8b57-a83db930db6b
91710ba5-28fd-4319-8be7-008ed22591e2	117b5b1a-cd71-4a26-a30f-8381b33ea40b	ab53db60-3142-4699-8b57-a83db930db6b
dd09de51-c0be-4887-a45b-76ce2eed4cc9	26ceb965-33d2-479d-b9e6-d64825118c78	ab53db60-3142-4699-8b57-a83db930db6b
d24d2b33-9cac-4486-830b-c6b085d66bed	16f0f7e7-b59d-4c83-aea5-6cb31dd8375e	ab53db60-3142-4699-8b57-a83db930db6b
229dcfe1-6dd0-435c-9542-561cd84d8491	f37f2350-fd4e-4153-81e1-a3de49a0cae4	ab53db60-3142-4699-8b57-a83db930db6b
fba148e5-6422-4d68-8c61-cc3500c35837	7d8fd058-6d07-4c3d-a267-95dbb34bb982	15c6f56b-e8f5-4d9e-a698-09de205e05d6
09157cc4-9de5-4660-8b43-45b429be42ed	f892432f-4714-4660-8e97-114aeef555a6	15c6f56b-e8f5-4d9e-a698-09de205e05d6
2a89b69f-d054-4027-844a-b6426e72143a	55483b88-f08c-40db-ae7d-89390ea0f610	dc328c99-e50e-4d40-ae3c-f19ee7630225
1312d905-b1b7-451e-9004-e245919cf43a	ea63bd58-ecb6-4a62-8fa7-42bbc9612199	1683134b-ab43-494e-b727-4c07ef67e525
e7fca46f-4e17-4066-9f7f-118d5395fb48	4a3d3c86-ce1b-43f3-9ff2-f18b8df86d95	213d5326-df0b-4e32-ac39-3dea069a6e7d
10ba2fad-616e-46e1-bfa2-c4225b04f7ea	75b40dcc-77df-41ab-a90e-0ab14ee70d60	213d5326-df0b-4e32-ac39-3dea069a6e7d
0c95ccfe-bc0b-4551-85d2-fc742dd987e1	a9a125d8-29bf-4a4d-8d96-18e97d242de2	213d5326-df0b-4e32-ac39-3dea069a6e7d
97d653d6-3779-43b3-9f36-9ffb51e65ac9	4583bc6c-1186-4a30-a862-2d3563427903	213d5326-df0b-4e32-ac39-3dea069a6e7d
187fab66-c525-49ca-9490-1422029f2bf5	3b389517-6113-4ad8-b99a-90c05f98b013	213d5326-df0b-4e32-ac39-3dea069a6e7d
56ee3bdd-84e7-4312-aab9-60ae10d01653	f3e9e179-4630-42da-9b44-b413f6820950	00f84872-99e7-4665-8bda-ba5db2154fd0
35ffd146-deec-4056-982b-2986b62cde0d	a06888ca-d1ba-42fb-bea6-cdef22029bfc	00f84872-99e7-4665-8bda-ba5db2154fd0
777be326-263c-42cd-8a3c-fe8076d16d3c	f013a3f3-b4d0-40e1-89ed-baa28f29bb65	00f84872-99e7-4665-8bda-ba5db2154fd0
d99be078-402d-4255-9323-7463689346e8	0c74ec20-d342-4b86-8a7a-69184e3bdaa0	00f84872-99e7-4665-8bda-ba5db2154fd0
56d3007b-1030-4924-85d0-7a3a6e7ea1df	6fc40b58-59fa-4ba9-9790-cf847b28473f	00f84872-99e7-4665-8bda-ba5db2154fd0
0b9dd41f-4a6f-4541-afd6-36586a3f1108	34aed480-c47b-4777-921e-1b1422b50de5	00f84872-99e7-4665-8bda-ba5db2154fd0
ca4ab427-50f6-4dff-a137-81b091824414	baf0b57e-4726-4f69-99a0-c8cbf4d617fd	00f84872-99e7-4665-8bda-ba5db2154fd0
be6e8ec9-5ebf-4eab-9d5c-55b31373ef4f	a6d38208-a092-4cb1-bfd7-1cbb79ea644f	00f84872-99e7-4665-8bda-ba5db2154fd0
b9f01de7-f59d-497a-a87a-1950813d79e9	2cb515b4-3b21-4d6d-848a-a491f8ccf631	83ac2bcd-2011-43fb-b5cc-cea3cdd17173
b136c180-29d6-4f7a-9cb9-82aa51c6545d	3929853a-0636-4165-8b7e-51d36563599d	83ac2bcd-2011-43fb-b5cc-cea3cdd17173
37c16089-2b1a-4114-90e9-a49cc2643661	c86f13aa-6853-4a3c-88d4-bddbeae55561	d885bfdd-ada6-4f52-9b42-e5377b850365
1628427e-0d34-4d44-b126-8a08ab5205cf	71c10522-7db0-4cde-9fbf-eafff1aec380	d885bfdd-ada6-4f52-9b42-e5377b850365
1212f097-ae91-4b9f-aac2-33b37e359841	f5bcaae7-9fac-45a8-9913-a1c2098c4a4a	d885bfdd-ada6-4f52-9b42-e5377b850365
bf5e07b3-76c8-4148-9bf5-953cf64e9493	b43b1632-06f9-4304-81aa-f4b25ee6c6ec	94bc80e1-0853-4e46-845c-ce4e591c78f8
7745f6c4-cf57-4c5e-8274-75f6f38f07f2	81469f35-ee9f-417b-b297-b99efbb0bbeb	94bc80e1-0853-4e46-845c-ce4e591c78f8
0283f7b5-7cba-4457-b3ed-efebeb776c97	e8d65f73-ec52-476d-814f-6e3d3f9d8b4e	9f5ee5c5-c03b-4a23-94f0-ee3212353e5d
78fedfdd-aeb3-45d2-9ad4-7016e72b41ec	b2944873-7a2d-41cb-8c79-370a21860bfb	9f5ee5c5-c03b-4a23-94f0-ee3212353e5d
11a1dd3f-d101-48f0-a58d-4cd4166bd97c	48545562-b6dd-48b0-a705-a5704e1cd51c	9f5ee5c5-c03b-4a23-94f0-ee3212353e5d
f80a32e9-50dd-44c5-9864-d2ee49c59c08	a9e3e7a0-9d3b-410a-b2d8-09ca826e3a6c	88067829-2bb5-43e0-8de7-7b234f971a0d
59d5f371-864a-409f-8fe4-514278944793	d52ba8a2-05ce-4952-a6c6-8f32706df7d0	88067829-2bb5-43e0-8de7-7b234f971a0d
3d8f85ca-d8af-4ddd-ba6d-bf750a88534e	9afc213d-6d00-45b5-a1dd-44bea751d202	88067829-2bb5-43e0-8de7-7b234f971a0d
b1fcb0af-da5e-483d-a39d-87ec12dc7b97	d495fa01-e51c-4371-a08b-c4fc204b6c35	88067829-2bb5-43e0-8de7-7b234f971a0d
51798389-5b7e-455a-b239-f9d0441bae68	b7bae9b1-3bed-4b5b-800c-09fbdf6f0801	88067829-2bb5-43e0-8de7-7b234f971a0d
0955f366-2c76-4b95-a83d-d7b067f6809f	fba392ed-e4b5-48cf-b331-7e74f9392931	b389451d-5f5d-43c8-aae2-0cc8e8833a65
c00dd108-db62-46d9-a3c1-7e467fc36172	862a0771-6946-4eb9-b50b-1d98f9eb53da	b389451d-5f5d-43c8-aae2-0cc8e8833a65
c2b3cb94-de72-4d0d-b978-688659182967	cd4c74a1-f17f-415f-92d4-ddfda4866d64	b389451d-5f5d-43c8-aae2-0cc8e8833a65
9d8dc3d2-0f39-467f-b3d1-23eeca4b38a8	a6eedcee-ffed-4700-8521-fa8aa2235a26	b389451d-5f5d-43c8-aae2-0cc8e8833a65
0b06c1ec-52bb-4853-b543-8a10d82f36d5	2e76de7d-29a8-4342-b5fb-231778431913	b389451d-5f5d-43c8-aae2-0cc8e8833a65
f483ddfb-3113-40a7-964c-97ad78f83e87	3c069ebd-2c2e-4901-a654-29d64ab1d87a	b389451d-5f5d-43c8-aae2-0cc8e8833a65
23866d22-68f9-403f-9904-34f312cfafd8	c5406142-352b-4c0e-9ebd-0ec30f388b48	b389451d-5f5d-43c8-aae2-0cc8e8833a65
32d4cc44-a38a-4fb5-b29d-7c25ee4cc5ac	95bc7b93-0db0-4b68-8132-f0f7d5123ed5	b389451d-5f5d-43c8-aae2-0cc8e8833a65
3a06a9b1-43a6-476e-b946-268867031cf7	16197fd8-1e7f-41ce-9d30-ff4b65939cca	4bb55d21-28fd-432e-9316-afcdeef6a78e
a6148840-6d9a-483e-81a8-3e0da0c1d5cb	a7ee282e-3fe7-4311-aeed-f77dda102e07	4bb55d21-28fd-432e-9316-afcdeef6a78e
18773bbe-806b-44fa-9b35-84ee94ce7b89	df7afcd2-1daa-4ee3-abf9-8294192b3880	4cdd3b42-754a-472f-85fb-869baf06d8b7
0c12afe5-caea-43cc-a57f-de18089f84d5	ae63e43d-2633-417e-b53e-b076102fc608	4cdd3b42-754a-472f-85fb-869baf06d8b7
d9a6ab6a-22c6-4ac5-a670-0a284b16a9ce	ba51dbc9-bff8-40e4-bbe8-2b283ec8f94b	4cdd3b42-754a-472f-85fb-869baf06d8b7
fdb42b32-8f92-446a-a221-873d9ced0cce	2386d6fe-7c43-46dd-9ea2-92670c50c743	4cdd3b42-754a-472f-85fb-869baf06d8b7
02b6c922-61c9-48ff-b04f-31a1f4ab634c	1a63e582-5cd1-4b89-97fe-1d4de00bda5d	4cdd3b42-754a-472f-85fb-869baf06d8b7
28d4f3b4-d82b-4409-a287-cb85b34ec53e	67fcabe2-644c-4f64-8ee4-7941f7eabea3	4cdd3b42-754a-472f-85fb-869baf06d8b7
ea68899b-1e54-447e-9bc5-0e847b6945e7	d6bc5a54-01be-4a60-9152-dc7ed8747887	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
c5420d9c-af68-4c94-996f-84e70e89dba5	0a7b47c6-c882-45ac-be78-b7fdadea1656	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
bf499cfc-cbfd-4b13-bda7-9bdc99944f33	935d3a03-a55b-4235-b9b1-98c60edafd0d	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
26c9d22d-c163-4eab-b034-6d852cecf82a	88106be4-54ef-4281-85b3-239c3ccf6bb3	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
5ac83531-5cb7-4c21-9e04-9ec92f2fa17b	a520841d-2032-4dbd-af63-2eebc475d846	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
b4d3c8e0-ed40-4f13-beaa-f3bad7de82c6	64bf2e20-2d75-40fc-bf52-4e172ad70044	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
01d21c5d-501a-4659-b221-b10a54608400	9c9f8939-134e-475a-8fe0-363794d3bcf6	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
e4f8f427-362e-4e21-b19e-3053dccfa92a	f93cd231-c2cc-49e2-9d25-66dbac0f8bd4	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
13ebeace-4f98-4386-a1dc-646d138b8fbf	ecac5566-2b2e-4f75-a80e-894d088bbfd1	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
9124cc9f-feb3-4a15-bd67-6947be1ea155	092eea35-1f7f-4fc2-aa48-41625c084df0	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
fe24718c-4abe-4475-bea5-3001e8ab7877	0cd9ec5d-181a-41de-a372-af33436b1ab9	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9
2d3521dc-d9ed-48d2-8976-f7526caea133	04ec0a96-5485-4842-ab85-07ab46b7334e	a1f418f5-ac08-4aa4-964f-b7e1ece4e970
ebabc70e-da6e-46fe-91c4-59670ecaceb2	2350092c-d335-45e9-8e70-cf1d2dac3c64	a1f418f5-ac08-4aa4-964f-b7e1ece4e970
cf81a963-2a23-4c75-956f-f67a1fd716d4	05483b9e-9a55-43e1-8d37-f58906d99a90	a1f418f5-ac08-4aa4-964f-b7e1ece4e970
e4ae1e39-36f4-4bfd-81dd-3f6c971ce8fb	5b419947-30e3-4102-8f6e-69fd43d2f1cc	a1f418f5-ac08-4aa4-964f-b7e1ece4e970
36410e91-91c9-4567-a3fa-d4987efa0db8	4f5ad92e-b3e7-4c54-937e-e70aa999c0c7	46f7d566-d6f3-4f96-90dc-b41ce41f1c76
23d5821b-7fa5-4dd5-9dd9-cb023554c41a	c36ef223-8c43-4804-afcf-1baaf9a5178b	46f7d566-d6f3-4f96-90dc-b41ce41f1c76
1873a19d-d028-4d72-b0d5-08cb21b55477	2c3a2637-557c-49c6-a6be-83eb343027d7	46f7d566-d6f3-4f96-90dc-b41ce41f1c76
7efe199c-527c-401f-9d9c-563a3ed965cb	eeafe6cb-9a4e-4982-b50d-8854ab8bd5ec	46f7d566-d6f3-4f96-90dc-b41ce41f1c76
b1b7c24c-97cc-47a3-be8b-8de2829a84a4	4f5ad92e-b3e7-4c54-937e-e70aa999c0c7	cf940ab4-bfa5-4b83-bf6a-6b5346f09081
768c46e9-dd67-4f87-a18f-2746c817615b	2c3a2637-557c-49c6-a6be-83eb343027d7	cf940ab4-bfa5-4b83-bf6a-6b5346f09081
26eef3f1-eec2-439e-ad37-87f6af65f3b5	356e53b0-539f-40fe-b8bc-a16376c9daaa	96baeee8-461c-470e-a82d-1ca192725241
a3d94539-60df-44ff-b237-47c420707e89	b4af4681-7706-4f23-b0df-c4340356a5a0	96baeee8-461c-470e-a82d-1ca192725241
e3495267-da7a-4c7c-a9f7-998ce5cac156	41af4948-123f-47fd-b840-6921adb63088	96baeee8-461c-470e-a82d-1ca192725241
f3bcac28-cf02-4d0e-b59c-d843d4006d6a	ce99662c-7898-4485-aad9-7264a5c0a1d9	96baeee8-461c-470e-a82d-1ca192725241
b84f8232-e2b4-4abd-af82-790820ace3a6	578fd168-eba6-4011-867c-7b0529e1e93e	96baeee8-461c-470e-a82d-1ca192725241
416c45d7-3765-49d4-9b2a-13c788a57b6d	c3b42312-eac4-400c-b523-2ad65b1f406a	96baeee8-461c-470e-a82d-1ca192725241
f65ca9d6-dfe0-405c-991d-c27f02bfad8a	c9024aa0-b5ea-427c-80ac-96e15f22cb12	713d3e38-b5c2-498e-8ed6-26120cecda0e
f9f54329-1915-43e4-a5a1-857e1c481332	1f8ef3b2-3980-4327-a62b-11bd1b643043	713d3e38-b5c2-498e-8ed6-26120cecda0e
e675ea11-ad08-4e8a-9015-d8e0b6795f00	127bc976-6e7b-4b43-8412-b688c321b716	713d3e38-b5c2-498e-8ed6-26120cecda0e
9a9cc3c5-091d-4838-ba84-fb172fce81ed	b7a4e3f9-bbb3-4f57-9648-7e3b78184697	5df88b9d-659c-4b96-b5f4-69e0122dee98
cd8636c7-4ff5-4b33-b0e0-f84c6b4bbdab	d291b4b9-fe8e-470d-aab2-eaf78588f1a5	5df88b9d-659c-4b96-b5f4-69e0122dee98
563986c6-56e6-4eba-a865-f8aa77855ca6	88106be4-54ef-4281-85b3-239c3ccf6bb3	5df88b9d-659c-4b96-b5f4-69e0122dee98
fe901fc1-01b8-446d-85c4-802e7adbda4e	388a9b14-d368-41cb-8484-45887de55fcc	5df88b9d-659c-4b96-b5f4-69e0122dee98
0d007f62-b0fe-4baf-b243-d2c4a016432a	84735f6b-fc94-4cc7-a771-c660e93b1520	5df88b9d-659c-4b96-b5f4-69e0122dee98
3d826570-3842-44c5-b0ea-ae1c066eea42	841abf3c-d9e9-4ff7-b7b4-aaa687ac0edf	712077a7-3cc8-4357-a696-7799060fdf15
0927c183-7449-4fc2-b205-d60953611d5b	14ac6931-6ca2-4a59-97d3-ccdb179869eb	712077a7-3cc8-4357-a696-7799060fdf15
b17f2e7c-3a84-406e-9830-7ec3e9058760	0b33d92c-f4d6-49cd-a136-89fc777b8a3d	712077a7-3cc8-4357-a696-7799060fdf15
8cef8cfc-77c0-48e7-8b51-6a09b203a3e8	4f5ad92e-b3e7-4c54-937e-e70aa999c0c7	50f82f94-a384-4fcd-8d59-f9f55d7c0a54
ec129748-9673-45fc-9618-ca84aa0a8150	c36ef223-8c43-4804-afcf-1baaf9a5178b	50f82f94-a384-4fcd-8d59-f9f55d7c0a54
82a0ba20-a4c1-4a36-8b4c-8feecd85ac77	2c3a2637-557c-49c6-a6be-83eb343027d7	50f82f94-a384-4fcd-8d59-f9f55d7c0a54
e297793b-0034-4771-b21e-871bba0bda9f	64bf2e20-2d75-40fc-bf52-4e172ad70044	50f82f94-a384-4fcd-8d59-f9f55d7c0a54
98ff1775-9ef6-4756-9bd8-61e622bf4224	35ca2e58-3e19-4ff5-a289-8f83e0d2060b	50f82f94-a384-4fcd-8d59-f9f55d7c0a54
4591d40f-97ad-4c57-aa0c-b3125a7f9b24	0c9025a7-6c59-4b3e-a79d-2388321ac4f0	e94920b3-cdcb-42cc-a1c9-706271466a79
9bda7b0e-acae-4257-9706-23e279008094	afe06e6c-552b-4b30-b13c-f9b8515cc252	e94920b3-cdcb-42cc-a1c9-706271466a79
c6593729-26a0-450e-a41a-145c9d676e26	e3b448b8-9d9a-4ccd-bfbb-1742f8c818c8	e94920b3-cdcb-42cc-a1c9-706271466a79
9f3414ea-4b59-4402-a0f8-8cc6c579b5f8	26ceb965-33d2-479d-b9e6-d64825118c78	e94920b3-cdcb-42cc-a1c9-706271466a79
f5a75297-596b-4589-a1ec-9fc089ade613	49de597d-2871-42da-889f-e85852162d0b	e94920b3-cdcb-42cc-a1c9-706271466a79
b573e528-f0f1-431f-963a-74e86002c607	ea63bd58-ecb6-4a62-8fa7-42bbc9612199	d3f585bb-6d3f-4d2a-99ca-43e2afccaf51
22f8aea5-5803-4cf2-bf7e-322be9cca2fb	1ae159bb-cc3f-4f02-88a6-1d6a747461ae	d3f585bb-6d3f-4d2a-99ca-43e2afccaf51
6026ceaf-4222-4d7e-aee2-a847325e1892	bc7c2ef7-d61c-43c3-b5c7-f0b6c262bbce	d3f585bb-6d3f-4d2a-99ca-43e2afccaf51
db6e2887-d240-4f74-b5c4-adcece58e565	6bf8c21d-5c5b-4df9-b847-3f144df4dce6	bb82e390-6c91-4895-839e-724aca4b842e
7546ed03-428b-4577-98ea-9628e6152843	2d35168f-b729-4053-8177-2a9cd3fbb472	90154d05-bead-49c8-ae28-ab55a8988aff
f1ea5ada-303d-491f-98c3-e13eb3a6c98f	41f453f3-88fd-4e0e-bd9c-a388dd528b52	e32e0735-f513-49c1-855f-6aff8aedf24d
330ddeab-aab4-4831-b2bf-42277b345350	8f615ae1-e2d7-4379-842f-fd6ea993b6b4	e32e0735-f513-49c1-855f-6aff8aedf24d
a1d94dce-5cd5-444e-905c-c286c8bf90a0	89f5c39b-1b0a-4ebe-9e0b-5f72397d943d	e32e0735-f513-49c1-855f-6aff8aedf24d
253b2fd3-267a-4a0a-af85-c0163ab5512a	b23d0504-a5a9-436c-9956-ac01c1620268	e32e0735-f513-49c1-855f-6aff8aedf24d
c8d50e7a-5fbd-4656-9318-f8f91b8708d5	0cfe7daa-b3aa-4f04-9eb5-30bc420e433a	e32e0735-f513-49c1-855f-6aff8aedf24d
3a9d7bcc-1458-4861-a762-d412dc02f13e	5d927faf-fcc3-4ffe-b425-82f3ba76826c	e32e0735-f513-49c1-855f-6aff8aedf24d
29d75fe3-c550-470a-a74b-8259a2cc3246	d1888ad3-0a82-42e4-b56d-9e40dcbb1701	e32e0735-f513-49c1-855f-6aff8aedf24d
83f5a57a-791e-423d-8fe1-f46e237bd3df	e486905b-7bcf-47eb-ac0f-9dd745c1a2b9	e32e0735-f513-49c1-855f-6aff8aedf24d
014d5975-c28e-44e6-be3c-9f7b6c4fad1f	be80bb62-780c-4956-85e1-c7f5344613ea	e32e0735-f513-49c1-855f-6aff8aedf24d
3fa9dc95-fea0-41aa-afe9-ff57aa7bcb80	c357e368-77c6-42a4-8db1-18e172193e73	9be818fe-58e1-422d-b7cf-6405ee68affb
2177c407-798a-45f9-a89e-a859e214a395	b7a4bdd9-5f5e-4ba2-ac2e-d9f65bc39c4c	9be818fe-58e1-422d-b7cf-6405ee68affb
1f13e580-eb0c-4b3d-a224-ca6e0c6c8d42	457ca2f3-139b-4f6a-869b-b9f64b2ef194	9be818fe-58e1-422d-b7cf-6405ee68affb
456b1f8f-8635-4981-b98b-82d7034950b5	4d9e010b-b82b-4e3e-abb0-921d43fe3ab2	9be818fe-58e1-422d-b7cf-6405ee68affb
4a744804-239e-4371-8ddc-aceac7c06aa2	181ca8c0-d8e0-4810-b1c6-c75b9c10fe1f	5bfd9fa5-90c8-41f0-adff-8f74e5fd967d
fcf9181e-30e7-41ed-9d4c-cfed2529d2ee	ff2dc078-3b41-49cc-9d8f-fe1b05a13547	5bfd9fa5-90c8-41f0-adff-8f74e5fd967d
90460b57-8b9a-4f90-bcb4-f4c6120c3ed3	1a652482-ade8-4809-b836-681cf82cb532	85e3fce3-9846-43f4-9f6b-be6a43e75cb8
8c931cd9-2301-444b-8af9-fb84fac68e27	d5e1219e-a729-4a3a-a21a-9b2b6407900b	85e3fce3-9846-43f4-9f6b-be6a43e75cb8
642227e4-1f90-471d-a200-4eaa889f8884	a3b4a538-79fb-49b9-bf23-6d20ca1aa387	80e66420-469a-4882-b628-b42d2370c3a8
58e22b81-2335-4297-81cd-992684daf74f	7c740887-599f-4077-8e74-7531dba0742b	80e66420-469a-4882-b628-b42d2370c3a8
fc6779d5-1770-411a-b9e5-8dd423c7774f	b6bcd869-ef13-41ba-866f-a87689173774	17cebfa7-efa0-4ff7-a6fa-145a650889a4
106f2ce3-e4e2-42db-a24f-93143c9759e3	afd137a8-f8a4-47c7-8263-bc33857fe223	17cebfa7-efa0-4ff7-a6fa-145a650889a4
a8e45cdb-bed1-45e9-ba4d-2af18387969d	f93cd231-c2cc-49e2-9d25-66dbac0f8bd4	17cebfa7-efa0-4ff7-a6fa-145a650889a4
e6e1091f-aa06-4afe-a924-3ac46cb81799	de1e3666-e037-471f-953e-fc044961e8e7	17cebfa7-efa0-4ff7-a6fa-145a650889a4
\.


--
-- Data for Name: map_member_to_rule; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY map_member_to_rule (member, catalog, rule, mode) FROM stdin;
c36ef223-8c43-4804-afcf-1baaf9a5178b	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	db6d8b30-16df-4ecd-be2f-c8194f94e1f4	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	93b1e20c-fc07-4c41-8c9f-0cf810d434f0	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	63c666d4-d8c1-41e1-b67d-27e4b262d7a3	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	9519ed9d-bce7-4048-9366-1ce62f2e428d	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	9519ed9d-bce7-4048-9366-1ce62f2e428d	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	f2ef2670-6c3f-4516-876f-ffc46b8eb9e8	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	f2ef2670-6c3f-4516-876f-ffc46b8eb9e8	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	1683134b-ab43-494e-b727-4c07ef67e525	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	1683134b-ab43-494e-b727-4c07ef67e525	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	213d5326-df0b-4e32-ac39-3dea069a6e7d	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	213d5326-df0b-4e32-ac39-3dea069a6e7d	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	83ac2bcd-2011-43fb-b5cc-cea3cdd17173	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	83ac2bcd-2011-43fb-b5cc-cea3cdd17173	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	88067829-2bb5-43e0-8de7-7b234f971a0d	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	88067829-2bb5-43e0-8de7-7b234f971a0d	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	b389451d-5f5d-43c8-aae2-0cc8e8833a65	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	b389451d-5f5d-43c8-aae2-0cc8e8833a65	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	4bb55d21-28fd-432e-9316-afcdeef6a78e	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	4bb55d21-28fd-432e-9316-afcdeef6a78e	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	2d86ce4d-d5f7-49c0-b112-4dfb9bf6fed9	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	15c6f56b-e8f5-4d9e-a698-09de205e05d6	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	15c6f56b-e8f5-4d9e-a698-09de205e05d6	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	94bc80e1-0853-4e46-845c-ce4e591c78f8	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	94bc80e1-0853-4e46-845c-ce4e591c78f8	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	46f7d566-d6f3-4f96-90dc-b41ce41f1c76	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	46f7d566-d6f3-4f96-90dc-b41ce41f1c76	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	dc328c99-e50e-4d40-ae3c-f19ee7630225	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	dc328c99-e50e-4d40-ae3c-f19ee7630225	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	e61b8693-19ca-4f51-9e8a-751972120263	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	e61b8693-19ca-4f51-9e8a-751972120263	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	4cdd3b42-754a-472f-85fb-869baf06d8b7	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	4cdd3b42-754a-472f-85fb-869baf06d8b7	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	00f84872-99e7-4665-8bda-ba5db2154fd0	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	00f84872-99e7-4665-8bda-ba5db2154fd0	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	d885bfdd-ada6-4f52-9b42-e5377b850365	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	d885bfdd-ada6-4f52-9b42-e5377b850365	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	9f5ee5c5-c03b-4a23-94f0-ee3212353e5d	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	9f5ee5c5-c03b-4a23-94f0-ee3212353e5d	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	a1f418f5-ac08-4aa4-964f-b7e1ece4e970	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	a1f418f5-ac08-4aa4-964f-b7e1ece4e970	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	17cebfa7-efa0-4ff7-a6fa-145a650889a4	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	17cebfa7-efa0-4ff7-a6fa-145a650889a4	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	80e66420-469a-4882-b628-b42d2370c3a8	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	80e66420-469a-4882-b628-b42d2370c3a8	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	50f82f94-a384-4fcd-8d59-f9f55d7c0a54	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	50f82f94-a384-4fcd-8d59-f9f55d7c0a54	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	d3f585bb-6d3f-4d2a-99ca-43e2afccaf51	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	d3f585bb-6d3f-4d2a-99ca-43e2afccaf51	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	9be818fe-58e1-422d-b7cf-6405ee68affb	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	9be818fe-58e1-422d-b7cf-6405ee68affb	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	00000000-0000-0000-0000-000000000000	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	00000000-0000-0000-0000-000000000000	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	bb82e390-6c91-4895-839e-724aca4b842e	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	bb82e390-6c91-4895-839e-724aca4b842e	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	90154d05-bead-49c8-ae28-ab55a8988aff	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	90154d05-bead-49c8-ae28-ab55a8988aff	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	5bfd9fa5-90c8-41f0-adff-8f74e5fd967d	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	5bfd9fa5-90c8-41f0-adff-8f74e5fd967d	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	e32e0735-f513-49c1-855f-6aff8aedf24d	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	e32e0735-f513-49c1-855f-6aff8aedf24d	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	e94920b3-cdcb-42cc-a1c9-706271466a79	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	e94920b3-cdcb-42cc-a1c9-706271466a79	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	85e3fce3-9846-43f4-9f6b-be6a43e75cb8	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	85e3fce3-9846-43f4-9f6b-be6a43e75cb8	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	9c9989ba-9df3-42c6-b570-858f4488604a	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	9c9989ba-9df3-42c6-b570-858f4488604a	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	1e503f74-c03b-4858-812b-ab2fb7962013	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	1e503f74-c03b-4858-812b-ab2fb7962013	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	b4e98951-2b31-4341-8cb9-0ace637890b4	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	b4e98951-2b31-4341-8cb9-0ace637890b4	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	4ca62851-4aeb-4c8f-983e-66f75e0bb58e	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	4ca62851-4aeb-4c8f-983e-66f75e0bb58e	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	ab53db60-3142-4699-8b57-a83db930db6b	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	ab53db60-3142-4699-8b57-a83db930db6b	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	783e5830-8daf-466a-9f16-69a430205432	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	783e5830-8daf-466a-9f16-69a430205432	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	3d4c3b0b-e864-40b7-b545-a0875792dcb4	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	3d4c3b0b-e864-40b7-b545-a0875792dcb4	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	50d42568-9c36-4575-b378-13435da8c336	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	50d42568-9c36-4575-b378-13435da8c336	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	760a27a7-e792-45ef-b6d7-9dc137eb5295	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	760a27a7-e792-45ef-b6d7-9dc137eb5295	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	09efe19c-e2de-4838-9312-17ad1496b800	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	09efe19c-e2de-4838-9312-17ad1496b800	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	3ba05389-454e-4b10-bab1-40c956853d67	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	3ba05389-454e-4b10-bab1-40c956853d67	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	5d1c46a8-f499-4217-a665-1c01c9237cfc	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	5d1c46a8-f499-4217-a665-1c01c9237cfc	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	fe5a6fe7-ab0f-47c4-9e5f-f7fbf13e20e6	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	fe5a6fe7-ab0f-47c4-9e5f-f7fbf13e20e6	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	a9789003-dd50-4ff2-828e-353627566500	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	a9789003-dd50-4ff2-828e-353627566500	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	1765069b-234f-4adb-b12e-58502d05a940	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	1765069b-234f-4adb-b12e-58502d05a940	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	2ac29a02-220a-4ae6-8b6a-4365333488b3	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	2ac29a02-220a-4ae6-8b6a-4365333488b3	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	86e5df0c-ca86-47a4-9754-d703c40f1683	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	86e5df0c-ca86-47a4-9754-d703c40f1683	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	d9b49c33-de87-4f50-9a1e-4868c4d65411	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	d9b49c33-de87-4f50-9a1e-4868c4d65411	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	2837fef0-7061-401e-b58a-9c1315c6eca2	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	2837fef0-7061-401e-b58a-9c1315c6eca2	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	4af74392-5f13-4a3f-8524-e298394fb647	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	4af74392-5f13-4a3f-8524-e298394fb647	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	28f669b1-6e32-4274-85a2-32426f618669	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	28f669b1-6e32-4274-85a2-32426f618669	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	3cdad4d0-a9d7-45e4-b6af-fd329100edda	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	3cdad4d0-a9d7-45e4-b6af-fd329100edda	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	1716f2db-eb40-4372-9e4c-9288170c2171	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	1716f2db-eb40-4372-9e4c-9288170c2171	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	b00921d0-b4b9-455a-b193-f4c08108e24e	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	b00921d0-b4b9-455a-b193-f4c08108e24e	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	35c243f1-80c5-4a72-a671-f8d67f09441e	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	35c243f1-80c5-4a72-a671-f8d67f09441e	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	7f9c1570-e913-470b-b3ff-62c727b0d57a	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	7f9c1570-e913-470b-b3ff-62c727b0d57a	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	9a46e688-aff8-4e61-bab4-463a870f1a68	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	9a46e688-aff8-4e61-bab4-463a870f1a68	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	0d3017ff-e40b-4959-bfea-7e8b9679d5d0	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	0d3017ff-e40b-4959-bfea-7e8b9679d5d0	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	4ff90351-9668-4ae6-9aaf-dab7a4d4c1a2	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	4ff90351-9668-4ae6-9aaf-dab7a4d4c1a2	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	89483c7b-b971-42a0-a131-d8a52d5fc939	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	89483c7b-b971-42a0-a131-d8a52d5fc939	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	e03b03b8-f367-4fc3-8ff6-42d6dbf799d8	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	e03b03b8-f367-4fc3-8ff6-42d6dbf799d8	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	3885755a-8330-4dd8-af6c-2e3698cf6399	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	3885755a-8330-4dd8-af6c-2e3698cf6399	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	60696bb8-04ed-4bf4-8348-ccc3caddb784	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	60696bb8-04ed-4bf4-8348-ccc3caddb784	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	712077a7-3cc8-4357-a696-7799060fdf15	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	712077a7-3cc8-4357-a696-7799060fdf15	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	cf940ab4-bfa5-4b83-bf6a-6b5346f09081	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	cf940ab4-bfa5-4b83-bf6a-6b5346f09081	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	5df88b9d-659c-4b96-b5f4-69e0122dee98	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	5df88b9d-659c-4b96-b5f4-69e0122dee98	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	96baeee8-461c-470e-a82d-1ca192725241	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	96baeee8-461c-470e-a82d-1ca192725241	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	713d3e38-b5c2-498e-8ed6-26120cecda0e	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
c36ef223-8c43-4804-afcf-1baaf9a5178b	713d3e38-b5c2-498e-8ed6-26120cecda0e	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
\.


--
-- Data for Name: map_principals_to_stages; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY map_principals_to_stages (id, stage, princial) FROM stdin;
\.


--
-- Data for Name: map_role_to_rule; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY map_role_to_rule (role, rule, mode) FROM stdin;
235d5092-4895-469b-ad92-ee77c1c70352	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
235d5092-4895-469b-ad92-ee77c1c70352	be2de51f-bd7e-4f11-ba63-7d3c56169664	group
3414fdcb-496e-410f-b41c-288f8f454cce	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
3414fdcb-496e-410f-b41c-288f8f454cce	be2de51f-bd7e-4f11-ba63-7d3c56169664	group
3414fdcb-496e-410f-b41c-288f8f454cce	1a80d738-94a1-4568-900f-fc77a1592127	member
3414fdcb-496e-410f-b41c-288f8f454cce	c488bb6b-e9c0-4775-af01-3dd83dc6a9cd	member
3414fdcb-496e-410f-b41c-288f8f454cce	5d4e3cde-fbae-4a6b-973d-f183bf6b73e9	member
7721aae1-6bf7-1014-996e-31e7601ac163	f58d7d69-7d7e-463c-8b89-a512dcf06ac1	member
7721aae1-6bf7-1014-996e-31e7601ac163	1a80d738-94a1-4568-900f-fc77a1592127	member
7721aae1-6bf7-1014-996e-31e7601ac163	be2de51f-bd7e-4f11-ba63-7d3c56169664	member
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY members (id, login, password, created, updated) FROM stdin;
ab7f951e-4a89-40e9-8476-b6b262da47fc	GubaevSoslan	261828d5a8fcd7782b456cf0dcd118d10a6bbb2ca39fc55c8d5bb9a352a2e327	2009-04-22 14:27:23+04	2010-08-11 19:32:02.708+04
39d40812-fc54-4342-9b98-e1c1f4222d22	ilyas	d3abe2a5e34f48d6e362606ca044f06e7fb77adb920a4b1a6845601b48443222	2010-07-30 19:52:16.988+04	2010-07-30 19:52:16.988+04
35ca2e58-3e19-4ff5-a289-8f83e0d2060b	shablon	53efc18fa6a132efb4c8f5524d3b5ce707cf179ee7fa0be3737486f95d540647	2009-04-28 17:39:26+04	2010-08-11 19:32:02.712+04
71c10522-7db0-4cde-9fbf-eafff1aec380	roint7	4c3aada37cf7fd3819b2da502a15f78f7ce5a2ce6d584b630344ff00dffc74ac	2008-06-18 00:00:00+04	2010-08-11 19:32:02.715+04
c86f13aa-6853-4a3c-88d4-bddbeae55561	roint17	03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4	2009-08-10 14:43:33+04	2010-08-11 19:32:02.718+04
8e457cab-f0f5-4878-80b4-4ee6c2448edf	nutcedar	d75c28d547b370b6d424fa075cc89196b7d55c040c5e20d57a4ac2cd2b956b42	2009-08-18 15:57:21+04	2010-08-11 19:32:02.721+04
894ca299-93f5-4f56-b415-f12f3cc22383	lozickaya	84f5e503630296f780d1c6d02593c1cdb5585bb5948adfcd3a4d838b9a370693	2009-08-24 14:36:33+04	2010-08-11 19:32:02.725+04
14257ad1-cdd2-4eeb-addb-2670fe7cc7ee	jezlov	6c26278a8a387ad58c4c296953b89e6f852e947be7d19e20a6db1cb04d232368	2009-08-24 14:38:53+04	2010-08-11 19:32:02.729+04
74bd326c-df70-4880-8e24-99a244b2cc61	firsova	5f49c85ed52c492098d75f08e6614db2dda5ad988ebd81c5da8e05fc9f039bfc	2009-08-24 14:45:13+04	2010-08-11 19:32:02.732+04
bf67a730-cb01-443d-848d-0d8c3b9f9d22	klishenko	3a5e6867fb13e7674543e1545d25fa916f9e8d2075f56a83b038ca2cca18bb48	2009-08-24 14:42:51+04	2010-08-11 19:32:02.735+04
22355bc0-4134-4a76-a49e-3d4e77ea7c3f	Nata	81e5582115fef4e202714098ab0805c19e59471272d68a6bd3b85a876c4b494c	2009-08-24 14:44:17+04	2010-08-11 19:32:02.738+04
baf0b57e-4726-4f69-99a0-c8cbf4d617fd	timkin	e83c1c4388ff0e57a76d5fc7aeb2ae76800665f6a5a2d63fe561c40d26ccd6eb	2009-10-05 15:51:16+04	2010-08-11 19:32:02.741+04
6bf8c21d-5c5b-4df9-b847-3f144df4dce6	kotofey	c1cf024576e9c756b252bd5035efc64c72c17affe236909ded190d266a5bfdf1	2010-01-12 11:30:44+03	2010-08-11 19:32:02.744+04
f2ee7c59-2462-486d-a989-917dda16fac5	irinag	3963317a2b410e5357f4d839787aedb9ceef495514fe5cd91f846ab3a59621e0	2009-08-20 14:07:18+04	2010-08-11 19:32:02.748+04
ee2259cf-4da2-4336-bb83-7b7bba626de5	kometa	b988b5837c24ad1987f31266e0246b0fdaaf7948714cfa2a9f7757c52977ff14	2010-01-21 15:02:27+03	2010-08-11 19:32:02.753+04
b17c817d-f19f-4cea-9eaa-fba4ef84e9d8	pimenov	665115b1ff8d4d3481efc931d7e2637658961f023e06421db3dffa2e44666789	2009-08-24 14:34:36+04	2010-08-11 19:32:02.756+04
85d8bd4f-e9d9-47e5-8f8d-dcfeb5eb6639	oleg3012	258d18044a8ac48a5a169b4de7c1b9a99f060e0a9950cbcc9b3a4af13e3e3ca1	2009-08-24 14:38:08+04	2010-08-11 19:32:02.76+04
bfd1515f-ad99-47f6-80cd-3aaf0df63ca2	Lena	422605fa39cbda76b85f09940ef447e653630bad9893d7e2d2ea1ce2fbca1432	2009-08-24 14:30:58+04	2010-08-11 19:32:02.764+04
9f2f4b11-7eab-46c8-9f8b-c117a4a9efed	shitikova	aeb028140ff7fea6de4683194a53c425f267069c1c043460858849b62dbbfba6	2009-08-24 14:37:32+04	2010-08-11 19:32:02.769+04
f68a5200-6383-4e3a-8d7f-608bad97ad70	juliak	fbc019a2f48d0e2a3ea54c2b1e64f7d90eb3de1e46be0b706dfd94a99f0bc938	2009-08-24 14:35:33+04	2010-08-11 19:32:02.773+04
9e5eb564-da2c-46a5-a08b-9626467f885a	Stepennaya	372aec8768d74ce44f44dec862c109ec9745cd4e403a0634f2ad2737ad4b55fc	2009-08-24 14:45:54+04	2010-08-11 19:32:02.776+04
04bff9ee-7671-4e9a-bb89-12387c7ad932	lenaz	d931a74fe3bb28deee7f370e404c97740113e325b75c41335fe7798fbbbb67cc	2009-08-24 14:43:37+04	2010-08-11 19:32:02.779+04
df7afcd2-1daa-4ee3-abf9-8294192b3880	barsukova	c0034605ea413370d5ad022b8d2f7fe33461bf6d7e5f4ac78f02c27b793673c9	2009-05-19 14:42:32+04	2010-08-11 19:32:02.783+04
64bf2e20-2d75-40fc-bf52-4e172ad70044	rush	07de067c359069a79ca56dabbb3d365a23c2f22db8e1e45783b1dd52fe653eae	2008-06-06 00:00:00+04	2010-08-11 19:32:02.786+04
ecac5566-2b2e-4f75-a80e-894d088bbfd1	user4	3667791642e38a8ab09987a0b5e051bdbb374937fd775cac9a8322c61a3ec0a2	2008-06-17 00:00:00+04	2010-08-11 19:32:02.789+04
c5406142-352b-4c0e-9ebd-0ec30f388b48	user14	04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb	2008-06-17 00:00:00+04	2010-08-11 19:32:02.793+04
95bc7b93-0db0-4b68-8132-f0f7d5123ed5	user18	04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb	2008-06-18 00:00:00+04	2010-08-11 19:32:02.796+04
9afc213d-6d00-45b5-a1dd-44bea751d202	user43	04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb	2008-06-18 00:00:00+04	2010-08-11 19:32:02.799+04
2350092c-d335-45e9-8e70-cf1d2dac3c64	user46	04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb	2008-06-18 00:00:00+04	2010-08-11 19:32:02.804+04
05483b9e-9a55-43e1-8d37-f58906d99a90	user48	04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb	2008-06-18 00:00:00+04	2010-08-11 19:32:02.807+04
5b419947-30e3-4102-8f6e-69fd43d2f1cc	user49	04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb	2008-06-18 00:00:00+04	2010-08-11 19:32:02.811+04
d495fa01-e51c-4371-a08b-c4fc204b6c35	user50	04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb	2008-06-18 00:00:00+04	2010-08-11 19:32:02.814+04
a7ee282e-3fe7-4311-aeed-f77dda102e07	user52	04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb	2008-06-18 00:00:00+04	2010-08-11 19:32:02.817+04
f3e9e179-4630-42da-9b44-b413f6820950	gzovsky	9baed8fceea6e36d36670d72429d909547165efc038c293a14a41ef2edf83141	2008-06-18 00:00:00+04	2010-08-11 19:32:02.821+04
a520841d-2032-4dbd-af63-2eebc475d846	Pan	fea379f0a133dd53f4c562ab2e9ed8b48e02a4b659467ea7d191769d091874c9	2008-08-05 09:58:28+04	2010-08-11 19:32:02.824+04
a6d38208-a092-4cb1-bfd7-1cbb79ea644f	zoint	723013d616bc63f2582fa6cacf7c10d035d02f5d50f50a9c16e97793380a2a33	2008-06-18 00:00:00+04	2010-08-11 19:32:02.827+04
2cb515b4-3b21-4d6d-848a-a491f8ccf631	balandyuk	e83c1c4388ff0e57a76d5fc7aeb2ae76800665f6a5a2d63fe561c40d26ccd6eb	2008-07-31 12:22:12+04	2010-08-11 19:32:02.83+04
f5bcaae7-9fac-45a8-9913-a1c2098c4a4a	roint8	ad1f3889d0032e7c2791053060e4c044837353325fbd42cdeeef65638ed31c2a	2008-06-18 00:00:00+04	2010-08-11 19:32:02.834+04
d6bc5a54-01be-4a60-9152-dc7ed8747887	arkusha	a405eba78bf2e6db44ebe0b28bbc9cdc449f9ac990d2029c50a15e6853cfdf20	2008-06-17 00:00:00+04	2010-08-11 19:32:02.837+04
a06888ca-d1ba-42fb-bea6-cdef22029bfc	roint1	576c85c584f60555c2a024cbb99dfbbdb5f58c3bdcf28dbc8ea315fd46a388f3	2008-06-18 00:00:00+04	2010-08-11 19:32:02.84+04
0c74ec20-d342-4b86-8a7a-69184e3bdaa0	roint4	592fbed6f4ef4a643b0c5dec00a9a32f69a4027aedb972265cd9237b7b31d564	2008-06-18 00:00:00+04	2010-08-11 19:32:02.843+04
c36ef223-8c43-4804-afcf-1baaf9a5178b	kai	f844ad6231ada5aa202a39fe48b28f113d32dfb0ab109e3d75110335b462e1a0	2008-07-03 00:00:00+04	2010-08-11 19:32:02.846+04
04ead111-9f16-4623-924a-c57b5e5eab06	karpis	11d8c0d1a5bc0a64b1ce1d5c3c2aaaa0587558848d84292a33ec8a51677cbb17	2008-06-18 00:00:00+04	2010-08-11 19:32:02.849+04
fa5f4153-c80d-49a0-be64-4dab3703fb96	morozov	3b8a55a123d2e1333c51705c33b4c1f91fa722aad3fe8d21f480964047d8693d	2008-06-18 00:00:00+04	2010-08-11 19:32:02.852+04
3c069ebd-2c2e-4901-a654-29d64ab1d87a	Sidorov	3d15365abf41b11946371a9dfa5fe6df87b30b3b8fb6c00293a6e87a859a40f6	2008-06-17 00:00:00+04	2010-08-11 19:32:02.855+04
a9a125d8-29bf-4a4d-8d96-18e97d242de2	gomianin	ea13f905c407d6d2790cd0a5554fce750fc7b8e489dac8b26bf5669925bb7eb5	2008-06-18 00:00:00+04	2010-08-11 19:32:02.859+04
48545562-b6dd-48b0-a705-a5704e1cd51c	vak	752ebad70688bc16544b295304a02a01627039b59cbdaea276d5d5d0d0bc6b2b	2008-06-18 00:00:00+04	2010-08-11 19:32:02.862+04
2e76de7d-29a8-4342-b5fb-231778431913	mishin	7b570d7f323872337620c1e5dcc349a6740978c7e18e370a3a5af18c17872c87	2008-07-31 12:34:14+04	2010-08-11 19:32:02.864+04
e8d65f73-ec52-476d-814f-6e3d3f9d8b4e	jrnlst	2dfff992926eae305179c98db7de33e7bf2b9483e1529d17b398e7d9be338b7a	2008-06-18 00:00:00+04	2010-08-11 19:32:02.867+04
b2944873-7a2d-41cb-8c79-370a21860bfb	nembutal	8098a5700aaad52248614e69047e7f0d42f99ede56010ce47e350af2384d9dce	2008-06-18 00:00:00+04	2010-08-11 19:32:02.869+04
b43b1632-06f9-4304-81aa-f4b25ee6c6ec	AlexVO	b79fc8d948435c9b8f54e78eb5ffe51e739618665ccbc44908314c4a6b243ebf	2008-06-18 00:00:00+04	2010-08-11 19:32:02.872+04
fba392ed-e4b5-48cf-b331-7e74f9392931	gena	9c8737c4d7c6be323f9cca6d673c3b7bdc7c6ed14bf93f7028c4794a90dd2d2b	2008-06-18 00:00:00+04	2010-08-11 19:32:02.874+04
862a0771-6946-4eb9-b50b-1d98f9eb53da	konop	72a2d4365f37780690ee9d05b9a173e9036187fbfd5b5ae61785c5d5b0bf8a8a	2008-06-17 00:00:00+04	2010-08-11 19:32:02.876+04
b7bae9b1-3bed-4b5b-800c-09fbdf6f0801	vlad	5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5	2008-06-18 00:00:00+04	2010-08-11 19:32:02.879+04
4c121319-d541-431a-9002-69030a521911	korrektor	6c703179a2a4e0a01467259dc35e7d8570c5201914fe6e9fb34f212fa098b737	2008-06-18 00:00:00+04	2010-08-11 19:32:02.882+04
a6eedcee-ffed-4700-8521-fa8aa2235a26	mish	f15c98a7a40b73f46303dc67b2b7720027a966c0bd9077bd7e5a5b2b4e86fde1	2008-06-17 00:00:00+04	2010-08-11 19:32:02.884+04
bc6f6808-1c4b-4256-ad33-992eb2e3908d	arbuzov58	8bf1872715ac95a12205ff61d325c809700f89d24d8a5163ae15bb6500729c9a	2008-06-17 00:00:00+04	2010-08-11 19:32:02.887+04
f013a3f3-b4d0-40e1-89ed-baa28f29bb65	roint2	6606753e5a126d7068012a526d44c3eb2f7fcd09d5faeb30c77dbfd87ca7e758	2008-06-18 00:00:00+04	2010-08-11 19:32:02.889+04
d52ba8a2-05ce-4952-a6c6-8f32706df7d0	tu-man	02cb24215266035457e660207710ded0b6b18d3999a3ad0144e9bb6d59c28bf0	2008-06-18 00:00:00+04	2010-08-11 19:32:02.891+04
55483b88-f08c-40db-ae7d-89390ea0f610	nechetov	f7ac69722a0706c533afa393b1574a761a073df0a8280094d3500a4bbc9c2877	2008-06-18 00:00:00+04	2010-08-11 19:32:02.895+04
4583bc6c-1186-4a30-a862-2d3563427903	leonov	ba3b2846e38ab687810b2fffda65cbe7b7beb7ae47d9025204bdb4f15cfdc69d	2008-07-31 12:30:55+04	2010-08-11 19:32:02.897+04
4f5ad92e-b3e7-4c54-937e-e70aa999c0c7	inprint	f1b496e73e077f417e51af7b698d3eee9158ee91126669f614ca33f0f8ad9a0d	2000-01-01 00:00:00+03	2010-08-11 19:32:02.9+04
ea63bd58-ecb6-4a62-8fa7-42bbc9612199	karpova	2dc97f87df1f1386c9b0283dcf68c9555256e0545870b9690f8c576f6b4aee5f	2008-09-03 12:09:02+04	2010-08-11 19:32:02.903+04
81469f35-ee9f-417b-b297-b99efbb0bbeb	kolodochkin	7c7b26f694c108b7beed5a4abc6686d4d5ecc06d9f21a29e822c4e7912ef5e2e	2008-06-18 00:00:00+04	2010-08-11 19:32:02.905+04
6fc40b58-59fa-4ba9-9790-cf847b28473f	roint6	ec54e99514663edb97adef400fbf34a77daae108303d3da8008a7dfb4cdf0f52	2008-06-18 00:00:00+04	2010-08-11 19:32:02.907+04
ecb1a1a2-43c8-459c-bdf7-5b1770b80c23	dobin	5b4ee83710d28e032bfb1c444dccd4c0358c4bd37f3c2115811beaadaf2200b5	2008-06-17 00:00:00+04	2010-08-11 19:32:02.909+04
3929853a-0636-4165-8b7e-51d36563599d	soloviev	bd08603e3c597df8f2e39c41fa0b51869e6d07fb8f206d90b0ebb3b0d92a7a70	2008-06-18 00:00:00+04	2010-08-11 19:32:02.912+04
04ec0a96-5485-4842-ab85-07ab46b7334e	foto	cb098bd0f44e3ebc343496a6a30182b2fbb6b69c4e2605ea8519ed8a3c762589	2008-06-18 00:00:00+04	2010-08-11 19:32:02.914+04
67fcabe2-644c-4f64-8ee4-7941f7eabea3	stepan	c07af124eb1998528f972580429a91b046c24485ebb7ff21354a87c79c7f7790	2008-09-09 13:54:30+04	2010-08-11 19:32:02.916+04
e630c359-10b1-45c1-96f7-153f449ffcaa	borovickiy	59cbec130380ef3653368aee47482d60fa5e34d7417c35fdfe4148267398e0ef	2009-03-29 23:48:50+04	2010-08-11 19:32:02.919+04
eeafe6cb-9a4e-4982-b50d-8854ab8bd5ec	redactor	03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4	2008-08-07 13:22:00+04	2010-08-11 19:32:02.921+04
d1888ad3-0a82-42e4-b56d-9e40dcbb1701	vlasov	a3fd67b81f4ea3c96753a7931e83f944c75e38f913f37bab1d3d2d8959f67a91	2009-02-26 23:44:23+03	2010-08-11 19:32:02.924+04
cd4c74a1-f17f-415f-92d4-ddfda4866d64	kozlov	9c7da494a06e21eb847c3863aed7533a240bf3da4f84c688c029bd79972470c8	2008-07-31 12:28:39+04	2010-08-11 19:32:02.926+04
34aed480-c47b-4777-921e-1b1422b50de5	roint9	0a95adbf8581859ae0cc477127abeaf4ad89916405c41855af8fbc482e1634e8	2008-07-31 12:35:57+04	2010-08-11 19:32:02.928+04
36db93a2-525f-482f-98bc-b7ea5634241a	kondrtieva	e3b5623d1fc9171023b6fc3023f7a1ce05145f9ee7508baa3206d815c8dad352	2009-03-29 23:50:35+04	2010-08-11 19:32:02.931+04
3a32d534-dd27-45a1-b6fd-b8841825c91b	panyarskaya	8e8bc7b93a00c6d16450586a5582e6be0a7cfa592ae3e5554219299df750e431	2009-03-29 23:51:10+04	2010-08-11 19:32:02.933+04
434e5b0e-52a2-4ae5-b62e-01744ad4a375	uzr	7d824ad37e366f330ef3d3bafb8dc8b18a5b07622e2830eac5966339d98a94b0	2008-10-30 12:32:01+03	2010-08-11 19:32:02.936+04
de1e3666-e037-471f-953e-fc044961e8e7	udin	b1624a48de24aa81052d82df5d65ad7706561f24d7b015540d1c933c495c945d	2009-02-26 23:30:05+03	2010-08-11 19:32:02.938+04
aee83f19-a826-4747-98bd-e46298e505ff	kodachenko	023e451cade76941ea8444ce0a8630e421e68baf8c7e07f818484945d153154b	2009-02-26 23:46:15+03	2010-08-11 19:32:02.941+04
457ca2f3-139b-4f6a-869b-b9f64b2ef194	lazareva	1df0eaec89161aa0d2f7364bd8ce2d718a7d6b2b652048173c5738c3f624e716	2009-02-26 23:46:39+03	2010-08-11 19:32:02.943+04
8f615ae1-e2d7-4379-842f-fd6ea993b6b4	dyachenko	968ade2ca3c2911805ddb8603a84da05d536b723b86c096fb1b3ff6ac0d56ee0	2009-02-26 23:47:24+03	2010-08-11 19:32:02.946+04
be80bb62-780c-4956-85e1-c7f5344613ea	zdorov	779d080ffddb9f7e27c98e3ed7e6afd0f54e164f696d5c05cf799c4cc489e77d	2009-02-26 23:48:00+03	2010-08-11 19:32:02.948+04
a3b4a538-79fb-49b9-bf23-6d20ca1aa387	samarin	7ddcad2f4337fe1b494fa793dce23eb6fe9d8c785ce42614d51a407f2a585549	2009-02-26 23:48:33+03	2010-08-11 19:32:02.95+04
4d9e010b-b82b-4e3e-abb0-921d43fe3ab2	turin	5cd5d53aaf0921c96cd417427baf52996517da365ebd7385ed3ebae1b59f5f29	2009-02-26 23:49:32+03	2010-08-11 19:32:02.953+04
b6bcd869-ef13-41ba-866f-a87689173774	galagina	7181d88057124cf0cf0db70eb33a5b82a92e16abe6b55d7ede7f1e5bb6fedbea	2009-02-26 23:50:16+03	2010-08-11 19:32:02.956+04
3eeacaa6-bd8e-416a-a4f2-7542b7345276	panchenko	45d5200f1e3934535a9f513165116b91e8560a42f6f72f916a95401a61b74d2f	2009-03-29 23:51:38+04	2010-08-11 19:32:02.958+04
181ca8c0-d8e0-4810-b1c6-c75b9c10fe1f	dahnovskiy	f35f1704d7be842e236f37d5996c78f4223daf0beb14579c0b4f81fb2470eebe	2009-02-26 23:44:52+03	2010-08-11 19:32:02.961+04
ae63e43d-2633-417e-b53e-b076102fc608	elena	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	2008-09-09 13:33:46+04	2010-08-11 19:32:02.963+04
9c9f8939-134e-475a-8fe0-363794d3bcf6	sub	45b2801858833eaa0d120dd09f4af854d5e998f2a33f480b8b82fe2d0f599e6b	2008-06-17 00:00:00+04	2010-08-11 19:32:02.965+04
1ae159bb-cc3f-4f02-88a6-1d6a747461ae	mkor	02e6295d8f522840f09b5194b3f023799ad6ed3306d9296005787e792224df20	2009-02-26 23:49:56+03	2010-08-11 19:32:02.967+04
75b40dcc-77df-41ab-a90e-0ab14ee70d60	borissenkov	cbc8a597a67c465497550c4a4a7eebdb138442c06be06a78cc1ee8715658ff44	2008-06-17 00:00:00+04	2010-08-11 19:32:02.97+04
f892432f-4714-4660-8e97-114aeef555a6	smirnov	a0bd500821a86e562ff1a1ab1d85caca8f3ddd287a0a3267536f9a1b7335cfb3	2008-06-18 00:00:00+04	2010-08-11 19:32:02.972+04
b7a4bdd9-5f5e-4ba2-ac2e-d9f65bc39c4c	dolgaya	4a46efa4b44b711db8f756ff71b8502bd604d1fc6cc1f7004de38899e3a829df	2009-02-26 23:47:03+03	2010-08-11 19:32:02.974+04
0cd9ec5d-181a-41de-a372-af33436b1ab9	zgr	48f599a9094eb9a4fcd2ff73dd158208d3a2e0d8769a32e3c3795fc8791a0a71	2008-06-17 00:00:00+04	2010-08-11 19:32:02.979+04
3b389517-6113-4ad8-b99a-90c05f98b013	teremenko	cdd8da6646b548909ff80d950e93dedd0f0f48da55a8002f2534106709443b8f	2008-08-12 13:57:46+04	2010-08-11 19:32:02.981+04
7d8fd058-6d07-4c3d-a267-95dbb34bb982	Morj	f7ac69722a0706c533afa393b1574a761a073df0a8280094d3500a4bbc9c2877	2008-06-18 00:00:00+04	2010-08-11 19:32:02.983+04
ff2dc078-3b41-49cc-9d8f-fe1b05a13547	ermolaev	5142601592a8eb81417ac153f4ea8b01e2b0ecbecd582f37d493158f02b112a6	2009-02-26 23:45:47+03	2010-08-11 19:32:02.986+04
b366e89e-6ddc-4681-96e9-69fe3917ba3f	prokhorov	9c677310d6079d7cb203d166c60f04ef1a3932697a633af520d0bfe3535d7552	2009-03-29 23:49:23+04	2010-08-11 19:32:02.988+04
b01445bb-591c-46f7-9c26-ee49447c122a	Sveta	5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5	2008-08-08 10:59:59+04	2010-08-11 19:32:02.99+04
2d35168f-b729-4053-8177-2a9cd3fbb472	vorontsov	9c5c18ed7f0440996d99ee23540d3d4f667523a24630ce12b2bb86e3095ff7db	2009-02-26 23:43:44+03	2010-08-11 19:32:02.993+04
26ceb965-33d2-479d-b9e6-d64825118c78	marshalkin	ae70ac14fb00fdeb62f7959d570837a2bfe2aa83ea32974db2a9d9c17816bc2d	2009-03-10 12:11:08+03	2010-08-11 19:32:02.996+04
b23d0504-a5a9-436c-9956-ac01c1620268	kurlapov	6120002cb13ff41c7fb906c378151ee4c4e29dec47ee2ee06d07964b4a7c1c03	2009-04-09 12:23:32+04	2010-08-11 19:32:02.998+04
d74815ad-81a0-48ab-9d6e-4b0d02c9a817	mbmoto	3624ba5366aed439d3362bcc9515bda3529d0dd5ea5624831fdbda2dc4150d1f	2009-03-12 11:48:42+03	2010-08-11 19:32:03.001+04
41f453f3-88fd-4e0e-bd9c-a388dd528b52	chernyshev	b1b63e16876f0668ce77e31828c5f73ddda9ad8fda49a558c018d3a1b139f183	2009-02-26 23:48:17+03	2010-08-11 19:32:03.004+04
2c3a2637-557c-49c6-a6be-83eb343027d7	plaha	c313837f2a3539786b57adf2a347864f8be57245b4f2f4005ae436112d3a1ab8	2008-06-06 00:00:00+04	2010-08-11 19:32:03.007+04
16197fd8-1e7f-41ce-9d30-ff4b65939cca	mashburo	2afe7e4d26a79cbca351b9da6ee2c0be7cdd517c35f3aa449d91c27ce5e20535	2008-08-07 13:02:11+04	2010-08-11 19:32:03.009+04
0c9025a7-6c59-4b3e-a79d-2388321ac4f0	asatur	baa480a44618f05c95845ede16cef609216eb9d80a4ae06376c592e7f9dc19a4	2009-03-17 15:06:34+03	2010-08-11 19:32:03.012+04
117b5b1a-cd71-4a26-a30f-8381b33ea40b	kvas	09c587fb282c3423f0867eb10c37a6fd4e3a157865efbf7bccfd51621e9940c1	2008-07-31 12:26:06+04	2010-08-11 19:32:03.014+04
ef168a69-2451-4716-8f43-d9c70ee84bc9	baryshev	e51d8132c770bc26353db99f0e45a7e7233a8ffeea1e2882c98968363bea7fd6	2008-08-13 17:50:27+04	2010-08-11 19:32:03.016+04
88106be4-54ef-4281-85b3-239c3ccf6bb3	nbgjuhfabz	20c140d0c4ec4dfc0a5839cf1670849edfde7925206c976d20855a52c53e66c0	2009-03-27 21:11:03+03	2010-08-11 19:32:03.019+04
b1c0524c-7568-4aae-bfb1-a57b1b71eba0	pd	9b362f502df33eeab16c548c99902239927167ba674426bef7c2872a3cf5c6ac	2009-03-29 23:46:47+04	2010-08-11 19:32:03.022+04
ff09c497-a5f9-443d-b77f-5a25663d2100	mordovcev	9d32f1abae62c1f11252925981d32384c928f97d8d3ada92901aadd79903f2a0	2009-03-29 23:47:34+04	2010-08-11 19:32:03.024+04
8740b2c1-0e83-498b-9866-1023cc943399	mandrusov	445439a06b9c2e399ef881270d45ed5c0094fbf0adf2c5739af0e55dc6bbb062	2009-03-29 23:48:18+04	2010-08-11 19:32:03.027+04
bfbcbf9e-61ad-43e7-9e5f-4e72d522981e	chernykh	c60ddfb09de56129801eca17a3ae98c2abef1250de1902a7e9b194f413873c69	2009-03-29 23:50:03+04	2010-08-11 19:32:03.029+04
f93cd231-c2cc-49e2-9d25-66dbac0f8bd4	sukhov	9cd79809eb7d66fc2b91232cfc7067a9dd6ed6bd576ca5388c7e1835e8b467fd	2008-06-17 00:00:00+04	2010-08-11 19:32:03.031+04
5d927faf-fcc3-4ffe-b425-82f3ba76826c	reaper	6161b0a284159565a0f7d5df2dd2698b5f87906cd91ff5322caf179b451f5a41	2009-04-07 15:27:38+04	2010-08-11 19:32:03.033+04
f37f2350-fd4e-4153-81e1-a3de49a0cae4	site	fbae041b02c41ed0fd8a4efb039bc780dd6af4a1f0c420f42561ae705dda43fe	2009-04-23 12:38:26+04	2010-08-11 19:32:03.036+04
4a3d3c86-ce1b-43f3-9ff2-f18b8df86d95	095max	a416b856dd017f606874ee5d0b22cd72516baccf68a294cd9a5038c9decd63aa	2008-06-18 00:00:00+04	2010-08-11 19:32:03.038+04
1a652482-ade8-4809-b836-681cf82cb532	kutovaya	6e585169cd156ef933d5692c803fe3d8315003685a034abb93f6876011b06415	2009-03-25 12:03:51+03	2010-08-11 19:32:03.04+04
89f5c39b-1b0a-4ebe-9e0b-5f72397d943d	garyaev	753a9a26a44fcbd92c74c900c6f088dafc6cd061f11120b386fa01753abd800a	2009-05-07 14:43:37+04	2010-08-11 19:32:03.043+04
2386d6fe-7c43-46dd-9ea2-92670c50c743	liza	cc5407cf51196462ddfd9496960f9e7c32906cc248b7e0bd24b2f74fb8dd83b3	2009-10-21 13:33:22+04	2010-08-11 19:32:03.045+04
d62fb09d-f4da-4561-8e1f-4c7d4ca5f65a	leonid	2eaec43092610b78c4ca4325022300df71d55322d32c79e39938fb329e3c2f56	2009-08-20 14:06:51+04	2010-08-11 19:32:03.047+04
046a7805-8dd7-4f9e-a21b-45dbc9b9c78e	Sokol	ea8da5fde6ee939c0d9700e3cb679856df3a7b4a6f39989554d20367681d369c	2009-08-24 14:35:10+04	2010-08-11 19:32:03.05+04
afe06e6c-552b-4b30-b13c-f9b8515cc252	boyko	a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3	2009-08-05 13:59:04+04	2010-08-11 19:32:03.053+04
201b8bb4-e560-4548-a55c-d9f8bad1c17e	nigma	461c919e2ad71a1661acdae814b6d63bd6f261f9f5c1ce118f7db097b9fae97a	2009-08-24 14:31:25+04	2010-08-11 19:32:03.055+04
0a7b47c6-c882-45ac-be78-b7fdadea1656	fedorov	fe2ff08d848707c3e8b6e261c78d7d363f9be5a6a5f8a55552e6b79dcbe98575	2009-08-12 12:31:12+04	2010-08-11 19:32:03.057+04
a9e3e7a0-9d3b-410a-b2d8-09ca826e3a6c	olga	0ffe1abd1a08215353c233d6e009613e95eec4253832a761af28ff37ac5a150c	2008-08-14 14:07:04+04	2010-08-11 19:32:03.06+04
37245b73-0c9f-4a71-86db-7fcfd0ebcda8	mihalchev	a3c634612623689ca8d393b05c7133c3ef4a5aa6e1904d49f53d6981b14dbd57	2009-08-24 14:29:49+04	2010-08-11 19:32:03.062+04
089d2f8c-e623-4195-b7b1-e5bd5c3f5f3e	koshkina	48c992f999e82f7e699d222dd4012a9d7904833e9a0725f4266ba251e7655c20	2009-08-24 14:36:07+04	2010-08-11 19:32:03.064+04
7434e003-6b61-4736-bab5-6bfcd1d09e7f	russkih	763268845c7dfd7874da066eec488955ab972d5f4ac076c2eecfff2d9ce91492	2009-08-24 14:37:05+04	2010-08-11 19:32:03.066+04
1d6dcd3a-a919-426a-a896-a0e6d127c2ea	elina	b2ca613e3a17a7c19fc325570b2bedff10ad564fe06b36693677537c7b547cea	2009-08-24 14:37:51+04	2010-08-11 19:32:03.069+04
191e7e82-1f84-44d6-afd6-88c7fa5dc697	uharov	7627c37e9a0b2b3fbcc241878a8a9becb3bfeebc68b17b06a4b0e84b1899c839	2009-08-24 14:42:32+04	2010-08-11 19:32:03.071+04
c2d15d41-d069-46ad-9bd5-fb9f96ae2509	balashovan	ec151ec8d771b59db7dc41d0408cc83c62fa3acb305c4fd1e65b257a89102eac	2009-08-24 14:45:32+04	2010-08-11 19:32:03.074+04
d5e1219e-a729-4a3a-a21a-9b2b6407900b	tolkacheva	ddccc3ee9995501ffca2f0efa79b2ac2ab04e7e5a17ceeb35d128bcf259f90a7	2010-02-08 16:36:39+03	2010-08-11 19:32:03.076+04
935d3a03-a55b-4235-b9b1-98c60edafd0d	mps	b2bf2bb7e7ab19b90d4c1022499ba52e436f0c9e2778a17fcd62c71df738d3c6	2008-06-17 00:00:00+04	2010-08-11 19:32:03.078+04
60380170-8ece-40db-b3de-320e11bcf365	cvetochek	ed4bcde84b44ee07370cb95a634596854fddd9480205db812494f6546694300d	2009-08-24 14:43:14+04	2010-08-11 19:32:03.081+04
16f0f7e7-b59d-4c83-aea5-6cb31dd8375e	masha	5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5	2009-02-26 23:48:54+03	2010-08-11 19:32:03.087+04
1a63e582-5cd1-4b89-97fe-1d4de00bda5d	sasha	be47addbcb8f60566a3d7fd5a36f8195798e2848b368195d9a5d20e007c59a0c	2010-01-20 15:00:39+03	2010-08-11 19:32:03.089+04
e3234892-467c-4009-b4e8-f77e989d81fb	arkk	964b2df641e08c0bdf97caeef9a54aafedb0635fe55123c444b4f8c64801ba1f	2010-01-21 15:15:21+03	2010-08-11 19:32:03.091+04
a80159b2-1289-4c68-9801-655192aa7a49	alenka	0c6f5f65089b08a01db873390637b67eda21928cb7a433fcc59d04cceb24e6d6	2009-08-24 14:44:45+04	2010-08-11 19:32:03.094+04
c72e677e-feed-4b25-9104-556ae5c3d2f6	nikita	3e8cc52e339c9a17e00959b8f6e4e55fa7bf0718261c1f3819750eeef20ba822	2009-08-24 14:38:31+04	2010-08-11 19:32:03.096+04
092eea35-1f7f-4fc2-aa48-41625c084df0	Yurchenko	c2a181d8178a9f753b013fc4bb892ceeb5dc5bcb763352610844b93341ea52a4	2009-02-26 23:28:43+03	2010-08-11 19:32:03.099+04
0e5db04a-3fca-4d81-b38d-adb1ac00f74a	marusia	40771a76e8746afe558b09bacb9191e701500b91ebd112cd527a3183341657c0	2009-08-24 14:43:57+04	2010-08-11 19:32:03.101+04
c357e368-77c6-42a4-8db1-18e172193e73	delgado	541e79dce70b1842ab891d404ac5fb4dee5b920734d668ef33be4b3e7d8240b0	2010-01-27 17:08:13+03	2010-08-11 19:32:03.103+04
e3b448b8-9d9a-4ccd-bfbb-1742f8c818c8	dasha	03df2e5fa6ba5dcdd43ba9ce80b2955dbddd2f914182c58bb882b44748d0ab00	2009-09-21 13:38:54+04	2010-08-11 19:32:03.106+04
356e53b0-539f-40fe-b8bc-a16376c9daaa	koltun	60a2994be7d4731c6262b6da3e3ed2d95a5cae18f8698dbd833f6ee3b675927a	2010-08-04 12:14:45+04	2010-08-11 19:32:03.108+04
41af4948-123f-47fd-b840-6921adb63088	redkina	1c0c2945a938584cac03e4aaeda62e67561a077ba5d5189e2d15e9ddd3270fa9	2010-08-04 12:15:30+04	2010-08-11 19:32:03.111+04
ce99662c-7898-4485-aad9-7264a5c0a1d9	savchenko	bec3d16ee098c5fa0b41babd84d19454114ca110ccdf8004aa40ff10f557a691	2010-08-04 12:16:31+04	2010-08-11 19:32:03.113+04
b4af4681-7706-4f23-b0df-c4340356a5a0	mihalev	15d954322910f03ce387700a7d9998abf9ed3575591a148be1e4d2675740bf2c	2010-08-04 12:17:36+04	2010-08-11 19:32:03.116+04
c3b42312-eac4-400c-b523-2ad65b1f406a	ustinov	6122afd29a619dcba74f1ca2828958d974de5df2b3951856995a0de0955efad8	2010-08-04 12:18:35+04	2010-08-11 19:32:03.119+04
c9024aa0-b5ea-427c-80ac-96e15f22cb12	dorohova	1187a39d1dcc58a1c09cdc3f8d67e6ce6f2e666d03fa73af39b7d99ca48fb8d1	2010-08-04 12:19:49+04	2010-08-11 19:32:03.121+04
b89663e2-11af-476f-84c1-e49d24407070	Kolchev	b4b6e5deeec1253972cd0ec230e2951c5b2518c19cf9aa4198ee8731fee58795	2010-03-22 16:39:26+03	2010-08-11 19:32:03.123+04
49de597d-2871-42da-889f-e85852162d0b	nickg	cae38d8cf7607a1dc4cf5dd762b0039da9b2e5c9169a13617abd9f5d78448ff8	2010-02-25 12:03:13+03	2010-08-11 19:32:03.126+04
ba51dbc9-bff8-40e4-bbe8-2b283ec8f94b	Kopotov	95b6631de31572769c189d43d6a40a7e15f2e87535adce80d9bb8a7461b8572c	2010-04-08 12:33:17+04	2010-08-11 19:32:03.128+04
afd137a8-f8a4-47c7-8263-bc33857fe223	Stinger	907c1223fc5bac40917748dd565b812ed7db1b1741d28047b30b64c119504c59	2010-05-17 14:03:49+04	2010-08-11 19:32:03.13+04
1f8ef3b2-3980-4327-a62b-11bd1b643043	samoylova	ff917f71ac8064753319fd0c246c2ab6aa66e066b424bf6a75049180827afa62	2010-08-04 12:20:33+04	2010-08-11 19:32:03.133+04
d363dfbd-926a-4d88-9047-da0fe90d06d3	Tyurina	c9a02cdbafbb7564129f72e3472f359ff6f2be6202f9a9192310606a10e6ce68	2010-03-26 14:32:50+03	2010-08-11 19:32:03.135+04
127bc976-6e7b-4b43-8412-b688c321b716	ulanova	a82e05b77b413eb9f22e9046e68da0cace3eb296f1224aebb10db8749055d8d2	2010-08-04 12:21:44+04	2010-08-11 19:32:03.137+04
24a9dd37-8138-45e0-a543-ec865089438a	churkina	0b5ebdd5d3d97d4fa51577311a122ed14267d7ec881b9de61f2c11422f80c7a0	2010-05-21 16:34:07+04	2010-08-11 19:32:03.139+04
7c740887-599f-4077-8e74-7531dba0742b	Vladimir	8ec3e99ade3055c2b616ee759de9a3ee9b672ad18959438137481b55bc69e8d0	2010-05-19 18:20:45+04	2010-08-11 19:32:03.142+04
e486905b-7bcf-47eb-ac0f-9dd745c1a2b9	Wong	fafbecde6511ef5baa7938fba725e2aac83ae055235ce7ccca76b648e44c05e4	2010-07-19 13:46:39+04	2010-08-11 19:32:03.144+04
bc7c2ef7-d61c-43c3-b5c7-f0b6c262bbce	Ptiza	55d6be8ee934b026f4ff68fbd5cdbb85f1429953ec5e49ef06399537f29b8b01	2010-08-02 11:24:34+04	2010-08-11 19:32:03.147+04
0cfe7daa-b3aa-4f04-9eb5-30bc420e433a	Legat	34fcdc810c668f0754c8f2299151950dd73614fb8aecf0c2d87e5ed98e1b930d	2010-08-02 12:51:52+04	2010-08-11 19:32:03.149+04
14ac6931-6ca2-4a59-97d3-ccdb179869eb	melnik	8c71c6fc01b684283c8b7762b34c09459c0746313a6eae052a67d7a8ea0a9293	2010-08-04 12:06:10+04	2010-08-11 19:32:03.152+04
0b33d92c-f4d6-49cd-a136-89fc777b8a3d	platonov	77b3c37f471b9881df2c9568accaf009d3e4fcf3849d1cfe45868a9439d3de11	2010-08-04 12:07:29+04	2010-08-11 19:32:03.154+04
841abf3c-d9e9-4ff7-b7b4-aaa687ac0edf	brevdo	8ef59b86cd372cd25f55fa38356afcf86dc6914f973c6629b265da469556a124	2010-08-04 12:08:30+04	2010-08-11 19:32:03.156+04
84735f6b-fc94-4cc7-a771-c660e93b1520	voronkova	32e6db74067886d4fbf4d050b2279754295032bdf83900a3522eb0e3fc7ffbb4	2010-08-04 12:09:37+04	2010-08-11 19:32:03.159+04
d291b4b9-fe8e-470d-aab2-eaf78588f1a5	levchenko	aeaef54eaf1cb4f92f0209f4f7687ab7cd377e8d6cccaae5815f22af8bf33574	2010-08-04 12:10:43+04	2010-08-11 19:32:03.161+04
b7a4e3f9-bbb3-4f57-9648-7e3b78184697	goncharov	2f0aa2844c3fc8d4f32aa42a7097938f309cc498f7d98ace1d13f20cf35764af	2010-08-04 12:11:47+04	2010-08-11 19:32:03.163+04
388a9b14-d368-41cb-8484-45887de55fcc	nikolaeva	135b0ed201f5e63a814d3783ecb306968ff249128994e2e55317166b45ee857d	2010-08-04 12:12:53+04	2010-08-11 19:32:03.165+04
578fd168-eba6-4011-867c-7b0529e1e93e	sergeev	31a3f8d7c14e0b057fcbc787a932c1b01a72d68192223be6942ed8214d3fc266	2010-08-04 12:13:45+04	2010-08-11 19:32:03.168+04
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY profiles (id, title, shortcut, "position", created, updated) FROM stdin;
ab7f951e-4a89-40e9-8476-b6b262da47fc	Губаев Сослан	Губаев С.	Рекламный менеджер	2010-08-11 19:32:02.71+04	2010-08-11 19:32:02.71+04
35ca2e58-3e19-4ff5-a289-8f83e0d2060b	!Шаблоны, рыбы	!Шаблоны, рыбы	Шаблоны, рыбы	2010-08-11 19:32:02.714+04	2010-08-11 19:32:02.714+04
71c10522-7db0-4cde-9fbf-eafff1aec380	Сачков Максим Анатольевич	Сачков М.А.	заведующий	2010-08-11 19:32:02.716+04	2010-08-11 19:32:02.716+04
c86f13aa-6853-4a3c-88d4-bddbeae55561	Федоров Дмитрий	Д.С.	редактор	2010-08-11 19:32:02.719+04	2010-08-11 19:32:02.719+04
8e457cab-f0f5-4878-80b4-4ee6c2448edf	Самошкина Елена Юрьевна	Самошкина Е. Ю.	Верстальщик	2010-08-11 19:32:02.722+04	2010-08-11 19:32:02.722+04
894ca299-93f5-4f56-b415-f12f3cc22383	Лозицкая Л.	Лозицкая Л.	редактор	2010-08-11 19:32:02.727+04	2010-08-11 19:32:02.727+04
14257ad1-cdd2-4eeb-addb-2670fe7cc7ee	Жезлов А.	Жезлов А.	редактор	2010-08-11 19:32:02.73+04	2010-08-11 19:32:02.73+04
74bd326c-df70-4880-8e24-99a244b2cc61	Фирсова Т.	Фирсова Т.	корректор	2010-08-11 19:32:02.733+04	2010-08-11 19:32:02.733+04
bf67a730-cb01-443d-848d-0d8c3b9f9d22	Клищенко А.	Клищенко А.	главный художник	2010-08-11 19:32:02.736+04	2010-08-11 19:32:02.736+04
22355bc0-4134-4a76-a49e-3d4e77ea7c3f	Войлокова Н.	Войлокова Н.	цветоделитель	2010-08-11 19:32:02.739+04	2010-08-11 19:32:02.739+04
baf0b57e-4726-4f69-99a0-c8cbf4d617fd	Тимкин Юрий Леонидович	Тимкин Ю.Л.	редактор	2010-08-11 19:32:02.743+04	2010-08-11 19:32:02.743+04
6bf8c21d-5c5b-4df9-b847-3f144df4dce6	Кочетов Андрей Юрьевич	Кочетов А.Ю.	редактор	2010-08-11 19:32:02.746+04	2010-08-11 19:32:02.746+04
f2ee7c59-2462-486d-a989-917dda16fac5	Журавская И.	Журавская И.	зам. главного редактора	2010-08-11 19:32:02.749+04	2010-08-11 19:32:02.749+04
ee2259cf-4da2-4336-bb83-7b7bba626de5	Ежов Андрей Игоревич	Ежов А.И.	редактор	2010-08-11 19:32:02.754+04	2010-08-11 19:32:02.754+04
b17c817d-f19f-4cea-9eaa-fba4ef84e9d8	Пименов И.	Пименов И.	заведующий отделом	2010-08-11 19:32:02.758+04	2010-08-11 19:32:02.758+04
85d8bd4f-e9d9-47e5-8f8d-dcfeb5eb6639	Гетманенко О.	Гетманенко О.	заведующий отделом	2010-08-11 19:32:02.762+04	2010-08-11 19:32:02.762+04
bfd1515f-ad99-47f6-80cd-3aaf0df63ca2	Алексеева Е.	Алексеева Е.	редактор	2010-08-11 19:32:02.766+04	2010-08-11 19:32:02.766+04
9f2f4b11-7eab-46c8-9f8b-c117a4a9efed	Шитикова Е.	Шитикова Е.	заведующий отделом	2010-08-11 19:32:02.771+04	2010-08-11 19:32:02.771+04
f68a5200-6383-4e3a-8d7f-608bad97ad70	Копрянцева Ю.	Копрянцева Ю.	заведующий отделом	2010-08-11 19:32:02.774+04	2010-08-11 19:32:02.774+04
9e5eb564-da2c-46a5-a08b-9626467f885a	Степенная Л.	Степенная Л.	секретарь	2010-08-11 19:32:02.778+04	2010-08-11 19:32:02.778+04
04bff9ee-7671-4e9a-bb89-12387c7ad932	Зиновьева Елена	Зиновьева Е.	верстальщик	2010-08-11 19:32:02.781+04	2010-08-11 19:32:02.781+04
df7afcd2-1daa-4ee3-abf9-8294192b3880	Бaрсукова Юлия	Бaрсукова Ю.	Рекламный менеджер	2010-08-11 19:32:02.784+04	2010-08-11 19:32:02.784+04
64bf2e20-2d75-40fc-bf52-4e172ad70044	Алексеев Аркадий Викторович	Алексеев А.В.	руководитель zr.ru	2010-08-11 19:32:02.788+04	2010-08-11 19:32:02.788+04
ecac5566-2b2e-4f75-a80e-894d088bbfd1	Тилевич Марк Григорьевич	Тилевич М.Г.	советник главного редактора	2010-08-11 19:32:02.791+04	2010-08-11 19:32:02.791+04
c5406142-352b-4c0e-9ebd-0ec30f388b48	Торичный Петр Петрович	Торичный П.П.	инженер	2010-08-11 19:32:02.794+04	2010-08-11 19:32:02.794+04
95bc7b93-0db0-4b68-8132-f0f7d5123ed5	Жаринов Валерий Игоревич	Жаринов В.И.	инженер ЛТЦ	2010-08-11 19:32:02.797+04	2010-08-11 19:32:02.797+04
9afc213d-6d00-45b5-a1dd-44bea751d202	Воеводов Олег Александрович	Воеводов О.А.	Художник 	2010-08-11 19:32:02.801+04	2010-08-11 19:32:02.801+04
2350092c-d335-45e9-8e70-cf1d2dac3c64	Батыру Александр Петрович 	Батыру А.П.	Фотокорреспондент 	2010-08-11 19:32:02.805+04	2010-08-11 19:32:02.805+04
05483b9e-9a55-43e1-8d37-f58906d99a90	Садков Георгий Алексеевич	Садков Г.А.	Фотокорреспондент	2010-08-11 19:32:02.809+04	2010-08-11 19:32:02.809+04
5b419947-30e3-4102-8f6e-69fd43d2f1cc	Якубов Константин Михайлович	Якубов К.М.	Фотокорреспондент	2010-08-11 19:32:02.812+04	2010-08-11 19:32:02.812+04
d495fa01-e51c-4371-a08b-c4fc204b6c35	Ветохин Евгений Анатольевич	Ветохин Е.А.	Вед. Спец по сканированию	2010-08-11 19:32:02.816+04	2010-08-11 19:32:02.816+04
a7ee282e-3fe7-4311-aeed-f77dda102e07	Кузнецов Михаил Николаевич	Кузнецов М.Н.	Литсотрудник	2010-08-11 19:32:02.819+04	2010-08-11 19:32:02.819+04
f3e9e179-4630-42da-9b44-b413f6820950	Гзовский Михаил Владимирович	Гзовский М.В.	редактор	2010-08-11 19:32:02.822+04	2010-08-11 19:32:02.822+04
a520841d-2032-4dbd-af63-2eebc475d846	Панярский Виктор Владимирович	Панярский В.В.	Предс. сов. директоров	2010-08-11 19:32:02.826+04	2010-08-11 19:32:02.826+04
a6d38208-a092-4cb1-bfd7-1cbb79ea644f	Канунников Сергей Викторович	Канунников С.В.	заведующий	2010-08-11 19:32:02.828+04	2010-08-11 19:32:02.828+04
2cb515b4-3b21-4d6d-848a-a491f8ccf631	Баландюк Сергей Евгеньевич	Баландюк С.	редактор	2010-08-11 19:32:02.832+04	2010-08-11 19:32:02.832+04
f5bcaae7-9fac-45a8-9913-a1c2098c4a4a	Фомин Анатолий Александрович	Фомин А.А.	заведующий	2010-08-11 19:32:02.835+04	2010-08-11 19:32:02.835+04
d6bc5a54-01be-4a60-9152-dc7ed8747887	Аркуша Владимир Александрович	Аркуша В.А.	Шеф по тексту	2010-08-11 19:32:02.839+04	2010-08-11 19:32:02.839+04
a06888ca-d1ba-42fb-bea6-cdef22029bfc	Арутюнян Денис Сергеевич	Арутюнян Д.С.	редактор	2010-08-11 19:32:02.842+04	2010-08-11 19:32:02.842+04
0c74ec20-d342-4b86-8a7a-69184e3bdaa0	Клочков Сергей Константинович	Клочков С.К.	редактор	2010-08-11 19:32:02.845+04	2010-08-11 19:32:02.845+04
04ead111-9f16-4623-924a-c57b5e5eab06	Карпис Людмила Викторовна	Карпис Л.В.	Художник 	2010-08-11 19:32:02.851+04	2010-08-11 19:32:02.851+04
fa5f4153-c80d-49a0-be64-4dab3703fb96	Морозов Андрей Олегович	Морозов А.О.	редактор	2010-08-11 19:32:02.854+04	2010-08-11 19:32:02.854+04
3c069ebd-2c2e-4901-a654-29d64ab1d87a	Сидоров Андрей Васильевич 	Сидоров А.В.	редактор	2010-08-11 19:32:02.857+04	2010-08-11 19:32:02.857+04
a9a125d8-29bf-4a4d-8d96-18e97d242de2	Гомянин Максим Юрьевич	Гомянин М.Ю.	редактор	2010-08-11 19:32:02.86+04	2010-08-11 19:32:02.86+04
48545562-b6dd-48b0-a705-a5704e1cd51c	Крючков Вадим Юрьевич	Крючков В.Ю.	заведующий	2010-08-11 19:32:02.863+04	2010-08-11 19:32:02.863+04
2e76de7d-29a8-4342-b5fb-231778431913	Мишин Сергей Владимирович	Мишин С.В.	редактор	2010-08-11 19:32:02.866+04	2010-08-11 19:32:02.866+04
e8d65f73-ec52-476d-814f-6e3d3f9d8b4e	Никишев Вадим Валерьевич	Никишев В.В.	редактор	2010-08-11 19:32:02.868+04	2010-08-11 19:32:02.868+04
b2944873-7a2d-41cb-8c79-370a21860bfb	Зиновьев Сергей Викторович	Зиновьев С.В.	редактор	2010-08-11 19:32:02.871+04	2010-08-11 19:32:02.871+04
b43b1632-06f9-4304-81aa-f4b25ee6c6ec	Воробьев-Обухов Алексей Вадимович	Воробьев-Обухов А.В.	редактор	2010-08-11 19:32:02.873+04	2010-08-11 19:32:02.873+04
fba392ed-e4b5-48cf-b331-7e74f9392931	Емелькин Геннадий Николаевич 	Емелькин Г.Н.	Главный инженер ЛТЦ	2010-08-11 19:32:02.875+04	2010-08-11 19:32:02.875+04
862a0771-6946-4eb9-b50b-1d98f9eb53da	Коноп Эдуард Викторович	Коноп Э.В.	редактор	2010-08-11 19:32:02.878+04	2010-08-11 19:32:02.878+04
b7bae9b1-3bed-4b5b-800c-09fbdf6f0801	Крупчинский Владислав Викторович	Крупчинский В.В.	Главный художник	2010-08-11 19:32:02.881+04	2010-08-11 19:32:02.881+04
c36ef223-8c43-4804-afcf-1baaf9a5178b	z-Кай	K.A.I	Сотрудник тех.поддержки	2010-08-11 19:32:02.848+04	2010-08-11 19:32:02.848+04
4c121319-d541-431a-9002-69030a521911	Шин Клара Владимировна	Шин К.В.	корректор	2010-08-11 19:32:02.883+04	2010-08-11 19:32:02.883+04
a6eedcee-ffed-4700-8521-fa8aa2235a26	Мишин Антон Сергеевич	Мишин А.С.	инженер	2010-08-11 19:32:02.886+04	2010-08-11 19:32:02.886+04
bc6f6808-1c4b-4256-ad33-992eb2e3908d	Арбузов Владимир Александрович 	Арбузов В.А.	инженер	2010-08-11 19:32:02.888+04	2010-08-11 19:32:02.888+04
f013a3f3-b4d0-40e1-89ed-baa28f29bb65	Воскресенский Сергей Константинович	Воскресенский С.К.	редактор	2010-08-11 19:32:02.89+04	2010-08-11 19:32:02.89+04
d52ba8a2-05ce-4952-a6c6-8f32706df7d0	Юрков Олег Викторович	Юрков О.В.	Художник 	2010-08-11 19:32:02.893+04	2010-08-11 19:32:02.893+04
55483b88-f08c-40db-ae7d-89390ea0f610	Нечетов Юрий Алексеевич	Нечетов Ю.А.	редактор	2010-08-11 19:32:02.896+04	2010-08-11 19:32:02.896+04
4583bc6c-1186-4a30-a862-2d3563427903	Леонов Павел	Леонов П.	редактор	2010-08-11 19:32:02.898+04	2010-08-11 19:32:02.898+04
4f5ad92e-b3e7-4c54-937e-e70aa999c0c7	Администратор	Администратор	Сотрудник поддержки	2010-08-11 19:32:02.901+04	2010-08-11 19:32:02.901+04
ea63bd58-ecb6-4a62-8fa7-42bbc9612199	Карпова Ольга Владимировна	Карпова О.В.	корректор	2010-08-11 19:32:02.904+04	2010-08-11 19:32:02.904+04
81469f35-ee9f-417b-b297-b99efbb0bbeb	Колодочкин Михаил Владимирович 	Колодочкин М.В.	заведующий	2010-08-11 19:32:02.906+04	2010-08-11 19:32:02.906+04
6fc40b58-59fa-4ba9-9790-cf847b28473f	Панов Денис Юрьевич	Панов Д.Ю.	редактор	2010-08-11 19:32:02.908+04	2010-08-11 19:32:02.908+04
ecb1a1a2-43c8-459c-bdf7-5b1770b80c23	Добин Александр Эдуардович 	Добин А.Э.	редактор	2010-08-11 19:32:02.911+04	2010-08-11 19:32:02.911+04
3929853a-0636-4165-8b7e-51d36563599d	Соловьев Владимир Николаевич	Соловьев В.Н.	заведующий	2010-08-11 19:32:02.913+04	2010-08-11 19:32:02.913+04
04ec0a96-5485-4842-ab85-07ab46b7334e	Кульнев Александр Анатольевич	Кульнев А.А.	Фотокорреспондент 	2010-08-11 19:32:02.915+04	2010-08-11 19:32:02.915+04
67fcabe2-644c-4f64-8ee4-7941f7eabea3	Кузьменко Степан Николаевич	Кузьменко С.Н.	Директор РБ	2010-08-11 19:32:02.917+04	2010-08-11 19:32:02.917+04
e630c359-10b1-45c1-96f7-153f449ffcaa	Боровицкий Д.В.	Боровицкий Д.В.	Редактор	2010-08-11 19:32:02.92+04	2010-08-11 19:32:02.92+04
eeafe6cb-9a4e-4982-b50d-8854ab8bd5ec	redactor	NN	redactor	2010-08-11 19:32:02.923+04	2010-08-11 19:32:02.923+04
d1888ad3-0a82-42e4-b56d-9e40dcbb1701	Власов Антон	Власов А.	Зав. отделом	2010-08-11 19:32:02.925+04	2010-08-11 19:32:02.925+04
cd4c74a1-f17f-415f-92d4-ddfda4866d64	Козлов Игорь Юрьевич	Козлов И.Ю.	редактор	2010-08-11 19:32:02.927+04	2010-08-11 19:32:02.927+04
34aed480-c47b-4777-921e-1b1422b50de5	Крапивин Александр Михайлович	Крапивин А.М.	редактор	2010-08-11 19:32:02.93+04	2010-08-11 19:32:02.93+04
36db93a2-525f-482f-98bc-b7ea5634241a	Кондратьева Е.А.	Кондратьева Е.А.	Верстальщик	2010-08-11 19:32:02.932+04	2010-08-11 19:32:02.932+04
3a32d534-dd27-45a1-b6fd-b8841825c91b	Панярская М.В.	Панярская М.В.	Редактор	2010-08-11 19:32:02.934+04	2010-08-11 19:32:02.934+04
434e5b0e-52a2-4ae5-b62e-01744ad4a375	Сапожников Леонид	Сапожников Л.А.	Глав ред. ЗР Украина	2010-08-11 19:32:02.937+04	2010-08-11 19:32:02.937+04
de1e3666-e037-471f-953e-fc044961e8e7	Юдин Дмитрий	Юдин Д.	Зам. гл. редактора	2010-08-11 19:32:02.939+04	2010-08-11 19:32:02.939+04
aee83f19-a826-4747-98bd-e46298e505ff	Кодаченко Татьяна	Кодаченко Т.	Зав. отделом	2010-08-11 19:32:02.942+04	2010-08-11 19:32:02.942+04
457ca2f3-139b-4f6a-869b-b9f64b2ef194	Лазарева Лидия	Лазарева Л.	Зав. отделом	2010-08-11 19:32:02.945+04	2010-08-11 19:32:02.945+04
8f615ae1-e2d7-4379-842f-fd6ea993b6b4	Дьяченко Дмитрий	Дьяченко Д.	Тест редактор	2010-08-11 19:32:02.947+04	2010-08-11 19:32:02.947+04
be80bb62-780c-4956-85e1-c7f5344613ea	Здоров Владимир	Здоров В.	Тест редактор	2010-08-11 19:32:02.949+04	2010-08-11 19:32:02.949+04
a3b4a538-79fb-49b9-bf23-6d20ca1aa387	Самарин Николай	Самарин Н.	Редактор	2010-08-11 19:32:02.952+04	2010-08-11 19:32:02.952+04
4d9e010b-b82b-4e3e-abb0-921d43fe3ab2	Тюрин Дмитрий	Тюрин Д.	Фотограф	2010-08-11 19:32:02.955+04	2010-08-11 19:32:02.955+04
b6bcd869-ef13-41ba-866f-a87689173774	Галагина Наталия	Галагина Н.	Секретарь	2010-08-11 19:32:02.957+04	2010-08-11 19:32:02.957+04
3eeacaa6-bd8e-416a-a4f2-7542b7345276	Панченко Ж.А.	Панченко Ж.А.	Корректор	2010-08-11 19:32:02.959+04	2010-08-11 19:32:02.959+04
181ca8c0-d8e0-4810-b1c6-c75b9c10fe1f	Дахновский Борис	Дахновский Б.	Редактор	2010-08-11 19:32:02.962+04	2010-08-11 19:32:02.962+04
ae63e43d-2633-417e-b53e-b076102fc608	Елушова Елена Владимировна	Елушова Е.В.	Рекламный менеджер	2010-08-11 19:32:02.964+04	2010-08-11 19:32:02.964+04
9c9f8939-134e-475a-8fe0-363794d3bcf6	Субботин Вячеслав Михайлович	Субботин В.М.	заместитель главного редактора	2010-08-11 19:32:02.966+04	2010-08-11 19:32:02.966+04
1ae159bb-cc3f-4f02-88a6-1d6a747461ae	Карагодина Т.Ф.	Карагодина Т.Ф.	Корректор	2010-08-11 19:32:02.969+04	2010-08-11 19:32:02.969+04
75b40dcc-77df-41ab-a90e-0ab14ee70d60	Борисенков Евгений Владимирович	Борисенков Е.В.	заведующий	2010-08-11 19:32:02.971+04	2010-08-11 19:32:02.971+04
f892432f-4714-4660-8e97-114aeef555a6	Смирнов Сергей Васильевич	Смирнов С.В.	заведующий	2010-08-11 19:32:02.973+04	2010-08-11 19:32:02.973+04
b7a4bdd9-5f5e-4ba2-ac2e-d9f65bc39c4c	Долгая Наталия	Долгая Н.	Дизайнер	2010-08-11 19:32:02.975+04	2010-08-11 19:32:02.975+04
0cd9ec5d-181a-41de-a372-af33436b1ab9	Чуйкин Антон Витальевич	Чуйкин А.В.	Главный редактор	2010-08-11 19:32:02.98+04	2010-08-11 19:32:02.98+04
3b389517-6113-4ad8-b99a-90c05f98b013	Теременко Игорь Александрович	Теременко И.А.	Редактор	2010-08-11 19:32:02.982+04	2010-08-11 19:32:02.982+04
7d8fd058-6d07-4c3d-a267-95dbb34bb982	Моржаретто Игорь Александрович	Моржаретто И.А.	Заведующий	2010-08-11 19:32:02.984+04	2010-08-11 19:32:02.984+04
ff2dc078-3b41-49cc-9d8f-fe1b05a13547	Ермолаев Николай	Ермолаев Н.	Редактор	2010-08-11 19:32:02.987+04	2010-08-11 19:32:02.987+04
b366e89e-6ddc-4681-96e9-69fe3917ba3f	Прохоров О.А.	Прохоров О.А.	Обозреватель	2010-08-11 19:32:02.989+04	2010-08-11 19:32:02.989+04
b01445bb-591c-46f7-9c26-ee49447c122a	Тимохина Светлана	Тимохина С.	секретарь	2010-08-11 19:32:02.992+04	2010-08-11 19:32:02.992+04
2d35168f-b729-4053-8177-2a9cd3fbb472	Воронцов Александр	Воронцов А.	Зав. отделом	2010-08-11 19:32:02.995+04	2010-08-11 19:32:02.995+04
26ceb965-33d2-479d-b9e6-d64825118c78	Маршалкин Ярослав Сергеевич	Маршалкин Я.С.	expert to site	2010-08-11 19:32:02.997+04	2010-08-11 19:32:02.997+04
b23d0504-a5a9-436c-9956-ac01c1620268	Курлапов Павел Юрьевич	Курлапов П.Ю.	тест-редактор	2010-08-11 19:32:03+04	2010-08-11 19:32:03+04
d74815ad-81a0-48ab-9d6e-4b0d02c9a817	МБ-МОТО	МБ-МОТО	Оператор электронного набора	2010-08-11 19:32:03.003+04	2010-08-11 19:32:03.003+04
41f453f3-88fd-4e0e-bd9c-a388dd528b52	Чернышев Кирилл	Чернышев К.	Тест редактор	2010-08-11 19:32:03.005+04	2010-08-11 19:32:03.005+04
2c3a2637-557c-49c6-a6be-83eb343027d7	Рак Алексей Викторович	Рак А.В.	специалист по внедрению	2010-08-11 19:32:03.008+04	2010-08-11 19:32:03.008+04
16197fd8-1e7f-41ce-9d30-ff4b65939cca	Машбюро	Машбюро	оператор электронного набора	2010-08-11 19:32:03.011+04	2010-08-11 19:32:03.011+04
0c9025a7-6c59-4b3e-a79d-2388321ac4f0	Бисембин Асатур	Бисембин А.	web-редактор	2010-08-11 19:32:03.013+04	2010-08-11 19:32:03.013+04
117b5b1a-cd71-4a26-a30f-8381b33ea40b	Васильев Константин Владимирович	Васильев К.В.	редактор	2010-08-11 19:32:03.015+04	2010-08-11 19:32:03.015+04
ef168a69-2451-4716-8f43-d9c70ee84bc9	Барышев Михаил Борисович	Барышев М.Б.	редактор	2010-08-11 19:32:03.018+04	2010-08-11 19:32:03.018+04
88106be4-54ef-4281-85b3-239c3ccf6bb3	ТИПОГРАФИЯ	ТИПОГРАФИЯ	готовые материалы	2010-08-11 19:32:03.021+04	2010-08-11 19:32:03.021+04
b1c0524c-7568-4aae-bfb1-a57b1b71eba0	Поцелуевский Д.А	Поцелуевский Д.А	Главный редактор	2010-08-11 19:32:03.023+04	2010-08-11 19:32:03.023+04
ff09c497-a5f9-443d-b77f-5a25663d2100	Мордовцев Н.Н.	Мордовцев Н.Н.	Зам.гл.редактора	2010-08-11 19:32:03.025+04	2010-08-11 19:32:03.025+04
8740b2c1-0e83-498b-9866-1023cc943399	Мандрусов А.А.	Мандрусов А.А.	Гл.художник	2010-08-11 19:32:03.028+04	2010-08-11 19:32:03.028+04
bfbcbf9e-61ad-43e7-9e5f-4e72d522981e	Черных И.М.	Черных И.М.	Корреспондент	2010-08-11 19:32:03.03+04	2010-08-11 19:32:03.03+04
f93cd231-c2cc-49e2-9d25-66dbac0f8bd4	Сухов Анатолий Тильмекович	Сухов А.Т.	Главный редактор	2010-08-11 19:32:03.032+04	2010-08-11 19:32:03.032+04
5d927faf-fcc3-4ffe-b425-82f3ba76826c	Владимиров Максим	Владимиров М.	Тест-редактор	2010-08-11 19:32:03.035+04	2010-08-11 19:32:03.035+04
f37f2350-fd4e-4153-81e1-a3de49a0cae4	Site-editor	Site	Site	2010-08-11 19:32:03.037+04	2010-08-11 19:32:03.037+04
4a3d3c86-ce1b-43f3-9ff2-f18b8df86d95	Приходько Максим Игоревич	Приходько М.И.	редактор	2010-08-11 19:32:03.039+04	2010-08-11 19:32:03.039+04
1a652482-ade8-4809-b836-681cf82cb532	Кутовая З.	Кутовая З.	Менеджер РБ	2010-08-11 19:32:03.041+04	2010-08-11 19:32:03.041+04
89f5c39b-1b0a-4ebe-9e0b-5f72397d943d	Гаряев Лев	Гаряев Л.	редактор	2010-08-11 19:32:03.044+04	2010-08-11 19:32:03.044+04
2386d6fe-7c43-46dd-9ea2-92670c50c743	Кузьменко Ульяна	Кузьменко У.	Рекламный менеджер	2010-08-11 19:32:03.046+04	2010-08-11 19:32:03.046+04
d62fb09d-f4da-4561-8e1f-4c7d4ca5f65a	Климанович Л.	Климанович Л.	главный редактор	2010-08-11 19:32:03.049+04	2010-08-11 19:32:03.049+04
046a7805-8dd7-4f9e-a21b-45dbc9b9c78e	Соколова Татьяна	Соколова Т.	заведующий отделом	2010-08-11 19:32:03.051+04	2010-08-11 19:32:03.051+04
afe06e6c-552b-4b30-b13c-f9b8515cc252	Бойко Мария	Бойко М.	веб-редактор	2010-08-11 19:32:03.054+04	2010-08-11 19:32:03.054+04
201b8bb4-e560-4548-a55c-d9f8bad1c17e	Нигматулина Ирина	Нигматулина И.	выпуск. редактор	2010-08-11 19:32:03.056+04	2010-08-11 19:32:03.056+04
0a7b47c6-c882-45ac-be78-b7fdadea1656	Федоров Дмитрий Станиславович	Федоров Д. С.	Зам. гл.ред.	2010-08-11 19:32:03.058+04	2010-08-11 19:32:03.058+04
a9e3e7a0-9d3b-410a-b2d8-09ca826e3a6c	Кладовикова Ольга Львовна	Кладовикова О.Л.	Верстальщик	2010-08-11 19:32:03.061+04	2010-08-11 19:32:03.061+04
37245b73-0c9f-4a71-86db-7fcfd0ebcda8	Михальчев С.	Михальчев С.	менеджер	2010-08-11 19:32:03.063+04	2010-08-11 19:32:03.063+04
089d2f8c-e623-4195-b7b1-e5bd5c3f5f3e	Кошкина Г.	Кошкина Г.	редактор	2010-08-11 19:32:03.065+04	2010-08-11 19:32:03.065+04
7434e003-6b61-4736-bab5-6bfcd1d09e7f	Русских Т.	Русских Т.	редактор	2010-08-11 19:32:03.068+04	2010-08-11 19:32:03.068+04
1d6dcd3a-a919-426a-a896-a0e6d127c2ea	Елина В.	Елина В.	редактор	2010-08-11 19:32:03.07+04	2010-08-11 19:32:03.07+04
191e7e82-1f84-44d6-afd6-88c7fa5dc697	Ухаров П.Е.	Ухаров П.Е.	Бильд редактор	2010-08-11 19:32:03.072+04	2010-08-11 19:32:03.072+04
c2d15d41-d069-46ad-9bd5-fb9f96ae2509	Балашова Н.	Балашова Н.	корректор	2010-08-11 19:32:03.075+04	2010-08-11 19:32:03.075+04
d5e1219e-a729-4a3a-a21a-9b2b6407900b	Толкачева Елена	Толкачева Е.	Менеджер РБ	2010-08-11 19:32:03.077+04	2010-08-11 19:32:03.077+04
935d3a03-a55b-4235-b9b1-98c60edafd0d	Меньших Петр Степанович 	Меньших П.С.	 	2010-08-11 19:32:03.079+04	2010-08-11 19:32:03.079+04
60380170-8ece-40db-b3de-320e11bcf365	Полунина Е.	Полунина Е.	Дизайнер	2010-08-11 19:32:03.082+04	2010-08-11 19:32:03.082+04
16f0f7e7-b59d-4c83-aea5-6cb31dd8375e	Долгая Мария	Долгая М.	веб-редактор	2010-08-11 19:32:03.088+04	2010-08-11 19:32:03.088+04
1a63e582-5cd1-4b89-97fe-1d4de00bda5d	Мухин Александр Яковлевич	Мухин А.Я.	Координатор проекта	2010-08-11 19:32:03.09+04	2010-08-11 19:32:03.09+04
e3234892-467c-4009-b4e8-f77e989d81fb	Аркадий Козлов	Козлов А.	Техред	2010-08-11 19:32:03.093+04	2010-08-11 19:32:03.093+04
a80159b2-1289-4c68-9801-655192aa7a49	Балашова Е.	Балашова Е.	старший корректор	2010-08-11 19:32:03.095+04	2010-08-11 19:32:03.095+04
c72e677e-feed-4b25-9104-556ae5c3d2f6	Котровский Н.	Котровский Н.	редактор	2010-08-11 19:32:03.097+04	2010-08-11 19:32:03.097+04
092eea35-1f7f-4fc2-aa48-41625c084df0	Юрченко Максим Иванович	Юрченко М.И.	 Ответ.сек.	2010-08-11 19:32:03.1+04	2010-08-11 19:32:03.1+04
0e5db04a-3fca-4d81-b38d-adb1ac00f74a	Авдеева М.	Авдеева М.	верстальщик	2010-08-11 19:32:03.102+04	2010-08-11 19:32:03.102+04
c357e368-77c6-42a4-8db1-18e172193e73	Щеголев Сергей	Щеголев С. Г.	дизайнер	2010-08-11 19:32:03.105+04	2010-08-11 19:32:03.105+04
e3b448b8-9d9a-4ccd-bfbb-1742f8c818c8	Терешкович Дарья Андреевна	Терешкович Д.А.	редактор	2010-08-11 19:32:03.107+04	2010-08-11 19:32:03.107+04
356e53b0-539f-40fe-b8bc-a16376c9daaa	Колтун Андрей Михайлович	Колтун А.М.	Редактор	2010-08-11 19:32:03.109+04	2010-08-11 19:32:03.109+04
41af4948-123f-47fd-b840-6921adb63088	Редькина Елена Георгиевна	Редькина Е.Г.	Редактор	2010-08-11 19:32:03.112+04	2010-08-11 19:32:03.112+04
ce99662c-7898-4485-aad9-7264a5c0a1d9	Савченко Кирилл Евгеньевич	Савченко К.Е.	Редактор	2010-08-11 19:32:03.114+04	2010-08-11 19:32:03.114+04
b4af4681-7706-4f23-b0df-c4340356a5a0	Михалев Вадим Вазгенович	Михалев В.В.	Редактор	2010-08-11 19:32:03.118+04	2010-08-11 19:32:03.118+04
c3b42312-eac4-400c-b523-2ad65b1f406a	Устинов Вадим Георгиевич	Устинов В.Г.	Редактор	2010-08-11 19:32:03.12+04	2010-08-11 19:32:03.12+04
c9024aa0-b5ea-427c-80ac-96e15f22cb12	Дорохова Елена Владимировна	Дорохова Е.В.	Корректор	2010-08-11 19:32:03.122+04	2010-08-11 19:32:03.122+04
b89663e2-11af-476f-84c1-e49d24407070	Колчев Павел 	Колчев Павел	зав произ. отделом	2010-08-11 19:32:03.124+04	2010-08-11 19:32:03.124+04
49de597d-2871-42da-889f-e85852162d0b	Гирман Н.С.	Гирман Н.С.	редактор	2010-08-11 19:32:03.127+04	2010-08-11 19:32:03.127+04
ba51dbc9-bff8-40e4-bbe8-2b283ec8f94b	Копотов Алексей Владимирович	Копотов А.В.	зам директора РБ "За рулем"	2010-08-11 19:32:03.129+04	2010-08-11 19:32:03.129+04
afd137a8-f8a4-47c7-8263-bc33857fe223	Астапов А.В.	Астапов А.В.	зам. гл. ред.	2010-08-11 19:32:03.131+04	2010-08-11 19:32:03.131+04
1f8ef3b2-3980-4327-a62b-11bd1b643043	Самойлова Галина Анатольевна	Самойлова Г.А.	Корректор	2010-08-11 19:32:03.134+04	2010-08-11 19:32:03.134+04
d363dfbd-926a-4d88-9047-da0fe90d06d3	Тюрина Татьяна	Тюрина Т.	PR-менеджер	2010-08-11 19:32:03.136+04	2010-08-11 19:32:03.136+04
127bc976-6e7b-4b43-8412-b688c321b716	Уланова Наталья Анатольевна	Уланова Н.А.	Машинистка	2010-08-11 19:32:03.138+04	2010-08-11 19:32:03.138+04
24a9dd37-8138-45e0-a543-ec865089438a	Чуркина Татьяна	Чуркина Т.	менеджер маркетинг	2010-08-11 19:32:03.14+04	2010-08-11 19:32:03.14+04
7c740887-599f-4077-8e74-7531dba0742b	Безруков В.И.	Безруков В.И.	Редактор	2010-08-11 19:32:03.143+04	2010-08-11 19:32:03.143+04
e486905b-7bcf-47eb-ac0f-9dd745c1a2b9	Абалакин Роман	Абалакин Р.	редактор	2010-08-11 19:32:03.146+04	2010-08-11 19:32:03.146+04
bc7c2ef7-d61c-43c3-b5c7-f0b6c262bbce	Кирюнина Татьяна Борисовна	Кирюнина Т.Б.	Корректор	2010-08-11 19:32:03.148+04	2010-08-11 19:32:03.148+04
0cfe7daa-b3aa-4f04-9eb5-30bc420e433a	Бобриков Евгений Михайлович	Бобриков Е. М.	Фотограф	2010-08-11 19:32:03.151+04	2010-08-11 19:32:03.151+04
14ac6931-6ca2-4a59-97d3-ccdb179869eb	Мельник Александр Дмитриевич	Мельник А.Д.	Главный редактор	2010-08-11 19:32:03.153+04	2010-08-11 19:32:03.153+04
0b33d92c-f4d6-49cd-a136-89fc777b8a3d	Платонов Владимир Илиодорович	Платонов В.И.	Зам. главного редактора	2010-08-11 19:32:03.155+04	2010-08-11 19:32:03.155+04
841abf3c-d9e9-4ff7-b7b4-aaa687ac0edf	Бревдо Кирилл Александрович	Бревдо К. А.	Зам. главного редактора	2010-08-11 19:32:03.157+04	2010-08-11 19:32:03.157+04
84735f6b-fc94-4cc7-a771-c660e93b1520	Воронкова Анна Васильевна	Воронкова А.В.	Заведующая отделом	2010-08-11 19:32:03.16+04	2010-08-11 19:32:03.16+04
d291b4b9-fe8e-470d-aab2-eaf78588f1a5	Левченко Кирилл Игоревич	Левченко К.И.	Ведущий дизайнер	2010-08-11 19:32:03.162+04	2010-08-11 19:32:03.162+04
b7a4e3f9-bbb3-4f57-9648-7e3b78184697	Гончаров Максим Борисович	Гончаров М.Б.	Фоторедактор	2010-08-11 19:32:03.164+04	2010-08-11 19:32:03.164+04
388a9b14-d368-41cb-8484-45887de55fcc	Николаева Ирина Станиславовна	Николаева И.С.	Дизайнер	2010-08-11 19:32:03.167+04	2010-08-11 19:32:03.167+04
578fd168-eba6-4011-867c-7b0529e1e93e	Сергеев Алексей Львович	Сергеев А.Л.	Редактор	2010-08-11 19:32:03.169+04	2010-08-11 19:32:03.169+04
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY roles (id, catalog, name, shortcut, description, created, updated) FROM stdin;
3d1d1339-36a7-476a-8af1-82129a136eb6	00000000-0000-0000-0000-000000000000	Консультант	Консультант	Помогает в разрешении вопросов с программой	2010-08-12 20:18:13.343+04	2010-08-12 20:18:13.343+04
18aa10cc-2385-4310-b68e-867aa6944057	00000000-0000-0000-0000-000000000000	Корреспондент	Корреспондент	Корреспондент, работающий в редакции	2010-08-12 20:18:13.344+04	2010-08-12 20:18:13.344+04
9ca86e3a-30e2-41f7-91c9-be3e53af7c40	00000000-0000-0000-0000-000000000000	Ответственный секретарь	Ответственный секретарь	Ответственный секретарь 	2010-08-12 20:18:13.347+04	2010-08-12 20:18:13.347+04
63fbf18e-48bf-4e74-b6d4-7361396fdb77	00000000-0000-0000-0000-000000000000	Удаленный корреспондент	Удаленный корреспондент	Корреспондент, который работает через интернет	2010-08-12 20:18:13.348+04	2010-08-12 20:18:13.348+04
af028c7e-600a-47cc-a90a-0f29d58a2561	00000000-0000-0000-0000-000000000000	Фотокорреспондент	Фотокорреспондент	 	2010-08-12 20:18:13.349+04	2010-08-12 20:18:13.349+04
235d5092-4895-469b-ad92-ee77c1c70352	00000000-0000-0000-0000-000000000000	Главный редактор	Главный редактор		2010-08-12 20:18:13.357+04	2010-08-12 20:18:13.357+04
d71e8d4a-6685-4138-875d-7981076394c4	00000000-0000-0000-0000-000000000000	Зам. гл.редактора	Зам. гл.редактора		2010-08-12 20:18:13.36+04	2010-08-12 20:18:13.36+04
4587e5ac-cce3-4883-bc72-0a7ad6eaf833	00000000-0000-0000-0000-000000000000	Тест редактор	Тест редактор		2010-08-12 20:18:13.361+04	2010-08-12 20:18:13.361+04
4f251c6f-bd2a-454b-861e-ebb9d690bb60	00000000-0000-0000-0000-000000000000	Фотограф	Фотограф		2010-08-12 20:18:13.364+04	2010-08-12 20:18:13.364+04
d53a0e91-2c04-44f2-875e-a778e4b0c78b	00000000-0000-0000-0000-000000000000	Дизайнер	Дизайнер		2010-08-12 20:18:13.366+04	2010-08-12 20:18:13.366+04
ea6778ba-dc19-47a4-bc7a-62867b9ac28b	00000000-0000-0000-0000-000000000000	Менеджер РБ	Менеджер РБ		2010-08-12 20:18:13.368+04	2010-08-12 20:18:13.368+04
60625d58-e707-48dc-93eb-7c986b9e9eb1	00000000-0000-0000-0000-000000000000	Корректор	Корректор	Корректорская правка	2010-08-12 20:18:13.374+04	2010-08-12 20:18:13.374+04
921c8f78-992c-4e3f-9b3c-be9e32190bfd	00000000-0000-0000-0000-000000000000	Сотрудник ОХО	Сотрудник ОХО	Художественное оформление	2010-08-12 20:18:13.375+04	2010-08-12 20:18:13.375+04
d7af18ac-750f-4ad4-9de5-3239677f7466	00000000-0000-0000-0000-000000000000	Рекламный агент	Рекламный агент	 	2010-08-12 20:18:13.376+04	2010-08-12 20:18:13.376+04
c0760036-2f36-4f7a-8afa-3491778906ae	00000000-0000-0000-0000-000000000000	Директор рекламного бюро	Директор рекламного бюро		2010-08-12 20:18:13.378+04	2010-08-12 20:18:13.378+04
c0c2a6ec-8c8c-4952-8927-503dd5898381	00000000-0000-0000-0000-000000000000	Зам. главного редактора	Зам. главного редактора		2010-08-12 20:18:13.38+04	2010-08-12 20:18:13.38+04
64dca17e-e329-4263-a124-ae5ff01483f6	00000000-0000-0000-0000-000000000000	Выпуск. редактор	Выпуск. редактор		2010-08-12 20:18:13.382+04	2010-08-12 20:18:13.382+04
bf1df1ba-5817-480e-8f99-629789c24993	00000000-0000-0000-0000-000000000000	Техн. редактор	Техн. редактор		2010-08-12 20:18:13.385+04	2010-08-12 20:18:13.385+04
c82ffa60-5461-4b8c-99dc-0f6c28b11598	00000000-0000-0000-0000-000000000000	Главный художник	Главный художник		2010-08-12 20:18:13.388+04	2010-08-12 20:18:13.388+04
a4d49d84-919f-4339-9cd4-0379d24f1096	00000000-0000-0000-0000-000000000000	Старший верстальщик	Старший верстальщик		2010-08-12 20:18:13.389+04	2010-08-12 20:18:13.389+04
3414fdcb-496e-410f-b41c-288f8f454cce	00000000-0000-0000-0000-000000000000	Верстальщик	Верстальщик		2010-08-12 20:18:13.39+04	2010-08-12 20:18:13.39+04
39168b53-a5b4-45dc-b238-cf8bcc6894a5	00000000-0000-0000-0000-000000000000	Цветоделитель	Цветоделитель		2010-08-12 20:18:13.392+04	2010-08-12 20:18:13.392+04
4e6a3746-656e-499b-95c6-f3906589f371	00000000-0000-0000-0000-000000000000	Старший корректор	Старший корректор		2010-08-12 20:18:13.393+04	2010-08-12 20:18:13.393+04
062493fe-951c-4791-af15-ca4178794896	00000000-0000-0000-0000-000000000000	Секретарь	Секретарь		2010-08-12 20:18:13.395+04	2010-08-12 20:18:13.395+04
8d0a53d1-8120-4bb2-86cf-f54aadd1b50b	00000000-0000-0000-0000-000000000000	Фоторедактор	Фоторедактор		2010-08-12 20:18:13.401+04	2010-08-12 20:18:13.401+04
4303c956-f77e-4599-b49b-ec40c9e0d319	00000000-0000-0000-0000-000000000000	Редактор	Редактор		2010-08-12 20:18:13.402+04	2010-08-12 20:18:13.402+04
c5fb14c0-24ce-4946-ac14-77f0054809ef	00000000-0000-0000-0000-000000000000	Машинистка	Машинистка		2010-08-12 20:18:13.405+04	2010-08-12 20:18:13.405+04
10f621fa-5cee-4975-ae5f-c163c1aaeb8f	3cdad4d0-a9d7-45e4-b6af-fd329100edda	Зав. отделом	Зав. отделом	 	2010-08-12 20:18:13.351+04	2010-08-13 15:17:54.521+04
d0123a31-89cc-4577-956f-5c21b407b226	28f669b1-6e32-4274-85a2-32426f618669	Бильд редактор	Бильд редактор		2010-08-12 20:18:13.386+04	2010-08-13 15:21:32.017+04
7721aae1-6bf7-1014-996e-31e7601ac163	00000000-0000-0000-0000-000000000000	Альфа	альфа	Альфа и Омега	2010-08-13 14:39:26.427+04	2010-08-17 13:25:22.894+04
\.


--
-- Data for Name: rubrics; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY rubrics (id, fascicle, parent, title, shortcut, description, created, updated) FROM stdin;
00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:41.531+04	2010-09-19 03:09:41.531+04
00000000-0000-0000-0000-000000000000	b732191b-638f-4f85-a1a3-f925934d555f	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:41.546+04	2010-09-19 03:09:41.546+04
536e67f6-d7af-4107-aa4a-e57279b4cf7d	b732191b-638f-4f85-a1a3-f925934d555f	8cb5c363-dac2-43c2-ae09-ad4dbcd7458e	Тест	Тест		2010-09-19 03:09:41.635+04	2010-09-19 03:09:41.635+04
a717fa8d-9326-4179-8ef7-14880655cc56	b732191b-638f-4f85-a1a3-f925934d555f	8cb5c363-dac2-43c2-ae09-ad4dbcd7458e	Спецтест	Спецтест		2010-09-19 03:09:41.639+04	2010-09-19 03:09:41.639+04
a5b4edb4-74d8-484f-a85e-cf6d14993c44	b732191b-638f-4f85-a1a3-f925934d555f	8cb5c363-dac2-43c2-ae09-ad4dbcd7458e	Премьера	Премьера		2010-09-19 03:09:41.643+04	2010-09-19 03:09:41.643+04
f589b5fc-27a9-465c-af85-dcae8b67f6d3	b732191b-638f-4f85-a1a3-f925934d555f	8cb5c363-dac2-43c2-ae09-ad4dbcd7458e	Презентация	Презентация		2010-09-19 03:09:41.646+04	2010-09-19 03:09:41.646+04
1bc49477-d470-4514-b4dc-18ca7e271545	b732191b-638f-4f85-a1a3-f925934d555f	8cb5c363-dac2-43c2-ae09-ad4dbcd7458e	Наше знакомство	Наше знакомство		2010-09-19 03:09:41.648+04	2010-09-19 03:09:41.648+04
e7f265cf-c7fd-47ff-93ae-8d3348883fdd	b732191b-638f-4f85-a1a3-f925934d555f	8cb5c363-dac2-43c2-ae09-ad4dbcd7458e	Высший класс	Высший класс		2010-09-19 03:09:41.651+04	2010-09-19 03:09:41.651+04
aff080b0-d70e-44ed-bab4-e3d1a8bf1f4d	b732191b-638f-4f85-a1a3-f925934d555f	8cb5c363-dac2-43c2-ae09-ad4dbcd7458e	Презентация	Презентация		2010-09-19 03:09:41.654+04	2010-09-19 03:09:41.654+04
9d1d9641-9546-4784-8d2e-02bd00b28419	b732191b-638f-4f85-a1a3-f925934d555f	3405f2b6-09ad-4bc9-9601-6d6961fc1244	Компоненты	Компоненты		2010-09-19 03:09:41.657+04	2010-09-19 03:09:41.657+04
a811c49a-cfdb-4abb-ab3d-18961ca6d3ac	b732191b-638f-4f85-a1a3-f925934d555f	3405f2b6-09ad-4bc9-9601-6d6961fc1244	Экспертиза	Экспертиза		2010-09-19 03:09:41.682+04	2010-09-19 03:09:41.682+04
f81bab2c-bdd6-4367-8249-64f8f3c62763	b732191b-638f-4f85-a1a3-f925934d555f	3405f2b6-09ad-4bc9-9601-6d6961fc1244	Новые товары	Новые товары		2010-09-19 03:09:41.685+04	2010-09-19 03:09:41.685+04
78d8d127-ddcc-4725-a450-a0ba2a490eb7	b732191b-638f-4f85-a1a3-f925934d555f	3405f2b6-09ad-4bc9-9601-6d6961fc1244	Электроника	Электроника		2010-09-19 03:09:41.687+04	2010-09-19 03:09:41.687+04
878a916a-d00c-4028-8635-fb0da8523b10	b732191b-638f-4f85-a1a3-f925934d555f	3405f2b6-09ad-4bc9-9601-6d6961fc1244	На прилавке	На прилавке		2010-09-19 03:09:41.689+04	2010-09-19 03:09:41.689+04
bbd06453-8298-4f86-8f36-74965c65de3f	b732191b-638f-4f85-a1a3-f925934d555f	f9deefeb-45a8-44e9-87ae-159c4a4c940a	Дегустация	Дегустация		2010-09-19 03:09:41.691+04	2010-09-19 03:09:41.691+04
a7abec8a-172b-4f79-ba20-661bb2f8c65c	b732191b-638f-4f85-a1a3-f925934d555f	f9deefeb-45a8-44e9-87ae-159c4a4c940a	Семейство	Семейство		2010-09-19 03:09:41.693+04	2010-09-19 03:09:41.693+04
52fb20ff-04fc-4273-8dd8-baa9ed732cbb	b732191b-638f-4f85-a1a3-f925934d555f	f9deefeb-45a8-44e9-87ae-159c4a4c940a	Новости дилеров	Новости дилеров		2010-09-19 03:09:41.695+04	2010-09-19 03:09:41.695+04
3b761d7b-25d8-43ae-8edb-3868bac0d5b7	b732191b-638f-4f85-a1a3-f925934d555f	f9deefeb-45a8-44e9-87ae-159c4a4c940a	В деталях	В деталях		2010-09-19 03:09:41.697+04	2010-09-19 03:09:41.697+04
dedbdce6-aa8d-4d19-bf47-8ed6b61e231d	b732191b-638f-4f85-a1a3-f925934d555f	f9deefeb-45a8-44e9-87ae-159c4a4c940a	Комплектация	Комплектация		2010-09-19 03:09:41.699+04	2010-09-19 03:09:41.699+04
76156b23-fcce-401e-bd27-2e1668457256	b732191b-638f-4f85-a1a3-f925934d555f	f9deefeb-45a8-44e9-87ae-159c4a4c940a	Парк ЗР	Парк ЗР		2010-09-19 03:09:41.701+04	2010-09-19 03:09:41.701+04
485c2761-f0c4-4f5c-8889-6b3e8a9db615	b732191b-638f-4f85-a1a3-f925934d555f	f9deefeb-45a8-44e9-87ae-159c4a4c940a	Опции	Опции		2010-09-19 03:09:41.703+04	2010-09-19 03:09:41.703+04
18c238ba-6bbc-486f-a4cc-010b82a9e86f	b732191b-638f-4f85-a1a3-f925934d555f	f9deefeb-45a8-44e9-87ae-159c4a4c940a	Автосалон	Автосалон		2010-09-19 03:09:41.705+04	2010-09-19 03:09:41.705+04
b5306004-da81-47f5-8b6d-951be0b4b88b	b732191b-638f-4f85-a1a3-f925934d555f	927a6296-4d93-482f-9565-b6e06d6d5b8b	Вы нам писали	Вы нам писали		2010-09-19 03:09:41.707+04	2010-09-19 03:09:41.707+04
c3cbf4bb-2f64-4160-ad45-147abbe7daa5	b732191b-638f-4f85-a1a3-f925934d555f	927a6296-4d93-482f-9565-b6e06d6d5b8b	Отвечает Главред	Отвечает Главред		2010-09-19 03:09:41.709+04	2010-09-19 03:09:41.709+04
275c95cc-61d5-4959-974e-bb1f7b5eec88	b732191b-638f-4f85-a1a3-f925934d555f	927a6296-4d93-482f-9565-b6e06d6d5b8b	Личное мнение	Личное мнение		2010-09-19 03:09:41.711+04	2010-09-19 03:09:41.711+04
968a9d53-bb10-4828-bcff-8be8091dd686	b732191b-638f-4f85-a1a3-f925934d555f	bd8a8584-ad8c-4499-a744-85f3c5ce4ea5	С миру по гонке	С миру по гонке		2010-09-19 03:09:41.713+04	2010-09-19 03:09:41.713+04
5e3d8abf-07e7-405f-a3af-38179b22ffa7	b732191b-638f-4f85-a1a3-f925934d555f	bd8a8584-ad8c-4499-a744-85f3c5ce4ea5	Ралли	Ралли		2010-09-19 03:09:41.715+04	2010-09-19 03:09:41.715+04
0c13aa3d-6545-4fd5-864a-aed54f1e0d46	b732191b-638f-4f85-a1a3-f925934d555f	bd8a8584-ad8c-4499-a744-85f3c5ce4ea5	Формула-1	Формула-1		2010-09-19 03:09:41.717+04	2010-09-19 03:09:41.717+04
fdfe251d-a4cf-4243-a881-7cc2cfda50ad	b732191b-638f-4f85-a1a3-f925934d555f	bd8a8584-ad8c-4499-a744-85f3c5ce4ea5	Спорт	Спорт		2010-09-19 03:09:41.719+04	2010-09-19 03:09:41.719+04
f476fadb-3f3f-4bf0-b9f2-6618b27dacce	b732191b-638f-4f85-a1a3-f925934d555f	bd8a8584-ad8c-4499-a744-85f3c5ce4ea5	Кольцевые гонки	Кольцевые гонки		2010-09-19 03:09:41.722+04	2010-09-19 03:09:41.722+04
5a053cdf-423a-48a3-b97d-2e43d12416bc	b732191b-638f-4f85-a1a3-f925934d555f	58ba221c-0ddb-4c70-85ba-e0fc7f9c6d45	Грузовики	Грузовики		2010-09-19 03:09:41.724+04	2010-09-19 03:09:41.724+04
092eae6c-e135-4598-8427-b97c7f418e3c	b732191b-638f-4f85-a1a3-f925934d555f	eecfd453-1f5b-4bb2-b6d2-f1fb2f520a7b	Интервью	Интервью		2010-09-19 03:09:41.726+04	2010-09-19 03:09:41.726+04
4ea6aadf-ee7d-4ed4-ad9c-d87e9630d99d	b732191b-638f-4f85-a1a3-f925934d555f	eecfd453-1f5b-4bb2-b6d2-f1fb2f520a7b	Экономика-Обозрение	Экономика-Обозрение		2010-09-19 03:09:41.728+04	2010-09-19 03:09:41.728+04
29877c10-ab94-498c-b869-80f25dbf3b5f	b732191b-638f-4f85-a1a3-f925934d555f	eecfd453-1f5b-4bb2-b6d2-f1fb2f520a7b	Новости	Новости		2010-09-19 03:09:41.731+04	2010-09-19 03:09:41.731+04
b01370df-ef17-4574-9178-6f7845f007cb	b732191b-638f-4f85-a1a3-f925934d555f	5ef9dc0c-b62d-4965-904e-8deb1d0d81eb	Спорный момент	Спорный момент		2010-09-19 03:09:41.733+04	2010-09-19 03:09:41.733+04
34e437b5-06f5-4dbe-b385-010cd1ed239f	b732191b-638f-4f85-a1a3-f925934d555f	5ef9dc0c-b62d-4965-904e-8deb1d0d81eb	Следствие ведет ЗР	Следствие ведет ЗР		2010-09-19 03:09:41.736+04	2010-09-19 03:09:41.736+04
3205e7da-fe3f-47b5-bd3c-62f1d581f60f	b732191b-638f-4f85-a1a3-f925934d555f	5ef9dc0c-b62d-4965-904e-8deb1d0d81eb	Самозащита	Самозащита		2010-09-19 03:09:41.738+04	2010-09-19 03:09:41.738+04
e0c4fafb-ea7a-4736-a1e5-6c99b07699bb	b732191b-638f-4f85-a1a3-f925934d555f	5ef9dc0c-b62d-4965-904e-8deb1d0d81eb	Прямая линия	Прямая линия		2010-09-19 03:09:41.74+04	2010-09-19 03:09:41.74+04
501848e0-a28d-4036-9877-7d0915d77092	b732191b-638f-4f85-a1a3-f925934d555f	5ef9dc0c-b62d-4965-904e-8deb1d0d81eb	Ответы юриста	Ответы юриста		2010-09-19 03:09:41.742+04	2010-09-19 03:09:41.742+04
8e922d79-8840-46f3-9a05-8268e7dcfe51	b732191b-638f-4f85-a1a3-f925934d555f	5ef9dc0c-b62d-4965-904e-8deb1d0d81eb	Безопасность	Безопасность		2010-09-19 03:09:41.744+04	2010-09-19 03:09:41.744+04
f24b7603-bea7-4419-9c4d-e36a85b4e7b3	b732191b-638f-4f85-a1a3-f925934d555f	5ef9dc0c-b62d-4965-904e-8deb1d0d81eb	Новости	Новости		2010-09-19 03:09:41.747+04	2010-09-19 03:09:41.747+04
aec6c7b3-3096-49dc-abbd-23ca9b0a105e	b732191b-638f-4f85-a1a3-f925934d555f	be34168b-d4db-444b-9441-e8ca9f269ec1	Тест-ремонт	Тест-ремонт		2010-09-19 03:09:41.749+04	2010-09-19 03:09:41.749+04
d2ce6f43-9cc3-40a1-bd0a-e2ec3864778e	b732191b-638f-4f85-a1a3-f925934d555f	be34168b-d4db-444b-9441-e8ca9f269ec1	Хочу разобраться	Хочу разобраться		2010-09-19 03:09:41.751+04	2010-09-19 03:09:41.751+04
6a242206-8a72-4b2a-a55f-2ae94863fa92	b732191b-638f-4f85-a1a3-f925934d555f	be34168b-d4db-444b-9441-e8ca9f269ec1	Мастерская	Мастерская		2010-09-19 03:09:41.753+04	2010-09-19 03:09:41.753+04
900ac4e3-38b4-4a75-ae01-334ebac2181d	b732191b-638f-4f85-a1a3-f925934d555f	be34168b-d4db-444b-9441-e8ca9f269ec1	Взаимозаменяемость	Взаимозаменяемость		2010-09-19 03:09:41.755+04	2010-09-19 03:09:41.755+04
e5da3997-502f-433c-86b8-784dde2470a0	b732191b-638f-4f85-a1a3-f925934d555f	be34168b-d4db-444b-9441-e8ca9f269ec1	Отвечают специалисты	Отвечают специалисты		2010-09-19 03:09:41.757+04	2010-09-19 03:09:41.757+04
42d54f6e-25ce-4959-ac89-2b8ec777febc	b732191b-638f-4f85-a1a3-f925934d555f	be34168b-d4db-444b-9441-e8ca9f269ec1	Советы бывалых	Советы бывалых		2010-09-19 03:09:41.759+04	2010-09-19 03:09:41.759+04
7545861a-9e7f-4bb9-bb15-73e361ddde24	b732191b-638f-4f85-a1a3-f925934d555f	be34168b-d4db-444b-9441-e8ca9f269ec1	Доводим	Доводим		2010-09-19 03:09:41.762+04	2010-09-19 03:09:41.762+04
1bb117d3-e7cc-419a-8628-eb217aedc889	b732191b-638f-4f85-a1a3-f925934d555f	be34168b-d4db-444b-9441-e8ca9f269ec1	Конкурс	Конкурс		2010-09-19 03:09:41.763+04	2010-09-19 03:09:41.763+04
307ac513-e934-4e2a-b5da-ad0944b926ef	b732191b-638f-4f85-a1a3-f925934d555f	7092d1f4-47e7-43e5-aed8-ba9d08d80417	Новинки-исследования-изобретения	Новинки-исследования-изобретения		2010-09-19 03:09:41.765+04	2010-09-19 03:09:41.765+04
877ee272-4b04-4e49-9a20-b2575f06ed52	b732191b-638f-4f85-a1a3-f925934d555f	7092d1f4-47e7-43e5-aed8-ba9d08d80417	Обозрение	Обозрение		2010-09-19 03:09:41.768+04	2010-09-19 03:09:41.768+04
0c49e609-52a7-475b-9448-470885959929	b732191b-638f-4f85-a1a3-f925934d555f	7092d1f4-47e7-43e5-aed8-ba9d08d80417	Концепт-кар	Концепт-кар		2010-09-19 03:09:41.77+04	2010-09-19 03:09:41.77+04
8ceb12cb-b11b-402b-b2a7-5d50ad10d5e6	b732191b-638f-4f85-a1a3-f925934d555f	7092d1f4-47e7-43e5-aed8-ba9d08d80417	Технологии	Технологии		2010-09-19 03:09:41.772+04	2010-09-19 03:09:41.772+04
132ec494-d0a5-4936-a141-38b492f8c0b3	b732191b-638f-4f85-a1a3-f925934d555f	850766d7-ebca-4ab3-8b30-7545d80ed80b	Без границ	Без границ		2010-09-19 03:09:41.774+04	2010-09-19 03:09:41.774+04
710c4a6b-c53b-4ff5-8cd1-467b4ffc1cd5	b732191b-638f-4f85-a1a3-f925934d555f	850766d7-ebca-4ab3-8b30-7545d80ed80b	Живые классики	Живые классики		2010-09-19 03:09:41.776+04	2010-09-19 03:09:41.776+04
383904b9-6426-4708-8b13-914907118d4d	b732191b-638f-4f85-a1a3-f925934d555f	850766d7-ebca-4ab3-8b30-7545d80ed80b	Эксперимент	Эксперимент		2010-09-19 03:09:41.778+04	2010-09-19 03:09:41.778+04
32505e72-fe65-4445-87cb-52eb054c4af1	b732191b-638f-4f85-a1a3-f925934d555f	850766d7-ebca-4ab3-8b30-7545d80ed80b	Путешествие	Путешествие		2010-09-19 03:09:41.781+04	2010-09-19 03:09:41.781+04
52b27710-d912-48d5-950d-4038ad21ea41	b732191b-638f-4f85-a1a3-f925934d555f	97c3ce84-bf5c-4156-b136-af7f09e9f918	Цены ЗР	Цены ЗР		2010-09-19 03:09:41.783+04	2010-09-19 03:09:41.783+04
012ff729-6928-4f21-b00c-3fcfcfffb89a	b732191b-638f-4f85-a1a3-f925934d555f	78f9aed3-33b0-448d-bb55-8c016d4934dd	На гребне моды	На гребне моды		2010-09-19 03:09:41.786+04	2010-09-19 03:09:41.786+04
85872228-b15f-4f5d-91f6-8e446589ec1a	b732191b-638f-4f85-a1a3-f925934d555f	78f9aed3-33b0-448d-bb55-8c016d4934dd	Тюнинг	Тюнинг		2010-09-19 03:09:41.788+04	2010-09-19 03:09:41.788+04
00000000-0000-0000-0000-000000000000	bf24034e-5558-44be-a5a4-897b0441af41	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:41.798+04	2010-09-19 03:09:41.798+04
e66b3aa0-77d0-4ff7-b4bd-c2f9451982d7	bf24034e-5558-44be-a5a4-897b0441af41	ad1b0e5a-934f-4157-b75c-8abe3937c204	Тест	Тест		2010-09-19 03:09:41.853+04	2010-09-19 03:09:41.853+04
ef3c86ad-2673-41ac-98ee-4ae6e5244e13	bf24034e-5558-44be-a5a4-897b0441af41	ad1b0e5a-934f-4157-b75c-8abe3937c204	Спецтест	Спецтест		2010-09-19 03:09:41.856+04	2010-09-19 03:09:41.856+04
68928049-e896-4cc1-b56f-a5717099605e	bf24034e-5558-44be-a5a4-897b0441af41	ad1b0e5a-934f-4157-b75c-8abe3937c204	Премьера	Премьера		2010-09-19 03:09:41.858+04	2010-09-19 03:09:41.858+04
18d1016a-efff-4a0b-b474-f542e0fa6a0b	bf24034e-5558-44be-a5a4-897b0441af41	ad1b0e5a-934f-4157-b75c-8abe3937c204	Презентация	Презентация		2010-09-19 03:09:41.861+04	2010-09-19 03:09:41.861+04
7491691f-8a47-4883-87dc-77fe2b3b6a69	bf24034e-5558-44be-a5a4-897b0441af41	ad1b0e5a-934f-4157-b75c-8abe3937c204	Наше знакомство	Наше знакомство		2010-09-19 03:09:41.863+04	2010-09-19 03:09:41.863+04
a1ece7db-b69d-4318-b56a-dfba4958fb88	bf24034e-5558-44be-a5a4-897b0441af41	ad1b0e5a-934f-4157-b75c-8abe3937c204	Высший класс	Высший класс		2010-09-19 03:09:41.865+04	2010-09-19 03:09:41.865+04
6e03e093-4f30-4328-a7bf-8606641e4ebb	bf24034e-5558-44be-a5a4-897b0441af41	ad1b0e5a-934f-4157-b75c-8abe3937c204	Презентация	Презентация		2010-09-19 03:09:41.867+04	2010-09-19 03:09:41.867+04
a520704f-4c03-48a1-9fa6-e38738e3b8d3	bf24034e-5558-44be-a5a4-897b0441af41	63c69a90-fa05-44f6-9a01-9a5b9210b8e9	Компоненты	Компоненты		2010-09-19 03:09:41.87+04	2010-09-19 03:09:41.87+04
6df0a46d-2f95-4abf-b92c-a2f77a0c0d3c	bf24034e-5558-44be-a5a4-897b0441af41	63c69a90-fa05-44f6-9a01-9a5b9210b8e9	Экспертиза	Экспертиза		2010-09-19 03:09:41.872+04	2010-09-19 03:09:41.872+04
61307f00-15a9-410a-8693-3d1c3bb1dcfb	bf24034e-5558-44be-a5a4-897b0441af41	63c69a90-fa05-44f6-9a01-9a5b9210b8e9	Новые товары	Новые товары		2010-09-19 03:09:41.875+04	2010-09-19 03:09:41.875+04
77c63ba4-0463-4b70-9594-3ee5979d983b	bf24034e-5558-44be-a5a4-897b0441af41	63c69a90-fa05-44f6-9a01-9a5b9210b8e9	Электроника	Электроника		2010-09-19 03:09:41.877+04	2010-09-19 03:09:41.877+04
fb094cdc-cd79-4950-a3bd-0d6c0923ce9b	bf24034e-5558-44be-a5a4-897b0441af41	63c69a90-fa05-44f6-9a01-9a5b9210b8e9	На прилавке	На прилавке		2010-09-19 03:09:41.879+04	2010-09-19 03:09:41.879+04
f0f14be8-a531-489f-8f54-c8a2750b3e93	bf24034e-5558-44be-a5a4-897b0441af41	96d59f19-50ee-4a6a-ada0-d98816cded7f	Дегустация	Дегустация		2010-09-19 03:09:41.881+04	2010-09-19 03:09:41.881+04
d91299f0-2753-43af-91ab-5bf18d7d435f	bf24034e-5558-44be-a5a4-897b0441af41	96d59f19-50ee-4a6a-ada0-d98816cded7f	Семейство	Семейство		2010-09-19 03:09:41.883+04	2010-09-19 03:09:41.883+04
d4fc4ab9-ef70-4cc3-9b45-c6c7104ab697	bf24034e-5558-44be-a5a4-897b0441af41	96d59f19-50ee-4a6a-ada0-d98816cded7f	Новости дилеров	Новости дилеров		2010-09-19 03:09:41.886+04	2010-09-19 03:09:41.886+04
b99a0634-51b9-4980-a24c-e5b9bb621ef1	bf24034e-5558-44be-a5a4-897b0441af41	96d59f19-50ee-4a6a-ada0-d98816cded7f	В деталях	В деталях		2010-09-19 03:09:41.888+04	2010-09-19 03:09:41.888+04
11e5ef0f-fa6d-4de2-a035-ac41af3e835b	bf24034e-5558-44be-a5a4-897b0441af41	96d59f19-50ee-4a6a-ada0-d98816cded7f	Комплектация	Комплектация		2010-09-19 03:09:41.89+04	2010-09-19 03:09:41.89+04
fb06372c-6035-4ba1-88bc-aeb98a6a8560	bf24034e-5558-44be-a5a4-897b0441af41	96d59f19-50ee-4a6a-ada0-d98816cded7f	Парк ЗР	Парк ЗР		2010-09-19 03:09:41.892+04	2010-09-19 03:09:41.892+04
97f8f2c2-cd1f-45b7-bfb9-b8f28d761811	bf24034e-5558-44be-a5a4-897b0441af41	96d59f19-50ee-4a6a-ada0-d98816cded7f	Опции	Опции		2010-09-19 03:09:41.894+04	2010-09-19 03:09:41.894+04
b2ddee76-9f54-431c-9fd9-0053d998fe3b	bf24034e-5558-44be-a5a4-897b0441af41	96d59f19-50ee-4a6a-ada0-d98816cded7f	Автосалон	Автосалон		2010-09-19 03:09:41.896+04	2010-09-19 03:09:41.896+04
4f6166cd-b210-4c4e-ad0b-7d88cea56685	bf24034e-5558-44be-a5a4-897b0441af41	82d53ee6-b357-4ca2-ae1c-92f825bde72c	Вы нам писали	Вы нам писали		2010-09-19 03:09:41.898+04	2010-09-19 03:09:41.898+04
765e2edb-a94d-4fa7-bd31-974c2d32868e	bf24034e-5558-44be-a5a4-897b0441af41	82d53ee6-b357-4ca2-ae1c-92f825bde72c	Отвечает Главред	Отвечает Главред		2010-09-19 03:09:41.9+04	2010-09-19 03:09:41.9+04
0216cfb0-6d77-4493-be67-f93d8045de9d	bf24034e-5558-44be-a5a4-897b0441af41	82d53ee6-b357-4ca2-ae1c-92f825bde72c	Личное мнение	Личное мнение		2010-09-19 03:09:41.902+04	2010-09-19 03:09:41.902+04
2bdec4f1-28e3-48e9-af57-399d8d1cfd83	bf24034e-5558-44be-a5a4-897b0441af41	676df53e-f898-472e-ad92-44908006f78d	С миру по гонке	С миру по гонке		2010-09-19 03:09:41.904+04	2010-09-19 03:09:41.904+04
cdc9ca0a-ac8e-47b4-a1d3-c7adb479a80e	bf24034e-5558-44be-a5a4-897b0441af41	676df53e-f898-472e-ad92-44908006f78d	Ралли	Ралли		2010-09-19 03:09:41.906+04	2010-09-19 03:09:41.906+04
a783fd1f-29b7-4219-a0a0-b246d7c276c3	bf24034e-5558-44be-a5a4-897b0441af41	676df53e-f898-472e-ad92-44908006f78d	Формула-1	Формула-1		2010-09-19 03:09:41.909+04	2010-09-19 03:09:41.909+04
38f11ce6-f6ee-4038-a216-4be4918265c5	bf24034e-5558-44be-a5a4-897b0441af41	676df53e-f898-472e-ad92-44908006f78d	Спорт	Спорт		2010-09-19 03:09:41.911+04	2010-09-19 03:09:41.911+04
b02c3c72-a19c-4506-9fa9-2db7b5e555c6	bf24034e-5558-44be-a5a4-897b0441af41	676df53e-f898-472e-ad92-44908006f78d	Кольцевые гонки	Кольцевые гонки		2010-09-19 03:09:41.913+04	2010-09-19 03:09:41.913+04
56fa1a9e-35d7-460d-b664-473d46f89a32	bf24034e-5558-44be-a5a4-897b0441af41	b492843e-2f9b-4453-95f4-bd2d7ed76f74	Грузовики	Грузовики		2010-09-19 03:09:41.915+04	2010-09-19 03:09:41.915+04
4c1b4aaf-82c9-4dd5-a0fc-ad563abc812b	bf24034e-5558-44be-a5a4-897b0441af41	49c34633-16e0-4579-9c82-fff3992c0922	Интервью	Интервью		2010-09-19 03:09:41.918+04	2010-09-19 03:09:41.918+04
e36371f1-f47e-4823-b43b-8a8316217e1f	bf24034e-5558-44be-a5a4-897b0441af41	49c34633-16e0-4579-9c82-fff3992c0922	Экономика-Обозрение	Экономика-Обозрение		2010-09-19 03:09:41.92+04	2010-09-19 03:09:41.92+04
6be376dc-1d1b-4684-8e43-a2c03bd9021f	bf24034e-5558-44be-a5a4-897b0441af41	49c34633-16e0-4579-9c82-fff3992c0922	Новости	Новости		2010-09-19 03:09:41.923+04	2010-09-19 03:09:41.923+04
d9491d27-7f6c-4c2a-adc7-654542f71e1a	bf24034e-5558-44be-a5a4-897b0441af41	83b65697-dab8-4c98-8ea1-db5c3a773c8d	Спорный момент	Спорный момент		2010-09-19 03:09:41.925+04	2010-09-19 03:09:41.925+04
5b9cf4d4-b250-4a39-866f-bcb95fb8a692	bf24034e-5558-44be-a5a4-897b0441af41	83b65697-dab8-4c98-8ea1-db5c3a773c8d	Следствие ведет ЗР	Следствие ведет ЗР		2010-09-19 03:09:41.927+04	2010-09-19 03:09:41.927+04
fd98b7e9-8412-44f3-9838-e414e3cfe80e	bf24034e-5558-44be-a5a4-897b0441af41	83b65697-dab8-4c98-8ea1-db5c3a773c8d	Самозащита	Самозащита		2010-09-19 03:09:41.929+04	2010-09-19 03:09:41.929+04
45836f8b-0008-4096-959a-9f7284bcc7ec	bf24034e-5558-44be-a5a4-897b0441af41	83b65697-dab8-4c98-8ea1-db5c3a773c8d	Прямая линия	Прямая линия		2010-09-19 03:09:41.932+04	2010-09-19 03:09:41.932+04
6ccfbbce-f940-4d8a-b4fa-a23e950c1b33	bf24034e-5558-44be-a5a4-897b0441af41	83b65697-dab8-4c98-8ea1-db5c3a773c8d	Ответы юриста	Ответы юриста		2010-09-19 03:09:41.935+04	2010-09-19 03:09:41.935+04
535e38d7-b729-42bb-8f5e-cfdfd7f69b2c	bf24034e-5558-44be-a5a4-897b0441af41	83b65697-dab8-4c98-8ea1-db5c3a773c8d	Безопасность	Безопасность		2010-09-19 03:09:41.937+04	2010-09-19 03:09:41.937+04
b8b78bc1-a416-4033-be36-50b82068c66f	bf24034e-5558-44be-a5a4-897b0441af41	83b65697-dab8-4c98-8ea1-db5c3a773c8d	Новости	Новости		2010-09-19 03:09:41.939+04	2010-09-19 03:09:41.939+04
d9296b3c-4168-4da6-ac94-484ee22d5a60	bf24034e-5558-44be-a5a4-897b0441af41	85d02f4d-5668-4833-b4db-eebc9398d2bb	Тест-ремонт	Тест-ремонт		2010-09-19 03:09:41.941+04	2010-09-19 03:09:41.941+04
58a5b3f7-c509-4532-bd4e-86efd36ad932	bf24034e-5558-44be-a5a4-897b0441af41	85d02f4d-5668-4833-b4db-eebc9398d2bb	Хочу разобраться	Хочу разобраться		2010-09-19 03:09:41.943+04	2010-09-19 03:09:41.943+04
c4b6d6a1-ab83-4e01-a2a1-70de4ff38472	bf24034e-5558-44be-a5a4-897b0441af41	85d02f4d-5668-4833-b4db-eebc9398d2bb	Мастерская	Мастерская		2010-09-19 03:09:41.945+04	2010-09-19 03:09:41.945+04
6eaed967-25d9-4aea-9aa6-b691a652eb58	bf24034e-5558-44be-a5a4-897b0441af41	85d02f4d-5668-4833-b4db-eebc9398d2bb	Взаимозаменяемость	Взаимозаменяемость		2010-09-19 03:09:41.947+04	2010-09-19 03:09:41.947+04
de518664-3cac-4dd4-992d-03414a5db2e1	bf24034e-5558-44be-a5a4-897b0441af41	85d02f4d-5668-4833-b4db-eebc9398d2bb	Отвечают специалисты	Отвечают специалисты		2010-09-19 03:09:41.949+04	2010-09-19 03:09:41.949+04
0ab3dc09-09c9-475b-8a2c-8e6740648885	bf24034e-5558-44be-a5a4-897b0441af41	85d02f4d-5668-4833-b4db-eebc9398d2bb	Советы бывалых	Советы бывалых		2010-09-19 03:09:41.951+04	2010-09-19 03:09:41.951+04
daf7c4f1-a30f-416f-8570-08004b050037	bf24034e-5558-44be-a5a4-897b0441af41	85d02f4d-5668-4833-b4db-eebc9398d2bb	Доводим	Доводим		2010-09-19 03:09:41.953+04	2010-09-19 03:09:41.953+04
7609cd3b-3329-410d-87d0-995edb0b580b	bf24034e-5558-44be-a5a4-897b0441af41	85d02f4d-5668-4833-b4db-eebc9398d2bb	Конкурс	Конкурс		2010-09-19 03:09:41.956+04	2010-09-19 03:09:41.956+04
f2c1f99a-2733-42e7-a76b-d9781bf60964	bf24034e-5558-44be-a5a4-897b0441af41	a699532f-5963-4731-a237-9b7b06ede8b9	Новинки-исследования-изобретения	Новинки-исследования-изобретения		2010-09-19 03:09:41.958+04	2010-09-19 03:09:41.958+04
ab82d287-8e19-41ff-8a5e-484960e0946b	bf24034e-5558-44be-a5a4-897b0441af41	a699532f-5963-4731-a237-9b7b06ede8b9	Обозрение	Обозрение		2010-09-19 03:09:41.96+04	2010-09-19 03:09:41.96+04
85cce19f-f23e-413a-bfa8-b655a35c818f	bf24034e-5558-44be-a5a4-897b0441af41	a699532f-5963-4731-a237-9b7b06ede8b9	Концепт-кар	Концепт-кар		2010-09-19 03:09:41.962+04	2010-09-19 03:09:41.962+04
4980ecea-c9f3-4bd3-aec9-4d246797ac96	bf24034e-5558-44be-a5a4-897b0441af41	a699532f-5963-4731-a237-9b7b06ede8b9	Технологии	Технологии		2010-09-19 03:09:41.964+04	2010-09-19 03:09:41.964+04
e89a5b62-f37e-4997-a523-d96973bf1de8	bf24034e-5558-44be-a5a4-897b0441af41	22c27d6b-9d82-4a33-b12a-8327845f5cfd	Без границ	Без границ		2010-09-19 03:09:41.966+04	2010-09-19 03:09:41.966+04
4a5bcea4-2b12-436a-94f4-be5099cb1778	bf24034e-5558-44be-a5a4-897b0441af41	22c27d6b-9d82-4a33-b12a-8327845f5cfd	Живые классики	Живые классики		2010-09-19 03:09:41.968+04	2010-09-19 03:09:41.968+04
db5f61bb-0e0e-4b76-8bbc-f5b05d600cc4	bf24034e-5558-44be-a5a4-897b0441af41	22c27d6b-9d82-4a33-b12a-8327845f5cfd	Эксперимент	Эксперимент		2010-09-19 03:09:41.97+04	2010-09-19 03:09:41.97+04
5096e41e-f930-4c54-a9d4-85a6a0a03355	bf24034e-5558-44be-a5a4-897b0441af41	22c27d6b-9d82-4a33-b12a-8327845f5cfd	Путешествие	Путешествие		2010-09-19 03:09:41.973+04	2010-09-19 03:09:41.973+04
f35d10a3-6ba2-43ae-a2d0-82e1cd80b3da	bf24034e-5558-44be-a5a4-897b0441af41	e6780b1f-f8b8-4a77-9078-30e2da6b096f	Цены ЗР	Цены ЗР		2010-09-19 03:09:41.974+04	2010-09-19 03:09:41.974+04
bd102f80-120a-495b-a1ce-7b025fc21c5c	bf24034e-5558-44be-a5a4-897b0441af41	0c218f5b-2e31-4715-8fe1-4017289048bc	На гребне моды	На гребне моды		2010-09-19 03:09:41.977+04	2010-09-19 03:09:41.977+04
c540ee59-53fa-4325-8912-29e252cf6307	bf24034e-5558-44be-a5a4-897b0441af41	0c218f5b-2e31-4715-8fe1-4017289048bc	Тюнинг	Тюнинг		2010-09-19 03:09:41.98+04	2010-09-19 03:09:41.98+04
00000000-0000-0000-0000-000000000000	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:41.987+04	2010-09-19 03:09:41.987+04
842ae181-09cc-4449-ac06-f2b0f93b9674	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	4c18fc13-b1a5-461e-b169-f29ae3c4b959	rubric1-1	rubric1-1		2010-09-19 03:09:42.008+04	2010-09-19 03:09:42.008+04
300797da-f115-4acc-bfeb-8237107c2c1d	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	4c18fc13-b1a5-461e-b169-f29ae3c4b959	rubric1-2	rubric1-2		2010-09-19 03:09:42.01+04	2010-09-19 03:09:42.01+04
b3167c08-2052-4da5-abb7-e47ab6b064cb	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	4c18fc13-b1a5-461e-b169-f29ae3c4b959	rubric1-3	rubric1-3		2010-09-19 03:09:42.011+04	2010-09-19 03:09:42.011+04
82261b8a-6e16-4e57-b82d-adc21198fe03	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	96cc7bcb-db43-4b75-a740-2ec2894b3076	rubric2-1	rubric2-1		2010-09-19 03:09:42.013+04	2010-09-19 03:09:42.013+04
7908bcc6-ce9f-437b-b868-152a3708c166	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	96cc7bcb-db43-4b75-a740-2ec2894b3076	rubric2-2	rubric2-2		2010-09-19 03:09:42.015+04	2010-09-19 03:09:42.015+04
c910abff-5263-4beb-9abc-923b85671fcb	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	96cc7bcb-db43-4b75-a740-2ec2894b3076	rubric2-3	rubric2-3		2010-09-19 03:09:42.016+04	2010-09-19 03:09:42.016+04
444e9c7a-e6af-46d3-92ad-af7ab5d39431	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	1bfa0496-de72-4952-adc4-1984280a29b6	rubric3-1	rubric3-1		2010-09-19 03:09:42.018+04	2010-09-19 03:09:42.018+04
3544f93b-12b3-48af-915e-4c0360eb1143	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	1bfa0496-de72-4952-adc4-1984280a29b6	rubric3-2	rubric3-2		2010-09-19 03:09:42.019+04	2010-09-19 03:09:42.019+04
d675fcf5-7b56-44b7-aa64-b34f6073eb15	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	1bfa0496-de72-4952-adc4-1984280a29b6	rubric3-3	rubric3-3		2010-09-19 03:09:42.021+04	2010-09-19 03:09:42.021+04
dfd50288-3482-4340-a563-3f331ba267ce	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	5b24ce1d-3327-4465-983f-c7c83d381874	rubric4-1	rubric4-1		2010-09-19 03:09:42.023+04	2010-09-19 03:09:42.023+04
845bc5f3-e106-4490-b320-93fb9f4a9ade	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	5b24ce1d-3327-4465-983f-c7c83d381874	rubric4-2	rubric4-2		2010-09-19 03:09:42.025+04	2010-09-19 03:09:42.025+04
05a48a0f-bfb7-4e43-a190-53f1f648a0c6	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	5b24ce1d-3327-4465-983f-c7c83d381874	rubric4-3	rubric4-3		2010-09-19 03:09:42.027+04	2010-09-19 03:09:42.027+04
b1eb4dcd-a8ec-4fb2-aeac-2851b2330a9a	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	fdcf5f95-821f-4166-8e43-276d6cec03b2	Содержание-1	Содержание-1		2010-09-19 03:09:42.028+04	2010-09-19 03:09:42.028+04
fb71a210-b9c4-4818-939d-7af1fd0366c4	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	fdcf5f95-821f-4166-8e43-276d6cec03b2	Содержание-2	Содержание-2		2010-09-19 03:09:42.03+04	2010-09-19 03:09:42.03+04
8610c90b-c6c7-44df-9009-919bad65b06e	33c47ee6-90f0-4c9c-82a7-d1836ede0b16	fdcf5f95-821f-4166-8e43-276d6cec03b2	Содержание-3	Содержание-3		2010-09-19 03:09:42.032+04	2010-09-19 03:09:42.032+04
00000000-0000-0000-0000-000000000000	8204b4c6-381a-4a1a-abd0-9b9977ccd8fe	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.038+04	2010-09-19 03:09:42.038+04
00000000-0000-0000-0000-000000000000	42845691-6ded-449f-9a70-424a80f60dfb	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.083+04	2010-09-19 03:09:42.083+04
00000000-0000-0000-0000-000000000000	83c0ff44-8f9c-4d52-bc4a-1781f140a450	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.122+04	2010-09-19 03:09:42.122+04
1064bec5-8919-447b-910c-3a1d04e5b8d7	83c0ff44-8f9c-4d52-bc4a-1781f140a450	957dcb09-fa6c-4612-94cb-09a08c0001c0	Тест	Тест		2010-09-19 03:09:42.157+04	2010-09-19 03:09:42.157+04
43045b9c-9aaa-448a-8ec6-dcc03f7c147e	83c0ff44-8f9c-4d52-bc4a-1781f140a450	957dcb09-fa6c-4612-94cb-09a08c0001c0	Спецтест	Спецтест		2010-09-19 03:09:42.159+04	2010-09-19 03:09:42.159+04
d0ed8f81-c419-4e21-be1e-a0cc70b09d93	83c0ff44-8f9c-4d52-bc4a-1781f140a450	957dcb09-fa6c-4612-94cb-09a08c0001c0	Премьера	Премьера		2010-09-19 03:09:42.162+04	2010-09-19 03:09:42.162+04
24e85982-e913-4c1b-98bd-ce9c58636e9a	83c0ff44-8f9c-4d52-bc4a-1781f140a450	957dcb09-fa6c-4612-94cb-09a08c0001c0	Наше знакомство	Наше знакомство		2010-09-19 03:09:42.164+04	2010-09-19 03:09:42.164+04
16604d46-7c2a-4326-a5f9-15ef382a5213	83c0ff44-8f9c-4d52-bc4a-1781f140a450	957dcb09-fa6c-4612-94cb-09a08c0001c0	Высший класс	Высший класс		2010-09-19 03:09:42.165+04	2010-09-19 03:09:42.165+04
810526c1-c8c1-4c45-a97e-20c855dfeeb7	83c0ff44-8f9c-4d52-bc4a-1781f140a450	957dcb09-fa6c-4612-94cb-09a08c0001c0	Презентация	Презентация		2010-09-19 03:09:42.166+04	2010-09-19 03:09:42.166+04
1f4186c1-8145-421c-9b31-75d7b3794d0c	83c0ff44-8f9c-4d52-bc4a-1781f140a450	beaa68cb-edf4-4911-aa17-61890bad5024	Компоненты	Компоненты		2010-09-19 03:09:42.168+04	2010-09-19 03:09:42.168+04
609237fc-04fc-420d-8bb8-94ad8d2083d4	83c0ff44-8f9c-4d52-bc4a-1781f140a450	beaa68cb-edf4-4911-aa17-61890bad5024	Экспертиза	Экспертиза		2010-09-19 03:09:42.169+04	2010-09-19 03:09:42.169+04
63bd3f3e-9be6-4b16-9aab-a975e300db67	83c0ff44-8f9c-4d52-bc4a-1781f140a450	beaa68cb-edf4-4911-aa17-61890bad5024	Новые товары	Новые товары		2010-09-19 03:09:42.171+04	2010-09-19 03:09:42.171+04
d371136c-a3be-4125-aab9-8597c440115a	83c0ff44-8f9c-4d52-bc4a-1781f140a450	beaa68cb-edf4-4911-aa17-61890bad5024	Электроника	Электроника		2010-09-19 03:09:42.173+04	2010-09-19 03:09:42.173+04
02d81537-c5c0-4cb4-99d1-62536d0a77ce	83c0ff44-8f9c-4d52-bc4a-1781f140a450	beaa68cb-edf4-4911-aa17-61890bad5024	На прилавке	На прилавке		2010-09-19 03:09:42.174+04	2010-09-19 03:09:42.174+04
faf2f4ca-4e99-4d7d-a3b9-f9a683cb49ee	83c0ff44-8f9c-4d52-bc4a-1781f140a450	f1120d4d-1c05-433c-9fe9-5928812078c4	Дегустация	Дегустация		2010-09-19 03:09:42.176+04	2010-09-19 03:09:42.176+04
134a7a6c-5f7b-4917-a4a0-5d42f32efac0	83c0ff44-8f9c-4d52-bc4a-1781f140a450	f1120d4d-1c05-433c-9fe9-5928812078c4	Семейство	Семейство		2010-09-19 03:09:42.177+04	2010-09-19 03:09:42.177+04
66e8dc74-a6a3-4aa1-9615-6515ceb0036d	83c0ff44-8f9c-4d52-bc4a-1781f140a450	f1120d4d-1c05-433c-9fe9-5928812078c4	Новости дилеров	Новости дилеров		2010-09-19 03:09:42.179+04	2010-09-19 03:09:42.179+04
37e1d6c1-7271-46e9-bc65-4ed9cca3ec43	83c0ff44-8f9c-4d52-bc4a-1781f140a450	f1120d4d-1c05-433c-9fe9-5928812078c4	В деталях	В деталях		2010-09-19 03:09:42.18+04	2010-09-19 03:09:42.18+04
0cf5dcd9-e865-4bc8-ac32-75048f0d6ca8	83c0ff44-8f9c-4d52-bc4a-1781f140a450	f1120d4d-1c05-433c-9fe9-5928812078c4	Комплектация	Комплектация		2010-09-19 03:09:42.181+04	2010-09-19 03:09:42.181+04
afa1f7a8-f925-4625-a71b-e0d105950b90	83c0ff44-8f9c-4d52-bc4a-1781f140a450	f1120d4d-1c05-433c-9fe9-5928812078c4	Парк ЗР	Парк ЗР		2010-09-19 03:09:42.183+04	2010-09-19 03:09:42.183+04
ed82e9cb-3d16-47a1-9cca-4f176001f334	83c0ff44-8f9c-4d52-bc4a-1781f140a450	f1120d4d-1c05-433c-9fe9-5928812078c4	Опции	Опции		2010-09-19 03:09:42.184+04	2010-09-19 03:09:42.184+04
cfc5370f-e829-43ce-b2a0-1f646e875fa1	83c0ff44-8f9c-4d52-bc4a-1781f140a450	f1120d4d-1c05-433c-9fe9-5928812078c4	Автосалон	Автосалон		2010-09-19 03:09:42.186+04	2010-09-19 03:09:42.186+04
2494ae09-669e-4f89-8358-ad49c19c8857	83c0ff44-8f9c-4d52-bc4a-1781f140a450	658eafa6-145e-4ff1-b700-c4d546675ea1	Вы нам писали	Вы нам писали		2010-09-19 03:09:42.187+04	2010-09-19 03:09:42.187+04
893a6694-cac8-4b63-a266-b99ec551748f	83c0ff44-8f9c-4d52-bc4a-1781f140a450	658eafa6-145e-4ff1-b700-c4d546675ea1	Отвечает Главред	Отвечает Главред		2010-09-19 03:09:42.189+04	2010-09-19 03:09:42.189+04
99c75051-1ce1-46f9-bb99-d4b7c98c149d	83c0ff44-8f9c-4d52-bc4a-1781f140a450	658eafa6-145e-4ff1-b700-c4d546675ea1	Личное мнение	Личное мнение		2010-09-19 03:09:42.19+04	2010-09-19 03:09:42.19+04
4b377063-37d1-4ea9-a597-586e7c8daf62	83c0ff44-8f9c-4d52-bc4a-1781f140a450	2d1e5c05-caab-4d77-81e9-b716d422d648	С миру по гонке	С миру по гонке		2010-09-19 03:09:42.191+04	2010-09-19 03:09:42.191+04
00a13b35-083d-4c7e-ae3e-2952c8bda394	83c0ff44-8f9c-4d52-bc4a-1781f140a450	2d1e5c05-caab-4d77-81e9-b716d422d648	Ралли	Ралли		2010-09-19 03:09:42.193+04	2010-09-19 03:09:42.193+04
57bd0830-a27d-4196-8529-7437a9add324	83c0ff44-8f9c-4d52-bc4a-1781f140a450	2d1e5c05-caab-4d77-81e9-b716d422d648	Формула-1	Формула-1		2010-09-19 03:09:42.194+04	2010-09-19 03:09:42.194+04
b79c52a9-339b-4932-bc3c-8b2cdb30cf8a	83c0ff44-8f9c-4d52-bc4a-1781f140a450	2d1e5c05-caab-4d77-81e9-b716d422d648	Спорт	Спорт		2010-09-19 03:09:42.196+04	2010-09-19 03:09:42.196+04
aae724da-b409-443d-8273-4b2433b361ce	83c0ff44-8f9c-4d52-bc4a-1781f140a450	2d1e5c05-caab-4d77-81e9-b716d422d648	Кольцевые гонки	Кольцевые гонки		2010-09-19 03:09:42.197+04	2010-09-19 03:09:42.197+04
41c76902-02fb-41e4-b5d6-1482545c8979	83c0ff44-8f9c-4d52-bc4a-1781f140a450	38b9e2ea-f4da-4a9d-ba9f-4421a50e7137	Грузовики	Грузовики		2010-09-19 03:09:42.199+04	2010-09-19 03:09:42.199+04
7d898901-241c-41ac-8ac7-c247cd18f574	83c0ff44-8f9c-4d52-bc4a-1781f140a450	2d90c725-01e5-437f-923f-0ad7f209de0c	Интервью	Интервью		2010-09-19 03:09:42.2+04	2010-09-19 03:09:42.2+04
8047616b-82bf-4d45-bff0-4d1d51872d69	83c0ff44-8f9c-4d52-bc4a-1781f140a450	2d90c725-01e5-437f-923f-0ad7f209de0c	Экономика-Обозрение	Экономика-Обозрение		2010-09-19 03:09:42.201+04	2010-09-19 03:09:42.201+04
efb0e5bf-bae8-4aeb-b626-7bbef4171919	83c0ff44-8f9c-4d52-bc4a-1781f140a450	2d90c725-01e5-437f-923f-0ad7f209de0c	Новости	Новости		2010-09-19 03:09:42.203+04	2010-09-19 03:09:42.203+04
577e92da-64d3-43d0-98fa-889ce0692e19	83c0ff44-8f9c-4d52-bc4a-1781f140a450	29c6dd29-a85a-4378-aa8b-b0eda0e31ce3	Спорный момент	Спорный момент		2010-09-19 03:09:42.204+04	2010-09-19 03:09:42.204+04
e5aa7118-fb6c-4453-b87d-020938905d46	83c0ff44-8f9c-4d52-bc4a-1781f140a450	29c6dd29-a85a-4378-aa8b-b0eda0e31ce3	Следствие ведет ЗР	Следствие ведет ЗР		2010-09-19 03:09:42.206+04	2010-09-19 03:09:42.206+04
d0e90235-3695-4704-9d07-8b7170077375	83c0ff44-8f9c-4d52-bc4a-1781f140a450	29c6dd29-a85a-4378-aa8b-b0eda0e31ce3	Самозащита	Самозащита		2010-09-19 03:09:42.208+04	2010-09-19 03:09:42.208+04
9dcd3ce7-50e5-45bf-844a-bb62346ee54b	83c0ff44-8f9c-4d52-bc4a-1781f140a450	29c6dd29-a85a-4378-aa8b-b0eda0e31ce3	Прямая линия	Прямая линия		2010-09-19 03:09:42.209+04	2010-09-19 03:09:42.209+04
1c2355c5-4c8d-4b72-bb73-f8bdfe5305a2	83c0ff44-8f9c-4d52-bc4a-1781f140a450	29c6dd29-a85a-4378-aa8b-b0eda0e31ce3	Ответы юриста	Ответы юриста		2010-09-19 03:09:42.211+04	2010-09-19 03:09:42.211+04
3de20c1b-0f03-4498-af30-098b11eda7d7	83c0ff44-8f9c-4d52-bc4a-1781f140a450	29c6dd29-a85a-4378-aa8b-b0eda0e31ce3	Безопасность	Безопасность		2010-09-19 03:09:42.212+04	2010-09-19 03:09:42.212+04
7211995d-0e50-411a-9d15-9c1a7ed32603	83c0ff44-8f9c-4d52-bc4a-1781f140a450	29c6dd29-a85a-4378-aa8b-b0eda0e31ce3	Новости	Новости		2010-09-19 03:09:42.213+04	2010-09-19 03:09:42.213+04
4eb3db13-2279-47f3-9dc2-7b1e854ce868	83c0ff44-8f9c-4d52-bc4a-1781f140a450	efa0c041-d7bb-4d39-84ea-913d32035c09	Тест-ремонт	Тест-ремонт		2010-09-19 03:09:42.215+04	2010-09-19 03:09:42.215+04
6f30abc6-140d-4901-a3af-a739b1ee32ce	83c0ff44-8f9c-4d52-bc4a-1781f140a450	efa0c041-d7bb-4d39-84ea-913d32035c09	Хочу разобраться	Хочу разобраться		2010-09-19 03:09:42.216+04	2010-09-19 03:09:42.216+04
79f448c0-dd51-4b50-98d4-272ea3a927a4	83c0ff44-8f9c-4d52-bc4a-1781f140a450	efa0c041-d7bb-4d39-84ea-913d32035c09	Мастерская	Мастерская		2010-09-19 03:09:42.218+04	2010-09-19 03:09:42.218+04
af49c62d-3c29-46b3-8112-27dcd96f8eae	83c0ff44-8f9c-4d52-bc4a-1781f140a450	efa0c041-d7bb-4d39-84ea-913d32035c09	Взаимозаменяемость	Взаимозаменяемость		2010-09-19 03:09:42.22+04	2010-09-19 03:09:42.22+04
aa66f7d3-7203-4099-addc-a489eece324e	83c0ff44-8f9c-4d52-bc4a-1781f140a450	efa0c041-d7bb-4d39-84ea-913d32035c09	Отвечают специалисты	Отвечают специалисты		2010-09-19 03:09:42.221+04	2010-09-19 03:09:42.221+04
8cf5fe93-af13-45d8-8047-4d780b7a94fd	83c0ff44-8f9c-4d52-bc4a-1781f140a450	efa0c041-d7bb-4d39-84ea-913d32035c09	Советы бывалых	Советы бывалых		2010-09-19 03:09:42.222+04	2010-09-19 03:09:42.222+04
2f13fa64-fd66-43f7-a6ff-98a45e70f145	83c0ff44-8f9c-4d52-bc4a-1781f140a450	efa0c041-d7bb-4d39-84ea-913d32035c09	Доводим	Доводим		2010-09-19 03:09:42.224+04	2010-09-19 03:09:42.224+04
09124009-a823-46c9-8d77-fea907d9be69	83c0ff44-8f9c-4d52-bc4a-1781f140a450	efa0c041-d7bb-4d39-84ea-913d32035c09	Конкурс	Конкурс		2010-09-19 03:09:42.225+04	2010-09-19 03:09:42.225+04
93b742d6-b202-4520-a8d3-48fb12248ca1	83c0ff44-8f9c-4d52-bc4a-1781f140a450	6806f197-9c0a-4227-b795-d1d7b9497404	Новинки-исследования-изобретения	Новинки-исследования-изобретения		2010-09-19 03:09:42.227+04	2010-09-19 03:09:42.227+04
57b04b08-68c1-4bf4-8bff-cb6b578885d4	83c0ff44-8f9c-4d52-bc4a-1781f140a450	6806f197-9c0a-4227-b795-d1d7b9497404	Обозрение	Обозрение		2010-09-19 03:09:42.229+04	2010-09-19 03:09:42.229+04
9c50e772-7b98-4fff-8de5-94c46743ba1f	83c0ff44-8f9c-4d52-bc4a-1781f140a450	6806f197-9c0a-4227-b795-d1d7b9497404	Концепт-кар	Концепт-кар		2010-09-19 03:09:42.23+04	2010-09-19 03:09:42.23+04
c1bdd331-409b-4c41-bc0a-100abca9d699	83c0ff44-8f9c-4d52-bc4a-1781f140a450	6806f197-9c0a-4227-b795-d1d7b9497404	Технологии	Технологии		2010-09-19 03:09:42.232+04	2010-09-19 03:09:42.232+04
ad7e4e38-3a81-4ab1-9548-731f0a55ba6b	83c0ff44-8f9c-4d52-bc4a-1781f140a450	3e27054e-dc0a-45ae-9d4e-78d2f0e05411	Без границ	Без границ		2010-09-19 03:09:42.233+04	2010-09-19 03:09:42.233+04
727d170d-2df4-412c-a8b2-164e8c315c19	83c0ff44-8f9c-4d52-bc4a-1781f140a450	3e27054e-dc0a-45ae-9d4e-78d2f0e05411	Живые классики	Живые классики		2010-09-19 03:09:42.235+04	2010-09-19 03:09:42.235+04
67ea83b7-a7b1-4083-88e4-558c7cb99860	83c0ff44-8f9c-4d52-bc4a-1781f140a450	3e27054e-dc0a-45ae-9d4e-78d2f0e05411	Эксперимент	Эксперимент		2010-09-19 03:09:42.236+04	2010-09-19 03:09:42.236+04
22fa17d1-7f42-40ce-ad13-509f89d24340	83c0ff44-8f9c-4d52-bc4a-1781f140a450	3e27054e-dc0a-45ae-9d4e-78d2f0e05411	Путешествие	Путешествие		2010-09-19 03:09:42.238+04	2010-09-19 03:09:42.238+04
382c1124-d28b-4800-b7cc-694592dfb7c6	83c0ff44-8f9c-4d52-bc4a-1781f140a450	91121f19-5855-45d5-9551-450b157c3ed7	Цены ЗР	Цены ЗР		2010-09-19 03:09:42.239+04	2010-09-19 03:09:42.239+04
3df2a86b-b884-4356-b18f-6aea515ac3d2	83c0ff44-8f9c-4d52-bc4a-1781f140a450	a1c45c85-d04c-4d03-86b1-6b5a8c1942b1	На гребне моды	На гребне моды		2010-09-19 03:09:42.241+04	2010-09-19 03:09:42.241+04
bcb6c689-e538-4694-952a-1d2a9e00bad2	83c0ff44-8f9c-4d52-bc4a-1781f140a450	a1c45c85-d04c-4d03-86b1-6b5a8c1942b1	Тюнинг	Тюнинг		2010-09-19 03:09:42.243+04	2010-09-19 03:09:42.243+04
00000000-0000-0000-0000-000000000000	35f75638-02d1-4e06-a29a-21e90f1cfde3	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.249+04	2010-09-19 03:09:42.249+04
00000000-0000-0000-0000-000000000000	b7f3aa1f-3443-43ea-8f25-280a00d24e35	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.284+04	2010-09-19 03:09:42.284+04
00000000-0000-0000-0000-000000000000	98fe92c9-b4a7-4a95-a0be-3dd72fd411d8	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.314+04	2010-09-19 03:09:42.314+04
00000000-0000-0000-0000-000000000000	e398085f-1158-44fb-a179-927e56556e4e	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.347+04	2010-09-19 03:09:42.347+04
00000000-0000-0000-0000-000000000000	78e8efb9-0d6a-4206-9ddc-350acbf3acc7	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.357+04	2010-09-19 03:09:42.357+04
00000000-0000-0000-0000-000000000000	4ce835c9-5c9d-4adb-92b3-ead02153f8f2	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.386+04	2010-09-19 03:09:42.386+04
00000000-0000-0000-0000-000000000000	66032704-2b7d-416c-98aa-aac5ad77dc64	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.414+04	2010-09-19 03:09:42.414+04
00000000-0000-0000-0000-000000000000	cb899fea-facf-4eca-a529-04f6def0af78	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.442+04	2010-09-19 03:09:42.442+04
00000000-0000-0000-0000-000000000000	b159dd0f-8bd7-4555-8319-2083556bb7f8	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.453+04	2010-09-19 03:09:42.453+04
00000000-0000-0000-0000-000000000000	63446907-3389-42e1-9775-d651a9d7877e	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.474+04	2010-09-19 03:09:42.474+04
00000000-0000-0000-0000-000000000000	5e21447b-0295-42d8-8fd5-b9af45f1af20	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.502+04	2010-09-19 03:09:42.502+04
00000000-0000-0000-0000-000000000000	35250213-05d7-4702-9d95-2f2be1812eb4	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.525+04	2010-09-19 03:09:42.525+04
00000000-0000-0000-0000-000000000000	c7141356-2836-4525-8465-53983cf09d20	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.549+04	2010-09-19 03:09:42.549+04
00000000-0000-0000-0000-000000000000	154a37c7-d12d-4e02-aabd-aeabcb0cb91b	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.568+04	2010-09-19 03:09:42.568+04
00000000-0000-0000-0000-000000000000	f792f23a-5123-4854-b50d-7352c9d20245	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.588+04	2010-09-19 03:09:42.588+04
00000000-0000-0000-0000-000000000000	70a3568d-7cdf-4ce1-9015-6cdd19972e06	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.608+04	2010-09-19 03:09:42.608+04
00000000-0000-0000-0000-000000000000	de7bcae7-cdc7-4df3-b177-af801d15cac6	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.632+04	2010-09-19 03:09:42.632+04
00000000-0000-0000-0000-000000000000	c6deaf72-e508-4f5d-aeca-942786e29e03	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.641+04	2010-09-19 03:09:42.641+04
00000000-0000-0000-0000-000000000000	81f5a35c-f74f-4d47-97da-a045878a7091	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.674+04	2010-09-19 03:09:42.674+04
00000000-0000-0000-0000-000000000000	08abc7af-37d9-4dfb-82ba-2bdb7a532cc5	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.697+04	2010-09-19 03:09:42.697+04
00000000-0000-0000-0000-000000000000	43942374-48e0-4319-b644-e16c6f9154ac	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.73+04	2010-09-19 03:09:42.73+04
00000000-0000-0000-0000-000000000000	b807f7cf-dcf2-42f0-93a6-3793c3e651a2	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.752+04	2010-09-19 03:09:42.752+04
00000000-0000-0000-0000-000000000000	08362519-7e72-4213-840a-4fc744c5a48e	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.784+04	2010-09-19 03:09:42.784+04
00000000-0000-0000-0000-000000000000	534b9942-48ef-49d7-bbbd-b752ecfde409	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.802+04	2010-09-19 03:09:42.802+04
00000000-0000-0000-0000-000000000000	f8e1287c-5527-464a-9a7e-478110ff1f03	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.832+04	2010-09-19 03:09:42.832+04
00000000-0000-0000-0000-000000000000	2d1808ce-bd9b-428e-ade9-b9aae2ce5c1b	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.858+04	2010-09-19 03:09:42.858+04
00000000-0000-0000-0000-000000000000	9b29875c-f00b-4c86-93eb-759fa3420a20	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.868+04	2010-09-19 03:09:42.868+04
00000000-0000-0000-0000-000000000000	020374f8-8db8-42a0-bb20-e2b5d3b67d04	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.897+04	2010-09-19 03:09:42.897+04
00000000-0000-0000-0000-000000000000	72a37221-8866-4172-b56c-793002d118f4	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.928+04	2010-09-19 03:09:42.928+04
00000000-0000-0000-0000-000000000000	79678219-1369-4195-b6e7-9e2e6fd51957	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.957+04	2010-09-19 03:09:42.957+04
00000000-0000-0000-0000-000000000000	054bd40f-e181-4114-bf46-a346319da606	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:42.989+04	2010-09-19 03:09:42.989+04
00000000-0000-0000-0000-000000000000	9b20caf1-5271-4f65-9184-f67515affdbe	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.011+04	2010-09-19 03:09:43.011+04
00000000-0000-0000-0000-000000000000	ac18cceb-3153-49b2-a49c-298787543411	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.039+04	2010-09-19 03:09:43.039+04
6e8f2e6d-6820-4236-995e-dfb395d08f50	ac18cceb-3153-49b2-a49c-298787543411	3194276d-af0a-49c1-a854-bb559a5905ef	Комплектация	Комплектация		2010-09-19 03:09:43.07+04	2010-09-19 03:09:43.07+04
8101a625-62b4-4343-a588-7e4512a40d25	ac18cceb-3153-49b2-a49c-298787543411	3194276d-af0a-49c1-a854-bb559a5905ef	Парк ЗР	Парк ЗР		2010-09-19 03:09:43.071+04	2010-09-19 03:09:43.071+04
4b23d7d7-b05f-4a3c-bc34-0fd45a08d894	ac18cceb-3153-49b2-a49c-298787543411	28a750a3-b9e6-4fc1-8ab5-dd997d2aaa7f	Тест	Тест		2010-09-19 03:09:43.073+04	2010-09-19 03:09:43.073+04
462f6b74-fa16-416d-919a-c4d52fc4167c	ac18cceb-3153-49b2-a49c-298787543411	28a750a3-b9e6-4fc1-8ab5-dd997d2aaa7f	Спецтест	Спецтест		2010-09-19 03:09:43.074+04	2010-09-19 03:09:43.074+04
6ce06ac8-04e2-4cf6-84e3-8d5ed38b2769	ac18cceb-3153-49b2-a49c-298787543411	28a750a3-b9e6-4fc1-8ab5-dd997d2aaa7f	Премьера	Премьера		2010-09-19 03:09:43.075+04	2010-09-19 03:09:43.075+04
eeda2855-1e3c-46af-be0e-11c0c0f132ff	ac18cceb-3153-49b2-a49c-298787543411	28a750a3-b9e6-4fc1-8ab5-dd997d2aaa7f	Презентация	Презентация		2010-09-19 03:09:43.077+04	2010-09-19 03:09:43.077+04
d6d74196-ef41-4bc0-bc50-6480e9cee2d1	ac18cceb-3153-49b2-a49c-298787543411	28a750a3-b9e6-4fc1-8ab5-dd997d2aaa7f	Наше знакомство	Наше знакомство		2010-09-19 03:09:43.078+04	2010-09-19 03:09:43.078+04
a9fe6155-d7e1-4ccd-86fd-ce32e6d11cc2	ac18cceb-3153-49b2-a49c-298787543411	28a750a3-b9e6-4fc1-8ab5-dd997d2aaa7f	Высший класс	Высший класс		2010-09-19 03:09:43.079+04	2010-09-19 03:09:43.079+04
651d90c5-ba97-444b-881d-cd07e67cf5b8	ac18cceb-3153-49b2-a49c-298787543411	28a750a3-b9e6-4fc1-8ab5-dd997d2aaa7f	Презентация	Презентация		2010-09-19 03:09:43.08+04	2010-09-19 03:09:43.08+04
5274b8d9-23e2-4aa4-aa21-3bcbd0a368c3	ac18cceb-3153-49b2-a49c-298787543411	c4f6e1b0-dcad-4efd-8d90-52088b5ec1d9	Компоненты	Компоненты		2010-09-19 03:09:43.081+04	2010-09-19 03:09:43.081+04
b37485c4-8770-46dd-bd1e-24a8b908a6d1	ac18cceb-3153-49b2-a49c-298787543411	c4f6e1b0-dcad-4efd-8d90-52088b5ec1d9	Экспертиза	Экспертиза		2010-09-19 03:09:43.083+04	2010-09-19 03:09:43.083+04
1b815a41-00a8-4bc8-b59a-5222a1b4572c	ac18cceb-3153-49b2-a49c-298787543411	c4f6e1b0-dcad-4efd-8d90-52088b5ec1d9	Новые товары	Новые товары		2010-09-19 03:09:43.084+04	2010-09-19 03:09:43.084+04
1545fd7a-4b7d-43f4-8c1b-9444d133f29d	ac18cceb-3153-49b2-a49c-298787543411	c4f6e1b0-dcad-4efd-8d90-52088b5ec1d9	Электроника	Электроника		2010-09-19 03:09:43.085+04	2010-09-19 03:09:43.085+04
7f5b4234-fc23-4d25-ac4c-a027302fae20	ac18cceb-3153-49b2-a49c-298787543411	c4f6e1b0-dcad-4efd-8d90-52088b5ec1d9	На прилавке	На прилавке		2010-09-19 03:09:43.086+04	2010-09-19 03:09:43.086+04
d119d80a-758b-469c-9e4c-b2920a1e0dee	ac18cceb-3153-49b2-a49c-298787543411	3194276d-af0a-49c1-a854-bb559a5905ef	Дегустация	Дегустация		2010-09-19 03:09:43.087+04	2010-09-19 03:09:43.087+04
6cd2ab36-d50c-4269-88a0-51d75f2740ee	ac18cceb-3153-49b2-a49c-298787543411	3194276d-af0a-49c1-a854-bb559a5905ef	Семейство	Семейство		2010-09-19 03:09:43.089+04	2010-09-19 03:09:43.089+04
ac519625-8135-41c8-b15b-c274964cd4e0	ac18cceb-3153-49b2-a49c-298787543411	3194276d-af0a-49c1-a854-bb559a5905ef	Новости дилеров	Новости дилеров		2010-09-19 03:09:43.09+04	2010-09-19 03:09:43.09+04
ff78e518-2cd6-43cf-981f-9f4df6c501c6	ac18cceb-3153-49b2-a49c-298787543411	3194276d-af0a-49c1-a854-bb559a5905ef	В деталях	В деталях		2010-09-19 03:09:43.091+04	2010-09-19 03:09:43.091+04
1ba20cb1-2e29-4825-b365-bc1ea0ac82df	ac18cceb-3153-49b2-a49c-298787543411	3194276d-af0a-49c1-a854-bb559a5905ef	Опции	Опции		2010-09-19 03:09:43.092+04	2010-09-19 03:09:43.092+04
3dc85fa9-f9df-461b-a05a-1decd8485c5a	ac18cceb-3153-49b2-a49c-298787543411	3194276d-af0a-49c1-a854-bb559a5905ef	Автосалон	Автосалон		2010-09-19 03:09:43.093+04	2010-09-19 03:09:43.093+04
3ead46a9-a7f2-465f-9b9f-18d606159c40	ac18cceb-3153-49b2-a49c-298787543411	5cbe4a25-d534-484a-8207-7a8077c91f68	Вы нам писали	Вы нам писали		2010-09-19 03:09:43.095+04	2010-09-19 03:09:43.095+04
4e30b793-bb91-4b30-af6b-cb80c31f3e01	ac18cceb-3153-49b2-a49c-298787543411	5cbe4a25-d534-484a-8207-7a8077c91f68	Отвечает Главред	Отвечает Главред		2010-09-19 03:09:43.096+04	2010-09-19 03:09:43.096+04
efd6f970-7882-4963-b54a-ef14f70f9e06	ac18cceb-3153-49b2-a49c-298787543411	5cbe4a25-d534-484a-8207-7a8077c91f68	Личное мнение	Личное мнение		2010-09-19 03:09:43.097+04	2010-09-19 03:09:43.097+04
76e499a4-d937-45fa-a2b3-a80d8beffdd5	ac18cceb-3153-49b2-a49c-298787543411	f148fc25-9044-4824-b03a-77b4e9a8697d	С миру по гонке	С миру по гонке		2010-09-19 03:09:43.098+04	2010-09-19 03:09:43.098+04
3f469081-1c4d-483f-a8e9-ce9a72443f64	ac18cceb-3153-49b2-a49c-298787543411	f148fc25-9044-4824-b03a-77b4e9a8697d	Ралли	Ралли		2010-09-19 03:09:43.099+04	2010-09-19 03:09:43.099+04
9e740a43-9c77-4e04-8539-cd4b44547d5f	ac18cceb-3153-49b2-a49c-298787543411	f148fc25-9044-4824-b03a-77b4e9a8697d	Формула-1	Формула-1		2010-09-19 03:09:43.101+04	2010-09-19 03:09:43.101+04
ef3b5704-5841-47bd-8910-e96462450c32	ac18cceb-3153-49b2-a49c-298787543411	f148fc25-9044-4824-b03a-77b4e9a8697d	Спорт	Спорт		2010-09-19 03:09:43.102+04	2010-09-19 03:09:43.102+04
087b0789-66e7-479f-8d1f-0e046500cf76	ac18cceb-3153-49b2-a49c-298787543411	f148fc25-9044-4824-b03a-77b4e9a8697d	Кольцевые гонки	Кольцевые гонки		2010-09-19 03:09:43.103+04	2010-09-19 03:09:43.103+04
388136fc-b718-4b24-995c-a4702b2ce124	ac18cceb-3153-49b2-a49c-298787543411	941fc721-6ebb-4011-9d6e-f33bb125a6e0	Грузовики	Грузовики		2010-09-19 03:09:43.104+04	2010-09-19 03:09:43.104+04
abbf941b-68ae-44fe-9cb1-be41b26d7517	ac18cceb-3153-49b2-a49c-298787543411	55513856-f1c0-45b4-87fe-d36902888f91	Интервью	Интервью		2010-09-19 03:09:43.106+04	2010-09-19 03:09:43.106+04
ac125798-85f5-46b2-ac24-1115860f51f3	ac18cceb-3153-49b2-a49c-298787543411	55513856-f1c0-45b4-87fe-d36902888f91	Экономика-Обозрение	Экономика-Обозрение		2010-09-19 03:09:43.107+04	2010-09-19 03:09:43.107+04
d14c470e-e598-41f8-ac75-b67056bcccfc	ac18cceb-3153-49b2-a49c-298787543411	55513856-f1c0-45b4-87fe-d36902888f91	Новости	Новости		2010-09-19 03:09:43.108+04	2010-09-19 03:09:43.108+04
ffeb286d-4cc3-4cee-a21f-fd262a08bea1	ac18cceb-3153-49b2-a49c-298787543411	bb1f14aa-cd7f-4a13-87b3-784ed75f6777	Спорный момент	Спорный момент		2010-09-19 03:09:43.109+04	2010-09-19 03:09:43.109+04
41b3021e-7803-4aaf-b167-46a8795cdc86	ac18cceb-3153-49b2-a49c-298787543411	bb1f14aa-cd7f-4a13-87b3-784ed75f6777	Следствие ведет ЗР	Следствие ведет ЗР		2010-09-19 03:09:43.111+04	2010-09-19 03:09:43.111+04
57667d91-187a-4e6b-aab3-c61e0f6111d6	ac18cceb-3153-49b2-a49c-298787543411	bb1f14aa-cd7f-4a13-87b3-784ed75f6777	Самозащита	Самозащита		2010-09-19 03:09:43.112+04	2010-09-19 03:09:43.112+04
2b51b9ee-f2b9-4de7-baa3-e2a6cd19d3ae	ac18cceb-3153-49b2-a49c-298787543411	bb1f14aa-cd7f-4a13-87b3-784ed75f6777	Прямая линия	Прямая линия		2010-09-19 03:09:43.113+04	2010-09-19 03:09:43.113+04
5069fb20-15d6-43a2-932d-136d892d9bf1	ac18cceb-3153-49b2-a49c-298787543411	bb1f14aa-cd7f-4a13-87b3-784ed75f6777	Ответы юриста	Ответы юриста		2010-09-19 03:09:43.114+04	2010-09-19 03:09:43.114+04
56bfa854-e47e-4b05-b380-631003c9dc1c	ac18cceb-3153-49b2-a49c-298787543411	bb1f14aa-cd7f-4a13-87b3-784ed75f6777	Безопасность	Безопасность		2010-09-19 03:09:43.115+04	2010-09-19 03:09:43.115+04
905fc687-bd77-4b73-bb62-f4f4913233e4	ac18cceb-3153-49b2-a49c-298787543411	bb1f14aa-cd7f-4a13-87b3-784ed75f6777	Новости	Новости		2010-09-19 03:09:43.116+04	2010-09-19 03:09:43.116+04
67e55e1d-bc3d-4b1c-9408-7e38fd4d6753	ac18cceb-3153-49b2-a49c-298787543411	d6bdff3e-c03c-47db-b956-7ac6c614c7e3	Тест-ремонт	Тест-ремонт		2010-09-19 03:09:43.118+04	2010-09-19 03:09:43.118+04
b354174d-7eba-43bc-9795-c4087de03364	ac18cceb-3153-49b2-a49c-298787543411	d6bdff3e-c03c-47db-b956-7ac6c614c7e3	Хочу разобраться	Хочу разобраться		2010-09-19 03:09:43.119+04	2010-09-19 03:09:43.119+04
2507b87e-d0eb-473c-a394-23bca6cdc982	ac18cceb-3153-49b2-a49c-298787543411	d6bdff3e-c03c-47db-b956-7ac6c614c7e3	Мастерская	Мастерская		2010-09-19 03:09:43.12+04	2010-09-19 03:09:43.12+04
0ee228d7-98f9-401a-82f3-46f12998ec46	ac18cceb-3153-49b2-a49c-298787543411	d6bdff3e-c03c-47db-b956-7ac6c614c7e3	Взаимозаменяемость	Взаимозаменяемость		2010-09-19 03:09:43.121+04	2010-09-19 03:09:43.121+04
dae5888b-f4ed-484b-90f5-a2698b60ff71	ac18cceb-3153-49b2-a49c-298787543411	d6bdff3e-c03c-47db-b956-7ac6c614c7e3	Отвечают специалисты	Отвечают специалисты		2010-09-19 03:09:43.122+04	2010-09-19 03:09:43.122+04
5c05f507-61dc-4599-86c2-dbbcba439f02	ac18cceb-3153-49b2-a49c-298787543411	d6bdff3e-c03c-47db-b956-7ac6c614c7e3	Советы бывалых	Советы бывалых		2010-09-19 03:09:43.124+04	2010-09-19 03:09:43.124+04
83d54394-8295-4da7-8663-87f8d2535d00	ac18cceb-3153-49b2-a49c-298787543411	d6bdff3e-c03c-47db-b956-7ac6c614c7e3	Доводим	Доводим		2010-09-19 03:09:43.125+04	2010-09-19 03:09:43.125+04
e7fecbd4-2700-4a96-a887-853a7af6fbc3	ac18cceb-3153-49b2-a49c-298787543411	d6bdff3e-c03c-47db-b956-7ac6c614c7e3	Конкурс	Конкурс		2010-09-19 03:09:43.126+04	2010-09-19 03:09:43.126+04
6f85f57e-13d8-439e-ad2c-b8602a059b25	ac18cceb-3153-49b2-a49c-298787543411	718ab83f-9f68-448c-9cf0-e260f26729dd	Новинки-исследования-изобретения	Новинки-исследования-изобретения		2010-09-19 03:09:43.127+04	2010-09-19 03:09:43.127+04
3eb07391-a3c4-4927-aea8-807889966d05	ac18cceb-3153-49b2-a49c-298787543411	718ab83f-9f68-448c-9cf0-e260f26729dd	Обозрение	Обозрение		2010-09-19 03:09:43.128+04	2010-09-19 03:09:43.128+04
0b921034-549f-48ac-8723-85f83bf086a3	ac18cceb-3153-49b2-a49c-298787543411	718ab83f-9f68-448c-9cf0-e260f26729dd	Концепт-кар	Концепт-кар		2010-09-19 03:09:43.129+04	2010-09-19 03:09:43.129+04
528eef76-11e8-4402-b974-0b2daaa8b547	ac18cceb-3153-49b2-a49c-298787543411	718ab83f-9f68-448c-9cf0-e260f26729dd	Технологии	Технологии		2010-09-19 03:09:43.131+04	2010-09-19 03:09:43.131+04
dadc0786-d4cc-44ce-a128-79434b9a3343	ac18cceb-3153-49b2-a49c-298787543411	e774c7cd-0b2b-4fe9-baca-fe3002db03d2	Без границ	Без границ		2010-09-19 03:09:43.132+04	2010-09-19 03:09:43.132+04
8bec5dd5-7c0e-44b2-905c-91451efd3454	ac18cceb-3153-49b2-a49c-298787543411	e774c7cd-0b2b-4fe9-baca-fe3002db03d2	Живые классики	Живые классики		2010-09-19 03:09:43.133+04	2010-09-19 03:09:43.133+04
60fc1fdf-d5cd-4e0e-8dd8-381e6268a953	ac18cceb-3153-49b2-a49c-298787543411	e774c7cd-0b2b-4fe9-baca-fe3002db03d2	Эксперимент	Эксперимент		2010-09-19 03:09:43.134+04	2010-09-19 03:09:43.134+04
1bfd763e-5da4-406d-bb08-f818b6d914d6	ac18cceb-3153-49b2-a49c-298787543411	e774c7cd-0b2b-4fe9-baca-fe3002db03d2	Путешествие	Путешествие		2010-09-19 03:09:43.136+04	2010-09-19 03:09:43.136+04
fa4891ca-747f-4668-9e74-d1a2cf6d5b0b	ac18cceb-3153-49b2-a49c-298787543411	929b2e7a-80cb-436a-9a5b-d58aa9089dac	Цены ЗР	Цены ЗР		2010-09-19 03:09:43.137+04	2010-09-19 03:09:43.137+04
aacab953-a05f-4e85-8e8c-97dbfb5baa2f	ac18cceb-3153-49b2-a49c-298787543411	b7ef184e-647a-403e-853c-9ea298d5c171	На гребне моды	На гребне моды		2010-09-19 03:09:43.138+04	2010-09-19 03:09:43.138+04
f5c362c2-11a3-49e5-aa87-47879233603b	ac18cceb-3153-49b2-a49c-298787543411	b7ef184e-647a-403e-853c-9ea298d5c171	Тюнинг	Тюнинг		2010-09-19 03:09:43.139+04	2010-09-19 03:09:43.139+04
00000000-0000-0000-0000-000000000000	8023615e-eaed-44fc-bcbb-ffd59378c811	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.144+04	2010-09-19 03:09:43.144+04
00000000-0000-0000-0000-000000000000	ddba3254-f04d-4c4f-a6e3-06fa15f73ec8	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.166+04	2010-09-19 03:09:43.166+04
00000000-0000-0000-0000-000000000000	e268fa39-f35e-4a81-940f-f20033d64836	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.2+04	2010-09-19 03:09:43.2+04
00000000-0000-0000-0000-000000000000	e9a80f9b-45b4-4681-9319-ecdd2812efd4	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.231+04	2010-09-19 03:09:43.231+04
00000000-0000-0000-0000-000000000000	c536d8c3-33d6-44c5-b2e5-bcea671a070e	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.25+04	2010-09-19 03:09:43.25+04
00000000-0000-0000-0000-000000000000	88f25a94-6e90-42ce-855c-526aa92b9a5d	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.285+04	2010-09-19 03:09:43.285+04
00000000-0000-0000-0000-000000000000	08067592-b9eb-440b-8b98-e2491043ed39	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.311+04	2010-09-19 03:09:43.311+04
00000000-0000-0000-0000-000000000000	5913ff51-4ee4-4941-96ac-565236937c2d	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.345+04	2010-09-19 03:09:43.345+04
00000000-0000-0000-0000-000000000000	3b3b4951-c897-4626-9109-009ba3e9f9fd	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.37+04	2010-09-19 03:09:43.37+04
00000000-0000-0000-0000-000000000000	ee3ba207-a0ad-47f2-adf4-abf933619d15	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.395+04	2010-09-19 03:09:43.395+04
00000000-0000-0000-0000-000000000000	d62ba395-f854-43c4-8448-9508e72b3530	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.423+04	2010-09-19 03:09:43.423+04
00000000-0000-0000-0000-000000000000	dcc8ce2d-df05-472c-ba52-7d79b442546d	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.449+04	2010-09-19 03:09:43.449+04
00000000-0000-0000-0000-000000000000	44b2913d-bf64-4464-a079-aee6184b2d06	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.475+04	2010-09-19 03:09:43.475+04
00000000-0000-0000-0000-000000000000	6f932426-79d4-4631-8ccd-89c12ec6959f	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.498+04	2010-09-19 03:09:43.498+04
00000000-0000-0000-0000-000000000000	e8ffc95f-d90f-4f89-a2b0-0989c7bf61a2	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.527+04	2010-09-19 03:09:43.527+04
00000000-0000-0000-0000-000000000000	861454b0-4d5b-4bbe-b09c-c7b22093a525	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.553+04	2010-09-19 03:09:43.553+04
00000000-0000-0000-0000-000000000000	93739a43-c4ef-43ca-81e2-a2b64ac44d56	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.582+04	2010-09-19 03:09:43.582+04
00000000-0000-0000-0000-000000000000	750d111c-994c-46ca-888e-e2b4a8662887	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.605+04	2010-09-19 03:09:43.605+04
00000000-0000-0000-0000-000000000000	706f5f9c-5d90-4a15-9ddf-7a1939916b6c	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.639+04	2010-09-19 03:09:43.639+04
00000000-0000-0000-0000-000000000000	db776095-f67f-4e10-9acf-9e70e1fc83a8	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.664+04	2010-09-19 03:09:43.664+04
00000000-0000-0000-0000-000000000000	012fbccd-6b40-40b0-909a-7d07a1c0d224	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.686+04	2010-09-19 03:09:43.686+04
00000000-0000-0000-0000-000000000000	677e19ff-aaab-4a86-b61c-2f436de510a8	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.709+04	2010-09-19 03:09:43.709+04
00000000-0000-0000-0000-000000000000	dbc81fc4-645c-4827-8e5b-46a527a27e25	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.72+04	2010-09-19 03:09:43.72+04
00000000-0000-0000-0000-000000000000	90eb0213-95ca-427e-8f36-a5cbb0f51f24	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.743+04	2010-09-19 03:09:43.743+04
00000000-0000-0000-0000-000000000000	f3e51f59-e3da-4533-a304-a7f5dbda5648	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.774+04	2010-09-19 03:09:43.774+04
00000000-0000-0000-0000-000000000000	2a8ac2ed-9348-4c8b-9f25-ccd5c07350d5	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.81+04	2010-09-19 03:09:43.81+04
00000000-0000-0000-0000-000000000000	614a26eb-b7cb-47b3-a953-7ad6fe0557ba	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.835+04	2010-09-19 03:09:43.835+04
00000000-0000-0000-0000-000000000000	7760f777-bd78-4167-8647-c7d5f3232fc1	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.873+04	2010-09-19 03:09:43.873+04
5ff9ea37-a534-47e1-958c-31a6f3aa044a	7760f777-bd78-4167-8647-c7d5f3232fc1	d25eb967-aaee-4522-8b4d-c57459b2b2c3	Тест	Тест		2010-09-19 03:09:43.907+04	2010-09-19 03:09:43.907+04
5c60f3da-e5e2-464b-b96d-67bd0124451b	7760f777-bd78-4167-8647-c7d5f3232fc1	d25eb967-aaee-4522-8b4d-c57459b2b2c3	Спецтест	Спецтест		2010-09-19 03:09:43.909+04	2010-09-19 03:09:43.909+04
f2f002d4-b5a6-4ace-8825-0b3660ae5772	7760f777-bd78-4167-8647-c7d5f3232fc1	d25eb967-aaee-4522-8b4d-c57459b2b2c3	Премьера	Премьера		2010-09-19 03:09:43.91+04	2010-09-19 03:09:43.91+04
8ede2c21-3d0c-4540-b7f8-829a573bf99f	7760f777-bd78-4167-8647-c7d5f3232fc1	d25eb967-aaee-4522-8b4d-c57459b2b2c3	Презентация	Презентация		2010-09-19 03:09:43.911+04	2010-09-19 03:09:43.911+04
043f22cb-609c-4a2c-a878-bd5edfe99c8a	7760f777-bd78-4167-8647-c7d5f3232fc1	d25eb967-aaee-4522-8b4d-c57459b2b2c3	Наше знакомство	Наше знакомство		2010-09-19 03:09:43.912+04	2010-09-19 03:09:43.912+04
7816c98d-2017-4ae3-8b86-52c41f53b3da	7760f777-bd78-4167-8647-c7d5f3232fc1	d25eb967-aaee-4522-8b4d-c57459b2b2c3	Высший класс	Высший класс		2010-09-19 03:09:43.913+04	2010-09-19 03:09:43.913+04
2f7a3741-df19-46c0-805a-0f48f2781e4f	7760f777-bd78-4167-8647-c7d5f3232fc1	d25eb967-aaee-4522-8b4d-c57459b2b2c3	Авто на час	Авто на час		2010-09-19 03:09:43.915+04	2010-09-19 03:09:43.915+04
1410df1b-02b4-42b3-8295-9561ecd4c349	7760f777-bd78-4167-8647-c7d5f3232fc1	d25eb967-aaee-4522-8b4d-c57459b2b2c3	Испытано в деле	Испытано в деле		2010-09-19 03:09:43.916+04	2010-09-19 03:09:43.916+04
4bb91f19-5f8e-4494-89e0-39abec880d84	7760f777-bd78-4167-8647-c7d5f3232fc1	9da05598-4d4d-4c01-ae52-94d4aec5ab61	Компоненты	Компоненты		2010-09-19 03:09:43.917+04	2010-09-19 03:09:43.917+04
6ca8cb5d-3d80-4607-80f7-7ea06581d058	7760f777-bd78-4167-8647-c7d5f3232fc1	9da05598-4d4d-4c01-ae52-94d4aec5ab61	Экспертиза	Экспертиза		2010-09-19 03:09:43.919+04	2010-09-19 03:09:43.919+04
c3e92503-9c94-4e76-b127-40936e96cd05	7760f777-bd78-4167-8647-c7d5f3232fc1	9da05598-4d4d-4c01-ae52-94d4aec5ab61	Новые товары	Новые товары		2010-09-19 03:09:43.92+04	2010-09-19 03:09:43.92+04
63a08f70-f85d-4020-9943-80b3ac56ebf3	7760f777-bd78-4167-8647-c7d5f3232fc1	9da05598-4d4d-4c01-ae52-94d4aec5ab61	Электроника	Электроника		2010-09-19 03:09:43.921+04	2010-09-19 03:09:43.921+04
6399f910-b751-4e81-8f4d-1f4cb1738b9e	7760f777-bd78-4167-8647-c7d5f3232fc1	9da05598-4d4d-4c01-ae52-94d4aec5ab61	На прилавке	На прилавке		2010-09-19 03:09:43.922+04	2010-09-19 03:09:43.922+04
9caffdc1-3419-440a-8cd0-78f8354137aa	7760f777-bd78-4167-8647-c7d5f3232fc1	9da05598-4d4d-4c01-ae52-94d4aec5ab61	Товаровед	Товаровед		2010-09-19 03:09:43.923+04	2010-09-19 03:09:43.923+04
51e98f93-2a5a-4cc3-85bf-744959c7a04c	7760f777-bd78-4167-8647-c7d5f3232fc1	9da05598-4d4d-4c01-ae52-94d4aec5ab61	Проверено ЗР	Проверено ЗР		2010-09-19 03:09:43.925+04	2010-09-19 03:09:43.925+04
94e1ad0a-700a-4f4a-bf8e-a4096d0e53b3	7760f777-bd78-4167-8647-c7d5f3232fc1	fa8a94b3-a957-4036-ba56-2c2a5c2a65cb	Дегустация	Дегустация		2010-09-19 03:09:43.926+04	2010-09-19 03:09:43.926+04
761a510c-417d-47b7-bb85-53f4918bf375	7760f777-bd78-4167-8647-c7d5f3232fc1	fa8a94b3-a957-4036-ba56-2c2a5c2a65cb	Семейство	Семейство		2010-09-19 03:09:43.927+04	2010-09-19 03:09:43.927+04
80b08ef1-a6e1-4ad9-803b-72db3f95269a	7760f777-bd78-4167-8647-c7d5f3232fc1	fa8a94b3-a957-4036-ba56-2c2a5c2a65cb	Новости дилеров	Новости дилеров		2010-09-19 03:09:43.928+04	2010-09-19 03:09:43.928+04
711ec774-ca88-46b6-9dab-83a67a12edbc	7760f777-bd78-4167-8647-c7d5f3232fc1	fa8a94b3-a957-4036-ba56-2c2a5c2a65cb	В деталях	В деталях		2010-09-19 03:09:43.93+04	2010-09-19 03:09:43.93+04
19fb5dc3-b300-4809-a6f9-ede39eba870a	7760f777-bd78-4167-8647-c7d5f3232fc1	fa8a94b3-a957-4036-ba56-2c2a5c2a65cb	Комплектация	Комплектация		2010-09-19 03:09:43.931+04	2010-09-19 03:09:43.931+04
a139d33c-eaa8-40b6-a008-80698557b8b1	7760f777-bd78-4167-8647-c7d5f3232fc1	fa8a94b3-a957-4036-ba56-2c2a5c2a65cb	Парк ЗР	Парк ЗР		2010-09-19 03:09:43.932+04	2010-09-19 03:09:43.932+04
1dfe1b4b-2d0d-4fe8-a295-a2b9c331b2c8	7760f777-bd78-4167-8647-c7d5f3232fc1	fa8a94b3-a957-4036-ba56-2c2a5c2a65cb	Опции	Опции		2010-09-19 03:09:43.933+04	2010-09-19 03:09:43.933+04
79d985dc-181b-44ab-9437-28537df5c048	7760f777-bd78-4167-8647-c7d5f3232fc1	fa8a94b3-a957-4036-ba56-2c2a5c2a65cb	Автосалон	Автосалон		2010-09-19 03:09:43.934+04	2010-09-19 03:09:43.934+04
dabae897-3482-4375-b10d-0f00583e963b	7760f777-bd78-4167-8647-c7d5f3232fc1	67c17bab-a09d-48e6-95e0-f9d772427ef6	Вы нам писали	Вы нам писали		2010-09-19 03:09:43.936+04	2010-09-19 03:09:43.936+04
a7a18941-8c0c-4b1b-8575-9cc66e20e699	7760f777-bd78-4167-8647-c7d5f3232fc1	67c17bab-a09d-48e6-95e0-f9d772427ef6	Отвечает Главред	Отвечает Главред		2010-09-19 03:09:43.937+04	2010-09-19 03:09:43.937+04
9ab7dca9-1861-4e87-83de-871abb6f26d3	7760f777-bd78-4167-8647-c7d5f3232fc1	67c17bab-a09d-48e6-95e0-f9d772427ef6	Личное мнение	Личное мнение		2010-09-19 03:09:43.938+04	2010-09-19 03:09:43.938+04
b7288198-4257-4db4-ad7f-15300fb42857	7760f777-bd78-4167-8647-c7d5f3232fc1	71f4a649-192b-406a-bc82-75f6f0494aba	С миру по гонке	С миру по гонке		2010-09-19 03:09:43.939+04	2010-09-19 03:09:43.939+04
5d67c637-7d38-4f95-955e-4a1afbcd39f9	7760f777-bd78-4167-8647-c7d5f3232fc1	71f4a649-192b-406a-bc82-75f6f0494aba	Ралли	Ралли		2010-09-19 03:09:43.94+04	2010-09-19 03:09:43.94+04
05d9fb13-5572-4da3-8011-b60b312b8a1a	7760f777-bd78-4167-8647-c7d5f3232fc1	71f4a649-192b-406a-bc82-75f6f0494aba	Формула-1	Формула-1		2010-09-19 03:09:43.942+04	2010-09-19 03:09:43.942+04
9a3a46c2-eef7-40b5-a3f4-176d509209d6	7760f777-bd78-4167-8647-c7d5f3232fc1	71f4a649-192b-406a-bc82-75f6f0494aba	Спорт	Спорт		2010-09-19 03:09:43.943+04	2010-09-19 03:09:43.943+04
324d7d9d-cb42-4fb8-9142-c49f7db31457	7760f777-bd78-4167-8647-c7d5f3232fc1	71f4a649-192b-406a-bc82-75f6f0494aba	Кольцевые гонки	Кольцевые гонки		2010-09-19 03:09:43.944+04	2010-09-19 03:09:43.944+04
48700167-5f09-4c34-967c-7d3dfc68ed99	7760f777-bd78-4167-8647-c7d5f3232fc1	0ac9530d-fedf-4a93-a31a-3a1f1f14e6f8	Грузовики	Грузовики		2010-09-19 03:09:43.945+04	2010-09-19 03:09:43.945+04
88ac1c2b-32bd-4419-b3f1-2779dc62714c	7760f777-bd78-4167-8647-c7d5f3232fc1	839c2d0a-179c-4e17-91e4-0b8238067717	Интервью	Интервью		2010-09-19 03:09:43.947+04	2010-09-19 03:09:43.947+04
585bac9f-f4eb-454f-a405-f7189f9b5ba3	7760f777-bd78-4167-8647-c7d5f3232fc1	839c2d0a-179c-4e17-91e4-0b8238067717	Экономика-Обозрение	Экономика-Обозрение		2010-09-19 03:09:43.948+04	2010-09-19 03:09:43.948+04
613a04c1-89de-4ccf-b8b2-c7d5cb396fb2	7760f777-bd78-4167-8647-c7d5f3232fc1	839c2d0a-179c-4e17-91e4-0b8238067717	Новости	Новости		2010-09-19 03:09:43.949+04	2010-09-19 03:09:43.949+04
4ea1eb42-58b2-4750-a62c-006bb130cfa5	7760f777-bd78-4167-8647-c7d5f3232fc1	e4427615-97ce-4667-b71f-71cf1419b0f4	Спорный момент	Спорный момент		2010-09-19 03:09:43.95+04	2010-09-19 03:09:43.95+04
be3ec489-4e71-4029-a091-a80560f1356e	7760f777-bd78-4167-8647-c7d5f3232fc1	e4427615-97ce-4667-b71f-71cf1419b0f4	Следствие ведет ЗР	Следствие ведет ЗР		2010-09-19 03:09:43.952+04	2010-09-19 03:09:43.952+04
a4eeefdf-51b5-4055-b5c2-f2c49290eb9d	7760f777-bd78-4167-8647-c7d5f3232fc1	e4427615-97ce-4667-b71f-71cf1419b0f4	Самозащита	Самозащита		2010-09-19 03:09:43.953+04	2010-09-19 03:09:43.953+04
2af1b4ed-8f28-4384-9b88-e99cfb6b8772	7760f777-bd78-4167-8647-c7d5f3232fc1	e4427615-97ce-4667-b71f-71cf1419b0f4	Прямая линия	Прямая линия		2010-09-19 03:09:43.954+04	2010-09-19 03:09:43.954+04
91e01a65-2804-4c10-9876-aaebcdd548dc	7760f777-bd78-4167-8647-c7d5f3232fc1	e4427615-97ce-4667-b71f-71cf1419b0f4	Ответы юриста	Ответы юриста		2010-09-19 03:09:43.955+04	2010-09-19 03:09:43.955+04
5a10dba1-669a-494c-98c3-8b3bfb63b0ad	7760f777-bd78-4167-8647-c7d5f3232fc1	e4427615-97ce-4667-b71f-71cf1419b0f4	Безопасность	Безопасность		2010-09-19 03:09:43.956+04	2010-09-19 03:09:43.956+04
4a11c1b0-08b4-4851-b357-258312be24d9	7760f777-bd78-4167-8647-c7d5f3232fc1	e4427615-97ce-4667-b71f-71cf1419b0f4	Новости	Новости		2010-09-19 03:09:43.958+04	2010-09-19 03:09:43.958+04
ffc5289f-cda1-4a89-8599-920339c3b316	7760f777-bd78-4167-8647-c7d5f3232fc1	0917c949-6585-48ec-9539-b5c6d7efea35	Тест-ремонт	Тест-ремонт		2010-09-19 03:09:43.959+04	2010-09-19 03:09:43.959+04
5c8fa6d0-6de8-4bec-a4bd-bc4722767bd8	7760f777-bd78-4167-8647-c7d5f3232fc1	0917c949-6585-48ec-9539-b5c6d7efea35	Хочу разобраться	Хочу разобраться		2010-09-19 03:09:43.96+04	2010-09-19 03:09:43.96+04
c346d836-cd71-4dac-8767-07cb62e7f5c2	7760f777-bd78-4167-8647-c7d5f3232fc1	0917c949-6585-48ec-9539-b5c6d7efea35	Мастерская	Мастерская		2010-09-19 03:09:43.961+04	2010-09-19 03:09:43.961+04
6287ade9-70d4-4fc6-b5b4-94987cb68321	7760f777-bd78-4167-8647-c7d5f3232fc1	0917c949-6585-48ec-9539-b5c6d7efea35	Взаимозаменяемость	Взаимозаменяемость		2010-09-19 03:09:43.962+04	2010-09-19 03:09:43.962+04
ca0316c3-a55c-4614-b702-80f23b9699d6	7760f777-bd78-4167-8647-c7d5f3232fc1	0917c949-6585-48ec-9539-b5c6d7efea35	Отвечают специалисты	Отвечают специалисты		2010-09-19 03:09:43.964+04	2010-09-19 03:09:43.964+04
2b0037fd-aa5c-4fcd-9bce-709fa9f2464e	7760f777-bd78-4167-8647-c7d5f3232fc1	0917c949-6585-48ec-9539-b5c6d7efea35	Советы бывалых	Советы бывалых		2010-09-19 03:09:43.965+04	2010-09-19 03:09:43.965+04
541eeaec-56d5-43c1-aa16-54d6bf1886e5	7760f777-bd78-4167-8647-c7d5f3232fc1	0917c949-6585-48ec-9539-b5c6d7efea35	Доводим	Доводим		2010-09-19 03:09:43.966+04	2010-09-19 03:09:43.966+04
7a3e3a68-3458-43b5-a1df-427b25e69960	7760f777-bd78-4167-8647-c7d5f3232fc1	0917c949-6585-48ec-9539-b5c6d7efea35	Конкурс	Конкурс		2010-09-19 03:09:43.967+04	2010-09-19 03:09:43.967+04
2bf92c09-27cb-431f-9288-c324c2db742a	7760f777-bd78-4167-8647-c7d5f3232fc1	ec20904a-365f-4199-a89b-f177d68c2251	Обозрение	Обозрение		2010-09-19 03:09:43.968+04	2010-09-19 03:09:43.968+04
c04861da-c479-4804-af6c-9a1fd31557d6	7760f777-bd78-4167-8647-c7d5f3232fc1	ec20904a-365f-4199-a89b-f177d68c2251	Концепт-кар	Концепт-кар		2010-09-19 03:09:43.969+04	2010-09-19 03:09:43.969+04
9a9309f4-40f8-43f0-b5d7-978bfb8a169f	7760f777-bd78-4167-8647-c7d5f3232fc1	ec20904a-365f-4199-a89b-f177d68c2251	Технологии	Технологии		2010-09-19 03:09:43.971+04	2010-09-19 03:09:43.971+04
5361df23-a9ae-4af7-a493-befc07fbca6a	7760f777-bd78-4167-8647-c7d5f3232fc1	ec20904a-365f-4199-a89b-f177d68c2251	Новинки	Новинки	Новинки, исследования, изобретения	2010-09-19 03:09:43.972+04	2010-09-19 03:09:43.972+04
c026441a-ce3d-4cce-8e7f-976bd7238a88	7760f777-bd78-4167-8647-c7d5f3232fc1	029a3c27-aaf4-4650-88ac-f547a20998f2	Без границ	Без границ		2010-09-19 03:09:43.973+04	2010-09-19 03:09:43.973+04
2e686e2c-38c5-45d2-975e-cee255a209ed	7760f777-bd78-4167-8647-c7d5f3232fc1	029a3c27-aaf4-4650-88ac-f547a20998f2	Живые классики	Живые классики		2010-09-19 03:09:43.974+04	2010-09-19 03:09:43.974+04
4c3237be-6453-4e56-bcb5-4c49a9047bd0	7760f777-bd78-4167-8647-c7d5f3232fc1	029a3c27-aaf4-4650-88ac-f547a20998f2	Эксперимент	Эксперимент		2010-09-19 03:09:43.975+04	2010-09-19 03:09:43.975+04
ed53269c-3fcd-4179-8491-37ef07bbe4a0	7760f777-bd78-4167-8647-c7d5f3232fc1	029a3c27-aaf4-4650-88ac-f547a20998f2	Путешествие	Путешествие		2010-09-19 03:09:43.977+04	2010-09-19 03:09:43.977+04
c2cb771d-1f0b-4c7e-bc96-04186a9f8361	7760f777-bd78-4167-8647-c7d5f3232fc1	1dbed8e5-81e6-480e-9f0c-1b62818f3234	Цены ЗР	Цены ЗР		2010-09-19 03:09:43.978+04	2010-09-19 03:09:43.978+04
39c4772f-435c-417c-a7fb-f184120b2d1f	7760f777-bd78-4167-8647-c7d5f3232fc1	40c2a7d0-313c-43a2-afbd-d499f33145b0	На гребне моды	На гребне моды		2010-09-19 03:09:43.979+04	2010-09-19 03:09:43.979+04
712fa654-8875-4713-bd1d-73e6f503bf14	7760f777-bd78-4167-8647-c7d5f3232fc1	40c2a7d0-313c-43a2-afbd-d499f33145b0	Тюнинг	Тюнинг		2010-09-19 03:09:43.981+04	2010-09-19 03:09:43.981+04
00000000-0000-0000-0000-000000000000	0eac0aab-6534-4000-bd46-4f0e85c60847	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:43.988+04	2010-09-19 03:09:43.988+04
00000000-0000-0000-0000-000000000000	58771368-ca78-49f1-95c2-35e2b9873c6c	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:44.019+04	2010-09-19 03:09:44.019+04
00000000-0000-0000-0000-000000000000	d162b81c-94ef-425b-a04f-54818fffe63a	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:44.042+04	2010-09-19 03:09:44.042+04
01dc4bae-567a-4806-b668-2c7330ed092d	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	В курсе событий	В курсе событий		2010-09-19 03:09:44.064+04	2010-09-19 03:09:44.064+04
f6d1b5e7-1d0b-458b-930b-33c165fe054d	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Новости	Новости		2010-09-19 03:09:44.065+04	2010-09-19 03:09:44.065+04
d6157afd-20c7-454c-92e1-70a260ce9531	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Конференция	Конференция		2010-09-19 03:09:44.067+04	2010-09-19 03:09:44.067+04
2f4b3740-3e36-4e69-9fc2-2ef32686f337	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Особое внимание	Особое внимание		2010-09-19 03:09:44.068+04	2010-09-19 03:09:44.068+04
7fc37297-effc-4a39-b718-be2d22acabb7	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Кадры	Кадры		2010-09-19 03:09:44.069+04	2010-09-19 03:09:44.069+04
ba74a91e-c2ee-4d44-a3f0-d76eca423633	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Безопасность	Безопасность		2010-09-19 03:09:44.07+04	2010-09-19 03:09:44.07+04
87cf616a-4bf4-477c-b820-8ab37dec928d	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Лизинг	Лизинг		2010-09-19 03:09:44.071+04	2010-09-19 03:09:44.071+04
8b87e6d0-47de-4c3d-b02e-51e72e3cdfdf	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Страхование	Страхование		2010-09-19 03:09:44.073+04	2010-09-19 03:09:44.073+04
dd58e05a-c9cd-4493-a43e-314ab57953e9	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Налоги	Налоги		2010-09-19 03:09:44.074+04	2010-09-19 03:09:44.074+04
0eb94621-eac1-4ac0-b2e1-acfc7a2f2dad	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Логистика	Логистика		2010-09-19 03:09:44.075+04	2010-09-19 03:09:44.075+04
8f97cc9e-6a60-475b-99dc-7861644d266c	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Гарантия	Гарантия		2010-09-19 03:09:44.076+04	2010-09-19 03:09:44.076+04
91f53afe-426c-46f3-80c7-2c781acdad27	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Перевозки	Перевозки		2010-09-19 03:09:44.077+04	2010-09-19 03:09:44.077+04
bea0feb2-2542-4e65-bb8d-26d89c67e20d	d162b81c-94ef-425b-a04f-54818fffe63a	baec765f-ba6e-4aaf-9de6-306cc414a319	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:44.081+04	2010-09-19 03:09:44.081+04
4342a1ef-95ed-463a-812a-731ad784fded	d162b81c-94ef-425b-a04f-54818fffe63a	6a02e89a-8f0b-484d-b42e-633d4e5073fd	Tyrex Trophy	Tyrex Trophy		2010-09-19 03:09:44.083+04	2010-09-19 03:09:44.083+04
8766fd25-0b3f-46ba-9ec0-3f2f8493a87f	d162b81c-94ef-425b-a04f-54818fffe63a	6a02e89a-8f0b-484d-b42e-633d4e5073fd	УМЗ-4216	УМЗ-4216		2010-09-19 03:09:44.084+04	2010-09-19 03:09:44.084+04
1dea5eee-4e2f-46c1-8b40-9263cdee168e	d162b81c-94ef-425b-a04f-54818fffe63a	6a02e89a-8f0b-484d-b42e-633d4e5073fd	GoodYear	GoodYear		2010-09-19 03:09:44.086+04	2010-09-19 03:09:44.086+04
7b0b2e77-7c61-401f-9321-f96b6914b82f	d162b81c-94ef-425b-a04f-54818fffe63a	42f74d43-a1ca-49bd-9b1c-751792f030a9	Премьера	Премьера		2010-09-19 03:09:44.087+04	2010-09-19 03:09:44.087+04
0a391333-142e-4e89-b558-30801c1d921b	d162b81c-94ef-425b-a04f-54818fffe63a	42f74d43-a1ca-49bd-9b1c-751792f030a9	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:44.088+04	2010-09-19 03:09:44.088+04
ef9af986-87fe-4f6f-a506-1e0c1aa5ad13	d162b81c-94ef-425b-a04f-54818fffe63a	42f74d43-a1ca-49bd-9b1c-751792f030a9	Новости	Новости		2010-09-19 03:09:44.089+04	2010-09-19 03:09:44.089+04
89b6e1a2-f031-4260-a84f-526e9e321c7a	d162b81c-94ef-425b-a04f-54818fffe63a	42f74d43-a1ca-49bd-9b1c-751792f030a9	Опыт эксплуатации	Опыт эксплуатации		2010-09-19 03:09:44.09+04	2010-09-19 03:09:44.09+04
87d9ad26-ac0a-45b8-a00d-ab8bf71b12e8	d162b81c-94ef-425b-a04f-54818fffe63a	42f74d43-a1ca-49bd-9b1c-751792f030a9	Конкуренты с востока	Конкуренты с востока		2010-09-19 03:09:44.091+04	2010-09-19 03:09:44.091+04
555c4863-e786-4062-a8fa-348bedc5a56a	d162b81c-94ef-425b-a04f-54818fffe63a	42f74d43-a1ca-49bd-9b1c-751792f030a9	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:44.093+04	2010-09-19 03:09:44.093+04
c70a4d14-9c60-4ac6-83d4-bdf5e78945ef	d162b81c-94ef-425b-a04f-54818fffe63a	42f74d43-a1ca-49bd-9b1c-751792f030a9	Прицепы	Прицепы		2010-09-19 03:09:44.094+04	2010-09-19 03:09:44.094+04
1f2d779d-3b45-4e5c-8927-b1f1a38145f7	d162b81c-94ef-425b-a04f-54818fffe63a	fa35ae85-ad7c-42a3-a75b-037d3c5932a7	Прицепы	Прицепы		2010-09-19 03:09:44.095+04	2010-09-19 03:09:44.095+04
950e7b89-9683-43f4-bdb9-a67c26ac08bd	d162b81c-94ef-425b-a04f-54818fffe63a	fa35ae85-ad7c-42a3-a75b-037d3c5932a7	Новости	Новости		2010-09-19 03:09:44.096+04	2010-09-19 03:09:44.096+04
ec109d46-18ba-495f-b250-f25f7dc1c666	d162b81c-94ef-425b-a04f-54818fffe63a	fa35ae85-ad7c-42a3-a75b-037d3c5932a7	Без комментариев	Без комментариев		2010-09-19 03:09:44.098+04	2010-09-19 03:09:44.098+04
8753ac42-3b6d-4891-9db4-f5c37de631d6	d162b81c-94ef-425b-a04f-54818fffe63a	fa35ae85-ad7c-42a3-a75b-037d3c5932a7	Компоненты	Компоненты		2010-09-19 03:09:44.099+04	2010-09-19 03:09:44.099+04
f75eaf4e-1bb5-4ecf-9098-53af5ce33f9c	d162b81c-94ef-425b-a04f-54818fffe63a	fa35ae85-ad7c-42a3-a75b-037d3c5932a7	Бизнес в России	Бизнес в России		2010-09-19 03:09:44.1+04	2010-09-19 03:09:44.1+04
02dc40de-d3f8-45f4-ad93-81fca5db091f	d162b81c-94ef-425b-a04f-54818fffe63a	fa35ae85-ad7c-42a3-a75b-037d3c5932a7	Масла	Масла		2010-09-19 03:09:44.101+04	2010-09-19 03:09:44.101+04
b25894ac-cb4e-4965-9b44-10a88cf553a2	d162b81c-94ef-425b-a04f-54818fffe63a	fa35ae85-ad7c-42a3-a75b-037d3c5932a7	Шины	Шины		2010-09-19 03:09:44.102+04	2010-09-19 03:09:44.102+04
1c2585d3-6a76-41f7-9a49-ddaa15d4c443	d162b81c-94ef-425b-a04f-54818fffe63a	fa35ae85-ad7c-42a3-a75b-037d3c5932a7	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:44.104+04	2010-09-19 03:09:44.104+04
9ec8c0fd-ed38-44a7-bbdd-81418801e829	d162b81c-94ef-425b-a04f-54818fffe63a	690e36e6-3d1b-4cce-ad2a-0377d65b704c	Новости	Новости		2010-09-19 03:09:44.105+04	2010-09-19 03:09:44.105+04
613b79dd-52f1-4e14-8d6a-087aed85988c	d162b81c-94ef-425b-a04f-54818fffe63a	690e36e6-3d1b-4cce-ad2a-0377d65b704c	Масла	Масла		2010-09-19 03:09:44.106+04	2010-09-19 03:09:44.106+04
554cbdcf-8335-4f9e-a7d0-25b8ae790bd2	d162b81c-94ef-425b-a04f-54818fffe63a	690e36e6-3d1b-4cce-ad2a-0377d65b704c	Шины	Шины		2010-09-19 03:09:44.107+04	2010-09-19 03:09:44.107+04
c2b1a5fc-5064-489d-ae0c-00e47255f695	d162b81c-94ef-425b-a04f-54818fffe63a	690e36e6-3d1b-4cce-ad2a-0377d65b704c	АКБ	АКБ		2010-09-19 03:09:44.109+04	2010-09-19 03:09:44.109+04
8a2df585-0c74-41e9-af22-1865b1faa1e7	d162b81c-94ef-425b-a04f-54818fffe63a	690e36e6-3d1b-4cce-ad2a-0377d65b704c	Ремзона	Ремзона		2010-09-19 03:09:44.11+04	2010-09-19 03:09:44.11+04
2763a517-5bab-4dbf-b6b3-fa7fcfdac3b7	d162b81c-94ef-425b-a04f-54818fffe63a	690e36e6-3d1b-4cce-ad2a-0377d65b704c	Оборудование	Оборудование		2010-09-19 03:09:44.111+04	2010-09-19 03:09:44.111+04
784ffdbd-33fd-446a-8d2f-84f495ff50c9	d162b81c-94ef-425b-a04f-54818fffe63a	690e36e6-3d1b-4cce-ad2a-0377d65b704c	Агрегаты	Агрегаты		2010-09-19 03:09:44.112+04	2010-09-19 03:09:44.112+04
00000000-0000-0000-0000-000000000000	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:44.117+04	2010-09-19 03:09:44.117+04
fa947054-170e-4837-a121-4f1dbaae68d5	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	В курсе событий	В курсе событий		2010-09-19 03:09:44.14+04	2010-09-19 03:09:44.14+04
d34db16f-061b-4d86-aa6e-95b198e54597	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Новости	Новости		2010-09-19 03:09:44.143+04	2010-09-19 03:09:44.143+04
bc47f08a-46ea-4ef3-bd60-c8b6fa135263	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Конференция	Конференция		2010-09-19 03:09:44.144+04	2010-09-19 03:09:44.144+04
ae66eab6-4e34-4f1e-bdef-6cbb5ecd76fb	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Особое внимание	Особое внимание		2010-09-19 03:09:44.145+04	2010-09-19 03:09:44.145+04
c4dcc845-010c-4bf3-8b81-9f46da83ac8d	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Кадры	Кадры		2010-09-19 03:09:44.146+04	2010-09-19 03:09:44.146+04
fdb355f8-7a39-4761-b413-b97b95282384	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Безопасность	Безопасность		2010-09-19 03:09:44.147+04	2010-09-19 03:09:44.147+04
03c35739-7460-4eca-b72f-ecee01a43005	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Лизинг	Лизинг		2010-09-19 03:09:44.149+04	2010-09-19 03:09:44.149+04
5f162494-e57f-4b2e-9a97-f2cd27cbae23	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Страхование	Страхование		2010-09-19 03:09:44.15+04	2010-09-19 03:09:44.15+04
a09a7c45-5c03-421c-8a43-f0d83a204ecc	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Налоги	Налоги		2010-09-19 03:09:44.152+04	2010-09-19 03:09:44.152+04
89a87e4e-2f7c-4ae3-ab4d-9ae67f8afa71	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Логистика	Логистика		2010-09-19 03:09:44.153+04	2010-09-19 03:09:44.153+04
d02fc689-82bd-4839-834a-c66de4908965	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Гарантия	Гарантия		2010-09-19 03:09:44.154+04	2010-09-19 03:09:44.154+04
cd2936f2-a5dd-496c-a396-9f156b56ed27	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Перевозки	Перевозки		2010-09-19 03:09:44.184+04	2010-09-19 03:09:44.184+04
7fe5c4a0-71af-4d09-bc72-185ed747d05f	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	98c237aa-441e-49a3-997d-0bc22fba07cd	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:44.187+04	2010-09-19 03:09:44.187+04
64c39fa8-38fc-4503-8528-811d1b37e042	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	9fe45981-f5cc-4b90-b853-935fce2e7b5d	Tyrex Trophy	Tyrex Trophy		2010-09-19 03:09:44.189+04	2010-09-19 03:09:44.189+04
31fd6290-5e2b-4217-a040-a4d64e89c9fb	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	9fe45981-f5cc-4b90-b853-935fce2e7b5d	УМЗ-4216	УМЗ-4216		2010-09-19 03:09:44.191+04	2010-09-19 03:09:44.191+04
55c53548-6fc5-48f3-b05d-e7ed222d3687	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	9fe45981-f5cc-4b90-b853-935fce2e7b5d	GoodYear	GoodYear		2010-09-19 03:09:44.192+04	2010-09-19 03:09:44.192+04
9d36d904-5b30-4074-b56b-1328da041d3e	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	0c99a13e-1529-4130-ba6b-c3e88fe6f6f9	Премьера	Премьера		2010-09-19 03:09:44.193+04	2010-09-19 03:09:44.193+04
f26a9422-8690-4479-8c3b-85b9aec3ba60	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	0c99a13e-1529-4130-ba6b-c3e88fe6f6f9	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:44.194+04	2010-09-19 03:09:44.194+04
7aae4bee-e4c6-4a7f-ba14-194a9316af67	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	0c99a13e-1529-4130-ba6b-c3e88fe6f6f9	Новости	Новости		2010-09-19 03:09:44.195+04	2010-09-19 03:09:44.195+04
4d944cad-7e8f-4dd0-a0d7-ed746506bc0d	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	0c99a13e-1529-4130-ba6b-c3e88fe6f6f9	Опыт эксплуатации	Опыт эксплуатации		2010-09-19 03:09:44.197+04	2010-09-19 03:09:44.197+04
ba818617-0e8c-495c-9543-2662726c38b5	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	0c99a13e-1529-4130-ba6b-c3e88fe6f6f9	Конкуренты с востока	Конкуренты с востока		2010-09-19 03:09:44.198+04	2010-09-19 03:09:44.198+04
a7691513-540c-4ff9-a745-40b52647516c	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	0c99a13e-1529-4130-ba6b-c3e88fe6f6f9	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:44.2+04	2010-09-19 03:09:44.2+04
111765a4-a308-4689-b5fe-5ab6b6efb121	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	0c99a13e-1529-4130-ba6b-c3e88fe6f6f9	Прицепы	Прицепы		2010-09-19 03:09:44.201+04	2010-09-19 03:09:44.201+04
60e7cfcc-be3e-49d3-93be-a62e4c171569	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	6a3b1f9c-c4b8-4f3f-9738-69dde90f98a0	Прицепы	Прицепы		2010-09-19 03:09:44.202+04	2010-09-19 03:09:44.202+04
6781aa44-5863-4795-8c7c-5bd392137864	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	6a3b1f9c-c4b8-4f3f-9738-69dde90f98a0	Новости	Новости		2010-09-19 03:09:44.203+04	2010-09-19 03:09:44.203+04
d43d7058-8e7a-4c38-9085-f26a859ba6f4	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	6a3b1f9c-c4b8-4f3f-9738-69dde90f98a0	Без комментариев	Без комментариев		2010-09-19 03:09:44.205+04	2010-09-19 03:09:44.205+04
bfbb295a-7d71-414e-bbb8-038342e3efc5	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	6a3b1f9c-c4b8-4f3f-9738-69dde90f98a0	Компоненты	Компоненты		2010-09-19 03:09:44.206+04	2010-09-19 03:09:44.206+04
cd2a9eea-868a-4037-8911-f858cfdcd21f	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	6a3b1f9c-c4b8-4f3f-9738-69dde90f98a0	Бизнес в России	Бизнес в России		2010-09-19 03:09:44.209+04	2010-09-19 03:09:44.209+04
ffcb1e9a-7a14-4ceb-8aab-4c24fe6a2025	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	6a3b1f9c-c4b8-4f3f-9738-69dde90f98a0	Масла	Масла		2010-09-19 03:09:44.21+04	2010-09-19 03:09:44.21+04
fbc7605c-b196-4fcf-94d6-ca38f2488c12	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	6a3b1f9c-c4b8-4f3f-9738-69dde90f98a0	Шины	Шины		2010-09-19 03:09:44.212+04	2010-09-19 03:09:44.212+04
14c3a706-0bd7-48d7-bd3f-20918f51bed5	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	6a3b1f9c-c4b8-4f3f-9738-69dde90f98a0	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:44.213+04	2010-09-19 03:09:44.213+04
659c81ff-40e2-4546-92dd-c80dfad8b2ae	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	af9350e0-bd10-4a84-b3f6-fe48097afa39	Новости	Новости		2010-09-19 03:09:44.214+04	2010-09-19 03:09:44.214+04
9adcc03a-d230-4734-bf35-0ce997f9a0a6	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	af9350e0-bd10-4a84-b3f6-fe48097afa39	Масла	Масла		2010-09-19 03:09:44.215+04	2010-09-19 03:09:44.215+04
16cdf25a-7cd5-443e-9dc4-c0847981ebc3	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	af9350e0-bd10-4a84-b3f6-fe48097afa39	Шины	Шины		2010-09-19 03:09:44.216+04	2010-09-19 03:09:44.216+04
b4f9a611-45ad-49df-bbec-6a99d2a73e2b	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	af9350e0-bd10-4a84-b3f6-fe48097afa39	АКБ	АКБ		2010-09-19 03:09:44.217+04	2010-09-19 03:09:44.217+04
ee4c9cf4-45cd-4df9-9dfa-7ae51a96eca2	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	af9350e0-bd10-4a84-b3f6-fe48097afa39	Ремзона	Ремзона		2010-09-19 03:09:44.219+04	2010-09-19 03:09:44.219+04
916bc469-55ec-4746-9de7-1a72e59433dc	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	af9350e0-bd10-4a84-b3f6-fe48097afa39	Оборудование	Оборудование		2010-09-19 03:09:44.22+04	2010-09-19 03:09:44.22+04
0a271e9f-7d59-45e9-ab79-12e05933a455	82e9f54e-d0a6-4f36-ad51-33a6067d38a8	af9350e0-bd10-4a84-b3f6-fe48097afa39	Агрегаты	Агрегаты		2010-09-19 03:09:44.221+04	2010-09-19 03:09:44.221+04
00000000-0000-0000-0000-000000000000	64e1b37e-eb7a-4201-b427-bb210bdf3736	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:44.226+04	2010-09-19 03:09:44.226+04
00000000-0000-0000-0000-000000000000	9a96554f-2f94-4af5-9fd1-116736efc27a	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:44.263+04	2010-09-19 03:09:44.263+04
48a76904-f0f9-4052-a3c2-b077b381fd8f	9a96554f-2f94-4af5-9fd1-116736efc27a	84c0b23a-5226-4f5d-aea6-37814b16acb2	Тест	Тест		2010-09-19 03:09:44.295+04	2010-09-19 03:09:44.295+04
6a26a4f5-5256-46be-bed0-13480387c579	9a96554f-2f94-4af5-9fd1-116736efc27a	84c0b23a-5226-4f5d-aea6-37814b16acb2	Спецтест	Спецтест		2010-09-19 03:09:44.298+04	2010-09-19 03:09:44.298+04
c7ee7811-deae-40f0-ad51-14dd810d1ed9	9a96554f-2f94-4af5-9fd1-116736efc27a	84c0b23a-5226-4f5d-aea6-37814b16acb2	Премьера	Премьера		2010-09-19 03:09:44.3+04	2010-09-19 03:09:44.3+04
59b6828f-b7be-4a8f-80e6-b5766846455f	9a96554f-2f94-4af5-9fd1-116736efc27a	84c0b23a-5226-4f5d-aea6-37814b16acb2	Презентация	Презентация		2010-09-19 03:09:44.301+04	2010-09-19 03:09:44.301+04
f8726ae3-083e-4a58-a854-4cfa82e394ee	9a96554f-2f94-4af5-9fd1-116736efc27a	84c0b23a-5226-4f5d-aea6-37814b16acb2	Наше знакомство	Наше знакомство		2010-09-19 03:09:44.303+04	2010-09-19 03:09:44.303+04
2d697d14-1b0c-49b6-8036-bb18d3d20824	9a96554f-2f94-4af5-9fd1-116736efc27a	84c0b23a-5226-4f5d-aea6-37814b16acb2	Высший класс	Высший класс		2010-09-19 03:09:44.304+04	2010-09-19 03:09:44.304+04
311afd22-4885-40d6-a27a-4587675fc966	9a96554f-2f94-4af5-9fd1-116736efc27a	84c0b23a-5226-4f5d-aea6-37814b16acb2	Авто на час	Авто на час		2010-09-19 03:09:44.305+04	2010-09-19 03:09:44.305+04
c3350700-8bbc-4e73-98f2-9bae28f09034	9a96554f-2f94-4af5-9fd1-116736efc27a	84c0b23a-5226-4f5d-aea6-37814b16acb2	Испытано в деле	Испытано в деле		2010-09-19 03:09:44.306+04	2010-09-19 03:09:44.306+04
649bd970-2b7e-4ae4-8ac8-7ac994c9d12f	9a96554f-2f94-4af5-9fd1-116736efc27a	f3d23ac4-37ba-40d4-8d29-757ab49f4254	Компоненты	Компоненты		2010-09-19 03:09:44.307+04	2010-09-19 03:09:44.307+04
c9404e20-f355-4a8c-bdff-313b3911a4f2	9a96554f-2f94-4af5-9fd1-116736efc27a	f3d23ac4-37ba-40d4-8d29-757ab49f4254	Экспертиза	Экспертиза		2010-09-19 03:09:44.309+04	2010-09-19 03:09:44.309+04
a18d9884-738d-4d27-8816-d6db67619f37	9a96554f-2f94-4af5-9fd1-116736efc27a	f3d23ac4-37ba-40d4-8d29-757ab49f4254	Новые товары	Новые товары		2010-09-19 03:09:44.31+04	2010-09-19 03:09:44.31+04
48c02c4d-a7df-43bc-9dc4-9f1485cbe976	9a96554f-2f94-4af5-9fd1-116736efc27a	f3d23ac4-37ba-40d4-8d29-757ab49f4254	Электроника	Электроника		2010-09-19 03:09:44.311+04	2010-09-19 03:09:44.311+04
de66ec36-6f06-4d8e-a1da-9af020f6279c	9a96554f-2f94-4af5-9fd1-116736efc27a	f3d23ac4-37ba-40d4-8d29-757ab49f4254	На прилавке	На прилавке		2010-09-19 03:09:44.312+04	2010-09-19 03:09:44.312+04
46e06f5b-b88b-4629-bd9c-b5173831b777	9a96554f-2f94-4af5-9fd1-116736efc27a	f3d23ac4-37ba-40d4-8d29-757ab49f4254	Товаровед	Товаровед		2010-09-19 03:09:44.314+04	2010-09-19 03:09:44.314+04
3c21c79c-b3a9-4f4e-a4a7-ec52ca18797f	9a96554f-2f94-4af5-9fd1-116736efc27a	f3d23ac4-37ba-40d4-8d29-757ab49f4254	Проверено ЗР	Проверено ЗР		2010-09-19 03:09:44.315+04	2010-09-19 03:09:44.315+04
212fc0cb-a3a9-41e3-9e28-1357559f5d5d	9a96554f-2f94-4af5-9fd1-116736efc27a	40d73146-9c34-4922-bbe0-4b5db48abaac	Дегустация	Дегустация		2010-09-19 03:09:44.316+04	2010-09-19 03:09:44.316+04
4b93de86-8f6e-4f03-bd73-673972ccf1f8	9a96554f-2f94-4af5-9fd1-116736efc27a	40d73146-9c34-4922-bbe0-4b5db48abaac	Семейство	Семейство		2010-09-19 03:09:44.318+04	2010-09-19 03:09:44.318+04
0565a633-46bf-4dd4-a424-944ab293515c	9a96554f-2f94-4af5-9fd1-116736efc27a	40d73146-9c34-4922-bbe0-4b5db48abaac	Новости дилеров	Новости дилеров		2010-09-19 03:09:44.319+04	2010-09-19 03:09:44.319+04
4d2eafbc-448e-4670-b253-740ba13dda15	9a96554f-2f94-4af5-9fd1-116736efc27a	40d73146-9c34-4922-bbe0-4b5db48abaac	В деталях	В деталях		2010-09-19 03:09:44.321+04	2010-09-19 03:09:44.321+04
28d1ca3a-596e-4630-a6ef-445d18e532da	9a96554f-2f94-4af5-9fd1-116736efc27a	40d73146-9c34-4922-bbe0-4b5db48abaac	Комплектация	Комплектация		2010-09-19 03:09:44.322+04	2010-09-19 03:09:44.322+04
0b9bd95f-9da5-422e-b2de-7e14439a7070	9a96554f-2f94-4af5-9fd1-116736efc27a	40d73146-9c34-4922-bbe0-4b5db48abaac	Парк ЗР	Парк ЗР		2010-09-19 03:09:44.323+04	2010-09-19 03:09:44.323+04
fb0b593a-4b9d-428a-906e-ad725a7ce8a3	9a96554f-2f94-4af5-9fd1-116736efc27a	40d73146-9c34-4922-bbe0-4b5db48abaac	Опции	Опции		2010-09-19 03:09:44.325+04	2010-09-19 03:09:44.325+04
2715e1e3-4ce8-4275-a1d6-b271d93ecc34	9a96554f-2f94-4af5-9fd1-116736efc27a	40d73146-9c34-4922-bbe0-4b5db48abaac	Автосалон	Автосалон		2010-09-19 03:09:44.326+04	2010-09-19 03:09:44.326+04
d57bb985-8dbe-4a83-a3b6-94c7f8f9b45a	9a96554f-2f94-4af5-9fd1-116736efc27a	863e779a-7509-40ea-a747-630de989704f	Вы нам писали	Вы нам писали		2010-09-19 03:09:44.327+04	2010-09-19 03:09:44.327+04
a10c3ee8-7af1-477a-a7ad-c31b0c378884	9a96554f-2f94-4af5-9fd1-116736efc27a	863e779a-7509-40ea-a747-630de989704f	Отвечает Главред	Отвечает Главред		2010-09-19 03:09:44.329+04	2010-09-19 03:09:44.329+04
c16dddb6-0570-4fa4-9417-01a134886f48	9a96554f-2f94-4af5-9fd1-116736efc27a	863e779a-7509-40ea-a747-630de989704f	Личное мнение	Личное мнение		2010-09-19 03:09:44.33+04	2010-09-19 03:09:44.33+04
8f61ccaf-9cfb-43f3-a226-393a40b49577	9a96554f-2f94-4af5-9fd1-116736efc27a	2c184627-cf2a-4a51-a316-862cd1e0c7f9	С миру по гонке	С миру по гонке		2010-09-19 03:09:44.331+04	2010-09-19 03:09:44.331+04
6412277f-6fd3-4339-a0e3-af59251f5ae4	9a96554f-2f94-4af5-9fd1-116736efc27a	2c184627-cf2a-4a51-a316-862cd1e0c7f9	Ралли	Ралли		2010-09-19 03:09:44.332+04	2010-09-19 03:09:44.332+04
1c3d069a-a3d6-41b4-ba88-2a0027b6e6d7	9a96554f-2f94-4af5-9fd1-116736efc27a	2c184627-cf2a-4a51-a316-862cd1e0c7f9	Формула-1	Формула-1		2010-09-19 03:09:44.334+04	2010-09-19 03:09:44.334+04
c40c8c42-b244-4c6a-9762-32ce46d6cd78	9a96554f-2f94-4af5-9fd1-116736efc27a	2c184627-cf2a-4a51-a316-862cd1e0c7f9	Спорт	Спорт		2010-09-19 03:09:44.335+04	2010-09-19 03:09:44.335+04
6032f9d9-1e6f-43c7-b214-208ef5c8fe73	9a96554f-2f94-4af5-9fd1-116736efc27a	2c184627-cf2a-4a51-a316-862cd1e0c7f9	Кольцевые гонки	Кольцевые гонки		2010-09-19 03:09:44.337+04	2010-09-19 03:09:44.337+04
68fe3fe1-1c77-4d3e-90ff-5712552126dd	9a96554f-2f94-4af5-9fd1-116736efc27a	f2abaa89-6f33-435b-925d-93af0728fb5d	Грузовики	Грузовики		2010-09-19 03:09:44.339+04	2010-09-19 03:09:44.339+04
25f7d4aa-5b0e-4a3c-8e34-6532d95018bb	9a96554f-2f94-4af5-9fd1-116736efc27a	e09438f1-3500-46ec-8926-32cc24cf31d5	Интервью	Интервью		2010-09-19 03:09:44.341+04	2010-09-19 03:09:44.341+04
b4addd55-b110-4d6e-b56f-a050b9c5d75f	9a96554f-2f94-4af5-9fd1-116736efc27a	e09438f1-3500-46ec-8926-32cc24cf31d5	Экономика-Обозрение	Экономика-Обозрение		2010-09-19 03:09:44.342+04	2010-09-19 03:09:44.342+04
75a3e320-8fbc-4d40-8234-c131fe713d43	9a96554f-2f94-4af5-9fd1-116736efc27a	e09438f1-3500-46ec-8926-32cc24cf31d5	Новости	Новости		2010-09-19 03:09:44.344+04	2010-09-19 03:09:44.344+04
08eb03a7-391e-472c-b68c-65fa80c2b406	9a96554f-2f94-4af5-9fd1-116736efc27a	b36704d7-c62e-4e23-8662-273ea35f4823	Спорный момент	Спорный момент		2010-09-19 03:09:44.345+04	2010-09-19 03:09:44.345+04
79b9d3d8-27b0-4d03-9480-19652a47f1cd	9a96554f-2f94-4af5-9fd1-116736efc27a	b36704d7-c62e-4e23-8662-273ea35f4823	Следствие ведет ЗР	Следствие ведет ЗР		2010-09-19 03:09:44.346+04	2010-09-19 03:09:44.346+04
4b47befd-2d68-449d-8dd9-cfcc334f9eef	9a96554f-2f94-4af5-9fd1-116736efc27a	b36704d7-c62e-4e23-8662-273ea35f4823	Самозащита	Самозащита		2010-09-19 03:09:44.347+04	2010-09-19 03:09:44.347+04
902fc313-59ea-4eed-8879-7a366b27c9f4	9a96554f-2f94-4af5-9fd1-116736efc27a	b36704d7-c62e-4e23-8662-273ea35f4823	Прямая линия	Прямая линия		2010-09-19 03:09:44.349+04	2010-09-19 03:09:44.349+04
83fca84f-2d63-45c5-980a-3891b9632f95	9a96554f-2f94-4af5-9fd1-116736efc27a	b36704d7-c62e-4e23-8662-273ea35f4823	Ответы юриста	Ответы юриста		2010-09-19 03:09:44.35+04	2010-09-19 03:09:44.35+04
41fdab8d-d88f-465a-aa98-f1de8844f354	9a96554f-2f94-4af5-9fd1-116736efc27a	b36704d7-c62e-4e23-8662-273ea35f4823	Безопасность	Безопасность		2010-09-19 03:09:44.351+04	2010-09-19 03:09:44.351+04
512a3ab8-dd01-4c60-a99e-e274e1264522	9a96554f-2f94-4af5-9fd1-116736efc27a	b36704d7-c62e-4e23-8662-273ea35f4823	Новости	Новости		2010-09-19 03:09:44.353+04	2010-09-19 03:09:44.353+04
3af4922d-a24b-455a-a710-8339df937606	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Тест-ремонт	Тест-ремонт		2010-09-19 03:09:44.354+04	2010-09-19 03:09:44.354+04
cbe5d35f-f9c6-479f-a77f-ad3a9d224fb1	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Хочу разобраться	Хочу разобраться		2010-09-19 03:09:44.355+04	2010-09-19 03:09:44.355+04
2df7a19e-c4f4-4dd0-8aca-80f70c4bf68e	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Мастерская	Мастерская		2010-09-19 03:09:44.357+04	2010-09-19 03:09:44.357+04
6f7868ac-dea8-440b-bc8f-5d794ee7f3b3	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Взаимозаменяемость	Взаимозаменяемость		2010-09-19 03:09:44.358+04	2010-09-19 03:09:44.358+04
03a7bf5c-d8c5-4fdc-a6c7-74b027b18a5b	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Отвечают специалисты	Отвечают специалисты		2010-09-19 03:09:44.359+04	2010-09-19 03:09:44.359+04
04dd8626-ea18-4780-a5c9-5ba212e256de	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Советы бывалых	Советы бывалых		2010-09-19 03:09:44.36+04	2010-09-19 03:09:44.36+04
87ec26a4-9cbd-40b8-afb7-628705e1edf3	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Доводим	Доводим		2010-09-19 03:09:44.361+04	2010-09-19 03:09:44.361+04
5f21d9fe-b556-4a05-b3be-4dc7508b7b25	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Конкурс	Конкурс		2010-09-19 03:09:44.363+04	2010-09-19 03:09:44.363+04
758b2417-441c-4fae-ba29-d84d1f3be4b8	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Форум	Форум		2010-09-19 03:09:44.364+04	2010-09-19 03:09:44.364+04
7bf6b675-9601-4b01-94be-9252c1569369	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	В деталях	В деталях		2010-09-19 03:09:44.365+04	2010-09-19 03:09:44.365+04
0354007b-5807-4cb5-b018-00f40d27b699	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Диагностика	Диагностика		2010-09-19 03:09:44.367+04	2010-09-19 03:09:44.367+04
a0354217-c422-49ba-8fb7-3813420d5352	9a96554f-2f94-4af5-9fd1-116736efc27a	0b9650bc-9d77-46ae-b128-9d9d77c65f2a	Крайний случай	Крайний случай		2010-09-19 03:09:44.368+04	2010-09-19 03:09:44.368+04
9c4d3d3a-28b5-4c9b-8607-5ea33d1d0d12	9a96554f-2f94-4af5-9fd1-116736efc27a	6d3c3995-8e36-4873-9fb3-5a331b6a8357	Обозрение	Обозрение		2010-09-19 03:09:44.369+04	2010-09-19 03:09:44.369+04
01674b75-4f81-4f5c-acd1-35e16e370296	9a96554f-2f94-4af5-9fd1-116736efc27a	6d3c3995-8e36-4873-9fb3-5a331b6a8357	Концепт-кар	Концепт-кар		2010-09-19 03:09:44.37+04	2010-09-19 03:09:44.37+04
607f4158-0daf-4253-977c-1a4652100462	9a96554f-2f94-4af5-9fd1-116736efc27a	6d3c3995-8e36-4873-9fb3-5a331b6a8357	Технологии	Технологии		2010-09-19 03:09:44.372+04	2010-09-19 03:09:44.372+04
90be05af-8667-43c4-93be-c2f0d5348a61	9a96554f-2f94-4af5-9fd1-116736efc27a	6d3c3995-8e36-4873-9fb3-5a331b6a8357	Новинки	Новинки	Новинки, исследования, изобретения	2010-09-19 03:09:44.373+04	2010-09-19 03:09:44.373+04
7e4b7c35-afd5-49f9-8ed8-b226473cc595	9a96554f-2f94-4af5-9fd1-116736efc27a	92c67604-3f1b-4316-8a8a-5f90e0291e0e	Без границ	Без границ		2010-09-19 03:09:44.374+04	2010-09-19 03:09:44.374+04
5d12f385-ebaf-49be-aec3-8a36fc41f734	9a96554f-2f94-4af5-9fd1-116736efc27a	92c67604-3f1b-4316-8a8a-5f90e0291e0e	Живые классики	Живые классики		2010-09-19 03:09:44.376+04	2010-09-19 03:09:44.376+04
6194661b-523f-4eda-83ee-aed6fc2210da	9a96554f-2f94-4af5-9fd1-116736efc27a	92c67604-3f1b-4316-8a8a-5f90e0291e0e	Эксперимент	Эксперимент		2010-09-19 03:09:44.377+04	2010-09-19 03:09:44.377+04
6ef6e55f-6168-4222-9368-941f57f56dff	9a96554f-2f94-4af5-9fd1-116736efc27a	92c67604-3f1b-4316-8a8a-5f90e0291e0e	Путешествие	Путешествие		2010-09-19 03:09:44.379+04	2010-09-19 03:09:44.379+04
84f2bbf2-f696-4aa3-b921-03d76bf996f7	9a96554f-2f94-4af5-9fd1-116736efc27a	d8de4cce-b4a1-435a-bf70-c5c2f22a767f	Цены ЗР	Цены ЗР		2010-09-19 03:09:44.38+04	2010-09-19 03:09:44.38+04
a27bb31a-52ba-48b3-8adc-6aa250b1339e	9a96554f-2f94-4af5-9fd1-116736efc27a	164a233a-4882-43e4-9636-d1089985909b	На гребне моды	На гребне моды		2010-09-19 03:09:44.381+04	2010-09-19 03:09:44.381+04
f099cd77-fe48-448d-b4ad-645b487821cd	9a96554f-2f94-4af5-9fd1-116736efc27a	164a233a-4882-43e4-9636-d1089985909b	Тюнинг	Тюнинг		2010-09-19 03:09:44.382+04	2010-09-19 03:09:44.382+04
00000000-0000-0000-0000-000000000000	953eea94-1899-4aa1-bacb-7cb19bf373cb	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:44.388+04	2010-09-19 03:09:44.388+04
00000000-0000-0000-0000-000000000000	848f7187-6099-459d-83b6-46213bc811db	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:44.415+04	2010-09-19 03:09:44.415+04
00000000-0000-0000-0000-000000000000	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:44.455+04	2010-09-19 03:09:44.455+04
d66a7111-5e4f-44ac-8ea1-0edefd06650d	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	В курсе событий	В курсе событий		2010-09-19 03:09:44.477+04	2010-09-19 03:09:44.477+04
7f51dde3-e1f7-4d60-b6b1-dbe2f3dd2110	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Новости	Новости		2010-09-19 03:09:44.48+04	2010-09-19 03:09:44.48+04
ee75f831-034c-44d1-9130-11fec60af53a	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Конференция	Конференция		2010-09-19 03:09:44.481+04	2010-09-19 03:09:44.481+04
d1820083-8de2-4d66-b4cd-f19700af584b	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Особое внимание	Особое внимание		2010-09-19 03:09:44.482+04	2010-09-19 03:09:44.482+04
223ebcb2-cec9-43e5-b531-fb06eadb9639	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Кадры	Кадры		2010-09-19 03:09:44.483+04	2010-09-19 03:09:44.483+04
cf71e1f4-ef45-44cf-9f34-ea3b714c66e8	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Безопасность	Безопасность		2010-09-19 03:09:44.485+04	2010-09-19 03:09:44.485+04
240275e7-c641-4866-a130-037e5d69a0e1	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Лизинг	Лизинг		2010-09-19 03:09:44.486+04	2010-09-19 03:09:44.486+04
86c49747-6320-4da8-abf4-d302bf092883	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Страхование	Страхование		2010-09-19 03:09:44.487+04	2010-09-19 03:09:44.487+04
780d4035-0e1a-415b-bb9e-b3e654f4952f	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Налоги	Налоги		2010-09-19 03:09:44.489+04	2010-09-19 03:09:44.489+04
46050fe5-8b42-463e-9241-3a8aad36aa88	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Логистика	Логистика		2010-09-19 03:09:44.49+04	2010-09-19 03:09:44.49+04
c49faa5b-5282-44f3-af4f-4342cf77599e	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Гарантия	Гарантия		2010-09-19 03:09:44.492+04	2010-09-19 03:09:44.492+04
44720d20-7c88-4d4d-b86a-b126fe0bf8ae	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Перевозки	Перевозки		2010-09-19 03:09:44.493+04	2010-09-19 03:09:44.493+04
5ce46a69-42ef-4f80-95f9-8adf0bb7a6bd	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	2c4a80fb-f062-4eba-87e8-d8f65a2a74c2	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:44.494+04	2010-09-19 03:09:44.494+04
0d7abea6-9799-4a0d-b85e-2acaafd2996c	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	8498c445-7385-419d-a3b0-7abb98985570	Tyrex Trophy	Tyrex Trophy		2010-09-19 03:09:44.495+04	2010-09-19 03:09:44.495+04
4bb4d494-f201-449b-b536-81fe166e1a0c	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	8498c445-7385-419d-a3b0-7abb98985570	УМЗ-4216	УМЗ-4216		2010-09-19 03:09:44.497+04	2010-09-19 03:09:44.497+04
3658da7c-6270-4ba5-bc20-9bfeb30fce6d	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	8498c445-7385-419d-a3b0-7abb98985570	GoodYear	GoodYear		2010-09-19 03:09:44.498+04	2010-09-19 03:09:44.498+04
3e07ddbe-ad09-4b09-b6e0-d42389c0246c	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	b6dbf50d-f7f4-4db9-aa1a-f3904cf5a8bd	Премьера	Премьера		2010-09-19 03:09:44.499+04	2010-09-19 03:09:44.499+04
36c88080-e0ef-401c-8e10-bdbb5589cfac	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	b6dbf50d-f7f4-4db9-aa1a-f3904cf5a8bd	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:44.501+04	2010-09-19 03:09:44.501+04
2d8ca742-a4c4-4360-b909-dbf2c938945d	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	b6dbf50d-f7f4-4db9-aa1a-f3904cf5a8bd	Новости	Новости		2010-09-19 03:09:44.502+04	2010-09-19 03:09:44.502+04
783b9baa-4e59-4a73-b001-e051913cd28c	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	b6dbf50d-f7f4-4db9-aa1a-f3904cf5a8bd	Опыт эксплуатации	Опыт эксплуатации		2010-09-19 03:09:44.503+04	2010-09-19 03:09:44.503+04
8d33863b-79e4-49e0-a7bb-1ca712398227	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	b6dbf50d-f7f4-4db9-aa1a-f3904cf5a8bd	Конкуренты с востока	Конкуренты с востока		2010-09-19 03:09:44.504+04	2010-09-19 03:09:44.504+04
ca69ec0b-b625-41e3-a705-9a4f14ca0871	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	b6dbf50d-f7f4-4db9-aa1a-f3904cf5a8bd	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:44.506+04	2010-09-19 03:09:44.506+04
4aa46266-4bed-499d-89e0-0dbcddfad6a6	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	b6dbf50d-f7f4-4db9-aa1a-f3904cf5a8bd	Прицепы	Прицепы		2010-09-19 03:09:44.507+04	2010-09-19 03:09:44.507+04
fdaf2f27-ebb7-494e-be3d-0e54dceed035	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	97591d66-3306-4a4f-bc4c-f8239c13bef4	Прицепы	Прицепы		2010-09-19 03:09:44.509+04	2010-09-19 03:09:44.509+04
9648bcf9-efad-437d-bceb-98537aaa26c7	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	97591d66-3306-4a4f-bc4c-f8239c13bef4	Новости	Новости		2010-09-19 03:09:44.51+04	2010-09-19 03:09:44.51+04
6e4c2490-294e-4f42-8ccc-fe14d825eff8	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	97591d66-3306-4a4f-bc4c-f8239c13bef4	Без комментариев	Без комментариев		2010-09-19 03:09:44.512+04	2010-09-19 03:09:44.512+04
c5d9be14-d69a-44dc-b0fa-83d537dbe800	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	97591d66-3306-4a4f-bc4c-f8239c13bef4	Компоненты	Компоненты		2010-09-19 03:09:44.513+04	2010-09-19 03:09:44.513+04
80a745ce-a777-433b-9724-bd691187f860	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	97591d66-3306-4a4f-bc4c-f8239c13bef4	Бизнес в России	Бизнес в России		2010-09-19 03:09:44.514+04	2010-09-19 03:09:44.514+04
cb2a0890-993b-41ab-8e59-cf3ca0d0dfdf	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	97591d66-3306-4a4f-bc4c-f8239c13bef4	Масла	Масла		2010-09-19 03:09:44.516+04	2010-09-19 03:09:44.516+04
5bbe0581-4289-4cb3-b9d1-f490518df977	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	97591d66-3306-4a4f-bc4c-f8239c13bef4	Шины	Шины		2010-09-19 03:09:44.517+04	2010-09-19 03:09:44.517+04
8deb3385-8a5b-416c-8532-1504fe36181f	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	97591d66-3306-4a4f-bc4c-f8239c13bef4	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:44.518+04	2010-09-19 03:09:44.518+04
ee69436b-cae9-43b1-b5bb-e4cdf0a1fdf9	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	4900f4c3-8320-4768-8eea-cd638024e55f	Новости	Новости		2010-09-19 03:09:44.52+04	2010-09-19 03:09:44.52+04
084c13d3-6e0f-4680-888c-87012a63f226	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	4900f4c3-8320-4768-8eea-cd638024e55f	Масла	Масла		2010-09-19 03:09:44.521+04	2010-09-19 03:09:44.521+04
2291aa0a-5287-4a7c-b9d6-864eedb8558f	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	4900f4c3-8320-4768-8eea-cd638024e55f	Шины	Шины		2010-09-19 03:09:44.522+04	2010-09-19 03:09:44.522+04
3ee84301-85ea-4358-a938-9e26513ac8d1	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	4900f4c3-8320-4768-8eea-cd638024e55f	АКБ	АКБ		2010-09-19 03:09:44.523+04	2010-09-19 03:09:44.523+04
ff96b558-a0b1-4ef0-92ad-aa3248be36f4	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	4900f4c3-8320-4768-8eea-cd638024e55f	Ремзона	Ремзона		2010-09-19 03:09:44.525+04	2010-09-19 03:09:44.525+04
f982ad69-a1c8-48b5-9125-cf53e8a9b237	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	4900f4c3-8320-4768-8eea-cd638024e55f	Оборудование	Оборудование		2010-09-19 03:09:44.526+04	2010-09-19 03:09:44.526+04
f6d47aae-710b-456e-9ca2-fe2f79f1de98	5b1b9fb7-c31e-44e6-8ddc-c0d63e4dbced	4900f4c3-8320-4768-8eea-cd638024e55f	Агрегаты	Агрегаты		2010-09-19 03:09:44.527+04	2010-09-19 03:09:44.527+04
00000000-0000-0000-0000-000000000000	4fd73209-568f-4349-9156-65714d0bdebe	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:44.533+04	2010-09-19 03:09:44.533+04
a8e50abe-c6c2-45fd-867c-1067e04220a5	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	В курсе событий	В курсе событий		2010-09-19 03:09:44.897+04	2010-09-19 03:09:44.897+04
919b61cc-be19-4508-a076-8a17e245f5a3	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Новости	Новости		2010-09-19 03:09:44.901+04	2010-09-19 03:09:44.901+04
96cde06e-5a5f-41e8-a7c0-8097b1b9543d	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Конференция	Конференция		2010-09-19 03:09:44.903+04	2010-09-19 03:09:44.903+04
adab6543-6919-488b-809f-3ab3b0821c48	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Особое внимание	Особое внимание		2010-09-19 03:09:44.906+04	2010-09-19 03:09:44.906+04
e4373ea3-4ed5-45ba-bb9c-279738356130	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Кадры	Кадры		2010-09-19 03:09:44.909+04	2010-09-19 03:09:44.909+04
7d42fc13-0317-44fd-936d-c30fa0629bd5	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Безопасность	Безопасность		2010-09-19 03:09:44.913+04	2010-09-19 03:09:44.913+04
f455827e-df56-4b54-af9a-52c5b91e1414	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Лизинг	Лизинг		2010-09-19 03:09:44.916+04	2010-09-19 03:09:44.916+04
7086e128-a6e7-41ef-96c0-ae19e169f315	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Страхование	Страхование		2010-09-19 03:09:44.918+04	2010-09-19 03:09:44.918+04
c7e132cd-a7fc-4ea7-b348-df37f7020023	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Налоги	Налоги		2010-09-19 03:09:44.921+04	2010-09-19 03:09:44.921+04
ae212fc4-7dbe-4bb9-836a-9c739b81cef9	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Логистика	Логистика		2010-09-19 03:09:44.924+04	2010-09-19 03:09:44.924+04
13264f68-06aa-4bf1-8a62-d89b35556e7b	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Гарантия	Гарантия		2010-09-19 03:09:44.928+04	2010-09-19 03:09:44.928+04
6be7ebf1-6727-4396-8b12-081e851566af	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Перевозки	Перевозки		2010-09-19 03:09:44.931+04	2010-09-19 03:09:44.931+04
8c60835f-90ad-41a5-a514-b3d93fa30bf4	4fd73209-568f-4349-9156-65714d0bdebe	8b3afe82-7559-4a77-89a3-6e2537bfac24	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:44.934+04	2010-09-19 03:09:44.934+04
0b04bb36-d4a5-45c2-aab5-8fd42e6fea26	4fd73209-568f-4349-9156-65714d0bdebe	121906d7-2654-4696-8c7a-edc71f8ea6be	Tyrex Trophy	Tyrex Trophy		2010-09-19 03:09:44.937+04	2010-09-19 03:09:44.937+04
4ce6717c-89f0-4800-800e-faf3eb7c7007	4fd73209-568f-4349-9156-65714d0bdebe	121906d7-2654-4696-8c7a-edc71f8ea6be	УМЗ-4216	УМЗ-4216		2010-09-19 03:09:44.941+04	2010-09-19 03:09:44.941+04
f06f7877-9e86-46a3-9279-8b578c9bb404	4fd73209-568f-4349-9156-65714d0bdebe	121906d7-2654-4696-8c7a-edc71f8ea6be	GoodYear	GoodYear		2010-09-19 03:09:44.944+04	2010-09-19 03:09:44.944+04
eab853f0-723c-41c1-b0a3-e01fc03396ac	4fd73209-568f-4349-9156-65714d0bdebe	9090d8ed-c1a5-4485-aa81-9daa9f64dfa4	Премьера	Премьера		2010-09-19 03:09:44.947+04	2010-09-19 03:09:44.947+04
d4334933-4e64-4cea-906f-e6b689d94d08	4fd73209-568f-4349-9156-65714d0bdebe	9090d8ed-c1a5-4485-aa81-9daa9f64dfa4	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:44.949+04	2010-09-19 03:09:44.949+04
7b54ff25-b887-408a-a721-66940009577c	4fd73209-568f-4349-9156-65714d0bdebe	9090d8ed-c1a5-4485-aa81-9daa9f64dfa4	Новости	Новости		2010-09-19 03:09:44.951+04	2010-09-19 03:09:44.951+04
19f53c2f-ecd0-4e30-b924-e10fe9e90e3c	4fd73209-568f-4349-9156-65714d0bdebe	9090d8ed-c1a5-4485-aa81-9daa9f64dfa4	Опыт эксплуатации	Опыт эксплуатации		2010-09-19 03:09:44.955+04	2010-09-19 03:09:44.955+04
98f8663f-d823-4221-8b5c-858f642a7fb0	4fd73209-568f-4349-9156-65714d0bdebe	9090d8ed-c1a5-4485-aa81-9daa9f64dfa4	Конкуренты с востока	Конкуренты с востока		2010-09-19 03:09:44.958+04	2010-09-19 03:09:44.958+04
27066f17-b45d-4d98-8620-d3ceb0a86e2b	4fd73209-568f-4349-9156-65714d0bdebe	9090d8ed-c1a5-4485-aa81-9daa9f64dfa4	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:44.961+04	2010-09-19 03:09:44.961+04
5093c1d2-1b6c-4889-9279-762a5876f332	4fd73209-568f-4349-9156-65714d0bdebe	9090d8ed-c1a5-4485-aa81-9daa9f64dfa4	Прицепы	Прицепы		2010-09-19 03:09:44.963+04	2010-09-19 03:09:44.963+04
0e2c2a13-3b91-4c04-8751-5ec3ebfe0c08	4fd73209-568f-4349-9156-65714d0bdebe	e9430941-6430-47bc-a7fa-663e5c8995d2	Прицепы	Прицепы		2010-09-19 03:09:44.965+04	2010-09-19 03:09:44.965+04
ca6eaddc-7331-4e5a-856b-dafa18bea8bb	4fd73209-568f-4349-9156-65714d0bdebe	e9430941-6430-47bc-a7fa-663e5c8995d2	Новости	Новости		2010-09-19 03:09:44.968+04	2010-09-19 03:09:44.968+04
59d568c9-7e5d-46e9-bff5-ffb6934730d4	4fd73209-568f-4349-9156-65714d0bdebe	e9430941-6430-47bc-a7fa-663e5c8995d2	Без комментариев	Без комментариев		2010-09-19 03:09:44.971+04	2010-09-19 03:09:44.971+04
1a3118fc-eea0-4805-937d-0117e4d73d8b	4fd73209-568f-4349-9156-65714d0bdebe	e9430941-6430-47bc-a7fa-663e5c8995d2	Компоненты	Компоненты		2010-09-19 03:09:44.974+04	2010-09-19 03:09:44.974+04
0fd96f32-bbc1-40ac-83d0-8d5427f5b0c0	4fd73209-568f-4349-9156-65714d0bdebe	e9430941-6430-47bc-a7fa-663e5c8995d2	Бизнес в России	Бизнес в России		2010-09-19 03:09:44.976+04	2010-09-19 03:09:44.976+04
b8a9f062-026d-42e2-b758-e3b1d8d63625	4fd73209-568f-4349-9156-65714d0bdebe	e9430941-6430-47bc-a7fa-663e5c8995d2	Масла	Масла		2010-09-19 03:09:44.978+04	2010-09-19 03:09:44.978+04
91d7a00d-030e-4d0b-ba58-837ba779d49c	4fd73209-568f-4349-9156-65714d0bdebe	e9430941-6430-47bc-a7fa-663e5c8995d2	Шины	Шины		2010-09-19 03:09:44.981+04	2010-09-19 03:09:44.981+04
77c179af-75e4-496c-bef8-3a443932ae15	4fd73209-568f-4349-9156-65714d0bdebe	e9430941-6430-47bc-a7fa-663e5c8995d2	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:44.984+04	2010-09-19 03:09:44.984+04
e7112648-ae30-4b57-a864-58ad5c619144	4fd73209-568f-4349-9156-65714d0bdebe	dee64700-8926-4862-b3f3-2eeb0977884a	Новости	Новости		2010-09-19 03:09:44.987+04	2010-09-19 03:09:44.987+04
cefe23c1-e661-47e9-a88e-e3c03f907899	4fd73209-568f-4349-9156-65714d0bdebe	dee64700-8926-4862-b3f3-2eeb0977884a	Масла	Масла		2010-09-19 03:09:44.989+04	2010-09-19 03:09:44.989+04
90bdd148-1a72-478e-a0df-dfc01b1ccfd2	4fd73209-568f-4349-9156-65714d0bdebe	dee64700-8926-4862-b3f3-2eeb0977884a	Шины	Шины		2010-09-19 03:09:44.992+04	2010-09-19 03:09:44.992+04
742dba93-2fb5-4a4a-8377-61d2b699b768	4fd73209-568f-4349-9156-65714d0bdebe	dee64700-8926-4862-b3f3-2eeb0977884a	АКБ	АКБ		2010-09-19 03:09:44.995+04	2010-09-19 03:09:44.995+04
c0bc2968-64e0-4281-9f79-36a563d6e8db	4fd73209-568f-4349-9156-65714d0bdebe	dee64700-8926-4862-b3f3-2eeb0977884a	Ремзона	Ремзона		2010-09-19 03:09:44.998+04	2010-09-19 03:09:44.998+04
0e328744-ac06-4206-94a7-d857fdc77b8c	4fd73209-568f-4349-9156-65714d0bdebe	dee64700-8926-4862-b3f3-2eeb0977884a	Оборудование	Оборудование		2010-09-19 03:09:45+04	2010-09-19 03:09:45+04
83132160-46fa-48ef-8ba4-233b75415b77	4fd73209-568f-4349-9156-65714d0bdebe	dee64700-8926-4862-b3f3-2eeb0977884a	Агрегаты	Агрегаты		2010-09-19 03:09:45.002+04	2010-09-19 03:09:45.002+04
00000000-0000-0000-0000-000000000000	deb6f461-5d5e-4302-87ea-7d446502b34e	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:45.013+04	2010-09-19 03:09:45.013+04
dacfd5d9-5323-4335-afb6-d16c7ba5efe9	deb6f461-5d5e-4302-87ea-7d446502b34e	f4bf3c8f-c871-47a6-87ec-3b1ac02efaf7	Тест	Тест		2010-09-19 03:09:45.077+04	2010-09-19 03:09:45.077+04
c0c2230f-c46a-46bf-8a99-8c33cbc53e41	deb6f461-5d5e-4302-87ea-7d446502b34e	f4bf3c8f-c871-47a6-87ec-3b1ac02efaf7	Спецтест	Спецтест		2010-09-19 03:09:45.079+04	2010-09-19 03:09:45.079+04
c06a0e9c-819e-464c-b310-00931dc18eef	deb6f461-5d5e-4302-87ea-7d446502b34e	f4bf3c8f-c871-47a6-87ec-3b1ac02efaf7	Премьера	Премьера		2010-09-19 03:09:45.081+04	2010-09-19 03:09:45.081+04
09ab3639-1dae-46ab-b07b-8a59de6aa480	deb6f461-5d5e-4302-87ea-7d446502b34e	f4bf3c8f-c871-47a6-87ec-3b1ac02efaf7	Презентация	Презентация		2010-09-19 03:09:45.084+04	2010-09-19 03:09:45.084+04
11601bd6-4014-45d1-a3e6-510fa4294577	deb6f461-5d5e-4302-87ea-7d446502b34e	f4bf3c8f-c871-47a6-87ec-3b1ac02efaf7	Наше знакомство	Наше знакомство		2010-09-19 03:09:45.087+04	2010-09-19 03:09:45.087+04
82c1b3eb-aaba-4c1d-a0be-90f96b7977d8	deb6f461-5d5e-4302-87ea-7d446502b34e	f4bf3c8f-c871-47a6-87ec-3b1ac02efaf7	Высший класс	Высший класс		2010-09-19 03:09:45.09+04	2010-09-19 03:09:45.09+04
3be220c5-193f-4779-a481-4f30d7f73bd4	deb6f461-5d5e-4302-87ea-7d446502b34e	f4bf3c8f-c871-47a6-87ec-3b1ac02efaf7	Авто на час	Авто на час		2010-09-19 03:09:45.092+04	2010-09-19 03:09:45.092+04
b500b944-13e9-48e9-b423-6817bc9dbdc1	deb6f461-5d5e-4302-87ea-7d446502b34e	f4bf3c8f-c871-47a6-87ec-3b1ac02efaf7	Испытано в деле	Испытано в деле		2010-09-19 03:09:45.094+04	2010-09-19 03:09:45.094+04
2d84a09b-b81b-4e9c-81e0-1438c9c45cf8	deb6f461-5d5e-4302-87ea-7d446502b34e	323a61c7-7f4f-4420-98cb-f81f738429cb	Компоненты	Компоненты		2010-09-19 03:09:45.096+04	2010-09-19 03:09:45.096+04
0918a9f1-f48f-451c-bcbd-28e176f499ed	deb6f461-5d5e-4302-87ea-7d446502b34e	323a61c7-7f4f-4420-98cb-f81f738429cb	Экспертиза	Экспертиза		2010-09-19 03:09:45.099+04	2010-09-19 03:09:45.099+04
0099a7cb-4694-4300-b178-3a13e9b62195	deb6f461-5d5e-4302-87ea-7d446502b34e	323a61c7-7f4f-4420-98cb-f81f738429cb	Новые товары	Новые товары		2010-09-19 03:09:45.102+04	2010-09-19 03:09:45.102+04
c651c41e-ec77-4778-824e-c410bffffa04	deb6f461-5d5e-4302-87ea-7d446502b34e	323a61c7-7f4f-4420-98cb-f81f738429cb	Электроника	Электроника		2010-09-19 03:09:45.105+04	2010-09-19 03:09:45.105+04
7de0d6bb-de23-4cf3-841f-62fdfd4a4986	deb6f461-5d5e-4302-87ea-7d446502b34e	323a61c7-7f4f-4420-98cb-f81f738429cb	На прилавке	На прилавке		2010-09-19 03:09:45.107+04	2010-09-19 03:09:45.107+04
694d3820-faf4-476f-b35d-2a40a63d2d71	deb6f461-5d5e-4302-87ea-7d446502b34e	323a61c7-7f4f-4420-98cb-f81f738429cb	Товаровед	Товаровед		2010-09-19 03:09:45.11+04	2010-09-19 03:09:45.11+04
f2681183-3008-46ab-a987-6bbca38f6581	deb6f461-5d5e-4302-87ea-7d446502b34e	323a61c7-7f4f-4420-98cb-f81f738429cb	Проверено ЗР	Проверено ЗР		2010-09-19 03:09:45.113+04	2010-09-19 03:09:45.113+04
64f02c1b-06ae-48ea-9b84-00a63942846d	deb6f461-5d5e-4302-87ea-7d446502b34e	43af09f0-7048-408c-a14e-6d8d59d1047f	Дегустация	Дегустация		2010-09-19 03:09:45.116+04	2010-09-19 03:09:45.116+04
305db49f-85a4-498b-a466-bb1156b0d0c5	deb6f461-5d5e-4302-87ea-7d446502b34e	43af09f0-7048-408c-a14e-6d8d59d1047f	Семейство	Семейство		2010-09-19 03:09:45.118+04	2010-09-19 03:09:45.118+04
e1556ccb-3fbe-4ca1-92bf-492365248a3c	deb6f461-5d5e-4302-87ea-7d446502b34e	43af09f0-7048-408c-a14e-6d8d59d1047f	Новости дилеров	Новости дилеров		2010-09-19 03:09:45.12+04	2010-09-19 03:09:45.12+04
565c494d-09c8-4492-b593-f3c51ad03de4	deb6f461-5d5e-4302-87ea-7d446502b34e	43af09f0-7048-408c-a14e-6d8d59d1047f	В деталях	В деталях		2010-09-19 03:09:45.123+04	2010-09-19 03:09:45.123+04
98eb2754-60e9-463b-9fad-7d7443a37b46	deb6f461-5d5e-4302-87ea-7d446502b34e	43af09f0-7048-408c-a14e-6d8d59d1047f	Комплектация	Комплектация		2010-09-19 03:09:45.125+04	2010-09-19 03:09:45.125+04
ec8d618a-854e-4b04-9391-97b0bbebdf56	deb6f461-5d5e-4302-87ea-7d446502b34e	43af09f0-7048-408c-a14e-6d8d59d1047f	Парк ЗР	Парк ЗР		2010-09-19 03:09:45.128+04	2010-09-19 03:09:45.128+04
465840d4-5a65-4d8d-8b2a-54b30980f0f7	deb6f461-5d5e-4302-87ea-7d446502b34e	43af09f0-7048-408c-a14e-6d8d59d1047f	Опции	Опции		2010-09-19 03:09:45.131+04	2010-09-19 03:09:45.131+04
25b17da1-f04b-4e33-840d-cd04cb267348	deb6f461-5d5e-4302-87ea-7d446502b34e	43af09f0-7048-408c-a14e-6d8d59d1047f	Автосалон	Автосалон		2010-09-19 03:09:45.133+04	2010-09-19 03:09:45.133+04
1e1a5c89-b89b-4db7-b25f-9884c0827c89	deb6f461-5d5e-4302-87ea-7d446502b34e	c83a2c61-e04b-4b03-a3ab-28d015e03191	Вы нам писали	Вы нам писали		2010-09-19 03:09:45.136+04	2010-09-19 03:09:45.136+04
249cc089-685a-4573-a84f-a4f3f38fd169	deb6f461-5d5e-4302-87ea-7d446502b34e	c83a2c61-e04b-4b03-a3ab-28d015e03191	Отвечает Главред	Отвечает Главред		2010-09-19 03:09:45.139+04	2010-09-19 03:09:45.139+04
827f71ea-cbdb-45d1-b747-27620aff9968	deb6f461-5d5e-4302-87ea-7d446502b34e	c83a2c61-e04b-4b03-a3ab-28d015e03191	Личное мнение	Личное мнение		2010-09-19 03:09:45.142+04	2010-09-19 03:09:45.142+04
c4713222-f176-4af5-ae17-28a9a982f2ab	deb6f461-5d5e-4302-87ea-7d446502b34e	4680df93-0152-4eb3-94c9-cade3c40ca62	С миру по гонке	С миру по гонке		2010-09-19 03:09:45.144+04	2010-09-19 03:09:45.144+04
b44acb24-3655-4502-83f3-dd1a7fb35e75	deb6f461-5d5e-4302-87ea-7d446502b34e	4680df93-0152-4eb3-94c9-cade3c40ca62	Ралли	Ралли		2010-09-19 03:09:45.147+04	2010-09-19 03:09:45.147+04
5967146c-d475-420e-be07-6fd313c6986a	deb6f461-5d5e-4302-87ea-7d446502b34e	4680df93-0152-4eb3-94c9-cade3c40ca62	Формула-1	Формула-1		2010-09-19 03:09:45.15+04	2010-09-19 03:09:45.15+04
a2b86e5d-d91b-4238-897e-b52bd961b264	deb6f461-5d5e-4302-87ea-7d446502b34e	4680df93-0152-4eb3-94c9-cade3c40ca62	Спорт	Спорт		2010-09-19 03:09:45.153+04	2010-09-19 03:09:45.153+04
49da8d09-ac39-4165-b374-e4462e78c036	deb6f461-5d5e-4302-87ea-7d446502b34e	4680df93-0152-4eb3-94c9-cade3c40ca62	Кольцевые гонки	Кольцевые гонки		2010-09-19 03:09:45.155+04	2010-09-19 03:09:45.155+04
406190f8-e82d-4a16-82b7-4367d9951a83	deb6f461-5d5e-4302-87ea-7d446502b34e	bedca5b1-626d-41ba-8bcb-96348e378fc9	Грузовики	Грузовики		2010-09-19 03:09:45.158+04	2010-09-19 03:09:45.158+04
4ebffed1-afa8-42af-819d-c02102f85f71	deb6f461-5d5e-4302-87ea-7d446502b34e	0a68a814-8601-49ed-abf1-e5a70edb4d37	Интервью	Интервью		2010-09-19 03:09:45.16+04	2010-09-19 03:09:45.16+04
83191c3a-f344-476d-bd4e-e54f8a6349a7	deb6f461-5d5e-4302-87ea-7d446502b34e	0a68a814-8601-49ed-abf1-e5a70edb4d37	Экономика-Обозрение	Экономика-Обозрение		2010-09-19 03:09:45.162+04	2010-09-19 03:09:45.162+04
ff27583d-da11-433e-aa9e-fe23a0572b48	deb6f461-5d5e-4302-87ea-7d446502b34e	0a68a814-8601-49ed-abf1-e5a70edb4d37	Новости	Новости		2010-09-19 03:09:45.166+04	2010-09-19 03:09:45.166+04
e8c0deec-71b8-41cd-9b16-f9d1eb3392ce	deb6f461-5d5e-4302-87ea-7d446502b34e	efc0e899-d41a-4d2d-9842-db9d55ff4c73	Спорный момент	Спорный момент		2010-09-19 03:09:45.169+04	2010-09-19 03:09:45.169+04
7ae0f92f-f54b-47fb-a8c4-971082c28d6a	deb6f461-5d5e-4302-87ea-7d446502b34e	efc0e899-d41a-4d2d-9842-db9d55ff4c73	Следствие ведет ЗР	Следствие ведет ЗР		2010-09-19 03:09:45.171+04	2010-09-19 03:09:45.171+04
80079317-268e-49eb-b139-a320f1096421	deb6f461-5d5e-4302-87ea-7d446502b34e	efc0e899-d41a-4d2d-9842-db9d55ff4c73	Самозащита	Самозащита		2010-09-19 03:09:45.173+04	2010-09-19 03:09:45.173+04
9a1ea69e-d73d-4921-8adf-eb77a49d3b39	deb6f461-5d5e-4302-87ea-7d446502b34e	efc0e899-d41a-4d2d-9842-db9d55ff4c73	Прямая линия	Прямая линия		2010-09-19 03:09:45.176+04	2010-09-19 03:09:45.176+04
b8fcb10a-dfdf-4408-ac58-f75efe0fbe83	deb6f461-5d5e-4302-87ea-7d446502b34e	efc0e899-d41a-4d2d-9842-db9d55ff4c73	Ответы юриста	Ответы юриста		2010-09-19 03:09:45.179+04	2010-09-19 03:09:45.179+04
7b984b1c-750f-497a-9ad2-206390492734	deb6f461-5d5e-4302-87ea-7d446502b34e	efc0e899-d41a-4d2d-9842-db9d55ff4c73	Безопасность	Безопасность		2010-09-19 03:09:45.182+04	2010-09-19 03:09:45.182+04
b746d542-8756-4053-bc48-0d17e326db8e	deb6f461-5d5e-4302-87ea-7d446502b34e	efc0e899-d41a-4d2d-9842-db9d55ff4c73	Новости	Новости		2010-09-19 03:09:45.184+04	2010-09-19 03:09:45.184+04
368fe808-7708-454e-b802-f5d5f6be31aa	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Тест-ремонт	Тест-ремонт		2010-09-19 03:09:45.186+04	2010-09-19 03:09:45.186+04
9a8abb74-bcf5-444f-a0e1-689a07385add	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Хочу разобраться	Хочу разобраться		2010-09-19 03:09:45.188+04	2010-09-19 03:09:45.188+04
f86fa658-1de7-4aa6-807c-108e31eaf5ad	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Мастерская	Мастерская		2010-09-19 03:09:45.191+04	2010-09-19 03:09:45.191+04
ce8a0876-6a7e-47cb-b2b8-56658c068a7d	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Взаимозаменяемость	Взаимозаменяемость		2010-09-19 03:09:45.194+04	2010-09-19 03:09:45.194+04
9f2ed829-c4b9-4fa1-8fab-df465005073c	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Отвечают специалисты	Отвечают специалисты		2010-09-19 03:09:45.196+04	2010-09-19 03:09:45.196+04
5a9c23c2-991b-43b1-aabf-6dda9d221435	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Советы бывалых	Советы бывалых		2010-09-19 03:09:45.198+04	2010-09-19 03:09:45.198+04
2a4a469c-f1b1-494b-83f1-4c82747b92d9	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Доводим	Доводим		2010-09-19 03:09:45.201+04	2010-09-19 03:09:45.201+04
3c6f1262-fde9-4a1c-8409-cf4b01ac8c52	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Конкурс	Конкурс		2010-09-19 03:09:45.203+04	2010-09-19 03:09:45.203+04
899a27f1-6e8d-4beb-937e-df4de2b19775	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Форум	Форум		2010-09-19 03:09:45.206+04	2010-09-19 03:09:45.206+04
c8e241d7-204c-4b33-8bfd-023f7bceb010	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	В деталях	В деталях		2010-09-19 03:09:45.208+04	2010-09-19 03:09:45.208+04
c93d0d0c-ebcb-405d-ac14-03891110b92d	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Диагностика	Диагностика		2010-09-19 03:09:45.211+04	2010-09-19 03:09:45.211+04
aa558f5b-2d7b-478a-b845-cd084a2e7f26	deb6f461-5d5e-4302-87ea-7d446502b34e	d350724e-f8c9-4beb-adf3-34b41ec58686	Крайний случай	Крайний случай		2010-09-19 03:09:45.213+04	2010-09-19 03:09:45.213+04
4cc41ebb-f742-43e1-862a-9e319e989614	deb6f461-5d5e-4302-87ea-7d446502b34e	138a5506-66e9-4af0-8aae-93644e46f615	Обозрение	Обозрение		2010-09-19 03:09:45.215+04	2010-09-19 03:09:45.215+04
668a2dea-4af5-4a7f-a1fa-9a800653bf87	deb6f461-5d5e-4302-87ea-7d446502b34e	138a5506-66e9-4af0-8aae-93644e46f615	Концепт-кар	Концепт-кар		2010-09-19 03:09:45.218+04	2010-09-19 03:09:45.218+04
31169dd1-2172-4eb4-9aff-c0abeaf54d76	deb6f461-5d5e-4302-87ea-7d446502b34e	138a5506-66e9-4af0-8aae-93644e46f615	Технологии	Технологии		2010-09-19 03:09:45.221+04	2010-09-19 03:09:45.221+04
a47e3fde-4e7c-4973-903a-71156c5c6000	deb6f461-5d5e-4302-87ea-7d446502b34e	138a5506-66e9-4af0-8aae-93644e46f615	Новинки	Новинки	Новинки, исследования, изобретения	2010-09-19 03:09:45.223+04	2010-09-19 03:09:45.223+04
7db11796-3971-4b6b-bc3d-ca88e28ef6f2	deb6f461-5d5e-4302-87ea-7d446502b34e	bdb3e129-2b43-40cc-a901-ccfd847c5aea	Без границ	Без границ		2010-09-19 03:09:45.226+04	2010-09-19 03:09:45.226+04
ea30527b-0b00-4a8d-99c5-ea34f9a5e246	deb6f461-5d5e-4302-87ea-7d446502b34e	bdb3e129-2b43-40cc-a901-ccfd847c5aea	Живые классики	Живые классики		2010-09-19 03:09:45.228+04	2010-09-19 03:09:45.228+04
84d724ea-05ca-4c7c-a60a-4a6d6e782d8c	deb6f461-5d5e-4302-87ea-7d446502b34e	bdb3e129-2b43-40cc-a901-ccfd847c5aea	Эксперимент	Эксперимент		2010-09-19 03:09:45.231+04	2010-09-19 03:09:45.231+04
e7dca54f-812f-40de-a947-8673449bc0e2	deb6f461-5d5e-4302-87ea-7d446502b34e	bdb3e129-2b43-40cc-a901-ccfd847c5aea	Путешествие	Путешествие		2010-09-19 03:09:45.233+04	2010-09-19 03:09:45.233+04
31426287-c1ea-4928-bd5b-c9640de37132	deb6f461-5d5e-4302-87ea-7d446502b34e	b7841eb2-2507-4ea9-a0ca-edc8f4c6bc7d	Цены ЗР	Цены ЗР		2010-09-19 03:09:45.236+04	2010-09-19 03:09:45.236+04
44ff2a3b-6f92-4879-ad49-c10b8a73416d	deb6f461-5d5e-4302-87ea-7d446502b34e	c1dae0ac-e163-40c0-896f-3cd3c32ec8d5	На гребне моды	На гребне моды		2010-09-19 03:09:45.238+04	2010-09-19 03:09:45.238+04
f22e17c8-ff8f-4536-b38a-864e430494f3	deb6f461-5d5e-4302-87ea-7d446502b34e	c1dae0ac-e163-40c0-896f-3cd3c32ec8d5	Тюнинг	Тюнинг		2010-09-19 03:09:45.241+04	2010-09-19 03:09:45.241+04
00000000-0000-0000-0000-000000000000	77c71b8e-b229-4794-8a53-01b79ea8ba1b	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:45.251+04	2010-09-19 03:09:45.251+04
d119fc95-10a4-45e9-a99d-f5e4a52b99a4	77c71b8e-b229-4794-8a53-01b79ea8ba1b	e323f336-eab2-44de-8049-5f8a56a5d937	Тест	Тест		2010-09-19 03:09:45.319+04	2010-09-19 03:09:45.319+04
453b66cb-b02a-41d9-936e-cbee1afd7dad	77c71b8e-b229-4794-8a53-01b79ea8ba1b	e323f336-eab2-44de-8049-5f8a56a5d937	Спецтест	Спецтест		2010-09-19 03:09:45.322+04	2010-09-19 03:09:45.322+04
a038267e-152c-4d5f-ab52-ec7228a53659	77c71b8e-b229-4794-8a53-01b79ea8ba1b	e323f336-eab2-44de-8049-5f8a56a5d937	Премьера	Премьера		2010-09-19 03:09:45.325+04	2010-09-19 03:09:45.325+04
48697d55-4437-4f06-8ee1-97eedbac0166	77c71b8e-b229-4794-8a53-01b79ea8ba1b	e323f336-eab2-44de-8049-5f8a56a5d937	Презентация	Презентация		2010-09-19 03:09:45.327+04	2010-09-19 03:09:45.327+04
4977433d-02a4-46ad-8d58-b19c6f265a33	77c71b8e-b229-4794-8a53-01b79ea8ba1b	e323f336-eab2-44de-8049-5f8a56a5d937	Наше знакомство	Наше знакомство		2010-09-19 03:09:45.33+04	2010-09-19 03:09:45.33+04
c00afb49-c1f5-48d4-8c53-c58e345c1f43	77c71b8e-b229-4794-8a53-01b79ea8ba1b	e323f336-eab2-44de-8049-5f8a56a5d937	Высший класс	Высший класс		2010-09-19 03:09:45.333+04	2010-09-19 03:09:45.333+04
7df6bf82-71ac-4f99-a9c6-67b88804205c	77c71b8e-b229-4794-8a53-01b79ea8ba1b	e323f336-eab2-44de-8049-5f8a56a5d937	Авто на час	Авто на час		2010-09-19 03:09:45.336+04	2010-09-19 03:09:45.336+04
b00fa76a-cf38-4f47-8050-b8fec6ea46d2	77c71b8e-b229-4794-8a53-01b79ea8ba1b	e323f336-eab2-44de-8049-5f8a56a5d937	Испытано в деле	Испытано в деле		2010-09-19 03:09:45.339+04	2010-09-19 03:09:45.339+04
9adb454e-db2f-429b-8f6b-325bbaad8c2e	77c71b8e-b229-4794-8a53-01b79ea8ba1b	f702193a-3878-42dd-98a9-3e69d98ad545	Компоненты	Компоненты		2010-09-19 03:09:45.341+04	2010-09-19 03:09:45.341+04
ae187aa9-ce4a-4c9a-81f3-7681c1dd6732	77c71b8e-b229-4794-8a53-01b79ea8ba1b	f702193a-3878-42dd-98a9-3e69d98ad545	Экспертиза	Экспертиза		2010-09-19 03:09:45.343+04	2010-09-19 03:09:45.343+04
9f6a8b5a-619d-4672-994b-e8023fad8447	77c71b8e-b229-4794-8a53-01b79ea8ba1b	f702193a-3878-42dd-98a9-3e69d98ad545	Новые товары	Новые товары		2010-09-19 03:09:45.345+04	2010-09-19 03:09:45.345+04
df51b8f9-5d8a-4d63-8c3e-5bf7c0a6933a	77c71b8e-b229-4794-8a53-01b79ea8ba1b	f702193a-3878-42dd-98a9-3e69d98ad545	Электроника	Электроника		2010-09-19 03:09:45.348+04	2010-09-19 03:09:45.348+04
02189303-dd15-4346-b640-f84194f2ad36	77c71b8e-b229-4794-8a53-01b79ea8ba1b	f702193a-3878-42dd-98a9-3e69d98ad545	На прилавке	На прилавке		2010-09-19 03:09:45.35+04	2010-09-19 03:09:45.35+04
73b4e421-1566-4329-8abf-c57d888d763f	77c71b8e-b229-4794-8a53-01b79ea8ba1b	f702193a-3878-42dd-98a9-3e69d98ad545	Товаровед	Товаровед		2010-09-19 03:09:45.352+04	2010-09-19 03:09:45.352+04
88898d54-8033-41de-ad83-9bdd5e3653b0	77c71b8e-b229-4794-8a53-01b79ea8ba1b	f702193a-3878-42dd-98a9-3e69d98ad545	Проверено ЗР	Проверено ЗР		2010-09-19 03:09:45.354+04	2010-09-19 03:09:45.354+04
700d7efc-584d-43cd-89b6-24050f279258	77c71b8e-b229-4794-8a53-01b79ea8ba1b	fd46de01-5fdd-4d5e-91cf-bebf0c776bd6	Дегустация	Дегустация		2010-09-19 03:09:45.356+04	2010-09-19 03:09:45.356+04
d26e4cc9-8d68-4fce-84f3-e1b05da446cd	77c71b8e-b229-4794-8a53-01b79ea8ba1b	fd46de01-5fdd-4d5e-91cf-bebf0c776bd6	Семейство	Семейство		2010-09-19 03:09:45.359+04	2010-09-19 03:09:45.359+04
badbdc35-238a-479d-a169-22efa48c8a99	77c71b8e-b229-4794-8a53-01b79ea8ba1b	fd46de01-5fdd-4d5e-91cf-bebf0c776bd6	Новости дилеров	Новости дилеров		2010-09-19 03:09:45.362+04	2010-09-19 03:09:45.362+04
3ea729b5-81b9-4235-91ef-7aa0282f9c83	77c71b8e-b229-4794-8a53-01b79ea8ba1b	fd46de01-5fdd-4d5e-91cf-bebf0c776bd6	В деталях	В деталях		2010-09-19 03:09:45.364+04	2010-09-19 03:09:45.364+04
e91a2610-618d-4c98-bcca-f1a2805aadc7	77c71b8e-b229-4794-8a53-01b79ea8ba1b	fd46de01-5fdd-4d5e-91cf-bebf0c776bd6	Комплектация	Комплектация		2010-09-19 03:09:45.366+04	2010-09-19 03:09:45.366+04
66f83267-7123-48d4-b720-1b356282554e	77c71b8e-b229-4794-8a53-01b79ea8ba1b	fd46de01-5fdd-4d5e-91cf-bebf0c776bd6	Парк ЗР	Парк ЗР		2010-09-19 03:09:45.369+04	2010-09-19 03:09:45.369+04
a9f5dbb0-1c31-48c3-b095-d40ee225c3a4	77c71b8e-b229-4794-8a53-01b79ea8ba1b	fd46de01-5fdd-4d5e-91cf-bebf0c776bd6	Опции	Опции		2010-09-19 03:09:45.372+04	2010-09-19 03:09:45.372+04
b92a72be-9d15-4264-a6ca-f8fa5337daca	77c71b8e-b229-4794-8a53-01b79ea8ba1b	fd46de01-5fdd-4d5e-91cf-bebf0c776bd6	Автосалон	Автосалон		2010-09-19 03:09:45.374+04	2010-09-19 03:09:45.374+04
56575c27-b610-401e-8899-f1ffbc89cbae	77c71b8e-b229-4794-8a53-01b79ea8ba1b	6e075652-2c8e-4493-a658-a3a053776bb5	Вы нам писали	Вы нам писали		2010-09-19 03:09:45.377+04	2010-09-19 03:09:45.377+04
34816e48-c3ac-4e4e-82ea-a6d0a2b8bd34	77c71b8e-b229-4794-8a53-01b79ea8ba1b	6e075652-2c8e-4493-a658-a3a053776bb5	Отвечает Главред	Отвечает Главред		2010-09-19 03:09:45.379+04	2010-09-19 03:09:45.379+04
a5b8ed1e-a96f-464f-90a0-e7dbf2953a31	77c71b8e-b229-4794-8a53-01b79ea8ba1b	6e075652-2c8e-4493-a658-a3a053776bb5	Личное мнение	Личное мнение		2010-09-19 03:09:45.382+04	2010-09-19 03:09:45.382+04
ecd99a1b-f504-4440-b7ac-aa3ad1169d7f	77c71b8e-b229-4794-8a53-01b79ea8ba1b	ac712d3c-e001-4c5b-a8a9-346b437d14dd	С миру по гонке	С миру по гонке		2010-09-19 03:09:45.384+04	2010-09-19 03:09:45.384+04
223ab307-16e5-454f-bd79-9f4836ccb7fa	77c71b8e-b229-4794-8a53-01b79ea8ba1b	ac712d3c-e001-4c5b-a8a9-346b437d14dd	Ралли	Ралли		2010-09-19 03:09:45.386+04	2010-09-19 03:09:45.386+04
8c0b4904-1fff-4ad6-9b69-039a689c36b5	77c71b8e-b229-4794-8a53-01b79ea8ba1b	ac712d3c-e001-4c5b-a8a9-346b437d14dd	Формула-1	Формула-1		2010-09-19 03:09:45.389+04	2010-09-19 03:09:45.389+04
ce945e31-c8b9-4fdd-9373-9b782bb318e5	77c71b8e-b229-4794-8a53-01b79ea8ba1b	ac712d3c-e001-4c5b-a8a9-346b437d14dd	Спорт	Спорт		2010-09-19 03:09:45.391+04	2010-09-19 03:09:45.391+04
e8cef5bd-a2f7-4a1b-adc1-0b86d9b6ad61	77c71b8e-b229-4794-8a53-01b79ea8ba1b	ac712d3c-e001-4c5b-a8a9-346b437d14dd	Кольцевые гонки	Кольцевые гонки		2010-09-19 03:09:45.393+04	2010-09-19 03:09:45.393+04
ed305090-c698-4c5f-b407-c7c90ad91eac	77c71b8e-b229-4794-8a53-01b79ea8ba1b	a39fcaf1-c958-4c76-a50a-3706bfda0bfd	Грузовики	Грузовики		2010-09-19 03:09:45.396+04	2010-09-19 03:09:45.396+04
f9cf92ad-ec0f-492c-887b-28b6af902c67	77c71b8e-b229-4794-8a53-01b79ea8ba1b	626ae9d4-5033-4244-93cf-429b6a745a22	Интервью	Интервью		2010-09-19 03:09:45.399+04	2010-09-19 03:09:45.399+04
d59269e8-827e-41b0-9515-f99c68be1d4c	77c71b8e-b229-4794-8a53-01b79ea8ba1b	626ae9d4-5033-4244-93cf-429b6a745a22	Экономика-Обозрение	Экономика-Обозрение		2010-09-19 03:09:45.401+04	2010-09-19 03:09:45.401+04
c0838077-1c03-485c-b8f7-2bd68f79efd4	77c71b8e-b229-4794-8a53-01b79ea8ba1b	626ae9d4-5033-4244-93cf-429b6a745a22	Новости	Новости		2010-09-19 03:09:45.404+04	2010-09-19 03:09:45.404+04
b455e458-4c9f-4ca4-9b35-a0dc4450a6f3	77c71b8e-b229-4794-8a53-01b79ea8ba1b	86b79f79-009d-44c7-a01b-c2da7797645e	Спорный момент	Спорный момент		2010-09-19 03:09:45.407+04	2010-09-19 03:09:45.407+04
60ffc946-5f92-441c-8fb6-0eb5bb56b565	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Спецназ	Спецназ		2010-09-19 03:09:45.997+04	2010-09-19 03:09:45.997+04
78315508-e971-4c6b-93df-a66468abe997	77c71b8e-b229-4794-8a53-01b79ea8ba1b	86b79f79-009d-44c7-a01b-c2da7797645e	Следствие ведет ЗР	Следствие ведет ЗР		2010-09-19 03:09:45.41+04	2010-09-19 03:09:45.41+04
4ee95065-8645-43b8-b70c-8c7e8e5d6f25	77c71b8e-b229-4794-8a53-01b79ea8ba1b	86b79f79-009d-44c7-a01b-c2da7797645e	Самозащита	Самозащита		2010-09-19 03:09:45.413+04	2010-09-19 03:09:45.413+04
fbee9fd3-0b44-4406-9748-47f89e3ef653	77c71b8e-b229-4794-8a53-01b79ea8ba1b	86b79f79-009d-44c7-a01b-c2da7797645e	Прямая линия	Прямая линия		2010-09-19 03:09:45.416+04	2010-09-19 03:09:45.416+04
83b0f853-94ea-43c0-a64c-81e5f5584b91	77c71b8e-b229-4794-8a53-01b79ea8ba1b	86b79f79-009d-44c7-a01b-c2da7797645e	Ответы юриста	Ответы юриста		2010-09-19 03:09:45.418+04	2010-09-19 03:09:45.418+04
0d0f9ef4-a6a6-4587-a85c-0e52dffd5a83	77c71b8e-b229-4794-8a53-01b79ea8ba1b	86b79f79-009d-44c7-a01b-c2da7797645e	Безопасность	Безопасность		2010-09-19 03:09:45.421+04	2010-09-19 03:09:45.421+04
8a842614-ebea-41b6-b7c3-08ec2a0eeae3	77c71b8e-b229-4794-8a53-01b79ea8ba1b	86b79f79-009d-44c7-a01b-c2da7797645e	Новости	Новости		2010-09-19 03:09:45.424+04	2010-09-19 03:09:45.424+04
61f24c42-8e08-4311-ad92-878cedd7b2f7	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Тест-ремонт	Тест-ремонт		2010-09-19 03:09:45.427+04	2010-09-19 03:09:45.427+04
7fd41278-06e4-4c46-aa4b-5f318f162bd1	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Хочу разобраться	Хочу разобраться		2010-09-19 03:09:45.43+04	2010-09-19 03:09:45.43+04
92ff9dee-8bb5-4650-9e0b-b53831297b09	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Мастерская	Мастерская		2010-09-19 03:09:45.432+04	2010-09-19 03:09:45.432+04
c9ecc041-02c6-4501-a3c7-06ee3c86ecda	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Взаимозаменяемость	Взаимозаменяемость		2010-09-19 03:09:45.434+04	2010-09-19 03:09:45.434+04
954f72c6-6f17-45cd-84da-13876a124652	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Отвечают специалисты	Отвечают специалисты		2010-09-19 03:09:45.437+04	2010-09-19 03:09:45.437+04
eb102cae-ecf9-4666-a095-02e98f77d1ff	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Советы бывалых	Советы бывалых		2010-09-19 03:09:45.439+04	2010-09-19 03:09:45.439+04
e68e1d45-f7e5-4e2b-a089-e9656a29166c	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Доводим	Доводим		2010-09-19 03:09:45.442+04	2010-09-19 03:09:45.442+04
26ab659a-abc8-4593-b3a8-5d7b3abaae6c	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Конкурс	Конкурс		2010-09-19 03:09:45.444+04	2010-09-19 03:09:45.444+04
ffa98069-46b1-44cd-adcd-bad36eafe6ca	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Форум	Форум		2010-09-19 03:09:45.447+04	2010-09-19 03:09:45.447+04
44a46aa5-b8ff-42a2-8e8e-2131e3bc7f57	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	В деталях	В деталях		2010-09-19 03:09:45.449+04	2010-09-19 03:09:45.449+04
a6fe2a86-ec06-4ce6-a0c4-f19d788f6ef8	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Диагностика	Диагностика		2010-09-19 03:09:45.452+04	2010-09-19 03:09:45.452+04
e8b93c72-a34f-443a-997d-01d40d2ad551	77c71b8e-b229-4794-8a53-01b79ea8ba1b	911d696a-8b50-440e-a892-7c2e5f5894b3	Крайний случай	Крайний случай		2010-09-19 03:09:45.455+04	2010-09-19 03:09:45.455+04
f010bd09-4e7f-4b81-a58d-12f921cefde7	77c71b8e-b229-4794-8a53-01b79ea8ba1b	8d522137-a83e-4917-9f10-99493216cc22	Обозрение	Обозрение		2010-09-19 03:09:45.457+04	2010-09-19 03:09:45.457+04
832e1b95-d545-4234-8b6a-1c7d6f4e8472	77c71b8e-b229-4794-8a53-01b79ea8ba1b	8d522137-a83e-4917-9f10-99493216cc22	Концепт-кар	Концепт-кар		2010-09-19 03:09:45.459+04	2010-09-19 03:09:45.459+04
e4b059d3-f689-4e39-879e-d5b0b1f177cf	77c71b8e-b229-4794-8a53-01b79ea8ba1b	8d522137-a83e-4917-9f10-99493216cc22	Технологии	Технологии		2010-09-19 03:09:45.462+04	2010-09-19 03:09:45.462+04
1c4de38d-dfed-4101-94d2-b7c9a6d5ec45	77c71b8e-b229-4794-8a53-01b79ea8ba1b	8d522137-a83e-4917-9f10-99493216cc22	Новинки	Новинки	Новинки, исследования, изобретения	2010-09-19 03:09:45.464+04	2010-09-19 03:09:45.464+04
48f602c5-50ae-4ada-8fdf-cb137c188312	77c71b8e-b229-4794-8a53-01b79ea8ba1b	d95ff646-0a86-416b-8e72-fac5d8f659b0	Без границ	Без границ		2010-09-19 03:09:45.467+04	2010-09-19 03:09:45.467+04
953b102b-7747-48a8-8241-f4de08f4d987	77c71b8e-b229-4794-8a53-01b79ea8ba1b	d95ff646-0a86-416b-8e72-fac5d8f659b0	Живые классики	Живые классики		2010-09-19 03:09:45.469+04	2010-09-19 03:09:45.469+04
4c6437e6-5c42-4ae7-984b-f611dadbee38	77c71b8e-b229-4794-8a53-01b79ea8ba1b	d95ff646-0a86-416b-8e72-fac5d8f659b0	Эксперимент	Эксперимент		2010-09-19 03:09:45.471+04	2010-09-19 03:09:45.471+04
01165436-5961-40a4-9856-d33e335f7647	77c71b8e-b229-4794-8a53-01b79ea8ba1b	d95ff646-0a86-416b-8e72-fac5d8f659b0	Путешествие	Путешествие		2010-09-19 03:09:45.473+04	2010-09-19 03:09:45.473+04
2158eb4e-6def-48f2-b59f-dca9d323545c	77c71b8e-b229-4794-8a53-01b79ea8ba1b	61f1e946-acab-4ad2-834e-c2a67119c3d0	Цены ЗР	Цены ЗР		2010-09-19 03:09:45.476+04	2010-09-19 03:09:45.476+04
7db4a29b-f196-4f7a-b78f-34483bfce529	77c71b8e-b229-4794-8a53-01b79ea8ba1b	602a5640-a481-455d-92c8-b1a02ae2b013	На гребне моды	На гребне моды		2010-09-19 03:09:45.479+04	2010-09-19 03:09:45.479+04
88c78ea9-867b-43c0-894b-05b20fd39802	77c71b8e-b229-4794-8a53-01b79ea8ba1b	602a5640-a481-455d-92c8-b1a02ae2b013	Тюнинг	Тюнинг		2010-09-19 03:09:45.482+04	2010-09-19 03:09:45.482+04
00000000-0000-0000-0000-000000000000	4d0daad8-2c82-4d67-b75d-079300f89caf	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:45.493+04	2010-09-19 03:09:45.493+04
00000000-0000-0000-0000-000000000000	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:45.541+04	2010-09-19 03:09:45.541+04
b6f6b6b6-cb4e-4df1-a134-8215859fd080	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	В курсе событий	В курсе событий		2010-09-19 03:09:45.582+04	2010-09-19 03:09:45.582+04
10202a5c-3cc7-43cf-86d9-772475ded397	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Новости	Новости		2010-09-19 03:09:45.585+04	2010-09-19 03:09:45.585+04
92680900-950f-4bb6-984c-96c904ffb978	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Конференция	Конференция		2010-09-19 03:09:45.588+04	2010-09-19 03:09:45.588+04
a64e64b3-33d9-45b0-8c47-a8ddc5b516e8	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Особое внимание	Особое внимание		2010-09-19 03:09:45.59+04	2010-09-19 03:09:45.59+04
2410f9ab-5164-48b8-b8bf-53abcad66270	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Кадры	Кадры		2010-09-19 03:09:45.592+04	2010-09-19 03:09:45.592+04
eae7a139-274e-4a01-90c6-27b83c2f5be5	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Безопасность	Безопасность		2010-09-19 03:09:45.595+04	2010-09-19 03:09:45.595+04
4a56ffbd-3b71-4914-bd5c-a6e73d06a0eb	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Лизинг	Лизинг		2010-09-19 03:09:45.598+04	2010-09-19 03:09:45.598+04
4b29e88b-7e9a-4815-9f13-55b329dcde07	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Страхование	Страхование		2010-09-19 03:09:45.6+04	2010-09-19 03:09:45.6+04
4bb183c6-51b5-49b3-8ce6-560e6b14c467	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Налоги	Налоги		2010-09-19 03:09:45.603+04	2010-09-19 03:09:45.603+04
f9118bcf-66bb-4592-a9fc-de155dd5b511	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Логистика	Логистика		2010-09-19 03:09:45.605+04	2010-09-19 03:09:45.605+04
9f5e34fa-c959-477b-bdcc-727be5e07634	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Гарантия	Гарантия		2010-09-19 03:09:45.607+04	2010-09-19 03:09:45.607+04
5d07aaa3-9161-44ea-9c53-e9204176fe60	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Перевозки	Перевозки		2010-09-19 03:09:45.609+04	2010-09-19 03:09:45.609+04
0b968eff-04d6-4125-9aec-5bc96c8bba61	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	433f2ecf-29d0-485c-a661-6d421393a6ab	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:45.612+04	2010-09-19 03:09:45.612+04
9bf173c6-3a2a-4243-a942-1e630099af40	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	e03a5e75-d22e-4556-9b78-0c424174ef2b	Tyrex Trophy	Tyrex Trophy		2010-09-19 03:09:45.614+04	2010-09-19 03:09:45.614+04
22493c6b-31e5-44cc-90da-b9b92e5bbaf9	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	e03a5e75-d22e-4556-9b78-0c424174ef2b	УМЗ-4216	УМЗ-4216		2010-09-19 03:09:45.616+04	2010-09-19 03:09:45.616+04
67db4f17-269e-4025-8683-1b067cffb159	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	e03a5e75-d22e-4556-9b78-0c424174ef2b	GoodYear	GoodYear		2010-09-19 03:09:45.619+04	2010-09-19 03:09:45.619+04
15c651d3-76ac-4f90-9a66-d315282418bf	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	820c6a18-31f3-4c99-858c-2400be659868	Премьера	Премьера		2010-09-19 03:09:45.621+04	2010-09-19 03:09:45.621+04
c67a0459-2e00-41ca-a8a4-fdfacecd68c6	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	820c6a18-31f3-4c99-858c-2400be659868	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:45.623+04	2010-09-19 03:09:45.623+04
8667ac7c-e3ab-434b-a386-a24dbb9be7ab	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	820c6a18-31f3-4c99-858c-2400be659868	Новости	Новости		2010-09-19 03:09:45.625+04	2010-09-19 03:09:45.625+04
160dfe51-7a4c-4eed-bcd6-eab5bc776cdc	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	820c6a18-31f3-4c99-858c-2400be659868	Опыт эксплуатации	Опыт эксплуатации		2010-09-19 03:09:45.627+04	2010-09-19 03:09:45.627+04
d93780cd-2e8d-4771-8fff-9718d0222ad2	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	820c6a18-31f3-4c99-858c-2400be659868	Конкуренты с востока	Конкуренты с востока		2010-09-19 03:09:45.629+04	2010-09-19 03:09:45.629+04
4f1914df-b5b5-477e-85dd-6351211f3fd9	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	820c6a18-31f3-4c99-858c-2400be659868	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:45.632+04	2010-09-19 03:09:45.632+04
ca3e6e41-fade-4730-9822-21318612231f	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	820c6a18-31f3-4c99-858c-2400be659868	Прицепы	Прицепы		2010-09-19 03:09:45.634+04	2010-09-19 03:09:45.634+04
0e4ac966-3dcd-4cb4-99b4-04bd7f0d0786	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	2ab354de-c90b-4f22-bafa-1f4c279b1fc1	Прицепы	Прицепы		2010-09-19 03:09:45.636+04	2010-09-19 03:09:45.636+04
124ef91c-035d-4d01-9a44-6b9e253bbb0e	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	2ab354de-c90b-4f22-bafa-1f4c279b1fc1	Новости	Новости		2010-09-19 03:09:45.639+04	2010-09-19 03:09:45.639+04
5a6a4073-4529-4ca6-acee-ae66e618e4f5	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	2ab354de-c90b-4f22-bafa-1f4c279b1fc1	Без комментариев	Без комментариев		2010-09-19 03:09:45.641+04	2010-09-19 03:09:45.641+04
394f9cc9-d622-4ac2-a2c4-a9ad2a747cfc	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	2ab354de-c90b-4f22-bafa-1f4c279b1fc1	Компоненты	Компоненты		2010-09-19 03:09:45.643+04	2010-09-19 03:09:45.643+04
0a2f3f5d-5ecd-419e-b795-1d1384763e2e	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	2ab354de-c90b-4f22-bafa-1f4c279b1fc1	Бизнес в России	Бизнес в России		2010-09-19 03:09:45.646+04	2010-09-19 03:09:45.646+04
04f7ab9f-552d-4dd3-9332-897024286917	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	2ab354de-c90b-4f22-bafa-1f4c279b1fc1	Масла	Масла		2010-09-19 03:09:45.649+04	2010-09-19 03:09:45.649+04
d3e4183e-ecef-443a-9d2d-f900912680f3	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	2ab354de-c90b-4f22-bafa-1f4c279b1fc1	Шины	Шины		2010-09-19 03:09:45.652+04	2010-09-19 03:09:45.652+04
54d41de3-db8a-4913-a84b-40f1017bea52	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	2ab354de-c90b-4f22-bafa-1f4c279b1fc1	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:45.654+04	2010-09-19 03:09:45.654+04
32bec5aa-05dc-4702-8f4a-9e35460b747d	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	3b6aab29-9455-4d6e-9ef1-7349ed99d760	Новости	Новости		2010-09-19 03:09:45.656+04	2010-09-19 03:09:45.656+04
bedabeb6-5234-4355-9afc-61c8e603f9c5	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	3b6aab29-9455-4d6e-9ef1-7349ed99d760	Масла	Масла		2010-09-19 03:09:45.658+04	2010-09-19 03:09:45.658+04
45323f8f-90c9-4b67-9e5b-ac73aa800a42	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	3b6aab29-9455-4d6e-9ef1-7349ed99d760	Шины	Шины		2010-09-19 03:09:45.661+04	2010-09-19 03:09:45.661+04
638003f3-ae9d-4bff-8d35-4413d7d2e9f1	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	3b6aab29-9455-4d6e-9ef1-7349ed99d760	АКБ	АКБ		2010-09-19 03:09:45.664+04	2010-09-19 03:09:45.664+04
0811148d-f747-492e-9255-62ab7d75c6c1	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	3b6aab29-9455-4d6e-9ef1-7349ed99d760	Ремзона	Ремзона		2010-09-19 03:09:45.666+04	2010-09-19 03:09:45.666+04
659caf83-51ff-4566-8f4a-ab97ceaefd37	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	3b6aab29-9455-4d6e-9ef1-7349ed99d760	Оборудование	Оборудование		2010-09-19 03:09:45.668+04	2010-09-19 03:09:45.668+04
b2bce363-5b8a-4f72-bf2a-01487868e2d6	ac1d0ca1-06bb-4d74-89e5-1662a68475dd	3b6aab29-9455-4d6e-9ef1-7349ed99d760	Агрегаты	Агрегаты		2010-09-19 03:09:45.671+04	2010-09-19 03:09:45.671+04
00000000-0000-0000-0000-000000000000	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:45.681+04	2010-09-19 03:09:45.681+04
36c560a4-d366-46a9-bb37-772182d565df	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Эндуро	Эндуро		2010-09-19 03:09:45.729+04	2010-09-19 03:09:45.729+04
e29607eb-f141-4665-ba96-7f26ae7d987c	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	c7d33019-1db4-49ad-96ee-d3b27552d57f	Тест	Тест		2010-09-19 03:09:45.732+04	2010-09-19 03:09:45.732+04
ca9dda48-050e-4d0a-bb11-2c1b5c1d3859	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	c7d33019-1db4-49ad-96ee-d3b27552d57f	Супертест	Супертест		2010-09-19 03:09:45.734+04	2010-09-19 03:09:45.734+04
e5af517c-3f23-4761-87e7-bfb21ff4a446	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	c7d33019-1db4-49ad-96ee-d3b27552d57f	Сравнение	Сравнение		2010-09-19 03:09:45.736+04	2010-09-19 03:09:45.736+04
9a8d0aea-d9bc-47b7-91ea-b2fdc30b1123	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	c7d33019-1db4-49ad-96ee-d3b27552d57f	Тест-драйв	Тест-драйв		2010-09-19 03:09:45.74+04	2010-09-19 03:09:45.74+04
310cb9b4-591e-4619-b5a6-80f31d655501	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	c7d33019-1db4-49ad-96ee-d3b27552d57f	Спецтест	Спецтест		2010-09-19 03:09:45.743+04	2010-09-19 03:09:45.743+04
a693fcbf-3cfb-4a85-aa9e-b17ed7770e10	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	c746aa30-2c98-4668-a02b-7267a7ee0540	Новости	Новости		2010-09-19 03:09:45.745+04	2010-09-19 03:09:45.745+04
30c5aeb0-e141-4615-b55a-0b34e805c684	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	c746aa30-2c98-4668-a02b-7267a7ee0540	Мнение	Мнение		2010-09-19 03:09:45.747+04	2010-09-19 03:09:45.747+04
a0263399-1273-42db-bbb4-9fd43438b667	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	c2f3d19c-a1dd-47df-964b-3c992c61f04e	Анонс	Анонс		2010-09-19 03:09:45.75+04	2010-09-19 03:09:45.75+04
d2fb51c2-1ca3-4140-83a9-b02c3f540b4c	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Спидвей	Спидвей		2010-09-19 03:09:45.752+04	2010-09-19 03:09:45.752+04
5961c504-809e-4335-aedc-b041b4843a24	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Снегоходы	Снегоходы		2010-09-19 03:09:45.755+04	2010-09-19 03:09:45.755+04
64221d9e-5c5c-4f95-88d1-408fb417139f	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Новости	Новости		2010-09-19 03:09:45.757+04	2010-09-19 03:09:45.757+04
f2a71b5e-cede-4607-ab8b-2b3786e9464a	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Ралли-рейд	Ралли-рейд		2010-09-19 03:09:45.759+04	2010-09-19 03:09:45.759+04
d4aedba6-7e17-4a56-99b1-1e8d92f3370b	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Кольцо	Кольцо		2010-09-19 03:09:45.762+04	2010-09-19 03:09:45.762+04
89a2838d-fab1-416d-b323-fee03d368288	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Мотобол	Мотобол		2010-09-19 03:09:45.765+04	2010-09-19 03:09:45.765+04
b220e22f-63ab-455d-8c63-e8f845d574d3	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Мото GP	Мото GP		2010-09-19 03:09:45.768+04	2010-09-19 03:09:45.768+04
46828c48-6675-48d1-951d-e336f3f755d4	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	История	История		2010-09-19 03:09:45.77+04	2010-09-19 03:09:45.77+04
9fcf628a-e99b-453b-b88a-1c46fd0e4699	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Кросс	Кросс		2010-09-19 03:09:45.772+04	2010-09-19 03:09:45.772+04
1aff0d36-2add-4796-8c97-6880a8927e8a	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Супербайк	Супербайк		2010-09-19 03:09:45.775+04	2010-09-19 03:09:45.775+04
7c78b4b2-c193-481a-b20a-b31518c3ed09	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Гонки на льду	Гонки на льду		2010-09-19 03:09:45.777+04	2010-09-19 03:09:45.777+04
b7aa0ea0-1c41-46fb-a497-3dadcb6a1304	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Фристайл	Фристайл		2010-09-19 03:09:45.779+04	2010-09-19 03:09:45.779+04
254c3d0b-506f-4154-9884-5692f55a139e	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	83b34a08-73a5-44cd-9f97-c57a20db6648	Трек-тест	Трек-тест		2010-09-19 03:09:45.782+04	2010-09-19 03:09:45.782+04
2019211d-0e3f-4ccb-b1e1-2455493470de	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Механик	Механик		2010-09-19 03:09:45.784+04	2010-09-19 03:09:45.784+04
112d5d8c-1702-4549-9c47-ac86efce11f5	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Вопрос-ответ	Вопрос-ответ		2010-09-19 03:09:45.786+04	2010-09-19 03:09:45.786+04
5fd5869b-ae97-405e-a148-6b7d8f4975e9	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Опыт	Опыт		2010-09-19 03:09:45.789+04	2010-09-19 03:09:45.789+04
efe124d0-2b51-4b09-8be6-9ea2e79f2118	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Ремзона	Ремзона		2010-09-19 03:09:45.791+04	2010-09-19 03:09:45.791+04
31644f3a-ebbf-4054-8c5a-1bdd28227c89	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Эксклюзив	Эксклюзив		2010-09-19 03:09:45.794+04	2010-09-19 03:09:45.794+04
bf92b538-8f5b-4144-a58d-85231bcb2c66	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Имидж	Имидж		2010-09-19 03:09:45.797+04	2010-09-19 03:09:45.797+04
f415b46a-749e-4340-a0d8-d94d6d3800d9	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Отвал башки!	Отвал башки!		2010-09-19 03:09:45.799+04	2010-09-19 03:09:45.799+04
799df132-6cfc-477c-926e-ddb73067ba02	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Строим эндуро	Строим эндуро		2010-09-19 03:09:45.802+04	2010-09-19 03:09:45.802+04
ad036a44-ba37-47c8-8658-57540589b1c5	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Мозгодром	Мозгодром		2010-09-19 03:09:45.804+04	2010-09-19 03:09:45.804+04
bafc5965-1711-426c-a649-9af9667be64b	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Академия	Академия		2010-09-19 03:09:45.806+04	2010-09-19 03:09:45.806+04
a1ab98a8-3e6d-4bae-904c-b99648ab7492	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Кросс	Кросс		2010-09-19 03:09:45.809+04	2010-09-19 03:09:45.809+04
cc16739d-b438-41a5-bf78-47dcc9c5c5c1	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Тюнинг	Тюнинг		2010-09-19 03:09:45.811+04	2010-09-19 03:09:45.811+04
3d665605-5132-4ac6-9957-24ec1b529a1a	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Регламент	Регламент		2010-09-19 03:09:45.814+04	2010-09-19 03:09:45.814+04
8d93f810-3270-4a20-be33-5f3389ea067e	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Доводим	Доводим		2010-09-19 03:09:45.816+04	2010-09-19 03:09:45.816+04
ac2402dd-d6b3-4244-9192-b178406ba62d	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	78b6e77d-e1fb-4224-a74a-a3f691adaacd	Оборудование	Оборудование		2010-09-19 03:09:45.819+04	2010-09-19 03:09:45.819+04
b56d21dd-9be3-4c77-b7aa-4ca0a0df0098	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Спор	Спор		2010-09-19 03:09:45.822+04	2010-09-19 03:09:45.822+04
8296610b-d52b-4497-a931-75757088d0b2	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Криминал	Криминал		2010-09-19 03:09:45.824+04	2010-09-19 03:09:45.824+04
6f0a9dad-7619-4a8d-b59f-40f84c41c657	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Изо	Изо		2010-09-19 03:09:45.826+04	2010-09-19 03:09:45.826+04
765695c2-bbe4-462e-a1ac-77392cc6fd40	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	CD на колесах	CD на колесах		2010-09-19 03:09:45.829+04	2010-09-19 03:09:45.829+04
7ef530f5-8a9d-4739-be4a-29936e52b25d	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Клуб-инфо	Клуб-инфо		2010-09-19 03:09:45.832+04	2010-09-19 03:09:45.832+04
57b34b97-9437-484b-9e2c-a3c2ea62ab85	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Один из нас	Один из нас		2010-09-19 03:09:45.834+04	2010-09-19 03:09:45.834+04
9153da31-6633-4f39-b8ce-90e726f631ab	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Звезды на мотоциклах	Звезды на мотоциклах		2010-09-19 03:09:45.837+04	2010-09-19 03:09:45.837+04
f5a75d46-b1da-4607-ae0c-ff806b0a1459	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Человек-легенда	Человек-легенда		2010-09-19 03:09:45.839+04	2010-09-19 03:09:45.839+04
4935b514-e2dc-45a3-be69-fa1231ba1bb2	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Игра по-крупному	Игра по-крупному		2010-09-19 03:09:45.841+04	2010-09-19 03:09:45.841+04
3d201813-b76c-416c-a474-6a1f394882be	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Консультация	Консультация		2010-09-19 03:09:45.843+04	2010-09-19 03:09:45.843+04
a6444ce2-5b77-4376-a60b-d6821010b5ee	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Суперсамопал	Суперсамопал		2010-09-19 03:09:45.846+04	2010-09-19 03:09:45.846+04
3e62fc76-7da1-4ebc-abed-44c1fd37207e	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	"Гвоздь" сезона	"Гвоздь" сезона		2010-09-19 03:09:45.848+04	2010-09-19 03:09:45.848+04
aacb789c-6298-442f-a26e-cbd01a792f7d	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Экстрим-тур	Экстрим-тур		2010-09-19 03:09:45.851+04	2010-09-19 03:09:45.851+04
8ed0e84f-7542-4c01-b2eb-def28c566938	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Конкурс читателей	Конкурс читателей		2010-09-19 03:09:45.854+04	2010-09-19 03:09:45.854+04
35ccb6c8-ee1e-41d8-8055-063b6d199ba6	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Экспертиза	Экспертиза		2010-09-19 03:09:45.858+04	2010-09-19 03:09:45.858+04
2b5da00d-a46f-47dc-a6b7-eb265077084b	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Прилавок	Прилавок		2010-09-19 03:09:45.861+04	2010-09-19 03:09:45.861+04
5e417286-6df7-4aea-b9ca-8dcdb5d23a0f	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Мотай на ус!	Мотай на ус!		2010-09-19 03:09:45.863+04	2010-09-19 03:09:45.863+04
3ac79549-83bb-4cda-97fd-870b3ebfdce5	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Не обманись!	Не обманись!		2010-09-19 03:09:45.866+04	2010-09-19 03:09:45.866+04
410cf284-55e2-42f5-9b3a-fa7f431fa390	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Юрспас	Юрспас		2010-09-19 03:09:45.868+04	2010-09-19 03:09:45.868+04
126a791b-a59a-4682-a804-bf76a1828901	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Экстрим	Экстрим		2010-09-19 03:09:45.87+04	2010-09-19 03:09:45.87+04
a9103cbd-a125-43fb-ac74-196752cc824b	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	MY'ZONE	MY'ZONE		2010-09-19 03:09:45.873+04	2010-09-19 03:09:45.873+04
331bb89c-a282-4300-8365-ae919260ec64	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Ищите пятницу	Ищите пятницу		2010-09-19 03:09:45.875+04	2010-09-19 03:09:45.875+04
6e8f3d91-8caf-41c1-a662-e1533d2c7ce2	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Барахолка	Барахолка		2010-09-19 03:09:45.877+04	2010-09-19 03:09:45.877+04
af733c8d-bacf-4a6e-9e89-0b3e596b44a5	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	По городам и весям	По городам и весям		2010-09-19 03:09:45.88+04	2010-09-19 03:09:45.88+04
1d0787fb-d50d-469e-93e9-6fa5cbe12463	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	От очевидца	От очевидца		2010-09-19 03:09:45.883+04	2010-09-19 03:09:45.883+04
87dacd74-c8e1-4fae-b757-481bd08b84c1	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Мастер-пилот	Мастер-пилот		2010-09-19 03:09:45.885+04	2010-09-19 03:09:45.885+04
72245640-dd00-4777-ae3e-a9a987a1b65c	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Зимний адреналин	Зимний адреналин		2010-09-19 03:09:45.888+04	2010-09-19 03:09:45.888+04
685f750f-1994-4231-a9d3-60d75eb819a5	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Увековечим	Увековечим		2010-09-19 03:09:45.89+04	2010-09-19 03:09:45.89+04
981f1454-6167-465d-bb85-fd6255f7499f	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Распахнутый мир	Распахнутый мир		2010-09-19 03:09:45.892+04	2010-09-19 03:09:45.892+04
6f41367f-b015-49cf-aa06-11f63aec5375	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Мини-путешествие	Мини-путешествие		2010-09-19 03:09:45.894+04	2010-09-19 03:09:45.894+04
c619fe33-bcd1-4e9c-978b-c44ed973bd65	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Безопасность	Безопасность		2010-09-19 03:09:45.896+04	2010-09-19 03:09:45.896+04
d066459f-72c0-4a69-b273-a1e5b12c3ab2	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Актуально	Актуально		2010-09-19 03:09:45.899+04	2010-09-19 03:09:45.899+04
07251f34-8e1e-46c1-84a3-b1e10023aad7	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Заграница	Заграница		2010-09-19 03:09:45.901+04	2010-09-19 03:09:45.901+04
7a786590-1520-4376-8edd-cdf9222f7104	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Клубная жизнь	Клубная жизнь		2010-09-19 03:09:45.903+04	2010-09-19 03:09:45.903+04
de312b5d-3fc1-456b-af1e-17c04e23f2ce	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	d05524ab-e7d6-4285-afb8-b9317c398ee2	Нам пишут	Нам пишут		2010-09-19 03:09:45.905+04	2010-09-19 03:09:45.905+04
792c857f-90e0-4f51-81de-42b2c47730c3	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Стоп линия	Стоп линия		2010-09-19 03:09:45.908+04	2010-09-19 03:09:45.908+04
3a52bbdb-7edb-4e8a-873a-4c732d980393	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	С комфортом	С комфортом		2010-09-19 03:09:45.911+04	2010-09-19 03:09:45.911+04
72671184-4609-4582-8783-824ec2d3d6f7	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Модельный гид	Модельный гид		2010-09-19 03:09:45.913+04	2010-09-19 03:09:45.913+04
5db0b33b-5951-4a08-ba2a-173d2ad66d50	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Бенефис диллера	Бенефис диллера		2010-09-19 03:09:45.915+04	2010-09-19 03:09:45.915+04
e7b7337d-0cfd-4222-9755-2d65a5a4d9af	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Книжная полка	Книжная полка		2010-09-19 03:09:45.918+04	2010-09-19 03:09:45.918+04
967abba0-5ebd-4161-b5ed-8e43ec39e001	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Береги себя, родного!	Береги себя, родного!		2010-09-19 03:09:45.921+04	2010-09-19 03:09:45.921+04
113546ea-2696-474c-aafb-35289beec511	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Вердикт	Вердикт		2010-09-19 03:09:45.923+04	2010-09-19 03:09:45.923+04
72ef26dd-b19c-4851-886c-0b0e37b81496	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Памятка покупателю	Памятка покупателю		2010-09-19 03:09:45.926+04	2010-09-19 03:09:45.926+04
81c9eaa2-1905-495d-bc0f-3294ae7cb874	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Проблема выбора	Проблема выбора		2010-09-19 03:09:45.928+04	2010-09-19 03:09:45.928+04
8585c765-34f6-4271-9228-56eaefebae79	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Статистика	Статистика		2010-09-19 03:09:45.93+04	2010-09-19 03:09:45.93+04
d9991d80-35b1-4539-a3be-732fb2478d19	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Цены "Мото"	Цены "Мото"		2010-09-19 03:09:45.932+04	2010-09-19 03:09:45.932+04
5a68ec8c-a936-4a22-9c71-0f1eb316e0dd	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Из первых уст	Из первых уст		2010-09-19 03:09:45.935+04	2010-09-19 03:09:45.935+04
dc3f5250-586f-4037-970d-f7886f5ba950	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	VIP-холл	VIP-холл		2010-09-19 03:09:45.938+04	2010-09-19 03:09:45.938+04
a5eb0087-18ff-44a8-97ac-86ee01c2c65c	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Брэнд	Брэнд		2010-09-19 03:09:45.94+04	2010-09-19 03:09:45.94+04
7aca6fea-e55c-4393-a27b-2eeb7ae9828a	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Досье	Досье		2010-09-19 03:09:45.943+04	2010-09-19 03:09:45.943+04
851ec249-b2ca-4761-bfc2-be072ed345a9	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	631c8042-611c-426e-8e2c-aa0fd11e005a	Выбираем	Выбираем		2010-09-19 03:09:45.946+04	2010-09-19 03:09:45.946+04
f4d9fe4f-f6ed-4971-9432-7176c022de77	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Новости	Новости		2010-09-19 03:09:45.948+04	2010-09-19 03:09:45.948+04
b8720c32-2eb6-4f6f-8b57-eac2dd7fbedb	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Интеграция	Интеграция		2010-09-19 03:09:45.95+04	2010-09-19 03:09:45.95+04
fc968f21-32f2-4c62-9715-c0c4ac5e9d10	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Мы и мотоциклы	Мы и мотоциклы		2010-09-19 03:09:45.952+04	2010-09-19 03:09:45.952+04
89bbd478-766d-4ac5-9708-f97923e1666f	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Актуально	Актуально		2010-09-19 03:09:45.955+04	2010-09-19 03:09:45.955+04
84ba58a9-b16f-4515-887f-a8d2b74a1a14	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Тест	Тест		2010-09-19 03:09:45.958+04	2010-09-19 03:09:45.958+04
4c95bb0f-e69e-40a9-8754-88662487482d	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Тест-райд	Тест-райд		2010-09-19 03:09:45.961+04	2010-09-19 03:09:45.961+04
e9e6784d-17c8-4b3e-9f2a-618496c5c5c3	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Секонд-тест	Секонд-тест		2010-09-19 03:09:45.963+04	2010-09-19 03:09:45.963+04
78ad2153-f572-40a8-97bb-0e27d6d7d286	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Испытания	Испытания		2010-09-19 03:09:45.965+04	2010-09-19 03:09:45.965+04
9d5803a2-2d0b-4d5a-b730-976fdf821292	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Экзотика	Экзотика		2010-09-19 03:09:45.968+04	2010-09-19 03:09:45.968+04
403b6da2-a81b-4a90-9588-e8c7ea6a87ab	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Кунсткамера	Кунсткамера		2010-09-19 03:09:45.971+04	2010-09-19 03:09:45.971+04
904ebf17-b5eb-4990-91a4-026220dd5ea8	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Тюнинг	Тюнинг		2010-09-19 03:09:45.974+04	2010-09-19 03:09:45.974+04
5589c702-a841-4eb5-916d-6163cf8fb4c3	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Подиум	Подиум		2010-09-19 03:09:45.976+04	2010-09-19 03:09:45.976+04
423283e3-ce06-41c0-a0af-552eb4e4300c	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Внутренние дела	Внутренние дела		2010-09-19 03:09:45.978+04	2010-09-19 03:09:45.978+04
7077a69d-6e01-4c11-99a5-ddae3aa2041e	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Не понаслышке	Не понаслышке		2010-09-19 03:09:45.981+04	2010-09-19 03:09:45.981+04
f300a583-c71e-498c-af3f-82f5cd9b564a	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Русский проект	Русский проект		2010-09-19 03:09:45.984+04	2010-09-19 03:09:45.984+04
006717f1-e35e-48de-91e2-43833851bb11	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Kit-парад	Kit-парад		2010-09-19 03:09:45.987+04	2010-09-19 03:09:45.987+04
f4447d91-8865-4811-a1d2-09d692af0591	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Дизайн-центр	Дизайн-центр		2010-09-19 03:09:45.989+04	2010-09-19 03:09:45.989+04
d14ab1dc-1bcd-4a02-bcd0-c94768c4655b	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Динамит-клуб	Динамит-клуб		2010-09-19 03:09:45.992+04	2010-09-19 03:09:45.992+04
e55f8cb7-edc2-4ae1-b6a2-9209c58e06de	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Дегустация	Дегустация		2010-09-19 03:09:45.994+04	2010-09-19 03:09:45.994+04
54c239d8-4e17-4883-bab6-ed4343e80f79	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Железный марш	Железный марш		2010-09-19 03:09:46+04	2010-09-19 03:09:46+04
cba0fa9b-f212-43a2-a21a-fdb3dd7b9463	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Кто на новенького?	Кто на новенького?		2010-09-19 03:09:46.002+04	2010-09-19 03:09:46.002+04
707f1383-d190-4b10-9640-0a3bbfce7f7e	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Топ-модель	Топ-модель		2010-09-19 03:09:46.004+04	2010-09-19 03:09:46.004+04
857af2ec-20f2-4773-bf77-a880bc9ed0c5	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Скутерьма	Скутерьма		2010-09-19 03:09:46.006+04	2010-09-19 03:09:46.006+04
8697c337-357d-486d-a33f-e05944017829	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Скутермания	Скутермания		2010-09-19 03:09:46.008+04	2010-09-19 03:09:46.008+04
df690d20-4f0e-4b59-a232-a418edc5fe82	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Униккумы	Униккумы		2010-09-19 03:09:46.011+04	2010-09-19 03:09:46.011+04
8689f1c6-29ad-4d55-ab47-4cb01a1079d5	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Инорынок	Инорынок		2010-09-19 03:09:46.014+04	2010-09-19 03:09:46.014+04
2a2db4aa-10be-4688-ae28-20c5e5e86085	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Загранка	Загранка		2010-09-19 03:09:46.016+04	2010-09-19 03:09:46.016+04
dc2b2006-2ffd-438f-b071-f4337c061d08	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Резонанс	Резонанс		2010-09-19 03:09:46.019+04	2010-09-19 03:09:46.019+04
3b18283e-1002-4b8f-9997-0fe76850ecd6	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Форсаж	Форсаж		2010-09-19 03:09:46.022+04	2010-09-19 03:09:46.022+04
62b6adb9-65ff-4da7-9a7d-0742436007a7	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Книжная полка	Книжная полка		2010-09-19 03:09:46.025+04	2010-09-19 03:09:46.025+04
58bb287a-af7a-455f-ad65-b69c4effa897	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Культ масс	Культ масс		2010-09-19 03:09:46.028+04	2010-09-19 03:09:46.028+04
0eefdf2d-ebba-4668-8733-c769615b66e9	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Дебют	Дебют		2010-09-19 03:09:46.031+04	2010-09-19 03:09:46.031+04
5649b97a-a87c-40f6-9e81-771fa55aaf94	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Preview	Preview		2010-09-19 03:09:46.033+04	2010-09-19 03:09:46.033+04
5076cab2-60ba-4b61-931f-fe16fc5008d9	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Эволюция	Эволюция		2010-09-19 03:09:46.035+04	2010-09-19 03:09:46.035+04
e0f9d62b-ff00-4431-af5d-87e4d8b3fbcc	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Вернисаж	Вернисаж		2010-09-19 03:09:46.038+04	2010-09-19 03:09:46.038+04
0dae1ab2-6012-4b65-ad6e-32cd4bd6aceb	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Красотищща	Красотищща		2010-09-19 03:09:46.041+04	2010-09-19 03:09:46.041+04
f9efe8e0-5512-4571-a7e1-3a442015b5d9	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Беда!	Беда!		2010-09-19 03:09:46.043+04	2010-09-19 03:09:46.043+04
bf8f174d-4aaf-48b4-87ec-2e1eed2b2cf0	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Рождение жанра	Рождение жанра		2010-09-19 03:09:46.045+04	2010-09-19 03:09:46.045+04
0bb8ccdb-e76e-44a4-8293-c732b0e1b055	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Самопал	Самопал		2010-09-19 03:09:46.048+04	2010-09-19 03:09:46.048+04
69fa34d4-2011-4348-826c-4ce700b2932a	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Практическая польза	Практическая польза		2010-09-19 03:09:46.05+04	2010-09-19 03:09:46.05+04
cdfc5caf-d54a-4edb-a896-ba265a00ad12	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Scootera	Scootera		2010-09-19 03:09:46.053+04	2010-09-19 03:09:46.053+04
b4da38fa-2cf2-4e14-8060-869e6c816bb0	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Шоу-парадиз	Шоу-парадиз		2010-09-19 03:09:46.055+04	2010-09-19 03:09:46.055+04
dbc94df0-01ba-4772-8660-85a4875e7ed1	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Тюнинг-шоу	Тюнинг-шоу		2010-09-19 03:09:46.058+04	2010-09-19 03:09:46.058+04
0f57bd3d-1643-4827-a743-b99351f52f62	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Генеалогия	Генеалогия		2010-09-19 03:09:46.06+04	2010-09-19 03:09:46.06+04
53e03db8-94fc-4ba8-9af0-26c90c9dbeab	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Премьер-тест	Премьер-тест		2010-09-19 03:09:46.062+04	2010-09-19 03:09:46.062+04
6e9f0642-9875-4a9d-b817-b4d93d5b9905	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Из первых уст	Из первых уст		2010-09-19 03:09:46.065+04	2010-09-19 03:09:46.065+04
1a7e8dba-3fe4-46f9-8f0a-4d73db96b5d0	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Встречайте	Встречайте		2010-09-19 03:09:46.067+04	2010-09-19 03:09:46.067+04
c4f75c79-854e-4902-bcba-2d430edbe2fd	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Изобридеи	Изобридеи		2010-09-19 03:09:46.07+04	2010-09-19 03:09:46.07+04
20008c68-11da-4bbd-9680-067419f9b0db	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Higt-tech	Higt-tech		2010-09-19 03:09:46.072+04	2010-09-19 03:09:46.072+04
1678bf84-b6f3-4c6d-a8c1-eec5497a82cf	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Письма из Европы	Письма из Европы		2010-09-19 03:09:46.074+04	2010-09-19 03:09:46.074+04
63e6a357-c354-4bd8-8503-f51217410496	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Брэнд	Брэнд		2010-09-19 03:09:46.077+04	2010-09-19 03:09:46.077+04
5b9262cc-9d5c-4bfe-856b-04ce3547d92d	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Экип-тест	Экип-тест		2010-09-19 03:09:46.079+04	2010-09-19 03:09:46.079+04
4cb8f878-550c-42c7-8eca-a8b916460123	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Мастер-пилот	Мастер-пилот		2010-09-19 03:09:46.082+04	2010-09-19 03:09:46.082+04
e5e41115-ad10-48ab-91a8-78805fcd134e	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Tech-art	Tech-art		2010-09-19 03:09:46.084+04	2010-09-19 03:09:46.084+04
307da676-6ca2-4c10-b81a-5df1a07cb0ff	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Know-how	Know-how		2010-09-19 03:09:46.086+04	2010-09-19 03:09:46.086+04
0bece8e2-5339-4086-a9ca-f2414eb38f19	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	110cdb57-6129-4e50-b04c-cdcc0e71a75b	Flashback	Flashback		2010-09-19 03:09:46.089+04	2010-09-19 03:09:46.089+04
d055445d-2c0d-421f-802f-3096315dc6c4	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	771775c6-64e3-4693-bb2f-6f188fa71858	Содержание	Содержание		2010-09-19 03:09:46.091+04	2010-09-19 03:09:46.091+04
f2dde4b0-01e0-4d7f-9209-d1f676664450	d4b228d3-7067-49e8-b5b7-03ca7f752f0c	771775c6-64e3-4693-bb2f-6f188fa71858	Список моделей	Список моделей		2010-09-19 03:09:46.094+04	2010-09-19 03:09:46.094+04
00000000-0000-0000-0000-000000000000	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:46.105+04	2010-09-19 03:09:46.105+04
d8c62364-3eb2-4e30-ab42-1417bf9a3c98	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	ac5e0f3f-3f3b-4176-9282-0c87c23a34af	Тест	Тест		2010-09-19 03:09:46.173+04	2010-09-19 03:09:46.173+04
3c4efb78-2231-4be5-9ca8-bdf9ad2315c5	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	ac5e0f3f-3f3b-4176-9282-0c87c23a34af	Спецтест	Спецтест		2010-09-19 03:09:46.175+04	2010-09-19 03:09:46.175+04
bb563626-198d-421d-9a88-d8275cebf29c	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	ac5e0f3f-3f3b-4176-9282-0c87c23a34af	Премьера	Премьера		2010-09-19 03:09:46.178+04	2010-09-19 03:09:46.178+04
0f5d2c40-b44a-4281-8632-e7954aa2913c	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	ac5e0f3f-3f3b-4176-9282-0c87c23a34af	Презентация	Презентация		2010-09-19 03:09:46.181+04	2010-09-19 03:09:46.181+04
54ad3b2e-2f39-4ebd-8695-d703f1d2b271	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	ac5e0f3f-3f3b-4176-9282-0c87c23a34af	Наше знакомство	Наше знакомство		2010-09-19 03:09:46.183+04	2010-09-19 03:09:46.183+04
153537d1-b860-4151-accf-c0049dc578b6	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	ac5e0f3f-3f3b-4176-9282-0c87c23a34af	Высший класс	Высший класс		2010-09-19 03:09:46.185+04	2010-09-19 03:09:46.185+04
a33423d2-8ef0-4876-8808-62226ca19de0	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	ac5e0f3f-3f3b-4176-9282-0c87c23a34af	Авто на час	Авто на час		2010-09-19 03:09:46.187+04	2010-09-19 03:09:46.187+04
b4f7b545-db2a-4e24-9a51-c1d5b67f1b71	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	ac5e0f3f-3f3b-4176-9282-0c87c23a34af	Испытано в деле	Испытано в деле		2010-09-19 03:09:46.19+04	2010-09-19 03:09:46.19+04
93693b06-ec59-4e06-9176-9559c780609c	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	5d73ddb0-0793-4dd0-816f-183a42b04809	Компоненты	Компоненты		2010-09-19 03:09:46.193+04	2010-09-19 03:09:46.193+04
8111c31a-6579-4244-a1a5-73bc6362915d	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	5d73ddb0-0793-4dd0-816f-183a42b04809	Экспертиза	Экспертиза		2010-09-19 03:09:46.196+04	2010-09-19 03:09:46.196+04
45255e4b-b8f1-443a-9fd1-f9776d9b07b3	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	5d73ddb0-0793-4dd0-816f-183a42b04809	Новые товары	Новые товары		2010-09-19 03:09:46.198+04	2010-09-19 03:09:46.198+04
7edeca37-5c06-4049-9d88-0709326d3742	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	5d73ddb0-0793-4dd0-816f-183a42b04809	Электроника	Электроника		2010-09-19 03:09:46.2+04	2010-09-19 03:09:46.2+04
f708501a-f1de-4444-92ac-d1064cbcdc3e	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	5d73ddb0-0793-4dd0-816f-183a42b04809	На прилавке	На прилавке		2010-09-19 03:09:46.202+04	2010-09-19 03:09:46.202+04
1eaab797-d556-4c3a-b55e-a48709e465e4	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	5d73ddb0-0793-4dd0-816f-183a42b04809	Товаровед	Товаровед		2010-09-19 03:09:46.205+04	2010-09-19 03:09:46.205+04
170ee883-5741-4c20-a02d-b12d70e3a6b5	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	5d73ddb0-0793-4dd0-816f-183a42b04809	Проверено ЗР	Проверено ЗР		2010-09-19 03:09:46.208+04	2010-09-19 03:09:46.208+04
408e0d10-0506-44e1-93ac-ff98cd3989e9	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	d1e58723-8fb3-4c12-9a6b-d42fb65b7146	Дегустация	Дегустация		2010-09-19 03:09:46.21+04	2010-09-19 03:09:46.21+04
aceba2fd-71e1-486c-808e-ccc2387fefcc	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	d1e58723-8fb3-4c12-9a6b-d42fb65b7146	Семейство	Семейство		2010-09-19 03:09:46.213+04	2010-09-19 03:09:46.213+04
9b832b42-d9e3-4605-8360-7a5c26bcde5c	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	d1e58723-8fb3-4c12-9a6b-d42fb65b7146	Новости дилеров	Новости дилеров		2010-09-19 03:09:46.215+04	2010-09-19 03:09:46.215+04
90790897-0306-4c7f-97f1-7be840aacdb6	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	d1e58723-8fb3-4c12-9a6b-d42fb65b7146	В деталях	В деталях		2010-09-19 03:09:46.218+04	2010-09-19 03:09:46.218+04
99eb9f8c-45e4-4654-a877-2cde66fdcbb8	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	d1e58723-8fb3-4c12-9a6b-d42fb65b7146	Комплектация	Комплектация		2010-09-19 03:09:46.221+04	2010-09-19 03:09:46.221+04
ca9cbe93-197d-4c60-afe6-c8615301a161	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	d1e58723-8fb3-4c12-9a6b-d42fb65b7146	Парк ЗР	Парк ЗР		2010-09-19 03:09:46.223+04	2010-09-19 03:09:46.223+04
bdf8806a-8200-42a5-bed2-a878b9961a63	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	d1e58723-8fb3-4c12-9a6b-d42fb65b7146	Опции	Опции		2010-09-19 03:09:46.225+04	2010-09-19 03:09:46.225+04
6788f513-93a4-45b2-93fc-9051d67c092a	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	d1e58723-8fb3-4c12-9a6b-d42fb65b7146	Автосалон	Автосалон		2010-09-19 03:09:46.228+04	2010-09-19 03:09:46.228+04
518333ec-a74d-422c-8621-bf79aa461de5	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	7646d5e4-17bb-4c54-b37d-6a50dbddd746	Вы нам писали	Вы нам писали		2010-09-19 03:09:46.23+04	2010-09-19 03:09:46.23+04
3aa12fc2-76b0-42d2-8922-356523b3b5f8	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	7646d5e4-17bb-4c54-b37d-6a50dbddd746	Отвечает Главред	Отвечает Главред		2010-09-19 03:09:46.232+04	2010-09-19 03:09:46.232+04
ecb0773c-43bd-4067-97fa-754f3d981020	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	7646d5e4-17bb-4c54-b37d-6a50dbddd746	Личное мнение	Личное мнение		2010-09-19 03:09:46.235+04	2010-09-19 03:09:46.235+04
33294d26-fe82-41fb-9e58-ca1040327a22	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	25367a60-c3b4-4d0e-b546-33969f2eb274	С миру по гонке	С миру по гонке		2010-09-19 03:09:46.237+04	2010-09-19 03:09:46.237+04
fd14bef2-762f-426d-af6f-73d23104216b	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	25367a60-c3b4-4d0e-b546-33969f2eb274	Ралли	Ралли		2010-09-19 03:09:46.239+04	2010-09-19 03:09:46.239+04
edd6e458-d2d3-494d-bd7c-f0f37f0f2174	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	25367a60-c3b4-4d0e-b546-33969f2eb274	Формула-1	Формула-1		2010-09-19 03:09:46.241+04	2010-09-19 03:09:46.241+04
7607fcf4-06b6-4301-ac2d-86a647af90e9	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	25367a60-c3b4-4d0e-b546-33969f2eb274	Спорт	Спорт		2010-09-19 03:09:46.244+04	2010-09-19 03:09:46.244+04
80b6d6ca-7e3f-43b8-b44e-28503e199c5d	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	25367a60-c3b4-4d0e-b546-33969f2eb274	Кольцевые гонки	Кольцевые гонки		2010-09-19 03:09:46.247+04	2010-09-19 03:09:46.247+04
1e423192-62fa-4bfc-8a27-cc93e02180af	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	963ba0c7-4a37-41d8-9eb6-51bcca9b3e93	Грузовики	Грузовики		2010-09-19 03:09:46.249+04	2010-09-19 03:09:46.249+04
d6a3b8c7-8cdc-4b16-ba03-84c1a84652cb	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	81906f37-5c85-4976-96ac-1065e098b2b9	Интервью	Интервью		2010-09-19 03:09:46.251+04	2010-09-19 03:09:46.251+04
93607672-2973-42bb-b63f-7c5eb16622fa	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	81906f37-5c85-4976-96ac-1065e098b2b9	Экономика-Обозрение	Экономика-Обозрение		2010-09-19 03:09:46.253+04	2010-09-19 03:09:46.253+04
b6e92481-33f5-454d-a1f3-429562c30c86	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	81906f37-5c85-4976-96ac-1065e098b2b9	Новости	Новости		2010-09-19 03:09:46.256+04	2010-09-19 03:09:46.256+04
afcebab8-7bd5-459c-b406-8cb7866cfb77	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	48691883-3e2c-4c99-bdf0-a50d76360d5a	Спорный момент	Спорный момент		2010-09-19 03:09:46.258+04	2010-09-19 03:09:46.258+04
8a8c913c-1a3a-4b05-8cdd-0aca8d2a72dd	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	48691883-3e2c-4c99-bdf0-a50d76360d5a	Следствие ведет ЗР	Следствие ведет ЗР		2010-09-19 03:09:46.261+04	2010-09-19 03:09:46.261+04
9c942caa-16d6-470c-afef-2aed35c4497b	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	48691883-3e2c-4c99-bdf0-a50d76360d5a	Самозащита	Самозащита		2010-09-19 03:09:46.263+04	2010-09-19 03:09:46.263+04
1f1f57ef-fef9-49e2-ba78-0225745f6781	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	48691883-3e2c-4c99-bdf0-a50d76360d5a	Прямая линия	Прямая линия		2010-09-19 03:09:46.266+04	2010-09-19 03:09:46.266+04
364847ca-c2af-42af-bffe-ce63acf2358a	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	48691883-3e2c-4c99-bdf0-a50d76360d5a	Ответы юриста	Ответы юриста		2010-09-19 03:09:46.269+04	2010-09-19 03:09:46.269+04
0c3ba895-d837-47d9-b0b2-a6086b0f7f58	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	48691883-3e2c-4c99-bdf0-a50d76360d5a	Безопасность	Безопасность		2010-09-19 03:09:46.271+04	2010-09-19 03:09:46.271+04
236b2dca-2b59-453b-a858-907f9c48e500	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	48691883-3e2c-4c99-bdf0-a50d76360d5a	Новости	Новости		2010-09-19 03:09:46.275+04	2010-09-19 03:09:46.275+04
caf35b90-d553-49ea-8881-1e2ac4047a7f	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Тест-ремонт	Тест-ремонт		2010-09-19 03:09:46.277+04	2010-09-19 03:09:46.277+04
ed733be5-5256-445b-a637-c20f6d32e211	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Хочу разобраться	Хочу разобраться		2010-09-19 03:09:46.279+04	2010-09-19 03:09:46.279+04
e6f57315-4cda-46ab-98a7-6ba2f048da32	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Мастерская	Мастерская		2010-09-19 03:09:46.281+04	2010-09-19 03:09:46.281+04
0f945beb-abda-4838-8f79-b3515ff12dc8	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Взаимозаменяемость	Взаимозаменяемость		2010-09-19 03:09:46.284+04	2010-09-19 03:09:46.284+04
4d69ebd2-7aa2-4e78-9861-bd798a25e1c4	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Отвечают специалисты	Отвечают специалисты		2010-09-19 03:09:46.287+04	2010-09-19 03:09:46.287+04
52e96412-f2a4-4d8c-9e7f-562f5539426f	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Советы бывалых	Советы бывалых		2010-09-19 03:09:46.289+04	2010-09-19 03:09:46.289+04
bf291f86-3ce7-4b33-b6b3-b2ebf1bf8081	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Доводим	Доводим		2010-09-19 03:09:46.291+04	2010-09-19 03:09:46.291+04
2493931f-5ca9-4cd8-9650-8363692b66a0	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Конкурс	Конкурс		2010-09-19 03:09:46.293+04	2010-09-19 03:09:46.293+04
1225f44f-4e6d-4684-aca5-db5677e45e97	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Форум	Форум		2010-09-19 03:09:46.296+04	2010-09-19 03:09:46.296+04
836b6d49-789f-457e-a2ee-9a49243e604e	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	В деталях	В деталях		2010-09-19 03:09:46.298+04	2010-09-19 03:09:46.298+04
2d259746-21a8-44a4-a62c-4babbd415db2	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Диагностика	Диагностика		2010-09-19 03:09:46.301+04	2010-09-19 03:09:46.301+04
474e4b27-7f02-4639-9a94-fcbe39cd0149	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	b292500a-44a6-47a8-81c0-e851c7c4f7ba	Крайний случай	Крайний случай		2010-09-19 03:09:46.303+04	2010-09-19 03:09:46.303+04
e339c504-39be-45e0-86df-f8e3f8a607a3	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	47fc49d6-0f71-4707-a016-51b04dfc031b	Обозрение	Обозрение		2010-09-19 03:09:46.305+04	2010-09-19 03:09:46.305+04
47aa574c-8172-472f-8f61-cb4f952bc06e	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	47fc49d6-0f71-4707-a016-51b04dfc031b	Концепт-кар	Концепт-кар		2010-09-19 03:09:46.307+04	2010-09-19 03:09:46.307+04
957aa6e1-a0ce-42ea-97b4-e105f7c9f01a	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	47fc49d6-0f71-4707-a016-51b04dfc031b	Технологии	Технологии		2010-09-19 03:09:46.31+04	2010-09-19 03:09:46.31+04
6cc0c210-f397-4de3-853c-3da76b3a3ce6	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	47fc49d6-0f71-4707-a016-51b04dfc031b	Новинки	Новинки	Новинки, исследования, изобретения	2010-09-19 03:09:46.313+04	2010-09-19 03:09:46.313+04
bcd866a1-73ca-4c9b-92d2-4084da061fe3	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	7dd64509-85ee-4934-b143-f6e6dc70a40b	Без границ	Без границ		2010-09-19 03:09:46.315+04	2010-09-19 03:09:46.315+04
6886017a-e446-459a-96af-b0e7b674a34c	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	7dd64509-85ee-4934-b143-f6e6dc70a40b	Живые классики	Живые классики		2010-09-19 03:09:46.317+04	2010-09-19 03:09:46.317+04
bceeb8a6-b56e-4080-8be1-afa40e1a891a	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	7dd64509-85ee-4934-b143-f6e6dc70a40b	Эксперимент	Эксперимент		2010-09-19 03:09:46.32+04	2010-09-19 03:09:46.32+04
c4f0ab9a-23ec-4d44-bdaa-093afa89d76e	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	7dd64509-85ee-4934-b143-f6e6dc70a40b	Путешествие	Путешествие		2010-09-19 03:09:46.322+04	2010-09-19 03:09:46.322+04
090cae8a-0ea8-425e-940c-c6fef6a84f6e	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	d5bee9c7-89bf-49f7-8816-044155108288	Цены ЗР	Цены ЗР		2010-09-19 03:09:46.325+04	2010-09-19 03:09:46.325+04
fda9a808-dd38-4b42-ae53-1d4b05742a7d	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	1e07cba9-556d-45b9-b37d-bf17e1f79668	На гребне моды	На гребне моды		2010-09-19 03:09:46.328+04	2010-09-19 03:09:46.328+04
f0819fcd-3dc1-4257-a94a-d804d13a4e68	7c19709f-e8ff-42ee-ad81-3c4b5ed89901	1e07cba9-556d-45b9-b37d-bf17e1f79668	Тюнинг	Тюнинг		2010-09-19 03:09:46.33+04	2010-09-19 03:09:46.33+04
00000000-0000-0000-0000-000000000000	22abeebf-f805-4140-b1ac-52dd782b8362	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:46.342+04	2010-09-19 03:09:46.342+04
a0b14985-0d5e-4378-a8d1-a811b479cb90	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	В курсе событий	В курсе событий		2010-09-19 03:09:46.383+04	2010-09-19 03:09:46.383+04
29f5a11c-e592-48ff-88df-a253063e2aef	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Новости	Новости		2010-09-19 03:09:46.385+04	2010-09-19 03:09:46.385+04
355720d5-4855-44c1-a008-b77636f8691e	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Конференция	Конференция		2010-09-19 03:09:46.388+04	2010-09-19 03:09:46.388+04
f435e6ea-191e-40eb-b557-72f1346e7cea	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Особое внимание	Особое внимание		2010-09-19 03:09:46.391+04	2010-09-19 03:09:46.391+04
52823f4c-6135-4d58-9874-afeff6e8d118	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Кадры	Кадры		2010-09-19 03:09:46.394+04	2010-09-19 03:09:46.394+04
a7b5ab03-5416-459e-b4f4-fcaec01f5b8c	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Безопасность	Безопасность		2010-09-19 03:09:46.397+04	2010-09-19 03:09:46.397+04
6327aa50-d607-44f9-b01b-c8b7431b4e3d	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Лизинг	Лизинг		2010-09-19 03:09:46.399+04	2010-09-19 03:09:46.399+04
72afa9ee-4c90-46f8-985e-8d5fe4c6f623	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Страхование	Страхование		2010-09-19 03:09:46.402+04	2010-09-19 03:09:46.402+04
3059d5de-98e2-4713-8dbc-8767ae222b99	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Налоги	Налоги		2010-09-19 03:09:46.404+04	2010-09-19 03:09:46.404+04
dd6bb88f-9385-4a56-8ca9-e568a304a30f	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Логистика	Логистика		2010-09-19 03:09:46.407+04	2010-09-19 03:09:46.407+04
5ea616c6-46e8-4b94-9238-95f985f0f61b	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Гарантия	Гарантия		2010-09-19 03:09:46.41+04	2010-09-19 03:09:46.41+04
bf23578a-f673-45a0-8da4-6a3124d3e6a8	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Перевозки	Перевозки		2010-09-19 03:09:46.412+04	2010-09-19 03:09:46.412+04
bbded37d-71b9-40ea-8f87-626b8ce6ef2a	22abeebf-f805-4140-b1ac-52dd782b8362	90686def-fb0f-43a3-8311-4e1055751ea5	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:46.415+04	2010-09-19 03:09:46.415+04
e141c31d-e178-47d3-bb2f-a4f6c40c88a3	22abeebf-f805-4140-b1ac-52dd782b8362	90e25c98-9a2c-4ac5-ade5-09b26f50f64a	Tyrex Trophy	Tyrex Trophy		2010-09-19 03:09:46.418+04	2010-09-19 03:09:46.418+04
4589a283-9049-41d5-9922-04cb5122d74d	22abeebf-f805-4140-b1ac-52dd782b8362	90e25c98-9a2c-4ac5-ade5-09b26f50f64a	УМЗ-4216	УМЗ-4216		2010-09-19 03:09:46.421+04	2010-09-19 03:09:46.421+04
57f715c3-9976-4de0-880f-816fe5f0f85f	22abeebf-f805-4140-b1ac-52dd782b8362	90e25c98-9a2c-4ac5-ade5-09b26f50f64a	GoodYear	GoodYear		2010-09-19 03:09:46.423+04	2010-09-19 03:09:46.423+04
ce33d524-aab6-47b9-8d25-eb4a575a0633	22abeebf-f805-4140-b1ac-52dd782b8362	32e780fc-d474-4313-b1b8-e2ec54539f6b	Премьера	Премьера		2010-09-19 03:09:46.425+04	2010-09-19 03:09:46.425+04
366ee130-7946-4f45-b282-318b6c67ab4c	22abeebf-f805-4140-b1ac-52dd782b8362	32e780fc-d474-4313-b1b8-e2ec54539f6b	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:46.427+04	2010-09-19 03:09:46.427+04
4d0a9608-5313-4950-8666-0203c9a9f637	22abeebf-f805-4140-b1ac-52dd782b8362	32e780fc-d474-4313-b1b8-e2ec54539f6b	Новости	Новости		2010-09-19 03:09:46.43+04	2010-09-19 03:09:46.43+04
a3acee09-570e-42fc-a524-1b585bd0a75b	22abeebf-f805-4140-b1ac-52dd782b8362	32e780fc-d474-4313-b1b8-e2ec54539f6b	Опыт эксплуатации	Опыт эксплуатации		2010-09-19 03:09:46.432+04	2010-09-19 03:09:46.432+04
2c30d5aa-31c0-4547-a110-3f1eac8dab77	22abeebf-f805-4140-b1ac-52dd782b8362	32e780fc-d474-4313-b1b8-e2ec54539f6b	Конкуренты с востока	Конкуренты с востока		2010-09-19 03:09:46.435+04	2010-09-19 03:09:46.435+04
998ab4a4-c1a7-458c-99b0-f96d6627129d	22abeebf-f805-4140-b1ac-52dd782b8362	32e780fc-d474-4313-b1b8-e2ec54539f6b	Пассажирские перевозки	Пассажирские перевозки		2010-09-19 03:09:46.437+04	2010-09-19 03:09:46.437+04
1e075c47-0b89-4269-8929-2fcf43722810	22abeebf-f805-4140-b1ac-52dd782b8362	32e780fc-d474-4313-b1b8-e2ec54539f6b	Прицепы	Прицепы		2010-09-19 03:09:46.439+04	2010-09-19 03:09:46.439+04
ad076986-ce3f-45a7-9067-1697eee11129	22abeebf-f805-4140-b1ac-52dd782b8362	859451a9-8f1f-45fc-bec0-167bf0484cb3	Прицепы	Прицепы		2010-09-19 03:09:46.442+04	2010-09-19 03:09:46.442+04
7f2575c3-4dbb-4bed-a20e-442cac98280f	22abeebf-f805-4140-b1ac-52dd782b8362	859451a9-8f1f-45fc-bec0-167bf0484cb3	Новости	Новости		2010-09-19 03:09:46.444+04	2010-09-19 03:09:46.444+04
48ad6fd9-58a2-4c65-a7bc-c6da6443ef36	22abeebf-f805-4140-b1ac-52dd782b8362	859451a9-8f1f-45fc-bec0-167bf0484cb3	Без комментариев	Без комментариев		2010-09-19 03:09:46.448+04	2010-09-19 03:09:46.448+04
fd59e885-1cdc-436a-8eac-f74e69535718	22abeebf-f805-4140-b1ac-52dd782b8362	859451a9-8f1f-45fc-bec0-167bf0484cb3	Компоненты	Компоненты		2010-09-19 03:09:46.45+04	2010-09-19 03:09:46.45+04
3a1ac649-37c3-4390-8a8c-5e0787080251	22abeebf-f805-4140-b1ac-52dd782b8362	859451a9-8f1f-45fc-bec0-167bf0484cb3	Бизнес в России	Бизнес в России		2010-09-19 03:09:46.452+04	2010-09-19 03:09:46.452+04
3d7d62cf-69f6-4036-8f8b-181ac45d50e2	22abeebf-f805-4140-b1ac-52dd782b8362	859451a9-8f1f-45fc-bec0-167bf0484cb3	Масла	Масла		2010-09-19 03:09:46.455+04	2010-09-19 03:09:46.455+04
dd883a8f-e2a3-47f2-9f31-21a59500cff0	22abeebf-f805-4140-b1ac-52dd782b8362	859451a9-8f1f-45fc-bec0-167bf0484cb3	Шины	Шины		2010-09-19 03:09:46.457+04	2010-09-19 03:09:46.457+04
a82687c3-d9c6-425d-8420-119543700ae8	22abeebf-f805-4140-b1ac-52dd782b8362	859451a9-8f1f-45fc-bec0-167bf0484cb3	Пристальный взгляд	Пристальный взгляд		2010-09-19 03:09:46.46+04	2010-09-19 03:09:46.46+04
b407cea9-edd8-43a3-9840-9ed8ddfe1d0a	22abeebf-f805-4140-b1ac-52dd782b8362	ce2260cd-0340-4ccd-9a7f-7cd62ed960d4	Новости	Новости		2010-09-19 03:09:46.462+04	2010-09-19 03:09:46.462+04
d6192937-a784-4879-92f7-933a08d90877	22abeebf-f805-4140-b1ac-52dd782b8362	ce2260cd-0340-4ccd-9a7f-7cd62ed960d4	Масла	Масла		2010-09-19 03:09:46.464+04	2010-09-19 03:09:46.464+04
c0f9a0ca-9727-4c46-b602-40a55fc2ef21	22abeebf-f805-4140-b1ac-52dd782b8362	ce2260cd-0340-4ccd-9a7f-7cd62ed960d4	Шины	Шины		2010-09-19 03:09:46.467+04	2010-09-19 03:09:46.467+04
f98b2008-b613-4601-809e-e7f479716a03	22abeebf-f805-4140-b1ac-52dd782b8362	ce2260cd-0340-4ccd-9a7f-7cd62ed960d4	АКБ	АКБ		2010-09-19 03:09:46.47+04	2010-09-19 03:09:46.47+04
e3045e7b-d346-403a-863d-77772bc8d441	22abeebf-f805-4140-b1ac-52dd782b8362	ce2260cd-0340-4ccd-9a7f-7cd62ed960d4	Ремзона	Ремзона		2010-09-19 03:09:46.473+04	2010-09-19 03:09:46.473+04
c0fd988c-8d24-4650-96f8-df42e62bc6b8	22abeebf-f805-4140-b1ac-52dd782b8362	ce2260cd-0340-4ccd-9a7f-7cd62ed960d4	Оборудование	Оборудование		2010-09-19 03:09:46.475+04	2010-09-19 03:09:46.475+04
f330f5d0-6ea3-418c-b824-42ae8a2607d6	22abeebf-f805-4140-b1ac-52dd782b8362	ce2260cd-0340-4ccd-9a7f-7cd62ed960d4	Агрегаты	Агрегаты		2010-09-19 03:09:46.477+04	2010-09-19 03:09:46.477+04
00000000-0000-0000-0000-000000000000	f9cfd971-ea52-47b3-90dd-6a31c03579db	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:46.489+04	2010-09-19 03:09:46.489+04
6aace513-c9c2-4796-96de-1d51af80ae49	f9cfd971-ea52-47b3-90dd-6a31c03579db	622c810d-ffda-4431-aaf2-62ef1790edd1	Тест	Тест		2010-09-19 03:09:46.54+04	2010-09-19 03:09:46.54+04
19e94ec6-8400-4eb9-8ea6-e3e01e120cb6	f9cfd971-ea52-47b3-90dd-6a31c03579db	622c810d-ffda-4431-aaf2-62ef1790edd1	Супертест	Супертест		2010-09-19 03:09:46.542+04	2010-09-19 03:09:46.542+04
4e435d63-e34c-4e9c-a655-3e56a9a73169	f9cfd971-ea52-47b3-90dd-6a31c03579db	622c810d-ffda-4431-aaf2-62ef1790edd1	Сравнение	Сравнение		2010-09-19 03:09:46.545+04	2010-09-19 03:09:46.545+04
cc6e4e75-9059-4c56-86f6-b49d8ddee4c2	f9cfd971-ea52-47b3-90dd-6a31c03579db	622c810d-ffda-4431-aaf2-62ef1790edd1	Тест-драйв	Тест-драйв		2010-09-19 03:09:46.549+04	2010-09-19 03:09:46.549+04
1a952eb6-7a2e-4099-b623-080ec5646a27	f9cfd971-ea52-47b3-90dd-6a31c03579db	622c810d-ffda-4431-aaf2-62ef1790edd1	Спецтест	Спецтест		2010-09-19 03:09:46.551+04	2010-09-19 03:09:46.551+04
cdb56129-1d08-4480-88d2-253bae167754	f9cfd971-ea52-47b3-90dd-6a31c03579db	4d546462-8b4c-412f-8875-d872ad2b302b	Новости	Новости		2010-09-19 03:09:46.554+04	2010-09-19 03:09:46.554+04
6bb8847c-7d59-43c2-8015-cfa7fdf18955	f9cfd971-ea52-47b3-90dd-6a31c03579db	4d546462-8b4c-412f-8875-d872ad2b302b	Мнение	Мнение		2010-09-19 03:09:46.569+04	2010-09-19 03:09:46.569+04
3c1212c0-2515-43e4-88b4-2a17f89fc1fb	f9cfd971-ea52-47b3-90dd-6a31c03579db	cb2e3a60-ae1f-4a2f-8f1c-da137440ab57	Анонс	Анонс		2010-09-19 03:09:46.572+04	2010-09-19 03:09:46.572+04
c6337914-1cfe-47e2-89f2-7251dc87bc2f	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Спидвей	Спидвей		2010-09-19 03:09:46.574+04	2010-09-19 03:09:46.574+04
9f217426-8593-4d46-bfc0-8907710a1bf9	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Снегоходы	Снегоходы		2010-09-19 03:09:46.577+04	2010-09-19 03:09:46.577+04
6265d12b-2370-473c-be30-bafff411a9ca	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Новости	Новости		2010-09-19 03:09:46.58+04	2010-09-19 03:09:46.58+04
291458d3-0322-436a-826b-6706dd0e15a3	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Ралли-рейд	Ралли-рейд		2010-09-19 03:09:46.582+04	2010-09-19 03:09:46.582+04
8c95f67d-8014-4be3-b201-5ce801c8ce6e	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Кольцо	Кольцо		2010-09-19 03:09:46.584+04	2010-09-19 03:09:46.584+04
fe7735d2-f9d3-4c19-bbbe-52da6871bd5f	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Эндуро	Эндуро		2010-09-19 03:09:46.587+04	2010-09-19 03:09:46.587+04
c329d6b2-c41a-41f1-8b0f-b80ad2e7eb98	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Мотобол	Мотобол		2010-09-19 03:09:46.589+04	2010-09-19 03:09:46.589+04
fd29b9b9-1094-4b9a-9818-90b29bbcef67	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Мото GP	Мото GP		2010-09-19 03:09:46.592+04	2010-09-19 03:09:46.592+04
19d742de-8825-4229-8f22-03bc1224c66c	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	История	История		2010-09-19 03:09:46.594+04	2010-09-19 03:09:46.594+04
4362b519-5e7f-4bda-ba22-c046f9e74c5d	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Кросс	Кросс		2010-09-19 03:09:46.597+04	2010-09-19 03:09:46.597+04
be722d94-0098-463a-81fd-9793e02369c3	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Супербайк	Супербайк		2010-09-19 03:09:46.599+04	2010-09-19 03:09:46.599+04
09ea76a5-668c-4410-bc83-b141b0fc0348	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Гонки на льду	Гонки на льду		2010-09-19 03:09:46.602+04	2010-09-19 03:09:46.602+04
7937dd91-828b-4de9-bdbb-b2b1e80b7073	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Фристайл	Фристайл		2010-09-19 03:09:46.605+04	2010-09-19 03:09:46.605+04
0e9ee98f-729d-4b56-ac13-ad41317f7cf0	f9cfd971-ea52-47b3-90dd-6a31c03579db	c7d45ef4-8cc9-441f-a080-fcccac6a1aed	Трек-тест	Трек-тест		2010-09-19 03:09:46.607+04	2010-09-19 03:09:46.607+04
f8122e12-b887-4e31-b0b2-86521f5407bf	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Механик	Механик		2010-09-19 03:09:46.609+04	2010-09-19 03:09:46.609+04
34e80a67-bc8f-469f-b4bb-429eeca9fbce	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Вопрос-ответ	Вопрос-ответ		2010-09-19 03:09:46.612+04	2010-09-19 03:09:46.612+04
54a72b45-d22e-4182-b876-feef84a31184	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Опыт	Опыт		2010-09-19 03:09:46.615+04	2010-09-19 03:09:46.615+04
ea453562-b40d-45c3-9c01-472c0e93d31b	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Ремзона	Ремзона		2010-09-19 03:09:46.617+04	2010-09-19 03:09:46.617+04
7e381a98-1a0d-4a6b-ac20-a52de5d0eebd	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Эксклюзив	Эксклюзив		2010-09-19 03:09:46.62+04	2010-09-19 03:09:46.62+04
1107cf7c-e0a9-48e6-a482-f3f63ee34b91	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Имидж	Имидж		2010-09-19 03:09:46.622+04	2010-09-19 03:09:46.622+04
f0894379-dbd1-4308-879b-9558e92af9f0	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Отвал башки!	Отвал башки!		2010-09-19 03:09:46.624+04	2010-09-19 03:09:46.624+04
c89912bd-2bae-4f2c-aae0-762f2d60beac	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Строим эндуро	Строим эндуро		2010-09-19 03:09:46.627+04	2010-09-19 03:09:46.627+04
a2229605-9650-4814-8dc4-dd3eca59a636	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Мозгодром	Мозгодром		2010-09-19 03:09:46.63+04	2010-09-19 03:09:46.63+04
a6a4ac7d-2546-423c-b87e-f63689b2d89f	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Академия	Академия		2010-09-19 03:09:46.632+04	2010-09-19 03:09:46.632+04
b6d96a52-d143-4cde-bfce-f7faecc92f44	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Кросс	Кросс		2010-09-19 03:09:46.634+04	2010-09-19 03:09:46.634+04
6755fdf1-d4c7-4c20-8675-841cd7d26646	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Тюнинг	Тюнинг		2010-09-19 03:09:46.637+04	2010-09-19 03:09:46.637+04
a3efbcf7-8113-4fcf-9f52-9cf46d338540	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Регламент	Регламент		2010-09-19 03:09:46.639+04	2010-09-19 03:09:46.639+04
f107219c-f1f3-44e4-900d-6cdc4f6382ac	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Доводим	Доводим		2010-09-19 03:09:46.642+04	2010-09-19 03:09:46.642+04
606b3670-1299-481b-af58-1d1502bff32a	f9cfd971-ea52-47b3-90dd-6a31c03579db	53c0806f-d4be-4c59-b0a3-9260a7a52ae6	Оборудование	Оборудование		2010-09-19 03:09:46.645+04	2010-09-19 03:09:46.645+04
771f2795-2ef4-4d20-b129-1b03ab04fe01	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Спор	Спор		2010-09-19 03:09:46.647+04	2010-09-19 03:09:46.647+04
645531d9-c1b1-4301-98e4-c596d3ac8270	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Криминал	Криминал		2010-09-19 03:09:46.649+04	2010-09-19 03:09:46.649+04
7808b3bf-da75-4b2c-86fa-7c9f8fe0a211	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Изо	Изо		2010-09-19 03:09:46.651+04	2010-09-19 03:09:46.651+04
779c11ac-8834-4eac-bb70-5c599d131cec	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	CD на колесах	CD на колесах		2010-09-19 03:09:46.654+04	2010-09-19 03:09:46.654+04
8e265980-778d-4d62-85a8-466be2b56308	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Клуб-инфо	Клуб-инфо		2010-09-19 03:09:46.657+04	2010-09-19 03:09:46.657+04
be04fbeb-f259-4d08-8ad3-835c4bb1d342	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Один из нас	Один из нас		2010-09-19 03:09:46.659+04	2010-09-19 03:09:46.659+04
1b3d36e5-a53c-44ed-bc1e-c956a44cc129	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Звезды на мотоциклах	Звезды на мотоциклах		2010-09-19 03:09:46.661+04	2010-09-19 03:09:46.661+04
65ce4e8b-5f35-4485-9e4f-d6c2657988c7	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Человек-легенда	Человек-легенда		2010-09-19 03:09:46.664+04	2010-09-19 03:09:46.664+04
ff82a622-cef4-495d-b2c0-fb38539b5a7e	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Игра по-крупному	Игра по-крупному		2010-09-19 03:09:46.667+04	2010-09-19 03:09:46.667+04
ed4ca81f-1a59-4c1c-9c5a-ff5725e87d59	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Консультация	Консультация		2010-09-19 03:09:46.67+04	2010-09-19 03:09:46.67+04
12fcbf6f-b7c7-4a35-bf71-d5960da080c2	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Суперсамопал	Суперсамопал		2010-09-19 03:09:46.672+04	2010-09-19 03:09:46.672+04
4deccd17-0990-4ad4-a8e0-a63608cd0bc9	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	"Гвоздь" сезона	"Гвоздь" сезона		2010-09-19 03:09:46.675+04	2010-09-19 03:09:46.675+04
751888d7-8c14-4ab5-99f8-1310ae779769	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Экстрим-тур	Экстрим-тур		2010-09-19 03:09:46.677+04	2010-09-19 03:09:46.677+04
2cf0effd-3f8d-4f86-b63e-c98c8f6f0d10	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Конкурс читателей	Конкурс читателей		2010-09-19 03:09:46.68+04	2010-09-19 03:09:46.68+04
2bd6abd4-9d90-4de4-9db6-5a0ef44e24d6	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Экспертиза	Экспертиза		2010-09-19 03:09:46.683+04	2010-09-19 03:09:46.683+04
96bacbe8-95bf-406b-bbcc-97537a3d97a0	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Прилавок	Прилавок		2010-09-19 03:09:46.685+04	2010-09-19 03:09:46.685+04
5ed766d0-bd6b-426b-adcd-9f1cb70d45c7	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Мотай на ус!	Мотай на ус!		2010-09-19 03:09:46.687+04	2010-09-19 03:09:46.687+04
a4e31c3a-97f5-47bc-9a80-abaf796e8e74	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Не обманись!	Не обманись!		2010-09-19 03:09:46.69+04	2010-09-19 03:09:46.69+04
64ef171b-1041-47a6-ad13-89841cb058dd	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Юрспас	Юрспас		2010-09-19 03:09:46.693+04	2010-09-19 03:09:46.693+04
d31d3a1f-cb3f-4d07-bef5-5868510293bd	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Экстрим	Экстрим		2010-09-19 03:09:46.696+04	2010-09-19 03:09:46.696+04
b3975834-9ce1-4701-bb68-95fe3872d76c	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	MY'ZONE	MY'ZONE		2010-09-19 03:09:46.699+04	2010-09-19 03:09:46.699+04
dcef5ecb-895d-4686-b461-1842e01c8d60	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Ищите пятницу	Ищите пятницу		2010-09-19 03:09:46.701+04	2010-09-19 03:09:46.701+04
0e26b5ee-896e-4896-8b64-562f0326d31a	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Барахолка	Барахолка		2010-09-19 03:09:46.703+04	2010-09-19 03:09:46.703+04
3b70271b-4582-4be6-9641-cfaf5891c059	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	По городам и весям	По городам и весям		2010-09-19 03:09:46.705+04	2010-09-19 03:09:46.705+04
2c9fb8dd-dd9e-40b6-aa6f-d92e925b67c4	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	От очевидца	От очевидца		2010-09-19 03:09:46.708+04	2010-09-19 03:09:46.708+04
68018973-4f6e-4aec-bd29-1e391d179cb0	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Мастер-пилот	Мастер-пилот		2010-09-19 03:09:46.71+04	2010-09-19 03:09:46.71+04
506d50d9-52b9-4d3b-ab6b-2e4295d4c6b8	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Зимний адреналин	Зимний адреналин		2010-09-19 03:09:46.713+04	2010-09-19 03:09:46.713+04
76af5d44-d786-4b5c-88aa-cd6bb6a29cc9	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Увековечим	Увековечим		2010-09-19 03:09:46.715+04	2010-09-19 03:09:46.715+04
613073ae-40fa-4277-ada6-b94e5761afe9	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Распахнутый мир	Распахнутый мир		2010-09-19 03:09:46.717+04	2010-09-19 03:09:46.717+04
e4b44e27-d5e9-4e77-b339-b4a1e64c0095	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Мини-путешествие	Мини-путешествие		2010-09-19 03:09:46.72+04	2010-09-19 03:09:46.72+04
a10dc1c1-ff6f-4eb9-a1b9-0867f40ef9a3	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Безопасность	Безопасность		2010-09-19 03:09:46.723+04	2010-09-19 03:09:46.723+04
190490e8-b029-42d6-bb87-1ad33e669f9b	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Актуально	Актуально		2010-09-19 03:09:46.725+04	2010-09-19 03:09:46.725+04
6c1b3cdf-609d-4dbd-b857-00b6205325e4	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Заграница	Заграница		2010-09-19 03:09:46.727+04	2010-09-19 03:09:46.727+04
7bc4ef80-361e-4004-8ec2-e7d9520e0f22	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Клубная жизнь	Клубная жизнь		2010-09-19 03:09:46.729+04	2010-09-19 03:09:46.729+04
980d56c6-0610-4ead-bddc-c65a3e1a830c	f9cfd971-ea52-47b3-90dd-6a31c03579db	a1fc0ada-0493-4d2d-8d4c-5bc1d5991d7c	Нам пишут	Нам пишут		2010-09-19 03:09:46.732+04	2010-09-19 03:09:46.732+04
bd5ff06b-321f-481e-b428-0d474e20c2f0	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Стоп линия	Стоп линия		2010-09-19 03:09:46.734+04	2010-09-19 03:09:46.734+04
3361b74e-4b49-4f7b-b3e5-2f95c738a002	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	С комфортом	С комфортом		2010-09-19 03:09:46.737+04	2010-09-19 03:09:46.737+04
41b2b0a1-2aab-4107-bfb4-ebecb9b0f7d0	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Модельный гид	Модельный гид		2010-09-19 03:09:46.739+04	2010-09-19 03:09:46.739+04
1bec9a1e-a671-489d-ba43-c2c66c3ed8d9	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Бенефис диллера	Бенефис диллера		2010-09-19 03:09:46.741+04	2010-09-19 03:09:46.741+04
9193e389-f1b5-45ec-8108-19f9b69b0e9f	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Книжная полка	Книжная полка		2010-09-19 03:09:46.744+04	2010-09-19 03:09:46.744+04
e3f076d3-c523-45d0-ab7f-e3e3230d7203	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Береги себя, родного!	Береги себя, родного!		2010-09-19 03:09:46.747+04	2010-09-19 03:09:46.747+04
9b67f88b-b553-4f99-a603-beb9c2102eca	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Вердикт	Вердикт		2010-09-19 03:09:46.75+04	2010-09-19 03:09:46.75+04
c99e0d1e-2909-4184-88a6-0a3354886c8f	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Памятка покупателю	Памятка покупателю		2010-09-19 03:09:46.752+04	2010-09-19 03:09:46.752+04
94ef0c91-362e-4d61-a85a-20e9a12c4c2b	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Проблема выбора	Проблема выбора		2010-09-19 03:09:46.754+04	2010-09-19 03:09:46.754+04
9ff6697e-a3f2-4b63-9b91-2e8602529b79	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Статистика	Статистика		2010-09-19 03:09:46.756+04	2010-09-19 03:09:46.756+04
85916367-ab0c-43c9-a042-b9d97bf836ff	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Цены "Мото"	Цены "Мото"		2010-09-19 03:09:46.759+04	2010-09-19 03:09:46.759+04
d1fee299-dedc-4c96-a89f-bbcaa35b72c6	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Из первых уст	Из первых уст		2010-09-19 03:09:46.761+04	2010-09-19 03:09:46.761+04
0c19a9a7-dfa6-4ee3-abb0-b9de7dda1567	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	VIP-холл	VIP-холл		2010-09-19 03:09:46.764+04	2010-09-19 03:09:46.764+04
8d3a08e7-f6b8-44f7-b0f6-0a5d16f1b5b7	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Брэнд	Брэнд		2010-09-19 03:09:46.766+04	2010-09-19 03:09:46.766+04
23192118-0c34-446d-9879-a4eca3604162	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Досье	Досье		2010-09-19 03:09:46.769+04	2010-09-19 03:09:46.769+04
e86b6677-5ad9-4a89-9331-38f843bf715b	f9cfd971-ea52-47b3-90dd-6a31c03579db	383fee1c-42b2-409d-a765-8fdb81d16226	Выбираем	Выбираем		2010-09-19 03:09:46.772+04	2010-09-19 03:09:46.772+04
88776b84-9fdb-4fc1-a246-88bfee766bdf	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Новости	Новости		2010-09-19 03:09:46.774+04	2010-09-19 03:09:46.774+04
2a98ee68-d7c4-4d5b-93d1-6032d4f570f0	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Интеграция	Интеграция		2010-09-19 03:09:46.777+04	2010-09-19 03:09:46.777+04
fd2396cf-394f-43b3-bc7e-0b0aa5ff1ade	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Мы и мотоциклы	Мы и мотоциклы		2010-09-19 03:09:46.779+04	2010-09-19 03:09:46.779+04
d8728ad8-2644-49d1-8463-52085b36ce93	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Актуально	Актуально		2010-09-19 03:09:46.781+04	2010-09-19 03:09:46.781+04
3d85ae04-2ea6-4c2f-9334-e7c95c687dca	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Тест	Тест		2010-09-19 03:09:46.784+04	2010-09-19 03:09:46.784+04
d9083d0e-360e-4f14-8063-d9a6768d6060	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Тест-райд	Тест-райд		2010-09-19 03:09:46.786+04	2010-09-19 03:09:46.786+04
8c9eedf3-71b1-45bb-8d85-322dea5ab2b7	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Секонд-тест	Секонд-тест		2010-09-19 03:09:46.789+04	2010-09-19 03:09:46.789+04
9a095339-6282-421e-ab35-877fd8bd9e7f	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Испытания	Испытания		2010-09-19 03:09:46.791+04	2010-09-19 03:09:46.791+04
7f65ab5d-f8f6-44a9-a35e-e2950a5b5480	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Экзотика	Экзотика		2010-09-19 03:09:46.793+04	2010-09-19 03:09:46.793+04
8b3d137e-6333-401e-b841-13cf9c0cc847	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Кунсткамера	Кунсткамера		2010-09-19 03:09:46.796+04	2010-09-19 03:09:46.796+04
1fe42976-eba5-45be-8803-95cce6fd718a	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Тюнинг	Тюнинг		2010-09-19 03:09:46.798+04	2010-09-19 03:09:46.798+04
d8e7e877-0014-44d2-9ab3-233f80b024d9	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Подиум	Подиум		2010-09-19 03:09:46.802+04	2010-09-19 03:09:46.802+04
93839eee-a4ee-49e9-a7c1-ce3e6c375a82	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Внутренние дела	Внутренние дела		2010-09-19 03:09:46.804+04	2010-09-19 03:09:46.804+04
36b3dcf5-f166-452f-9434-99e69195da18	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Не понаслышке	Не понаслышке		2010-09-19 03:09:46.806+04	2010-09-19 03:09:46.806+04
164e08e9-8fb3-47ac-b0dc-dca4fd74ac81	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Русский проект	Русский проект		2010-09-19 03:09:46.808+04	2010-09-19 03:09:46.808+04
0db567cd-1ed0-42a6-be52-4fe1822f4d8b	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Kit-парад	Kit-парад		2010-09-19 03:09:46.811+04	2010-09-19 03:09:46.811+04
5847882c-1635-45b4-bbcf-a385d9680a42	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Дизайн-центр	Дизайн-центр		2010-09-19 03:09:46.814+04	2010-09-19 03:09:46.814+04
512acbc8-2799-482e-868a-f9f240cf7945	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Динамит-клуб	Динамит-клуб		2010-09-19 03:09:46.816+04	2010-09-19 03:09:46.816+04
6471bff1-db45-4b23-9827-5ac0374092c2	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Дегустация	Дегустация		2010-09-19 03:09:46.818+04	2010-09-19 03:09:46.818+04
9db7bac1-e8b9-43d1-b1da-dbb7dd003019	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Спецназ	Спецназ		2010-09-19 03:09:46.82+04	2010-09-19 03:09:46.82+04
4a1917d5-f481-4d9b-bdc8-2a32a7040794	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Железный марш	Железный марш		2010-09-19 03:09:46.823+04	2010-09-19 03:09:46.823+04
9113534a-7663-4bda-ab00-90ef2bcfe368	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Кто на новенького?	Кто на новенького?		2010-09-19 03:09:46.826+04	2010-09-19 03:09:46.826+04
66028217-e05b-43b8-b0a2-1f385ce22aa7	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Топ-модель	Топ-модель		2010-09-19 03:09:46.829+04	2010-09-19 03:09:46.829+04
55a23da1-aec4-408f-ac8a-7e5bc32439fa	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Скутерьма	Скутерьма		2010-09-19 03:09:46.831+04	2010-09-19 03:09:46.831+04
bb356f3e-db0e-4408-bc76-2c673f63d099	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Скутермания	Скутермания		2010-09-19 03:09:46.834+04	2010-09-19 03:09:46.834+04
49f2e683-73e2-4eab-a777-3b2379459a97	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Униккумы	Униккумы		2010-09-19 03:09:46.837+04	2010-09-19 03:09:46.837+04
236c6510-5289-45cc-aaa4-6174eae7ef06	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Инорынок	Инорынок		2010-09-19 03:09:46.84+04	2010-09-19 03:09:46.84+04
e567b32f-9b2e-4a74-a8c5-56336c992819	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Загранка	Загранка		2010-09-19 03:09:46.842+04	2010-09-19 03:09:46.842+04
0eab70c4-33d4-4ee3-ad02-2f63b9475951	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Резонанс	Резонанс		2010-09-19 03:09:46.844+04	2010-09-19 03:09:46.844+04
6e87d907-99de-4ed5-b701-9956ba7e2bea	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Форсаж	Форсаж		2010-09-19 03:09:46.847+04	2010-09-19 03:09:46.847+04
e9d6caa0-9e46-4a0f-869d-edc248fc4e74	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Книжная полка	Книжная полка		2010-09-19 03:09:46.85+04	2010-09-19 03:09:46.85+04
5ded317d-d226-43fb-9533-238e3832791c	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Культ масс	Культ масс		2010-09-19 03:09:46.852+04	2010-09-19 03:09:46.852+04
302e56c0-e639-4e3d-ad79-c9c0f7d3c80f	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Дебют	Дебют		2010-09-19 03:09:46.855+04	2010-09-19 03:09:46.855+04
3061d330-7432-4509-9c38-f88cd3445d9b	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Preview	Preview		2010-09-19 03:09:46.857+04	2010-09-19 03:09:46.857+04
f22d32e5-6302-46a5-adcc-aa7b88008de1	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Эволюция	Эволюция		2010-09-19 03:09:46.859+04	2010-09-19 03:09:46.859+04
79df4c49-d02b-40b3-a988-386dbe6ff148	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Вернисаж	Вернисаж		2010-09-19 03:09:46.862+04	2010-09-19 03:09:46.862+04
5eceea55-d8fb-4c81-995f-889d41852937	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Красотищща	Красотищща		2010-09-19 03:09:46.865+04	2010-09-19 03:09:46.865+04
69a3215f-8b12-4aaa-b3f1-502947a85574	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Беда!	Беда!		2010-09-19 03:09:46.868+04	2010-09-19 03:09:46.868+04
bf406869-5316-418c-8dc8-87f22342f8ee	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Рождение жанра	Рождение жанра		2010-09-19 03:09:46.87+04	2010-09-19 03:09:46.87+04
99dd4801-97c9-4b1c-ae3d-059a233098f2	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Самопал	Самопал		2010-09-19 03:09:46.872+04	2010-09-19 03:09:46.872+04
55ef3525-ef58-45ba-8599-63c01530b194	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Практическая польза	Практическая польза		2010-09-19 03:09:46.874+04	2010-09-19 03:09:46.874+04
139fb3cb-040e-488e-b408-c2f2982280b5	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Scootera	Scootera		2010-09-19 03:09:46.877+04	2010-09-19 03:09:46.877+04
d0f22e9d-27b6-476c-9478-0bafee450a9e	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Шоу-парадиз	Шоу-парадиз		2010-09-19 03:09:46.88+04	2010-09-19 03:09:46.88+04
c83d877e-bf61-4d1d-bef6-8275a7980f79	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Тюнинг-шоу	Тюнинг-шоу		2010-09-19 03:09:46.882+04	2010-09-19 03:09:46.882+04
de18307a-786c-41f7-bdf2-85f3b4e771a4	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Генеалогия	Генеалогия		2010-09-19 03:09:46.885+04	2010-09-19 03:09:46.885+04
8d2707ff-d2b3-426b-8907-87977199327e	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Премьер-тест	Премьер-тест		2010-09-19 03:09:46.888+04	2010-09-19 03:09:46.888+04
4311f2dc-a495-4157-9b24-5ed637b0b567	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Из первых уст	Из первых уст		2010-09-19 03:09:46.891+04	2010-09-19 03:09:46.891+04
9c7b5740-1092-479b-8af6-b8f394808619	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Встречайте	Встречайте		2010-09-19 03:09:46.893+04	2010-09-19 03:09:46.893+04
0dc4ef4d-1bc4-482b-abf1-4c1f470d2b9f	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Изобридеи	Изобридеи		2010-09-19 03:09:46.895+04	2010-09-19 03:09:46.895+04
41ee39c4-f31e-4c91-bea6-cfb6c100a2c7	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Higt-tech	Higt-tech		2010-09-19 03:09:46.898+04	2010-09-19 03:09:46.898+04
59a68dfd-3bfd-45a0-bebb-5c3dfe37effa	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Письма из Европы	Письма из Европы		2010-09-19 03:09:46.901+04	2010-09-19 03:09:46.901+04
1840fc6f-98de-44ee-b033-30dd55928d1e	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Брэнд	Брэнд		2010-09-19 03:09:46.904+04	2010-09-19 03:09:46.904+04
81156941-9930-462c-8c94-3d9ffbddba09	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Экип-тест	Экип-тест		2010-09-19 03:09:46.906+04	2010-09-19 03:09:46.906+04
71c760c4-f5bd-4a3d-83c6-70239b9c9e9b	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Мастер-пилот	Мастер-пилот		2010-09-19 03:09:46.908+04	2010-09-19 03:09:46.908+04
86e41268-d54c-4ea7-947f-502f12f05278	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Tech-art	Tech-art		2010-09-19 03:09:46.911+04	2010-09-19 03:09:46.911+04
68158016-5588-4d09-a594-1209aba72ba2	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Know-how	Know-how		2010-09-19 03:09:46.914+04	2010-09-19 03:09:46.914+04
16cf50df-d28f-46fb-8ba6-02d810b5a50c	f9cfd971-ea52-47b3-90dd-6a31c03579db	fca1e7fd-e6e1-4f68-9876-8bc0dff69ab3	Flashback	Flashback		2010-09-19 03:09:46.917+04	2010-09-19 03:09:46.917+04
81f7bb72-164e-4ddc-8e2c-cb7bfbe811af	f9cfd971-ea52-47b3-90dd-6a31c03579db	5072bfcb-5f3a-495c-91ef-308be4de27a3	Содержание	Содержание		2010-09-19 03:09:46.919+04	2010-09-19 03:09:46.919+04
b318f20c-eed2-401a-9aa9-149bc066b593	f9cfd971-ea52-47b3-90dd-6a31c03579db	5072bfcb-5f3a-495c-91ef-308be4de27a3	Список моделей	Список моделей		2010-09-19 03:09:46.921+04	2010-09-19 03:09:46.921+04
00000000-0000-0000-0000-000000000000	1718de7a-ce8e-44ba-8228-ceb1d22e56ae	00000000-0000-0000-0000-000000000000	Not found	Not found		2010-09-19 03:09:46.931+04	2010-09-19 03:09:46.931+04
\.


--
-- Data for Name: rules; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY rules (id, "group", rule, name, shortcut, description, sortorder) FROM stdin;
12d66e21-c8ba-4001-b407-d64229a3a756	\N	document-owner	Материалы			20
b0c6753c-551c-4ab5-8409-ea9798432c91	document-owner	document.owner.reserve	Размещать в портфель	Размещать в портфель		8
d2bb51ee-b0ce-44d8-bbce-5b2b217bed12	document-owner	document.owner.print	Отправлять на верстку	Отправлять на верстку		9
cfbb3a50-34ca-4d15-a982-1d8098b31a3a	edition	edition.fascicle.page.makedown	Снимать полосы с верстки	Снимать с верстки		3
0da9306b-7aae-40a6-8d90-b7d51a15280f	edition	edition.fascicle.page.makeup	Отправлять полосы на верстку	Отправлять на верстку		4
ef101761-903f-4ee8-939e-11b6db98a68b	edition	edition.fascicle.breadboarding.manage	Макетировать полосы	Макетировать		1
c03274bc-482e-4759-9e0b-4b6b17eeae2f	edition	edition.fascicle.page.allocation.document	Назначать материалы на полосы	Назначать материалы		2
671fa468-cd2f-404b-89dc-cad8e092847a	\N	edition	Компоновка			30
5f64ec34-3106-49fb-bfdc-ca15ad489624	\N	advertising	Реклама			40
e9dbc995-c9d3-43d7-84e3-eeb0c776a1aa	document-owner	document.owner.view	Просматривать	Просматривать		2
5d4e3cde-fbae-4a6b-973d-f183bf6b73e9	document-owner	document.owner.add	Добавлять	Добавлять		1
4943b704-0457-4024-adef-cc26ea4c947e	document-owner	document.owner.edit	Редактировать формуляр	Редактировать формуляр		3
77d0dd3d-4fcd-44a7-9903-c78675a27a2d	document-owner	document.owner.delete	Удалять	Удалять		4
c488bb6b-e9c0-4775-af01-3dd83dc6a9cd	document-owner	document.owner.restore	Восстанавливать	Восстанавливать		5
f67e4a32-3e7b-4dd1-bac1-8f2b6047fdb5	document-owner	document.owner.file.create	Создавать файлы	Создавать файлы		10
bd870c4a-eb82-4f51-a09f-4214b09fd5e6	document-owner	document.owner.file.approve	Утверждать файлы	Утверждать файлы		14
0a72c6a6-b9a7-4c5e-8088-153ba59ae79f	document-owner	document.owner.file.upload	Загружать файлы	Загружать файлы		11
53844d9b-e03b-45aa-b3e4-888e20e9aa0d	document-owner	document.owner.file.delete	Удалять файлы	Удалять файлы		12
b1fec3c8-2842-4054-ad5b-7f93940a820a	document-owner	document.owner.file.manage	Изменять файлы	Изменять файлы		13
76b99216-e110-439c-80b0-cdd05832047f	document-owner	document.owner.comment	Комментировать	Комментировать		6
bac0cd33-aa28-4361-ad8c-f980a3a66f26	document-owner	document.owner.exchange	Передавать	Передавать		7
fef34459-9405-4424-83e2-916d29a5a3ac	advertising	advertising.manage.advertiser	Добавление рекламодателей	Управление рекламодателями		2
d46a961b-6bef-4442-85eb-803c1e4a33eb	advertising	advertising.view	Просматривать рекламу	Просматривать		1
af7bcdde-1940-4b0f-9369-81702c2c199b	advertising	advertising.manage.mockup	Добавление макетов	Управление макетами		4
8c0ba025-c275-48b6-baa8-a80b2da1cc17	advertising	advertising.approve.mockup	Утверждение макетов	Утверждение макетов		5
b76adddd-c10c-40d8-a38d-1c6c50b7ec13	advertising	advertising.manage.request	Добавление заявками	Управление заявками		3
6f220a59-b4df-49b6-bc57-1a789ec81eec	advertising	advertising.approve.request	Утверждение заявок	Утверждение заявок		6
ee616ff0-c7f7-4318-a36e-a80352b2cd84	edition	edition.view	Просматривать выпуски	Просматривать		1
3a551f02-09d9-4390-8e4f-90b3631bdb80	edition	edition.fascicle.composition.manage	Менять компоновку выпуска	Изменять компоновку		3
4e064090-cc07-44a4-8e46-8335f3565894	edition	edition.manage	Управлять выпусками	Управлять календарем		2
5f37ad4d-bc3f-4f40-acb9-66ba2030cf9f	document-owner	document.department.manage	Редактировать дату сдачи и выпуск	Редактировать дату сдачи и выпуск		3
18c59970-97b4-4bfd-8538-05d53c2605fe	document-owner	document.department.entrust	Назначать редактора	Назначать редактора		4
fb436b9c-cd6a-468b-864c-eb492a56ff39	document-owner	document.department.file.manage	Изменять файлы	Изменять файлы		14
75620635-3a2d-4953-93f1-d5ae2cbf2c51	document-owner	document.department.capture	Захватывать	Захватывать		7
0e13a3ae-2e80-4e7d-a766-80d1e8d7c51f	\N	catalog	Каталог			10
be2de51f-bd7e-4f11-ba63-7d3c56169664	catalog	settings.manage.edition	Управлять редакцией, изданиями	Управлять изданиями		2
1a80d738-94a1-4568-900f-fc77a1592127	catalog	settings.manage.people	Управлять сотрудниками	Управлять сотрудниками		3
f58d7d69-7d7e-463c-8b89-a512dcf06ac1	catalog	settings.manage.exchange	Управлять движением материалов	Управлять обменом		4
0471091d-621f-4e32-af0d-8f2bc8d4042d	catalog	settings.confidential.edit	Измененять конфиденциальную информацию	Управлять паролями		2
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY sessions (id, member, ipaddress, created, updated) FROM stdin;
113fc969-28ee-4df0-9b32-02e0e98bb0f5	39d40812-fc54-4342-9b98-e1c1f4222d22		2010-09-27 23:47:21.473901+04	2010-09-28 01:51:21.19717+04
\.


--
-- Data for Name: stages; Type: TABLE DATA; Schema: public; Owner: inprint
--

COPY stages (id, branch, color, weight, title, shortcut, description, created, updated) FROM stdin;
30d53cb9-bf40-4e3d-a5ee-967a891a64a4	eed0c8a2-6bf8-1014-b3fa-01e8601ac163	FFFF00	40	Редактура	Редактура		2010-08-18 15:59:31.068+04	2010-08-18 15:59:31.068+04
c128e8ef-af5a-4bc0-8af0-41ba05beff98	eed0c8a2-6bf8-1014-b3fa-01e8601ac163	00FF00	50	Утверждение	Утверждение		2010-08-18 15:59:31.07+04	2010-08-18 15:59:31.07+04
dfa2c9ca-61e6-4fb4-9449-a54e3d191608	eed0c8a2-6bf8-1014-b3fa-01e8601ac163	00CCFF	60	Корректура	Корректура		2010-08-18 15:59:31.072+04	2010-08-18 15:59:31.072+04
e2ce48d4-32bb-44e8-a388-287eebd3af5b	eed0c8a2-6bf8-1014-b3fa-01e8601ac163	0000FF	80	Верстка	Верстка		2010-08-18 15:59:31.074+04	2010-08-18 15:59:31.074+04
1e9677b3-c544-43ca-8594-de5593ac8a9c	eed0c8a2-6bf8-1014-b3fa-01e8601ac163	CC99FF	100	Сверстано	Сверстано		2010-08-18 15:59:31.111+04	2010-08-18 15:59:31.111+04
4d340b73-03a8-4614-8972-7e01fa17a124	eed0c8a2-6bf8-1014-b3fa-01e8601ac163	FF0000	10	Написание	Написание		2010-08-18 15:59:31.117+04	2010-08-18 15:59:31.117+04
73d89a8c-6c4a-477d-8a5f-20607ed4a777	eed0c8a2-6bf8-1014-b3fa-01e8601ac163	969696	30	Тех. ред	Тех. ред		2010-08-18 15:59:31.144+04	2010-08-18 15:59:31.144+04
2a597d45-21d9-437a-9544-c9517586af3b	eed47a37-6bf8-1014-b3fa-01e8601ac163	00FFFF	90	Верстка	Верстка	Верстка материала	2010-08-18 15:59:31.194+04	2010-08-18 15:59:31.194+04
38c9352c-870a-400a-9f71-101b1be1711c	eed47a37-6bf8-1014-b3fa-01e8601ac163	3366FF	100	Сверстано	Сверстано	Материал сверстан	2010-08-18 15:59:31.217+04	2010-08-18 15:59:31.217+04
a36aff2f-c5da-46c6-807d-307526440b7f	eed47a37-6bf8-1014-b3fa-01e8601ac163	CCFFFF	75	Корректура	Корректура	Корректура	2010-08-18 15:59:31.219+04	2010-08-18 15:59:31.219+04
14fdda7e-0034-49ea-b5fd-08ecc36f4f4c	eed47a37-6bf8-1014-b3fa-01e8601ac163	FFCC00	35	Редактирование	Редактирование	Редактирование материала	2010-08-18 15:59:31.221+04	2010-08-18 15:59:31.221+04
3ff2759f-9730-4949-972f-98f386d75966	eed47a37-6bf8-1014-b3fa-01e8601ac163	FFFF00	50	Сдача и утверждение	Сдача и утверждение	Утверждение материала	2010-08-18 15:59:31.222+04	2010-08-18 15:59:31.222+04
73f0ae4b-0be2-42e0-9111-6b827efc88c7	eed47a37-6bf8-1014-b3fa-01e8601ac163	CCFFCC	65	Вычитка	Вычитка	Вычитка материала автором	2010-08-18 15:59:31.224+04	2010-08-18 15:59:31.224+04
63f04620-dc65-420c-ba51-3bbd8347008b	eed47a37-6bf8-1014-b3fa-01e8601ac163	000000	6	Написание	Написание	Этап написания материала	2010-08-18 15:59:31.226+04	2010-08-18 15:59:31.226+04
dabbdaf2-b36e-46fb-9c83-c39938e2d319	eed745f4-6bf8-1014-b3fa-01e8601ac163	00FFFF	80	Верстка	Верстка		2010-08-18 15:59:31.234+04	2010-08-18 15:59:31.234+04
4ab4648c-71ff-4adb-b6f7-223a4b84b6c2	eed745f4-6bf8-1014-b3fa-01e8601ac163	666699	35	М-л сдан	М-л сдан		2010-08-18 15:59:31.236+04	2010-08-18 15:59:31.236+04
eeb238f2-bfcf-4e9a-b142-c259c77ad789	eed745f4-6bf8-1014-b3fa-01e8601ac163	339966	40	Зам. гл. ред.	Зам. гл. ред.		2010-08-18 15:59:31.237+04	2010-08-18 15:59:31.237+04
28f1ac13-5262-4093-8e5d-b2e754e5ab4f	eed745f4-6bf8-1014-b3fa-01e8601ac163	3366FF	100	Свёрстан	Свёрстан		2010-08-18 15:59:31.24+04	2010-08-18 15:59:31.24+04
1c6d3f1d-d8d4-4f53-8d10-6e96002a4fec	eed745f4-6bf8-1014-b3fa-01e8601ac163	FF0000	50	Корректура	Корректура	Корректор МОТО	2010-08-18 15:59:31.242+04	2010-08-18 15:59:31.242+04
d2b5c3e8-259f-4d77-b566-d03fba89ea70	eed745f4-6bf8-1014-b3fa-01e8601ac163	99CC00	60	ГлавРед, Корректура	ГлавРед, Корректура		2010-08-18 15:59:31.263+04	2010-08-18 15:59:31.263+04
eede84e7-20a0-4d68-ab51-2d1b6c4919c5	eed745f4-6bf8-1014-b3fa-01e8601ac163	FFFFFF	100	Шаблоны	Шаблоны		2010-08-18 15:59:31.265+04	2010-08-18 15:59:31.265+04
548e4f99-77ad-4a08-9195-7eefc4612e43	eed745f4-6bf8-1014-b3fa-01e8601ac163	FFCC00	30	Написание	Написание		2010-08-18 15:59:31.267+04	2010-08-18 15:59:31.267+04
8df9ce5c-0abb-4a5d-b873-5ecaa6a61714	eed89c46-6bf8-1014-b3fa-01e8601ac163	00FF00	60	Утверждение	Утверждение		2010-08-18 15:59:31.272+04	2010-08-18 15:59:31.272+04
c175adc2-1c59-4674-ac9a-ae784efc743f	eed89c46-6bf8-1014-b3fa-01e8601ac163	33CCCC	45	Написание	Написание		2010-08-18 15:59:31.273+04	2010-08-18 15:59:31.273+04
ba638a0f-c6fb-44b4-862c-7ee11e041b61	eed89c46-6bf8-1014-b3fa-01e8601ac163	FF0000	70	Корректура	Корректура		2010-08-18 15:59:31.275+04	2010-08-18 15:59:31.275+04
acc6a226-31d7-40f1-abec-cc5f01f88e88	eed89c46-6bf8-1014-b3fa-01e8601ac163	C0C0C0	90	Верстка	Верстка		2010-08-18 15:59:31.277+04	2010-08-18 15:59:31.277+04
3392475f-d45a-4138-b804-e14decfda1f1	eed89c46-6bf8-1014-b3fa-01e8601ac163	3366FF	100	Сверстано	Сверстано		2010-08-18 15:59:31.278+04	2010-08-18 15:59:31.278+04
e7e1e8e4-f8e6-4939-a15b-37dba488761f	eed90bdb-6bf8-1014-b3fa-01e8601ac163	99CC00	60	Правка	Правка	Правка текста	2010-08-18 15:59:31.285+04	2010-08-18 15:59:31.285+04
631ef7c8-e6a0-4243-b3a0-3fb151aadb97	eed90bdb-6bf8-1014-b3fa-01e8601ac163	339966	70	Вычитка	Вычитка	Вычитка материала автором	2010-08-18 15:59:31.287+04	2010-08-18 15:59:31.287+04
3153a3c4-f60d-4b8b-b8b8-d35a94271bb0	eed90bdb-6bf8-1014-b3fa-01e8601ac163	FF6600	10	Написание	Написание	Этап написания материала	2010-08-18 15:59:31.288+04	2010-08-18 15:59:31.288+04
daa4ae74-1680-4c43-896c-1f936463201a	eed90bdb-6bf8-1014-b3fa-01e8601ac163	FFCC00	25	Подготовка	Подготовка	Доработка материала в отделе	2010-08-18 15:59:31.292+04	2010-08-18 15:59:31.292+04
67a1e5f2-ff98-4a96-9ef4-f57039af8d58	eed90bdb-6bf8-1014-b3fa-01e8601ac163	0000FF	100	Сверстано	Сверстано	Материал сверстан	2010-08-18 15:59:31.294+04	2010-08-18 15:59:31.294+04
6c1d78bd-55f6-4765-8812-df2139a14db7	eed90bdb-6bf8-1014-b3fa-01e8601ac163	00CCFF	90	Верстка	Верстка	Верстка материала	2010-08-18 15:59:31.296+04	2010-08-18 15:59:31.296+04
7f679cec-6ed6-4696-8897-a96a6390deab	eed90bdb-6bf8-1014-b3fa-01e8601ac163	00FFFF	80	Корректура	Корректура	Корректура	2010-08-18 15:59:31.297+04	2010-08-18 15:59:31.297+04
bbdb8ae4-9892-4b9e-8fba-99c5a01ff7b4	eed90bdb-6bf8-1014-b3fa-01e8601ac163	FFFF00	50	Сдача, утверждение	Сдача, утверждение	Утверждение материала	2010-08-18 15:59:31.299+04	2010-08-18 15:59:31.299+04
\.


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
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: fascicles_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY fascicles
    ADD CONSTRAINT fascicles_pkey PRIMARY KEY (id);


--
-- Name: headlines_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY headlines
    ADD CONSTRAINT headlines_pkey PRIMARY KEY (id, fascicle);


--
-- Name: map_documents_to_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_documents_to_exchange
    ADD CONSTRAINT map_documents_to_exchange_pkey PRIMARY KEY (id);


--
-- Name: map_documents_to_fascicles_document_key; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_documents_to_fascicles
    ADD CONSTRAINT map_documents_to_fascicles_document_key UNIQUE (document, fascicle);


--
-- Name: map_documents_to_fascicles_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_documents_to_fascicles
    ADD CONSTRAINT map_documents_to_fascicles_pkey PRIMARY KEY (id);


--
-- Name: map_member_to_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_pkey PRIMARY KEY (member, catalog);


--
-- Name: map_member_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_member_to_rule
    ADD CONSTRAINT map_member_to_rule_pkey PRIMARY KEY (member, catalog, rule, mode);


--
-- Name: map_principals_to_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_principals_to_stages
    ADD CONSTRAINT map_principals_to_stages_pkey PRIMARY KEY (id, stage, princial);


--
-- Name: map_role_to_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_pkey PRIMARY KEY (role, rule, mode);


--
-- Name: member_card_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT member_card_pkey PRIMARY KEY (id);


--
-- Name: member_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY members
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: member_session_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT member_session_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: inprint; Tablespace: 
--

ALTER TABLE ONLY rubrics
    ADD CONSTRAINT rubrics_pkey PRIMARY KEY (id, fascicle);


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
-- Name: indx_fascicle; Type: INDEX; Schema: public; Owner: inprint; Tablespace: 
--

CREATE INDEX indx_fascicle ON documents USING btree (fascicle);


--
-- Name: indx_headline; Type: INDEX; Schema: public; Owner: inprint; Tablespace: 
--

CREATE INDEX indx_headline ON documents USING btree (fascicle, headline, headline_shortcut);


--
-- Name: indx_ingroup; Type: INDEX; Schema: public; Owner: inprint; Tablespace: 
--

CREATE INDEX indx_ingroup ON documents USING btree (ingroups);


--
-- Name: catalog_insert_before; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER catalog_insert_before
    BEFORE INSERT ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE catalog_insert_before_trigger();


--
-- Name: catalog_tree_delete_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER catalog_tree_delete_after
    AFTER DELETE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE catalog_delete_after_trigger();


--
-- Name: catalog_update_after; Type: TRIGGER; Schema: public; Owner: inprint
--

CREATE TRIGGER catalog_update_after
    AFTER UPDATE ON catalog
    FOR EACH ROW
    EXECUTE PROCEDURE catalog_update_after_trigger();


--
-- Name: map_member_to_catalog_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY map_member_to_catalog
    ADD CONSTRAINT map_member_to_catalog_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: map_member_to_rule_member_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY map_member_to_rule
    ADD CONSTRAINT map_member_to_rule_member_fkey FOREIGN KEY (member) REFERENCES members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: map_member_to_rule_rule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY map_member_to_rule
    ADD CONSTRAINT map_member_to_rule_rule_fkey FOREIGN KEY (rule) REFERENCES rules(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: map_role_to_rule_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_role_fkey FOREIGN KEY (role) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: map_role_to_rule_rule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: inprint
--

ALTER TABLE ONLY map_role_to_rule
    ADD CONSTRAINT map_role_to_rule_rule_fkey FOREIGN KEY (rule) REFERENCES rules(id) ON UPDATE CASCADE ON DELETE CASCADE;


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

