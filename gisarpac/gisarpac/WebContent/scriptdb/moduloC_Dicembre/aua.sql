-- public.aua_autorizzazioni definition

-- Drop table

-- DROP TABLE public.aua_autorizzazioni;

CREATE TABLE public.aua_autorizzazioni (
	id bigserial NOT NULL,
	progressivo int8 NOT NULL,
	estremi text NOT NULL,
	data_rilascio timestamp NULL,
	data_scadenza timestamp NULL,
	ente text NULL,
	tipo text NULL,
	operazioni_r text NULL,
	operazioni_d text NULL,
	trashed_date timestamp NULL,
	gestione_vfu bool NULL,
	gestione_raee bool NULL,
	incenerimento bool NULL,
	autorizzazione_eow bool NULL,
	note_internal_use_only_hd text NULL,
	id_impresa int8 NULL
);






-- public.aua_dati_autorizzazioni definition

-- Drop table

-- DROP TABLE public.aua_dati_autorizzazioni;

CREATE TABLE public.aua_dati_autorizzazioni (
	id bigserial NOT NULL,
	id_autorizzazione int8 NOT NULL,
	capacita_complessiva int8 NULL,
	coincenerimento text NULL,
	categoria_discarica text NULL,
	capacita_residua int8 NULL,
	capacita_pericolosa int8 NULL,
	capacita_non_pericolosa int8 NULL
);




-- public.aua_impresa definition

-- Drop table

-- DROP TABLE public.aua_impresa;

CREATE TABLE public.aua_impresa (
	id bigserial NOT NULL,
	codice_fiscale_impresa text NULL,
	note text NULL,
	ragione_sociale text NULL,
	enteredby int4 NULL,
	modifiedby int4 NULL,
	trashed_date timestamp NULL,
	note_internal_use_only_hd text NULL
);




-- public.aua_stabilimento definition

-- Drop table

-- DROP TABLE public.aua_stabilimento;

CREATE TABLE public.aua_stabilimento (
	id bigserial NOT NULL,
	id_impresa int8 NOT NULL,
	id_indirizzo int8 NOT NULL,
	entered timestamp NULL,
	modified timestamp NULL,
	entered_by int4 NULL,
	modified_by int4 NULL,
	id_asl int4 NULL,
	flag_fuori_regione bool NULL,
	ciureg text NULL,
	trashed_date timestamp NULL,
	notes_hd text NULL,
	anno text NULL,
	trashed_by int4 NULL,
	num_schede_aut int4 NULL,
	ciuprov text NULL,
	mesi_attivita varchar NULL
);



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
  WHERE arsc.enabled IS TRUE
UNION
 SELECT DISTINCT as2.id::integer AS riferimento_id,
    'stabId'::text AS riferimento_id_nome,
    'id_stabilimento'::text AS riferimento_id_nome_col,
    'aua_stabilimento'::text AS riferimento_id_nome_tab,
    '-1'::integer AS id_indirizzo_impresa,
    as2.id_indirizzo::integer AS id_sede_operativa,
    '-1'::integer AS sede_mobile_o_altro,
    'indirizzi'::text AS riferimento_nome_tab_indirizzi,
    as2.id_impresa::integer AS id_impresa,
    'aua_impresa'::text AS riferimento_nome_tab_impresa,
    '-1'::integer AS id_soggetto_fisico,
    'aua_soggetto_fisico'::text AS riferimento_nome_tab_soggetto_fisico,
    '-1'::integer AS id_attivita,
    NULL::boolean AS pregresso_o_import,
    NULL::integer AS riferimento_org_id,
    as2.entered AS data_inserimento,
    ai.ragione_sociale::character varying(300) AS ragione_sociale,
    as2.id_asl AS asl_rif,
    lsi.description AS asl,
    ai.codice_fiscale_impresa AS codice_fiscale,
    ''::text AS codice_fiscale_rappresentante,
    as2.ciureg::character varying(255) AS partita_iva,
    3 AS categoria_rischio,
    now()::timestamp without time zone AS prossimo_controllo,
    ''::text AS num_riconoscimento,
    ''::text AS n_reg,
    ''::text AS n_linea,
    ''::text AS nominativo_rappresentante,
    'CON SEDE FISSA'::text AS tipo_attivita_descrizione,
    1 AS tipo_attivita,
    now()::timestamp without time zone AS data_inizio_attivita,
    now()::timestamp without time zone AS data_fine_attivita,
    ''::character varying(50) AS stato,
    '-1'::integer AS id_stato,
    c.nome AS comune,
    lp.description AS provincia_stab,
    concat(o1.via, ' ', o1.civico) AS indirizzo,
    o1.cap AS cap_stab,
    o1.latitudine AS latitudine_stab,
    o1.longitudine AS longitudine_stab,
    ''::character varying(100) AS comune_leg,
    ''::text AS provincia_leg,
    ''::character varying(300) AS indirizzo_leg,
    ''::character(20) AS cap_leg,
    NULL::double precision AS latitudine_leg,
    NULL::double precision AS longitudine_leg,
    ''::text AS macroarea,
    ''::text AS aggregazione,
    ''::text AS attivita,
    ''::character varying(1000) AS path_attivita_completo,
    ''::text AS gestione_masterlist,
    ''::text AS norma,
    1 AS id_norma,
    999 AS tipologia_operatore,
    1 AS tipo_ricerca_anagrafica,
    'gray'::text AS color,
    ''::text AS n_reg_old,
    '-1'::integer AS id_tipo_linea_reg_ric,
    '-1'::integer AS id_linea,
    ''::text AS codice_macroarea,
    ''::text AS codice_aggregazione,
    ''::text AS codice_attivita,
    NULL::boolean AS miscela,
    false AS principale,
    c.id AS id_comune
   FROM aua_stabilimento as2
     JOIN aua_impresa ai ON as2.id_impresa = ai.id
     LEFT JOIN indirizzi o1 ON o1.id = as2.id_indirizzo
     LEFT JOIN comuni1 c ON c.id = o1.comune
     LEFT JOIN lookup_province lp ON lp.code::text = o1.provincia::text
     LEFT JOIN lookup_site_id lsi ON lsi.code = as2.id_asl;
     
     
     
     
     
     CREATE OR REPLACE FUNCTION public.aua_insert_into_ricerche_anagrafiche_old_materializzata(idstabilimento integer)
 RETURNS boolean
 LANGUAGE plpgsql
 STRICT
