CREATE TABLE public.fascicoli
(
  id serial,
  numero text,
  data_inizio timestamp without time zone,
  entered timestamp default current_timestamp,
  enteredby integer,
  modified timestamp default current_timestamp,
  modifiedby integer,
  trashed_date timestamp,
  riferimento_id integer,
  riferimento_id_nome_tab text,
  note text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.fascicoli
  OWNER TO postgres;

  CREATE OR REPLACE FUNCTION public.fascicoli_lista_globale(IN _riferimento_id integer, _riferimento_id_nome_tab text)
   RETURNS json  AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select f.id as "idFascicolo", f.numero as "numero", f.data_inizio as "dataInizio", f.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from fascicoli f 
										join access a on a.user_id = f.enteredby 
										join contact co on co.contact_id = a.contact_id
										where f.riferimento_id = _riferimento_id and f.riferimento_id_nome_tab = _riferimento_id_nome_tab
										order by f.data_inizio desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql
  COST 100;

  


CREATE OR REPLACE FUNCTION public.fascicolo_dettaglio_globale(_idfascicolo integer)
  RETURNS json AS
$BODY$	
DECLARE
	
	campiservizio json;
	anagrafica json;
	fascicolo json;
	dati json;
	utente json;
	datifascicolo json;
	finale json;
	
	rifid integer;
	rifnometab text;
BEGIN

	rifid := (select riferimento_id from fascicoli  where id = _idfascicolo);
	rifnometab := (select c.riferimento_id_nome_tab from fascicoli c where id = _idfascicolo);
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from fascicoli c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where id = _idfascicolo 
								  union select 'dataInserimento' as nome, entered::text as descrizione from fascicoli where id = _idfascicolo
								  union select 'idFascicolo' as nome, id::text as descrizione from fascicoli where id = _idfascicolo
								  ) b);

	anagrafica:= (select json_object_agg(nome,descrizione) from (select 'partitaIva' as nome, trim(partita_iva) as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab
								  union select 'riferimentoId' as nome,  rifid::text
								  union select 'riferimentoIdNomeTab' as nome,  rifnometab::text 
								  union select 'ragioneSociale' as nome, ragione_sociale as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab) c);

	datifascicolo := (select json_object_agg(nome,descrizione) from (select 'numero' as nome, numero as descrizione from fascicoli  where id = _idfascicolo
								  union select 'dataInizio' as nome,  data_inizio::text from fascicoli where id = _idfascicolo 
								  ) b);

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, enteredby as descrizione from fascicoli where id = _idfascicolo) d); 

	finale := (select unaccent(concat('{',
	(select concat_ws(' ','"Dati":', datifascicolo, ',"Anagrafica":', anagrafica, ',"Utente":',utente, 
	',"CampiServizio":', campiServizio)),'}'))::json);
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicolo_dettaglio_globale(integer)
  OWNER TO postgres;



  
CREATE OR REPLACE FUNCTION public.fascicolo_insert_globale(IN _json_dati json)
  RETURNS integer AS
$BODY$	
DECLARE
	anagrafica json; 
	utenti json;
	datigenerici json; -- qui dovrebbero essere incluse anche le note
	
	idfascicolo integer;
	idutente integer;
	output integer;
	
