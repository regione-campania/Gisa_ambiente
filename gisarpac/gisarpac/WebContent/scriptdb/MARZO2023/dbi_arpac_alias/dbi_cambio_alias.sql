-- FUNCTION: public.dbi_cambio_alias(text, text)

-- DROP FUNCTION IF EXISTS public.dbi_cambio_alias(text, text);

CREATE OR REPLACE FUNCTION public.dbi_cambio_alias(
	input_username text,
	input_alias text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
us_id integer;
alias_count integer;
msg text;

BEGIN

us_id := (select user_id from access where username = input_username);

alias_count:= (select count (alias_utente) from access_ where alias_utente = input_alias OR username = input_alias);

if(alias_count>0) THEN 

msg= 'KO alias gia presente nel sistema';

ELSE 

update access_ set alias_utente = input_alias where user_id = us_id;
msg ='OK';

END IF;

RETURN msg;

END
$BODY$;

ALTER FUNCTION public.dbi_cambio_alias(text, text)
    OWNER TO postgres;
