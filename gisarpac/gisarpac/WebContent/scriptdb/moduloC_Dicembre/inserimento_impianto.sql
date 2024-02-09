-- public.aia_stabilimento definition

-- Drop table

-- DROP TABLE public.aia_stabilimento;

-- public.aia_stabilimento definition

-- Drop table

-- DROP TABLE public.aia_stabilimento;

CREATE TABLE public.aia_stabilimento (
	id bigserial NOT NULL,
	id_impresa int8 NOT NULL,
	id_indirizzo int8 NOT NULL,
	entered timestamp NULL,
	modified timestamp NULL,
	entered_by int4 NULL,
	modified_by int4 NULL,
	id_asl int4 NULL,
	id_soggetto_fisico int4 NULL,
	flag_fuori_regione bool NULL,
	numero_registrazione text NULL,
	denominazione text NULL,
	trashed_date timestamp NULL,
	notes_hd text NULL,
	num_protocollo text NULL,
	trashed_by int4 NULL,
	id_old_stab int4 NULL
);

-- public.aia_impresa definition

-- Drop table
-- public.ricerche_anagrafiche_old_materializzata definition

-- Drop table

-- DROP TABLE public.ricerche_anagrafiche_old_materializzata;

ALTER TABLE public.ricerche_anagrafiche_old_materializzata ADD principale bool NULL;



ALTER TABLE public.ricerche_anagrafiche_old_materializzata ADD id_comune int4 NULL;
-- DROP TABLE public.aia_impresa;

CREATE TABLE public.aia_impresa (
	id bigserial NOT NULL,
	id_soggetto_fisico int8 NOT NULL,
	id_indirizzo int8 NOT NULL,
	codice_fiscale_impresa text NULL,
	note text NULL,
	partita_iva text NULL,
	ragione_sociale text NULL,
	enteredby int4 NULL,
	modifiedby int4 NULL,
	trashed_date timestamp NULL,
	domicilio_digitale text NULL,
	tipo_impresa int4 NULL,
	tipo_societa int4 NULL,
	codice_interno_impresa text NULL,
	note_internal_use_only_hd text NULL,
	id_old_impresa int4 NULL
);


CREATE TABLE public.aia_soggetto_fisico (
	id bigserial NOT NULL,
	id_indirizzo int8 NOT NULL,
	cognome text NULL,
	nome text NULL,
	comune_nascita text NULL,
	codice_fiscale text NULL,
	enteredby text NULL,
	modifiedby text NULL,
	sesso text NULL,
	telefono bpchar(50) NULL,
	fax bpchar(50) NULL,
	email varchar(100) NULL,
	telefono1 bpchar(50) NULL,
	data_nascita timestamp NULL,
	documento_identita text NULL,
	provenienza_estera bool NULL,
	provincia_nascita text NULL,
	trashed_date timestamp NULL,
	note_hd text NULL,
	id_nazione_nascita int4 NULL,
	id_comune_nascita int4 NULL,
	id_old_soggetto int4 NULL,
	id_old_soggetto_stab int4 NULL
);


CREATE TABLE public.aia_rel_stabilimento_codici (
	id bigserial NOT NULL,
	id_stabilimento int8 NOT NULL,
	id_codice_descrizione int8 NOT NULL,
	principale bool NULL,
	quantitativi_autorizzati int4 NULL,
	data_inizio_attivita timestamp NULL,
	data_fine_attivita timestamp NULL,
	id_stato int4 NULL,
	note_hd text NULL,
	numero_registrazione_linea text NULL,
	enabled bool NULL
);

