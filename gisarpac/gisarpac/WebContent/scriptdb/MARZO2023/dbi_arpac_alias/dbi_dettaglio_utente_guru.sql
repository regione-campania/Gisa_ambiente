-- FUNCTION: public.dbi_dettaglio_utente_guru(integer)

-- DROP FUNCTION IF EXISTS public.dbi_dettaglio_utente_guru(integer);

CREATE OR REPLACE FUNCTION public.dbi_dettaglio_utente_guru(
	userid integer)
    RETURNS TABLE(id integer, username text, alias_utente text, nome text, cognome text, cf text, id_ruolo integer, id_asl integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE

BEGIN
RETURN QUERY
    
 select a.user_id, a.username::text, a.alias_utente::text, c.namefirst::text, c.namelast::text, c.codice_fiscale::text, r.role_id, asl.code
from access_ a
left join access_dati ac on ac.user_id = a.user_id
left join contact_ c on c.contact_id = a.contact_id
left join role r on r.role_id = a.role_id
left join lookup_site_id asl on asl.code = ac.site_id
where a.user_id = userId;

END;
$BODY$;

ALTER FUNCTION public.dbi_dettaglio_utente_guru(integer)
    OWNER TO postgres;
