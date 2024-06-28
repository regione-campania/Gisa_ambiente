--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.1

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
-- Name: cl_23; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA cl_23;


ALTER SCHEMA cl_23 OWNER TO postgres;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: riskcat; Type: DOMAIN; Schema: cl_23; Owner: postgres
--

CREATE DOMAIN cl_23.riskcat AS integer
	CONSTRAINT riskcat_check CHECK (((VALUE > 0) AND (VALUE < 6)));


ALTER DOMAIN cl_23.riskcat OWNER TO postgres;

--
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
-- Name: a_tipol_ml_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.a_tipol_ml_id_seq OWNED BY cl_23.a_tipol_ml.id;


--
-- Name: anag_cl; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.anag_cl (
    id integer NOT NULL,
    name text,
    title text NOT NULL
);


ALTER TABLE cl_23.anag_cl OWNER TO postgres;

--
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
-- Name: anag_cl_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.anag_cl_id_seq OWNED BY cl_23.anag_cl.id;


--
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
-- Name: cl_effluenti_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.cl_effluenti_id_seq OWNED BY cl_23.cl_effluenti.id;


--
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
-- Name: cl_emissioni_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.cl_emissioni_id_seq OWNED BY cl_23.cl_emissioni.id;


--
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
-- Name: cl_fanghi_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.cl_fanghi_id_seq OWNED BY cl_23.cl_fanghi.id;


--
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
-- Name: cl_reflui_oleari_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.cl_reflui_oleari_id_seq OWNED BY cl_23.cl_reflui_oleari.id;


--
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
-- Name: cl_rifiuti_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.cl_rifiuti_id_seq OWNED BY cl_23.cl_rifiuti.id;


--
-- Name: cl_rumori; Type: TABLE; Schema: cl_23; Owner: postgres
--

CREATE TABLE cl_23.cl_rumori (
    id integer,
    prog integer,
    grp integer,
    domanda text,
    no_punti real,
    si_punti real,
    sez text,
    id_parent text,
    comm text,
    trashed_date timestamp without time zone,
    peso real
);


ALTER TABLE cl_23.cl_rumori OWNER TO postgres;

--
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
-- Name: config_cl_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.config_cl_id_seq OWNED BY cl_23.old_config_cl.id;


--
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
-- Name: config_punti_id_seq; Type: SEQUENCE OWNED BY; Schema: cl_23; Owner: postgres
--

ALTER SEQUENCE cl_23.config_punti_id_seq OWNED BY cl_23.old_config_sez.id;


--
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
-- Name: access_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.access_log_id_seq OWNED BY public.log_access.id;


--
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
-- Name: appdocu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appdocu_id_seq OWNED BY public.appdocu.id;


--
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
-- Name: lista_cl; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.lista_cl AS
 SELECT DISTINCT ml10_old.list_cl,
    ml10_old.id_linea
   FROM public.ml10_old
  ORDER BY ml10_old.list_cl;


ALTER TABLE public.lista_cl OWNER TO postgres;

--
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
-- Name: log_checklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_checklist_id_seq OWNED BY public.log_checklist.id;


--
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
-- Name: norma_old; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.norma_old AS
 SELECT DISTINCT ml10_old.norma,
    ml10_old.id_norma
   FROM public.ml10_old
  ORDER BY ml10_old.norma;


ALTER TABLE public.norma_old OWNER TO postgres;

--
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
-- Name: utente_risposta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utente_risposta (
    id bigint DEFAULT nextval('public.utente_risposta_id_seq'::regclass),
    id_utente bigint,
    id_checklist bigint,
    id_domanda bigint,
    punteggio real,
    risposta character varying,
    entered timestamp(0) without time zone
);


ALTER TABLE public.utente_risposta OWNER TO postgres;

--
-- Name: a_tipol_ml id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.a_tipol_ml ALTER COLUMN id SET DEFAULT nextval('cl_23.a_tipol_ml_id_seq'::regclass);


--
-- Name: anag_cl id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.anag_cl ALTER COLUMN id SET DEFAULT nextval('cl_23.anag_cl_id_seq'::regclass);


--
-- Name: cl_effluenti id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_effluenti ALTER COLUMN id SET DEFAULT nextval('cl_23.cl_effluenti_id_seq'::regclass);


--
-- Name: cl_emissioni id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_emissioni ALTER COLUMN id SET DEFAULT nextval('cl_23.cl_emissioni_id_seq'::regclass);


