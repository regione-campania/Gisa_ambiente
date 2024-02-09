--Fix di campi
delete from scheda_operatore_metadati where tipo_operatore not in (6,24);
delete from lookup_tipo_scheda_operatore  where code not in (6,24);

-- copia scheda centralizzata nel db dest select * from aggiorna_scheda_centralizzata(24);

update configuratore_template_no_scia set html_label = 'X' where html_name = 'lat_stabilimento' and id = 41;
update configuratore_template_no_scia set html_label = 'Y' where html_name = 'long_stabilimento' and id = 42;
update configuratore_template_no_scia set html_label = 'COORDINATE GEOGRAFICHE' where html_name = 'coordinate_stabilimento' and id = 40;

update gruppi_template_no_scia set html_label = 'GESTORE STABILIMENTO' where ftl_name = 'rappleg' and id = 2;

-- Creo lookup tipo autorizzazione

-- Table: public.lookup_norme

-- DROP TABLE public.lookup_norme;

CREATE TABLE public.lookup_autorizzazione_tipo
(
  code serial primary key,
  description character varying(300) NOT NULL,
  default_item boolean DEFAULT false,
  level integer DEFAULT 0,
  enabled boolean DEFAULT true
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lookup_autorizzazione_tipo
  OWNER TO postgres;

  insert into lookup_autorizzazione_tipo(description) values ('Regionale');
  insert into lookup_autorizzazione_tipo(description) values ('Statale');

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


