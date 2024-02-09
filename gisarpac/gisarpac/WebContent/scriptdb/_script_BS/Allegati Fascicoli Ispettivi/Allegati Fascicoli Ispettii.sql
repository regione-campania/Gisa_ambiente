-- Table: public.fascicoli_ispettivi_allegati

-- DROP TABLE IF EXISTS public.fascicoli_ispettivi_allegati;

CREATE TABLE IF NOT EXISTS public.fascicoli_ispettivi_allegati
(
    id SERIAL PRIMARY KEY,
    id_fascicolo_ispettivo integer,
    codice_allegato text COLLATE pg_catalog."default",
    nome_allegato text COLLATE pg_catalog."default",
    oggetto_allegato text COLLATE pg_catalog."default",
    enteredby integer,
    entered timestamp without time zone DEFAULT 'now()',
    trashedby integer,
    trashed_date timestamp without time zone,
    note_hd text COLLATE pg_catalog."default"
)


 DROP FUNCTION IF EXISTS public.fascicolo_ispettivo_close(integer, text, integer, integer, integer);


CREATE OR REPLACE FUNCTION public.fascicolo_ispettivo_close(
	_id_fascicolo_ispettivo integer,
	_data_chiusura text,
	_anno_protocollo integer,
	_numero_protocollo integer,
	_cod_allegato text,
	_id_utente integer)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
	id_fascicolo_ispettivo_protocollo integer;
	id_fascicolo_ispettivo_allegato integer;
BEGIN
	
	update fascicoli_ispettivi set modifiedby = _id_utente, modified= current_timestamp, stato=2, data_chiusura = to_timestamp(_data_chiusura,'YYYY-MM-DD HH:MI:SS') where id = _id_fascicolo_ispettivo;
	
	insert into fascicoli_ispettivi_protocolli (id_fascicolo_ispettivo, anno_protocollo, numero_protocollo, enteredby, entered) values (_id_fascicolo_ispettivo, _anno_protocollo, _numero_protocollo, _id_utente, now()) returning id into id_fascicolo_ispettivo_protocollo;
	
	insert into fascicoli_ispettivi_allegati (id_fascicolo_ispettivo, codice_allegato, nome_allegato, oggetto_allegato, enteredby) values (_id_fascicolo_ispettivo, _cod_allegato, 'RapportoChiusura', 'Rapporto Chiusura Fascicolo Ispettivo', _id_utente) returning id into id_fascicolo_ispettivo_allegato;

	if(id_fascicolo_ispettivo_protocollo > 0 AND id_fascicolo_ispettivo_allegato > 0) then
		return 'OK, operazione effettuata con successo.';
	else 
		return 'KO, operazione fallita.';
	end if;
	
END;
$BODY$;


CREATE OR REPLACE FUNCTION public.get_fascicoli_ispettivi_rapporto_chiusura(
	_idfascicolo integer)
    RETURNS TABLE(cod_allegato text, id_fascicolo_ispettivo integer) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

select 	codice_allegato,  id_fascicolo_ispettivo      
	from fascicoli_ispettivi_allegati

					where id_fascicolo_ispettivo = _idfascicolo and trashed_date is null order by entered desc limit 1;
    
$BODY$;

ALTER FUNCTION public.get_fascicoli_ispettivi_rapporto_chiusura(integer)
    OWNER TO postgres;


