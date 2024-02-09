-- FUNCTION: public.dbi_insert_utente_guru(character varying, character varying, character varying, integer, integer, integer, boolean, integer, character varying, character varying, character varying, text, text, character varying, character varying, timestamp with time zone, integer, text, text, text)

-- DROP FUNCTION IF EXISTS public.dbi_insert_utente_guru(character varying, character varying, character varying, integer, integer, integer, boolean, integer, character varying, character varying, character varying, text, text, character varying, character varying, timestamp with time zone, integer, text, text, text);

CREATE OR REPLACE FUNCTION public.dbi_insert_utente_guru(
	usr character varying,
	alias_utente character varying,
	password character varying,
	role_id integer,
	enteredby integer,
	modifiedby integer,
	enabled boolean,
	site_id integer,
	namefirst_input character varying,
	namelast_input character varying,
	cf character varying,
	notes text,
	luogo text,
	nickname character varying,
	email character varying,
	expires timestamp with time zone,
	id_struttura integer,
	inaccess text,
	indpat text,
	inni text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

   DECLARE
msg text ;
userId integer;
   
BEGIN

SELECT user_id into userId from access_ where username = usr;

IF userId > 0 THEN
return 'ERRORE. USERNAME ESISTENTE NEL SISTEMA.';
END IF;

msg := (select * from public.dbi_insert_utente(usr, alias_utente, password, role_id, enteredby, modifiedby, enabled, site_id, namefirst_input, namelast_input, cf, 'Inserito da GURU.', luogo, nickname, email, expires, id_struttura, inaccess, indpat, inni));
	
	RETURN msg;

END
$BODY$;

ALTER FUNCTION public.dbi_insert_utente_guru(character varying, character varying, character varying, integer, integer, integer, boolean, integer, character varying, character varying, character varying, text, text, character varying, character varying, timestamp with time zone, integer, text, text, text)
    OWNER TO postgres;
