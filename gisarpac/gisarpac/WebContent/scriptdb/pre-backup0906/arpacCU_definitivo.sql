
insert into permission (category_id,permission,permission_view,permission_add,permission_edit,permission_delete,description , level,enabled,active)
values (36,'gestionenuovacu',true,true,true,true,'GESTIONE CAVALIERE DEDICATO AI CU',10,true,true) returning permission_id;


insert into role_permission (id, role_id, permission_id, role_view, role_add) values ((select max(id)+1 from role_permission),1,766,true, true); 
insert into role_permission (id, role_id, permission_id, role_view, role_add) values ((select max(id)+1 from role_permission),31,766,true, true); 
insert into role_permission (id, role_id, permission_id, role_view, role_add) values ((select max(id)+1 from role_permission),32,766,true, true); 

truncate lookup_tipo_controllo cascade; 
insert into lookup_tipo_controllo(code, description, enabled) values (1, 'Ispezione AIA ordinaria', true);
insert into lookup_tipo_controllo(code, description, enabled) values (2, 'Ispezione AIA straordinaria', true); 
insert into lookup_tipo_controllo(code, description, enabled) values (3, 'Ispezione AIA non programmata', true); 

CREATE OR REPLACE FUNCTION public.get_tecniche_by_id_anagrafica(
    IN _riferimento_id integer,
    IN _riferimento_id_nome_tab text)
  RETURNS TABLE(id integer, nome text) AS
$BODY$
DECLARE
	check_linea_moll int;
	check_esistenza_anag int;
	check_esistenza_macello int;
BEGIN 
	
	RETURN QUERY
		select code, description::text from lookup_tipo_controllo where enabled order by description; -- escono le tecniche BASE + quelle ad hoc
	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_tecniche_by_id_anagrafica(integer, text)
  OWNER TO postgres;