BEGIN
	 -- mi ricavo i singoli oggetti JSON per blocchi
	anagrafica :=  _json_dati ->'Anagrafica'; 
	RAISE INFO 'json anagrafica %',anagrafica;

	utenti :=  _json_dati ->'Utente';
	RAISE INFO 'json utenti %',utenti;
	
	idutente := utenti -> 'userId';
	RAISE INFO 'idutente %',idutente;

	datigenerici := _json_dati ->'Dati';
	RAISE INFO 'json datigenerici %',datigenerici;

	-- STEP 0: INSERIAMO IL RECORD JSON PER LOGO
	INSERT INTO cu_log_json(enteredby, json_cu) values(idutente,_json_dati);
	
	-- chiamo la dbi per il fascicolo
	idfascicolo := (SELECT * from public.fascicolo_insert(anagrafica, idutente));
	
	-- STEP 3: INSERIAMO I DATI DEL CU + linee
	update fascicoli set 
	data_inizio  = (datigenerici ->> 'dataInizio')::timestamp without time zone, 
	numero =  (datigenerici ->> 'numero')::text
        where id = idfascicolo;
	

    	 return idfascicolo;
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.fascicolo_insert_globale(json)
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.fascicolo_insert(IN _json_anagrafica json, IN _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	riferimento_id integer;
	riferimento_tab text;
	resultid integer;
BEGIN
	  -- recupero il riferimento anagrafico
	  riferimento_id := _json_anagrafica ->> 'riferimentoId' ;
	  riferimento_tab := _json_anagrafica ->> 'riferimentoIdNomeTab';

	INSERT INTO fascicoli (enteredby, riferimento_id, riferimento_id_nome_tab) values (_idutente,riferimento_id,riferimento_tab)
	returning id into resultid;

	 return resultid;
	 		
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.fascicolo_insert(json, integer)
  OWNER TO postgres;
  
  -- fascicolo
  
  
  
CREATE TABLE public.fascicoli
(
  id serial,
  numero text,
  data_inizio timestamp without time zone,
  entered timestamp default current_timestamp,
  enteredby integer,
  modified timestamp default current_timestamp,
  modifiedby integer,
  trashed_date timestamp,
  riferimento_id integer,
  riferimento_id_nome_tab text,
  note text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.fascicoli
  OWNER TO postgres;

  CREATE OR REPLACE FUNCTION public.fascicoli_lista_globale(IN _riferimento_id integer, _riferimento_id_nome_tab text)
   RETURNS json  AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select f.id as "idFascicolo", f.numero as "numero", f.data_inizio as "dataInizio", f.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from fascicoli f 
										join access a on a.user_id = f.enteredby 
										join contact co on co.contact_id = a.contact_id
										where f.riferimento_id = _riferimento_id and f.riferimento_id_nome_tab = _riferimento_id_nome_tab
										order by f.data_inizio desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql
  COST 100;

  


CREATE OR REPLACE FUNCTION public.fascicolo_dettaglio_globale(_idfascicolo integer)
  RETURNS json AS
$BODY$	
DECLARE
	
	campiservizio json;
	anagrafica json;
	fascicolo json;
	dati json;
	utente json;
	datifascicolo json;
	finale json;
	
	rifid integer;
	rifnometab text;
BEGIN

	rifid := (select riferimento_id from fascicoli  where id = _idfascicolo);
	rifnometab := (select c.riferimento_id_nome_tab from fascicoli c where id = _idfascicolo);
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from fascicoli c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where id = _idfascicolo 
								  union select 'dataInserimento' as nome, entered::text as descrizione from fascicoli where id = _idfascicolo
								  union select 'idFascicolo' as nome, id::text as descrizione from fascicoli where id = _idfascicolo
								  ) b);

	anagrafica:= (select json_object_agg(nome,descrizione) from (select 'partitaIva' as nome, trim(partita_iva) as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab
								  union select 'riferimentoId' as nome,  rifid::text
								  union select 'riferimentoIdNomeTab' as nome,  rifnometab::text 
								  union select 'ragioneSociale' as nome, ragione_sociale as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab) c);

	datifascicolo := (select json_object_agg(nome,descrizione) from (select 'numero' as nome, numero as descrizione from fascicoli  where id = _idfascicolo
								  union select 'dataInizio' as nome,  data_inizio::text from fascicoli where id = _idfascicolo 
								  ) b);

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, enteredby as descrizione from fascicoli where id = _idfascicolo) d); 

	finale := (select unaccent(concat('{',
	(select concat_ws(' ','"Dati":', datifascicolo, ',"Anagrafica":', anagrafica, ',"Utente":',utente, 
	',"CampiServizio":', campiServizio)),'}'))::json);
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicolo_dettaglio_globale(integer)
  OWNER TO postgres;



  
CREATE OR REPLACE FUNCTION public.fascicolo_insert_globale(IN _json_dati json)
  RETURNS integer AS
$BODY$	
DECLARE
	anagrafica json; 
	utenti json;
	datigenerici json; -- qui dovrebbero essere incluse anche le note
	
	idfascicolo integer;
	idutente integer;
	output integer;
	
BEGIN
	 -- mi ricavo i singoli oggetti JSON per blocchi
	anagrafica :=  _json_dati ->'Anagrafica'; 
	RAISE INFO 'json anagrafica %',anagrafica;

	utenti :=  _json_dati ->'Utente';
	RAISE INFO 'json utenti %',utenti;
	
	idutente := utenti -> 'userId';
	RAISE INFO 'idutente %',idutente;

	datigenerici := _json_dati ->'Dati';
	RAISE INFO 'json datigenerici %',datigenerici;

	-- STEP 0: INSERIAMO IL RECORD JSON PER LOGO
	INSERT INTO cu_log_json(enteredby, json_cu) values(idutente,_json_dati);
	
	-- chiamo la dbi per il fascicolo
	idfascicolo := (SELECT * from public.fascicolo_insert(anagrafica, idutente));
	
	-- STEP 3: INSERIAMO I DATI DEL CU + linee
	update fascicoli set 
	data_inizio  = (datigenerici ->> 'dataInizio')::timestamp without time zone, 
	numero =  (datigenerici ->> 'numero')::text
        where id = idfascicolo;
	

    	 return idfascicolo;
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.fascicolo_insert_globale(json)
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.fascicolo_insert(IN _json_anagrafica json, IN _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	riferimento_id integer;
	riferimento_tab text;
	resultid integer;
BEGIN
	  -- recupero il riferimento anagrafico
	  riferimento_id := _json_anagrafica ->> 'riferimentoId' ;
	  riferimento_tab := _json_anagrafica ->> 'riferimentoIdNomeTab';

	INSERT INTO fascicoli (enteredby, riferimento_id, riferimento_id_nome_tab) values (_idutente,riferimento_id,riferimento_tab)
	returning id into resultid;

	 return resultid;
	 		
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.fascicolo_insert(json, integer)
  OWNER TO postgres;

