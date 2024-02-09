drop table rel_macrocategoria_programma_campionamento;
drop table public.rel_programma_categoria_campionamento;
drop table lookup_macrocategoria_programmi_campionamento;
drop table lookup_programmi_campionamento;
drop table lookup_categoria_merceologica;
drop table campione_categoria_merceologica;
drop FUNCTION public.get_programmi_campionamento();
drop function campione_insert_categoria_merceologica(json, integer);

-- backup e restore da .dev di programmi_campionamento_categorie_merceologiche
 pg_dump -h 127.0.0.1 -Upostgres -t programmi_campionamento_categorie_merceologiche gisarpac | psql -h 131.1.255.97 gisa -Upostgres

CREATE OR REPLACE FUNCTION public.get_programmi_campionamento_categorie_merceologiche()
  RETURNS TABLE(code integer, categoria_merceologica text, nome_programma_campionamento text, nome_programma_campionamento_macrocategoria text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select id, p.categoria_merceologica, p.programma_campionamento,  p.macrocategoria 
	from programmi_campionamento_categorie_merceologiche p;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_programmi_campionamento_categorie_merceologiche()
  OWNER TO postgres;
  

CREATE TABLE public.campione_programma_campionamento
(
  id serial,
  id_campione integer,
  id_programma_campionamento integer,
  enabled boolean default true
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.campione_programma_campionamento
  OWNER TO postgres;

CREATE TABLE public.lookup_tipo_attivita
(
  code serial,
  tipo character varying NOT NULL,
  default_item boolean DEFAULT false,
  level integer DEFAULT 0,
  enabled boolean DEFAULT true
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lookup_tipo_attivita
  OWNER TO postgres;

insert into lookup_tipo_attivita(tipo) values ('Monitoraggio');
insert into lookup_tipo_attivita(tipo) values ('Controllo');

CREATE OR REPLACE FUNCTION public.get_tipi_attivita()
  RETURNS TABLE(code integer, tipo text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select m.code, m.tipo::text
	from lookup_tipo_attivita m
	where m.enabled
	order by m.tipo;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_tipi_attivita()
  OWNER TO postgres;

--select * from public.get_tipi_attivita()
DROP FUNCTION public.campione_insert_analiti(json, integer);

CREATE OR REPLACE FUNCTION public.campione_insert_programma_campionamento(
    _json_dati json,
    _idcampione integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json;
BEGIN
	FOR i IN SELECT * FROM json_array_elements(_json_dati)  
		LOOP
			RAISE NOTICE 'id %', i->>'id';
			INSERT INTO  campione_programma_campionamento (id_campione, id_programma_campionamento) values (_idcampione, (i ->> 'id')::integer);
		END LOOP;		

	 return 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_insert_programma_campionamento(json, integer)
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.campione_insert(
    _json_anagrafica json,
    _idutente integer)
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

alter table campioni add column id_tipo_attivita integer;

CREATE OR REPLACE FUNCTION public.campione_insert_analiti(
    _json_dati json,
    _idcampione integer)
  RETURNS integer AS
$BODY$	
DECLARE
	i json;
BEGIN
	FOR i IN SELECT * FROM json_array_elements(_json_dati)  
		LOOP
			RAISE NOTICE 'id %', i->>'id';
			INSERT INTO  campione_analiti (id_campione, analiti_id) values (_idcampione, (i ->> 'id')::integer);
		END LOOP;		

	 return 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_insert_analiti(json, integer)
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.campione_insert_globale(_json_dati json)
  RETURNS integer AS
$BODY$	
DECLARE
	datigiornataispettiva json; 
	utente json;
	laboratorio json;
	numeroverbale json;
	programmacampionamento json;
	dati json;
	analiti json;
	gruppoispettivo json;
	tipoattivita json;
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

	laboratorio :=  _json_dati ->'Laboratorio';
	RAISE INFO 'json Laboratorio %',laboratorio;

	analiti :=  _json_dati ->'TipoAnalisi';
	RAISE INFO 'json Analiti %',analiti;

	tipoattivita :=  _json_dati ->'TipoAttivita';
	RAISE INFO 'json TipoAttivita %',tipoattivita;
	
	numeroverbale :=  _json_dati ->'NumeroVerbale';
	RAISE INFO 'json numeroverbale %',numeroverbale;

	programmacampionamento :=  _json_dati ->'ProgrammaCampionamentoCategoriaMerceologica';
	RAISE INFO 'json ProgrammaCampionamento %',programmacampionamento;

	gruppoispettivo :=  _json_dati ->'GruppoIspettivo';
	RAISE INFO 'json gruppoispettivo %',gruppoispettivo;
	
	-- STEP 0: INSERIAMO IL RECORD JSON PER LOG
	INSERT INTO giornate_ispettive_log_json(enteredby, json_cu) values(idutente,_json_dati);
	
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: INSERIAMO IL RECORD IN CAMPIONI
	idcampione := (SELECT * from public.campione_insert(dati, idutente));
	-- STEP 3: INSERIAMO GLI ANALITI
	output := (SELECT * from public.campione_insert_analiti(analiti, idcampione));
	-- STEP 4: INSERIAMO IL PROGRAMMA CAMPIONAMENTO
	output := (SELECT * from public.campione_insert_programma_campionamento(programmacampionamento, idcampione));
	-- STEP 4: INSERIAMO IL GRUPPO ISPETTIVO
	output := (SELECT * from public.campione_insert_gruppo_ispettivo(gruppoispettivo, idcampione));
	-- STEP 5: INSERIAMO GLI ALTRI DATI DEL CAMPIONE
	update campioni set 
	id_laboratorio= (laboratorio->>'id')::int, 
	--id_motivazione = (motivazione ->> 'id')::integer, 
	num_verbale=lpad(id::text, 6, '0'),
	id_tipo_attivita = (tipoattivita ->> 'id')::integer,
	id_giornata_ispettiva = (datigiornataispettiva ->> 'idGiornataIspettiva')::integer  where id = idcampione;
	
    	 return idcampione;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_insert_globale(json)
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.campione_dettaglio_globale(_idcampione integer)
  RETURNS json AS
$BODY$	
DECLARE
	campiservizio json;
	laboratorio json;
	tipoattivita json;
	numeroverbale json;
	finale json;
	utente json;
	programmacampionamento json;
	categoriamerceologica json;
	dati json;
	datigiornataispettiva json;
	gruppoispettivo json;
	analiti json;
	id_dipartimento integer;

BEGIN
	-- chiamo la dbi puntuale per ogni blocco
	-- STEP 1: recuperiamo i campi del campione
	laboratorio := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, (l.description)::text as descrizione from lookup_destinazione_campione l join campioni c on c.id_laboratorio= l.code
							               union select 'id' as nome,  (l.code)::text from  lookup_destinazione_campione l join campioni c on c.id_laboratorio= l.code) a);
	tipoattivita := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, l.tipo as descrizione from campioni c join lookup_tipo_attivita l on l.code = c.id_tipo_attivita where id= _idcampione
						union
						select 'id' as nome, l.code::text as id from campioni c join lookup_tipo_attivita l on l.code = c.id_tipo_attivita where id= _idcampione) a);				             

	--numeroverbale := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, num_verbale as descrizione from campioni where id = _idcampione
	--						               union select 'id' as nome,  1::text) a);				             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from campioni where id = _idcampione) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, 
	                                                        note as descrizione 
	                                                        from campioni where id = _idcampione
							        union select 'dataPrelievo' as nome, (data_prelievo)::text  
							        from campioni where id = _idcampione
							        union select 'numeroVerbale' as nome, num_verbale
							        from campioni where id = _idcampione
							        ) a);	
	
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
	-- STEP 3: recuperiamo i campi programmacontrollo
	programmacampionamento := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select c.categoria_merceologica as nome,
							     c.programma_campionamento as "nomeProgrammaCampionamento", 
							     c.id as id, 
							     c.macrocategoria as "nomeProgrammaCampionamentoMacrocategoria" 
							     from campione_programma_campionamento cm
							     join programmi_campionamento_categorie_merceologiche c on c.id = cm.id_programma_campionamento
							     where id_campione = _idcampione and cm.enabled) t);
	-- STEP 4: recuperiamo i campi analiti
	analiti := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select a.descrizione_analita_livello_uno::text as livello1, 
										 a.descrizione_analita_livello_due::text as livello2, 
										 a.descrizione_analita_livello_tre::text as livello3, a.progressivo as id 
										         from campione_analiti ca
										         join analiti a on a.progressivo = ca.analiti_id
										         where id_campione = _idcampione) t);

										         
	--STEP 5: gruppo ispettivo
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
		(select concat_ws(' ', '"Dati":', dati, ',"DatiGiornataIspettiva":', datigiornataispettiva, 
		--',"NumeroVerbale":', numeroverbale, 
		',"Utente":',utente, 
		',"ProgrammaCampionamentoCategoriaMerceologica":', programmacampionamento,
		',"Laboratorio":', laboratorio,
		',"TipoAnalisi":', analiti,
		',"GruppoIspettivo":', gruppoispettivo,
		',"CampiServizio":', campiServizio,
		',"TipoAttivita":', tipoattivita)),'}'))::json);
		
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_dettaglio_globale(integer)
  OWNER TO postgres;

