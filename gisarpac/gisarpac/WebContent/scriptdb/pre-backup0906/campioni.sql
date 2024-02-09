delete from lookup_Destinazione_campione where code=1;
update lookup_Destinazione_campione set code =1, description='ARPAC' where code=2;
-- tabella minimal campione
CREATE TABLE public.campioni
(
  id serial,
  id_controllo integer,
  data_prelievo timestamp without time zone,
  data_chiusura timestamp without time zone,
  esito text,
  num_verbale text,
  id_laboratorio integer,
  id_motivazione integer,
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
ALTER TABLE public.campioni
  OWNER TO postgres;
  
  
  -- insert campioni
CREATE OR REPLACE FUNCTION public.campione_insert(IN _json_anagrafica json, IN _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	
	resultid integer;
BEGIN
	 
	INSERT INTO campioni (enteredby, note, data_prelievo) values (_idutente,(_json_anagrafica ->> 'note')::text,(_json_anagrafica ->> 'dataPrelievo')::timestamp without time zone)
	returning id into resultid;

	  return resultid;
	 		
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.campione_insert(json, integer)
  OWNER TO postgres;

  CREATE OR REPLACE FUNCTION public.campione_insert_matrice(IN _json_dati json, IN _idcampione integer)
  RETURNS integer AS
$BODY$	
DECLARE
	
	resultid integer;
BEGIN
	INSERT INTO matrici_campioni (id_campione, id_matrice, cammino) values (_idcampione,(_json_dati ->> 'id')::integer,(_json_dati ->> 'nome')::text)
	returning id into resultid;

	  return resultid;
	 		
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.campione_insert_matrice(json, integer)
  OWNER TO postgres;
  
CREATE OR REPLACE FUNCTION public.campione_insert_analiti(IN _json_dati json, _idcampione integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json;
BEGIN
	FOR i IN SELECT * FROM json_array_elements(_json_dati)  
		LOOP
			RAISE NOTICE 'id %', i->>'id';
			INSERT INTO analiti_campioni (id_campione, analiti_id, cammino) values (_idcampione, (i ->> 'id')::integer,(i ->> 'nome')::text);
		END LOOP;		

	 return 1;

END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.campione_insert_analiti(json, integer)
  OWNER TO postgres;
  
  ALTER TABLE public.analiti_campioni DROP CONSTRAINT analiti_campioni_id_campione_fkey;
ALTER TABLE public.matrici_campioni DROP CONSTRAINT matrici_campioni_id_campione_fkey;


CREATE OR REPLACE FUNCTION public.campione_insert_globale(IN _json_dati json)
  RETURNS integer AS
$BODY$	
DECLARE
	daticu json; 
	utente json;
	motivazione json;
	laboratorio json;
	numeroverbale json;
	matrice json;
	analiti json;
	dati json;
	
	idcampione integer;
	idutente integer;
	output integer;
	
BEGIN
	 -- mi ricavo i singoli oggetti JSON per blocchi
	daticu :=  _json_dati ->'DatiCU';
	RAISE INFO 'json daticu %',daticu;

	dati :=  _json_dati ->'Dati'; 
	RAISE INFO 'json dati %',dati;

	utente :=  _json_dati ->'Utente';
	RAISE INFO 'json utenti %',utente;
	
	idutente := utente -> 'userId';
	RAISE INFO 'idutente %',idutente;

	motivazione :=  _json_dati ->'Motivazione';
	RAISE INFO 'json motivazione %',motivazione;

	laboratorio :=  _json_dati ->'Laboratorio';
	RAISE INFO 'json TipiVerifica %',laboratorio;

	numeroverbale :=  _json_dati ->'NumeroVerbale';
	RAISE INFO 'json numeroverbale %',numeroverbale;
       
        matrice :=  _json_dati ->'Matrice';
	RAISE INFO 'json matrice %',matrice;

	analiti :=  _json_dati ->'Analiti';
	RAISE INFO 'json analiti %',analiti;
	
	-- STEP 0: INSERIAMO IL RECORD JSON PER LOG
	INSERT INTO cu_log_json(enteredby, json_cu) values(idutente,_json_dati);
	
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: INSERIAMO IL RECORD IN CAMPIONI
	idcampione := (SELECT * from public.campione_insert(dati, idutente));
	-- STEP 2: INSERIAMO LA MATRICE
	output := (SELECT * from public.campione_insert_matrice(matrice, idcampione));
	-- STEP 3: INSERIAMO GLI ANALITI
	output := (SELECT * from public.campione_insert_analiti(analiti, idcampione));

	-- STEP 4: INSERIAMO GLI ALTRI DATI DEL CAMPIONE
	update campioni set id_laboratorio= (laboratorio->>'id')::int, id_motivazione = (motivazione ->> 'id')::integer, num_verbale='DA GENERARE',
	id_controllo = (daticu ->> 'idControllo')::integer  where id = idcampione;
	
    	 return idcampione;
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.campione_insert_globale(json)
  OWNER TO postgres;
  
  
CREATE OR REPLACE FUNCTION public.campione_dettaglio_globale(IN _idcampione integer)
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
							               union select 'ragioneSociale' as nome, r.ragione_sociale as descrizione
							                     from controlli_ufficiali cu 
							                     join campioni c on c.id_controllo = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab) a);	     
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
   LANGUAGE plpgsql  
  COST 100;

  
CREATE OR REPLACE FUNCTION public.campioni_lista_globale(IN _id_controllo integer)
   RETURNS json  AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select id as "idCampione", num_verbale as "NumVerbale", c.data_prelievo as "dataPrelievo", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from campioni c  
										join access a on a.user_id = c.enteredby 
										join contact co on co.contact_id = a.contact_id
										where c.id_controllo = _id_controllo 
										order by c.data_prelievo desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql
  COST 100;
  
  
update lookup_destinazione_campione set description = 'Area Analitica AV' where code=1;
insert into lookup_destinazione_campione(code, description) values (2, 'Area Analitica BN');
insert into lookup_destinazione_campione(code, description) values (3, 'Area Analitica CE');
insert into lookup_destinazione_campione(code, description) values (4, 'Area Analitica NA');
insert into lookup_destinazione_campione(code, description) values (5, 'Area Analitica SA');
insert into lookup_destinazione_campione(code, description) values (6, 'U.O. Centro Siti contaminati');