--
-- Name: cl_fanghi id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_fanghi ALTER COLUMN id SET DEFAULT nextval('cl_23.cl_fanghi_id_seq'::regclass);


--
-- Name: cl_reflui_oleari id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_reflui_oleari ALTER COLUMN id SET DEFAULT nextval('cl_23.cl_reflui_oleari_id_seq'::regclass);


--
-- Name: cl_rifiuti id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_rifiuti ALTER COLUMN id SET DEFAULT nextval('cl_23.cl_rifiuti_id_seq'::regclass);


--
-- Name: old_config_cl id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_cl ALTER COLUMN id SET DEFAULT nextval('cl_23.config_cl_id_seq'::regclass);


--
-- Name: old_config_sez id; Type: DEFAULT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_sez ALTER COLUMN id SET DEFAULT nextval('cl_23.config_punti_id_seq'::regclass);


--
-- Name: appdocu id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appdocu ALTER COLUMN id SET DEFAULT nextval('public.appdocu_id_seq'::regclass);


--
-- Name: log_access id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_access ALTER COLUMN id SET DEFAULT nextval('public.access_log_id_seq'::regclass);


--
-- Name: log_checklist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_checklist ALTER COLUMN id SET DEFAULT nextval('public.log_checklist_id_seq'::regclass);


--
-- Name: a_tipol_ml a_tipol_ml_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.a_tipol_ml
    ADD CONSTRAINT a_tipol_ml_pkey PRIMARY KEY (id);


--
-- Name: anag_cl anag_cl_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.anag_cl
    ADD CONSTRAINT anag_cl_pkey PRIMARY KEY (id);


--
-- Name: cl_acque_reflue cl_acque_reflue_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_acque_reflue
    ADD CONSTRAINT cl_acque_reflue_pkey PRIMARY KEY (id);


--
-- Name: cl_effluenti cl_effluenti_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_effluenti
    ADD CONSTRAINT cl_effluenti_pkey PRIMARY KEY (id);


--
-- Name: cl_fanghi cl_fanghi_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_fanghi
    ADD CONSTRAINT cl_fanghi_pkey PRIMARY KEY (id);


--
-- Name: cl_reflui_oleari cl_reflui_oleari_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_reflui_oleari
    ADD CONSTRAINT cl_reflui_oleari_pkey PRIMARY KEY (id);


--
-- Name: cl_rifiuti cl_rifiuti_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.cl_rifiuti
    ADD CONSTRAINT cl_rifiuti_pkey PRIMARY KEY (id);


--
-- Name: old_config_cl config_cl_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_cl
    ADD CONSTRAINT config_cl_pkey PRIMARY KEY (id);


--
-- Name: old_config_sez config_punti_pkey; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_sez
    ADD CONSTRAINT config_punti_pkey PRIMARY KEY (id);


--
-- Name: old_config_cl idx_uniq_name; Type: CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_cl
    ADD CONSTRAINT idx_uniq_name UNIQUE (cl_name);


--
-- Name: cl_emissioni_idx; Type: INDEX; Schema: cl_23; Owner: postgres
--

CREATE UNIQUE INDEX cl_emissioni_idx ON cl_23.cl_emissioni USING btree (prog, sez) WHERE (trashed_date IS NULL);


--
-- Name: cl_emissioni_prog; Type: INDEX; Schema: cl_23; Owner: postgres
--

CREATE UNIQUE INDEX cl_emissioni_prog ON cl_23.cl_emissioni USING btree (prog) WHERE (trashed_date IS NULL);


--
-- Name: cod_univ_idx; Type: INDEX; Schema: cl_23; Owner: postgres
--

CREATE UNIQUE INDEX cod_univ_idx ON cl_23.a_tipol_ml USING btree (codice_univoco) WHERE (codice_univoco IS NOT NULL);


--
-- Name: config_punti_key; Type: INDEX; Schema: cl_23; Owner: postgres
--

CREATE UNIQUE INDEX config_punti_key ON cl_23.old_config_sez USING btree (cl_name, sez_name) WHERE (trashed_date IS NULL);


--
-- Name: old_config_sez fk_config_cl; Type: FK CONSTRAINT; Schema: cl_23; Owner: postgres
--

ALTER TABLE ONLY cl_23.old_config_sez
    ADD CONSTRAINT fk_config_cl FOREIGN KEY (cl_name) REFERENCES cl_23.old_config_cl(cl_name) NOT VALID;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