CREATE TABLE public.lookup_esami
(
  code serial,
  description character varying(500) NOT NULL,
  default_item boolean DEFAULT false,
  level integer DEFAULT 0,
  enabled boolean DEFAULT true,
  id_tecnica integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lookup_esami
  OWNER TO postgres;

insert into lookup_esami(code, description, id_tecnica) values (1, 'Decreto AIA', 1); 
insert into lookup_esami(code, description, id_tecnica) values (2, 'Progetti e interventi richiesti in AIA', 1); 
insert into lookup_esami(code, description, id_tecnica) values (3, 'Esiti autocontrollo', 1); 
insert into lookup_esami(code, description, id_tecnica) values (4, 'Ultima dichiarazione disponibile E-PRTR e MUD', 1); 
insert into lookup_esami(code, description, id_tecnica) values (5, 'Comunicazione dell''azienda di adeguamento all''AIA e/o richieste di proroghe', 1); 
insert into lookup_esami(code, description, id_tecnica) values (6, 'Successive comunicazioni di variazioni amministrative e/o tecniche',1); 
insert into lookup_esami(code, description, id_tecnica) values (7, 'Precedenti controlli',1); 
insert into lookup_esami(code, description, id_tecnica) values (8, 'Validità delle eventuali certificazioni ambientali ed eventuale utilizzo della relativa documentazione SGA', 1); 
insert into lookup_esami(code, description, id_tecnica) values (9, 'Decreto AIA',2 ); 
insert into lookup_esami(code, description, id_tecnica) values (10, 'Eventuali esposti, ordinanze', 2); 
insert into lookup_esami(code, description, id_tecnica) values (11, 'Esiti autocontrollo',2 ); 
insert into lookup_esami(code, description, id_tecnica) values (12, 'Precedenti controlli', 2); 
insert into lookup_esami(code, description, id_tecnica) values (13, 'Eventuale utilizzo della relativa documentazione SGA',2 ); 

CREATE TABLE public.lookup_motivi
(
  code serial,
  description character varying(500) NOT NULL,
  default_item boolean DEFAULT false,
  level integer DEFAULT 0,
  enabled boolean DEFAULT true,
  id_tecnica integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lookup_motivi
  OWNER TO postgres;

insert into lookup_motivi(code, description, id_tecnica) values (1, 'Reclami', 2); 
insert into lookup_motivi(code, description, id_tecnica) values (2, 'Grave incidente', 2); 
insert into lookup_motivi(code, description, id_tecnica) values (3, 'Valutazioni dell''agenzia', 2); 
insert into lookup_motivi(code, description, id_tecnica) values (4, 'Richiesta dell''AC', 2); 
insert into lookup_motivi(code, description, id_tecnica) values (5, 'Comunicazioni dell''azienda di esecuzione di interventi', 2); 
insert into lookup_motivi(code, description, id_tecnica) values (6, 'Richieste della Magistratura', 2); 

--select * from lookup_esami
drop FUNCTION public.get_oggetto_del_controllo(integer);
CREATE OR REPLACE FUNCTION public.get_esami_documentazione(IN _id_tecnica integer)
  RETURNS TABLE(code integer, esame text, id_tecnica integer) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select e.code, e.description::text, e.id_tecnica
	from lookup_esami e
	where e.enabled
	and ( _id_tecnica = -1 or e.id_tecnica = _id_tecnica)
	order by e.id_tecnica, e.description;
END;
$BODY$
  LANGUAGE plpgsql
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_esami_documentazione(integer)
  OWNER TO postgres;


CREATE TABLE public.lookup_tipi_verifica
(
  code serial,
  description character varying(500) NOT NULL,
  default_item boolean DEFAULT false,
  level integer DEFAULT 0,
  enabled boolean DEFAULT true
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lookup_tipi_verifica
  OWNER TO postgres;

insert into lookup_tipi_verifica(code, description) values (1, 'Materie prime e utilizzo delle risorse'); 
insert into lookup_tipi_verifica(code, description) values (2, 'Emissioni in aria'); 
insert into lookup_tipi_verifica(code, description) values (3, 'Emissioni in acqua'); 
insert into lookup_tipi_verifica(code, description) values (4, 'Rifiuti 3.2.5 Rumore'); 
insert into lookup_tipi_verifica(code, description) values (5, 'Suolo e sottosuolo'); 
insert into lookup_tipi_verifica(code, description) values (6, 'Altre componenti ambientali'); 
insert into lookup_tipi_verifica(code, description) values (7, 'Gestione degli incidenti e anomalie'); 
insert into lookup_tipi_verifica(code, description) values (8, 'Sistema di gestione Ambientale'); 

CREATE OR REPLACE FUNCTION public.get_tipi_verifica()
  RETURNS TABLE(code integer, tipo_verifica text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select t.code, t.description::text
	from lookup_tipi_verifica t 
	where t.enabled
	order by t.description;
END;
$BODY$
  LANGUAGE plpgsql
  COST 100
  ROWS 1000;

select * from public.get_tipi_verifica()

  --select * from public.get_esami_documentazione(1)
  --select * from public.get_esami_documentazione(-1)

drop function public.get_motivi_cu(integer, integer,text[]);
DROP FUNCTION get_motivi_cu(integer)
CREATE OR REPLACE FUNCTION public.get_motivi_cu(
    IN _id_tecnica integer)
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
  LANGUAGE plpgsql
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_motivi_cu(integer)
  OWNER TO postgres;


drop FUNCTION public.get_percontodi_strutture(integer, integer, integer)
drop FUNCTION public.get_percontodi_strutture_poli()
drop FUNCTION public.get_percontodi_strutture_asl(integer, integer, integer);
drop FUNCTION public.get_percontodi_strutture_asl(integer, integer);

CREATE OR REPLACE FUNCTION public.get_percontodi_strutture_dipartimento(
    IN _anno integer,
    IN _id_dipartimento integer)
  RETURNS TABLE(id_dipartimento integer, dipartimento text, tipologia text, descrizione text, appartenenza text, id integer) AS
$BODY$
DECLARE

BEGIN 

	
	return query
	SELECT 
	strutt_semplice.id_asl as id_asl_struttura_semplice,
	asl.description::text as dipartimento,
	tipooia.description::text as tipologia,
	strutt_semplice.descrizione::text as descrizione_struttura_semplice, 
        strutt_complessa.descrizione::text as appartenenza, 
        strutt_semplice.id as id_struttura_semplice	
	FROM dpat_strutture_asl strutt_complessa
	LEFT JOIN dpat_strutture_asl strutt_semplice on strutt_semplice.id_padre = strutt_complessa.id and 
                                           strutt_semplice.disabilitato = false and strutt_semplice.stato = 2 and strutt_semplice.enabled
        LEFT JOIN lookup_site_id asl on asl.code = strutt_semplice.id_asl
	LEFT JOIN lookup_tipologia_nodo_oia tipooia ON strutt_complessa.tipologia_struttura = tipooia.code 
	where strutt_complessa.disabilitato = false and  strutt_complessa.tipologia_struttura in(13,14) and strutt_complessa.stato=2 and strutt_complessa.enabled
        and (strutt_complessa.id_asl = _id_dipartimento or _id_dipartimento is null) 
        and strutt_complessa.id_strumento_calcolo in (select dpat_strumento_calcolo.id 
			                          from dpat_strumento_calcolo 
			                          where (dpat_strumento_calcolo.id_asl = _id_dipartimento or _id_dipartimento is null) and 
			                                (strutt_complessa.anno = _anno or _anno is null) 
			                          ) and  strutt_semplice.id >0
	order by strutt_complessa.descrizione::text,strutt_semplice.descrizione::text ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_percontodi_strutture_dipartimento(integer, integer)
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.get_dipartimento_controllo(
    IN _riferimento_id integer,
    IN _riferimento_id_nome_tab text,
    IN _id_utente integer)
  RETURNS TABLE(id integer, nome text) AS
$BODY$
DECLARE
	id_asl_recuperato integer;
	ruolo_utente integer;
	asl_recuperata text;
	id_asl_utente integer;
	asl_utente text;
BEGIN
	-- recupero ruolo utente
	ruolo_utente := (select role_id from access_ where user_id  = _id_utente);
	raise info 'ruolo_utente: %', ruolo_utente;
	-- recupero ASL dello stabilimento
	id_asl_recuperato := (select asl_rif from ricerche_anagrafiche_old_materializzata where 
			      riferimento_id = _riferimento_id and riferimento_id_nome_tab = _riferimento_id_nome_tab and tipo_attivita =1 limit 1);
	asl_recuperata := (select asl from ricerche_anagrafiche_old_materializzata where  
			      riferimento_id = _riferimento_id and riferimento_id_nome_tab = _riferimento_id_nome_tab and tipo_attivita =1 limit 1);	
	-- recupero ASL dell'utente
	select ad.site_id, lsi.description into id_asl_utente, asl_utente
	from access_dati ad left join lookup_site_id lsi on lsi.code = ad.site_id
	where ad.user_id = _id_utente and ad.site_id > 0;		      	

	raise info 'id_asl_recuperato: %', id_asl_recuperato;
	raise info 'asl_recuperata: %', asl_recuperata;
	raise info 'id_asl_utente: %', id_asl_utente;
	raise info 'asl_utente: %', asl_utente;
			      	      	      
	-- se lo stabilimento è fisso, recupero ASL 
	if id_asl_recuperato > 0 then
		return query select id_asl_recuperato, asl_recuperata;
	-- se lo stabilimento è mobile e l'utente ha l'ASL, recupero ASL
	elsif (id_asl_recuperato is null or id_asl_recuperato <= 0) and id_asl_utente > 0 then
		return query select id_asl_utente, asl_utente;
	else -- è mobile o è un altro scenario...
		return query select code, description::text from lookup_site_id where enabled and code <> 16 order by code;
	end if;
	
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_dipartimento_controllo(integer, text, integer)
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.dpat_get_nominativi(
    IN asl_input integer DEFAULT -1::integer,
    IN anno_input integer DEFAULT NULL::integer,
    IN stato_input text DEFAULT NULL::text,
    IN id_struttura_complessa_input integer DEFAULT NULL::integer,
    IN descrizione_struttura_complessa_input text DEFAULT NULL::text,
    IN id_struttura_semplice_input integer DEFAULT NULL::integer,
    IN descrizione_struttura_semplice_input text DEFAULT NULL::text,
    IN id_qualifica_input integer DEFAULT -1::integer)
  RETURNS TABLE(id_nominativo integer, id_anagrafica_nominativo integer, nominativo text, codice_fiscale text, qualifica text, data_scadenza_nominativo timestamp without time zone, id_struttura_semplice integer, desc_strutt_semplice text, stato_strutt_semplice integer, data_scadenza_strutt_semplice timestamp without time zone, id_strutt_complessa integer, desc_strutt_complessa text, data_scadenza_strutt_complessa timestamp without time zone, stato_strutt_complessa integer, id_asl integer, anno integer) AS
$BODY$
DECLARE
	r RECORD;
BEGIN
	FOR id_nominativo, id_anagrafica_nominativo, nominativo,  codice_fiscale, qualifica, data_scadenza_nominativo,id_struttura_semplice, desc_strutt_semplice, 
       stato_strutt_semplice, data_scadenza_strutt_semplice, id_strutt_complessa, desc_strutt_complessa,data_scadenza_strutt_complessa, stato_strutt_complessa,  
       id_asl, anno	
      in

select n.id as id_nominativo, n.id_anagrafica_nominativo, concat(c.namefirst, ' ', c.namelast) as nominativo,  c.codice_fiscale, lq.description as qualifica,  
       n.data_scadenza as data_scadenza_nominativo,n.id_dpat_strumento_calcolo_strutture as id_struttura_semplice, strutt_semplice.descrizione as desc_strutt_semplice, 
       strutt_semplice.stato as stato_strutt_semplice, strutt_semplice.data_scadenza as data_scadenza_strutt_semplice, strutt_complessa.id as id_strutt_complessa, 
       strutt_complessa.descrizione as desc_strutt_complessa, strutt_complessa.data_scadenza as data_scadenza_strutt_complessa, strutt_complessa.stato as stato_strutt_complessa,  
       strutt_complessa.id_asl, strutt_complessa.anno
from dpat_strumento_calcolo_nominativi n 
join dpat_strutture_asl strutt_semplice on strutt_semplice.id = n.id_struttura and strutt_semplice.disabilitato = false
join dpat_strutture_asl strutt_complessa on strutt_complessa.id = strutt_semplice.id_padre and strutt_complessa.disabilitato = false 
join lookup_qualifiche lq on lq.code = id_lookup_qualifica 
join access_ users on users.user_id =  n.id_anagrafica_nominativo
join contact_ c on c.contact_id = users.contact_id
where n.trashed_Date is null and 
      (strutt_semplice.stato::text = ANY (string_to_array(stato_input, ',')) or stato_input is null) and
      (strutt_complessa.id = id_struttura_complessa_input or id_struttura_complessa_input is null) and 
      (strutt_complessa.descrizione ilike '%' || descrizione_struttura_complessa_input || '%' or descrizione_struttura_complessa_input is null) and
      (strutt_semplice.id = id_struttura_semplice_input or id_struttura_semplice_input is null) and 
      -- NEW per refactoring nucleo
      (lq.code = id_qualifica_input or id_qualifica_input = -1) and 
      ------ end new
      (strutt_semplice.descrizione ilike '%' || descrizione_struttura_semplice_input || '%' or descrizione_struttura_semplice_input is null) and
      strutt_complessa.id_strumento_calcolo in (select id 
						from dpat_strumento_calcolo 
						where (strutt_complessa.id_asl = asl_input or asl_input = -1) and 
						      (strutt_complessa.anno = anno_input or anno_input is null) 
						)
order by lq.livello_qualifiche_dpat


        LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.dpat_get_nominativi(integer, integer, text, integer, text, integer, text, integer)
  OWNER TO postgres;

 DROP FUNCTION public.get_nucleo_componenti(integer, integer, text);

--select * from public.get_nucleo_componenti(2022,-1,-1,'') 

CREATE OR REPLACE FUNCTION public.get_nucleo_componenti
(IN _anno integer DEFAULT NULL::integer, 
IN _id_qualifica integer DEFAULT -1::integer, 
IN _id_dipartimento integer DEFAULT -1::integer,
IN _id_struttura text DEFAULT ''::text
)
  RETURNS TABLE(id integer, nominativo text, id_struttura integer, nome_struttura text, id_qualifica integer, nome_qualifica text) AS
$BODY$
DECLARE
	lista_strutture text;
BEGIN
	lista_strutture := (select replace(replace(_id_struttura,'(',''''),')',''''));
	raise info 'lista: %', lista_strutture;
	raise info 'string to array input: %', string_to_array(lista_strutture,',');
	return query
		select d.id_anagrafica_nominativo, d.nominativo, d.id_struttura_semplice, concat_ws('->',d.desc_strutt_complessa,d.desc_strutt_semplice), _id_qualifica, d.qualifica
		from public.dpat_get_nominativi(_id_dipartimento::integer, _anno::integer, null::text,null::integer,null::text,null,null, _id_qualifica) d
		--where 1=1 and (_id_struttura = '' or string_to_array(d.id_Struttura_semplice::text,',') <@ string_to_array('8167,8365'::text,',')); 
		where 1=1 and (_id_struttura = '' or string_to_array(d.id_Struttura_semplice::text,',') <@ string_to_array(lista_strutture,',')); 

END;
$BODY$
  LANGUAGE plpgsql
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_nucleo_componenti(integer, integer, integer, text)
  OWNER TO postgres;

------------------------ dbi per bean Anagrafica --------------------------------
--DROP FUNCTION get_motivi_cu(integer,integer,text[])
CREATE OR REPLACE FUNCTION public.get_anagrafica_by_id(IN _riferimento_id integer, _riferimento_id_nome_tab text)
  RETURNS TABLE(ragione_sociale text, riferimento_id_nome_tab text, riferimento_id integer, partita_iva text, n_reg text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	 
select distinct m.ragione_sociale::text, m.riferimento_id_nome_tab, m.riferimento_id, m.partita_iva::text, m.n_reg::text 
from ricerche_anagrafiche_old_materializzata m
where m.riferimento_id = _riferimento_id and m.riferimento_id_nome_tab = _riferimento_id_nome_tab ;
END;
$BODY$
  LANGUAGE plpgsql
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_anagrafica_by_id(integer, text)
  OWNER TO postgres;

drop FUNCTION public.get_anagrafica_linee_by_id(integer, text, integer, integer);
drop FUNCTION public.get_anagrafica_linee_by_id(integer, text, integer);
CREATE OR REPLACE FUNCTION public.get_anagrafica_linee_by_id(
    IN _riferimento_id integer,
    IN _riferimento_id_nome_tab text)
  RETURNS TABLE(n_linea text, id_linea integer, norma text, macroarea text, aggregazione text, attivita text, codice_macroarea text, codice_aggregazione text, codice_attivita text) AS
$BODY$
DECLARE
BEGIN
		RETURN QUERY
		select distinct m.n_linea::text, m.id_linea, m.norma, m.macroarea, m.aggregazione, m.attivita, m.codice_macroarea, m.codice_aggregazione, m.codice_attivita 
		from ricerche_anagrafiche_old_materializzata m
		where m.riferimento_id = _riferimento_id and m.riferimento_id_nome_tab = _riferimento_id_nome_tab 
		--and ( _id_linea = -1 or m.id_linea = _id_linea)
		order by id_linea asc;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

-------------------------------- fine blocco ANAGRAFICA CU-----------------------
  
CREATE TABLE public.cu_log_json
(
  id serial,
  enteredby integer,
  entered timestamp without time zone DEFAULT now(),
  json_cu json
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cu_log_json
  OWNER TO postgres;
  
--  select * from public.get_motivi_cu(-1)

drop table  public.lookup_eventi_oggetti_cu;
DROP TABLE public.rel_oggetti_eventi_cu;

drop table linee_attivita_controlli_ufficiali_stab_soa;
drop table linee_attivita_controlli_ufficiali_backup;  

-- tabella minimal CU
CREATE TABLE public.controlli_ufficiali
(
  id serial,
  id_dipartimento integer,
  data_inizio timestamp without time zone,
  data_fine timestamp without time zone,
  data_chiusura timestamp without time zone,
  stato integer,
  ore text,
  entered timestamp default current_timestamp,
  enteredby integer,
  modified timestamp default current_timestamp,
  modifiedby integer,
  trashed_date timestamp,
  riferimento_id integer,
  riferimento_id_nome_tab text,
  id_tecnica integer,
  note text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.controlli_ufficiali
  OWNER TO postgres;


CREATE TABLE public.controlli_ufficiali_motivi
(
  id serial,
  id_controllo integer,
  id_motivo integer,
  entered timestamp default current_timestamp,
  enteredby integer,
  modified timestamp default current_timestamp,
  modifiedby integer,
  trashed_date timestamp
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.controlli_ufficiali_motivi
  OWNER TO postgres;


CREATE TABLE public.controlli_ufficiali_tipi_verifica
(
  id serial,
  id_controllo integer,
  id_tipo_verifica integer,
  entered timestamp default current_timestamp,
  enteredby integer,
  modified timestamp default current_timestamp,
  modifiedby integer,
  trashed_date timestamp
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.controlli_ufficiali_tipi_verifica
  OWNER TO postgres;


CREATE TABLE public.controlli_ufficiali_esami
(
  id serial,
  id_controllo integer,
  id_esame integer,
  entered timestamp default current_timestamp,
  enteredby integer,
  modified timestamp default current_timestamp,
  modifiedby integer,
  trashed_date timestamp
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.controlli_ufficiali_esami
  OWNER TO postgres;

CREATE TABLE public.controlli_per_conto_di
(
  id serial,
  id_controllo integer,
  id_percontodi integer,
  entered timestamp default current_timestamp,
  enteredby integer,
  modified timestamp default current_timestamp,
  modifiedby integer,
  trashed_date timestamp
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.controlli_per_conto_di
  OWNER TO postgres;

-- controlli_ufficiali
-- linee_attivita_controlli_ufficiali  
-- cu_nucleo  
-- controlli_ufficiali_motivi
-- controlli_ufficiali_tipi_verifica
-- controlli_ufficiali_esami
-- controlli_per_conto_di

drop FUNCTION public.cu_insert_oggetti(json, integer)
 ---------------------------------------------------------------------------------------------------------
ALTER TABLE public.linee_attivita_controlli_ufficiali DROP CONSTRAINT linee_attivita_controlli_ufficiali_id_controllo_ufficiale_fkey;
CREATE OR REPLACE FUNCTION public.cu_insert_anagrafica(IN _json_anagrafica json, IN _idutente integer)
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

	INSERT INTO controlli_ufficiali (enteredby, riferimento_id, riferimento_id_nome_tab) values (_idutente,riferimento_id,riferimento_tab)
	returning id into resultid;

	  return resultid;
	 		
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.cu_insert_anagrafica(json, integer)
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.cu_insert_tecnica(IN _json_tecnica json, _idcu integer)
  RETURNS integer AS
$BODY$	
BEGIN
	  -- effettuo l'update in quanto il record CU esiste gia'
	  UPDATE controlli_ufficiali set id_tecnica  = (_json_tecnica ->> 'id')::int where id = _idcu;
	  return 1;		
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.cu_insert_tecnica(json, integer)
  OWNER TO postgres;
  
CREATE OR REPLACE FUNCTION public.cu_insert_linee(IN _json_linea json, _idcu integer, _riferimento_nome_tab text)
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
		  INSERT INTO linee_attivita_controlli_ufficiali (id_controllo_ufficiale, id_linea_attivita, codice_linea, riferimento_nome_tab) values
		  (_idcu, (i->>'id')::integer, i->>'codice', _riferimento_nome_tab);
	  END LOOP;

    	 return 1;
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.cu_insert_linee(json, integer, text)
  OWNER TO postgres;  

drop FUNCTION public.cu_insert_esami(json, integer);
CREATE OR REPLACE FUNCTION public.cu_insert_esami(IN _json_datiesami json, _idcu integer, _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_datiesami) 
	  LOOP
	      RAISE NOTICE 'id %', i->>'id'; 
	      INSERT INTO controlli_ufficiali_esami (id_controllo, id_esame, enteredby) values
		 (_idcu, (i->>'id')::integer, _idutente);
	  END LOOP;

    	 return 1;
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.cu_insert_esami(json, integer, integer)
  OWNER TO postgres;

-- ispezioni con motivi
CREATE OR REPLACE FUNCTION public.cu_insert_motivi(IN _json_daticonmotivi json, _idcu integer, _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_daticonmotivi) 
	  LOOP
	      RAISE INFO 'id %', i->>'id';
	      INSERT INTO controlli_ufficiali_motivi (id_controllo, id_motivo, enteredby) values(_idcu,(i->>'id')::integer,_idutente);
			
	  END LOOP;

    	 return 1;
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
  
  CREATE OR REPLACE FUNCTION public.cu_insert_percontodi(IN _json_datipercontodi json, _idcu integer, _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_datipercontodi) 
	  LOOP
	      RAISE INFO 'id %', i->>'id';
	      INSERT INTO controlli_per_conto_di (id_controllo, id_percontodi, enteredby) values(_idcu,(i->>'id')::integer,_idutente);
			
	  END LOOP;

    	 return 1;
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
--tipi_di_verifica
 CREATE OR REPLACE FUNCTION public.cu_insert_tipiverifica(IN _json_daticontipiverifica json, _idcu integer, _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_daticontipiverifica) 
	  LOOP
	      RAISE INFO 'id %', i->>'id';
	      INSERT INTO controlli_ufficiali_tipi_verifica (id_controllo, id_tipo_verifica, enteredby) values(_idcu,(i->>'id')::integer,_idutente);
			
	  END LOOP;

    	 return 1;
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;



CREATE OR REPLACE FUNCTION public.cu_insert_nucleo(
    _json_daticonnucleo json,
    _idcu integer)
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
	
		 INSERT INTO cu_nucleo (id_controllo_ufficiale, id_componente, enabled) values (_idcu, (i->>'id')::integer,true);
	  END LOOP;


    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cu_insert_nucleo(json, integer)
  OWNER TO postgres;

  CREATE EXTENSION unaccent;


  
  -- gestione fasi lavorazione
  CREATE TABLE public.controlli_fase_lavorazione
(
  id serial,
  id_controllo integer,
  id_fase_lavorazione integer,
  entered timestamp default current_timestamp,
  enteredby integer,
  modified timestamp default current_timestamp,
  modifiedby integer,
  trashed_date timestamp
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.controlli_fase_lavorazione
  OWNER TO postgres;

 CREATE OR REPLACE FUNCTION public.cu_insert_fasi_lavorazione(IN _json_datifasilavorazione json, _idcu integer, _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_datifasilavorazione) 
	  LOOP
	      RAISE INFO 'id %', i->>'id';
	      INSERT INTO controlli_fase_lavorazione (id_controllo, id_fase_lavorazione, enteredby) values(_idcu,(i->>'id')::integer,_idutente);
			
	  END LOOP;

    	 return 1;
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;

  -- Function: public.cu_dettaglio_globale(integer)
-- Function: public.cu_dettaglio_globale(integer)

-- DROP FUNCTION public.cu_dettaglio_globale(integer);

CREATE OR REPLACE FUNCTION public.cu_dettaglio_globale(_idcontrollo integer)
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
	nucleo json;
	esami json;
	tipiverifica json;
	percontodi json;
	campiservizio json;
	fasilavorazione json;
	fascicolo json;
	matrici json;
	
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
	   
	id_tecnica := (select c.id_tecnica  from controlli_ufficiali c where id = _idcontrollo); 
	anno_controllo := (select date_part('year',data_inizio)::integer from controlli_ufficiali where id = _idcontrollo);
	rifid := (select riferimento_id from controlli_ufficiali where id = _idcontrollo);
	id_dipartimento := (select c.id_dipartimento from controlli_ufficiali c where id = _idcontrollo);
	rifnometab := (select c.riferimento_id_nome_tab from controlli_ufficiali c where id = _idcontrollo);
	--tipologia_operatore := (select distinct m.tipologia_operatore from ricerche_anagrafiche_old_materializzata m where m.riferimento_id = rifid and m.riferimento_id_nome_tab = rifnometab );
	lineacontrollo := (select codice_linea from linee_attivita_controlli_ufficiali  where  id_controllo_ufficiale  = _idcontrollo and trashed_date is null);

	path_linea := (select path_descrizione from ml8_linee_attivita_nuove_materializzata where codice = lineacontrollo and livello = 3 limit 1);
	
	-- costruzione dei json
	tecnicacu := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, description as descrizione from lookup_tipo_controllo where code = id_tecnica 
							union select 'id' as nome,  id_tecnica::text) a); 
        --tecnicacu := (select json_object_agg('Tecnica', tecnicacu));
	raise info 'json tecnica ricostruito%', tecnicacu;
	daticu := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from controlli_ufficiali where id = _idcontrollo
								  union select 'dataInizio' as nome,  data_inizio::text from controlli_ufficiali where id = _idcontrollo 
								  union select 'dataFine' as nome,  data_fine::text from controlli_ufficiali where id = _idcontrollo 
								  union select 'oraInizio' as nome,  coalesce(ore::text,'') from controlli_ufficiali where id = _idcontrollo 
								  union select 'oraFine' as nome,  coalesce(ora_fine::text,'') from controlli_ufficiali where id = _idcontrollo 
								  union select 'conclusa' as nome,  coalesce(conclusa_verifica::text,'') from controlli_ufficiali where id = _idcontrollo 
								  ) b);
	--daticu := (select json_object_agg('Dati', daticu));
	raise info 'json daticu ricostruito%', daticu;
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'stato' as nome, l.description as descrizione 
									 from controlli_ufficiali c join lookup_stato_cu l on l.code = c.stato 
									 where id = _idcontrollo
								  union select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from controlli_ufficiali c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where id = _idcontrollo 
								  union select 'dataInserimento' as nome, entered::text as descrizione from controlli_ufficiali where id = _idcontrollo
								  union select 'idControllo' as nome, id::text as descrizione from controlli_ufficiali where id = _idcontrollo 
								  ) b);

	anagrafica := (select json_object_agg(nome,descrizione) from (select 'partitaIva' as nome, trim(partita_iva) as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab
								  union select 'riferimentoId' as nome,  rifid::text
								  union select 'riferimentoIdNomeTab' as nome,  rifnometab::text 
								  union select 'ragioneSociale' as nome, ragione_sociale as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab) c);
	--anagrafica := (select json_object_agg('Anagrafica', anagrafica));
	raise info 'json anagrafica ricostruito%', anagrafica;

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, enteredby as descrizione from controlli_ufficiali where id = _idcontrollo) d); 
	--utente := (select json_object_agg('Utente', utente));
	raise info 'json utente ricostruito%', utente;

	dipartimento := (select json_object_agg(nome,descrizione) from (select 'nome' as nome,  description as descrizione from lookup_site_id where code= id_dipartimento
								union select 'id' as nome, id_dipartimento::text) e); 
	--asl := (select json_object_agg('Asl', asl));
	raise info 'json asl ricostruito%', dipartimento;
				  
	--"Linee":[{"codice":"MS.020-MS.020.500-852IT3A401","nome":"path completo","id":"192439"}],
	linee := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select lineacontrollo as codice, path_linea as nome, (select id_linea_attivita from linee_attivita_controlli_ufficiali  where trashed_date is null and id_controllo_ufficiale = _idcontrollo) as id 
										from controlli_ufficiali where id = _idcontrollo) t);
	--linee := (select json_object_agg('Linee', linee));
	raise info 'json linee ricostruito%', linee;


	nucleo := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select d.nominativo as nominativo, c.id_componente as id, d.qualifica as qualifica, concat_ws('->', d.desc_strutt_complessa, d.desc_strutt_semplice) as struttura
										from cu_nucleo c
										left join public.dpat_get_nominativi(-1,anno_controllo,null,null,null,null,null,-1) d on d.id_anagrafica_nominativo = c.id_componente
										left join access_ ac on ac.user_id = c.id_componente -- è giusto?
										where id_controllo_ufficiale = _idcontrollo) t);

	--nucleo := (select json_object_agg('Nucleo', nucleo));
	raise info 'json nucleo ricostruito %', nucleo;


										
	tipiverifica := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from controlli_ufficiali_tipi_verifica c
										join lookup_tipi_verifica l on l.code = c.id_tipo_verifica
										where c.id_controllo = _idcontrollo) t);
	--tipiverifica := (select json_object_agg('TipiVerifica', tipiverifica));
	raise info 'json esami ricostruito %', tipiverifica;
	
	percontodi := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select o.descrizione_lunga as nome, o.id as id 
										from controlli_per_conto_di c
										join oia_nodo o on o.id = c.id_percontodi
										where c.id_controllo = _idcontrollo) t);

	fasilavorazione := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select o.tipo_quadro as "tipoQuadro", 
											 o.id as id, 
											 o.tipo_impianto as "tipoImpianto", 
											 o.punti_emissione as "puntiEmissione", 
											 o.impianti_abbattimento as "impiantiAbbattimento",
											 o.fasi_lavorazione as "fasiLavorazione",
											 o.inquinanti as "inquinanti"
										from controlli_fase_lavorazione c
										join fasi_lavorazione o on o.id = c.id_fase_lavorazione
										where c.trashed_date is null and c.id_controllo = _idcontrollo) t);

										
	fascicolo := (select json_object_agg(nome,descrizione) from (select 'numero' as nome,  numero as descrizione from fascicoli  where id in (select id_fascicolo from controlli_ufficiali where id = _idcontrollo and trashed_date is null) 
								union select 'id' as nome, id_fascicolo::text as descrizione from controlli_ufficiali where id = _idcontrollo) e); 

	matrici := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id, c.conclusa
										from controlli_ufficiali_matrici c
										join lookup_matrice_controlli l on l.code = c.id_matrice
										where c.id_controllo = _idcontrollo) t);

			
	--percontodi := (select json_object_agg('PerContoDi', percontodi));
	raise info 'json esami ricostruito %', percontodi;
	
	
	--raise info 'cosa succede %', (select concat_ws(' ', '"Tecnica":', tecnicacu, ',"Dati":', daticu, ',"Anagrafica":', anagrafica, ',"Utente":',utente, ',"Asl":', asl, ',"Linee":', linee, ',"Nucleo":', nucleo, ',"Motivi":', motivi)); --- provare a concatenare senza passare prt il json_object_agg
	--raise info 'json da convertire %', unaccent(concat('{',
	--(select concat_ws(' ', '"Tecnica":', tecnicacu, ',"Dati":', daticu, ',"Anagrafica":', anagrafica, ',"Utente":',utente, ',"Asl":', asl, ',"Linee":', linee, ',"Nucleo":', nucleo, ',"Motivi":', motivi)),'}'))::json;

	if (tecnicacu ->> 'id')::int = 2 then
		-- RECUPERO I MOTIVI E GLI ESAMI RICHIESTI
		motivi := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from controlli_ufficiali_motivi c
										join lookup_motivi l on l.code = c.id_motivo 
										where c.id_controllo = _idcontrollo) t);
		--motivi := (select json_object_agg('Motivi', motivi));
		raise info 'json motivi ricostruito %', motivi;

		esami := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from controlli_ufficiali_esami c
										join lookup_esami l on l.code = c.id_esame 
										where c.id_controllo = _idcontrollo) t);
		--esami := (select json_object_agg('Esami', esami));
		raise info 'json esami ricostruito %', esami;

		finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Tecnica":', tecnicacu, ',"Dati":', daticu, ',"Anagrafica":', anagrafica, ',"Utente":',utente, ',"Dipartimento":', dipartimento, ',"Linee":', linee, ',"Nucleo":', nucleo, 
		',"Esami":', esami,
		',"PerContoDi":', percontodi,
		',"TipiVerifica":', tipiverifica,
		',"Fascicolo":', fascicolo,
		',"Matrici":', matrici,
		',"CampiServizio":', campiServizio,
		--',"FasiLavorazione":', coalesce(fasilavorazione,to_json('[]'::text)),
		',"FasiLavorazione":', coalesce(fasilavorazione,array_to_json('{}'::int[])),
		',"Motivi":', motivi)),'}'))::json);

		
	-- se si tratta di AIA ordinaria
	elsif (tecnicacu ->> 'id')::int = 1 then
		-- RECUPERO SOLO GLI ESAMI
		esami := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from controlli_ufficiali_esami c
										join lookup_esami l on l.code = c.id_esame 
										where c.id_controllo = _idcontrollo) t);
		--esami := (select json_object_agg('Esami', esami));
		raise info 'json esami ricostruito %', esami;

		finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Tecnica":', tecnicacu, ',"Dati":', daticu, ',"Anagrafica":', anagrafica, ',"Utente":',utente, ',"Dipartimento":', dipartimento, ',"Linee":', linee, ',"Nucleo":', nucleo, 
		',"Esami":', esami,
		',"PerContoDi":', percontodi,
		',"Fascicolo":', fascicolo,
		',"Matrici":', matrici,
		',"CampiServizio":', campiServizio,
		--',"FasiLavorazione":', coalesce(fasilavorazione,to_json('[]'::text)),
		',"FasiLavorazione":', coalesce(fasilavorazione,array_to_json('{}'::int[])),
		',"TipiVerifica":', tipiverifica)),'}'))::json);
		
	else
		-- do nothing per altre tecniche
		RAISE INFO 'la tecnica non prevede aggiunte di campi';
		finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Tecnica":', tecnicacu, ',"Dati":', daticu, ',"Anagrafica":', anagrafica, ',"Utente":',utente, ',"Dipartimento":', dipartimento, ',"Linee":', linee, ',"Nucleo":', nucleo, 
		',"PerContoDi":', percontodi,
		',"Fascicolo":', fascicolo,
		',"Matrici":', matrici,
		',"CampiServizio":', campiServizio,
		--',"FasiLavorazione":', coalesce(fasilavorazione,to_json('[]'::text)),
		',"FasiLavorazione":', coalesce(fasilavorazione,array_to_json('{}'::int[])),
		',"TipiVerifica":', tipiverifica)),'}'))::json);
	end if;
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cu_dettaglio_globale(integer)
  OWNER TO postgres;


  
  
