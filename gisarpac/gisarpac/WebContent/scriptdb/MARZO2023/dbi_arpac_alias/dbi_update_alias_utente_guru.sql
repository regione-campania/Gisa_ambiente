-- FUNCTION: public.dbi_update_alias_utente_guru(integer, text)

-- DROP FUNCTION IF EXISTS public.dbi_update_alias_utente_guru(integer, text);

CREATE OR REPLACE FUNCTION public.dbi_update_alias_utente_guru(
	userid integer,
	alias_utente text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

   DECLARE
msg text ;
   
BEGIN

msg := (select * from public.dbi_cambio_alias((select username from access_ where user_id = userId), alias_utente));

RETURN msg;

END
$BODY$;

ALTER FUNCTION public.dbi_update_alias_utente_guru(integer, text)
    OWNER TO postgres;