AS $function$
DECLARE
idRecord int ;
BEGIN

raise info 'sto eliminando dalla tabella ';
delete from ricerche_anagrafiche_old_materializzata where riferimento_id_nome ='stabId' and riferimento_id_nome_tab = 'aua_stabilimento'  and riferimento_id =idStabilimento ;
raise info 'Eliminazione Eseguita ';
insert into ricerche_anagrafiche_old_materializzata (select * from ricerca_anagrafiche  where riferimento_id_nome ='stabId' and riferimento_id_nome_tab = 'aua_stabilimento'  and riferimento_id =idStabilimento);
raise info 'Nuovo Inserimento Effettuato ';

	return true ;
 END;
$function$
;


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



CREATE OR REPLACE FUNCTION public.import_aua()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$

declare 
arow record;
id_da_salvare int4;
cap_ text;
cod_provincia_ text;
c_id_ int4;
id_stab int4;
id_indirizzo int4;
id_imp int4;
id_aut int4;
	BEGIN

		
		
		
		
		 -- Ciclo attraverso le tuple della tabella sorgente
    FOR arow IN SELECT * FROM semplificate_per_gisa spg  LOOP
        -- Inserimento della tupla nella tabella di destinazione
        INSERT INTO aua_impresa (codice_fiscale_impresa, ragione_sociale)
        VALUES (arow.codicefiscale, arow.descrragsoc) returning id into id_imp;

        -- Recupero dell'ID appena inserito nella tabella di destinazione

       select c.cap,c.cod_provincia,c.id into cap_,cod_provincia_,c_id_ from semplificate_per_gisa spg join comuni1 c on concat('0',spg.istatprovincia,case
	WHEN length(spg.istatcomune::text)=1  THEN concat('00',spg.istatcomune)
    WHEN  length(spg.istatcomune::text)=2 THEN concat('0',spg.istatcomune)
    WHEN length(spg.istatcomune::text)=3  THEN spg.istatcomune::text
    ELSE ''
  END) ilike c.istat where spg.codicefiscale ilike arow.codicefiscale; 
       
       
       insert into indirizzi(via,cap,provincia,nazione,comune,civico)values(
       arow.via,cap_,cod_provincia_,'ITALIA',c_id_,arow.NumCivico
       ) returning id into id_indirizzo;
       
       
       INSERT INTO aua_stabilimento(ciureg,id_impresa,id_indirizzo,entered,modified,ciuprov,anno,num_schede_aut,mesi_attivita)
        VALUES (arow.ciureg,id_imp,id_indirizzo,now(),now(),arow.ciuprov,arow.anno,arow.numschedeaut,arow.mesi_di_attivita_anno) returning id into id_stab;
       
       
      INSERT INTO public.aua_autorizzazioni
	( progressivo, estremi, data_rilascio, data_scadenza, ente, tipo, operazioni_r, operazioni_d, trashed_date, gestione_vfu, gestione_raee, incenerimento, autorizzazione_eow, note_internal_use_only_hd, id_impresa)
	VALUES( arow.progressivoaut, arow.estremiautorizzazione,arow.datarilascioaut::timestamp without time zone,arow.datascadaut::timestamp without time zone, arow.ente, 
	arow.tipoaut, arow.operazionirautorizzate, arow.operazionidautorizzate, NULL, 
case when arow.gestionevfu = '1' then true else false end ,case when arow.gestioneraee = '1' then true else false end,case when arow.incenerimento = '1' then true else false end,case when arow.autorizzazioneeow = '1' then true else false end, NULL, id_imp)returning id into id_aut;
       

