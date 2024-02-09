
CREATE TABLE giornate_ispettive_allegati (id serial primary key, id_giornata_ispettiva integer, codice_allegato text, nome_allegato text, oggetto_allegato text, enteredby integer, entered timestamp without time zone default now(), trashedby integer, trashed_date timestamp without time zone, note_hd text);

CREATE OR REPLACE FUNCTION public.get_giornate_ispettive_allegati(
	_id_giornata_ispettiva integer)
    RETURNS TABLE(codice_allegato text, nome_allegato text, oggetto_allegato text, entered timestamp without time zone, enteredby integer, id_giornata_ispettiva integer) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

select 	codice_allegato , nome_allegato , oggetto_allegato, entered , enteredby , id_giornata_ispettiva      
	from giornate_ispettive_allegati

					where id_giornata_ispettiva = _id_giornata_ispettiva and trashed_date is null order by entered desc;
    
$BODY$;
ALTER FUNCTION public.get_giornate_ispettive_allegati(integer)
    OWNER TO postgres;