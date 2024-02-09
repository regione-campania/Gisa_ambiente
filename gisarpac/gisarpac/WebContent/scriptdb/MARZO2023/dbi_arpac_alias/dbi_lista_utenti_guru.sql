-- FUNCTION: public.dbi_lista_utenti_guru()

-- DROP FUNCTION IF EXISTS public.dbi_lista_utenti_guru();

CREATE OR REPLACE FUNCTION public.dbi_lista_utenti_guru(
	)
    RETURNS TABLE(id integer, username text, alias_utente text, nome text, cognome text, codice_fiscale text, ruolo text, asl text, id_ruolo integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE

BEGIN
RETURN QUERY
    
 select a.user_id, a.username::text, a.alias_utente::text, c.namefirst::text, c.namelast::text, c.codice_fiscale::text, r.role::text, CASE WHEN asl.code > 0 THEN asl.description ELSE 'TUTTI I DIPARTIMENTI' END::text , r.role_id
from access a
left join access_dati ac on ac.user_id = a.user_id
left join contact_ c on c.contact_id = a.contact_id
left join role r on r.role_id = a.role_id
left join lookup_site_id asl on asl.code = ac.site_id
order by a.entered desc;

END;
$BODY$;

ALTER FUNCTION public.dbi_lista_utenti_guru()
    OWNER TO postgres;
