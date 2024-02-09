-- mancano!
  
  
-- Function: public.dbi_opu_get_progressivo_linea_per_stabilimento(text)

-- DROP FUNCTION public.dbi_opu_get_progressivo_linea_per_stabilimento(text);

update lookup_stato_lab set description = 'in attivita'''  where code = 0;
update lookup_stato_lab set description = 'AIA revocata'  where code = 1;
update lookup_stato_lab set description = 'Conferimenti sospesi dal 2011 - AIA non rinnovata'  where code = 2;
update lookup_stato_lab set description = 'Impianto non operativo'  where code = 3;
update lookup_stato_lab set description = 'Impianto chiuso'  where code = 4;
update lookup_stato_lab set description = 'Impianto dismesso'  where code = 6;
update lookup_stato_lab set description = 'AUA'  where code = 5;
update lookup_stato_lab set description = 'AIA non rinnovata'  where code = 7;

delete from lookup_tipo_impresa_societa  where code > 10

 -- copia scheda centralizzata nel db dest select * from aggiorna_scheda_centralizzata(24);

update configuratore_template_no_scia set html_label = 'X' where html_name = 'lat_stabilimento' and id = 41;
update configuratore_template_no_scia set html_label = 'Y' where html_name = 'long_stabilimento' and id = 42;
update configuratore_template_no_scia set html_label = 'COORDINATE GEOGRAFICHE' where html_name = 'coordinate_stabilimento' and id = 40;
update gruppi_template_no_scia set html_label = 'GESTORE STABILIMENTO' where ftl_name = 'rappleg' and id = 2;
-- Aggiorno dimensione campo asl

update configuratore_template_no_scia set html_style = 'placeholder="asl" readonly size="40px"' where id = 208 and html_label = 'ASL';



 -- Creo gruppo autorizzazione

SELECT MAX(id) + 1 FROM gruppi_template_no_scia;
CREATE SEQUENCE gruppi_template_no_scia_id_seq START WITH 13; --copiare dal max
ALTER TABLE gruppi_template_no_scia ALTER COLUMN id SET DEFAULT nextval('gruppi_template_no_scia_id_seq');
 
insert into gruppi_template_no_scia (html_label, ftl_name) values ('DATI AUTORIZZAZIONE', 'autorizzazione');

 -- Inserisco campi autorizzazione

SELECT MAX(id) + 1 FROM configuratore_template_no_scia;
CREATE SEQUENCE configuratore_template_no_scia_id_seq START WITH 271; --copiare dal max
ALTER TABLE configuratore_template_no_scia ALTER COLUMN id SET DEFAULT nextval('configuratore_template_no_scia_id_seq');
 
insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('', true, 'dm', 'nome_sezione', '', 'autorizzazione');

insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('ID AIA', true, 'dma', 'text', 'autorizzazione_id_aia', '_b_autorizzazione_id_aia');

insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field, sql_campo_lookup, sql_origine_lookup, sql_condizione_lookup)
values ('AUTORIZZAZIONE REGIONALE/STATALE', true, 'dmb', 'select', 'autorizzazione_tipo', '_b_autorizzazione_tipo', 'code,description', 'lookup_autorizzazione_tipo', 'enabled=true');

insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('DECRETO DIRIGENZIALE NUMERO', true, 'dmc', 'text', 'autorizzazione_numero', '_b_autorizzazione_numero');

insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('DECRETO DIRIGENZIALE DATA', true, 'dmd', 'date', 'autorizzazione_data', '_b_autorizzazione_data');

insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('NOTA', true, 'dme', 'text', 'autorizzazione_nota', '_b_autorizzazione_nota');

insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('BURC', true, 'dmf', 'text', 'autorizzazione_burc', '_b_autorizzazione_burc');

insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('DENOMINAZIONE', true, 'dh0', 'text', 'denominazione_stab', '_b_denominazione_stab');

-- Inserisco il mapping

--SELECT MAX(id) + 1 FROM schema_anagrafica; esisteva già
--CREATE SEQUENCE schema_anagrafica_id_seq START WITH 1529; --copiare dal max
ALTER TABLE schema_anagrafica ALTER COLUMN id SET DEFAULT nextval('schema_anagrafica_id_seq');

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'DATI AUTORIZZAZIONE'), (select id from configuratore_template_no_scia where html_type = 'nome_sezione' and mapping_field = 'autorizzazione'), false, true);

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'DATI AUTORIZZAZIONE'), (select id from configuratore_template_no_scia where html_name = 'autorizzazione_id_aia'), false, true);

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'DATI AUTORIZZAZIONE'), (select id from configuratore_template_no_scia where html_name = 'autorizzazione_tipo'), false, true);

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'DATI AUTORIZZAZIONE'), (select id from configuratore_template_no_scia where html_name = 'autorizzazione_numero'), false, true);

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'DATI AUTORIZZAZIONE'), (select id from configuratore_template_no_scia where html_name = 'autorizzazione_data'), false, true);

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'DATI AUTORIZZAZIONE'), (select id from configuratore_template_no_scia where html_name = 'autorizzazione_nota'), false, true);

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'DATI AUTORIZZAZIONE'), (select id from configuratore_template_no_scia where html_name = 'autorizzazione_burc'), false, true);

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'DATI STABILIMENTO'), (select id from configuratore_template_no_scia where html_name = 'denominazione_stab'), false, true);


