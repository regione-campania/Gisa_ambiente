UPDATE public."role"
SET "role"='Dirigente coordinatore', description='Dirigente coordinatore', enteredby=964, entered='2022-03-25 14:52:16.930', modifiedby=964, modified='2022-03-25 14:52:16.930', enabled=false, role_type=0, role_old=NULL, "admin"=NULL, note=NULL, super_ruolo=1, descrizione_super_ruolo='RUOLO GISA', in_access=true, in_dpat=true, in_nucleo_ispettivo=true, carico_default=0, peso_per_somma_ui=0, id_lookup_qualifica_old=NULL, livello_qualifiche_dpat=0, enabled_as_qualifica=true, view_lista_utenti_nucleo_ispettivo=true, peso_per_somma_ui_old=NULL
WHERE role_id=43;


ALTER TABLE public.giornata_ispettiva_gruppo_ispettivo RENAME COLUMN responsabile TO dirigente;


CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_gruppo_ispettivo(_json_daticonnucleo json, _idgiornataispettiva integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_daticonnucleo) 
	  LOOP
	      
	
		 INSERT INTO giornata_ispettiva_gruppo_ispettivo (id_giornata_ispettiva, id_componente, enabled, referente, dirigente, 
														  addetto_campionamento, tecnico_campionamento, id_struttura, nome_struttura) 
		 values (_idgiornataispettiva, 
				(i->>'id')::integer,
				 true, 
		 		coalesce((i->>'referente')::boolean,false), 
		 		coalesce((i->>'dirigente')::boolean,false),
			  	coalesce((i->>'addettoCampionamento')::boolean,false),
				coalesce((i->>'tecnicoCampionamento')::boolean,false),
				(i->>'idAreaSemplice')::integer, (i->>'descrizioneAreaSemplice')::text);
	  END LOOP;

    	 return 1;
END;
$function$
;



CREATE OR REPLACE FUNCTION public.giornata_ispettiva_dettaglio_globale(_idgiornataispettiva integer)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
	
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

	gruppoispettivo := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select distinct gn.nome as nominativo, gn.id,
						gn.qualifica as qualifica, c.nome_struttura as "descrizioneAreaSemplice",
						c.dirigente, c.referente
						from giornata_ispettiva_gruppo_ispettivo c
						join public.dpat_get_nominativi_by_area_semplice(c.id_struttura) gn on gn.id = c.id_componente
							where id_giornata_ispettiva =_idgiornataispettiva) t);

	--gruppoispettivo := (select json_object_agg('GruppoIspettivo', gruppoispettivo));
	raise info 'json gruppoispettivo ricostruito %', gruppoispettivo;

										
	tipiverifica := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_tipi_verifica c
										join lookup_tipi_verifica l on l.code = c.id_tipo_verifica
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);
	--tipiverifica := (select json_object_agg('TipiVerifica', tipiverifica));
	raise info 'json tipi verifica %', tipiverifica;
	
	percontodi := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select distinct o.nome as nome, o.id_area_complessa as id 
																		from giornate_ispettive_per_conto_di c
																		join public.dpat_get_area_semplice(c.id_percontodi) o on o.id = c.id_percontodi
																		where c.id_giornata_ispettiva =  _idgiornataispettiva) t);
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
$function$
;


CREATE OR REPLACE FUNCTION public.get_anagrafica_matrici(_riferimento_id integer, _riferimento_id_nome_tab text)
 RETURNS TABLE(code integer, matrice text)
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
RETURN QUERY
	select distinct t.code, t.description::text
	from lookup_matrice_controlli t 
	where t.enabled;

	END;
$function$
;

-- public.utenti_modulospid definition

-- Drop table

-- DROP TABLE public.utenti_modulospid;

CREATE TABLE public.utenti_modulospid (
	user_id bigserial NOT NULL,
	namelast text NOT NULL,
	namefirst text NOT NULL,
	cf text NOT NULL,
	email text NULL,
	phone_number text NULL,
	role_id int4 NOT NULL,
	ciureg text NOT NULL,
	stab_id int4 NOT NULL,
	identificativo_ente_stabilimento text NULL,
	stab_iva_cf text NULL,
	cap text NULL,
	comune text NULL,
	indirizzo text NULL,
	referente text NULL,
	referente_role text NULL,
	referente_mail text NULL,
	referente_phone text NULL,
	pec text NULL,
	processato bool NULL,
	entered timestamp NULL
);


CREATE OR REPLACE FUNCTION public.dbi_insert_utente_modulospid(namelast text, namefirst text, cf text, email text, phone_number text, ciureg_input text, identificativo_ente_stabilimento text, stab_iva_cf text, cap text, comune text, indirizzo text, referente text, referente_role text, referente_mail text, referente_phone text, pec text)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
   DECLARE
   ciureg_search text;
   stab_id int;
   processed bool;
  
BEGIN

    ciureg_search:=(SELECT ciureg FROM public.aua_stabilimento WHERE ciureg=ciureg_input AND trashed_date IS NULL);
	
    IF (ciureg_search is null) THEN
	   processed:=false;
	   stab_id:=-1;
	   ELSE
	   processed:=true;
	   stab_id:=(SELECT id from public.aua_stabilimento WHERE ciureg=ciureg_input AND trashed_date IS NULL);
	END IF;
    	
	INSERT INTO utenti_modulospid (namelast, namefirst, cf, email, phone_number, role_id, ciureg, stab_id, identificativo_ente_stabilimento, stab_iva_cf, cap, comune, indirizzo, referente, referente_role, referente_mail, referente_phone, pec, processato, entered)
	VALUES (namelast, namefirst, cf, email, phone_number, 1, ciureg_input, stab_id, identificativo_ente_stabilimento, stab_iva_cf, cap, comune, indirizzo, referente, referente_role, referente_mail, referente_phone, pec, processed, now());
	       
   	RETURN true;

END
$function$
;