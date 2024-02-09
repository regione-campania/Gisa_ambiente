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


  
CREATE OR REPLACE FUNCTION public.non_conformita_insert_globale(IN _json_dati json)
  RETURNS integer AS
$BODY$	
DECLARE
	daticu json; 
	utente json;
	motivazione json;
	linea json;
	dati json;
	
	idnc integer;
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

	motivazione :=  _json_dati ->'TipoVerifica';
	RAISE INFO 'json motivazione %',motivazione;

	linea :=  _json_dati ->'Linea';
	RAISE INFO 'json TipiVerifica %',linea;
	
	-- STEP 0: INSERIAMO IL RECORD JSON PER LOG
	INSERT INTO cu_log_json(enteredby, json_cu) values(idutente,_json_dati);
	
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: INSERIAMO IL RECORD IN NC
	idnc := (SELECT * from public.non_conformita_insert(dati, idutente));

	-- STEP 4: INSERIAMO GLI ALTRI DATI DELLA NC
	update non_conformita set id_linea = (linea ->> 'id')::integer, id_tipo_verifica = (motivazione ->> 'id')::integer, id_controllo = (daticu ->> 'idControllo')::integer  where id = idnc;
	
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
  
  

CREATE OR REPLACE FUNCTION public.non_conformita_dettaglio_globale(IN _idnc integer)
  RETURNS json AS
$BODY$	
DECLARE
	campiservizio json;
	motivazione json;
	finale json;
	utente json;
	linea json;
	dati json;
	daticu json;
	
	id_controllo integer;
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

	id_controllo := (select n.id_controllo from non_conformita n where n.id = _idnc);
	codicelinea := (select l.codice_linea from linee_attivita_controlli_ufficiali l where   l.id_controllo_ufficiale  = id_controllo and l.trashed_date is null );

	linea := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, path_descrizione::text as descrizione from ml8_linee_attivita_nuove_materializzata  where codice= codicelinea
								 union
								select 'id' as nome, id_linea_attivita::text as descrizione 
								from linee_attivita_controlli_ufficiali  where trashed_date is null and id_controllo_ufficiale = id_controllo) a);				             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from non_conformita  where id = _idnc) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from non_conformita where id = _idnc) a);	

	daticu := (select json_object_agg(nome,descrizione) from (select 'idControllo' as nome, n.id_controllo::text as descrizione from non_conformita n where n.id = _idnc
							               union select 'dipartimento' as nome, l.description::text  
							                     from controlli_ufficiali cu 
							                     join non_conformita c on c.id_controllo = cu.id
							                     join lookup_site_id l on l.code = cu.id_dipartimento
							               union select 'ragioneSociale' as nome, r.ragione_sociale as descrizione
							                     from controlli_ufficiali cu 
							                     join non_conformita c on c.id_controllo = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab) a);	     

										
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
		(select concat_ws(' ', '"Dati":', dati, ',"DatiCU":', daticu, 
		--',"NumeroVerbale":', numeroverbale, 
		',"Utente":',utente, 
		',"Linea":', linea,
		',"CampiServizio":', campiServizio,
		',"TipoVerifica":', motivazione)),'}'))::json);
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$
   LANGUAGE plpgsql  
  COST 100;
  
  CREATE OR REPLACE FUNCTION public.non_conformita_lista_globale(IN _id_controllo integer)
   RETURNS json  AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select id as "idNonConformita", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from non_conformita c  
										join access a on a.user_id = c.enteredby 
										join contact co on co.contact_id = a.contact_id
										where c.id_controllo = _id_controllo 
									) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql
  COST 100;
