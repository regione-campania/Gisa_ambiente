dump schema preaccettazione

delete from preaccettazione.associazione_preaccettazione_entita;
delete from preaccettazione.stati_preaccettazione;
delete from preaccettazione.codici_preaccettazione;
		
alter table lookup_destinazione_campione add column short_description character varying

CREATE OR REPLACE VIEW public.quesiti_diagnostici_sigla AS 
 SELECT lookup_piano_monitoraggio_.code,
    lookup_piano_monitoraggio_.description,
    lookup_piano_monitoraggio_.enabled,
    lookup_piano_monitoraggio_.codice_esame,
    lookup_piano_monitoraggio_.level,
    lookup_piano_monitoraggio_.default_item,
    'lookup_piano_monitoraggio'::text AS short_description
   FROM lookup_piano_monitoraggio lookup_piano_monitoraggio_
  WHERE (lookup_piano_monitoraggio_.codice_esame IS NOT NULL OR lookup_piano_monitoraggio_.codice_esame <> ''::text) AND lookup_piano_monitoraggio_.enabled
UNION
 SELECT lookup_tipo_ispezione_.code,
    lookup_tipo_ispezione_.description,
    lookup_tipo_ispezione_.enabled,
    lookup_tipo_ispezione_.codice_esame,
    lookup_tipo_ispezione_.level,
    lookup_tipo_ispezione_.default_item,
    'lookup_tipo_ispezione'::text AS short_description
   FROM lookup_tipo_ispezione lookup_tipo_ispezione_
  WHERE (lookup_tipo_ispezione_.codice_esame IS NOT NULL OR lookup_tipo_ispezione_.codice_esame <> ''::text) AND lookup_tipo_ispezione_.enabled;

ALTER TABLE public.quesiti_diagnostici_sigla
  OWNER TO postgres;

  -- Function: public.ordina_stringhe_alfanumeriche(text, integer)

-- DROP FUNCTION public.ordina_stringhe_alfanumeriche(text, integer);

CREATE OR REPLACE FUNCTION public.ordina_stringhe_alfanumeriche(
    IN _var1 text,
    IN _var2 integer)
  RETURNS TABLE(element text) AS
$BODY$

BEGIN

    return query
    SELECT regexp_replace(regexp_replace(_var1, '[0-9]+', repeat('0',_var2) || '\&', 'g'), '[0-9]*([0-9]{' || _var2 || '})', '\1', 'g');
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.ordina_stringhe_alfanumeriche(text, integer)
  OWNER TO postgres;
  
  update lookup_destinazione_campione set code=7 where code=1;
insert into lookup_destinazione_campione(code, description, short_description) values (1, 'ARPAC', 'A');

-- Function: public.campione_dettaglio_globale(integer)

-- DROP FUNCTION public.campione_dettaglio_globale(integer);

CREATE OR REPLACE FUNCTION public.campione_dettaglio_globale(_idcampione integer)
  RETURNS json AS
$BODY$	
DECLARE
	campiservizio json;
	laboratorio json;
	motivazione json;
	numeroverbale json;
	finale json;
	utente json;
	analiti json;
	matrice json;
	dati json;
	daticu json;
	
	id_dipartimento integer;

BEGIN
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: recuperiamo i campi del campione
	laboratorio := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, (l.description)::text as descrizione from lookup_destinazione_campione l join campioni c on c.id_laboratorio= l.code
							               union select 'id' as nome,  (l.code)::text from  lookup_destinazione_campione l join campioni c on c.id_laboratorio= l.code) a);
	motivazione := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, 'DA DEFINIRE' as descrizione 
							               union select 'id' as nome,  1::text) a);				             

	numeroverbale := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, 'GENERA' as descrizione 
							               union select 'id' as nome,  1::text) a);				             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from campioni where id = _idcampione) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from campioni where id = _idcampione
							               union select 'dataPrelievo' as nome, (data_prelievo)::text  from campioni where id = _idcampione) a);	

	daticu := (select json_object_agg(nome,descrizione) from (select 'idControllo' as nome, id_controllo::text as descrizione from campioni where id = _idcampione
							               union select 'dipartimento' as nome, l.description::text  
							                     from controlli_ufficiali cu 
							                     join campioni c on c.id_controllo = cu.id
							                     join lookup_site_id l on l.code = cu.id_dipartimento
							               union select distinct 'ragioneSociale' as nome, r.ragione_sociale as descrizione
							                     from controlli_ufficiali cu 
							                     join campioni c on c.id_controllo = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
									union select distinct 'riferimentoId' as nome, r.riferimento_id::text as descrizione
							                     from controlli_ufficiali cu 
							                     join campioni c on c.id_controllo = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							          ) a);	     
	-- STEP 2: recuperiamo i campi matrice
	matrice := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, cammino::text as descrizione from matrici_campioni where id_campione  = _idcampione
							             union select 'id' as nome, id::text from matrici_campioni where id_campione  = _idcampione) a);
	-- STEP 3: recuperiamo i campi analiti
	analiti := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select cammino as nome, analiti_id as id 
										from analiti_campioni where id_campione = _idcampione) t);
										
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from campioni c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where c.id = _idcampione 
								  union select 'dataInserimento' as nome, entered::text as descrizione from campioni where id = _idcampione
								  union select 'idCampione' as nome, id::text as descrizione from campioni where id = _idcampione 
								  ) b);

	finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Dati":', dati, ',"DatiCU":', daticu, ',"NumeroVerbale":', numeroverbale, ',"Utente":',utente, 
		',"Matrice":', matrice,
		',"Analiti":', analiti,
		',"Laboratorio":', laboratorio,
		',"CampiServizio":', campiServizio,
		',"Motivazione":', motivazione)),'}'))::json);
		
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_dettaglio_globale(integer)
  OWNER TO postgres;

select * from public.campione_dettaglio_globale(1)