update configuratore_template_no_scia set html_label = 'DIPARTIMENTO', html_style = 'placeholder="dipartimento" readonly size="40px"' where html_label ilike 'ASL';

-- Creo gruppo Responsabile Stabilimento

insert into gruppi_template_no_scia (html_label, ftl_name) values ('RESPONSABILE STABILIMENTO', 'resp_stab');

 -- Inserisco campi Responsabile Stabilimento
 
insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('', true, 'bzz', 'nome_sezione', '', 'resp_stab');

insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('NOME', true, 'bzza', 'text', 'nome_resp_stab', '_b_nome_resp_stab');

insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('COGNOME', true, 'bzzc', 'text', 'cognome_resp_stab', '_b_cognome_resp_stab');

insert into configuratore_template_no_scia(html_label, html_enabled, html_ordine, html_type, html_name, mapping_field)
values ('CODICE FISCALE', true, 'bzzd', 'text', 'cf_resp_stab', '_b_cf_resp_stab');

-- Inserisco il mapping


insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'RESPONSABILE STABILIMENTO'), (select id from configuratore_template_no_scia where html_type = 'nome_sezione' and mapping_field = 'resp_stab'), false, true);

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'RESPONSABILE STABILIMENTO'), (select id from configuratore_template_no_scia where html_name = 'nome_resp_stab'), false, true);

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'RESPONSABILE STABILIMENTO'), (select id from configuratore_template_no_scia where html_name = 'cognome_resp_stab'), false, true);

insert into schema_anagrafica (codice_univoco_ml, id_gruppo_template, id_campo_configuratore, campo_esteso, enabled)
values ('TEST-SCIA', (select id from gruppi_template_no_scia where html_label = 'RESPONSABILE STABILIMENTO'), (select id from configuratore_template_no_scia where html_name = 'cf_resp_stab'), false, true);


-- lookup_destinazione_campione da ricreare!

-- mancano le linee!
-- Function: public.get_linea_attivita_noscia()

-- DROP FUNCTION public.get_linea_attivita_noscia();

CREATE OR REPLACE FUNCTION public.get_linea_attivita_noscia()
  RETURNS TABLE(codice_attivita text, path_descrizione text, description text) AS
$BODY$
	select ml8.codice, concat(ln.description, '-> ', ml8.path_descrizione) path_descrizione , ln.description
		from ml8_linee_attivita_nuove_materializzata ml8 
			join master_list_flag_linee_attivita mlf on mlf.codice_univoco = ml8.codice
			join opu_lookup_norme_master_list ln on code = ml8.id_norma
		where mlf.no_scia = true;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_linea_attivita_noscia()
  OWNER TO postgres;
  
  
CREATE OR REPLACE FUNCTION public.cerca_metadato(IN _codice_univoco_ml text)
  RETURNS TABLE(id integer, id_configuratore integer, html_label_sezione text, ftl_name text, html_label text, enabled boolean, sql_campo text, sql_origine text, sql_condizione text, html_ordine text, html_type text, sql_campo_lookup text, sql_origine_lookup text, sql_condizione_lookup text, html_name text, mapping_field text, oid_parent integer, html_style text, html_event text) AS
$BODY$
select 	sa.id,
	ct.id as id_configuratore,
	gt.html_label as html_label_sezione,
	gt.ftl_name,
	ct.html_label,
	sa.enabled,
	ct.sql_campo,
	ct.sql_origine,
	ct.sql_condizione,
	ct.html_ordine,
	ct.html_type,
	ct.sql_campo_lookup,
	ct.sql_origine_lookup,
	ct.sql_condizione_lookup,
	ct.html_name,
	ct.mapping_field,
	ct.oid_parent,
	ct.html_style,
	ct.html_event      
	from gruppi_template_no_scia gt 
		join schema_anagrafica sa on gt.id = sa.id_gruppo_template
		join configuratore_template_no_scia ct on ct.id = sa.id_campo_configuratore
			where trim(sa.codice_univoco_ml) = trim(_codice_univoco_ml) and sa.enabled
				and ct.oid_parent is null
					order by ct.html_ordine ASC;
    
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.cerca_metadato(text)
  OWNER TO postgres;