-- svuota cu
delete from controlli_ufficiali ;
delete from controlli_ufficiali_esami ;
delete from controlli_per_conto_di 
delete from controlli_ufficiali_motivi ;
delete from controlli_ufficiali_motivi_ispezione;
delete from controlli_ufficiali_tipi_verifica;
delete from non_conformita;
delete from campioni;
delete from controlli_fase_lavorazione;
delete from analiti_campioni;  
delete from matrici_campioni;      

-- Function: public.cu_insert_globale(json)

-- DROP FUNCTION public.cu_insert_globale(json);

CREATE OR REPLACE FUNCTION public.cu_insert_globale(_json_dati json)
  RETURNS integer AS
$BODY$	
DECLARE
	anagrafica json; 
	utenti json;
	tecnicacu json;
	lineacu json;
	oggetticu json;
	motivicu json;
	nucleo json;
	percontodi json;
	esami json;
	tipiverifica json;
	datigenerici json; -- qui dovrebbero essere incluse anche le note
	dipartimento json;
	fasilavorazione json;
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
       
        nucleo :=  _json_dati ->'Nucleo';
	RAISE INFO 'json nucleo %',nucleo;

	percontodi :=  _json_dati ->'PerContoDi';
	RAISE INFO 'json per conto di %',percontodi;
	
	datigenerici := _json_dati ->'Dati';
	RAISE INFO 'json datigenerici %',datigenerici;

	dipartimento := _json_dati -> 'Dipartimento';
	RAISE INFO 'json dipartimento %',dipartimento;

	fasilavorazione := _json_dati -> 'FasiLavorazione';
	RAISE INFO 'json dipartimento %',fasilavorazione;

	fascicolo := _json_dati -> 'Fascicolo';
	RAISE INFO 'json fascicolo %',fascicolo;

	matrici := _json_dati -> 'Matrici';
	RAISE INFO 'json matrici %',matrici;

	-- STEP 0: INSERIAMO IL RECORD JSON PER LOGO
	INSERT INTO cu_log_json(enteredby, json_cu) values(idutente,_json_dati);
	
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: INSERIAMO IL RECORD IN TICKET PER OTTENERE IL TICKETID
	idcontrollo := (SELECT * from public.cu_insert_anagrafica(anagrafica, idutente));
	-- STEP 2: INSERIAMO LA TECNICA
	output := (SELECT * from public.cu_insert_tecnica(tecnicacu, idcontrollo));

	raise info 'stampaaaaaaa %', length(datigenerici ->> 'dataFine');
	-- STEP 3: INSERIAMO I DATI DEL CU + linee
	update controlli_ufficiali set stato=1, note = (datigenerici ->> 'note'), id_dipartimento = (dipartimento ->> 'id')::int, 
	data_inizio  = (datigenerici ->> 'dataInizio')::timestamp without time zone, 
	data_fine = (case when length(datigenerici ->> 'dataFine') > 0 then (datigenerici ->> 'dataFine')::timestamp without time zone else null end), 
	ore = (datigenerici ->> 'oraInizio'), 
	ora_fine = (datigenerici ->> 'oraFine')
	where id = idcontrollo;
	output := (SELECT * from public.cu_insert_linee(lineacu, idcontrollo, anagrafica ->> 'riferimentoIdNomeTab'));
	
	-- se si tratta di AIA straordinaria
	if (tecnicacu ->> 'id')::int = 2 then
		-- STEP 4: INSERIAMO I MOTIVI E GLI ESAMI RICHIESTI
		motivicu :=  _json_dati ->'Motivi';
		RAISE INFO 'json motivicu %',motivicu;
		output :=(SELECT * from public.cu_insert_motivi(motivicu, idcontrollo,idutente));	
		output :=(SELECT * from public.cu_insert_esami(esami, idcontrollo, idutente));	
	-- se si tratta di AIA ordinaria
	elsif (tecnicacu ->> 'id')::int = 1 then
		--STEP 4: INSERIAMO GLI ESAMI RICHIESTI
		output :=(SELECT * from public.cu_insert_esami(esami, idcontrollo, idutente));
	else
		-- do nothing per altre tecniche
		RAISE INFO 'la tecnica non prevede aggiunte di campi';
	end if;

	-- STEP 5: INSERIAMO I tipi di verifica comuni a tutte e 3 le tecniche
	output := (SELECT * from public.cu_insert_tipiverifica(tipiverifica, idcontrollo, idutente));
	
	-- STEP 6: INSERIAMO I COMPONENTI DEL NUCLEO
	output := (SELECT * FROM public.cu_insert_nucleo(nucleo,idcontrollo));

	-- STEP 7: INSERIAMO I percontodi
	output := (SELECT * FROM public.cu_insert_percontodi(percontodi,idcontrollo,idutente));

	-- STEP 8: INSERIAMO le fasi
	output := (SELECT * FROM public.cu_insert_fasi_lavorazione(fasilavorazione,idcontrollo,idutente));

        -- STEP 9: INSERIAMO i fascicoli
	update controlli_ufficiali set id_fascicolo = (fascicolo ->>'id')::integer where id = idcontrollo;

	-- STEP 10: INSERIAMO la matrice
	output :=(SELECT * from public.cu_insert_matrici(matrici, idcontrollo, idutente));

    	 return idcontrollo;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cu_insert_globale(json)
  OWNER TO postgres;


  


  
  drop FUNCTION public.get_nucleo_qualifiche(integer);
  

