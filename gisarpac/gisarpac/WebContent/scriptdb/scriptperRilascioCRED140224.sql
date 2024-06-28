CREATE OR REPLACE FUNCTION public.campione_insert_gruppo_ispettivo(
    _json_daticonnucleo json,
    _idcampione integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_daticonnucleo) 
	  LOOP
		 INSERT INTO campione_gruppo_ispettivo (id_campione, id_componente, enabled, id_struttura, nome_struttura) values (_idcampione, (i->>'id')::integer,true, (i->>'idStruttura')::integer, (i->>'struttura')::text);
	  END LOOP;


    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_insert_gruppo_ispettivo(json, integer)
  OWNER TO postgres;
  


-- FUNCTION: public.non_conformita_dettaglio_globale(integer)

-- DROP FUNCTION IF EXISTS public.non_conformita_dettaglio_globale(integer);

CREATE OR REPLACE FUNCTION public.non_conformita_dettaglio_globale(
	_idnc integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	campiservizio json;
	motivazione json;
	finale json;
	utente json;
	linea json;
	dati json;
	daticu json;
	
	_id_giornata_ispettiva integer;
	id_linea_nc integer;
	codicelinea text;

BEGIN
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: recuperiamo i campi della nc
	motivazione := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, l.description::text as descrizione 
									from non_conformita nc 
									join lookup_tipi_verifica l on l.code = nc.id_tipo_verifica 
									where nc.id = _idnc
							               union 
							               select 'id' as nome,  l.code::text as descrizione 
							               from non_conformita nc 
							               join lookup_tipi_verifica l on l.code = nc.id_tipo_verifica
								       where nc.id = _idnc
							               ) a);		

	_id_giornata_ispettiva := (select n.id_giornata_ispettiva from non_conformita n where n.id = _idnc);
	id_linea_nc = (select n.id_linea from non_conformita n where n.id = _idnc);
	--codicelinea := (select l.codice_linea from linee_attivita_giornate_ispettive l where l.id_giornata_ispettiva  = id_controllo and l.trashed_date is null and id_linea_attivita = );

	linea := (select json_object_agg(nome,descrizione) from (
								select 'nome' as nome, c.descrizione_completa as descrizione 
								from non_conformita nc
								left join linee_attivita_giornate_ispettive l on l.id_giornata_ispettiva =nc.id_giornata_ispettiva  
								left join codici_categoria_ippc c on concat(c.id_categoria,'-',c.id_codici_ippc,'-', c.id_codici_descrizione) = l.codice_linea
								where l.trashed_date is null and nc.trashed_date is null and nc.id = _idnc
								union
								select 'id' as nome, id_linea::text as descrizione 
								from non_conformita nc
								where trashed_date is null and nc.id = _idnc) a);
													             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from non_conformita  where id = _idnc) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from non_conformita where id = _idnc) a);	

	daticu := (select json_object_agg(nome,descrizione) from (select 'idGiornataIspettiva' as nome, n.id_giornata_ispettiva::text as descrizione from non_conformita n where n.id = _idnc
							             union select 'riferimentoId' as nome, cu.riferimento_id::text  
							                     from giornate_ispettive cu 
							                     join non_conformita c on c.id_giornata_ispettiva = cu.id
							                     where c.id = _idnc  
										 union select 'idFascicoloIspettivo' as nome, cu.id_fascicolo_ispettivo::text  
							                     from giornate_ispettive cu 
							                     join non_conformita c on c.id_giornata_ispettiva = cu.id
							                     where c.id = _idnc  
										 union select 'dipartimento' as nome, l.description::text  
							                     from giornate_ispettive cu 
							                     join non_conformita c on c.id_giornata_ispettiva = cu.id
							                     join lookup_site_id l on l.code = cu.id_dipartimento
							                     where c.id = _idnc
							               union select 'ragioneSociale' as nome, r.ragione_sociale as descrizione
							                     from giornate_ispettive cu 
							                     join non_conformita c on c.id_giornata_ispettiva = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							                     where c.id = _idnc) a);	     

										
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from non_conformita c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where c.id = _idnc 	
								  union select 'idNonConformita' as nome, id::text as descrizione from non_conformita where id = _idnc
								  union select 'dataInserimento' as nome, entered::text as descrizione from non_conformita where id = _idnc
								  union select 'idnon_conformita' as nome, id::text as descrizione from non_conformita where id = _idnc 
								  ) b);

	finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Dati":', dati, ',"DatiGiornataIspettiva":', daticu, 
		--',"NumeroVerbale":', numeroverbale, 
		',"Utente":',utente, 
		',"Linea":', linea,
		',"CampiServizio":', campiServizio,
		',"TipoVerifica":', motivazione
		)),'}'))::json);
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$;

ALTER FUNCTION public.non_conformita_dettaglio_globale(integer)
    OWNER TO postgres;

    -- FUNCTION: public.campione_dettaglio_globale(integer)

-- DROP FUNCTION IF EXISTS public.campione_dettaglio_globale(integer);

CREATE OR REPLACE FUNCTION public.campione_dettaglio_globale(
	_idcampione integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	campiservizio json;
	laboratorio json;
	tipoattivita json;
	numeroverbale json;
	finale json;
	utente json;
	programmacampionamento json;
	categoriamerceologica json;
	dati json;
	datigiornataispettiva json;
	gruppoispettivo json;
	analiti json;
	id_dipartimento integer;
	

BEGIN
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: recuperiamo i campi del campione
	laboratorio := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, (l.description)::text as descrizione 
																   from lookup_destinazione_campione l join campioni c on c.id_laboratorio= l.code
							               							union select 'id' as nome,  (l.code)::text from  lookup_destinazione_campione l 
																    join campioni c on c.id_laboratorio= l.code 
																  ) a);
										   
	tipoattivita := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, l.tipo as descrizione from campioni c join lookup_tipo_attivita l on l.code = c.id_tipo_attivita where id= _idcampione
						union
						select 'id' as nome, l.code::text as id from campioni c join lookup_tipo_attivita l on l.code = c.id_tipo_attivita where id= _idcampione) a);				             

	--numeroverbale := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, num_verbale as descrizione from campioni where id = _idcampione
	--						               union select 'id' as nome,  1::text) a);				             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from campioni where id = _idcampione) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, 
	                                                        note as descrizione 
	                                                        from campioni where id = _idcampione
							        union select 'dataPrelievo' as nome, (data_prelievo)::text  
							        from campioni where id = _idcampione
							        union select 'numeroVerbale' as nome, num_verbale
							        from campioni where id = _idcampione
							        ) a);	
	
	datigiornataispettiva := (select json_object_agg(nome,descrizione) from (select 'idGiornataIspettiva' as nome, id_giornata_ispettiva::text as descrizione from campioni where id = _idcampione
							               union select 'dipartimento' as nome, l.description::text  
							                     from giornate_ispettive cu 
							                     join campioni c on c.id_giornata_ispettiva = cu.id
							                     join lookup_site_id l on l.code = cu.id_dipartimento
							                     where c.id = _idcampione
							               union select distinct 'ragioneSociale' as nome, r.ragione_sociale as descrizione
							                     from giornate_ispettive cu 
							                     join campioni c on c.id_giornata_ispettiva = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							                     where c.id = _idcampione
											union select distinct 'riferimentoId' as nome, r.riferimento_id::text as descrizione
							                     from giornate_ispettive cu 
							                     join campioni c on c.id_giornata_ispettiva = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							                     where c.id = _idcampione  
											union select distinct 'idFascicoloIspettivo' as nome, cu.id_fascicolo_ispettivo::text
							                     from giornate_ispettive cu 
							                     join campioni c on c.id_giornata_ispettiva = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							                     where c.id = _idcampione					 
							          ) a);	     
	-- STEP 3: recuperiamo i campi programmacontrollo
	programmacampionamento := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select c.categoria_merceologica as nome,
							     c.programma_campionamento as "nomeProgrammaCampionamento", 
							     c.id as id, 
							     c.macrocategoria as "nomeProgrammaCampionamentoMacrocategoria" 
							     from campione_programma_campionamento cm
							     join programmi_campionamento_categorie_merceologiche c on c.id = cm.id_programma_campionamento
							     where id_campione = _idcampione and cm.enabled) t);
	-- STEP 4: recuperiamo i campi analiti
	analiti := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select a.descrizione_analita_livello_uno::text as livello1, 
										 a.descrizione_analita_livello_due::text as livello2, 
										 a.descrizione_analita_livello_tre::text as livello3, a.progressivo as id 
										         from campione_analiti ca
										         join analiti a on a.progressivo = ca.analiti_id
										         where id_campione = _idcampione) t);

										         
	--STEP 5: gruppo ispettivo
	gruppoispettivo := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select distinct d.nominativo as nominativo, c.id_componente as id, d.qualifica as qualifica, c.nome_struttura as struttura
										from campione_gruppo_ispettivo c
										join public.dpat_get_nominativi(-1, (select date_part('year',data_prelievo)::integer from campioni where id = _idcampione),null,null,null,c.id_struttura,null,-1) d on d.id_anagrafica_nominativo = c.id_componente
										left join access_ ac on ac.user_id = c.id_componente
										where c.id_campione = _idcampione) t);
										
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from campioni c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where c.id = _idcampione 
								  union select 'dataInserimento' as nome, entered::text as descrizione from campioni where id = _idcampione
								  union select 'idCampione' as nome, id::text as descrizione from campioni where id = _idcampione 
								  ) b);

	finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Dati":', dati, ',"DatiGiornataIspettiva":', datigiornataispettiva, 
		--',"NumeroVerbale":', numeroverbale, 
		',"Utente":',utente, 
		',"ProgrammaCampionamentoCategoriaMerceologica":', programmacampionamento,
		',"Laboratorio":', laboratorio,
		',"TipoAnalisi":', analiti,
		',"GruppoIspettivo":', gruppoispettivo,
		',"CampiServizio":', campiServizio,
		',"TipoAttivita":', tipoattivita)),'}'))::json);
		
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$;

