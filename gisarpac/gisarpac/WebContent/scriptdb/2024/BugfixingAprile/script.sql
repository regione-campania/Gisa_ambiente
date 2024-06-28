-- FUNCTION: public.insert_subparticella(integer, text, text, integer)

DROP FUNCTION IF EXISTS public.insert_subparticella(integer, text, text, integer);

CREATE OR REPLACE FUNCTION public.insert_subparticella(
	_id_padre integer,
	_codice_sito text,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE 
	id_subparticella integer;
BEGIN	
	insert into area_particelle(codice_sito, id_padre, entered, entered_by) 
	values(_codice_sito,
	_id_padre,
	now(),
	_id_utente) returning id into id_subparticella;

	return id_subparticella;
	      
END;
$BODY$;

ALTER FUNCTION public.insert_subparticella(integer, text, integer)
    OWNER TO postgres;
	
 DROP FUNCTION IF EXISTS public.update_subparticella(integer, integer, text, text, integer);

CREATE OR REPLACE FUNCTION public.update_subparticella(
	_id integer,
	_id_padre integer,
	_codice_sito text,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE 
	id_subparticella integer;
BEGIN	
	update area_particelle
	set 
	codice_sito = _codice_sito, 
	id_padre = _id_padre, 
	modified= now(),
	modified_by = _id_utente
	where id = _id and trashed_date is null;

	return _id;
	      
END;
$BODY$;

ALTER FUNCTION public.update_subparticella(integer, integer, text, integer)
    OWNER TO postgres;

-- FUNCTION: public.insert_area(text, text, integer, integer, text, text, text, text, text, text, text, integer)

 DROP FUNCTION IF EXISTS public.insert_area(text, text, integer, integer, text, text, text, text, text, text, text, integer);

CREATE OR REPLACE FUNCTION public.insert_area(
	_codice_sito text,
	_id_sito text,
	_id_provincia integer,
	_id_comune integer,
	_sezione text,
	_foglio_catastale text,
	_particella_catastale text,
	_classe_rischio text,
	_coordinate_x text,
	_coordinate_y text,
	_area text,
	_note text,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE 
	id_area_particella integer;
BEGIN	
	insert into area_particelle(codice_sito, id_sito, id_provincia, id_comune, foglio_catastale, particella_catastale, classe_rischio, coordinate_x, coordinate_y, area, sezione, note, id_padre, entered, entered_by) 
	values(_codice_sito,
	_id_sito ,
	_id_provincia ,
	_id_comune ,
	_foglio_catastale ,
	_particella_catastale ,
	_classe_rischio,
	_coordinate_x,
	_coordinate_y,
	_area,
	_sezione,		   
	_note,
	-1,
	now(),
	_id_utente) returning id into id_area_particella;

	return id_area_particella;
	      
END;
$BODY$;



-- FUNCTION: public.update_area(integer, text, text, integer, integer, text, text, text, text, text, text, text, integer)

DROP FUNCTION IF EXISTS public.update_area(integer, text, text, integer, integer, text, text, text, text, text, text, text, integer);
CREATE OR REPLACE FUNCTION public.update_area(
	_id integer,
	_codice_sito text,
	_id_sito text,
	_id_provincia integer,
	_id_comune integer,
	_sezione text,
	_foglio_catastale text,
	_particella_catastale text,
	_classe_rischio text,
	_coordinate_x text,
	_coordinate_y text,
	_area text,
	_note text,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE 
	
BEGIN	
	update area_particelle set 
	id_sito = _id_sito ,
	id_provincia = _id_provincia ,
	id_comune = _id_comune ,
	codice_sito = _codice_sito,
	foglio_catastale = _foglio_catastale,
	particella_catastale = _particella_catastale,
	classe_rischio = _classe_rischio,
	coordinate_x = _coordinate_x,
	coordinate_y = _coordinate_y,
	area = _area,
	sezione = _sezione, 
	note = _note,
	modified = now(),
	modified_by = _id_utente
	where id = _id and trashed_date is null;

	return _id;
	      
END;
$BODY$;


	
	
	-- FUNCTION: public.get_dettaglio_particella(integer)

-- DROP FUNCTION IF EXISTS public.get_dettaglio_particella(integer);

CREATE OR REPLACE FUNCTION public.get_dettaglio_particella(
	_id integer)
    RETURNS TABLE(id integer, codice_sito text, id_comune integer, id_provincia integer, descrizione_comune text, descrizione_provincia text, foglio_catastale text, particella_catastale text, classe_rischio text, coordinate_x text, coordinate_y text, sezione text, area text, note text, id_padre integer, id_sito text, entered timestamp without time zone, entered_by integer, modified timestamp without time zone, modified_by integer, trashed_date timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	
BEGIN 
	
	RETURN QUERY 
		select a.id, a.codice_sito, a.id_comune, a.id_provincia, 
		upper(c.nome) as descrizione_comune, upper(l.description) as descrizione_provincia,
		a.foglio_catastale, a.particella_catastale, a.classe_rischio, 
		a.coordinate_x, a.coordinate_y, a.sezione, a.area,a.note, a.id_padre, a.id_sito,
		a.entered, a.entered_by, a.modified, a.modified_by, a.trashed_date
		from area_particelle a
		left join comuni1 c on c.id = a.id_comune
		left join lookup_province l on l.code= c.cod_provincia::integer
		where a.trashed_date is null and a.id = _id;
END;
$BODY$;

ALTER FUNCTION public.get_dettaglio_particella(integer)
    OWNER TO postgres;

-- DROP FUNCTION IF EXISTS public.get_lista_aree(text, integer, integer);

CREATE OR REPLACE FUNCTION public.get_lista_aree(
	_codice_sito text DEFAULT NULL::text,
	_id_provincia integer DEFAULT '-1'::integer,
	_id_comune integer DEFAULT '-1'::integer)
    RETURNS TABLE(id integer, codice_sito text, id_comune integer, id_provincia integer, descrizione_comune text, descrizione_provincia text, sezione text, foglio_catastale text, particella_catastale text, classe_rischio text, coordinate_x text, coordinate_y text, area text, note text, id_padre integer, id_sito text, entered timestamp without time zone, entered_by integer, modified timestamp without time zone, modified_by integer, trashed_date timestamp without time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	
BEGIN 
	
	RETURN QUERY
		select a.id, a.codice_sito, a.id_comune, a.id_provincia, 
		upper(c.nome) as descrizione_comune, upper(l.description) as descrizione_provincia,
		a.sezione, a.foglio_catastale, a.particella_catastale, a.classe_rischio, 
		a.coordinate_x, a.coordinate_y, a.area, a.note, a.id_padre, a.id_sito,
		a.entered, a.entered_by, a.modified, a.modified_by, a.trashed_date 
		from area_particelle a
		left join comuni1 c on c.id = a.id_comune
		left join lookup_province l on l.code= c.cod_provincia::integer
		where a.trashed_date is null and (a.id_padre is null or a.id_padre = -1) and
		(_codice_sito = '' or _codice_sito is null or a.codice_sito ilike _codice_sito) and 
		(_id_provincia = -1 or a.id_provincia=_id_provincia) and 
		(_id_comune = -1 or a.id_comune = _id_comune);
END;
$BODY$;

ALTER FUNCTION public.get_lista_aree(text, integer, integer)
    OWNER TO postgres;

update area_particelle set sezione = '' where sezione is null 