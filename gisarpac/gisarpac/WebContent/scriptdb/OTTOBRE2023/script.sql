-- CHI: RITA MELE
-- QUANDO: 17/10/23
-- COSA: aggiunta del permesso per terra dei fuochi

--6
insert into permission_category (category, description, level, enabled, constant) values (37,'Terra dei fuochi',1,true, 1) returning category_id;
--26
insert into permission (category_id,permission,permission_view,permission_add,permission_edit,permission_delete,description , level,enabled,active)
values (6,'terra-dei-fuochi',true,true,true,true,'GESTIONE CAVALIERE DEDICATO ALLA TERRA DEI FUOCHI',10,true,true) returning permission_id;



CREATE TABLE IF NOT EXISTS public.lookup_campionamento_particella
(
    code serial,
    description text,
    default_item boolean DEFAULT false,
    level integer DEFAULT 0,
    enabled boolean DEFAULT true
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.lookup_campionamento_particella
    OWNER to postgres; 

CREATE OR REPLACE FUNCTION public.get_campionamento_particella(
	_id_area_particella integer)
    RETURNS TABLE(id integer, descrizione text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	id_padre integer;
BEGIN 
	
    id_padre :=	(select a.id_padre from area_particelle a where a.trashed_date is null and a.id = _id_area_particella);
	if (id_padre > 0) then
		RETURN QUERY
		select l.code, l.description from lookup_campionamento_particella l where enabled and default_item;
	else
		RETURN QUERY
		select l.code, l.description from lookup_campionamento_particella l where enabled and default_item = false;
	end if;
END;
$BODY$;

ALTER FUNCTION public.get_campionamento_particella(integer)
    OWNER TO postgres;


    
insert into lookup_campionamento_particella(description) values ('MANCATO CAMPIONAMENTO SU SUOLO');
insert into lookup_campionamento_particella(description) values ('MANCATO CAMPIONAMENTO SU ACQUE SOTTERRANEE');
insert into lookup_campionamento_particella(description, default_item) values ('CAMPIONAMENTO SU SUOLO',true);
insert into lookup_campionamento_particella(description, default_item) values ('CAMPIONAMENTO SU ACQUE SOTTERRANEE',true);
DROP FUNCTION IF EXISTS public.get_motivi_controllo_ufficiale(integer);

--select * from public.get_campionamento_particella()

-- inserimento tecnica per campionamento
insert into lookup_tipo_controllo (code,description, info_campione, enabled) values(4,'Campionamento', true, false);

alter table giornata_ispettiva_gruppo_ispettivo add column addetto_campionamento boolean;
alter table giornata_ispettiva_gruppo_ispettivo add column tecnico_campionamento boolean;
alter table particelle add column trashed_date timestamp;
CREATE TABLE IF NOT EXISTS public.campionamento_suolo_particelle_dati_verbale
(
    id serial,
    id_campione integer,
    carabinieri_forestali text,
	altri_partecipanti text,
	proprietario_particella text,
	presente_al_campionamento_in_qualita_di text,
	codice_identificativo_voc text,
	codice_identificativo_c1 text,
	codice_identificativo_c2 text,
	codice_identificativo_c3 text,
	codice_identificativo_c4 text,
	codice_identificativo_c5 text,
	codice_identificativo_medio_composito text,
	coordinata_x_voc text,
	coordinata_x_c1 text,
	coordinata_x_c2 text,
	coordinata_x_c3 text,
	coordinata_x_c4 text,
	coordinata_x_c5 text,
    coordinata_x_medio_composito text,
	coordinata_y_voc text,
	coordinata_y_c1 text,
	coordinata_y_c2 text,
	coordinata_y_c3 text,
	coordinata_y_c4 text,
	coordinata_y_c5 text,
    coordinata_y_medio_composito text,
    num_campioni_elementari text,
    particella_campionata text,
	prodotti_coltivati text,
	presenza_rifiuti text,
	id_utente integer,
    trashed_date timestamp
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.campionamento_suolo_particelle_dati_verbale
    OWNER to postgres;

alter table campionamento_suolo_particelle_dati_verbale add column id_area_particelle integer;

    
CREATE TABLE IF NOT EXISTS public.lookup_coltura_particella
(
    code serial,
    description text,
	short_description text,
    default_item boolean DEFAULT false,
    level integer DEFAULT 0,
    enabled boolean DEFAULT true
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.lookup_coltura_particella
    OWNER to postgres;    

insert into lookup_coltura_particella(description, short_description) values('Con coltura in atto','C');
insert into lookup_coltura_particella(description, short_description) values('Arata','A');
insert into lookup_coltura_particella(description, short_description) values('Incolta con erba spontanea','I');
insert into lookup_coltura_particella(description, short_description) values('Non coltivabile','NC');

CREATE OR REPLACE FUNCTION public.get_tipo_coltura_particella()
    RETURNS TABLE(id integer, descrizione text, codice text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	
BEGIN 
	
	RETURN QUERY
		select l.code, l.description, l.short_description from lookup_coltura_particella l where enabled;

END;
$BODY$;

ALTER FUNCTION public.get_tipo_coltura_particella()
    OWNER TO postgres;
    
CREATE OR REPLACE FUNCTION public.verifica_univocita_codice_sito_particella(IN _codice text, _id integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
flagblocco boolean;
contatore integer;

BEGIN

flagblocco :=true;
if _id = -1 then
	contatore := (select count(*) from area_particelle where trashed_date is null and 
			  trim(upper(codice_sito)) ilike trim(upper(_codice)));
else
	contatore := (select count(*) from area_particelle where trashed_date is null and 
			  	trim(upper(codice_sito)) ilike trim(upper(_codice)) and id <> _id);
end if;
if contatore = 0 then
	flagblocco := false; -- non esiste duplicato
else
	flagblocco := true; --  esiste duplicato
end if;
	
	return flagblocco;

 END;
$BODY$;

ALTER FUNCTION public.verifica_univocita_codice_sito_particella(text,integer)
    OWNER TO postgres;
	

CREATE OR REPLACE FUNCTION public.insert_area(
	_codice_sito text,
	_id_sito text,
	_id_provincia integer,
	_id_comune integer,
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
	insert into area_particelle(codice_sito, id_sito, id_provincia, id_comune, foglio_catastale, particella_catastale, classe_rischio, coordinate_x, coordinate_y, area, note, id_padre, entered, entered_by) 
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
	_note,
	-1,
	now(),
	_id_utente) returning id into id_area_particella;

	return id_area_particella;
	      
END;
$BODY$;

ALTER FUNCTION public.insert_area(text, text, integer, integer, text, text, text, text, text, text, text, integer)
    OWNER TO postgres;
	
	-- FUNCTION: public.update_area_particella(integer, text, text, integer, integer, text, text, text, text, text, text, text, integer)

-- DROP FUNCTION IF EXISTS public.update_area_particella(integer, text, text, integer, integer, text, text, text, text, text, text, text, integer);

CREATE OR REPLACE FUNCTION public.update_area(
	_id integer,
	_codice_sito text,
	_id_sito text,
	_id_provincia integer,
	_id_comune integer,
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
	foglio_catastale = _foglio_catastale,
	particella_catastale = _particella_catastale,
	classe_rischio = _classe_rischio,
	coordinate_x = _coordinate_x,
	coordinate_y = _coordinate_y,
	area = _area,
	note = _note,
	modified = now(),
	modified_by = _id_utente
	where id = _id and trashed_date is null;

	return _id;
	      
END;
$BODY$;

ALTER FUNCTION public.update_area(integer, text, text, integer, integer, text, text, text, text, text, text, text, integer)
    OWNER TO postgres;
    
CREATE OR REPLACE FUNCTION public.update_subparticella(
	_id integer,
	_id_padre integer,
	_codice_sito text,
	_coordinate_x text,
	_coordinate_y text,
	_note text,
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
	set codice_sito = _codice_sito, 
	coordinate_x = _coordinate_x, 
	coordinate_y = _coordinate_y, 
	note = _note, 
	id_padre = _id_padre, 
	modified= now(),
	modified_by = _id_utente
	where id = _id and trashed_date is null;

	return _id;
	      
END;
$BODY$;

ALTER FUNCTION public.update_subparticella(integer, integer, text, text, text, text, integer)
    OWNER TO postgres;
-- tabella di log per inserimento campionamento

    CREATE TABLE IF NOT EXISTS public.campionamento_particelle_log_json
(
    id serial,
    enteredby integer,
    entered timestamp without time zone DEFAULT now(),
    json_cp json
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.campionamento_particelle_log_json
    OWNER to postgres;
    

CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_gruppo_ispettivo(
	_json_daticonnucleo json,
	_idgiornataispettiva integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_daticonnucleo) 
	  LOOP
	      
	
		 INSERT INTO giornata_ispettiva_gruppo_ispettivo (id_giornata_ispettiva, id_componente, enabled, referente, responsabile, 
														  addetto_campionamento, tecnico_campionamento, id_struttura, nome_struttura) 
		 values (_idgiornataispettiva, 
				(i->>'id')::integer,
				 true, 
		 		coalesce((i->>'referente')::boolean,false), 
		 		coalesce((i->>'responsabile')::boolean,false),
			  	coalesce((i->>'addettoCampionamento')::boolean,false),
				coalesce((i->>'tecnicoCampionamento')::boolean,false),
				(i->>'idStruttura')::integer, (i->>'struttura')::text);
	  END LOOP;

    	 return 1;
END;
$BODY$;

ALTER FUNCTION public.giornata_ispettiva_insert_gruppo_ispettivo(json, integer)
    OWNER TO postgres;
	


-- FUNCTION: public.campionamento_suolo_insert_dati_verbale(json, integer)

-- DROP FUNCTION IF EXISTS public.campionamento_suolo_insert_dati_verbale(json, integer);

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
									altri_partecipanti,
									proprietario_particella,
									presente_al_campionamento_in_qualita_di,
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
									presenza_rifiuti,
								    id_utente) values
									((_json_dati ->>'carabinieriForestali')::text,
									 (_json_dati ->>'altriPartecipanti')::text,
									 (_json_dati ->>'datiProprietarioParticella')::text,
									 (_json_dati ->>'qualitaAltriPartecipanti')::text,
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
									 (_json_dati ->>'presenzaRifiuti')::text,
									 _idutente)
			returning id into result;
		return result;
END;
$BODY$;

ALTER FUNCTION public.campionamento_suolo_insert_dati_verbale(json, integer)
    OWNER TO postgres;


-- FUNCTION: public.campionamento_particella_insert_globale(json)

-- DROP FUNCTION IF EXISTS public.campionamento_particella_insert_globale(json);

-- FUNCTION: public.campionamento_particella_insert_globale(json)

-- DROP FUNCTION IF EXISTS public.campionamento_particella_insert_globale(json);

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
	gruppoispettivo json;
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
	
	gruppoispettivo :=  _json_dati ->'GruppoTecniciAddetti';
	RAISE INFO 'json Gruppo Ispettivo %', gruppoispettivo;
	
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
	output := (SELECT * FROM public.giornata_ispettiva_insert_gruppo_ispettivo(gruppoispettivo,idcontrollo));

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
	
	-- STEP 3.1: INSERIAMO IL GRUPPO ISPETTIVO
	output := (SELECT * from public.campione_insert_gruppo_ispettivo(gruppoispettivo, idcampione));
	
	--STEP 4: inserisco dati del verbale
	id_campionamento_suolo := (select * from campionamento_suolo_insert_dati_verbale(dativerbale,idutente));
	update campionamento_suolo_particelle_dati_verbale 
	set id_campione= idcampione
	where id = id_campionamento_suolo;
	
	return idcampione;
END;
$BODY$;

ALTER FUNCTION public.campionamento_particella_insert_globale(json)
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
	gruppoispettivo json;
	dativerbalecampione json;
	tecnicacu json;
	matrici json;
	motivo json;

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
														select 'codiceSito' as nome, p.codice_sito
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
										
	raise info 'GRUPPO ISPETTIVO: %', gruppoispettivo;								
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from campioni c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where c.id = _idcampione 
								  union select 'dataInserimento' as nome, entered::text as descrizione from campioni where id = _idcampione
								  union select 'idCampione' as nome, id::text as descrizione from campioni where id = _idcampione 
								  ) b);
								  
	raise info 'CAMPI SERVIZIO: %', campiservizio;	
	matrici := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id
										from giornate_ispettive_matrici c
										join lookup_matrice_controlli l on l.code = c.id_matrice
										where c.id_giornata_ispettiva = idgiornataispettiva) t);
										
	raise info 'CAMPI MATRICI: %', matrici;	
	dativerbalecampione := (select json_object_agg(nome,descrizione) from (
															select 'coordinataX5' as nome, coordinata_x_c5 as descrizione
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'coordinataX4' as nome, coordinata_x_c4
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'coordinataY5' as nome, coordinata_y_c5
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione					
															union 
															select 'codiceIdentificativo1' as nome, codice_identificativo_c1
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'codiceIdentificativo2' as nome, codice_identificativo_c2
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union
															select 'codiceIdentificativo5' as nome, codice_identificativo_c5
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'codiceIdentificativo3' as nome, codice_identificativo_c3
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'codiceIdentificativo4' as nome, codice_identificativo_c4
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'coordinataX3' as nome, coordinata_x_c3
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'coordinataY4' as nome, coordinata_y_c4
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'coordinataX2' as nome, coordinata_x_c2
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione	
															union 
															select 'coordinataX1' as nome, coordinata_x_c1
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'coordinataY3' as nome, coordinata_y_c3
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'coordinataY2' as nome, coordinata_y_c2
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'coordinataY1' as nome, coordinata_y_c1
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'codiceIdentificativoVoc' as nome, codice_identificativo_voc
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'coordinataXVoc' as nome, coordinata_x_voc
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'coordinataYVoc' as nome, coordinata_y_voc
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'codiceIdentificativoMedioComposito' as nome, codice_identificativo_medio_composito
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'presenzaRifiuti' as nome, presenza_rifiuti::text
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'numCampioniElementari' as nome, num_campioni_elementari
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'tipoColturaDescrizione' as nome, prodotti_coltivati
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'tipoColturaCodice' as nome, particella_campionata
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'tipoColturaNote' as nome, prodotti_coltivati_note
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'altriPartecipanti' as nome, altri_partecipanti
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'datiProprietarioParticella' as nome, proprietario_particella
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union 
															select 'carabinieriForestali' as nome, carabinieri_forestali
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
															union
															select 'qualitaAltriPartecipanti' as nome, presente_al_campionamento_in_qualita_di
															from campionamento_suolo_particelle_dati_verbale where id_campione = _idcampione
														)a);
		
	raise info 'CAMPI DATI VERBALE: %', dativerbalecampione;	
	finale := (select unaccent(concat('{',
		(select concat_ws(' ', 
		'"Dati":', dati, 
		',"Anagrafica":', anagrafica, 
		',"Utente":',utente, 
		',"Laboratorio":', laboratorio,
		',"Motivo":', motivo,
		',"GruppoTecniciAddetti":', gruppoispettivo,
		',"CampiServizio":', campiServizio,
		',"DatiVerbaleCampione":', dativerbalecampione,
		',"Matrici":', matrici)),'}'))::json);
		
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$;

ALTER FUNCTION public.campionamento_particella_dettaglio_globale(integer)
    OWNER TO postgres;

	
--select * from campionamento_particella_dettaglio_globale(48)    
alter table campionamento_suolo_particelle_dati_verbale add column prodotti_coltivati_note text;




CREATE OR REPLACE FUNCTION public.campionamento_particella_lista_globale(
	_id_particella integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
	output json;
BEGIN
	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM 
				(select c.id as "idCampione", num_verbale as "numeroVerbale", c.data_prelievo as "dataPrelievo", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from campioni c  
										join access a on a.user_id = c.enteredby 
										join contact co on co.contact_id = a.contact_id
				 						join giornate_ispettive gi on gi.id = c.id_giornata_ispettiva
										where gi.riferimento_id =_id_particella and gi.riferimento_id_nome_tab='area_particelle'
										and c.trashed_date is null and gi.trashed_date is null
										order by c.data_prelievo desc) t);
	return output;
END;
$BODY$;

ALTER FUNCTION public.campionamento_particella_lista_globale(integer)
    OWNER TO postgres;
	
CREATE OR REPLACE FUNCTION public.campione_get_verbale_campionamento_suolo(
	_id_campione integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
	output json;
	outputcampione json;
BEGIN
	outputCampione := (select * from campionamento_particella_dettaglio_globale(_id_campione));
	output := '{"Campione" : ' || outputCampione || '}';

	return output;
	
END;
$BODY$;

ALTER FUNCTION public.campione_get_verbale_campionamento_suolo(integer)
    OWNER TO postgres;
    
alter table particelle rename to area_particelle;
alter table area_particelle add column id_padre integer;
alter table area_particelle add column id_sito text;
alter table area_particelle rename column comune to id_comune;
alter table area_particelle rename column provincia to id_provincia;

CREATE OR REPLACE FUNCTION public.insert_subparticella(
	_id_padre integer,
	_codice_sito text,
	_coordinate_x text,
	_coordinate_y text,
	_note text,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE 
	id_subparticella integer;
BEGIN	
	insert into area_particelle(codice_sito, coordinate_x, coordinate_y, note, id_padre, entered, entered_by) 
	values(_codice_sito,
	_coordinate_x,
	_coordinate_y,
	_note,
	_id_padre,
	now(),
	_id_utente) returning id into id_subparticella;

	return id_subparticella;
	      
END;
$BODY$;

ALTER FUNCTION public.insert_subparticella(integer, text, text, text, text, integer)
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_lista_subparticelle(_id_padre integer)
    RETURNS SETOF area_particelle
	LANGUAGE 'plpgsql'
	COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	
BEGIN 
	
	RETURN QUERY
		select * from area_particelle where trashed_date is null and id_padre = _id_padre;
END;
$BODY$;

ALTER FUNCTION public.get_lista_subparticelle(integer)
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_lista_aree(
	_codice_sito text DEFAULT NULL::text,
	_id_provincia integer DEFAULT '-1'::integer,
	_id_comune integer DEFAULT '-1'::integer)
    RETURNS TABLE(id integer, codice_sito text, id_comune integer, id_provincia integer, descrizione_comune text, descrizione_provincia text, foglio_catastale text, particella_catastale text, classe_rischio text, coordinate_x text, coordinate_y text, area text, note text, id_padre integer, id_sito text, entered timestamp without time zone, entered_by integer, modified timestamp without time zone, modified_by integer, trashed_date timestamp without time zone) 
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
		a.coordinate_x, a.coordinate_y, a.area,a.note, a.id_padre, a.id_sito,
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
    
    
CREATE OR REPLACE FUNCTION public.get_dettaglio_particella(_id integer)
    RETURNS table(id integer, codice_sito text, id_comune integer, id_provincia integer,
				  descrizione_comune text, descrizione_provincia text, 
				  foglio_catastale text, particella_catastale text, classe_rischio text, 
				  coordinate_x text, coordinate_y text, area text, note text, id_padre integer, id_sito text,
				  entered timestamp, entered_by integer, modified timestamp, modified_by integer, trashed_date timestamp)
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
		a.coordinate_x, a.coordinate_y, a.area,a.note, a.id_padre, a.id_sito,
		a.entered, a.entered_by, a.modified, a.modified_by, a.trashed_date
		from area_particelle a
		left join comuni1 c on c.id = a.id_comune
		left join lookup_province l on l.code= c.cod_provincia::integer
		where a.trashed_date is null and a.id = _id;
END;
$BODY$;

ALTER FUNCTION public.get_dettaglio_particella(integer)
    OWNER TO postgres;
	

	--select * from get_dettaglio_particella(17)
 
 CREATE OR REPLACE FUNCTION public.get_motivi_campionamento_particella(_campioni_area boolean default null::boolean)
    RETURNS table (id integer, descrizione text)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE  
BEGIN 
	return query select code, description from lookup_campionamento_particella where enabled and 
	(_campioni_area is null or _campioni_area = default_item)
	order by description;


END 
$BODY$;

ALTER FUNCTION public.get_motivi_campionamento_particella(boolean)
    OWNER TO postgres;

 CREATE OR REPLACE FUNCTION public.campione_get_verbale_mancato_campionamento_suolo(
	_id_area integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
	output json;
	anagrafica json;
	subparticelle json;
BEGIN
	
	anagrafica := (select json_object_agg(nome,descrizione) from (
														select 'riferimentoId' as nome, a.id::text as descrizione
														from area_particelle a
														where a.trashed_date is null and a.id = _id_area
														union
														select 'provincia' as nome, lp.description
														from area_particelle a
														join comuni1 c on c.id=a.id_comune
														join lookup_province lp on lp.code=c.cod_provincia::integer
														where a.trashed_date is null and a.id = _id_area
														union
														select 'comune' as nome, c.nome
														from area_particelle a
														join comuni1 c on c.id=a.id_comune
														where a.trashed_date is null and a.id = _id_area
							        				) a);
	subparticelle :=(SELECT array_to_json(array_agg(row_to_json(t))) FROM (
										select distinct 
										p.codice_sito as "codiceSito" 
										from area_particelle p where p.trashed_date is null and 
							            p.id_padre= _id_area
										) t);
										
	output := '{"Anagrafica" : ' || anagrafica || ', "Subparticelle" : '|| subparticelle ||' }';

	return output;
	
END;
$BODY$;

ALTER FUNCTION public.campione_get_verbale_campionamento_suolo(integer)
    OWNER TO postgres;

	
----------- svuota tutto ------------
--delete from area_particelle;
--delete from campionamento_suolo_particelle_dati_verbale;
--delete from campionamento_particelle_log_json;
--delete from giornate_ispettive where riferimento_id_nome_tab='area_particelle';
--delete from fascicoli_ispettivi where riferimento_id_nome_tab='area_particelle';

CREATE OR REPLACE VIEW public.particelle_non_campionate
 AS
 select 
		 a.id as id_particella, a.codice_sito as codice_sito_particella, a.id_padre as id_area_appartenenza, 
		 b.codice_sito as codice_sito_area
		from area_particelle a
		join area_particelle b on b.id =a.id_padre and b.trashed_date is null
		where a.trashed_date is null and a.id_padre > 0 and a.id not in (
		select riferimento_id from giornate_ispettive where trashed_date is null and riferimento_id_nome_tab = 'area_particelle')
		and a.id_padre > 0;
ALTER TABLE public.particelle_non_campionate
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_json_aree_non_campionate()
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
	output json;
	
BEGIN

	
	output := ((SELECT array_to_json(array_agg(row_to_json(t))) 
										 FROM (
											 	select distinct codice_sito_area as "codiceSito", id_area_appartenenza as "riferimentoId" 
											 	from particelle_non_campionate) t));
										
	return output;
	
END;
$BODY$;

ALTER FUNCTION public.get_json_aree_non_campionate()
    OWNER TO postgres;

select * from get_json_aree_non_campionate()
			   
CREATE OR REPLACE FUNCTION public.get_json_subparticelle_non_campionate(IN _id_area integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
	output json;
	
BEGIN

	
	output := (SELECT json_agg(json_build_object('codiceSito', codice_sito_particella, 'riferimentoId', id_particella))
			   FROM particelle_non_campionate  where id_area_appartenenza = _id_area);
										
	return output;
	
END;
$BODY$;

ALTER FUNCTION public.get_json_subparticelle_non_campionate(integer)
    OWNER TO postgres;
    
    -- FUNCTION: public.get_matrici(text, text)

-- DROP FUNCTION IF EXISTS public.get_matrici(text, text);

CREATE OR REPLACE FUNCTION public.get_matrici(
	_lista_id text DEFAULT NULL::integer,
	_descrizione text DEFAULT ''::text)
    RETURNS TABLE(code integer, matrice text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
BEGIN
	
RETURN QUERY
	select t.code, t.description::text
	from lookup_matrice_controlli t 
	where t.enabled and
    (_lista_id is null or t.code in (SELECT unnest(string_to_array(_lista_id, ',')::int[]))) 
	and
	(_descrizione = '' or t.description = '')
	order by t.description;
END;
$BODY$;

ALTER FUNCTION public.get_matrici(text, text)
    OWNER TO postgres;
insert into lookup_matrice_controlli(code, description, short_description, level,enabled) values(10,'Suolo','Suolo', 0, true)