ALTER FUNCTION public.campione_dettaglio_globale(integer)
    OWNER TO postgres;


-- FUNCTION: public.giornata_ispettiva_dettaglio_globale(integer)

-- DROP FUNCTION IF EXISTS public.giornata_ispettiva_dettaglio_globale(integer);

CREATE OR REPLACE FUNCTION public.giornata_ispettiva_dettaglio_globale(
	_idgiornataispettiva integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	tecnicacu json;
	daticu json;
	anagrafica json;
	utente json;
	dipartimento json;
	motivi json;
	linee json;
	gruppoispettivo json;
	esami json;
	tipiverifica json;
	percontodi json;
	campiservizio json;
	fasilavorazione json;
	fascicolo json;
	matrici json;
	emissioniatmosfera json;
	finale json;
	id_tecnica integer;
	anno_controllo integer;
	id_dipartimento integer;
	rifid integer;
	tipologia_operatore integer;
	rifnometab text;
	lineacontrollo text;
	path_linea text;
	
BEGIN

	---fasilavorazione := to_json('[]'::text);
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: recuperiamo la tecnica es: "Tecnica":{ "nome":"Ispezione AIA straordinaria","id":2},
	   
	id_tecnica := (select c.id_tecnica  from giornate_ispettive c where id = _idgiornataispettiva); 
	anno_controllo := (select date_part('year',data_inizio)::integer from giornate_ispettive where id = _idgiornataispettiva);
	rifid := (select riferimento_id from giornate_ispettive where id = _idgiornataispettiva);
	id_dipartimento := (select c.id_dipartimento from giornate_ispettive c where id = _idgiornataispettiva);
	rifnometab := (select c.riferimento_id_nome_tab from giornate_ispettive c where id = _idgiornataispettiva);
	--tipologia_operatore := (select distinct m.tipologia_operatore from ricerche_anagrafiche_old_materializzata m where m.riferimento_id = rifid and m.riferimento_id_nome_tab = rifnometab );
	--lineacontrollo := (select codice_linea from linee_attivita_giornate_ispettive  where  id_giornata_ispettiva  = _idgiornataispettiva and trashed_date is null);

	--path_linea := (select path_descrizione from ml8_linee_attivita_nuove_materializzata where codice = lineacontrollo and livello = 3 limit 1);
	
	-- costruzione dei json
	tecnicacu := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, description as descrizione from lookup_tipo_controllo where code = id_tecnica 
							union select 'id' as nome,  id_tecnica::text) a); 
        --tecnicacu := (select json_object_agg('Tecnica', tecnicacu));
	raise info 'json tecnica ricostruito%', tecnicacu;
	daticu := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from giornate_ispettive where id = _idgiornataispettiva
								  union select 'dataInizio' as nome,  data_inizio::text from giornate_ispettive where id = _idgiornataispettiva 
								  union select 'dataFine' as nome,  data_fine::text from giornate_ispettive where id = _idgiornataispettiva 
								  union select 'oraInizio' as nome,  coalesce(ore::text,'') from giornate_ispettive where id = _idgiornataispettiva 
								  union select 'oraFine' as nome,  coalesce(ora_fine::text,'') from giornate_ispettive where id = _idgiornataispettiva 
								  union select 'conclusa' as nome,  coalesce(conclusa_verifica::text,'') from giornate_ispettive where id = _idgiornataispettiva 
								  ) b);
	--daticu := (select json_object_agg('Dati', daticu));
	raise info 'json daticu ricostruito%', daticu;
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'stato' as nome, l.description as descrizione 
									 from giornate_ispettive c join lookup_stato_cu l on l.code = c.stato 
									 where id = _idgiornataispettiva
								  union select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from giornate_ispettive c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where id = _idgiornataispettiva 
								  union select 'dataInserimento' as nome, entered::text as descrizione from giornate_ispettive where id = _idgiornataispettiva
								  union select 'idGiornataIspettiva' as nome, id::text as descrizione from giornate_ispettive where id = _idgiornataispettiva 
								  ) b);

	anagrafica := (select json_object_agg(nome,descrizione) from (select 'partitaIva' as nome, trim(partita_iva) as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab
								  union select 'riferimentoId' as nome,  rifid::text
								  union select 'riferimentoIdNomeTab' as nome,  rifnometab::text 
								  union select 'ragioneSociale' as nome, ragione_sociale as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab) c);
	--anagrafica := (select json_object_agg('Anagrafica', anagrafica));
	raise info 'json anagrafica ricostruito%', anagrafica;

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, enteredby as descrizione from giornate_ispettive where id = _idgiornataispettiva) d); 
	--utente := (select json_object_agg('Utente', utente));
	raise info 'json utente ricostruito%', utente;

	dipartimento := (select json_object_agg(nome,descrizione) from (select 'nome' as nome,  description as descrizione from lookup_site_id where code= id_dipartimento
								union select 'id' as nome, id_dipartimento::text) e); 
	--asl := (select json_object_agg('Asl', asl));
	raise info 'json asl ricostruito%', dipartimento;
				  
	--"Linee":[{"codice":"MS.020-MS.020.500-852IT3A401","nome":"path completo","id":"192439"}],
	--linee := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select lineacontrollo as codice, path_linea as nome, (select id_linea_attivita from linee_attivita_giornate_ispettive  where trashed_date is null and id_giornata_ispettiva = _idgiornataispettiva) as id 
	--									from giornate_ispettive where id = _idgiornataispettiva) t);
	--linee := (select json_object_agg('Linee', linee));

	--06/07
	linee := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select codice_linea as codice, replace(coalesce(m.descrizione_completa,''), '''', '''''') as nome, l.id_linea_attivita as id 
				from giornate_ispettive c
				left join linee_attivita_giornate_ispettive l on l.id_giornata_ispettiva=c.id and l.trashed_date is null			
				left join codici_categoria_ippc m on concat(m.id_categoria, '-', m.id_codici_ippc, '-', m.id_codici_descrizione) = l.codice_linea
				where c.id = _idgiornataispettiva and c.trashed_date is null) t);
				raise info 'json linee ricostruito%', linee;

	gruppoispettivo := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select distinct d.nominativo as nominativo, c.id_componente as id, d.qualifica as qualifica, c.nome_struttura as struttura,
										c.responsabile, c.referente
										from giornata_ispettiva_gruppo_ispettivo c
										join public.dpat_get_nominativi(-1,anno_controllo,null,null,null,c.id_struttura,null,-1) d on d.id_anagrafica_nominativo = c.id_componente
										left join access_ ac on ac.user_id = c.id_componente -- è giusto?
										where id_giornata_ispettiva = _idgiornataispettiva) t);

	--gruppoispettivo := (select json_object_agg('GruppoIspettivo', gruppoispettivo));
	raise info 'json gruppoispettivo ricostruito %', gruppoispettivo;

										
	tipiverifica := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_tipi_verifica c
										join lookup_tipi_verifica l on l.code = c.id_tipo_verifica
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);
	--tipiverifica := (select json_object_agg('TipiVerifica', tipiverifica));
	raise info 'json tipi verifica %', tipiverifica;
	
	percontodi := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select o.descrizione_lunga as nome, o.id as id 
										from giornate_ispettive_per_conto_di c
										join oia_nodo o on o.id = c.id_percontodi
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);
	raise info 'json per conto di %', percontodi;

	emissioniatmosfera := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select e.fasi_lavorativa as "fasiLavorativa", c.note, 
											c.parametri_analizzati as "parametriAnalizzati", 
											e.codice_camino as "codiceCamino", e.id, 
											c.data_sopralluogo_2016 as "dataSopralluogo2016", 
											e.sistema_abbattimento as "sistemaAbbattimento", 
											e.inquinanti, c.esito_conforme as "esitoConforme",
											c.superamenti_limiti_normativi as "superamentiLimitiNormativi" 
											from  
											giornate_ispettive_emissioni_in_atmosfera_camini c
											join emissioni_in_atmosfera_camini e on e.id = c.id_emissioni_in_atmosfera_camini 
											join giornate_ispettive cu on cu.id = c.id_giornata_ispettiva
											where cu.trashed_date is null and c.trashed_date is null
											and c.id_giornata_ispettiva = _idgiornataispettiva) t);
												
	raise info 'json emissioni atmosfera %', emissioniatmosfera;

										
	fascicolo := (select json_object_agg(nome,descrizione) from (select 'numero' as nome,  numero as descrizione from fascicoli_ispettivi  where id in (select id_fascicolo_ispettivo from giornate_ispettive where id = _idgiornataispettiva and trashed_date is null) 
								union select 'id' as nome, id_fascicolo_ispettivo::text as descrizione from giornate_ispettive where id = _idgiornataispettiva) e); 
								
	raise info 'json fascicolo %', fascicolo;

	matrici := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id, c.conclusa
										from giornate_ispettive_matrici c
										join lookup_matrice_controlli l on l.code = c.id_matrice
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);

	raise info 'json matrici %', matrici;
		
	
	if (tecnicacu ->> 'id')::int = 2 then
		-- RECUPERO I MOTIVI E GLI ESAMI RICHIESTI
		motivi := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_motivi c
										join lookup_motivi l on l.code = c.id_motivo 
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);
		--motivi := (select json_object_agg('Motivi', motivi));
		raise info 'json motivi ricostruito %', motivi;

		esami := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_esami c
										join lookup_esami l on l.code = c.id_esame 
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);
		--esami := (select json_object_agg('Esami', esami));
		raise info 'json esami ricostruito %', esami;

		finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Tecnica":', tecnicacu, ',"Dati":', daticu, ',"Anagrafica":', anagrafica, ',"Utente":',utente, ',"Dipartimento":', dipartimento, ',"Linee":', linee, ',"GruppoIspettivo":', gruppoispettivo, 
		',"Esami":', esami,
		',"PerContoDi":', percontodi,
		',"TipiVerifica":', tipiverifica,
		',"FascicoloIspettivo":', fascicolo,
		',"Matrici":', coalesce(matrici,array_to_json('{}'::int[])),
		',"CampiServizio":', campiServizio,
		--',"FasiLavorazione":', coalesce(fasilavorazione,to_json('[]'::text)),
		',"EmissioniAtmosferaCamini":', coalesce(emissioniatmosfera,array_to_json('{}'::int[])),
		',"Motivi":', motivi)),'}'))::json);

		
	-- se si tratta di AIA ordinaria
	elsif (tecnicacu ->> 'id')::int = 1 then
		-- RECUPERO SOLO GLI ESAMI
		esami := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_esami c
										join lookup_esami l on l.code = c.id_esame 
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);
		--esami := (select json_object_agg('Esami', esami));
		raise info 'json esami ricostruito %', esami;

		finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Tecnica":', tecnicacu, ',"Dati":', daticu, ',"Anagrafica":', anagrafica, ',"Utente":',utente, ',"Dipartimento":', dipartimento, ',"Linee":', linee, ',"GruppoIspettivo":', gruppoispettivo, 
		',"Esami":', esami,
		',"PerContoDi":', percontodi,
		',"FascicoloIspettivo":', fascicolo,
		',"Matrici":', coalesce(matrici,array_to_json('{}'::int[])),
		',"CampiServizio":', campiServizio,
		--',"FasiLavorazione":', coalesce(fasilavorazione,to_json('[]'::text)),
		',"EmissioniAtmosferaCamini":', coalesce(emissioniatmosfera,array_to_json('{}'::int[])),
		',"TipiVerifica":', tipiverifica)),'}'))::json);
		
	else
		-- do nothing per altre tecniche
		RAISE INFO 'la tecnica non prevede aggiunte di campi';
		finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Tecnica":', tecnicacu, ',"Dati":', daticu, ',"Anagrafica":', anagrafica, ',"Utente":',utente, ',"Dipartimento":', dipartimento, ',"Linee":', linee, ',"GruppoIspettivo":', gruppoispettivo, 
		',"PerContoDi":', percontodi,
		',"FascicoloIspettivo":', fascicolo,
		',"Matrici":', coalesce(matrici,array_to_json('{}'::int[])),
		',"CampiServizio":', campiServizio,
		--',"FasiLavorazione":', coalesce(fasilavorazione,to_json('[]'::text)),
		',"EmissioniAtmosferaCamini":', coalesce(emissioniatmosfera,array_to_json('{}'::int[])),
		',"TipiVerifica":', tipiverifica)),'}'))::json);
	end if;
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$;

ALTER FUNCTION public.giornata_ispettiva_dettaglio_globale(integer)
    OWNER TO postgres;

DROP TABLE IF EXISTS public.campionamento_suolo_particelle_dati_verbale;

CREATE TABLE IF NOT EXISTS public.campionamento_suolo_particelle_dati_verbale
(
    id serial,
    id_campione integer,
    carabinieri_forestali text COLLATE pg_catalog."default",
    altri_partecipanti1 text COLLATE pg_catalog."default",
    proprietario_particella text COLLATE pg_catalog."default",
    presente_al_campionamento_in_qualita_di_1 text COLLATE pg_catalog."default",
    codice_identificativo_voc text COLLATE pg_catalog."default",
    codice_identificativo_c1 text COLLATE pg_catalog."default",
    codice_identificativo_c2 text COLLATE pg_catalog."default",
    codice_identificativo_c3 text COLLATE pg_catalog."default",
    codice_identificativo_c4 text COLLATE pg_catalog."default",
    codice_identificativo_c5 text COLLATE pg_catalog."default",
    codice_identificativo_medio_composito text COLLATE pg_catalog."default",
    coordinata_x_voc text COLLATE pg_catalog."default",
    coordinata_x_c1 text COLLATE pg_catalog."default",
    coordinata_x_c2 text COLLATE pg_catalog."default",
    coordinata_x_c3 text COLLATE pg_catalog."default",
    coordinata_x_c4 text COLLATE pg_catalog."default",
    coordinata_x_c5 text COLLATE pg_catalog."default",
    coordinata_x_medio_composito text COLLATE pg_catalog."default",
    coordinata_y_voc text COLLATE pg_catalog."default",
    coordinata_y_c1 text COLLATE pg_catalog."default",
    coordinata_y_c2 text COLLATE pg_catalog."default",
    coordinata_y_c3 text COLLATE pg_catalog."default",
    coordinata_y_c4 text COLLATE pg_catalog."default",
    coordinata_y_c5 text COLLATE pg_catalog."default",
    coordinata_y_medio_composito text COLLATE pg_catalog."default",
    num_campioni_elementari text COLLATE pg_catalog."default",
    particella_campionata text COLLATE pg_catalog."default",
    prodotti_coltivati text COLLATE pg_catalog."default",
    presenza_rifiuti text COLLATE pg_catalog."default",
    id_utente integer,
    trashed_date timestamp without time zone,
    prodotti_coltivati_note text COLLATE pg_catalog."default",
    id_area_particelle integer,
    aliquota_cd_fitofarmaci boolean,
    aliquota_e boolean,
    aliquota_f boolean,
    aliquota_h boolean,
    aliquota_i boolean,
    aliquota_lm boolean,
    aliquota_n boolean,
    presente_al_campionamento_in_qualita_di_2 text COLLATE pg_catalog."default",
    presente_al_campionamento_in_qualita_di_3 text COLLATE pg_catalog."default",
    dati_altra_persona_presente text COLLATE pg_catalog."default",
    qualita_altra_persona_presente text COLLATE pg_catalog."default",
    altri_partecipanti2 text COLLATE pg_catalog."default",
    altri_partecipanti3 text COLLATE pg_catalog."default",
    presenza_rifiuti_note text COLLATE pg_catalog."default",
    tipo_coltura_motivazione text COLLATE pg_catalog."default",
    presenza_rifiuti_descrizione text COLLATE pg_catalog."default",
    proprietario_presente boolean,
    irrigazione_in_loco text COLLATE pg_catalog."default",
    irrigazione_informazioni text COLLATE pg_catalog."default",
    irrigazione_derivazione text COLLATE pg_catalog."default",
    pozzo_campionamento text COLLATE pg_catalog."default",
    pozzo_campionamento_verbale_numero text COLLATE pg_catalog."default",
    pozzo_campionamento_verbale_data text COLLATE pg_catalog."default",
    dichiarazioni text COLLATE pg_catalog."default",
    strumentazione text COLLATE pg_catalog."default",
    note_aggiuntive text COLLATE pg_catalog."default",
    aliquota_a boolean,
    aliquota_bg boolean,
    aliquota_c boolean,
    aliquota_d boolean,
    aliquota_a_data text COLLATE pg_catalog."default",
    aliquota_bg_data text COLLATE pg_catalog."default",
    aliquota_c_data text COLLATE pg_catalog."default",
    aliquota_d_data text COLLATE pg_catalog."default",
    aliquota_e_data text COLLATE pg_catalog."default",
    aliquota_f_data text COLLATE pg_catalog."default",
    aliquota_h_data text COLLATE pg_catalog."default",
    aliquota_i_data text COLLATE pg_catalog."default",
    aliquota_lm_data text COLLATE pg_catalog."default",
    aliquota_n_data text COLLATE pg_catalog."default",
    aliquota_a_ora text COLLATE pg_catalog."default",
    aliquota_bg_ora text COLLATE pg_catalog."default",
    aliquota_c_ora text COLLATE pg_catalog."default",
    aliquota_d_ora text COLLATE pg_catalog."default",
    aliquota_e_ora text COLLATE pg_catalog."default",
    aliquota_f_ora text COLLATE pg_catalog."default",
    aliquota_h_ora text COLLATE pg_catalog."default",
    aliquota_i_ora text COLLATE pg_catalog."default",
    aliquota_lm_ora text COLLATE pg_catalog."default",
    aliquota_n_ora text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.campionamento_suolo_particelle_dati_verbale
    OWNER to postgres;
    
 alter table area_particelle add column sezione text;
	drop function public.insert_subparticella(integer, text, text, text, text, integer);
CREATE OR REPLACE FUNCTION public.insert_subparticella(
	_id_padre integer,
	_codice_sito text,
	_sezione text,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE 
	id_subparticella integer;
BEGIN	
	insert into area_particelle(codice_sito, sezione, id_padre, entered, entered_by) 
	values(_codice_sito,
	_sezione,
	_id_padre,
	now(),
	_id_utente) returning id into id_subparticella;

	return id_subparticella;
	      
END;
$BODY$;

ALTER FUNCTION public.insert_subparticella(integer, text, text,integer)
    OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.update_subparticella(
	_id integer,
	_id_padre integer,
	_codice_sito text,
	_sezione text,
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
	sezione = _sezione, 
	id_padre = _id_padre, 
	modified= now(),
	modified_by = _id_utente
	where id = _id and trashed_date is null;

	return _id;
	      
END;
$BODY$;

ALTER FUNCTION public.update_subparticella(integer, integer, text, text,integer)
    OWNER TO postgres;
    
CREATE OR REPLACE FUNCTION public.get_dettaglio_particella(
	_id integer)
    RETURNS TABLE(id integer, codice_sito text, id_comune integer, id_provincia integer, 
				  descrizione_comune text, descrizione_provincia text, foglio_catastale text, 
				  particella_catastale text, classe_rischio text, coordinate_x text, coordinate_y text, 
				  sezione text, area text, note text, id_padre integer, id_sito text, entered timestamp without time zone, entered_by integer, modified timestamp without time zone, modified_by integer, trashed_date timestamp without time zone) 
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


insert into role(role_id, role, description, enteredby, entered, modifiedby, modified, enabled, super_ruolo,
				descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica,
				view_lista_utenti_nucleo_ispettivo) values (
				9, 'Tecnico campionamento','Tecnico campionamento', 964, current_timestamp,
				964, current_timestamp, true, 1,'RUOLO GISA', true, false, false,true,  true);

CREATE OR REPLACE FUNCTION public.campionamento_particella_insert_globale(
	_json_dati json)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	
	idcontrollo integer;
	idutente integer;
	id_campionamento_suolo integer;
	idcampione integer;
	idfascicolo integer;
	output integer;
	id_dipartimento integer;
	
	utenti json;
	anagrafica json;
	datigenerici json;
	motivo json; -- scelta del tipo di campionamento
	tecnicacu json;
	laboratorio json;
	dativerbale json;
	gruppoaddetti json;
	gruppotecnici json;
	matrici json;
	
BEGIN
	
	utenti :=  _json_dati ->'Utente';
	RAISE INFO 'json utenti %',utenti;
	
	idutente := utenti -> 'userId';
	RAISE INFO 'idutente %',idutente;
	
	anagrafica :=  _json_dati ->'Anagrafica';
	RAISE INFO 'json anagrafica %',anagrafica;
	
	datigenerici :=  _json_dati ->'Dati';
	RAISE INFO 'json dati generici %',datigenerici;
	
	tecnicacu :=  _json_dati ->'Tecnica';
	RAISE INFO 'json tecnica %', tecnicacu;
	
	gruppotecnici :=  _json_dati ->'GruppoTecnici';
	RAISE INFO 'json Gruppo Tecnici %', gruppotecnici;
		
	gruppoaddetti  := _json_dati ->'GruppoAddetti';
	RAISE INFO 'json Gruppo Addetti %', gruppoaddetti;
	
	laboratorio :=  _json_dati ->'Laboratorio';
	RAISE INFO 'json dati laboratorio %', laboratorio;
	
	motivo :=  _json_dati ->'Motivo';
	RAISE INFO 'json dati motivo/scelta campionamento %', motivo;
	
	dativerbale :=  _json_dati ->'DatiVerbaleCampione';
	RAISE INFO 'json dati generici %', dativerbale;
	
	matrici :=  _json_dati ->'Matrici';
	RAISE INFO 'json dati generici %', matrici;
	
	-- inserisco nel log il json
	-- STEP 0: INSERIAMO IL RECORD JSON PER LOG
	INSERT INTO campionamento_particelle_log_json(enteredby, json_cp) values(idutente,_json_dati);
	
	-- STEP 1: fascicolo ispettivo fittizio 
	idfascicolo := (SELECT * from public.fascicolo_ispettivo_insert(anagrafica, idutente));
	update fascicoli_ispettivi set 
	data_inizio  = (datigenerici ->> 'dataPrelievo')::timestamp without time zone, 
	numero =  (anagrafica ->> 'riferimentoId')::text,
	note = 'INSERIMENTO FASCICOLO FITTIZIO PER CAMPIONAMENTO SUOLO'
    where id = idfascicolo;
	
	-- STEP 2: inserisco cu fittizio
	idcontrollo := (SELECT * from public.giornata_ispettiva_insert_anagrafica(anagrafica, idutente));	
	-- STEP 2.1: INSERIAMO LA TECNICA
	output := (SELECT * from public.giornata_ispettiva_insert_tecnica(tecnicacu, idcontrollo));

	-- STEP 2.2: AGGIORNAMENTO DATI CU 
	update giornate_ispettive 
	set stato=3, 
	note = 'INSERIMENTO CU FITTIZIO PER CAMPIONAMENTO SUOLO', 
	id_dipartimento =(select codiceistatasl::integer from comuni1 where id = (anagrafica ->> 'comune')::integer), 
	id_fascicolo_ispettivo = idfascicolo, 
	data_inizio  = (datigenerici ->> 'dataPrelievo')::timestamp without time zone, 
	data_fine = (datigenerici ->> 'dataPrelievo')::timestamp without time zone, 
	ore = (datigenerici ->> 'ore'), 
	ora_fine = (datigenerici ->> 'ore')
	where id = idcontrollo;
	
	-- STEP 2.3: INSERIAMO I COMPONENTI DEL NUCLEO
	output := (SELECT * FROM public.giornata_ispettiva_insert_gruppo_ispettivo(gruppotecnici,idcontrollo));
	
	
	-- STEP 2.4: INSERIAMO la matrice
	output :=(SELECT * from public.giornata_ispettiva_insert_matrici(matrici, idcontrollo, idutente));
	
	--STEP 3: inserisco campione fittizio (note e dataPrelievo)
	idcampione := (SELECT * from public.campione_insert(datigenerici, idutente));
	update campioni set 
	id_laboratorio= (laboratorio->>'id')::int, 
	num_verbale=case when (datigenerici ->> 'numeroVerbale') <> 'AUTOMATICO' then (datigenerici ->> 'numeroVerbale') else lpad(id::text, 6, '0') end,
	id_motivazione = (motivo ->> 'id')::integer,
	note=concat_ws('-', note, 'INSERIMENTO CAMPIONE FITTIZIO PER CAMPIONAMENTO SUOLO'),
	id_giornata_ispettiva = idcontrollo  
	where id = idcampione;

	
	--STEP 4: inserisco dati del verbale
	id_campionamento_suolo := (select * from campionamento_suolo_insert_dati_verbale(dativerbale,idutente));
	update campionamento_suolo_particelle_dati_verbale 
	set id_campione= idcampione
	where id = id_campionamento_suolo;
	
	-- STEP 3.1: INSERIAMO IL GRUPPO ADDETTI MULTISERVIZI
	output := (SELECT * from public.campione_insert_gruppo_addetti(gruppoaddetti, idcampione));
	
	-- STEP 3.2: INSERIAMO I COMPONENTI DEL NUCLEO
	output := (SELECT * FROM public.campione_insert_gruppo_tecnici(gruppotecnici,idcampione));

	
	return idcampione;
END;
$BODY$;

ALTER FUNCTION public.campionamento_particella_insert_globale(json)
    OWNER TO postgres;

DROP FUNCTION IF EXISTS public.campione_insert_gruppo_multiservizi(json, integer);
CREATE TABLE IF NOT EXISTS public.campione_gruppo_addetti
(
    id integer NOT NULL DEFAULT nextval('campione_gruppo_multiservizi_id_seq'::regclass),
    id_componente integer,
    enabled boolean DEFAULT true,
    id_campione integer
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.campione_gruppo_addetti
    OWNER to postgres;
CREATE OR REPLACE FUNCTION public.campione_insert_gruppo_addetti(
	_json_dati json,
	_idcampione integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_dati) 
	  LOOP
		 INSERT INTO campione_gruppo_addetti (id_campione, id_componente, enabled) values (_idcampione, (i->>'id')::integer,true);
	  END LOOP;

    	 return 1;
END;
$BODY$;

ALTER FUNCTION public.campione_insert_gruppo_addetti(json, integer)
    OWNER TO postgres;
    
CREATE TABLE IF NOT EXISTS public.campione_gruppo_tecnici
(
    id serial,
    id_componente integer,
    enabled boolean DEFAULT true,
    id_campione integer
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.campione_gruppo_tecnici
    OWNER to postgres;
CREATE OR REPLACE FUNCTION public.campione_insert_gruppo_tecnici(
	_json_dati json,
	_idcampione integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	i json; 
BEGIN
	   FOR i IN SELECT * FROM json_array_elements(_json_dati) 
	  LOOP
		 INSERT INTO campione_gruppo_tecnici (id_campione, id_componente, enabled) values (_idcampione, (i->>'id')::integer,true);
	  END LOOP;

    	 return 1;
END;
$BODY$;

ALTER FUNCTION public.campione_insert_gruppo_tecnici(json, integer)
    OWNER TO postgres;
    
drop function public.giornata_ispettiva_insert_gruppo_tecnici(json, integer);
-- FUNCTION: public.campionamento_particella_dettaglio_globale(integer)
CREATE OR REPLACE FUNCTION public.campionamento_suolo_insert_dati_verbale(
	_json_dati json,
	_idutente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	result integer;
	
BEGIN
	     INSERT INTO campionamento_suolo_particelle_dati_verbale 
		  						   (carabinieri_forestali, 
									altri_partecipanti1,
									altri_partecipanti2,
									altri_partecipanti3,
									proprietario_particella,
									presente_al_campionamento_in_qualita_di_1,
									presente_al_campionamento_in_qualita_di_2,
									presente_al_campionamento_in_qualita_di_3,
									dati_altra_persona_presente,
									qualita_altra_persona_presente,
									proprietario_presente,
									irrigazione_in_loco, 
									dichiarazioni,
									strumentazione, 
									note_aggiuntive,
									irrigazione_informazioni,
									irrigazione_derivazione,
									pozzo_campionamento,
									pozzo_campionamento_verbale_numero,
									pozzo_campionamento_verbale_data,
									codice_identificativo_voc,
									codice_identificativo_c1,
									codice_identificativo_c2,
									codice_identificativo_c3,
									codice_identificativo_c4,
									codice_identificativo_c5,
									codice_identificativo_medio_composito,
									coordinata_x_voc,
									coordinata_x_c1,
									coordinata_x_c2,
									coordinata_x_c3,
									coordinata_x_c4,
									coordinata_x_c5,
									coordinata_x_medio_composito,
									coordinata_y_voc,
									coordinata_y_c1,
									coordinata_y_c2,
									coordinata_y_c3,
									coordinata_y_c4,
									coordinata_y_c5,
									coordinata_y_medio_composito,
									num_campioni_elementari,
									particella_campionata,
									prodotti_coltivati,
									prodotti_Coltivati_note,
									tipo_coltura_motivazione,
									aliquota_a,
									aliquota_bg,
									aliquota_c,
									aliquota_d,
									aliquota_e,
									aliquota_f,
									aliquota_h,
									aliquota_i,
									aliquota_lm,
									aliquota_n,
									aliquota_a_data,
									aliquota_bg_data,
									aliquota_c_data,
									aliquota_d_data,
									aliquota_e_data,
									aliquota_f_data,
									aliquota_h_data,
									aliquota_i_data,
									aliquota_lm_data,
									aliquota_n_data,
									aliquota_a_ora,
									aliquota_bg_ora,
									aliquota_c_ora,
									aliquota_d_ora,
									aliquota_e_ora,
									aliquota_f_ora,
									aliquota_h_ora,
									aliquota_i_ora,
									aliquota_lm_ora,
									aliquota_n_ora,
									aliquota_cd_fitofarmaci,
									presenza_rifiuti,
									presenza_rifiuti_descrizione,
									presenza_rifiuti_note,
								    id_utente) values
									((_json_dati ->>'carabinieriForestali')::text,
									 (_json_dati ->>'altriPartecipanti1')::text,
									 (_json_dati ->>'altriPartecipanti2')::text,
									 (_json_dati ->>'altriPartecipanti3')::text,
									 (_json_dati ->>'datiProprietarioParticella')::text,
									 (_json_dati ->>'qualitaAltriPartecipanti1')::text,
									 (_json_dati ->>'qualitaAltriPartecipanti2')::text,
									 (_json_dati ->>'qualitaAltriPartecipanti3')::text,
									 (_json_dati ->>'datiAltraPersonaPresente')::text,
									 (_json_dati ->>'qualitaAltraPersonaPresente')::text,
									 (_json_dati ->>'proprietarioPresente')::boolean,
									 (_json_dati ->>'irrigazioneInLoco')::boolean,
									 (_json_dati ->>'dichiarazioni')::text,
									 (_json_dati ->>'strumentazione')::text,
									 (_json_dati ->>'noteAggiuntive')::text,
									 (_json_dati ->>'irrigazioneInformazioni')::text, 
									 (_json_dati ->>'irrigazioneDerivazione')::text, 
									 (_json_dati ->>'pozzoCampionamento')::text,
									 (_json_dati ->>'pozzoCampionamentoVerbaleNumero')::text,
									 (_json_dati ->>'pozzoCampionamentoVerbaleData')::text,
									 (_json_dati ->>'codiceIdentificativoVoc')::text,
									 (_json_dati ->>'codiceIdentificativo1')::text,
									 (_json_dati ->>'codiceIdentificativo2')::text,
									 (_json_dati ->>'codiceIdentificativo3')::text,
									 (_json_dati ->>'codiceIdentificativo4')::text,
									 (_json_dati ->>'codiceIdentificativo5')::text,
									 (_json_dati ->>'codiceIdentificativoMedioComposito')::text,
									 (_json_dati ->>'coordinataXVoc')::text,
									 (_json_dati ->>'coordinataX1')::text,
									 (_json_dati ->>'coordinataX2')::text,
									 (_json_dati ->>'coordinataX3')::text,
									 (_json_dati ->>'coordinataX4')::text,
									 (_json_dati ->>'coordinataX5')::text,
									 (_json_dati ->>'coordinataXMedioComposito')::text,
									 (_json_dati ->>'coordinataYVoc')::text,
									 (_json_dati ->>'coordinataY1')::text,
									 (_json_dati ->>'coordinataY2')::text,
									 (_json_dati ->>'coordinataY3')::text,
									 (_json_dati ->>'coordinataY4')::text,
									 (_json_dati ->>'coordinataY5')::text,
									 (_json_dati ->>'coordinataYMedioComposito')::text,
									 (_json_dati ->>'numCampioniElementari')::text,
									 (_json_dati ->>'tipoColturaCodice')::text,
									 (_json_dati ->>'tipoColturaDescrizione')::text,
									 (_json_dati ->>'tipoColturaNote')::text,
									 -- nuove aliquote
									 (_json_dati ->>'tipoColturaMotivazione')::text,
									 coalesce((_json_dati->>'aliquotaA')::boolean,false),
									 coalesce((_json_dati->>'aliquotaBG')::boolean,false),
									 coalesce((_json_dati->>'aliquotaC')::boolean,false),
									 coalesce((_json_dati->>'aliquotaD')::boolean,false),
									 coalesce((_json_dati->>'aliquotaE')::boolean,false),
									 coalesce((_json_dati->>'aliquotaF')::boolean,false),
									 coalesce((_json_dati->>'aliquotaH')::boolean,false),
									 coalesce((_json_dati->>'aliquotaI')::boolean,false),
									 coalesce((_json_dati->>'aliquotaLM')::boolean,false),
									 coalesce((_json_dati->>'aliquotaN')::boolean,false),
									  (_json_dati ->>'aliquotaA_data')::text,
									  (_json_dati ->>'aliquotaBG_data')::text,
									  (_json_dati ->>'aliquotaC_data')::text,
									  (_json_dati ->>'aliquotaD_data')::text,
									  (_json_dati ->>'aliquotaE_data')::text,
									  (_json_dati ->>'aliquotaF_data')::text,
									  (_json_dati ->>'aliquotaH_data')::text,
									  (_json_dati ->>'aliquotaI_data')::text,
									  (_json_dati ->>'aliquotaLM_data')::text,
									  (_json_dati ->>'aliquotaN_data')::text,
									 (_json_dati ->>'aliquotaA_ora')::text,
									  (_json_dati ->>'aliquotaBG_ora')::text,
									  (_json_dati ->>'aliquotaC_ora')::text,
									  (_json_dati ->>'aliquotaD_ora')::text,
									  (_json_dati ->>'aliquotaE_ora')::text,
									  (_json_dati ->>'aliquotaF_ora')::text,
									  (_json_dati ->>'aliquotaH_ora')::text,
									  (_json_dati ->>'aliquotaI_ora')::text,
									  (_json_dati ->>'aliquotaLM_ora')::text,
									  (_json_dati ->>'aliquotaN_ora')::text,
									  coalesce((_json_dati->>'aliquotaCD_fitofarmaci')::boolean,false),
									  (_json_dati ->>'presenzaRifiuti')::text, 
									  (_json_dati ->>'presenzaRifiutiDescrizione')::text,
									  (_json_dati ->>'presenzaRifiutiNote')::text,
									  _idutente)
			returning id into result;
		return result;
END;
$BODY$;

ALTER FUNCTION public.campionamento_suolo_insert_dati_verbale(json, integer)
    OWNER TO postgres;

    -- FUNCTION: public.campionamento_particella_dettaglio_globale(integer)
-- DROP FUNCTION IF EXISTS public.campionamento_particella_dettaglio_globale(integer);

-- FUNCTION: public.campionamento_particella_dettaglio_globale(integer)
-- DROP FUNCTION IF EXISTS public.campionamento_particella_dettaglio_globale(integer);

CREATE OR REPLACE FUNCTION public.campionamento_particella_dettaglio_globale(
	_idcampione integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

	
DECLARE
	campiservizio json;
	laboratorio json;
	finale json;
	utente json;
	dati json;
	anagrafica json;
	gruppotecnici json;
	gruppoispettivo json;
	gruppoaddetti json;
	dativerbalecampione json;
	tecnicacu json;
	matrici json;
	motivo json;
	test text;
	id_dipartimento integer;
	idgiornataispettiva integer;
	riferimento_id integer;
	id_tecnica integer;

BEGIN

	idgiornataispettiva :=(select c.id_giornata_ispettiva from campioni c where c.id = _idcampione);
	raise info 'ID GIORNATA ISPETTIVA: %', idgiornataispettiva;
	riferimento_id := (select g.riferimento_id from giornate_ispettive g where g.trashed_date is null and g.id = idgiornataispettiva);
	id_tecnica := (select g.id_tecnica from giornate_ispettive g where g.trashed_date is null and g.id = idgiornataispettiva);
	-- STEP 1: recuperiamo i campi del campione
	laboratorio := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, (l.description)::text as descrizione from lookup_destinazione_campione l join campioni c on c.id_laboratorio= l.code
							               union select 'id' as nome,  (l.code)::text from  lookup_destinazione_campione l join campioni c on c.id_laboratorio= l.code) a);
	
	raise info 'LABORATORIO: %', laboratorio;        
	
	motivo := (select json_object_agg(nome,descrizione) from (select 'descrizione' as nome, (l.description)::text as descrizione from lookup_campionamento_particella 
															  l join campioni c on c.id_motivazione = l.code where c.id = _idcampione
							              			 			union select 'id' as nome, (l.code)::text from  lookup_campionamento_particella l 
															  	join campioni c on c.id_motivazione = l.code
																where c.id = _idcampione) a);
	raise info 'MOTIVO: %', motivo;  	
	
	anagrafica := (select json_object_agg(nome,descrizione) from (
														select 'particellaCatastale' as nome, p.particella_catastale as descrizione
														from area_particelle a
														join area_particelle p on a.id_padre=p.id 
														where p.trashed_date is null and a.id = riferimento_id
														union
														select 'codiceSito' as nome, a.codice_sito
														from area_particelle a
														join area_particelle p on a.id_padre=p.id 
														where p.trashed_date is null and a.id = riferimento_id
														union 
														select 'foglioCatastale' as nome, p.foglio_catastale
														from area_particelle a
														join area_particelle p on a.id_padre=p.id 
														where p.trashed_date is null and a.id = riferimento_id	
														union
														select 'riferimentoId' as nome, id::text
														from area_particelle
														where id = riferimento_id	
														union
														select 'comune' as nome, c.nome::text
														from area_particelle a
														join area_particelle p on a.id_padre=p.id 
														join comuni1 c on c.id=p.id_comune
														where a.id = riferimento_id	
														union
														select 'provincia' as nome, lp.description::text
														from area_particelle a
														join area_particelle p on a.id_padre=p.id 
														join comuni1 c on c.id=p.id_comune
														join lookup_province lp on lp.code=c.cod_provincia::integer
														where a.id = riferimento_id	
														union
														select 'classeRischio' as nome, p.classe_rischio
														from area_particelle a
														join area_particelle p on a.id_padre=p.id 
														where p.trashed_date is null and a.id = riferimento_id	
														union
														select 'area' as nome, p.area
														from area_particelle a
														join area_particelle p on a.id_padre=p.id 
														where  p.trashed_date is null and a.id = riferimento_id
														union
														select 'coordinateX' as nome, coordinate_x
														from area_particelle
														where id = riferimento_id
														union
														select 'coordinateY' as nome, coordinate_y
														from area_particelle
														where id = riferimento_id
														union
														select 'riferimentoIdNomeTab' as nome, 'area_particelle'							        	
							        				) a);
	raise info 'ANAGRAFICA: %', anagrafica;        

	tecnicacu := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, description as descrizione from lookup_tipo_controllo where code = id_tecnica 
							union select 'id' as nome,  id_tecnica::text) a); 
							
	raise info 'TECNICA: %', tecnicacu;  
	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from campioni where id = _idcampione) a);				             
 
 	raise info 'UTENTE: %', utente; 
	dati := (select json_object_agg(nome,descrizione) from (
															select 'dataPrelievo' as nome, (data_prelievo)::text as descrizione
															from campioni c where c.id = _idcampione
															union select 'numeroVerbale' as nome, num_verbale
															from campioni c where c.id = _idcampione
															union select 'ore' as nome, g.ore
															from campioni c join 
															giornate_ispettive g on g.id = c.id_giornata_ispettiva
															where c.id = _idcampione					
							        					) a);	
	raise info 'DATI: %', dati; 
	--STEP gruppo ispettivo
	gruppoispettivo := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (
										select distinct 
										d.nominativo as nominativo, c.id_componente as id, d.qualifica as qualifica, c.nome_struttura as struttura,
							            (select g.addetto_campionamento as "addettoCampionamento" from giornata_ispettiva_gruppo_ispettivo g where g.id_giornata_ispettiva = idgiornataispettiva and g.enabled and g.id_componente=c.id_componente),
										(select g.tecnico_campionamento as "tecnicoCampionamento" from giornata_ispettiva_gruppo_ispettivo g where g.id_giornata_ispettiva = idgiornataispettiva and g.enabled and g.id_componente=c.id_componente)
										from campione_gruppo_ispettivo c
										join public.dpat_get_nominativi(-1, (select date_part('year',data_prelievo)::integer from campioni where id = _idcampione),null,null,null,c.id_struttura,null,-1) d on d.id_anagrafica_nominativo = c.id_componente
										left join access_ ac on ac.user_id = c.id_componente
										where c.id_campione = _idcampione) t);
	
	raise info 'GRUPPO tecnici: %', gruppotecnici;		
	gruppoaddetti :=(SELECT array_to_json(array_agg(row_to_json(t))) from (
							select concat_ws(' ', co.namefirst, co.namelast)::text as nominativo, 'ARPAC MULTISERVIZI' as qualifica, m.id_componente as id
								          from access a 
								          join contact co on co.contact_id = a.contact_id
										  left join campione_gruppo_addetti m on m.id_componente= a.user_id
									      where m.enabled and m.id_campione = _idcampione
								  ) t
				);
	
	raise info 'GRUPPO ADDETTI: %', gruppoaddetti;
	
	gruppotecnici :=(SELECT array_to_json(array_agg(row_to_json(t))) from (
							select concat_ws(' ', co.namefirst, co.namelast)::text as nominativo, 'TECNICO CAMPIONAMENTO' as qualifica, m.id_componente as id
								          from access a 
								          join contact co on co.contact_id = a.contact_id
										  left join campione_gruppo_tecnici m on m.id_componente= a.user_id
									      where m.enabled and m.id_campione = _idcampione
								  ) t
	);
	
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from campioni c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where c.id = _idcampione and c.trashed_date is null
								  union select 'dataInserimento' as nome, entered::text as descrizione from campioni where id = _idcampione
								  union select 'idCampione' as nome, id::text as descrizione from campioni where id = _idcampione 
								  ) b);
								  
	raise info 'CAMPI SERVIZIO: %', campiservizio;	
	matrici := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id
										from giornate_ispettive_matrici c
										join lookup_matrice_controlli l on l.code = c.id_matrice
										where c.id_giornata_ispettiva = idgiornataispettiva) t);
										
	raise info 'CAMPI MATRICI: %', matrici;	
	dativerbalecampione := (SELECT json_object_agg(name, value)
															 FROM (VALUES
																('numCampioniElementari', to_json(t1.num_campioni_elementari)),   
																('presenzaRifiuti', to_json(t1.presenza_rifiuti)),  
																('codiceIdentificativoMedioComposito', to_json(t1.codice_identificativo_medio_composito)),  
																('codiceIdentificativo1', to_json(t1.codice_identificativo_c1)),
																('codiceIdentificativo2', to_json(t1.codice_identificativo_c2)),   
																('codiceIdentificativo3', to_json(t1.codice_identificativo_c3)),
																('codiceIdentificativo4', to_json(t1.codice_identificativo_c4)),   
																('codiceIdentificativo5', to_json(t1.codice_identificativo_c5)),
																('coordinataX5', to_json(t1.coordinata_x_c5)),
																('coordinataX4', to_json(t1.coordinata_x_c4)),
																('coordinataX3', to_json(t1.coordinata_x_c3)),
																('coordinataX2', to_json(t1.coordinata_x_c2)),
																('coordinataX1', to_json(t1.coordinata_x_c1)),
																('coordinataY5', to_json(t1.coordinata_y_c5)),  
																('coordinataY4', to_json(t1.coordinata_y_c4)),
																('coordinataY3', to_json(t1.coordinata_y_c3)),
																('coordinataY2', to_json(t1.coordinata_y_c2)),
																('coordinataY1', to_json(t1.coordinata_y_c1)),
																('codiceIdentificativoVoc', to_json(t1.codice_identificativo_voc)),   
																('coordinataYVoc', to_json(t1.coordinata_y_voc)),
																('coordinataXVoc', to_json(t1.coordinata_x_voc)),  
																('tipoColturaDescrizione', to_json(t1.prodotti_coltivati)),
																('tipoColturaCodice', to_json(t1.particella_campionata)),   
																('tipoColturaNote', to_json(t1.prodotti_coltivati_note)),   
																('altriPartecipanti1', to_json(t1.altri_partecipanti1)),
																('altriPartecipanti2', to_json(t1.altri_partecipanti2)),
																('altriPartecipanti3', to_json(t1.altri_partecipanti3)),
																('datiProprietarioParticella', to_json(t1.proprietario_particella)),   
																('carabinieriForestali', to_json(t1.carabinieri_forestali)),   
																('qualitaAltriPartecipanti1', to_json(t1.presente_al_campionamento_in_qualita_di_1)),
																('qualitaAltriPartecipanti2', to_json(t1.presente_al_campionamento_in_qualita_di_2)),
																('qualitaAltriPartecipanti3', to_json(t1.presente_al_campionamento_in_qualita_di_3)),
																('proprietarioPresente', to_json(t1.proprietario_presente)),  
																('datiAltraPersonaPresente', to_json(t1.dati_altra_persona_presente)),  
																('qualitaAltraPersonaPresente', to_json(t1.qualita_altra_persona_presente)), 								   
																('irrigazioneInLoco', to_json(t1.irrigazione_in_loco::boolean)), 
																('irrigazioneInformazioni', to_json(t1.irrigazione_informazioni)), 
																('irrigazioneDerivazione', to_json(t1.irrigazione_derivazione)), 
																('pozzoCampionamento', to_json(t1.pozzo_campionamento::boolean)),
																('pozzoCampionamentoVerbaleNumero', to_json(t1.pozzo_campionamento_verbale_numero)), 
																('pozzoCampionamentoVerbaleData', to_json(t1.pozzo_campionamento_verbale_data)), 
																('dichiarazioni', to_json(t1.dichiarazioni)), 
																('strumentazione', to_json(t1.strumentazione)), 
																('noteAggiuntive', to_json(t1.note_aggiuntive)),    
																('tipoColturaMotivazione', to_json(t1.tipo_coltura_motivazione)),  
																('presenzaRifiutiDescrizione', to_json(t1.presenza_rifiuti_descrizione)),  
																('presenzaRifiutiNote', to_json(t1.presenza_rifiuti_note)),  
																('aliquotaA', to_json(t1.aliquota_a)),
																('aliquotaBG', to_json(t1.aliquota_bg)),
																('aliquotaC', to_json(t1.aliquota_c)),   
																('aliquotaD', to_json(t1.aliquota_d)),  
																('aliquotaE', to_json(t1.aliquota_e)), 
																('aliquotaF', to_json(t1.aliquota_f)), 
																('aliquotaH', to_json(t1.aliquota_h)),  
																('aliquotaI', to_json(t1.aliquota_i)),
																('aliquotaLM', to_json(t1.aliquota_lm)),
																('aliquotaN', to_json(t1.aliquota_n)),
																('aliquotaA_data', to_json(t1.aliquota_a_data)),
																('aliquotaBG_data', to_json(t1.aliquota_bg_data)),
																('aliquotaC_data', to_json(t1.aliquota_c_data)),   
																('aliquotaD_data', to_json(t1.aliquota_d_data)),  
																('aliquotaE_data', to_json(t1.aliquota_e_data)), 
																('aliquotaF_data', to_json(t1.aliquota_f_data)), 
																('aliquotaH_data', to_json(t1.aliquota_h_data)),  
																('aliquotaI_data', to_json(t1.aliquota_i_data)),
																('aliquotaLM_data', to_json(t1.aliquota_lm_data)),
																('aliquotaN_data', to_json(t1.aliquota_n_data)),
																('aliquotaA_ora', to_json(t1.aliquota_a_ora)),
																('aliquotaBG_ora', to_json(t1.aliquota_bg_ora)),
																('aliquotaC_ora', to_json(t1.aliquota_c_ora)),   
																('aliquotaD_ora', to_json(t1.aliquota_d_ora)),  
																('aliquotaE_ora', to_json(t1.aliquota_e_ora)), 
																('aliquotaF_ora', to_json(t1.aliquota_f_ora)), 
																('aliquotaH_ora', to_json(t1.aliquota_h_ora)),  
																('aliquotaI_ora', to_json(t1.aliquota_i_ora)),
																('aliquotaLM_ora', to_json(t1.aliquota_lm_ora)),
																('aliquotaN_ora', to_json(t1.aliquota_n_ora)),
																('aliquotaCD_fitofarmaci', to_json(t1.aliquota_cd_fitofarmaci))
																) AS props(name, value)
															 WHERE value IS NOT NULL
															) AS json
														FROM campionamento_suolo_particelle_dati_verbale as t1
														WHERE t1.id_campione = _idcampione	and t1.trashed_date is null;
														
		
	raise info 'CAMPI DATI VERBALE: %', dativerbalecampione;	

	finale := (select unaccent(concat('{',
		(select concat_ws(' ', 
		'"Dati":', dati, 
		',"Anagrafica":', anagrafica, 
		',"Utente":',utente, 
		',"Laboratorio":', laboratorio,
		',"Motivo":', motivo,
		',"GruppoTecnici":',  coalesce (gruppotecnici,'[{}]'),
		',"GruppoAddetti":', coalesce (gruppoaddetti,'[{}]'),
		',"CampiServizio":', campiServizio,
		',"DatiVerbaleCampione":', dativerbalecampione,
		',"Matrici":', matrici)),'}'))::json);
		
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$;

ALTER FUNCTION public.campionamento_particella_dettaglio_globale(integer)
    OWNER TO postgres;

select max(id) from role_permission
ALTER SEQUENCE role_permission_id_seq RESTART WITH ?;


-- ripristino dbi
CREATE OR REPLACE FUNCTION public.non_conformita_lista_globale(_id_giornata_ispettiva integer)
  RETURNS json AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select id as "idNonConformita", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from non_conformita c  
										join access a on a.user_id = c.enteredby 
										join contact co on co.contact_id = a.contact_id
										where c.id_giornata_ispettiva = _id_giornata_ispettiva 
									) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.non_conformita_lista_globale(integer)
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.non_conformita_insert_globale(_json_dati json)
  RETURNS integer AS
$BODY$	
DECLARE
	datigiornataispettiva json; 
	utente json;
	motivazione json;
	linea json;
	dati json;
	
	idnc integer;
	idutente integer;
	output integer;
	
BEGIN
	 -- mi ricavo i singoli oggetti JSON per blocchi
	datigiornataispettiva :=  _json_dati ->'DatiGiornataIspettiva';
	RAISE INFO 'json datigiornataispettiva %',datigiornataispettiva;

	dati :=  _json_dati ->'Dati'; 
	RAISE INFO 'json dati %',dati;

	utente :=  _json_dati ->'Utente';
	RAISE INFO 'json utenti %',utente;
	
	idutente := utente -> 'userId';
	RAISE INFO 'idutente %',idutente;

	motivazione :=  _json_dati ->'TipoVerifica';
	RAISE INFO 'json motivazione %',motivazione;

	linea :=  _json_dati ->'Linea';
	RAISE INFO 'json TipiVerifica %',linea;
	
	-- STEP 0: INSERIAMO IL RECORD JSON PER LOG
	INSERT INTO giornate_ispettive_log_json(enteredby, json_cu) values(idutente,_json_dati);
	
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: INSERIAMO IL RECORD IN NC
	idnc := (SELECT * from public.non_conformita_insert(dati, idutente));

	-- STEP 4: INSERIAMO GLI ALTRI DATI DELLA NC
	update non_conformita set id_linea = (linea ->> 'id')::integer, id_tipo_verifica = (motivazione ->> 'id')::integer, id_giornata_ispettiva = (datigiornataispettiva ->> 'idGiornataIspettiva')::integer  where id = idnc;
	
    	 return idnc;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.non_conformita_insert_globale(json)
  OWNER TO postgres;
  
    -- insert nc
CREATE OR REPLACE FUNCTION public.non_conformita_insert(IN _json_anagrafica json, IN _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	
	resultid integer;
BEGIN
	 
	INSERT INTO non_conformita (enteredby, note) values (_idutente,(_json_anagrafica ->> 'note')::text)
	returning id into resultid;

	  return resultid;
	 		
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.non_conformita_insert(json, integer)
  OWNER TO postgres;
  
  DROP FUNCTION IF EXISTS public.non_conformita_dettaglio_globale(integer);



CREATE OR REPLACE FUNCTION public.non_conformita_dettaglio_globale(
	_idnc integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	campiservizio json;
	motivazione json;
	finale json;
	utente json;
	linea json;
	dati json;
	daticu json;
	
	_id_giornata_ispettiva integer;
	id_linea_nc integer;
	codicelinea text;

BEGIN
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: recuperiamo i campi della nc
	motivazione := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, l.description::text as descrizione 
									from non_conformita nc 
									join lookup_tipi_verifica l on l.code = nc.id_tipo_verifica 
									where nc.id = _idnc
							               union 
							               select 'id' as nome,  l.code::text as descrizione 
							               from non_conformita nc 
							               join lookup_tipi_verifica l on l.code = nc.id_tipo_verifica
								       where nc.id = _idnc
							               ) a);		

	_id_giornata_ispettiva := (select n.id_giornata_ispettiva from non_conformita n where n.id = _idnc);
	id_linea_nc = (select n.id_linea from non_conformita n where n.id = _idnc);
	--codicelinea := (select l.codice_linea from linee_attivita_giornate_ispettive l where l.id_giornata_ispettiva  = id_controllo and l.trashed_date is null and id_linea_attivita = );

	linea := (select json_object_agg(nome,descrizione) from (
								select 'nome' as nome, c.descrizione_completa as descrizione
								from non_conformita nc
								left join linee_attivita_giornate_ispettive l on l.id_giornata_ispettiva =nc.id_giornata_ispettiva  
								left join codici_categoria_ippc c on concat(c.id_categoria,'-',c.id_codici_ippc,'-', c.id_codici_descrizione) = l.codice_linea
								where l.trashed_date is null and nc.trashed_date is null and nc.id = _idnc and l.id_linea_attivita = nc.id_linea
								union
								select 'id' as nome, id_linea::text as descrizione 
								from non_conformita nc
								where trashed_date is null and nc.id = _idnc) a);
													             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from non_conformita  where id = _idnc) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from non_conformita where id = _idnc) a);	

	daticu := (select json_object_agg(nome,descrizione) from (select 'idGiornataIspettiva' as nome, n.id_giornata_ispettiva::text as descrizione from non_conformita n where n.id = _idnc
							             union select 'riferimentoId' as nome, cu.riferimento_id::text  
							                     from giornate_ispettive cu 
							                     join non_conformita c on c.id_giornata_ispettiva = cu.id
							                     where c.id = _idnc  
										 union select 'idFascicoloIspettivo' as nome, cu.id_fascicolo_ispettivo::text  
							                     from giornate_ispettive cu 
							                     join non_conformita c on c.id_giornata_ispettiva = cu.id
							                     where c.id = _idnc  
										 union select 'dipartimento' as nome, l.description::text  
							                     from giornate_ispettive cu 
							                     join non_conformita c on c.id_giornata_ispettiva = cu.id
							                     join lookup_site_id l on l.code = cu.id_dipartimento
							                     where c.id = _idnc
							               union select 'ragioneSociale' as nome, r.ragione_sociale as descrizione
							                     from giornate_ispettive cu 
							                     join non_conformita c on c.id_giornata_ispettiva = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							                     where c.id = _idnc) a);	     

										
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from non_conformita c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where c.id = _idnc 	
								  union select 'idNonConformita' as nome, id::text as descrizione from non_conformita where id = _idnc
								  union select 'dataInserimento' as nome, entered::text as descrizione from non_conformita where id = _idnc
								  union select 'idnon_conformita' as nome, id::text as descrizione from non_conformita where id = _idnc 
								  ) b);

	finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Dati":', dati, ',"DatiGiornataIspettiva":', daticu, 
		--',"NumeroVerbale":', numeroverbale, 
		',"Utente":',utente, 
		',"Linea":', linea,
		',"CampiServizio":', campiServizio,
		',"TipoVerifica":', motivazione
		)),'}'))::json);
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$;

ALTER FUNCTION public.non_conformita_dettaglio_globale(integer)
    OWNER TO postgres;




	
	-- View: public.codici_categoria_ippc

-- DROP VIEW public.codici_categoria_ippc;

CREATE OR REPLACE VIEW public.codici_categoria_ippc
 AS
 SELECT c.id AS id_categoria,
    c.categoria,
    ip.id AS id_codici_ippc,
    ip.codice,
    d.id AS id_codici_descrizione,
    d.descrizione,
	concat(c.categoria, '-', ip.codice, '-', d.descrizione) as descrizione_completa
   FROM codici_categoria c
     JOIN codici_ippc ip ON ip.id_codici_categoria = c.id
     JOIN codici_descrizione d ON d.id_codici_ippc = ip.id;

ALTER TABLE public.codici_categoria_ippc
    OWNER TO postgres;

CREATE TABLE public.non_conformita
(
  id serial,
  id_giornata_ispettiva integer,
  id_tipo_verifica integer,
  id_linea integer,
  entered timestamp default current_timestamp,
  enteredby integer,
  modified timestamp default current_timestamp,
  modifiedby integer,
  trashed_date timestamp, 
  note text
)
WITH (
  OIDS=FALSE
);


-- CAMPIONI
delete from campioni;
delete from campionamento_suolo_particelle_dati_verbale;
delete from area_particelle;
delete from campionamento_particelle_log_json;
delete from aree_verbali_protocolli;
delete from campione_gruppo_addetti;
delete from campione_analiti;
delete from campione_gruppo_ispettivo;
delete from campione_programma_campionamento;
delete from campioni_verbali_protocolli;
-- NON CONFORMITA

delete from non_conformita;

-- FASCICOLI

delete from fascicoli_ispettivi;
delete from fascicoli_ispettivi_protocolli ;

-- GIORNATE ISPETTIVE
delete from giornate_ispettive;
delete from giornate_ispettive_esami ;
delete from giornate_ispettive_matrici ;
delete from giornate_ispettive_motivi ;
delete from giornate_ispettive_tipi_verifica ;
delete from giornate_ispettive_log_json;
delete from giornate_ispettive_verbali_protocolli;
delete from giornate_ispettive_verbali_protocolli; 
delete from giornate_ispettive_fase_lavorazione;
delete from giornate_ispettive_allegati;
delete from giornate_ispettive_per_conto_di;