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
	
	raise info 'GRUPPO tecnici: %', gruppotecnici;
	
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


CREATE OR REPLACE FUNCTION public.giornata_ispettiva_upsert_matrici(
	_json_datimatrici json,
	_idgiornataispettiva integer,
	_idutente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	i json; 
	count_matrici integer;
BEGIN
	count_matrici := (select count(*) from giornate_ispettive_matrici where id_giornata_ispettiva= _idgiornataispettiva and trashed_date is null);
	
	 FOR i IN SELECT * FROM json_array_elements(_json_datimatrici) 
		  LOOP
			  RAISE NOTICE 'id %', i->>'id'; 
			  if(count_matrici > 0) then
				  update giornate_ispettive_matrici set id_matrice = (i->>'id')::integer,
					modifiedby = _idutente,
					modified = now() 
					where id_giornata_ispettiva = _idgiornataispettiva and trashed_date is null;
			 else
				 INSERT INTO giornate_ispettive_matrici (id_giornata_ispettiva, id_matrice, conclusa, enteredby) values
				 (_idgiornataispettiva, (i->>'id')::integer, (i->>'conclusa')::text, _idutente);
			end if;
		  END LOOP;
	
    	 return 1;
END;
$BODY$;

ALTER FUNCTION public.giornata_ispettiva_upsert_matrici(json, integer, integer)
    OWNER TO postgres;

 
CREATE OR REPLACE FUNCTION public.campionamento_suolo_update_dati_verbale(
	_json_dati json,
	_idutente integer,
    _idcampione integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	result integer;
	
BEGIN
		 --select * from campionamento_suolo_particelle_dati_verbale where id_campione=151
	     update campionamento_suolo_particelle_dati_verbale 
		 						set carabinieri_forestali = (_json_dati ->>'carabinieriForestali')::text
		 						, altri_partecipanti1 = (_json_dati ->>'altriPartecipanti1')::text
								, altri_partecipanti2 = (_json_dati ->>'altriPartecipanti2')::text
								, altri_partecipanti3 = (_json_dati ->>'altriPartecipanti3')::text
								, proprietario_particella = (_json_dati ->>'datiProprietarioParticella')::text
								, presente_al_campionamento_in_qualita_di_1 = (_json_dati ->>'qualitaAltriPartecipanti1')::text
								, presente_al_campionamento_in_qualita_di_2 = (_json_dati ->>'qualitaAltriPartecipanti2')::text
								, presente_al_campionamento_in_qualita_di_3 =  (_json_dati ->>'qualitaAltriPartecipanti3')::text
								, dati_altra_persona_presente = (_json_dati ->>'datiAltraPersonaPresente')::text
								, qualita_altra_persona_presente = (_json_dati ->>'qualitaAltraPersonaPresente')::text
								, proprietario_presente =  (_json_dati ->>'proprietarioPresente')::boolean
								, irrigazione_in_loco = (_json_dati ->>'irrigazioneInLoco')::boolean
								, dichiarazioni = (_json_dati ->>'dichiarazioni')::text
								, strumentazione = (_json_dati ->>'strumentazione')::text
								, note_aggiuntive = (_json_dati ->>'noteAggiuntive')::text
								, irrigazione_informazioni = (_json_dati ->>'irrigazioneInformazioni')::text
								, irrigazione_derivazione =  (_json_dati ->>'irrigazioneDerivazione')::text
								, pozzo_campionamento = (_json_dati ->>'pozzoCampionamento')::text
								, pozzo_campionamento_verbale_numero = (_json_dati ->>'pozzoCampionamentoVerbaleNumero')::text
								, pozzo_campionamento_verbale_data = (_json_dati ->>'pozzoCampionamentoVerbaleData')::text
								, codice_identificativo_voc =  (_json_dati ->>'codiceIdentificativoVoc')::text
								, codice_identificativo_c1 = (_json_dati ->>'codiceIdentificativo1')::text
								, codice_identificativo_c2 = (_json_dati ->>'codiceIdentificativo2')::text
								, codice_identificativo_c3 = (_json_dati ->>'codiceIdentificativo3')::text
								, codice_identificativo_c4 =  (_json_dati ->>'codiceIdentificativo4')::text
								, codice_identificativo_c5 =  (_json_dati ->>'codiceIdentificativo5')::text
								, codice_identificativo_medio_composito = (_json_dati ->>'codiceIdentificativoMedioComposito')::text
								, coordinata_x_voc = (_json_dati ->>'coordinataXVoc')::text
								, coordinata_x_c1 = (_json_dati ->>'coordinataX1')::text
								, coordinata_x_c2 = (_json_dati ->>'coordinataX2')::text
								, coordinata_x_c3 = (_json_dati ->>'coordinataX3')::text
								, coordinata_x_c4 = (_json_dati ->>'coordinataX4')::text
								, coordinata_x_c5 = (_json_dati ->>'coordinataX5')::text
								, coordinata_x_medio_composito = (_json_dati ->>'coordinataXMedioComposito')::text
								, coordinata_y_voc = (_json_dati ->>'coordinataYVoc')::text 
								, coordinata_y_c1 = (_json_dati ->>'coordinataY1')::text
								, coordinata_y_c2 = (_json_dati ->>'coordinataY2')::text
								, coordinata_y_c3 = (_json_dati ->>'coordinataY3')::text
								, coordinata_y_c4 = (_json_dati ->>'coordinataY4')::text
								, coordinata_y_c5 = (_json_dati ->>'coordinataY5')::text
								, coordinata_y_medio_composito = (_json_dati ->>'coordinataYMedioComposito')::text
								, num_campioni_elementari = (_json_dati ->>'numCampioniElementari')::text
								, particella_campionata = (_json_dati ->>'tipoColturaCodice')::text
								, prodotti_coltivati =  (_json_dati ->>'tipoColturaDescrizione')::text
								, prodotti_Coltivati_note = (_json_dati ->>'tipoColturaNote')::text
								, tipo_coltura_motivazione = (_json_dati ->>'tipoColturaMotivazione')::text
								, aliquota_a = coalesce((_json_dati->>'aliquotaA')::boolean,false)
								, aliquota_bg = coalesce((_json_dati->>'aliquotaBG')::boolean,false)
								, aliquota_c = coalesce((_json_dati->>'aliquotaC')::boolean,false)
								, aliquota_d = coalesce((_json_dati->>'aliquotaD')::boolean,false)
								, aliquota_e = coalesce((_json_dati->>'aliquotaE')::boolean,false)
								, aliquota_f = coalesce((_json_dati->>'aliquotaF')::boolean,false)
								, aliquota_h = coalesce((_json_dati->>'aliquotaH')::boolean,false)
								, aliquota_i = coalesce((_json_dati->>'aliquotaI')::boolean,false)
								, aliquota_lm = coalesce((_json_dati->>'aliquotaLM')::boolean,false)
								, aliquota_n = coalesce((_json_dati->>'aliquotaN')::boolean,false)
								, aliquota_a_data =  (_json_dati ->>'aliquotaA_data')::text
								, aliquota_bg_data = (_json_dati ->>'aliquotaBG_data')::text
								, aliquota_c_data = (_json_dati ->>'aliquotaC_data')::text
								, aliquota_d_data = (_json_dati ->>'aliquotaD_data')::text
								, aliquota_e_data = (_json_dati ->>'aliquotaE_data')::text
								, aliquota_f_data = (_json_dati ->>'aliquotaF_data')::text
								, aliquota_h_data = (_json_dati ->>'aliquotaH_data')::text
								, aliquota_i_data = (_json_dati ->>'aliquotaI_data')::text
								, aliquota_lm_data = (_json_dati ->>'aliquotaLM_data')::text
								, aliquota_n_data = (_json_dati ->>'aliquotaN_data')::text
								, aliquota_a_ora = (_json_dati ->>'aliquotaA_ora')::text
								, aliquota_bg_ora = (_json_dati ->>'aliquotaBG_ora')::text
								, aliquota_c_ora = (_json_dati ->>'aliquotaC_ora')::text
								, aliquota_d_ora = (_json_dati ->>'aliquotaD_ora')::text
								, aliquota_e_ora = (_json_dati ->>'aliquotaE_ora')::text
								, aliquota_f_ora = (_json_dati ->>'aliquotaF_ora')::text
								, aliquota_h_ora = (_json_dati ->>'aliquotaH_ora')::text
								, aliquota_i_ora = (_json_dati ->>'aliquotaI_ora')::text
								, aliquota_lm_ora =  (_json_dati ->>'aliquotaLM_ora')::text
								, aliquota_n_ora = (_json_dati ->>'aliquotaN_ora')::text
								, aliquota_cd_fitofarmaci = coalesce((_json_dati->>'aliquotaCD_fitofarmaci')::boolean,false)
								, presenza_rifiuti =  (_json_dati ->>'presenzaRifiuti')::text
								, presenza_rifiuti_descrizione =  (_json_dati ->>'presenzaRifiutiDescrizione')::text
								, presenza_rifiuti_note = (_json_dati ->>'presenzaRifiutiNote')::text
								, id_utente= _idutente
								where id_campione = _idcampione and trashed_date is null;
		return _idcampione;
END;
$BODY$;

ALTER FUNCTION public.campionamento_suolo_update_dati_verbale(json, integer, integer)
    OWNER TO postgres;

alter table campione_gruppo_addetti add column note_hd text;
CREATE OR REPLACE FUNCTION public.campione_upsert_gruppo_addetti(
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

	  update campione_gruppo_addetti set note_hd= concat_ws(';',note_hd,'CANCELLATO RECORD PER MODIFICA'), enabled=false where id_campione = _idcampione and enabled;
	  FOR i IN SELECT * FROM json_array_elements(_json_dati) 
	  LOOP
		 INSERT INTO campione_gruppo_addetti (id_campione, id_componente, enabled) values (_idcampione, (i->>'id')::integer,true);
	  END LOOP;

    	 return 1;
END;
$BODY$;

ALTER FUNCTION public.campione_upsert_gruppo_addetti(json, integer)
    OWNER TO postgres;
	
alter table campione_gruppo_tecnici add column note_hd text;
CREATE OR REPLACE FUNCTION public.campione_upsert_gruppo_tecnici(
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
	
	 update campione_gruppo_tecnici set note_hd= concat_ws(';',note_hd,'CANCELLATO RECORD PER MODIFICA'), enabled=false where id_campione = _idcampione and enabled;

	   FOR i IN SELECT * FROM json_array_elements(_json_dati) 
	  LOOP
		 INSERT INTO campione_gruppo_tecnici (id_campione, id_componente, enabled) values (_idcampione, (i->>'id')::integer,true);
	  END LOOP;

    	 return 1;
END;
$BODY$;

ALTER FUNCTION public.campione_upsert_gruppo_tecnici(json, integer)
    OWNER TO postgres;
	

CREATE OR REPLACE FUNCTION public.campionamento_particella_update_globale(
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
	campiservizio json;
	
BEGIN
	
	utenti :=  _json_dati ->'Utente';
	RAISE INFO 'json utenti %',utenti;
	
	idutente := utenti -> 'userId';
	RAISE INFO 'idutente %',idutente;
	
	datigenerici :=  _json_dati ->'Dati';
	RAISE INFO 'json dati generici %',datigenerici;
	

	gruppotecnici :=  _json_dati ->'GruppoTecnici';
	RAISE INFO 'json Gruppo Tecnici %', gruppotecnici;
		
	gruppoaddetti  := _json_dati ->'GruppoAddetti';
	RAISE INFO 'json Gruppo Addetti %', gruppoaddetti;
	
	motivo :=  _json_dati ->'Motivo';
	RAISE INFO 'json dati motivo/scelta campionamento %', motivo;
	
	dativerbale :=  _json_dati ->'DatiVerbaleCampione';
	RAISE INFO 'json dati generici %', dativerbale;
	
	matrici :=  _json_dati ->'Matrici';
	RAISE INFO 'json dati generici %', matrici;
	
	campiservizio :=  _json_dati ->'CampiServizio';
	RAISE INFO 'json dati campi servizio %', campiservizio;
	
	-- inserisco nel log il json
	-- STEP 0: INSERIAMO IL RECORD JSON PER LOG
	INSERT INTO campionamento_particelle_log_json(enteredby, json_cp) values(idutente,_json_dati);
	
	--STEP 1: CALCOLO L'ID CONTROLLO
	idcontrollo := (select id_giornata_ispettiva from campioni where id = (campiservizio ->> 'idCampione')::integer and trashed_date is null);
	raise info 'id Controllo/giornata ispettiva: %', idcontrollo;
	
	-- STEP 2: modifichiamo la matrice
	output :=(SELECT * from public.giornata_ispettiva_upsert_matrici(matrici, idcontrollo, idutente));
	
	--STEP 3: modifico campione fittizio (note e dataPrelievo)
	update campioni set 
		data_prelievo = (datigenerici ->> 'dataPrelievo')::timestamp without time zone,
		num_verbale = (datigenerici ->> 'numeroVerbale'),
		id_motivazione = (motivo ->> 'id')::integer,
		modified = now(),
		modifiedby = idutente, 
		note=concat_ws('-', note, 'MODIFICA CAMPIONE FITTIZIO PER CAMPIONAMENTO SUOLO')
		where id = (campiservizio ->> 'idCampione')::integer
		and trashed_date is null;

	--STEP 4: modifico dati del verbale
	idcampione := (select * from campionamento_suolo_update_dati_verbale(dativerbale,idutente, (campiservizio ->> 'idCampione')::integer));
	
	-- STEP 3.1: INSERIAMO IL GRUPPO ADDETTI MULTISERVIZI
	output := (SELECT * from public.campione_upsert_gruppo_addetti(gruppoaddetti, idcampione));
	
	-- STEP 3.2: INSERIAMO I COMPONENTI DEL NUCLEO
	output := (SELECT * FROM public.campione_upsert_gruppo_tecnici(gruppotecnici,idcampione));

	return idcampione;
END;
$BODY$;

ALTER FUNCTION public.campionamento_particella_update_globale(json)
    OWNER TO postgres;
    
   
----------------------------------------------------- nuove richieste ---------------------------------------
    insert into role(role_id, role, description, enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
 (select 44,'Direzione tecnica Arpac','Direzione tecnica Arpac', enteredby, entered, 
 modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, 
 in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo 
from role where role_id=6);

select 'insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,'||permission_id||','||role_view||','||role_add||','||role_edit||','||role_delete||');',
* from role_permission where role_id=6

insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,755,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,98,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,99,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,101,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,105,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,2254489,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,144,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,350000,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,305,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,755,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,98,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,99,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,101,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,105,true,true,true,false);
insert into role_permission(role_id, permission_id, role_view, role_add, role_edit, role_delete) 
values (44,5,true,true,true,false);

alter table campione_gruppo_addetti add column nome_1 text;
alter table campione_gruppo_addetti add column nome_2 text;
alter table campione_gruppo_addetti add column nome_3 text;
alter table campione_gruppo_addetti add column cognome_1 text;
alter table campione_gruppo_addetti add column cognome_2 text;
alter table campione_gruppo_addetti add column cognome_3 text;


CREATE OR REPLACE FUNCTION public.campione_insert_gruppo_addetti(
	_json_dati json,
	_idcampione integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
BEGIN
	  
	INSERT INTO campione_gruppo_addetti (id_campione, nome_1, nome_2, nome_3, cognome_1, cognome_2, cognome_3, enabled) values (_idcampione, (_json_dati->>'nome1'), 
																																	 (_json_dati->>'nome2'),
																																	 (_json_dati->>'nome3'),
																																	 (_json_dati->>'cognome1'),
																																	 (_json_dati->>'cognome2'),
																																	 (_json_dati->>'cognome3'),
																																	 true);
    return 1;
END;
$BODY$;

ALTER FUNCTION public.campione_insert_gruppo_addetti(json, integer)
    OWNER TO postgres;

-- FUNCTION: public.campione_upsert_gruppo_addetti(json, integer)

-- DROP FUNCTION IF EXISTS public.campione_upsert_gruppo_addetti(json, integer);

CREATE OR REPLACE FUNCTION public.campione_upsert_gruppo_addetti(
	_json_dati json,
	_idcampione integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
BEGIN

	  update campione_gruppo_addetti set note_hd= concat_ws(';',note_hd,'CANCELLATO RECORD PER MODIFICA'), enabled=false where id_campione = _idcampione and enabled;
	 
	  INSERT INTO campione_gruppo_addetti (id_campione, nome_1, nome_2, nome_3, cognome_1, cognome_2, cognome_3, enabled) values (_idcampione, (_json_dati->>'nome1'), 
																																	 (_json_dati->>'nome2'),
																																	 (_json_dati->>'nome3'),
																																	 (_json_dati->>'cognome1'),
																																	 (_json_dati->>'cognome2'),
																																	 (_json_dati->>'cognome3'),
																																	 true);	  

      return 1;
END;
$BODY$;

ALTER FUNCTION public.campione_upsert_gruppo_addetti(json, integer)
    OWNER TO postgres;

    
  


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
	
	gruppoaddetti :=(select json_object_agg(nome,descrizione) from (select 'nome1' as nome, nome_1::text as descrizione from 
												campione_gruppo_addetti 
															 where id_campione = _idcampione
							              			 		 union 
											   select 'nome2' as nome, nome_2::text as descrizione from campione_gruppo_addetti 
															 where id_campione = _idcampione
												union
												select 'nome3' as nome, nome_3::text as descrizione from campione_gruppo_addetti 
															 where id_campione = _idcampione
												union
												select 'cognome1' as nome, cognome_1::text as descrizione from campione_gruppo_addetti 
															 where id_campione = _idcampione
												union
												select 'cognome2' as nome, cognome_2::text as descrizione from campione_gruppo_addetti 
															 where id_campione = _idcampione
												union
												select 'cognome3' as nome, cognome_3::text as descrizione from campione_gruppo_addetti 
															 where id_campione = _idcampione
											   ) a);
																
				
	raise info 'GRUPPO ADDETTI: %', gruppoaddetti;
	
	gruppotecnici :=(SELECT array_to_json(array_agg(row_to_json(t))) from (
							select concat_ws(' ', co.namefirst, co.namelast)::text as nominativo, 'TECNICO CAMPIONAMENTO' as qualifica, m.id_componente as id
								          from access a 
								          join contact co on co.contact_id = a.contact_id
										  left join campione_gruppo_tecnici m on m.id_componente= a.user_id
									      where m.enabled and m.id_campione = _idcampione
								  ) t
	);
	
	raise info 'GRUPPO tecnici: %', gruppotecnici;
	
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

    
delete from area_particelle;
delete from campionamento_particelle_log_json;
delete from campionamento_suolo_particelle_dati_verbale;
delete from campione_gruppo_addetti;
delete from campione_gruppo_tecnici;

+ script di import

update role set role_type = 0 where role_type is null;
alter table role alter column role_type set default 0;

insert into role_permission (role_id, permission_id, role_view, role_add, role_edit, role_delete) 
(select 9, permission_id, role_view, role_add, role_edit, role_delete
from role_permission where role_id = 44);


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
from access_ a
left join access_dati ac on ac.user_id = a.user_id
left join contact_ c on c.contact_id = a.contact_id
left join role r on r.role_id = a.role_id
left join lookup_site_id asl on asl.code = ac.site_id
where a.enabled and a.data_scadenza is null and a.cessato is false
order by a.entered desc;

END;
$BODY$;

ALTER FUNCTION public.dbi_lista_utenti_guru()
    OWNER TO postgres;


DROP INDEX IF EXISTS public.usernameloc;

-- FUNCTION: public.dbi_update_disable_utente_guru(integer)

-- DROP FUNCTION IF EXISTS public.dbi_update_disable_utente_guru(integer);

CREATE OR REPLACE FUNCTION public.dbi_update_disable_utente_guru(
	userid integer)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

   DECLARE
msg text ;
   
BEGIN

update access_ set data_scadenza = now(), enabled = false, trashed_date = now(), note_hd = 'Scaduto in seguito a disabilitazione da GURU.' where user_id = userId and data_scadenza is null;
msg := 'OK';

RETURN msg;

END
$BODY$;

ALTER FUNCTION public.dbi_update_disable_utente_guru(integer)
    OWNER TO postgres;
