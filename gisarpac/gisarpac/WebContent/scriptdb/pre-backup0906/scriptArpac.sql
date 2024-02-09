--alter SEQUENCE role_role_id_seq RESTART  3365

CREATE OR REPLACE VIEW public.lookup_qualifiche AS 
 SELECT a.code,
    a.description,
    a.short_description,
    a.default_item,
    a.level,
    a.enabled,
    a.carico_default,
    a.peso_per_somma_ui,
    a.in_dpat,
    a.view_lista_utenti_nucleo_ispettivo,
    a.gruppo,
    a.in_nucleo_ispettivo,
    a.livello_qualifiche_dpat,
    a.origine
   FROM ( SELECT role.role_id AS code,
            role.role AS description,
            role.description AS short_description,
            false AS default_item,
                CASE
                    WHEN role.in_dpat = true THEN 1
                    WHEN role.in_dpat = false AND role.super_ruolo = 1 THEN 10
                    WHEN role.super_ruolo = 2 THEN 0
                    ELSE NULL::integer
                END AS level,
            role.enabled_as_qualifica AS enabled,
            role.carico_default,
            role.peso_per_somma_ui,
            role.in_dpat,
            role.view_lista_utenti_nucleo_ispettivo,
            false AS gruppo,
            role.in_nucleo_ispettivo,
            role.livello_qualifiche_dpat,
            10 AS origine
           FROM role where enabled
        UNION
         SELECT role.role_id AS code,
            role.role AS description,
            role.description AS short_description,
            false AS default_item,
                CASE
                    WHEN role.in_dpat = true THEN 1
                    WHEN role.in_dpat = false AND role.super_ruolo = 1 THEN 10
                    WHEN role.super_ruolo = 2 THEN 0
                    ELSE NULL::integer
                END AS level,
            role.enabled_as_qualifica AS enabled,
            role.carico_default,
            role.peso_per_somma_ui,
            role.in_dpat,
            role.view_lista_utenti_nucleo_ispettivo,
            false AS gruppo,
            role.in_nucleo_ispettivo,
            role.livello_qualifiche_dpat,
            11 AS origine
           FROM role_ext role
          WHERE role.enabled
        UNION
         SELECT 0 AS code,
            'UTENTI ASL'::character varying(80) AS description,
            'UTENTI ASL'::character varying(255) AS short_description,
            false AS default_item,
            0 AS level,
            true AS enabled,
            NULL::integer AS carico_default,
            NULL::integer AS aspeso_per_somma_ui,
            NULL::boolean AS in_dpat,
            NULL::boolean AS view_lista_utenti_nucleo_ispettivo,
            true AS gruppo,
            true AS in_nucleo_ispettivo,
            0 AS livello_qualifiche_dpat,
            0 AS origine
        UNION
         SELECT 1 AS code,
            'UTENTI EXTRA ASL'::character varying(80) AS description,
            'UTENTI EXTRA ASL'::character varying(255) AS short_description,
            false AS default_item,
            1 AS level,
            true AS enabled,
            NULL::integer AS carico_default,
            NULL::integer AS aspeso_per_somma_ui,
            NULL::boolean AS in_dpat,
            NULL::boolean AS view_lista_utenti_nucleo_ispettivo,
            true AS gruppo,
            true AS in_nucleo_ispettivo,
            1 AS livello_qualifiche_dpat,
            1 AS origine) a
  ORDER BY a.code;

update role_ext  set enabled=false
update role set role='Referente ispettivo', description ='Referente ispettivo' where role_id=42;
update role set role='Dirigente Regionale', description ='Dirigente Regionale' where role_id=27;
update role set role='Responsabile procedimento', description ='Responsabile procedimento' where role_id=43;