insert into aua_dati_autorizzazioni(id_autorizzazione,capacita_complessiva,coincenerimento,
categoria_discarica,capacita_residua,capacita_pericolosa,capacita_non_pericolosa)values(
id_aut,arow."Capacit_complessiva_autoriz",arow.coincenerimento,arow.categoriadiscarica_1,arow.capacitaresidua3112_1,arow."di cui capacit rif pericolosi", arow."di cui capacit rif non pericolosi"
);


      perform refresh_anagrafica(id_stab::int, 'aua');
       
    END LOOP;
		
		
		
		
		
		
		
		
		
		
		return 1;
		
	END;
$function$
;



CREATE OR REPLACE FUNCTION public.insert_aua(jsondati json, utente_in integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE 

_id_indirizzo_stabilimento int8;
id_stab int8;
id_impresa int8;
id_aut int8;
BEGIN	

	IF (length(trim(jsonDati ->>'via_stab')) <> 0)  THEN
	_id_indirizzo_stabilimento := insert_indirizzo(106, jsonDati ->> 'cod_provincia_stab',
							       (jsonDati ->> 'cod_comune_stab')::integer, null, (jsonDati ->> 'toponimo_stab')::integer,
							       jsonDati ->> 'via_stab', jsonDati ->> 'cap_stab', jsonDati ->> 'civico_stab',
							       (jsonDati ->> 'latitudine_stab')::double precision, (jsonDati ->> 'longitudine_stab')::double precision,
							       jsonDati ->> 'presso_stab');
	END IF;
	

insert into aua_impresa (codice_fiscale_impresa,ragione_sociale,enteredby) values(
	jsonDati ->>'codice_fiscale_impresa',
	jsonDati ->>'ragione_sociale',
	utente_in::int4
	)returning id into id_impresa;



	
 insert into aua_stabilimento (id_impresa,id_indirizzo,entered,modified,entered_by,ciureg,ciuprov,anno,mesi_attivita,num_schede_aut) values(
		id_impresa,
		_id_indirizzo_stabilimento,
		now(),
		now(),
		utente_in::int4,
		jsonDati ->> 'ciureg',
		jsonDati ->> 'ciuprov',
		jsonDati ->> 'anno',
		jsonDati ->> 'mesi_attivita',
		(jsonDati ->> 'schede_aut')::int4
		)returning id into id_stab;



	insert into aua_autorizzazioni(progressivo,estremi,data_rilascio,data_scadenza,ente,tipo,operazioni_r,operazioni_d,gestione_vfu,gestione_raee,incenerimento,autorizzazione_eow,id_impresa) 
	values('0001',
	jsonDati ->> 'estremi',
	(jsonDati ->> 'data_rilascio')::timestamp,
	(jsonDati ->> 'data_scadenza')::timestamp,
	jsonDati ->> 'ente',
	jsonDati ->> 'tipo',
	jsonDati ->> 'operazioni_r',
	jsonDati ->> 'operazioni_d',
	(jsonDati ->> 'gestione_vfu')::bool,
	(jsonDati ->> 'gestione_raee')::bool,
	(jsonDati ->> 'incenerimento')::bool,
	(jsonDati ->> 'autorizzazione_eow')::bool,
	id_impresa
	)returning id into id_aut;
	
	
	
	
	insert into aua_dati_autorizzazioni(id_autorizzazione,capacita_complessiva,coincenerimento,categoria_discarica,capacita_residua,capacita_pericolosa,capacita_non_pericolosa)values(
	id_aut,
	(jsonDati ->> 'capacita_complessiva')::int8,
	(jsonDati ->> 'coincenerimento')::int8,
	(jsonDati ->> 'categoria_discarica')::int8,
	(jsonDati ->> 'capacita_residua')::int8,
	(jsonDati ->> 'capacita_pericolosa')::int8,
	(jsonDati ->> 'capacita_non_pericolosa')::int8);
	
	

	perform refresh_anagrafica(id_stab::int, 'aua');
     
     
     
     
     
     



	
	return id_stab;
	
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

if (origine='aua') THEN
raise info 'aggiorno da AUA';
refresh := (select * from aua_insert_into_ricerche_anagrafiche_old_materializzata(id));
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