CREATE OR REPLACE FUNCTION public.insert_impianto(jsondati json, utente_in integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE 


id_indirizzo int4;
_id_sogg_fis int4;
id_impresa int4;
id_stab int4;
id_rel int4;
_id_indirizzo_sede_legale int4;
_id_indirizzo_stabilimento int4;
_id_indirizzo_sogg_fis int4;
n_ippc int4;
i int4;
nome_ippc text;
nome_quanti text;
nome_princ text;
nome_data text;
_numero_registrazione_osa text;
id_resp int4;
codice_asl int4;
_numero_registrazione text;
BEGIN	

	
	
	IF (length(trim(jsonDati ->>'id_impresa_recuperata')) <> 0) THEN	
	
	IF (length(trim(jsonDati ->>'via_sede_legale')) <> 0 OR (jsonDati ->> 'nazione_sede_legale')::integer <> 106) THEN
			--inserisci indirizzo impresa
			_id_indirizzo_sede_legale := insert_indirizzo((jsonDati ->> 'nazione_sede_legale')::integer, jsonDati ->> 'cod_provincia_sede_legale',
								       (jsonDati ->> 'cod_comune_sede_legale')::integer, jsonDati ->> 'comune_estero_sede_legale', 
								       (jsonDati ->> 'toponimo_sede_legale')::integer, jsonDati ->> 'via_sede_legale', jsonDati ->> 'cap_leg', jsonDati ->> 'civico_sede_legale',
								       null, null,
								       jsonDati ->> 'presso_sede_legale');
			--update id indirizzo impresa
			--update opu_operatore set id_indirizzo = _id_indirizzo_sede_legale where id = _id_operatore;
			
		END IF;

	
	IF (length(trim(jsonDati ->>'via_stab')) <> 0) THEN
		_id_indirizzo_stabilimento := insert_indirizzo(106, jsonDati ->> 'cod_provincia_stab',
								       (jsonDati ->> 'cod_comune_stab')::integer, null, (jsonDati ->> 'toponimo_stab')::integer,
								       jsonDati ->> 'via_stab', jsonDati ->> 'cap_stab', jsonDati ->> 'civico_stab',
								       (jsonDati ->> 'latitudine_stab')::double precision, (jsonDati ->> 'longitudine_stab')::double precision,
								       jsonDati ->> 'presso_stab');
	END IF;
	
--inserisci soggetto fisico
			IF (length(trim(jsonDati ->>'codice_fiscale_rappresentante')) <> 0 OR (jsonDati ->> 'nazione_nascita_rapp_leg')::integer <> 106) THEN
				_id_sogg_fis := insert_aia_soggetto_fisico(jsonDati ->> 'nome_rapp_leg', jsonDati ->> 'cognome_rapp_leg', (jsonDati ->> 'nazione_nascita_rapp_leg')::integer,
									  jsonDati ->> 'codice_fiscale_rappresentante', jsonDati ->> 'sesso_rapp_leg', utente_in, 
									  jsonDati ->> 'telefono_rapp_leg', jsonDati ->> 'email_rapp_leg', _id_indirizzo_sogg_fis,
									  jsonDati ->> 'comune_nascita_rapp_leg', (jsonDati ->> 'data_nascita_rapp_leg')::timestamp without time zone);
		        END IF;



	insert into aia_impresa (id_soggetto_fisico,id_indirizzo,codice_fiscale_impresa,partita_iva,ragione_sociale,domicilio_digitale) values(
	_id_sogg_fis,
	_id_indirizzo_sede_legale,
	jsonDati ->>'codice_fiscale_impresa',
	jsonDati ->>'partita_iva',
	jsonDati ->>'ragione_sociale',
	jsonDati ->>'email_impresa'
	)returning id into id_impresa;




insert into aia_soggetto_fisico(nome,cognome,codice_fiscale,id_indirizzo) values ( jsonDati ->>'nome_resp_stab',
		jsonDati ->>'cognome_resp_stab',
		jsonDati ->>'cf_resp_stab',
		-1) returning id into id_resp;
	
	
	
	 insert into aia_stabilimento (id_impresa,id_indirizzo,id_soggetto_fisico,entered,modified,denominazione,num_protocollo,numero_registrazione) values(
		id_impresa,
		_id_indirizzo_stabilimento,
		id_resp,
		now(),
		now(),
		jsonDati ->>'denominazione',
		jsonDati ->>'num_protocollo',
		_numero_registrazione_osa::text
		)returning id into id_stab;


	IF _id_indirizzo_stabilimento = _id_indirizzo_sede_legale THEN
		_numero_registrazione_osa = genera_numero_registrazione_da_comune((jsonDati ->> 'cod_comune_sede_legale')::integer);
	ELSE 
		_numero_registrazione_osa = genera_numero_registrazione_da_comune((jsonDati ->> 'cod_comune_stab')::integer);
	END IF;
	
	--IF _id_indirizzo_stabilimento is not null THEN
	--	SELECT distinct(split_part(key,'_',2)) into r FROM each(jsonDati) where key ilike '%lineaattivita_%' || '%_codice_univoco_ml%' limit 1;
	--	_codice_univoco_ml := jsonDati ->> concat('lineaattivita_', r,'_codice_univoco_ml');
		--_id_stabilimento := insert_opu_noscia_stabilimento(_id_operatore, _id_indirizzo_stabilimento, utente_in, _codice_univoco_ml, jsonDati ->> 'numero_registrazione_stabilimento');
	--	_id_stabilimento := insert_aia_stabilimento(_id_operatore, _id_indirizzo_stabilimento, utente_in, _codice_univoco_ml, _numero_registrazione_osa);
--	END IF;










n_ippc = (jsonDati ->> 'numero_ippc')::integer;
	i=0;
	
	for i in 0..n_ippc  loop
		
		nome_ippc = concat('id_ippc_',(i+1)::text);
		nome_quanti = concat('quantitativi_ippc_',(i+1)::text);
		nome_princ = concat('principale_ippc_',(i+1)::text);
		nome_data = concat('data_inizio_attivita_',(i+1)::text);

		
	 if ((jsonDati ->> nome_ippc)::integer is not null)
	 then
      raise info 'IPPC INFO % ',(jsonDati ->> nome_ippc)::integer;
     
    _numero_registrazione:= (select genera_numero_registrazione from genera_numero_registrazione(jsonDati ->> 'cod_comune_stab', jsonDati ->> 'cod_provincia_stab'));

     
      insert into aia_rel_stabilimento_codici(id_stabilimento,id_codice_descrizione,principale,quantitativi_autorizzati,data_inizio_attivita,id_stato,enabled,numero_registrazione_linea) 
     values(id_stab,(jsonDati ->> nome_ippc)::integer,(jsonDati ->> nome_princ)::boolean,
    (jsonDati ->> nome_quanti)::integer, (jsonDati ->> nome_data)::timestamp,99,true,
    _numero_registrazione
    );
     else
     end if;
     end loop;

	
		perform refresh_anagrafica(id_stab, 'aia');


--inserisciti impresa e soggetto fisico ex novo (indirizzi compresi)
		--inserimento indirizzo soggetto fisico/rapp legale
		--IF (length(trim(jsonDati ->>'via_soggfis')) <> 0 OR length(trim(jsonDati ->> 'comune_residenza_estero_soggfis')) <> 0) THEN
	ELSE

	
	
	
	
			if ((jsonDati ->> 'cod_comune_soggfis') <> '')  THEN

		IF (length(trim(jsonDati ->>'via_soggfis')) <> 0 OR (jsonDati ->> 'nazione_residenza_rapp_legale')::integer <> 106) THEN
			_id_indirizzo_sogg_fis := insert_indirizzo((jsonDati ->> 'nazione_residenza_rapp_legale')::integer, jsonDati ->> 'cod_provincia_soggfis',
									       (jsonDati ->> 'cod_comune_soggfis')::integer, jsonDati ->> 'comune_residenza_estero_soggfis',
									       (jsonDati ->> 'toponimo_soggfis')::integer, jsonDati ->> 'via_soggfis', jsonDati ->> 'cap_soggfis', jsonDati ->> 'civico_soggfis',
									       null, null,
									       jsonDati ->> 'presso_soggfis');
		END IF;
	else
	
			_id_indirizzo_sogg_fis := insert_indirizzo((jsonDati ->> 'nazione_residenza_rapp_legale')::integer, jsonDati ->> 'cod_provincia_soggfis',
									      	-1, jsonDati ->> 'comune_residenza_estero_soggfis',
									      	-1, jsonDati ->> 'via_soggfis', jsonDati ->> 'cap_soggfis', jsonDati ->> 'civico_soggfis',
									       null, null,
									       jsonDati ->> 'presso_soggfis');
	
	end if;

		--inserimento indirizzo sede legale/impresa
		--IF (length(trim(jsonDati ->>'via_sede_legale')) <> 0 OR length(trim(jsonDati ->> 'comune_estero_sede_legale')) <> 0) THEN
		if (jsonDati ->> 'cod_comune_sede_legale' <> '' ) THEN
		IF (length(trim(jsonDati ->>'via_sede_legale')) <> 0 OR (jsonDati ->> 'nazione_sede_legale')::integer <> 106) THEN
			_id_indirizzo_sede_legale := insert_indirizzo((jsonDati ->> 'nazione_sede_legale')::integer, jsonDati ->> 'cod_provincia_sede_legale',
									       (jsonDati ->> 'cod_comune_sede_legale')::integer, jsonDati ->> 'comune_estero_sede_legale', 
									       (jsonDati ->> 'toponimo_sede_legale')::integer, jsonDati ->> 'via_sede_legale', jsonDati ->> 'cap_leg', jsonDati ->> 'civico_sede_legale',
									       null,null,
									       jsonDati ->> 'presso_sede_legale');
		END IF;
	else
	
	
		_id_indirizzo_sede_legale := insert_indirizzo((jsonDati ->> 'nazione_sede_legale')::integer, jsonDati ->> 'cod_provincia_sede_legale',
									       -1, jsonDati ->> 'comune_estero_sede_legale', 
									       -1, jsonDati ->> 'via_sede_legale', jsonDati ->> 'cap_leg', jsonDati ->> 'civico_sede_legale',
									       null,null,
									       jsonDati ->> 'presso_sede_legale');
		END IF;
	
	
	

		--inserimento soggetto fisico/rapp legale
		IF (length(trim(jsonDati ->>'codice_fiscale_rappresentante')) <> 0 OR (jsonDati ->> 'nazione_nascita_rapp_legale')::integer <> 106) THEN
			_id_sogg_fis := insert_aia_soggetto_fisico(jsonDati ->> 'nome_rapp_leg', jsonDati ->> 'cognome_rapp_leg', (jsonDati ->> 'nazione_nascita_rapp_legale')::integer,
									  jsonDati ->> 'codice_fiscale_rappresentante', jsonDati ->> 'sesso_rapp_leg', utente_in, 
									  jsonDati ->> 'telefono_rapp_leg', jsonDati ->> 'email_rapp_leg', _id_indirizzo_sogg_fis,
									  jsonDati ->> 'comune_nascita_rapp_legale', (jsonDati ->> 'data_nascita_rapp_leg')::timestamp without time zone);
		END IF;
	
	
	
	insert into aia_impresa (id_soggetto_fisico,id_indirizzo,codice_fiscale_impresa,partita_iva,ragione_sociale,domicilio_digitale,tipo_impresa,enteredby) values(
	_id_sogg_fis,
	_id_indirizzo_sede_legale,
	jsonDati ->>'codice_fiscale_impresa',
	jsonDati ->>'partita_iva',
	jsonDati ->>'ragione_sociale',
	jsonDati ->>'email_impresa',
	(jsonDati ->>'tipo_impresa')::integer,
	utente_in::int4
	)returning id into id_impresa;

		--inserimento impresa/ operatore
		--IF (length(trim(jsonDati ->>'partita_iva')) <> 0 OR length(trim(jsonDati ->> 'codice_fiscale')) <> 0) THEN
		--	_id_operatore := insert_opu_noscia_impresa(jsonDati ->> 'codice_fiscale', jsonDati ->> 'partita_iva', jsonDati ->> 'ragione_sociale',
		--						   utente_in, jsonDati ->> 'email_impresa', (jsonDati ->> 'tipo_impresa')::integer, _id_indirizzo_sede_legale);
		--END IF;

		--inserimento relazione opu_rel_operatore_soggetto_fisico
		--IF _id_sogg_fis is not null AND _id_operatore is not null THEN
		--	perform insert_opu_noscia_rel_impresa_soggfis(_id_sogg_fis, _id_operatore);
	--	END IF;

	--inserimento indirizzo stabilimento







	_id_indirizzo_stabilimento := _id_indirizzo_sede_legale;
	IF (length(trim(jsonDati ->>'via_stab')) <> 0)  THEN
	_id_indirizzo_stabilimento := insert_indirizzo(106, jsonDati ->> 'cod_provincia_stab',
							       (jsonDati ->> 'cod_comune_stab')::integer, null, (jsonDati ->> 'toponimo_stab')::integer,
							       jsonDati ->> 'via_stab', jsonDati ->> 'cap_stab', jsonDati ->> 'civico_stab',
							       (jsonDati ->> 'latitudine_stab')::double precision, (jsonDati ->> 'longitudine_stab')::double precision,
							       jsonDati ->> 'presso_stab');
	END IF;
	



IF (_id_indirizzo_stabilimento = _id_indirizzo_sede_legale and (jsonDati ->> 'cod_comune_sede_legale') <> '') THEN
		_numero_registrazione_osa = genera_numero_registrazione_da_comune((jsonDati ->> 'cod_comune_sede_legale'));
	ELSE 
		_numero_registrazione_osa = genera_numero_registrazione_da_comune((jsonDati ->> 'cod_comune_stab')::integer);
	END IF;





insert into aia_soggetto_fisico(nome,cognome,codice_fiscale,id_indirizzo,enteredby) values ( jsonDati ->>'nome_resp_stab',
		jsonDati ->>'cognome_resp_stab',
		jsonDati ->>'cf_resp_stab',
		-1,utente_in::int4) returning id into id_resp;


	
	
	
	
	
	   insert into aia_stabilimento (id_impresa,id_indirizzo,id_soggetto_fisico,entered,modified,denominazione,num_protocollo,numero_registrazione,entered_by) values(
		id_impresa,
		_id_indirizzo_stabilimento,
		id_resp,
		now(),
		now(),
		jsonDati ->>'denominazione',
		jsonDati ->>'num_protocollo',
		_numero_registrazione_osa::text,
		utente_in::int4
		)returning id into id_stab;

	
		select c.codiceistatasl into codice_asl from aia_stabilimento as2 join indirizzi oi on oi.id = as2.id_indirizzo join comuni1 c on c.id =oi.comune where as2.id =id_stab;

	update aia_stabilimento set id_asl = codice_asl where id =id_stab;
	END IF;



	n_ippc = (jsonDati ->> 'numero_ippc')::integer;
	i=0;
	
	for i in 0..n_ippc  loop
		
		nome_ippc = concat('id_ippc_',(i+1)::text);
		nome_quanti = concat('quantitativi_ippc_',(i+1)::text);
		nome_princ = concat('principale_ippc_',(i+1)::text);
		nome_data = concat('data_inizio_attivita_',(i+1)::text);

		
	 if ((jsonDati ->> nome_ippc)::integer is not null)
	 then
      raise info 'IPPC INFO % ',(jsonDati ->> nome_ippc)::integer;
     
    _numero_registrazione:= (select genera_numero_registrazione from genera_numero_registrazione(jsonDati ->> 'cod_comune_stab', jsonDati ->> 'cod_provincia_stab'));

     
      insert into aia_rel_stabilimento_codici(id_stabilimento,id_codice_descrizione,principale,quantitativi_autorizzati,data_inizio_attivita,id_stato,enabled,numero_registrazione_linea) 
     values(id_stab,(jsonDati ->> nome_ippc)::integer,(jsonDati ->> nome_princ)::boolean,
    (jsonDati ->> nome_quanti)::integer, (jsonDati ->> nome_data)::timestamp,99,true,
    _numero_registrazione
    );
     else
     end if;
     end loop;

     
     
     
     -- inserimento campi aggiuntivi anagrafica
IF (id_stab is not null) THEN
	perform insert_anag_dati_aggiuntivi(id_stab,'aia_stabilimento',jsonDati ->> 'denominazione',
	                                            jsonDati ->>  'nome_resp_stab', jsonDati ->>  'cognome_resp_stab', jsonDati ->>  'cf_resp_stab');
END IF; 
-- fine inserimento campi aggiuntivi anagrafica



	perform refresh_anagrafica(id_stab, 'aia');
     
     
     
     
     
     



	
	return id_stab;
	
END;
$function$
;





CREATE OR REPLACE FUNCTION public.insert_aia_soggetto_fisico(_nome text, _cognome text, _nazione_nascita integer, _codice_fiscale text, _sesso text, _enteredby integer DEFAULT NULL::integer, _telefono text DEFAULT NULL::text, _email text DEFAULT NULL::text, _id_indirizzo integer DEFAULT NULL::integer, _comune_nascita text DEFAULT NULL::text, _data_nascita timestamp without time zone DEFAULT NULL::timestamp without time zone)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE 

	_id_sogg integer;
	_comune_nascita_testo text;
	_sesso_text text;
	_provenienza_estera boolean;
        
BEGIN	
	
	raise info 'NAZ %',_nazione_nascita;

	IF _nazione_nascita = 106 THEN
		select nome into _comune_nascita_testo from comuni1 where id = _comune_nascita::integer limit 1;
		_provenienza_estera := false;

		insert into aia_soggetto_fisico(cognome, nome, comune_nascita, codice_fiscale, enteredby, sesso, telefono, email, data_nascita, id_indirizzo, provenienza_estera, id_nazione_nascita, id_comune_nascita)
		values(_cognome, _nome, _comune_nascita_testo, _codice_fiscale, _enteredby, _sesso, _telefono, _email, _data_nascita, _id_indirizzo, _provenienza_estera, _nazione_nascita, _comune_nascita::integer) returning id into _id_sogg;
	ELSE
		_comune_nascita_testo := _comune_nascita;
		_provenienza_estera := true;
		insert into aia_soggetto_fisico(cognome, nome, comune_nascita, codice_fiscale, enteredby, sesso, telefono, email, data_nascita, id_indirizzo, provenienza_estera, id_nazione_nascita, id_comune_nascita)
		values(_cognome, _nome, _comune_nascita_testo, _codice_fiscale, _enteredby, _sesso, _telefono, _email, _data_nascita, _id_indirizzo, _provenienza_estera, _nazione_nascita, null) returning id into _id_sogg;
	END IF;

	return _id_sogg;
	      
END;
$function$
;






CREATE OR REPLACE FUNCTION public.aia_insert_into_ricerche_anagrafiche_old_materializzata(idstabilimento integer)
 RETURNS boolean
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
idRecord int ;
BEGIN

raise info 'sto eliminando dalla tabella ';
delete from ricerche_anagrafiche_old_materializzata where riferimento_id_nome ='stabId' and riferimento_id_nome_tab = 'aia_stabilimento'  and riferimento_id =idStabilimento ;
raise info 'Eliminazione Eseguita ';
insert into ricerche_anagrafiche_old_materializzata (select * from ricerca_anagrafiche where riferimento_id_nome ='stabId' and riferimento_id_nome_tab = 'aia_stabilimento'  and riferimento_id =idStabilimento);
raise info 'Nuovo Inserimento Effettuato ';

	return true ;
 END;
$function$
;





CREATE OR REPLACE FUNCTION public.refresh_anagrafica(id integer, origine text)
 RETURNS boolean
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
refresh boolean ;

BEGIN

raise info 'Valori accettati: org (org_id) altri_org (org_id) opu (id_stabilimento) sintesis (id_stabilimento) api (id_stabilimento) ric (alt_id) anagrafica (alt_id)';

if (origine='altri_org') THEN
raise info 'aggiorno da ALTRI ORGANIZATION';
refresh := (select * from altri_org_insert_into_ricerche_anagrafiche_old_materializzata(id));
end if;

if (origine='org') THEN
raise info 'aggiorno da ORGANIZATION';
refresh := (select * from org_insert_into_ricerche_anagrafiche_old_materializzata(id));
end if;

if (origine='opu') THEN
raise info 'aggiorno da OPU';
refresh := (select * from opu_insert_into_ricerche_anagrafiche_old_materializzata(id));
end if;

if (origine='aia') THEN
raise info 'aggiorno da AIA';
refresh := (select * from aia_insert_into_ricerche_anagrafiche_old_materializzata(id));
end if;

 if (origine='sintesis') THEN
raise info 'aggiorno da SINTESIS';
refresh := (select * from sintesis_insert_into_ricerche_anagrafiche_old_materializzata(id));
end if;

 if (origine='api') THEN
raise info 'aggiorno da API';
refresh := (select * from api_insert_into_ricerche_anagrafiche_old_materializzata(id));
end if;

if (origine='ric') THEN
raise info 'aggiorno da RICHIESTE';
refresh := (select * from ric_insert_into_ricerche_anagrafiche_old_materializzata(id));
end if;

if (origine='anagrafica') THEN
raise info 'aggiorno da ANAGRAFICA';
refresh := (select * from anagrafica.anagrafica_insert_into_ricerche_anagrafiche_old_materializzata(id));
end if;


return refresh;

 END;
$function$
;


-- public.ricerca_anagrafiche source

-- public.ricerca_anagrafiche source

CREATE OR REPLACE VIEW public.ricerca_anagrafiche
AS SELECT DISTINCT as2.id::integer AS riferimento_id,
    'stabId'::text AS riferimento_id_nome,
    'id_stabilimento'::text AS riferimento_id_nome_col,
    'aia_stabilimento'::text AS riferimento_id_nome_tab,
    ai.id_indirizzo::integer AS id_indirizzo_impresa,
    as2.id_indirizzo::integer AS id_sede_operativa,
    '-1'::integer AS sede_mobile_o_altro,
    'indirizzi'::text AS riferimento_nome_tab_indirizzi,
    as2.id_impresa::integer AS id_impresa,
    'aia_impresa'::text AS riferimento_nome_tab_impresa,
    as2.id_soggetto_fisico,
    'aia_soggetto_fisico'::text AS riferimento_nome_tab_soggetto_fisico,
    arsc.id::integer AS id_attivita,
    NULL::boolean AS pregresso_o_import,
    NULL::integer AS riferimento_org_id,
    as2.entered AS data_inserimento,
    ai.ragione_sociale::character varying(300) AS ragione_sociale,
    as2.id_asl AS asl_rif,
    lsi.description AS asl,
    ai.codice_fiscale_impresa AS codice_fiscale,
    asf.codice_fiscale AS codice_fiscale_rappresentante,
    ai.partita_iva::character varying(255) AS partita_iva,
    3 AS categoria_rischio,
    now()::timestamp without time zone AS prossimo_controllo,
    ''::text AS num_riconoscimento,
    as2.numero_registrazione AS n_reg,
    arsc.numero_registrazione_linea AS n_linea,
    concat_ws(' '::text, asf.nome, asf.cognome) AS nominativo_rappresentante,
    'CON SEDE FISSA'::text AS tipo_attivita_descrizione,
    1 AS tipo_attivita,
    arsc.data_inizio_attivita,
    arsc.data_fine_attivita,
    lsl.description AS stato,
    arsc.id_stato,
    c.nome AS comune,
    lp.description AS provincia_stab,
    concat(o1.via, ' ', o1.civico) AS indirizzo,
    o1.cap AS cap_stab,
    o1.latitudine AS latitudine_stab,
    o1.longitudine AS longitudine_stab,
    c2.nome AS comune_leg,
    lp2.description AS provincia_leg,
    o2.via AS indirizzo_leg,
    o2.cap AS cap_leg,
    NULL::double precision AS latitudine_leg,
    NULL::double precision AS longitudine_leg,
    cci.categoria AS macroarea,
    cci.codice AS aggregazione,
    cci.descrizione AS attivita,
    concat(cci.categoria, '->', cci.codice, '->', cci.descrizione)::character varying(1000) AS path_attivita_completo,
    ''::text AS gestione_masterlist,
    ''::text AS norma,
    1 AS id_norma,
    999 AS tipologia_operatore,
    1 AS tipo_ricerca_anagrafica,
    'gray'::text AS color,
    ''::text AS n_reg_old,
    '-1'::integer AS id_tipo_linea_reg_ric,
    cci.id_codici_descrizione AS id_linea,
    cci.id_categoria::text AS codice_macroarea,
    cci.id_codici_ippc::text AS codice_aggregazione,
    cci.id_codici_descrizione::text AS codice_attivita,
    NULL::boolean AS miscela,
    arsc.principale,
    c.id AS id_comune
   FROM aia_stabilimento as2
     JOIN aia_impresa ai ON as2.id_impresa = ai.id
     LEFT JOIN indirizzi o1 ON o1.id = as2.id_indirizzo
     LEFT JOIN comuni1 c ON c.id = o1.comune
     LEFT JOIN indirizzi o2 ON o2.id = ai.id_indirizzo
     LEFT JOIN comuni1 c2 ON c2.id = o2.comune
     LEFT JOIN aia_rel_stabilimento_codici arsc ON arsc.id_stabilimento = as2.id
     LEFT JOIN codici_categoria_ippc cci ON cci.id_codici_descrizione = arsc.id_codice_descrizione
     LEFT JOIN lookup_province lp ON lp.code::text = o1.provincia::text
     LEFT JOIN lookup_province lp2 ON lp2.code::text = o2.provincia::text
     LEFT JOIN aia_soggetto_fisico asf ON asf.id = as2.id_soggetto_fisico
     LEFT JOIN lookup_site_id lsi ON lsi.code = as2.id_asl
     LEFT JOIN lookup_stato_lab lsl ON arsc.id_stato = lsl.code
  WHERE arsc.enabled IS TRUE;
     
CREATE OR REPLACE VIEW public.lookup_codici_ippc_ricerca
AS SELECT DISTINCT ip.id AS code,
    ip.codice AS description,
    ip.codice AS short_description,
    false AS default_item,
    1 AS level,
    true AS enabled
   FROM codici_categoria c
     JOIN codici_ippc ip ON ip.id_codici_categoria = c.id
     JOIN codici_descrizione d ON d.id_codici_ippc = ip.id;
     
     
     
     
     
  
  
  
 CREATE OR REPLACE FUNCTION public.get_json_ippc(id_stabilimento_ integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
json_return text;
	BEGIN

		
		
		
		   select (concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json)::text into json_return as json_IPPC from(
				select id::text as id, 
				id_stabilimento::text as stabilimento, 
				cci.categoria::text as categoria, 
				cci.codice::text as codice,
				cci.descrizione::text as descrizione,
				principale::text as principale, 
				quantitativi_autorizzati::text as quantitativi,
				data_inizio_attivita::timestamp::date,
				data_fine_attivita::timestamp,
				id_stato::int4,
				arsc.note_hd,
				numero_registrazione_linea,
				arsc.enabled::bool,
				lsl.description as stato,
				cci.id_codici_descrizione as id_ippc
				from aia_rel_stabilimento_codici arsc join codici_categoria_ippc cci on arsc.id_codice_descrizione= cci.id_codici_descrizione 
				join lookup_stato_lab lsl on lsl.code=id_stato
				where arsc.id_stabilimento = id_stabilimento_ and arsc.enabled is true ) tab;
		
		
		
		
		

		
		return json_return;
		
	END;
$function$
;


CREATE OR REPLACE FUNCTION public.get_json_decreti(id_stabilimento_ integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare 
json_return text;
	BEGIN
		   
select (concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json)::text into json_return as json_decreti from(
				select  
				a.id_aia::text as id_aia, 
				l.description::text as descrizione, 
				a.num_decreto::text as decreto,
				a.nota::text as nota,
				a.burc::text as burc, 
				string_agg(m.description, '-')::text as matrici 
				from anag_dati_autorizzativi a left join lookup_autorizzazione_tipo l on a.tipo_autorizzazione = l.code left join anag_dati_autorizzativi_matrici am on am.id_anag_dati_autorizzativi = a.id left join
 lookup_matrice_controlli m on m.code = am.id_matrice
 where a.riferimento_id = id_stabilimento_ and a.riferimento_id_nome_tab = 'aia_stabilimento' and a.trashed_date is null 
group by a.id_aia, l.description, a.num_decreto, a.nota, a.burc) tab;
		
		
		
		
		
		
		
		return json_return;
		
	END;
$function$
;







CREATE OR REPLACE FUNCTION public.suap_dbi_cerca_indirizzo_per_id(iddindirizzo integer)
 RETURNS TABLE(id integer, via text, cap text, provincia text, nazione text, latitudine double precision, longitudine double precision, comune integer, riferimento_org_id integer, riferimento_address_id integer, address_type integer, comune_testo text, toponimo text, civico text, code integer, description text, cod_provincia text, descrizione_comune text, descrizione_provincia text, descrizione_toponimo text)
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
	r RECORD;
	 	
BEGIN
		FOR 
		id  , via  , cap  ,provincia  , nazione ,latitudine  , longitudine ,comune ,
riferimento_org_id  , riferimento_address_id ,address_type ,comune_testo , toponimo  , civico  ,code ,

description ,cod_provincia ,descrizione_comune , descrizione_provincia , descrizione_toponimo
		in

select 
ind.id , ind.via , ind.cap , ind.provincia  , ind.nazione ,ind.latitudine  , ind.longitudine ,ind.comune ,
ind.riferimento_org_id  , ind.riferimento_address_id ,ind.address_type ,ind.comune_testo as com , ind.toponimo  , ind.civico
,asl.code , asl.description ,c.cod_provincia,coalesce (c.nome,ind.comune_testo) as descrizionecomune,
lp.description as descrizioneprovincia, lt.description as descrizionetoponimo 
from opu_indirizzo ind 
join comuni1 c on c.id =ind.comune 
left join lookup_site_id asl on (c.codiceistatasl)::int = asl.codiceistat::int   and asl.enabled=true 
left join lookup_province lp on lp.code = c.cod_provincia::int  
left join lookup_toponimi lt on lt.code = ind.toponimo::int   where ind.id = iddindirizzo	


		
    LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
    
 END;
$function$
;








DROP FUNCTION IF EXISTS public.update_anag(integer, text, integer, text, integer, text);

CREATE OR REPLACE FUNCTION public.update_anag(
	_riferimento_id integer,
	_riferimento_id_nome_tab text,
	_id_nuovo_stato integer,
	_data_cambio_stato text,
	_id_utente integer,
	_nota text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$


DECLARE
	  
	  id_storico_result integer;
	  id_stato_prec integer;
	  output boolean;
BEGIN


	IF _riferimento_id_nome_tab = 'aia_stabilimento' then
	        id_stato_prec := (select id_stato from aia_rel_stabilimento_codici where enabled=true and id_stabilimento = _riferimento_id limit 1);
		update aia_rel_stabilimento_codici  set modifiedby = _id_utente, modified= current_timestamp, id_stato = _id_nuovo_stato where id_stabilimento = _riferimento_id;
		insert into anag_storico_modifiche (riferimento_id,riferimento_id_nome_tab, id_nuovo_stato, id_vecchio_stato, data_cambio_stato, nota,
				          enteredby) values(_riferimento_id, _riferimento_id_nome_tab, _id_nuovo_stato, id_stato_prec, _data_cambio_stato, _nota, _id_utente) 
				          returning id into id_storico_result ;
		output := (select * from refresh_anagrafica(_riferimento_id, 'aia'));
		
		--update opu_relazione_stabilimento_linee_produttive lp
		--set modifiedby = _id_utente, modified = current_timestamp, stato = _id_nuovo_stato
		--where enabled = 'true'
		--and lp.id_stabilimento = _riferimento_id;
	end if;
	
	if id_storico_result > 0 then
		return 'OK, operazione effettuata con successo.';
	else
		return 'KO, operazione non effettuata.';
	end if;

END;
$BODY$;

ALTER FUNCTION public.update_anag(integer, text, integer, text, integer, text)
    OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.cambio_titolarita_stabilimento_aia(jsondati json, utente_in integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE 


id_indirizzo int4;
_id_sogg_fis int4;
id_impresa int4;
id_stab int4;
id_rel int4;
_id_indirizzo_sede_legale int4;
_id_indirizzo_stabilimento int4;
_id_indirizzo_sogg_fis int4;
n_ippc int4;
i int4;
nome_ippc text;
nome_quanti text;
nome_princ text;
nome_data text;
_numero_registrazione_osa text;
codice_fiscale_leg text;
id_sogg int4;
json_impr_iniziale text;
BEGIN	
	
	
		SELECT json_agg(aia_impresa) into json_impr_iniziale FROM aia_impresa where id= (jsonDati ->>'id_impresa')::integer;

	
		select codice_fiscale into codice_fiscale_leg from aia_impresa ai join aia_soggetto_fisico asf on ai.id_soggetto_fisico = asf.id where ai.id=(jsonDati ->>'id_impresa')::integer;


		if (jsonDati ->> 'cod_comune_soggfis' <> '') then
		IF (length(trim(jsonDati ->>'via_soggfis')) <> 0 OR (jsonDati ->> 'nazione_residenza_rapp_legale')::integer <> 106) THEN
			_id_indirizzo_sogg_fis := insert_indirizzo((jsonDati ->> 'nazione_residenza_rapp_legale')::integer, jsonDati ->> 'cod_provincia_soggfis',
									       (jsonDati ->> 'cod_comune_soggfis')::integer, jsonDati ->> 'comune_residenza_estero_soggfis',
									       (jsonDati ->> 'toponimo_soggfis')::integer, jsonDati ->> 'via_soggfis', jsonDati ->> 'cap_soggfis', jsonDati ->> 'civico_soggfis',
									       null, null,
									       jsonDati ->> 'presso_soggfis');
		END IF;
	else
	_id_indirizzo_sogg_fis := insert_indirizzo((jsonDati ->> 'nazione_residenza_rapp_legale')::integer, jsonDati ->> 'cod_provincia_soggfis',
									       -1, jsonDati ->> 'comune_residenza_estero_soggfis',
									       -1, jsonDati ->> 'via_soggfis', jsonDati ->> 'cap_soggfis', jsonDati ->> 'civico_soggfis',
									       null, null,
									       jsonDati ->> 'presso_soggfis');
	
	
	end if;

		if (jsonDati ->> 'cod_comune_sede_legale' <> '') then
		IF (length(trim(jsonDati ->>'via_sede_legale')) <> 0 OR (jsonDati ->> 'nazione_sede_legale')::integer <> 106) THEN
			_id_indirizzo_sede_legale := insert_indirizzo((jsonDati ->> 'nazione_sede_legale')::integer, jsonDati ->> 'cod_provincia_sede_legale',
									       (jsonDati ->> 'cod_comune_sede_legale')::integer, jsonDati ->> 'comune_estero_sede_legale', 
									       (jsonDati ->> 'toponimo_sede_legale')::integer, jsonDati ->> 'via_sede_legale', jsonDati ->> 'cap_leg', jsonDati ->> 'civico_sede_legale',
									       null,null,
									       jsonDati ->> 'presso_sede_legale');
									      
									      update aia_impresa set id_indirizzo = _id_indirizzo_sede_legale where id = (jsonDati ->>'id_impresa')::integer;
		END IF;
		else
		_id_indirizzo_sede_legale := insert_indirizzo((jsonDati ->> 'nazione_sede_legale')::integer, jsonDati ->> 'cod_provincia_sede_legale',
									       -1, jsonDati ->> 'comune_estero_sede_legale', 
									       -1, jsonDati ->> 'via_sede_legale', jsonDati ->> 'cap_leg', jsonDati ->> 'civico_sede_legale',
									       null,null,
									       jsonDati ->> 'presso_sede_legale');
									      
									      update aia_impresa set id_indirizzo = _id_indirizzo_sede_legale where id = (jsonDati ->>'id_impresa')::integer;
		
		end if;
		--inserimento soggetto fisico/rapp legale
		if ((trim(jsonDati ->>'codice_fiscale_rappresentante') <> codice_fiscale_leg))
		then
		IF (length(trim(jsonDati ->>'codice_fiscale_rappresentante')) <> 0 OR (jsonDati ->> 'nazione_nascita_rapp_legale')::integer <> 106) THEN
			_id_sogg_fis := insert_aia_soggetto_fisico(jsonDati ->> 'nome_rapp_leg', jsonDati ->> 'cognome_rapp_leg', (jsonDati ->> 'nazione_nascita_rapp_legale')::integer,
									  jsonDati ->> 'codice_fiscale_rappresentante', jsonDati ->> 'sesso_rapp_leg', utente_in, 
									  jsonDati ->> 'telefono_rapp_leg', jsonDati ->> 'email_rapp_leg', _id_indirizzo_sogg_fis,
									  jsonDati ->> 'comune_nascita_rapp_legale', (jsonDati ->> 'data_nascita_rapp_leg')::timestamp without time zone);
									 
									 
			update aia_impresa set id_soggetto_fisico = _id_sogg_fis where id = (jsonDati ->>'id_impresa')::integer;
		END IF;
		end if;
		
		
		update aia_impresa set partita_iva = jsonDati ->>'partita_iva' , codice_fiscale_impresa = jsonDati ->>'codice_fiscale_impresa', modifiedby=utente_in::int4
		where id = (jsonDati ->>'id_impresa')::integer;
	
		select id_soggetto_fisico into id_sogg from aia_impresa ai where ai.id =(jsonDati ->>'id_impresa')::integer;
	
	
	if((jsonDati ->> 'cod_comune_soggfis') <> '' or (jsonDati ->> 'nazione_residenza_rapp_legale') <> '106' ) then
		update aia_soggetto_fisico set id_indirizzo = _id_indirizzo_sogg_fis,modifiedby=utente_in::int4 where id=id_sogg;
			end if;
		update aia_stabilimento set modified=now(), modified_by=utente_in::int4 where aia_stabilimento.id_impresa= (jsonDati ->>'id_impresa')::integer;

	

	
	insert into aia_impresa_storico_operazioni(id_impresa,id_utente,data_operazione,tipologia,json_iniziale,json_finale) values(
	(jsonDati ->>'id_impresa')::integer,
	utente_in,
	now(),
	'cambio',
	json_impr_iniziale::text,
	jsondati::text
	);
	
	return (jsonDati ->>'id_stabilimento')::integer  ;
	
END;
$function$
;



CREATE TABLE public.aia_impresa_storico_operazioni (
	id serial4 NOT NULL,
	id_impresa int8 NOT NULL,
	id_utente int8 NULL,
	data_operazione timestamp NULL,
	tipologia text NULL,
	json_iniziale text NULL,
	json_finale text NULL
);



CREATE OR REPLACE FUNCTION public.get_storico_cambio_stato_anag(_riferimento_id integer, _riferimento_id_nome_tab text)
 RETURNS SETOF anag_storico_modifiche
 LANGUAGE plpgsql
AS $function$
DECLARE
BEGIN
RETURN QUERY
	select * from anag_storico_modifiche 
	where riferimento_id = _riferimento_id and  
	trashed_date is null  and
	riferimento_id_nome_tab = _riferimento_id_nome_tab 
	order by entered desc;
END;
$function$
;




CREATE TABLE public.anag_storico_modifiche (
	id serial4 NOT NULL,
	riferimento_id int4 NULL,
	riferimento_id_nome_tab text NULL,
	id_nuovo_stato int4 NULL,
	id_vecchio_stato int4 NULL,
	data_cambio_stato text NULL,
	nota text NULL,
	enteredby int4 NULL,
	entered timestamp NULL DEFAULT now(),
	trashed_date timestamp NULL
);






ALTER TABLE public.opu_indirizzo RENAME TO indirizzi;
ALTER TABLE public.indirizzi RENAME CONSTRAINT opu_indirizzo_pkey TO indirizzi_pkey;


CREATE OR REPLACE FUNCTION public.genera_numero_registrazione(_idstabilimento integer)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
_numRegistrazione text ;
_idIndirizzo integer;
_idComune integer;
_idProvincia integer;
_codComune text;
_codProvincia text;
_progressivo integer;

BEGIN

_progressivo = 0;
_idIndirizzo := -1;

-- sede operativa
select relsi.id_indirizzo into _idIndirizzo from aia_stabilimento relsi where relsi.id = _idStabilimento and relsi.trashed_date  is null;
raise info 'CERCO ID INDIRIZZO SEDE OPERATIVA: %', _idIndirizzo;

-- sede legale
IF _idIndirizzo<0 THEN
select ai.id_indirizzo into _idIndirizzo from 
aia_stabilimento s
join aia_impresa ai on ai.id_stabilimento = s.id and ai.trashed_date is null
where s.id = _idStabilimento;
raise info 'CERCO ID INDIRIZZO SEDE LEGALE: %', _idIndirizzo;
END IF;

-- residenza
--IF _idIndirizzo<0 THEN
--select relsfi.id_indirizzo  into _idIndirizzo from 
--anagrafica.stabilimenti s
--join anagrafica.rel_imprese_stabilimenti relis on relis.id_stabilimento = s.id and relis.data_cancellazione is null and relis.data_scadenza is null
--join anagrafica.imprese i on i.id = relis.id_impresa and i.data_cancellazione is null
--join anagrafica.rel_imprese_soggetti_fisici relisf on relisf.id_impresa = i.id and relisf.data_cancellazione is null and relisf.data_scadenza is null
--join anagrafica.soggetti_fisici sf on sf.id = relisf.id_soggetto_fisico and sf.data_cancellazione is null
--join anagrafica.rel_soggetti_fisici_indirizzi relsfi on relsfi.id_soggetto_fisico = sf.id and relsfi.data_cancellazione is null and relsfi.data_scadenza is null 
--where s.id = _idStabilimento;
--raise info 'CERCO ID INDIRIZZO RESIDENZA: %', _idIndirizzo;
--END IF;

IF _idIndirizzo>0 THEN
-- se ho trovato un indirizzo, recupero i codici di comune e provincia
select comune into _idComune from indirizzi where id = _idIndirizzo;
select id_provincia into _idProvincia from comuni1 c  where id = _idComune;
select cod_comune into _codComune from comuni1 where id = _idComune;
select cod_provincia into _codProvincia from lookup_province where code = _idProvincia;
ELSE
-- altrimenti uso codici di default
_codComune := '000';
_codProvincia := 'ND';
END IF;
raise info 'COD COMUNE: %', _codComune;
raise info 'COD PROVINCIA: %', _codProvincia;

-- calcolo il progressivo per quei codici
select COALESCE(max(progressivo), 0) into _progressivo from progressivi_comune_provincia where cod_comune = _codComune and cod_provincia = _codProvincia;
_progressivo = _progressivo+1;
insert into progressivi_comune_provincia(progressivo, cod_comune, cod_provincia) values (_progressivo, _codComune, _codProvincia);

raise info 'PROGRESSIVO: %', _progressivo;

_numRegistrazione := 'U020' || 'N' || _codComune || _codProvincia || lpad(_progressivo||'', 6, '0');
raise info 'NUM REGISTRAZIONE: %', _numRegistrazione;

return _numRegistrazione ;
END;
$function$
;


CREATE OR REPLACE FUNCTION public.importa_anagrafica_aia(_idaia text)
 RETURNS integer
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE 

_idIndirizzoOperatore integer;
_idIndirizzoStabilimento integer;
_idIndirizzoSoggetto integer;
_idOperatore integer;
_idStabilimento integer;
_idSoggetto integer;
_numeroRegistrazione text;
_numeroRegistrazioneLinea text;
_noteHd text;
_refresh boolean;
r record;
_indice integer;
BEGIN

_noteHd := '[INSERITO PER IMPORT AIA '||_idAia||']';
_indice := 0;

-- insert into indirizzi (sede legale)
insert into indirizzi(via, cap, provincia, nazione, latitudine, longitudine, comune, toponimo, note_hd) 
select i.indirizzo, c.cap, p.code, 'ITALIA', i.coordinate_geografiche_y::double precision, i.coordinate_geografiche_x::double precision, c.id, 100, _noteHd
from import_aia_anagrafiche i
join comuni1 c on c.nome = i.comune
join lookup_province p on p.cod_provincia = i.pr
where i.id_aia = _idAia returning id into _idIndirizzoOperatore;
raise info '_idIndirizzoOperatore %', _idIndirizzoOperatore;

-- insert into indirizzi (sede operativa)
insert into indirizzi(via, cap, provincia, nazione, latitudine, longitudine, comune, toponimo, note_hd) 
select i.indirizzo, c.cap, p.code, 'ITALIA', i.coordinate_geografiche_y::double precision, i.coordinate_geografiche_x::double precision, c.id, 100, _noteHd
from import_aia_anagrafiche i
join comuni1 c on c.nome = i.comune
join lookup_province p on p.cod_provincia = i.pr
where i.id_aia = _idAia returning id into _idIndirizzoStabilimento;
raise info '_idIndirizzoStabilimento %', _idIndirizzoStabilimento;

-- insert into indirizzi (residenza soggetto)
insert into indirizzi(via, cap, provincia, nazione,comune, toponimo, note_hd) 
select '', '', -1, '', -1, -1, _noteHd returning id into _idIndirizzoSoggetto;
raise info '_idIndirizzoSoggetto %', _idIndirizzoSoggetto;

-- insert into opu_soggetto_fisico (soggetto anonimo con codice fiscale ND)
insert into opu_soggetto_fisico (nome, cognome, codice_fiscale, indirizzo_id, note_hd) 
select 'NDN', 'NDC', 'ND', _idIndirizzoSoggetto, _noteHd returning id into _idSoggetto;
raise info '_idSoggetto %', _idSoggetto;

-- insert into opu_operatore
insert into opu_operatore(codice_fiscale_impresa, partita_iva, ragione_sociale, id_indirizzo, note_internal_use_only_hd)
select codice_fiscale, codice_fiscale, ragione_sociale, _idIndirizzoOperatore, _noteHd
from import_aia_anagrafiche 
where id_aia = _idAia returning id into _idOperatore;
raise info '_idOperatore %', _idOperatore;

-- Numero registrazione
_numeroRegistrazione := (select * from genera_numero_registrazione_da_comune((select comune from indirizzi where id = _idIndirizzoStabilimento)));
raise info '_numeroRegistrazione %', _numeroRegistrazione;

-- insert into opu_stabilimento (con numero di registrazione generato, asl dell'indirizzo)
insert into opu_stabilimento (id_asl, id_operatore, id_soggetto_fisico, id_indirizzo, numero_registrazione, tipo_attivita, stato, notes_hd, entered)
select c.codiceistatasl::integer, _idOperatore, _idSoggetto, _idIndirizzoStabilimento, _numeroRegistrazione, 1, 99, _noteHd, now()
from import_aia_anagrafiche i
join comuni1 c on c.nome = i.comune
where i.id_aia = _idAia returning id into _idStabilimento;
raise info '_idStabilimento %', _idStabilimento;

-- insert into opu_rel_operatore_soggetto_fisico
insert into opu_rel_operatore_soggetto_fisico(id_operatore, id_soggetto_fisico, tipo_soggetto_fisico) 
select _idOperatore, _idSoggetto, 1;

-- insert into opu_relazione_stabilimento_linee_produttive

FOR r IN SELECT * FROM import_aia_linee_principali where id_aia = _idAia
    LOOP
    
SELECT _indice+1 into _indice;
SELECT _numeroRegistrazione||LPAD(_indice::text, 3, '0') into _numeroRegistrazioneLinea;

insert into opu_relazione_stabilimento_linee_produttive (id_linea_produttiva, id_stabilimento, stato, primario, numero_registrazione, codice_univoco_ml, tipo_carattere, enabled, note_hd)

select ml8.id_nuova_linea_attivita, _idStabilimento, 99, true, _numeroRegistrazioneLinea, ml8.codice, 1, true, _noteHd
from ml8_linee_attivita_nuove_materializzata ml8 where ml8.macroarea ilike r.denominazione_categoria_impianto and ml8.aggregazione ilike r.codice_ipcc_principale and ml8.attivita ilike r.descrizione_att_principale;

raise info 'Inserita linea principale % _idStabilimento % _numeroRegistrazioneLinea %', _indice, _idStabilimento, _numeroRegistrazioneLinea;
END LOOP;


FOR r IN SELECT * FROM import_aia_linee_secondarie where id_aia = _idAia
    LOOP
    
SELECT _indice+1 into _indice;
SELECT _numeroRegistrazione||LPAD(_indice::text, 3, '0') into _numeroRegistrazioneLinea;

insert into opu_relazione_stabilimento_linee_produttive (id_linea_produttiva, id_stabilimento, stato, primario, numero_registrazione, codice_univoco_ml, tipo_carattere, enabled, note_hd)

select ml8.id_nuova_linea_attivita, _idStabilimento, 99, false, _numeroRegistrazioneLinea, ml8.codice, 1, true, _noteHd
from ml8_linee_attivita_nuove_materializzata ml8 where ml8.macroarea ilike r.denominazione_categoria_impianto and ml8.aggregazione ilike r.codice_ipcc_secondaria and ml8.attivita ilike r.descrizione_att_secondaria;

raise info 'Inserita linea secondaria % _idStabilimento % _numeroRegistrazioneLinea %', _indice, _idStabilimento, _numeroRegistrazioneLinea;
END LOOP;

-- insert into select * from anag_dati_autorizzativi 

 insert into anag_dati_autorizzativi(riferimento_id, riferimento_id_nome_tab, id_aia, tipo_autorizzazione, num_decreto, data_decreto, nota, burc)
 select _idStabilimento, 'opu_stabilimento', i.id_aia, a.code, i.num_decreto_dirigenziale, i.data_decreto_dirigenziale, i.nota_su_decreto, i.burc
 from import_aia_decreti i
 join lookup_autorizzazione_tipo a on a.description ilike i.autorizzazione
 where i.id_aia = _idAia;
raise info 'Inseriti decreti _idStabilimento %', _idStabilimento;

 -- Log import AIA
 -- Qui rivedrei la tabella di log. Forse facciamo prima a usare id_aia invece di id di import_aia che è diventata una tabella di appoggio. In questa versione loggo tutti gli id relativi all'id_aia importato (11 record perchè su import_aia a causa della duplicazione dei decreti ci sono 11 righe). In alternativa una tabella di log per ogni entità di partenza (log_anagrafiche, log_decreti, log_linee_principali, log_linee_secondarie) ma mi sembra inutile

 insert into log_import_aia (id_import_aia, riferimento_id, riferimento_id_nome_tab)
 select id, _idStabilimento, 'opu_stabilimento'
 from import_aia where id_aia = _idAia;

 -- Refresh

 _refresh := (select * from refresh_anagrafica(_idStabilimento, 'opu'));

 raise info 'Terminato inserimento _idStabilimento %', _idStabilimento;

RETURN _idStabilimento;
 END;
$function$
;


CREATE OR REPLACE FUNCTION public.insert_gestione_anagrafica(campi_fissi hstore, campi_estesi hstore, utente_in integer, id_tipo_pratica_in integer, numero_pratica_in text, id_comune_in integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE 

	_id_indirizzo_sede_legale integer;
	_id_indirizzo_stabilimento integer;
	_id_indirizzo_sogg_fis integer;
	_id_sogg_fis integer;
	_id_operatore integer;
	_id_stabilimento integer;
	_comune_nascita_testo text;
	_codice_univoco_ml text;
	_data_inizio text;
	_data_fine text;
	_num_riconoscimento text;
	_tipo_carattere text;
	r integer;
	_id_suap_operatore integer;
	_id_suap_stabilimento integer;
	_alt_id_suap_stabilimento integer;
	_id_suap_sogg_fis integer;
	_n_categorizzabili integer;
	_numero_registrazione_osa text;
        
BEGIN	

_n_categorizzabili := -1;

--fare le assegnazioni alla variabili dichiarate sopra sia nel caso di dati recuperati che di nuovo inserimento

	IF (length(trim(campi_fissi ->'id_impresa_recuperata')) <> 0) THEN	
		_id_operatore := (campi_fissi -> 'id_impresa_recuperata')::integer;
		--update opu_operatore
		update opu_operatore 
			set codice_fiscale_impresa = campi_fissi -> 'codice_fiscale', partita_iva = campi_fissi -> 'partita_iva',
			    ragione_sociale = campi_fissi -> 'ragione_sociale', domicilio_digitale = campi_fissi -> 'email_impresa',
			    tipo_societa = (campi_fissi -> 'tipo_impresa')::integer 
			where id = _id_operatore;
			
		--IF (length(trim(campi_fissi ->'via_sede_legale')) <> 0 OR length(trim(campi_fissi -> 'comune_estero_sede_legale')) <> 0) THEN
		IF (length(trim(campi_fissi ->'via_sede_legale')) <> 0 OR (campi_fissi -> 'nazione_sede_legale')::integer <> 106) THEN
			--inserisci indirizzo impresa
			_id_indirizzo_sede_legale := insert_indirizzo((campi_fissi -> 'nazione_sede_legale')::integer, campi_fissi -> 'cod_provincia_sede_legale',
								       (campi_fissi -> 'cod_comune_sede_legale')::integer, campi_fissi -> 'comune_estero_sede_legale', 
								       (campi_fissi -> 'toponimo_sede_legale')::integer, campi_fissi -> 'via_sede_legale', campi_fissi -> 'cap_leg', campi_fissi -> 'civico_sede_legale',
								       (campi_fissi -> 'latitudine_leg')::double precision, (campi_fissi -> 'longitudine_leg')::double precision,
								       campi_fissi -> 'presso_sede_legale');
			--update id indirizzo impresa
			update opu_operatore set id_indirizzo = _id_indirizzo_sede_legale where id = _id_operatore;
			
		END IF;

		IF (length(trim(campi_fissi ->'id_rapp_legale_recuperato')) <> 0) THEN
			_id_sogg_fis := (campi_fissi -> 'id_rapp_legale_recuperato')::integer;
			--update opu_soggetto_fisico
			--gestione nel caso di provenienza estera
			IF (campi_fissi -> 'nazione_nascita_rapp_leg') = '106' THEN
				select nome into _comune_nascita_testo from comuni1 where id = (campi_fissi -> 'comune_nascita_rapp_leg')::integer limit 1;
				update opu_soggetto_fisico 
					set cognome = campi_fissi -> 'cognome_rapp_leg', nome = campi_fissi -> 'nome_rapp_leg',
					    comune_nascita = _comune_nascita_testo, codice_fiscale = campi_fissi -> 'codice_fiscale_rappresentante',
					    sesso = campi_fissi -> 'sesso_rapp_leg', telefono = campi_fissi -> 'telefono_rapp_leg',
					    email = campi_fissi -> 'email_rapp_leg', data_nascita = (campi_fissi -> 'data_nascita_rapp_leg')::timestamp without time zone, 
					    provenienza_estera = false, id_nazione_nascita = (campi_fissi -> 'nazione_nascita_rapp_leg')::integer, 
					    id_comune_nascita = (campi_fissi -> 'comune_nascita_rapp_leg')::integer
				        where id = _id_sogg_fis;
			ELSIF (length(trim(campi_fissi ->'nazione_nascita_rapp_leg')) <> 0) THEN
				update opu_soggetto_fisico 
					set cognome = campi_fissi -> 'cognome_rapp_leg', nome = campi_fissi -> 'nome_rapp_leg',
					    comune_nascita = campi_fissi -> 'comune_nascita_rapp_leg', codice_fiscale = campi_fissi -> 'codice_fiscale_rappresentante',
					    sesso = campi_fissi -> 'sesso_rapp_leg', telefono = campi_fissi -> 'telefono_rapp_leg',
					    email = campi_fissi -> 'email_rapp_leg', data_nascita = (campi_fissi -> 'data_nascita_rapp_leg')::timestamp without time zone, 
					    provenienza_estera = true, id_nazione_nascita = (campi_fissi -> 'nazione_nascita_rapp_leg')::integer
				        where id = _id_sogg_fis;
				
			END IF;
				    
			--IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR length(trim(campi_fissi -> 'comune_residenza_estero_soggfis')) <> 0) THEN
			IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR (campi_fissi -> 'nazione_soggfis')::integer <> 106) THEN
				--insert indirizzo soggetto fisico
				_id_indirizzo_sogg_fis := insert_indirizzo((campi_fissi -> 'nazione_soggfis')::integer, campi_fissi -> 'cod_provincia_soggfis',
								       (campi_fissi -> 'cod_comune_soggfis')::integer, campi_fissi -> 'comune_residenza_estero_soggfis',
								       (campi_fissi -> 'toponimo_soggfis')::integer, campi_fissi -> 'via_soggfis', campi_fissi -> 'cap_soggfis', campi_fissi -> 'civico_soggfis',
								       (campi_fissi -> 'latitudine_soggfis')::double precision, (campi_fissi -> 'longitudine_soggfis')::double precision,
								       campi_fissi -> 'presso_soggfis');
				--update id indirizzo soggetto fisico
				update opu_soggetto_fisico set indirizzo_id = _id_indirizzo_sogg_fis where id = _id_sogg_fis;
			END IF;
		ELSE
			--inserisci indirizzo soggetto fisico
			--IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR length(trim(campi_fissi -> 'comune_residenza_estero_soggfis')) <> 0) THEN
			IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR (campi_fissi -> 'nazione_soggfis')::integer <> 106) THEN
				_id_indirizzo_sogg_fis := insert_indirizzo((campi_fissi -> 'nazione_soggfis')::integer, campi_fissi -> 'cod_provincia_soggfis',
									       (campi_fissi -> 'cod_comune_soggfis')::integer, campi_fissi -> 'comune_residenza_estero_soggfis',
									       (campi_fissi -> 'toponimo_soggfis')::integer, campi_fissi -> 'via_soggfis', campi_fissi -> 'cap_soggfis', campi_fissi -> 'civico_soggfis',
									       (campi_fissi -> 'latitudine_soggfis')::double precision, (campi_fissi -> 'longitudine_soggfis')::double precision,
									       campi_fissi -> 'presso_soggfis');
		        END IF;
			--inserisci soggetto fisico
			IF (length(trim(campi_fissi ->'codice_fiscale_rappresentante')) <> 0 OR (campi_fissi -> 'nazione_nascita_rapp_leg')::integer <> 106) THEN
				_id_sogg_fis := insert_opu_noscia_soggetto_fisico(campi_fissi -> 'nome_rapp_leg', campi_fissi -> 'cognome_rapp_leg', (campi_fissi -> 'nazione_nascita_rapp_leg')::integer,
									  campi_fissi -> 'codice_fiscale_rappresentante', campi_fissi -> 'sesso_rapp_leg', utente_in, 
									  campi_fissi -> 'telefono_rapp_leg', campi_fissi -> 'email_rapp_leg', _id_indirizzo_sogg_fis,
									  campi_fissi -> 'comune_nascita_rapp_leg', (campi_fissi -> 'data_nascita_rapp_leg')::timestamp without time zone);
		        END IF;
			--inserisci relazione operatore-soggettofisico
			--inserimento relazione opu_rel_operatore_soggetto_fisico
			IF _id_sogg_fis is not null AND _id_operatore is not null THEN
				perform insert_opu_noscia_rel_impresa_soggfis(_id_sogg_fis, _id_operatore);
			END IF;
		END IF;
	ELSE
		--inserisciti impresa e soggetto fisico ex novo (indirizzi compresi)
		--inserimento indirizzo soggetto fisico/rapp legale
		--IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR length(trim(campi_fissi -> 'comune_residenza_estero_soggfis')) <> 0) THEN
		IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR (campi_fissi -> 'nazione_soggfis')::integer <> 106) THEN
			_id_indirizzo_sogg_fis := insert_indirizzo((campi_fissi -> 'nazione_soggfis')::integer, campi_fissi -> 'cod_provincia_soggfis',
									       (campi_fissi -> 'cod_comune_soggfis')::integer, campi_fissi -> 'comune_residenza_estero_soggfis',
									       (campi_fissi -> 'toponimo_soggfis')::integer, campi_fissi -> 'via_soggfis', campi_fissi -> 'cap_soggfis', campi_fissi -> 'civico_soggfis',
									       (campi_fissi -> 'latitudine_soggfis')::double precision, (campi_fissi -> 'longitudine_soggfis')::double precision,
									       campi_fissi -> 'presso_soggfis');
		END IF;

		--inserimento indirizzo sede legale/impresa
		--IF (length(trim(campi_fissi ->'via_sede_legale')) <> 0 OR length(trim(campi_fissi -> 'comune_estero_sede_legale')) <> 0) THEN
		IF (length(trim(campi_fissi ->'via_sede_legale')) <> 0 OR (campi_fissi -> 'nazione_sede_legale')::integer <> 106) THEN
			_id_indirizzo_sede_legale := insert_indirizzo((campi_fissi -> 'nazione_sede_legale')::integer, campi_fissi -> 'cod_provincia_sede_legale',
									       (campi_fissi -> 'cod_comune_sede_legale')::integer, campi_fissi -> 'comune_estero_sede_legale', 
									       (campi_fissi -> 'toponimo_sede_legale')::integer, campi_fissi -> 'via_sede_legale', campi_fissi -> 'cap_leg', campi_fissi -> 'civico_sede_legale',
									       (campi_fissi -> 'latitudine_leg')::double precision, (campi_fissi -> 'longitudine_leg')::double precision,
									       campi_fissi -> 'presso_sede_legale');
		END IF;

		--inserimento soggetto fisico/rapp legale
		IF (length(trim(campi_fissi ->'codice_fiscale_rappresentante')) <> 0 OR (campi_fissi -> 'nazione_nascita_rapp_leg')::integer <> 106) THEN
			_id_sogg_fis := insert_opu_noscia_soggetto_fisico(campi_fissi -> 'nome_rapp_leg', campi_fissi -> 'cognome_rapp_leg', (campi_fissi -> 'nazione_nascita_rapp_leg')::integer,
									  campi_fissi -> 'codice_fiscale_rappresentante', campi_fissi -> 'sesso_rapp_leg', utente_in, 
									  campi_fissi -> 'telefono_rapp_leg', campi_fissi -> 'email_rapp_leg', _id_indirizzo_sogg_fis,
									  campi_fissi -> 'comune_nascita_rapp_leg', (campi_fissi -> 'data_nascita_rapp_leg')::timestamp without time zone);
		END IF;

		--inserimento impresa/ operatore
		IF (length(trim(campi_fissi ->'partita_iva')) <> 0 OR length(trim(campi_fissi -> 'codice_fiscale')) <> 0) THEN
			_id_operatore := insert_opu_noscia_impresa(campi_fissi -> 'codice_fiscale', campi_fissi -> 'partita_iva', campi_fissi -> 'ragione_sociale',
								   utente_in, campi_fissi -> 'email_impresa', (campi_fissi -> 'tipo_impresa')::integer, _id_indirizzo_sede_legale);
		END IF;

		--inserimento relazione opu_rel_operatore_soggetto_fisico
		IF _id_sogg_fis is not null AND _id_operatore is not null THEN
			perform insert_opu_noscia_rel_impresa_soggfis(_id_sogg_fis, _id_operatore);
		END IF;
	END IF;

	--gestione stabilimento
	--inserimento indirizzo stabilimento
	_id_indirizzo_stabilimento := _id_indirizzo_sede_legale;
	IF (length(trim(campi_fissi ->'via_stab')) <> 0) THEN
		_id_indirizzo_stabilimento := insert_indirizzo(106, campi_fissi -> 'cod_provincia_stab',
								       (campi_fissi -> 'cod_comune_stab')::integer, null, (campi_fissi -> 'toponimo_stab')::integer,
								       campi_fissi -> 'via_stab', campi_fissi -> 'cap_stab', campi_fissi -> 'civico_stab',
								       (campi_fissi -> 'latitudine_stab')::double precision, (campi_fissi -> 'longitudine_stab')::double precision,
								       campi_fissi -> 'presso_stab');
	END IF;
	
	--inserisci stabilimento e recupero id stabilimento inserito
	IF _id_indirizzo_stabilimento = _id_indirizzo_sede_legale THEN
		_numero_registrazione_osa := genera_numero_registrazione_da_comune((campi_fissi -> 'cod_comune_sede_legale')::integer);
	ELSE 
		_numero_registrazione_osa := genera_numero_registrazione_da_comune((campi_fissi -> 'cod_comune_stab')::integer);
	END IF;
	
	IF _id_indirizzo_stabilimento is not null THEN
		SELECT distinct(split_part(key,'_',2)) into r FROM each(campi_fissi) where key ilike '%lineaattivita_%' || '%_codice_univoco_ml%' limit 1;
		_codice_univoco_ml := campi_fissi -> concat('lineaattivita_', r,'_codice_univoco_ml');
		--_id_stabilimento := insert_opu_noscia_stabilimento(_id_operatore, _id_indirizzo_stabilimento, utente_in, _codice_univoco_ml, campi_fissi -> 'numero_registrazione_stabilimento');
		_id_stabilimento := insert_opu_noscia_stabilimento(_id_operatore, _id_indirizzo_stabilimento, utente_in, _codice_univoco_ml, _numero_registrazione_osa);
	END IF;

	IF _id_indirizzo_stabilimento = _id_indirizzo_sede_legale THEN
		update opu_stabilimento set id_asl = (select codiceistatasl::integer from comuni1 where id = (campi_fissi -> 'cod_comune_sede_legale')::integer) where id = _id_stabilimento;
	END IF;

	--inserimento relazione stabilimento linea di attivita
	FOR r IN SELECT distinct(split_part(key,'_',2)) FROM each(campi_fissi) where key ilike '%lineaattivita_%'
	    LOOP
		_codice_univoco_ml := campi_fissi -> concat('lineaattivita_', r,'_codice_univoco_ml');
		_data_inizio := campi_fissi -> concat('lineaattivita_', r,'_data_inizio_attivita');
		_data_fine := campi_fissi -> concat('lineaattivita_', r,'_data_fine_attivita');
		_num_riconoscimento := campi_fissi -> concat('lineaattivita_', r,'_num_riconoscimento');
		_tipo_carattere := campi_fissi -> concat('lineaattivita_', r,'_tipo_carattere_attivita');
		
		IF (_id_stabilimento is not null AND length(trim(_codice_univoco_ml)) <> 0) THEN
			perform insert_opu_noscia_rel_stabilimento_linea(_id_stabilimento, _codice_univoco_ml, _num_riconoscimento, utente_in, 
									_data_inizio::timestamp without time zone, _data_fine::timestamp without time zone,
									_tipo_carattere::integer);
		END IF;	
	    END LOOP;

		IF (_id_stabilimento is not null) THEN
			update opu_stabilimento set data_inizio_attivita = (select min(data_inizio) from opu_relazione_stabilimento_linee_produttive where id_stabilimento = _id_stabilimento and enabled) where id = _id_stabilimento;    
         	END IF; 

select count(ml8.*) into _n_categorizzabili from opu_relazione_stabilimento_linee_produttive rel 
join ml8_linee_attivita_nuove_materializzata ml8 on ml8.id_nuova_linea_attivita = rel.id_linea_produttiva 
left join master_list_flag_linee_attivita flag on flag.codice_univoco = ml8.codice_attivita 
where flag.categorizzabili and rel.enabled and rel.id_stabilimento = _id_stabilimento;


-- inserimento campi aggiuntivi anagrafica
IF (_id_stabilimento is not null) THEN
	perform insert_anag_dati_aggiuntivi(_id_stabilimento,'opu_stabilimento',campi_fissi -> 'denominazione_stab',
	                                            campi_fissi -> 'nome_resp_stab', campi_fissi -> 'cognome_resp_stab', campi_fissi -> 'cf_resp_stab');
END IF; 
-- fine inserimento campi aggiuntivi anagrafica



IF _n_categorizzabili > 0 THEN
   update opu_stabilimento set categoria_rischio = 3 where id = _id_stabilimento;
END IF;

	perform refresh_anagrafica(_id_stabilimento, 'opu');

	raise WARNING 'id finali: id stab %, id operatore %, id sogg fis %s, id indi stab %, id ind impresa %s, id ind sogg fis %', 
			_id_stabilimento, _id_operatore, _id_sogg_fis, _id_indirizzo_stabilimento, _id_indirizzo_sede_legale, _id_indirizzo_sogg_fis;


	
	return _id_stabilimento;
	
END;
$function$
;

CREATE OR REPLACE FUNCTION public.insert_opu_noscia_indirizzo(_nazione integer, _id_provincia text, _id_comune integer, _comune_estero text, _toponimo integer, _via text, _cap text, _civico text DEFAULT NULL::text, _latitudine double precision DEFAULT NULL::double precision, _longitudine double precision DEFAULT NULL::double precision, _presso text DEFAULT NULL::text)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE 
	_nazione_testo text;
	_comune_testo text;
	_topon text;
	_id_ind integer;
        
BEGIN	

	select description into _nazione_testo from lookup_nazioni where code = _nazione limit 1;

	--se nazione uguale italia si inserisce l'indirizzo completo
	IF _nazione = 106 THEN
	
		select nome into _comune_testo from comuni1 where id = _id_comune limit 1;
		select description into _topon from lookup_toponimi where code = _toponimo limit 1;
		
		IF _civico is null THEN
			_civico := 'SNC';
		END IF;

		select id into _id_ind from indirizzi 
			where trim(provincia) ilike _id_provincia and
			      comune = _id_comune and
			      toponimo = _toponimo and
			      trim(via) ilike _via and
			      trim(civico) ilike _civico and
			      coalesce(presso,'') ilike coalesce(_presso,'') and
			      latitudine = _latitudine and
			      longitudine = _longitudine limit 1;

		IF _id_ind is null THEN
			insert into indirizzi(via, cap, provincia, nazione, latitudine, longitudine, comune, comune_testo, toponimo, civico, topon, presso)
			values(_via, _cap, _id_provincia, _nazione_testo, _latitudine, _longitudine, _id_comune, _comune_testo, _toponimo, _civico, _topon, _presso) returning id into _id_ind;
		END IF; 
	--se si tratta di un indirizzo estero si inseriscono (come testo) solo la nazione e il comune 
	ELSE
		select id into _id_ind from indirizzi 
			where trim(nazione) ilike trim(_nazione_testo) and trim(comune_testo) ilike trim(_comune_estero) limit 1;
			
		IF _id_ind is null THEN	      
			insert into indirizzi(nazione, comune_testo) values(_nazione_testo, _comune_estero) returning id into _id_ind;
		END IF;
		
	END IF;
	
	return _id_ind;
	      
END;
$function$
;


CREATE OR REPLACE FUNCTION public.update_comune_provincia()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
   DECLARE
   comune text;
   provincia text ;
   cap  text;
   cont integer;
   nazione text;
   nazione2 text;
   desc_nazione text;		
   cod_provincia_comune text;
   cod_provincia_province integer;
   msg text;
   
   BEGIN

msg = '';
desc_nazione = 'ITALIA';

if NEW.city  != ''
THEN
--Recuper codice della provincia inserita da lookup
if (NEW.state is not null) then 
	cod_provincia_province := (SELECT code from lookup_province where description ilike trim(NEW.state) or cod_provincia ilike trim(NEW.state));

end if;

-- Recupero comune scelto da lookup (con specifica della prov)
if (NEW.city  != '' and NEW.city is not null and cod_provincia_province is not null) then
	comune:= (select c.nome from 
	comuni1 c 
	where c.nome ilike trim(NEW.city) and c.cod_provincia::integer=cod_provincia_province
	);
	cod_provincia_comune := (SELECT cod_provincia from comuni1 where nome ilike trim(comune) and cod_provincia::integer=cod_provincia_province);
	provincia := (select lp.cod_provincia from lookup_province lp where cod_provincia_comune::integer=lp.code);
end if;

-- Recupero comune scelto da lookup (senza specifica della prov)
if (NEW.city != '' and NEW.city is not null and NEW.state is null) then
	cont := (select count(c.nome) from  --controllo sul comune (caso di stesso nome ma prov diverse)
	comuni1 c 
	where c.nome ilike trim(NEW.city)
	);
	IF (cont=1) then 
		comune:= (select c.nome from 
		comuni1 c 
		where c.nome ilike trim(NEW.city)
		);
		cod_provincia_comune := (SELECT cod_provincia from comuni1 where nome ilike trim(comune) );
		provincia := (select lp.cod_provincia from lookup_province lp where cod_provincia_comune::integer=lp.code);
	end if;
end if;

-- Recupero nazione scelta tramite COMUNE da lookup
if (NEW.city != '' and NEW.city is not null) then
	nazione:= (select naz.code from 
	lookup_nazioni naz where description ilike trim(NEW.city)
);
end if;

-- Recupero nazione scelta tramite PROVINCIA da lookup
if (NEW.state != '' and NEW.state is not null) then
	nazione2:= (select naz.code from 
	lookup_nazioni naz where description ilike trim(NEW.state)
);
end if;

-- SE NON HO TROVATO IL COMUNE
 IF (cod_provincia_comune is null) then	
	if (NEW.city is null or NEW.city='') then
		msg = msg || ' Comune non inserito; ';
	end if;
	if (NEW.city is not null and NEW.city!='') then
		msg = msg || ' Comune ' ||  NEW.city || ' non trovato o non coerente con provincia inserita';
	end if;
 END IF;
 
-- SE NON HO TROVATO LA PROVINCIA
IF (NEW.state is not null) then
	IF (cod_provincia_province is null) then
		msg = msg || ' Provincia ' ||  NEW.state || ' non trovata; ';
	end if;
END IF;

IF (cod_provincia_comune is not null and  cod_provincia_province is not null and cod_provincia_comune::integer <> cod_provincia_province) then
-- SE IL CODICE ISTAT DEL COMUNE E' DIVERSO DA QUELLO DELLA PROVINCIA
	msg = msg || ' Comune ' ||  trim(NEW.city) || ' non coerente con la provincia '|| trim(NEW.state); 
END IF;

-- Se ho trovato la nazione (comune) nella lookup
IF (nazione is not null and cod_provincia_comune is null) THEN
	msg = '';
	provincia := trim(NEW.city);
	comune := trim(NEW.state);
	desc_nazione = trim(NEW.city);
END IF;

-- Se ho trovato la nazione (provincia) nella lookup
IF (nazione2 is not null and cod_provincia_comune is null) THEN
	msg = '';
	provincia := trim(NEW.state);
	comune := trim(NEW.city);
	desc_nazione = trim(NEW.state);
END IF;

-- Se ho trovato un errore
IF (msg <> '') THEN
	msg = '[IndirizziException] ' || msg;
	raise exception '%', msg ;
END IF;

--Setto i valori
NEW.state := provincia;
NEW.city := comune;
NEW.country := desc_nazione;
NEW.codiceistatasl_old:=(select codiceistatasl_old from comuni1 where nome ilike NEW.city);

end if ;

RETURN NEW;
     
   END
$function$
;


CREATE OR REPLACE FUNCTION public.update_modif_stab()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
   DECLARE
   BEGIN


  NEW.numero_registrazione:= (select c.codice_nuovo_||lpad(dbi_opu_get_progressivo_per_comune(c.id)::text, 6, '0')
from
opu_stabilimento s
join indirizzi i on i.id=s.id_indirizzo
join comuni1 c on c.id = i.comune
where s.id =NEW.id );


     RETURN NEW;
   END
$function$
;


CREATE OR REPLACE FUNCTION public.verifica_esistenza_impresa(_partita_iva_in text)
 RETURNS SETOF json
 LANGUAGE plpgsql
AS $function$

BEGIN

 
return query
select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_imprese from
(
select distinct
       oo.id::text as id_impresa_recuperata,
       trim(oo.ragione_sociale) as ragione_sociale_impresa,
       trim(oo.partita_iva) as partita_iva_impresa, 
       trim(oo.codice_fiscale_impresa) as codice_fiscale_impresa, 
       trim(oo.domicilio_digitale) as email_impresa,
       oo.tipo_impresa::text as tipo_impresa,
       ln.code::text as nazione_sede_legale,
       case when ln.code = 106 then trim(oi.provincia) else null end as "provinciaIdSedeLegale",
       case when ln.code = 106 then trim(lp.description) else null end as provincia_sede_legale,
       case when ln.code = 106 then oi.comune::text else null end as "comuneIdSedeLegale",
       case when ln.code <> 106 then trim(oi.comune_testo) else null end as comune_estero_sede_legale,
       case when ln.code = 106 then trim(c.nome) else null end as comune_sede_legale,
       case when ln.code = 106 then oi.toponimo::text else null end as "topIdSedeLegale",
       case when ln.code = 106 then trim(lt.description) else null end as toponimo_sede_legale,
       case when ln.code = 106 then trim(oi.via) else null end as via_sede_legale,
       case when ln.code = 106 then trim(oi.civico) else null end as civico_sede_legale,
       case when ln.code = 106 then trim(oi.cap) else null end as cap_sede_legale,
       case when ln.code = 106 then trim(oi.presso) else null end as presso_sede_legale,
       case when ln.code = 106 then oi.latitudine::text else null end as latitudine_sede_legale,
       case when ln.code = 106 then oi.longitudine::text else null end as longitudine_sede_legale,
       os.id::text as id_rapp_legale_recuperato,
       trim(os.nome) as nome_rapp_legale, 
       trim(os.cognome) as cognome_rapp_legale, 
       trim(os.sesso) as sesso_rapp_legale, 
       case when os.provenienza_estera = false then 106::text else os.id_nazione_nascita::text end as nazione_nascita_rapp_legale, 
       case when os.provenienza_estera = false then c2_sogg.id::text else null end as comune_nascita_rapp_legale ,  
       case when os.provenienza_estera = true then trim(os.comune_nascita) end as comune_nascita_estero_rapp_legale ,
       to_char(os.data_nascita, 'DD-MM-YYYY') as data_nascita_rapp_legale,
       trim(os.codice_fiscale) as cf_rapp_legale,
       trim(os.email) as email_rapp_legale,
       trim(os.telefono) as telefono_rapp_legale,
       ln_sogg.code::text as nazione_residenza_rapp_legale,
       case when ln_sogg.code = 106 then oi_sogg.provincia::text else null end as "provinciaIdResidenzaRappLegale",
       case when ln_sogg.code = 106 then trim(lp_sogg.description) else null end as provincia_residenza_rapp_legale,
       case when ln_sogg.code = 106 then  oi_sogg.comune::text else null end as "comuneIdResidenzaRappLegale",
       case when ln_sogg.code <> 106 then trim(oi_sogg.comune_testo) else null end as comune_residenza_estero_rapp_legale,
       case when ln_sogg.code = 106 then trim(c_sogg.nome) else null end as comune_residenza_rapp_legale,
       case when ln_sogg.code = 106 then oi_sogg.toponimo::text else null end as "topIdResidenzaRappLegale" ,
       case when ln_sogg.code = 106 then trim(lt_sogg.description) else null end as toponimo_residenza_rapp_legale ,
       case when ln_sogg.code = 106 then trim(oi_sogg.via) else null end as via_residenza_rapp_legale,
       case when ln_sogg.code = 106 then trim(oi_sogg.civico) else null end as civico_residenza_rapp_legale,
       case when ln_sogg.code = 106 then trim(oi_sogg.cap) else null end as cap_residenza_rapp_legale,
       case when ln_sogg.code = 106 then trim(oi_sogg.presso) else null end as presso_rapp_legale,
       case when ln_sogg.code = 106 then oi_sogg.latitudine::text else null end as latitudine_rapp_legale,
       case when ln_sogg.code = 106 then oi_sogg.longitudine::text else null end as longitudine_rapp_legale
	from aia_impresa oo 
        join aia_stabilimento stab on stab.id_impresa = oo.id and stab.trashed_date is null
       -- join opu_relazione_stabilimento_linee_produttive rel on rel.id_stabilimento = stab.id
	left join indirizzi oi on oo.id_indirizzo = oi.id 
	left join comuni1 c on oi.comune = c.id
	left join lookup_province lp on lp.code = c.cod_provincia::integer
	left join lookup_toponimi lt on lt.code = oi.toponimo and lt.enabled
	left join lookup_nazioni ln on (trim(ln.description) ilike trim(oi.nazione) or trim(ln.code::text) ilike trim(oi.nazione))
	--left join opu_rel_operatore_soggetto_fisico opurel on opurel.id_operatore = oo.id
	left join aia_soggetto_fisico os on oo.id_soggetto_fisico = os.id
	left join indirizzi oi_sogg on os.id_indirizzo= oi_sogg.id
	left join comuni1 c_sogg on oi_sogg.comune = c_sogg.id
	left join lookup_province lp_sogg on lp_sogg.code = c_sogg.cod_provincia::integer
	left join lookup_toponimi lt_sogg on lt_sogg.code = oi_sogg.toponimo and lt_sogg.enabled
	left join lookup_nazioni ln_sogg on (trim(ln_sogg.description) ilike trim(oi_sogg.nazione) or trim (ln_sogg.code::text) ilike oi_sogg.nazione::text)
	left join comuni1 c2_sogg on trim(os.comune_nascita) ilike trim(c2_sogg.nome)		       
	where trim(oo.partita_iva) ilike trim(_partita_iva_in)
	--and opurel.enabled and rel.enabled
	--and opurel.data_fine is null
	and oo.trashed_date is null
	and os.trashed_date is null
        and stab.trashed_date is null

		      ) tab;

END;	
    
$function$
;



--RINOMINARE riferimento_nome_tab_indirizzi  IN RICERCHE ANAGRAFICHE MATERIALIZZATA



CREATE OR REPLACE FUNCTION preaccettazione.aggiorna_coordinate_stabilimento(_riferimento_id integer, _riferimento_id_nome text, _riferimento_id_nome_tab text, _latitudine double precision, _longitudine double precision)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE

	_id_sede_operativa integer;

BEGIN
	select id_sede_operativa into _id_sede_operativa
		from ricerche_anagrafiche_old_materializzata 
			where riferimento_id = _riferimento_id and 
			      riferimento_id_nome = _riferimento_id_nome and 
			      riferimento_id_nome_tab = _riferimento_id_nome_tab limit 1;	

	--"opu_indirizzo" per "opu_stabilimento", "suap_ric_scia_stabilimento" e "apicoltura_imprese"
	IF _riferimento_id_nome_tab = 'opu_stabilimento' or _riferimento_id_nome_tab = 'suap_ric_scia_stabilimento' or _riferimento_id_nome_tab = 'apicoltura_imprese' THEN
		update opu_indirizzo 
			set latitudine = _latitudine,
			    longitudine = _longitudine
			where id = _id_sede_operativa;
			
		update ricerche_anagrafiche_old_materializzata 
			set latitudine_stab = _latitudine, longitudine_stab = _longitudine
			where riferimento_id = _riferimento_id and riferimento_id_nome ilike _riferimento_id_nome and riferimento_id_nome_tab ilike _riferimento_id_nome_tab;
			
	END IF;

	--"organization_address" per "organization"	
	IF _riferimento_id_nome_tab = 'organization' THEN
		update organization_address
			set latitude = _latitudine,
			    longitude = _longitudine
			where address_id = _id_sede_operativa;

		update ricerche_anagrafiche_old_materializzata 
			set latitudine_stab = _latitudine, longitudine_stab = _longitudine
			where riferimento_id = _riferimento_id and riferimento_id_nome ilike _riferimento_id_nome and riferimento_id_nome_tab ilike _riferimento_id_nome_tab;

	END IF;
	
	--"anagrafica.indirizzi" per "stabilimenti"
	IF _riferimento_id_nome_tab = 'stabilimenti' THEN
		update anagrafica.indirizzi 
			set latitudine = _latitudine,
			    longitudine = _longitudine
			where id = _id_sede_operativa;

		update ricerche_anagrafiche_old_materializzata 
			set latitudine_stab = _latitudine, longitudine_stab = _longitudine
			where riferimento_id = _riferimento_id and riferimento_id_nome ilike _riferimento_id_nome and riferimento_id_nome_tab ilike _riferimento_id_nome_tab;
			
	END IF;
	
	--"sintesis_indirizzo" per "sintesis_stabilimento"
	IF _riferimento_id_nome_tab = 'sintesis_stabilimento' THEN
		update sintesis_indirizzo
			set latitudine = _latitudine,
			    longitudine = _longitudine
			where id = _id_sede_operativa;

		update ricerche_anagrafiche_old_materializzata 
			set latitudine_stab = _latitudine, longitudine_stab = _longitudine
			where riferimento_id = _riferimento_id and riferimento_id_nome ilike _riferimento_id_nome and riferimento_id_nome_tab ilike _riferimento_id_nome_tab;
	END IF;

	return true ;
	
END;
$function$
;


CREATE OR REPLACE FUNCTION public.dbi_cerca_indirizzo_per_id(iddindirizzo integer)
 RETURNS TABLE(id integer, via text, cap text, provincia text, nazione text, latitudine double precision, longitudine double precision, comune integer, riferimento_org_id integer, riferimento_address_id integer, address_type integer, comune_testo text, toponimo text, civico text, code integer, description text, cod_provincia text, descrizione_comune text, descrizione_provincia text, descrizione_toponimo text)
 LANGUAGE plpgsql
 STRICT
AS $function$

DECLARE
	r RECORD;
	 	
BEGIN
		FOR 
		id  , via  , cap  ,provincia  , nazione ,latitudine  , longitudine ,comune ,
riferimento_org_id  , riferimento_address_id ,address_type ,comune_testo , toponimo  , civico  ,code ,

description ,cod_provincia ,descrizione_comune , descrizione_provincia , descrizione_toponimo
		in

select 
ind.id , ind.via , ind.cap , ind.provincia  , ind.nazione ,ind.latitudine  , ind.longitudine ,ind.comune ,
ind.riferimento_org_id  , ind.riferimento_address_id ,ind.address_type ,ind.comune_testo as com , ind.toponimo  , ind.civico
,asl.code , asl.description ,c.cod_provincia,coalesce (c.nome,ind.comune_testo) as descrizionecomune,
lp.description as descrizioneprovincia, lt.description as descrizionetoponimo 
from indirizzi ind 
join comuni1 c on c.id =ind.comune 
left join lookup_site_id asl on (c.codiceistatasl)::int = asl.codiceistat::int   and asl.enabled=true 
left join lookup_province lp on lp.code = c.cod_provincia::int  
left join lookup_toponimi lt on lt.code = ind.toponimo::int   where ind.id = iddindirizzo	


		
    LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
    
 END;
$function$
;



ALTER TABLE public.opu_lookup_tipologia_attivita RENAME TO lookup_tipologia_attivita;





CREATE OR REPLACE FUNCTION public.insert_indirizzo(_nazione integer, _id_provincia text, _id_comune integer, _comune_estero text, _toponimo integer, _via text, _cap text, _civico text DEFAULT NULL::text, _latitudine double precision DEFAULT NULL::double precision, _longitudine double precision DEFAULT NULL::double precision, _presso text DEFAULT NULL::text)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE 
	_nazione_testo text;
	_comune_testo text;
	_topon text;
	_id_ind integer;
        
BEGIN	

	select description into _nazione_testo from lookup_nazioni where code = _nazione limit 1;

	--se nazione uguale italia si inserisce l'indirizzo completo
	IF _nazione = 106 THEN
	
		select nome into _comune_testo from comuni1 where id = _id_comune limit 1;
		select description into _topon from lookup_toponimi where code = _toponimo limit 1;
		
		IF _civico is null THEN
			_civico := 'SNC';
		END IF;

		select id into _id_ind from indirizzi 
			where trim(provincia) ilike _id_provincia and
			      comune = _id_comune and
			      toponimo = _toponimo and
			      trim(via) ilike _via and
			      trim(civico) ilike _civico and
			      coalesce(presso,'') ilike coalesce(_presso,'') and
			      latitudine = _latitudine and
			      longitudine = _longitudine limit 1;

		IF _id_ind is null THEN
			insert into indirizzi(via, cap, provincia, nazione, latitudine, longitudine, comune, comune_testo, toponimo, civico, topon, presso)
			values(_via, _cap, _id_provincia, _nazione_testo, _latitudine, _longitudine, _id_comune, _comune_testo, _toponimo, _civico, _topon, _presso) returning id into _id_ind;
		END IF; 
	--se si tratta di un indirizzo estero si inseriscono (come testo) solo la nazione e il comune 
	ELSE
		select id into _id_ind from indirizzi 
			where trim(nazione) ilike trim(_nazione_testo) and trim(comune_testo) ilike trim(_comune_estero) limit 1;
			
		IF _id_ind is null THEN	      
			insert into indirizzi(nazione, comune_testo) values(_nazione_testo, _comune_estero) returning id into _id_ind;
		END IF;
		
	END IF;
	
	return _id_ind;
	      
END;
$function$
;






CREATE OR REPLACE FUNCTION public.genera_numero_registrazione(_idstabilimento integer)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
_numRegistrazione text ;
_idIndirizzo integer;
_idComune integer;
_idProvincia integer;
_codComune text;
_codProvincia text;
_progressivo integer;

BEGIN

_progressivo = 0;
_idIndirizzo := -1;

-- sede operativa
select relsi.id_indirizzo into _idIndirizzo from aia_stabilimento relsi where relsi.id = _idStabilimento and relsi.trashed_date  is null;
raise info 'CERCO ID INDIRIZZO SEDE OPERATIVA: %', _idIndirizzo;

-- sede legale
IF _idIndirizzo<0 THEN
select ai.id_indirizzo into _idIndirizzo from 
aia_stabilimento s
join aia_impresa ai on ai.id_stabilimento = s.id and ai.trashed_date is null
where s.id = _idStabilimento;
raise info 'CERCO ID INDIRIZZO SEDE LEGALE: %', _idIndirizzo;
END IF;

-- residenza
--IF _idIndirizzo<0 THEN
--select relsfi.id_indirizzo  into _idIndirizzo from 
--anagrafica.stabilimenti s
--join anagrafica.rel_imprese_stabilimenti relis on relis.id_stabilimento = s.id and relis.data_cancellazione is null and relis.data_scadenza is null
--join anagrafica.imprese i on i.id = relis.id_impresa and i.data_cancellazione is null
--join anagrafica.rel_imprese_soggetti_fisici relisf on relisf.id_impresa = i.id and relisf.data_cancellazione is null and relisf.data_scadenza is null
--join anagrafica.soggetti_fisici sf on sf.id = relisf.id_soggetto_fisico and sf.data_cancellazione is null
--join anagrafica.rel_soggetti_fisici_indirizzi relsfi on relsfi.id_soggetto_fisico = sf.id and relsfi.data_cancellazione is null and relsfi.data_scadenza is null 
--where s.id = _idStabilimento;
--raise info 'CERCO ID INDIRIZZO RESIDENZA: %', _idIndirizzo;
--END IF;

IF _idIndirizzo>0 THEN
-- se ho trovato un indirizzo, recupero i codici di comune e provincia
select comune into _idComune from indirizzi where id = _idIndirizzo;
select id_provincia into _idProvincia from comuni1 c  where id = _idComune;
select cod_comune into _codComune from comuni1 where id = _idComune;
select cod_provincia into _codProvincia from lookup_province where code = _idProvincia;
ELSE
-- altrimenti uso codici di default
_codComune := '000';
_codProvincia := 'ND';
END IF;
raise info 'COD COMUNE: %', _codComune;
raise info 'COD PROVINCIA: %', _codProvincia;

-- calcolo il progressivo per quei codici
select COALESCE(max(progressivo), 0) into _progressivo from progressivi_comune_provincia where cod_comune = _codComune and cod_provincia = _codProvincia;
_progressivo = _progressivo+1;
insert into progressivi_comune_provincia(progressivo, cod_comune, cod_provincia) values (_progressivo, _codComune, _codProvincia);

raise info 'PROGRESSIVO: %', _progressivo;

_numRegistrazione := 'U020' || 'N' || _codComune || _codProvincia || lpad(_progressivo||'', 6, '0');
raise info 'NUM REGISTRAZIONE: %', _numRegistrazione;

return _numRegistrazione ;
END;
$function$
;


CREATE OR REPLACE FUNCTION public.genera_numero_registrazione(_idstabilimento integer)
 RETURNS text
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
_numRegistrazione text ;
_idIndirizzo integer;
_idComune integer;
_idProvincia integer;
_codComune text;
_codProvincia text;
_progressivo integer;

BEGIN

_progressivo = 0;
_idIndirizzo := -1;

-- sede operativa
select relsi.id_indirizzo into _idIndirizzo from aia_stabilimento relsi where relsi.id = _idStabilimento and relsi.trashed_date  is null;
raise info 'CERCO ID INDIRIZZO SEDE OPERATIVA: %', _idIndirizzo;

-- sede legale
IF _idIndirizzo<0 THEN
select ai.id_indirizzo into _idIndirizzo from 
aia_stabilimento s
join aia_impresa ai on ai.id_stabilimento = s.id and ai.trashed_date is null
where s.id = _idStabilimento;
raise info 'CERCO ID INDIRIZZO SEDE LEGALE: %', _idIndirizzo;
END IF;

-- residenza
--IF _idIndirizzo<0 THEN
--select relsfi.id_indirizzo  into _idIndirizzo from 
--anagrafica.stabilimenti s
--join anagrafica.rel_imprese_stabilimenti relis on relis.id_stabilimento = s.id and relis.data_cancellazione is null and relis.data_scadenza is null
--join anagrafica.imprese i on i.id = relis.id_impresa and i.data_cancellazione is null
--join anagrafica.rel_imprese_soggetti_fisici relisf on relisf.id_impresa = i.id and relisf.data_cancellazione is null and relisf.data_scadenza is null
--join anagrafica.soggetti_fisici sf on sf.id = relisf.id_soggetto_fisico and sf.data_cancellazione is null
--join anagrafica.rel_soggetti_fisici_indirizzi relsfi on relsfi.id_soggetto_fisico = sf.id and relsfi.data_cancellazione is null and relsfi.data_scadenza is null 
--where s.id = _idStabilimento;
--raise info 'CERCO ID INDIRIZZO RESIDENZA: %', _idIndirizzo;
--END IF;

IF _idIndirizzo>0 THEN
-- se ho trovato un indirizzo, recupero i codici di comune e provincia
select comune into _idComune from indirizzi where id = _idIndirizzo;
select id_provincia into _idProvincia from comuni1 c  where id = _idComune;
select cod_comune into _codComune from comuni1 where id = _idComune;
select cod_provincia into _codProvincia from lookup_province where code = _idProvincia;
ELSE
-- altrimenti uso codici di default
_codComune := '000';
_codProvincia := 'ND';
END IF;
raise info 'COD COMUNE: %', _codComune;
raise info 'COD PROVINCIA: %', _codProvincia;

-- calcolo il progressivo per quei codici
select COALESCE(max(progressivo), 0) into _progressivo from progressivi_comune_provincia where cod_comune = _codComune and cod_provincia = _codProvincia;
_progressivo = _progressivo+1;
insert into progressivi_comune_provincia(progressivo, cod_comune, cod_provincia) values (_progressivo, _codComune, _codProvincia);

raise info 'PROGRESSIVO: %', _progressivo;

_numRegistrazione := 'U020' || 'N' || _codComune || _codProvincia || lpad(_progressivo||'', 6, '0');
raise info 'NUM REGISTRAZIONE: %', _numRegistrazione;

return _numRegistrazione ;
END;
$function$
;


CREATE OR REPLACE FUNCTION public.genera_numero_registrazione_da_comune(_id_comune integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE 

	_numero_registrazione text;
	_codComune text;
	_codProvincia text;

        
BEGIN	

	select comuni1.cod_comune, lp.cod_provincia  into _codComune, _codProvincia 
		from comuni1 join lookup_province lp on lp.code =  comuni1.cod_provincia::int 
			where comuni1.id = _id_comune;
	_numero_registrazione:= (select genera_numero_registrazione from genera_numero_registrazione(_codComune, _codProvincia));

	return _numero_registrazione;
	      
END;
$function$
;


CREATE OR REPLACE FUNCTION public.update_impianto(jsondati json, utente_in integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE 


id_indirizzo int4;
_id_sogg_fis int4;
id_impresa int4;
id_stab int4;
id_rel int4;
_id_indirizzo_sede_legale int4;
_id_indirizzo_stabilimento int4;
_id_indirizzo_sogg_fis int4;
n_ippc int4;
i int4;
nome_ippc text;
nome_quanti text;
nome_princ text;
nome_data text;
_numero_registrazione_osa text;
id_resp int4;
id_legale int4;
id_resp2 int4;
nome_resp text;
cognome_resp text;
cf_resp text;
json_impr_iniziale text;
BEGIN	
	
	
		SELECT json_agg(aia_impresa) into json_impr_iniziale FROM aia_impresa where id= (jsonDati ->>'id_impresa')::integer;


	update aia_impresa set ragione_sociale = jsonDati ->>'ragione_sociale' , domicilio_digitale = jsonDati ->>'email_impresa',modifiedby=utente_in::int4 where id = (jsonDati ->>'id_impresa')::integer;
	select id_soggetto_fisico into id_resp from aia_stabilimento as2 where as2.id=(jsonDati ->>'id_stabilimento')::integer;

	select nome,cognome,codice_fiscale into nome_resp,cognome_resp,cf_resp from aia_soggetto_fisico asf where id=id_resp;
	select id_soggetto_fisico into id_legale from aia_impresa ai  where id=(jsonDati ->>'id_impresa')::integer;


	if (cf_resp <> jsonDati ->>'cf_resp_stab' or nome_resp <> jsonDati ->>'nome_resp_stab' or cognome_resp <> jsonDati ->>'cognome_resp_stab')
	then
	insert into aia_soggetto_fisico(nome,cognome,codice_fiscale,id_indirizzo) values(jsonDati ->>'nome_resp_stab',jsonDati ->>'cognome_resp_stab',jsonDati ->>'cf_resp_stab',-1) returning id into id_resp ;
	update aia_stabilimento set id_soggetto_fisico = id_resp,modified_by=utente_in::int4 ,modified=now() where id=(jsonDati ->>'id_stabilimento')::integer;
	end if;
	
	if (jsonDati ->> 'cod_comune_soggfis' <> '') then
		IF (length(trim(jsonDati ->>'via_soggfis')) <> 0 OR (jsonDati ->> 'nazione_residenza_rapp_legale')::integer <> 106) THEN
			_id_indirizzo_sogg_fis := insert_indirizzo((jsonDati ->> 'nazione_residenza_rapp_legale')::integer, jsonDati ->> 'cod_provincia_soggfis',
									       (jsonDati ->> 'cod_comune_soggfis')::integer, jsonDati ->> 'comune_residenza_estero_soggfis',
									       (jsonDati ->> 'toponimo_soggfis')::integer, jsonDati ->> 'via_soggfis', jsonDati ->> 'cap_soggfis', jsonDati ->> 'civico_soggfis',
									       null, null,
									       jsonDati ->> 'presso_soggfis');
		END IF;
	else
	_id_indirizzo_sogg_fis := insert_indirizzo((jsonDati ->> 'nazione_residenza_rapp_legale')::integer, jsonDati ->> 'cod_provincia_soggfis',
									       -1, jsonDati ->> 'comune_residenza_estero_soggfis',
									       -1, jsonDati ->> 'via_soggfis', jsonDati ->> 'cap_soggfis', jsonDati ->> 'civico_soggfis',
									       null, null,
									       jsonDati ->> 'presso_soggfis');
	
	
	end if;
	
	raise info '%', jsonDati;

	update aia_soggetto_fisico set telefono= jsonDati ->>'telefono_rapp_leg', email=jsonDati ->>'email_rapp_leg' ,modifiedby=utente_in::int4 where id=id_legale;

	
	if((jsonDati ->> 'cod_comune_soggfis') <> '' or (jsonDati ->> 'nazione_residenza_rapp_legale') <> '106' ) then
	update aia_soggetto_fisico set id_indirizzo= _id_indirizzo_sogg_fis where id=id_legale;
	end if;
	

	insert into aia_impresa_storico_operazioni(id_impresa,id_utente,data_operazione,tipologia,json_iniziale,json_finale) values(
	(jsonDati ->>'id_impresa')::integer,
	utente_in,
	now(),
	'modifica',
		json_impr_iniziale::text,
	jsondati::text
	);
	
	return (jsonDati ->>'id_stabilimento')::integer  ;
	
END;
$function$
;













insert into lookup_tipo_scheda_operatore (code, description, enabled, titolo, firma_data, nome_file) values (1, 'Impianti AIA', true, 'Scheda Impianto', false, 'SchedaImpianto');

update scheda_operatore_metadati set enabled = false where tipo_operatore = 1;insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','PARTITA IVA','','partita_iva','aia_stabilimento s left join aia_impresa a on s.id_impresa = a.id','s.id = #stabid#','aaa','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','CODICE FISCALE IMPRESA','','codice_fiscale_impresa','aia_stabilimento s left join aia_impresa a on s.id_impresa = a.id','s.id = #stabid#','aaaa','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','DOMICILIO DIGITALE (PEC)','','domicilio_digitale','aia_stabilimento s left join aia_impresa a on s.id_impresa = a.id','s.id = #stabid#','aaaaa','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','SEDE LEGALE','capitolo','','','','b','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','SEDE OPERATIVA','capitolo','','','','c','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','INDIRIZZO ','','concat(t.description, '' '', i.via, '', '', i.civico,'', '',  c.nome, '' '', i.cap, ''('', p.description, '') '')','aia_stabilimento s 
left join indirizzi i on i.id = s.id_indirizzo
left join lookup_toponimi t on t.code = i.toponimo
left join comuni1 c on c.id = i.comune
left join lookup_province p on p.code = c.cod_provincia::integer','s.id = #stabid#','cc','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','COORDINATE','','concat(''Long. '', i.longitudine, '' Lat. '', i.latitudine)','aia_stabilimento s 
left join indirizzi i on i.id = s.id_indirizzo
left join lookup_toponimi t on t.code = i.toponimo
left join comuni1 c on c.id = i.comune
left join lookup_province p on p.code = c.cod_provincia::integer','s.id = #stabid#','ccc','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','UTENTE INSERIMENTO','','concat(c.namefirst, '' '', c.namelast)','aia_stabilimento s left join access_ a on a.user_id = s.entered_by left join contact_ c on c.contact_id = a.contact_id','s.id = #stabid#','LLL','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','INDIRIZZO','','case when i.nazione ilike ''Italia'' then concat(t.description, '' '', i.via, '', '', i.civico,'', '', c.nome, '' '', i.cap, ''('', p.description, '') '') else concat(i.comune_testo, '' ('', i.nazione, '')'') end','aia_stabilimento s 
left join aia_impresa a on s.id_impresa = a.id
left join indirizzi i on i.id = a.id_indirizzo
left join lookup_toponimi t on t.code = i.toponimo
left join comuni1 c on c.id = i.comune
left join lookup_province p on p.code = c.cod_provincia::integer','s.id = #stabid#','bb','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','DATI IMPIANTO','capitolo','','','','d','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','CODICE FISCALE','','sf.codice_fiscale','aia_stabilimento s 
left join aia_impresa a on a.id = s.id_impresa
left join aia_soggetto_fisico sf on a.id_soggetto_fisico = sf.id','s.id = #stabid#','eeeee','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','DENOMINAZIONE','','d.denominazione_stabilimento','aia_stabilimento s 
left join anag_dati_aggiuntivi d on s.id = d.riferimento_id and d.riferimento_id_nome_tab = ''aia_stabilimento''','s.id = #stabid# and d.trashed_date is null and d.denominazione_stabilimento <> ''''','dd','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','DIPARTIMENTO','','a.description','aia_stabilimento s left join lookup_site_id a on a.code = s.id_asl','s.id = #stabid#','ddd','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','NUMERO REGISTRAZIONE GISA','','s.numero_registrazione','aia_stabilimento s','s.id = #stabid#','dddd','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','TIPO ATTIVITA''','','''CON SEDE FISSA''','aia_stabilimento s','s.id = #stabid#','ddddd','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','GESTORE IMPIANTO','capitolo','','','','e','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','NOME E COGNOME','','concat(sf.nome, '' '', sf.cognome)','aia_stabilimento s 
left join aia_impresa a on a.id = s.id_impresa
left join aia_soggetto_fisico sf on a.id_soggetto_fisico = sf.id','s.id = #stabid#','ee','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','SESSO','','sf.sesso','aia_stabilimento s 
left join aia_impresa a on a.id = s.id_impresa
left join aia_soggetto_fisico sf on a.id_soggetto_fisico = sf.id','s.id = #stabid#','eee','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','NASCITA','','concat(to_char(sf.data_nascita, ''dd/MM/yyyy''), '' ( '', sf.comune_nascita, '')'')','aia_stabilimento s 
left join aia_impresa a on a.id = s.id_impresa
left join aia_soggetto_fisico sf on a.id_soggetto_fisico = sf.id','s.id = #stabid#','eeee','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','DOMICILIO DIGITALE (PEC) ','','sf.email','aia_stabilimento s 
left join aia_impresa a on a.id = s.id_impresa
left join aia_soggetto_fisico sf on a.id_soggetto_fisico = sf.id','s.id = #stabid#','eeeeeee','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','TELEFONO ','','sf.telefono','aia_stabilimento s 
left join aia_impresa a on a.id = s.id_impresa
left join aia_soggetto_fisico sf on a.id_soggetto_fisico = sf.id','s.id = #stabid#','eeeeeeee','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','RESPONSABILE IMPIANTO','capitolo','','','','f','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','NOME E COGNOME ','','concat(sf.nome, '' '', sf.cognome)','aia_stabilimento s 
left join aia_soggetto_fisico sf on s.id_soggetto_fisico = sf.id','s.id = #stabid#','ff','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','LISTA CODICI IPPC','capitolo','','','','G','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','CODICI IPPC','','concat( CASE
    WHEN principale is true THEN ''(Codice Principale)<br>''
else ''(Codice Secondario)<br>'' end,''<b>categoria impianto -> codice ippc -> descrizione  </b><br>'',cci.categoria,''  -> '',cci.codice,''  -> '',cci.descrizione,''<br><b>Data inizio:</b>'',to_char(data_inizio_attivita, ''dd/MM/yyyy''),''<br><b>quantitativi autorizzati:</b>'',quantitativi_autorizzati::text,'' '',''<br><b>stato: </b>'',lsl.description::text)','aia_rel_stabilimento_codici arsc join codici_categoria_ippc cci on arsc.id_codice_descrizione=cci.id_codici_descrizione 
 join lookup_stato_lab lsl on lsl.code=id_stato','arsc.id_stabilimento = #stabid#','gg','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','CODICE FISCALE ','','sf.codice_fiscale','aia_stabilimento s 
left join aia_soggetto_fisico sf on s.id_soggetto_fisico = sf.id','s.id = #stabid#','fff','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','DATI AUTORIZZATIVI','capitolo','','','','h','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','DATI SPECIFICI','capitolo','','','','i','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','INFORMAZIONI DI SERVIZIO','capitolo','','','','L','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','DATA INSERIMENTO','','to_char(s.entered, ''dd/MM/yyyy'')','aia_stabilimento s','s.id = #stabid#','LL','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','DATI IMPRESA','capitolo','','','','a','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','RAGIONE SOCIALE','','ragione_sociale','aia_stabilimento s left join aia_impresa a on s.id_impresa = a.id','s.id = #stabid#','aa','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','ACQUE REFLUE','','concat(''<b>Depurazione reflui</b>: '', case when a.depurazione_reflui then ''SI'' else ''NO'' end, 
'' <b>Stato impianto</b>: '', s.description, 
'' <b>Gestore impianto</b>: '', a.gestore_impianto,
'' <b>Processo depurativo</b>: '', p.description,
'' <b>Potenzialita impianto AE</b>: '', a.potenzialita_impianto_ae,
'' <b>Recettore scarico</b>: '', a.recettore_scarico,
'' <b>Recettore finale</b>: '', a.recettore_finale,
'' <b>Codice Ulia</b>: '', a.codice_ulia)','anag_acque_reflue a
left join lookup_stato_impianto_acque_reflue s on s.code = a.id_stato_impianto
left join lookup_processo_depurativo p on p.code = a.id_processo_depurativo','a.riferimento_id = #stabid# 
and a.riferimento_id_nome_tab = ''aia_stabilimento'' 
and a.trashed_date is null 
and has_matrice_anagrafica(#stabid#, ''aia_stabilimento'', ''ACQUE REFLUE'')','III','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','RESIDENZA','','case when i.nazione ilike ''Italia'' then concat(t.description, '' '', i.via, '', '', i.civico,'', '', c.nome, '' '', i.cap, ''('', p.description, '') '') else concat(i.comune_testo, '' ('', i.nazione, '')'') end','aia_stabilimento s 
left join aia_impresa a on a.id = s.id_impresa
left join aia_soggetto_fisico sf on a.id_soggetto_fisico = sf.id
left join indirizzi i on i.id = sf.id_indirizzo
left join lookup_toponimi t on t.code = i.toponimo
left join comuni1 c on c.id = i.comune
left join lookup_province p on p.code = c.cod_provincia::integer','s.id = #stabid#','eeeeee','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','DECRETI','','concat(''<b>ID AIA</b>: '', a.id_aia, '' <b>Autorizzazione</b> : '', l.description, '' <b>Num. Decreto</b>: '', a.num_decreto, '' <b>Nota</b>: '', a.nota, '' <b>BURC</b>: '', a.burc, '' <b>Matrici</b>: '', string_agg(m.description, ''-''))','anag_dati_autorizzativi a
left join lookup_autorizzazione_tipo l on a.tipo_autorizzazione = l.code
left join anag_dati_autorizzativi_matrici am on am.id_anag_dati_autorizzativi = a.id
left join lookup_matrice_controlli m on m.code = am.id_matrice','a.riferimento_id =  #stabid# and a.riferimento_id_nome_tab = ''aia_stabilimento'' and a.trashed_date is null group by a.id_aia, l.description, a.num_decreto, a.nota, a.burc;','hh','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('1','EMISSIONI IN ATMOSFERA CAMINI','','concat(
''<b>Codice camino</b>: '', e.codice_camino, 
'' <b>Fasi lavorativa</b>: '', e.fasi_lavorativa,
'' <b>Inquinanti</b>:  '', e.inquinanti, 
'' <b>Sistema abbattimento</b>: '', e.sistema_abbattimento)','anag_emissioni_in_atmosfera_camini a
join emissioni_in_atmosfera_camini e on e.id = a.id_emissioni_in_atmosfera_camini  and a.trashed_date is null','a.riferimento_id = #stabid#
and a.riferimento_id_nome_tab = ''aia_stabilimento'' 
and a.trashed_date is null and  has_matrice_anagrafica(#stabid#, ''aia_stabilimento'', ''Emissione in atmosfera convogliate'')','II','');
delete from scheda_operatore_metadati where tipo_operatore <> 1;
delete from lookup_tipo_scheda_operatore where code <> 1;
insert into lookup_tipo_scheda_operatore (code, description, enabled, titolo, firma_data, nome_file) values (2, 'Impianti AUA', true, 'Scheda Impianto', false, 'SchedaImpianto');






alter table aia_rel_stabilimento_codici add column modifiedby integer;
alter table aia_rel_stabilimento_codici add column modified timestamp without time zone;










CREATE OR REPLACE FUNCTION public.update_ippc(jsondati json, utente_in integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE 


id_indirizzo int4;
_id_sogg_fis int4;
id_impresa int4;
id_stab int4;
id_rel int4;
i int4;
n_ippc int4;
nome_ippc text;
nome_quanti text;
nome_princ text;
nome_data text;
nome_univ text;
_numero_registrazione_osa text;
id_resp int4;
codice_asl int4;
_numero_registrazione text;
BEGIN	

	
	select id into id_stab from aia_stabilimento as2 where as2.id= (jsonDati ->> 'id_stabilimento')::integer;
	update aia_rel_stabilimento_codici set enabled=false where id_stabilimento=id_stab;

n_ippc = (jsonDati ->> 'numero_ippc')::integer;
	i=0;
	
	for i in 0..n_ippc  loop
		
		nome_ippc = concat('id_ippc_',(i+1)::text);
		nome_quanti = concat('quantitativi_ippc_',(i+1)::text);
		nome_princ = concat('principale_ippc_',(i+1)::text);
		nome_data = concat('data_inizio_attivita_',(i+1)::text);
		nome_univ = concat('id_ippc_univoco',(i+1)::text);
	
	if ((jsonDati ->> nome_univ)::integer is null)
	 then
		
	 if ((jsonDati ->> nome_ippc)::integer is not null)
	 then
      raise info 'IPPC INFO % ',(jsonDati ->> nome_ippc)::integer;
     
    _numero_registrazione:= (select genera_numero_registrazione from genera_numero_registrazione(jsonDati ->> 'cod_comune_stab', jsonDati ->> 'cod_provincia_stab'));

     
      insert into aia_rel_stabilimento_codici(id_stabilimento,id_codice_descrizione,principale,quantitativi_autorizzati,data_inizio_attivita,id_stato,enabled,numero_registrazione_linea) 
     values(id_stab,(jsonDati ->> nome_ippc)::integer,(jsonDati ->> nome_princ)::boolean,
    (jsonDati ->> nome_quanti)::integer, (jsonDati ->> nome_data)::timestamp,99,true,
    _numero_registrazione
    );
     end if;
    else
    update aia_rel_stabilimento_codici set enabled=true where id=(jsonDati ->> nome_univ)::integer;
    end if;
     end loop;

		perform refresh_anagrafica(id_stab, 'aia');

	
	return id_stab;
	
END;
$function$
;
