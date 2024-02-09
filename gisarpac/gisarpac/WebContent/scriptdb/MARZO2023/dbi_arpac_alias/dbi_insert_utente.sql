-- FUNCTION: public.dbi_insert_utente(character varying, character varying, integer, integer, integer, boolean, integer, character varying, character varying, character varying, text, text, character varying, character varying, timestamp with time zone, integer, text, text, text)

-- DROP FUNCTION IF EXISTS public.dbi_insert_utente(character varying, character varying, integer, integer, integer, boolean, integer, character varying, character varying, character varying, text, text, character varying, character varying, timestamp with time zone, integer, text, text, text);

CREATE OR REPLACE FUNCTION public.dbi_insert_utente(
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
us_id int ;
con_id int;
us_id2 int ;
flag boolean;
delegavisibilita text ;

   
BEGIN
	
	namefirst_input:= trim(namefirst_input);
namelast_input:= trim(namelast_input);
cf:= trim(cf);

	IF (role_id=-1) THEN
		enabled:=false;
	ELSE
		enabled:=true;
	END IF;

	IF (id_struttura=-1) THEN
		id_struttura:=null;
	END IF;

	con_id := (select contact_id from contact c where c.namefirst ilike namefirst_input and c.namelast ilike namelast_input and c.codice_fiscale ilike cf and c.trashed_date is null limit 1);
	
	IF (con_id is null) THEN	
		con_id:=nextVal('contact_contact_id_seq');
		
		INSERT INTO contact ( contact_id, namefirst, namelast, enteredby, modifiedby, site_id, codice_fiscale, notes, enabled,luogo,nickname,visibilita_delega ) 
		VALUES ( con_id, upper(namefirst_input), upper(namelast_input), 964, 964, site_id, cf, notes, enabled,luogo,nickname,delegavisibilita );

			
		--con_id=currVal('contact_contact_id_seq');
		INSERT INTO contact_emailaddress(contact_id, emailaddress_type, email, enteredby, modifiedby, primary_email)
		VALUES (con_id, 1, email, 964, 964, true);
	end if;
	
	
		us_id=nextVal('access_user_id_seq');
	
if (site_id>0)
		then
			delegavisibilita:=(select description from lookup_site_id where code =site_id);
			else
			delegavisibilita:=cf;
			end if ;

		 
		INSERT INTO access_ ( user_id, alias_utente, username, password, contact_id, role_id, enteredby, modifiedby, timezone, currency, language, enabled, expires, in_access, in_dpat, in_nucleo_ispettivo) 
		VALUES (  us_id, alias_utente, usr, password, con_id, role_id, 964, 964, 'Europe/Berlin', 'EUR', 'it_IT', enabled, expires::timestamp without time zone, inaccess::boolean, indpat::boolean, inni::boolean); 

		INSERT INTO access_dati ( user_id, site_id, visibilita_delega) 
		VALUES (  us_id, site_id, delegavisibilita ); 


	IF (id_struttura is not null) THEN
		us_id2=nextVal('access_collegamento_id_seq');
		INSERT INTO access_collegamento (id,id_utente,id_collegato,enabled) 
		VALUES (us_id2,us_id,id_canile,enabled); 
	END IF;



	msg = COALESCE(msg, 'OK');
	
	RETURN msg;

END
$BODY$;

