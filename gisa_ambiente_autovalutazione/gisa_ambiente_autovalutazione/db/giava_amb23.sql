--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.4

-- Started on 2023-10-19 17:05:51

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 7 (class 2615 OID 367411)
-- Name: cl_23; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA cl_23;


ALTER SCHEMA cl_23 OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 4342 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 2 (class 3079 OID 367412)
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- TOC entry 4344 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- TOC entry 3 (class 3079 OID 367458)
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- TOC entry 4345 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- TOC entry 944 (class 1247 OID 367466)
-- Name: riskcat; Type: DOMAIN; Schema: cl_23; Owner: postgres
--

CREATE DOMAIN cl_23.riskcat AS integer
	CONSTRAINT riskcat_check CHECK (((VALUE > 0) AND (VALUE < 6)));


ALTER DOMAIN cl_23.riskcat OWNER TO postgres;

--
-- TOC entry 324 (class 1255 OID 367468)
-- Name: aggregazione(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.aggregazione(_riferimento_id text DEFAULT NULL::text, _riferimento_id_nome_tab text DEFAULT NULL::text) RETURNS TABLE(codice_aggregazione text, aggregazione text, id_aggregazione text, id_macroarea text)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN	
	FOR 
		codice_aggregazione,
	    aggregazione,
	    id_aggregazione,
	    id_macroarea
    in
		select DISTINCT 
    m.codice_aggregazione,
	m.aggregazione,
    m.id_aggregazione,
    m.id_macroarea
   FROM ml10(_riferimento_id, _riferimento_id_nome_tab) m
  ORDER BY m.aggregazione
		LOOP
			RETURN NEXT;
		END LOOP;
	RETURN;
end;
$$;


ALTER FUNCTION public.aggregazione(_riferimento_id text, _riferimento_id_nome_tab text) OWNER TO postgres;

--
-- TOC entry 325 (class 1255 OID 367469)
-- Name: get_checklist_by_idlinea(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_checklist_by_idlinea(_id_linea integer) RETURNS TABLE(code integer, description character varying, short_description character varying, enabled boolean, versione double precision, num_chk integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN	
	FOR 
		code, description, short_description, enabled, versione, num_chk 
    in
		SELECT t1.code, t1.description, t1.short_description, t1.enabled, t1.versione, t1.num_chk 

   FROM dblink('dbname=gisa'::text, 'SELECT code, description, short_description, enabled, versione, num_chk 
		FROM giava.get_checklist_by_idlinea('||_id_linea||'::int) '::text) 
		t1(code integer, description character varying, short_description character varying, enabled boolean, versione double precision, num_chk integer)
		LOOP
			RETURN NEXT;
		END LOOP;
	RETURN;
end;
$$;


ALTER FUNCTION public.get_checklist_by_idlinea(_id_linea integer) OWNER TO postgres;

--
-- TOC entry 326 (class 1255 OID 367470)
-- Name: getconfig(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.getconfig() RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
	connString text;
BEGIN	
	select ' host='||"host"||' dbname='||"dbname"||' user='||"user"||' password='||"password"||' port='||"port" into connString from public.config limit 1;
	return connString;
end;
$$;


ALTER FUNCTION public.getconfig() OWNER TO postgres;

--
-- TOC entry 327 (class 1255 OID 367471)
-- Name: lda(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.lda(_riferimento_id text DEFAULT NULL::text, _riferimento_id_nome_tab text DEFAULT NULL::text) RETURNS TABLE(codice_attivita text, attivita text, id_linea text, id_aggregazione text)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN	
	FOR codice_attivita ,
	    attivita,
	    id_linea,
	    id_aggregazione
    in
		 SELECT DISTINCT 
		 m.codice_attivita,
		 m.attivita,
    m.id_linea,
    m.id_aggregazione
   FROM ml10(_riferimento_id, _riferimento_id_nome_tab) m
  ORDER BY m.attivita
		LOOP
			RETURN NEXT;
		END LOOP;
	RETURN;
end;
$$;


ALTER FUNCTION public.lda(_riferimento_id text, _riferimento_id_nome_tab text) OWNER TO postgres;

--
-- TOC entry 328 (class 1255 OID 367472)
-- Name: ml10(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ml10(_riferimento_id text DEFAULT NULL::text, _riferimento_id_nome_tab text DEFAULT NULL::text) RETURNS TABLE(codice_univoco text, norma text, id_norma text, codice_macroarea text, macroarea text, id_macroarea text, codice_aggregazione text, aggregazione text, id_aggregazione text, codice_attivita text, attivita text, id_linea text, list_cl jsonb)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN	
IF (_riferimento_id = 'null' and _riferimento_id_nome_tab = 'null') or (_riferimento_id is null and _riferimento_id_nome_tab is null)  then
	FOR 
		codice_univoco,
	    norma,
	    id_norma,
	    codice_macroarea,
	    macroarea,
	    id_macroarea,
	    codice_aggregazione,
	    aggregazione,
	    id_aggregazione,
	    codice_attivita,
	    attivita,
	    id_linea,
	    list_cl
    in
		SELECT *
   FROM dblink('dbname=gisa'::text, 'SELECT 
			codice_univoco, 
			codice_norma,  
			id_norma::text,
			codice_macroarea::text,  
			macroarea,
			id_macroarea::text, 
			codice_aggregazione::text,  
			aggregazione,
			id_aggregazione::text, 
			codice_attivita::text,
			attivita,
			id_linea::text, 
			NULL::jsonb list_cl  
		FROM giava.get_info_masterlist() 
		WHERE (rev=10 or rev=8 or rev=-1) and categorizzabili
		ORDER BY 2,4,7, 10'::text) t1(codice_univoco text, codice_norma text, id_norma text, codice_macroarea text, macroarea text, id_macroarea text, codice_aggregazione text, aggregazione text, id_aggregazione text, codice_attivita text, attivita text, id_linea text, list_cl jsonb)
		LOOP
			RETURN NEXT;
		END LOOP; 
	-- chiamo la dbi senza parametri
ELSE
	FOR 
		codice_univoco,
	    norma,
	    id_norma,
	    codice_macroarea,
	    macroarea,
	    id_macroarea,
	    codice_aggregazione,
	    aggregazione,
	    id_aggregazione,
	    codice_attivita,
	    attivita,
	    id_linea,
	    list_cl
    in
		SELECT *
   FROM dblink('dbname=gisa'::text, 'SELECT 
			codice_univoco, 
			codice_norma,  
			id_norma::text,
			codice_macroarea::text,  
			macroarea,
			id_macroarea::text, 
			codice_aggregazione::text,  
			aggregazione,
			id_aggregazione::text, 
			codice_attivita::text,
			attivita,
			id_linea::text, 
			NULL::jsonb list_cl  
		FROM giava.get_info_masterlist('||_riferimento_id||'::int, '''||_riferimento_id_nome_tab||'''::text) 
		WHERE (rev=10 or rev=8 or rev=-1) and categorizzabili
		ORDER BY 2,4,7, 10'::text) t1(codice_univoco text, codice_norma text, id_norma text, codice_macroarea text, macroarea text, id_macroarea text, codice_aggregazione text, aggregazione text, id_aggregazione text, codice_attivita text, attivita text, id_linea text, list_cl jsonb)
		LOOP
			RETURN NEXT;
		END LOOP;
	end if;
	RETURN;
end;
$$;


ALTER FUNCTION public.ml10(_riferimento_id text, _riferimento_id_nome_tab text) OWNER TO postgres;

--
-- TOC entry 329 (class 1255 OID 367473)
-- Name: norma(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.norma(_riferimento_id text DEFAULT NULL::text, _riferimento_id_nome_tab text DEFAULT NULL::text) RETURNS TABLE(norma text, id_linea text, id_norma text)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN	
	FOR 
	    norma,
	    id_norma
    in
		 SELECT DISTINCT m.norma,
    m.id_norma
   FROM ml10(_riferimento_id, _riferimento_id_nome_tab) m
  ORDER BY m.norma
		LOOP
			RETURN NEXT;
		END LOOP;
	RETURN;
end;
$$;


ALTER FUNCTION public.norma(_riferimento_id text, _riferimento_id_nome_tab text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 367474)
-- Name: a_tipol_ml; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.a_tipol_ml (
    desc_norma text,
    cod_norma text,
    cod_macroarea text,
    desc_macroarea text,
    cod_attivita text,
    cod_lda text,
    desc_aggregazione text,
    desc_lda text,
    cat_ex_ante text,
    codice_univoco text,
    allegati_categ text,
    parte_speciale text,
    note text,
    id integer NOT NULL,
    c_sez text
);


ALTER TABLE cl_23.a_tipol_ml OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 367479)
-- Name: a_tipol_ml_id_seq; Type: SEQUENCE; Schema: cl_23; Owner: postgres
--

CREATE SEQUENCE cl_23.a_tipol_ml_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cl_23.a_tipol_ml_id_seq OWNER TO postgres;

--
-- TOC entry 4346 (class 0 OID 0)
-- Dependencies: 223
-- Name: a_tipol_ml_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.a_tipol_ml_id_seq OWNED BY cl_23.a_tipol_ml.id;


--
-- TOC entry 259 (class 1259 OID 608353)
-- Name: anag_cl; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.anag_cl (
    id integer NOT NULL,
    name text,
    title text NOT NULL
);


ALTER TABLE cl_23.anag_cl OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 608352)
-- Name: anag_cl_id_seq; Type: SEQUENCE; Schema: cl_23; Owner: postgres
--

CREATE SEQUENCE cl_23.anag_cl_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cl_23.anag_cl_id_seq OWNER TO postgres;

--
-- TOC entry 4347 (class 0 OID 0)
-- Dependencies: 258
-- Name: anag_cl_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.anag_cl_id_seq OWNED BY cl_23.anag_cl.id;


--
-- TOC entry 257 (class 1259 OID 399827)
-- Name: cl_acque_reflue_id_seq; Type: SEQUENCE; Schema: cl_23; Owner: postgres
--

CREATE SEQUENCE cl_23.cl_acque_reflue_id_seq
    START WITH 21
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE cl_23.cl_acque_reflue_id_seq OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 399818)
-- Name: cl_acque_reflue; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.cl_acque_reflue (
    id integer DEFAULT nextval('cl_23.cl_acque_reflue_id_seq'::regclass) NOT NULL,
    prog numeric NOT NULL,
    grp numeric,
    domanda text NOT NULL,
    no_punti numeric,
    si_punti numeric,
    sez text,
    id_parent numeric,
    comm text,
    trashed_date text,
    peso numeric
);


ALTER TABLE cl_23.cl_acque_reflue OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 608374)
-- Name: cl_effluenti; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.cl_effluenti (
    id integer NOT NULL,
    prog numeric NOT NULL,
    grp numeric,
    domanda text NOT NULL,
    no_punti numeric,
    si_punti numeric,
    sez text,
    id_parent numeric,
    comm text,
    trashed_date text,
    peso numeric
);


ALTER TABLE cl_23.cl_effluenti OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 608373)
-- Name: cl_effluenti_id_seq; Type: SEQUENCE; Schema: cl_23; Owner: postgres
--

CREATE SEQUENCE cl_23.cl_effluenti_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cl_23.cl_effluenti_id_seq OWNER TO postgres;

--
-- TOC entry 4348 (class 0 OID 0)
-- Dependencies: 260
-- Name: cl_effluenti_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.cl_effluenti_id_seq OWNED BY cl_23.cl_effluenti.id;


--
-- TOC entry 255 (class 1259 OID 399783)
-- Name: cl_emissioni; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.cl_emissioni (
    id integer NOT NULL,
    prog numeric NOT NULL,
    grp numeric,
    domanda text NOT NULL,
    no_punti numeric,
    si_punti numeric,
    sez text,
    id_parent numeric,
    comm text,
    trashed_date text,
    peso numeric
);


ALTER TABLE cl_23.cl_emissioni OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 399782)
-- Name: cl_emissioni_id_seq; Type: SEQUENCE; Schema: cl_23; Owner: postgres
--

CREATE SEQUENCE cl_23.cl_emissioni_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cl_23.cl_emissioni_id_seq OWNER TO postgres;

--
-- TOC entry 4349 (class 0 OID 0)
-- Dependencies: 254
-- Name: cl_emissioni_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.cl_emissioni_id_seq OWNED BY cl_23.cl_emissioni.id;


--
-- TOC entry 263 (class 1259 OID 608392)
-- Name: cl_fanghi; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.cl_fanghi (
    id integer NOT NULL,
    prog numeric NOT NULL,
    grp numeric,
    domanda text,
    no_punti numeric,
    si_punti numeric,
    sez text,
    id_parent numeric,
    comm text,
    trashed_date text,
    peso numeric
);


ALTER TABLE cl_23.cl_fanghi OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 608391)
-- Name: cl_fanghi_id_seq; Type: SEQUENCE; Schema: cl_23; Owner: postgres
--

CREATE SEQUENCE cl_23.cl_fanghi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cl_23.cl_fanghi_id_seq OWNER TO postgres;

--
-- TOC entry 4350 (class 0 OID 0)
-- Dependencies: 262
-- Name: cl_fanghi_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.cl_fanghi_id_seq OWNED BY cl_23.cl_fanghi.id;


--
-- TOC entry 265 (class 1259 OID 608410)
-- Name: cl_reflui_oleari; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.cl_reflui_oleari (
    id integer NOT NULL,
    prog numeric NOT NULL,
    grp numeric,
    domanda text,
    si_punti numeric,
    no_punti numeric,
    sez text,
    id_parent numeric,
    comm text,
    trashed_date text,
    peso numeric
);


ALTER TABLE cl_23.cl_reflui_oleari OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 608409)
-- Name: cl_reflui_oleari_id_seq; Type: SEQUENCE; Schema: cl_23; Owner: postgres
--

CREATE SEQUENCE cl_23.cl_reflui_oleari_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cl_23.cl_reflui_oleari_id_seq OWNER TO postgres;

--
-- TOC entry 4351 (class 0 OID 0)
-- Dependencies: 264
-- Name: cl_reflui_oleari_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.cl_reflui_oleari_id_seq OWNED BY cl_23.cl_reflui_oleari.id;


--
-- TOC entry 267 (class 1259 OID 608419)
-- Name: cl_rifiuti; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.cl_rifiuti (
    id integer NOT NULL,
    prog numeric NOT NULL,
    grp numeric,
    domanda text,
    si_punti numeric,
    no_punti numeric,
    sez text,
    id_parent numeric,
    comm text,
    trashed_date text,
    peso numeric
);


ALTER TABLE cl_23.cl_rifiuti OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 608418)
-- Name: cl_rifiuti_id_seq; Type: SEQUENCE; Schema: cl_23; Owner: postgres
--

CREATE SEQUENCE cl_23.cl_rifiuti_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cl_23.cl_rifiuti_id_seq OWNER TO postgres;

--
-- TOC entry 4352 (class 0 OID 0)
-- Dependencies: 266
-- Name: cl_rifiuti_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.cl_rifiuti_id_seq OWNED BY cl_23.cl_rifiuti.id;


--
-- TOC entry 224 (class 1259 OID 367492)
-- Name: old_config_cl; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.old_config_cl (
    id integer NOT NULL,
    cl_name text NOT NULL,
    cl_title text NOT NULL,
    totale_per_sezioni boolean DEFAULT false,
    risposta_tripla boolean DEFAULT false,
    trashed_date text
);


ALTER TABLE cl_23.old_config_cl OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 367499)
-- Name: config_cl_id_seq; Type: SEQUENCE; Schema: cl_23; Owner: postgres
--

CREATE SEQUENCE cl_23.config_cl_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cl_23.config_cl_id_seq OWNER TO postgres;

--
-- TOC entry 4353 (class 0 OID 0)
-- Dependencies: 225
-- Name: config_cl_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.config_cl_id_seq OWNED BY cl_23.old_config_cl.id;


--
-- TOC entry 226 (class 1259 OID 367500)
-- Name: old_config_sez; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.old_config_sez (
    id integer NOT NULL,
    cl_name text NOT NULL,
    sez_name text NOT NULL,
    rischio_basso_punti text,
    rischio_basso_param numeric,
    rischio_medio_punti text,
    rischio_medio_param numeric,
    rischio_alto_punti text,
    rischio_alto_param numeric,
    trashed_date text
);


ALTER TABLE cl_23.old_config_sez OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 367505)
-- Name: config_punti_id_seq; Type: SEQUENCE; Schema: cl_23; Owner: postgres
--

CREATE SEQUENCE cl_23.config_punti_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cl_23.config_punti_id_seq OWNER TO postgres;

--
-- TOC entry 4354 (class 0 OID 0)
-- Dependencies: 227
-- Name: config_punti_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.config_punti_id_seq OWNED BY cl_23.old_config_sez.id;


--
-- TOC entry 228 (class 1259 OID 367584)
-- Name: log_access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_access (
    id bigint NOT NULL,
    id_utente bigint,
    entered timestamp without time zone,
    id_asl text,
    ip text
);


ALTER TABLE public.log_access OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 367589)
-- Name: access_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.access_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_log_id_seq OWNER TO postgres;

--
-- TOC entry 4355 (class 0 OID 0)
-- Dependencies: 229
-- Name: access_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.access_log_id_seq OWNED BY public.log_access.id;


--
-- TOC entry 230 (class 1259 OID 367590)
-- Name: ml10_old; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ml10_old AS
 SELECT t1.codice_univoco,
    t1.codice_norma AS norma,
    t1.id_norma,
    t1.macroarea,
    t1.id_macroarea,
    t1.aggregazione,
    t1.id_aggregazione,
    t1.attivita,
    t1.id_linea,
    t1.list_cl
   FROM public.dblink(public.getconfig(), 'SELECT 
			codice_univoco, 
			codice_norma,  
			id_norma::text,  
			macroarea,
			id_macroarea::text, 
			aggregazione,
			id_aggregazione::text, 
			attivita,
			id_linea::text, 
			NULL::jsonb list_cl  
		FROM digemon.get_info_masterlist() 
		WHERE rev=10 and categorizzabili
		ORDER BY 2,4,6, 8'::text) t1(codice_univoco text, codice_norma text, id_norma text, macroarea text, id_macroarea text, aggregazione text, id_aggregazione text, attivita text, id_linea text, list_cl jsonb);


ALTER TABLE public.ml10_old OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 367594)
-- Name: aggregazione_old; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.aggregazione_old AS
 SELECT DISTINCT ml10_old.aggregazione,
    ml10_old.id_aggregazione,
    ml10_old.id_macroarea
   FROM public.ml10_old
  ORDER BY ml10_old.aggregazione;


ALTER TABLE public.aggregazione_old OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 367598)
-- Name: appdocu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appdocu (
    id integer NOT NULL,
    doc text,
    code text,
    ord text,
    tit text
);


ALTER TABLE public.appdocu OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 367603)
-- Name: appdocu_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appdocu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appdocu_id_seq OWNER TO postgres;

--
-- TOC entry 4356 (class 0 OID 0)
-- Dependencies: 233
-- Name: appdocu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appdocu_id_seq OWNED BY public.appdocu.id;


--
-- TOC entry 234 (class 1259 OID 367604)
-- Name: audit; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.audit AS
 SELECT t1.id,
    t1.org_id,
    t1.livello_rischio,
    t1.numero_registrazione,
    t1.componenti_gruppo,
    t1.note,
    t1.data_1,
    t1.data_2,
    t1.livello_rischio_finale,
    t1.tipo_check,
    t1.punteggio_ultimi_anni,
    t1.id_controllo,
    t1.categoria,
    t1.last,
    t1.data_prossimo_controllo,
    t1.flag_bb,
    t1.trashed_date,
    t1.modified_by,
    t1.is_principale,
    t1.stato,
    t1.id_stabilimento,
    t1.id_apiario,
    t1.alt_id
   FROM public.dblink(public.getconfig(), 'SELECT 
id, 
org_id, 
livello_rischio, 
numero_registrazione, 
componenti_gruppo, 
note, 
data_1, 
data_2, 
livello_rischio_finale, 
tipo_check, 
punteggio_ultimi_anni, 
id_controllo, 
categoria, 
"last", 
data_prossimo_controllo, 
flag_bb, 
trashed_date, 
modified_by, 
is_principale, 
stato, 
id_stabilimento, 
id_apiario, 
alt_id 
  from audit'::text) t1(id integer, org_id integer, livello_rischio integer, numero_registrazione character varying(100), componenti_gruppo text, note text, data_1 timestamp without time zone, data_2 timestamp without time zone, livello_rischio_finale integer, tipo_check integer, punteggio_ultimi_anni integer, id_controllo character varying, categoria integer, last text, data_prossimo_controllo timestamp without time zone, flag_bb boolean, trashed_date timestamp without time zone, modified_by integer, is_principale boolean, stato text, id_stabilimento integer, id_apiario integer, alt_id integer);


ALTER TABLE public.audit OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 367609)
-- Name: audit_checklist; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.audit_checklist AS
 SELECT t1.checklist_id,
    t1.audit_id,
    t1.risposta,
    t1.punti,
    t1.stato
   FROM public.dblink(public.getconfig(), 'SELECT 
checklist_id, 
audit_id, 
risposta, 
punti, 
stato
  from audit_checklist'::text) t1(checklist_id integer, audit_id integer, risposta boolean, punti integer, stato text);


ALTER TABLE public.audit_checklist OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 367613)
-- Name: audit_checklist_type; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.audit_checklist_type AS
 SELECT t1.checklist_type_id,
    t1.audit_id,
    t1.valore_range,
    t1.operazione,
    t1.nota,
    t1.is_abilitato
   FROM public.dblink(public.getconfig(), 'SELECT 
checklist_type_id, 
audit_id, 
valore_range, 
operazione, nota, 
is_abilitato  
from audit_checklist_type'::text) t1(checklist_type_id integer, audit_id integer, valore_range integer, operazione character(1), nota text, is_abilitato boolean);


ALTER TABLE public.audit_checklist_type OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 367617)
-- Name: checklist; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.checklist AS
 SELECT t1.id,
    t1.parent_id,
    t1.checklist_type_id,
    t1.domanda,
    t1.descrizione,
    t1.punti_no,
    t1.punti_si,
    t1.level,
    t1.enabled,
    t1.grand_parents_id,
    t1.super_domanda
   FROM public.dblink(public.getconfig(), 'SELECT 
id, 
parent_id, 
checklist_type_id, 
domanda, descrizione, 
punti_no, 
punti_si, 
"level", 
enabled, 
grand_parents_id, 
super_domanda 
from checklist'::text) t1(id integer, parent_id integer, checklist_type_id integer, domanda text, descrizione text, punti_no integer, punti_si integer, level integer, enabled boolean, grand_parents_id integer, super_domanda boolean);


ALTER TABLE public.checklist OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 367621)
-- Name: checklist_type; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.checklist_type AS
 SELECT t1.code,
    t1.catrischio_id,
    t1.description,
    t1.range,
    t1.default_item,
    t1.level,
    t1.enabled,
    t1.is_disabilitato,
    t1.is_disabilitato_solo_xlaprima,
    t1.is_disabilitabile
   FROM public.dblink(public.getconfig(), 'SELECT 
code, 
catrischio_id, 
description, 
"range", 
default_item, 
"level", 
enabled, 
is_disabilitato, 
is_disabilitato_solo_xlaprima, 
is_disabilitabile
from checklist_type'::text) t1(code integer, catrischio_id integer, description character varying(300), range integer, default_item boolean, level integer, enabled boolean, is_disabilitato boolean, is_disabilitato_solo_xlaprima boolean, is_disabilitabile integer);


ALTER TABLE public.checklist_type OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 367625)
-- Name: lookup_org_catrischio; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lookup_org_catrischio AS
 SELECT t1.code,
    t1.description,
    t1.short_description,
    t1.default_item,
    t1.level,
    t1.enabled,
    t1.versione
   FROM public.dblink(public.getconfig(), 'SELECT 
code, 
description, 
short_description, 
default_item, 
"level", 
enabled, 
versione
from lookup_org_catrischio'::text) t1(code integer, description character varying(300), short_description character varying(300), default_item boolean, level integer, enabled boolean, versione double precision);


ALTER TABLE public.lookup_org_catrischio OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 367629)
-- Name: cl_chapts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cl_chapts AS
 SELECT c.code AS c_id,
    c.description AS c_desc,
    c.range,
    c.level AS c_level,
    c.is_disabilitato AS c_is_disabilitato,
    l.level AS l_level,
    l.description AS l_desc,
    l.short_description AS l_short_desc,
    l.code AS l_id
   FROM (public.checklist_type c
     JOIN public.lookup_org_catrischio l ON ((c.catrischio_id = l.code)))
  WHERE (c.enabled AND l.enabled)
  ORDER BY l.description, c.description;


ALTER TABLE public.cl_chapts OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 367634)
-- Name: cl_quests; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cl_quests AS
 SELECT d.id AS q_id,
    d.domanda,
    '-'::text AS sotto_domanda,
    d.parent_id,
    d.punti_no,
    d.punti_si,
    d.grand_parents_id,
    d.checklist_type_id AS id_chap
   FROM public.checklist d
  WHERE (d.enabled AND (d.parent_id = '-1'::integer))
UNION
 SELECT sd.id AS q_id,
    d.domanda,
    sd.domanda AS sotto_domanda,
    sd.parent_id,
    sd.punti_no,
    sd.punti_si,
    d.grand_parents_id,
    d.checklist_type_id AS id_chap
   FROM (public.checklist d
     JOIN public.checklist sd ON ((d.id = sd.parent_id)))
  WHERE (d.enabled AND sd.enabled AND (sd.parent_id > '-1'::integer))
  ORDER BY 1;


ALTER TABLE public.cl_quests OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 367639)
-- Name: cl_all; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cl_all AS
 SELECT cl_quests.q_id,
    c.c_id,
    c.l_id,
    c.l_desc,
    c.c_desc,
    cl_quests.domanda,
    cl_quests.sotto_domanda,
    cl_quests.parent_id,
    cl_quests.punti_no,
    cl_quests.punti_si
   FROM (public.cl_chapts c
     LEFT JOIN public.cl_quests ON ((cl_quests.id_chap = c.c_id)));


ALTER TABLE public.cl_all OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 367643)
-- Name: cl_lists; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.cl_lists AS
 SELECT l.code AS l_id,
    l.level AS l_level,
    l.description AS l_desc,
    l.short_description AS l_short_desc,
    l.default_item AS def,
    l.versione AS ver
   FROM public.lookup_org_catrischio l
  WHERE l.enabled
  ORDER BY l.description, l.short_description;


ALTER TABLE public.cl_lists OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 367647)
-- Name: config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config (
    host character varying,
    dbname character varying,
    "user" character varying,
    password character varying,
    port character varying
);


ALTER TABLE public.config OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 367652)
-- Name: lda_old; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lda_old AS
 SELECT DISTINCT ml10_old.attivita,
    ml10_old.id_linea,
    ml10_old.id_aggregazione
   FROM public.ml10_old
  ORDER BY ml10_old.attivita;


ALTER TABLE public.lda_old OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 367656)
-- Name: lista_cl; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lista_cl AS
 SELECT DISTINCT ml10_old.list_cl,
    ml10_old.id_linea
   FROM public.ml10_old
  ORDER BY ml10_old.list_cl;


ALTER TABLE public.lista_cl OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 367660)
-- Name: log_checklist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_checklist (
    id bigint NOT NULL,
    id_checklist bigint,
    id_utente bigint,
    entered timestamp without time zone
);


ALTER TABLE public.log_checklist OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 367663)
-- Name: log_checklist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_checklist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_checklist_id_seq OWNER TO postgres;

--
-- TOC entry 4357 (class 0 OID 0)
-- Dependencies: 248
-- Name: log_checklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_checklist_id_seq OWNED BY public.log_checklist.id;


--
-- TOC entry 249 (class 1259 OID 367664)
-- Name: macroarea; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.macroarea AS
 SELECT DISTINCT ml10_old.macroarea,
    ml10_old.id_macroarea,
    ml10_old.id_norma
   FROM public.ml10_old
  ORDER BY ml10_old.macroarea;


ALTER TABLE public.macroarea OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 367668)
-- Name: norma_old; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.norma_old AS
 SELECT DISTINCT ml10_old.norma,
    ml10_old.id_norma
   FROM public.ml10_old
  ORDER BY ml10_old.norma;


ALTER TABLE public.norma_old OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 367672)
-- Name: public_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.public_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.public_user_id_seq OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 367673)
-- Name: utente_risposta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.utente_risposta_id_seq
    START WITH 881
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.utente_risposta_id_seq OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 367674)
-- Name: utente_risposta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utente_risposta (
    id bigint DEFAULT nextval('public.utente_risposta_id_seq'::regclass),
    id_utente bigint,
    id_checklist bigint,
    id_domanda bigint,
    punteggio integer,
    risposta character varying,
    entered timestamp(0) without time zone
);


ALTER TABLE public.utente_risposta OWNER TO postgres;

--
-- TOC entry 4108 (class 2604 OID 367680)
-- Name: a_tipol_ml id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.a_tipol_ml ALTER COLUMN id SET DEFAULT nextval('cl_23.a_tipol_ml_id_seq'::regclass);


--
-- TOC entry 4119 (class 2604 OID 608356)
-- Name: anag_cl id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.anag_cl ALTER COLUMN id SET DEFAULT nextval('cl_23.anag_cl_id_seq'::regclass);


--
-- TOC entry 4120 (class 2604 OID 608377)
-- Name: cl_effluenti id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_effluenti ALTER COLUMN id SET DEFAULT nextval('cl_23.cl_effluenti_id_seq'::regclass);


--
-- TOC entry 4117 (class 2604 OID 399786)
-- Name: cl_emissioni id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_emissioni ALTER COLUMN id SET DEFAULT nextval('cl_23.cl_emissioni_id_seq'::regclass);


--
-- TOC entry 4121 (class 2604 OID 608395)
-- Name: cl_fanghi id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_fanghi ALTER COLUMN id SET DEFAULT nextval('cl_23.cl_fanghi_id_seq'::regclass);


--
-- TOC entry 4122 (class 2604 OID 608413)
-- Name: cl_reflui_oleari id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_reflui_oleari ALTER COLUMN id SET DEFAULT nextval('cl_23.cl_reflui_oleari_id_seq'::regclass);


--
-- TOC entry 4123 (class 2604 OID 608422)
-- Name: cl_rifiuti id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_rifiuti ALTER COLUMN id SET DEFAULT nextval('cl_23.cl_rifiuti_id_seq'::regclass);


--
-- TOC entry 4109 (class 2604 OID 367683)
-- Name: old_config_cl id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_cl ALTER COLUMN id SET DEFAULT nextval('cl_23.config_cl_id_seq'::regclass);


--
-- TOC entry 4112 (class 2604 OID 367684)
-- Name: old_config_sez id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_sez ALTER COLUMN id SET DEFAULT nextval('cl_23.config_punti_id_seq'::regclass);


--
-- TOC entry 4114 (class 2604 OID 367698)
-- Name: appdocu id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appdocu ALTER COLUMN id SET DEFAULT nextval('public.appdocu_id_seq'::regclass);


--
-- TOC entry 4113 (class 2604 OID 367699)
-- Name: log_access id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_access ALTER COLUMN id SET DEFAULT nextval('public.access_log_id_seq'::regclass);


--
-- TOC entry 4115 (class 2604 OID 367700)
-- Name: log_checklist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_checklist ALTER COLUMN id SET DEFAULT nextval('public.log_checklist_id_seq'::regclass);


--
-- TOC entry 4307 (class 0 OID 367474)
-- Dependencies: 222
-- Data for Name: a_tipol_ml; Type: TABLE DATA; Schema: cl_23; Owner: postgres
--

COPY cl_23.a_tipol_ml (desc_norma, cod_norma, cod_macroarea, desc_macroarea, cod_attivita, cod_lda, desc_aggregazione, desc_lda, cat_ex_ante, codice_univoco, allegati_categ, parte_speciale, note, id, c_sez) FROM stdin;
AUA	AUA	AUA-M	Autorizzazione Unica Ambientale	ARIA	IMPATTO	Aria	Impatto acustico	\N	AUA-ARIA-IMPATTO	cl_emissioni	\N	\N	4	\N
AUA	AUA	AUA-M	Autorizzazione Unica Ambientale	SUOLO	FANGHI	Suolo	Spandimento fanghi	\N	AUA-SUOLO-FANGHI	cl_fanghi	\N	\N	8	\N
AUA	AUA	AUA-M	Autorizzazione Unica Ambientale	ACQUA	SCARICHI	Acqua	Scarichi acque reflue	\N	AUA-ACQUA-SCARICHI	cl_acque_reflue	\N	\N	1	\N
AUA	AUA	AUA-M	Autorizzazione Unica Ambientale	ARIA	EMISSIONI	Aria	Emissioni in atmosfera	\N	AUA-ARIA-EMISSIONI	cl_emissioni	\N	\N	2	\N
AUA	AUA	AUA-M	Autorizzazione Unica Ambientale	SUOLO	RIFIUTI	Suolo	Rifiuti	\N	AUA-SUOLO-RIFIUTI	cl_rifiuti	\N	\N	3	\N
\.


--
-- TOC entry 4328 (class 0 OID 608353)
-- Dependencies: 259
-- Data for Name: anag_cl; Type: TABLE DATA; Schema: cl_23; Owner: postgres
--

COPY cl_23.anag_cl (id, name, title) FROM stdin;
3	cl_emissioni	EMISSIONI IN ATMOSFERA
4	cl_acustica	ACUSTICA
5	cl_acque_reflue	ACQUE REFLUE
6	cl_effluenti	UTILIZZO AGRONOMICO EFFLUENTI ZOOTECNICI
7	cl_fanghi	FANGHI DI DEPURAZIONE IN AGRICOLTURA
8	cl_rifiuti	GESTIONE RIFIUTI
9	cl_reflui_oleari	UTILIZZO AGRONOMICO REFLUI OLEARI
\.


--
-- TOC entry 4325 (class 0 OID 399818)
-- Dependencies: 256
-- Data for Name: cl_acque_reflue; Type: TABLE DATA; Schema: cl_23; Owner: postgres
--

COPY cl_23.cl_acque_reflue (id, prog, grp, domanda, no_punti, si_punti, sez, id_parent, comm, trashed_date, peso) FROM stdin;
1	1	\N	Il gestore dello stabilimento dispone di autorizzazione valida relativamente alle scadenze introdotte dal D.Lgs. 152/06 ss.mm.ii.	0	1	Profilo amministrativo	\N	\N	\N	1
2	2	\N	L'azienda ha  provveduto alla richiesta di istanza di rinnovo dell'autorizzazione alle emissioni in atmosfera prima della data di scadenza.	0	1	Profilo amministrativo	\N	\N	\N	1
3	3	1	Funzionante	0	0	Stato di realizzazione dello stabilimento	\N	\N	\N	0.25
4	4	1	Parzialmente funzionante o in Manutenzione	0.25	0	Stato di realizzazione dello stabilimento	\N	\N	\N	0.25
5	5	1	In Costruzione	0.5	0	Stato di realizzazione dello stabilimento	\N	\N	\N	0.25
6	6	1	In Progetto	0.75	0	Stato di realizzazione dello stabilimento	\N	\N	\N	0.25
7	7	1	Assente	1	0	Stato di realizzazione dello stabilimento	\N	\N	\N	0.25
8	8	\N	Certificazioni di Qualità, Sistemi di Gestione Aziendale, ecc.	0	1	Gestione dell'impianto	\N	\N	\N	0.25
9	9	\N	Corrispondenza del numero, tipologia e localizzazione delle emissioni in atmosfera convogliate e diffuse con quanto autorizzato.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
10	10	\N	Corrispondenza tra i punti di emissione scarsamente rilevanti (attività in deroga) ai sensi dell’art. 272 del D.Lgs. 152/06  con quanto elencato nella documentazione tecnica presentata per la richiesta di autorizzazione.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
11	11	\N	Corrispondenza del ciclo produttivo on quanto autorizzato.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
12	12	\N	Registrazione di eventuali anomalie di funzionamento o guasti degli impianti tali da non garantire il rispetto diei limiti di emissione fissati.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
13	13	\N	Effettuazione delle analisi di controllo degli inquinanti emessi in atmosfera dai camini, secondo le frequenze indicate in autorizzazione ed indicazione delle frequenze (Autocontrolli).	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
14	14	\N	Rispetto dei limiti previsti in autorizzazione.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
15	15	\N	Rispetto del programma di manutenzione del  controllo tecnico.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
16	16	\N	Conservazione dei referti analitici, a disposizione delle per le autorità di controllo presso la ditta per un periodo minimo di 5 anni ai sensi dell’art. 271 comma 18 del D.lgs.152/06.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
17	17	\N	Presenza di sistemi per il trattamento delle emissioni e loro conformità rispetto a quanto prescritto nell’autorizzazione.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
18	18	\N	Interventi di manutenzione secondo le tempistiche previste  per la sostituzione dei presidi depurativi in base al manuale di costruzione, uso e manutenzione ovvero negli atti a corredo del Decreto autorizzatorio, nonché della presenza di apposito registro che riporti le suddette annotazioni.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
19	19	\N	Trasmissioni obbligatorie prescritte nell'atto autorizzativo.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
20	20	\N	Controlli eseguiti da soggetti pubblici e/o Autorità Giudiziaria.	0	1	altre	\N	\N	\N	0.25
\.


--
-- TOC entry 4330 (class 0 OID 608374)
-- Dependencies: 261
-- Data for Name: cl_effluenti; Type: TABLE DATA; Schema: cl_23; Owner: postgres
--

COPY cl_23.cl_effluenti (id, prog, grp, domanda, no_punti, si_punti, sez, id_parent, comm, trashed_date, peso) FROM stdin;
8	1	\N	Comunicazione ai sensi dell'All. IV Parte A del DM 5046/2016	0.5	0.5	Informazioni amministrative	\N	\N	\N	1
9	2	\N	Comunicazione ai sensi dell'All. IV Parte B del DM 5046/2016	0.5	0.5	Informazioni amministrative	\N	\N	\N	1
10	3	\N	Predisposizione Piano Di Utilizzo 	0.5	0.5	Informazioni amministrative	\N	\N	\N	1
11	4	\N	La consistenza attuale è superiore all'ultima dichiarata	0	1	Consistenza 	\N	\N	\N	1
12	5	\N	>10%	0	1	Consistenza 	\N	\N	\N	1
13	6	\N	<10%	0	0.5	Consistenza 	\N	\N	\N	1.0
14	8	\N	La capacità di stoccaggio è adeguata all'attuale fabbisogno	0.5	1	Sistemi di stoccaggio effluente zootecnici, acque reflue e digestati 	\N	\N	\N	1
15	10	1	Trattamento anaerobico 	0	0.5	Tipologia  trattamenti per stabilizzazione effluenti	\N	\N	\N	1
16	11	1	Trattamento aerobico 	0	0.5	Tipologia  trattamenti per stabilizzazione effluenti	\N	\N	\N	1
17	12	1	Solo separazione solido/liquido	0	0.5	Tipologia  trattamenti per stabilizzazione effluenti	\N	\N	\N	1
18	14	\N	L'azienda cede totalmente gli effluenti prodotti a terzi	1	0	Gestione dell'impianto	\N	\N	\N	0.25
19	15	\N	L'azienda cede parzialmente gli effluenti prodotti a terzi	1	0.5	Gestione dell'impianto	\N	\N	\N	0.25
20	16	\N	Presentazione comunicazione all'autorità competente entro 30 gg dall'inizio delle attività	1	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
21	17	\N	L'azienda utilizza terreni sufficienti per l'attuale produzione di effluenti	1	0.5	Elenco Obblighi e prescrizioni	\N	\N	\N	1
22	18	\N	Terreno destinato allo spandimento  interessato dall'attività agricola	1	0.5	Elenco Obblighi e prescrizioni	\N	\N	\N	1
23	19	\N	Terreno destinato allo spandimento ubicato a più di 5 metri di distanza dalle sponde di corsi d'acqua superficiali	1	0.5	Elenco Obblighi e prescrizioni	\N	\N	\N	1
24	20	\N	Terreno destinato allo spandimento ubicato a più di 5 metri di distanza dall'inizio dell'arenile per le acque marino-costiere e quelle lacuali	1	0.5	Elenco Obblighi e prescrizioni	\N	\N	\N	1
25	21	\N	Terreno destinato allo spandimento ubicato a distanza maggiore di 200 m dalle zone di tutela assoluta circostanti captazioni o derivazioni delle aree di salvaguardia delle acque destinate al consumo umano	1	0.5	Elenco Obblighi e prescrizioni	\N	\N	\N	1
26	22	\N	Terreno destinato allo spandimento con pendenza media inferiore al 10%	1	0.5	Elenco Obblighi e prescrizioni	\N	\N	\N	1
27	23	\N	Terreno destinato allo spandimento ubicati a distanza superiore ai 10 m dal corsi d'acqua , dall'inizio dell'arenile per le acque marino-costiere e quelle lacuali e dalle strade	1	0.5	Elenco Obblighi e prescrizioni	\N	\N	\N	1
28	24	\N	Terreno destinato allo spandimento ubicati a distanza superiore ai 100 m dai centri abitati	1	0.5	Elenco Obblighi e prescrizioni	\N	\N	\N	1
29	25	\N	Terreno destinato allo spandimento ubicati a distanza superiore ai 100 m dai centri abitati	1	0.5	Elenco Obblighi e prescrizioni	\N	\N	\N	1
30	26	\N	Terreni oggetto di spandimento nella disponibilità del soggetto titolare dell'autorizzazione 	1	0.5	Elenco Obblighi e prescrizioni	\N	\N	\N	1
\.


--
-- TOC entry 4324 (class 0 OID 399783)
-- Dependencies: 255
-- Data for Name: cl_emissioni; Type: TABLE DATA; Schema: cl_23; Owner: postgres
--

COPY cl_23.cl_emissioni (id, prog, grp, domanda, no_punti, si_punti, sez, id_parent, comm, trashed_date, peso) FROM stdin;
1	1	\N	Il gestore dello stabilimento dispone di autorizzazione valida relativamente alle scadenze introdotte dal D.Lgs. 152/06 ss.mm.ii.	0	1	Profilo amministrativo	\N	\N	\N	1
2	2	\N	L'azienda ha  provveduto alla richiesta di istanza di rinnovo dell'autorizzazione alle emissioni in atmosfera prima della data di scadenza.	0	1	Profilo amministrativo	\N	\N	\N	1
3	3	\N	Funzionante	0	0	Stato di realizzazione dello stabilimento	\N	\N	\N	0.25
4	4	\N	Parzialmente funzionante o in Manutenzione	0.25	0	Stato di realizzazione dello stabilimento	\N	\N	\N	0.25
5	5	\N	In Costruzione	0.5	0	Stato di realizzazione dello stabilimento	\N	\N	\N	0.25
6	6	\N	In Progetto	0.75	0	Stato di realizzazione dello stabilimento	\N	\N	\N	0.25
7	7	\N	Assente	1	0	Stato di realizzazione dello stabilimento	\N	\N	\N	0.25
8	8	\N	Certificazioni di Qualità, Sistemi di Gestione Aziendale, ecc.	0	1	Gestione dell'impianto	\N	\N	\N	0.25
9	9	\N	Corrispondenza del numero, tipologia e localizzazione delle emissioni in atmosfera convogliate e diffuse con quanto autorizzato.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
10	10	\N	Corrispondenza tra i punti di emissione scarsamente rilevanti (attività in deroga) ai sensi dell’art. 272 del D.Lgs. 152/06  con quanto elencato nella documentazione tecnica presentata per la richiesta di autorizzazione.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
11	11	\N	Corrispondenza del ciclo produttivo on quanto autorizzato.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
12	12	\N	Registrazione di eventuali anomalie di funzionamento o guasti degli impianti tali da non garantire il rispetto diei limiti di emissione fissati.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
13	13	\N	Effettuazione delle analisi di controllo degli inquinanti emessi in atmosfera dai camini, secondo le frequenze indicate in autorizzazione ed indicazione delle frequenze (Autocontrolli).	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
14	14	\N	Rispetto dei limiti previsti in autorizzazione.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
15	15	\N	Rispetto del programma di manutenzione del  controllo tecnico.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
16	16	\N	Conservazione dei referti analitici, a disposizione delle per le autorità di controllo presso la ditta per un periodo minimo di 5 anni ai sensi dell’art. 271 comma 18 del D.lgs.152/06.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
20	20	\N	Controlli eseguiti da soggetti pubblici e/o Autorità Giudiziaria.	0	1	altre	\N	\N	\N	0.25
17	17	\N	Presenza di sistemi per il trattamento delle emissioni e loro conformità rispetto a quanto prescritto nell’autorizzazione.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
18	18	\N	Interventi di manutenzione secondo le tempistiche previste  per la sostituzione dei presidi depurativi in base al manuale di costruzione, uso e manutenzione ovvero negli atti a corredo del Decreto autorizzatorio, nonché della presenza di apposito registro che riporti le suddette annotazioni.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
19	19	\N	Trasmissioni obbligatorie prescritte nell'atto autorizzativo.	0	1	Elenco Obblighi e prescrizioni	\N	\N	\N	1
\.


--
-- TOC entry 4332 (class 0 OID 608392)
-- Dependencies: 263
-- Data for Name: cl_fanghi; Type: TABLE DATA; Schema: cl_23; Owner: postgres
--

COPY cl_23.cl_fanghi (id, prog, grp, domanda, no_punti, si_punti, sez, id_parent, comm, trashed_date, peso) FROM stdin;
1	2	\N	Autorizzazione richiesta per la prima volta	0.5	0.5	Informazioni amministrative	\N	\N	\N	1
2	3	\N	La titolarità dell'autorizzazione corrisponde al Gestore dell'impianto di depurazione	1	0	Informazioni amministrative	\N	\N	\N	1
3	4	1	Funzionante	\N	0	Stato  dell'impianto di depurazione da cui drerivano i fanghi	\N	\N	\N	0.25
4	5	1	Iparzialmente funzionante/n Manutenzione	\N	0.25	Stato  dell'impianto di depurazione da cui drerivano i fanghi	\N	\N	\N	0.25
5	6	1	In Costruzione	\N	0.5	Stato  dell'impianto di depurazione da cui drerivano i fanghi	\N	\N	\N	0.25
6	7	1	In Progetto	\N	0.75	Stato  dell'impianto di depurazione da cui drerivano i fanghi	\N	\N	\N	0.25
7	8	1	Assente	\N	1	Stato  dell'impianto di depurazione da cui drerivano i fanghi	\N	\N	\N	0.25
8	9	2	Attività produttive dell'industria agroalimentare	0	1	Tipologia  dell'impianto di depurazione da cui drerivano i fanghi	\N	\N	\N	1
9	10	2	Altre tipologie	1	0	Tipologia  dell'impianto di depurazione da cui drerivano i fanghi	\N	\N	\N	1
10	11	\N	Certificazioni di Qualità, Sistemi di Gestione Aziendale, ecc.	1	0	Gestione dell'impianto	\N	\N	\N	0.25
11	12	\N	Rispetto del ciclo di produzione dei fanghi secondo le tecnologie indicate in autorizzazione\n(trattati e stabilizzati) 	1	0	Elenco Obblighi e prescrizioni	\N	\N	\N	1
12	13	\N	Analisi dei fanghi secondo le frequenze indicate in autorizzazione 	1	0	Elenco Obblighi e prescrizioni	\N	\N	\N	1
13	14	\N	Analisi dei fanghi e dei terreni  eseguite da laboratorio accreditato (ACCREDIA o altro Ente certificatore)	1	0	Elenco Obblighi e prescrizioni	\N	\N	\N	1
14	15	\N	Analisi del monomero Acrilammide in luogo di autocertificazione	1	0	Elenco Obblighi e prescrizioni	\N	\N	\N	0.5
15	16	\N	Trasmissione degli esiti analitici agli enti preposti in fase di autorizzazione	1	0	Elenco Obblighi e prescrizioni	\N	\N	\N	0.5
16	17	\N	Terreni oggetto di spandimento nella disponibilità del soggetto tiolare dell'autorizzazione 	1	0	Elenco Obblighi e prescrizioni	\N	\N	\N	0.5
17	18	\N	Terreni oggetto di spandimento rientranti in zone vulnerabili ai nitrati  	1	0	Elenco Obblighi e prescrizioni	\N	\N	\N	1
18	19	\N	Disponibilità di tutti gli atti previsti dalla Delibera della Giunta Regionale n. 170 del 03/06/2014\nmodificata con Delibera Giunta Regionale n. 239 del 24/05/2016\n	1	0	Elenco Obblighi e prescrizioni	\N	\N	\N	1
\.


--
-- TOC entry 4334 (class 0 OID 608410)
-- Dependencies: 265
-- Data for Name: cl_reflui_oleari; Type: TABLE DATA; Schema: cl_23; Owner: postgres
--

COPY cl_23.cl_reflui_oleari (id, prog, grp, domanda, si_punti, no_punti, sez, id_parent, comm, trashed_date, peso) FROM stdin;
1	1	\N	Prima comunicazione  Lettere A,B,C,D	1.00	0.50	Informazioni amministrative	\N	\N	\N	1.00
2	2	\N	Comunicazione successiva alla prima Lettere B,C , D	1.00	0.50	Informazioni amministrative	\N	\N	\N	1.00
3	3	\N	Registro di spandimento 	0.50	0.50	Informazioni amministrative	\N	\N	\N	1.00
4	4	\N	Quaderno di frantoio	0.50	0.50	Informazioni amministrative	\N	\N	\N	1.00
5	5	\N	Rispetto del tempo di stoccaggio non  superiore a quindici giorni in silos, cisterne, \nvasche  interrate  o sopraelevate 	1.00	0.00	Stoccaggio e trasporto	\N	\N	\N	1.00
6	6	\N	Contenitori di stoccaggio hanno capacita' sufficiente a\ncontenere  le  acque  di  vegetazione  nei  periodi  in cui l'impiego\nagricolo  e'  impedito  da  motivazioni  agronomiche, climatiche o da\ndisposizioni normative.	1.00	0.00	Stoccaggio e trasporto	\N	\N	\N	1.00
7	7	\N	Le strutture di stoccaggio hanno le caratteristiche previsste dalla DGR 398/2006 	1.00	0.00	Stoccaggio e trasporto	\N	\N	\N	1.00
8	8	\N	\N	\N	\N	Gestione dell'impianto	\N	\N	\N	\N
9	9	\N	L'azienda cede totalmente le AAVV e le sanse umide prodotte a terzi	1.00	0	\N	\N	\N	\N	0.5
10	10	\N	L'azienda cede parzialmente le AAVV e le sanse umide prodotte a terzi	0.50	1.00	\N	\N	\N	\N	0.25
11	11	\N	Presentazione comunicazione all'autorità competente entro 30 gg dall'inizio delle attività	1.00	1.00	Elenco Obblighi e prescrizioni	\N	\N	\N	1.00
12	12	\N	Terreni destinati allo spandimento situati a distanza inferiore a trecento metri dalle\naree  di  salvaguardia delle captazioni di acque destinate al consumo\numano 	0.50	1.00	Elenco Obblighi e prescrizioni	\N	\N	\N	1.00
13	13	\N	Terreni destinati allo spandimento  situati a distanza inferiore a duecento metri dai\ncentri abitati	0.50	1.00	Elenco Obblighi e prescrizioni	\N	\N	\N	1.00
14	14	\N	Terreni destinati allo spandimento ubicati a distanza  inferiore a dieci metri dai corsi d'acqua misurati a\npartire   dalle  sponde  e  dagli  inghiottitoi  e  doline	0.50	1.00	Elenco Obblighi e prescrizioni	\N	\N	\N	1.00
15	15	\N	Terreni destinati allo spandimento ubicati distanza inferiore ai dieci metri dall'inizio dell'arenile per\nle acque marino costiere e lacuali	0.50	1.00	Elenco Obblighi e prescrizioni	\N	\N	\N	1.00
16	16	\N	Terreni destinati allo spandimento non investiti da colture orticole in atto	0.50	1.00	Elenco Obblighi e prescrizioni	\N	\N	\N	1.00
17	17	\N	Terreni destinati allo spandimento in  cui  siano  localizzate falde site ad una profondita' inferiore a\ndieci metri	1.00	1.00	Elenco Obblighi e prescrizioni	\N	\N	\N	1.00
18	18	\N	Terreni destinati allo spandimento  con  pendenza inferiore al 15 % privi di sistemazione\nidraulico agraria	0.50	1.00	Elenco Obblighi e prescrizioni	\N	\N	\N	0.50
19	19	\N	Controlli eseguiti da ARPAC ai sensi dell'art. 9 della L. 574/96 	1.00	1.00	Controlli eseguiti da soggetti pubblici e/o Autorità Giudiziaria	\N	\N	\N	0.25
\.


--
-- TOC entry 4336 (class 0 OID 608419)
-- Dependencies: 267
-- Data for Name: cl_rifiuti; Type: TABLE DATA; Schema: cl_23; Owner: postgres
--

COPY cl_23.cl_rifiuti (id, prog, grp, domanda, si_punti, no_punti, sez, id_parent, comm, trashed_date, peso) FROM stdin;
1	1	\N	IMPIANTO E' ISCRITTO SU ORSO https://orso.arpalombardia.it/	0	0.5	Aspetti amministrativi	\N	\N	\N	0.5
2	2	\N	I DATI SU ORSO SONO AGGIORNATI NEL RISPETTO DELLE SCADENZE	0.5	0	Aspetti amministrativi	\N	\N	\N	0.5
3	3	\N	L'IMPIANTO E' ISCRITTO ALL'ALBO GESTORI AMBIENTALI	0.5	0	Aspetti amministrativi	\N	\N	\N	0.5
4	4	\N	L'azienda possiede la certificazione ISO 9001?	0	0.25	Certificazioni	\N	\N	\N	0.25
5	5	\N	se NO l'azienda ha intenzione di avviare l'iter di certificazione ISO 9001 nei prossimi 12 mesi?	0.25	0	Certificazioni	\N	\N	\N	0.25
6	6	\N	L'azienda possiede la certificazione ISO 14001?	0	0.25	Certificazioni	\N	\N	\N	0.25
7	7	\N	se NO l'azienda ha intenzione di avviare l'iter di certificazione ISO 14001 nei prossimi 12 mesi?	0	0.25	Certificazioni	\N	\N	\N	0.25
8	8	\N	L'azienda possiede la certificazione EMAS?	0	0.25	Certificazioni	\N	\N	\N	0.25
9	9	\N	se NO l'azienda ha intenzione di avviare l'iter di certificazione  EMAS nei prossimi 12 mesi?	0.25	0	Certificazioni	\N	\N	\N	0.25
10	10	\N	L'azienda possiede altre certificazioni? 	0	0.25	Certificazioni	\N	\N	\N	0.25
11	11	\N	L'impianto produce MPS/EoW?	0	0.5	Dati di produzione MPS/EoW	\N	\N	\N	0.5
12	12	\N	I materiali prodotti sono certificati per lotti?	0	0.5	Dati di produzione MPS/EoW	\N	\N	\N	0.5
13	13	\N	Il campionamento e le analisi sono effettuate a cura del titolare dell'impianto ove i rifiuti sono prodotti almeno in occasione del primo conferimento all'impianto di recupero e, successivamente, ogni 24 mesi e, comunque, ogni volta che intervengano modifiche sostanziali nel processo di produzione	0	1	Aspetti gestionali	\N	\N	\N	1
14	14	\N	Ottemperanza alle prescrizioni ambientali riportate nell’atto autorizzativo o nella comunicazione dell’attività di gestione dei rifiuti	0	1	Aspetti gestionali	\N	\N	\N	1
15	15	\N	Coerenza tra  i quantitativi di rifiuti in deposito temporaneo, quelli autorizzati e quelli riportati sul registro di carico / scarico	1	0	Aspetti gestionali	\N	\N	\N	1
16	16	\N	Rispetto delle aree di stoccaggio indicate in autorizzazione o nelle comunicazioni e coerenza con le tipologie di rifiuti ivi previste	1	0	Aspetti gestionali	\N	\N	\N	1
17	17	\N	Aree di stoccaggio dei rifiuti presi in carico separate dalle aree per il deposito temporaneo dei rifiuti prodotti	0.5	0	Aspetti gestionali	\N	\N	\N	0.5
18	18	\N	Aree di stoccaggio chiaramente identificate e contrassegnate con i relativi codici CER. Mantenimento della separazione dei rifiuti pericolosi dai non pericolosi e dei rifiuti sulla base delle loro caratteristiche fisiche (solido/liquido)	0.5	0	Aspetti gestionali	\N	\N	\N	0.5
19	19	\N	Serbatoi depositati su bacini di contenimento e contenitori fissi e mobili provvisti di idonee chiusure per impedire la fuoriuscita del contenuto (I serbatoi per rifiuti liquidi devono essere provvisti di un bacino di contenimento con un volume almeno pari al 100% del volume del singolo serbatoio che vi insiste o, nel caso di più serbatoi, almeno al 110% del volume del serbatoio avente volume maggiore)	1	0	Aspetti gestionali	\N	\N	\N	1
20	20	\N	Effettuate verifiche dell'integrità delle apparecchiature	1	0	Riciclaggio per RAEE	\N	\N	\N	1
21	21	\N	Effettuate operazioni di messa in sicurezza delle apparecchiature (rif. art. 18 e punto 4 allegato VII d.lgs. 49/2014 e Specifica Tecnica CdCRAEE-AssoRAEE "Modalità di trattamento delle apparecchiature elettriche ed elettroniche dismesse (RAEE) - Criteri per la qualificazione degli impianti")	1	0	Riciclaggio per RAEE	\N	\N	\N	1
22	22	\N	Eseguite operazioni di preparazione per il riutilizzo e/o riciclaggio/recupero delle apparecchiature (rif. art. 18 e allegato VII d.lgs. 49/2014 e Specifica Tecnica CdCRAEE-AssoRAEE "Modalità di trattamento delle apparecchiature elettriche ed elettroniche dismesse (RAEE) - Criteri per la qualificazione degli impianti")	1	0	Riciclaggio per RAEE	\N	\N	\N	1
23	23	\N	Procedure di accettazione dei rifiuti mediante acquisizione dei formulari, di eventuali analisi chimiche	1	0	Aspetti documentali 	\N	\N	\N	1
24	24	\N	Correttezza delle modalità di annotazione sui registri di carico / scarico, formulari 	0	1	Aspetti documentali 	\N	\N	\N	1
25	25	\N	Rispetto del tempo di permanenza dei rifiuti previsto dalla normativa 	1	0	Aspetti documentali 	\N	\N	\N	1
26	26	\N	Presentazione dichiarazione MUD	0	0.5	Aspetti documentali 	\N	\N	\N	0.5
27	27	\N	Presenza piano emergenza interno 	1	0	Aspetti documentali 	\N	\N	\N	1
28	28	\N	Verifica che i rifiuti prodotti siano conferiti a soggetti autorizzati (verifica a campione)	0	1	Aspetti documentali 	\N	\N	\N	1
29	29	\N	Presenza eventuali analisi chimiche eseguite sui rifiuti prodotti 	1	0	Aspetti documentali 	\N	\N	\N	1
30	30	\N	I rifiuti prodotti/gestiti sono trasportati in Paesi dell'Unione Europea o in Paesi terzi?	0.25	0	Aspetti documentali 	\N	\N	\N	0.25
31	31	\N	I rifiuti gestiti sono importati da Paesi dell'Unione Europea o in Paesi terzi?	0.25	0	Aspetti documentali 	\N	\N	\N	0.25
32	34	\N	Accessi interni all’azienda e alle aree di stoccaggio mantenuti sgombri	0.5	0	Aspetti generali	\N	\N	\N	0.5
33	35	\N	Presenza di tracce di eventuali sversamenti sul suolo	0	1	Aspetti generali	\N	\N	\N	1
34	36	\N	Regolare manutenzione delle aree e delle strutture impiantistiche (vasche, serbatoi, superfici scolanti e canalette per la raccolta di liquidi o delle acque piovane mantenute in idonee condizioni di pulizia..)	1	0	Aspetti generali	\N	\N	\N	1
35	37	\N	Presenza  di segnalatori di livello ed opportuni dispositivi antitraboccamento per i serbatoi dei rifiuti liquidi	0	1	Aspetti generali	\N	\N	\N	1
36	38	\N	Documentazione di  prove di tenuta dei serbatoi interrati	1	0	Aspetti generali	\N	\N	\N	1
37	39	\N	Altezze di stoccaggio dei rifiuti in cumulo commisurate alla tipologia di rifiuto (in linea generale i fusti e le cisternette non devono essere sovrapposti per più di 3 piani, i cumuli di rifiuti devono avere altezza inferiore ai 3 mt o al massimo a 5 mt per gli impianti laddove aturoizzati dalla Regione)	0	1	Aspetti generali	\N	\N	\N	1
38	40	\N	Presenza di procedure / materiale per l’assorbimento dei liquidi in caso di sversamenti	1	0	Aspetti generali	\N	\N	\N	1
39	41	\N	In caso di caditoie, presenza di procedure per la loro chiusura in caso di sversamenti	0	1	Aspetti generali	\N	\N	\N	1
40	42	\N	Presenza di un’area di stoccaggio per rifiuti non conformi	1	0	Aspetti generali	\N	\N	\N	1
41	43	\N	Impermeabilizzazione delle aree di scarico / travaso dei rifiuti liquidi	0	1	Aspetti generali	\N	\N	\N	1
42	44	\N	Corretto deflusso dell’acqua piovana di dilavamento dei rifiuti	1	0	Aspetti generali	\N	\N	\N	1
43	45	\N	Presenza di un sistema/impianto di pesatura dei rifiuti 	0	1	Aspetti generali	\N	\N	\N	1
44	46	\N	Presenza del lay-out dell'impianto, riportato in più punti del sito	0	1	Aspetti generali	\N	\N	\N	1
45	47	\N	Presenza dei sistemi di rilevazione e allarme incendio	0	1	Aspetti generali	\N	\N	\N	1
46	48	\N	Presenza dei presidi fissi e/o mobili antincendio. Se sono presenti, gli stessi sono manutenuti?	0	1	Aspetti generali	\N	\N	\N	1
47	49	\N	Le aree di lavorazione dei rifiuti (compresa l'attività di selezione e cernita) sono coperte	0	1	Aspetti generali	\N	\N	\N	1
48	50	\N	I rifiuti liquidi (pericolosi e non pericolosi) sono stoccati in aree coperte	0	1	Aspetti generali	\N	\N	\N	1
49	51	\N	Le impermeabilizzazioni sono integre e non presentano rotture/fessurazioni	0	1	Aspetti generali	\N	\N	\N	1
50	52	\N	I rifiuti pericolosi sono stoccati in aree coperte	0	1	Aspetti generali	\N	\N	\N	1
51	53	\N	Presenza di un sistema di aspirazione e trattamento delle emissioni in atmosfera provenienti dalle operazioni di trattamnento sui rifiuti (es. triturazione)	0	1	Aspetti generali	\N	\N	\N	1
\.


--
-- TOC entry 4309 (class 0 OID 367492)
-- Dependencies: 224
-- Data for Name: old_config_cl; Type: TABLE DATA; Schema: cl_23; Owner: postgres
--

COPY cl_23.old_config_cl (id, cl_name, cl_title, totale_per_sezioni, risposta_tripla, trashed_date) FROM stdin;
1	cl_emissioni	Checklist Autovalutazione Emissioni	f	f	\N
2	cl_acque_reflue	Checklist Autovalutazione Acque Reflue	f	f	\N
\.


--
-- TOC entry 4311 (class 0 OID 367500)
-- Dependencies: 226
-- Data for Name: old_config_sez; Type: TABLE DATA; Schema: cl_23; Owner: postgres
--

COPY cl_23.old_config_sez (id, cl_name, sez_name, rischio_basso_punti, rischio_basso_param, rischio_medio_punti, rischio_medio_param, rischio_alto_punti, rischio_alto_param, trashed_date) FROM stdin;
37	cl_emissioni	Profilo amministrativo	\N	\N	\N	\N	\N	\N	\N
38	cl_emissioni	Stato di realizzazione dello stabilimento	\N	\N	\N	\N	\N	\N	\N
39	cl_emissioni	Gestione dell'impianto	\N	\N	\N	\N	\N	\N	\N
40	cl_emissioni	Elenco Obblighi e prescrizioni	\N	\N	\N	\N	\N	\N	\N
41	cl_emissioni	Controlli eseguiti da soggetti pubblici o Autorità Giudiziaria	\N	\N	\N	\N	\N	\N	\N
42	cl_emissioni	altre	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 4315 (class 0 OID 367598)
-- Dependencies: 232
-- Data for Name: appdocu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appdocu (id, doc, code, ord, tit) FROM stdin;
3	La view contenente le checklist si riduce dunque a poco più che id e descrizione.\r\n	\r\nCREATE OR REPLACE VIEW public.cl_lists AS \r\n SELECT l.code AS l_id,\r\n    l.level AS l_level,\r\n    l.description AS l_desc,\r\n    l.short_description AS l_short_desc,\r\n    l.default_item AS def,\r\n    l.versione AS ver\r\n   FROM lookup_org_catrischio l\r\n  WHERE l.enabled\r\n  ORDER BY l.description, l.short_description;	3	\N
4	Allo stesso modo la view contenente i capitoli si riduce a id, descrizione oltre alla ovvia chiave esterna verso le check list per mantenere il relazione.\r\n	\r\nCREATE OR REPLACE VIEW public.cl_chapts AS \r\n SELECT c.code AS c_id,\r\n    c.description AS c_desc,\r\n    c.range,\r\n    c.level AS c_level,\r\n    c.is_disabilitato AS c_is_disabilitato,\r\n    l.level AS l_level,\r\n    l.description AS l_desc,\r\n    l.short_description AS l_short_desc,\r\n    l.code AS l_id\r\n   FROM checklist_type c\r\n     JOIN lookup_org_catrischio l ON c.catrischio_id = l.code\r\n  WHERE c.enabled AND l.enabled\r\n  ORDER BY l.description, c.description;\r\n\r\n  	4	\N
5	La view delle domande appare invece leggermente più articolata. Lo schema record risultante è una parziale denormalizzazione rispetto alla relazione tra domande e sottodomande che viene linearizzata in maniera molto semplice e intuitiva, e soprattuto molto corrispondente alla modalità di visualizzazione scelta. Da notare che oltre alla struttura domanda-sottodomanda e alla chiave esterna verso il capitolo, viene conservato l'id del record padre. Nel caso delle domande sarà ovviamente non significativo e settato al valore -1. Altra cosa da notare è l'id del record nel caso di domande senza sottodomande è ovviamente univoco mentre nel caso di record relativo alla sottodomanda, poichè come descrizione compare sia la sottodomanda che la domanda parent, l'ambiguità potrebbe nascere. In questo caso va tenuto presente che l'id del record è quello della sottodomanda mentre l'id della domanda viene mantenuto nel capo id parent. Ultima cosa: i punteggi da attribure in caso di risposta SI o NO.	\r\nCREATE OR REPLACE VIEW public.cl_quests AS \r\n SELECT d.id AS q_id,\r\n    d.domanda,\r\n    '-'::text AS sotto_domanda,\r\n    d.parent_id,\r\n    d.punti_no,\r\n    d.punti_si,\r\n    d.grand_parents_id,\r\n    d.checklist_type_id AS id_chap\r\n   FROM checklist d\r\n  WHERE d.enabled AND d.parent_id = '-1'::integer\r\nUNION\r\n SELECT sd.id AS q_id,\r\n    d.domanda,\r\n    sd.domanda AS sotto_domanda,\r\n    sd.parent_id,\r\n    d.punti_no,\r\n    d.punti_si,\r\n    d.grand_parents_id,\r\n    d.checklist_type_id AS id_chap\r\n   FROM checklist d\r\n     JOIN checklist sd ON d.id = sd.parent_id\r\n  WHERE d.enabled AND sd.enabled AND sd.parent_id > '-1'::integer\r\n  ORDER BY 1;\r\n  	5	\N
6	Esiste infine un terzo livello, utilizzato per semplificare la gestione di una singola checklist nella sua completa struttura gerarchica. \r\nIn questa view compaiono le info strettamente necessarie per la generazione della GUI: le varie chiavi, le varie descrizioni e i punteggi SI e NO. A partire da questo tracciato viene generato l''array di oggetti JSON utilizzati per interagire, client side, con la parte html e javascript	\r\nCREATE OR REPLACE VIEW public.cl_all AS \r\n SELECT cl_quests.q_id,\r\n    c.c_id,\r\n    c.l_id,\r\n    c.l_desc,\r\n    c.c_desc,\r\n    cl_quests.domanda,\r\n    cl_quests.sotto_domanda,\r\n    cl_quests.parent_id,\r\n    cl_quests.punti_no,\r\n    cl_quests.punti_si\r\n   FROM cl_chapts c\r\n     LEFT JOIN cl_quests ON cl_quests.id_chap = c.c_id;\r\n  	6	\N
7	Il view-model, o presentation model o comunque la struttura dati fondamentale lato client è dunque la cheklist intesa come lista ordinata di capitoli, domande e sottodomande, con relativi punteggi di risposta affermativa e negativa.   	[\r\n  {\r\n    "l_id": "2022",\r\n    "l_desc": "Esercizio Vendita (rev 3)",\r\n    "c_id": "15188",\r\n    "c_desc": "CAPITOLO I: LOCALI,IMPIANTI ED ATTREZZATURE",\r\n    "parent_id": "-1",\r\n    "q_id": "410208",\r\n    "domanda": "L''azienda è regolarmente registrata?",\r\n    "punti_si": "0",\r\n    "punti_no": "20"\r\n  },\r\n  {\r\n    "l_id": "2022",\r\n    "l_desc": "Esercizio Vendita (rev 3)",\r\n    "c_id": "15188",\r\n    "c_desc": "CAPITOLO I: LOCALI,IMPIANTI ED ATTREZZATURE",\r\n    "parent_id": "-1",\r\n    "q_id": "410209",\r\n    "domanda": "Il o i varchi di accesso per la clientela ed altri eventuali varchi che danno all''esterno,sono chiudibili tramite una o più porte d''ingresso?",\r\n    "punti_si": "0",\r\n    "punti_no": "2"\r\n  },\r\n  {\r\n    "l_id": "2022",\r\n    "l_desc": "Esercizio Vendita (rev 3)",\r\n    "c_id": "15188",\r\n    "c_desc": "CAPITOLO I: LOCALI,IMPIANTI ED ATTREZZATURE",\r\n    "parent_id": "410209",\r\n    "q_id": "410210",\r\n    "domanda": "Il o i varchi di accesso per la clientela ed altri eventuali varchi che danno all''esterno,sono chiudibili tramite una o più porte d''ingresso?",\r\n    "punti_si": "0",\r\n    "punti_no": "2"\r\n  }\r\n]	7	JSON
2	Per evitare approcci invasivi, viene utilizzato un DB esterno come wrapper verso il DB Gisa. \r\nOgnuna delle tabelle interessate (sorv, sorv_checklist, sorv_checklist_type) viene replicata tramite una view su tabella remota basata su dblink.\r\nPer evidenziare la corrispondenza 1-a-1 tra dati locali e dati remoti, le view replicano esattamente anche il nome delle tabelle a cui si riferiscono. Questo rappresenta il primo livello dei dati. A partire da questo livello, viene utilizzato un secondo strato di view per modellare in maniera più semplice possibile le entità gerarchiche Checklist, Capitoli, Domande, Sottodomande. \r\nLe view di livello successivo al primo sono identificabili dal prefisso "cl_". 	\r\nCREATE OR REPLACE VIEW public.sorv AS\r\nSELECT\r\n  t1.id\r\n, t1.org_id\r\n, t1.livello_rischio\r\n, t1.numero_registrazione\r\n, t1.componenti_gruppo\r\n, t1.note\r\n, t1.data_1\r\n, t1.data_2\r\n, t1.livello_rischio_finale\r\n, t1.tipo_check\r\n, t1.punteggio_ultimi_anni\r\n, t1.id_controllo\r\n, t1.categoria\r\n, t1.last\r\n, t1.data_prossimo_controllo\r\n, t1.flag_bb\r\n, t1.trashed_date\r\n, t1.modified_by\r\n, t1.is_principale\r\n, t1.stato\r\n, t1.id_stabilimento\r\n, t1.id_apiario\r\n, t1.alt_id\r\nFROM\r\n  dblink('dbname=gisa'::text, 'SELECT\r\nid,\r\norg_id,\r\nlivello_rischio,\r\nnumero_registrazione,\r\ncomponenti_gruppo,\r\nnote,\r\ndata_1,\r\ndata_2,\r\nlivello_rischio_finale,\r\ntipo_check,\r\npunteggio_ultimi_anni,\r\nid_controllo,\r\ncategoria,\r\n"last",\r\ndata_prossimo_controllo,\r\nflag_bb,\r\ntrashed_date,\r\nmodified_by,\r\nis_principale,\r\nstato,\r\nid_stabilimento,\r\nid_apiario,\r\nalt_id  \r\nfrom sorv'::text) \r\nt1(\r\n  id integer, \r\n  org_id integer, \r\n  livello_rischio integer, \r\n  numero_registrazione character varying(100), \r\n  componenti_gruppo text, \r\n  note text, \r\n  data_1 timestamp without time zone, \r\n  data_2 timestamp without time zone, \r\n  livello_rischio_finale integer, \r\n  tipo_check integer, \r\n  punteggio_ultimi_anni integer, \r\n  id_controllo character varying, \r\n  categoria integer, \r\n  last text, \r\n  data_prossimo_controllo timestamp without time zone, \r\n  flag_bb boolean, \r\n  trashed_date timestamp without time zone, \r\n  modified_by integer, \r\n  is_principale boolean, \r\n  stato text, \r\n  id_stabilimento integer, \r\n  id_apiario integer, \r\n  alt_id integer\r\n);\r\n	2	Database
4	Allo stesso modo la view contenente i capitoli si riduce a id, descrizione oltre alla ovvia chiave esterna verso le check list per mantenere il relazione.\r\n	\r\nCREATE OR REPLACE VIEW public.cl_chapts AS \r\n SELECT c.code AS c_id,\r\n    c.description AS c_desc,\r\n    c.range,\r\n    c.level AS c_level,\r\n    c.is_disabilitato AS c_is_disabilitato,\r\n    l.level AS l_level,\r\n    l.description AS l_desc,\r\n    l.short_description AS l_short_desc,\r\n    l.code AS l_id\r\n   FROM checklist_type c\r\n     JOIN lookup_org_catrischio l ON c.catrischio_id = l.code\r\n  WHERE c.enabled AND l.enabled\r\n  ORDER BY l.description, c.description;\r\n\r\n  	4	\N
9	 \r\nLe Gui dell'applicazione sono pagine HTML generate in risposta ad una chiamata client. In generale sono tabelle dinamiche ottenute a partire da template che iterano su un array di righe    \r\n	\r\n  <table class="table table-striped table-bordered table-sm table-condensed">\r\n        \r\n    <thead>\r\n      <tr>\r\n\r\n        <th class="small font-weight-bold">Domanda</th>\r\n        <th class="small font-weight-bold">Sottodomanda</th>\r\n        <th class="small font-weight-bold" colspan="2">Punteggio</th>\r\n      </tr>\r\n    </thead>\r\n\r\n    <tbody>\r\n  {{$chp:=""}}\r\n  {{$dprec:=""}}\r\n  {{$idparent:=""}}\r\n {{range $i, $qst :=   .Qsts_1 }}\r\n\t{{ if ne $chp  $qst.C_desc }} {{$chp = $qst.C_desc}} <tr><td class="text-center chphdr" colspan="5">{{$qst.C_desc}}</td></tr>{{end}}\r\n\t<tr>\r\n        <td class="small {{ if eq $dprec $qst.Domanda }} font-weight-light font-italic{{end}}">{{ $qst.Domanda }}</td>\r\n        <td class="small">{{ $qst.SottoDomanda }}</td>\r\n        <td class="small text-center text-monospace" >\r\n\t\t\t<label>\r\n\t\t\t<input {{ if eq $dprec $qst.Domanda }} disabled data-idparent="{{ $idparent }}" {{else}} {{$idparent = $i}} data-id="{{$i}}"{{end}} onclick="updTot(this);" type="radio" name="q{{$i}}" value="{{ $qst.Punti_si }}" /> SI {{$qst.Punti_si|printf "%03d"}}\r\n\t\t\t</label>\r\n\t\t</td>\r\n        <td class="small text-center text-monospace">\r\n\t\t\t<label>\r\n\t\t\t<input {{ if eq $dprec $qst.Domanda }} disabled data-idparent="{{ $idparent }}" {{else}} data-id="{{$i}}" {{end}} onclick="updTot(this);"type="radio" name="q{{$i}}" value="{{ $qst.Punti_no }}" /> NO {{$qst.Punti_no|printf "%03d"}}\r\n\t\t\t</label>\r\n\t\t</td>\r\n    </tr>\r\n\t{{$dprec = $qst.Domanda}} \t\r\n {{end}}\r\n\t</tbody>\r\n\t</table>\r\n\r\n	9	View basata su HTML templates
1	Scopo dell'applicazione è fornire uno strumento semplificato di accesso alle checklist di valutazione del rischio. Le checklist sono abitualmente utilizzate nell'ambito dei controlli ufficiali di sorveglianza del sistema Gisa e la loro gestione richiede una ampia conoscenza dell'operatività del sistema. A pertire dall'accesso semplificato, diventa possibile eseguire rapide simulazioni finalizzate eventualmente a disposizione degli OSA per auto-valutazione. Un altro utilizzo potrebbe riguardare i referenti regionali addetti alla manutenzione evolutiva delle check list. 	\r\n   \r\n                              \\\\\\\\\\\\\\\r\n                            \\\\\\\\\\\\\\\\\\\\\\\\\r\n                          \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\r\n  -----------,-|           |C>   // )\\\\\\\\|\r\n           ,','|          /    || ,'/////|\r\n---------,','  |         (,    ||   /////\r\n         ||    |          \\\\  ||||//''''|\r\n         ||    |           |||||||     _|\r\n         ||    |______      `````\\____/ \\\r\n         ||    |     ,|         _/_____/ \\\r\n         ||  ,'    ,' |        /          |\r\n         ||,'    ,'   |       |         \\  |\r\n_________|/    ,'     |      /           | |\r\n_____________,'      ,',_____|      |    | |\r\n             |     ,','      |      |    | |\r\n             |   ,','    ____|_____/    /  |\r\n             | ,','  __/ |             /   |\r\n_____________|','   ///_/-------------/   |\r\n              |===========,'\r\n\r\n   	1	Obiettivi perseguiti
8	 La componente di backend è organizzata secondo il pattern architetturale Microservices, le chiamate saranno quindi molto simili a invocazioni di Api REST. Questo livello si occupa sostanzialmente di fare il router istradando le chiamate del client verso il DB e generando le Gui di risposta.  \r\n	\r\napp.Get("/get_chp/{idcl:int}", func(ctx iris.Context) {\t\r\n\t\r\n\tChps := []Chp{}\t\r\n\tid,_ := ctx.Params().GetInt("idcl")\t\r\n\tdb.Raw("select c_id, c_desc from cl_chapts where l_id=? AND not c_is_disabilitato order by 1", id).Find(&Chps)\r\n\tctx.ViewData("Chps", Chps)\r\n\tctx.View("chp.html")\t\r\n})\r\n\r\napp.Get("/get_qst/{idchp:int}", func(ctx iris.Context) {\r\n\t\t\r\n\tQsts := []Qst{}\t\r\n\tid,_ := ctx.Params().GetInt("idchp")\r\n\tdb.Raw("select q_id, domanda, sotto_domanda, punti_si, punti_no from cl_quests cq where id_chap=? order by 1", id).Find(&Qsts)\r\n\tctx.ViewData("Qsts", Qsts)\r\n\tctx.View("qst.html")\t\r\n\t})\r\n\r\napp.Get("/get_chp1/{idcl:int}", func(ctx iris.Context) {\r\n\t\t\r\n\tQsts_1 := []Qst_1{}\r\n\t\r\n\tid,_ := ctx.Params().GetInt("idcl")\r\n\t\r\n\tapp.Logger().Infof(" chapter of l_id: %d", id)\r\n\r\n\tdb.Raw("select q_id, c_desc, domanda, sotto_domanda, punti_si, punti_no from cl_all cq where l_id=? order by 1", id).Find(&Qsts_1)\r\n\r\n\tctx.ViewData("Qsts_1", Qsts_1)\r\n\tctx.View("qst_1.html")\r\n\t\r\n})\r\n\r\n   	8	Controller basato su Microservices
2	Per evitare approcci invasivi, viene utilizzato un DB esterno come wrapper verso il DB Gisa. \r\nOgnuna delle tabelle interessate (audit, audit_checklist, audit_checklist_type) viene replicata tramite una view su tabella remota basata su dblink.\r\nPer evidenziare la corrispondenza 1-a-1 tra dati locali e dati remoti, le view replicano esattamente anche il nome delle tabelle a cui si riferiscono. Questo rappresenta il primo livello dei dati. A partire da questo livello, viene utilizzato un secondo strato di view per modellare in maniera più semplice possibile le entità gerarchiche Checklist, Capitoli, Domande, Sottodomande. \r\nLe view di livello successivo al primo sono identificabili dal prefisso "cl_". 	\r\nCREATE OR REPLACE VIEW public.audit AS\r\nSELECT\r\n  t1.id\r\n, t1.org_id\r\n, t1.livello_rischio\r\n, t1.numero_registrazione\r\n, t1.componenti_gruppo\r\n, t1.note\r\n, t1.data_1\r\n, t1.data_2\r\n, t1.livello_rischio_finale\r\n, t1.tipo_check\r\n, t1.punteggio_ultimi_anni\r\n, t1.id_controllo\r\n, t1.categoria\r\n, t1.last\r\n, t1.data_prossimo_controllo\r\n, t1.flag_bb\r\n, t1.trashed_date\r\n, t1.modified_by\r\n, t1.is_principale\r\n, t1.stato\r\n, t1.id_stabilimento\r\n, t1.id_apiario\r\n, t1.alt_id\r\nFROM\r\n  dblink('dbname=gisa'::text, 'SELECT\r\nid,\r\norg_id,\r\nlivello_rischio,\r\nnumero_registrazione,\r\ncomponenti_gruppo,\r\nnote,\r\ndata_1,\r\ndata_2,\r\nlivello_rischio_finale,\r\ntipo_check,\r\npunteggio_ultimi_anni,\r\nid_controllo,\r\ncategoria,\r\n"last",\r\ndata_prossimo_controllo,\r\nflag_bb,\r\ntrashed_date,\r\nmodified_by,\r\nis_principale,\r\nstato,\r\nid_stabilimento,\r\nid_apiario,\r\nalt_id  \r\nfrom audit'::text) \r\nt1(\r\n  id integer, \r\n  org_id integer, \r\n  livello_rischio integer, \r\n  numero_registrazione character varying(100), \r\n  componenti_gruppo text, \r\n  note text, \r\n  data_1 timestamp without time zone, \r\n  data_2 timestamp without time zone, \r\n  livello_rischio_finale integer, \r\n  tipo_check integer, \r\n  punteggio_ultimi_anni integer, \r\n  id_controllo character varying, \r\n  categoria integer, \r\n  last text, \r\n  data_prossimo_controllo timestamp without time zone, \r\n  flag_bb boolean, \r\n  trashed_date timestamp without time zone, \r\n  modified_by integer, \r\n  is_principale boolean, \r\n  stato text, \r\n  id_stabilimento integer, \r\n  id_apiario integer, \r\n  alt_id integer\r\n);\r\n	2	Database
3	La view contenente le checklist si riduce dunque a poco più che id e descrizione.\r\n	\r\nCREATE OR REPLACE VIEW public.cl_lists AS \r\n SELECT l.code AS l_id,\r\n    l.level AS l_level,\r\n    l.description AS l_desc,\r\n    l.short_description AS l_short_desc,\r\n    l.default_item AS def,\r\n    l.versione AS ver\r\n   FROM lookup_org_catrischio l\r\n  WHERE l.enabled\r\n  ORDER BY l.description, l.short_description;	3	\N
1	Scopo dell'applicazione è fornire uno strumento semplificato di accesso alle checklist di valutazione del rischio. Le checklist sono abitualmente utilizzate nell'ambito dei controlli ufficiali di sorveglianza del sistema Gisa e la loro gestione richiede una ampèia conoscenza dell'operatività del sistema. A pertire dall'accesso semplificato, diventa possibile eseguire rapide simulazioni finalizzate eventualmente a disposizione degli OSA per auto-valutazione. Un altro utilizzo potrebbe riguardare i referenti regionali addetti alla manutenzione evolutiva delle check list. 	\r\n   \r\n                              \\\\\\\\\\\\\\\r\n                            \\\\\\\\\\\\\\\\\\\\\\\\\r\n                          \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\r\n  -----------,-|           |C>   // )\\\\\\\\|\r\n           ,','|          /    || ,'/////|\r\n---------,','  |         (,    ||   /////\r\n         ||    |          \\\\  ||||//''''|\r\n         ||    |           |||||||     _|\r\n         ||    |______      `````\\____/ \\\r\n         ||    |     ,|         _/_____/ \\\r\n         ||  ,'    ,' |        /          |\r\n         ||,'    ,'   |       |         \\  |\r\n_________|/    ,'     |      /           | |\r\n_____________,'      ,',_____|      |    | |\r\n             |     ,','      |      |    | |\r\n             |   ,','    ____|_____/    /  |\r\n             | ,','  __/ |             /   |\r\n_____________|','   ///_/-------------/   |\r\n              |===========,'\r\n\r\n   	1	Obiettivi perseguiti
5	La view delle domande appare invece leggermente più articolata. Lo schema record risultante è una parziale denormalizzazione rispetto alla relazione tra domande e sottodomande che viene linearizzata in maniera molto semplice e intuitiva, e soprattuto molto corrispondente alla modalità di visualizzazione scelta. Da notare che oltre alla struttura domanda-sottodomanda e alla chiave esterna verso il capitolo, viene conservato l'id del record padre. Nel caso delle domande sarà ovviamente non significativo e settato al valore -1. Altra cosa da notare è l'id del record nel caso di domande senza sottodomande è ovviamente univoco mentre nel caso di record relativo alla sottodomanda, poichè come descrizione compare sia la sottodomanda che la domanda parent, l'ambiguità potrebbe nascere. In questo caso va tenuto presente che l'id del record è quello della sottodomanda mentre l'id della domanda viene mantenuto nel capo id parent. Ultima cosa: i punteggi da attribure in caso di risposta SI o NO.	\r\nCREATE OR REPLACE VIEW public.cl_quests AS \r\n SELECT d.id AS q_id,\r\n    d.domanda,\r\n    '-'::text AS sotto_domanda,\r\n    d.parent_id,\r\n    d.punti_no,\r\n    d.punti_si,\r\n    d.grand_parents_id,\r\n    d.checklist_type_id AS id_chap\r\n   FROM checklist d\r\n  WHERE d.enabled AND d.parent_id = '-1'::integer\r\nUNION\r\n SELECT sd.id AS q_id,\r\n    d.domanda,\r\n    sd.domanda AS sotto_domanda,\r\n    sd.parent_id,\r\n    d.punti_no,\r\n    d.punti_si,\r\n    d.grand_parents_id,\r\n    d.checklist_type_id AS id_chap\r\n   FROM checklist d\r\n     JOIN checklist sd ON d.id = sd.parent_id\r\n  WHERE d.enabled AND sd.enabled AND sd.parent_id > '-1'::integer\r\n  ORDER BY 1;\r\n  	5	\N
6	Esiste infine un terzo livello, utilizzato per semplificare la gestione di una singola checklist nella sua completa struttura gerarchica. \r\nIn questa view compaiono le info strettamente necessarie per la generazione della GUI: le varie chiavi, le varie descrizioni e i punteggi SI e NO. A partire da questo tracciato viene generato l''array di oggetti JSON utilizzati per interagire, client side, con la parte html e javascript	\r\nCREATE OR REPLACE VIEW public.cl_all AS \r\n SELECT cl_quests.q_id,\r\n    c.c_id,\r\n    c.l_id,\r\n    c.l_desc,\r\n    c.c_desc,\r\n    cl_quests.domanda,\r\n    cl_quests.sotto_domanda,\r\n    cl_quests.parent_id,\r\n    cl_quests.punti_no,\r\n    cl_quests.punti_si\r\n   FROM cl_chapts c\r\n     LEFT JOIN cl_quests ON cl_quests.id_chap = c.c_id;\r\n  	6	\N
7	Il view-model, o presentation model o comunque la struttura dati fondamentale lato client è dunque la cheklist intesa come lista ordinata di capitoli, domande e sottodomande, con relativi punteggi di risposta affermativa e negativa.   	[\r\n  {\r\n    "l_id": "2022",\r\n    "l_desc": "Esercizio Vendita (rev 3)",\r\n    "c_id": "15188",\r\n    "c_desc": "CAPITOLO I: LOCALI,IMPIANTI ED ATTREZZATURE",\r\n    "parent_id": "-1",\r\n    "q_id": "410208",\r\n    "domanda": "L''azienda è regolarmente registrata?",\r\n    "punti_si": "0",\r\n    "punti_no": "20"\r\n  },\r\n  {\r\n    "l_id": "2022",\r\n    "l_desc": "Esercizio Vendita (rev 3)",\r\n    "c_id": "15188",\r\n    "c_desc": "CAPITOLO I: LOCALI,IMPIANTI ED ATTREZZATURE",\r\n    "parent_id": "-1",\r\n    "q_id": "410209",\r\n    "domanda": "Il o i varchi di accesso per la clientela ed altri eventuali varchi che danno all''esterno,sono chiudibili tramite una o più porte d''ingresso?",\r\n    "punti_si": "0",\r\n    "punti_no": "2"\r\n  },\r\n  {\r\n    "l_id": "2022",\r\n    "l_desc": "Esercizio Vendita (rev 3)",\r\n    "c_id": "15188",\r\n    "c_desc": "CAPITOLO I: LOCALI,IMPIANTI ED ATTREZZATURE",\r\n    "parent_id": "410209",\r\n    "q_id": "410210",\r\n    "domanda": "Il o i varchi di accesso per la clientela ed altri eventuali varchi che danno all''esterno,sono chiudibili tramite una o più porte d''ingresso?",\r\n    "punti_si": "0",\r\n    "punti_no": "2"\r\n  }\r\n]	7	JSON
8	 La componente di backend è organizzata secondo il pattern architetturale Microservices, le chiamate saranno quindi molto simili a invocazioni di Api REST. Questo livello si occupa sostanzialmente di fare il router istadando le chiamate del client verso il DB e generando le Gui di risposta.  \r\n	\r\napp.Get("/get_chp/{idcl:int}", func(ctx iris.Context) {\t\r\n\t\r\n\tChps := []Chp{}\t\r\n\tid,_ := ctx.Params().GetInt("idcl")\t\r\n\tdb.Raw("select c_id, c_desc from cl_chapts where l_id=? AND not c_is_disabilitato order by 1", id).Find(&Chps)\r\n\tctx.ViewData("Chps", Chps)\r\n\tctx.View("chp.html")\t\r\n})\r\n\r\napp.Get("/get_qst/{idchp:int}", func(ctx iris.Context) {\r\n\t\t\r\n\tQsts := []Qst{}\t\r\n\tid,_ := ctx.Params().GetInt("idchp")\r\n\tdb.Raw("select q_id, domanda, sotto_domanda, punti_si, punti_no from cl_quests cq where id_chap=? order by 1", id).Find(&Qsts)\r\n\tctx.ViewData("Qsts", Qsts)\r\n\tctx.View("qst.html")\t\r\n\t})\r\n\r\napp.Get("/get_chp1/{idcl:int}", func(ctx iris.Context) {\r\n\t\t\r\n\tQsts_1 := []Qst_1{}\r\n\t\r\n\tid,_ := ctx.Params().GetInt("idcl")\r\n\t\r\n\tapp.Logger().Infof(" chapter of l_id: %d", id)\r\n\r\n\tdb.Raw("select q_id, c_desc, domanda, sotto_domanda, punti_si, punti_no from cl_all cq where l_id=? order by 1", id).Find(&Qsts_1)\r\n\r\n\tctx.ViewData("Qsts_1", Qsts_1)\r\n\tctx.View("qst_1.html")\r\n\t\r\n})\r\n\r\n   	8	Controller basato su Microservices
9	 \r\nLe Gui dell'applicazione sono pagine HTML generate in risposta ad una chiamata client. In generale sono tabelle dinamiche ottenute a partire da template che iterano su un array di righe    \r\n	\r\n  <table class="table table-striped table-bordered table-sm table-condensed">\r\n        \r\n    <thead>\r\n      <tr>\r\n\r\n        <th class="small font-weight-bold">Domanda</th>\r\n        <th class="small font-weight-bold">Sottodomanda</th>\r\n        <th class="small font-weight-bold" colspan="2">Punteggio</th>\r\n      </tr>\r\n    </thead>\r\n\r\n    <tbody>\r\n  {{$chp:=""}}\r\n  {{$dprec:=""}}\r\n  {{$idparent:=""}}\r\n {{range $i, $qst :=   .Qsts_1 }}\r\n\t{{ if ne $chp  $qst.C_desc }} {{$chp = $qst.C_desc}} <tr><td class="text-center chphdr" colspan="5">{{$qst.C_desc}}</td></tr>{{end}}\r\n\t<tr>\r\n        <td class="small {{ if eq $dprec $qst.Domanda }} font-weight-light font-italic{{end}}">{{ $qst.Domanda }}</td>\r\n        <td class="small">{{ $qst.SottoDomanda }}</td>\r\n        <td class="small text-center text-monospace" >\r\n\t\t\t<label>\r\n\t\t\t<input {{ if eq $dprec $qst.Domanda }} disabled data-idparent="{{ $idparent }}" {{else}} {{$idparent = $i}} data-id="{{$i}}"{{end}} onclick="updTot(this);" type="radio" name="q{{$i}}" value="{{ $qst.Punti_si }}" /> SI {{$qst.Punti_si|printf "%03d"}}\r\n\t\t\t</label>\r\n\t\t</td>\r\n        <td class="small text-center text-monospace">\r\n\t\t\t<label>\r\n\t\t\t<input {{ if eq $dprec $qst.Domanda }} disabled data-idparent="{{ $idparent }}" {{else}} data-id="{{$i}}" {{end}} onclick="updTot(this);"type="radio" name="q{{$i}}" value="{{ $qst.Punti_no }}" /> NO {{$qst.Punti_no|printf "%03d"}}\r\n\t\t\t</label>\r\n\t\t</td>\r\n    </tr>\r\n\t{{$dprec = $qst.Domanda}} \t\r\n {{end}}\r\n\t</tbody>\r\n\t</table>\r\n\r\n	9	View basata su HTML templates
10	 \r\nE' possibile salvare le checklist compilate esportandole su file. Il formato JSON garantisce interoperabilità verso eventuali applicazioni di terze parti. Tutto il processo viene gestito client side in javascript.     \r\n	\r\nfunction exportjson() {\r\n\r\n\tvar j=JSON.stringify(jsonContent, null, 2);\r\n\tvar ar=[];\r\n\tar.push(j);\r\n\tvar blob = new Blob(ar, {type: "text/plain;charset=utf-8"});\r\n\r\n\tif (confirm(ar)) {\r\n\t\tsaveAs(blob, "json.txt");\r\n\t}\r\n}\r\n	10	Export checklist
\.


--
-- TOC entry 4317 (class 0 OID 367647)
-- Dependencies: 244
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config (host, dbname, "user", password, port) FROM stdin;
127.0.0.1	gisa	postgres		5432
\.


--
-- TOC entry 4313 (class 0 OID 367584)
-- Dependencies: 228
-- Data for Name: log_access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_access (id, id_utente, entered, id_asl, ip) FROM stdin;
1372	-786	2022-06-27 15:59:46.243581	-1	127.0.0.1
1373	-787	2022-06-27 16:48:15.83807	-1	127.0.0.1
1374	-788	2022-06-27 17:09:40.146393	-1	127.0.0.1
1375	-789	2022-06-28 06:47:29.52886	-1	127.0.0.1
1376	-790	2022-06-28 08:43:58.553189	-1	127.0.0.1
1377	-791	2022-06-28 08:45:36.835645	-1	127.0.0.1
1378	-792	2022-06-28 08:54:33.146199	-1	127.0.0.1
1379	-793	2022-06-28 08:54:59.773784	-1	127.0.0.1
1380	-794	2022-06-28 08:57:34.767421	-1	127.0.0.1
1381	-795	2022-06-28 10:43:37.841192	-1	127.0.0.1
1382	-796	2022-06-28 13:10:41.802533	-1	127.0.0.1
1383	-797	2022-06-29 08:55:49.409508	-1	127.0.0.1
1384	-798	2022-06-29 10:19:39.883018	-1	127.0.0.1
1385	-799	2022-06-29 10:52:27.565221	-1	127.0.0.1
1386	-800	2022-06-29 10:52:41.914458	-1	127.0.0.1
1387	-801	2022-06-29 11:00:58.044064	-1	127.0.0.1
1388	-802	2022-06-29 11:09:17.801072	-1	127.0.0.1
1389	-803	2022-06-29 13:11:28.752182	-1	127.0.0.1
1390	-888	2022-07-11 09:26:22.186209	-1	127.0.0.1
1391	-889	2022-07-11 10:10:43.39703	-1	127.0.0.1
1392	-891	2022-07-11 17:58:08.21044	-1	127.0.0.1
1393	-892	2022-07-12 10:16:13.754836	-1	127.0.0.1
1394	-893	2022-07-12 11:07:58.187692	-1	127.0.0.1
1395	-894	2022-07-12 12:10:10.47845	-1	127.0.0.1
1396	-895	2022-07-12 12:10:46.681847	-1	127.0.0.1
1397	-896	2022-07-12 12:11:26.385328	-1	127.0.0.1
1398	-898	2022-07-12 15:40:25.071751	-1	127.0.0.1
1399	-900	2022-07-12 16:13:06.183274	-1	127.0.0.1
1401	-902	2022-07-13 09:24:28.928333	-1	127.0.0.1
1402	-904	2022-07-13 10:25:17.099947	-1	127.0.0.1
1404	-907	2022-07-14 08:56:04.555473	-1	127.0.0.1
1405	-908	2022-07-14 19:43:46.668515	-1	127.0.0.1
1407	-913	2022-07-18 13:53:52.242609	-1	127.0.0.1
1409	-915	2022-07-18 21:57:01.570501	-1	127.0.0.1
1410	-916	2022-07-20 10:34:40.020068	-1	127.0.0.1
1411	-917	2022-07-20 14:19:20.732445	-1	127.0.0.1
1412	-919	2022-07-21 08:42:13.926925	-1	127.0.0.1
1413	-920	2022-07-21 18:13:35.833712	-1	127.0.0.1
1414	-923	2022-07-21 21:51:26.936582	-1	127.0.0.1
1415	-924	2022-07-22 10:21:39.155277	-1	127.0.0.1
1416	-925	2022-07-25 10:40:13.661429	-1	127.0.0.1
1417	-929	2022-07-25 13:50:00.178815	-1	127.0.0.1
1418	-930	2022-07-25 17:27:55.680919	-1	127.0.0.1
1419	-931	2022-07-26 13:09:58.6158	-1	127.0.0.1
1420	-932	2022-07-26 13:10:27.015526	-1	127.0.0.1
1421	-933	2022-07-27 10:54:46.869931	-1	127.0.0.1
1422	-934	2022-07-27 14:33:29.94296	-1	127.0.0.1
1423	-935	2022-07-27 14:35:43.54726	-1	127.0.0.1
1424	-936	2022-07-27 16:59:16.82382	-1	127.0.0.1
1425	-937	2022-07-27 20:23:43.685665	-1	127.0.0.1
1426	-939	2022-07-28 13:13:56.423727	-1	127.0.0.1
1427	-940	2022-07-28 17:43:49.167947	-1	127.0.0.1
1428	-943	2022-08-02 10:37:52.897789	-1	127.0.0.1
1429	-945	2022-08-03 14:38:51.938415	-1	127.0.0.1
1430	-946	2022-08-06 14:31:48.138499	-1	127.0.0.1
1431	-947	2022-08-09 22:58:22.486166	-1	127.0.0.1
1432	-948	2022-08-10 14:34:25.835743	-1	127.0.0.1
1433	-949	2022-08-11 12:36:56.956478	-1	127.0.0.1
1434	-950	2022-08-11 12:37:12.572908	-1	127.0.0.1
1436	-952	2022-08-12 12:34:13.416148	-1	127.0.0.1
1437	-953	2022-08-12 12:42:57.869346	-1	127.0.0.1
1438	-954	2022-08-12 12:56:47.749572	-1	127.0.0.1
1439	-956	2022-08-12 14:01:34.902678	-1	127.0.0.1
1440	-958	2022-08-12 14:04:38.090465	-1	127.0.0.1
1441	-959	2022-08-12 15:39:06.744588	-1	127.0.0.1
1442	-960	2022-08-12 18:25:58.958755	-1	127.0.0.1
1443	-961	2022-08-12 18:57:38.39644	-1	127.0.0.1
1444	-962	2022-08-12 19:46:04.940398	-1	127.0.0.1
1445	-963	2022-08-13 08:22:42.761394	-1	127.0.0.1
1446	-964	2022-08-13 18:55:26.95007	-1	127.0.0.1
1447	-965	2022-08-14 20:08:47.452513	-1	127.0.0.1
1448	-967	2022-08-15 04:27:09.40609	-1	127.0.0.1
1449	-968	2022-08-16 08:02:00.004515	-1	127.0.0.1
1450	-969	2022-08-16 09:06:02.562942	-1	127.0.0.1
1451	-972	2022-08-16 10:45:56.706566	-1	127.0.0.1
1452	-973	2022-08-16 13:01:39.966271	-1	127.0.0.1
1453	-974	2022-08-17 00:04:55.65502	-1	127.0.0.1
1454	-975	2022-08-17 08:20:34.191098	-1	127.0.0.1
1455	-976	2022-08-17 15:50:20.767084	-1	127.0.0.1
1456	-977	2022-08-18 16:36:46.209584	-1	127.0.0.1
1457	-978	2022-08-18 17:45:37.362455	-1	127.0.0.1
1458	-980	2022-08-19 08:21:22.035133	-1	127.0.0.1
1459	-981	2022-08-19 10:05:14.343631	-1	127.0.0.1
1460	-982	2022-08-19 10:05:50.26901	-1	127.0.0.1
1461	-983	2022-08-19 10:14:50.137116	-1	127.0.0.1
1462	-984	2022-08-19 10:25:46.470569	-1	127.0.0.1
1463	-985	2022-08-19 10:43:32.438741	-1	127.0.0.1
1464	-986	2022-08-19 11:01:01.445844	-1	127.0.0.1
1465	-988	2022-08-19 11:13:35.394148	-1	127.0.0.1
1466	-989	2022-08-19 11:26:11.496053	-1	127.0.0.1
1467	-990	2022-08-19 12:20:54.097935	-1	127.0.0.1
1468	-991	2022-08-21 19:02:10.42471	-1	127.0.0.1
1469	-992	2022-08-22 10:17:07.814965	-1	127.0.0.1
1470	-993	2022-08-22 10:17:15.256055	-1	127.0.0.1
1471	-994	2022-08-22 10:17:29.176309	-1	127.0.0.1
1472	-995	2022-08-22 10:18:00.730749	-1	127.0.0.1
1473	-996	2022-08-22 10:48:22.305772	-1	127.0.0.1
1474	-997	2022-08-22 11:16:51.280496	-1	127.0.0.1
1475	-998	2022-08-22 15:13:46.908868	-1	127.0.0.1
1476	-999	2022-08-23 18:10:56.681374	-1	127.0.0.1
1477	-1001	2022-08-24 13:22:36.264197	-1	127.0.0.1
1478	-1002	2022-08-24 16:59:00.683003	-1	127.0.0.1
1479	-1003	2022-08-24 17:56:55.22553	-1	127.0.0.1
1480	-1004	2022-08-24 23:37:52.059899	-1	127.0.0.1
1481	-1005	2022-08-25 13:09:08.626524	-1	127.0.0.1
1482	-1006	2022-08-25 19:29:47.57393	-1	127.0.0.1
1483	-1011	2022-08-26 18:51:11.542942	-1	127.0.0.1
1484	-1013	2022-08-28 14:07:33.089289	-1	127.0.0.1
1485	-1014	2022-08-29 09:43:54.831305	-1	127.0.0.1
1486	-1015	2022-08-29 12:52:35.108488	-1	127.0.0.1
1487	-1016	2022-08-29 12:52:56.947572	-1	127.0.0.1
1488	-1017	2022-08-29 14:13:35.407252	-1	127.0.0.1
1489	-1018	2022-08-29 15:31:06.402043	-1	127.0.0.1
1490	-1019	2022-08-30 09:35:53.04589	-1	127.0.0.1
1491	-1020	2022-08-30 09:37:05.57306	-1	127.0.0.1
1492	-1021	2022-08-30 09:43:14.406148	-1	127.0.0.1
1493	-1022	2022-08-30 09:49:56.497672	-1	127.0.0.1
1494	-1023	2022-08-30 10:56:40.8577	-1	127.0.0.1
1495	-1024	2022-08-30 12:38:33.481894	-1	127.0.0.1
1400	-901	2022-07-12 16:13:14.500165	-1	127.0.0.1
1403	-906	2022-07-13 11:57:12.872642	-1	127.0.0.1
1406	-912	2022-07-18 13:51:01.602388	-1	127.0.0.1
1408	-914	2022-07-18 21:56:37.969083	-1	127.0.0.1
1496	-1025	2022-08-30 12:38:48.287605	-1	127.0.0.1
1497	-1027	2022-08-30 12:41:20.788466	-1	127.0.0.1
239	-81	2021-06-15 09:34:31.781648	-1	151.73.210.134
1498	-1028	2022-08-30 12:43:13.991063	-1	127.0.0.1
1499	-1029	2022-08-30 12:44:39.39453	-1	127.0.0.1
1500	-1031	2022-08-30 16:30:19.679714	-1	127.0.0.1
1501	-1032	2022-08-31 11:26:29.343397	-1	127.0.0.1
1503	-1034	2022-09-01 08:27:38.606896	-1	127.0.0.1
1504	-1035	2022-09-01 08:41:53.976518	-1	127.0.0.1
1506	-1037	2022-09-01 17:50:07.108984	-1	127.0.0.1
1507	-1038	2022-09-02 13:13:55.389771	-1	127.0.0.1
1508	-1039	2022-09-02 15:42:36.356067	-1	127.0.0.1
1510	-1041	2022-09-05 16:54:47.677041	-1	127.0.0.1
1512	-1043	2022-09-06 10:28:05.358924	-1	127.0.0.1
1515	-1049	2022-09-07 13:54:35.963024	-1	127.0.0.1
1517	-1051	2022-09-08 10:30:37.802224	-1	127.0.0.1
1518	-1052	2022-09-08 10:35:35.978806	-1	127.0.0.1
1520	-1054	2022-09-08 18:30:56.472109	-1	127.0.0.1
1523	-1058	2022-09-12 16:03:18.232138	-1	127.0.0.1
260	10010286	2021-06-15 12:04:47.740277	201	151.73.210.134
261	10010286	2021-06-15 12:05:05.056421	201	151.73.210.134
1525	-1060	2022-09-12 16:38:31.497984	-1	127.0.0.1
1528	-1063	2022-09-13 12:00:46.094275	-1	127.0.0.1
1531	-1066	2022-09-14 01:55:31.655012	-1	127.0.0.1
1533	-1070	2022-09-16 16:55:23.654466	-1	127.0.0.1
1534	-1071	2022-09-17 08:19:15.325908	-1	127.0.0.1
1536	-1073	2022-09-20 11:08:32.210853	-1	127.0.0.1
1539	-1077	2022-09-21 08:28:52.839415	-1	127.0.0.1
1543	-1083	2022-09-21 22:54:05.889542	-1	127.0.0.1
1545	-1086	2022-09-22 10:36:20.643998	-1	127.0.0.1
1548	-1089	2022-09-24 12:42:38.727884	-1	127.0.0.1
304	10010285	2021-06-17 09:55:40.400076	207	93.40.228.221
305	10010285	2021-06-17 09:55:57.349057	207	93.40.228.221
306	-103	2021-06-17 09:56:40.985888	-1	93.40.228.221
307	10010285	2021-06-17 10:19:55.55127	207	93.40.228.221
308	-104	2021-06-17 10:46:22.686134	-1	93.40.228.221
314	-108	2021-06-18 17:08:12.252419	-1	79.18.159.211
320	-113	2021-06-24 12:29:07.993567	-1	79.18.159.211
1502	-1033	2022-08-31 16:33:33.675087	-1	127.0.0.1
1505	-1036	2022-09-01 14:07:07.019959	-1	127.0.0.1
1509	-1040	2022-09-02 18:03:44.665619	-1	127.0.0.1
1511	-1042	2022-09-05 20:07:37.326041	-1	127.0.0.1
1516	-1050	2022-09-08 08:17:03.100135	-1	127.0.0.1
1519	-1053	2022-09-08 11:07:49.207908	-1	127.0.0.1
1521	-1055	2022-09-11 23:04:40.237128	-1	127.0.0.1
1522	-1056	2022-09-12 08:52:03.842573	-1	127.0.0.1
1524	-1059	2022-09-12 16:04:04.384162	-1	127.0.0.1
1526	-1061	2022-09-12 16:39:38.784722	-1	127.0.0.1
1527	-1062	2022-09-13 09:35:44.437034	-1	127.0.0.1
1529	-1064	2022-09-13 15:16:38.715163	-1	127.0.0.1
1530	-1065	2022-09-14 01:55:29.689789	-1	127.0.0.1
1532	-1069	2022-09-16 10:13:40.451571	-1	127.0.0.1
1535	-1072	2022-09-20 11:07:47.465436	-1	127.0.0.1
1537	-1075	2022-09-20 14:32:13.000104	-1	127.0.0.1
1538	-1076	2022-09-20 16:21:07.889426	-1	127.0.0.1
1540	-1078	2022-09-21 10:11:08.138071	-1	127.0.0.1
1541	-1080	2022-09-21 12:59:07.142606	-1	127.0.0.1
1542	-1082	2022-09-21 22:54:03.906032	-1	127.0.0.1
1544	-1085	2022-09-22 09:55:19.281439	-1	127.0.0.1
1546	-1087	2022-09-22 19:20:56.762084	-1	127.0.0.1
1547	-1088	2022-09-23 15:29:07.889247	-1	127.0.0.1
1549	-1090	2022-09-26 10:51:52.518618	-1	127.0.0.1
1550	-1091	2022-09-30 08:09:48.389148	-1	127.0.0.1
1551	-1092	2022-09-30 11:06:48.937807	-1	127.0.0.1
1552	-1094	2022-09-30 12:22:53.306821	-1	127.0.0.1
1553	-1095	2022-09-30 14:55:31.380368	-1	127.0.0.1
1554	-1098	2022-10-03 12:24:14.222628	-1	127.0.0.1
1555	-1099	2022-10-03 12:40:54.47381	-1	127.0.0.1
1556	-1101	2022-10-07 10:50:54.154696	-1	127.0.0.1
1557	-1102	2022-10-07 10:51:29.831962	-1	127.0.0.1
1558	-1103	2022-10-07 20:33:28.734662	-1	127.0.0.1
1559	-1104	2022-10-08 00:40:18.830698	-1	127.0.0.1
1560	-1108	2022-10-11 09:47:09.926609	-1	127.0.0.1
1561	-1109	2022-10-12 07:32:41.985835	-1	127.0.0.1
1562	-1110	2022-10-12 08:51:50.198403	-1	127.0.0.1
1563	-1113	2022-10-12 15:11:35.31245	-1	127.0.0.1
1564	-1114	2022-10-13 17:15:18.809841	-1	127.0.0.1
1565	-1115	2022-10-15 07:26:44.066863	-1	127.0.0.1
1566	-1116	2022-10-15 12:50:23.085585	-1	127.0.0.1
1567	-1117	2022-10-15 21:42:05.59632	-1	127.0.0.1
1568	-1118	2022-10-18 12:20:17.797017	-1	127.0.0.1
1569	-1120	2022-10-18 12:44:03.178036	-1	127.0.0.1
1570	-1121	2022-10-18 22:43:53.814132	-1	127.0.0.1
1571	-1122	2022-10-19 15:48:23.15518	-1	127.0.0.1
1572	-1123	2022-10-20 13:12:50.375481	-1	127.0.0.1
1573	-1124	2022-10-24 12:44:03.615254	-1	127.0.0.1
1574	-1125	2022-10-24 15:00:37.242024	-1	127.0.0.1
1575	-1126	2022-10-25 10:41:06.678689	-1	127.0.0.1
1576	-1127	2022-10-25 10:41:22.262984	-1	127.0.0.1
1577	-1129	2022-10-25 10:43:43.302585	-1	127.0.0.1
1578	-1130	2022-10-25 13:45:50.892409	-1	127.0.0.1
1579	-1132	2022-10-27 12:34:42.05345	-1	127.0.0.1
1580	-1133	2022-10-27 17:01:05.583284	-1	127.0.0.1
1581	-1134	2022-10-27 17:34:32.703968	-1	127.0.0.1
1582	-1135	2022-10-27 22:49:28.298778	-1	127.0.0.1
1583	-1137	2022-10-28 10:25:43.242378	-1	127.0.0.1
1584	-1138	2022-10-28 15:40:11.150523	-1	127.0.0.1
1585	-1139	2022-10-28 15:50:26.427471	-1	127.0.0.1
1586	-1140	2022-10-28 16:03:50.73731	-1	127.0.0.1
1587	-1141	2022-10-28 19:18:16.921762	-1	127.0.0.1
1588	-1142	2022-10-31 11:22:02.439252	-1	127.0.0.1
1589	-1143	2022-10-31 21:04:10.272734	-1	127.0.0.1
1590	-1144	2022-11-01 10:42:23.000471	-1	127.0.0.1
1591	-1147	2022-11-03 16:11:22.375488	-1	127.0.0.1
1592	-1148	2022-11-03 18:57:06.309245	-1	127.0.0.1
415	-139	2021-09-17 00:23:21.011611	-1	159.65.88.214
1593	-1149	2022-11-04 08:09:46.306916	-1	127.0.0.1
1594	-1150	2022-11-04 23:50:09.550983	-1	127.0.0.1
1595	-1151	2022-11-06 21:48:30.573353	-1	127.0.0.1
1596	-1152	2022-11-09 10:10:12.853471	-1	127.0.0.1
1597	-1153	2022-11-10 12:48:39.388489	-1	127.0.0.1
1598	-1156	2022-11-10 13:09:42.915998	-1	127.0.0.1
1599	-1158	2022-11-10 13:11:28.833116	-1	127.0.0.1
1600	-1160	2022-11-10 13:17:57.794138	-1	127.0.0.1
1601	-1162	2022-11-10 15:03:56.075865	-1	127.0.0.1
1602	-1163	2022-11-10 18:10:51.526426	-1	127.0.0.1
1603	-1164	2022-11-11 18:13:06.766616	-1	127.0.0.1
1604	-1166	2022-11-14 10:18:20.723341	-1	127.0.0.1
1605	-1167	2022-11-14 21:16:03.682705	-1	127.0.0.1
1606	-1168	2022-11-14 23:08:30.002091	-1	127.0.0.1
1607	-1170	2022-11-15 10:51:38.273039	-1	127.0.0.1
1608	-1171	2022-11-17 09:22:24.830641	-1	127.0.0.1
1609	-1172	2022-11-17 12:50:11.048656	-1	127.0.0.1
1610	-1173	2022-11-17 13:45:20.586001	-1	127.0.0.1
1611	-1174	2022-11-17 13:45:40.115929	-1	127.0.0.1
1612	-1175	2022-11-18 08:50:21.19438	-1	127.0.0.1
1613	-1176	2022-11-21 09:56:34.615986	-1	127.0.0.1
1614	-1177	2022-11-21 21:02:33.069652	-1	127.0.0.1
1615	-1178	2022-11-22 14:01:30.141148	-1	127.0.0.1
1616	-1181	2022-11-23 11:54:11.680354	-1	127.0.0.1
1617	-1182	2022-11-24 11:04:19.240702	-1	127.0.0.1
1618	-1184	2022-11-24 20:06:59.081932	-1	127.0.0.1
1619	-1185	2022-11-24 20:07:01.124198	-1	127.0.0.1
1620	-1186	2022-11-27 07:39:43.630313	-1	127.0.0.1
1621	-1187	2022-11-28 15:00:38.316308	-1	127.0.0.1
1622	-1188	2022-11-28 20:10:57.671773	-1	127.0.0.1
1623	-1189	2022-12-06 10:36:59.923448	-1	127.0.0.1
1624	-1191	2022-12-08 23:00:44.113934	-1	127.0.0.1
1625	-1192	2022-12-09 18:06:47.521571	-1	127.0.0.1
1626	-1193	2022-12-12 10:44:17.833297	-1	127.0.0.1
1627	-1194	2022-12-12 12:38:17.901841	-1	127.0.0.1
1628	-1195	2022-12-12 17:47:39.139479	-1	127.0.0.1
1629	-1196	2022-12-15 20:23:05.635802	-1	127.0.0.1
1630	-1198	2022-12-19 11:47:50.589129	-1	127.0.0.1
1631	-1200	2022-12-19 12:03:13.626853	-1	127.0.0.1
1632	-1201	2022-12-19 12:09:32.904381	-1	127.0.0.1
1633	-1204	2022-12-20 09:45:21.668186	-1	127.0.0.1
1634	-1205	2022-12-21 11:56:27.485618	-1	127.0.0.1
1635	-1206	2022-12-21 12:09:09.454337	-1	127.0.0.1
1636	-1207	2022-12-30 14:59:29.18036	-1	127.0.0.1
1637	-1208	2023-01-02 12:44:07.191748	-1	127.0.0.1
1638	-1209	2023-01-05 22:55:54.141999	-1	127.0.0.1
1639	-1210	2023-01-08 10:11:20.181519	-1	127.0.0.1
1640	-1212	2023-01-08 10:22:07.717395	-1	127.0.0.1
1641	-1213	2023-01-08 13:22:04.57857	-1	127.0.0.1
1642	-1215	2023-01-10 15:09:53.985593	-1	127.0.0.1
1643	-1217	2023-01-13 07:24:02.994642	-1	127.0.0.1
1644	-1218	2023-01-13 12:40:02.188466	-1	127.0.0.1
1645	-1219	2023-01-13 12:59:18.940629	-1	127.0.0.1
1646	-1220	2023-01-16 11:10:47.847036	-1	127.0.0.1
1647	-1221	2023-01-16 11:55:03.282687	-1	127.0.0.1
1648	-1222	2023-01-16 12:21:14.927233	-1	127.0.0.1
1649	-1223	2023-01-16 17:33:24.79842	-1	127.0.0.1
1650	-1224	2023-01-17 15:40:15.141849	-1	127.0.0.1
1651	-1225	2023-01-17 16:40:17.260237	-1	127.0.0.1
1652	-1226	2023-01-18 08:48:49.699678	-1	127.0.0.1
1653	-1227	2023-01-18 12:16:16.362007	-1	127.0.0.1
1654	-1228	2023-01-18 12:52:11.775524	-1	127.0.0.1
1655	-1229	2023-01-18 15:19:08.595924	-1	127.0.0.1
1656	-1231	2023-01-19 12:00:59.883041	-1	127.0.0.1
1657	-1232	2023-01-19 13:09:02.70328	-1	127.0.0.1
1658	-1234	2023-01-19 15:13:15.608817	-1	127.0.0.1
1659	-1235	2023-01-19 17:27:44.801586	-1	127.0.0.1
1660	-1236	2023-01-19 18:54:33.027685	-1	127.0.0.1
483	10010299	2021-09-23 08:34:05.55745	202	151.70.214.213
486	10010301	2021-09-23 08:41:21.486355	205	151.70.214.213
528	-180	2021-09-23 10:14:34.43133	-1	93.40.225.109
530	-181	2021-09-23 10:31:23.687267	-1	93.40.225.109
555	10010306	2021-09-28 14:47:04.974961	201	151.70.214.213
1661	-1237	2023-01-23 11:23:43.51285	-1	127.0.0.1
1662	-1238	2023-01-25 16:45:05.363262	-1	127.0.0.1
560	10010306	2021-09-28 14:49:32.858832	201	151.70.214.213
1663	-1239	2023-01-27 10:53:43.552985	-1	127.0.0.1
1664	-1240	2023-01-27 21:58:53.514448	-1	127.0.0.1
1665	-1241	2023-01-30 17:39:07.371731	-1	127.0.0.1
1666	-1242	2023-01-31 02:57:47.650294	-1	127.0.0.1
1667	-1243	2023-02-01 14:34:33.277861	-1	127.0.0.1
1668	-1244	2023-02-03 08:57:16.730209	-1	127.0.0.1
1669	-1245	2023-02-03 15:28:43.600022	-1	127.0.0.1
1670	-1246	2023-02-04 11:33:08.569324	-1	127.0.0.1
1671	-1247	2023-02-05 10:43:53.685679	-1	127.0.0.1
1672	-1248	2023-02-05 11:09:22.626012	-1	127.0.0.1
1673	-1249	2023-02-05 11:30:50.284982	-1	127.0.0.1
1674	-1250	2023-02-05 12:49:49.11344	-1	127.0.0.1
1675	-1251	2023-02-05 19:18:16.637452	-1	127.0.0.1
1676	-1252	2023-02-06 16:03:52.224683	-1	127.0.0.1
1677	-1254	2023-02-06 16:15:30.878523	-1	127.0.0.1
1678	-1255	2023-02-06 16:16:10.935283	-1	127.0.0.1
1679	-1256	2023-02-07 15:12:31.757596	-1	127.0.0.1
1680	-1257	2023-02-10 10:44:48.322096	-1	127.0.0.1
1681	-1258	2023-02-12 10:27:50.475328	-1	127.0.0.1
1682	-1259	2023-02-13 11:35:20.487517	-1	127.0.0.1
1683	-1261	2023-02-13 16:09:35.198401	-1	127.0.0.1
1684	-1262	2023-02-13 16:09:53.332701	-1	127.0.0.1
1685	-1263	2023-02-13 16:10:25.920686	-1	127.0.0.1
1686	-1265	2023-02-14 10:12:10.982634	-1	127.0.0.1
1687	-1266	2023-02-14 10:12:50.021339	-1	127.0.0.1
1688	-1267	2023-02-14 10:21:16.755131	-1	127.0.0.1
588	10010314	2021-09-30 11:45:15.680412	207	151.70.214.213
1689	-1268	2023-02-14 10:26:03.161362	-1	127.0.0.1
590	10010313	2021-09-30 11:46:47.224793	205	151.70.214.213
1690	-1269	2023-02-14 10:36:34.059293	-1	127.0.0.1
1691	-1270	2023-02-14 10:36:43.638859	-1	127.0.0.1
1692	-1271	2023-02-14 10:37:13.37634	-1	127.0.0.1
1693	-1272	2023-02-14 10:39:02.223906	-1	127.0.0.1
1694	-1273	2023-02-14 10:43:12.817656	-1	127.0.0.1
1695	-1274	2023-02-14 11:15:23.092491	-1	127.0.0.1
1696	-1275	2023-02-14 11:21:50.00802	-1	127.0.0.1
1697	-1278	2023-02-14 11:56:06.551914	-1	127.0.0.1
1698	-1279	2023-02-14 11:56:12.446142	-1	127.0.0.1
1699	-1280	2023-02-14 11:56:22.292128	-1	127.0.0.1
1700	-1281	2023-02-14 11:58:15.725372	-1	127.0.0.1
1701	-1283	2023-02-14 11:58:45.10794	-1	127.0.0.1
1702	-1284	2023-02-14 12:00:19.332368	-1	127.0.0.1
1703	-1285	2023-02-14 12:00:26.410792	-1	127.0.0.1
1704	-1286	2023-02-14 12:00:35.931788	-1	127.0.0.1
1705	-1288	2023-02-14 12:00:52.504852	-1	127.0.0.1
1706	-1289	2023-02-14 12:06:48.441954	-1	127.0.0.1
1707	-1290	2023-02-14 12:55:35.321741	-1	127.0.0.1
1708	-1291	2023-02-14 13:27:33.444739	-1	127.0.0.1
1709	-1292	2023-02-14 17:10:00.362955	-1	127.0.0.1
1710	-1293	2023-02-15 13:26:18.054595	-1	127.0.0.1
1711	-1294	2023-02-17 09:08:23.324199	-1	127.0.0.1
1712	-1295	2023-02-18 19:19:31.020544	-1	127.0.0.1
1713	-1297	2023-02-22 12:06:45.682978	-1	127.0.0.1
1714	-1298	2023-02-23 11:35:05.927275	-1	127.0.0.1
1715	-1300	2023-02-23 14:57:09.419091	-1	127.0.0.1
1716	-1301	2023-02-23 16:07:30.123758	-1	127.0.0.1
1717	-1302	2023-02-23 16:07:50.614243	-1	127.0.0.1
1718	-1303	2023-02-25 16:38:52.860298	-1	127.0.0.1
1719	-1304	2023-02-25 22:22:58.946532	-1	127.0.0.1
1720	-1305	2023-02-25 23:55:15.085482	-1	127.0.0.1
1721	-1307	2023-02-28 12:03:18.637818	-1	127.0.0.1
1722	-1308	2023-02-28 12:03:36.730137	-1	127.0.0.1
624	-211	2021-09-30 15:11:17.484975	-1	151.70.214.213
1723	-1309	2023-03-01 09:37:14.252512	-1	127.0.0.1
1724	-1311	2023-03-01 10:15:40.507707	-1	127.0.0.1
1725	-1313	2023-03-01 13:44:53.066824	-1	127.0.0.1
1726	-1314	2023-03-01 13:45:07.263384	-1	127.0.0.1
1727	-1315	2023-03-02 18:28:38.508271	-1	127.0.0.1
1728	-1316	2023-03-03 16:18:23.260648	-1	127.0.0.1
1729	-1317	2023-03-03 18:59:21.500882	-1	127.0.0.1
1730	-1318	2023-03-07 11:54:49.036575	-1	127.0.0.1
1731	-1319	2023-03-09 13:30:24.734127	-1	127.0.0.1
1732	-1321	2023-03-10 16:04:07.53629	-1	127.0.0.1
1733	-1322	2023-03-13 21:46:21.520017	-1	127.0.0.1
1734	-1323	2023-03-13 21:52:35.088721	-1	127.0.0.1
1735	-1324	2023-03-14 17:13:19.964214	-1	127.0.0.1
1736	-1325	2023-03-14 17:13:31.038545	-1	127.0.0.1
1737	-1326	2023-03-15 09:29:13.658999	-1	127.0.0.1
1738	-1327	2023-03-17 22:28:01.913003	-1	127.0.0.1
1739	-1328	2023-03-21 12:24:46.174761	-1	127.0.0.1
1740	-1329	2023-03-21 13:30:40.073928	-1	127.0.0.1
1741	-1331	2023-03-21 18:40:07.285413	-1	127.0.0.1
1742	-1332	2023-03-22 08:04:01.106806	-1	127.0.0.1
1743	-1333	2023-03-23 10:11:32.395459	-1	127.0.0.1
1744	-1334	2023-03-23 13:58:30.798824	-1	127.0.0.1
1745	-1335	2023-03-24 12:08:53.245588	-1	127.0.0.1
1746	-1336	2023-03-25 03:42:36.243177	-1	127.0.0.1
1747	-1337	2023-03-27 10:27:19.473643	-1	127.0.0.1
1748	-1338	2023-03-27 10:48:36.370567	-1	127.0.0.1
1749	-1339	2023-03-28 11:22:19.202733	-1	127.0.0.1
1750	-1340	2023-03-28 14:54:13.705962	-1	127.0.0.1
1751	-1341	2023-03-28 22:24:00.049277	-1	127.0.0.1
1752	-1342	2023-03-29 14:45:40.216538	-1	127.0.0.1
1753	-1343	2023-03-30 14:18:40.970845	-1	127.0.0.1
1754	-1345	2023-03-30 17:59:58.510458	-1	127.0.0.1
1755	-1346	2023-03-30 22:40:21.434385	-1	127.0.0.1
1756	-1348	2023-03-31 09:25:40.508066	-1	127.0.0.1
1757	-1349	2023-03-31 22:32:46.165618	-1	127.0.0.1
1758	-1350	2023-04-02 19:13:16.402208	-1	127.0.0.1
1759	-1351	2023-04-02 19:50:51.863739	-1	127.0.0.1
1760	-1352	2023-04-02 19:56:15.815928	-1	127.0.0.1
1761	-1353	2023-04-02 20:44:43.80274	-1	127.0.0.1
1762	-1354	2023-04-03 12:40:30.014829	-1	127.0.0.1
1763	-1355	2023-04-05 12:38:31.423281	-1	127.0.0.1
1764	-1357	2023-04-05 17:02:34.67976	-1	127.0.0.1
1765	-1358	2023-04-06 09:13:25.674238	-1	127.0.0.1
1766	-1359	2023-04-07 12:51:07.675912	-1	127.0.0.1
1767	-1363	2023-04-12 15:29:36.785229	-1	127.0.0.1
1769	-1371	2023-04-14 16:43:27.646505	-1	127.0.0.1
1770	-1373	2023-04-16 01:21:58.264094	-1	127.0.0.1
1771	-1381	2023-04-17 19:43:59.595803	-1	127.0.0.1
1772	-1382	2023-04-18 16:17:41.918017	-1	127.0.0.1
1773	-1383	2023-04-18 17:54:39.57835	-1	127.0.0.1
1774	-1384	2023-04-19 15:12:04.635782	-1	127.0.0.1
677	10010320	2021-10-04 11:06:09.791133	206	2.45.142.210
687	10010325	2021-10-04 14:39:37.011733	206	109.115.186.2
688	10010325	2021-10-04 14:40:31.815409	206	109.115.186.2
689	10010325	2021-10-04 14:40:55.939303	206	109.115.186.2
690	10010325	2021-10-04 15:11:47.480623	206	109.115.186.2
691	10010325	2021-10-04 15:12:21.686257	206	109.115.186.2
692	10010320	2021-10-04 15:13:53.023239	206	2.45.142.210
693	10010320	2021-10-04 15:14:31.055237	206	2.45.142.210
697	-215	2021-10-04 21:11:25.451651	-1	146.56.129.233
774	-259	2021-10-21 09:55:37.055793	-1	79.52.10.109
800	-271	2021-10-27 17:01:40.960385	-1	151.73.245.230
801	10010321	2021-10-27 17:29:43.431597	204	151.73.245.230
802	-272	2021-10-28 08:40:40.772405	-1	87.17.146.119
803	-273	2021-10-28 09:57:32.259059	-1	87.17.146.119
804	-274	2021-10-28 10:07:58.109337	-1	87.17.146.119
805	-275	2021-10-28 10:19:24.374932	-1	87.17.146.119
806	-276	2021-10-28 10:52:12.280056	-1	82.55.101.26
847	10006775	2021-10-28 17:25:48.241259	206	5.90.136.66
848	10006775	2021-10-28 17:28:50.771829	206	5.90.136.66
858	-319	2021-10-29 08:00:50.731315	-1	151.73.245.230
860	10010322	2021-10-29 11:53:13.538886	207	109.115.186.2
866	-326	2021-10-31 20:31:27.652763	-1	51.158.21.238
850	-314	2021-10-28 17:30:19.555709	-1	5.90.136.66
851	-315	2021-10-28 17:35:12.244998	-1	5.90.136.66
867	-327	2021-11-08 13:14:50.366836	-1	109.115.186.2
868	-328	2021-11-08 15:55:05.647821	-1	109.115.186.2
869	-329	2021-11-08 16:01:52.724681	-1	109.115.186.2
870	-330	2021-11-08 16:42:47.887278	-1	109.115.186.2
871	-331	2021-11-08 16:47:17.260191	-1	109.115.186.2
872	-332	2021-11-10 13:34:00.10027	-1	27.115.124.37
873	-333	2021-11-16 14:56:28.594879	-1	109.115.186.2
874	-334	2021-11-16 14:57:34.728646	-1	109.115.186.2
875	-335	2021-11-16 15:02:32.893455	-1	109.115.186.2
880	10010321	2021-11-18 09:51:54.377619	204	109.115.186.2
881	-340	2021-11-18 09:53:05.770584	-1	109.115.186.2
995	-411	2021-11-24 16:23:46.215667	-1	127.0.0.1
883	-342	2021-11-18 11:23:48.465266	-1	151.14.95.136
896	-355	2021-11-18 23:04:27.044979	-1	151.70.13.242
934	-357	2021-11-22 06:47:17.144206	-1	151.57.207.250
937	-360	2021-11-22 14:07:06.441396	-1	127.0.0.1
939	-362	2021-11-22 14:35:08.830989	-1	127.0.0.1
940	10010646	2021-11-22 15:10:50.633609	204	127.0.0.1
941	10010646	2021-11-22 15:27:07.544397	204	127.0.0.1
944	-363	2021-11-22 16:05:47.56065	-1	127.0.0.1
945	-364	2021-11-22 16:06:25.489352	-1	127.0.0.1
946	-365	2021-11-22 16:10:01.484282	-1	127.0.0.1
947	-366	2021-11-22 16:16:55.198909	-1	127.0.0.1
948	-367	2021-11-22 16:19:00.232686	-1	127.0.0.1
949	-368	2021-11-22 16:23:30.760585	-1	127.0.0.1
950	-369	2021-11-22 16:31:04.535496	-1	127.0.0.1
951	-370	2021-11-22 16:35:45.294908	-1	127.0.0.1
952	-371	2021-11-22 16:39:45.863078	-1	127.0.0.1
953	-372	2021-11-22 16:42:12.815665	-1	127.0.0.1
954	10010646	2021-11-22 16:43:54.331026	204	127.0.0.1
955	10010646	2021-11-22 16:46:26.457175	204	127.0.0.1
956	-373	2021-11-22 17:05:31.535766	-1	127.0.0.1
957	10010646	2021-11-22 17:06:14.098624	204	127.0.0.1
958	-374	2021-11-22 17:07:07.385976	-1	127.0.0.1
959	-375	2021-11-22 17:07:40.822731	-1	127.0.0.1
960	-376	2021-11-22 17:08:30.442099	-1	127.0.0.1
961	-377	2021-11-22 17:08:43.503404	-1	127.0.0.1
962	-378	2021-11-22 17:09:00.439061	-1	127.0.0.1
963	-379	2021-11-22 17:09:58.942964	-1	127.0.0.1
964	-380	2021-11-22 17:10:09.119887	-1	127.0.0.1
967	-383	2021-11-22 17:13:32.817849	-1	127.0.0.1
968	-384	2021-11-22 17:14:23.76359	-1	127.0.0.1
970	-386	2021-11-22 17:15:32.573854	-1	127.0.0.1
971	-387	2021-11-22 17:18:01.354913	-1	127.0.0.1
972	-388	2021-11-22 17:18:32.394573	-1	127.0.0.1
973	-389	2021-11-22 17:23:39.917276	-1	127.0.0.1
974	-390	2021-11-22 17:24:15.406303	-1	127.0.0.1
975	-391	2021-11-22 17:24:56.969089	-1	127.0.0.1
976	-392	2021-11-22 17:25:09.252814	-1	127.0.0.1
977	-393	2021-11-22 17:30:43.144984	-1	127.0.0.1
978	-394	2021-11-22 18:11:14.941929	-1	127.0.0.1
979	-395	2021-11-23 08:06:13.56446	-1	127.0.0.1
980	-396	2021-11-23 08:17:19.879425	-1	127.0.0.1
981	-397	2021-11-23 08:44:03.311564	-1	127.0.0.1
982	-398	2021-11-23 09:08:45.298787	-1	127.0.0.1
983	-399	2021-11-23 09:33:05.755486	-1	127.0.0.1
984	-400	2021-11-23 09:38:37.087542	-1	127.0.0.1
985	-401	2021-11-23 10:05:36.147301	-1	127.0.0.1
986	-402	2021-11-23 10:05:40.417024	-1	127.0.0.1
987	-403	2021-11-23 15:58:30.990215	-1	127.0.0.1
988	-404	2021-11-23 16:16:40.154632	-1	127.0.0.1
989	-405	2021-11-23 18:01:43.057212	-1	127.0.0.1
990	-406	2021-11-24 15:58:22.066935	-1	127.0.0.1
991	-407	2021-11-24 16:19:18.327462	-1	127.0.0.1
992	-408	2021-11-24 16:20:03.244322	-1	127.0.0.1
993	-409	2021-11-24 16:20:47.131076	-1	127.0.0.1
994	-410	2021-11-24 16:20:47.886757	-1	127.0.0.1
996	-412	2021-11-24 16:26:49.330145	-1	127.0.0.1
997	-413	2021-11-24 16:44:37.707547	-1	127.0.0.1
998	-414	2021-11-25 16:38:39.229166	-1	127.0.0.1
999	-415	2021-11-25 16:46:16.479956	-1	127.0.0.1
1000	-416	2021-11-26 09:56:52.852388	-1	127.0.0.1
1001	-417	2021-11-26 09:59:17.138035	-1	127.0.0.1
1002	-418	2021-11-26 11:20:06.27446	-1	127.0.0.1
1003	-419	2021-11-26 13:08:09.120168	-1	127.0.0.1
1004	-420	2021-11-26 13:14:32.394829	-1	127.0.0.1
1005	-421	2021-11-26 13:15:19.876832	-1	127.0.0.1
1006	-422	2021-11-26 13:16:24.671511	-1	127.0.0.1
1007	-423	2021-11-27 09:04:34.090781	-1	127.0.0.1
1008	-424	2021-11-27 10:05:42.522213	-1	127.0.0.1
1009	-425	2021-11-27 10:28:53.893595	-1	127.0.0.1
1010	-426	2021-11-27 10:52:40.555735	-1	127.0.0.1
1011	-427	2021-11-27 11:20:25.120507	-1	127.0.0.1
1012	-428	2021-11-27 14:53:33.846034	-1	127.0.0.1
1013	-429	2021-11-27 15:04:40.461355	-1	127.0.0.1
1014	-430	2021-11-27 21:57:26.408142	-1	127.0.0.1
1015	-431	2021-11-28 15:47:10.192997	-1	127.0.0.1
1016	10010646	2021-11-29 15:37:37.296163	204	127.0.0.1
1017	10010646	2021-11-29 16:09:53.539489	204	127.0.0.1
1018	-432	2021-12-01 11:11:07.119517	-1	127.0.0.1
1019	-433	2021-12-01 12:44:13.641637	-1	127.0.0.1
1020	-434	2021-12-01 12:58:48.765105	-1	127.0.0.1
1021	-435	2021-12-01 16:33:00.403971	-1	127.0.0.1
1022	-436	2021-12-01 16:36:45.452436	-1	127.0.0.1
1023	-437	2021-12-01 16:37:04.053075	-1	127.0.0.1
1024	-438	2021-12-02 10:01:26.903577	-1	127.0.0.1
1025	-439	2021-12-02 10:01:27.095781	-1	127.0.0.1
1026	-440	2021-12-02 10:34:57.525428	-1	127.0.0.1
1027	-441	2021-12-02 10:44:50.89357	-1	127.0.0.1
1028	-442	2021-12-02 10:50:07.726733	-1	127.0.0.1
1029	-443	2021-12-02 10:52:37.834738	-1	127.0.0.1
1030	-444	2021-12-02 10:52:40.315843	-1	127.0.0.1
1031	-445	2021-12-02 10:52:46.880381	-1	127.0.0.1
1032	-446	2021-12-02 10:52:52.347616	-1	127.0.0.1
1033	-447	2021-12-02 12:03:46.516042	-1	127.0.0.1
1034	-448	2021-12-03 12:34:49.6476	-1	127.0.0.1
1035	-449	2021-12-05 13:05:25.588359	-1	127.0.0.1
1036	-450	2021-12-06 13:14:19.098339	-1	127.0.0.1
1037	-451	2021-12-06 19:15:18.346589	-1	127.0.0.1
1038	-452	2021-12-06 20:36:31.725816	-1	127.0.0.1
1039	-453	2021-12-07 11:08:32.594354	-1	127.0.0.1
1040	-454	2021-12-07 13:58:50.420536	-1	127.0.0.1
1041	-455	2021-12-07 14:49:36.238856	-1	127.0.0.1
1042	-456	2021-12-09 10:07:17.297826	-1	127.0.0.1
1043	-457	2021-12-09 11:59:46.12947	-1	127.0.0.1
1044	-458	2021-12-09 14:32:33.294824	-1	127.0.0.1
1045	-459	2021-12-09 14:34:18.646983	-1	127.0.0.1
1046	-460	2021-12-10 09:50:45.501867	-1	127.0.0.1
1047	-461	2021-12-10 11:07:50.377292	-1	127.0.0.1
1048	-462	2021-12-10 11:09:11.074642	-1	127.0.0.1
1049	-463	2021-12-10 11:22:51.547692	-1	127.0.0.1
1050	-464	2021-12-10 14:25:43.078664	-1	127.0.0.1
1051	-465	2021-12-13 10:39:25.367139	-1	127.0.0.1
1052	-466	2021-12-13 14:44:18.27261	-1	127.0.0.1
1053	-467	2021-12-15 10:02:58.149029	-1	127.0.0.1
1054	-468	2021-12-15 10:54:36.90825	-1	127.0.0.1
1055	-469	2021-12-16 09:50:01.936226	-1	127.0.0.1
1056	-470	2021-12-17 13:38:20.353731	-1	127.0.0.1
1057	-471	2021-12-19 11:28:10.181179	-1	127.0.0.1
1058	-472	2021-12-19 11:30:19.797609	-1	127.0.0.1
1059	-473	2021-12-19 16:33:38.606193	-1	127.0.0.1
1060	-474	2021-12-20 19:43:49.708307	-1	127.0.0.1
1061	-475	2021-12-21 10:59:05.666664	-1	127.0.0.1
1062	-476	2021-12-21 13:21:29.581392	-1	127.0.0.1
1063	-477	2021-12-22 10:15:58.569567	-1	127.0.0.1
1064	-478	2021-12-22 11:22:49.658841	-1	127.0.0.1
1065	-479	2021-12-22 12:06:21.447285	-1	127.0.0.1
1066	-480	2021-12-22 12:29:17.047272	-1	127.0.0.1
1067	-481	2021-12-22 13:08:37.606586	-1	127.0.0.1
1068	-482	2021-12-23 12:08:27.147711	-1	127.0.0.1
1069	-483	2021-12-26 11:19:57.715584	-1	127.0.0.1
1070	-484	2021-12-29 10:48:52.76727	-1	127.0.0.1
1071	-485	2022-01-03 15:28:30.190225	-1	127.0.0.1
1072	-486	2022-01-03 15:29:41.158738	-1	127.0.0.1
1073	-487	2022-01-04 14:17:22.339871	-1	127.0.0.1
1074	-488	2022-01-05 08:14:57.654854	-1	127.0.0.1
1075	-489	2022-01-05 22:16:35.152734	-1	127.0.0.1
1076	-490	2022-01-05 22:18:30.272267	-1	127.0.0.1
1077	-491	2022-01-06 14:52:59.226615	-1	127.0.0.1
1078	-492	2022-01-06 14:52:59.597783	-1	127.0.0.1
1079	-493	2022-01-06 14:52:59.675794	-1	127.0.0.1
1080	-494	2022-01-06 14:52:59.901406	-1	127.0.0.1
1081	-495	2022-01-06 14:53:00.401973	-1	127.0.0.1
1082	-496	2022-01-06 14:53:09.794428	-1	127.0.0.1
1083	-497	2022-01-06 15:06:59.420756	-1	127.0.0.1
1084	-498	2022-01-07 09:59:29.930755	-1	127.0.0.1
1085	-499	2022-01-13 09:31:02.950757	-1	127.0.0.1
1086	-500	2022-01-13 11:12:07.199096	-1	127.0.0.1
1087	-501	2022-01-13 14:00:51.057677	-1	127.0.0.1
1088	-502	2022-01-13 22:14:51.741871	-1	127.0.0.1
1089	-503	2022-01-14 09:22:58.946086	-1	127.0.0.1
1090	-504	2022-01-14 13:07:52.018913	-1	127.0.0.1
1091	-505	2022-01-17 12:26:18.903479	-1	127.0.0.1
1092	-506	2022-01-17 14:11:56.509774	-1	127.0.0.1
1093	-507	2022-01-17 14:12:00.05402	-1	127.0.0.1
1094	-508	2022-01-17 21:31:19.325133	-1	127.0.0.1
1095	-509	2022-01-18 18:36:02.279971	-1	127.0.0.1
1096	-510	2022-01-19 11:08:33.182023	-1	127.0.0.1
1097	-511	2022-01-20 17:47:05.934105	-1	127.0.0.1
1098	-512	2022-01-21 11:03:07.142789	-1	127.0.0.1
1099	-513	2022-01-21 11:03:10.766187	-1	127.0.0.1
1100	-514	2022-01-21 16:12:46.052186	-1	127.0.0.1
1101	-515	2022-01-21 19:32:27.255276	-1	127.0.0.1
1102	-516	2022-01-24 07:50:14.856373	-1	127.0.0.1
1103	-517	2022-01-24 07:51:46.120625	-1	127.0.0.1
1104	-518	2022-01-24 07:51:59.69715	-1	127.0.0.1
1105	-519	2022-01-24 09:15:13.40466	-1	127.0.0.1
1106	-520	2022-01-24 09:23:59.439161	-1	127.0.0.1
1107	-521	2022-01-24 09:24:47.050747	-1	127.0.0.1
1108	-522	2022-01-24 11:54:33.050029	-1	127.0.0.1
1109	-523	2022-01-24 11:55:19.033005	-1	127.0.0.1
1110	-524	2022-01-25 08:42:13.679273	-1	127.0.0.1
1111	-525	2022-01-25 08:43:15.168617	-1	127.0.0.1
1112	-526	2022-01-25 10:49:45.347115	-1	127.0.0.1
1113	-527	2022-01-25 10:49:46.155104	-1	127.0.0.1
1114	-528	2022-01-25 10:49:46.386676	-1	127.0.0.1
1115	-529	2022-01-25 10:49:46.394244	-1	127.0.0.1
1116	-530	2022-01-25 10:54:01.744595	-1	127.0.0.1
1117	-531	2022-01-25 13:21:01.645231	-1	127.0.0.1
1118	-532	2022-01-25 14:56:42.994752	-1	127.0.0.1
1119	-533	2022-01-25 14:59:03.391173	-1	127.0.0.1
1120	-534	2022-01-25 15:00:33.248162	-1	127.0.0.1
1121	-535	2022-01-25 16:58:23.205532	-1	127.0.0.1
1123	-537	2022-01-26 16:45:37.365678	-1	127.0.0.1
1124	-538	2022-01-27 10:40:42.470289	-1	127.0.0.1
1125	-539	2022-01-27 10:43:22.655332	-1	127.0.0.1
1133	-547	2022-01-31 12:01:42.289345	-1	127.0.0.1
1134	-548	2022-01-31 12:01:44.671433	-1	127.0.0.1
1137	-551	2022-02-02 09:26:47.595017	-1	127.0.0.1
1138	-552	2022-02-02 09:29:58.638107	-1	127.0.0.1
1139	-553	2022-02-02 09:37:14.917326	-1	127.0.0.1
1140	-554	2022-02-02 10:14:35.889592	-1	127.0.0.1
1143	-557	2022-02-02 12:32:19.916124	-1	127.0.0.1
1145	-559	2022-02-03 09:13:22.835067	-1	127.0.0.1
1146	-560	2022-02-03 09:16:10.425975	-1	127.0.0.1
1147	-561	2022-02-03 09:20:44.923822	-1	127.0.0.1
1149	-563	2022-02-03 12:38:52.298516	-1	127.0.0.1
1122	-536	2022-01-26 11:32:29.219795	-1	127.0.0.1
1126	-540	2022-01-27 15:25:38.621715	-1	127.0.0.1
1127	-541	2022-01-28 08:24:40.217525	-1	127.0.0.1
1128	-542	2022-01-28 09:53:21.107889	-1	127.0.0.1
1129	-543	2022-01-31 09:27:13.22302	-1	127.0.0.1
1130	-544	2022-01-31 10:58:36.767399	-1	127.0.0.1
1131	-545	2022-01-31 11:30:22.067537	-1	127.0.0.1
1132	-546	2022-01-31 12:00:09.342407	-1	127.0.0.1
1135	-549	2022-01-31 12:47:16.179954	-1	127.0.0.1
1136	-550	2022-01-31 12:47:16.987693	-1	127.0.0.1
1141	-555	2022-02-02 10:17:58.182714	-1	127.0.0.1
1142	-556	2022-02-02 11:05:01.991305	-1	127.0.0.1
1144	-558	2022-02-02 12:37:51.480586	-1	127.0.0.1
1148	-562	2022-02-03 09:23:54.488137	-1	127.0.0.1
1150	-564	2022-02-07 09:05:38.133863	-1	127.0.0.1
1151	-565	2022-02-07 09:06:40.219085	-1	127.0.0.1
1152	-566	2022-02-07 10:23:03.133594	-1	127.0.0.1
1153	-567	2022-02-07 13:00:24.369025	-1	127.0.0.1
1154	-568	2022-02-07 13:15:05.309195	-1	127.0.0.1
1155	-569	2022-02-07 13:19:15.265067	-1	127.0.0.1
1156	-570	2022-02-07 14:10:37.449428	-1	127.0.0.1
1157	-571	2022-02-07 14:16:59.045589	-1	127.0.0.1
1158	-572	2022-02-07 14:27:48.145185	-1	127.0.0.1
1159	-573	2022-02-07 14:42:11.053995	-1	127.0.0.1
1160	-574	2022-02-09 14:28:14.534082	-1	127.0.0.1
1161	-575	2022-02-10 05:33:29.215785	-1	127.0.0.1
1162	-576	2022-02-10 10:32:34.469576	-1	127.0.0.1
1163	-577	2022-02-10 12:57:42.836514	-1	127.0.0.1
1164	-578	2022-02-10 15:13:49.241528	-1	127.0.0.1
1165	-579	2022-02-11 18:49:15.115086	-1	127.0.0.1
1166	-580	2022-02-14 11:02:13.843794	-1	127.0.0.1
1167	-581	2022-02-14 14:28:33.107618	-1	127.0.0.1
1168	-582	2022-02-14 19:20:27.882263	-1	127.0.0.1
1169	-583	2022-02-16 08:30:23.605097	-1	127.0.0.1
1170	-584	2022-02-16 09:03:03.488034	-1	127.0.0.1
1171	-585	2022-02-16 17:04:54.870692	-1	127.0.0.1
1172	-586	2022-02-16 19:52:01.896488	-1	127.0.0.1
1173	-587	2022-02-17 07:45:50.191838	-1	127.0.0.1
1174	-588	2022-02-17 09:05:04.022719	-1	127.0.0.1
1175	-589	2022-02-17 09:06:22.58554	-1	127.0.0.1
1176	-590	2022-02-17 20:21:16.435152	-1	127.0.0.1
1177	-591	2022-02-18 12:32:06.745423	-1	127.0.0.1
1178	-592	2022-02-18 22:32:51.549342	-1	127.0.0.1
1179	-593	2022-02-19 10:18:36.593909	-1	127.0.0.1
1180	-594	2022-02-19 11:34:28.3303	-1	127.0.0.1
1181	-595	2022-02-19 11:34:48.943129	-1	127.0.0.1
1182	-596	2022-02-19 21:09:42.651644	-1	127.0.0.1
1183	-597	2022-02-22 16:16:01.007642	-1	127.0.0.1
1184	-598	2022-02-23 19:33:51.060958	-1	127.0.0.1
1185	-599	2022-02-24 17:40:07.719049	-1	127.0.0.1
1186	-600	2022-02-24 20:49:01.317864	-1	127.0.0.1
1187	-601	2022-02-25 09:40:25.97746	-1	127.0.0.1
1188	-602	2022-02-25 09:40:27.998886	-1	127.0.0.1
1189	-603	2022-02-25 12:00:18.290836	-1	127.0.0.1
1190	-604	2022-02-25 12:03:45.926645	-1	127.0.0.1
1191	-605	2022-02-25 12:05:48.519538	-1	127.0.0.1
1192	-606	2022-02-25 12:06:45.867871	-1	127.0.0.1
1193	-607	2022-02-25 12:06:56.862318	-1	127.0.0.1
1194	-608	2022-02-25 12:08:42.67559	-1	127.0.0.1
1195	-609	2022-02-25 14:25:20.593999	-1	127.0.0.1
1196	-610	2022-02-25 14:48:12.335594	-1	127.0.0.1
1197	-611	2022-02-25 14:48:15.719524	-1	127.0.0.1
1198	-612	2022-02-25 14:50:45.56864	-1	127.0.0.1
1199	-613	2022-02-25 14:51:59.807849	-1	127.0.0.1
1200	-614	2022-02-25 14:53:31.78964	-1	127.0.0.1
1201	-615	2022-02-25 16:18:16.970309	-1	127.0.0.1
1202	-616	2022-02-25 16:56:25.146199	-1	127.0.0.1
1203	-617	2022-02-25 16:56:27.731461	-1	127.0.0.1
1204	-618	2022-02-25 16:56:34.158951	-1	127.0.0.1
1205	-619	2022-02-26 12:48:26.099676	-1	127.0.0.1
1206	-620	2022-02-26 12:52:10.853943	-1	127.0.0.1
1207	-621	2022-02-28 04:19:16.512666	-1	127.0.0.1
1208	-622	2022-03-01 12:30:55.420508	-1	127.0.0.1
1209	-623	2022-03-01 18:59:44.626641	-1	127.0.0.1
1210	-624	2022-03-02 23:17:21.086559	-1	127.0.0.1
1211	-625	2022-03-04 02:54:02.857468	-1	127.0.0.1
1212	-626	2022-03-04 16:29:22.011079	-1	127.0.0.1
1213	-627	2022-03-05 03:34:56.543465	-1	127.0.0.1
1214	-628	2022-03-07 12:21:43.862699	-1	127.0.0.1
1215	-629	2022-03-08 06:06:46.739814	-1	127.0.0.1
1216	-630	2022-03-09 09:56:47.458607	-1	127.0.0.1
1217	-631	2022-03-10 15:45:40.047272	-1	127.0.0.1
1218	-632	2022-03-11 02:51:20.547012	-1	127.0.0.1
1219	-633	2022-03-15 09:58:30.203131	-1	127.0.0.1
1220	-634	2022-03-16 10:22:25.501294	-1	127.0.0.1
1221	-635	2022-03-16 10:26:26.600254	-1	127.0.0.1
1222	-636	2022-03-16 10:42:34.400561	-1	127.0.0.1
1223	-637	2022-03-16 13:59:32.226207	-1	127.0.0.1
1224	-638	2022-03-17 23:09:06.093333	-1	127.0.0.1
1225	-639	2022-03-18 09:06:51.790131	-1	127.0.0.1
1226	-640	2022-03-18 09:14:35.077581	-1	127.0.0.1
1227	-641	2022-03-18 09:15:28.087846	-1	127.0.0.1
1228	-642	2022-03-18 11:35:57.873525	-1	127.0.0.1
1229	-643	2022-03-20 12:40:26.97557	-1	127.0.0.1
1230	-644	2022-03-20 18:21:35.588932	-1	127.0.0.1
1231	-645	2022-03-21 08:22:03.614543	-1	127.0.0.1
1232	-646	2022-03-21 13:14:39.626961	-1	127.0.0.1
1233	-647	2022-03-22 11:07:20.97854	-1	127.0.0.1
1234	-648	2022-03-23 15:23:36.587174	-1	127.0.0.1
1235	-649	2022-03-23 15:24:51.63465	-1	127.0.0.1
1236	-650	2022-03-23 15:26:44.994975	-1	127.0.0.1
1237	-651	2022-03-25 07:21:44.851972	-1	127.0.0.1
1238	-652	2022-03-25 11:45:49.479599	-1	127.0.0.1
1239	-653	2022-03-25 11:46:40.067483	-1	127.0.0.1
1240	-654	2022-03-25 11:47:28.699597	-1	127.0.0.1
1241	-655	2022-03-25 11:51:20.966682	-1	127.0.0.1
1242	-656	2022-03-25 11:53:13.148238	-1	127.0.0.1
1243	-657	2022-03-26 17:55:31.620106	-1	127.0.0.1
1244	-658	2022-03-28 16:21:20.613397	-1	127.0.0.1
1245	-659	2022-03-30 03:31:07.003995	-1	127.0.0.1
1246	-660	2022-03-30 14:43:27.960828	-1	127.0.0.1
1247	-661	2022-04-02 09:15:47.374544	-1	127.0.0.1
1248	-662	2022-04-03 08:00:28.343582	-1	127.0.0.1
1249	-663	2022-04-04 09:35:08.686117	-1	127.0.0.1
1250	-664	2022-04-04 12:03:33.114726	-1	127.0.0.1
1251	-665	2022-04-04 12:27:07.742104	-1	127.0.0.1
1252	-666	2022-04-04 20:41:52.749717	-1	127.0.0.1
1253	-667	2022-04-06 12:00:53.53442	-1	127.0.0.1
1254	-668	2022-04-06 14:49:06.913705	-1	127.0.0.1
1255	-669	2022-04-06 18:01:13.671005	-1	127.0.0.1
1256	-670	2022-04-08 15:14:11.858377	-1	127.0.0.1
1257	-671	2022-04-08 22:11:33.295995	-1	127.0.0.1
1258	-672	2022-04-10 00:47:18.843671	-1	127.0.0.1
1259	-673	2022-04-11 10:59:13.469874	-1	127.0.0.1
1260	-674	2022-04-11 12:22:23.313576	-1	127.0.0.1
1261	-675	2022-04-11 12:22:26.418332	-1	127.0.0.1
1262	-676	2022-04-11 12:33:48.292592	-1	127.0.0.1
1263	-677	2022-04-11 13:05:31.840384	-1	127.0.0.1
1264	-678	2022-04-13 10:02:46.353585	-1	127.0.0.1
1266	-680	2022-04-13 12:40:31.083673	-1	127.0.0.1
1267	-681	2022-04-13 13:03:52.334501	-1	127.0.0.1
1269	-683	2022-04-13 14:11:44.091781	-1	127.0.0.1
1270	-684	2022-04-13 14:14:46.718828	-1	127.0.0.1
1265	-679	2022-04-13 10:39:20.422588	-1	127.0.0.1
1268	-682	2022-04-13 14:11:15.755431	-1	127.0.0.1
1271	-685	2022-04-13 20:25:09.491607	-1	127.0.0.1
1272	-686	2022-04-22 11:01:40.732206	-1	127.0.0.1
1273	-687	2022-04-22 11:55:53.485034	-1	127.0.0.1
1274	-688	2022-04-23 17:30:27.355847	-1	127.0.0.1
1275	-689	2022-04-24 04:06:30.351116	-1	127.0.0.1
1276	-690	2022-04-24 17:53:25.13247	-1	127.0.0.1
1277	-691	2022-04-29 08:42:12.612723	-1	127.0.0.1
1278	-692	2022-04-29 08:48:27.908878	-1	127.0.0.1
1279	-693	2022-04-29 08:48:37.437113	-1	127.0.0.1
1280	-694	2022-04-29 09:26:07.508415	-1	127.0.0.1
1281	-695	2022-05-02 10:38:51.506319	-1	127.0.0.1
1282	-696	2022-05-03 17:12:39.804526	-1	127.0.0.1
1283	-697	2022-05-04 16:14:59.19619	-1	127.0.0.1
1284	-698	2022-05-05 09:29:03.904919	-1	127.0.0.1
1285	-699	2022-05-05 10:32:15.25408	-1	127.0.0.1
1286	-700	2022-05-06 08:20:58.501257	-1	127.0.0.1
1287	-701	2022-05-06 10:36:28.266745	-1	127.0.0.1
1288	-702	2022-05-06 13:07:13.961442	-1	127.0.0.1
1289	-703	2022-05-06 16:53:56.215962	-1	127.0.0.1
1290	-704	2022-05-10 12:16:08.459047	-1	127.0.0.1
1291	-705	2022-05-10 12:26:30.841131	-1	127.0.0.1
1292	-706	2022-05-10 12:48:17.571939	-1	127.0.0.1
1293	-707	2022-05-12 11:10:46.702748	-1	127.0.0.1
1294	-708	2022-05-12 15:32:16.057588	-1	127.0.0.1
1295	-709	2022-05-12 15:53:22.216056	-1	127.0.0.1
1296	-710	2022-05-12 15:55:52.80748	-1	127.0.0.1
1297	-711	2022-05-12 16:41:42.252577	-1	127.0.0.1
1298	-712	2022-05-12 17:27:57.341086	-1	127.0.0.1
1299	-713	2022-05-12 18:09:45.343344	-1	127.0.0.1
1300	-714	2022-05-13 10:23:17.353368	-1	127.0.0.1
1301	-715	2022-05-13 11:19:52.479947	-1	127.0.0.1
1302	-716	2022-05-13 11:38:55.656972	-1	127.0.0.1
1303	-717	2022-05-13 11:43:42.404528	-1	127.0.0.1
1304	-718	2022-05-13 12:32:41.160951	-1	127.0.0.1
1305	-719	2022-05-13 12:52:36.033327	-1	127.0.0.1
1306	-720	2022-05-13 14:58:41.377026	-1	127.0.0.1
1307	-721	2022-05-13 15:01:01.434768	-1	127.0.0.1
1308	-722	2022-05-13 15:19:50.274539	-1	127.0.0.1
1309	-723	2022-05-13 15:23:14.093096	-1	127.0.0.1
1310	-724	2022-05-13 15:26:31.973156	-1	127.0.0.1
1311	-725	2022-05-13 15:32:25.361531	-1	127.0.0.1
1312	-726	2022-05-13 15:33:51.29629	-1	127.0.0.1
1313	-727	2022-05-15 05:06:34.6204	-1	127.0.0.1
1314	-728	2022-05-15 23:12:16.692033	-1	127.0.0.1
1315	-729	2022-05-16 09:57:46.48003	-1	127.0.0.1
1316	-730	2022-05-16 10:41:06.253407	-1	127.0.0.1
1317	-731	2022-05-16 12:26:32.790404	-1	127.0.0.1
1318	-732	2022-05-16 12:32:43.787252	-1	127.0.0.1
1319	-733	2022-05-17 12:12:58.338055	-1	127.0.0.1
1320	-734	2022-05-19 00:30:31.904274	-1	127.0.0.1
1321	-735	2022-05-19 12:32:22.61334	-1	127.0.0.1
1322	-736	2022-05-19 12:33:04.795327	-1	127.0.0.1
1323	-737	2022-05-19 12:33:22.308864	-1	127.0.0.1
1324	-738	2022-05-19 12:33:51.917982	-1	127.0.0.1
1325	-739	2022-05-19 12:34:43.658879	-1	127.0.0.1
1326	-740	2022-05-19 12:35:23.691932	-1	127.0.0.1
1327	-741	2022-05-19 12:35:37.699136	-1	127.0.0.1
1328	-742	2022-05-20 11:34:06.744275	-1	127.0.0.1
1329	-743	2022-05-20 17:26:57.820866	-1	127.0.0.1
1330	-744	2022-05-20 19:16:49.869425	-1	127.0.0.1
1331	-745	2022-05-23 17:36:16.493813	-1	127.0.0.1
1332	-746	2022-05-24 11:53:41.585779	-1	127.0.0.1
1333	-747	2022-05-24 16:01:30.125387	-1	127.0.0.1
1334	-748	2022-05-26 07:48:33.275196	-1	127.0.0.1
1335	-749	2022-05-26 10:48:47.602627	-1	127.0.0.1
1336	-750	2022-05-28 19:18:15.660562	-1	127.0.0.1
1337	-751	2022-05-30 12:56:09.184396	-1	127.0.0.1
1338	-752	2022-06-02 21:59:30.675649	-1	127.0.0.1
1339	-753	2022-06-03 08:36:18.503561	-1	127.0.0.1
1340	-754	2022-06-04 15:43:18.449517	-1	127.0.0.1
1341	-755	2022-06-06 10:53:48.069821	-1	127.0.0.1
1342	-756	2022-06-08 05:42:55.191388	-1	127.0.0.1
1343	-757	2022-06-09 11:31:40.524392	-1	127.0.0.1
1344	-758	2022-06-10 12:13:49.872363	-1	127.0.0.1
1345	-759	2022-06-13 16:20:23.495383	-1	127.0.0.1
1346	-760	2022-06-14 12:15:33.145871	-1	127.0.0.1
1347	-761	2022-06-14 12:16:00.650582	-1	127.0.0.1
1348	-762	2022-06-14 17:41:35.615455	-1	127.0.0.1
1349	-763	2022-06-15 13:34:36.117764	-1	127.0.0.1
1350	-764	2022-06-15 14:20:12.875032	-1	127.0.0.1
1351	-765	2022-06-15 14:20:28.903034	-1	127.0.0.1
1352	-766	2022-06-15 14:20:29.904536	-1	127.0.0.1
1353	-767	2022-06-15 14:32:26.468193	-1	127.0.0.1
1354	-768	2022-06-15 14:33:44.536616	-1	127.0.0.1
1355	-769	2022-06-15 14:35:08.433248	-1	127.0.0.1
1356	-770	2022-06-15 15:50:07.199883	-1	127.0.0.1
1357	-771	2022-06-16 13:11:38.608248	-1	127.0.0.1
1358	-772	2022-06-16 22:52:32.623585	-1	127.0.0.1
1359	-773	2022-06-17 23:32:41.893766	-1	127.0.0.1
1360	-774	2022-06-18 11:59:04.206129	-1	127.0.0.1
1361	-775	2022-06-21 10:45:48.591222	-1	127.0.0.1
1362	-776	2022-06-22 18:47:14.710028	-1	127.0.0.1
1363	-777	2022-06-23 12:21:29.252526	-1	127.0.0.1
1364	-778	2022-06-23 13:58:39.56707	-1	127.0.0.1
1365	-779	2022-06-24 14:35:07.56301	-1	127.0.0.1
1366	-780	2022-06-24 14:37:03.066604	-1	127.0.0.1
1367	-781	2022-06-24 18:23:20.90717	-1	127.0.0.1
1368	-782	2022-06-26 20:50:47.934448	-1	127.0.0.1
1369	-783	2022-06-27 10:26:07.025378	-1	127.0.0.1
1370	-784	2022-06-27 11:41:09.064486	-1	127.0.0.1
1371	-785	2022-06-27 11:53:40.219523	-1	127.0.0.1
1775	-1385	2023-04-21 19:58:03.193564	-1	10.10.5.10
1776	-1391	2023-04-24 13:26:18.655182	-1	10.10.5.24
1777	-1392	2023-04-24 14:03:19.499818	-1	10.10.5.24
1778	-1393	2023-04-25 18:11:27.160773	-1	10.10.5.11
1779	-1394	2023-04-25 18:50:06.112087	-1	10.10.5.11
1780	-1395	2023-04-25 18:52:41.829745	-1	10.10.5.11
1781	-1396	2023-04-25 18:55:35.84185	-1	10.10.5.11
1782	-1397	2023-04-25 19:16:56.327361	-1	10.10.5.11
1783	-1398	2023-04-25 19:32:04.055208	-1	10.10.5.11
1784	-1400	2023-04-25 20:33:03.109631	-1	10.10.5.11
1785	-1401	2023-04-26 08:47:15.533465	-1	172.16.3.104
1786	-1403	2023-04-26 09:07:34.862359	-1	172.16.3.104
1787	-1404	2023-04-26 10:24:39.868609	-1	217.59.139.10
1788	-1405	2023-04-26 10:26:23.428956	-1	172.16.0.125
1789	-1407	2023-04-26 19:53:30.063075	-1	82.54.193.126
1790	-1408	2023-04-26 21:33:00.545615	-1	82.54.193.126
1791	-1409	2023-04-27 10:20:24.603729	-1	172.16.3.254
1792	-1410	2023-04-27 11:40:32.658047	-1	172.16.3.104
1793	-1412	2023-04-27 19:15:16.822752	-1	82.54.193.126
1794	-1414	2023-04-27 19:29:06.041754	-1	82.54.193.126
1795	-1417	2023-04-28 14:04:20.715109	-1	172.16.3.254
1796	-1418	2023-05-01 11:55:02.072781	-1	10.10.5.11
1797	-1420	2023-05-01 12:13:48.550593	-1	82.49.179.16
1798	-1422	2023-05-01 12:16:03.044208	-1	82.49.179.16
1799	-1424	2023-05-01 12:21:00.672143	-1	82.49.179.16
1800	-1434	2023-05-01 18:43:39.003281	-1	82.49.179.16
1801	-1437	2023-05-01 18:48:29.542486	-1	82.49.179.16
1802	-1438	2023-05-01 18:50:35.632206	-1	82.49.179.16
1803	-1439	2023-05-01 20:02:38.704019	-1	82.49.179.16
1804	-1441	2023-05-01 21:03:40.939772	-1	10.10.5.11
1805	-1442	2023-05-01 21:38:46.987491	-1	10.10.5.11
1806	-1443	2023-05-02 09:20:44.339249	-1	172.16.3.104
1807	-1445	2023-05-02 11:08:06.907949	-1	5.170.171.8
1808	-1446	2023-05-03 13:01:10.479046	-1	172.16.3.104
1809	-1447	2023-05-09 15:19:47.170231	-1	10.10.5.16
1810	-1448	2023-05-10 19:54:07.101287	-1	10.10.5.10
1811	-1449	2023-05-10 20:00:12.579096	-1	10.10.5.10
1812	-1450	2023-05-10 20:37:45.700678	-1	10.10.5.10
1813	-1453	2023-05-10 20:41:10.175452	-1	10.10.5.10
1814	-1454	2023-05-10 21:50:49.379854	-1	10.10.5.10
1815	-1455	2023-05-10 21:52:03.331301	-1	10.10.5.10
1816	-1456	2023-05-10 22:02:29.274179	-1	10.10.5.10
1817	-1457	2023-05-11 09:45:58.442682	-1	93.40.228.133
1818	-1458	2023-05-11 10:44:20.863418	-1	2.232.192.227
1819	-1460	2023-05-11 11:11:37.699758	-1	93.43.74.130
1820	-1462	2023-05-11 11:19:13.152841	-1	10.10.5.21
1821	-1463	2023-05-11 12:25:44.256525	-1	10.10.5.21
1822	-1464	2023-05-11 14:17:05.132363	-1	79.47.31.97
1823	-1465	2023-05-11 14:24:36.70737	-1	79.47.31.97
1824	-1467	2023-05-11 15:38:34.529421	-1	79.47.31.97
1825	-1468	2023-05-11 20:02:09.505363	-1	82.49.179.16
1826	-1470	2023-05-11 20:02:43.326632	-1	82.49.179.16
1827	-1472	2023-09-12 12:36:46.325403	-1	172.16.3.104
1828	-1474	2023-09-12 13:46:45.376586	-1	172.16.3.104
1829	-1475	2023-09-12 13:50:04.785254	-1	172.16.3.121
1830	-1476	2023-09-12 14:01:51.03201	-1	172.16.3.121
1831	-1477	2023-09-12 14:01:54.384353	-1	77.111.246.31
1832	-1478	2023-09-12 14:02:47.306804	-1	172.16.3.121
1833	-1480	2023-09-12 14:08:06.897839	-1	185.30.68.48
1834	-1481	2023-09-12 14:10:26.909554	-1	185.30.68.48
1835	-1483	2023-09-12 14:31:59.27545	-1	185.30.68.48
1836	-1484	2023-09-12 15:20:37.94829	-1	172.16.3.121
1837	-1486	2023-09-27 10:48:44.653446	-1	79.8.233.73
1838	-1487	2023-09-27 11:49:22.299667	-1	93.43.74.130
1839	-1489	2023-09-27 11:49:36.868578	-1	40.94.90.74
1840	-1490	2023-09-27 12:15:41.106044	-1	93.43.74.130
1841	-1492	2023-09-27 12:16:21.558736	-1	40.94.95.3
1842	-1493	2023-09-28 10:13:12.747118	-1	87.10.70.71
1843	-1494	2023-10-04 15:49:57.599185	-1	93.43.74.130
1844	-1496	2023-10-04 15:50:11.411562	-1	93.43.74.130
1845	-1497	2023-10-04 15:50:13.090856	-1	40.94.88.76
1846	-1499	2023-10-04 15:50:57.008451	-1	93.43.74.130
1847	-1503	2023-10-04 16:00:13.691707	-1	93.43.74.130
1848	-1504	2023-10-04 16:11:57.538046	-1	93.43.74.130
1849	-1505	2023-10-04 16:12:32.559821	-1	40.94.87.40
1850	-1507	2023-10-05 09:47:41.749292	-1	40.94.105.78
1851	-1511	2023-10-05 11:49:28.390803	-1	40.94.94.56
1852	-1512	2023-10-11 13:24:13.690943	-1	40.94.104.40
1853	-1513	2023-10-12 09:21:36.194461	-1	93.43.74.130
1854	-1515	2023-10-12 09:22:16.90312	-1	40.94.95.31
1855	-1518	2023-10-17 15:54:41.451262	-1	80.180.195.125
1856	-1519	2023-10-17 15:57:09.634853	-1	80.180.195.125
1857	-1520	2023-10-17 16:32:11.810338	-1	80.180.195.125
1858	-1521	2023-10-18 11:33:27.089539	-1	172.16.3.130
1859	-1522	2023-10-18 19:52:02.84032	-1	82.54.92.51
1860	-1523	2023-10-19 12:44:39.450653	-1	82.54.92.51
1861	-1524	2023-10-19 15:16:10.083076	-1	82.54.92.51
1862	-1525	2023-10-19 16:49:16.991779	-1	82.54.92.51
1863	-1526	2023-10-19 16:55:43.812908	-1	82.54.92.51
\.


--
-- TOC entry 4318 (class 0 OID 367660)
-- Dependencies: 247
-- Data for Name: log_checklist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_checklist (id, id_checklist, id_utente, entered) FROM stdin;
1	2022	10000740	2021-05-10 09:20:15.722825
2	2022	10000740	2021-05-10 10:45:37.936603
3	2022	10000740	2021-05-10 10:45:42.75421
4	2023	-7	2021-05-11 15:19:02.847656
5	2022	-12	2021-05-11 15:35:09.046941
6	2022	-16	2021-05-11 15:40:54.659375
7	2022	-27	2021-05-11 16:53:00.11086
8	2022	10000740	2021-05-11 17:07:30.532558
9	2022	10000740	2021-05-11 17:07:43.999023
10	2048	-49	2021-06-14 17:24:18.598193
11	2022	1	2021-06-14 17:31:17.876124
12	2022	1	2021-06-14 17:31:20.708098
13	2022	10010280	2021-06-15 09:43:40.915025
14	2023	10010286	2021-06-15 10:08:14.465205
15	2023	10010286	2021-06-15 10:08:25.485768
16	2023	10010286	2021-06-15 10:08:41.434142
17	2022	10010280	2021-06-15 10:33:42.167735
18	2022	10010280	2021-06-15 10:33:47.424668
19	2022	10010280	2021-06-15 10:34:01.5246
20	2022	10010280	2021-06-15 10:34:36.239166
21	2022	10010280	2021-06-15 10:34:53.744668
22	2022	10010280	2021-06-15 10:36:42.529212
23	2022	10010280	2021-06-15 10:36:45.136211
24	2022	10010280	2021-06-15 10:37:16.180053
25	2022	10010280	2021-06-15 10:37:18.772143
26	2022	10010280	2021-06-15 10:37:24.160887
27	2022	10010280	2021-06-15 10:37:49.846563
28	2022	10010280	2021-06-15 10:37:53.800519
29	2022	10010280	2021-06-15 10:40:24.801074
30	2023	10010280	2021-06-15 10:46:36.646059
31	2023	10010280	2021-06-15 10:47:04.851749
32	2023	10010286	2021-06-15 11:24:28.583822
33	2023	10010286	2021-06-15 11:24:38.967221
34	2023	10010286	2021-06-15 11:25:54.153501
35	2023	10010286	2021-06-15 11:26:43.628866
36	2023	10010286	2021-06-15 11:31:06.472893
37	2023	10010286	2021-06-15 11:31:37.004502
38	2023	10010286	2021-06-15 11:32:14.372252
39	2023	10010286	2021-06-15 11:32:28.356416
40	2023	10010286	2021-06-15 11:32:45.208923
41	2023	10010286	2021-06-15 11:34:21.249148
42	2023	10010286	2021-06-15 11:34:35.816119
43	2023	10010286	2021-06-15 11:34:49.809789
44	2023	10010286	2021-06-15 11:35:03.513206
45	2023	10010286	2021-06-15 11:35:19.415574
46	2023	10010286	2021-06-15 11:35:32.237159
47	2023	10010286	2021-06-15 11:35:42.695809
48	2023	10010286	2021-06-15 11:35:50.981101
49	2023	10010286	2021-06-15 11:35:58.355728
50	2023	10010286	2021-06-15 11:36:11.89167
51	2023	10010286	2021-06-15 11:36:21.256188
52	2023	10010286	2021-06-15 11:36:34.252713
53	2023	10010286	2021-06-15 11:36:42.850577
54	2023	10010286	2021-06-15 11:36:50.464743
55	2023	10010286	2021-06-15 11:39:06.798117
56	2023	10010286	2021-06-15 11:39:33.818325
57	2023	10010286	2021-06-15 11:39:55.532574
58	2023	10010286	2021-06-15 11:40:04.908376
59	2023	10010286	2021-06-15 11:40:17.597476
60	2023	10010286	2021-06-15 11:40:25.575858
61	2023	10010286	2021-06-15 11:40:35.039514
62	2023	10010286	2021-06-15 11:40:42.875444
63	2023	10010286	2021-06-15 11:40:50.401191
64	2023	10010286	2021-06-15 11:45:33.022372
65	2023	10010286	2021-06-15 11:46:41.790042
66	2023	10010286	2021-06-15 11:49:08.664276
67	2023	10010286	2021-06-15 11:49:23.600788
68	2022	10010286	2021-06-15 11:50:14.719754
69	2023	10010286	2021-06-15 11:50:18.379998
70	2024	10010286	2021-06-15 11:50:33.680482
71	2023	10010286	2021-06-15 11:50:37.803534
72	2023	10010286	2021-06-15 11:51:28.437665
73	2022	10010286	2021-06-15 12:04:55.350554
74	2023	10010286	2021-06-15 12:05:21.833181
75	2022	10010285	2021-06-17 08:57:29.880859
76	2022	10010285	2021-06-17 09:03:48.451275
77	2022	10010279	2021-06-17 09:16:07.257411
78	2023	10010286	2021-06-17 15:40:24.452368
79	2023	10010286	2021-06-17 15:42:09.942659
80	2022	10010285	2021-06-17 15:51:49.904747
81	2022	10010285	2021-06-17 15:51:55.808827
82	2023	10010286	2021-09-15 10:16:18.866292
83	2058	10010300	2021-09-22 16:14:39.631718
84	2058	10010300	2021-09-22 16:21:37.249196
85	2058	10010300	2021-09-22 16:21:54.353831
86	2064	10010300	2021-09-22 16:26:08.222501
87	2058	10010300	2021-09-22 16:39:45.064706
88	2058	10010300	2021-09-22 16:39:49.820113
89	2030	10010300	2021-09-22 16:42:19.970197
90	2058	10010300	2021-09-22 17:02:53.814244
91	2058	10010299	2021-09-22 17:24:44.943985
92	2042	10010301	2021-09-22 17:55:53.958016
93	2042	10010301	2021-09-22 18:06:48.321953
94	2058	10010303	2021-09-23 10:39:52.862901
95	2022	10010304	2021-09-28 14:51:48.515278
96	2022	10010306	2021-09-29 11:44:12.872435
97	2022	10010306	2021-09-29 11:44:17.843077
98	2022	10010306	2021-09-29 11:44:21.180234
99	2022	10010306	2021-09-29 11:44:25.307007
100	2022	-209	2021-09-30 14:37:33.865673
101	2022	-209	2021-09-30 14:38:47.037646
102	2022	-209	2021-09-30 14:38:59.545756
103	2022	10010315	2021-09-30 14:43:45.601024
104	2022	10010318	2021-09-30 15:47:23.884139
105	2037	10010313	2021-09-30 15:58:06.755474
106	2023	10010331	2021-10-04 12:40:04.607387
107	2041	10010325	2021-10-04 14:58:05.340451
108	2048	10010325	2021-10-04 15:07:23.358465
109	2022	-228	2021-10-12 14:50:28.721336
110	2022	-228	2021-10-12 14:50:47.99095
111	2022	-228	2021-10-12 14:52:03.202403
112	2022	-228	2021-10-12 14:53:53.488693
113	2022	-228	2021-10-12 14:58:15.603123
114	2022	-228	2021-10-12 15:00:18.66612
115	2022	-228	2021-10-12 15:01:22.697559
116	2022	-228	2021-10-12 15:02:27.682003
117	2022	-228	2021-10-12 15:02:52.251621
118	2027	-241	2021-10-12 15:54:11.931129
119	2027	-241	2021-10-12 15:54:25.78844
120	2022	-247	2021-10-13 15:12:59.570334
121	2040	-247	2021-10-13 15:25:07.286916
122	2022	-247	2021-10-13 15:25:28.485244
123	2022	-247	2021-10-13 15:27:18.14536
124	2022	\N	2021-10-13 15:31:37.082411
125	2022	\N	2021-10-13 15:33:26.473795
126	2022	-249	2021-10-13 16:01:27.772707
127	2022	\N	2021-10-13 16:03:16.70268
128	2022	-250	2021-10-13 16:21:38.691148
129	2022	\N	2021-10-13 16:22:54.555218
130	2022	\N	2021-10-13 16:24:44.982598
131	2022	\N	2021-10-13 16:25:48.772003
132	2022	\N	2021-10-13 16:27:13.745821
133	2022	\N	2021-10-13 16:27:48.844133
134	2022	-251	2021-10-13 16:29:30.064878
135	2022	-251	2021-10-13 16:29:55.377499
136	2022	-251	2021-10-13 16:32:35.119081
137	2022	-251	2021-10-13 16:32:47.532467
138	2022	-253	2021-10-13 16:56:51.579756
139	2022	\N	2021-10-13 16:58:37.836881
140	2022	\N	2021-10-13 16:59:22.165321
141	2022	\N	2021-10-13 17:15:00.534681
142	2022	-254	2021-10-13 17:17:36.093738
143	2022	\N	2021-10-13 17:21:34.313664
144	2022	\N	2021-10-13 17:38:09.092666
145	2022	-255	2021-10-13 17:39:43.67349
146	2022	10010315	2021-10-14 08:31:55.858662
147	2022	-258	2021-10-14 11:09:52.174742
148	2022	-258	2021-10-14 11:10:12.35899
149	2022	-258	2021-10-14 11:10:32.284074
150	2022	-258	2021-10-14 11:11:30.446547
151	2022	-258	2021-10-14 11:16:36.132545
152	2022	-258	2021-10-14 11:17:13.666158
153	2022	-258	2021-10-14 11:17:22.202559
154	2023	10010331	2021-10-26 16:23:09.638964
155	2023	10010331	2021-10-26 16:23:23.338887
156	2022	10010321	2021-10-26 16:34:48.583137
157	2022	10010329	2021-10-27 10:21:25.806882
158	2022	10010329	2021-10-27 10:52:09.591227
159	2030	10010329	2021-10-27 10:52:29.723856
160	2022	-269	2021-10-27 15:28:52.534606
161	2022	-271	2021-10-27 17:20:56.656508
162	2022	10010321	2021-10-27 17:31:15.806982
163	2022	-287	2021-10-28 11:57:13.977372
164	2022	-287	2021-10-28 11:58:18.299021
165	2022	-287	2021-10-28 11:58:31.807419
166	2022	-287	2021-10-28 12:00:20.261224
167	2022	-287	2021-10-28 12:00:47.454955
168	2022	-287	2021-10-28 12:01:27.707951
169	2022	-287	2021-10-28 12:05:03.115068
170	2022	-288	2021-10-28 12:08:53.713654
171	2022	-288	2021-10-28 12:09:44.305519
172	2022	-288	2021-10-28 12:10:25.085394
173	2022	-288	2021-10-28 12:10:58.136841
174	2022	-288	2021-10-28 12:11:41.635688
175	2022	10010315	2021-10-28 12:16:18.103419
176	2022	10010315	2021-10-28 12:16:51.164951
177	2022	-295	2021-10-28 15:05:52.987758
178	2022	-305	2021-10-28 15:07:04.835393
179	2022	-305	2021-10-28 15:08:59.287365
180	2022	-305	2021-10-28 15:27:14.947793
181	2022	-305	2021-10-28 15:29:35.611106
182	2022	-305	2021-10-28 15:30:03.886811
183	2022	-305	2021-10-28 15:31:04.59874
184	2022	-306	2021-10-28 15:34:38.95422
185	2022	-306	2021-10-28 15:34:57.155778
186	2022	-306	2021-10-28 15:36:41.905732
187	2022	-306	2021-10-28 15:38:35.729629
188	2022	-306	2021-10-28 15:38:59.891464
189	2022	-307	2021-10-28 15:39:17.237153
190	2022	-307	2021-10-28 15:40:00.461481
191	2022	-307	2021-10-28 15:40:03.485596
192	2022	-307	2021-10-28 15:40:09.735861
193	2022	-307	2021-10-28 15:40:14.614971
194	2022	10010315	2021-10-28 16:03:45.99562
195	2022	-317	2021-10-28 18:00:00.911769
196	2022	-372	2021-11-22 16:42:22.398456
197	2058	10010646	2021-11-22 16:46:42.246793
198	2058	10010646	2021-11-22 16:51:04.101585
199	2030	-406	2021-11-24 16:04:21.920416
200	2042	-423	2021-11-27 09:26:03.521484
201	2042	-500	2022-01-13 12:15:26.138911
202	2041	\N	2022-01-25 16:46:17.262168
203	2041	\N	2022-01-25 16:53:52.663753
204	2042	-544	2022-01-31 11:51:10.818804
205	2042	-545	2022-01-31 11:56:24.247621
206	2046	-586	2022-02-16 20:11:21.054572
207	2037	-791	2022-06-28 11:17:04.18843
208	2036	-841	2022-06-30 13:30:39.581679
209	2036	-843	2022-06-30 13:43:42.953567
210	2036	-844	2022-06-30 13:56:44.89296
211	2036	-846	2022-06-30 14:01:03.486814
212	2036	-847	2022-06-30 14:02:01.934145
213	2036	-856	2022-06-30 15:06:03.573164
214	2036	-857	2022-06-30 15:08:04.446563
215	2036	-858	2022-06-30 15:19:50.966084
216	2036	-904	2022-07-13 10:28:23.281663
217	2036	-930	2022-07-25 17:33:05.150743
218	2041	-943	2022-08-02 11:26:34.052686
219	2041	-943	2022-08-02 11:26:43.141424
220	2046	-978	2022-08-18 18:05:21.111441
221	2036	-982	2022-08-19 10:10:50.395884
222	2049	-1053	2022-09-08 11:55:01.887952
223	2046	-1089	2022-09-24 13:01:21.526983
224	2046	-1113	2022-10-12 15:31:32.639445
225	2034	-1142	2022-10-31 11:28:26.689979
226	2042	-1260	2023-02-13 15:47:50.691512
227	2042	-1293	2023-02-15 13:30:34.227259
228	2049	-1330	2023-03-21 13:51:07.571511
229	2046	-1347	2023-03-30 22:52:46.765045
\.


--
-- TOC entry 4322 (class 0 OID 367674)
-- Dependencies: 253
-- Data for Name: utente_risposta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utente_risposta (id, id_utente, id_checklist, id_domanda, punteggio, risposta, entered) FROM stdin;
862	1	2023	410495	0	SI	2021-05-04 09:34:06
1247	1	2022	410222	1	NO	2021-06-14 17:31:21
1248	1	2022	410223	3	NO	2021-06-14 17:31:21
1249	1	2022	410224	1	SI	2021-06-14 17:31:21
1250	1	2022	410225	1	SI	2021-06-14 17:31:21
1251	1	2022	410226	1	SI	2021-06-14 17:31:21
6820	10010286	2022	410208	20	NO	2021-06-15 12:04:55
1141	10000006	2022	410208	20	NO	2021-05-07 12:13:33
1142	10000006	2022	410209	0	SI	2021-05-07 12:13:33
1143	10000006	2022	410210	0	SI	2021-05-07 12:13:33
7859	10010325	2048	416334	6	SI	2021-10-04 15:07:23
7861	10010325	2048	416336	0	SI	2021-10-04 15:07:24
7863	10010325	2048	416338	3	SI	2021-10-04 15:07:24
7865	10010325	2048	416340	5	NO	2021-10-04 15:07:24
7558	-209	2022	410208	0	SI	2021-09-30 14:39:00
7560	-209	2022	410210	0	SI	2021-09-30 14:39:00
1158	10000784	2022	410208	0	SI	2021-05-07 16:16:54
1159	10000784	2022	410209	0	SI	2021-05-07 16:16:54
1160	10000784	2022	410210	2	NO	2021-05-07 16:16:54
1161	10000784	2022	410211	0	SI	2021-05-07 16:16:54
1162	10000784	2022	410212	2	NO	2021-05-07 16:16:54
1163	10000784	2022	410213	0	SI	2021-05-07 16:16:54
1164	10000784	2022	410214	0	SI	2021-05-07 16:16:54
1165	10000784	2022	410215	0	SI	2021-05-07 16:16:54
1166	10000784	2022	410216	1	NO	2021-05-07 16:16:54
1167	10000784	2022	410217	4	NO	2021-05-07 16:16:54
7386	10010300	2064	419562	0	NO	2021-09-22 16:26:08
7387	10010300	2064	419563	0	NO	2021-09-22 16:26:08
1184	10008600	2043	414908	0	SI	2021-05-07 16:33:59
1185	10008600	2043	414909	0	SI	2021-05-07 16:33:59
926	1	2024	410823	3	SI	2021-05-04 12:51:59
927	1	2024	410824	9	SI	2021-05-04 12:51:59
928	1	2024	410825	18	SI	2021-05-04 12:51:59
929	1	2024	410826	30	SI	2021-05-04 12:51:59
1186	10008600	2043	414910	0	SI	2021-05-07 16:33:59
1187	10008600	2043	414911	6	NO	2021-05-07 16:33:59
1188	10000740	2024	410634	2	SI	2021-05-07 17:08:14
1189	10000740	2024	410635	3	SI	2021-05-07 17:08:14
1190	10000740	2024	410636	5	SI	2021-05-07 17:08:14
1191	10000740	2024	410637	0	SI	2021-05-07 17:08:14
1192	10000740	2024	410638	1	NO	2021-05-07 17:08:14
1193	10000740	2024	410639	1	NO	2021-05-07 17:08:14
7388	10010300	2064	419564	6	NO	2021-09-22 16:26:08
7389	10010300	2064	419566	0	NO	2021-09-22 16:26:08
7390	10010300	2064	419568	0	NO	2021-09-22 16:26:09
7391	10010300	2064	419570	10	NO	2021-09-22 16:26:09
7392	10010300	2064	419571	3	NO	2021-09-22 16:26:09
7393	10010300	2064	419572	8	NO	2021-09-22 16:26:09
7394	10010300	2064	419573	4	NO	2021-09-22 16:26:09
7395	10010300	2064	419574	3	NO	2021-09-22 16:26:09
1199	-7	2023	410495	0	SI	2021-05-11 15:19:03
1200	-7	2023	410496	0	NO	2021-05-11 15:19:04
1201	-7	2023	410498	0	SI	2021-05-11 15:19:04
1202	-7	2023	410499	25	NO	2021-05-11 15:19:04
1203	-12	2022	410208	0	SI	2021-05-11 15:35:10
1204	-12	2022	410209	2	NO	2021-05-11 15:35:10
1205	-16	2022	410208	0	SI	2021-05-11 15:40:55
1206	-27	2022	410208	0	SI	2021-05-11 16:53:01
1207	-27	2022	410209	2	NO	2021-05-11 16:53:01
1210	10000740	2022	410208	0	SI	2021-05-11 17:07:44
1211	10000740	2022	410209	2	NO	2021-05-11 17:07:45
1212	10000740	2022	410217	0	SI	2021-05-11 17:07:45
1213	10000740	2022	410218	4	NO	2021-05-11 17:07:45
1214	10000740	2022	410219	0	SI	2021-05-11 17:07:45
1215	-49	2048	416334	6	SI	2021-06-14 17:24:19
1216	-49	2048	416335	0	NO	2021-06-14 17:24:19
1217	-49	2048	416336	0	SI	2021-06-14 17:24:19
1218	-49	2048	416356	0	SI	2021-06-14 17:24:19
1219	-49	2048	416357	0	SI	2021-06-14 17:24:19
1236	1	2022	410208	20	NO	2021-06-14 17:31:21
1237	1	2022	410209	0	SI	2021-06-14 17:31:21
1238	1	2022	410210	2	NO	2021-06-14 17:31:21
1239	1	2022	410211	2	NO	2021-06-14 17:31:21
1240	1	2022	410212	2	NO	2021-06-14 17:31:21
1241	1	2022	410213	0	SI	2021-06-14 17:31:21
1242	1	2022	410217	4	NO	2021-06-14 17:31:21
1243	1	2022	410218	4	NO	2021-06-14 17:31:21
1244	1	2022	410219	2	NO	2021-06-14 17:31:21
1245	1	2022	410220	3	NO	2021-06-14 17:31:21
1246	1	2022	410221	0	SI	2021-06-14 17:31:21
7860	10010325	2048	416335	0	NO	2021-10-04 15:07:23
7862	10010325	2048	416337	3	SI	2021-10-04 15:07:24
7864	10010325	2048	416339	0	SI	2021-10-04 15:07:24
7866	10010325	2048	416341	5	NO	2021-10-04 15:07:24
7559	-209	2022	410209	0	SI	2021-09-30 14:39:00
7561	-209	2022	410211	2	NO	2021-09-30 14:39:00
7223	10010285	2022	410208	0	SI	2021-06-17 15:51:56
7318	10010286	2023	410596	30	NO	2021-09-15 10:16:24
7319	10010286	2023	410597	30	SI	2021-09-15 10:16:24
7320	10010286	2023	410598	0	NO	2021-09-15 10:16:24
7321	10010286	2023	410600	0	SI	2021-09-15 10:16:24
7322	10010286	2023	410601	0	NO	2021-09-15 10:16:24
7323	10010286	2023	410606	8	NO	2021-09-15 10:16:24
7324	10010286	2023	410607	0	SI	2021-09-15 10:16:24
7325	10010286	2023	410608	5	NO	2021-09-15 10:16:24
7326	10010286	2023	410609	5	SI	2021-09-15 10:16:24
7327	10010286	2023	410610	0	NO	2021-09-15 10:16:24
7328	10010286	2023	410611	4	SI	2021-09-15 10:16:24
7329	10010286	2023	410613	5	NO	2021-09-15 10:16:24
7330	10010286	2023	410614	0	SI	2021-09-15 10:16:24
7331	10010286	2023	410615	4	NO	2021-09-15 10:16:24
7332	10010286	2023	410616	0	SI	2021-09-15 10:16:24
7333	10010286	2023	410618	0	NO	2021-09-15 10:16:24
7334	10010286	2023	410619	60	SI	2021-09-15 10:16:24
7335	10010286	2023	410620	0	NO	2021-09-15 10:16:24
7336	10010286	2023	410621	120	SI	2021-09-15 10:16:24
7337	10010286	2023	410622	0	NO	2021-09-15 10:16:24
7338	10010286	2023	410623	1	SI	2021-09-15 10:16:24
7339	10010286	2023	410624	0	NO	2021-09-15 10:16:25
7340	10010286	2023	410625	3	SI	2021-09-15 10:16:25
7341	10010286	2023	410626	0	NO	2021-09-15 10:16:25
7342	10010286	2023	410628	250	SI	2021-09-15 10:16:25
7343	10010286	2023	410629	0	NO	2021-09-15 10:16:25
7344	10010286	2023	410630	25	SI	2021-09-15 10:16:25
7345	10010286	2023	410631	0	NO	2021-09-15 10:16:25
7346	10010286	2023	420831	0	SI	2021-09-15 10:16:25
7347	10010286	2023	420832	0	NO	2021-09-15 10:16:25
7348	10010286	2023	420833	1	SI	2021-09-15 10:16:25
7349	10010286	2023	420834	0	NO	2021-09-15 10:16:25
7350	10010286	2023	420835	1	SI	2021-09-15 10:16:25
7351	10010286	2023	420836	0	NO	2021-09-15 10:16:25
7352	10010286	2023	420837	3	SI	2021-09-15 10:16:25
7353	10010286	2023	420838	0	NO	2021-09-15 10:16:25
7354	10010286	2023	420839	3	SI	2021-09-15 10:16:25
7355	10010286	2023	420840	0	NO	2021-09-15 10:16:25
7356	10010286	2023	420841	12	SI	2021-09-15 10:16:25
7357	10010286	2023	420842	0	NO	2021-09-15 10:16:25
7508	10010301	2042	414640	50	NO	2021-09-22 18:06:48
7510	10010301	2042	414644	0	NO	2021-09-22 18:06:49
7512	10010301	2042	414650	5	SI	2021-09-22 18:06:49
7517	10010304	2022	410233	1	SI	2021-09-28 14:51:49
7519	10010304	2022	410235	1	SI	2021-09-28 14:51:49
7454	10010300	2030	411861	0	NO	2021-09-22 16:42:20
7455	10010300	2030	411862	0	NO	2021-09-22 16:42:20
7456	10010300	2030	411863	4	NO	2021-09-22 16:42:20
7457	10010300	2030	411864	3	NO	2021-09-22 16:42:20
7224	10010285	2022	410209	0	SI	2021-06-17 15:51:56
7458	10010300	2030	411865	25	NO	2021-09-22 16:42:20
7459	10010300	2030	411866	0	NO	2021-09-22 16:42:20
7460	10010300	2030	412052	4	NO	2021-09-22 16:42:20
7461	10010300	2030	412054	0	NO	2021-09-22 16:42:20
7462	10010300	2030	412055	0	NO	2021-09-22 16:42:21
7463	10010300	2030	412056	0	NO	2021-09-22 16:42:21
7464	10010300	2030	412057	0	NO	2021-09-22 16:42:21
7465	10010300	2030	412058	0	NO	2021-09-22 16:42:21
7466	10010300	2058	418071	13	NO	2021-09-22 17:02:54
1704	10010280	2022	410208	0	SI	2021-06-15 10:40:25
1705	10010280	2022	410209	0	SI	2021-06-15 10:40:25
1706	10010280	2022	410210	2	NO	2021-06-15 10:40:25
1707	10010280	2022	410211	2	NO	2021-06-15 10:40:25
1708	10010280	2022	410212	0	SI	2021-06-15 10:40:25
1709	10010280	2022	410213	0	SI	2021-06-15 10:40:25
1710	10010280	2022	410214	1	NO	2021-06-15 10:40:25
7467	10010300	2058	418073	6	NO	2021-09-22 17:02:54
7468	10010300	2058	418074	8	NO	2021-09-22 17:02:54
7469	10010300	2058	418075	0	NO	2021-09-22 17:02:54
7470	10010300	2058	418076	4	NO	2021-09-22 17:02:54
7471	10010300	2058	418077	0	NO	2021-09-22 17:02:54
7472	10010300	2058	418080	10	NO	2021-09-22 17:02:54
7473	10010300	2058	418081	0	SI	2021-09-22 17:02:54
7474	10010300	2058	418082	4	NO	2021-09-22 17:02:54
7475	10010300	2058	418083	9	NO	2021-09-22 17:02:54
7476	10010300	2058	418084	5	NO	2021-09-22 17:02:54
7477	10010300	2058	418085	1	SI	2021-09-22 17:02:55
7478	10010300	2058	418086	0	NO	2021-09-22 17:02:55
7479	10010300	2058	418087	0	NO	2021-09-22 17:02:55
7480	10010300	2058	418088	0	NO	2021-09-22 17:02:55
7481	10010300	2058	418089	0	NO	2021-09-22 17:02:55
7482	10010300	2058	418092	4	NO	2021-09-22 17:02:55
7483	10010300	2058	418093	1	NO	2021-09-22 17:02:55
7484	10010300	2058	418095	4	NO	2021-09-22 17:02:55
7485	10010300	2058	418098	0	NO	2021-09-22 17:02:55
7486	10010300	2058	418099	30	NO	2021-09-22 17:02:55
7487	10010300	2058	418100	0	NO	2021-09-22 17:02:55
7488	10010300	2058	418101	17	NO	2021-09-22 17:02:55
7489	10010300	2058	418102	0	NO	2021-09-22 17:02:55
7490	10010300	2058	418103	0	NO	2021-09-22 17:02:55
7491	10010300	2058	418104	0	NO	2021-09-22 17:02:55
7492	10010300	2058	418105	0	NO	2021-09-22 17:02:55
7493	10010300	2058	418106	0	NO	2021-09-22 17:02:55
7494	10010300	2058	418107	0	NO	2021-09-22 17:02:55
7495	10010300	2058	418409	100	SI	2021-09-22 17:02:56
7496	10010300	2058	418410	250	SI	2021-09-22 17:02:56
7497	10010300	2058	418411	25	SI	2021-09-22 17:02:56
7498	10010300	2058	418412	25	SI	2021-09-22 17:02:56
7499	10010300	2058	418413	0	NO	2021-09-22 17:02:56
7567	10010318	2022	410213	1	NO	2021-09-30 15:47:24
7518	10010304	2022	410234	1	SI	2021-09-28 14:51:49
7520	10010304	2022	410236	0	SI	2021-09-28 14:51:49
7867	10010325	2048	416343	3	NO	2021-10-04 15:07:24
7869	10010325	2048	416345	6	SI	2021-10-04 15:07:24
7871	10010325	2048	416347	5	NO	2021-10-04 15:07:24
7873	10010325	2048	416349	5	NO	2021-10-04 15:07:24
7875	10010325	2048	416351	5	SI	2021-10-04 15:07:24
7877	10010325	2048	416353	5	NO	2021-10-04 15:07:24
7879	10010325	2048	416355	0	SI	2021-10-04 15:07:24
7868	10010325	2048	416344	0	SI	2021-10-04 15:07:24
7870	10010325	2048	416346	10	NO	2021-10-04 15:07:24
7509	10010301	2042	414643	6	NO	2021-09-22 18:06:48
7511	10010301	2042	414649	6	SI	2021-09-22 18:06:49
7513	10010301	2042	414651	22	NO	2021-09-22 18:06:49
7872	10010325	2048	416348	0	NO	2021-10-04 15:07:24
7874	10010325	2048	416350	0	SI	2021-10-04 15:07:24
7876	10010325	2048	416352	4	NO	2021-10-04 15:07:24
7878	10010325	2048	416354	0	SI	2021-10-04 15:07:24
7880	10010325	2048	416356	0	SI	2021-10-04 15:07:24
7225	10010286	2023	410495	400	NO	2021-09-15 10:16:19
7226	10010286	2023	410496	3	SI	2021-09-15 10:16:19
7227	10010286	2023	410497	0	NO	2021-09-15 10:16:19
7228	10010286	2023	410498	0	SI	2021-09-15 10:16:19
7229	10010286	2023	410499	25	NO	2021-09-15 10:16:19
7230	10010286	2023	410500	0	SI	2021-09-15 10:16:19
7231	10010286	2023	410501	25	NO	2021-09-15 10:16:19
7232	10010286	2023	410502	0	SI	2021-09-15 10:16:19
7233	10010286	2023	410503	25	NO	2021-09-15 10:16:19
7234	10010286	2023	410504	0	SI	2021-09-15 10:16:19
7235	10010286	2023	410505	0	SI	2021-09-15 10:16:19
7236	10010286	2023	410506	0	SI	2021-09-15 10:16:20
7237	10010286	2023	410507	25	NO	2021-09-15 10:16:20
7238	10010286	2023	410508	6	NO	2021-09-15 10:16:20
7239	10010286	2023	410509	0	SI	2021-09-15 10:16:20
7240	10010286	2023	410510	10	NO	2021-09-15 10:16:20
7241	10010286	2023	410512	3	SI	2021-09-15 10:16:20
7242	10010286	2023	410513	0	NO	2021-09-15 10:16:20
7243	10010286	2023	410514	0	SI	2021-09-15 10:16:20
7244	10010286	2023	410515	0	NO	2021-09-15 10:16:20
7245	10010286	2023	410516	0	SI	2021-09-15 10:16:20
7246	10010286	2023	410517	20	NO	2021-09-15 10:16:20
7247	10010286	2023	410518	0	SI	2021-09-15 10:16:20
7248	10010286	2023	410519	20	NO	2021-09-15 10:16:20
7249	10010286	2023	410520	0	SI	2021-09-15 10:16:20
7250	10010286	2023	410521	20	NO	2021-09-15 10:16:20
7251	10010286	2023	410522	0	SI	2021-09-15 10:16:20
7252	10010286	2023	410523	25	NO	2021-09-15 10:16:20
7253	10010286	2023	410524	0	SI	2021-09-15 10:16:20
7254	10010286	2023	410525	25	NO	2021-09-15 10:16:20
7255	10010286	2023	410526	0	SI	2021-09-15 10:16:20
7256	10010286	2023	410527	20	NO	2021-09-15 10:16:21
7257	10010286	2023	410528	0	SI	2021-09-15 10:16:21
7258	10010286	2023	410529	8	NO	2021-09-15 10:16:21
7259	10010286	2023	410530	0	SI	2021-09-15 10:16:21
7260	10010286	2023	410531	8	NO	2021-09-15 10:16:21
7261	10010286	2023	410532	0	SI	2021-09-15 10:16:21
7262	10010286	2023	410533	9	NO	2021-09-15 10:16:21
7263	10010286	2023	410534	4	SI	2021-09-15 10:16:21
7264	10010286	2023	410535	0	NO	2021-09-15 10:16:21
7265	10010286	2023	410536	0	SI	2021-09-15 10:16:21
7266	10010286	2023	410537	7	NO	2021-09-15 10:16:21
7267	10010286	2023	410538	0	SI	2021-09-15 10:16:21
7268	10010286	2023	410539	6	NO	2021-09-15 10:16:21
7269	10010286	2023	410541	0	SI	2021-09-15 10:16:21
7270	10010286	2023	410542	6	NO	2021-09-15 10:16:21
7271	10010286	2023	410543	0	SI	2021-09-15 10:16:21
7272	10010286	2023	410545	50	NO	2021-09-15 10:16:21
7273	10010286	2023	410546	0	SI	2021-09-15 10:16:21
7274	10010286	2023	410547	12	NO	2021-09-15 10:16:21
7275	10010286	2023	410548	8	SI	2021-09-15 10:16:21
7276	10010286	2023	410549	7	NO	2021-09-15 10:16:21
7277	10010286	2023	410550	3	SI	2021-09-15 10:16:22
7278	10010286	2023	410551	12	NO	2021-09-15 10:16:22
7279	10010286	2023	410553	4	SI	2021-09-15 10:16:22
7280	10010286	2023	410554	15	NO	2021-09-15 10:16:22
7281	10010286	2023	410556	0	SI	2021-09-15 10:16:22
7282	10010286	2023	410557	8	NO	2021-09-15 10:16:22
7283	10010286	2023	410558	10	SI	2021-09-15 10:16:22
7284	10010286	2023	410559	0	NO	2021-09-15 10:16:22
7285	10010286	2023	410561	0	SI	2021-09-15 10:16:22
7286	10010286	2023	410562	3	NO	2021-09-15 10:16:22
7287	10010286	2023	410563	0	SI	2021-09-15 10:16:22
7288	10010286	2023	410564	3	NO	2021-09-15 10:16:22
7289	10010286	2023	410565	0	SI	2021-09-15 10:16:22
7290	10010286	2023	410566	3	NO	2021-09-15 10:16:22
7291	10010286	2023	410567	0	SI	2021-09-15 10:16:22
7292	10010286	2023	410568	3	NO	2021-09-15 10:16:22
7293	10010286	2023	410569	0	SI	2021-09-15 10:16:22
7294	10010286	2023	410570	3	NO	2021-09-15 10:16:22
7295	10010286	2023	410571	0	SI	2021-09-15 10:16:22
7296	10010286	2023	410572	3	NO	2021-09-15 10:16:22
7297	10010286	2023	410573	0	SI	2021-09-15 10:16:23
7298	10010286	2023	410574	3	NO	2021-09-15 10:16:23
7299	10010286	2023	410575	5	SI	2021-09-15 10:16:23
7300	10010286	2023	410576	0	NO	2021-09-15 10:16:23
7301	10010286	2023	410577	1	SI	2021-09-15 10:16:23
7302	10010286	2023	410578	0	NO	2021-09-15 10:16:23
7303	10010286	2023	410579	1	SI	2021-09-15 10:16:23
7304	10010286	2023	410580	0	NO	2021-09-15 10:16:23
7305	10010286	2023	410581	1	SI	2021-09-15 10:16:23
7306	10010286	2023	410582	0	NO	2021-09-15 10:16:23
7307	10010286	2023	410583	1	SI	2021-09-15 10:16:23
7308	10010286	2023	410584	0	NO	2021-09-15 10:16:23
7309	10010286	2023	410585	3	SI	2021-09-15 10:16:23
7310	10010286	2023	410586	0	NO	2021-09-15 10:16:23
7311	10010286	2023	410587	1	SI	2021-09-15 10:16:23
7312	10010286	2023	410588	0	NO	2021-09-15 10:16:23
7313	10010286	2023	410590	5	SI	2021-09-15 10:16:23
7314	10010286	2023	410591	50	NO	2021-09-15 10:16:23
7315	10010286	2023	410592	0	SI	2021-09-15 10:16:23
7316	10010286	2023	410593	17	NO	2021-09-15 10:16:23
7317	10010286	2023	410595	0	SI	2021-09-15 10:16:23
7897	-228	2022	410208	0	SI	2021-10-12 15:02:52
7898	-228	2022	410209	0	SI	2021-10-12 15:02:52
7899	-241	2027	411205	4	SI	2021-10-12 15:54:26
7900	-241	2027	411206	4	SI	2021-10-12 15:54:26
7901	-241	2027	411207	4	SI	2021-10-12 15:54:26
7902	-241	2027	411208	4	SI	2021-10-12 15:54:26
7905	-247	2022	419848	0	SI	2021-10-13 15:27:18
7911	-258	2022	410208	0	SI	2021-10-14 11:17:22
8018	10010331	2023	410495	400	NO	2021-10-26 16:23:23
8019	10010331	2023	410496	0	NO	2021-10-26 16:23:23
8020	10010331	2023	410498	70	NO	2021-10-26 16:23:24
8021	10010331	2023	410499	25	NO	2021-10-26 16:23:24
8022	10010331	2023	410500	25	NO	2021-10-26 16:23:24
8023	10010331	2023	410505	25	NO	2021-10-26 16:23:24
8024	10010331	2023	410508	6	NO	2021-10-26 16:23:24
8025	10010331	2023	410509	6	NO	2021-10-26 16:23:24
8026	10010331	2023	410510	10	NO	2021-10-26 16:23:24
8027	10010331	2023	410512	0	NO	2021-10-26 16:23:24
8028	10010331	2023	410514	5	NO	2021-10-26 16:23:24
8029	10010331	2023	410515	0	NO	2021-10-26 16:23:24
8030	10010331	2023	410516	20	NO	2021-10-26 16:23:24
8031	10010331	2023	410518	20	NO	2021-10-26 16:23:24
8032	10010331	2023	410520	20	NO	2021-10-26 16:23:24
8033	10010331	2023	410522	25	NO	2021-10-26 16:23:24
8034	10010331	2023	410526	20	NO	2021-10-26 16:23:24
8035	10010331	2023	410528	8	NO	2021-10-26 16:23:24
8036	10010331	2023	410530	8	NO	2021-10-26 16:23:24
8037	10010331	2023	410532	9	NO	2021-10-26 16:23:24
8038	10010331	2023	410534	0	NO	2021-10-26 16:23:24
8039	10010331	2023	410536	7	NO	2021-10-26 16:23:24
8040	10010331	2023	410538	4	NO	2021-10-26 16:23:24
8041	10010331	2023	410539	6	NO	2021-10-26 16:23:24
8042	10010331	2023	410541	6	NO	2021-10-26 16:23:24
8043	10010331	2023	410543	4	NO	2021-10-26 16:23:24
8044	10010331	2023	410545	50	NO	2021-10-26 16:23:24
8045	10010331	2023	410546	7	NO	2021-10-26 16:23:25
8046	10010331	2023	410547	12	NO	2021-10-26 16:23:25
8047	10010331	2023	410548	0	NO	2021-10-26 16:23:25
8048	10010331	2023	410549	7	NO	2021-10-26 16:23:25
8049	10010331	2023	410550	0	NO	2021-10-26 16:23:25
8050	10010331	2023	410551	12	NO	2021-10-26 16:23:25
8051	10010331	2023	410553	0	NO	2021-10-26 16:23:25
8052	10010331	2023	410554	15	NO	2021-10-26 16:23:25
8053	10010331	2023	410556	10	NO	2021-10-26 16:23:25
8054	10010331	2023	410557	0	SI	2021-10-26 16:23:25
8055	10010331	2023	410558	0	NO	2021-10-26 16:23:25
8056	10010331	2023	410561	3	NO	2021-10-26 16:23:25
8057	10010331	2023	410562	3	NO	2021-10-26 16:23:25
8058	10010331	2023	410563	3	NO	2021-10-26 16:23:25
8059	10010331	2023	410564	3	NO	2021-10-26 16:23:25
8060	10010331	2023	410565	3	NO	2021-10-26 16:23:25
8061	10010331	2023	410566	3	NO	2021-10-26 16:23:25
8062	10010331	2023	410567	3	NO	2021-10-26 16:23:25
8063	10010331	2023	410568	3	NO	2021-10-26 16:23:25
8064	10010331	2023	410569	3	NO	2021-10-26 16:23:25
8065	10010331	2023	410570	3	NO	2021-10-26 16:23:25
8066	10010331	2023	410571	0	SI	2021-10-26 16:23:25
8067	10010331	2023	410572	0	SI	2021-10-26 16:23:25
8068	10010331	2023	410573	0	SI	2021-10-26 16:23:26
8069	10010331	2023	410574	0	SI	2021-10-26 16:23:26
8070	10010331	2023	410575	0	NO	2021-10-26 16:23:26
8071	10010331	2023	410576	0	NO	2021-10-26 16:23:26
8072	10010331	2023	410577	0	NO	2021-10-26 16:23:26
8073	10010331	2023	410578	0	NO	2021-10-26 16:23:26
8074	10010331	2023	410579	0	NO	2021-10-26 16:23:26
8075	10010331	2023	410580	0	NO	2021-10-26 16:23:26
8076	10010331	2023	410581	0	NO	2021-10-26 16:23:26
8077	10010331	2023	410582	0	NO	2021-10-26 16:23:26
8078	10010331	2023	410583	0	NO	2021-10-26 16:23:26
8079	10010331	2023	410584	0	NO	2021-10-26 16:23:26
8080	10010331	2023	410585	0	NO	2021-10-26 16:23:26
8081	10010331	2023	410586	0	NO	2021-10-26 16:23:26
8082	10010331	2023	410587	0	NO	2021-10-26 16:23:26
8083	10010331	2023	410588	0	NO	2021-10-26 16:23:26
8084	10010331	2023	410590	5	SI	2021-10-26 16:23:26
8085	10010331	2023	410591	50	NO	2021-10-26 16:23:26
8086	10010331	2023	410592	9	NO	2021-10-26 16:23:26
8087	10010331	2023	410593	17	NO	2021-10-26 16:23:26
8088	10010331	2023	410595	3	NO	2021-10-26 16:23:26
8089	10010331	2023	410596	30	NO	2021-10-26 16:23:26
8090	10010331	2023	410597	0	NO	2021-10-26 16:23:26
8091	10010331	2023	410598	0	NO	2021-10-26 16:23:26
8092	10010331	2023	410600	12	NO	2021-10-26 16:23:27
8093	10010331	2023	410601	0	NO	2021-10-26 16:23:27
8094	10010331	2023	410606	8	NO	2021-10-26 16:23:27
8095	10010331	2023	410607	5	NO	2021-10-26 16:23:27
8096	10010331	2023	410609	0	NO	2021-10-26 16:23:27
8097	10010331	2023	410611	0	NO	2021-10-26 16:23:27
8098	10010331	2023	410613	5	NO	2021-10-26 16:23:27
8099	10010331	2023	410614	5	NO	2021-10-26 16:23:27
8100	10010331	2023	410615	4	NO	2021-10-26 16:23:27
8101	10010331	2023	410616	3	NO	2021-10-26 16:23:27
8102	10010331	2023	410618	0	NO	2021-10-26 16:23:27
8103	10010331	2023	410619	0	NO	2021-10-26 16:23:27
8104	10010331	2023	410620	0	NO	2021-10-26 16:23:27
8105	10010331	2023	410621	0	NO	2021-10-26 16:23:27
8106	10010331	2023	410622	0	NO	2021-10-26 16:23:27
8107	10010331	2023	410623	0	NO	2021-10-26 16:23:27
8108	10010331	2023	410625	0	NO	2021-10-26 16:23:27
8109	10010331	2023	410628	0	NO	2021-10-26 16:23:27
8110	10010331	2023	410629	0	NO	2021-10-26 16:23:27
8111	10010331	2023	410630	0	NO	2021-10-26 16:23:27
8112	10010331	2023	410631	0	NO	2021-10-26 16:23:27
8113	10010331	2023	420831	15	NO	2021-10-26 16:23:27
8114	10010331	2023	420832	0	NO	2021-10-26 16:23:27
8115	10010331	2023	420833	0	NO	2021-10-26 16:23:27
8116	10010331	2023	420834	0	NO	2021-10-26 16:23:28
8117	10010331	2023	420835	0	NO	2021-10-26 16:23:28
8118	10010331	2023	420836	0	NO	2021-10-26 16:23:28
8119	10010331	2023	420837	0	NO	2021-10-26 16:23:28
8120	10010331	2023	420838	0	NO	2021-10-26 16:23:28
8121	10010331	2023	420839	0	NO	2021-10-26 16:23:28
8122	10010331	2023	420841	0	NO	2021-10-26 16:23:28
8123	10010331	2023	420842	0	NO	2021-10-26 16:23:28
8350	-406	2030	411847	0	SI	2021-11-24 16:04:22
8351	-406	2030	411848	0	SI	2021-11-24 16:04:22
8352	-406	2030	411849	0	SI	2021-11-24 16:04:22
8353	-406	2030	411850	0	NO	2021-11-24 16:04:22
8354	-406	2030	411852	0	SI	2021-11-24 16:04:22
8355	-406	2030	411853	0	SI	2021-11-24 16:04:22
8356	-406	2030	411854	10	NO	2021-11-24 16:04:22
8357	-406	2030	411856	8	NO	2021-11-24 16:04:22
8358	-406	2030	411857	0	SI	2021-11-24 16:04:22
8359	-406	2030	411858	6	SI	2021-11-24 16:04:22
8360	-406	2030	411859	0	SI	2021-11-24 16:04:22
8361	-406	2030	411860	12	SI	2021-11-24 16:04:22
8362	-406	2030	411861	4	SI	2021-11-24 16:04:22
8363	-406	2030	411862	0	NO	2021-11-24 16:04:22
8364	-406	2030	411863	4	NO	2021-11-24 16:04:22
8365	-406	2030	411864	3	NO	2021-11-24 16:04:22
8366	-406	2030	411865	0	SI	2021-11-24 16:04:22
8367	-406	2030	411866	2	SI	2021-11-24 16:04:22
8368	-406	2030	411867	10	NO	2021-11-24 16:04:22
8369	-406	2030	411868	0	SI	2021-11-24 16:04:22
8370	-406	2030	411869	0	SI	2021-11-24 16:04:22
8371	-406	2030	411870	3	SI	2021-11-24 16:04:22
8372	-406	2030	411871	22	NO	2021-11-24 16:04:22
8373	-406	2030	411873	0	SI	2021-11-24 16:04:22
8374	-406	2030	411874	17	SI	2021-11-24 16:04:22
8375	-406	2030	411875	0	NO	2021-11-24 16:04:22
8376	-406	2030	411878	0	SI	2021-11-24 16:04:22
8377	-406	2030	411879	2	NO	2021-11-24 16:04:22
8378	-406	2030	411880	0	SI	2021-11-24 16:04:22
8379	-406	2030	411881	4	NO	2021-11-24 16:04:22
8380	-406	2030	411882	0	SI	2021-11-24 16:04:22
8381	-406	2030	411883	0	NO	2021-11-24 16:04:22
8382	-406	2030	411884	0	NO	2021-11-24 16:04:22
8383	-406	2030	411888	0	NO	2021-11-24 16:04:22
8384	-406	2030	411891	0	SI	2021-11-24 16:04:22
8385	-406	2030	411892	0	SI	2021-11-24 16:04:22
8386	-406	2030	411893	0	SI	2021-11-24 16:04:22
8387	-406	2030	411894	0	SI	2021-11-24 16:04:22
8388	-406	2030	411895	2	NO	2021-11-24 16:04:22
8389	-406	2030	411896	0	SI	2021-11-24 16:04:22
8390	-406	2030	411897	0	SI	2021-11-24 16:04:22
8391	-406	2030	411898	2	SI	2021-11-24 16:04:22
8392	-406	2030	411899	0	SI	2021-11-24 16:04:22
8393	-406	2030	411900	0	SI	2021-11-24 16:04:22
8394	-406	2030	411901	0	SI	2021-11-24 16:04:22
8395	-406	2030	411902	0	SI	2021-11-24 16:04:22
8396	-406	2030	411903	3	NO	2021-11-24 16:04:22
8397	-406	2030	411906	0	NO	2021-11-24 16:04:22
8398	-406	2030	411908	4	SI	2021-11-24 16:04:22
8399	-406	2030	411909	0	SI	2021-11-24 16:04:22
8400	-406	2030	411910	0	SI	2021-11-24 16:04:22
8401	-406	2030	411911	0	SI	2021-11-24 16:04:22
8402	-406	2030	411912	4	SI	2021-11-24 16:04:22
8403	-406	2030	411913	6	SI	2021-11-24 16:04:22
8404	-406	2030	411914	2	SI	2021-11-24 16:04:22
8405	-406	2030	411915	0	SI	2021-11-24 16:04:22
8406	-406	2030	411916	8	NO	2021-11-24 16:04:22
8407	-406	2030	411917	8	NO	2021-11-24 16:04:22
8408	-406	2030	411918	8	NO	2021-11-24 16:04:22
8409	-406	2030	411919	0	NO	2021-11-24 16:04:22
8410	-406	2030	411920	3	SI	2021-11-24 16:04:22
8411	-406	2030	411921	7	SI	2021-11-24 16:04:22
8412	-406	2030	411922	5	NO	2021-11-24 16:04:22
8413	-406	2030	411930	0	NO	2021-11-24 16:04:22
8414	-406	2030	411936	0	NO	2021-11-24 16:04:22
8415	-406	2030	411938	0	NO	2021-11-24 16:04:22
8416	-406	2030	411940	0	NO	2021-11-24 16:04:22
8417	-406	2030	411941	12	NO	2021-11-24 16:04:22
8418	-406	2030	411942	12	SI	2021-11-24 16:04:22
8419	-406	2030	411943	0	SI	2021-11-24 16:04:22
8420	-406	2030	411944	0	SI	2021-11-24 16:04:22
8421	-406	2030	411945	0	SI	2021-11-24 16:04:22
8422	-406	2030	411946	0	SI	2021-11-24 16:04:22
8423	-406	2030	411947	12	SI	2021-11-24 16:04:22
8424	-406	2030	411948	5	NO	2021-11-24 16:04:22
8425	-406	2030	411950	0	SI	2021-11-24 16:04:22
8426	-406	2030	411951	0	NO	2021-11-24 16:04:22
8427	-406	2030	411952	12	SI	2021-11-24 16:04:22
8428	-406	2030	411953	0	NO	2021-11-24 16:04:22
8429	-406	2030	411954	0	NO	2021-11-24 16:04:22
8430	-406	2030	411955	0	SI	2021-11-24 16:04:22
8431	-406	2030	411956	0	SI	2021-11-24 16:04:22
8432	-406	2030	411957	0	SI	2021-11-24 16:04:22
8433	-406	2030	411958	0	SI	2021-11-24 16:04:22
8434	-406	2030	411959	9	SI	2021-11-24 16:04:22
8435	-406	2030	411960	2	SI	2021-11-24 16:04:22
8436	-406	2030	411961	12	NO	2021-11-24 16:04:22
8437	-406	2030	411962	0	SI	2021-11-24 16:04:22
8438	-406	2030	411963	0	NO	2021-11-24 16:04:22
8439	-406	2030	411966	2	SI	2021-11-24 16:04:22
8440	-406	2030	411967	0	NO	2021-11-24 16:04:22
8441	-406	2030	411969	0	SI	2021-11-24 16:04:22
8442	-406	2030	411970	9	NO	2021-11-24 16:04:22
8443	-406	2030	411971	10	SI	2021-11-24 16:04:22
8444	-406	2030	411972	10	SI	2021-11-24 16:04:22
8445	-406	2030	411973	15	SI	2021-11-24 16:04:22
8446	-406	2030	411974	2	SI	2021-11-24 16:04:22
8447	-406	2030	411975	0	SI	2021-11-24 16:04:22
8448	-406	2030	411976	3	NO	2021-11-24 16:04:22
8449	-406	2030	411977	2	SI	2021-11-24 16:04:22
8450	-406	2030	411978	4	SI	2021-11-24 16:04:22
8451	-406	2030	411979	7	SI	2021-11-24 16:04:22
8452	-406	2030	411980	15	SI	2021-11-24 16:04:22
8453	-406	2030	411981	30	SI	2021-11-24 16:04:22
8454	-406	2030	411983	8	NO	2021-11-24 16:04:22
8455	-406	2030	411988	0	SI	2021-11-24 16:04:22
8456	-406	2030	411989	0	SI	2021-11-24 16:04:22
8457	-406	2030	411990	8	NO	2021-11-24 16:04:22
8458	-406	2030	411991	6	NO	2021-11-24 16:04:22
8459	-406	2030	411992	12	SI	2021-11-24 16:04:22
8460	-406	2030	411993	5	SI	2021-11-24 16:04:22
8461	-406	2030	411995	0	SI	2021-11-24 16:04:22
8462	-406	2030	411996	0	SI	2021-11-24 16:04:22
8463	-406	2030	411997	0	SI	2021-11-24 16:04:22
8464	-406	2030	411998	25	NO	2021-11-24 16:04:22
8465	-406	2030	412001	0	SI	2021-11-24 16:04:22
8466	-406	2030	412002	0	SI	2021-11-24 16:04:22
8467	-406	2030	412003	0	SI	2021-11-24 16:04:22
8468	-406	2030	412004	0	SI	2021-11-24 16:04:22
8469	-406	2030	412005	0	SI	2021-11-24 16:04:22
8470	-406	2030	412006	2	SI	2021-11-24 16:04:22
8471	-406	2030	412007	0	SI	2021-11-24 16:04:22
8472	-406	2030	412008	0	NO	2021-11-24 16:04:22
8473	-406	2030	412010	1	NO	2021-11-24 16:04:22
8474	-406	2030	412012	5	NO	2021-11-24 16:04:22
8475	-406	2030	412013	0	SI	2021-11-24 16:04:22
8476	-406	2030	412014	0	SI	2021-11-24 16:04:22
8477	-406	2030	412015	0	SI	2021-11-24 16:04:22
8478	-406	2030	412016	0	SI	2021-11-24 16:04:22
8479	-406	2030	412018	0	SI	2021-11-24 16:04:22
8480	-406	2030	412019	2	SI	2021-11-24 16:04:22
8481	-406	2030	412020	0	SI	2021-11-24 16:04:22
8482	-406	2030	412021	10	NO	2021-11-24 16:04:22
8483	-406	2030	412028	0	SI	2021-11-24 16:04:22
8484	-406	2030	412029	0	SI	2021-11-24 16:04:22
8485	-406	2030	412030	2	NO	2021-11-24 16:04:22
8486	-406	2030	412033	0	SI	2021-11-24 16:04:22
8487	-406	2030	412034	0	SI	2021-11-24 16:04:22
8488	-406	2030	412035	3	SI	2021-11-24 16:04:22
8489	-406	2030	412036	10	SI	2021-11-24 16:04:22
8490	-406	2030	412037	0	SI	2021-11-24 16:04:22
8491	-406	2030	412038	3	SI	2021-11-24 16:04:22
8492	-406	2030	412039	2	SI	2021-11-24 16:04:22
8493	-406	2030	412041	20	SI	2021-11-24 16:04:22
8494	-406	2030	412042	40	SI	2021-11-24 16:04:22
8495	-406	2030	412043	0	NO	2021-11-24 16:04:22
8496	-406	2030	412044	0	NO	2021-11-24 16:04:22
8497	-406	2030	412045	55	SI	2021-11-24 16:04:22
8498	-406	2030	412046	0	NO	2021-11-24 16:04:22
8499	-406	2030	412047	35	SI	2021-11-24 16:04:22
8500	-406	2030	412048	25	SI	2021-11-24 16:04:22
8501	-406	2030	412049	15	SI	2021-11-24 16:04:22
8502	-406	2030	412050	0	SI	2021-11-24 16:04:22
8503	-406	2030	412051	0	SI	2021-11-24 16:04:22
8504	-406	2030	412052	0	SI	2021-11-24 16:04:22
8505	-406	2030	412054	0	NO	2021-11-24 16:04:22
8506	-406	2030	412055	0	NO	2021-11-24 16:04:22
8507	-406	2030	412056	25	SI	2021-11-24 16:04:22
8508	-406	2030	412057	25	SI	2021-11-24 16:04:22
8509	-406	2030	412058	25	SI	2021-11-24 16:04:22
8510	-423	2042	414640	0	SI	2021-11-27 09:26:04
8511	-423	2042	414641	6	SI	2021-11-27 09:26:04
8512	-423	2042	414643	6	NO	2021-11-27 09:26:04
8513	-423	2042	414644	2	SI	2021-11-27 09:26:04
8514	-423	2042	414645	7	NO	2021-11-27 09:26:04
8515	-423	2042	414646	0	SI	2021-11-27 09:26:04
8516	-423	2042	414647	0	NO	2021-11-27 09:26:04
8517	-423	2042	414648	0	NO	2021-11-27 09:26:04
8518	-423	2042	414649	0	NO	2021-11-27 09:26:04
8519	-423	2042	414650	0	NO	2021-11-27 09:26:04
8520	-423	2042	414651	22	NO	2021-11-27 09:26:04
8521	-423	2042	414652	8	NO	2021-11-27 09:26:04
8522	-423	2042	414667	5	NO	2021-11-27 09:26:04
8523	-423	2042	414672	0	NO	2021-11-27 09:26:04
8524	-423	2042	414673	22	NO	2021-11-27 09:26:04
8525	-423	2042	414674	8	NO	2021-11-27 09:26:04
8526	-423	2042	414688	5	NO	2021-11-27 09:26:04
8527	-423	2042	414693	0	NO	2021-11-27 09:26:04
8528	-423	2042	414695	0	SI	2021-11-27 09:26:04
8529	-423	2042	414696	2	NO	2021-11-27 09:26:04
8530	-423	2042	414697	0	SI	2021-11-27 09:26:04
8531	-423	2042	414698	4	NO	2021-11-27 09:26:04
8532	-423	2042	414699	5	NO	2021-11-27 09:26:04
8533	-423	2042	414700	0	NO	2021-11-27 09:26:04
8534	-423	2042	414701	1	SI	2021-11-27 09:26:04
8535	-423	2042	414702	0	SI	2021-11-27 09:26:04
8536	-423	2042	414703	3	SI	2021-11-27 09:26:04
8537	-423	2042	414704	0	NO	2021-11-27 09:26:04
8538	-423	2042	414705	1	SI	2021-11-27 09:26:04
8539	-423	2042	414706	0	SI	2021-11-27 09:26:04
8540	-423	2042	414707	5	NO	2021-11-27 09:26:04
8541	-423	2042	414708	0	SI	2021-11-27 09:26:04
8542	-423	2042	414709	0	SI	2021-11-27 09:26:04
8543	-423	2042	414710	0	SI	2021-11-27 09:26:04
8544	-423	2042	414711	4	NO	2021-11-27 09:26:04
8545	-423	2042	414712	0	SI	2021-11-27 09:26:04
8546	-423	2042	414713	0	SI	2021-11-27 09:26:04
8547	-423	2042	414714	0	SI	2021-11-27 09:26:04
8548	-423	2042	414715	0	NO	2021-11-27 09:26:04
8549	-423	2042	414717	0	NO	2021-11-27 09:26:04
8550	-423	2042	414718	0	SI	2021-11-27 09:26:04
8551	-423	2042	414719	0	SI	2021-11-27 09:26:04
8552	-423	2042	414720	0	SI	2021-11-27 09:26:04
8553	-423	2042	414721	0	SI	2021-11-27 09:26:04
8554	-423	2042	414722	10	NO	2021-11-27 09:26:04
8555	-423	2042	414723	0	SI	2021-11-27 09:26:04
8556	-423	2042	414726	0	NO	2021-11-27 09:26:04
8557	-423	2042	414728	0	NO	2021-11-27 09:26:04
8558	-423	2042	414731	0	NO	2021-11-27 09:26:04
8559	-423	2042	414732	2	NO	2021-11-27 09:26:04
8560	-423	2042	414733	0	NO	2021-11-27 09:26:04
8561	-423	2042	414734	5	NO	2021-11-27 09:26:04
8562	-423	2042	414736	0	NO	2021-11-27 09:26:04
8563	-423	2042	414741	0	NO	2021-11-27 09:26:04
8564	-423	2042	414742	3	NO	2021-11-27 09:26:04
8565	-423	2042	414743	2	NO	2021-11-27 09:26:04
8566	-423	2042	414745	0	NO	2021-11-27 09:26:04
8567	-423	2042	414746	8	NO	2021-11-27 09:26:04
8568	-423	2042	414748	2	NO	2021-11-27 09:26:04
8569	-423	2042	414749	18	NO	2021-11-27 09:26:04
8570	-423	2042	414750	0	NO	2021-11-27 09:26:04
8571	-423	2042	414751	0	SI	2021-11-27 09:26:04
8572	-423	2042	414752	8	NO	2021-11-27 09:26:04
8573	-423	2042	414754	0	NO	2021-11-27 09:26:04
8574	-423	2042	414755	0	NO	2021-11-27 09:26:04
8575	-423	2042	414757	0	NO	2021-11-27 09:26:04
8576	-423	2042	414758	0	SI	2021-11-27 09:26:04
8577	-423	2042	414759	0	SI	2021-11-27 09:26:04
8578	-423	2042	414760	0	SI	2021-11-27 09:26:04
8579	-423	2042	414761	5	NO	2021-11-27 09:26:04
8580	-423	2042	414762	5	NO	2021-11-27 09:26:04
8581	-423	2042	414763	0	SI	2021-11-27 09:26:04
8582	-423	2042	414764	0	NO	2021-11-27 09:26:04
8583	-423	2042	414765	0	NO	2021-11-27 09:26:04
8584	-423	2042	414766	0	NO	2021-11-27 09:26:04
8585	-423	2042	414767	0	SI	2021-11-27 09:26:04
8586	-423	2042	414768	0	SI	2021-11-27 09:26:04
8587	-423	2042	414769	0	SI	2021-11-27 09:26:04
8588	-423	2042	414770	3	NO	2021-11-27 09:26:04
8589	-423	2042	414771	0	SI	2021-11-27 09:26:04
8590	-423	2042	414772	0	SI	2021-11-27 09:26:04
8591	-423	2042	414773	7	SI	2021-11-27 09:26:04
8592	-423	2042	414774	5	SI	2021-11-27 09:26:04
8593	-423	2042	414775	0	SI	2021-11-27 09:26:04
8594	-423	2042	414776	0	SI	2021-11-27 09:26:04
8595	-423	2042	414777	0	NO	2021-11-27 09:26:04
8596	-423	2042	414778	0	NO	2021-11-27 09:26:04
8597	-423	2042	414779	0	NO	2021-11-27 09:26:04
8598	-423	2042	414780	5	NO	2021-11-27 09:26:04
8599	-423	2042	414781	5	NO	2021-11-27 09:26:04
8600	-423	2042	414782	3	NO	2021-11-27 09:26:04
8601	-423	2042	414783	3	NO	2021-11-27 09:26:04
8602	-423	2042	414784	5	NO	2021-11-27 09:26:04
8603	-423	2042	414785	0	NO	2021-11-27 09:26:04
8604	-423	2042	414786	0	NO	2021-11-27 09:26:04
8605	-423	2042	414787	5	SI	2021-11-27 09:26:04
8606	-423	2042	414788	0	NO	2021-11-27 09:26:04
8607	-423	2042	414789	0	NO	2021-11-27 09:26:04
8608	-423	2042	414790	0	SI	2021-11-27 09:26:04
8609	-423	2042	414791	0	SI	2021-11-27 09:26:04
8610	-423	2042	414792	0	SI	2021-11-27 09:26:04
8611	-423	2042	414793	2	SI	2021-11-27 09:26:04
8612	-423	2042	414794	0	SI	2021-11-27 09:26:04
8613	-423	2042	414795	0	SI	2021-11-27 09:26:04
8614	-423	2042	414796	2	SI	2021-11-27 09:26:04
8615	-423	2042	414797	0	NO	2021-11-27 09:26:04
8616	-423	2042	414798	0	NO	2021-11-27 09:26:04
8617	-423	2042	414804	0	NO	2021-11-27 09:26:04
8618	-423	2042	414805	0	NO	2021-11-27 09:26:04
8619	-423	2042	414806	30	NO	2021-11-27 09:26:04
8620	-423	2042	414807	0	NO	2021-11-27 09:26:04
8621	-423	2042	414808	0	NO	2021-11-27 09:26:04
8622	-423	2042	414809	0	NO	2021-11-27 09:26:04
8623	-423	2042	414810	0	NO	2021-11-27 09:26:04
8624	-423	2042	414811	0	SI	2021-11-27 09:26:04
8625	-423	2042	414812	0	SI	2021-11-27 09:26:04
8626	-423	2042	414813	0	NO	2021-11-27 09:26:04
8627	-423	2042	414814	0	NO	2021-11-27 09:26:04
8628	-423	2042	414815	0	NO	2021-11-27 09:26:04
8629	-423	2042	414816	0	NO	2021-11-27 09:26:04
8630	-423	2042	414817	0	NO	2021-11-27 09:26:04
8631	-423	2042	414818	0	NO	2021-11-27 09:26:04
8632	-423	2042	414820	0	SI	2021-11-27 09:26:04
8633	-423	2042	414821	0	SI	2021-11-27 09:26:04
8634	-423	2042	414822	0	NO	2021-11-27 09:26:04
8635	-423	2042	414823	0	SI	2021-11-27 09:26:04
8636	-423	2042	414824	0	SI	2021-11-27 09:26:04
8637	-423	2042	414825	0	NO	2021-11-27 09:26:04
8638	-423	2042	414826	6	NO	2021-11-27 09:26:04
8639	-423	2042	414830	0	NO	2021-11-27 09:26:04
8640	-423	2042	414832	0	SI	2021-11-27 09:26:04
8641	-423	2042	414833	0	SI	2021-11-27 09:26:04
8642	-423	2042	414834	0	SI	2021-11-27 09:26:04
8643	-423	2042	414835	0	SI	2021-11-27 09:26:04
8644	-423	2042	414838	0	SI	2021-11-27 09:26:04
8645	-423	2042	414839	0	SI	2021-11-27 09:26:04
8646	-423	2042	414840	0	SI	2021-11-27 09:26:04
8647	-423	2042	414841	0	SI	2021-11-27 09:26:04
8648	-423	2042	414842	3	NO	2021-11-27 09:26:04
8649	-423	2042	414843	0	NO	2021-11-27 09:26:04
8650	-423	2042	414844	0	SI	2021-11-27 09:26:04
8651	-423	2042	414845	0	NO	2021-11-27 09:26:04
8652	-423	2042	414847	0	SI	2021-11-27 09:26:04
8653	-423	2042	414848	0	SI	2021-11-27 09:26:04
8654	-423	2042	414849	0	SI	2021-11-27 09:26:04
8655	-423	2042	414850	0	SI	2021-11-27 09:26:04
8656	-423	2042	414851	0	SI	2021-11-27 09:26:04
8657	-423	2042	414852	0	SI	2021-11-27 09:26:04
8658	-423	2042	414853	0	SI	2021-11-27 09:26:04
8659	-423	2042	414855	20	NO	2021-11-27 09:26:04
8660	-423	2042	414856	5	SI	2021-11-27 09:26:04
8661	-423	2042	414857	0	SI	2021-11-27 09:26:04
8662	-423	2042	414858	0	SI	2021-11-27 09:26:04
8663	-423	2042	414859	0	SI	2021-11-27 09:26:04
8664	-423	2042	414860	2	NO	2021-11-27 09:26:04
8665	-423	2042	414861	0	SI	2021-11-27 09:26:04
8666	-423	2042	414862	0	SI	2021-11-27 09:26:04
8667	-423	2042	414863	0	SI	2021-11-27 09:26:04
8668	-423	2042	414865	0	SI	2021-11-27 09:26:04
8669	-423	2042	414866	0	SI	2021-11-27 09:26:04
8670	-423	2042	414867	2	NO	2021-11-27 09:26:04
8671	-423	2042	414870	0	SI	2021-11-27 09:26:04
8672	-423	2042	414871	0	SI	2021-11-27 09:26:04
8673	-423	2042	414872	0	NO	2021-11-27 09:26:04
8674	-423	2042	414873	0	NO	2021-11-27 09:26:04
8675	-423	2042	414874	0	SI	2021-11-27 09:26:04
8676	-423	2042	414875	0	NO	2021-11-27 09:26:04
8677	-423	2042	414876	0	NO	2021-11-27 09:26:04
8678	-423	2042	414878	0	NO	2021-11-27 09:26:04
8679	-423	2042	414880	35	SI	2021-11-27 09:26:04
8680	-423	2042	414881	0	NO	2021-11-27 09:26:04
8681	-423	2042	414882	0	NO	2021-11-27 09:26:04
8682	-423	2042	414883	0	SI	2021-11-27 09:26:04
8683	-423	2042	414884	10	SI	2021-11-27 09:26:04
8684	-423	2042	414885	0	NO	2021-11-27 09:26:04
8685	-423	2042	414887	0	NO	2021-11-27 09:26:04
8686	-423	2042	414889	0	NO	2021-11-27 09:26:04
8687	-423	2042	414893	0	NO	2021-11-27 09:26:04
8688	-423	2042	414898	2	NO	2021-11-27 09:26:04
8689	-423	2042	414899	4	NO	2021-11-27 09:26:04
8690	-423	2042	414901	0	NO	2021-11-27 09:26:04
8691	-423	2042	414902	0	NO	2021-11-27 09:26:04
8692	-423	2042	414903	0	NO	2021-11-27 09:26:04
8693	-423	2042	414904	0	NO	2021-11-27 09:26:04
8694	-423	2042	414905	0	NO	2021-11-27 09:26:04
8695	-423	2042	419819	0	SI	2021-11-27 09:26:04
8696	-423	2042	419820	10	NO	2021-11-27 09:26:04
8697	-423	2042	419821	4	SI	2021-11-27 09:26:04
8698	-423	2042	419822	0	SI	2021-11-27 09:26:04
8699	-423	2042	419823	10	NO	2021-11-27 09:26:04
8700	-423	2042	419824	0	SI	2021-11-27 09:26:04
8701	-423	2042	419825	0	NO	2021-11-27 09:26:04
8702	-423	2042	419859	0	NO	2021-11-27 09:26:04
8703	-500	2042	414640	0	SI	2022-01-13 12:15:26
8704	-500	2042	414641	6	SI	2022-01-13 12:15:26
8705	-500	2042	414643	6	NO	2022-01-13 12:15:26
8706	-500	2042	414644	2	SI	2022-01-13 12:15:26
8707	-500	2042	414645	7	NO	2022-01-13 12:15:26
8708	-500	2042	414646	0	SI	2022-01-13 12:15:26
8709	-500	2042	414647	0	NO	2022-01-13 12:15:26
8710	-500	2042	414648	0	NO	2022-01-13 12:15:26
8711	-500	2042	414649	0	NO	2022-01-13 12:15:26
8712	-500	2042	414650	5	SI	2022-01-13 12:15:26
8713	-500	2042	414651	0	SI	2022-01-13 12:15:26
8714	-500	2042	414652	0	SI	2022-01-13 12:15:26
8715	-500	2042	414653	0	SI	2022-01-13 12:15:26
8716	-500	2042	414654	0	SI	2022-01-13 12:15:26
8717	-500	2042	414655	4	NO	2022-01-13 12:15:26
8718	-500	2042	414656	3	NO	2022-01-13 12:15:26
8719	-500	2042	414657	0	SI	2022-01-13 12:15:26
8720	-500	2042	414658	0	NO	2022-01-13 12:15:26
8721	-500	2042	414659	0	NO	2022-01-13 12:15:26
8722	-500	2042	414660	0	NO	2022-01-13 12:15:26
8723	-500	2042	414661	0	SI	2022-01-13 12:15:26
8724	-500	2042	414662	0	SI	2022-01-13 12:15:26
8725	-500	2042	414663	0	SI	2022-01-13 12:15:26
8726	-500	2042	414664	0	SI	2022-01-13 12:15:26
8727	-500	2042	414665	0	SI	2022-01-13 12:15:26
8728	-500	2042	414666	0	SI	2022-01-13 12:15:26
8729	-500	2042	414667	0	SI	2022-01-13 12:15:26
8730	-500	2042	414668	0	SI	2022-01-13 12:15:26
8731	-500	2042	414669	0	SI	2022-01-13 12:15:26
8732	-500	2042	414670	0	SI	2022-01-13 12:15:26
8733	-500	2042	414671	0	SI	2022-01-13 12:15:26
8734	-500	2042	414672	5	SI	2022-01-13 12:15:26
8735	-500	2042	414673	0	SI	2022-01-13 12:15:26
8736	-500	2042	414674	0	SI	2022-01-13 12:15:26
8737	-500	2042	414675	0	SI	2022-01-13 12:15:26
8738	-500	2042	414676	0	SI	2022-01-13 12:15:26
8739	-500	2042	414677	0	SI	2022-01-13 12:15:26
8740	-500	2042	414678	0	SI	2022-01-13 12:15:26
8741	-500	2042	414679	0	SI	2022-01-13 12:15:26
8742	-500	2042	414680	0	NO	2022-01-13 12:15:26
8743	-500	2042	414681	0	NO	2022-01-13 12:15:26
8744	-500	2042	414682	0	NO	2022-01-13 12:15:26
8745	-500	2042	414683	0	SI	2022-01-13 12:15:26
8746	-500	2042	414684	0	SI	2022-01-13 12:15:26
8747	-500	2042	414685	0	SI	2022-01-13 12:15:26
8748	-500	2042	414686	0	SI	2022-01-13 12:15:26
8749	-500	2042	414687	0	SI	2022-01-13 12:15:26
8750	-500	2042	414688	0	SI	2022-01-13 12:15:26
8751	-500	2042	414689	0	SI	2022-01-13 12:15:26
8752	-500	2042	414690	0	SI	2022-01-13 12:15:26
8753	-500	2042	414691	0	SI	2022-01-13 12:15:26
8754	-500	2042	414692	0	SI	2022-01-13 12:15:26
8755	-500	2042	414693	0	NO	2022-01-13 12:15:26
8756	-500	2042	414695	0	SI	2022-01-13 12:15:26
8757	-500	2042	414696	2	NO	2022-01-13 12:15:26
8758	-500	2042	414697	2	NO	2022-01-13 12:15:26
8759	-500	2042	414701	1	SI	2022-01-13 12:15:26
8760	-500	2042	414702	0	SI	2022-01-13 12:15:26
8761	-500	2042	414703	3	SI	2022-01-13 12:15:26
8762	-500	2042	414704	2	SI	2022-01-13 12:15:26
8763	-500	2042	414705	1	SI	2022-01-13 12:15:26
8764	-500	2042	414706	0	SI	2022-01-13 12:15:26
8765	-500	2042	414707	0	SI	2022-01-13 12:15:26
8766	-500	2042	414708	0	SI	2022-01-13 12:15:26
8767	-500	2042	414709	0	SI	2022-01-13 12:15:26
8768	-500	2042	414710	0	SI	2022-01-13 12:15:26
8769	-500	2042	414711	0	SI	2022-01-13 12:15:26
8770	-500	2042	414712	0	SI	2022-01-13 12:15:26
8771	-500	2042	414713	0	SI	2022-01-13 12:15:26
8772	-500	2042	414714	0	SI	2022-01-13 12:15:26
8773	-500	2042	414715	3	SI	2022-01-13 12:15:26
8774	-500	2042	414716	0	SI	2022-01-13 12:15:26
8775	-500	2042	414717	5	SI	2022-01-13 12:15:26
8776	-500	2042	414718	0	SI	2022-01-13 12:15:26
8777	-500	2042	414719	0	SI	2022-01-13 12:15:26
8778	-500	2042	414720	0	SI	2022-01-13 12:15:26
8779	-500	2042	414721	0	SI	2022-01-13 12:15:26
8780	-500	2042	414722	0	SI	2022-01-13 12:15:26
8781	-500	2042	414723	0	SI	2022-01-13 12:15:26
8782	-500	2042	414726	0	NO	2022-01-13 12:15:26
8783	-500	2042	414728	5	SI	2022-01-13 12:15:26
8784	-500	2042	414730	0	SI	2022-01-13 12:15:26
8785	-500	2042	414731	0	NO	2022-01-13 12:15:26
8786	-500	2042	414732	2	NO	2022-01-13 12:15:26
8787	-500	2042	414733	0	NO	2022-01-13 12:15:26
8788	-500	2042	414734	5	NO	2022-01-13 12:15:26
8789	-500	2042	414736	13	SI	2022-01-13 12:15:26
8790	-500	2042	414737	0	SI	2022-01-13 12:15:26
8791	-500	2042	414738	0	SI	2022-01-13 12:15:26
8792	-500	2042	414739	0	SI	2022-01-13 12:15:26
8793	-500	2042	414740	0	NO	2022-01-13 12:15:26
8794	-500	2042	414741	0	NO	2022-01-13 12:15:26
8795	-500	2042	414742	0	SI	2022-01-13 12:15:26
8796	-500	2042	414743	0	SI	2022-01-13 12:15:26
8797	-500	2042	414744	0	SI	2022-01-13 12:15:26
8798	-500	2042	414745	0	NO	2022-01-13 12:15:26
8799	-500	2042	414746	0	SI	2022-01-13 12:15:26
8800	-500	2042	414747	0	NO	2022-01-13 12:15:26
8801	-500	2042	414748	0	SI	2022-01-13 12:15:26
8802	-500	2042	414749	0	SI	2022-01-13 12:15:26
8803	-500	2042	414750	0	NO	2022-01-13 12:15:26
8804	-500	2042	414751	0	SI	2022-01-13 12:15:26
8805	-500	2042	414752	0	SI	2022-01-13 12:15:26
8806	-500	2042	414753	0	NO	2022-01-13 12:15:26
8807	-500	2042	414754	0	NO	2022-01-13 12:15:26
8808	-500	2042	414755	0	NO	2022-01-13 12:15:26
8809	-500	2042	414757	0	NO	2022-01-13 12:15:26
8810	-500	2042	414758	0	SI	2022-01-13 12:15:26
8811	-500	2042	414759	0	SI	2022-01-13 12:15:26
8812	-500	2042	414760	0	SI	2022-01-13 12:15:26
8813	-500	2042	414761	0	SI	2022-01-13 12:15:26
8814	-500	2042	414762	0	SI	2022-01-13 12:15:26
8815	-500	2042	414763	0	SI	2022-01-13 12:15:26
8816	-500	2042	414764	0	NO	2022-01-13 12:15:26
8817	-500	2042	414765	0	NO	2022-01-13 12:15:26
8818	-500	2042	414766	0	NO	2022-01-13 12:15:26
8819	-500	2042	414767	0	SI	2022-01-13 12:15:26
8820	-500	2042	414768	0	SI	2022-01-13 12:15:26
8821	-500	2042	414769	0	SI	2022-01-13 12:15:26
8822	-500	2042	414770	0	SI	2022-01-13 12:15:26
8823	-500	2042	414771	0	SI	2022-01-13 12:15:26
8824	-500	2042	414772	0	SI	2022-01-13 12:15:26
8825	-500	2042	414773	0	NO	2022-01-13 12:15:26
8826	-500	2042	414774	0	NO	2022-01-13 12:15:26
8827	-500	2042	414775	15	NO	2022-01-13 12:15:26
8828	-500	2042	414785	0	NO	2022-01-13 12:15:26
8829	-500	2042	414786	0	NO	2022-01-13 12:15:26
8830	-500	2042	414787	0	NO	2022-01-13 12:15:26
8831	-500	2042	414789	0	NO	2022-01-13 12:15:26
8832	-500	2042	414790	0	SI	2022-01-13 12:15:26
8833	-500	2042	414791	0	SI	2022-01-13 12:15:26
8834	-500	2042	414792	0	SI	2022-01-13 12:15:26
8835	-500	2042	414793	0	NO	2022-01-13 12:15:26
8836	-500	2042	414794	0	SI	2022-01-13 12:15:26
8837	-500	2042	414795	0	SI	2022-01-13 12:15:26
8838	-500	2042	414796	0	NO	2022-01-13 12:15:26
8839	-500	2042	414797	0	NO	2022-01-13 12:15:27
8840	-500	2042	414798	6	SI	2022-01-13 12:15:27
8841	-500	2042	414799	0	SI	2022-01-13 12:15:27
8842	-500	2042	414800	0	NO	2022-01-13 12:15:27
8843	-500	2042	414801	0	NO	2022-01-13 12:15:27
8844	-500	2042	414802	0	NO	2022-01-13 12:15:27
8845	-500	2042	414804	0	NO	2022-01-13 12:15:27
8846	-500	2042	414805	0	NO	2022-01-13 12:15:27
8847	-500	2042	414806	0	SI	2022-01-13 12:15:27
8848	-500	2042	414807	0	NO	2022-01-13 12:15:27
8849	-500	2042	414808	0	NO	2022-01-13 12:15:27
8850	-500	2042	414809	0	NO	2022-01-13 12:15:27
8851	-500	2042	414810	0	NO	2022-01-13 12:15:27
8852	-500	2042	414811	7	NO	2022-01-13 12:15:27
8853	-500	2042	414812	3	NO	2022-01-13 12:15:27
8854	-500	2042	414813	0	NO	2022-01-13 12:15:27
8855	-500	2042	414814	0	NO	2022-01-13 12:15:27
8856	-500	2042	414815	0	NO	2022-01-13 12:15:27
8857	-500	2042	414816	0	NO	2022-01-13 12:15:27
8858	-500	2042	414817	0	NO	2022-01-13 12:15:27
8859	-500	2042	414818	0	NO	2022-01-13 12:15:27
8860	-500	2042	414820	0	SI	2022-01-13 12:15:27
8861	-500	2042	414821	0	SI	2022-01-13 12:15:27
8862	-500	2042	414822	0	NO	2022-01-13 12:15:27
8863	-500	2042	414823	0	SI	2022-01-13 12:15:27
8864	-500	2042	414824	0	SI	2022-01-13 12:15:27
8865	-500	2042	414825	0	NO	2022-01-13 12:15:27
8866	-500	2042	414826	0	SI	2022-01-13 12:15:27
8867	-500	2042	414827	0	SI	2022-01-13 12:15:27
8868	-500	2042	414828	0	SI	2022-01-13 12:15:27
8869	-500	2042	414829	0	NO	2022-01-13 12:15:27
8870	-500	2042	414830	0	NO	2022-01-13 12:15:27
8871	-500	2042	414832	0	SI	2022-01-13 12:15:27
8872	-500	2042	414833	0	SI	2022-01-13 12:15:27
8873	-500	2042	414834	0	SI	2022-01-13 12:15:27
8874	-500	2042	414835	0	SI	2022-01-13 12:15:27
8875	-500	2042	414838	0	SI	2022-01-13 12:15:27
8876	-500	2042	414839	0	SI	2022-01-13 12:15:27
8877	-500	2042	414840	0	SI	2022-01-13 12:15:27
8878	-500	2042	414841	0	SI	2022-01-13 12:15:27
8879	-500	2042	414842	3	NO	2022-01-13 12:15:27
8880	-500	2042	414843	0	NO	2022-01-13 12:15:27
8881	-500	2042	414844	0	SI	2022-01-13 12:15:27
8882	-500	2042	414845	1	SI	2022-01-13 12:15:27
8883	-500	2042	414846	0	SI	2022-01-13 12:15:27
8884	-500	2042	414847	0	SI	2022-01-13 12:15:27
8885	-500	2042	414848	0	SI	2022-01-13 12:15:27
8886	-500	2042	414849	0	SI	2022-01-13 12:15:27
8887	-500	2042	414850	0	SI	2022-01-13 12:15:27
8888	-500	2042	414851	0	SI	2022-01-13 12:15:27
8889	-500	2042	414852	0	SI	2022-01-13 12:15:27
8890	-500	2042	414853	0	SI	2022-01-13 12:15:27
8891	-500	2042	414855	20	NO	2022-01-13 12:15:27
8892	-500	2042	414856	0	NO	2022-01-13 12:15:27
8893	-500	2042	414857	0	SI	2022-01-13 12:15:27
8894	-500	2042	414858	0	SI	2022-01-13 12:15:27
8895	-500	2042	414859	0	SI	2022-01-13 12:15:27
8896	-500	2042	414860	0	SI	2022-01-13 12:15:27
8897	-500	2042	414861	0	SI	2022-01-13 12:15:27
8898	-500	2042	414862	0	SI	2022-01-13 12:15:27
8899	-500	2042	414863	0	SI	2022-01-13 12:15:27
8900	-500	2042	414865	0	SI	2022-01-13 12:15:27
8901	-500	2042	414866	0	SI	2022-01-13 12:15:27
8902	-500	2042	414867	0	SI	2022-01-13 12:15:27
8903	-500	2042	414868	0	SI	2022-01-13 12:15:27
8904	-500	2042	414869	0	SI	2022-01-13 12:15:27
8905	-500	2042	414870	0	SI	2022-01-13 12:15:27
8906	-500	2042	414871	0	SI	2022-01-13 12:15:27
8907	-500	2042	414872	0	NO	2022-01-13 12:15:27
8908	-500	2042	414873	0	NO	2022-01-13 12:15:27
8909	-500	2042	414874	0	SI	2022-01-13 12:15:27
8910	-500	2042	414875	0	NO	2022-01-13 12:15:27
8911	-500	2042	414876	0	NO	2022-01-13 12:15:27
8912	-500	2042	414878	0	NO	2022-01-13 12:15:27
8913	-500	2042	414880	0	NO	2022-01-13 12:15:27
8914	-500	2042	414881	0	NO	2022-01-13 12:15:27
8915	-500	2042	414882	0	NO	2022-01-13 12:15:27
8916	-500	2042	414883	0	SI	2022-01-13 12:15:27
8917	-500	2042	414884	0	NO	2022-01-13 12:15:27
8918	-500	2042	414885	0	NO	2022-01-13 12:15:27
8919	-500	2042	414887	0	NO	2022-01-13 12:15:27
8920	-500	2042	414889	0	NO	2022-01-13 12:15:27
8921	-500	2042	414893	0	NO	2022-01-13 12:15:27
8922	-500	2042	414898	2	NO	2022-01-13 12:15:27
8923	-500	2042	414899	4	NO	2022-01-13 12:15:27
8924	-500	2042	414901	0	NO	2022-01-13 12:15:27
8925	-500	2042	414902	0	NO	2022-01-13 12:15:27
8926	-500	2042	414903	0	NO	2022-01-13 12:15:27
8927	-500	2042	414904	0	NO	2022-01-13 12:15:27
8928	-500	2042	414905	0	NO	2022-01-13 12:15:27
8929	-500	2042	419819	0	SI	2022-01-13 12:15:27
8930	-500	2042	419820	0	SI	2022-01-13 12:15:27
8931	-500	2042	419821	4	SI	2022-01-13 12:15:27
8932	-500	2042	419822	2	NO	2022-01-13 12:15:27
8933	-500	2042	419823	10	NO	2022-01-13 12:15:27
8934	-500	2042	419824	0	SI	2022-01-13 12:15:27
8935	-500	2042	419825	0	NO	2022-01-13 12:15:27
8936	-500	2042	419859	12	SI	2022-01-13 12:15:27
8937	\N	2041	414344	0	SI	2022-01-25 16:46:17
8938	\N	2041	414345	0	SI	2022-01-25 16:46:17
8939	\N	2041	414346	0	NO	2022-01-25 16:46:17
8940	\N	2041	414347	0	SI	2022-01-25 16:46:17
8941	\N	2041	414348	0	SI	2022-01-25 16:46:17
8942	\N	2041	414349	0	SI	2022-01-25 16:46:17
8943	\N	2041	414350	0	SI	2022-01-25 16:46:17
8944	\N	2041	414351	0	NO	2022-01-25 16:46:17
8945	\N	2041	414356	0	NO	2022-01-25 16:46:17
8946	\N	2041	414357	0	SI	2022-01-25 16:46:17
8947	\N	2041	414358	0	SI	2022-01-25 16:46:17
8948	\N	2041	414359	0	SI	2022-01-25 16:46:17
8949	\N	2041	414360	0	SI	2022-01-25 16:46:17
8950	\N	2041	414361	0	NO	2022-01-25 16:46:17
8951	\N	2041	414362	0	SI	2022-01-25 16:46:17
8952	\N	2041	414363	0	SI	2022-01-25 16:46:17
8953	\N	2041	414364	0	NO	2022-01-25 16:46:17
8954	\N	2041	414368	3	SI	2022-01-25 16:46:17
8955	\N	2041	414369	0	SI	2022-01-25 16:46:17
8956	\N	2041	414370	3	SI	2022-01-25 16:46:17
8957	\N	2041	414371	0	NO	2022-01-25 16:46:17
8958	\N	2041	414375	0	NO	2022-01-25 16:46:17
8959	\N	2041	414377	0	SI	2022-01-25 16:46:17
8960	\N	2041	414378	0	SI	2022-01-25 16:46:17
8961	\N	2041	414379	2	SI	2022-01-25 16:46:17
8962	\N	2041	414380	0	SI	2022-01-25 16:46:17
8963	\N	2041	414381	0	SI	2022-01-25 16:46:17
8964	\N	2041	414382	0	NO	2022-01-25 16:46:17
8965	\N	2041	414383	0	NO	2022-01-25 16:46:17
8966	\N	2041	414384	0	NO	2022-01-25 16:46:17
8967	\N	2041	414385	5	SI	2022-01-25 16:46:17
8968	\N	2041	414386	0	SI	2022-01-25 16:46:17
8969	\N	2041	414387	0	SI	2022-01-25 16:46:17
8970	\N	2041	414388	0	SI	2022-01-25 16:46:17
8971	\N	2041	414389	0	SI	2022-01-25 16:46:17
8972	\N	2041	414390	4	NO	2022-01-25 16:46:17
8973	\N	2041	414391	0	SI	2022-01-25 16:46:17
8974	\N	2041	414392	0	SI	2022-01-25 16:46:17
8975	\N	2041	414393	0	NO	2022-01-25 16:46:17
8976	\N	2041	414394	0	NO	2022-01-25 16:46:17
8977	\N	2041	414395	0	NO	2022-01-25 16:46:17
8978	\N	2041	414396	0	SI	2022-01-25 16:46:17
8979	\N	2041	414397	0	SI	2022-01-25 16:46:17
8980	\N	2041	414398	0	SI	2022-01-25 16:46:18
8981	\N	2041	414399	0	SI	2022-01-25 16:46:18
8982	\N	2041	414400	0	SI	2022-01-25 16:46:18
8983	\N	2041	414401	0	SI	2022-01-25 16:46:18
8984	\N	2041	414402	5	NO	2022-01-25 16:46:18
8985	\N	2041	414407	0	SI	2022-01-25 16:46:18
8986	\N	2041	414408	0	NO	2022-01-25 16:46:18
8987	\N	2041	414409	0	NO	2022-01-25 16:46:18
8988	\N	2041	414410	0	NO	2022-01-25 16:46:18
8989	\N	2041	414412	0	NO	2022-01-25 16:46:18
8990	\N	2041	414413	0	NO	2022-01-25 16:46:18
8991	\N	2041	414416	2	NO	2022-01-25 16:46:18
8992	\N	2041	414418	0	NO	2022-01-25 16:46:18
8993	\N	2041	414421	0	NO	2022-01-25 16:46:18
8994	\N	2041	414422	8	NO	2022-01-25 16:46:18
8995	\N	2041	414424	0	NO	2022-01-25 16:46:18
8996	\N	2041	414425	0	NO	2022-01-25 16:46:18
8997	\N	2041	414426	0	SI	2022-01-25 16:46:18
8998	\N	2041	414427	0	SI	2022-01-25 16:46:18
8999	\N	2041	414428	0	SI	2022-01-25 16:46:18
9000	\N	2041	414429	3	SI	2022-01-25 16:46:18
9001	\N	2041	414430	0	SI	2022-01-25 16:46:18
9002	\N	2041	414431	0	NO	2022-01-25 16:46:18
9003	\N	2041	414432	0	SI	2022-01-25 16:46:18
9004	\N	2041	414433	0	SI	2022-01-25 16:46:18
9005	\N	2041	414434	0	NO	2022-01-25 16:46:18
9006	\N	2041	414435	0	NO	2022-01-25 16:46:18
9007	\N	2041	414436	0	NO	2022-01-25 16:46:18
9008	\N	2041	414438	0	NO	2022-01-25 16:46:18
9009	\N	2041	414442	0	SI	2022-01-25 16:46:18
9010	\N	2041	414443	0	SI	2022-01-25 16:46:18
9011	\N	2041	414444	0	NO	2022-01-25 16:46:18
9012	\N	2041	414445	0	NO	2022-01-25 16:46:18
9013	\N	2041	414446	1	SI	2022-01-25 16:46:18
9014	\N	2041	414447	0	SI	2022-01-25 16:46:18
9015	\N	2041	414448	5	SI	2022-01-25 16:46:18
9017	\N	2041	414450	0	SI	2022-01-25 16:46:18
9019	\N	2041	414452	0	SI	2022-01-25 16:46:18
9021	\N	2041	414454	0	SI	2022-01-25 16:46:18
9023	\N	2041	414456	0	NO	2022-01-25 16:46:18
9025	\N	2041	414458	0	SI	2022-01-25 16:46:18
9027	\N	2041	414460	0	SI	2022-01-25 16:46:18
9029	\N	2041	414462	0	SI	2022-01-25 16:46:18
9031	\N	2041	414464	0	NO	2022-01-25 16:46:18
9033	\N	2041	414466	15	NO	2022-01-25 16:46:18
9035	\N	2041	414478	0	NO	2022-01-25 16:46:18
9037	\N	2041	414480	0	SI	2022-01-25 16:46:18
9039	\N	2041	414482	0	SI	2022-01-25 16:46:18
9041	\N	2041	414484	2	SI	2022-01-25 16:46:18
9043	\N	2041	414486	0	NO	2022-01-25 16:46:18
9045	\N	2041	414488	2	SI	2022-01-25 16:46:18
9047	\N	2041	414490	0	SI	2022-01-25 16:46:18
9049	\N	2041	414492	0	SI	2022-01-25 16:46:18
9051	\N	2041	414494	0	SI	2022-01-25 16:46:18
9053	\N	2041	414496	0	SI	2022-01-25 16:46:18
9055	\N	2041	414498	0	NO	2022-01-25 16:46:18
9057	\N	2041	414501	0	SI	2022-01-25 16:46:18
9059	\N	2041	414503	0	SI	2022-01-25 16:46:18
9061	\N	2041	414505	0	SI	2022-01-25 16:46:18
9063	\N	2041	414507	0	SI	2022-01-25 16:46:18
9065	\N	2041	414510	0	SI	2022-01-25 16:46:18
9067	\N	2041	414512	0	NO	2022-01-25 16:46:18
9069	\N	2041	414514	0	NO	2022-01-25 16:46:18
9071	\N	2041	414517	0	NO	2022-01-25 16:46:18
9073	\N	2041	414519	0	SI	2022-01-25 16:46:18
9075	\N	2041	414521	0	NO	2022-01-25 16:46:18
9077	\N	2041	414523	0	SI	2022-01-25 16:46:18
9079	\N	2041	414525	0	NO	2022-01-25 16:46:18
9081	\N	2041	414528	0	NO	2022-01-25 16:46:18
9083	\N	2041	414531	0	NO	2022-01-25 16:46:18
9085	\N	2041	414533	0	NO	2022-01-25 16:46:18
9087	\N	2041	414535	0	NO	2022-01-25 16:46:18
9089	\N	2041	414537	0	SI	2022-01-25 16:46:18
9091	\N	2041	414539	0	NO	2022-01-25 16:46:18
9093	\N	2041	414541	0	NO	2022-01-25 16:46:18
9095	\N	2041	414543	0	NO	2022-01-25 16:46:18
9097	\N	2041	414545	0	NO	2022-01-25 16:46:18
9099	\N	2041	414548	0	SI	2022-01-25 16:46:18
9101	\N	2041	414550	0	SI	2022-01-25 16:46:18
9103	\N	2041	414552	2	SI	2022-01-25 16:46:18
9105	\N	2041	414554	0	SI	2022-01-25 16:46:18
9107	\N	2041	414557	0	SI	2022-01-25 16:46:18
9109	\N	2041	414559	0	SI	2022-01-25 16:46:18
9111	\N	2041	414561	0	NO	2022-01-25 16:46:18
9113	\N	2041	414563	0	SI	2022-01-25 16:46:18
9115	\N	2041	414565	0	SI	2022-01-25 16:46:18
9117	\N	2041	414567	0	NO	2022-01-25 16:46:18
9119	\N	2041	414569	1	SI	2022-01-25 16:46:18
9121	\N	2041	414571	1	NO	2022-01-25 16:46:18
9123	\N	2041	414574	0	SI	2022-01-25 16:46:18
9125	\N	2041	414576	0	SI	2022-01-25 16:46:18
9127	\N	2041	414579	0	SI	2022-01-25 16:46:18
9129	\N	2041	414581	0	SI	2022-01-25 16:46:18
9131	\N	2041	414583	0	SI	2022-01-25 16:46:18
9133	\N	2041	414585	0	SI	2022-01-25 16:46:18
9135	\N	2041	414588	0	SI	2022-01-25 16:46:18
9137	\N	2041	414590	0	SI	2022-01-25 16:46:18
9139	\N	2041	414592	0	SI	2022-01-25 16:46:18
9141	\N	2041	414594	0	SI	2022-01-25 16:46:18
9143	\N	2041	414596	0	NO	2022-01-25 16:46:18
9145	\N	2041	414598	0	NO	2022-01-25 16:46:18
9147	\N	2041	414601	10	SI	2022-01-25 16:46:18
9149	\N	2041	414603	0	NO	2022-01-25 16:46:18
9151	\N	2041	414605	0	NO	2022-01-25 16:46:18
9153	\N	2041	414609	0	NO	2022-01-25 16:46:18
9155	\N	2041	414611	0	NO	2022-01-25 16:46:18
9157	\N	2041	414613	0	NO	2022-01-25 16:46:18
9159	\N	2041	414615	0	NO	2022-01-25 16:46:18
9161	\N	2041	414617	0	NO	2022-01-25 16:46:18
9163	\N	2041	414619	65	SI	2022-01-25 16:46:18
9165	\N	2041	414622	0	NO	2022-01-25 16:46:18
9167	\N	2041	414624	0	NO	2022-01-25 16:46:18
9169	\N	2041	414631	4	NO	2022-01-25 16:46:18
9171	\N	2041	414634	0	NO	2022-01-25 16:46:18
9173	\N	2041	414636	0	NO	2022-01-25 16:46:18
9175	\N	2041	419809	0	SI	2022-01-25 16:46:18
9016	\N	2041	414449	0	SI	2022-01-25 16:46:18
9018	\N	2041	414451	0	SI	2022-01-25 16:46:18
9020	\N	2041	414453	5	NO	2022-01-25 16:46:18
9022	\N	2041	414455	0	NO	2022-01-25 16:46:18
9024	\N	2041	414457	0	NO	2022-01-25 16:46:18
9026	\N	2041	414459	0	SI	2022-01-25 16:46:18
9028	\N	2041	414461	0	SI	2022-01-25 16:46:18
9030	\N	2041	414463	0	SI	2022-01-25 16:46:18
9032	\N	2041	414465	0	NO	2022-01-25 16:46:18
9034	\N	2041	414476	0	NO	2022-01-25 16:46:18
9036	\N	2041	414479	0	SI	2022-01-25 16:46:18
9038	\N	2041	414481	0	SI	2022-01-25 16:46:18
9040	\N	2041	414483	0	NO	2022-01-25 16:46:18
9042	\N	2041	414485	0	SI	2022-01-25 16:46:18
9044	\N	2041	414487	0	NO	2022-01-25 16:46:18
9046	\N	2041	414489	0	SI	2022-01-25 16:46:18
9048	\N	2041	414491	0	SI	2022-01-25 16:46:18
9050	\N	2041	414493	0	SI	2022-01-25 16:46:18
9052	\N	2041	414495	0	SI	2022-01-25 16:46:18
9054	\N	2041	414497	0	SI	2022-01-25 16:46:18
9056	\N	2041	414500	0	SI	2022-01-25 16:46:18
9058	\N	2041	414502	0	SI	2022-01-25 16:46:18
9060	\N	2041	414504	0	SI	2022-01-25 16:46:18
9062	\N	2041	414506	0	NO	2022-01-25 16:46:18
9064	\N	2041	414508	0	NO	2022-01-25 16:46:18
9066	\N	2041	414511	0	SI	2022-01-25 16:46:18
9068	\N	2041	414513	0	NO	2022-01-25 16:46:18
9070	\N	2041	414516	0	NO	2022-01-25 16:46:18
9072	\N	2041	414518	0	SI	2022-01-25 16:46:18
9074	\N	2041	414520	0	SI	2022-01-25 16:46:18
9076	\N	2041	414522	0	SI	2022-01-25 16:46:18
9078	\N	2041	414524	0	NO	2022-01-25 16:46:18
9080	\N	2041	414527	0	NO	2022-01-25 16:46:18
9082	\N	2041	414529	0	NO	2022-01-25 16:46:18
9084	\N	2041	414532	0	SI	2022-01-25 16:46:18
9086	\N	2041	414534	0	NO	2022-01-25 16:46:18
9088	\N	2041	414536	0	NO	2022-01-25 16:46:18
9090	\N	2041	414538	0	SI	2022-01-25 16:46:18
9092	\N	2041	414540	0	NO	2022-01-25 16:46:18
9094	\N	2041	414542	0	NO	2022-01-25 16:46:18
9096	\N	2041	414544	0	NO	2022-01-25 16:46:18
9098	\N	2041	414547	0	SI	2022-01-25 16:46:18
9100	\N	2041	414549	0	NO	2022-01-25 16:46:18
9102	\N	2041	414551	0	SI	2022-01-25 16:46:18
9104	\N	2041	414553	0	SI	2022-01-25 16:46:18
9106	\N	2041	414556	0	SI	2022-01-25 16:46:18
9108	\N	2041	414558	0	SI	2022-01-25 16:46:18
9110	\N	2041	414560	0	SI	2022-01-25 16:46:18
9112	\N	2041	414562	0	SI	2022-01-25 16:46:18
9114	\N	2041	414564	0	SI	2022-01-25 16:46:18
9116	\N	2041	414566	0	SI	2022-01-25 16:46:18
9118	\N	2041	414568	0	SI	2022-01-25 16:46:18
9120	\N	2041	414570	0	SI	2022-01-25 16:46:18
9122	\N	2041	414573	0	SI	2022-01-25 16:46:18
9124	\N	2041	414575	0	SI	2022-01-25 16:46:18
9126	\N	2041	414577	0	SI	2022-01-25 16:46:18
9128	\N	2041	414580	0	SI	2022-01-25 16:46:18
9130	\N	2041	414582	0	SI	2022-01-25 16:46:18
9132	\N	2041	414584	0	SI	2022-01-25 16:46:18
9134	\N	2041	414586	0	SI	2022-01-25 16:46:18
9136	\N	2041	414589	0	SI	2022-01-25 16:46:18
9138	\N	2041	414591	0	SI	2022-01-25 16:46:18
9140	\N	2041	414593	0	SI	2022-01-25 16:46:18
9142	\N	2041	414595	0	NO	2022-01-25 16:46:18
9144	\N	2041	414597	0	SI	2022-01-25 16:46:18
9146	\N	2041	414599	0	NO	2022-01-25 16:46:18
9148	\N	2041	414602	10	SI	2022-01-25 16:46:18
9150	\N	2041	414604	3	SI	2022-01-25 16:46:18
9152	\N	2041	414606	0	NO	2022-01-25 16:46:18
9154	\N	2041	414610	0	NO	2022-01-25 16:46:18
9156	\N	2041	414612	0	NO	2022-01-25 16:46:18
9158	\N	2041	414614	11	SI	2022-01-25 16:46:18
9160	\N	2041	414616	0	NO	2022-01-25 16:46:18
9162	\N	2041	414618	0	SI	2022-01-25 16:46:18
9164	\N	2041	414621	0	NO	2022-01-25 16:46:18
9166	\N	2041	414623	0	NO	2022-01-25 16:46:18
9168	\N	2041	414630	2	NO	2022-01-25 16:46:18
9170	\N	2041	414633	0	NO	2022-01-25 16:46:18
9172	\N	2041	414635	0	NO	2022-01-25 16:46:18
9174	\N	2041	414637	0	NO	2022-01-25 16:46:18
9176	\N	2041	414344	0	SI	2022-01-25 16:53:53
9177	\N	2041	414345	0	SI	2022-01-25 16:53:53
9178	\N	2041	414346	0	NO	2022-01-25 16:53:53
9179	\N	2041	414347	0	SI	2022-01-25 16:53:53
9180	\N	2041	414348	0	SI	2022-01-25 16:53:53
9181	\N	2041	414349	0	SI	2022-01-25 16:53:53
9182	\N	2041	414350	0	SI	2022-01-25 16:53:53
9183	\N	2041	414351	0	NO	2022-01-25 16:53:53
9184	\N	2041	414356	0	NO	2022-01-25 16:53:53
9185	\N	2041	414357	0	SI	2022-01-25 16:53:53
9186	\N	2041	414358	0	SI	2022-01-25 16:53:53
9187	\N	2041	414359	0	SI	2022-01-25 16:53:53
9188	\N	2041	414360	0	SI	2022-01-25 16:53:53
9189	\N	2041	414361	0	NO	2022-01-25 16:53:53
9190	\N	2041	414362	0	SI	2022-01-25 16:53:53
9191	\N	2041	414363	0	SI	2022-01-25 16:53:53
9192	\N	2041	414364	0	NO	2022-01-25 16:53:53
9193	\N	2041	414368	3	SI	2022-01-25 16:53:53
9194	\N	2041	414369	0	SI	2022-01-25 16:53:53
9195	\N	2041	414370	3	SI	2022-01-25 16:53:53
9196	\N	2041	414371	0	NO	2022-01-25 16:53:53
9197	\N	2041	414375	0	NO	2022-01-25 16:53:53
9198	\N	2041	414377	0	SI	2022-01-25 16:53:53
9199	\N	2041	414378	0	SI	2022-01-25 16:53:53
9200	\N	2041	414379	2	SI	2022-01-25 16:53:53
9201	\N	2041	414380	0	SI	2022-01-25 16:53:53
9202	\N	2041	414381	0	SI	2022-01-25 16:53:53
9203	\N	2041	414382	0	NO	2022-01-25 16:53:53
9204	\N	2041	414383	0	NO	2022-01-25 16:53:53
9205	\N	2041	414384	0	NO	2022-01-25 16:53:53
9206	\N	2041	414385	5	SI	2022-01-25 16:53:53
9207	\N	2041	414386	0	SI	2022-01-25 16:53:53
9208	\N	2041	414387	0	SI	2022-01-25 16:53:53
9209	\N	2041	414388	0	SI	2022-01-25 16:53:53
9210	\N	2041	414389	0	SI	2022-01-25 16:53:53
9211	\N	2041	414390	4	NO	2022-01-25 16:53:53
9212	\N	2041	414391	0	SI	2022-01-25 16:53:53
9213	\N	2041	414392	0	SI	2022-01-25 16:53:53
9214	\N	2041	414393	0	NO	2022-01-25 16:53:53
9215	\N	2041	414394	0	NO	2022-01-25 16:53:53
9216	\N	2041	414395	0	NO	2022-01-25 16:53:53
9218	\N	2041	414397	0	SI	2022-01-25 16:53:53
9220	\N	2041	414399	0	SI	2022-01-25 16:53:53
9222	\N	2041	414401	0	SI	2022-01-25 16:53:53
9224	\N	2041	414407	0	SI	2022-01-25 16:53:53
9226	\N	2041	414409	0	NO	2022-01-25 16:53:53
9228	\N	2041	414412	0	NO	2022-01-25 16:53:53
9230	\N	2041	414416	2	NO	2022-01-25 16:53:53
9232	\N	2041	414421	0	NO	2022-01-25 16:53:53
9234	\N	2041	414424	0	NO	2022-01-25 16:53:53
9236	\N	2041	414426	0	SI	2022-01-25 16:53:53
9238	\N	2041	414428	0	SI	2022-01-25 16:53:53
9240	\N	2041	414430	0	SI	2022-01-25 16:53:53
9242	\N	2041	414432	0	SI	2022-01-25 16:53:53
9244	\N	2041	414434	0	NO	2022-01-25 16:53:53
9246	\N	2041	414436	0	NO	2022-01-25 16:53:53
9248	\N	2041	414442	0	SI	2022-01-25 16:53:53
9250	\N	2041	414444	0	NO	2022-01-25 16:53:53
9252	\N	2041	414446	1	SI	2022-01-25 16:53:53
9254	\N	2041	414448	5	SI	2022-01-25 16:53:53
9256	\N	2041	414450	0	SI	2022-01-25 16:53:53
9258	\N	2041	414452	0	SI	2022-01-25 16:53:53
9260	\N	2041	414454	0	SI	2022-01-25 16:53:53
9262	\N	2041	414456	0	NO	2022-01-25 16:53:53
9264	\N	2041	414458	0	SI	2022-01-25 16:53:53
9266	\N	2041	414460	0	SI	2022-01-25 16:53:53
9268	\N	2041	414462	0	SI	2022-01-25 16:53:53
9270	\N	2041	414464	0	NO	2022-01-25 16:53:53
9272	\N	2041	414466	15	NO	2022-01-25 16:53:53
9274	\N	2041	414478	0	NO	2022-01-25 16:53:53
9276	\N	2041	414480	0	SI	2022-01-25 16:53:53
9278	\N	2041	414482	0	SI	2022-01-25 16:53:53
9280	\N	2041	414484	2	SI	2022-01-25 16:53:53
9282	\N	2041	414486	0	NO	2022-01-25 16:53:53
9284	\N	2041	414488	2	SI	2022-01-25 16:53:53
9286	\N	2041	414490	0	SI	2022-01-25 16:53:53
9288	\N	2041	414492	0	SI	2022-01-25 16:53:53
9290	\N	2041	414494	0	SI	2022-01-25 16:53:53
9292	\N	2041	414496	0	SI	2022-01-25 16:53:53
9294	\N	2041	414498	0	NO	2022-01-25 16:53:53
9296	\N	2041	414501	0	SI	2022-01-25 16:53:53
9298	\N	2041	414503	0	SI	2022-01-25 16:53:53
9300	\N	2041	414505	0	SI	2022-01-25 16:53:53
9302	\N	2041	414507	0	SI	2022-01-25 16:53:53
9304	\N	2041	414510	0	SI	2022-01-25 16:53:53
9306	\N	2041	414512	0	NO	2022-01-25 16:53:53
9308	\N	2041	414514	0	NO	2022-01-25 16:53:53
9310	\N	2041	414517	0	NO	2022-01-25 16:53:53
9312	\N	2041	414519	0	SI	2022-01-25 16:53:53
9314	\N	2041	414521	0	NO	2022-01-25 16:53:53
9316	\N	2041	414523	0	SI	2022-01-25 16:53:53
9318	\N	2041	414525	0	NO	2022-01-25 16:53:53
9320	\N	2041	414528	0	NO	2022-01-25 16:53:53
9322	\N	2041	414531	0	NO	2022-01-25 16:53:53
9324	\N	2041	414533	0	NO	2022-01-25 16:53:53
9326	\N	2041	414535	0	NO	2022-01-25 16:53:53
9328	\N	2041	414537	0	SI	2022-01-25 16:53:53
9330	\N	2041	414539	0	NO	2022-01-25 16:53:53
9332	\N	2041	414541	0	NO	2022-01-25 16:53:53
9334	\N	2041	414543	0	NO	2022-01-25 16:53:53
9336	\N	2041	414545	0	NO	2022-01-25 16:53:53
9338	\N	2041	414548	0	SI	2022-01-25 16:53:53
9340	\N	2041	414550	0	SI	2022-01-25 16:53:53
9342	\N	2041	414552	2	SI	2022-01-25 16:53:53
9344	\N	2041	414554	0	SI	2022-01-25 16:53:53
9346	\N	2041	414557	0	SI	2022-01-25 16:53:53
9348	\N	2041	414559	0	SI	2022-01-25 16:53:53
9350	\N	2041	414561	0	NO	2022-01-25 16:53:53
9352	\N	2041	414563	0	SI	2022-01-25 16:53:53
9354	\N	2041	414565	0	SI	2022-01-25 16:53:53
9356	\N	2041	414567	0	NO	2022-01-25 16:53:53
9358	\N	2041	414569	1	SI	2022-01-25 16:53:53
9360	\N	2041	414571	1	NO	2022-01-25 16:53:53
9362	\N	2041	414574	0	SI	2022-01-25 16:53:53
9364	\N	2041	414576	0	SI	2022-01-25 16:53:53
9366	\N	2041	414579	0	SI	2022-01-25 16:53:53
9368	\N	2041	414581	0	SI	2022-01-25 16:53:53
9370	\N	2041	414583	0	SI	2022-01-25 16:53:53
9372	\N	2041	414585	0	SI	2022-01-25 16:53:53
9374	\N	2041	414588	0	SI	2022-01-25 16:53:53
9376	\N	2041	414590	0	SI	2022-01-25 16:53:53
9378	\N	2041	414592	0	SI	2022-01-25 16:53:53
9380	\N	2041	414594	0	SI	2022-01-25 16:53:53
9382	\N	2041	414596	0	NO	2022-01-25 16:53:53
9384	\N	2041	414598	0	NO	2022-01-25 16:53:53
9386	\N	2041	414601	10	SI	2022-01-25 16:53:53
9388	\N	2041	414603	0	NO	2022-01-25 16:53:53
9390	\N	2041	414605	0	NO	2022-01-25 16:53:53
9392	\N	2041	414609	0	NO	2022-01-25 16:53:53
9394	\N	2041	414611	0	NO	2022-01-25 16:53:53
9396	\N	2041	414613	0	NO	2022-01-25 16:53:53
9398	\N	2041	414615	0	NO	2022-01-25 16:53:53
9400	\N	2041	414617	0	NO	2022-01-25 16:53:53
9402	\N	2041	414619	65	SI	2022-01-25 16:53:53
9404	\N	2041	414622	0	NO	2022-01-25 16:53:53
9406	\N	2041	414624	0	NO	2022-01-25 16:53:53
9408	\N	2041	414631	4	NO	2022-01-25 16:53:53
9410	\N	2041	414634	0	NO	2022-01-25 16:53:53
9412	\N	2041	414636	0	NO	2022-01-25 16:53:53
9414	\N	2041	419809	0	SI	2022-01-25 16:53:53
9217	\N	2041	414396	0	SI	2022-01-25 16:53:53
9219	\N	2041	414398	0	SI	2022-01-25 16:53:53
9221	\N	2041	414400	0	SI	2022-01-25 16:53:53
9223	\N	2041	414402	5	NO	2022-01-25 16:53:53
9225	\N	2041	414408	0	NO	2022-01-25 16:53:53
9227	\N	2041	414410	0	NO	2022-01-25 16:53:53
9229	\N	2041	414413	0	NO	2022-01-25 16:53:53
9231	\N	2041	414418	0	NO	2022-01-25 16:53:53
9233	\N	2041	414422	8	NO	2022-01-25 16:53:53
9235	\N	2041	414425	0	NO	2022-01-25 16:53:53
9237	\N	2041	414427	0	SI	2022-01-25 16:53:53
9239	\N	2041	414429	3	SI	2022-01-25 16:53:53
9241	\N	2041	414431	0	NO	2022-01-25 16:53:53
9243	\N	2041	414433	0	SI	2022-01-25 16:53:53
9245	\N	2041	414435	0	NO	2022-01-25 16:53:53
9247	\N	2041	414438	0	NO	2022-01-25 16:53:53
9249	\N	2041	414443	0	SI	2022-01-25 16:53:53
9251	\N	2041	414445	0	NO	2022-01-25 16:53:53
9253	\N	2041	414447	0	SI	2022-01-25 16:53:53
9255	\N	2041	414449	0	SI	2022-01-25 16:53:53
9257	\N	2041	414451	0	SI	2022-01-25 16:53:53
9259	\N	2041	414453	5	NO	2022-01-25 16:53:53
9261	\N	2041	414455	0	NO	2022-01-25 16:53:53
9263	\N	2041	414457	0	NO	2022-01-25 16:53:53
9265	\N	2041	414459	0	SI	2022-01-25 16:53:53
9267	\N	2041	414461	0	SI	2022-01-25 16:53:53
9269	\N	2041	414463	0	SI	2022-01-25 16:53:53
9271	\N	2041	414465	0	NO	2022-01-25 16:53:53
9273	\N	2041	414476	0	NO	2022-01-25 16:53:53
9275	\N	2041	414479	0	SI	2022-01-25 16:53:53
9277	\N	2041	414481	0	SI	2022-01-25 16:53:53
9279	\N	2041	414483	0	NO	2022-01-25 16:53:53
9281	\N	2041	414485	0	SI	2022-01-25 16:53:53
9283	\N	2041	414487	0	NO	2022-01-25 16:53:53
9285	\N	2041	414489	0	SI	2022-01-25 16:53:53
9287	\N	2041	414491	0	SI	2022-01-25 16:53:53
9289	\N	2041	414493	0	SI	2022-01-25 16:53:53
9291	\N	2041	414495	0	SI	2022-01-25 16:53:53
9293	\N	2041	414497	0	SI	2022-01-25 16:53:53
9295	\N	2041	414500	0	SI	2022-01-25 16:53:53
9297	\N	2041	414502	0	SI	2022-01-25 16:53:53
9299	\N	2041	414504	0	SI	2022-01-25 16:53:53
9301	\N	2041	414506	0	NO	2022-01-25 16:53:53
9303	\N	2041	414508	0	NO	2022-01-25 16:53:53
9305	\N	2041	414511	0	SI	2022-01-25 16:53:53
9307	\N	2041	414513	0	NO	2022-01-25 16:53:53
9309	\N	2041	414516	0	NO	2022-01-25 16:53:53
9311	\N	2041	414518	0	SI	2022-01-25 16:53:53
9313	\N	2041	414520	0	SI	2022-01-25 16:53:53
9315	\N	2041	414522	0	SI	2022-01-25 16:53:53
9317	\N	2041	414524	0	NO	2022-01-25 16:53:53
9319	\N	2041	414527	0	NO	2022-01-25 16:53:53
9321	\N	2041	414529	0	NO	2022-01-25 16:53:53
9323	\N	2041	414532	0	SI	2022-01-25 16:53:53
9325	\N	2041	414534	0	NO	2022-01-25 16:53:53
9327	\N	2041	414536	0	NO	2022-01-25 16:53:53
9329	\N	2041	414538	0	SI	2022-01-25 16:53:53
9331	\N	2041	414540	0	NO	2022-01-25 16:53:53
9333	\N	2041	414542	0	NO	2022-01-25 16:53:53
9335	\N	2041	414544	0	NO	2022-01-25 16:53:53
9337	\N	2041	414547	0	SI	2022-01-25 16:53:53
9339	\N	2041	414549	0	NO	2022-01-25 16:53:53
9341	\N	2041	414551	0	SI	2022-01-25 16:53:53
9343	\N	2041	414553	0	SI	2022-01-25 16:53:53
9345	\N	2041	414556	0	SI	2022-01-25 16:53:53
9347	\N	2041	414558	0	SI	2022-01-25 16:53:53
9349	\N	2041	414560	0	SI	2022-01-25 16:53:53
9351	\N	2041	414562	0	SI	2022-01-25 16:53:53
9353	\N	2041	414564	0	SI	2022-01-25 16:53:53
9355	\N	2041	414566	0	SI	2022-01-25 16:53:53
9357	\N	2041	414568	0	SI	2022-01-25 16:53:53
9359	\N	2041	414570	0	SI	2022-01-25 16:53:53
9361	\N	2041	414573	0	SI	2022-01-25 16:53:53
9363	\N	2041	414575	0	SI	2022-01-25 16:53:53
9365	\N	2041	414577	0	SI	2022-01-25 16:53:53
9367	\N	2041	414580	0	SI	2022-01-25 16:53:53
9369	\N	2041	414582	0	SI	2022-01-25 16:53:53
9371	\N	2041	414584	0	SI	2022-01-25 16:53:53
9373	\N	2041	414586	0	SI	2022-01-25 16:53:53
9375	\N	2041	414589	0	SI	2022-01-25 16:53:53
9377	\N	2041	414591	0	SI	2022-01-25 16:53:53
9379	\N	2041	414593	0	SI	2022-01-25 16:53:53
9381	\N	2041	414595	0	NO	2022-01-25 16:53:53
9383	\N	2041	414597	0	SI	2022-01-25 16:53:53
9385	\N	2041	414599	0	NO	2022-01-25 16:53:53
9387	\N	2041	414602	10	SI	2022-01-25 16:53:53
9389	\N	2041	414604	3	SI	2022-01-25 16:53:53
9391	\N	2041	414606	0	NO	2022-01-25 16:53:53
9393	\N	2041	414610	0	NO	2022-01-25 16:53:53
9395	\N	2041	414612	0	NO	2022-01-25 16:53:53
9397	\N	2041	414614	11	SI	2022-01-25 16:53:53
9399	\N	2041	414616	0	NO	2022-01-25 16:53:53
9401	\N	2041	414618	0	SI	2022-01-25 16:53:53
9403	\N	2041	414621	0	NO	2022-01-25 16:53:53
9405	\N	2041	414623	0	NO	2022-01-25 16:53:53
9407	\N	2041	414630	2	NO	2022-01-25 16:53:53
9409	\N	2041	414633	0	NO	2022-01-25 16:53:53
9411	\N	2041	414635	0	NO	2022-01-25 16:53:53
9413	\N	2041	414637	0	NO	2022-01-25 16:53:53
9415	-544	2042	414640	0	SI	2022-01-31 11:51:11
9416	-544	2042	414641	0	NO	2022-01-31 11:51:11
9417	-544	2042	414643	0	SI	2022-01-31 11:51:11
9418	-544	2042	414644	2	SI	2022-01-31 11:51:11
9419	-544	2042	414645	0	SI	2022-01-31 11:51:11
9420	-544	2042	414646	0	SI	2022-01-31 11:51:11
9421	-544	2042	414647	5	SI	2022-01-31 11:51:11
9422	-544	2042	414648	0	NO	2022-01-31 11:51:11
9423	-544	2042	414649	6	SI	2022-01-31 11:51:11
9424	-544	2042	414650	0	NO	2022-01-31 11:51:11
9425	-544	2042	414651	22	NO	2022-01-31 11:51:11
9426	-544	2042	414652	8	NO	2022-01-31 11:51:11
9427	-544	2042	414667	5	NO	2022-01-31 11:51:11
9428	-544	2042	414672	0	NO	2022-01-31 11:51:11
9429	-544	2042	414673	22	NO	2022-01-31 11:51:11
9430	-544	2042	414674	8	NO	2022-01-31 11:51:11
9431	-544	2042	414688	5	NO	2022-01-31 11:51:11
9432	-544	2042	414693	0	NO	2022-01-31 11:51:11
9433	-544	2042	414695	0	SI	2022-01-31 11:51:11
9435	-544	2042	414697	0	SI	2022-01-31 11:51:11
9437	-544	2042	414699	0	SI	2022-01-31 11:51:11
9439	-544	2042	414701	1	SI	2022-01-31 11:51:11
9441	-544	2042	414703	3	SI	2022-01-31 11:51:11
9443	-544	2042	414705	1	SI	2022-01-31 11:51:11
9445	-544	2042	414707	0	SI	2022-01-31 11:51:11
9447	-544	2042	414709	0	SI	2022-01-31 11:51:11
9449	-544	2042	414711	0	SI	2022-01-31 11:51:11
9451	-544	2042	414713	0	SI	2022-01-31 11:51:11
9453	-544	2042	414715	0	NO	2022-01-31 11:51:11
9455	-544	2042	414718	0	SI	2022-01-31 11:51:11
9457	-544	2042	414720	0	SI	2022-01-31 11:51:11
9459	-544	2042	414722	10	NO	2022-01-31 11:51:11
9461	-544	2042	414726	4	SI	2022-01-31 11:51:11
9463	-544	2042	414728	0	NO	2022-01-31 11:51:11
9465	-544	2042	414732	0	SI	2022-01-31 11:51:11
9467	-544	2042	414734	5	NO	2022-01-31 11:51:11
9469	-544	2042	414741	0	NO	2022-01-31 11:51:11
9471	-544	2042	414743	2	NO	2022-01-31 11:51:11
9473	-544	2042	414746	8	NO	2022-01-31 11:51:11
9475	-544	2042	414749	18	NO	2022-01-31 11:51:11
9477	-544	2042	414751	0	SI	2022-01-31 11:51:11
9479	-544	2042	414754	0	NO	2022-01-31 11:51:11
9481	-544	2042	414756	0	SI	2022-01-31 11:51:11
9483	-544	2042	414758	20	NO	2022-01-31 11:51:11
9485	-544	2042	414760	0	SI	2022-01-31 11:51:11
9487	-544	2042	414762	5	NO	2022-01-31 11:51:11
9489	-544	2042	414764	0	NO	2022-01-31 11:51:11
9491	-544	2042	414766	0	NO	2022-01-31 11:51:11
9493	-544	2042	414768	5	NO	2022-01-31 11:51:11
9495	-544	2042	414770	0	SI	2022-01-31 11:51:11
9497	-544	2042	414772	0	SI	2022-01-31 11:51:11
9499	-544	2042	414774	5	SI	2022-01-31 11:51:11
9501	-544	2042	414776	0	SI	2022-01-31 11:51:11
9503	-544	2042	414778	0	NO	2022-01-31 11:51:11
9505	-544	2042	414780	5	NO	2022-01-31 11:51:11
9507	-544	2042	414782	0	SI	2022-01-31 11:51:11
9509	-544	2042	414784	0	SI	2022-01-31 11:51:11
9511	-544	2042	414786	0	NO	2022-01-31 11:51:11
9513	-544	2042	414789	0	NO	2022-01-31 11:51:11
9515	-544	2042	414791	0	SI	2022-01-31 11:51:11
9517	-544	2042	414793	0	NO	2022-01-31 11:51:11
9519	-544	2042	414795	0	SI	2022-01-31 11:51:11
9521	-544	2042	414797	0	NO	2022-01-31 11:51:11
9523	-544	2042	414804	0	NO	2022-01-31 11:51:11
9525	-544	2042	414806	0	SI	2022-01-31 11:51:11
9527	-544	2042	414808	0	NO	2022-01-31 11:51:11
9529	-544	2042	414810	0	NO	2022-01-31 11:51:11
9531	-544	2042	414812	0	SI	2022-01-31 11:51:11
9533	-544	2042	414814	0	NO	2022-01-31 11:51:11
9535	-544	2042	414816	0	NO	2022-01-31 11:51:11
9537	-544	2042	414818	0	NO	2022-01-31 11:51:11
9539	-544	2042	414821	0	SI	2022-01-31 11:51:11
9541	-544	2042	414823	0	SI	2022-01-31 11:51:11
9543	-544	2042	414825	0	NO	2022-01-31 11:51:11
9545	-544	2042	414830	0	NO	2022-01-31 11:51:11
9547	-544	2042	414833	0	SI	2022-01-31 11:51:11
9549	-544	2042	414835	0	SI	2022-01-31 11:51:11
9551	-544	2042	414839	0	SI	2022-01-31 11:51:11
9553	-544	2042	414841	0	SI	2022-01-31 11:51:11
9555	-544	2042	414843	0	NO	2022-01-31 11:51:11
9557	-544	2042	414845	0	NO	2022-01-31 11:51:11
9559	-544	2042	414848	0	SI	2022-01-31 11:51:11
9561	-544	2042	414850	0	SI	2022-01-31 11:51:11
9563	-544	2042	414852	3	NO	2022-01-31 11:51:11
9565	-544	2042	414855	0	SI	2022-01-31 11:51:11
9567	-544	2042	414857	0	SI	2022-01-31 11:51:11
9569	-544	2042	414859	0	SI	2022-01-31 11:51:11
9571	-544	2042	414861	0	SI	2022-01-31 11:51:11
9573	-544	2042	414863	0	SI	2022-01-31 11:51:11
9575	-544	2042	414866	0	SI	2022-01-31 11:51:11
9577	-544	2042	414868	0	SI	2022-01-31 11:51:11
9579	-544	2042	414870	0	SI	2022-01-31 11:51:11
9581	-544	2042	414872	0	NO	2022-01-31 11:51:11
9583	-544	2042	414874	0	SI	2022-01-31 11:51:11
9585	-544	2042	414876	0	NO	2022-01-31 11:51:11
9587	-544	2042	414880	0	NO	2022-01-31 11:51:11
9589	-544	2042	414882	0	NO	2022-01-31 11:51:11
9591	-544	2042	414884	10	SI	2022-01-31 11:51:11
9593	-544	2042	414887	20	SI	2022-01-31 11:51:11
9595	-544	2042	414889	0	NO	2022-01-31 11:51:11
9597	-544	2042	414898	0	SI	2022-01-31 11:51:11
9599	-544	2042	414901	0	NO	2022-01-31 11:51:11
9601	-544	2042	414903	0	NO	2022-01-31 11:51:11
9603	-544	2042	414905	0	NO	2022-01-31 11:51:11
9605	-544	2042	419820	10	NO	2022-01-31 11:51:11
9607	-544	2042	419822	0	SI	2022-01-31 11:51:11
9609	-544	2042	419824	0	SI	2022-01-31 11:51:11
9611	-544	2042	419859	12	SI	2022-01-31 11:51:11
9613	-545	2042	414641	0	NO	2022-01-31 11:56:24
9615	-545	2042	414644	2	SI	2022-01-31 11:56:24
9617	-545	2042	414646	0	SI	2022-01-31 11:56:24
9619	-545	2042	414648	0	NO	2022-01-31 11:56:24
9621	-545	2042	414650	0	NO	2022-01-31 11:56:24
9623	-545	2042	414652	8	NO	2022-01-31 11:56:24
9625	-545	2042	414672	0	NO	2022-01-31 11:56:24
9627	-545	2042	414674	8	NO	2022-01-31 11:56:24
9629	-545	2042	414693	0	NO	2022-01-31 11:56:24
9631	-545	2042	414696	0	SI	2022-01-31 11:56:24
9633	-545	2042	414698	0	SI	2022-01-31 11:56:24
9635	-545	2042	414700	0	NO	2022-01-31 11:56:24
9637	-545	2042	414702	0	SI	2022-01-31 11:56:24
9639	-545	2042	414704	0	NO	2022-01-31 11:56:24
9641	-545	2042	414706	0	SI	2022-01-31 11:56:24
9643	-545	2042	414708	0	SI	2022-01-31 11:56:24
9645	-545	2042	414710	0	SI	2022-01-31 11:56:24
9434	-544	2042	414696	0	SI	2022-01-31 11:51:11
9436	-544	2042	414698	0	SI	2022-01-31 11:51:11
9438	-544	2042	414700	0	NO	2022-01-31 11:51:11
9440	-544	2042	414702	0	SI	2022-01-31 11:51:11
9442	-544	2042	414704	2	SI	2022-01-31 11:51:11
9444	-544	2042	414706	0	SI	2022-01-31 11:51:11
9446	-544	2042	414708	0	SI	2022-01-31 11:51:11
9448	-544	2042	414710	0	SI	2022-01-31 11:51:11
9450	-544	2042	414712	0	SI	2022-01-31 11:51:11
9452	-544	2042	414714	0	SI	2022-01-31 11:51:11
9454	-544	2042	414717	0	NO	2022-01-31 11:51:11
9456	-544	2042	414719	0	SI	2022-01-31 11:51:11
9458	-544	2042	414721	0	SI	2022-01-31 11:51:11
9460	-544	2042	414723	0	SI	2022-01-31 11:51:11
9462	-544	2042	414727	0	SI	2022-01-31 11:51:11
9464	-544	2042	414731	0	NO	2022-01-31 11:51:11
9466	-544	2042	414733	0	NO	2022-01-31 11:51:11
9468	-544	2042	414736	0	NO	2022-01-31 11:51:11
9470	-544	2042	414742	3	NO	2022-01-31 11:51:11
9472	-544	2042	414745	0	NO	2022-01-31 11:51:11
9474	-544	2042	414748	2	NO	2022-01-31 11:51:11
9476	-544	2042	414750	0	NO	2022-01-31 11:51:11
9478	-544	2042	414752	8	NO	2022-01-31 11:51:11
9480	-544	2042	414755	1	SI	2022-01-31 11:51:11
9482	-544	2042	414757	0	NO	2022-01-31 11:51:11
9484	-544	2042	414759	0	SI	2022-01-31 11:51:11
9486	-544	2042	414761	5	NO	2022-01-31 11:51:11
9488	-544	2042	414763	0	SI	2022-01-31 11:51:11
9490	-544	2042	414765	0	NO	2022-01-31 11:51:11
9492	-544	2042	414767	0	SI	2022-01-31 11:51:11
9494	-544	2042	414769	5	NO	2022-01-31 11:51:11
9496	-544	2042	414771	0	SI	2022-01-31 11:51:11
9498	-544	2042	414773	0	NO	2022-01-31 11:51:11
9500	-544	2042	414775	0	SI	2022-01-31 11:51:11
9502	-544	2042	414777	0	NO	2022-01-31 11:51:11
9504	-544	2042	414779	0	NO	2022-01-31 11:51:11
9506	-544	2042	414781	5	NO	2022-01-31 11:51:11
9508	-544	2042	414783	0	SI	2022-01-31 11:51:11
9510	-544	2042	414785	0	NO	2022-01-31 11:51:11
9512	-544	2042	414787	0	NO	2022-01-31 11:51:11
9514	-544	2042	414790	0	SI	2022-01-31 11:51:11
9516	-544	2042	414792	0	SI	2022-01-31 11:51:11
9518	-544	2042	414794	0	SI	2022-01-31 11:51:11
9520	-544	2042	414796	0	NO	2022-01-31 11:51:11
9522	-544	2042	414798	0	NO	2022-01-31 11:51:11
9524	-544	2042	414805	0	NO	2022-01-31 11:51:11
9526	-544	2042	414807	0	NO	2022-01-31 11:51:11
9528	-544	2042	414809	0	NO	2022-01-31 11:51:11
9530	-544	2042	414811	0	SI	2022-01-31 11:51:11
9532	-544	2042	414813	0	NO	2022-01-31 11:51:11
9534	-544	2042	414815	0	NO	2022-01-31 11:51:11
9536	-544	2042	414817	0	NO	2022-01-31 11:51:11
9538	-544	2042	414820	0	SI	2022-01-31 11:51:11
9540	-544	2042	414822	0	NO	2022-01-31 11:51:11
9542	-544	2042	414824	0	SI	2022-01-31 11:51:11
9544	-544	2042	414826	6	NO	2022-01-31 11:51:11
9546	-544	2042	414832	0	SI	2022-01-31 11:51:11
9548	-544	2042	414834	0	SI	2022-01-31 11:51:11
9550	-544	2042	414838	0	SI	2022-01-31 11:51:11
9552	-544	2042	414840	0	SI	2022-01-31 11:51:11
9554	-544	2042	414842	3	NO	2022-01-31 11:51:11
9556	-544	2042	414844	0	SI	2022-01-31 11:51:11
9558	-544	2042	414847	0	SI	2022-01-31 11:51:11
9560	-544	2042	414849	0	SI	2022-01-31 11:51:11
9562	-544	2042	414851	0	SI	2022-01-31 11:51:11
9564	-544	2042	414853	0	SI	2022-01-31 11:51:11
9566	-544	2042	414856	0	NO	2022-01-31 11:51:11
9568	-544	2042	414858	0	SI	2022-01-31 11:51:11
9570	-544	2042	414860	0	SI	2022-01-31 11:51:11
9572	-544	2042	414862	0	SI	2022-01-31 11:51:11
9574	-544	2042	414865	0	SI	2022-01-31 11:51:11
9576	-544	2042	414867	0	SI	2022-01-31 11:51:11
9578	-544	2042	414869	0	SI	2022-01-31 11:51:11
9580	-544	2042	414871	0	SI	2022-01-31 11:51:11
9582	-544	2042	414873	0	NO	2022-01-31 11:51:11
9584	-544	2042	414875	0	NO	2022-01-31 11:51:11
9586	-544	2042	414878	55	SI	2022-01-31 11:51:11
9588	-544	2042	414881	0	NO	2022-01-31 11:51:11
9590	-544	2042	414883	0	SI	2022-01-31 11:51:11
9592	-544	2042	414885	0	NO	2022-01-31 11:51:11
9594	-544	2042	414888	12	SI	2022-01-31 11:51:11
9596	-544	2042	414893	0	NO	2022-01-31 11:51:11
9598	-544	2042	414899	4	NO	2022-01-31 11:51:11
9600	-544	2042	414902	0	NO	2022-01-31 11:51:11
9602	-544	2042	414904	0	NO	2022-01-31 11:51:11
9604	-544	2042	419819	6	NO	2022-01-31 11:51:11
9606	-544	2042	419821	4	SI	2022-01-31 11:51:11
9608	-544	2042	419823	10	NO	2022-01-31 11:51:11
9610	-544	2042	419825	0	NO	2022-01-31 11:51:11
9612	-545	2042	414640	0	SI	2022-01-31 11:56:24
9614	-545	2042	414643	0	SI	2022-01-31 11:56:24
9616	-545	2042	414645	0	SI	2022-01-31 11:56:24
9618	-545	2042	414647	0	NO	2022-01-31 11:56:24
9620	-545	2042	414649	0	NO	2022-01-31 11:56:24
9622	-545	2042	414651	22	NO	2022-01-31 11:56:24
9624	-545	2042	414667	5	NO	2022-01-31 11:56:24
9626	-545	2042	414673	22	NO	2022-01-31 11:56:24
9628	-545	2042	414688	5	NO	2022-01-31 11:56:24
9630	-545	2042	414695	0	SI	2022-01-31 11:56:24
9632	-545	2042	414697	0	SI	2022-01-31 11:56:24
9634	-545	2042	414699	0	SI	2022-01-31 11:56:24
9636	-545	2042	414701	1	SI	2022-01-31 11:56:24
9638	-545	2042	414703	3	SI	2022-01-31 11:56:24
9640	-545	2042	414705	1	SI	2022-01-31 11:56:24
9642	-545	2042	414707	0	SI	2022-01-31 11:56:24
9644	-545	2042	414709	0	SI	2022-01-31 11:56:24
9646	-545	2042	414711	0	SI	2022-01-31 11:56:24
9647	-545	2042	414712	0	SI	2022-01-31 11:56:24
9649	-545	2042	414714	0	SI	2022-01-31 11:56:24
9651	-545	2042	414717	0	NO	2022-01-31 11:56:24
9653	-545	2042	414719	0	SI	2022-01-31 11:56:24
9655	-545	2042	414721	10	NO	2022-01-31 11:56:24
9657	-545	2042	414723	0	SI	2022-01-31 11:56:24
9659	-545	2042	414728	5	SI	2022-01-31 11:56:24
9661	-545	2042	414731	0	NO	2022-01-31 11:56:24
9663	-545	2042	414733	0	NO	2022-01-31 11:56:24
9665	-545	2042	414736	0	NO	2022-01-31 11:56:24
9667	-545	2042	414742	3	NO	2022-01-31 11:56:24
9669	-545	2042	414745	0	NO	2022-01-31 11:56:24
9671	-545	2042	414748	2	NO	2022-01-31 11:56:24
9673	-545	2042	414750	0	NO	2022-01-31 11:56:24
9675	-545	2042	414752	0	SI	2022-01-31 11:56:24
9677	-545	2042	414754	0	NO	2022-01-31 11:56:24
9679	-545	2042	414756	0	SI	2022-01-31 11:56:24
9681	-545	2042	414758	20	NO	2022-01-31 11:56:24
9683	-545	2042	414774	5	SI	2022-01-31 11:56:24
9685	-545	2042	414776	0	SI	2022-01-31 11:56:24
9687	-545	2042	414778	0	NO	2022-01-31 11:56:24
9689	-545	2042	414780	5	NO	2022-01-31 11:56:24
9691	-545	2042	414782	0	SI	2022-01-31 11:56:24
9693	-545	2042	414784	0	SI	2022-01-31 11:56:24
9695	-545	2042	414786	0	NO	2022-01-31 11:56:24
9697	-545	2042	414789	0	NO	2022-01-31 11:56:24
9699	-545	2042	414791	0	SI	2022-01-31 11:56:24
9701	-545	2042	414793	0	NO	2022-01-31 11:56:24
9703	-545	2042	414795	0	SI	2022-01-31 11:56:25
9705	-545	2042	414797	0	NO	2022-01-31 11:56:25
9707	-545	2042	414804	0	NO	2022-01-31 11:56:25
9709	-545	2042	414806	0	SI	2022-01-31 11:56:25
9711	-545	2042	414808	0	NO	2022-01-31 11:56:25
9713	-545	2042	414810	0	NO	2022-01-31 11:56:25
9715	-545	2042	414812	0	SI	2022-01-31 11:56:25
9717	-545	2042	414814	0	NO	2022-01-31 11:56:25
9719	-545	2042	414816	0	NO	2022-01-31 11:56:25
9721	-545	2042	414818	0	NO	2022-01-31 11:56:25
9723	-545	2042	414821	0	SI	2022-01-31 11:56:25
9725	-545	2042	414823	0	SI	2022-01-31 11:56:25
9727	-545	2042	414825	0	NO	2022-01-31 11:56:25
9729	-545	2042	414830	0	NO	2022-01-31 11:56:25
9731	-545	2042	414833	0	SI	2022-01-31 11:56:25
9733	-545	2042	414835	0	SI	2022-01-31 11:56:25
9735	-545	2042	414839	0	SI	2022-01-31 11:56:25
9737	-545	2042	414841	0	SI	2022-01-31 11:56:25
9739	-545	2042	414843	2	SI	2022-01-31 11:56:25
9741	-545	2042	414845	0	NO	2022-01-31 11:56:25
9743	-545	2042	414848	0	SI	2022-01-31 11:56:25
9745	-545	2042	414850	0	SI	2022-01-31 11:56:25
9747	-545	2042	414852	0	SI	2022-01-31 11:56:25
9749	-545	2042	414855	0	SI	2022-01-31 11:56:25
9751	-545	2042	414857	0	SI	2022-01-31 11:56:25
9753	-545	2042	414859	0	SI	2022-01-31 11:56:25
9755	-545	2042	414861	0	SI	2022-01-31 11:56:25
9757	-545	2042	414863	0	SI	2022-01-31 11:56:25
9759	-545	2042	414866	0	SI	2022-01-31 11:56:25
9761	-545	2042	414868	0	SI	2022-01-31 11:56:25
9763	-545	2042	414870	0	SI	2022-01-31 11:56:25
9765	-545	2042	414872	0	NO	2022-01-31 11:56:25
9767	-545	2042	414874	0	SI	2022-01-31 11:56:25
9769	-545	2042	414876	0	NO	2022-01-31 11:56:25
9771	-545	2042	414880	35	SI	2022-01-31 11:56:25
9773	-545	2042	414882	0	NO	2022-01-31 11:56:25
9775	-545	2042	414884	10	SI	2022-01-31 11:56:25
9777	-545	2042	414887	0	NO	2022-01-31 11:56:25
9779	-545	2042	414893	0	NO	2022-01-31 11:56:25
9781	-545	2042	414899	4	NO	2022-01-31 11:56:25
9783	-545	2042	414902	0	NO	2022-01-31 11:56:25
9785	-545	2042	414904	0	NO	2022-01-31 11:56:25
9787	-545	2042	419819	0	SI	2022-01-31 11:56:25
9789	-545	2042	419821	4	SI	2022-01-31 11:56:25
9791	-545	2042	419823	0	SI	2022-01-31 11:56:25
9793	-545	2042	419825	0	NO	2022-01-31 11:56:25
9648	-545	2042	414713	0	SI	2022-01-31 11:56:24
9650	-545	2042	414715	0	NO	2022-01-31 11:56:24
9652	-545	2042	414718	0	SI	2022-01-31 11:56:24
9654	-545	2042	414720	0	SI	2022-01-31 11:56:24
9656	-545	2042	414722	10	NO	2022-01-31 11:56:24
9658	-545	2042	414726	0	NO	2022-01-31 11:56:24
9660	-545	2042	414730	0	SI	2022-01-31 11:56:24
9662	-545	2042	414732	0	SI	2022-01-31 11:56:24
9664	-545	2042	414734	5	NO	2022-01-31 11:56:24
9666	-545	2042	414741	0	NO	2022-01-31 11:56:24
9668	-545	2042	414743	2	NO	2022-01-31 11:56:24
9670	-545	2042	414746	8	NO	2022-01-31 11:56:24
9672	-545	2042	414749	18	NO	2022-01-31 11:56:24
9674	-545	2042	414751	3	NO	2022-01-31 11:56:24
9676	-545	2042	414753	0	NO	2022-01-31 11:56:24
9678	-545	2042	414755	1	SI	2022-01-31 11:56:24
9680	-545	2042	414757	0	NO	2022-01-31 11:56:24
9682	-545	2042	414759	6	NO	2022-01-31 11:56:24
9684	-545	2042	414775	0	SI	2022-01-31 11:56:24
9686	-545	2042	414777	0	NO	2022-01-31 11:56:24
9688	-545	2042	414779	0	NO	2022-01-31 11:56:24
9690	-545	2042	414781	5	NO	2022-01-31 11:56:24
9692	-545	2042	414783	0	SI	2022-01-31 11:56:24
9694	-545	2042	414785	10	SI	2022-01-31 11:56:24
9696	-545	2042	414787	0	NO	2022-01-31 11:56:24
9698	-545	2042	414790	0	SI	2022-01-31 11:56:24
9700	-545	2042	414792	0	SI	2022-01-31 11:56:24
9702	-545	2042	414794	0	SI	2022-01-31 11:56:24
9704	-545	2042	414796	2	SI	2022-01-31 11:56:25
9706	-545	2042	414798	0	NO	2022-01-31 11:56:25
9708	-545	2042	414805	0	NO	2022-01-31 11:56:25
9710	-545	2042	414807	0	NO	2022-01-31 11:56:25
9712	-545	2042	414809	0	NO	2022-01-31 11:56:25
9714	-545	2042	414811	7	NO	2022-01-31 11:56:25
9716	-545	2042	414813	0	NO	2022-01-31 11:56:25
9718	-545	2042	414815	0	NO	2022-01-31 11:56:25
9720	-545	2042	414817	0	NO	2022-01-31 11:56:25
9722	-545	2042	414820	0	SI	2022-01-31 11:56:25
9724	-545	2042	414822	0	NO	2022-01-31 11:56:25
9726	-545	2042	414824	0	SI	2022-01-31 11:56:25
9728	-545	2042	414826	6	NO	2022-01-31 11:56:25
9730	-545	2042	414832	0	SI	2022-01-31 11:56:25
9732	-545	2042	414834	0	SI	2022-01-31 11:56:25
9734	-545	2042	414838	0	SI	2022-01-31 11:56:25
9736	-545	2042	414840	0	SI	2022-01-31 11:56:25
9738	-545	2042	414842	0	SI	2022-01-31 11:56:25
9740	-545	2042	414844	0	SI	2022-01-31 11:56:25
9742	-545	2042	414847	0	SI	2022-01-31 11:56:25
9744	-545	2042	414849	0	SI	2022-01-31 11:56:25
9746	-545	2042	414851	0	SI	2022-01-31 11:56:25
9748	-545	2042	414853	0	SI	2022-01-31 11:56:25
9750	-545	2042	414856	0	NO	2022-01-31 11:56:25
9752	-545	2042	414858	0	SI	2022-01-31 11:56:25
9754	-545	2042	414860	0	SI	2022-01-31 11:56:25
9756	-545	2042	414862	0	SI	2022-01-31 11:56:25
9758	-545	2042	414865	0	SI	2022-01-31 11:56:25
9760	-545	2042	414867	0	SI	2022-01-31 11:56:25
9762	-545	2042	414869	0	SI	2022-01-31 11:56:25
9764	-545	2042	414871	0	SI	2022-01-31 11:56:25
9766	-545	2042	414873	0	NO	2022-01-31 11:56:25
9768	-545	2042	414875	0	NO	2022-01-31 11:56:25
9770	-545	2042	414878	55	SI	2022-01-31 11:56:25
9772	-545	2042	414881	0	NO	2022-01-31 11:56:25
9774	-545	2042	414883	0	SI	2022-01-31 11:56:25
9776	-545	2042	414885	0	NO	2022-01-31 11:56:25
9778	-545	2042	414889	0	NO	2022-01-31 11:56:25
9780	-545	2042	414898	0	SI	2022-01-31 11:56:25
9782	-545	2042	414901	0	NO	2022-01-31 11:56:25
9784	-545	2042	414903	0	NO	2022-01-31 11:56:25
9786	-545	2042	414905	0	NO	2022-01-31 11:56:25
9788	-545	2042	419820	10	NO	2022-01-31 11:56:25
9790	-545	2042	419822	0	SI	2022-01-31 11:56:25
9792	-545	2042	419824	0	SI	2022-01-31 11:56:25
9794	-545	2042	419859	12	SI	2022-01-31 11:56:25
9795	-586	2046	415898	0	SI	2022-02-16 20:11:21
9796	-586	2046	415899	1	SI	2022-02-16 20:11:21
9797	-586	2046	415900	0	SI	2022-02-16 20:11:21
9798	-586	2046	415901	0	SI	2022-02-16 20:11:21
9799	-586	2046	415902	2	SI	2022-02-16 20:11:21
9800	-586	2046	415903	0	NO	2022-02-16 20:11:21
9801	-586	2046	415904	0	NO	2022-02-16 20:11:21
9802	-586	2046	415905	1	SI	2022-02-16 20:11:21
9803	-586	2046	415906	0	SI	2022-02-16 20:11:21
9804	-586	2046	415907	0	SI	2022-02-16 20:11:21
9805	-586	2046	415908	0	SI	2022-02-16 20:11:21
9806	-586	2046	415909	0	SI	2022-02-16 20:11:21
9807	-586	2046	415910	0	NO	2022-02-16 20:11:21
9808	-586	2046	415911	0	NO	2022-02-16 20:11:21
9809	-586	2046	415912	0	NO	2022-02-16 20:11:21
9810	-586	2046	415913	0	SI	2022-02-16 20:11:21
9811	-586	2046	415914	0	NO	2022-02-16 20:11:21
9812	-586	2046	415915	0	NO	2022-02-16 20:11:21
9813	-586	2046	415916	0	SI	2022-02-16 20:11:21
9814	-586	2046	415917	0	SI	2022-02-16 20:11:21
9815	-586	2046	415918	0	SI	2022-02-16 20:11:21
9816	-586	2046	415919	0	SI	2022-02-16 20:11:21
9817	-586	2046	415920	0	SI	2022-02-16 20:11:21
9818	-586	2046	415921	0	SI	2022-02-16 20:11:21
9819	-586	2046	415922	0	SI	2022-02-16 20:11:21
9820	-586	2046	415923	1	SI	2022-02-16 20:11:21
9821	-586	2046	415924	0	SI	2022-02-16 20:11:21
9822	-586	2046	415925	3	NO	2022-02-16 20:11:21
9823	-586	2046	415936	0	SI	2022-02-16 20:11:21
9824	-586	2046	415937	0	SI	2022-02-16 20:11:21
9825	-586	2046	415938	0	SI	2022-02-16 20:11:21
9826	-586	2046	415939	0	SI	2022-02-16 20:11:21
9827	-586	2046	415940	0	SI	2022-02-16 20:11:21
9828	-586	2046	415941	0	NO	2022-02-16 20:11:21
9829	-586	2046	415942	0	SI	2022-02-16 20:11:21
9830	-586	2046	415943	0	SI	2022-02-16 20:11:21
9831	-586	2046	415944	0	SI	2022-02-16 20:11:21
9832	-586	2046	415945	0	SI	2022-02-16 20:11:21
9833	-586	2046	415946	0	SI	2022-02-16 20:11:21
9834	-586	2046	415947	0	SI	2022-02-16 20:11:21
9835	-586	2046	415948	2	SI	2022-02-16 20:11:21
9836	-586	2046	415949	1	SI	2022-02-16 20:11:21
9837	-586	2046	415950	0	SI	2022-02-16 20:11:21
9838	-586	2046	415951	1	SI	2022-02-16 20:11:21
9839	-586	2046	415952	0	NO	2022-02-16 20:11:21
9840	-586	2046	415953	0	NO	2022-02-16 20:11:21
9841	-586	2046	415956	3	NO	2022-02-16 20:11:21
9842	-586	2046	415957	0	SI	2022-02-16 20:11:21
9843	-586	2046	415958	0	SI	2022-02-16 20:11:21
9844	-586	2046	415959	0	SI	2022-02-16 20:11:21
9845	-586	2046	415960	3	SI	2022-02-16 20:11:21
9846	-586	2046	415961	0	SI	2022-02-16 20:11:21
9847	-586	2046	415962	0	NO	2022-02-16 20:11:21
9848	-586	2046	415963	0	SI	2022-02-16 20:11:21
9849	-586	2046	415964	0	SI	2022-02-16 20:11:21
9850	-586	2046	415965	0	SI	2022-02-16 20:11:21
9851	-586	2046	415966	0	SI	2022-02-16 20:11:21
9852	-586	2046	415967	0	SI	2022-02-16 20:11:21
9853	-586	2046	415968	0	NO	2022-02-16 20:11:21
9854	-586	2046	415969	0	SI	2022-02-16 20:11:21
9855	-586	2046	415970	0	NO	2022-02-16 20:11:21
9856	-586	2046	415972	0	SI	2022-02-16 20:11:21
9857	-586	2046	415973	0	SI	2022-02-16 20:11:21
9858	-586	2046	415974	0	NO	2022-02-16 20:11:21
9859	-586	2046	415975	0	NO	2022-02-16 20:11:21
9860	-586	2046	415976	0	SI	2022-02-16 20:11:21
9861	-586	2046	415977	0	NO	2022-02-16 20:11:21
9862	-586	2046	415984	0	NO	2022-02-16 20:11:21
9863	-586	2046	415986	0	SI	2022-02-16 20:11:21
9864	-586	2046	415987	0	SI	2022-02-16 20:11:21
9865	-586	2046	415988	0	SI	2022-02-16 20:11:21
9866	-586	2046	415989	1	SI	2022-02-16 20:11:21
9867	-586	2046	415990	0	SI	2022-02-16 20:11:21
9868	-586	2046	415991	0	SI	2022-02-16 20:11:21
9869	-586	2046	415992	0	NO	2022-02-16 20:11:21
9870	-586	2046	415993	0	NO	2022-02-16 20:11:21
9871	-586	2046	415995	0	NO	2022-02-16 20:11:21
9872	-586	2046	415996	0	NO	2022-02-16 20:11:21
9873	-586	2046	415997	0	SI	2022-02-16 20:11:21
9874	-586	2046	415998	0	NO	2022-02-16 20:11:21
9875	-586	2046	415999	0	NO	2022-02-16 20:11:21
9876	-586	2046	416000	0	NO	2022-02-16 20:11:21
9877	-586	2046	416001	0	NO	2022-02-16 20:11:21
9878	-586	2046	416002	0	SI	2022-02-16 20:11:21
9879	-586	2046	416003	0	NO	2022-02-16 20:11:21
9880	-586	2046	416004	0	NO	2022-02-16 20:11:21
9881	-586	2046	416005	0	NO	2022-02-16 20:11:21
9882	-586	2046	416006	0	NO	2022-02-16 20:11:21
9883	-586	2046	416007	0	NO	2022-02-16 20:11:21
9884	-586	2046	416008	0	NO	2022-02-16 20:11:21
9885	-586	2046	416009	0	NO	2022-02-16 20:11:21
9886	-586	2046	416013	0	NO	2022-02-16 20:11:21
9887	-586	2046	416014	0	SI	2022-02-16 20:11:21
9888	-586	2046	416015	0	SI	2022-02-16 20:11:21
9889	-586	2046	416017	0	SI	2022-02-16 20:11:21
9890	-586	2046	416018	0	SI	2022-02-16 20:11:21
9891	-586	2046	416019	0	NO	2022-02-16 20:11:21
9892	-586	2046	416020	0	SI	2022-02-16 20:11:21
9893	-586	2046	416021	0	SI	2022-02-16 20:11:21
9894	-586	2046	416022	1	SI	2022-02-16 20:11:21
9895	-586	2046	416023	0	SI	2022-02-16 20:11:21
9896	-586	2046	416025	17	SI	2022-02-16 20:11:21
9897	-586	2046	416026	0	SI	2022-02-16 20:11:21
9898	-586	2046	416027	0	SI	2022-02-16 20:11:21
9899	-586	2046	416028	0	SI	2022-02-16 20:11:21
9900	-586	2046	416029	0	SI	2022-02-16 20:11:21
9901	-586	2046	416030	0	NO	2022-02-16 20:11:21
9902	-586	2046	416031	0	SI	2022-02-16 20:11:21
9903	-586	2046	416032	0	SI	2022-02-16 20:11:21
9904	-586	2046	416033	0	SI	2022-02-16 20:11:21
9905	-586	2046	416034	0	SI	2022-02-16 20:11:21
9906	-586	2046	416035	0	SI	2022-02-16 20:11:21
9907	-586	2046	416036	0	NO	2022-02-16 20:11:21
9908	-586	2046	416037	0	SI	2022-02-16 20:11:21
9909	-586	2046	416038	0	SI	2022-02-16 20:11:21
9910	-586	2046	416039	1	NO	2022-02-16 20:11:21
9911	-586	2046	416040	0	SI	2022-02-16 20:11:21
9912	-586	2046	416041	0	SI	2022-02-16 20:11:21
9913	-586	2046	416042	0	SI	2022-02-16 20:11:21
9914	-586	2046	416043	0	SI	2022-02-16 20:11:21
9915	-586	2046	416044	0	SI	2022-02-16 20:11:21
9916	-586	2046	416045	0	SI	2022-02-16 20:11:21
9917	-586	2046	416046	0	SI	2022-02-16 20:11:21
9918	-586	2046	416048	0	NO	2022-02-16 20:11:21
9919	-586	2046	416049	0	SI	2022-02-16 20:11:21
9920	-586	2046	416050	0	SI	2022-02-16 20:11:21
9921	-586	2046	416051	0	SI	2022-02-16 20:11:21
9922	-586	2046	416052	0	SI	2022-02-16 20:11:21
9923	-586	2046	416054	0	SI	2022-02-16 20:11:21
9924	-586	2046	416055	2	SI	2022-02-16 20:11:21
9925	-586	2046	416056	0	SI	2022-02-16 20:11:21
9926	-586	2046	416057	0	SI	2022-02-16 20:11:21
9927	-586	2046	416058	0	SI	2022-02-16 20:11:21
9928	-586	2046	416059	0	SI	2022-02-16 20:11:21
9929	-586	2046	416060	0	SI	2022-02-16 20:11:21
9930	-586	2046	416061	0	SI	2022-02-16 20:11:21
9931	-586	2046	416062	0	SI	2022-02-16 20:11:21
9932	-586	2046	416064	0	SI	2022-02-16 20:11:21
9933	-586	2046	416065	0	SI	2022-02-16 20:11:21
9934	-586	2046	416066	0	SI	2022-02-16 20:11:21
9935	-586	2046	416067	0	SI	2022-02-16 20:11:21
9936	-586	2046	416068	2	SI	2022-02-16 20:11:21
9937	-586	2046	416069	0	NO	2022-02-16 20:11:21
9938	-586	2046	416070	0	SI	2022-02-16 20:11:21
9939	-586	2046	416071	0	NO	2022-02-16 20:11:21
9940	-586	2046	416073	8	SI	2022-02-16 20:11:21
9941	-586	2046	416074	0	NO	2022-02-16 20:11:21
9942	-586	2046	416075	0	NO	2022-02-16 20:11:21
9943	-586	2046	416076	0	NO	2022-02-16 20:11:21
9944	-586	2046	416077	0	SI	2022-02-16 20:11:21
9945	-586	2046	416078	0	NO	2022-02-16 20:11:21
9946	-586	2046	416079	0	NO	2022-02-16 20:11:21
9947	-586	2046	416085	0	NO	2022-02-16 20:11:21
9948	-586	2046	416086	0	NO	2022-02-16 20:11:21
9949	-586	2046	416087	0	NO	2022-02-16 20:11:21
9950	-586	2046	416088	0	NO	2022-02-16 20:11:21
9951	-586	2046	419806	8	NO	2022-02-16 20:11:21
9952	-791	2037	413241	15	SI	2022-06-28 11:17:04
9953	-791	2037	413243	0	SI	2022-06-28 11:17:04
9954	-791	2037	413244	1	SI	2022-06-28 11:17:04
9955	-791	2037	413245	0	SI	2022-06-28 11:17:04
9956	-791	2037	413246	0	SI	2022-06-28 11:17:04
9957	-791	2037	413247	16	SI	2022-06-28 11:17:04
9958	-791	2037	413248	0	SI	2022-06-28 11:17:04
9959	-791	2037	413249	0	SI	2022-06-28 11:17:04
9960	-791	2037	413250	0	SI	2022-06-28 11:17:04
9961	-791	2037	413251	0	SI	2022-06-28 11:17:04
9962	-791	2037	413252	0	SI	2022-06-28 11:17:04
9963	-791	2037	413253	0	SI	2022-06-28 11:17:04
9964	-791	2037	413254	0	SI	2022-06-28 11:17:04
9965	-791	2037	413255	0	SI	2022-06-28 11:17:04
9966	-791	2037	413256	0	NO	2022-06-28 11:17:04
9967	-791	2037	413257	0	NO	2022-06-28 11:17:04
9968	-791	2037	413258	0	NO	2022-06-28 11:17:04
9969	-791	2037	413259	0	SI	2022-06-28 11:17:04
9970	-791	2037	413260	0	SI	2022-06-28 11:17:04
9971	-791	2037	413261	0	SI	2022-06-28 11:17:04
9972	-791	2037	413262	0	SI	2022-06-28 11:17:04
9973	-791	2037	413263	0	SI	2022-06-28 11:17:04
9974	-791	2037	413264	0	SI	2022-06-28 11:17:04
9975	-791	2037	413265	0	SI	2022-06-28 11:17:04
9976	-791	2037	413266	5	NO	2022-06-28 11:17:04
9977	-791	2037	413272	5	SI	2022-06-28 11:17:04
9978	-791	2037	413273	5	SI	2022-06-28 11:17:04
9979	-791	2037	413274	0	SI	2022-06-28 11:17:04
9980	-791	2037	413275	0	SI	2022-06-28 11:17:04
9981	-791	2037	413276	0	NO	2022-06-28 11:17:04
9982	-791	2037	413279	0	NO	2022-06-28 11:17:04
9983	-791	2037	413280	3	NO	2022-06-28 11:17:04
9984	-791	2037	413281	2	NO	2022-06-28 11:17:04
9985	-791	2037	413283	0	NO	2022-06-28 11:17:04
9986	-791	2037	413284	8	NO	2022-06-28 11:17:04
9987	-791	2037	413286	2	NO	2022-06-28 11:17:04
9988	-791	2037	413287	18	NO	2022-06-28 11:17:04
9989	-791	2037	413288	0	NO	2022-06-28 11:17:04
9990	-791	2037	413289	0	NO	2022-06-28 11:17:04
9991	-791	2037	413292	0	NO	2022-06-28 11:17:04
9992	-791	2037	413293	5	NO	2022-06-28 11:17:04
9993	-791	2037	413294	0	NO	2022-06-28 11:17:04
9994	-791	2037	413295	1	NO	2022-06-28 11:17:04
9995	-791	2037	413297	5	SI	2022-06-28 11:17:04
9996	-791	2037	413298	0	NO	2022-06-28 11:17:04
9997	-791	2037	413299	0	SI	2022-06-28 11:17:04
9998	-791	2037	413300	0	SI	2022-06-28 11:17:04
9999	-791	2037	413301	0	SI	2022-06-28 11:17:04
10000	-791	2037	413302	0	SI	2022-06-28 11:17:04
10001	-791	2037	413303	3	SI	2022-06-28 11:17:04
10002	-791	2037	413304	1	SI	2022-06-28 11:17:04
10003	-791	2037	413305	0	SI	2022-06-28 11:17:04
10004	-791	2037	413306	3	SI	2022-06-28 11:17:04
10005	-791	2037	413307	0	NO	2022-06-28 11:17:04
10006	-791	2037	413308	1	SI	2022-06-28 11:17:04
10007	-791	2037	413309	0	SI	2022-06-28 11:17:04
10008	-791	2037	413310	0	SI	2022-06-28 11:17:04
10009	-791	2037	413311	0	SI	2022-06-28 11:17:04
10010	-791	2037	413312	0	SI	2022-06-28 11:17:04
10011	-791	2037	413313	0	SI	2022-06-28 11:17:04
10012	-791	2037	413314	0	SI	2022-06-28 11:17:04
10013	-791	2037	413315	0	SI	2022-06-28 11:17:04
10014	-791	2037	413316	0	SI	2022-06-28 11:17:04
10015	-791	2037	413317	0	SI	2022-06-28 11:17:04
10016	-791	2037	413318	4	SI	2022-06-28 11:17:04
10017	-791	2037	413319	4	NO	2022-06-28 11:17:04
10018	-791	2037	413320	0	SI	2022-06-28 11:17:04
10019	-791	2037	413321	0	SI	2022-06-28 11:17:04
10020	-791	2037	413322	0	SI	2022-06-28 11:17:04
10021	-791	2037	413323	0	SI	2022-06-28 11:17:04
10022	-791	2037	413324	20	NO	2022-06-28 11:17:04
10023	-791	2037	413326	0	SI	2022-06-28 11:17:04
10024	-791	2037	413329	0	NO	2022-06-28 11:17:04
10025	-791	2037	413331	0	NO	2022-06-28 11:17:04
10026	-791	2037	413334	0	NO	2022-06-28 11:17:05
10027	-791	2037	413335	0	SI	2022-06-28 11:17:05
10028	-791	2037	413336	0	SI	2022-06-28 11:17:05
10029	-791	2037	413337	0	NO	2022-06-28 11:17:05
10030	-791	2037	413338	0	NO	2022-06-28 11:17:05
10031	-791	2037	413340	0	NO	2022-06-28 11:17:05
10032	-791	2037	413341	0	SI	2022-06-28 11:17:05
10033	-791	2037	413342	0	SI	2022-06-28 11:17:05
10034	-791	2037	413343	0	NO	2022-06-28 11:17:05
10035	-791	2037	413344	0	NO	2022-06-28 11:17:05
10036	-791	2037	413345	5	SI	2022-06-28 11:17:05
10037	-791	2037	413346	0	SI	2022-06-28 11:17:05
10038	-791	2037	413347	0	SI	2022-06-28 11:17:05
10039	-791	2037	413348	0	SI	2022-06-28 11:17:05
10040	-791	2037	413349	0	SI	2022-06-28 11:17:05
10041	-791	2037	413350	0	SI	2022-06-28 11:17:05
10042	-791	2037	413351	0	NO	2022-06-28 11:17:05
10044	-791	2037	413353	0	NO	2022-06-28 11:17:05
10046	-791	2037	413355	0	SI	2022-06-28 11:17:05
10048	-791	2037	413357	0	SI	2022-06-28 11:17:05
10050	-791	2037	413359	0	SI	2022-06-28 11:17:05
10052	-791	2037	413361	0	NO	2022-06-28 11:17:05
10054	-791	2037	413372	0	NO	2022-06-28 11:17:05
10056	-791	2037	413381	0	SI	2022-06-28 11:17:05
10058	-791	2037	413384	0	NO	2022-06-28 11:17:05
10060	-791	2037	413386	0	NO	2022-06-28 11:17:05
10062	-791	2037	413388	0	NO	2022-06-28 11:17:05
10064	-791	2037	413390	0	SI	2022-06-28 11:17:05
10066	-791	2037	413392	0	NO	2022-06-28 11:17:05
10068	-791	2037	413394	0	NO	2022-06-28 11:17:05
10070	-791	2037	413396	0	NO	2022-06-28 11:17:05
10072	-791	2037	413399	0	SI	2022-06-28 11:17:05
10074	-791	2037	413401	0	NO	2022-06-28 11:17:05
10076	-791	2037	413403	0	SI	2022-06-28 11:17:05
10078	-791	2037	413405	0	SI	2022-06-28 11:17:05
10080	-791	2037	413407	0	NO	2022-06-28 11:17:05
10082	-791	2037	413410	0	SI	2022-06-28 11:17:05
10084	-791	2037	413412	0	SI	2022-06-28 11:17:05
10086	-791	2037	413416	0	SI	2022-06-28 11:17:05
10088	-791	2037	413418	0	SI	2022-06-28 11:17:05
10090	-791	2037	413420	0	SI	2022-06-28 11:17:05
10092	-791	2037	413422	0	SI	2022-06-28 11:17:05
10094	-791	2037	413424	0	SI	2022-06-28 11:17:05
10096	-791	2037	413426	0	SI	2022-06-28 11:17:05
10098	-791	2037	413428	0	SI	2022-06-28 11:17:05
10100	-791	2037	413430	0	SI	2022-06-28 11:17:05
10102	-791	2037	413433	0	SI	2022-06-28 11:17:05
10104	-791	2037	413442	0	SI	2022-06-28 11:17:05
10106	-791	2037	413444	0	SI	2022-06-28 11:17:05
10108	-791	2037	413446	0	SI	2022-06-28 11:17:05
10110	-791	2037	413448	0	SI	2022-06-28 11:17:05
10112	-791	2037	413450	0	NO	2022-06-28 11:17:05
10114	-791	2037	413452	0	NO	2022-06-28 11:17:05
10116	-791	2037	413455	20	SI	2022-06-28 11:17:05
10118	-791	2037	413457	0	NO	2022-06-28 11:17:05
10120	-791	2037	413459	0	NO	2022-06-28 11:17:05
10122	-791	2037	413462	0	NO	2022-06-28 11:17:05
10124	-791	2037	413464	0	NO	2022-06-28 11:17:05
10126	-791	2037	413466	0	SI	2022-06-28 11:17:05
10128	-791	2037	413469	0	NO	2022-06-28 11:17:05
10130	-791	2037	413474	0	SI	2022-06-28 11:17:05
10132	-791	2037	413476	0	SI	2022-06-28 11:17:05
10134	-791	2037	413478	0	SI	2022-06-28 11:17:05
10136	-791	2037	413480	0	SI	2022-06-28 11:17:05
10138	-791	2037	413483	0	NO	2022-06-28 11:17:05
10140	-791	2037	413485	0	NO	2022-06-28 11:17:05
10142	-791	2037	419836	0	SI	2022-06-28 11:17:05
10144	-791	2037	419846	0	SI	2022-06-28 11:17:05
10146	-791	2037	419850	0	SI	2022-06-28 11:17:05
10148	-791	2037	419852	0	SI	2022-06-28 11:17:05
10150	-791	2037	419854	0	SI	2022-06-28 11:17:05
10152	-791	2037	419856	0	SI	2022-06-28 11:17:05
10154	-791	2037	419858	15	SI	2022-06-28 11:17:05
10043	-791	2037	413352	0	NO	2022-06-28 11:17:05
10045	-791	2037	413354	0	SI	2022-06-28 11:17:05
10047	-791	2037	413356	0	SI	2022-06-28 11:17:05
10049	-791	2037	413358	0	SI	2022-06-28 11:17:05
10051	-791	2037	413360	0	NO	2022-06-28 11:17:05
10053	-791	2037	413362	15	NO	2022-06-28 11:17:05
10055	-791	2037	413373	10	NO	2022-06-28 11:17:05
10057	-791	2037	413383	0	NO	2022-06-28 11:17:05
10059	-791	2037	413385	0	SI	2022-06-28 11:17:05
10061	-791	2037	413387	0	NO	2022-06-28 11:17:05
10063	-791	2037	413389	0	NO	2022-06-28 11:17:05
10065	-791	2037	413391	0	SI	2022-06-28 11:17:05
10067	-791	2037	413393	0	NO	2022-06-28 11:17:05
10069	-791	2037	413395	0	NO	2022-06-28 11:17:05
10071	-791	2037	413397	0	NO	2022-06-28 11:17:05
10073	-791	2037	413400	0	SI	2022-06-28 11:17:05
10075	-791	2037	413402	0	SI	2022-06-28 11:17:05
10077	-791	2037	413404	0	SI	2022-06-28 11:17:05
10079	-791	2037	413406	0	SI	2022-06-28 11:17:05
10081	-791	2037	413408	0	NO	2022-06-28 11:17:05
10083	-791	2037	413411	0	SI	2022-06-28 11:17:05
10085	-791	2037	413413	0	SI	2022-06-28 11:17:05
10087	-791	2037	413417	0	SI	2022-06-28 11:17:05
10089	-791	2037	413419	0	SI	2022-06-28 11:17:05
10091	-791	2037	413421	2	SI	2022-06-28 11:17:05
10093	-791	2037	413423	1	SI	2022-06-28 11:17:05
10095	-791	2037	413425	0	SI	2022-06-28 11:17:05
10097	-791	2037	413427	0	SI	2022-06-28 11:17:05
10099	-791	2037	413429	0	SI	2022-06-28 11:17:05
10101	-791	2037	413431	0	SI	2022-06-28 11:17:05
10103	-791	2037	413434	0	SI	2022-06-28 11:17:05
10105	-791	2037	413443	0	SI	2022-06-28 11:17:05
10107	-791	2037	413445	0	SI	2022-06-28 11:17:05
10109	-791	2037	413447	0	SI	2022-06-28 11:17:05
10111	-791	2037	413449	0	NO	2022-06-28 11:17:05
10113	-791	2037	413451	0	SI	2022-06-28 11:17:05
10115	-791	2037	413453	0	NO	2022-06-28 11:17:05
10117	-791	2037	413456	0	NO	2022-06-28 11:17:05
10119	-791	2037	413458	0	SI	2022-06-28 11:17:05
10121	-791	2037	413461	45	SI	2022-06-28 11:17:05
10123	-791	2037	413463	0	NO	2022-06-28 11:17:05
10125	-791	2037	413465	12	SI	2022-06-28 11:17:05
10127	-791	2037	413467	0	NO	2022-06-28 11:17:05
10129	-791	2037	413473	45	SI	2022-06-28 11:17:05
10131	-791	2037	413475	40	SI	2022-06-28 11:17:05
10133	-791	2037	413477	0	NO	2022-06-28 11:17:05
10135	-791	2037	413479	0	SI	2022-06-28 11:17:05
10137	-791	2037	413482	0	NO	2022-06-28 11:17:05
10139	-791	2037	413484	0	NO	2022-06-28 11:17:05
10141	-791	2037	413486	0	NO	2022-06-28 11:17:05
10143	-791	2037	419845	5	SI	2022-06-28 11:17:05
10145	-791	2037	419849	0	SI	2022-06-28 11:17:05
10147	-791	2037	419851	5	SI	2022-06-28 11:17:05
10149	-791	2037	419853	0	SI	2022-06-28 11:17:05
10151	-791	2037	419855	0	SI	2022-06-28 11:17:05
10153	-791	2037	419857	0	SI	2022-06-28 11:17:05
10155	-858	2036	413113	0	SI	2022-06-30 15:19:51
10156	-858	2036	413114	0	SI	2022-06-30 15:19:51
10157	-858	2036	413115	0	NO	2022-06-30 15:19:51
10158	-858	2036	413119	0	SI	2022-06-30 15:19:51
10159	-858	2036	413120	2	SI	2022-06-30 15:19:51
10160	-858	2036	413121	0	NO	2022-06-30 15:19:51
10161	-858	2036	413124	0	SI	2022-06-30 15:19:51
10162	-858	2036	413125	0	SI	2022-06-30 15:19:51
10163	-858	2036	413126	0	SI	2022-06-30 15:19:51
10164	-858	2036	413127	0	SI	2022-06-30 15:19:51
10165	-858	2036	413128	0	SI	2022-06-30 15:19:51
10166	-858	2036	413129	0	SI	2022-06-30 15:19:51
10167	-858	2036	413130	1	NO	2022-06-30 15:19:51
10168	-858	2036	413132	0	NO	2022-06-30 15:19:51
10169	-858	2036	413134	4	NO	2022-06-30 15:19:51
10170	-858	2036	413135	2	NO	2022-06-30 15:19:51
10171	-858	2036	413137	2	NO	2022-06-30 15:19:51
10172	-858	2036	413138	2	NO	2022-06-30 15:19:51
10173	-858	2036	413141	0	NO	2022-06-30 15:19:51
10174	-858	2036	413144	0	NO	2022-06-30 15:19:51
10175	-858	2036	413145	0	NO	2022-06-30 15:19:51
10176	-858	2036	413150	1	NO	2022-06-30 15:19:51
10177	-858	2036	413152	0	NO	2022-06-30 15:19:51
10178	-858	2036	413154	0	NO	2022-06-30 15:19:51
10179	-858	2036	413156	0	NO	2022-06-30 15:19:51
10180	-858	2036	413157	0	NO	2022-06-30 15:19:51
10181	-858	2036	413158	25	NO	2022-06-30 15:19:51
10182	-858	2036	413159	0	NO	2022-06-30 15:19:51
10183	-858	2036	413160	0	NO	2022-06-30 15:19:51
10184	-858	2036	413161	0	NO	2022-06-30 15:19:51
10185	-858	2036	413162	10	NO	2022-06-30 15:19:51
10186	-858	2036	413163	3	NO	2022-06-30 15:19:51
10187	-858	2036	413164	0	NO	2022-06-30 15:19:51
10188	-858	2036	413165	0	NO	2022-06-30 15:19:51
10189	-858	2036	413166	0	NO	2022-06-30 15:19:51
10190	-858	2036	413167	0	NO	2022-06-30 15:19:51
10191	-858	2036	413168	0	NO	2022-06-30 15:19:51
10192	-858	2036	413170	3	NO	2022-06-30 15:19:51
10193	-858	2036	413174	0	NO	2022-06-30 15:19:51
10194	-858	2036	413175	5	NO	2022-06-30 15:19:51
10195	-858	2036	413179	0	NO	2022-06-30 15:19:51
10196	-858	2036	413181	12	NO	2022-06-30 15:19:51
10197	-858	2036	413182	25	NO	2022-06-30 15:19:51
10198	-858	2036	413185	6	NO	2022-06-30 15:19:51
10199	-858	2036	413186	3	NO	2022-06-30 15:19:51
10200	-858	2036	413187	2	NO	2022-06-30 15:19:51
10201	-858	2036	413188	1	NO	2022-06-30 15:19:51
10202	-858	2036	413189	1	NO	2022-06-30 15:19:51
10203	-858	2036	413190	0	NO	2022-06-30 15:19:51
10204	-858	2036	413191	3	NO	2022-06-30 15:19:51
10205	-858	2036	413192	0	NO	2022-06-30 15:19:51
10206	-858	2036	413194	1	NO	2022-06-30 15:19:51
10207	-858	2036	413196	2	NO	2022-06-30 15:19:51
10208	-858	2036	413197	2	NO	2022-06-30 15:19:51
10209	-858	2036	413198	1	NO	2022-06-30 15:19:51
10210	-858	2036	413199	1	NO	2022-06-30 15:19:51
10211	-858	2036	413200	4	NO	2022-06-30 15:19:51
10212	-858	2036	413202	7	NO	2022-06-30 15:19:51
10213	-858	2036	413203	0	NO	2022-06-30 15:19:51
10214	-858	2036	413204	2	NO	2022-06-30 15:19:51
10215	-858	2036	413212	7	NO	2022-06-30 15:19:51
10216	-858	2036	413213	2	NO	2022-06-30 15:19:51
10217	-858	2036	413214	1	NO	2022-06-30 15:19:51
10218	-858	2036	413217	2	NO	2022-06-30 15:19:51
10219	-858	2036	413218	3	NO	2022-06-30 15:19:51
10220	-858	2036	413219	0	NO	2022-06-30 15:19:51
10221	-858	2036	413220	0	NO	2022-06-30 15:19:51
10222	-858	2036	413221	4	NO	2022-06-30 15:19:51
10223	-858	2036	413222	0	NO	2022-06-30 15:19:51
10224	-858	2036	413223	0	NO	2022-06-30 15:19:51
10225	-858	2036	413225	0	NO	2022-06-30 15:19:51
10226	-858	2036	413226	7	NO	2022-06-30 15:19:51
10227	-858	2036	413227	0	NO	2022-06-30 15:19:51
10228	-858	2036	413228	0	NO	2022-06-30 15:19:51
10229	-858	2036	413230	0	NO	2022-06-30 15:19:51
10230	-858	2036	413235	0	NO	2022-06-30 15:19:51
10231	-858	2036	413236	0	NO	2022-06-30 15:19:51
10232	-858	2036	413237	0	NO	2022-06-30 15:19:51
10233	-858	2036	413238	0	NO	2022-06-30 15:19:51
10234	-858	2036	419832	1	NO	2022-06-30 15:19:51
10235	-858	2036	419833	3	NO	2022-06-30 15:19:51
10236	-858	2036	419834	2	NO	2022-06-30 15:19:51
10237	-858	2036	419837	4	NO	2022-06-30 15:19:51
10238	-904	2036	413113	25	NO	2022-07-13 10:28:23
10239	-904	2036	413114	3	NO	2022-07-13 10:28:23
10240	-904	2036	413115	0	NO	2022-07-13 10:28:23
10241	-904	2036	413119	1	NO	2022-07-13 10:28:23
10242	-904	2036	413121	0	NO	2022-07-13 10:28:23
10243	-904	2036	413124	0	SI	2022-07-13 10:28:23
10244	-904	2036	413125	0	SI	2022-07-13 10:28:23
10245	-904	2036	413126	5	NO	2022-07-13 10:28:23
10246	-904	2036	413127	0	SI	2022-07-13 10:28:23
10247	-904	2036	413128	2	NO	2022-07-13 10:28:23
10248	-904	2036	413129	2	NO	2022-07-13 10:28:23
10249	-904	2036	413130	1	NO	2022-07-13 10:28:23
10250	-904	2036	413132	0	NO	2022-07-13 10:28:23
10251	-904	2036	413134	4	NO	2022-07-13 10:28:23
10252	-904	2036	413135	0	SI	2022-07-13 10:28:24
10253	-904	2036	413136	1	NO	2022-07-13 10:28:24
10254	-904	2036	413137	2	NO	2022-07-13 10:28:24
10255	-904	2036	413138	0	SI	2022-07-13 10:28:24
10256	-904	2036	413139	0	NO	2022-07-13 10:28:24
10257	-904	2036	413141	0	NO	2022-07-13 10:28:24
10258	-904	2036	413144	2	SI	2022-07-13 10:28:24
10259	-904	2036	413145	0	NO	2022-07-13 10:28:24
10260	-904	2036	413150	1	NO	2022-07-13 10:28:24
10261	-904	2036	413152	0	NO	2022-07-13 10:28:24
10262	-904	2036	413154	0	NO	2022-07-13 10:28:24
10263	-904	2036	413156	0	NO	2022-07-13 10:28:24
10264	-904	2036	413157	7	SI	2022-07-13 10:28:24
10265	-904	2036	413158	25	NO	2022-07-13 10:28:24
10266	-904	2036	413159	12	SI	2022-07-13 10:28:24
10267	-904	2036	413160	12	SI	2022-07-13 10:28:24
10268	-904	2036	413161	2	SI	2022-07-13 10:28:24
10269	-904	2036	413162	10	NO	2022-07-13 10:28:24
10270	-904	2036	413163	3	NO	2022-07-13 10:28:24
10271	-904	2036	413164	0	NO	2022-07-13 10:28:24
10272	-904	2036	413165	0	NO	2022-07-13 10:28:24
10273	-904	2036	413166	0	NO	2022-07-13 10:28:24
10274	-904	2036	413167	0	NO	2022-07-13 10:28:24
10275	-904	2036	413168	0	NO	2022-07-13 10:28:24
10276	-904	2036	413170	0	SI	2022-07-13 10:28:24
10277	-904	2036	413171	2	NO	2022-07-13 10:28:24
10278	-904	2036	413172	1	SI	2022-07-13 10:28:24
10279	-904	2036	413173	1	NO	2022-07-13 10:28:24
10280	-904	2036	413174	0	NO	2022-07-13 10:28:24
10281	-904	2036	413175	5	NO	2022-07-13 10:28:24
10282	-904	2036	413179	0	NO	2022-07-13 10:28:24
10283	-904	2036	413181	12	NO	2022-07-13 10:28:24
10284	-904	2036	413182	25	NO	2022-07-13 10:28:24
10285	-904	2036	413185	6	NO	2022-07-13 10:28:24
10286	-904	2036	413186	3	NO	2022-07-13 10:28:24
10287	-904	2036	413187	2	NO	2022-07-13 10:28:24
10288	-904	2036	413188	1	NO	2022-07-13 10:28:24
10289	-904	2036	413189	1	NO	2022-07-13 10:28:24
10290	-904	2036	413190	1	SI	2022-07-13 10:28:24
10291	-904	2036	413191	3	NO	2022-07-13 10:28:24
10292	-904	2036	413192	1	SI	2022-07-13 10:28:24
10293	-904	2036	413193	1	NO	2022-07-13 10:28:24
10294	-904	2036	413194	1	NO	2022-07-13 10:28:24
10295	-904	2036	413196	0	SI	2022-07-13 10:28:24
10296	-904	2036	413197	2	NO	2022-07-13 10:28:24
10297	-904	2036	413198	1	NO	2022-07-13 10:28:24
10298	-904	2036	413199	0	SI	2022-07-13 10:28:24
10299	-904	2036	413200	4	NO	2022-07-13 10:28:24
10300	-904	2036	413202	7	NO	2022-07-13 10:28:24
10301	-904	2036	413203	0	NO	2022-07-13 10:28:24
10302	-904	2036	413204	2	NO	2022-07-13 10:28:24
10303	-904	2036	413212	7	NO	2022-07-13 10:28:24
10304	-904	2036	413213	0	SI	2022-07-13 10:28:24
10305	-904	2036	413214	1	NO	2022-07-13 10:28:24
10306	-904	2036	413217	2	NO	2022-07-13 10:28:24
10307	-904	2036	413218	3	NO	2022-07-13 10:28:24
10308	-904	2036	413219	0	NO	2022-07-13 10:28:24
10309	-904	2036	413220	0	NO	2022-07-13 10:28:24
10310	-904	2036	413221	0	SI	2022-07-13 10:28:24
10311	-904	2036	413222	2	SI	2022-07-13 10:28:24
10312	-904	2036	413223	0	NO	2022-07-13 10:28:24
10313	-904	2036	413225	20	SI	2022-07-13 10:28:24
10315	-904	2036	413227	0	NO	2022-07-13 10:28:24
10317	-904	2036	413230	0	NO	2022-07-13 10:28:24
10319	-904	2036	413236	0	NO	2022-07-13 10:28:24
10321	-904	2036	413238	0	NO	2022-07-13 10:28:24
10323	-904	2036	419833	3	NO	2022-07-13 10:28:24
10325	-904	2036	419837	4	NO	2022-07-13 10:28:24
10314	-904	2036	413226	7	NO	2022-07-13 10:28:24
10316	-904	2036	413228	0	NO	2022-07-13 10:28:24
10318	-904	2036	413235	0	NO	2022-07-13 10:28:24
10320	-904	2036	413237	0	NO	2022-07-13 10:28:24
10322	-904	2036	419832	0	SI	2022-07-13 10:28:24
10324	-904	2036	419834	2	NO	2022-07-13 10:28:24
10326	-930	2036	413113	0	SI	2022-07-25 17:33:05
10327	-930	2036	413114	0	SI	2022-07-25 17:33:05
10328	-930	2036	413115	0	NO	2022-07-25 17:33:05
10329	-930	2036	413119	1	NO	2022-07-25 17:33:05
10330	-930	2036	413121	1	SI	2022-07-25 17:33:05
10331	-930	2036	413122	0	SI	2022-07-25 17:33:05
10332	-930	2036	413123	0	SI	2022-07-25 17:33:05
10333	-930	2036	413124	0	SI	2022-07-25 17:33:05
10334	-930	2036	413125	0	SI	2022-07-25 17:33:05
10335	-930	2036	413126	0	SI	2022-07-25 17:33:05
10336	-930	2036	413127	0	SI	2022-07-25 17:33:05
10337	-930	2036	413128	0	SI	2022-07-25 17:33:05
10338	-930	2036	413129	0	SI	2022-07-25 17:33:05
10339	-930	2036	413130	0	SI	2022-07-25 17:33:05
10340	-930	2036	413131	0	SI	2022-07-25 17:33:05
10341	-930	2036	413132	2	SI	2022-07-25 17:33:05
10342	-930	2036	413133	0	SI	2022-07-25 17:33:05
10343	-930	2036	413134	0	SI	2022-07-25 17:33:05
10344	-930	2036	413135	0	SI	2022-07-25 17:33:05
10345	-930	2036	413136	0	SI	2022-07-25 17:33:05
10346	-930	2036	413137	0	SI	2022-07-25 17:33:05
10347	-930	2036	413138	0	SI	2022-07-25 17:33:05
10348	-930	2036	413139	0	NO	2022-07-25 17:33:05
10349	-930	2036	413141	3	SI	2022-07-25 17:33:05
10350	-930	2036	413143	0	SI	2022-07-25 17:33:05
10351	-930	2036	413144	2	SI	2022-07-25 17:33:05
10352	-930	2036	413145	10	SI	2022-07-25 17:33:05
10353	-930	2036	413146	0	SI	2022-07-25 17:33:05
10354	-930	2036	413147	0	SI	2022-07-25 17:33:05
10355	-930	2036	413148	0	SI	2022-07-25 17:33:05
10356	-930	2036	413149	20	SI	2022-07-25 17:33:05
10357	-930	2036	413150	0	SI	2022-07-25 17:33:05
10358	-930	2036	413151	0	NO	2022-07-25 17:33:05
10359	-930	2036	413152	0	NO	2022-07-25 17:33:05
10360	-930	2036	413154	0	NO	2022-07-25 17:33:05
10361	-930	2036	413156	0	NO	2022-07-25 17:33:05
10362	-930	2036	413157	0	NO	2022-07-25 17:33:05
10363	-930	2036	413158	0	SI	2022-07-25 17:33:05
10364	-930	2036	413159	0	NO	2022-07-25 17:33:05
10365	-930	2036	413160	0	NO	2022-07-25 17:33:05
10366	-930	2036	413161	0	NO	2022-07-25 17:33:05
10367	-930	2036	413162	0	SI	2022-07-25 17:33:05
10368	-930	2036	413163	3	NO	2022-07-25 17:33:05
10369	-930	2036	413164	0	NO	2022-07-25 17:33:05
10370	-930	2036	413165	0	NO	2022-07-25 17:33:05
10371	-930	2036	413166	0	NO	2022-07-25 17:33:05
10372	-930	2036	413167	0	NO	2022-07-25 17:33:05
10373	-930	2036	413168	0	NO	2022-07-25 17:33:05
10374	-930	2036	413170	0	SI	2022-07-25 17:33:05
10375	-930	2036	413171	0	SI	2022-07-25 17:33:05
10376	-930	2036	413172	0	NO	2022-07-25 17:33:05
10377	-930	2036	413173	0	SI	2022-07-25 17:33:05
10378	-930	2036	413174	0	NO	2022-07-25 17:33:05
10379	-930	2036	413175	0	SI	2022-07-25 17:33:05
10380	-930	2036	413176	0	SI	2022-07-25 17:33:05
10381	-930	2036	413177	0	SI	2022-07-25 17:33:05
10382	-930	2036	413178	0	NO	2022-07-25 17:33:05
10383	-930	2036	413179	0	NO	2022-07-25 17:33:05
10384	-930	2036	413181	0	SI	2022-07-25 17:33:05
10385	-930	2036	413182	0	SI	2022-07-25 17:33:05
10386	-930	2036	413185	0	SI	2022-07-25 17:33:05
10387	-930	2036	413186	0	SI	2022-07-25 17:33:05
10388	-930	2036	413187	0	SI	2022-07-25 17:33:05
10389	-930	2036	413188	0	SI	2022-07-25 17:33:05
10390	-930	2036	413189	0	SI	2022-07-25 17:33:05
10391	-930	2036	413190	0	NO	2022-07-25 17:33:05
10392	-930	2036	413191	0	SI	2022-07-25 17:33:05
10393	-930	2036	413192	0	NO	2022-07-25 17:33:05
10394	-930	2036	413194	0	SI	2022-07-25 17:33:05
10395	-930	2036	413195	0	SI	2022-07-25 17:33:05
10396	-930	2036	413196	0	SI	2022-07-25 17:33:05
10397	-930	2036	413197	0	SI	2022-07-25 17:33:05
10398	-930	2036	413198	0	SI	2022-07-25 17:33:05
10399	-930	2036	413199	0	SI	2022-07-25 17:33:05
10400	-930	2036	413200	0	SI	2022-07-25 17:33:05
10401	-930	2036	413202	0	SI	2022-07-25 17:33:05
10402	-930	2036	413203	0	NO	2022-07-25 17:33:05
10403	-930	2036	413204	0	SI	2022-07-25 17:33:05
10404	-930	2036	413212	0	SI	2022-07-25 17:33:05
10405	-930	2036	413213	0	SI	2022-07-25 17:33:05
10406	-930	2036	413214	0	SI	2022-07-25 17:33:05
10407	-930	2036	413215	0	SI	2022-07-25 17:33:05
10408	-930	2036	413216	0	SI	2022-07-25 17:33:05
10409	-930	2036	413217	0	SI	2022-07-25 17:33:05
10410	-930	2036	413218	0	SI	2022-07-25 17:33:05
10411	-930	2036	413219	0	NO	2022-07-25 17:33:05
10412	-930	2036	413220	0	NO	2022-07-25 17:33:05
10413	-930	2036	413221	0	SI	2022-07-25 17:33:05
10414	-930	2036	413222	0	NO	2022-07-25 17:33:05
10415	-930	2036	413223	0	NO	2022-07-25 17:33:05
10416	-930	2036	413225	0	NO	2022-07-25 17:33:05
10417	-930	2036	413226	0	SI	2022-07-25 17:33:05
10418	-930	2036	413227	0	NO	2022-07-25 17:33:05
10419	-930	2036	413228	0	NO	2022-07-25 17:33:05
10420	-930	2036	413230	0	NO	2022-07-25 17:33:05
10421	-930	2036	413235	0	NO	2022-07-25 17:33:05
10422	-930	2036	413236	0	NO	2022-07-25 17:33:05
10423	-930	2036	413237	0	NO	2022-07-25 17:33:05
10424	-930	2036	413238	0	NO	2022-07-25 17:33:05
10425	-930	2036	419832	0	SI	2022-07-25 17:33:05
10426	-930	2036	419833	0	SI	2022-07-25 17:33:05
10427	-930	2036	419834	0	SI	2022-07-25 17:33:05
10428	-930	2036	419835	0	NO	2022-07-25 17:33:05
10429	-930	2036	419837	0	SI	2022-07-25 17:33:05
10430	-930	2036	419838	0	SI	2022-07-25 17:33:05
10431	-930	2036	419839	0	SI	2022-07-25 17:33:05
10432	-930	2036	419840	0	SI	2022-07-25 17:33:05
10433	-930	2036	419841	0	SI	2022-07-25 17:33:05
10434	-930	2036	419842	0	SI	2022-07-25 17:33:05
10655	-943	2041	414344	0	SI	2022-08-02 11:26:43
10656	-943	2041	414345	0	SI	2022-08-02 11:26:43
10657	-943	2041	414346	0	NO	2022-08-02 11:26:43
10658	-943	2041	414347	0	SI	2022-08-02 11:26:43
10659	-943	2041	414348	0	SI	2022-08-02 11:26:43
10660	-943	2041	414349	0	SI	2022-08-02 11:26:43
10661	-943	2041	414350	0	SI	2022-08-02 11:26:43
10662	-943	2041	414351	25	SI	2022-08-02 11:26:43
10663	-943	2041	414352	17	NO	2022-08-02 11:26:43
10664	-943	2041	414353	16	NO	2022-08-02 11:26:43
10665	-943	2041	414354	9	SI	2022-08-02 11:26:43
10666	-943	2041	414355	0	NO	2022-08-02 11:26:43
10667	-943	2041	414356	0	NO	2022-08-02 11:26:43
10668	-943	2041	414357	0	SI	2022-08-02 11:26:43
10669	-943	2041	414358	0	SI	2022-08-02 11:26:43
10670	-943	2041	414359	0	SI	2022-08-02 11:26:43
10671	-943	2041	414360	0	SI	2022-08-02 11:26:43
10672	-943	2041	414361	0	NO	2022-08-02 11:26:43
10673	-943	2041	414362	0	SI	2022-08-02 11:26:43
10674	-943	2041	414363	5	NO	2022-08-02 11:26:43
10675	-943	2041	414364	9	SI	2022-08-02 11:26:43
10676	-943	2041	414365	0	NO	2022-08-02 11:26:43
10677	-943	2041	414366	0	SI	2022-08-02 11:26:43
10678	-943	2041	414367	0	NO	2022-08-02 11:26:43
10679	-943	2041	414368	3	SI	2022-08-02 11:26:43
10680	-943	2041	414369	0	SI	2022-08-02 11:26:43
10681	-943	2041	414370	3	SI	2022-08-02 11:26:43
10682	-943	2041	414371	3	SI	2022-08-02 11:26:43
10683	-943	2041	414372	17	NO	2022-08-02 11:26:43
10684	-943	2041	414373	6	NO	2022-08-02 11:26:43
10685	-943	2041	414374	5	NO	2022-08-02 11:26:43
10686	-943	2041	414375	7	SI	2022-08-02 11:26:43
10687	-943	2041	414376	0	SI	2022-08-02 11:26:43
10688	-943	2041	414377	0	SI	2022-08-02 11:26:43
10689	-943	2041	414378	13	NO	2022-08-02 11:26:43
10690	-943	2041	414379	2	SI	2022-08-02 11:26:43
10691	-943	2041	414380	0	SI	2022-08-02 11:26:43
10692	-943	2041	414381	0	SI	2022-08-02 11:26:43
10693	-943	2041	414382	0	NO	2022-08-02 11:26:43
10694	-943	2041	414383	0	NO	2022-08-02 11:26:43
10695	-943	2041	414384	6	SI	2022-08-02 11:26:43
10696	-943	2041	414385	5	SI	2022-08-02 11:26:43
10697	-943	2041	414386	0	SI	2022-08-02 11:26:43
10698	-943	2041	414387	8	NO	2022-08-02 11:26:43
10699	-943	2041	414402	5	NO	2022-08-02 11:26:43
10700	-943	2041	414407	0	SI	2022-08-02 11:26:43
10701	-943	2041	414408	0	NO	2022-08-02 11:26:43
10702	-943	2041	414409	0	NO	2022-08-02 11:26:43
10703	-943	2041	414410	0	NO	2022-08-02 11:26:43
10704	-943	2041	414412	0	NO	2022-08-02 11:26:43
10705	-943	2041	414413	0	NO	2022-08-02 11:26:43
10706	-943	2041	414416	2	NO	2022-08-02 11:26:43
10707	-943	2041	414418	0	NO	2022-08-02 11:26:43
10708	-943	2041	414421	0	NO	2022-08-02 11:26:43
10709	-943	2041	414422	8	NO	2022-08-02 11:26:43
10710	-943	2041	414424	0	NO	2022-08-02 11:26:43
10711	-943	2041	414425	0	NO	2022-08-02 11:26:43
10712	-943	2041	414426	3	NO	2022-08-02 11:26:43
10713	-943	2041	414427	2	NO	2022-08-02 11:26:43
10714	-943	2041	414429	0	NO	2022-08-02 11:26:43
10715	-943	2041	414430	8	NO	2022-08-02 11:26:43
10716	-943	2041	414432	2	NO	2022-08-02 11:26:43
10717	-943	2041	414433	18	NO	2022-08-02 11:26:43
10718	-943	2041	414434	0	NO	2022-08-02 11:26:43
10719	-943	2041	414435	0	NO	2022-08-02 11:26:43
10720	-943	2041	414436	0	NO	2022-08-02 11:26:43
10721	-943	2041	414438	0	NO	2022-08-02 11:26:43
10722	-943	2041	414442	3	NO	2022-08-02 11:26:43
10723	-943	2041	414443	0	SI	2022-08-02 11:26:43
10724	-943	2041	414444	3	SI	2022-08-02 11:26:43
10725	-943	2041	414445	0	NO	2022-08-02 11:26:43
10726	-943	2041	414446	1	SI	2022-08-02 11:26:43
10727	-943	2041	414447	0	SI	2022-08-02 11:26:43
10728	-943	2041	414448	5	SI	2022-08-02 11:26:43
10729	-943	2041	414449	0	SI	2022-08-02 11:26:43
10730	-943	2041	414450	6	NO	2022-08-02 11:26:43
10731	-943	2041	414465	0	NO	2022-08-02 11:26:43
10732	-943	2041	414466	15	NO	2022-08-02 11:26:43
10733	-943	2041	414476	0	NO	2022-08-02 11:26:43
10734	-943	2041	414478	9	SI	2022-08-02 11:26:43
10735	-943	2041	414479	0	SI	2022-08-02 11:26:43
10736	-943	2041	414480	0	SI	2022-08-02 11:26:43
10737	-943	2041	414481	0	SI	2022-08-02 11:26:43
10738	-943	2041	414482	0	SI	2022-08-02 11:26:43
10739	-943	2041	414483	3	SI	2022-08-02 11:26:43
10740	-943	2041	414484	2	SI	2022-08-02 11:26:43
10741	-943	2041	414485	0	SI	2022-08-02 11:26:43
10742	-943	2041	414486	3	SI	2022-08-02 11:26:43
10743	-943	2041	414487	2	SI	2022-08-02 11:26:43
10744	-943	2041	414488	2	SI	2022-08-02 11:26:43
10745	-943	2041	414489	0	SI	2022-08-02 11:26:43
10746	-943	2041	414490	0	SI	2022-08-02 11:26:43
10747	-943	2041	414491	0	SI	2022-08-02 11:26:43
10748	-943	2041	414492	7	NO	2022-08-02 11:26:43
10749	-943	2041	414493	0	SI	2022-08-02 11:26:43
10750	-943	2041	414494	0	SI	2022-08-02 11:26:43
10751	-943	2041	414495	0	SI	2022-08-02 11:26:43
10752	-943	2041	414496	0	SI	2022-08-02 11:26:43
10753	-943	2041	414497	3	NO	2022-08-02 11:26:43
10754	-943	2041	414498	3	SI	2022-08-02 11:26:43
10755	-943	2041	414499	3	NO	2022-08-02 11:26:43
10756	-943	2041	414500	0	SI	2022-08-02 11:26:43
10757	-943	2041	414501	5	NO	2022-08-02 11:26:43
10758	-943	2041	414502	3	NO	2022-08-02 11:26:43
10759	-943	2041	414503	10	NO	2022-08-02 11:26:43
10760	-943	2041	414504	10	NO	2022-08-02 11:26:43
10761	-943	2041	414505	0	SI	2022-08-02 11:26:43
10762	-943	2041	414506	0	NO	2022-08-02 11:26:43
10763	-943	2041	414507	0	SI	2022-08-02 11:26:43
10764	-943	2041	414508	0	NO	2022-08-02 11:26:43
10765	-943	2041	414510	0	SI	2022-08-02 11:26:43
10766	-943	2041	414511	0	SI	2022-08-02 11:26:43
10767	-943	2041	414512	7	SI	2022-08-02 11:26:43
10768	-943	2041	414513	3	SI	2022-08-02 11:26:43
10769	-943	2041	414514	0	NO	2022-08-02 11:26:43
10770	-943	2041	414516	0	NO	2022-08-02 11:26:43
10771	-943	2041	414517	0	NO	2022-08-02 11:26:43
10772	-943	2041	414518	0	SI	2022-08-02 11:26:43
10773	-943	2041	414519	2	NO	2022-08-02 11:26:43
10774	-943	2041	414520	0	SI	2022-08-02 11:26:43
10775	-943	2041	414521	2	SI	2022-08-02 11:26:43
10776	-943	2041	414522	0	SI	2022-08-02 11:26:43
10777	-943	2041	414523	0	SI	2022-08-02 11:26:43
10778	-943	2041	414524	2	SI	2022-08-02 11:26:43
10779	-943	2041	414525	0	NO	2022-08-02 11:26:43
10780	-943	2041	414527	9	SI	2022-08-02 11:26:43
10781	-943	2041	414528	9	SI	2022-08-02 11:26:43
10782	-943	2041	414529	0	NO	2022-08-02 11:26:43
10783	-943	2041	414531	0	NO	2022-08-02 11:26:43
10784	-943	2041	414532	0	SI	2022-08-02 11:26:43
10785	-943	2041	414533	20	SI	2022-08-02 11:26:43
10786	-943	2041	414534	0	NO	2022-08-02 11:26:43
10787	-943	2041	414535	0	NO	2022-08-02 11:26:43
10788	-943	2041	414536	0	NO	2022-08-02 11:26:43
10789	-943	2041	414537	0	SI	2022-08-02 11:26:43
10790	-943	2041	414538	7	NO	2022-08-02 11:26:43
10791	-943	2041	414539	0	NO	2022-08-02 11:26:43
10792	-943	2041	414540	0	NO	2022-08-02 11:26:43
10793	-943	2041	414541	4	SI	2022-08-02 11:26:43
10794	-943	2041	414542	0	NO	2022-08-02 11:26:43
10795	-943	2041	414543	0	NO	2022-08-02 11:26:43
10796	-943	2041	414544	0	NO	2022-08-02 11:26:43
10797	-943	2041	414545	0	NO	2022-08-02 11:26:43
10798	-943	2041	414547	0	SI	2022-08-02 11:26:43
10799	-943	2041	414548	0	SI	2022-08-02 11:26:43
10800	-943	2041	414549	0	NO	2022-08-02 11:26:43
10801	-943	2041	414550	0	SI	2022-08-02 11:26:43
10802	-943	2041	414551	0	SI	2022-08-02 11:26:43
10803	-943	2041	414552	0	NO	2022-08-02 11:26:43
10804	-943	2041	414553	10	NO	2022-08-02 11:26:43
10805	-943	2041	414556	0	SI	2022-08-02 11:26:43
10806	-943	2041	414557	0	SI	2022-08-02 11:26:43
10807	-943	2041	414558	0	SI	2022-08-02 11:26:43
10808	-943	2041	414559	0	SI	2022-08-02 11:26:43
10809	-943	2041	414560	0	SI	2022-08-02 11:26:43
10810	-943	2041	414561	0	NO	2022-08-02 11:26:43
10811	-943	2041	414562	0	SI	2022-08-02 11:26:43
10812	-943	2041	414563	0	SI	2022-08-02 11:26:43
10813	-943	2041	414564	0	SI	2022-08-02 11:26:43
10814	-943	2041	414565	0	SI	2022-08-02 11:26:43
10815	-943	2041	414566	3	NO	2022-08-02 11:26:43
10816	-943	2041	414567	0	NO	2022-08-02 11:26:43
10817	-943	2041	414568	0	SI	2022-08-02 11:26:43
10818	-943	2041	414569	0	NO	2022-08-02 11:26:43
10819	-943	2041	414571	0	SI	2022-08-02 11:26:43
10820	-943	2041	414572	0	SI	2022-08-02 11:26:43
10821	-943	2041	414573	0	SI	2022-08-02 11:26:43
10822	-943	2041	414574	0	SI	2022-08-02 11:26:43
10823	-943	2041	414575	3	NO	2022-08-02 11:26:43
10824	-943	2041	414576	0	SI	2022-08-02 11:26:43
10825	-943	2041	414577	0	SI	2022-08-02 11:26:43
10826	-943	2041	414579	0	SI	2022-08-02 11:26:43
10827	-943	2041	414580	0	SI	2022-08-02 11:26:43
10828	-943	2041	414581	0	SI	2022-08-02 11:26:43
10829	-943	2041	414582	0	SI	2022-08-02 11:26:43
10830	-943	2041	414583	0	SI	2022-08-02 11:26:43
10831	-943	2041	414584	0	SI	2022-08-02 11:26:43
10832	-943	2041	414585	0	SI	2022-08-02 11:26:43
10833	-943	2041	414586	0	SI	2022-08-02 11:26:43
10834	-943	2041	414588	0	SI	2022-08-02 11:26:43
10835	-943	2041	414589	0	SI	2022-08-02 11:26:43
10836	-943	2041	414590	0	SI	2022-08-02 11:26:43
10837	-943	2041	414591	0	SI	2022-08-02 11:26:43
10838	-943	2041	414592	0	SI	2022-08-02 11:26:43
10839	-943	2041	414593	0	SI	2022-08-02 11:26:43
10840	-943	2041	414594	0	SI	2022-08-02 11:26:43
10841	-943	2041	414595	3	SI	2022-08-02 11:26:43
10842	-943	2041	414596	0	NO	2022-08-02 11:26:43
10843	-943	2041	414597	0	SI	2022-08-02 11:26:43
10844	-943	2041	414598	0	NO	2022-08-02 11:26:43
10845	-943	2041	414599	0	NO	2022-08-02 11:26:43
10846	-943	2041	414601	10	SI	2022-08-02 11:26:43
10847	-943	2041	414602	10	SI	2022-08-02 11:26:43
10848	-943	2041	414603	0	NO	2022-08-02 11:26:43
10849	-943	2041	414604	3	SI	2022-08-02 11:26:43
10850	-943	2041	414605	0	NO	2022-08-02 11:26:44
10851	-943	2041	414606	0	NO	2022-08-02 11:26:44
10852	-943	2041	414609	0	NO	2022-08-02 11:26:44
10853	-943	2041	414610	0	NO	2022-08-02 11:26:44
10854	-943	2041	414611	0	NO	2022-08-02 11:26:44
10855	-943	2041	414612	0	NO	2022-08-02 11:26:44
10856	-943	2041	414613	0	NO	2022-08-02 11:26:44
10857	-943	2041	414614	0	NO	2022-08-02 11:26:44
10858	-943	2041	414615	0	NO	2022-08-02 11:26:44
10859	-943	2041	414616	0	NO	2022-08-02 11:26:44
10860	-943	2041	414617	60	SI	2022-08-02 11:26:44
10861	-943	2041	414618	19	NO	2022-08-02 11:26:44
10862	-943	2041	414619	65	SI	2022-08-02 11:26:44
10863	-943	2041	414621	0	NO	2022-08-02 11:26:44
10864	-943	2041	414622	0	NO	2022-08-02 11:26:44
10865	-943	2041	414623	0	NO	2022-08-02 11:26:44
10866	-943	2041	414624	0	NO	2022-08-02 11:26:44
10867	-943	2041	414630	2	NO	2022-08-02 11:26:44
10868	-943	2041	414631	4	NO	2022-08-02 11:26:44
10869	-943	2041	414633	0	NO	2022-08-02 11:26:44
10870	-943	2041	414634	0	NO	2022-08-02 11:26:44
10871	-943	2041	414635	0	NO	2022-08-02 11:26:44
10872	-943	2041	414636	0	NO	2022-08-02 11:26:44
10873	-943	2041	414637	0	NO	2022-08-02 11:26:44
10874	-943	2041	419809	0	SI	2022-08-02 11:26:44
10875	-978	2046	415898	0	SI	2022-08-18 18:05:21
10876	-978	2046	415899	1	SI	2022-08-18 18:05:21
10877	-978	2046	415900	0	SI	2022-08-18 18:05:21
10878	-978	2046	415901	0	SI	2022-08-18 18:05:21
10879	-978	2046	415902	2	SI	2022-08-18 18:05:21
10880	-978	2046	415903	0	NO	2022-08-18 18:05:21
10881	-978	2046	415904	0	NO	2022-08-18 18:05:21
10882	-978	2046	415905	1	SI	2022-08-18 18:05:21
10883	-978	2046	415906	0	SI	2022-08-18 18:05:21
10884	-978	2046	415907	4	NO	2022-08-18 18:05:21
10885	-978	2046	415919	0	SI	2022-08-18 18:05:21
10886	-978	2046	415920	0	SI	2022-08-18 18:05:21
10887	-978	2046	415921	1	NO	2022-08-18 18:05:21
10888	-978	2046	415922	0	SI	2022-08-18 18:05:21
10889	-978	2046	415923	1	SI	2022-08-18 18:05:21
10890	-978	2046	415924	0	SI	2022-08-18 18:05:21
10891	-978	2046	415925	3	NO	2022-08-18 18:05:21
10892	-978	2046	415936	0	SI	2022-08-18 18:05:21
10893	-978	2046	415937	0	SI	2022-08-18 18:05:21
10894	-978	2046	415938	1	NO	2022-08-18 18:05:21
10895	-978	2046	415939	0	SI	2022-08-18 18:05:21
10896	-978	2046	415940	8	NO	2022-08-18 18:05:21
10897	-978	2046	415941	7	SI	2022-08-18 18:05:21
10898	-978	2046	415942	0	SI	2022-08-18 18:05:21
10899	-978	2046	415943	0	SI	2022-08-18 18:05:21
10900	-978	2046	415944	1	NO	2022-08-18 18:05:21
10901	-978	2046	415945	0	SI	2022-08-18 18:05:21
10902	-978	2046	415946	0	SI	2022-08-18 18:05:21
10903	-978	2046	415947	0	SI	2022-08-18 18:05:21
10904	-978	2046	415948	2	SI	2022-08-18 18:05:21
10905	-978	2046	415949	0	NO	2022-08-18 18:05:21
10906	-978	2046	415953	1	SI	2022-08-18 18:05:21
10907	-978	2046	415954	0	SI	2022-08-18 18:05:21
10908	-978	2046	415955	0	SI	2022-08-18 18:05:21
10909	-978	2046	415956	0	SI	2022-08-18 18:05:21
10910	-978	2046	415957	0	SI	2022-08-18 18:05:21
10911	-978	2046	415958	0	SI	2022-08-18 18:05:21
10912	-978	2046	415959	0	SI	2022-08-18 18:05:21
10913	-978	2046	415960	3	SI	2022-08-18 18:05:21
10914	-978	2046	415961	2	NO	2022-08-18 18:05:21
10915	-978	2046	415962	4	SI	2022-08-18 18:05:21
10916	-978	2046	415963	0	SI	2022-08-18 18:05:21
10917	-978	2046	415964	0	SI	2022-08-18 18:05:21
10918	-978	2046	415965	0	SI	2022-08-18 18:05:21
10919	-978	2046	415966	0	SI	2022-08-18 18:05:21
10920	-978	2046	415967	0	SI	2022-08-18 18:05:21
10921	-978	2046	415968	3	SI	2022-08-18 18:05:21
10922	-978	2046	415969	0	SI	2022-08-18 18:05:21
10923	-978	2046	415970	0	NO	2022-08-18 18:05:21
10924	-978	2046	415972	0	SI	2022-08-18 18:05:21
10925	-978	2046	415973	0	SI	2022-08-18 18:05:21
10926	-978	2046	415974	5	SI	2022-08-18 18:05:21
10927	-978	2046	415975	4	SI	2022-08-18 18:05:21
10928	-978	2046	415976	4	NO	2022-08-18 18:05:21
10929	-978	2046	415977	10	SI	2022-08-18 18:05:21
10930	-978	2046	415978	0	SI	2022-08-18 18:05:21
10931	-978	2046	415979	0	SI	2022-08-18 18:05:21
10932	-978	2046	415980	0	SI	2022-08-18 18:05:21
10933	-978	2046	415981	0	SI	2022-08-18 18:05:21
10934	-978	2046	415982	0	NO	2022-08-18 18:05:21
10935	-978	2046	415983	0	NO	2022-08-18 18:05:21
10936	-978	2046	415984	3	SI	2022-08-18 18:05:21
10937	-978	2046	415985	0	SI	2022-08-18 18:05:21
10938	-978	2046	415986	0	SI	2022-08-18 18:05:21
10939	-978	2046	415987	1	NO	2022-08-18 18:05:21
10940	-978	2046	415988	0	SI	2022-08-18 18:05:21
10941	-978	2046	415989	0	NO	2022-08-18 18:05:21
10942	-978	2046	415990	2	NO	2022-08-18 18:05:21
10943	-978	2046	415991	2	NO	2022-08-18 18:05:21
10944	-978	2046	415992	0	NO	2022-08-18 18:05:21
10945	-978	2046	415993	0	NO	2022-08-18 18:05:21
10946	-978	2046	415995	7	SI	2022-08-18 18:05:21
10947	-978	2046	415996	7	SI	2022-08-18 18:05:21
10948	-978	2046	415997	0	SI	2022-08-18 18:05:21
10949	-978	2046	415998	20	SI	2022-08-18 18:05:21
10950	-978	2046	415999	30	SI	2022-08-18 18:05:21
10951	-978	2046	416000	0	NO	2022-08-18 18:05:21
10952	-978	2046	416001	0	NO	2022-08-18 18:05:21
10953	-978	2046	416002	0	SI	2022-08-18 18:05:21
10954	-978	2046	416003	0	NO	2022-08-18 18:05:21
10955	-978	2046	416004	0	NO	2022-08-18 18:05:21
10956	-978	2046	416005	0	NO	2022-08-18 18:05:21
10957	-978	2046	416006	0	NO	2022-08-18 18:05:21
10958	-978	2046	416007	0	NO	2022-08-18 18:05:21
10959	-978	2046	416008	0	NO	2022-08-18 18:05:21
10960	-978	2046	416009	0	NO	2022-08-18 18:05:21
10961	-978	2046	416013	0	NO	2022-08-18 18:05:21
10962	-978	2046	416014	0	SI	2022-08-18 18:05:21
10963	-978	2046	416015	0	SI	2022-08-18 18:05:21
10964	-978	2046	416017	0	SI	2022-08-18 18:05:21
10965	-978	2046	416018	3	NO	2022-08-18 18:05:21
10966	-978	2046	416019	0	NO	2022-08-18 18:05:21
10967	-978	2046	416020	0	SI	2022-08-18 18:05:21
10968	-978	2046	416021	0	SI	2022-08-18 18:05:21
10969	-978	2046	416022	1	SI	2022-08-18 18:05:21
10970	-978	2046	416023	0	SI	2022-08-18 18:05:21
10971	-978	2046	416025	17	SI	2022-08-18 18:05:21
10972	-978	2046	416026	0	SI	2022-08-18 18:05:21
10973	-978	2046	416027	0	SI	2022-08-18 18:05:21
10974	-978	2046	416028	0	SI	2022-08-18 18:05:21
10975	-978	2046	416029	2	NO	2022-08-18 18:05:21
10976	-978	2046	416030	2	SI	2022-08-18 18:05:21
10977	-978	2046	416031	0	SI	2022-08-18 18:05:21
10978	-978	2046	416032	0	SI	2022-08-18 18:05:21
10979	-978	2046	416033	0	SI	2022-08-18 18:05:21
10980	-978	2046	416034	0	SI	2022-08-18 18:05:21
10981	-978	2046	416035	1	NO	2022-08-18 18:05:21
10982	-978	2046	416036	0	NO	2022-08-18 18:05:21
10983	-978	2046	416037	0	SI	2022-08-18 18:05:21
10984	-978	2046	416038	0	SI	2022-08-18 18:05:21
10985	-978	2046	416039	1	NO	2022-08-18 18:05:21
10986	-978	2046	416040	0	SI	2022-08-18 18:05:21
10987	-978	2046	416041	0	SI	2022-08-18 18:05:21
10988	-978	2046	416042	0	SI	2022-08-18 18:05:21
10989	-978	2046	416043	0	SI	2022-08-18 18:05:21
10990	-978	2046	416044	1	NO	2022-08-18 18:05:21
10991	-978	2046	416045	0	SI	2022-08-18 18:05:21
10992	-978	2046	416046	0	SI	2022-08-18 18:05:21
10993	-978	2046	416048	0	NO	2022-08-18 18:05:21
10994	-978	2046	416049	0	SI	2022-08-18 18:05:21
10995	-978	2046	416050	1	NO	2022-08-18 18:05:21
10996	-978	2046	416051	0	SI	2022-08-18 18:05:21
10997	-978	2046	416052	0	SI	2022-08-18 18:05:21
10998	-978	2046	416054	0	SI	2022-08-18 18:05:21
10999	-978	2046	416055	0	NO	2022-08-18 18:05:21
11000	-978	2046	416056	0	SI	2022-08-18 18:05:21
11001	-978	2046	416057	0	SI	2022-08-18 18:05:21
11002	-978	2046	416058	0	SI	2022-08-18 18:05:21
11003	-978	2046	416059	0	SI	2022-08-18 18:05:21
11004	-978	2046	416060	0	SI	2022-08-18 18:05:21
11005	-978	2046	416061	0	SI	2022-08-18 18:05:21
11006	-978	2046	416062	2	NO	2022-08-18 18:05:21
11007	-978	2046	416064	0	SI	2022-08-18 18:05:21
11008	-978	2046	416065	0	SI	2022-08-18 18:05:21
11009	-978	2046	416066	0	SI	2022-08-18 18:05:21
11010	-978	2046	416067	0	SI	2022-08-18 18:05:21
11011	-978	2046	416068	0	NO	2022-08-18 18:05:21
11012	-978	2046	416069	0	NO	2022-08-18 18:05:21
11013	-978	2046	416070	0	SI	2022-08-18 18:05:21
11014	-978	2046	416071	0	NO	2022-08-18 18:05:21
11015	-978	2046	416073	8	SI	2022-08-18 18:05:21
11016	-978	2046	416074	0	NO	2022-08-18 18:05:21
11017	-978	2046	416075	0	NO	2022-08-18 18:05:21
11018	-978	2046	416076	0	NO	2022-08-18 18:05:21
11019	-978	2046	416077	0	SI	2022-08-18 18:05:21
11020	-978	2046	416078	5	SI	2022-08-18 18:05:21
11021	-978	2046	416079	0	NO	2022-08-18 18:05:21
11022	-978	2046	416085	0	NO	2022-08-18 18:05:21
11023	-978	2046	416086	0	NO	2022-08-18 18:05:21
11024	-978	2046	416087	0	NO	2022-08-18 18:05:21
11025	-978	2046	416088	0	NO	2022-08-18 18:05:21
11026	-978	2046	419806	0	SI	2022-08-18 18:05:21
11027	-978	2046	419807	0	SI	2022-08-18 18:05:21
11028	-978	2046	419808	0	SI	2022-08-18 18:05:21
11029	-982	2036	413113	25	NO	2022-08-19 10:10:50
11030	-982	2036	413114	3	NO	2022-08-19 10:10:50
11031	-982	2036	413115	0	NO	2022-08-19 10:10:50
11032	-982	2036	413119	1	NO	2022-08-19 10:10:50
11033	-982	2036	413121	0	NO	2022-08-19 10:10:50
11034	-982	2036	413124	2	NO	2022-08-19 10:10:50
11035	-982	2036	413125	5	NO	2022-08-19 10:10:50
11036	-982	2036	413126	5	NO	2022-08-19 10:10:50
11037	-982	2036	413127	2	NO	2022-08-19 10:10:50
11038	-982	2036	413128	2	NO	2022-08-19 10:10:50
11039	-982	2036	413129	2	NO	2022-08-19 10:10:50
11040	-982	2036	413130	1	NO	2022-08-19 10:10:50
11041	-982	2036	413132	0	NO	2022-08-19 10:10:50
11042	-982	2036	413134	4	NO	2022-08-19 10:10:50
11043	-982	2036	413135	2	NO	2022-08-19 10:10:50
11044	-982	2036	413137	2	NO	2022-08-19 10:10:50
11045	-982	2036	413138	2	NO	2022-08-19 10:10:50
11046	-982	2036	413141	0	NO	2022-08-19 10:10:50
11047	-982	2036	413144	0	NO	2022-08-19 10:10:50
11048	-982	2036	413145	0	NO	2022-08-19 10:10:50
11049	-982	2036	413150	1	NO	2022-08-19 10:10:50
11050	-982	2036	413152	0	NO	2022-08-19 10:10:50
11051	-982	2036	413154	0	NO	2022-08-19 10:10:50
11052	-982	2036	413156	0	NO	2022-08-19 10:10:50
11053	-982	2036	413157	0	NO	2022-08-19 10:10:50
11054	-982	2036	413158	25	NO	2022-08-19 10:10:50
11055	-982	2036	413159	0	NO	2022-08-19 10:10:50
11056	-982	2036	413160	0	NO	2022-08-19 10:10:50
11057	-982	2036	413161	0	NO	2022-08-19 10:10:50
11058	-982	2036	413162	10	NO	2022-08-19 10:10:50
11059	-982	2036	413163	3	NO	2022-08-19 10:10:50
11060	-982	2036	413164	0	NO	2022-08-19 10:10:50
11061	-982	2036	413165	0	NO	2022-08-19 10:10:50
11062	-982	2036	413166	0	NO	2022-08-19 10:10:50
11063	-982	2036	413167	0	NO	2022-08-19 10:10:50
11064	-982	2036	413168	0	NO	2022-08-19 10:10:50
11065	-982	2036	413170	3	NO	2022-08-19 10:10:50
11066	-982	2036	413174	0	NO	2022-08-19 10:10:50
11067	-982	2036	413175	5	NO	2022-08-19 10:10:50
11068	-982	2036	413179	0	NO	2022-08-19 10:10:50
11069	-982	2036	413181	12	NO	2022-08-19 10:10:50
11070	-982	2036	413182	25	NO	2022-08-19 10:10:50
11071	-982	2036	413185	6	NO	2022-08-19 10:10:50
11072	-982	2036	413186	3	NO	2022-08-19 10:10:50
11073	-982	2036	413187	2	NO	2022-08-19 10:10:50
11074	-982	2036	413188	1	NO	2022-08-19 10:10:50
11075	-982	2036	413189	1	NO	2022-08-19 10:10:50
11076	-982	2036	413190	0	NO	2022-08-19 10:10:50
11077	-982	2036	413191	3	NO	2022-08-19 10:10:50
11078	-982	2036	413192	0	NO	2022-08-19 10:10:50
11079	-982	2036	413194	1	NO	2022-08-19 10:10:50
11080	-982	2036	413196	2	NO	2022-08-19 10:10:50
11081	-982	2036	413197	2	NO	2022-08-19 10:10:50
11082	-982	2036	413198	1	NO	2022-08-19 10:10:50
11083	-982	2036	413199	1	NO	2022-08-19 10:10:50
11084	-982	2036	413200	4	NO	2022-08-19 10:10:50
11085	-982	2036	413202	7	NO	2022-08-19 10:10:50
11086	-982	2036	413203	0	NO	2022-08-19 10:10:51
11087	-982	2036	413204	0	SI	2022-08-19 10:10:51
11088	-982	2036	413212	7	NO	2022-08-19 10:10:51
11089	-982	2036	413213	2	NO	2022-08-19 10:10:51
11090	-982	2036	413214	1	NO	2022-08-19 10:10:51
11091	-982	2036	413217	2	NO	2022-08-19 10:10:51
11092	-982	2036	413218	3	NO	2022-08-19 10:10:51
11093	-982	2036	413219	0	NO	2022-08-19 10:10:51
11094	-982	2036	413220	0	NO	2022-08-19 10:10:51
11095	-982	2036	413221	4	NO	2022-08-19 10:10:51
11096	-982	2036	413222	0	NO	2022-08-19 10:10:51
11097	-982	2036	413223	0	NO	2022-08-19 10:10:51
11098	-982	2036	413225	0	NO	2022-08-19 10:10:51
11099	-982	2036	413226	7	NO	2022-08-19 10:10:51
11100	-982	2036	413227	0	NO	2022-08-19 10:10:51
11101	-982	2036	413228	0	NO	2022-08-19 10:10:51
11102	-982	2036	413230	0	NO	2022-08-19 10:10:51
11103	-982	2036	413235	0	NO	2022-08-19 10:10:51
11104	-982	2036	413236	0	NO	2022-08-19 10:10:51
11105	-982	2036	413237	0	NO	2022-08-19 10:10:51
11106	-982	2036	413238	0	NO	2022-08-19 10:10:51
11107	-982	2036	419832	1	NO	2022-08-19 10:10:51
11108	-982	2036	419833	3	NO	2022-08-19 10:10:51
11109	-982	2036	419834	2	NO	2022-08-19 10:10:51
11110	-982	2036	419837	4	NO	2022-08-19 10:10:51
11111	-1053	2049	416511	0	NO	2022-09-08 11:55:02
11112	-1053	2049	416513	0	SI	2022-09-08 11:55:02
11113	-1053	2049	416514	2	SI	2022-09-08 11:55:02
11114	-1053	2049	416515	0	SI	2022-09-08 11:55:02
11115	-1053	2049	416516	0	SI	2022-09-08 11:55:02
11116	-1053	2049	416517	5	SI	2022-09-08 11:55:02
11117	-1053	2049	416518	0	NO	2022-09-08 11:55:02
11118	-1053	2049	416519	0	NO	2022-09-08 11:55:02
11119	-1053	2049	416520	5	SI	2022-09-08 11:55:02
11120	-1053	2049	416521	0	SI	2022-09-08 11:55:02
11121	-1053	2049	416522	8	NO	2022-09-08 11:55:02
11122	-1053	2049	416537	0	SI	2022-09-08 11:55:02
11123	-1053	2049	416538	0	SI	2022-09-08 11:55:02
11124	-1053	2049	416539	0	SI	2022-09-08 11:55:02
11125	-1053	2049	416540	0	SI	2022-09-08 11:55:02
11126	-1053	2049	416541	0	SI	2022-09-08 11:55:02
11127	-1053	2049	416542	5	SI	2022-09-08 11:55:02
11128	-1053	2049	416543	0	SI	2022-09-08 11:55:02
11129	-1053	2049	416544	8	NO	2022-09-08 11:55:02
11130	-1053	2049	416558	0	SI	2022-09-08 11:55:02
11131	-1053	2049	416559	0	SI	2022-09-08 11:55:02
11132	-1053	2049	416560	0	SI	2022-09-08 11:55:02
11133	-1053	2049	416561	0	SI	2022-09-08 11:55:02
11134	-1053	2049	416562	0	SI	2022-09-08 11:55:02
11135	-1053	2049	416563	0	SI	2022-09-08 11:55:02
11136	-1053	2049	416564	0	NO	2022-09-08 11:55:02
11137	-1053	2049	416565	0	NO	2022-09-08 11:55:02
11138	-1053	2049	416567	0	NO	2022-09-08 11:55:02
11139	-1053	2049	416568	0	SI	2022-09-08 11:55:02
11140	-1053	2049	416569	0	SI	2022-09-08 11:55:02
11141	-1053	2049	416570	0	SI	2022-09-08 11:55:02
11142	-1053	2049	416571	0	NO	2022-09-08 11:55:02
11143	-1053	2049	416572	1	SI	2022-09-08 11:55:02
11144	-1053	2049	416573	0	SI	2022-09-08 11:55:02
11145	-1053	2049	416574	3	SI	2022-09-08 11:55:02
11146	-1053	2049	416575	0	NO	2022-09-08 11:55:02
11147	-1053	2049	416576	1	SI	2022-09-08 11:55:02
11148	-1053	2049	416577	0	SI	2022-09-08 11:55:02
11149	-1053	2049	416578	0	SI	2022-09-08 11:55:02
11150	-1053	2049	416579	0	SI	2022-09-08 11:55:02
11151	-1053	2049	416580	0	SI	2022-09-08 11:55:02
11152	-1053	2049	416581	3	NO	2022-09-08 11:55:02
11153	-1053	2049	416582	2	NO	2022-09-08 11:55:02
11154	-1053	2049	416583	0	SI	2022-09-08 11:55:02
11155	-1053	2049	416584	0	SI	2022-09-08 11:55:02
11156	-1053	2049	416585	0	SI	2022-09-08 11:55:02
11157	-1053	2049	416586	3	SI	2022-09-08 11:55:02
11158	-1053	2049	416587	0	SI	2022-09-08 11:55:02
11159	-1053	2049	416588	0	NO	2022-09-08 11:55:02
11160	-1053	2049	416589	0	SI	2022-09-08 11:55:02
11161	-1053	2049	416590	0	SI	2022-09-08 11:55:02
11162	-1053	2049	416591	0	NO	2022-09-08 11:55:02
11163	-1053	2049	416592	20	NO	2022-09-08 11:55:02
11164	-1053	2049	416594	0	SI	2022-09-08 11:55:02
11165	-1053	2049	416595	0	SI	2022-09-08 11:55:02
11166	-1053	2049	416596	0	SI	2022-09-08 11:55:02
11167	-1053	2049	416597	0	SI	2022-09-08 11:55:02
11168	-1053	2049	416598	4	SI	2022-09-08 11:55:02
11169	-1053	2049	416599	0	SI	2022-09-08 11:55:02
11170	-1053	2049	416600	0	NO	2022-09-08 11:55:02
11171	-1053	2049	416602	7	SI	2022-09-08 11:55:02
11172	-1053	2049	416603	0	SI	2022-09-08 11:55:02
11173	-1053	2049	416604	0	SI	2022-09-08 11:55:02
11174	-1053	2049	416605	0	NO	2022-09-08 11:55:02
11175	-1053	2049	416606	3	NO	2022-09-08 11:55:02
11176	-1053	2049	416607	0	NO	2022-09-08 11:55:02
11178	-1053	2049	416610	1	SI	2022-09-08 11:55:02
11180	-1053	2049	416612	0	SI	2022-09-08 11:55:02
11182	-1053	2049	416614	0	NO	2022-09-08 11:55:02
11184	-1053	2049	416617	0	NO	2022-09-08 11:55:02
11186	-1053	2049	416620	0	NO	2022-09-08 11:55:02
11188	-1053	2049	416622	0	SI	2022-09-08 11:55:02
11190	-1053	2049	416624	0	NO	2022-09-08 11:55:02
11192	-1053	2049	416626	0	SI	2022-09-08 11:55:02
11194	-1053	2049	416628	0	NO	2022-09-08 11:55:02
11196	-1053	2049	416631	0	NO	2022-09-08 11:55:02
11198	-1053	2049	416633	0	NO	2022-09-08 11:55:02
11200	-1053	2049	416635	0	NO	2022-09-08 11:55:02
11202	-1053	2049	416637	0	NO	2022-09-08 11:55:02
11204	-1053	2049	416639	0	SI	2022-09-08 11:55:02
11206	-1053	2049	416641	0	NO	2022-09-08 11:55:02
11208	-1053	2049	416643	0	NO	2022-09-08 11:55:02
11210	-1053	2049	416645	0	NO	2022-09-08 11:55:02
11212	-1053	2049	416648	0	SI	2022-09-08 11:55:02
11214	-1053	2049	416650	0	SI	2022-09-08 11:55:02
11216	-1053	2049	416652	1	SI	2022-09-08 11:55:02
11218	-1053	2049	416655	0	SI	2022-09-08 11:55:02
11220	-1053	2049	416657	0	SI	2022-09-08 11:55:02
11222	-1053	2049	416659	0	SI	2022-09-08 11:55:02
11224	-1053	2049	416661	0	SI	2022-09-08 11:55:02
11226	-1053	2049	416663	0	SI	2022-09-08 11:55:02
11228	-1053	2049	416665	0	SI	2022-09-08 11:55:02
11230	-1053	2049	416667	0	SI	2022-09-08 11:55:02
11232	-1053	2049	416669	2	NO	2022-09-08 11:55:02
11234	-1053	2049	416672	0	SI	2022-09-08 11:55:02
11236	-1053	2049	416674	3	NO	2022-09-08 11:55:02
11238	-1053	2049	416676	0	SI	2022-09-08 11:55:02
11240	-1053	2049	416679	0	NO	2022-09-08 11:55:02
11242	-1053	2049	416681	0	SI	2022-09-08 11:55:02
11244	-1053	2049	416683	2	NO	2022-09-08 11:55:02
11246	-1053	2049	416685	0	SI	2022-09-08 11:55:02
11248	-1053	2049	416688	0	SI	2022-09-08 11:55:02
11250	-1053	2049	416690	0	SI	2022-09-08 11:55:02
11252	-1053	2049	416692	0	SI	2022-09-08 11:55:02
11254	-1053	2049	416694	0	SI	2022-09-08 11:55:02
11256	-1053	2049	416696	0	NO	2022-09-08 11:55:02
11258	-1053	2049	416698	0	NO	2022-09-08 11:55:02
11260	-1053	2049	416701	0	NO	2022-09-08 11:55:02
11262	-1053	2049	416703	0	NO	2022-09-08 11:55:02
11264	-1053	2049	416705	0	NO	2022-09-08 11:55:02
11266	-1053	2049	416707	0	NO	2022-09-08 11:55:02
11268	-1053	2049	416709	0	NO	2022-09-08 11:55:02
11270	-1053	2049	416711	0	SI	2022-09-08 11:55:02
11272	-1053	2049	416713	17	NO	2022-09-08 11:55:02
11274	-1053	2049	416715	0	SI	2022-09-08 11:55:02
11276	-1053	2049	416717	4	NO	2022-09-08 11:55:02
11278	-1053	2049	416720	0	NO	2022-09-08 11:55:02
11280	-1053	2049	416722	0	NO	2022-09-08 11:55:02
11177	-1053	2049	416608	5	NO	2022-09-08 11:55:02
11179	-1053	2049	416611	0	SI	2022-09-08 11:55:02
11181	-1053	2049	416613	0	NO	2022-09-08 11:55:02
11183	-1053	2049	416615	0	NO	2022-09-08 11:55:02
11185	-1053	2049	416618	0	NO	2022-09-08 11:55:02
11187	-1053	2049	416621	0	SI	2022-09-08 11:55:02
11189	-1053	2049	416623	0	SI	2022-09-08 11:55:02
11191	-1053	2049	416625	0	SI	2022-09-08 11:55:02
11193	-1053	2049	416627	0	NO	2022-09-08 11:55:02
11195	-1053	2049	416630	0	NO	2022-09-08 11:55:02
11197	-1053	2049	416632	0	SI	2022-09-08 11:55:02
11199	-1053	2049	416634	0	NO	2022-09-08 11:55:02
11201	-1053	2049	416636	0	NO	2022-09-08 11:55:02
11203	-1053	2049	416638	0	SI	2022-09-08 11:55:02
11205	-1053	2049	416640	0	NO	2022-09-08 11:55:02
11207	-1053	2049	416642	0	NO	2022-09-08 11:55:02
11209	-1053	2049	416644	0	NO	2022-09-08 11:55:02
11211	-1053	2049	416647	0	SI	2022-09-08 11:55:02
11213	-1053	2049	416649	0	NO	2022-09-08 11:55:02
11215	-1053	2049	416651	0	SI	2022-09-08 11:55:02
11217	-1053	2049	416653	0	SI	2022-09-08 11:55:02
11219	-1053	2049	416656	0	SI	2022-09-08 11:55:02
11221	-1053	2049	416658	0	SI	2022-09-08 11:55:02
11223	-1053	2049	416660	5	SI	2022-09-08 11:55:02
11225	-1053	2049	416662	0	SI	2022-09-08 11:55:02
11227	-1053	2049	416664	0	SI	2022-09-08 11:55:02
11229	-1053	2049	416666	2	SI	2022-09-08 11:55:02
11231	-1053	2049	416668	1	SI	2022-09-08 11:55:02
11233	-1053	2049	416670	1	NO	2022-09-08 11:55:02
11235	-1053	2049	416673	0	SI	2022-09-08 11:55:02
11237	-1053	2049	416675	3	NO	2022-09-08 11:55:02
11239	-1053	2049	416678	0	SI	2022-09-08 11:55:02
11241	-1053	2049	416680	0	SI	2022-09-08 11:55:02
11243	-1053	2049	416682	0	SI	2022-09-08 11:55:02
11245	-1053	2049	416684	0	SI	2022-09-08 11:55:02
11247	-1053	2049	416686	0	SI	2022-09-08 11:55:02
11249	-1053	2049	416689	0	SI	2022-09-08 11:55:02
11251	-1053	2049	416691	0	SI	2022-09-08 11:55:02
11253	-1053	2049	416693	0	SI	2022-09-08 11:55:02
11255	-1053	2049	416695	0	NO	2022-09-08 11:55:02
11257	-1053	2049	416697	0	SI	2022-09-08 11:55:02
11259	-1053	2049	416699	0	NO	2022-09-08 11:55:02
11261	-1053	2049	416702	20	SI	2022-09-08 11:55:02
11263	-1053	2049	416704	0	NO	2022-09-08 11:55:02
11265	-1053	2049	416706	0	SI	2022-09-08 11:55:02
11267	-1053	2049	416708	13	SI	2022-09-08 11:55:02
11269	-1053	2049	416710	25	SI	2022-09-08 11:55:02
11271	-1053	2049	416712	0	NO	2022-09-08 11:55:02
11273	-1053	2049	416714	0	NO	2022-09-08 11:55:02
11275	-1053	2049	416716	2	NO	2022-09-08 11:55:02
11277	-1053	2049	416719	0	NO	2022-09-08 11:55:02
11279	-1053	2049	416721	0	NO	2022-09-08 11:55:02
11281	-1053	2049	416723	0	NO	2022-09-08 11:55:02
11282	-1089	2046	415898	0	SI	2022-09-24 13:01:22
11283	-1089	2046	415899	1	SI	2022-09-24 13:01:22
11284	-1089	2046	415900	0	SI	2022-09-24 13:01:22
11285	-1089	2046	415901	0	SI	2022-09-24 13:01:22
11286	-1089	2046	415902	2	SI	2022-09-24 13:01:22
11287	-1089	2046	415903	0	NO	2022-09-24 13:01:22
11288	-1089	2046	415904	0	NO	2022-09-24 13:01:22
11289	-1089	2046	415905	1	SI	2022-09-24 13:01:22
11290	-1089	2046	415906	0	SI	2022-09-24 13:01:22
11291	-1089	2046	415907	0	SI	2022-09-24 13:01:22
11292	-1089	2046	415908	0	SI	2022-09-24 13:01:22
11293	-1089	2046	415909	1	NO	2022-09-24 13:01:22
11294	-1089	2046	415910	1	SI	2022-09-24 13:01:22
11295	-1089	2046	415911	0	NO	2022-09-24 13:01:22
11296	-1089	2046	415912	0	NO	2022-09-24 13:01:22
11297	-1089	2046	415913	0	SI	2022-09-24 13:01:22
11298	-1089	2046	415914	2	SI	2022-09-24 13:01:22
11299	-1089	2046	415915	2	SI	2022-09-24 13:01:22
11300	-1089	2046	415916	1	NO	2022-09-24 13:01:22
11301	-1089	2046	415917	0	SI	2022-09-24 13:01:22
11302	-1089	2046	415918	1	NO	2022-09-24 13:01:22
11303	-1089	2046	415919	0	SI	2022-09-24 13:01:22
11304	-1089	2046	415920	0	SI	2022-09-24 13:01:22
11305	-1089	2046	415921	1	NO	2022-09-24 13:01:22
11306	-1089	2046	415922	0	SI	2022-09-24 13:01:22
11307	-1089	2046	415923	1	SI	2022-09-24 13:01:22
11308	-1089	2046	415924	0	SI	2022-09-24 13:01:22
11309	-1089	2046	415925	3	NO	2022-09-24 13:01:22
11310	-1089	2046	415936	0	SI	2022-09-24 13:01:22
11311	-1089	2046	415937	0	SI	2022-09-24 13:01:22
11312	-1089	2046	415938	1	NO	2022-09-24 13:01:22
11313	-1089	2046	415939	0	SI	2022-09-24 13:01:22
11314	-1089	2046	415940	0	SI	2022-09-24 13:01:22
11315	-1089	2046	415941	0	NO	2022-09-24 13:01:22
11316	-1089	2046	415942	0	SI	2022-09-24 13:01:22
11317	-1089	2046	415943	0	SI	2022-09-24 13:01:22
11318	-1089	2046	415944	1	NO	2022-09-24 13:01:22
11319	-1089	2046	415945	0	SI	2022-09-24 13:01:22
11320	-1089	2046	415946	0	SI	2022-09-24 13:01:22
11321	-1089	2046	415947	4	NO	2022-09-24 13:01:22
11322	-1089	2046	415948	0	NO	2022-09-24 13:01:22
11323	-1089	2046	415949	1	SI	2022-09-24 13:01:22
11324	-1089	2046	415950	0	SI	2022-09-24 13:01:22
11325	-1089	2046	415951	0	NO	2022-09-24 13:01:22
11326	-1089	2046	415952	0	NO	2022-09-24 13:01:22
11327	-1089	2046	415953	0	NO	2022-09-24 13:01:22
11328	-1089	2046	415956	3	NO	2022-09-24 13:01:22
11329	-1089	2046	415957	0	SI	2022-09-24 13:01:22
11330	-1089	2046	415958	0	SI	2022-09-24 13:01:22
11331	-1089	2046	415959	1	NO	2022-09-24 13:01:22
11332	-1089	2046	415960	3	SI	2022-09-24 13:01:22
11333	-1089	2046	415961	0	SI	2022-09-24 13:01:22
11334	-1089	2046	415962	0	NO	2022-09-24 13:01:22
11335	-1089	2046	415963	0	SI	2022-09-24 13:01:22
11336	-1089	2046	415964	0	SI	2022-09-24 13:01:22
11338	-1089	2046	415966	0	SI	2022-09-24 13:01:22
11340	-1089	2046	415970	0	NO	2022-09-24 13:01:22
11342	-1089	2046	415973	0	SI	2022-09-24 13:01:22
11344	-1089	2046	415975	0	NO	2022-09-24 13:01:22
11346	-1089	2046	415977	0	NO	2022-09-24 13:01:22
11348	-1089	2046	415985	0	SI	2022-09-24 13:01:22
11350	-1089	2046	415995	0	NO	2022-09-24 13:01:22
11352	-1089	2046	415997	0	SI	2022-09-24 13:01:22
11354	-1089	2046	415999	0	NO	2022-09-24 13:01:22
11356	-1089	2046	416001	0	NO	2022-09-24 13:01:22
11358	-1089	2046	416003	0	NO	2022-09-24 13:01:22
11360	-1089	2046	416005	0	NO	2022-09-24 13:01:22
11362	-1089	2046	416007	0	NO	2022-09-24 13:01:22
11364	-1089	2046	416009	0	NO	2022-09-24 13:01:22
11366	-1089	2046	416014	3	NO	2022-09-24 13:01:22
11368	-1089	2046	416017	0	SI	2022-09-24 13:01:22
11370	-1089	2046	416019	0	NO	2022-09-24 13:01:22
11372	-1089	2046	416021	0	SI	2022-09-24 13:01:22
11374	-1089	2046	416023	0	SI	2022-09-24 13:01:22
11376	-1089	2046	416026	0	SI	2022-09-24 13:01:22
11378	-1089	2046	416028	0	SI	2022-09-24 13:01:22
11380	-1089	2046	416030	2	SI	2022-09-24 13:01:22
11382	-1089	2046	416032	0	SI	2022-09-24 13:01:22
11384	-1089	2046	416034	0	SI	2022-09-24 13:01:22
11386	-1089	2046	416036	0	NO	2022-09-24 13:01:22
11388	-1089	2046	416038	0	SI	2022-09-24 13:01:22
11390	-1089	2046	416040	0	NO	2022-09-24 13:01:22
11392	-1089	2046	416043	0	SI	2022-09-24 13:01:22
11394	-1089	2046	416045	1	NO	2022-09-24 13:01:22
11396	-1089	2046	416048	0	NO	2022-09-24 13:01:22
11398	-1089	2046	416050	0	SI	2022-09-24 13:01:22
11400	-1089	2046	416052	0	SI	2022-09-24 13:01:22
11402	-1089	2046	416055	0	NO	2022-09-24 13:01:22
11404	-1089	2046	416057	4	NO	2022-09-24 13:01:22
11406	-1089	2046	416065	0	SI	2022-09-24 13:01:22
11408	-1089	2046	416067	0	SI	2022-09-24 13:01:22
11410	-1089	2046	416069	0	NO	2022-09-24 13:01:22
11412	-1089	2046	416071	0	NO	2022-09-24 13:01:22
11414	-1089	2046	416074	0	NO	2022-09-24 13:01:22
11416	-1089	2046	416076	0	NO	2022-09-24 13:01:22
11418	-1089	2046	416078	0	NO	2022-09-24 13:01:22
11420	-1089	2046	416085	0	NO	2022-09-24 13:01:22
11422	-1089	2046	416087	0	NO	2022-09-24 13:01:22
11424	-1089	2046	419806	0	SI	2022-09-24 13:01:22
11426	-1089	2046	419808	0	SI	2022-09-24 13:01:22
11337	-1089	2046	415965	0	SI	2022-09-24 13:01:22
11339	-1089	2046	415967	4	NO	2022-09-24 13:01:22
11341	-1089	2046	415972	0	SI	2022-09-24 13:01:22
11343	-1089	2046	415974	0	NO	2022-09-24 13:01:22
11345	-1089	2046	415976	4	NO	2022-09-24 13:01:22
11347	-1089	2046	415984	3	SI	2022-09-24 13:01:22
11349	-1089	2046	415986	5	NO	2022-09-24 13:01:22
11351	-1089	2046	415996	0	NO	2022-09-24 13:01:22
11353	-1089	2046	415998	0	NO	2022-09-24 13:01:22
11355	-1089	2046	416000	0	NO	2022-09-24 13:01:22
11357	-1089	2046	416002	0	SI	2022-09-24 13:01:22
11359	-1089	2046	416004	4	SI	2022-09-24 13:01:22
11361	-1089	2046	416006	0	NO	2022-09-24 13:01:22
11363	-1089	2046	416008	0	NO	2022-09-24 13:01:22
11365	-1089	2046	416013	0	NO	2022-09-24 13:01:22
11367	-1089	2046	416015	0	SI	2022-09-24 13:01:22
11369	-1089	2046	416018	0	SI	2022-09-24 13:01:22
11371	-1089	2046	416020	0	SI	2022-09-24 13:01:22
11373	-1089	2046	416022	1	SI	2022-09-24 13:01:22
11375	-1089	2046	416025	17	SI	2022-09-24 13:01:22
11377	-1089	2046	416027	0	SI	2022-09-24 13:01:22
11379	-1089	2046	416029	0	SI	2022-09-24 13:01:22
11381	-1089	2046	416031	0	SI	2022-09-24 13:01:22
11383	-1089	2046	416033	0	SI	2022-09-24 13:01:22
11385	-1089	2046	416035	1	NO	2022-09-24 13:01:22
11387	-1089	2046	416037	0	SI	2022-09-24 13:01:22
11389	-1089	2046	416039	0	SI	2022-09-24 13:01:22
11391	-1089	2046	416042	0	SI	2022-09-24 13:01:22
11393	-1089	2046	416044	1	NO	2022-09-24 13:01:22
11395	-1089	2046	416046	0	SI	2022-09-24 13:01:22
11397	-1089	2046	416049	0	SI	2022-09-24 13:01:22
11399	-1089	2046	416051	0	SI	2022-09-24 13:01:22
11401	-1089	2046	416054	0	SI	2022-09-24 13:01:22
11403	-1089	2046	416056	0	SI	2022-09-24 13:01:22
11405	-1089	2046	416064	0	SI	2022-09-24 13:01:22
11407	-1089	2046	416066	0	SI	2022-09-24 13:01:22
11409	-1089	2046	416068	0	NO	2022-09-24 13:01:22
11411	-1089	2046	416070	0	SI	2022-09-24 13:01:22
11413	-1089	2046	416073	8	SI	2022-09-24 13:01:22
11415	-1089	2046	416075	0	NO	2022-09-24 13:01:22
11417	-1089	2046	416077	0	SI	2022-09-24 13:01:22
11419	-1089	2046	416079	0	NO	2022-09-24 13:01:22
11421	-1089	2046	416086	0	NO	2022-09-24 13:01:22
11423	-1089	2046	416088	0	NO	2022-09-24 13:01:22
11425	-1089	2046	419807	0	SI	2022-09-24 13:01:22
11427	-1113	2046	415898	3	NO	2022-10-12 15:31:33
11428	-1113	2046	415899	1	SI	2022-10-12 15:31:33
11429	-1113	2046	415900	0	SI	2022-10-12 15:31:33
11430	-1113	2046	415901	0	SI	2022-10-12 15:31:33
11431	-1113	2046	415902	2	SI	2022-10-12 15:31:33
11432	-1113	2046	415903	0	NO	2022-10-12 15:31:33
11433	-1113	2046	415904	0	NO	2022-10-12 15:31:33
11434	-1113	2046	415905	1	SI	2022-10-12 15:31:33
11435	-1113	2046	415906	0	SI	2022-10-12 15:31:33
11436	-1113	2046	415907	0	SI	2022-10-12 15:31:33
11437	-1113	2046	415908	0	SI	2022-10-12 15:31:33
11438	-1113	2046	415909	1	NO	2022-10-12 15:31:33
11439	-1113	2046	415910	0	NO	2022-10-12 15:31:33
11440	-1113	2046	415911	0	NO	2022-10-12 15:31:33
11441	-1113	2046	415912	0	NO	2022-10-12 15:31:33
11442	-1113	2046	415913	0	SI	2022-10-12 15:31:33
11443	-1113	2046	415914	0	NO	2022-10-12 15:31:33
11444	-1113	2046	415915	0	NO	2022-10-12 15:31:33
11445	-1113	2046	415916	0	SI	2022-10-12 15:31:33
11446	-1113	2046	415917	0	SI	2022-10-12 15:31:33
11447	-1113	2046	415918	1	NO	2022-10-12 15:31:33
11448	-1113	2046	415919	0	SI	2022-10-12 15:31:33
11449	-1113	2046	415920	0	SI	2022-10-12 15:31:33
11450	-1113	2046	415921	1	NO	2022-10-12 15:31:33
11451	-1113	2046	415922	0	SI	2022-10-12 15:31:33
11452	-1113	2046	415923	1	SI	2022-10-12 15:31:33
11453	-1113	2046	415924	0	SI	2022-10-12 15:31:33
11454	-1113	2046	415925	0	SI	2022-10-12 15:31:33
11455	-1113	2046	415926	0	SI	2022-10-12 15:31:33
11456	-1113	2046	415927	1	NO	2022-10-12 15:31:33
11457	-1113	2046	415928	0	NO	2022-10-12 15:31:33
11458	-1113	2046	415929	0	NO	2022-10-12 15:31:33
11459	-1113	2046	415930	0	NO	2022-10-12 15:31:33
11460	-1113	2046	415931	0	NO	2022-10-12 15:31:33
11461	-1113	2046	415932	0	NO	2022-10-12 15:31:33
11462	-1113	2046	415933	2	NO	2022-10-12 15:31:33
11463	-1113	2046	415934	0	SI	2022-10-12 15:31:33
11464	-1113	2046	415935	0	SI	2022-10-12 15:31:33
11465	-1113	2046	415936	0	SI	2022-10-12 15:31:33
11466	-1113	2046	415937	0	SI	2022-10-12 15:31:33
11467	-1113	2046	415938	1	NO	2022-10-12 15:31:33
11468	-1113	2046	415939	0	SI	2022-10-12 15:31:33
11469	-1113	2046	415940	8	NO	2022-10-12 15:31:33
11470	-1113	2046	415941	7	SI	2022-10-12 15:31:33
11471	-1113	2046	415942	0	SI	2022-10-12 15:31:33
11472	-1113	2046	415943	0	SI	2022-10-12 15:31:33
11473	-1113	2046	415944	0	SI	2022-10-12 15:31:33
11474	-1113	2046	415945	0	SI	2022-10-12 15:31:33
11475	-1113	2046	415946	0	SI	2022-10-12 15:31:33
11476	-1113	2046	415947	0	SI	2022-10-12 15:31:33
11477	-1113	2046	415948	0	NO	2022-10-12 15:31:33
11478	-1113	2046	415949	0	NO	2022-10-12 15:31:33
11479	-1113	2046	415953	0	NO	2022-10-12 15:31:33
11480	-1113	2046	415956	3	NO	2022-10-12 15:31:33
11481	-1113	2046	415957	0	SI	2022-10-12 15:31:33
11482	-1113	2046	415958	0	SI	2022-10-12 15:31:33
11483	-1113	2046	415959	0	SI	2022-10-12 15:31:33
11484	-1113	2046	415960	3	SI	2022-10-12 15:31:33
11485	-1113	2046	415961	0	SI	2022-10-12 15:31:33
11486	-1113	2046	415962	0	NO	2022-10-12 15:31:33
11487	-1113	2046	415963	0	SI	2022-10-12 15:31:33
11488	-1113	2046	415964	0	SI	2022-10-12 15:31:33
11489	-1113	2046	415965	0	SI	2022-10-12 15:31:33
11490	-1113	2046	415966	0	SI	2022-10-12 15:31:33
11491	-1113	2046	415967	0	SI	2022-10-12 15:31:33
11492	-1113	2046	415968	3	SI	2022-10-12 15:31:33
11493	-1113	2046	415969	0	SI	2022-10-12 15:31:33
11494	-1113	2046	415970	0	NO	2022-10-12 15:31:33
11495	-1113	2046	415972	0	SI	2022-10-12 15:31:33
11496	-1113	2046	415973	0	SI	2022-10-12 15:31:33
11497	-1113	2046	415974	0	NO	2022-10-12 15:31:33
11498	-1113	2046	415975	4	SI	2022-10-12 15:31:33
11499	-1113	2046	415976	4	NO	2022-10-12 15:31:33
11500	-1113	2046	415977	0	NO	2022-10-12 15:31:33
11501	-1113	2046	415984	0	NO	2022-10-12 15:31:33
11502	-1113	2046	415986	5	NO	2022-10-12 15:31:33
11503	-1113	2046	415995	0	NO	2022-10-12 15:31:33
11504	-1113	2046	415996	0	NO	2022-10-12 15:31:33
11505	-1113	2046	415997	0	SI	2022-10-12 15:31:33
11506	-1113	2046	415998	20	SI	2022-10-12 15:31:33
11507	-1113	2046	415999	0	NO	2022-10-12 15:31:33
11508	-1113	2046	416000	0	NO	2022-10-12 15:31:33
11509	-1113	2046	416001	0	NO	2022-10-12 15:31:33
11510	-1113	2046	416002	0	SI	2022-10-12 15:31:33
11511	-1113	2046	416003	0	NO	2022-10-12 15:31:33
11512	-1113	2046	416004	0	NO	2022-10-12 15:31:33
11513	-1113	2046	416005	0	NO	2022-10-12 15:31:33
11514	-1113	2046	416006	0	NO	2022-10-12 15:31:33
11515	-1113	2046	416007	0	NO	2022-10-12 15:31:33
11516	-1113	2046	416008	0	NO	2022-10-12 15:31:33
11517	-1113	2046	416009	0	NO	2022-10-12 15:31:33
11518	-1113	2046	416013	0	NO	2022-10-12 15:31:33
11519	-1113	2046	416014	0	SI	2022-10-12 15:31:33
11520	-1113	2046	416015	0	SI	2022-10-12 15:31:33
11521	-1113	2046	416017	0	SI	2022-10-12 15:31:33
11522	-1113	2046	416018	0	SI	2022-10-12 15:31:33
11523	-1113	2046	416019	0	NO	2022-10-12 15:31:33
11524	-1113	2046	416020	0	SI	2022-10-12 15:31:33
11525	-1113	2046	416021	0	SI	2022-10-12 15:31:33
11526	-1113	2046	416022	1	SI	2022-10-12 15:31:33
11527	-1113	2046	416023	4	NO	2022-10-12 15:31:33
11528	-1113	2046	416025	0	NO	2022-10-12 15:31:33
11529	-1113	2046	416026	0	SI	2022-10-12 15:31:33
11530	-1113	2046	416027	0	SI	2022-10-12 15:31:33
11531	-1113	2046	416028	0	SI	2022-10-12 15:31:33
11532	-1113	2046	416029	2	NO	2022-10-12 15:31:33
11533	-1113	2046	416030	2	SI	2022-10-12 15:31:33
11534	-1113	2046	416031	0	SI	2022-10-12 15:31:33
11535	-1113	2046	416032	0	SI	2022-10-12 15:31:33
11536	-1113	2046	416033	0	SI	2022-10-12 15:31:33
11537	-1113	2046	416034	0	SI	2022-10-12 15:31:33
11538	-1113	2046	416035	0	SI	2022-10-12 15:31:33
11539	-1113	2046	416036	0	NO	2022-10-12 15:31:33
11540	-1113	2046	416037	0	SI	2022-10-12 15:31:33
11541	-1113	2046	416038	0	SI	2022-10-12 15:31:33
11542	-1113	2046	416039	0	SI	2022-10-12 15:31:33
11543	-1113	2046	416040	0	SI	2022-10-12 15:31:33
11544	-1113	2046	416041	0	SI	2022-10-12 15:31:33
11545	-1113	2046	416042	0	SI	2022-10-12 15:31:33
11546	-1113	2046	416043	0	SI	2022-10-12 15:31:33
11547	-1113	2046	416044	0	SI	2022-10-12 15:31:33
11548	-1113	2046	416045	1	NO	2022-10-12 15:31:33
11549	-1113	2046	416046	0	SI	2022-10-12 15:31:33
11550	-1113	2046	416048	0	NO	2022-10-12 15:31:33
11551	-1113	2046	416049	0	SI	2022-10-12 15:31:33
11552	-1113	2046	416050	0	SI	2022-10-12 15:31:33
11553	-1113	2046	416051	0	SI	2022-10-12 15:31:33
11554	-1113	2046	416052	2	NO	2022-10-12 15:31:33
11555	-1113	2046	416054	0	SI	2022-10-12 15:31:33
11556	-1113	2046	416055	2	SI	2022-10-12 15:31:33
11557	-1113	2046	416056	2	NO	2022-10-12 15:31:33
11558	-1113	2046	416057	0	SI	2022-10-12 15:31:33
11559	-1113	2046	416058	0	SI	2022-10-12 15:31:33
11560	-1113	2046	416059	0	SI	2022-10-12 15:31:33
11561	-1113	2046	416060	0	SI	2022-10-12 15:31:33
11562	-1113	2046	416061	0	SI	2022-10-12 15:31:33
11563	-1113	2046	416062	0	SI	2022-10-12 15:31:33
11564	-1113	2046	416064	0	SI	2022-10-12 15:31:33
11565	-1113	2046	416065	3	NO	2022-10-12 15:31:33
11566	-1113	2046	416066	0	SI	2022-10-12 15:31:33
11567	-1113	2046	416067	0	SI	2022-10-12 15:31:33
11568	-1113	2046	416068	0	NO	2022-10-12 15:31:33
11569	-1113	2046	416069	0	NO	2022-10-12 15:31:33
11570	-1113	2046	416070	0	SI	2022-10-12 15:31:33
11571	-1113	2046	416071	0	NO	2022-10-12 15:31:33
11572	-1113	2046	416073	8	SI	2022-10-12 15:31:33
11573	-1113	2046	416074	0	NO	2022-10-12 15:31:33
11574	-1113	2046	416075	0	NO	2022-10-12 15:31:33
11575	-1113	2046	416076	0	NO	2022-10-12 15:31:33
11576	-1113	2046	416077	0	SI	2022-10-12 15:31:33
11577	-1113	2046	416078	0	NO	2022-10-12 15:31:33
11578	-1113	2046	416079	0	NO	2022-10-12 15:31:33
11579	-1113	2046	416085	0	NO	2022-10-12 15:31:33
11580	-1113	2046	416086	0	NO	2022-10-12 15:31:33
11581	-1113	2046	416087	0	NO	2022-10-12 15:31:33
11582	-1113	2046	416088	0	NO	2022-10-12 15:31:33
11583	-1113	2046	419806	0	SI	2022-10-12 15:31:33
11584	-1113	2046	419807	0	SI	2022-10-12 15:31:33
11585	-1113	2046	419808	8	NO	2022-10-12 15:31:33
11586	-1142	2034	412761	0	SI	2022-10-31 11:28:27
11587	-1142	2034	412767	1	NO	2022-10-31 11:28:27
11588	-1142	2034	412768	1	SI	2022-10-31 11:28:27
11589	-1142	2034	412769	0	SI	2022-10-31 11:28:27
11590	-1142	2034	412770	4	SI	2022-10-31 11:28:27
11591	-1142	2034	412771	0	SI	2022-10-31 11:28:27
11592	-1142	2034	412772	0	SI	2022-10-31 11:28:27
11593	-1142	2034	412773	0	SI	2022-10-31 11:28:27
11594	-1142	2034	412774	0	NO	2022-10-31 11:28:27
11595	-1142	2034	412775	2	NO	2022-10-31 11:28:27
11596	-1142	2034	412776	0	SI	2022-10-31 11:28:27
11597	-1142	2034	412777	0	SI	2022-10-31 11:28:27
11598	-1142	2034	412778	0	SI	2022-10-31 11:28:27
11599	-1142	2034	412779	1	SI	2022-10-31 11:28:27
11600	-1142	2034	412780	0	SI	2022-10-31 11:28:27
11601	-1142	2034	412781	0	SI	2022-10-31 11:28:27
11602	-1142	2034	412782	2	SI	2022-10-31 11:28:27
11603	-1142	2034	412783	2	SI	2022-10-31 11:28:27
11604	-1142	2034	412784	0	NO	2022-10-31 11:28:27
11605	-1142	2034	412785	0	NO	2022-10-31 11:28:27
11606	-1142	2034	412786	15	NO	2022-10-31 11:28:27
11607	-1142	2034	412787	2	NO	2022-10-31 11:28:27
11608	-1142	2034	412800	0	SI	2022-10-31 11:28:27
11609	-1142	2034	412801	0	SI	2022-10-31 11:28:27
11610	-1142	2034	412802	0	SI	2022-10-31 11:28:27
11611	-1142	2034	412803	0	SI	2022-10-31 11:28:27
11612	-1142	2034	412804	0	SI	2022-10-31 11:28:27
11613	-1142	2034	412805	1	SI	2022-10-31 11:28:27
11614	-1142	2034	412806	15	NO	2022-10-31 11:28:27
11615	-1142	2034	412807	2	NO	2022-10-31 11:28:27
11616	-1142	2034	412820	2	NO	2022-10-31 11:28:27
11617	-1142	2034	412825	4	SI	2022-10-31 11:28:27
11618	-1142	2034	412826	15	SI	2022-10-31 11:28:27
11619	-1142	2034	412827	0	NO	2022-10-31 11:28:27
11620	-1142	2034	412829	4	SI	2022-10-31 11:28:27
11621	-1142	2034	412830	2	SI	2022-10-31 11:28:27
11622	-1142	2034	412831	3	SI	2022-10-31 11:28:27
11623	-1142	2034	412832	3	SI	2022-10-31 11:28:27
11624	-1142	2034	412833	0	NO	2022-10-31 11:28:27
11625	-1142	2034	412834	3	SI	2022-10-31 11:28:27
11626	-1142	2034	412835	15	NO	2022-10-31 11:28:27
11627	-1142	2034	412836	4	SI	2022-10-31 11:28:27
11628	-1142	2034	412837	0	SI	2022-10-31 11:28:27
11629	-1142	2034	412838	6	SI	2022-10-31 11:28:27
11630	-1142	2034	412839	10	NO	2022-10-31 11:28:27
11631	-1142	2034	412841	0	SI	2022-10-31 11:28:27
11632	-1142	2034	412842	15	SI	2022-10-31 11:28:27
11633	-1142	2034	412843	20	SI	2022-10-31 11:28:27
11634	-1142	2034	412844	4	SI	2022-10-31 11:28:27
11635	-1142	2034	412845	3	SI	2022-10-31 11:28:27
11636	-1142	2034	412846	0	SI	2022-10-31 11:28:27
11637	-1142	2034	412847	0	SI	2022-10-31 11:28:27
11638	-1142	2034	412848	0	SI	2022-10-31 11:28:27
11639	-1142	2034	412849	2	SI	2022-10-31 11:28:27
11640	-1142	2034	412850	0	NO	2022-10-31 11:28:27
11641	-1142	2034	412851	3	SI	2022-10-31 11:28:27
11642	-1142	2034	412852	12	SI	2022-10-31 11:28:27
11643	-1142	2034	412853	20	SI	2022-10-31 11:28:27
11644	-1142	2034	412854	0	SI	2022-10-31 11:28:27
11645	-1142	2034	412855	4	NO	2022-10-31 11:28:27
11646	-1142	2034	412857	0	SI	2022-10-31 11:28:27
11647	-1142	2034	412858	0	SI	2022-10-31 11:28:27
11648	-1142	2034	412859	2	SI	2022-10-31 11:28:27
11649	-1142	2034	412860	0	SI	2022-10-31 11:28:27
11650	-1142	2034	412862	0	NO	2022-10-31 11:28:27
11651	-1142	2034	412863	0	SI	2022-10-31 11:28:27
11652	-1142	2034	412864	6	NO	2022-10-31 11:28:27
11653	-1142	2034	412867	4	NO	2022-10-31 11:28:27
11654	-1142	2034	412868	0	SI	2022-10-31 11:28:27
11655	-1142	2034	412869	1	NO	2022-10-31 11:28:27
11656	-1142	2034	412870	1	NO	2022-10-31 11:28:27
11657	-1142	2034	412871	0	SI	2022-10-31 11:28:27
11658	-1142	2034	412872	1	SI	2022-10-31 11:28:27
11659	-1142	2034	412873	0	SI	2022-10-31 11:28:27
11660	-1142	2034	412874	1	SI	2022-10-31 11:28:27
11661	-1142	2034	412875	1	NO	2022-10-31 11:28:27
11662	-1142	2034	412876	0	SI	2022-10-31 11:28:27
11663	-1142	2034	412877	2	NO	2022-10-31 11:28:27
11664	-1142	2034	412878	0	SI	2022-10-31 11:28:27
11665	-1142	2034	412879	0	SI	2022-10-31 11:28:27
11666	-1142	2034	412880	0	SI	2022-10-31 11:28:27
11667	-1142	2034	412881	0	SI	2022-10-31 11:28:27
11668	-1142	2034	412882	0	SI	2022-10-31 11:28:27
11669	-1142	2034	412883	0	NO	2022-10-31 11:28:27
11670	-1142	2034	412884	1	NO	2022-10-31 11:28:27
11671	-1142	2034	412886	0	SI	2022-10-31 11:28:27
11672	-1142	2034	412887	1	NO	2022-10-31 11:28:27
11673	-1142	2034	412889	0	SI	2022-10-31 11:28:27
11674	-1142	2034	412890	0	NO	2022-10-31 11:28:27
11675	-1142	2034	412891	0	SI	2022-10-31 11:28:27
11676	-1142	2034	412892	0	SI	2022-10-31 11:28:27
11677	-1142	2034	412893	2	NO	2022-10-31 11:28:27
11678	-1142	2034	412894	1	NO	2022-10-31 11:28:27
11679	-1142	2034	412895	1	NO	2022-10-31 11:28:27
11680	-1142	2034	412896	1	NO	2022-10-31 11:28:27
11681	-1142	2034	412897	1	NO	2022-10-31 11:28:27
11682	-1142	2034	412899	0	SI	2022-10-31 11:28:27
11683	-1142	2034	412900	0	SI	2022-10-31 11:28:27
11684	-1142	2034	412901	0	SI	2022-10-31 11:28:27
11685	-1142	2034	412902	0	SI	2022-10-31 11:28:27
11686	-1142	2034	412903	1	SI	2022-10-31 11:28:27
11687	-1142	2034	412904	3	SI	2022-10-31 11:28:27
11688	-1142	2034	412905	0	SI	2022-10-31 11:28:27
11689	-1142	2034	412906	2	SI	2022-10-31 11:28:27
11690	-1142	2034	412908	0	NO	2022-10-31 11:28:27
11691	-1142	2034	412909	0	NO	2022-10-31 11:28:27
11692	-1142	2034	412910	0	NO	2022-10-31 11:28:27
11693	-1142	2034	412911	0	NO	2022-10-31 11:28:27
11694	-1142	2034	412912	15	NO	2022-10-31 11:28:27
11695	-1142	2034	412914	250	SI	2022-10-31 11:28:27
11696	-1142	2034	412915	25	SI	2022-10-31 11:28:27
11697	-1142	2034	412916	25	SI	2022-10-31 11:28:27
11698	-1142	2034	412917	0	NO	2022-10-31 11:28:27
11699	-1142	2034	419826	0	SI	2022-10-31 11:28:27
11700	-1142	2034	419827	0	NO	2022-10-31 11:28:27
11701	-1142	2034	419828	0	NO	2022-10-31 11:28:27
11702	-1142	2034	419829	1	NO	2022-10-31 11:28:27
11703	-1142	2034	419830	2	NO	2022-10-31 11:28:27
11704	-1260	2042	414640	50	NO	2023-02-13 15:47:51
11705	-1260	2042	414641	6	SI	2023-02-13 15:47:51
11706	-1260	2042	414643	6	NO	2023-02-13 15:47:51
11707	-1260	2042	414644	0	NO	2023-02-13 15:47:51
11708	-1260	2042	414645	7	NO	2023-02-13 15:47:51
11709	-1260	2042	414646	0	SI	2023-02-13 15:47:51
11710	-1260	2042	414647	0	NO	2023-02-13 15:47:51
11711	-1260	2042	414648	5	SI	2023-02-13 15:47:51
11712	-1260	2042	414649	0	NO	2023-02-13 15:47:51
11713	-1260	2042	414650	0	NO	2023-02-13 15:47:51
11714	-1260	2042	414651	22	NO	2023-02-13 15:47:51
11715	-1260	2042	414652	8	NO	2023-02-13 15:47:51
11716	-1260	2042	414667	0	SI	2023-02-13 15:47:51
11717	-1260	2042	414668	4	NO	2023-02-13 15:47:51
11718	-1260	2042	414669	0	SI	2023-02-13 15:47:51
11719	-1260	2042	414670	0	SI	2023-02-13 15:47:51
11720	-1260	2042	414671	0	SI	2023-02-13 15:47:51
11721	-1260	2042	414672	0	NO	2023-02-13 15:47:51
11722	-1260	2042	414673	0	SI	2023-02-13 15:47:51
11723	-1260	2042	414674	8	NO	2023-02-13 15:47:51
11724	-1260	2042	414688	5	NO	2023-02-13 15:47:51
11725	-1260	2042	414693	15	SI	2023-02-13 15:47:51
11726	-1260	2042	414695	0	SI	2023-02-13 15:47:51
11727	-1260	2042	414696	0	SI	2023-02-13 15:47:51
11728	-1260	2042	414697	0	SI	2023-02-13 15:47:51
11729	-1260	2042	414698	4	NO	2023-02-13 15:47:51
11730	-1260	2042	414699	0	SI	2023-02-13 15:47:51
11731	-1260	2042	414700	0	NO	2023-02-13 15:47:51
11732	-1260	2042	414701	0	NO	2023-02-13 15:47:51
11733	-1260	2042	414705	0	NO	2023-02-13 15:47:51
11734	-1260	2042	414708	0	SI	2023-02-13 15:47:51
11735	-1260	2042	414709	13	NO	2023-02-13 15:47:51
11736	-1260	2042	414710	4	NO	2023-02-13 15:47:51
11737	-1260	2042	414711	4	NO	2023-02-13 15:47:51
11738	-1260	2042	414712	3	NO	2023-02-13 15:47:51
11739	-1260	2042	414713	0	SI	2023-02-13 15:47:51
11740	-1260	2042	414714	3	NO	2023-02-13 15:47:51
11741	-1260	2042	414715	3	SI	2023-02-13 15:47:51
11742	-1260	2042	414716	3	NO	2023-02-13 15:47:51
11743	-1260	2042	414717	0	NO	2023-02-13 15:47:51
11744	-1260	2042	414718	5	NO	2023-02-13 15:47:51
11745	-1260	2042	414719	0	SI	2023-02-13 15:47:51
11746	-1260	2042	414720	0	SI	2023-02-13 15:47:51
11747	-1260	2042	414721	0	SI	2023-02-13 15:47:51
11748	-1260	2042	414722	0	SI	2023-02-13 15:47:51
11749	-1260	2042	414723	4	NO	2023-02-13 15:47:51
11750	-1260	2042	414726	0	NO	2023-02-13 15:47:51
11751	-1260	2042	414728	5	SI	2023-02-13 15:47:51
11752	-1260	2042	414730	3	NO	2023-02-13 15:47:51
11753	-1260	2042	414731	0	NO	2023-02-13 15:47:51
11754	-1260	2042	414732	0	SI	2023-02-13 15:47:51
11755	-1260	2042	414733	3	SI	2023-02-13 15:47:51
11756	-1260	2042	414734	5	NO	2023-02-13 15:47:51
11757	-1260	2042	414736	0	NO	2023-02-13 15:47:51
11758	-1260	2042	414741	0	NO	2023-02-13 15:47:51
11759	-1260	2042	414742	3	NO	2023-02-13 15:47:51
11760	-1260	2042	414743	2	NO	2023-02-13 15:47:51
11761	-1260	2042	414745	0	NO	2023-02-13 15:47:51
11762	-1260	2042	414746	8	NO	2023-02-13 15:47:51
11763	-1260	2042	414748	0	SI	2023-02-13 15:47:51
11764	-1260	2042	414749	0	SI	2023-02-13 15:47:51
11765	-1260	2042	414750	0	NO	2023-02-13 15:47:51
11766	-1260	2042	414751	3	NO	2023-02-13 15:47:51
11767	-1260	2042	414752	8	NO	2023-02-13 15:47:51
11768	-1260	2042	414754	7	SI	2023-02-13 15:47:51
11769	-1260	2042	414755	0	NO	2023-02-13 15:47:51
11770	-1260	2042	414757	0	NO	2023-02-13 15:47:51
11771	-1260	2042	414758	0	SI	2023-02-13 15:47:51
11772	-1260	2042	414759	6	NO	2023-02-13 15:47:51
11773	-1260	2042	414774	0	NO	2023-02-13 15:47:51
11774	-1260	2042	414775	15	NO	2023-02-13 15:47:51
11775	-1260	2042	414785	10	SI	2023-02-13 15:47:51
11776	-1260	2042	414786	0	NO	2023-02-13 15:47:51
11777	-1260	2042	414787	0	NO	2023-02-13 15:47:51
11778	-1260	2042	414789	0	NO	2023-02-13 15:47:51
11779	-1260	2042	414790	7	NO	2023-02-13 15:47:51
11780	-1260	2042	414798	0	NO	2023-02-13 15:47:51
11781	-1260	2042	414804	0	NO	2023-02-13 15:47:51
11782	-1260	2042	414805	10	SI	2023-02-13 15:47:51
11783	-1260	2042	414806	0	SI	2023-02-13 15:47:51
11784	-1260	2042	414807	15	SI	2023-02-13 15:47:51
11785	-1260	2042	414808	15	SI	2023-02-13 15:47:51
11786	-1260	2042	414809	5	SI	2023-02-13 15:47:51
11787	-1260	2042	414810	2	SI	2023-02-13 15:47:51
11788	-1260	2042	414811	0	SI	2023-02-13 15:47:51
11789	-1260	2042	414812	0	SI	2023-02-13 15:47:51
11790	-1260	2042	414813	0	NO	2023-02-13 15:47:51
11791	-1260	2042	414814	4	SI	2023-02-13 15:47:51
11792	-1260	2042	414815	0	NO	2023-02-13 15:47:51
11793	-1260	2042	414816	0	NO	2023-02-13 15:47:51
11794	-1260	2042	414817	0	NO	2023-02-13 15:47:51
11795	-1260	2042	414818	0	NO	2023-02-13 15:47:51
11796	-1260	2042	414820	8	NO	2023-02-13 15:47:51
11797	-1260	2042	414825	6	SI	2023-02-13 15:47:51
11798	-1260	2042	414826	6	NO	2023-02-13 15:47:51
11799	-1260	2042	414830	0	NO	2023-02-13 15:47:51
11800	-1260	2042	414832	5	NO	2023-02-13 15:47:51
11801	-1260	2042	414833	5	NO	2023-02-13 15:47:51
11802	-1260	2042	414834	0	SI	2023-02-13 15:47:51
11803	-1260	2042	414835	0	SI	2023-02-13 15:47:51
11804	-1260	2042	414838	0	SI	2023-02-13 15:47:51
11805	-1260	2042	414839	0	SI	2023-02-13 15:47:51
11806	-1260	2042	414840	0	SI	2023-02-13 15:47:51
11807	-1260	2042	414841	0	SI	2023-02-13 15:47:51
11808	-1260	2042	414842	0	SI	2023-02-13 15:47:51
11809	-1260	2042	414843	2	SI	2023-02-13 15:47:51
11810	-1260	2042	414844	0	SI	2023-02-13 15:47:51
11812	-1260	2042	414847	1	NO	2023-02-13 15:47:51
11814	-1260	2042	414850	0	SI	2023-02-13 15:47:51
11816	-1260	2042	414852	0	SI	2023-02-13 15:47:51
11818	-1260	2042	414855	0	SI	2023-02-13 15:47:51
11820	-1260	2042	414857	2	NO	2023-02-13 15:47:51
11822	-1260	2042	414865	10	NO	2023-02-13 15:47:51
11824	-1260	2042	414867	2	NO	2023-02-13 15:47:51
11826	-1260	2042	414871	0	SI	2023-02-13 15:47:51
11828	-1260	2042	414873	10	SI	2023-02-13 15:47:51
11830	-1260	2042	414875	0	NO	2023-02-13 15:47:51
11832	-1260	2042	414878	0	NO	2023-02-13 15:47:51
11834	-1260	2042	414881	0	NO	2023-02-13 15:47:51
11836	-1260	2042	414883	12	NO	2023-02-13 15:47:51
11838	-1260	2042	414885	0	NO	2023-02-13 15:47:51
11840	-1260	2042	414889	0	NO	2023-02-13 15:47:51
11842	-1260	2042	414898	0	SI	2023-02-13 15:47:51
11844	-1260	2042	414901	100	SI	2023-02-13 15:47:51
11846	-1260	2042	414903	25	SI	2023-02-13 15:47:51
11848	-1260	2042	414905	0	NO	2023-02-13 15:47:51
11850	-1260	2042	419820	10	NO	2023-02-13 15:47:51
11852	-1260	2042	419823	0	SI	2023-02-13 15:47:51
11854	-1260	2042	419859	12	SI	2023-02-13 15:47:51
11811	-1260	2042	414845	0	NO	2023-02-13 15:47:51
11813	-1260	2042	414849	0	SI	2023-02-13 15:47:51
11815	-1260	2042	414851	3	NO	2023-02-13 15:47:51
11817	-1260	2042	414853	8	NO	2023-02-13 15:47:51
11819	-1260	2042	414856	0	NO	2023-02-13 15:47:51
11821	-1260	2042	414858	10	NO	2023-02-13 15:47:51
11823	-1260	2042	414866	0	SI	2023-02-13 15:47:51
11825	-1260	2042	414870	3	NO	2023-02-13 15:47:51
11827	-1260	2042	414872	3	SI	2023-02-13 15:47:51
11829	-1260	2042	414874	8	NO	2023-02-13 15:47:51
11831	-1260	2042	414876	0	NO	2023-02-13 15:47:51
11833	-1260	2042	414880	0	NO	2023-02-13 15:47:51
11835	-1260	2042	414882	15	SI	2023-02-13 15:47:51
11837	-1260	2042	414884	10	SI	2023-02-13 15:47:51
11839	-1260	2042	414887	0	NO	2023-02-13 15:47:51
11841	-1260	2042	414893	0	NO	2023-02-13 15:47:51
11843	-1260	2042	414899	0	SI	2023-02-13 15:47:51
11845	-1260	2042	414902	0	NO	2023-02-13 15:47:51
11847	-1260	2042	414904	25	SI	2023-02-13 15:47:51
11849	-1260	2042	419819	6	NO	2023-02-13 15:47:51
11851	-1260	2042	419821	0	NO	2023-02-13 15:47:51
11853	-1260	2042	419824	4	NO	2023-02-13 15:47:51
12074	-1330	2049	416511	0	NO	2023-03-21 13:51:08
12075	-1330	2049	416513	0	SI	2023-03-21 13:51:08
12076	-1330	2049	416514	0	NO	2023-03-21 13:51:08
12077	-1330	2049	416515	0	SI	2023-03-21 13:51:08
12078	-1330	2049	416516	0	SI	2023-03-21 13:51:08
12079	-1330	2049	416517	5	SI	2023-03-21 13:51:08
12080	-1330	2049	416518	0	NO	2023-03-21 13:51:08
12081	-1330	2049	416519	0	NO	2023-03-21 13:51:08
12082	-1330	2049	416520	5	SI	2023-03-21 13:51:08
12083	-1330	2049	416521	0	SI	2023-03-21 13:51:08
12084	-1330	2049	416522	0	SI	2023-03-21 13:51:08
12085	-1330	2049	416523	0	SI	2023-03-21 13:51:08
12086	-1330	2049	416524	0	SI	2023-03-21 13:51:08
12087	-1330	2049	416525	4	NO	2023-03-21 13:51:08
12088	-1330	2049	416526	0	SI	2023-03-21 13:51:08
12089	-1330	2049	416527	0	SI	2023-03-21 13:51:08
12090	-1330	2049	416528	0	NO	2023-03-21 13:51:08
12091	-1330	2049	416529	0	NO	2023-03-21 13:51:08
12092	-1330	2049	416530	0	NO	2023-03-21 13:51:08
12093	-1330	2049	416531	0	SI	2023-03-21 13:51:08
12094	-1330	2049	416532	0	SI	2023-03-21 13:51:08
12095	-1330	2049	416533	0	SI	2023-03-21 13:51:08
12096	-1330	2049	416534	0	SI	2023-03-21 13:51:08
12097	-1330	2049	416535	0	SI	2023-03-21 13:51:08
12098	-1330	2049	416536	3	NO	2023-03-21 13:51:08
12099	-1330	2049	416537	0	SI	2023-03-21 13:51:08
12100	-1330	2049	416538	0	SI	2023-03-21 13:51:08
12101	-1330	2049	416539	3	NO	2023-03-21 13:51:08
12102	-1330	2049	416540	0	SI	2023-03-21 13:51:08
12103	-1330	2049	416541	0	SI	2023-03-21 13:51:08
12104	-1330	2049	416542	5	SI	2023-03-21 13:51:08
12105	-1330	2049	416543	0	SI	2023-03-21 13:51:08
12106	-1330	2049	416544	0	SI	2023-03-21 13:51:08
12107	-1330	2049	416545	0	SI	2023-03-21 13:51:08
12108	-1330	2049	416546	0	SI	2023-03-21 13:51:08
12109	-1330	2049	416547	4	NO	2023-03-21 13:51:08
12110	-1330	2049	416548	0	SI	2023-03-21 13:51:08
12111	-1330	2049	416549	0	SI	2023-03-21 13:51:08
12112	-1330	2049	416550	0	NO	2023-03-21 13:51:08
12113	-1330	2049	416551	0	NO	2023-03-21 13:51:08
12114	-1330	2049	416552	0	NO	2023-03-21 13:51:08
12115	-1330	2049	416553	0	SI	2023-03-21 13:51:08
12116	-1330	2049	416554	0	SI	2023-03-21 13:51:08
12117	-1330	2049	416555	0	SI	2023-03-21 13:51:08
12118	-1330	2049	416556	0	SI	2023-03-21 13:51:08
12119	-1330	2049	416557	0	SI	2023-03-21 13:51:08
12120	-1330	2049	416558	0	SI	2023-03-21 13:51:08
12121	-1330	2049	416559	0	SI	2023-03-21 13:51:08
12122	-1330	2049	416560	3	NO	2023-03-21 13:51:08
12123	-1330	2049	416561	0	SI	2023-03-21 13:51:08
12124	-1330	2049	416562	0	SI	2023-03-21 13:51:08
12125	-1330	2049	416563	0	SI	2023-03-21 13:51:08
12126	-1330	2049	416564	0	NO	2023-03-21 13:51:08
12127	-1330	2049	416565	0	NO	2023-03-21 13:51:08
12128	-1330	2049	416567	0	NO	2023-03-21 13:51:08
12129	-1330	2049	416568	0	SI	2023-03-21 13:51:08
12130	-1330	2049	416569	0	SI	2023-03-21 13:51:08
12131	-1330	2049	416570	0	SI	2023-03-21 13:51:08
12132	-1330	2049	416571	0	NO	2023-03-21 13:51:08
12133	-1330	2049	416572	1	SI	2023-03-21 13:51:08
12134	-1330	2049	416573	0	SI	2023-03-21 13:51:08
12135	-1330	2049	416574	3	SI	2023-03-21 13:51:08
12136	-1330	2049	416575	0	NO	2023-03-21 13:51:08
12137	-1330	2049	416576	1	SI	2023-03-21 13:51:08
12138	-1330	2049	416577	0	SI	2023-03-21 13:51:08
12139	-1330	2049	416578	0	SI	2023-03-21 13:51:08
12140	-1330	2049	416579	0	SI	2023-03-21 13:51:08
12141	-1330	2049	416580	0	SI	2023-03-21 13:51:08
12142	-1330	2049	416581	0	SI	2023-03-21 13:51:08
12143	-1330	2049	416582	0	SI	2023-03-21 13:51:08
12144	-1330	2049	416583	0	SI	2023-03-21 13:51:08
12145	-1330	2049	416584	0	SI	2023-03-21 13:51:08
12146	-1330	2049	416585	0	SI	2023-03-21 13:51:08
12147	-1330	2049	416586	0	NO	2023-03-21 13:51:08
12148	-1330	2049	416588	0	NO	2023-03-21 13:51:08
12149	-1330	2049	416589	0	SI	2023-03-21 13:51:08
12150	-1330	2049	416590	0	SI	2023-03-21 13:51:08
12151	-1330	2049	416591	0	NO	2023-03-21 13:51:08
12152	-1330	2049	416592	20	NO	2023-03-21 13:51:08
12153	-1330	2049	416594	0	SI	2023-03-21 13:51:08
12154	-1330	2049	416595	0	SI	2023-03-21 13:51:08
12155	-1330	2049	416596	12	NO	2023-03-21 13:51:08
12156	-1330	2049	416597	0	SI	2023-03-21 13:51:08
12157	-1330	2049	416598	4	SI	2023-03-21 13:51:08
12158	-1330	2049	416599	0	SI	2023-03-21 13:51:08
12159	-1330	2049	416600	0	NO	2023-03-21 13:51:08
12160	-1330	2049	416602	7	SI	2023-03-21 13:51:08
12161	-1330	2049	416603	0	SI	2023-03-21 13:51:08
12162	-1330	2049	416604	0	SI	2023-03-21 13:51:08
12163	-1330	2049	416605	0	NO	2023-03-21 13:51:08
12164	-1330	2049	416606	0	SI	2023-03-21 13:51:08
12165	-1330	2049	416607	0	NO	2023-03-21 13:51:08
12166	-1330	2049	416608	5	NO	2023-03-21 13:51:08
12167	-1330	2049	416610	0	NO	2023-03-21 13:51:08
12168	-1330	2049	416611	0	SI	2023-03-21 13:51:08
12169	-1330	2049	416612	0	SI	2023-03-21 13:51:08
12170	-1330	2049	416613	0	NO	2023-03-21 13:51:08
12171	-1330	2049	416614	0	NO	2023-03-21 13:51:08
12172	-1330	2049	416615	0	NO	2023-03-21 13:51:08
12173	-1330	2049	416617	0	NO	2023-03-21 13:51:08
12174	-1330	2049	416618	0	NO	2023-03-21 13:51:08
12175	-1330	2049	416620	0	NO	2023-03-21 13:51:08
12176	-1330	2049	416621	8	NO	2023-03-21 13:51:08
12177	-1330	2049	416630	0	NO	2023-03-21 13:51:08
12178	-1330	2049	416631	0	NO	2023-03-21 13:51:08
12179	-1330	2049	416632	0	SI	2023-03-21 13:51:08
12180	-1330	2049	416633	0	NO	2023-03-21 13:51:08
12181	-1330	2049	416634	0	NO	2023-03-21 13:51:08
12182	-1330	2049	416635	0	NO	2023-03-21 13:51:08
12183	-1330	2049	416636	0	NO	2023-03-21 13:51:08
12184	-1330	2049	416637	0	NO	2023-03-21 13:51:08
12185	-1330	2049	416638	0	SI	2023-03-21 13:51:08
12186	-1330	2049	416639	0	SI	2023-03-21 13:51:08
12187	-1330	2049	416640	0	NO	2023-03-21 13:51:08
12188	-1330	2049	416641	0	NO	2023-03-21 13:51:08
12189	-1330	2049	416642	0	NO	2023-03-21 13:51:08
12190	-1330	2049	416643	0	NO	2023-03-21 13:51:08
12191	-1330	2049	416644	0	NO	2023-03-21 13:51:08
12192	-1330	2049	416645	0	NO	2023-03-21 13:51:08
12193	-1330	2049	416647	0	SI	2023-03-21 13:51:08
12194	-1330	2049	416648	0	SI	2023-03-21 13:51:08
12195	-1330	2049	416649	0	NO	2023-03-21 13:51:08
12196	-1330	2049	416650	0	SI	2023-03-21 13:51:08
12197	-1330	2049	416651	0	SI	2023-03-21 13:51:08
12198	-1330	2049	416652	0	NO	2023-03-21 13:51:08
12199	-1330	2049	416655	0	SI	2023-03-21 13:51:08
12200	-1330	2049	416656	0	SI	2023-03-21 13:51:08
12201	-1330	2049	416657	0	SI	2023-03-21 13:51:08
12202	-1330	2049	416658	0	SI	2023-03-21 13:51:08
12203	-1330	2049	416659	0	SI	2023-03-21 13:51:08
12204	-1330	2049	416660	5	SI	2023-03-21 13:51:08
12205	-1330	2049	416661	0	SI	2023-03-21 13:51:08
12206	-1330	2049	416662	0	SI	2023-03-21 13:51:08
12207	-1330	2049	416663	0	SI	2023-03-21 13:51:08
12208	-1330	2049	416664	0	SI	2023-03-21 13:51:08
12209	-1330	2049	416665	3	NO	2023-03-21 13:51:08
12210	-1330	2049	416666	0	NO	2023-03-21 13:51:08
12211	-1330	2049	416667	0	SI	2023-03-21 13:51:08
12212	-1330	2049	416668	0	NO	2023-03-21 13:51:08
12213	-1330	2049	416670	0	SI	2023-03-21 13:51:08
12214	-1330	2049	416671	0	SI	2023-03-21 13:51:08
12215	-1330	2049	416672	0	SI	2023-03-21 13:51:08
12216	-1330	2049	416673	0	SI	2023-03-21 13:51:08
12217	-1330	2049	416674	0	SI	2023-03-21 13:51:08
12218	-1330	2049	416675	0	SI	2023-03-21 13:51:08
12219	-1330	2049	416676	0	SI	2023-03-21 13:51:08
12220	-1330	2049	416678	0	SI	2023-03-21 13:51:08
12221	-1330	2049	416679	4	SI	2023-03-21 13:51:08
12222	-1330	2049	416680	0	SI	2023-03-21 13:51:08
12223	-1330	2049	416681	0	SI	2023-03-21 13:51:08
12224	-1330	2049	416682	0	SI	2023-03-21 13:51:08
12225	-1330	2049	416683	0	SI	2023-03-21 13:51:08
12226	-1330	2049	416684	0	SI	2023-03-21 13:51:08
12227	-1330	2049	416685	0	SI	2023-03-21 13:51:08
12228	-1330	2049	416686	0	SI	2023-03-21 13:51:08
12229	-1330	2049	416688	0	SI	2023-03-21 13:51:08
12230	-1330	2049	416689	0	SI	2023-03-21 13:51:08
12231	-1330	2049	416690	0	SI	2023-03-21 13:51:08
12232	-1330	2049	416691	0	SI	2023-03-21 13:51:08
12233	-1330	2049	416692	0	SI	2023-03-21 13:51:08
12234	-1330	2049	416693	0	SI	2023-03-21 13:51:08
12235	-1330	2049	416694	0	SI	2023-03-21 13:51:08
12236	-1330	2049	416695	0	NO	2023-03-21 13:51:08
12237	-1330	2049	416696	0	NO	2023-03-21 13:51:08
12238	-1330	2049	416697	0	SI	2023-03-21 13:51:08
12239	-1330	2049	416698	0	NO	2023-03-21 13:51:08
12240	-1330	2049	416699	0	NO	2023-03-21 13:51:08
12241	-1330	2049	416701	0	NO	2023-03-21 13:51:08
12242	-1330	2049	416702	0	NO	2023-03-21 13:51:08
12243	-1330	2049	416703	35	SI	2023-03-21 13:51:08
12244	-1330	2049	416704	0	NO	2023-03-21 13:51:08
12245	-1330	2049	416705	0	NO	2023-03-21 13:51:08
12246	-1330	2049	416706	0	SI	2023-03-21 13:51:08
12247	-1330	2049	416707	13	SI	2023-03-21 13:51:08
12248	-1330	2049	416708	13	SI	2023-03-21 13:51:08
12249	-1330	2049	416709	0	NO	2023-03-21 13:51:08
12250	-1330	2049	416710	0	NO	2023-03-21 13:51:08
12251	-1330	2049	416716	0	SI	2023-03-21 13:51:08
12252	-1330	2049	416717	4	NO	2023-03-21 13:51:08
12253	-1330	2049	416719	0	NO	2023-03-21 13:51:08
12254	-1330	2049	416720	0	NO	2023-03-21 13:51:08
12255	-1330	2049	416721	0	NO	2023-03-21 13:51:08
12256	-1330	2049	416722	0	NO	2023-03-21 13:51:08
12257	-1330	2049	416723	0	NO	2023-03-21 13:51:08
12258	-1347	2046	415898	0	SI	2023-03-30 22:52:47
12259	-1347	2046	415899	1	SI	2023-03-30 22:52:47
12260	-1347	2046	415900	0	SI	2023-03-30 22:52:47
12261	-1347	2046	415901	0	SI	2023-03-30 22:52:47
12262	-1347	2046	415902	0	NO	2023-03-30 22:52:47
12263	-1347	2046	415903	0	NO	2023-03-30 22:52:47
12264	-1347	2046	415904	3	SI	2023-03-30 22:52:47
12265	-1347	2046	415905	1	SI	2023-03-30 22:52:47
12266	-1347	2046	415906	0	SI	2023-03-30 22:52:47
12267	-1347	2046	415907	4	NO	2023-03-30 22:52:47
12268	-1347	2046	415919	3	NO	2023-03-30 22:52:47
12269	-1347	2046	415923	1	SI	2023-03-30 22:52:47
12270	-1347	2046	415924	0	SI	2023-03-30 22:52:47
12271	-1347	2046	415925	3	NO	2023-03-30 22:52:47
12272	-1347	2046	415936	3	NO	2023-03-30 22:52:47
12273	-1347	2046	415940	0	SI	2023-03-30 22:52:47
12274	-1347	2046	415941	7	SI	2023-03-30 22:52:47
12275	-1347	2046	415942	0	SI	2023-03-30 22:52:47
12276	-1347	2046	415943	0	SI	2023-03-30 22:52:47
12277	-1347	2046	415944	0	SI	2023-03-30 22:52:47
12278	-1347	2046	415945	1	NO	2023-03-30 22:52:47
12279	-1347	2046	415949	0	NO	2023-03-30 22:52:47
12280	-1347	2046	415953	0	NO	2023-03-30 22:52:47
12281	-1347	2046	415956	0	SI	2023-03-30 22:52:47
12282	-1347	2046	415957	0	SI	2023-03-30 22:52:47
12283	-1347	2046	415958	1	NO	2023-03-30 22:52:47
12284	-1347	2046	415960	3	SI	2023-03-30 22:52:47
12285	-1347	2046	415961	2	NO	2023-03-30 22:52:47
12286	-1347	2046	415962	4	SI	2023-03-30 22:52:47
12287	-1347	2046	415963	0	SI	2023-03-30 22:52:47
12288	-1347	2046	415964	0	SI	2023-03-30 22:52:47
12289	-1347	2046	415965	0	SI	2023-03-30 22:52:47
12290	-1347	2046	415966	0	SI	2023-03-30 22:52:47
12291	-1347	2046	415967	4	NO	2023-03-30 22:52:47
12292	-1347	2046	415970	4	SI	2023-03-30 22:52:47
12293	-1347	2046	415971	4	NO	2023-03-30 22:52:47
12294	-1347	2046	415972	0	SI	2023-03-30 22:52:47
12295	-1347	2046	415973	5	NO	2023-03-30 22:52:47
12296	-1347	2046	415974	5	SI	2023-03-30 22:52:47
12297	-1347	2046	415975	4	SI	2023-03-30 22:52:47
12298	-1347	2046	415976	0	SI	2023-03-30 22:52:47
12299	-1347	2046	415977	0	NO	2023-03-30 22:52:47
12300	-1347	2046	415984	0	NO	2023-03-30 22:52:47
12301	-1347	2046	415986	5	NO	2023-03-30 22:52:47
12302	-1347	2046	415995	7	SI	2023-03-30 22:52:47
12303	-1347	2046	415996	7	SI	2023-03-30 22:52:47
12304	-1347	2046	415997	0	SI	2023-03-30 22:52:47
12305	-1347	2046	415998	20	SI	2023-03-30 22:52:47
12306	-1347	2046	415999	30	SI	2023-03-30 22:52:47
12307	-1347	2046	416000	12	SI	2023-03-30 22:52:47
12308	-1347	2046	416001	4	SI	2023-03-30 22:52:47
12309	-1347	2046	416002	0	SI	2023-03-30 22:52:47
12310	-1347	2046	416003	4	SI	2023-03-30 22:52:47
12311	-1347	2046	416004	4	SI	2023-03-30 22:52:47
12312	-1347	2046	416005	3	SI	2023-03-30 22:52:47
12313	-1347	2046	416006	7	SI	2023-03-30 22:52:47
12314	-1347	2046	416007	15	SI	2023-03-30 22:52:47
12315	-1347	2046	416008	30	SI	2023-03-30 22:52:47
12316	-1347	2046	416009	5	SI	2023-03-30 22:52:47
12317	-1347	2046	416013	4	SI	2023-03-30 22:52:47
12318	-1347	2046	416014	0	SI	2023-03-30 22:52:47
12319	-1347	2046	416015	0	SI	2023-03-30 22:52:47
12320	-1347	2046	416017	8	NO	2023-03-30 22:52:47
12321	-1347	2046	416022	0	NO	2023-03-30 22:52:47
12322	-1347	2046	416025	17	SI	2023-03-30 22:52:47
12323	-1347	2046	416026	0	SI	2023-03-30 22:52:47
12324	-1347	2046	416027	0	SI	2023-03-30 22:52:47
12325	-1347	2046	416028	0	SI	2023-03-30 22:52:47
12326	-1347	2046	416029	2	NO	2023-03-30 22:52:47
12327	-1347	2046	416030	0	NO	2023-03-30 22:52:47
12328	-1347	2046	416031	0	SI	2023-03-30 22:52:47
12329	-1347	2046	416032	0	SI	2023-03-30 22:52:47
12330	-1347	2046	416033	0	SI	2023-03-30 22:52:47
12331	-1347	2046	416034	0	SI	2023-03-30 22:52:47
12332	-1347	2046	416035	0	SI	2023-03-30 22:52:47
12333	-1347	2046	416036	1	SI	2023-03-30 22:52:47
12334	-1347	2046	416037	0	SI	2023-03-30 22:52:47
12335	-1347	2046	416038	0	SI	2023-03-30 22:52:47
12336	-1347	2046	416039	1	NO	2023-03-30 22:52:47
12337	-1347	2046	416040	0	SI	2023-03-30 22:52:47
12338	-1347	2046	416041	2	NO	2023-03-30 22:52:47
12339	-1347	2046	416042	0	SI	2023-03-30 22:52:47
12340	-1347	2046	416043	0	SI	2023-03-30 22:52:47
12341	-1347	2046	416044	0	SI	2023-03-30 22:52:47
12342	-1347	2046	416045	0	SI	2023-03-30 22:52:47
12343	-1347	2046	416046	0	SI	2023-03-30 22:52:47
12344	-1347	2046	416048	15	SI	2023-03-30 22:52:47
12345	-1347	2046	416049	0	SI	2023-03-30 22:52:47
12346	-1347	2046	416050	1	NO	2023-03-30 22:52:47
12347	-1347	2046	416051	0	SI	2023-03-30 22:52:47
12348	-1347	2046	416052	0	SI	2023-03-30 22:52:47
12349	-1347	2046	416054	0	SI	2023-03-30 22:52:47
12350	-1347	2046	416055	2	SI	2023-03-30 22:52:47
12351	-1347	2046	416056	0	SI	2023-03-30 22:52:47
12352	-1347	2046	416057	4	NO	2023-03-30 22:52:47
12353	-1347	2046	416064	0	SI	2023-03-30 22:52:47
12354	-1347	2046	416065	0	SI	2023-03-30 22:52:47
12355	-1347	2046	416066	0	SI	2023-03-30 22:52:47
12356	-1347	2046	416067	0	SI	2023-03-30 22:52:47
12357	-1347	2046	416068	2	SI	2023-03-30 22:52:47
12358	-1347	2046	416069	4	SI	2023-03-30 22:52:47
12359	-1347	2046	416070	0	SI	2023-03-30 22:52:47
12360	-1347	2046	416071	2	SI	2023-03-30 22:52:47
12361	-1347	2046	416073	8	SI	2023-03-30 22:52:47
12362	-1347	2046	416074	18	SI	2023-03-30 22:52:47
12363	-1347	2046	416075	35	SI	2023-03-30 22:52:47
12364	-1347	2046	416076	70	SI	2023-03-30 22:52:47
12365	-1347	2046	416077	0	SI	2023-03-30 22:52:47
12366	-1347	2046	416078	5	SI	2023-03-30 22:52:47
12367	-1347	2046	416079	30	SI	2023-03-30 22:52:47
12368	-1347	2046	416080	0	SI	2023-03-30 22:52:47
12369	-1347	2046	416081	15	SI	2023-03-30 22:52:47
12370	-1347	2046	416082	0	SI	2023-03-30 22:52:47
12371	-1347	2046	416083	15	SI	2023-03-30 22:52:47
12372	-1347	2046	416085	250	SI	2023-03-30 22:52:47
12373	-1347	2046	416086	25	SI	2023-03-30 22:52:47
12374	-1347	2046	416087	25	SI	2023-03-30 22:52:47
12375	-1347	2046	416088	25	SI	2023-03-30 22:52:47
12376	-1347	2046	419806	0	SI	2023-03-30 22:52:47
12377	-1347	2046	419807	0	SI	2023-03-30 22:52:47
12378	-1347	2046	419808	0	SI	2023-03-30 22:52:47
\.


--
-- TOC entry 4358 (class 0 OID 0)
-- Dependencies: 223
-- Name: a_tipol_ml_id_seq; Type: SEQUENCE SET; Schema: cl_23; Owner: postgres
--

SELECT pg_catalog.setval('cl_23.a_tipol_ml_id_seq', 5, true);


--
-- TOC entry 4359 (class 0 OID 0)
-- Dependencies: 258
-- Name: anag_cl_id_seq; Type: SEQUENCE SET; Schema: cl_23; Owner: postgres
--

SELECT pg_catalog.setval('cl_23.anag_cl_id_seq', 9, true);


--
-- TOC entry 4360 (class 0 OID 0)
-- Dependencies: 257
-- Name: cl_acque_reflue_id_seq; Type: SEQUENCE SET; Schema: cl_23; Owner: postgres
--

SELECT pg_catalog.setval('cl_23.cl_acque_reflue_id_seq', 1, false);


--
-- TOC entry 4361 (class 0 OID 0)
-- Dependencies: 260
-- Name: cl_effluenti_id_seq; Type: SEQUENCE SET; Schema: cl_23; Owner: postgres
--

SELECT pg_catalog.setval('cl_23.cl_effluenti_id_seq', 30, true);


--
-- TOC entry 4362 (class 0 OID 0)
-- Dependencies: 254
-- Name: cl_emissioni_id_seq; Type: SEQUENCE SET; Schema: cl_23; Owner: postgres
--

SELECT pg_catalog.setval('cl_23.cl_emissioni_id_seq', 20, true);


--
-- TOC entry 4363 (class 0 OID 0)
-- Dependencies: 262
-- Name: cl_fanghi_id_seq; Type: SEQUENCE SET; Schema: cl_23; Owner: postgres
--

SELECT pg_catalog.setval('cl_23.cl_fanghi_id_seq', 18, true);


--
-- TOC entry 4364 (class 0 OID 0)
-- Dependencies: 264
-- Name: cl_reflui_oleari_id_seq; Type: SEQUENCE SET; Schema: cl_23; Owner: postgres
--

SELECT pg_catalog.setval('cl_23.cl_reflui_oleari_id_seq', 19, true);


--
-- TOC entry 4365 (class 0 OID 0)
-- Dependencies: 266
-- Name: cl_rifiuti_id_seq; Type: SEQUENCE SET; Schema: cl_23; Owner: postgres
--

SELECT pg_catalog.setval('cl_23.cl_rifiuti_id_seq', 51, true);


--
-- TOC entry 4366 (class 0 OID 0)
-- Dependencies: 225
-- Name: config_cl_id_seq; Type: SEQUENCE SET; Schema: cl_23; Owner: postgres
--

SELECT pg_catalog.setval('cl_23.config_cl_id_seq', 23, true);


--
-- TOC entry 4367 (class 0 OID 0)
-- Dependencies: 227
-- Name: config_punti_id_seq; Type: SEQUENCE SET; Schema: cl_23; Owner: postgres
--

SELECT pg_catalog.setval('cl_23.config_punti_id_seq', 42, true);


--
-- TOC entry 4368 (class 0 OID 0)
-- Dependencies: 229
-- Name: access_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.access_log_id_seq', 1863, true);


--
-- TOC entry 4369 (class 0 OID 0)
-- Dependencies: 233
-- Name: appdocu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appdocu_id_seq', 10, true);


--
-- TOC entry 4370 (class 0 OID 0)
-- Dependencies: 248
-- Name: log_checklist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_checklist_id_seq', 229, true);


--
-- TOC entry 4371 (class 0 OID 0)
-- Dependencies: 251
-- Name: public_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.public_user_id_seq', 1526, true);


--
-- TOC entry 4372 (class 0 OID 0)
-- Dependencies: 252
-- Name: utente_risposta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utente_risposta_id_seq', 12378, true);


--
-- TOC entry 4125 (class 2606 OID 367702)
-- Name: a_tipol_ml a_tipol_ml_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.a_tipol_ml
    ADD CONSTRAINT a_tipol_ml_pkey PRIMARY KEY (id);


--
-- TOC entry 4139 (class 2606 OID 608360)
-- Name: anag_cl anag_cl_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.anag_cl
    ADD CONSTRAINT anag_cl_pkey PRIMARY KEY (id);


--
-- TOC entry 4137 (class 2606 OID 399824)
-- Name: cl_acque_reflue cl_acque_reflue_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_acque_reflue
    ADD CONSTRAINT cl_acque_reflue_pkey PRIMARY KEY (id);


--
-- TOC entry 4141 (class 2606 OID 608381)
-- Name: cl_effluenti cl_effluenti_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_effluenti
    ADD CONSTRAINT cl_effluenti_pkey PRIMARY KEY (id);


--
-- TOC entry 4143 (class 2606 OID 608399)
-- Name: cl_fanghi cl_fanghi_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_fanghi
    ADD CONSTRAINT cl_fanghi_pkey PRIMARY KEY (id);


--
-- TOC entry 4145 (class 2606 OID 608417)
-- Name: cl_reflui_oleari cl_reflui_oleari_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_reflui_oleari
    ADD CONSTRAINT cl_reflui_oleari_pkey PRIMARY KEY (id);


--
-- TOC entry 4147 (class 2606 OID 608426)
-- Name: cl_rifiuti cl_rifiuti_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_rifiuti
    ADD CONSTRAINT cl_rifiuti_pkey PRIMARY KEY (id);


--
-- TOC entry 4128 (class 2606 OID 367704)
-- Name: old_config_cl config_cl_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_cl
    ADD CONSTRAINT config_cl_pkey PRIMARY KEY (id);


--
-- TOC entry 4133 (class 2606 OID 367706)
-- Name: old_config_sez config_punti_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_sez
    ADD CONSTRAINT config_punti_pkey PRIMARY KEY (id);


--
-- TOC entry 4130 (class 2606 OID 608292)
-- Name: old_config_cl idx_uniq_name; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_cl
    ADD CONSTRAINT idx_uniq_name UNIQUE (cl_name);


--
-- TOC entry 4134 (class 1259 OID 399789)
-- Name: cl_emissioni_idx; Type: INDEX; Schema: cl_23; Owner: postgres
--

CREATE UNIQUE INDEX cl_emissioni_idx ON cl_23.cl_emissioni USING btree (prog, sez) WHERE (trashed_date IS NULL);


--
-- TOC entry 4135 (class 1259 OID 399817)
-- Name: cl_emissioni_prog; Type: INDEX; Schema: cl_23; Owner: postgres
--

CREATE UNIQUE INDEX cl_emissioni_prog ON cl_23.cl_emissioni USING btree (prog) WHERE (trashed_date IS NULL);


--
-- TOC entry 4126 (class 1259 OID 367709)
-- Name: cod_univ_idx; Type: INDEX; Schema: cl_23; Owner: postgres
--

CREATE UNIQUE INDEX cod_univ_idx ON cl_23.a_tipol_ml USING btree (codice_univoco) WHERE (codice_univoco IS NOT NULL);


--
-- TOC entry 4131 (class 1259 OID 367710)
-- Name: config_punti_key; Type: INDEX; Schema: cl_23; Owner: postgres
--

CREATE UNIQUE INDEX config_punti_key ON cl_23.old_config_sez USING btree (cl_name, sez_name) WHERE (trashed_date IS NULL);


--
-- TOC entry 4148 (class 2606 OID 608293)
-- Name: old_config_sez fk_config_cl; Type: FK CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_sez
    ADD CONSTRAINT fk_config_cl FOREIGN KEY (cl_name) REFERENCES cl_23.old_config_cl(cl_name) NOT VALID;


--
-- TOC entry 4343 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2023-10-19 17:05:58

--
-- PostgreSQL database dump complete
--