CREATE TABLE public.lookup_stato_cu
(
  code serial,
  description character varying(500) NOT NULL,
  default_item boolean DEFAULT false,
  level integer DEFAULT 0,
  enabled boolean DEFAULT true
 )
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lookup_stato_cu
  OWNER TO postgres;

  insert into lookup_stato_cu(code, description) values (1,'Aperto');
  insert into lookup_stato_cu(code, description) values (2,'Chiuso');
  insert into lookup_stato_cu(code, description) values (3,'Riaperto');
  
  CREATE OR REPLACE FUNCTION public.cu_lista_globale(IN _id_fascicolo integer)
   RETURNS json  AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select id as "idControllo", l.description as "stato", c.data_inizio as "dataInizio", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from  controlli_ufficiali c
										join access a on a.user_id = c.enteredby 
										join contact co on co.contact_id = a.contact_id
									        join lookup_stato_cu l on l.code = c.stato 
										where c.id_fascicolo =  _id_fascicolo
										order by c.data_inizio desc) t);


	return output;
	
END;
$BODY$
  LANGUAGE plpgsql
  COST 100;

  
  CREATE OR REPLACE FUNCTION public.cu_lista_globale(IN _riferimento_id integer, _riferimento_id_nome_tab text)
   RETURNS json  AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select id as "idControllo", s.description as "stato", l.description as "tecnica", data_inizio as "dataInizio", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from controlli_ufficiali c 
										join lookup_stato_cu s on s.code = c.stato
										join lookup_tipo_controllo l on l.code=c.id_tecnica
										join access a on a.user_id = c.enteredby 
										join contact co on co.contact_id = a.contact_id
										where c.riferimento_id = _riferimento_id and c.riferimento_id_nome_tab = _riferimento_id_nome_tab
										order by c.data_inizio desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql
  COST 100;

