DROP FUNCTION public.dbi_lista_asl_vda();

CREATE OR REPLACE FUNCTION public.dbi_lista_asl_guru()
  RETURNS TABLE(asl_id integer, asl text) AS
$BODY$
DECLARE

BEGIN
RETURN QUERY
    
 select a.code, a.description::text from lookup_site_id a where a.enabled and a.code <> 16 order by a.description ASC;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


DROP FUNCTION public.dbi_lista_ruoli_vda();

CREATE OR REPLACE FUNCTION public.dbi_lista_ruoli_guru()
  RETURNS TABLE(role_id integer, role text) AS
$BODY$
DECLARE

BEGIN
RETURN QUERY
    
 select r.role_id, r.role::text from role r where r.enabled order by role ASC;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


DROP FUNCTION public.dbi_insert_utente_vda(character varying, character varying, integer, integer, integer, boolean, integer, character varying, character varying, character varying, text, text, character varying, character varying, timestamp with time zone, integer, text, text, text);

CREATE OR REPLACE FUNCTION public.dbi_insert_utente_guru(
    usr character varying,
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
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
userId integer;
   
BEGIN

SELECT user_id into userId from access where username = usr;

IF userId > 0 THEN
return 'ERRORE. USERNAME ESISTENTE NEL SISTEMA.';
END IF;

msg := (select * from public.dbi_insert_utente(usr, password, role_id, enteredby, modifiedby, enabled, site_id, namefirst_input, namelast_input, cf, 'Inserito da GURU.', luogo, nickname, email, expires, id_struttura, inaccess, indpat, inni));
	
	RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


 DROP FUNCTION public.dbi_lista_utenti_vda();


CREATE OR REPLACE FUNCTION public.dbi_lista_utenti_guru()
  RETURNS TABLE(id integer, username text, nome text, cognome text, codice_fiscale text, ruolo text, asl text, id_ruolo integer) AS
$BODY$DECLARE

BEGIN
RETURN QUERY
    
 select a.user_id, a.username::text, c.namefirst::text, c.namelast::text, c.codice_fiscale::text, r.role::text, CASE WHEN asl.code > 0 THEN asl.description ELSE 'TUTTI I DIPARTIMENTI' END::text , r.role_id
from access a
left join access_dati ac on ac.user_id = a.user_id
left join contact_ c on c.contact_id = a.contact_id
left join role r on r.role_id = a.role_id
left join lookup_site_id asl on asl.code = ac.site_id
order by a.entered desc;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

DROP FUNCTION public.dbi_dettaglio_utente_vda(integer);

CREATE OR REPLACE FUNCTION public.dbi_dettaglio_utente_guru(IN userid integer)
  RETURNS TABLE(id integer, username text, nome text, cognome text, cf text, id_ruolo integer, id_asl integer) AS
$BODY$
DECLARE

BEGIN
RETURN QUERY
    
 select a.user_id, a.username::text, c.namefirst::text, c.namelast::text, c.codice_fiscale::text, r.role_id, asl.code
from access a
left join access_dati ac on ac.user_id = a.user_id
left join contact_ c on c.contact_id = a.contact_id
left join role r on r.role_id = a.role_id
left join lookup_site_id asl on asl.code = ac.site_id
where a.user_id = userId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

DROP FUNCTION public.dbi_update_utente_vda(integer, integer, integer, text, text, text);

CREATE OR REPLACE FUNCTION public.dbi_update_utente_guru(
    userid integer,
    roleid integer,
    aslid integer,
    nome text,
    cognome text,
    cf text)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
   
BEGIN

msg := (select * from public.dbi_insert_utente((select username from access_ where user_id = userId), (select password from access_ where user_id = userId), roleId, (select enteredby from access_ where user_id = userId), (select modifiedby from access_ where user_id = userId), true, aslId, nome, cognome, cf, 'Modificato da GURU.', '', '', '', null, -1, 'true', 'true', 'true'));

update access_ set data_scadenza = now(), note_hd = 'Scaduto in seguito a modifica da GURU.' where user_id = userId and data_scadenza is null;

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP FUNCTION public.dbi_update_disable_utente_vda(integer);

CREATE OR REPLACE FUNCTION public.dbi_update_disable_utente_guru(userid integer)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
   
BEGIN

update access_ set data_scadenza = now(), note_hd = 'Scaduto in seguito a disabilitazione da GURU.' where user_id = userId and data_scadenza is null;
msg := 'OK';

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


 DROP FUNCTION public.dbi_update_password_utente_vda(integer, text);

CREATE OR REPLACE FUNCTION public.dbi_update_password_utente_guru(
    userid integer,
    password text)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
   
BEGIN

msg := (select * from public.dbi_cambio_password((select username from access_ where user_id = userId), password));

RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

 DROP FUNCTION public.dbi_insert_vdaccess_log(integer, text, text, text, integer, text);

ALTER TABLE vdaccess_log rename to guru_log;

CREATE OR REPLACE FUNCTION public.dbi_insert_guru_log(
    _enteredby integer,
    _ip_enteredby text,
    _operazione text,
    _output text,
    _user_id integer,
    _username text)
  RETURNS boolean AS
$BODY$
   DECLARE
   
BEGIN

insert into guru_log (enteredby, ip_enteredby, operazione, output, user_id, username) values (_enteredby, _ip_enteredby, _operazione, _output, _user_id, _username);
RETURN true;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

update permission set permission = 'guru', description = 'Gestione Unificata Ruoli e Utenti' where permission = 'vdaccess';
