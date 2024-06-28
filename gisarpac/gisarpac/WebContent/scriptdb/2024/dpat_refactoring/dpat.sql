-- Table: public.lookup_dpat_area

-- DROP TABLE IF EXISTS public.lookup_dpat_area;

CREATE TABLE IF NOT EXISTS public.lookup_dpat_area
(
    code serial,
    description text COLLATE pg_catalog."default",
    enabled boolean DEFAULT true,
    entered timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp without time zone,
    enteredby integer,
    modifiedby integer,
    note_hd text COLLATE pg_catalog."default",
    CONSTRAINT lookup_dpat_area_pkey PRIMARY KEY (code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.lookup_dpat_area
    OWNER to postgres;
    
INSERT INTO lookup_dpat_area (DESCRIPTION) values ('AREA TERRITORIALE');
INSERT INTO lookup_dpat_area (DESCRIPTION) values ('AREA ANALITICA');

DROP TABLE IF EXISTS public.rel_dipartimento_anno_area;

CREATE TABLE IF NOT EXISTS public.rel_dipartimento_anno_area
(
    id integer NOT NULL DEFAULT nextval('rel_dipartimento_anno_area_id_seq'::regclass),
    id_area integer,
    id_dipartimento integer,
    anno integer,
    enabled boolean DEFAULT true,
    entered timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp without time zone,
    enteredby integer,
    modifiedby integer,
    note_hd text COLLATE pg_catalog."default",
    CONSTRAINT rel_dipartimento_anno_area_pkey PRIMARY KEY (id),
    CONSTRAINT fkey_area FOREIGN KEY (id_area)
        REFERENCES public.lookup_dpat_area (code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fkey_asl FOREIGN KEY (id_dipartimento)
        REFERENCES public.lookup_site_id (code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.rel_dipartimento_anno_area
    OWNER to postgres;
-- Index: fki_fkey_asl

-- DROP INDEX IF EXISTS public.fki_fkey_asl;

CREATE INDEX IF NOT EXISTS fki_fkey_asl
    ON public.rel_dipartimento_anno_area USING btree
    (id_dipartimento ASC NULLS LAST)
    TABLESPACE pg_default;
    
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (1,201,2023);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (2,201,2023);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (1,202,2023);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (2,202,2023);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (1,203,2023);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (2,203,2023);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (1,204,2023);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (2,204,2023);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (1,207,2023);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (2,207,2023);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (1,201,2024);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (2,201,2024);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (1,202,2024);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (2,202,2024);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (1,203,2024);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (2,203,2024);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (1,204,2024);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (2,204,2024);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (1,207,2024);
insert into rel_dipartimento_anno_area(id_area, id_dipartimento, anno) values (2,207,2024);


DROP TABLE IF EXISTS public.rel_area_complessa_semplice;

CREATE TABLE IF NOT EXISTS public.rel_area_complessa_semplice
(
    id serial,
    id_area_complessa integer,
    enabled boolean DEFAULT true,
    id_area_semplice integer,
    entered timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp without time zone,
    enteredby integer,
    modifiedby integer,
    CONSTRAINT rel_area_complessa_semplice_pkey PRIMARY KEY (id),
    CONSTRAINT fkey_area_complessa FOREIGN KEY (id_area_complessa)
        REFERENCES public.rel_dipartimento_anno_area (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fkey_area_semplice FOREIGN KEY (id_area_semplice)
        REFERENCES public.lookup_dpat_area (code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.rel_area_complessa_semplice
    OWNER to postgres;
-- Index: fki_fkey_area_complessa

-- DROP INDEX IF EXISTS public.fki_fkey_area_complessa;

CREATE INDEX IF NOT EXISTS fki_fkey_area_complessa
    ON public.rel_area_complessa_semplice USING btree
    (id_area_complessa ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: fki_fkey_area_semplice

-- DROP INDEX IF EXISTS public.fki_fkey_area_semplice;

CREATE INDEX IF NOT EXISTS fki_fkey_area_semplice
    ON public.rel_area_complessa_semplice USING btree
    (id_area_semplice ASC NULLS LAST)
    TABLESPACE pg_default;

DROP TABLE IF EXISTS public.rel_area_nominativi;

CREATE TABLE IF NOT EXISTS public.rel_area_nominativi
(
    id serial,
    id_area_semplice integer,
    id_nominativo integer,
    enabled boolean DEFAULT true,
    entered timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    modified timestamp without time zone,
    enteredby integer,
    modifiedby integer,
    note_hd text COLLATE pg_catalog."default",
    CONSTRAINT fkey_area_semplice FOREIGN KEY (id_area_semplice)
        REFERENCES public.rel_area_complessa_semplice (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT fkey_id_nominativo FOREIGN KEY (id_nominativo)
        REFERENCES public.access_ (user_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.rel_area_nominativi
    OWNER to postgres;
-- Index: fki_fkey_id_nominativo

-- DROP INDEX IF EXISTS public.fki_fkey_id_nominativo;

CREATE INDEX IF NOT EXISTS fki_fkey_id_nominativo
    ON public.rel_area_nominativi USING btree
    (id_nominativo ASC NULLS LAST)
    TABLESPACE pg_default;
    
  DROP TABLE IF EXISTS public.rel_gruppo_ruoli;

CREATE TABLE IF NOT EXISTS public.rel_gruppo_ruoli
(
    code serial,
    id_ruolo integer,
    id_gruppo integer
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.rel_gruppo_ruoli
    OWNER to postgres;
 
-- FUNCTION: public.dpat_insert_area_semplice(integer, text, integer)

-- DROP FUNCTION IF EXISTS public.dpat_insert_area_semplice(integer, text, integer);

CREATE OR REPLACE FUNCTION public.dpat_insert_area_semplice(
	_id_area_complessa integer,
	_nome text,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE 

	idarea_semplice integer;
	
BEGIN	

	insert into lookup_dpat_area (description, enteredby) values (_nome, _id_utente) returning  code into idarea_semplice;
	insert into rel_area_complessa_semplice (id_area_complessa, id_area_semplice, enteredby) values 
											(_id_area_complessa, idarea_semplice, _id_utente);	
	      
	return idarea_semplice;
END;
$BODY$;

ALTER FUNCTION public.dpat_insert_area_semplice(integer, text, integer)
    OWNER TO postgres;
    
 
-- FUNCTION: public.dpat_disable_area_semplice(integer, integer)

-- DROP FUNCTION IF EXISTS public.dpat_disable_area_semplice(integer, integer);

CREATE OR REPLACE FUNCTION public.dpat_disable_area_semplice(
	_id_area integer,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

BEGIN	
		update lookup_dpat_area set 
		enabled = false,
		modified = now(),
		modifiedby = _id_utente 
		where code = (select id_area_semplice from rel_area_complessa_semplice where id = _id_area);
		
		update rel_area_complessa_semplice set 
		enabled=false, 
		modified=now(), 
		modifiedby= _id_utente
		where id = _id_area;
		
		return _id_area;
		
END;
$BODY$;

ALTER FUNCTION public.dpat_disable_area_semplice(integer, integer)
    OWNER TO postgres;


 
CREATE OR REPLACE FUNCTION public.dpat_elimina_nominativo_area_semplice(
	_id_nominativo integer,
	_id_area_semplice integer,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
		idinserito integer;
BEGIN 
		update rel_area_nominativi set 
		modified = current_timestamp, 
		modifiedby = _id_utente,
		enabled=false 
		where enabled 
		and id_nominativo = _id_nominativo 
		and id_area_semplice = _id_area_semplice;
		
		return 1;
END;
$BODY$;

ALTER FUNCTION public.dpat_elimina_nominativo_area_semplice(integer, integer, integer)
    OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.dpat_elimina_nominativo_area_semplice(
	_id_nominativo integer,
	_id_area_semplice integer,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
		idinserito integer;
BEGIN 
		update rel_area_nominativi set 
		modified = current_timestamp, 
		modifiedby = _id_utente,
		enabled=false 
		where enabled 
		and id_nominativo = _id_nominativo 
		and id_area_semplice = _id_area_semplice;
		
		return 1;
END;
$BODY$;

ALTER FUNCTION public.dpat_elimina_nominativo_area_semplice(integer, integer, integer)
    OWNER TO postgres;

 
CREATE OR REPLACE FUNCTION public.dpat_get_area_complessa(
	_id_area_complessa integer)
    RETURNS TABLE(id integer, id_dipartimento integer, anno integer, nome text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	
BEGIN 
	
    return query 
		select rel.id, rel.id_dipartimento, rel.anno, area.description
		from rel_dipartimento_anno_area rel
		join lookup_dpat_area area on area.code = rel.id_area
		where rel.enabled 		
		and rel.id = _id_area_complessa;
		
END;
$BODY$;

ALTER FUNCTION public.dpat_get_area_complessa(integer)
    OWNER TO postgres;
    

CREATE OR REPLACE FUNCTION public.dpat_get_area_semplice(
	_id_area_semplice integer)
    RETURNS TABLE(id integer, id_area_complessa integer, nome text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	
BEGIN 
	
    return query 
		select rel.id, rel.id_area_complessa, l.description
		from rel_area_complessa_semplice rel
		join lookup_dpat_area l on l.code = rel.id_area_semplice
		where rel.enabled 		
		and rel.id = _id_area_semplice;
		
END;
$BODY$;

ALTER FUNCTION public.dpat_get_area_semplice(integer)
    OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.dpat_get_aree_complesse_by_dipartimento_anno(
	_anno integer,
	_id_dipartimento integer)
    RETURNS TABLE(id integer, anno integer, id_dipartimento integer, nome text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	
BEGIN 
	
    return query 
		select rel.id, rel.anno, rel.id_dipartimento, area.description
		from rel_dipartimento_anno_area rel
		join lookup_dpat_area area on area.code = rel.id_area
		where rel.enabled 
		and rel.id_dipartimento = _id_dipartimento
		and rel.anno = _anno;
		
END;
$BODY$;

ALTER FUNCTION public.dpat_get_aree_complesse_by_dipartimento_anno(integer, integer)
    OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.dpat_get_aree_semplici_by_area_complessa(
	_id_area_complessa integer)
    RETURNS TABLE(id integer, id_area_complessa integer, nome text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	
BEGIN 
	
    return query 
		select rel.id, rel.id_area_complessa, l.description
		from rel_area_complessa_semplice rel
		join lookup_dpat_area l on l.code = rel.id_area_semplice
		where rel.enabled 		
		and rel.id_area_complessa = _id_area_complessa
		order by rel.entered ASC;
		
END;
$BODY$;

ALTER FUNCTION public.dpat_get_aree_semplici_by_area_complessa(integer)
    OWNER TO postgres;
    

CREATE OR REPLACE FUNCTION public.dpat_get_nominativi(
	)
    RETURNS TABLE(id_nominativo integer, nome text, qualifica text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	
BEGIN 
	
    return query 
		select ac.user_id,  concat(c.namefirst, ' ', c.namelast)::text, r.description::text
		from access ac 
		join role r on r.role_id = ac.role_id
		left join contact c on c.contact_id = ac.contact_id
		where ac.enabled and ac.in_dpat;
		
END;
$BODY$;

ALTER FUNCTION public.dpat_get_nominativi()
    OWNER TO postgres;

 
CREATE OR REPLACE FUNCTION public.dpat_get_nominativi_by_area_semplice(
	_id_area_semplice integer)
    RETURNS TABLE(id integer, nome text, qualifica text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	
BEGIN 
	
    return query 
		select ac.user_id,  concat(c.namefirst, ' ', c.namelast)::text, r.description::text
		from rel_area_nominativi rel
		join access ac on ac.user_id = rel.id_nominativo
		join role r on r.role_id = ac.role_id
		left join contact c on c.contact_id = ac.contact_id
		where rel.enabled 		
		and rel.id_area_semplice = _id_area_semplice
		order by rel.entered asc;
		
END;
$BODY$;

ALTER FUNCTION public.dpat_get_nominativi_by_area_semplice(integer)
    OWNER TO postgres;
    

CREATE OR REPLACE FUNCTION public.dpat_get_nominativi_selezionabili(
	_id_area integer)
    RETURNS TABLE(id integer, nome text, qualifica text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	id_asl integer;
	
BEGIN 
	id_asl := (select id_dipartimento 
			  from rel_area_complessa_semplice s 
			  join rel_dipartimento_anno_area c on s.id_area_complessa = c.id
			  where s.id = _id_area and s.enabled and c.enabled);
    
	return query 
	
		select ac.user_id,  concat(c.namefirst, ' ', c.namelast)::text, r.description::text
			from access ac 
			join access_dati acd on acd.user_id = ac.user_id
			left join role r on r.role_id = ac.role_id
			left join contact c on c.contact_id = ac.contact_id
		where 
			ac.enabled 
			and ac.in_dpat --and rel.id_nominativo is null
			and acd.site_id > 0
			and acd.site_id = id_asl
			and ac.user_id not in (
									select id_nominativo 
									from rel_area_nominativi 
									where enabled 
									and id_area_semplice = _id_area
		
									);
END;
$BODY$;

ALTER FUNCTION public.dpat_get_nominativi_selezionabili(integer)
    OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.dpat_get_nominativo(
	_id_nominativo integer,
	_id_area_semplice integer)
    RETURNS TABLE(id integer, nome text, qualifica text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	
BEGIN 
	
    return query 
		select ac.user_id, concat(c.namefirst, ' ', c.namelast)::text, r.description::text
		from rel_area_nominativi rel
		join access ac on ac.user_id = rel.id_nominativo
		join role r on r.role_id = ac.role_id
		left join contact c on c.contact_id = ac.contact_id
		where rel.enabled 		
		and rel.id_area_semplice = _id_area_semplice and rel.id_nominativo = _id_nominativo;
		
END;
$BODY$;

ALTER FUNCTION public.dpat_get_nominativo(integer, integer)
    OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.dpat_insert_area_complessa(
	_anno integer,
	_id_dipartimento integer,
	_nome text,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE 

	id_area_complessa integer;
	idarea integer;
	
BEGIN	
	insert into lookup_dpat_area (description, enteredby) values (_nome, _id_utente) returning  code into id_area_complessa;
	
	insert into rel_dipartimento_anno_area (id_area, id_dipartimento, anno, enteredby) values (id_area_complessa, _id_dipartimento, _anno, _id_utente) returning id into idarea;	
	      
	return idarea;
END;
$BODY$;

ALTER FUNCTION public.dpat_insert_area_complessa(integer, integer, text, integer)
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.dpat_insert_nominativo_area_semplice(
	_id_nominativo integer,
	_id_area_semplice integer,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
		idinserito integer;
BEGIN 
		insert into rel_area_nominativi (id_area_semplice, id_nominativo, enteredby)  values 
		(_id_area_semplice, _id_nominativo, _id_utente) returning rel_area_nominativi.id into idinserito;
		return idinserito;
END;
$BODY$;

ALTER FUNCTION public.dpat_insert_nominativo_area_semplice(integer, integer, integer)
    OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.dpat_update_area_semplice(
	_id_area integer,
	_nome text,
	_id_utente integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

BEGIN	
		update lookup_dpat_area set 
		modified = current_timestamp, 
		modifiedby = _id_utente,
		description = _nome 
		where code = (select id_area_semplice from rel_area_complessa_semplice where id = _id_area);
		return _id_area;
END;
$BODY$;

ALTER FUNCTION public.dpat_update_area_semplice(integer, text, integer)
    OWNER TO postgres;

    
-- FUNCTION: public.campione_dettaglio_globale(integer)

-- DROP FUNCTION IF EXISTS public.campione_dettaglio_globale(integer);

CREATE OR REPLACE FUNCTION public.campione_dettaglio_globale(
	_idcampione integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
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
	laboratorio := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, (l.description)::text as descrizione 
																   from lookup_destinazione_campione l join campioni c on c.id_laboratorio= l.code
							               							union select 'id' as nome,  (l.code)::text from  lookup_destinazione_campione l 
																    join campioni c on c.id_laboratorio= l.code 
																  ) a);
										   
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
											union select distinct 'idFascicoloIspettivo' as nome, cu.id_fascicolo_ispettivo::text
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
	gruppoispettivo := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select distinct gn.nome as nominativo, gn.id,
																				gn.qualifica as qualifica, c.nome_struttura as "descrizioneAreaSemplice"
																				from campione_gruppo_ispettivo c
																				join public.dpat_get_nominativi_by_area_semplice(c.id_struttura) gn on gn.id = c.id_componente
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
$BODY$;

ALTER FUNCTION public.campione_dettaglio_globale(integer)
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
	--STEP gruppo ispettivo
	gruppoispettivo := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select distinct gn.nome as nominativo, gn.id,
																				gn.qualifica as qualifica, c.nome_struttura as "descrizioneAreaSemplice"
																				from campione_gruppo_ispettivo c
																				join public.dpat_get_nominativi_by_area_semplice(c.id_struttura) gn on gn.id = c.id_componente
																					where c.id_campione = _idcampione) t);
	
	raise info 'GRUPPO tecnici: %', gruppotecnici;		
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


CREATE OR REPLACE FUNCTION public.campione_insert_gruppo_ispettivo(
	_json_daticonnucleo json,
	_idcampione integer)
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
		 INSERT INTO campione_gruppo_ispettivo (id_campione, id_componente, enabled, id_struttura, nome_struttura) values (_idcampione, (i->>'id')::integer,true, (i->>'idAreaSemplice')::integer, (i->>'descrizioneAreaSemplice')::text);
	  END LOOP;

    	 return 1;
END;
$BODY$;

ALTER FUNCTION public.campione_insert_gruppo_ispettivo(json, integer)
    OWNER TO postgres;

-- FUNCTION: public.giornata_ispettiva_dettaglio_globale(integer)

-- DROP FUNCTION IF EXISTS public.giornata_ispettiva_dettaglio_globale(integer);

CREATE OR REPLACE FUNCTION public.giornata_ispettiva_dettaglio_globale(
	_idgiornataispettiva integer)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	
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
	   
	id_tecnica := (select c.id_tecnica  from giornate_ispettive c where id = _idgiornataispettiva); 
	anno_controllo := (select date_part('year',data_inizio)::integer from giornate_ispettive where id = _idgiornataispettiva);
	rifid := (select riferimento_id from giornate_ispettive where id = _idgiornataispettiva);
	id_dipartimento := (select c.id_dipartimento from giornate_ispettive c where id = _idgiornataispettiva);
	rifnometab := (select c.riferimento_id_nome_tab from giornate_ispettive c where id = _idgiornataispettiva);
	--tipologia_operatore := (select distinct m.tipologia_operatore from ricerche_anagrafiche_old_materializzata m where m.riferimento_id = rifid and m.riferimento_id_nome_tab = rifnometab );
	--lineacontrollo := (select codice_linea from linee_attivita_giornate_ispettive  where  id_giornata_ispettiva  = _idgiornataispettiva and trashed_date is null);

	--path_linea := (select path_descrizione from ml8_linee_attivita_nuove_materializzata where codice = lineacontrollo and livello = 3 limit 1);
	
	-- costruzione dei json
	tecnicacu := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, description as descrizione from lookup_tipo_controllo where code = id_tecnica 
							union select 'id' as nome,  id_tecnica::text) a); 
        --tecnicacu := (select json_object_agg('Tecnica', tecnicacu));
	raise info 'json tecnica ricostruito%', tecnicacu;
	daticu := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from giornate_ispettive where id = _idgiornataispettiva
								  union select 'dataInizio' as nome,  data_inizio::text from giornate_ispettive where id = _idgiornataispettiva 
								  union select 'dataFine' as nome,  data_fine::text from giornate_ispettive where id = _idgiornataispettiva 
								  union select 'oraInizio' as nome,  coalesce(ore::text,'') from giornate_ispettive where id = _idgiornataispettiva 
								  union select 'oraFine' as nome,  coalesce(ora_fine::text,'') from giornate_ispettive where id = _idgiornataispettiva 
								  union select 'conclusa' as nome,  coalesce(conclusa_verifica::text,'') from giornate_ispettive where id = _idgiornataispettiva 
								  ) b);
	--daticu := (select json_object_agg('Dati', daticu));
	raise info 'json daticu ricostruito%', daticu;
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'stato' as nome, l.description as descrizione 
									 from giornate_ispettive c join lookup_stato_cu l on l.code = c.stato 
									 where id = _idgiornataispettiva
								  union select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from giornate_ispettive c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where id = _idgiornataispettiva 
								  union select 'dataInserimento' as nome, entered::text as descrizione from giornate_ispettive where id = _idgiornataispettiva
								  union select 'idGiornataIspettiva' as nome, id::text as descrizione from giornate_ispettive where id = _idgiornataispettiva 
								  ) b);

	anagrafica := (select json_object_agg(nome,descrizione) from (select 'partitaIva' as nome, trim(partita_iva) as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab
								  union select 'riferimentoId' as nome,  rifid::text
								  union select 'riferimentoIdNomeTab' as nome,  rifnometab::text 
								  union select 'ragioneSociale' as nome, ragione_sociale as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab) c);
	--anagrafica := (select json_object_agg('Anagrafica', anagrafica));
	raise info 'json anagrafica ricostruito%', anagrafica;

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, enteredby as descrizione from giornate_ispettive where id = _idgiornataispettiva) d); 
	--utente := (select json_object_agg('Utente', utente));
	raise info 'json utente ricostruito%', utente;

	dipartimento := (select json_object_agg(nome,descrizione) from (select 'nome' as nome,  description as descrizione from lookup_site_id where code= id_dipartimento
								union select 'id' as nome, id_dipartimento::text) e); 
	--asl := (select json_object_agg('Asl', asl));
	raise info 'json asl ricostruito%', dipartimento;
				  
	--"Linee":[{"codice":"MS.020-MS.020.500-852IT3A401","nome":"path completo","id":"192439"}],
	--linee := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select lineacontrollo as codice, path_linea as nome, (select id_linea_attivita from linee_attivita_giornate_ispettive  where trashed_date is null and id_giornata_ispettiva = _idgiornataispettiva) as id 
	--									from giornate_ispettive where id = _idgiornataispettiva) t);
	--linee := (select json_object_agg('Linee', linee));

	--06/07
	linee := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select codice_linea as codice, replace(coalesce(m.descrizione_completa,''), '''', '''''') as nome, l.id_linea_attivita as id 
				from giornate_ispettive c
				left join linee_attivita_giornate_ispettive l on l.id_giornata_ispettiva=c.id and l.trashed_date is null			
				left join codici_categoria_ippc m on concat(m.id_categoria, '-', m.id_codici_ippc, '-', m.id_codici_descrizione) = l.codice_linea
				where c.id = _idgiornataispettiva and c.trashed_date is null) t);
				raise info 'json linee ricostruito%', linee;

	gruppoispettivo := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select distinct gn.nome as nominativo, gn.id,
						gn.qualifica as qualifica, c.nome_struttura as "descrizioneAreaSemplice",
						c.responsabile, c.referente
						from giornata_ispettiva_gruppo_ispettivo c
						join public.dpat_get_nominativi_by_area_semplice(c.id_struttura) gn on gn.id = c.id_componente
							where id_giornata_ispettiva =_idgiornataispettiva) t);

	--gruppoispettivo := (select json_object_agg('GruppoIspettivo', gruppoispettivo));
	raise info 'json gruppoispettivo ricostruito %', gruppoispettivo;

										
	tipiverifica := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_tipi_verifica c
										join lookup_tipi_verifica l on l.code = c.id_tipo_verifica
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);
	--tipiverifica := (select json_object_agg('TipiVerifica', tipiverifica));
	raise info 'json tipi verifica %', tipiverifica;
	
	percontodi := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select distinct o.nome as nome, o.id_area_complessa as id 
																		from giornate_ispettive_per_conto_di c
																		join public.dpat_get_area_semplice(c.id_percontodi) o on o.id = c.id_percontodi
																		where c.id_giornata_ispettiva =  _idgiornataispettiva) t);
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
											and c.id_giornata_ispettiva = _idgiornataispettiva) t);
												
	raise info 'json emissioni atmosfera %', emissioniatmosfera;

										
	fascicolo := (select json_object_agg(nome,descrizione) from (select 'numero' as nome,  numero as descrizione from fascicoli_ispettivi  where id in (select id_fascicolo_ispettivo from giornate_ispettive where id = _idgiornataispettiva and trashed_date is null) 
								union select 'id' as nome, id_fascicolo_ispettivo::text as descrizione from giornate_ispettive where id = _idgiornataispettiva) e); 
								
	raise info 'json fascicolo %', fascicolo;

	matrici := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id, c.conclusa
										from giornate_ispettive_matrici c
										join lookup_matrice_controlli l on l.code = c.id_matrice
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);

	raise info 'json matrici %', matrici;
		
	
	if (tecnicacu ->> 'id')::int = 2 then
		-- RECUPERO I MOTIVI E GLI ESAMI RICHIESTI
		motivi := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_motivi c
										join lookup_motivi l on l.code = c.id_motivo 
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);
		--motivi := (select json_object_agg('Motivi', motivi));
		raise info 'json motivi ricostruito %', motivi;

		esami := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from giornate_ispettive_esami c
										join lookup_esami l on l.code = c.id_esame 
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);
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
										where c.id_giornata_ispettiva = _idgiornataispettiva) t);
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
$BODY$;

ALTER FUNCTION public.giornata_ispettiva_dettaglio_globale(integer)
    OWNER TO postgres;

DROP FUNCTION get_giornata_ispettiva_gruppo_ispettivo_componenti(integer);
DROP FUNCTION get_gruppo_ispettivo_componenti_particella(integer,integer);   

CREATE OR REPLACE FUNCTION public.get_giornata_ispettiva_gruppo_ispettivo_componenti(
	_id_giornata_ispettiva integer)
    RETURNS TABLE(id integer, nominativo text, id_area_semplice integer, descrizione_area_semplice text, id_qualifica integer, nome_qualifica text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

BEGIN
	
	return query
		select distinct c.id_componente, 
		concat_ws(' ', cc.namefirst, cc.namelast)::text, c.id_struttura, c.nome_struttura::text, ac.role_id, r.role::text
		from giornata_ispettiva_gruppo_ispettivo c
	        left join access_ ac on ac.user_id = c.id_componente 
	        left join role r on r.role_id= ac.role_id
	        left join contact cc on cc.contact_id = ac.contact_id 
		where id_giornata_ispettiva = _id_giornata_ispettiva
		order by 4,2 asc; 

END;
$BODY$;

ALTER FUNCTION public.get_giornata_ispettiva_gruppo_ispettivo_componenti(integer)
    OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.get_gruppo_ispettivo_componenti(
	_anno integer DEFAULT NULL::integer,
	_id_dipartimento integer DEFAULT '-1'::integer)
    RETURNS TABLE(id integer, nominativo text, id_area_semplice integer, descrizione_area_semplice text, id_qualifica integer, nome_qualifica text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE

BEGIN
	return query
		SELECT o.id_nominativo, o.nominativo, id_istanza_area_semplice, concat(upper(o.asl),'->', upper(o.descrizione_area_complessa), '->',upper(o.descrizione_area_semplice)),
		o.id_qualifica, o.qualifica::text
		from organigramma_completo o
		where o.anno = _anno and  (_id_dipartimento = -1 or o.id_asl = _id_dipartimento);
		 

END;
$BODY$;

ALTER FUNCTION public.get_gruppo_ispettivo_componenti(integer, integer)
    OWNER TO postgres;

    
CREATE OR REPLACE FUNCTION public.get_gruppo_ispettivo_componenti_particella(
	_id_qualifica integer DEFAULT '-1'::integer,
	_id_dipartimento integer DEFAULT '-1'::integer)
    RETURNS TABLE(id integer, nominativo text, id_area_semplice integer, descrizione_area_semplice text, id_qualifica integer, nome_qualifica text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

BEGIN

	return query
		select ac.user_id, concat(c.namefirst,' ', c.namelast), -1, '', ac.role_id, r.description::text 
		from access ac 
		join contact c on ac.contact_id=c.contact_id
		join role r on r.role_id=ac.role_id
		where r.enabled and 
		(r.role_id = _id_qualifica or _id_qualifica = -1) 
		and (ac.site_id= _id_dipartimento or _id_dipartimento = -1);

END;
$BODY$;

ALTER FUNCTION public.get_gruppo_ispettivo_componenti_particella(integer, integer)
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_percontodi_aree_dipartimento(
	_anno integer,
	_id_dipartimento integer)
    RETURNS TABLE(id integer, id_dipartimento integer, dipartimento text, tipologia text, descrizione_area_semplice text, descrizione_area_complessa text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE

BEGIN 

	
	return query
	
	SELECT distinct o.id_istanza_area_semplice, o.id_asl, o.asl::text, 'AREA COMPLESSA', 
		    upper(o.descrizione_area_semplice), upper(o.descrizione_area_complessa)
		from organigramma_completo o 
		where id_asl= _id_dipartimento 
		and anno = _anno;
	

END;
$BODY$;

ALTER FUNCTION public.get_percontodi_aree_dipartimento(integer, integer)
    OWNER TO postgres;
   
-- View: public.organigramma_completo

-- DROP VIEW public.organigramma_completo;

CREATE OR REPLACE VIEW public.organigramma_completo
 AS
 SELECT DISTINCT diparea.id_dipartimento AS id_asl,
    asl.description AS asl,
    diparea.anno,
    area_complessa.code AS id_area_complessa,
    area_semplice.code AS id_area_semplice,
    diparea.id AS id_istanza_area_complessa,
    relacs.id AS id_istanza_area_semplice,
    relnom.id_nominativo,
    r.role_id AS id_qualifica,
    area_complessa.description AS descrizione_area_complessa,
    area_semplice.description AS descrizione_area_semplice,
    concat(c.namefirst::text, ' ', c.namelast) AS nominativo,
    r.description AS qualifica
   FROM lookup_dpat_area area_complessa
     LEFT JOIN rel_dipartimento_anno_area diparea ON diparea.id_area = area_complessa.code
     LEFT JOIN lookup_site_id asl ON asl.code = diparea.id_dipartimento
     LEFT JOIN rel_area_complessa_semplice relacs ON relacs.id_area_complessa = diparea.id
     LEFT JOIN lookup_dpat_area area_semplice ON relacs.id_area_semplice = area_semplice.code
     LEFT JOIN rel_area_nominativi relnom ON relnom.id_area_semplice = relacs.id AND relnom.enabled
     LEFT JOIN access ac ON ac.user_id = relnom.id_nominativo
     LEFT JOIN contact c ON c.contact_id = ac.contact_id
     LEFT JOIN role r ON r.role_id = ac.role_id
  WHERE diparea.enabled AND area_semplice.enabled AND relacs.enabled AND area_complessa.enabled AND asl.enabled
  ORDER BY asl.description, diparea.anno, area_complessa.description, area_semplice.description;

ALTER TABLE public.organigramma_completo
    OWNER TO postgres;