insert into role(role_id, role, description, enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
(select nextval('role_role_id_seq'),'Tecnico esperto di controlli di emissioni in atmosfera','Tecnico esperto di controlli di emissioni in atmosfera', enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo 
from role where role_id=43);
insert into role(role_id, role, description, enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
(select nextval('role_role_id_seq'),'Tecnico di controlli di scarichi di acque reflue','Tecnico di controlli di scarichi di acque reflue', enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo 
from role where role_id=43);
insert into role(role_id, role, description, enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
(select nextval('role_role_id_seq'),'Tecnico esperto in gestione rifiuti','Tecnico esperto in gestione rifiuti', enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo 
from role where role_id=43);
insert into role(role_id, role, description, enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
(select nextval('role_role_id_seq'),'Ufficiale di Polizia Giudiziaria','Ufficiale di Polizia Giudiziaria', enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo 
from role where role_id=43);
--select * from role  where enabled

select * from organization where trashed_date is null
truncate opu_stabilimento cascade;
truncate opu_operatore cascade;
truncate opu_indirizzo cascade;
truncate opu_rel_operatore_soggetto_fisico cascade;
truncate opu_relazione_stabilimento_linee_produttive cascade;
truncate opu_soggetto_fisico cascade;  
truncate opu_indirizzo cascade;
truncate apicoltura_apiari cascade;
drop table comuni1 cascade;
-------------------------------- copia tabella comuni
pg_dump -t comuni1 -U postgres -h 127.0.0.1 -d gisa > comuni1.sql
psql -U postgres -h 127.0.0.1 -d gisarpac < comuni1.sql
------------------------------------------------------


drop table opu_relazione_operatore_sede;
drop table opu_agr_appo ;
drop table opu_allevamenti_impresa cascade;
drop table opu_allevamenti_stabilimento cascade;
drop table opu_allevamenti_log_ko;
drop table opu_allevamenti_lista_import;
drop table opu_app_nomi;
drop table opu_indirizzo_ cascade;
drop table opu_indirizzo_old;
drop table opu_indirizzo_backup;       
drop table opu_linee_attivita_controlli_ufficiali_backup;
drop view dpat_strutture_asl cascade;

truncate sintesis_relazione_stabilimento_linee_produttive cascade;
truncate sintesis_soggetto_fisico;      
truncate sintesis_operatore cascade;
truncate sintesis_stabilimento cascade;
truncate sintesis_indirizzo cascade;
truncate lookup_site_id cascade;

-- inserire i distretti provinciali 
-- distretti provinciali
insert into lookup_site_id(code, description, short_description, enabled, level, codiceistat, id_provincia) values (201, 'Dipartimento Provinciale di Avellino', 'AV', true, 1, '064',64);
insert into lookup_site_id(code, description, short_description, enabled, level, codiceistat, id_provincia) values (202, 'Dipartimento Provinciale di Benevento', 'BN', true, 1, '062',62);
insert into lookup_site_id(code, description, short_description, enabled, level, codiceistat, id_provincia) values (203, 'Dipartimento Provinciale di Caserta', 'CE', true, 1, '061',61);
insert into lookup_site_id(code, description, short_description, enabled, level, codiceistat, id_provincia) values (204, 'Dipartimento Provinciale di Napoli', 'NA', true, 1, '063',63);
insert into lookup_site_id(code, description, short_description, enabled, level, codiceistat, id_provincia) values (207, 'Dipartimento Provinciale di Salerno', 'SA', true, 1, '065',65);
insert into lookup_site_id(code, description, short_description, enabled, level, codiceistat, id_provincia) values (-1, '--TUTTE LE ASL--', '', true, 1, '-1',NULL);

-- asl in anagrafica
insert into organization(name, entered, enteredby, modifiedby, modified, enabled, site_id,tipologia)values('Dipartimento provinciale di Avellino', now(), 964,964,now(),true, 201,6);
insert into organization(name, entered, enteredby, modifiedby, modified, enabled, site_id,tipologia)values('Dipartimento provinciale di Benevento', now(), 964,964,now(),true, 202,6);
insert into organization(name, entered, enteredby, modifiedby, modified, enabled, site_id,tipologia)values('Dipartimento provinciale di Caserta', now(), 964,964,now(),true, 203,6);
insert into organization(name, entered, enteredby, modifiedby, modified, enabled, site_id,tipologia)values('Dipartimento provinciale di Napoli', now(), 964,964,now(),true, 204,6);
insert into organization(name, entered, enteredby, modifiedby, modified, enabled, site_id,tipologia)values('Dipartimento provinciale di Salerno', now(), 964,964,now(),true, 207,6);


DROP VIEW public.oia_nodo cascade;

CREATE OR REPLACE VIEW public.oia_nodo AS 
 SELECT a.id,
    a.id_padre,
    a.id_asl,
    a.descrizione_lunga,
    a.n_livello,
    a.entered,
    a.entered_by,
    a.modified,
    a.modified_by,
    a.trashed_date,
    a.tipologia_struttura,
    a.comune,
    a.enabled,
    a.obsoleto,
    a.confermato,
    a.id_strumento_calcolo,
    a.carico_lavoro_annuo,
    a.percentuale_da_sottrarre,
    a.carico_lavoro_effettivo,
    a.fattori_incidenti_su_carico,
    a.codice_interno_fk,
    a.nome,
    a.id_utente,
    a.mail,
    a.indirizzo,
    a.delegato,
    a.descrizione_comune,
    a.id_oia_nodo_temp,
    a.data_scadenza,
    a.disabilitata,
    a.stato,
    a.anno,
    a.descrizione_area_struttura_complessa,
    a.uba_ui,
    a.somma_ui_area,
    a.somma_uba_area,
    a.id_lookup_area_struttura_asl,
    a.ui_struttura_foglio_att_iniziale,
    a.ui_struttura_foglio_att_finale,
    a.id_utente_edit,
    a.percentuale_area_a,
    a.stato_all2,
    a.stato_all6,
    a.codice_interno_univoco,
    a.descrizione_area_struttura
   FROM ( SELECT strutture_asl.id,
            strutture_asl.id_padre,
            strutture_asl.id_asl,
            strutture_asl.descrizione_lunga,
            strutture_asl.n_livello,
            strutture_asl.entered,
            strutture_asl.entered_by,
            strutture_asl.modified,
            strutture_asl.modified_by,
            strutture_asl.trashed_date,
            strutture_asl.tipologia_struttura,
            strutture_asl.comune,
            strutture_asl.enabled,
            strutture_asl.obsoleto,
            strutture_asl.confermato,
            strutture_asl.id_strumento_calcolo,
            strutture_asl.carico_lavoro_annuo,
            strutture_asl.percentuale_da_sottrarre,
            strutture_asl.carico_lavoro_effettivo,
            strutture_asl.fattori_incidenti_su_carico,
            strutture_asl.codice_interno_fk,
            strutture_asl.nome,
            strutture_asl.id_utente,
            strutture_asl.mail,
            strutture_asl.indirizzo,
            strutture_asl.delegato,
            strutture_asl.descrizione_comune,
            strutture_asl.id_oia_nodo_temp,
            strutture_asl.data_scadenza,
            strutture_asl.stato,
            strutture_asl.anno,
                CASE
                    WHEN strutture_asl.data_scadenza > now() OR strutture_asl.data_scadenza IS NULL THEN false
                    ELSE true
                END AS disabilitata,
            strutture_asl.descrizione_area_struttura_complessa,
            strutture_asl.uba_ui,
            strutture_asl.somma_ui_area,
            strutture_asl.somma_uba_area,
            strutture_asl.id_lookup_area_struttura_asl,
            strutture_asl.ui_struttura_foglio_att_iniziale,
            strutture_asl.ui_struttura_foglio_att_finale,
            strutture_asl.id_utente_edit,
            strutture_asl.percentuale_area_a,
            strutture_asl.stato_all2,
            strutture_asl.stato_all6,
            strutture_asl.codice_interno_univoco,
            area.description AS descrizione_area_struttura
           FROM strutture_asl
             LEFT JOIN lookup_area_struttura_asl area ON area.code = strutture_asl.id_lookup_area_struttura_asl) a
  ORDER BY a.codice_interno_fk, a.data_scadenza;

ALTER TABLE public.oia_nodo
  OWNER TO postgres;
ALTER TABLE public.oia_nodo ALTER COLUMN id SET DEFAULT nextval('oia_nodo_id_seq'::regclass);

CREATE OR REPLACE RULE strutture_asl_insert AS
    ON INSERT TO oia_nodo DO INSTEAD  INSERT INTO strutture_asl (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, trashed_date, tipologia_struttura, comune, enabled, obsoleto, confermato, id_strumento_calcolo, carico_lavoro_annuo, percentuale_da_sottrarre, carico_lavoro_effettivo, fattori_incidenti_su_carico, codice_interno_fk, nome, id_utente, mail, indirizzo, delegato, descrizione_comune, id_oia_nodo_temp, data_scadenza, stato, anno, uba_ui, ui_struttura_foglio_att_iniziale, ui_struttura_foglio_att_finale, id_utente_edit, percentuale_area_a, codice_interno_univoco)
  VALUES (new.id, new.id_padre, new.id_asl, new.descrizione_lunga, new.n_livello, new.entered, new.entered_by, new.modified, new.modified_by, new.trashed_date, new.tipologia_struttura, new.comune, new.enabled, new.obsoleto, new.confermato, new.id_strumento_calcolo, new.carico_lavoro_annuo, new.percentuale_da_sottrarre, new.carico_lavoro_effettivo, new.fattori_incidenti_su_carico, new.codice_interno_fk, new.nome, new.id_utente, new.mail, new.indirizzo, new.delegato, new.descrizione_comune, new.id_oia_nodo_temp, new.data_scadenza, new.stato, new.anno, new.uba_ui, new.ui_struttura_foglio_att_iniziale, new.ui_struttura_foglio_att_finale, new.id_utente_edit, new.percentuale_area_a, new.codice_interno_univoco);

CREATE OR REPLACE RULE strutture_asl_update AS
    ON UPDATE TO oia_nodo DO INSTEAD  UPDATE strutture_asl SET id_utente_edit = new.id_utente_edit, ui_struttura_foglio_att_iniziale = new.ui_struttura_foglio_att_iniziale, ui_struttura_foglio_att_finale = new.ui_struttura_foglio_att_finale, descrizione_area_struttura_complessa = new.descrizione_area_struttura_complessa, descrizione_lunga = new.descrizione_lunga, uba_ui = new.uba_ui, trashed_date = new.trashed_date, modified = new.modified, modified_by = new.modified_by, carico_lavoro_annuo = new.carico_lavoro_annuo, percentuale_da_sottrarre = new.percentuale_da_sottrarre, carico_lavoro_effettivo = new.carico_lavoro_effettivo, fattori_incidenti_su_carico = new.fattori_incidenti_su_carico, data_scadenza = new.data_scadenza, stato = new.stato, percentuale_area_a = new.percentuale_area_a
  WHERE strutture_asl.id = new.id;


CREATE OR REPLACE RULE "_RETURN" AS
    ON SELECT TO oia_nodo DO INSTEAD  SELECT a.id,
    a.id_padre,
    a.id_asl,
    a.descrizione_lunga,
    a.n_livello,
    a.entered,
    a.entered_by,
    a.modified,
    a.modified_by,
    a.trashed_date,
    a.tipologia_struttura,
    a.comune,
    a.enabled,
    a.obsoleto,
    a.confermato,
    a.id_strumento_calcolo,
    a.carico_lavoro_annuo,
    a.percentuale_da_sottrarre,
    a.carico_lavoro_effettivo,
    a.fattori_incidenti_su_carico,
    a.codice_interno_fk,
    a.nome,
    a.id_utente,
    a.mail,
    a.indirizzo,
    a.delegato,
    a.descrizione_comune,
    a.id_oia_nodo_temp,
    a.data_scadenza,
    a.disabilitata,
    a.stato,
    a.anno,
    a.descrizione_area_struttura_complessa,
    a.uba_ui,
    a.somma_ui_area,
    a.somma_uba_area,
    a.id_lookup_area_struttura_asl,
    a.ui_struttura_foglio_att_iniziale,
    a.ui_struttura_foglio_att_finale,
    a.id_utente_edit,
    a.percentuale_area_a,
    a.stato_all2,
    a.stato_all6,
    a.codice_interno_univoco,
    a.descrizione_area_struttura
   FROM ( SELECT strutture_asl.id,
            strutture_asl.id_padre,
            strutture_asl.id_asl,
            strutture_asl.descrizione_lunga,
            strutture_asl.n_livello,
            strutture_asl.entered,
            strutture_asl.entered_by,
            strutture_asl.modified,
            strutture_asl.modified_by,
            strutture_asl.trashed_date,
            strutture_asl.tipologia_struttura,
            strutture_asl.comune,
            strutture_asl.enabled,
            strutture_asl.obsoleto,
            strutture_asl.confermato,
            strutture_asl.id_strumento_calcolo,
            strutture_asl.carico_lavoro_annuo,
            strutture_asl.percentuale_da_sottrarre,
            strutture_asl.carico_lavoro_effettivo,
            strutture_asl.fattori_incidenti_su_carico,
            strutture_asl.codice_interno_fk,
            strutture_asl.nome,
            strutture_asl.id_utente,
            strutture_asl.mail,
            strutture_asl.indirizzo,
            strutture_asl.delegato,
            strutture_asl.descrizione_comune,
            strutture_asl.id_oia_nodo_temp,
            strutture_asl.data_scadenza,
            strutture_asl.stato,
            strutture_asl.anno,
                CASE
                    WHEN strutture_asl.data_scadenza > now() OR strutture_asl.data_scadenza IS NULL THEN false
                    ELSE true
                END AS disabilitata,
            strutture_asl.descrizione_area_struttura_complessa,
            strutture_asl.uba_ui,
            strutture_asl.somma_ui_area,
            strutture_asl.somma_uba_area,
            strutture_asl.id_lookup_area_struttura_asl,
            strutture_asl.ui_struttura_foglio_att_iniziale,
            strutture_asl.ui_struttura_foglio_att_finale,
            strutture_asl.id_utente_edit,
            strutture_asl.percentuale_area_a,
            strutture_asl.stato_all2,
            strutture_asl.stato_all6,
            strutture_asl.codice_interno_univoco,
            area.description AS descrizione_area_struttura
           FROM strutture_asl
             LEFT JOIN lookup_area_struttura_asl area ON area.code = strutture_asl.id_lookup_area_struttura_asl) a
  ORDER BY a.codice_interno_fk, a.data_scadenza;


CREATE OR REPLACE VIEW public.dpat_strutture_asl AS 
 WITH RECURSIVE recursetree(id, descrizione, nonno, livello, pathid, pathdes, id_asl, idsc, tipostruttura, caricoeffettivo, percentuale, caricoannuo, fattori, codicefk, datascadenza, disabilitato, id_padre, anno, stato, enabled, descrizione_area_struttura_complessa, uba_ui, somma_ui_area, somma_uba_area, id_lookup_area_struttura_asl, ui_struttura_foglio_att_iniziale, ui_struttura_foglio_att_finale, id_utente_edit, percentuale_area_a, stato_all2, stato_all6, descrizione_area_struttura, codice_interno_univoco) AS (
         SELECT n.id,
            n.descrizione_lunga,
            n.id_padre AS nonno,
            n.n_livello,
            n.id_padre::character varying(1000) AS path_id,
            n.descrizione_lunga::character varying(1000) AS pathdes,
            n.id_asl,
            n.id_strumento_calcolo,
            n.tipologia_struttura,
            n.carico_lavoro_effettivo,
            n.percentuale_da_sottrarre,
            n.carico_lavoro_annuo,
            n.fattori_incidenti_su_carico,
            n.codice_interno_fk,
            n.data_scadenza,
            n.disabilitata,
            n.id_padre,
            n.anno,
            n.stato,
            n.enabled,
            n.descrizione_area_struttura_complessa,
            n.uba_ui,
            n.somma_ui_area,
            n.somma_uba_area,
            n.id_lookup_area_struttura_asl,
            n.ui_struttura_foglio_att_iniziale,
            n.ui_struttura_foglio_att_finale,
            n.id_utente_edit,
            n.percentuale_area_a,
            n.stato_all2,
            n.stato_all6,
            area.description AS descrizione_area_struttura,
            n.codice_interno_univoco
           FROM oia_nodo n
             LEFT JOIN lookup_area_struttura_asl area ON area.code = n.id_lookup_area_struttura_asl
             JOIN lookup_site_id asl ON asl.code = n.id_asl
          WHERE n.id_padre > 0 AND n.trashed_date IS NULL
        UNION ALL
         SELECT rt.id,
            rt.descrizione,
            t.id_padre AS nonno,
            rt.livello,
            (((t.id_padre || ';'::text) || rt.pathid::text))::character varying(1000) AS "varchar",
            (((t.descrizione_lunga::text || '->'::text) || rt.pathdes::text))::character varying(1000) AS pathdes,
            rt.id_asl,
            rt.idsc,
            rt.tipostruttura,
            rt.caricoeffettivo,
            rt.percentuale,
            rt.caricoannuo,
            rt.fattori,
            rt.codicefk,
            rt.datascadenza,
            rt.disabilitato,
            rt.id_padre,
            rt.anno,
            rt.stato,
            rt.enabled,
            rt.descrizione_area_struttura_complessa,
            rt.uba_ui,
            rt.somma_ui_area,
            rt.somma_uba_area,
            COALESCE(rt.id_lookup_area_struttura_asl, t.id_lookup_area_struttura_asl) AS id_lookup_area_struttura_asl,
            rt.ui_struttura_foglio_att_iniziale,
            rt.ui_struttura_foglio_att_finale,
            rt.id_utente_edit,
            rt.percentuale_area_a,
            rt.stato_all2,
            rt.stato_all6,
            COALESCE(rt.descrizione_area_struttura, area.description) AS descrizione_area_struttura,
            rt.codice_interno_univoco
           FROM oia_nodo t
             LEFT JOIN lookup_area_struttura_asl area ON area.code = t.id_lookup_area_struttura_asl
             JOIN recursetree rt ON rt.nonno = t.id
          WHERE t.trashed_date IS NULL
        )
 SELECT recursetree.id,
    recursetree.descrizione,
    recursetree.descrizione AS descrizione_struttura,
    recursetree.nonno,
    recursetree.livello,
    recursetree.livello AS n_livello,
    recursetree.pathid,
    recursetree.pathdes,
    recursetree.id_asl,
    recursetree.tipostruttura AS tipologia_struttura,
    recursetree.idsc AS id_strumento_calcolo,
    recursetree.caricoeffettivo AS carico_lavoro_effettivo,
    recursetree.percentuale AS percentuale_da_sottrarre,
    recursetree.caricoannuo AS carico_lavoro_annuo,
    recursetree.fattori AS fattori_incidenti_su_carico,
        CASE
            WHEN recursetree.tipostruttura = 3 THEN 'S'::text
            ELSE 'V'::text
        END AS flag_sian_veterinari,
    recursetree.tipostruttura AS tipologia_struttura_flag,
    recursetree.codicefk AS codice_interno_fk,
    recursetree.datascadenza AS data_scadenza,
    recursetree.disabilitato,
    recursetree.id_padre,
    recursetree.anno,
    recursetree.stato,
    recursetree.enabled,
    padre.descrizione_lunga AS descrizione_padre,
    recursetree.descrizione_area_struttura_complessa,
    recursetree.uba_ui,
    recursetree.somma_ui_area,
    recursetree.somma_uba_area,
    recursetree.id_lookup_area_struttura_asl,
    recursetree.ui_struttura_foglio_att_iniziale,
    recursetree.ui_struttura_foglio_att_finale,
    recursetree.id_utente_edit,
    recursetree.percentuale_area_a,
    recursetree.stato_all2,
    recursetree.stato_all6,
    recursetree.descrizione_area_struttura,
    recursetree.codice_interno_univoco
   FROM recursetree
     LEFT JOIN oia_nodo padre ON padre.codice_interno_fk = recursetree.id_padre AND padre.disabilitata = false
  WHERE recursetree.nonno = 8
  ORDER BY recursetree.id_asl;

ALTER TABLE public.dpat_strutture_asl
  OWNER TO postgres;

  

insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(-1,-1,'Direzione Regionale', 0, current_timestamp, 291, current_timestamp, 291, 1, true, true, 'Direzione Regionale', 2, 2022);
-- tipologia struttura 13 da verificare??
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(1,-1,'Direzione Generale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Direzione Generale', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(2,-1,'U.O.Affari Generali e Contratti', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Affari Generali e Contratti', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(2,-1,'U.O.Affari Legali e Diritto Ambientale', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Affari Legali e Diritto Ambientale', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(2,-1,'U.O.Comunicazione e Ufficio Relazioni con il Pubblico', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Comunicazione e Ufficio Relazioni con il Pubblico', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(2,-1,'U.O.Qualità Sicurezza ed Energia', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Qualità Sicurezza ed Energia', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(2,-1,'U.O.Pianificazione Strategica Formazione e Progetti', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Pianificazione Strategica Formazione e Progetti', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(2,-1,'U.O.Controllo di Gestione Valutazione e Controllo Analogo', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Controllo di Gestione Valutazione e Controllo Analogo', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(2,-1,'U.O.Sistemi Informativi e Informatici', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Sistemi Informativi e Informatici', 2, 2022);

insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(1,-1,'Direzione Amministrativa', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Direzione Amministrativa', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(4,-1,'U.O.Personale', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Personale', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(4,-1,'U.O.Bilancio Contabilità e Finanze', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Bilancio Contabilità e Finanze', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(4,-1,'U.O.Provveditorato Economato e Patrimonio', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Provveditorato Economato e Patrimonio', 2, 2022);

insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(1,-1,'Direzione Tecnica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Direzione Tecnica', 2, 2022);

	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(3,-1,'U.O.C.Sostenibilità Ambientale e Controlli', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.C.Sostenibilità Ambientale e Controlli', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(3,-1,'U.O.C.Siti Contaminanti e Bonifiche', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.C.Siti Contaminanti e Bonifiche', 2, 2022);
	insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	(3,-1,'U.O.C.Monitoraggi e CEMEC', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.C.Monitoraggi e CEMEC', 2, 2022);

insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(8,201,'Dipartimento Provinciale di Avellino', 0, current_timestamp, 291, current_timestamp, 291, 1, true, true, 'Dipartimento Provinciale di Avellino', 2, 2022);
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(8,202,'Dipartimento Provinciale di Benevento', 0, current_timestamp, 291, current_timestamp, 291, 1, true, true, 'Dipartimento Provinciale di Benevento', 2, 2022);
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(8,203,'Dipartimento Provinciale di Caserta', 0, current_timestamp, 291, current_timestamp, 291, 1, true, true, 'Dipartimento Provinciale di Caserta', 2, 2022);
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(8,204,'Dipartimento Provinciale di Napoli', 0, current_timestamp, 291, current_timestamp, 291, 1, true, true, 'Dipartimento Provinciale di Napoli', 2, 2022);
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(8,207,'Dipartimento Provinciale di Salerno', 0, current_timestamp, 291, current_timestamp, 291, 1, true, true, 'Dipartimento Provinciale di Salerno', 2, 2022);

-- figli di Avellino complessa
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(19,201,'Area Analitica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Analitica', 2, 2022);
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(19,201,'Area Territoriale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Territoriale', 2, 2022);

-- figli di Benevento complessa
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(26,202,'Area Analitica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Analitica', 2, 2022);
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(26,202,'Area Territoriale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Territoriale', 2, 2022);

-- figli di Caserta complessa
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(21,203,'Area Analitica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Analitica', 2, 2022);
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(21,203,'Area Territoriale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Territoriale', 2, 2022);

-- figli di Napoli complessa
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(22,204,'Area Analitica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Analitica', 2, 2022);
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(22,204,'Area Territoriale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Territoriale', 2, 2022);

-- figli di SA complessa
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(23,207,'Area Analitica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Analitica', 2, 2022);
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(23,207,'Area Territoriale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Territoriale', 2, 2022);
insert into oia_nodo (id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
(23,207,'Centro Regionale Radioattivita''', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Centro Regionale Radioattivita''', 2, 2022);


update oia_nodo set codice_interno_fk = id;
--------------------------------------------------------------------------------------------
-- verificare le modifiche tra strutture_asl, strumento_calcolo
delete from dpat_strumento_calcolo where id <57
update dpat_strumento_calcolo set id_asl = 201 where id=57; 
insert into dpat_strumento_calcolo (anno, id_asl, entered, modified, enteredby, modifiedby, id, completo, riaperto, stato)
select 2022, 202, entered, modified, enteredby, modifiedby, 58, completo, riaperto, stato from dpat_strumento_calcolo where id=57;
insert into dpat_strumento_calcolo (anno, id_asl, entered, modified, enteredby, modifiedby, id, completo, riaperto, stato)
select 2022, 203, entered, modified, enteredby, modifiedby, 59, completo, riaperto, stato from dpat_strumento_calcolo where id=57;
insert into dpat_strumento_calcolo (anno, id_asl, entered, modified, enteredby, modifiedby, id, completo, riaperto, stato)
select 2022, 204, entered, modified, enteredby, modifiedby, 60, completo, riaperto, stato from dpat_strumento_calcolo where id=57;
insert into dpat_strumento_calcolo (anno, id_asl, entered, modified, enteredby, modifiedby, id, completo, riaperto, stato)
select 2022, 207, entered, modified, enteredby, modifiedby, 61, completo, riaperto, stato from dpat_strumento_calcolo where id=57;
update strutture_asl set id_strumento_calcolo = 57 where id_asl=201;
update strutture_asl set id_strumento_calcolo = 58 where id_asl=202;
update strutture_asl set id_strumento_calcolo = 59 where id_asl=203;
update strutture_asl set id_strumento_calcolo = 60 where id_asl=204;
update strutture_asl set id_strumento_calcolo = 61 where id_asl=207;

update strutture_asl set codice_interno_fk = id;
update strutture_asl set id=8 where id_padre=-1; -- nodo regione
update strutture_asl set id_padre=8 where id_padre=1; -- nodo regione
---------------------------------------------------------------------------------------------


CREATE OR REPLACE VIEW public.dpat_strumento_calcolo_nominativi AS 
 SELECT DISTINCT ON (a.codice_interno_fk) a.codice_interno_fk AS codice_interno_fk_,
    a.id_anagrafica_nominativo,
    a.id_lookup_qualifica,
    a.carico_lavoro_annuale,
    a.fattori_incidenti_su_carico,
    a.carico_lavoro_effettivo_annuale,
    a.id,
    a.id_dpat_strumento_calcolo_strutture,
    a.percentuale_ui_da_sottrarre,
    a.trashed_date,
    a.id_old_anagrafica_nominativo,
    a.confermato,
    a.data_conferma,
    a.confermato_da,
    a.data_scadenza,
    a.stato,
    a.codice_interno_fk,
    a.entered_by,
    a.entered,
    a.modified,
    a.modified_by,
        CASE
            WHEN a.descrizione IS NOT NULL THEN a.descrizione
            ELSE ''::character varying
        END::text::character varying(1000) AS descrizione,
    a.id_struttura,
    a.level,
    a.id_asl,
    a.anno,
    a.disabilitato,
    a.id_strumento_calcolo,
    a.uba_ui,
    a.stato_struttura
   FROM ( SELECT dpat_strumento_calcolo_nominativi_.id_anagrafica_nominativo,
            dpat_strumento_calcolo_nominativi_.id_lookup_qualifica,
            dpat_strumento_calcolo_nominativi_.carico_lavoro_annuale,
            dpat_strumento_calcolo_nominativi_.fattori_incidenti_su_carico,
            dpat_strumento_calcolo_nominativi_.carico_lavoro_effettivo_annuale,
            dpat_strumento_calcolo_nominativi_.id,
            dpat_strumento_calcolo_nominativi_.id_dpat_strumento_calcolo_strutture,
            dpat_strumento_calcolo_nominativi_.percentuale_ui_da_sottrarre,
            dpat_strumento_calcolo_nominativi_.trashed_date,
            dpat_strumento_calcolo_nominativi_.id_old_anagrafica_nominativo,
            dpat_strumento_calcolo_nominativi_.confermato,
            dpat_strumento_calcolo_nominativi_.data_conferma,
            dpat_strumento_calcolo_nominativi_.confermato_da,
            dpat_strumento_calcolo_nominativi_.data_scadenza,
            dpat_strumento_calcolo_nominativi_.stato,
            dpat_strumento_calcolo_nominativi_.codice_interno_fk,
            dpat_strumento_calcolo_nominativi_.entered_by,
            dpat_strumento_calcolo_nominativi_.entered,
            dpat_strumento_calcolo_nominativi_.modified,
            dpat_strumento_calcolo_nominativi_.modified_by,
            scstr.pathdes AS descrizione,
            scstr.id AS id_struttura,
            lq.livello_qualifiche_dpat AS level,
            scstr.id_asl,
            scstr.anno,
            scstr.disabilitato,
            scstr.id_strumento_calcolo,
            dpat_strumento_calcolo_nominativi_.uba_ui,
            scstr.stato AS stato_struttura
           FROM dpat_strumento_calcolo_nominativi_
             LEFT JOIN dpat_strutture_asl scstr ON scstr.codice_interno_fk = dpat_strumento_calcolo_nominativi_.id_dpat_strumento_calcolo_strutture AND scstr.disabilitato = false
             LEFT JOIN lookup_qualifiche lq ON lq.code = dpat_strumento_calcolo_nominativi_.id_lookup_qualifica
          WHERE dpat_strumento_calcolo_nominativi_.trashed_date IS NULL AND (dpat_strumento_calcolo_nominativi_.data_scadenza > (now() + '1 day'::interval) OR dpat_strumento_calcolo_nominativi_.data_scadenza IS NULL)) a
  ORDER BY a.codice_interno_fk, a.data_scadenza;

ALTER TABLE public.dpat_strumento_calcolo_nominativi
  OWNER TO postgres;

-- Rule: nominativi_insert ON public.dpat_strumento_calcolo_nominativi

-- DROP RULE nominativi_insert ON public.dpat_strumento_calcolo_nominativi;

CREATE OR REPLACE RULE nominativi_insert AS
    ON INSERT TO dpat_strumento_calcolo_nominativi DO INSTEAD  INSERT INTO dpat_strumento_calcolo_nominativi_ (id, id_anagrafica_nominativo, id_lookup_qualifica, carico_lavoro_annuale, fattori_incidenti_su_carico, percentuale_ui_da_sottrarre, carico_lavoro_effettivo_annuale, id_dpat_strumento_calcolo_strutture, entered_by, entered, stato, codice_interno_fk, uba_ui)
  VALUES (new.id, new.id_anagrafica_nominativo, new.id_lookup_qualifica, new.carico_lavoro_annuale, new.fattori_incidenti_su_carico, new.percentuale_ui_da_sottrarre, new.carico_lavoro_effettivo_annuale, new.id_dpat_strumento_calcolo_strutture, new.entered_by, new.entered, new.stato, new.codice_interno_fk, new.uba_ui);

-- Rule: nominativi_update ON public.dpat_strumento_calcolo_nominativi

-- DROP RULE nominativi_update ON public.dpat_strumento_calcolo_nominativi;

CREATE OR REPLACE RULE nominativi_update AS
    ON UPDATE TO dpat_strumento_calcolo_nominativi DO INSTEAD  UPDATE dpat_strumento_calcolo_nominativi_ SET trashed_date = new.trashed_date, data_scadenza = new.data_scadenza, modified = new.modified, modified_by = new.modified_by, stato = new.stato
  WHERE dpat_strumento_calcolo_nominativi_.id = new.id;

delete from dpat_strumento_calcolo_nominativi_  where id > 1;
select * from dpat_strumento_calcolo_nominativi  


-- Function: public.dbi_insert_utente(character varying, character varying, integer, integer, integer, boolean, integer, character varying, character varying, character varying, text, text, character varying, character varying, timestamp with time zone, integer)

-- DROP FUNCTION public.dbi_insert_utente(character varying, character varying, integer, integer, integer, boolean, integer, character varying, character varying, character varying, text, text, character varying, character varying, timestamp with time zone, integer);

CREATE OR REPLACE FUNCTION public.dbi_insert_utente(
    usr character varying,
    password character varying,
    role_id integer,
    enteredby integer,
    modifiedby integer,
    enabled boolean,
    site_id integer,
    namefirst character varying,
    namelast character varying,
    cf character varying,
    notes text,
    luogo text,
    nickname character varying,
    email character varying,
    expires timestamp with time zone,
    id_struttura integer)
  RETURNS text AS
$BODY$
   DECLARE
msg text ;
us_id int ;
con_id int;
us_id2 int ;
flag boolean;
delegavisibilita text ;
   
BEGIN

	IF (role_id=-1) THEN
		enabled:=false;
	ELSE
		enabled:=true;
	END IF;

	IF (id_struttura=-1) THEN
		id_struttura:=null;
	END IF;

	us_id := (select user_id from access a where a.username = usr and a.trashed_date is null);
	IF (us_id is null) THEN	
		us_id=nextVal('access_user_id_seq');
		con_id=nextVal('contact_contact_id_seq');
		if (site_id>0)
		then
			delegavisibilita:=(select description from lookup_site_id where code =site_id);
			else
			delegavisibilita:=cf;
			end if ;
		
		INSERT INTO access ( user_id, username, password, contact_id, site_id, role_id, enteredby, modifiedby, timezone, currency, language, enabled, expires) 
		VALUES (  us_id, usr, password, con_id, site_id, role_id, 964, 964, 'Europe/Berlin', 'EUR', 'it_IT', enabled, expires::timestamp without time zone); 

		con_id=currVal('contact_contact_id_seq');
		us_id=currVal('access_user_id_seq');
		INSERT INTO contact ( contact_id, user_id, namefirst, namelast, enteredby, modifiedby, site_id, codice_fiscale, notes, enabled,luogo,nickname,visibilita_delega ) 
		VALUES ( con_id, us_id, upper(namefirst), upper(namelast), 964, 964, site_id, cf, notes, enabled,luogo,nickname,delegavisibilita );

			 
		con_id=currVal('contact_contact_id_seq');
		INSERT INTO contact_emailaddress(contact_id, emailaddress_type, email, enteredby, modifiedby, primary_email)
		VALUES (con_id, 1, email, 964, 964, true);

		--flag := (select r.in_dpat from role r where r.enabled and r.role_id = $3);
		--IF (flag is false) THEN
		--	flag := (select r.in_nucleo_ispettivo from role r where r.enabled and r.role_id = $3);
		--	IF (flag is true) THEN	
		--		INSERT INTO anagrafica_nominativo (id_asl,nome,cognome,cf,mail,disabled,user_id_access,id_ruolo) 
		--		VALUES (site_id,namefirst,namelast,cf,email,true,us_id,role_id);
		--	END IF;
		--END IF;
		
	END IF;

	IF (id_struttura is not null) THEN
		us_id2=nextVal('access_collegamento_id_seq');
		INSERT INTO access_collegamento (id,id_utente,id_collegato,enabled) 
		VALUES (us_id2,us_id,id_canile,enabled); 
	END IF;
	
	msg = 'OK';
	RETURN msg;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.dbi_insert_utente(character varying, character varying, integer, integer, integer, boolean, integer, character varying, character varying, character varying, text, text, character varying, character varying, timestamp with time zone, integer)
  OWNER TO postgres;

INSERT INTO ACCESS_(user_id, username, password, contact_id, role_id, entered, enteredby, modifiedby) values(964, 'admin','',964, 1,now(), 964, 964) 

SELECT * FROM public.dbi_insert_utente(
    'rita.mele',
    md5('rita.mele'),
    1,
    1,
    32,
    true,
    -1,
    'Rita',
    'Mele',
    'MLERTI86H55F839D',
    '',
    '',
    '',
    '',
    NULL,
    -1)

SELECT * FROM public.dbi_insert_utente(
    'b.sansone',
    md5('b.sansone'),
    1,
    32,
    1,
    true,
    -1,
    'Bartolo',
    'Sansone',
    'SNSBTL86S12G813J',
    '',
    '',
    '',
    '',
    NULL,
    -1)

 
SELECT * FROM public.dbi_insert_utente(
    's.liccardo',
    md5('simone'),
    1,
    32,
    1,
    true,
    -1,
    'Simone',
    'Liccardo',
    'LCCSMN00E05E054Y',
    '',
    '',
    '',
    '',
    NULL,
    -1)

   
SELECT * FROM public.dbi_insert_utente(
    'g.marano',
    md5('giuseppe'),
    1,
    32,
    1,
    true,
    -1,
    'Giuseppe',
    'Marano',
    'MRNGPP00R09F839B',
    '',
    '',
    '',
    '',
    NULL,
    -1)

    SELECT * FROM ACCESS
insert into access_dati(user_id, site_id, visibilita_delega) values(40341,-1,'')
insert into access_dati(user_id, site_id, visibilita_delega) values(40342,-1,'')
insert into access_dati(user_id, site_id, visibilita_delega) values(40340,-1,'')
insert into access_dati(user_id, site_id, visibilita_delega) values(40343,-1,'')

------------------------------------------ anagrafiche
delete from ricerche_anagrafiche_old_materializzata;
---------------------------------- controlli ------------------
delete from lookup_tipo_controllo where code > 7;
update lookup_tipo_controllo set description = 'ISPEZIONE AIA' where code=4; -- la specifica ordinaria, straordinaria e non programmata è del cu e non della tecnica


-- View: public.anagrafica_stabilimenti_puliti

-- DROP VIEW public.anagrafica_stabilimenti_puliti;

CREATE OR REPLACE VIEW public.anagrafica_stabilimenti_puliti AS 
 SELECT DISTINCT op.id AS id_opu_operatore,
    ti.description AS tipoi_mpresa,
    ts.description AS tipo_societa,
    op.ragione_sociale,
    op.partita_iva,
    op.codice_fiscale_impresa,
    op.domicilio_digitale,
    sogg.id AS id_soggetto_fisico,
    sogg.nome,
    sogg.cognome,
    sogg.codice_fiscale AS cf_soggetto,
    sogg.data_nascita,
    sogg.comune_nascita,
    sogg.sesso,
    sogg.indirizzo_id AS id_indirizzo_residenza,
    cres.nome AS comune_residenza,
    lpres.description AS provincia_residenza,
    topres.description AS toponimo_residenza,
    res.via AS indirizzo_residenza,
    res.civico AS civico_residenza,
    res.cap AS cap_resindenza,
    op.id_indirizzo AS id_indirizzo_sede_legale,
    csl.nome AS comune_sede_legale,
    lpsl.description AS provincia_sede_legale,
    top.description AS toponimo_sede_legale,
    sl.via AS indirizzo_sede_legale,
    sl.civico AS civico_sede_legale,
    sl.cap AS cap_sede_legale,
    st.id AS id_stabilimento,
    st.id_indirizzo AS id_indirizzo_sede_operativa,
    cso.nome AS comune_sede_operativa,
    lpso.description AS provincia_sede_operativa,
    topso.description AS toponimo_sede_operativa,
    so.via AS indirizzo_sede_operativa,
    so.civico AS civicco_sede_operativa,
    so.cap AS cap_sede_operativa,
    lta.description AS tipo_attivita,
    ltc.description AS tipo_carattere
   FROM opu_operatore op
     JOIN opu_rel_operatore_soggetto_fisico relso ON relso.id_operatore = op.id AND relso.enabled
     JOIN opu_soggetto_fisico sogg ON sogg.id = relso.id_soggetto_fisico
     JOIN opu_indirizzo res ON res.id = sogg.indirizzo_id
     LEFT JOIN comuni1 cres ON cres.id = res.comune
     LEFT JOIN lookup_province lpres ON lpres.code = cres.cod_provincia::integer
     LEFT JOIN lookup_toponimi topres ON topres.code = res.toponimo
     LEFT JOIN lookup_opu_tipo_impresa ti ON ti.code = op.tipo_impresa
     LEFT JOIN lookup_opu_tipo_impresa_societa ts ON ts.code = op.tipo_societa
     JOIN opu_indirizzo sl ON sl.id = op.id_indirizzo
     LEFT JOIN comuni1 csl ON csl.id = sl.comune
     LEFT JOIN lookup_province lpsl ON lpsl.code = csl.cod_provincia::integer
     LEFT JOIN lookup_toponimi top ON top.code = sl.toponimo
     JOIN opu_stabilimento st ON st.id_operatore = op.id
     JOIN opu_indirizzo so ON so.id = st.id_indirizzo
     LEFT JOIN comuni1 cso ON cso.id = so.comune
     LEFT JOIN lookup_province lpso ON lpso.code = cso.cod_provincia::integer
     LEFT JOIN lookup_toponimi topso ON topso.code = so.toponimo
     JOIN opu_lookup_tipologia_attivita lta ON lta.code = st.tipo_attivita
     JOIN opu_lookup_tipologia_carattere ltc ON ltc.code = st.tipo_carattere
  WHERE 1 = 1 AND op.trashed_date IS NULL AND st.trashed_date IS NULL AND op.domicilio_digitale IS NOT NULL AND op.domicilio_digitale <> ''::text AND res.toponimo > 0 AND
        CASE
            WHEN op.tipo_impresa <> 1 THEN sl.toponimo > 0 AND res.civico <> ''::text AND sl.civico <> ''::text
            ELSE 1 = 1
        END AND
        CASE
            WHEN so.id > 0 AND st.tipo_attivita <> 2 THEN topso.code > 0 AND so.civico IS NOT NULL AND so.civico <> ''::text
            ELSE 1 = 1
        END
  ORDER BY op.id, st.id;

ALTER TABLE public.anagrafica_stabilimenti_puliti
  OWNER TO postgres;


-- anagrafica dati aggiuntivi
drop TABLE public.opu_dati_aggiuntivi

CREATE TABLE public.opu_dati_aggiuntivi
(
  id serial primary key,
  riferimento_id integer,
  riferimento_id_nome_tab text,
  id_aia text,
  tipo_autorizzazione integer,
  num_decreto text,
  data_decreto timestamp without time zone,
  nota text,
  burc text,
  denominazione_stabilimento text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.opu_dati_aggiuntivi
  OWNER TO postgres;
  
ALTER TABLE opu_dati_aggiuntivi ADD COLUMN nome_responsabile text;
ALTER TABLE opu_dati_aggiuntivi ADD COLUMN cognome_responsabile text;
ALTER TABLE opu_dati_aggiuntivi ADD COLUMN cf_responsabile text;


CREATE OR REPLACE FUNCTION public.insert_gestione_anagrafica(
    campi_fissi hstore,
    campi_estesi hstore,
    utente_in integer,
    id_tipo_pratica_in integer,
    numero_pratica_in text,
    id_comune_in integer)
  RETURNS integer AS
$BODY$
DECLARE 

	_id_indirizzo_sede_legale integer;
	_id_indirizzo_stabilimento integer;
	_id_indirizzo_sogg_fis integer;
	_id_sogg_fis integer;
	_id_operatore integer;
	_id_stabilimento integer;
	_comune_nascita_testo text;
	_codice_univoco_ml text;
	_data_inizio text;
	_data_fine text;
	_num_riconoscimento text;
	_tipo_carattere text;
	r integer;
	_id_suap_operatore integer;
	_id_suap_stabilimento integer;
	_alt_id_suap_stabilimento integer;
	_id_suap_sogg_fis integer;
	_n_categorizzabili integer;
	_numero_registrazione_osa text;
        
BEGIN	

_n_categorizzabili := -1;

--fare le assegnazioni alla variabili dichiarate sopra sia nel caso di dati recuperati che di nuovo inserimento

	IF (length(trim(campi_fissi ->'id_impresa_recuperata')) <> 0) THEN	
		_id_operatore := (campi_fissi -> 'id_impresa_recuperata')::integer;
		--update opu_operatore
		update opu_operatore 
			set codice_fiscale_impresa = campi_fissi -> 'codice_fiscale', partita_iva = campi_fissi -> 'partita_iva',
			    ragione_sociale = campi_fissi -> 'ragione_sociale', domicilio_digitale = campi_fissi -> 'email_impresa',
			    tipo_societa = (campi_fissi -> 'tipo_impresa')::integer 
			where id = _id_operatore;
			
		--IF (length(trim(campi_fissi ->'via_sede_legale')) <> 0 OR length(trim(campi_fissi -> 'comune_estero_sede_legale')) <> 0) THEN
		IF (length(trim(campi_fissi ->'via_sede_legale')) <> 0 OR (campi_fissi -> 'nazione_sede_legale')::integer <> 106) THEN
			--inserisci indirizzo impresa
			_id_indirizzo_sede_legale := insert_opu_noscia_indirizzo((campi_fissi -> 'nazione_sede_legale')::integer, campi_fissi -> 'cod_provincia_sede_legale',
								       (campi_fissi -> 'cod_comune_sede_legale')::integer, campi_fissi -> 'comune_estero_sede_legale', 
								       (campi_fissi -> 'toponimo_sede_legale')::integer, campi_fissi -> 'via_sede_legale', campi_fissi -> 'cap_leg', campi_fissi -> 'civico_sede_legale',
								       (campi_fissi -> 'latitudine_leg')::double precision, (campi_fissi -> 'longitudine_leg')::double precision,
								       campi_fissi -> 'presso_sede_legale');
			--update id indirizzo impresa
			update opu_operatore set id_indirizzo = _id_indirizzo_sede_legale where id = _id_operatore;
			
		END IF;

		IF (length(trim(campi_fissi ->'id_rapp_legale_recuperato')) <> 0) THEN
			_id_sogg_fis := (campi_fissi -> 'id_rapp_legale_recuperato')::integer;
			--update opu_soggetto_fisico
			--gestione nel caso di provenienza estera
			IF (campi_fissi -> 'nazione_nascita_rapp_leg') = '106' THEN
				select nome into _comune_nascita_testo from comuni1 where id = (campi_fissi -> 'comune_nascita_rapp_leg')::integer limit 1;
				update opu_soggetto_fisico 
					set cognome = campi_fissi -> 'cognome_rapp_leg', nome = campi_fissi -> 'nome_rapp_leg',
					    comune_nascita = _comune_nascita_testo, codice_fiscale = campi_fissi -> 'codice_fiscale_rappresentante',
					    sesso = campi_fissi -> 'sesso_rapp_leg', telefono = campi_fissi -> 'telefono_rapp_leg',
					    email = campi_fissi -> 'email_rapp_leg', data_nascita = (campi_fissi -> 'data_nascita_rapp_leg')::timestamp without time zone, 
					    provenienza_estera = false, id_nazione_nascita = (campi_fissi -> 'nazione_nascita_rapp_leg')::integer, 
					    id_comune_nascita = (campi_fissi -> 'comune_nascita_rapp_leg')::integer
				        where id = _id_sogg_fis;
			ELSIF (length(trim(campi_fissi ->'nazione_nascita_rapp_leg')) <> 0) THEN
				update opu_soggetto_fisico 
					set cognome = campi_fissi -> 'cognome_rapp_leg', nome = campi_fissi -> 'nome_rapp_leg',
					    comune_nascita = campi_fissi -> 'comune_nascita_rapp_leg', codice_fiscale = campi_fissi -> 'codice_fiscale_rappresentante',
					    sesso = campi_fissi -> 'sesso_rapp_leg', telefono = campi_fissi -> 'telefono_rapp_leg',
					    email = campi_fissi -> 'email_rapp_leg', data_nascita = (campi_fissi -> 'data_nascita_rapp_leg')::timestamp without time zone, 
					    provenienza_estera = true, id_nazione_nascita = (campi_fissi -> 'nazione_nascita_rapp_leg')::integer
				        where id = _id_sogg_fis;
				
			END IF;
				    
			--IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR length(trim(campi_fissi -> 'comune_residenza_estero_soggfis')) <> 0) THEN
			IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR (campi_fissi -> 'nazione_soggfis')::integer <> 106) THEN
				--insert indirizzo soggetto fisico
				_id_indirizzo_sogg_fis := insert_opu_noscia_indirizzo((campi_fissi -> 'nazione_soggfis')::integer, campi_fissi -> 'cod_provincia_soggfis',
								       (campi_fissi -> 'cod_comune_soggfis')::integer, campi_fissi -> 'comune_residenza_estero_soggfis',
								       (campi_fissi -> 'toponimo_soggfis')::integer, campi_fissi -> 'via_soggfis', campi_fissi -> 'cap_soggfis', campi_fissi -> 'civico_soggfis',
								       (campi_fissi -> 'latitudine_soggfis')::double precision, (campi_fissi -> 'longitudine_soggfis')::double precision,
								       campi_fissi -> 'presso_soggfis');
				--update id indirizzo soggetto fisico
				update opu_soggetto_fisico set indirizzo_id = _id_indirizzo_sogg_fis where id = _id_sogg_fis;
			END IF;
		ELSE
			--inserisci indirizzo soggetto fisico
			--IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR length(trim(campi_fissi -> 'comune_residenza_estero_soggfis')) <> 0) THEN
			IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR (campi_fissi -> 'nazione_soggfis')::integer <> 106) THEN
				_id_indirizzo_sogg_fis := insert_opu_noscia_indirizzo((campi_fissi -> 'nazione_soggfis')::integer, campi_fissi -> 'cod_provincia_soggfis',
									       (campi_fissi -> 'cod_comune_soggfis')::integer, campi_fissi -> 'comune_residenza_estero_soggfis',
									       (campi_fissi -> 'toponimo_soggfis')::integer, campi_fissi -> 'via_soggfis', campi_fissi -> 'cap_soggfis', campi_fissi -> 'civico_soggfis',
									       (campi_fissi -> 'latitudine_soggfis')::double precision, (campi_fissi -> 'longitudine_soggfis')::double precision,
									       campi_fissi -> 'presso_soggfis');
		        END IF;
			--inserisci soggetto fisico
			IF (length(trim(campi_fissi ->'codice_fiscale_rappresentante')) <> 0 OR (campi_fissi -> 'nazione_nascita_rapp_leg')::integer <> 106) THEN
				_id_sogg_fis := insert_opu_noscia_soggetto_fisico(campi_fissi -> 'nome_rapp_leg', campi_fissi -> 'cognome_rapp_leg', (campi_fissi -> 'nazione_nascita_rapp_leg')::integer,
									  campi_fissi -> 'codice_fiscale_rappresentante', campi_fissi -> 'sesso_rapp_leg', utente_in, 
									  campi_fissi -> 'telefono_rapp_leg', campi_fissi -> 'email_rapp_leg', _id_indirizzo_sogg_fis,
									  campi_fissi -> 'comune_nascita_rapp_leg', (campi_fissi -> 'data_nascita_rapp_leg')::timestamp without time zone);
		        END IF;
			--inserisci relazione operatore-soggettofisico
			--inserimento relazione opu_rel_operatore_soggetto_fisico
			IF _id_sogg_fis is not null AND _id_operatore is not null THEN
				perform insert_opu_noscia_rel_impresa_soggfis(_id_sogg_fis, _id_operatore);
			END IF;
		END IF;
	ELSE
		--inserisciti impresa e soggetto fisico ex novo (indirizzi compresi)
		--inserimento indirizzo soggetto fisico/rapp legale
		--IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR length(trim(campi_fissi -> 'comune_residenza_estero_soggfis')) <> 0) THEN
		IF (length(trim(campi_fissi ->'via_soggfis')) <> 0 OR (campi_fissi -> 'nazione_soggfis')::integer <> 106) THEN
			_id_indirizzo_sogg_fis := insert_opu_noscia_indirizzo((campi_fissi -> 'nazione_soggfis')::integer, campi_fissi -> 'cod_provincia_soggfis',
									       (campi_fissi -> 'cod_comune_soggfis')::integer, campi_fissi -> 'comune_residenza_estero_soggfis',
									       (campi_fissi -> 'toponimo_soggfis')::integer, campi_fissi -> 'via_soggfis', campi_fissi -> 'cap_soggfis', campi_fissi -> 'civico_soggfis',
									       (campi_fissi -> 'latitudine_soggfis')::double precision, (campi_fissi -> 'longitudine_soggfis')::double precision,
									       campi_fissi -> 'presso_soggfis');
		END IF;

		--inserimento indirizzo sede legale/impresa
		--IF (length(trim(campi_fissi ->'via_sede_legale')) <> 0 OR length(trim(campi_fissi -> 'comune_estero_sede_legale')) <> 0) THEN
		IF (length(trim(campi_fissi ->'via_sede_legale')) <> 0 OR (campi_fissi -> 'nazione_sede_legale')::integer <> 106) THEN
			_id_indirizzo_sede_legale := insert_opu_noscia_indirizzo((campi_fissi -> 'nazione_sede_legale')::integer, campi_fissi -> 'cod_provincia_sede_legale',
									       (campi_fissi -> 'cod_comune_sede_legale')::integer, campi_fissi -> 'comune_estero_sede_legale', 
									       (campi_fissi -> 'toponimo_sede_legale')::integer, campi_fissi -> 'via_sede_legale', campi_fissi -> 'cap_leg', campi_fissi -> 'civico_sede_legale',
									       (campi_fissi -> 'latitudine_leg')::double precision, (campi_fissi -> 'longitudine_leg')::double precision,
									       campi_fissi -> 'presso_sede_legale');
		END IF;

		--inserimento soggetto fisico/rapp legale
		IF (length(trim(campi_fissi ->'codice_fiscale_rappresentante')) <> 0 OR (campi_fissi -> 'nazione_nascita_rapp_leg')::integer <> 106) THEN
			_id_sogg_fis := insert_opu_noscia_soggetto_fisico(campi_fissi -> 'nome_rapp_leg', campi_fissi -> 'cognome_rapp_leg', (campi_fissi -> 'nazione_nascita_rapp_leg')::integer,
									  campi_fissi -> 'codice_fiscale_rappresentante', campi_fissi -> 'sesso_rapp_leg', utente_in, 
									  campi_fissi -> 'telefono_rapp_leg', campi_fissi -> 'email_rapp_leg', _id_indirizzo_sogg_fis,
									  campi_fissi -> 'comune_nascita_rapp_leg', (campi_fissi -> 'data_nascita_rapp_leg')::timestamp without time zone);
		END IF;

		--inserimento impresa/ operatore
		IF (length(trim(campi_fissi ->'partita_iva')) <> 0 OR length(trim(campi_fissi -> 'codice_fiscale')) <> 0) THEN
			_id_operatore := insert_opu_noscia_impresa(campi_fissi -> 'codice_fiscale', campi_fissi -> 'partita_iva', campi_fissi -> 'ragione_sociale',
								   utente_in, campi_fissi -> 'email_impresa', (campi_fissi -> 'tipo_impresa')::integer, _id_indirizzo_sede_legale);
		END IF;

		--inserimento relazione opu_rel_operatore_soggetto_fisico
		IF _id_sogg_fis is not null AND _id_operatore is not null THEN
			perform insert_opu_noscia_rel_impresa_soggfis(_id_sogg_fis, _id_operatore);
		END IF;
	END IF;

	--gestione stabilimento
	--inserimento indirizzo stabilimento
	_id_indirizzo_stabilimento := _id_indirizzo_sede_legale;
	IF (length(trim(campi_fissi ->'via_stab')) <> 0) THEN
		_id_indirizzo_stabilimento := insert_opu_noscia_indirizzo(106, campi_fissi -> 'cod_provincia_stab',
								       (campi_fissi -> 'cod_comune_stab')::integer, null, (campi_fissi -> 'toponimo_stab')::integer,
								       campi_fissi -> 'via_stab', campi_fissi -> 'cap_stab', campi_fissi -> 'civico_stab',
								       (campi_fissi -> 'latitudine_stab')::double precision, (campi_fissi -> 'longitudine_stab')::double precision,
								       campi_fissi -> 'presso_stab');
	END IF;
	
	--inserisci stabilimento e recupero id stabilimento inserito
	IF _id_indirizzo_stabilimento = _id_indirizzo_sede_legale THEN
		_numero_registrazione_osa := genera_numero_registrazione_da_comune((campi_fissi -> 'cod_comune_sede_legale')::integer);
	ELSE 
		_numero_registrazione_osa := genera_numero_registrazione_da_comune((campi_fissi -> 'cod_comune_stab')::integer);
	END IF;
	
	IF _id_indirizzo_stabilimento is not null THEN
		SELECT distinct(split_part(key,'_',2)) into r FROM each(campi_fissi) where key ilike '%lineaattivita_%' || '%_codice_univoco_ml%' limit 1;
		_codice_univoco_ml := campi_fissi -> concat('lineaattivita_', r,'_codice_univoco_ml');
		--_id_stabilimento := insert_opu_noscia_stabilimento(_id_operatore, _id_indirizzo_stabilimento, utente_in, _codice_univoco_ml, campi_fissi -> 'numero_registrazione_stabilimento');
		_id_stabilimento := insert_opu_noscia_stabilimento(_id_operatore, _id_indirizzo_stabilimento, utente_in, _codice_univoco_ml, _numero_registrazione_osa);
	END IF;

	IF _id_indirizzo_stabilimento = _id_indirizzo_sede_legale THEN
		update opu_stabilimento set id_asl = (select codiceistatasl::integer from comuni1 where id = (campi_fissi -> 'cod_comune_sede_legale')::integer) where id = _id_stabilimento;
	END IF;

	--inserimento relazione stabilimento linea di attivita
	FOR r IN SELECT distinct(split_part(key,'_',2)) FROM each(campi_fissi) where key ilike '%lineaattivita_%'
	    LOOP
		_codice_univoco_ml := campi_fissi -> concat('lineaattivita_', r,'_codice_univoco_ml');
		_data_inizio := campi_fissi -> concat('lineaattivita_', r,'_data_inizio_attivita');
		_data_fine := campi_fissi -> concat('lineaattivita_', r,'_data_fine_attivita');
		_num_riconoscimento := campi_fissi -> concat('lineaattivita_', r,'_num_riconoscimento');
		_tipo_carattere := campi_fissi -> concat('lineaattivita_', r,'_tipo_carattere_attivita');
		
		IF (_id_stabilimento is not null AND length(trim(_codice_univoco_ml)) <> 0) THEN
			perform insert_opu_noscia_rel_stabilimento_linea(_id_stabilimento, _codice_univoco_ml, _num_riconoscimento, utente_in, 
									_data_inizio::timestamp without time zone, _data_fine::timestamp without time zone,
									_tipo_carattere::integer);
		END IF;	
	    END LOOP;

		IF (_id_stabilimento is not null) THEN
			update opu_stabilimento set data_inizio_attivita = (select min(data_inizio) from opu_relazione_stabilimento_linee_produttive where id_stabilimento = _id_stabilimento and enabled) where id = _id_stabilimento;    
         	END IF; 

select count(ml8.*) into _n_categorizzabili from opu_relazione_stabilimento_linee_produttive rel 
join ml8_linee_attivita_nuove_materializzata ml8 on ml8.id_nuova_linea_attivita = rel.id_linea_produttiva 
left join master_list_flag_linee_attivita flag on flag.codice_univoco = ml8.codice_attivita 
where flag.categorizzabili and rel.enabled and rel.id_stabilimento = _id_stabilimento;


-- inserimento campi aggiuntivi anagrafica
IF (_id_stabilimento is not null) THEN
	perform insert_opu_no_scia_dati_aggiuntivi(_id_stabilimento,'opu_stabilimento',campi_fissi -> 'autorizzazione_id_aia', (campi_fissi -> 'autorizzazione_tipo')::integer,campi_fissi -> 'autorizzazione_numero', 
	                                           (campi_fissi -> 'autorizzazione_data')::timestamp without time zone, campi_fissi -> 'autorizzazione_nota',campi_fissi -> 'autorizzazione_burc', campi_fissi -> 'denominazione_stab',
	                                            campi_fissi -> 'nome_responsabile', campi_fissi -> 'cognome_responsabile', campi_fissi -> 'cf_responsabile');
END IF; 
-- fine inserimento campi aggiuntivi anagrafica



IF _n_categorizzabili > 0 THEN
   update opu_stabilimento set categoria_rischio = 3 where id = _id_stabilimento;
END IF;

	perform refresh_anagrafica(_id_stabilimento, 'opu');

	raise WARNING 'id finali: id stab %, id operatore %, id sogg fis %s, id indi stab %, id ind impresa %s, id ind sogg fis %', 
			_id_stabilimento, _id_operatore, _id_sogg_fis, _id_indirizzo_stabilimento, _id_indirizzo_sede_legale, _id_indirizzo_sogg_fis;


	
	return _id_stabilimento;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.insert_gestione_anagrafica(hstore, hstore, integer, integer, text, integer)
  OWNER TO postgres;

  
  DROP FUNCTION insert_opu_no_scia_dati_aggiuntivi(integer,text,text,integer,text,timestamp without time zone,text,text,text,text,text,text)
CREATE OR REPLACE FUNCTION public.insert_opu_no_scia_dati_aggiuntivi(
    _riferimento_id integer,
    _riferimento_id_nome_tab text,
    _autorizzazione_id_aia text,
    _autorizzazione_tipo integer,
    _autorizzazione_numero text,
    _autorizzazione_data timestamp without time zone, 
    _autorizzazione_nota text,
   _autorizzazione_burc text,
   _denominazione_stabilimento text,
   _nome_responsabile text,
   _cognome_responsabile text,
   _cf_responsabile text)
  RETURNS integer AS
$BODY$
DECLARE 
	id_opu_dati_aggiuntivi integer;
BEGIN	
	insert into opu_dati_aggiuntivi(riferimento_id , riferimento_id_nome_tab, id_aia, tipo_autorizzazione, num_decreto, data_decreto, nota, burc, denominazione_stabilimento, nome_responsabile, cognome_responsabile, cf_responsabile) 
	values(_riferimento_id, _riferimento_id_nome_tab, _autorizzazione_id_aia, _autorizzazione_tipo, _autorizzazione_numero, _autorizzazione_data, _autorizzazione_nota,_autorizzazione_burc, _denominazione_stabilimento,
	_nome_responsabile, _cognome_responsabile, _cf_responsabile) returning id into id_opu_dati_aggiuntivi;

	return id_opu_dati_aggiuntivi;
	      
END;
$BODY$
  LANGUAGE plpgsql
  COST 100;



  
-- Function: public.dbi_opu_get_progressivo_linea_per_stabilimento(text)

-- DROP FUNCTION public.dbi_opu_get_progressivo_linea_per_stabilimento(text);

CREATE OR REPLACE FUNCTION public.dbi_opu_get_progressivo_linea_per_stabilimento(numeroregistrazionestabilimento text)
  RETURNS integer AS
$BODY$
DECLARE
	progressivo integer;
BEGIN


	progressivo := (
	select max(prog)+1
	from
	(
	select distinct substring(ld.numero_registrazione from 0 for 16) as codice_stabilimento,CASE WHEN max(substring(ld.numero_registrazione from 17 for length(ld.numero_registrazione)) )::text != '' then max(substring(ld.numero_registrazione from 17 for length(ld.numero_registrazione)) )::int else 0 end as prog
from opu_stabilimento  os 
join opu_operatore op on op.id = os.id_operatore
join opu_relazione_stabilimento_linee_produttive ld on ld.id_stabilimento = os.id
where ld.numero_registrazione is not null and  os.numero_Registrazione =numeroregistrazionestabilimento
group by substring(ld.numero_registrazione from 0 for 16)





) 
lista_progressivi_per_asl
);

if (progressivo<=0 or progressivo is null)
then
return 1;
else
     RETURN progressivo;
     end if;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
ALTER FUNCTION public.dbi_opu_get_progressivo_linea_per_stabilimento(text)
  OWNER TO postgres;

 select * from lookup_stato_lab  

update lookup_stato_lab set description = 'in attivita'''  where code = 0;
update lookup_stato_lab set description = 'AIA revocata'  where code = 1;
update lookup_stato_lab set description = 'Conferimenti sospesi dal 2011 - AIA non rinnovata'  where code = 2;
update lookup_stato_lab set description = 'Impianto non operativo'  where code = 3;
update lookup_stato_lab set description = 'Impianto chiuso'  where code = 4;
update lookup_stato_lab set description = 'Impianto dismesso'  where code = 6;
update lookup_stato_lab set description = 'AUA'  where code = 5;
update lookup_stato_lab set description = 'AIA non rinnovata'  where code = 7;


delete from lookup_tipo_impresa_societa  where code > 10

 