alter table controlli_ufficiali  add column id_fascicolo integer;
alter table controlli_ufficiali  add column ora_fine text;

---- NEW

CREATE TABLE public.lookup_matrice_controlli
(
  code serial,
  description character varying(300) NOT NULL,
  short_description character varying(300),
  default_item boolean DEFAULT false,
  level integer DEFAULT 0,
  enabled boolean DEFAULT true
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lookup_matrice_controlli
  OWNER TO postgres;

insert into lookup_matrice_controlli(description, short_description) values('Acque superficiali','Acque superficiali');
insert into lookup_matrice_controlli(description, short_description) values('Acque sotterranee','Acque sotterranee');
insert into lookup_matrice_controlli(description, short_description) values('Acque reflue','Acque reflue');
insert into lookup_matrice_controlli(description, short_description) values('Rifiuti in uscita dall''impianto','Rifiuti in uscita dall''impianto');
insert into lookup_matrice_controlli(description, short_description) values('Rumore','Rumore');
insert into lookup_matrice_controlli(description, short_description) values('Elettromagnetismo','Elettromagnetismo');
insert into lookup_matrice_controlli(description, short_description) values('Emissione in atmosfera convogliate','Emissione in atmosfera convogliate');
insert into lookup_matrice_controlli(description, short_description) values('Emissioni diffuse','Emissioni diffuse');


CREATE OR REPLACE FUNCTION public.get_matrici_cu()
  RETURNS TABLE(code integer, matrice text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select t.code, t.description::text
	from lookup_matrice_controlli t 
	where t.enabled
	order by t.description;
END;
$BODY$
  LANGUAGE plpgsql
  COST 100;

--select * from public.get_matrici_cu()

CREATE OR REPLACE FUNCTION public.cu_insert_matrici(IN _json_datimatrici json, _idcu integer, _idutente integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
BEGIN
	  FOR i IN SELECT * FROM json_array_elements(_json_datimatrici) 
	  LOOP
	      RAISE NOTICE 'id %', i->>'id'; 
	      INSERT INTO controlli_ufficiali_matrici (id_controllo, id_matrice, conclusa, enteredby) values
		 (_idcu, (i->>'id')::integer, (i->>'conclusa')::text, _idutente);
	  END LOOP;

    	 return 1;
END;
$BODY$
   LANGUAGE plpgsql VOLATILE 
  COST 100;
ALTER FUNCTION public.cu_insert_matrici(json, integer, integer)
  OWNER TO postgres;
  

  CREATE TABLE public.controlli_ufficiali_matrici
(
  id serial,
  id_controllo integer,
  id_matrice integer,
  conclusa text,
  entered timestamp default current_timestamp,
  enteredby integer,
  modified timestamp default current_timestamp,
  modifiedby integer,
  trashed_date timestamp
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.controlli_ufficiali_matrici
  OWNER TO postgres;
  