-- Function: public.campioni_lista_globale(integer)

-- DROP FUNCTION public.campioni_lista_globale(integer);

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
										and c.trashed_date is null
										order by c.data_prelievo desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campioni_lista_globale(integer)
  OWNER TO postgres;

-- da gisa campania
create table analiti_arpac as (
SELECT ROW_NUMBER() OVER(ORDER BY m.nome asc, m2.nome asc, m3.nome asc) as progressivo, m.nome as descrizione_analita_livello_uno, m2.nome descrizione_analita_livello_due, 
m3.nome as descrizione_analita_livello_tre,
m.codice_esame as codice_analita_livello_uno, m2.codice_esame as codice_analita_livello_due, 
m3.codice_esame as codice_analita_livello_tre
from analiti m
join analiti m2 on m2.id_padre= m.analiti_id and m.id_padre=-1
left join analiti m3 on m3.id_padre = m2.analiti_id and m3.enabled and m3.nuova_gestione
where 
 --m.livello=0 --and m2.livello=1 
 m.enabled and m2.enabled and 
m.nuova_gestione and m2.nuova_gestione 
order by m.nome asc )

--drop table analiti
pg_dump -h 127.0.0.1 -Upostgres -t analiti_arpac gisa | psql -h 131.1.255.97 gisa -Upostgres

