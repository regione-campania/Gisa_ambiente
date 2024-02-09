DROP FUNCTION public.search_globale_fascicolo(integer);

CREATE OR REPLACE FUNCTION public.search_globale_fascicolo_ispettivo(IN _id_fascicolo_ispettivo integer)
  RETURNS TABLE(id_fascicolo_ispettivo integer, id_giornata_ispettiva integer, num_fascicolo text, ragione_sociale text, data_inizio text, dipartimento text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
    
select distinct f.id, -1, f.numero, s.ragione_sociale::text, to_char(f.data_inizio,'dd/mm/yyyy'), ''
from fascicoli_ispettivi f 
join ricerche_anagrafiche_old_materializzata s on s.riferimento_id = f.riferimento_id and s.riferimento_id_nome_tab = f.riferimento_id_nome_tab
where f.id = _id_fascicolo_ispettivo and f.trashed_date is null;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


 DROP FUNCTION public.search_globale_giornata_ispettiva(integer);

CREATE OR REPLACE FUNCTION public.search_globale_giornata_ispettiva(IN _id_giornata_ispettiva integer)
  RETURNS TABLE(id_fascicolo_ispettivo integer, id_giornata_ispettiva integer, num_fascicolo text, ragione_sociale text, data_inizio text, dipartimento text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
    
select distinct c.id_fascicolo_ispettivo, c.id, f.numero, s.ragione_sociale::text, to_char(c.data_inizio,'dd/mm/yyyy'), l.description::text
from giornate_ispettive c
join fascicoli_ispettivi f on f.id = c.id_fascicolo_ispettivo and f.trashed_date is null
join ricerche_anagrafiche_old_materializzata s on s.riferimento_id = c.riferimento_id and s.riferimento_id_nome_tab = c.riferimento_id_nome_tab
join lookup_site_id l on l.code = c.id_dipartimento
where c.id = _id_giornata_ispettiva and c.trashed_date is null;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
  
DROP FUNCTION public.campione_get_verbale_c4(integer);

CREATE OR REPLACE FUNCTION public.campione_get_verbale_c4(_id_campione integer)
  RETURNS json AS
$BODY$
DECLARE
	output json;
	idGiornataIspettiva integer;
	outputGiornataIspettiva json;
	outputCampione json;
BEGIN

	outputCampione := (select * from public.campione_dettaglio_globale(_id_campione));

	idGiornataIspettiva := ((outputCampione->>'DatiGiornataIspettiva')::json->>'idGiornataIspettiva')::integer;
	
	outputGiornataIspettiva := (select * from public.giornata_ispettiva_dettaglio_globale(idGiornataIspettiva));

	output := '{"GiornataIspettiva" : ' || outputGiornataIspettiva ||', "Campione" : ' || outputCampione || '}';

	return output;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_get_verbale_c4(integer)
  OWNER TO postgres;
  
DROP FUNCTION public.get_chiamata_ws_sicra_inserisci_protocollo_e_anagrafiche(integer, text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.get_chiamata_ws_sicra_inserisci_protocollo_e_anagrafiche(
    _id_giornata_ispettiva integer,
    _file text,
    _oggetto text,
    _nomeallegato text,
    _tipofile text,
    _tipoverbale text)
  RETURNS text AS
$BODY$
DECLARE
	ret text;
	_cognomenome text;
	_commento text;
BEGIN

_cognomenome := 'GISA';
_commento := 'Documento caricato per Verbale: '||_tipoverbale||' su Giornata Ispettiva: '||_id_giornata_ispettiva;

select 
concat('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
 <soapenv:Header/>
   <soapenv:Body>
 <tem:InserisciProtocolloEAnagrafiche>
 <tem:ProtoIn>
   <tem:TipoDocumento>', _tipoverbale, '</tem:TipoDocumento>
   <tem:Oggetto>', _oggetto, '</tem:Oggetto>
   <tem:Origine>A</tem:Origine>
   <tem:MittentiDestinatari>
   <tem:item>
   <tem:CognomeNome>', _cognomenome, '</tem:CognomeNome>
   </tem:item>
   </tem:MittentiDestinatari>
   <tem:AggiornaAnagrafiche>N</tem:AggiornaAnagrafiche>
   <tem:Allegati>
   <tem:item>
   <tem:TipoFile>', _tipofile, '</tem:TipoFile>
   <tem:Image>', _file, '</tem:Image>
   <tem:Commento>', _commento, '</tem:Commento>
   <tem:NomeAllegato>', _nomeallegato, '</tem:NomeAllegato>
   </tem:item>
   </tem:Allegati>
   </tem:ProtoIn>
   </tem:InserisciProtocolloEAnagrafiche>
   </soapenv:Body>
</soapenv:Envelope>') into ret;


 RETURN ret;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
ALTER FUNCTION public.get_chiamata_ws_sicra_inserisci_protocollo_e_anagrafiche(integer, text, text, text, text, text)
  OWNER TO postgres;

update comuni1 set codiceistatasl = '204' where codiceistatasl ='205';
update comuni1 set codiceistatasl = '204' where codiceistatasl ='206';
alter table controlli_ufficiali_emissioni_in_atmosfera_camini  RENAME TO giornate_ispettive_emissioni_in_atmosfera_camini;
alter table controlli_ufficiali RENAME TO giornate_ispettive;
alter table controlli_ufficiali_esami   RENAME TO giornate_ispettive_esami;
alter table controlli_ufficiali_matrici   RENAME TO giornate_ispettive_matrici;
alter table controlli_ufficiali_motivi   RENAME TO giornate_ispettive_motivi;
alter table controlli_ufficiali_motivi_ispezione     RENAME TO giornate_ispettive_motivi_ispezione;
alter table controlli_ufficiali_tipi_verifica  RENAME TO giornate_ispettive_tipi_verifica;
alter table controlli_ufficiali_verbali_protocolli  RENAME TO giornate_ispettive_verbali_protocolli;
alter table linee_attivita_controlli_ufficiali   RENAME TO linee_attivita_giornate_ispettive;
alter table controlli_per_conto_di  rename to giornate_ispettive_per_conto_di;
alter table controlli_fase_lavorazione  RENAME TO giornate_ispettive_fase_lavorazione;
alter table fascicoli  RENAME TO fascicoli_ispettivi;
alter table fascicoli_protocolli  RENAME TO fascicoli_ispettivi_protocolli;
alter table cu_nucleo   RENAME TO giornata_ispettiva_gruppo_ispettivo;
alter table public.cu_log_json rename to giornate_ispettive_log_json;
alter FUNCTION cu_dettaglio_globale(integer) rename to giornate_ispettive_dettaglio_globale;
alter FUNCTION public.cu_get_verbale_a6(integer) rename to giornate_ispettive_get_verbale_a6;
alter FUNCTION public.cu_insert_anagrafica(json, integer) rename to giornate_ispettive_insert_anagrafica;
alter FUNCTION public.cu_insert_emissioni_in_atmosfera_camini(json, integer, integer, integer, text) rename to giornate_ispettive_insert_emissioni_in_atmosfera_camini;
alter FUNCTION public.cu_insert_esami(json, integer, integer) rename to giornate_ispettive_insert_esami;
alter FUNCTION public.cu_insert_fasi_lavorazione(json, integer, integer) rename to giornate_ispettive_insert_fasi_lavorazione;
alter FUNCTION public.cu_insert_globale(json) rename to giornate_ispettive_insert_globale;
alter FUNCTION public.cu_insert_linee(json, integer, text) rename to giornate_ispettive_insert_linee;
alter FUNCTION public.cu_insert_matrici(json, integer, integer) rename to giornate_ispettive_insert_matrici;
alter FUNCTION public.cu_insert_motivi(json, integer, integer) rename to giornate_ispettive_insert_motivi;
alter FUNCTION public.cu_insert_nucleo(json, integer) rename to giornate_ispettive_insert_gruppo_ispettivo;
alter FUNCTION public.cu_insert_percontodi(json, integer, integer) rename to giornate_ispettive_insert_percontodi;
alter FUNCTION public.cu_insert_tecnica(json, integer) rename to giornate_ispettive_insert_tecnica;
alter FUNCTION public.cu_insert_tipiverifica(json, integer, integer) rename to giornate_ispettive_insert_tipiverifica;
alter FUNCTION public.cu_lista_globale(integer) rename to giornate_ispettive_lista_globale;
alter FUNCTION public.cu_lista_globale(integer, text) rename to giornate_ispettive_lista_globale;
alter FUNCTION public.fascicoli_lista_globale(integer, text) rename to fascicoli_ispettivi_lista_globale;
alter FUNCTION public.fascicolo_close(integer, text, integer) rename to fascicolo_ispettivo_close;
alter FUNCTION fascicolo_close(integer, text, integer, integer, integer) rename to fascicolo_ispettivo_close;
alter FUNCTION public.fascicolo_dettaglio_globale(integer) rename to fascicolo_ispettivo_dettaglio_globale;
alter FUNCTION public.fascicolo_insert(json, integer) rename to fascicolo_ispettivo_insert;
alter FUNCTION public.fascicolo_insert_globale(json) rename to fascicolo_ispettivo_insert_globale;
alter FUNCTION public.get_controlli_ufficiali_protocolli(integer, text) rename to get_giornate_ispettive_protocolli;
alter FUNCTION public.get_fascicoli_protocolli(integer) rename to get_fascicoli_ispettivi_protocolli;
alter FUNCTION public.get_nucleo_componenti(integer, integer, integer, text) rename to get_gruppo_ispettivo_componenti;

-- rename column
alter table giornate_ispettive rename id_fascicolo TO id_fascicolo_ispettivo;
alter table fascicoli_ispettivi_protocolli rename id_fascicolo TO id_fascicolo_ispettivo;
alter table giornate_ispettive_verbali_protocolli rename id_controllo_ufficiale TO id_giornata_ispettiva;
alter table linee_attivita_giornate_ispettive  rename id_controllo_ufficiale TO id_giornata_ispettiva;
alter table giornata_ispettiva_gruppo_ispettivo   rename id_controllo_ufficiale TO id_giornata_ispettiva;
 alter table giornate_ispettive_esami  rename id_controllo TO id_giornata_ispettiva;
alter table giornate_ispettive_emissioni_in_atmosfera_camini   rename id_controllo TO id_giornata_ispettiva;
alter table giornate_ispettive_fase_lavorazione  rename id_controllo TO id_giornata_ispettiva;
alter table giornate_ispettive_matrici  rename id_controllo TO id_giornata_ispettiva;
alter table giornate_ispettive_motivi rename id_controllo TO id_giornata_ispettiva;
alter table giornate_ispettive_per_conto_di rename id_controllo TO id_giornata_ispettiva;
alter table giornate_ispettive_tipi_verifica  rename id_controllo TO id_giornata_ispettiva;
alter table non_conformita rename id_controllo  to id_giornata_ispettiva;
alter table campioni rename id_controllo  to id_giornata_ispettiva;

DROP FUNCTION public.aggiorna_controlli_ufficiali_verbali_protocolli(integer, text, integer, integer, integer, text, text, text, text, integer);

CREATE OR REPLACE FUNCTION public.aggiorna_giornate_ispettive_verbali_protocolli(
    _id_giornata_ispettiva integer,
    _tipoverbale text,
    _id_documento integer,
    _numero_protocollo integer,
    _anno_protocollo integer,
    _data_protocollo text,
    _esito text,
    _faultstring text,
    _base64file text,
    user_id integer)
  RETURNS text AS
$BODY$
DECLARE
	
BEGIN

insert into giornate_ispettive_verbali_protocolli (id_giornata_ispettiva, tipo_verbale, id_documento, numero_protocollo, anno_protocollo, data_protocollo, esito, fault_string, base64file, enteredby) values (
_id_giornata_ispettiva, _tipoverbale, _id_documento, _numero_protocollo, _anno_protocollo, _data_protocollo, _esito, _faultstring, _base64file, user_id);


 RETURN 'OK';
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
  
CREATE OR REPLACE FUNCTION public.fascicoli_ispettivi_lista_globale(
    _riferimento_id integer,
    _riferimento_id_nome_tab text)
  RETURNS json AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select f.id as "idFascicoloIspettivo", f.numero as "numero", f.data_inizio as "dataInizio", f.entered as "dataInserimento", concat_ws(' ', co.namefirst, 
	                                                                  co.namelast)::text as "utenteInserimento", ls.description as "statoFascicolo", f.data_chiusura as "dataChiusura" 
										from fascicoli_ispettivi f 
										join lookup_stato_fascicolo ls on ls.code = f.stato
										join access a on a.user_id = f.enteredby 
										join contact co on co.contact_id = a.contact_id
										where f.riferimento_id = _riferimento_id and f.riferimento_id_nome_tab = _riferimento_id_nome_tab and f.trashed_date is null
										order by f.data_inizio desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicoli_ispettivi_lista_globale(integer, text)
  OWNER TO postgres;


DROP FUNCTION fascicolo_ispettivo_close(integer,text,integer,integer,integer);
CREATE OR REPLACE FUNCTION public.fascicolo_ispettivo_close(
    _id_fascicolo_ispettivo integer,
    _data_chiusura text,
    _anno_protocollo integer,
    _numero_protocollo integer,
    _id_utente integer)
  RETURNS text AS
$BODY$
DECLARE
	id_fascicolo_ispettivo_protocollo integer;
BEGIN
	
	update fascicoli_ispettivi set modifiedby = _id_utente, modified= current_timestamp, stato=2, data_chiusura = to_timestamp(_data_chiusura,'YYYY-MM-DD HH:MI:SS') where id = _id_fascicolo_ispettivo;
	insert into fascicoli_ispettivi_protocolli (id_fascicolo_ispettivo, anno_protocollo, numero_protocollo, enteredby, entered) values (_id_fascicolo_ispettivo, _anno_protocollo, _numero_protocollo, _id_utente, now()) returning id into id_fascicolo_ispettivo_protocollo;

	if(id_fascicolo_ispettivo_protocollo > 0) then
		return 'OK, operazione effettuata con successo.';
	else 
		return 'KO, operazione fallita.';
	end if;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicolo_ispettivo_close(integer, text, integer, integer, integer)
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.fascicolo_ispettivo_dettaglio_globale(_idfascicolo integer)
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
	statofascicolo json;
	
	rifid integer;
	rifnometab text;
BEGIN

	rifid := (select riferimento_id from fascicoli_ispettivi  where id = _idfascicolo);
	rifnometab := (select c.riferimento_id_nome_tab from fascicoli_ispettivi c where id = _idfascicolo);
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from fascicoli_ispettivi c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where id = _idfascicolo 
								  union select 'dataInserimento' as nome, entered::text as descrizione from fascicoli_ispettivi where id = _idfascicolo
								  union select 'idFascicoloIspettivo' as nome, id::text as descrizione from fascicoli_ispettivi where id = _idfascicolo
								  ) b);

	anagrafica:= (select json_object_agg(nome,descrizione) from (select 'partitaIva' as nome, trim(partita_iva) as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab
								  union select 'riferimentoId' as nome,  rifid::text
								  union select 'riferimentoIdNomeTab' as nome,  rifnometab::text 
								  union select 'ragioneSociale' as nome, ragione_sociale as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab) c);

	datifascicolo := (select json_object_agg(nome,descrizione) from (select 'numero' as nome, numero as descrizione from fascicoli_ispettivi  where id = _idfascicolo
								  union select 'dataInizio' as nome,  data_inizio::text from fascicoli_ispettivi where id = _idfascicolo 
								  ) b);
								  
	statofascicolo := (select json_object_agg(nome,descrizione) from (select 'stato' as nome, ls.description as descrizione from fascicoli_ispettivi f join lookup_stato_fascicolo ls on ls.code=f.stato where id = _idfascicolo
								  union select 'dataChiusura' as nome,  data_chiusura::text from fascicoli_ispettivi where id = _idfascicolo 
								  ) b);
						

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, enteredby as descrizione from fascicoli_ispettivi where id = _idfascicolo) d); 

	finale := (select unaccent(concat('{',
	(select concat_ws(' ','"Dati":', datifascicolo, ',
	"Anagrafica":', anagrafica, ',
	"Utente":',utente, ',
	"Stato":', statofascicolo, ',
	"CampiServizio":', campiServizio)),'}'))::json);
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicolo_ispettivo_dettaglio_globale(integer)
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.fascicolo_ispettivo_insert(
    _json_anagrafica json,
    _idutente integer)
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

	INSERT INTO fascicoli_ispettivi (enteredby, riferimento_id, riferimento_id_nome_tab) values (_idutente,riferimento_id,riferimento_tab)
	returning id into resultid;

	 return resultid;
	 		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicolo_ispettivo_insert(json, integer)
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.fascicolo_ispettivo_insert_globale(_json_dati json)
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
	INSERT INTO giornate_ispettive_log_json(enteredby, json_cu) values(idutente,_json_dati);
	
	-- chiamo la dbi per il fascicolo
	idfascicolo := (SELECT * from public.fascicolo_ispettivo_insert(anagrafica, idutente));
	
	-- STEP 3: INSERIAMO I DATI DEL CU + linee
	update fascicoli_ispettivi set 
	data_inizio  = (datigenerici ->> 'dataInizio')::timestamp without time zone, 
	numero =  (datigenerici ->> 'numero')::text
        where id = idfascicolo;
	

    	 return idfascicolo;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicolo_ispettivo_insert_globale(json)
  OWNER TO postgres;

 DROP FUNCTION get_fascicoli_ispettivi_protocolli(integer);
CREATE OR REPLACE FUNCTION public.get_fascicoli_ispettivi_protocolli(IN _idfascicolo integer)
  RETURNS TABLE(anno_protocollo integer, numero_protocollo integer, id_fascicolo_ispettivo integer) AS
$BODY$
select 	anno_protocollo , numero_protocollo ,  id_fascicolo_ispettivo      
	from fascicoli_ispettivi_protocolli 

					where id_fascicolo_ispettivo = _idfascicolo and trashed_date is null order by entered desc limit 1;
    
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_fascicoli_ispettivi_protocolli(integer)
  OWNER TO postgres;

DROP FUNCTION get_giornata_ispettiva_protocolli(integer,text);
CREATE OR REPLACE FUNCTION public.get_giornata_ispettiva_protocolli(
    IN _idgiornataispettiva integer,
    IN _tipoverbale text)
  RETURNS TABLE(anno_protocollo integer, numero_protocollo integer, tipo_verbale text, data_protocollo text, id_documento integer, base64file text, id_giornata_ispettiva integer) AS
$BODY$
select 	anno_protocollo , numero_protocollo , tipo_verbale , data_protocollo , id_documento, base64file , id_giornata_ispettiva      
	from giornate_ispettive_verbali_protocolli 

					where id_giornata_ispettiva = _idgiornataispettiva and tipo_verbale = _tipoverbale and trashed_date is null order by entered desc limit 1;
    
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_giornata_ispettiva_protocolli(integer, text)
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.giornate_ispettive_lista_globale(
    _riferimento_id integer,
    _riferimento_id_nome_tab text)
  RETURNS json AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select id as "idGiornataIspettiva", s.description as "stato", l.description as "tecnica", data_inizio as "dataInizio", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from controlli_ufficiali c 
										join lookup_stato_cu s on s.code = c.stato
										join lookup_tipo_controllo l on l.code=c.id_tecnica
										join access a on a.user_id = c.enteredby 
										join contact co on co.contact_id = a.contact_id
										where c.riferimento_id = _riferimento_id and c.riferimento_id_nome_tab = _riferimento_id_nome_tab and c.trashed_date is null
										order by c.data_inizio desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornate_ispettive_lista_globale(integer, text)
  OWNER TO postgres;

 DROP FUNCTION giornate_ispettive_lista_globale(integer); 
CREATE OR REPLACE FUNCTION public.giornate_ispettive_lista_globale(_id_fascicolo_ispettivo integer)
  RETURNS json AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select id as "idGiornataIspettiva", l.description as "stato", c.data_inizio as "dataInizio", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from  giornate_ispettive c
										join access a on a.user_id = c.enteredby 
										join contact co on co.contact_id = a.contact_id
									        join lookup_stato_cu l on l.code = c.stato 
										where c.id_fascicolo_ispettivo =  _id_fascicolo_ispettivo and c.trashed_date is null 
										order by c.data_inizio desc) t);


	return output;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornate_ispettive_lista_globale(integer)
  OWNER TO postgres;

DROP FUNCTION giornata_ispettiva_insert_tipiverifica(json,integer,integer);
CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_tipiverifica(
    _json_daticontipiverifica json,
    _idgiornataispettiva integer,
    _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_daticontipiverifica) 
	  LOOP
	      RAISE INFO 'id %', i->>'id';
	      INSERT INTO giornate_ispettive_tipi_verifica (id_giornata_ispettiva, id_tipo_verifica, enteredby) values(_idgiornataispettiva,(i->>'id')::integer,_idutente);
			
	  END LOOP;

    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_tipiverifica(json, integer, integer)
  OWNER TO postgres;

DROP FUNCTION giornata_ispettiva_insert_tecnica(json,integer);
CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_tecnica(
    _json_tecnica json,
    _idgiornataispettiva integer)
  RETURNS integer AS
$BODY$	
BEGIN
	  -- effettuo l'update in quanto il record CU esiste gia'
	  UPDATE giornate_ispettive  set id_tecnica  = (_json_tecnica ->> 'id')::int where id = _idgiornataispettiva;
	  return 1;		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_tecnica(json, integer)
  OWNER TO postgres;
  
DROP FUNCTION giornata_ispettiva_insert_percontodi(json,integer,integer);
  CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_percontodi(
    _json_datipercontodi json,
    _idgiornataispettiva integer,
    _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_datipercontodi) 
	  LOOP
	      RAISE INFO 'id %', i->>'id';
	      INSERT INTO giornate_ispettive_per_conto_di (id_giornata_ispettiva, id_percontodi, enteredby) values(_idgiornataispettiva,(i->>'id')::integer,_idutente);
			
	  END LOOP;

    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_percontodi(json, integer, integer)
  OWNER TO postgres;

DROP FUNCTION giornata_ispettiva_insert_motivi(json,integer,integer);
CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_motivi(
    _json_daticonmotivi json,
    _idgiornataispettiva integer,
    _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_daticonmotivi) 
	  LOOP
	      RAISE INFO 'id %', i->>'id';
	      INSERT INTO giornate_ispettive_motivi (id_giornata_ispettiva, id_motivo, enteredby) values(_idgiornataispettiva,(i->>'id')::integer,_idutente);
			
	  END LOOP;

    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_motivi(json, integer, integer)
  OWNER TO postgres;

DROP FUNCTION giornata_ispettiva_insert_matrici(json,integer,integer) ;
CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_matrici(
    _json_datimatrici json,
    _idgiornataispettiva integer,
    _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_datimatrici) 
	  LOOP
	      RAISE NOTICE 'id %', i->>'id'; 
	      INSERT INTO giornate_ispettive_matrici (id_giornata_ispettiva, id_matrice, conclusa, enteredby) values
		 (_idgiornataispettiva, (i->>'id')::integer, (i->>'conclusa')::text, _idutente);
	  END LOOP;

    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_matrici(json, integer, integer)
  OWNER TO postgres;

DROP FUNCTION giornata_ispettiva_insert_linee(json,integer,text);
CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_linee(
    _json_linea json,
    _idgiornataispettiva integer,
    _riferimento_nome_tab text)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  -- per quante sono le linee, inserisci 
	  FOR i IN SELECT * FROM json_array_elements(_json_linea) 
	  LOOP
	      RAISE NOTICE 'id %', i->>'id';
		-- can do some processing here
		  INSERT INTO linee_attivita_giornate_ispettive (id_giornata_ispettiva, id_linea_attivita, codice_linea, riferimento_nome_tab) values
		  (_idgiornataispettiva, (i->>'id')::integer, i->>'codice', _riferimento_nome_tab);
	  END LOOP;

    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_linee(json, integer, text)
  OWNER TO postgres;

DROP FUNCTION giornata_ispettiva_insert_gruppo_ispettivo(json,integer);
  CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_gruppo_ispettivo(
    _json_daticonnucleo json,
    _idgiornataispettiva integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_daticonnucleo) 
	  LOOP
	      RAISE INFO 'id nominativo %', i->>'id';
	      RAISE INFO 'struttura %', i->>'Struttura';
	      RAISE INFO 'id struttura %', (i->>'Struttura')::json ->> 'id'; 
	
		 INSERT INTO giornata_ispettiva_gruppo_ispettivo (id_giornata_ispettiva, id_componente, enabled, referente, responsabile, id_struttura, nome_struttura) values (_idgiornataispettiva, (i->>'id')::integer,true, (i->> 'referente')::boolean, (i->>'responsabile')::boolean, 
		 (i->>'idStruttura')::integer, (i->>'struttura')::text);
	  END LOOP;


    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_gruppo_ispettivo(json, integer)
  OWNER TO postgres;

 drop FUNCTION public.giornata_ispettiva_insert_globale(json);
CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_globale(_json_dati json)
  RETURNS integer AS
$BODY$	
DECLARE
	anagrafica json; 
	utenti json;
	tecnicacu json;
	lineacu json;
	oggetticu json;
	motivicu json;
	gruppoispettivo json;
	percontodi json;
	esami json;
	tipiverifica json;
	datigenerici json; -- qui dovrebbero essere incluse anche le note
	dipartimento json;
	emissioni_in_atmosfera json;
        fascicolo json;
        matrici json;
        
	idcontrollo integer;
	idutente integer;
	output integer;
	
BEGIN
	 -- mi ricavo i singoli oggetti JSON per blocchi
	tecnicacu :=  _json_dati ->'Tecnica';
	RAISE INFO 'json tecnica %',tecnicacu;

	anagrafica :=  _json_dati ->'Anagrafica'; 
	RAISE INFO 'json anagrafica %',anagrafica;

	utenti :=  _json_dati ->'Utente';
	RAISE INFO 'json utenti %',utenti;
	
	idutente := utenti -> 'userId';
	RAISE INFO 'idutente %',idutente;

	lineacu :=  _json_dati ->'Linee';
	RAISE INFO 'json lineacu %',lineacu;

	tipiverifica :=  _json_dati ->'TipiVerifica';
	RAISE INFO 'json TipiVerifica %',tipiverifica;

	esami :=  _json_dati ->'Esami';
	RAISE INFO 'json esami %',esami;
       
        gruppoispettivo :=  _json_dati ->'GruppoIspettivo';
	RAISE INFO 'json gruppoispettivo %',gruppoispettivo;

	percontodi :=  _json_dati ->'PerContoDi';
	RAISE INFO 'json per conto di %',percontodi;
	
	datigenerici := _json_dati ->'Dati';
	RAISE INFO 'json datigenerici %',datigenerici;

	dipartimento := _json_dati -> 'Dipartimento';
	RAISE INFO 'json dipartimento %',dipartimento;

	emissioni_in_atmosfera := _json_dati -> 'EmissioniAtmosferaCamini';
	RAISE INFO 'json dipartimento %', emissioni_in_atmosfera;

	fascicolo := _json_dati -> 'FascicoloIspettivo';
	RAISE INFO 'json fascicolo %',fascicolo;

	matrici := _json_dati -> 'Matrici';
	RAISE INFO 'json matrici %',matrici;
  
	-- STEP 0: INSERIAMO IL RECORD JSON PER LOGO
	INSERT INTO giornate_ispettive_log_json(enteredby, json_cu) values(idutente,_json_dati);
	
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: INSERIAMO IL RECORD IN TICKET PER OTTENERE IL TICKETID
	idcontrollo := (SELECT * from public.giornata_ispettiva_insert_anagrafica(anagrafica, idutente));
	-- STEP 2: INSERIAMO LA TECNICA
	output := (SELECT * from public.giornata_ispettiva_insert_tecnica(tecnicacu, idcontrollo));

	raise info 'stampaaaaaaa %', length(datigenerici ->> 'dataFine');
	-- STEP 3: INSERIAMO I DATI DEL CU + linee
	update giornate_ispettive set stato=1, note = (datigenerici ->> 'note'), id_dipartimento = (dipartimento ->> 'id')::int, 
	data_inizio  = (datigenerici ->> 'dataInizio')::timestamp without time zone, 
	data_fine = (case when length(datigenerici ->> 'dataFine') > 0 then (datigenerici ->> 'dataFine')::timestamp without time zone else null end), 
	ore = (datigenerici ->> 'oraInizio'), 
	ora_fine = (datigenerici ->> 'oraFine')
	where id = idcontrollo;
	output := (SELECT * from public.giornata_ispettiva_insert_linee(lineacu, idcontrollo, anagrafica ->> 'riferimentoIdNomeTab'));
	
	-- se si tratta di AIA straordinaria
	if (tecnicacu ->> 'id')::int = 2 then
		-- STEP 4: INSERIAMO I MOTIVI E GLI ESAMI RICHIESTI
		motivicu :=  _json_dati ->'Motivi';
		RAISE INFO 'json motivicu %',motivicu;
		output :=(SELECT * from public.giornata_ispettiva_insert_motivi(motivicu, idcontrollo,idutente));	
		output :=(SELECT * from public.giornata_ispettiva_insert_esami(esami, idcontrollo, idutente));	
	-- se si tratta di AIA ordinaria
	elsif (tecnicacu ->> 'id')::int = 1 then
		--STEP 4: INSERIAMO GLI ESAMI RICHIESTI
		output :=(SELECT * from public.giornata_ispettiva_insert_esami(esami, idcontrollo, idutente));
	else
		-- do nothing per altre tecniche
		RAISE INFO 'la tecnica non prevede aggiunte di campi';
	end if;

	-- STEP 5: INSERIAMO I tipi di verifica comuni a tutte e 3 le tecniche
	output := (SELECT * from public.giornata_ispettiva_insert_tipiverifica(tipiverifica, idcontrollo, idutente));
	
	-- STEP 6: INSERIAMO I COMPONENTI DEL NUCLEO
	output := (SELECT * FROM public.giornata_ispettiva_insert_gruppo_ispettivo(gruppoispettivo,idcontrollo));

	-- STEP 7: INSERIAMO I percontodi
	output := (SELECT * FROM public.giornata_ispettiva_insert_percontodi(percontodi,idcontrollo,idutente));

	-- STEP 8: INSERIAMO le fasi
	output := (SELECT * FROM public.giornata_ispettiva_insert_emissioni_in_atmosfera_camini(emissioni_in_atmosfera,idcontrollo,idutente, (anagrafica ->> 'riferimentoId')::integer, anagrafica ->> 'riferimentoIdNomeTab'));

        -- STEP 9: INSERIAMO i fascicoli
	update giornate_ispettive set id_fascicolo_ispettivo = (fascicolo ->>'id')::integer where id = idcontrollo;

	-- STEP 10: INSERIAMO la matrice
	output :=(SELECT * from public.giornata_ispettiva_insert_matrici(matrici, idcontrollo, idutente));

    	 return idcontrollo;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_globale(json)
  OWNER TO postgres;

DROP FUNCTION giornata_ispettiva_insert_fasi_lavorazione(json,integer,integer);
CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_fasi_lavorazione(
    _json_datifasilavorazione json,
    _idgiornataispettiva integer,
    _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_datifasilavorazione) 
	  LOOP
	      RAISE INFO 'id %', i->>'id';
	      INSERT INTO giornate_ispettive_fase_lavorazione (id_giornata_ispettiva, id_fase_lavorazione, enteredby) values(_idgiornataispettiva,(i->>'id')::integer,_idutente);
			
	  END LOOP;

    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_fasi_lavorazione(json, integer, integer)
  OWNER TO postgres;

DROP FUNCTION giornata_ispettiva_insert_esami(json,integer,integer);
  CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_esami(
    _json_datiesami json,
    _idgiornataispettiva integer,
    _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_datiesami) 
	  LOOP
	      RAISE NOTICE 'id %', i->>'id'; 
	      INSERT INTO giornate_ispettive_esami (id_giornata_ispettiva, id_esame, enteredby) values
		 (_idgiornataispettiva, (i->>'id')::integer, _idutente);
	  END LOOP;

    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_esami(json, integer, integer)
  OWNER TO postgres;



DROP FUNCTION giornata_ispettiva_insert_emissioni_in_atmosfera_camini(json,integer,integer,integer,text);
CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_emissioni_in_atmosfera_camini(
    _json_datifasilavorazione json,
    _idgiornataispettiva integer,
    _idutente integer,
    _riferimento_id integer,
    _riferimento_id_nome_tab text)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
	id_emissioni_camini integer;
BEGIN


	  FOR i IN SELECT * FROM json_array_elements(_json_datifasilavorazione) 
	  LOOP
	      RAISE INFO 'id %', i->>'id';
	    

		if ((i->>'id')::integer) <0 then
			-- fai insert in anag_emissioni_in_atmosfera_camini
			insert into emissioni_in_atmosfera_camini(codice_camino, fasi_lavorativa, inquinanti, sistema_abbattimento) values((i->>'codiceCamino')::text, (i->>'fasiLavorativa')::text, (i->>'inquinanti')::text, (i->>'sistemaAbbattimento')::text) 
			returning id into id_emissioni_camini;
			insert into anag_emissioni_in_atmosfera_camini( id_emissioni_in_atmosfera_camini,enteredby, riferimento_id, riferimento_id_nome_tab) values(id_emissioni_camini, _idutente, _riferimento_id, _riferimento_id_nome_tab);
		else
			id_emissioni_camini := (i->>'id')::integer;
		end if;		
	                                                            
	        INSERT INTO giornate_ispettive_emissioni_in_atmosfera_camini  (id_giornata_ispettiva, id_emissioni_in_atmosfera_camini, esito_conforme, note, data_sopralluogo_2016, parametri_analizzati, superamenti_limiti_normativi,
	                                                                      entered, enteredby) values
	                                                                     (_idgiornataispettiva,
	                                                                      id_emissioni_camini,
	                                                                     (i->>'esitoConforme')::boolean,
	                                                                     (i->>'note')::text,
	                                                                     (i->>'dataSopralluogo2016')::text,
	                                                                     (i->>'parametriAnalizzati')::text,
	                                                                     (i->>'superamentiLimitiNormativi')::text,
	                                                                     now(),
								             _idutente);
	  END LOOP;

    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_emissioni_in_atmosfera_camini(json, integer, integer, integer, text)
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.giornata_ispettiva_insert_anagrafica(
    _json_anagrafica json,
    _idutente integer)
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

	INSERT INTO giornate_ispettive (enteredby, riferimento_id, riferimento_id_nome_tab) values (_idutente,riferimento_id,riferimento_tab)
	returning id into resultid;

	  return resultid;
	 		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_insert_anagrafica(json, integer)
  OWNER TO postgres;

DROP FUNCTION giornata_ispettiva_get_verbale_a6(integer);
CREATE OR REPLACE FUNCTION public.giornata_ispettiva_get_verbale_a6(_id_giornata_ispettiva integer)
  RETURNS json AS
$BODY$
DECLARE
	output json;
BEGIN

	-- output := (SELECT (row_to_json(t)) FROM (select id as "idGiornataIspettiva", l.description as "stato", c.data_inizio as "dataInizio", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
	--									from  controlli_ufficiali c
	--									join access a on a.user_id = c.enteredby 
	--									join contact co on co.contact_id = a.contact_id
	--								        join lookup_stato_cu l on l.code = c.stato 
	--									where c.id =  _id_giornata_ispettiva
	--									order by c.data_inizio desc) t);

	output := (select * from public.giornata_ispettiva_dettaglio_globale(_id_giornata_ispettiva));

	return output;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_get_verbale_a6(integer)
  OWNER TO postgres;

  CREATE OR REPLACE FUNCTION public.giornata_ispettiva_dettaglio_globale(_idcontrollo integer)
  RETURNS json AS
$BODY$	
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
	   
	id_tecnica := (select c.id_tecnica  from giornate_ispettive c where id = _idcontrollo); 
	anno_controllo := (select date_part('year',data_inizio)::integer from giornate_ispettive where id = _idcontrollo);
	rifid := (select riferimento_id from giornate_ispettive where id = _idcontrollo);
	id_dipartimento := (select c.id_dipartimento from giornate_ispettive c where id = _idcontrollo);
	rifnometab := (select c.riferimento_id_nome_tab from giornate_ispettive c where id = _idcontrollo);
	--tipologia_operatore := (select distinct m.tipologia_operatore from ricerche_anagrafiche_old_materializzata m where m.riferimento_id = rifid and m.riferimento_id_nome_tab = rifnometab );
	--lineacontrollo := (select codice_linea from linee_attivita_giornate_ispettive  where  id_giornata_ispettiva  = _idcontrollo and trashed_date is null);

	--path_linea := (select path_descrizione from ml8_linee_attivita_nuove_materializzata where codice = lineacontrollo and livello = 3 limit 1);
	
	-- costruzione dei json
	tecnicacu := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, description as descrizione from lookup_tipo_controllo where code = id_tecnica 
							union select 'id' as nome,  id_tecnica::text) a); 
        --tecnicacu := (select json_object_agg('Tecnica', tecnicacu));
	raise info 'json tecnica ricostruito%', tecnicacu;
	daticu := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from giornate_ispettive where id = _idcontrollo
								  union select 'dataInizio' as nome,  data_inizio::text from giornate_ispettive where id = _idcontrollo 
								  union select 'dataFine' as nome,  data_fine::text from giornate_ispettive where id = _idcontrollo 
								  union select 'oraInizio' as nome,  coalesce(ore::text,'') from giornate_ispettive where id = _idcontrollo 
								  union select 'oraFine' as nome,  coalesce(ora_fine::text,'') from giornate_ispettive where id = _idcontrollo 
								  union select 'conclusa' as nome,  coalesce(conclusa_verifica::text,'') from giornate_ispettive where id = _idcontrollo 
								  ) b);
	--daticu := (select json_object_agg('Dati', daticu));
	raise info 'json daticu ricostruito%', daticu;
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'stato' as nome, l.description as descrizione 
									 from giornate_ispettive c join lookup_stato_cu l on l.code = c.stato 
									 where id = _idcontrollo
								  union select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from giornate_ispettive c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where id = _idcontrollo 
								  union select 'dataInserimento' as nome, entered::text as descrizione from giornate_ispettive where id = _idcontrollo
								  union select 'idGiornataIspettiva' as nome, id::text as descrizione from giornate_ispettive where id = _idcontrollo 
								  ) b);

	anagrafica := (select json_object_agg(nome,descrizione) from (select 'partitaIva' as nome, trim(partita_iva) as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab
								  union select 'riferimentoId' as nome,  rifid::text
								  union select 'riferimentoIdNomeTab' as nome,  rifnometab::text 
								  union select 'ragioneSociale' as nome, ragione_sociale as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab) c);
	--anagrafica := (select json_object_agg('Anagrafica', anagrafica));
	raise info 'json anagrafica ricostruito%', anagrafica;

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, enteredby as descrizione from giornate_ispettive where id = _idcontrollo) d); 
	--utente := (select json_object_agg('Utente', utente));
	raise info 'json utente ricostruito%', utente;

	dipartimento := (select json_object_agg(nome,descrizione) from (select 'nome' as nome,  description as descrizione from lookup_site_id where code= id_dipartimento
								union select 'id' as nome, id_dipartimento::text) e); 
	--asl := (select json_object_agg('Asl', asl));
	raise info 'json asl ricostruito%', dipartimento;
				  
	--"Linee":[{"codice":"MS.020-MS.020.500-852IT3A401","nome":"path completo","id":"192439"}],
	--linee := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select lineacontrollo as codice, path_linea as nome, (select id_linea_attivita from linee_attivita_giornate_ispettive  where trashed_date is null and id_giornata_ispettiva = _idcontrollo) as id 
	--									from giornate_ispettive where id = _idcontrollo) t);
	--linee := (select json_object_agg('Linee', linee));


	--06/07
	linee := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select codice_linea as codice, replace(coalesce(ml.path_descrizione,''), '''', '''''') as nome, l.id_linea_attivita as id 
									from giornate_ispettive c
									left join linee_attivita_giornate_ispettive l on l.id_giornata_ispettiva=c.id and l.trashed_date is null			
									left join master_list_linea_attivita m on m.codice_univoco = l.codice_linea
									left join ml8_linee_attivita_nuove_materializzata ml on ml.id_attivita = m.id
									where c.id = _idcontrollo and c.trashed_date is null) t);
	raise info 'json linee ricostruito%', linee;


	gruppoispettivo := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select distinct d.nominativo as nominativo, c.id_componente as id, d.qualifica as qualifica, c.nome_struttura as struttura,
										c.responsabile, c.referente
										from giornata_ispettiva_gruppo_ispettivo c
										join public.dpat_get_nominativi(-1,anno_controllo,null,null,null,c.id_struttura,null,-1) d on d.id_anagrafica_nominativo = c.id_componente
										left join access_ ac on ac.user_id = c.id_componente -- è giusto?
										where id_giornata_ispettiva = _idcontrollo) t);

	--gruppoispettivo := (select json_object_agg('GruppoIspettivo', gruppoispettivo));
	raise info 'json gruppoispettivo ricostruito %', gruppoispettivo;


										
	tipiverifica := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_tipi_verifica c
										join lookup_tipi_verifica l on l.code = c.id_tipo_verifica
										where c.id_giornata_ispettiva = _idcontrollo) t);
	--tipiverifica := (select json_object_agg('TipiVerifica', tipiverifica));
	raise info 'json tipi verifica %', tipiverifica;
	
	percontodi := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select o.descrizione_lunga as nome, o.id as id 
										from giornate_ispettive_per_conto_di c
										join oia_nodo o on o.id = c.id_percontodi
										where c.id_giornata_ispettiva = _idcontrollo) t);
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
											and c.id_giornata_ispettiva = _idcontrollo) t);
												
	raise info 'json emissioni atmosfera %', emissioniatmosfera;

										
	fascicolo := (select json_object_agg(nome,descrizione) from (select 'numero' as nome,  numero as descrizione from fascicoli_ispettivi  where id in (select id_fascicolo_ispettivo from giornate_ispettive where id = _idcontrollo and trashed_date is null) 
								union select 'id' as nome, id_fascicolo_ispettivo::text as descrizione from giornate_ispettive where id = _idcontrollo) e); 
								
	raise info 'json fascicolo %', fascicolo;

	matrici := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id, c.conclusa
										from giornate_ispettive_matrici c
										join lookup_matrice_controlli l on l.code = c.id_matrice
										where c.id_giornata_ispettiva = _idcontrollo) t);

	raise info 'json matrici %', matrici;
		
	
	if (tecnicacu ->> 'id')::int = 2 then
		-- RECUPERO I MOTIVI E GLI ESAMI RICHIESTI
		motivi := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_motivi c
										join lookup_motivi l on l.code = c.id_motivo 
										where c.id_giornata_ispettiva = _idcontrollo) t);
		--motivi := (select json_object_agg('Motivi', motivi));
		raise info 'json motivi ricostruito %', motivi;

		esami := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_esami c
										join lookup_esami l on l.code = c.id_esame 
										where c.id_giornata_ispettiva = _idcontrollo) t);
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
										where c.id_giornata_ispettiva = _idcontrollo) t);
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.giornata_ispettiva_dettaglio_globale(integer)
  OWNER TO postgres;

-- Function: public.non_conformita_dettaglio_globale(integer)

-- DROP FUNCTION public.non_conformita_dettaglio_globale(integer);
CREATE OR REPLACE FUNCTION public.non_conformita_dettaglio_globale(_idnc integer)
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

	linea := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, path_descrizione::text as descrizione from ml8_linee_attivita_nuove_materializzata  
								where codice =
								(select codice_linea from linee_attivita_giornate_ispettive l where l.id_linea_attivita =id_linea_nc and l.id_giornata_ispettiva = _id_giornata_ispettiva)
								union
								select 'id' as nome, id_linea::text as descrizione 
								from non_conformita nc
								where trashed_date is null and nc.id = _idnc) a);	
									             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from non_conformita  where id = _idnc) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from non_conformita where id = _idnc) a);	

	daticu := (select json_object_agg(nome,descrizione) from (select 'idGiornataIspettiva' as nome, n.id_giornata_ispettiva::text as descrizione from non_conformita n where n.id = _idnc
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.non_conformita_dettaglio_globale(integer)
  OWNER TO postgres;

DROP FUNCTION campioni_lista_globale(integer);
CREATE OR REPLACE FUNCTION public.campioni_lista_globale(_id_giornata_ispettiva integer)
  RETURNS json AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select id as "idCampione", num_verbale as "NumVerbale", c.data_prelievo as "dataPrelievo", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from campioni c  
										join access a on a.user_id = c.enteredby 
										join contact co on co.contact_id = a.contact_id
										where c.id_giornata_ispettiva = _id_giornata_ispettiva 
										order by c.data_prelievo desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campioni_lista_globale(integer)
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

  DROP FUNCTION public.get_giornata_ispettiva_protocolli(integer, text);
  CREATE OR REPLACE FUNCTION public.get_motivi_giornata_ispettiva(IN _id_tecnica integer)
  RETURNS TABLE(code integer, motivo text, id_tecnica integer) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select m.code, m.description::text, m.id_tecnica
	from lookup_motivi m
	where m.enabled
	and ( _id_tecnica = -1 or m.id_tecnica = _id_tecnica)
	order by m.id_tecnica, m.description;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_motivi_giornata_ispettiva(integer)
  OWNER TO postgres;
  
  DROP FUNCTION non_conformita_lista_globale(integer);
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

  DROP FUNCTION public.get_giornate_ispettive_protocolli(integer, text);

CREATE OR REPLACE FUNCTION public.get_giornate_ispettive_protocolli(
    IN _id_giornata_ispettiva integer,
    IN _tipoverbale text)
  RETURNS TABLE(anno_protocollo integer, numero_protocollo integer, tipo_verbale text, data_protocollo text, id_documento integer, base64file text, id_giornata_ispettiva integer) AS
$BODY$
select 	anno_protocollo , numero_protocollo , tipo_verbale , data_protocollo , id_documento, base64file , id_giornata_ispettiva      
	from giornate_ispettive_verbali_protocolli 

					where id_giornata_ispettiva = _id_giornata_ispettiva and tipo_verbale = _tipoverbale and trashed_date is null order by entered desc limit 1;
    
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

  
CREATE OR REPLACE FUNCTION public.get_gruppo_ispettivo_componenti(
    IN _anno integer DEFAULT NULL::integer,
    IN _id_qualifica integer DEFAULT '-1'::integer,
    IN _id_dipartimento integer DEFAULT '-1'::integer,
    IN _id_struttura text DEFAULT ''::text)
  RETURNS TABLE(id integer, nominativo text, id_struttura integer, nome_struttura text, id_qualifica integer, nome_qualifica text) AS
$BODY$
DECLARE
	lista_strutture text;
BEGIN
	lista_strutture := (select replace(replace(_id_struttura,'(',''''),')',''''));
	raise info 'lista: %', lista_strutture;
	raise info 'string to array input: %', string_to_array(lista_strutture,',');
	return query
		select d.id_anagrafica_nominativo, d.nominativo, d.id_struttura_semplice, concat_ws('->', (select description from lookup_site_id where enabled and code = d.id_asl),d.desc_strutt_complessa,d.desc_strutt_semplice), _id_qualifica, d.qualifica
		from public.dpat_get_nominativi(_id_dipartimento::integer, _anno::integer, null::text,null::integer,null::text,null,null, _id_qualifica) d
		--where 1=1 and (_id_struttura = '' or string_to_array(d.id_Struttura_semplice::text,',') <@ string_to_array('8167,8365'::text,',')); 
		where 1=1 and (_id_struttura = '' or string_to_array(d.id_Struttura_semplice::text,',') <@ string_to_array(lista_strutture,','))
		order by 4,2 asc; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_gruppo_ispettivo_componenti(integer, integer, integer, text)
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.get_giornata_ispettiva_gruppo_ispettivo_componenti(IN _id_giornata_ispettiva integer)
  RETURNS TABLE(id integer, nominativo text, id_struttura integer, nome_struttura text, id_qualifica integer, nome_qualifica text) AS
$BODY$

BEGIN
	
	return query
		select distinct c.id_componente, concat_ws(' ', cc.namefirst, cc.namelast)::text, c.id_struttura, c.nome_struttura::text, ac.role_id, r.role::text
		from giornata_ispettiva_gruppo_ispettivo c
	        left join access_ ac on ac.user_id = c.id_componente 
	        left join role r on r.role_id= ac.role_id
	        left join contact cc on cc.contact_id = ac.contact_id 
		where id_giornata_ispettiva = _id_giornata_ispettiva
		order by 4,2 asc; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_giornata_ispettiva_gruppo_ispettivo_componenti(integer)
  OWNER TO postgres;

--select * from get_giornata_ispettiva_gruppo_ispettivo_componenti(38) 
CREATE OR REPLACE FUNCTION public.campione_insert_globale(_json_dati json)
  RETURNS integer AS
$BODY$	
DECLARE
	datigiornataispettiva json; 
	utente json;
	motivazione json;
	laboratorio json;
	numeroverbale json;
	matrice json;
	analiti json;
	dati json;
	gruppoispettivo json;
	
	idcampione integer;
	idutente integer;
	output integer;
	
BEGIN
	 -- mi ricavo i singoli oggetti JSON per blocchi
	datigiornataispettiva:=  _json_dati ->'DatiGiornataIspettiva';
	RAISE INFO 'json datigiornataispettiva %',datigiornataispettiva;

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

	gruppoispettivo :=  _json_dati ->'GruppoIspettivo';
	RAISE INFO 'json gruppoispettivo %',gruppoispettivo;
	
	-- STEP 0: INSERIAMO IL RECORD JSON PER LOG
	INSERT INTO giornate_ispettive_log_json(enteredby, json_cu) values(idutente,_json_dati);
	
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: INSERIAMO IL RECORD IN CAMPIONI
	idcampione := (SELECT * from public.campione_insert(dati, idutente));
	-- STEP 2: INSERIAMO LA MATRICE
	output := (SELECT * from public.campione_insert_matrice(matrice, idcampione));
	-- STEP 3: INSERIAMO GLI ANALITI
	output := (SELECT * from public.campione_insert_analiti(analiti, idcampione));
	-- STEP 4: INSERIAMO IL GRUPPO ISPETTIVO
	output := (SELECT * from public.campione_insert_gruppo_ispettivo(gruppoispettivo, idcampione));
	-- STEP 5: INSERIAMO GLI ALTRI DATI DEL CAMPIONE
	update campioni set id_laboratorio= (laboratorio->>'id')::int, id_motivazione = (motivazione ->> 'id')::integer, num_verbale=lpad(id::text, 6, '0'),
	id_giornata_ispettiva = (datigiornataispettiva ->> 'idGiornataIspettiva')::integer  where id = idcampione;
	
    	 return idcampione;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_insert_globale(json)
  OWNER TO postgres;


CREATE TABLE public.campione_gruppo_ispettivo
(
  id serial,
  id_campione integer,
  id_componente integer,
  enabled boolean DEFAULT true,
  note_hd text,
  id_struttura integer,
  nome_struttura text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.campione_gruppo_ispettivo
  OWNER TO postgres;


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
	datigiornataispettiva json;
	gruppoispettivo json;
	
	id_dipartimento integer;

BEGIN
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: recuperiamo i campi del campione
	laboratorio := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, (l.description)::text as descrizione from lookup_destinazione_campione l join campioni c on c.id_laboratorio= l.code
							               union select 'id' as nome,  (l.code)::text from  lookup_destinazione_campione l join campioni c on c.id_laboratorio= l.code) a);
	motivazione := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, 'DA DEFINIRE' as descrizione 
							               union select 'id' as nome,  1::text) a);				             

	numeroverbale := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, num_verbale as descrizione from campioni where id = _idcampione
							               union select 'id' as nome,  1::text) a);				             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from campioni where id = _idcampione) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from campioni where id = _idcampione
							               union select 'dataPrelievo' as nome, (data_prelievo)::text  from campioni where id = _idcampione) a);	

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
							          ) a);	     
	-- STEP 2: recuperiamo i campi matrice
	matrice := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, cammino::text as descrizione from matrici_campioni where id_campione  = _idcampione
							             union select 'id' as nome, id::text from matrici_campioni where id_campione  = _idcampione) a);
	-- STEP 3: recuperiamo i campi analiti
	analiti := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select cammino as nome, analiti_id as id 
										from analiti_campioni where id_campione = _idcampione) t);

	--STEP 4: gruppo ispettivo
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
		(select concat_ws(' ', '"Dati":', dati, ',"DatiGiornataIspettiva":', datigiornataispettiva, ',"NumeroVerbale":', numeroverbale, ',"Utente":',utente, 
		',"Matrice":', matrice,
		',"Analiti":', analiti,
		',"Laboratorio":', laboratorio,
		',"GruppoIspettivo":', gruppoispettivo,
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
  
--update permission set permission = 'gestionenuovaispezione' where permission_id = 4; --nome "gestionenuovacu"

  --select * from giornata_ispettiva_dettaglio_globale(33)