alter table analiti_arpac RENAME to analiti;
alter table analiti_Campioni rename to campione_analiti;

alter table analiti add column enabled boolean default true;

CREATE OR REPLACE FUNCTION public.get_tipi_analisi()
  RETURNS TABLE(id integer, livello1 text, livello2 text, livello3 text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select m.progressivo::integer, m.descrizione_analita_livello_uno::text, m.descrizione_analita_livello_due::text, m.descrizione_analita_livello_tre::text
	from analiti m
	where m.enabled
	order by m.descrizione_analita_livello_uno;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_tipi_analisi()
  OWNER TO postgres;

  --select * from get_tipi_analisi()
--------------->  modifiche post collaudo loredana
alter TABLE  fascicoli_ispettivi  add column note_hd text;
CREATE OR REPLACE FUNCTION public.fascicolo_ispettivo_delete(
    _id_fascicolo integer,
    _note_elimina text, 
    _id_utente integer)
  RETURNS TEXT AS
$BODY$	
DECLARE
	conta integer;
	msg text;
BEGIN
	conta := (select count(*) from giornate_ispettive where trashed_date is null and id_fascicolo_ispettivo  = _id_fascicolo);
	if conta > 0 then
		msg = 'NON E'' POSSIBILE CANCELLARE IL FASCICOLO IN QUANTO SONO PRESENTI GIORNATE ISPETTIVE.';
	else
		update fascicoli_ispettivi set modifiedby = _id_utente, note_hd=concat_ws('***',note_hd,'Cancellazione fascicolo avvenuta tramite dbi.'), trashed_date=current_timestamp where id = _id_fascicolo;
		msg = 'OK. Il fascicolo ispettivo e'' stato cancellato.';
	end if;

	return msg;	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicolo_ispettivo_delete(integer, text, integer)
  OWNER TO postgres;
  
-------------- new post collaudo
-- backup tabella programmi_campionamento_categorie_merceologiche da .dev
  update programmi_campionamento_categorie_merceologiche set categoria_merceologica = '-' where id=15;
alter table programmi_campionamento_categorie_merceologiche drop COLUMN id_categoria_merceologica;
alter table programmi_campionamento_categorie_merceologiche drop COLUMN id_programma_campionamento;
alter table programmi_campionamento_categorie_merceologiche drop COLUMN id_macrocategoria;
update programmi_campionamento_categorie_merceologiche set categoria_merceologica  = 'Nessuna categoria merceologica/matrice associata' where id in (6,15);

  ------------------------>
  insert into lookup_tipi_verifica(code, description) values(10,'Altro');
insert into lookup_matrice_controlli (description) values('Altro'); -- verifica id univoci
alter table lookup_tipi_verifica add column gestione_altro boolean default false;

CREATE OR REPLACE FUNCTION public.get_tipi_verifica(matrici text)
 RETURNS table (code integer, tipo_verifica text , gestione_altro boolean) AS
$BODY$
DECLARE
	result int[];
BEGIN
	-- execute query 1;
	result := (select * from get_tipi_verifica_ids(matrici));
	raise info '%', result;
	return query 
	select t.code, t.description::text, t.gestione_altro from get_items(result) t;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION public.get_tipi_verifica_ids(matrici text)
 -- RETURNS TABLE(code integer, tipo_verifica text, gestione_altro boolean) AS
 RETURNS int [] AS 
$BODY$
DECLARE
  where_condition text;
  matrici_new integer[];

 where_condition_1 text;
 where_condition_2 text;
 where_condition_3 text;
 where_condition_4 text;
 where_condition_5 text;
 where_condition_6 text;
 where_finale text;
 
BEGIN
	matrici_new := matrici::int[];
	raise info 'matrici convertita%', matrici_new;
	raise info 'test: %', matrici_new && ARRAY[1,2,3];
	where_condition_1 ='';
	where_condition_2 ='';
	where_condition_3 ='';
	where_condition_4 ='';
	where_condition_5 ='';
	where_condition_6 ='';
	where_finale = '';

	if( matrici_new && '{1,2,3}'::int[]) then 
		where_condition_1= '3,';		--emissioni in acqua;
	end if;
	if ( matrici_new && '{7,8}'::int[]) then
		where_condition_2 = '2,';--emissioni in aria
	end if;
	if ( matrici_new && '{4}'::int[]) then
		where_condition_3 = '4,';  --Rifiuti 3.2.5
	end if;
	if ( matrici_new && '{5}'::int[]) then
		where_condition_4 = '9,'; --Rumore
	end if;
	if ( matrici_new && '{6}'::int[]) then
		--Altro
		where_condition_5 = '10,';
	end if;
	if ( matrici_new && '{9}'::int[]) then
		where_condition_6 = '7,8,5,6,1';
	end if;

	raise info 'query 1 %', where_condition_1;
	raise info 'query 2 %', where_condition_2;
	raise info 'query 3 %', where_condition_3;
	raise info 'query 4 %', where_condition_4;
	raise info 'query 5 %', where_condition_5;
	raise info 'query 6 %', where_condition_6;

       --costruire la lista definitiva con gli id
       where_finale = concat('{',where_condition_1,where_condition_2,where_condition_3,where_condition_4, where_condition_5, where_condition_6,'}');
       where_finale = replace(where_finale,',}','}');
       raise info 'query finale %', where_finale::int[];

       return where_finale::int[];
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  CREATE OR REPLACE FUNCTION public.get_items(p_ids int[])
 RETURNS table (code integer, description text, gestione_altro boolean) AS
$BODY$
DECLARE

BEGIN

 RETURN QUERY 
     select t.code, t.description::text, t.gestione_altro
    from lookup_tipi_verifica t 
    where t.code = any (p_ids);
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
   ROWS 1000;

   update lookup_tipi_verifica  set gestione_altro =true where  code in (7,8,5,6,1);