-- dump di partenza gisa_riuso_2
update role set role='Responsabile procedimento', description ='Responsabile procedimento' where role_id=43;

-- creare ruoli

insert into role(role_id, role, description, enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
(select 27,'Dirigente Regionale','Dirigente Regionale', enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo 
from role where role_id=43);
insert into role(role_id, role, description, enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
(select 42,'Referente ispettivo','Referente ispettivo', enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo 
from role where role_id=43);
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

update lookup_site_id set description ='Dipartimento Provinciale di Avellino' where code=201;
update lookup_site_id set description ='Dipartimento Provinciale di Benevento' where code=202;
update lookup_site_id set description ='Dipartimento Provinciale di Caserta' where code=203;
update lookup_site_id set description ='Dipartimento Provinciale di Napoli' where code=204;
update lookup_site_id set description ='Dipartimento Provinciale di Salerno' where code=207;

update strutture_asl set id_padre=8 where id=2;

DROP VIEW public.dpat_strumento_calcolo_nominativi;
DROP VIEW public.dpat_strutture_asl;
DROP VIEW public.oia_nodo;

-- allunga a 500 il nome per strutture ASL



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
    a.id_lookup_area_struttura_asl,
    a.ui_struttura_foglio_att_iniziale,
    a.ui_struttura_foglio_att_finale,
    a.id_utente_edit,
    a.percentuale_area_a,
    a.stato_all2,
    a.stato_all6,
    a.codice_interno_univoco,
    a.descrizione_area_struttura,
    a.data_congelamento
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
            strutture_asl.id_lookup_area_struttura_asl,
            strutture_asl.ui_struttura_foglio_att_iniziale,
            strutture_asl.ui_struttura_foglio_att_finale,
            strutture_asl.id_utente_edit,
            strutture_asl.percentuale_area_a,
            strutture_asl.stato_all2,
            strutture_asl.stato_all6,
            strutture_asl.codice_interno_univoco,
            area.description AS descrizione_area_struttura,
            strutture_asl.data_congelamento
           FROM strutture_asl
             LEFT JOIN lookup_area_struttura_asl area ON area.code = strutture_asl.id_lookup_area_struttura_asl) a
  ORDER BY a.codice_interno_fk, a.data_scadenza;

ALTER TABLE public.oia_nodo
  OWNER TO postgres;

  -- View: public.dpat_strutture_asl

-- DROP VIEW public.dpat_strutture_asl;

CREATE OR REPLACE VIEW public.dpat_strutture_asl AS 
 WITH RECURSIVE recursetree(id, descrizione, nonno, livello, pathid, pathdes, id_asl, idsc, tipostruttura, codicefk, datascadenza, disabilitato, id_padre, anno, stato, enabled, descrizione_area_struttura_complessa, id_lookup_area_struttura_asl, ui_struttura_foglio_att_iniziale, ui_struttura_foglio_att_finale, id_utente_edit, percentuale_area_a, stato_all2, stato_all6, descrizione_area_struttura, codice_interno_univoco, data_congelamento, entered, modified) AS (
         SELECT n.id,
            n.descrizione_lunga,
            n.id_padre AS nonno,
            n.n_livello,
            n.id_padre::character varying(1000) AS path_id,
            n.descrizione_lunga::character varying(1000) AS pathdes,
            n.id_asl,
            n.id_strumento_calcolo,
            n.tipologia_struttura,
            n.codice_interno_fk,
            n.data_scadenza,
            n.disabilitata,
            n.id_padre,
            n.anno,
            n.stato,
            n.enabled,
            n.descrizione_area_struttura_complessa,
            n.id_lookup_area_struttura_asl,
            n.ui_struttura_foglio_att_iniziale,
            n.ui_struttura_foglio_att_finale,
            n.id_utente_edit,
            n.percentuale_area_a,
            n.stato_all2,
            n.stato_all6,
            area.description AS descrizione_area_struttura,
            n.codice_interno_univoco,
            n.data_congelamento,
            n.entered,
            n.modified
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
            rt.codicefk,
            rt.datascadenza,
            rt.disabilitato,
            rt.id_padre,
            rt.anno,
            rt.stato,
            rt.enabled,
            rt.descrizione_area_struttura_complessa,
            COALESCE(rt.id_lookup_area_struttura_asl, t.id_lookup_area_struttura_asl) AS id_lookup_area_struttura_asl,
            rt.ui_struttura_foglio_att_iniziale,
            rt.ui_struttura_foglio_att_finale,
            rt.id_utente_edit,
            rt.percentuale_area_a,
            rt.stato_all2,
            rt.stato_all6,
            COALESCE(rt.descrizione_area_struttura, area.description) AS descrizione_area_struttura,
            rt.codice_interno_univoco,
            rt.data_congelamento,
            rt.entered,
            rt.modified
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
    recursetree.id_lookup_area_struttura_asl,
    recursetree.ui_struttura_foglio_att_iniziale,
    recursetree.ui_struttura_foglio_att_finale,
    recursetree.id_utente_edit,
    recursetree.percentuale_area_a,
    recursetree.stato_all2,
    recursetree.stato_all6,
    recursetree.descrizione_area_struttura,
    recursetree.codice_interno_univoco,
    recursetree.data_congelamento,
    recursetree.entered,
    recursetree.modified
   FROM recursetree
     LEFT JOIN oia_nodo padre ON padre.codice_interno_fk = recursetree.id_padre AND padre.disabilitata = false
  WHERE recursetree.nonno = 8
  ORDER BY recursetree.id_asl;

ALTER TABLE public.dpat_strutture_asl
  OWNER TO postgres;


-- Rule: strutture_asl_insert ON public.oia_nodo

-- DROP RULE strutture_asl_insert ON public.oia_nodo;

CREATE OR REPLACE RULE strutture_asl_insert AS
    ON INSERT TO oia_nodo DO INSTEAD  INSERT INTO strutture_asl (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, trashed_date, tipologia_struttura, comune, enabled, obsoleto, confermato, id_strumento_calcolo, codice_interno_fk, nome, id_utente, mail, indirizzo, delegato, descrizione_comune, id_oia_nodo_temp, data_scadenza, stato, anno, ui_struttura_foglio_att_iniziale, ui_struttura_foglio_att_finale, id_utente_edit, percentuale_area_a, codice_interno_univoco)
  VALUES (new.id, new.id_padre, new.id_asl, new.descrizione_lunga, new.n_livello, new.entered, new.entered_by, new.modified, new.modified_by, new.trashed_date, new.tipologia_struttura, new.comune, new.enabled, new.obsoleto, new.confermato, new.id_strumento_calcolo, new.codice_interno_fk, new.nome, new.id_utente, new.mail, new.indirizzo, new.delegato, new.descrizione_comune, new.id_oia_nodo_temp, new.data_scadenza, new.stato, new.anno, new.ui_struttura_foglio_att_iniziale, new.ui_struttura_foglio_att_finale, new.id_utente_edit, new.percentuale_area_a, new.codice_interno_univoco);

-- Rule: strutture_asl_update ON public.oia_nodo

-- DROP RULE strutture_asl_update ON public.oia_nodo;

CREATE OR REPLACE RULE strutture_asl_update AS
    ON UPDATE TO oia_nodo DO INSTEAD  UPDATE strutture_asl SET id_utente_edit = new.id_utente_edit, ui_struttura_foglio_att_iniziale = new.ui_struttura_foglio_att_iniziale, ui_struttura_foglio_att_finale = new.ui_struttura_foglio_att_finale, descrizione_area_struttura_complessa = new.descrizione_area_struttura_complessa, descrizione_lunga = new.descrizione_lunga, trashed_date = new.trashed_date, modified = new.modified, modified_by = new.modified_by, data_scadenza = new.data_scadenza, stato = new.stato, percentuale_area_a = new.percentuale_area_a
  WHERE strutture_asl.id = new.id;


CREATE OR REPLACE VIEW public.dpat_strumento_calcolo_nominativi AS 
 SELECT DISTINCT ON (a.codice_interno_fk) a.codice_interno_fk AS codice_interno_fk_,
    a.id_anagrafica_nominativo,
    a.id_lookup_qualifica,
    a.id,
    a.id_dpat_strumento_calcolo_strutture,
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
    a.stato_struttura
   FROM ( SELECT dpat_strumento_calcolo_nominativi_.id_anagrafica_nominativo,
            dpat_strumento_calcolo_nominativi_.id_lookup_qualifica,
            dpat_strumento_calcolo_nominativi_.id,
            dpat_strumento_calcolo_nominativi_.id_dpat_strumento_calcolo_strutture,
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
    ON INSERT TO dpat_strumento_calcolo_nominativi DO INSTEAD  INSERT INTO dpat_strumento_calcolo_nominativi_ (id, id_anagrafica_nominativo, id_lookup_qualifica, id_dpat_strumento_calcolo_strutture, entered_by, entered, stato, codice_interno_fk)
  VALUES (new.id, new.id_anagrafica_nominativo, new.id_lookup_qualifica, new.id_dpat_strumento_calcolo_strutture, new.entered_by, new.entered, new.stato, new.codice_interno_fk);

-- Rule: nominativi_update ON public.dpat_strumento_calcolo_nominativi

-- DROP RULE nominativi_update ON public.dpat_strumento_calcolo_nominativi;

CREATE OR REPLACE RULE nominativi_update AS
    ON UPDATE TO dpat_strumento_calcolo_nominativi DO INSTEAD  UPDATE dpat_strumento_calcolo_nominativi_ SET trashed_date = new.trashed_date, data_scadenza = new.data_scadenza, modified = new.modified, modified_by = new.modified_by, stato = new.stato
  WHERE dpat_strumento_calcolo_nominativi_.id = new.id;


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
    a.id_lookup_area_struttura_asl,
    a.ui_struttura_foglio_att_iniziale,
    a.ui_struttura_foglio_att_finale,
    a.id_utente_edit,
    a.percentuale_area_a,
    a.stato_all2,
    a.stato_all6,
    a.codice_interno_univoco,
    a.descrizione_area_struttura,
    a.data_congelamento
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
            strutture_asl.id_lookup_area_struttura_asl,
            strutture_asl.ui_struttura_foglio_att_iniziale,
            strutture_asl.ui_struttura_foglio_att_finale,
            strutture_asl.id_utente_edit,
            strutture_asl.percentuale_area_a,
            strutture_asl.stato_all2,
            strutture_asl.stato_all6,
            strutture_asl.codice_interno_univoco,
            area.description AS descrizione_area_struttura,
            strutture_asl.data_congelamento
           FROM strutture_asl
             LEFT JOIN lookup_area_struttura_asl area ON area.code = strutture_asl.id_lookup_area_struttura_asl) a
  ORDER BY a.codice_interno_fk, a.data_scadenza;
  
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo),2,-1,'U.O.Affari Generali e Contratti', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Affari Generali e Contratti', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 2,-1,'U.O.Affari Legali e Diritto Ambientale', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Affari Legali e Diritto Ambientale', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 2,-1,'U.O.Comunicazione e Uff. Relazioni con il Pubblico', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Comunicazione e Uff. Relazioni con il Pubblico', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 2,-1,'U.O.Qualità Sicurezza ed Energia', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Qualità Sicurezza ed Energia', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 2,-1,'U.O.Pianificazione Strategica Formazione e Progetti', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Pianificazione Strategica Formazione e Progetti', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 2,-1,'U.O.Controllo di Gestione Valutazione e Controllo Analogo', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Controllo di Gestione Valutazione e Controllo Analogo', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 2,-1,'U.O.Sistemi Informativi e Informatici', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Sistemi Informativi e Informatici', 2, 2022);



insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo),8,-1,'Direzione Amministrativa', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Direzione Amministrativa', 2, 2022);
	insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	((select max(id)+1 from oia_nodo), 24,-1,'U.O.Personale', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Personale', 2, 2022);
	insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	((select max(id)+1 from oia_nodo), 24,-1,'U.O.Bilancio Contabilità e Finanze', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Bilancio Contabilità e Finanze', 2, 2022);
	insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	((select max(id)+1 from oia_nodo), 24,-1,'U.O.Provveditorato Economato e Patrimonio', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.Provveditorato Economato e Patrimonio', 2, 2022);



insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo),8,-1,'Direzione Tecnica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Direzione Tecnica', 2, 2022);
	insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	((select max(id)+1 from oia_nodo),28,-1,'U.O.C.Sostenibilità Ambientale e Controlli', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.C.Sostenibilità Ambientale e Controlli', 2, 2022);
	insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	((select max(id)+1 from oia_nodo), 28,-1,'U.O.C.Siti Contaminanti e Bonifiche', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.C.Siti Contaminanti e Bonifiche', 2, 2022);
	insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
	((select max(id)+1 from oia_nodo), 28,-1,'U.O.C.Monitoraggi e CEMEC', 1, current_timestamp, 291, current_timestamp, 291, 39, true, true, 'U.O.C.Monitoraggi e CEMEC', 2, 2022);
	
	

-- figli di Avellino complessa
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 3,201,'Area Analitica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Analitica', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 3,201,'Area Territoriale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Territoriale', 2, 2022);

-- figli di Benevento complessa
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 4,202,'Area Analitica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Analitica', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 4,202,'Area Territoriale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Territoriale', 2, 2022);

-- figli di Caserta complessa
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 5,203,'Area Analitica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Analitica', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 5,203,'Area Territoriale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Territoriale', 2, 2022);

-- figli di Napoli complessa
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 6,204,'Area Analitica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Analitica', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 6,204,'Area Territoriale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Territoriale', 2, 2022);

-- figli di SA complessa
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 7,207,'Area Analitica', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Analitica', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 7,207,'Area Territoriale', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Area Territoriale', 2, 2022);
insert into oia_nodo (id, id_padre, id_asl, descrizione_lunga, n_livello, entered, entered_by, modified, modified_by, tipologia_struttura, enabled, confermato, nome, stato, anno) values
((select max(id)+1 from oia_nodo), 7,207,'Centro Regionale Radioattivita''', 1, current_timestamp, 291, current_timestamp, 291, 13, true, true, 'Centro Regionale Radioattivita''', 2, 2022);

update oia_nodo set codice_interno_fk = id;
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
update oia_nodo set codice_interno_fk = id;
delete from strutture_asl where id = 1;
delete from dpat_strumento_calcolo_nominativi_  where id > 1;

DROP FUNCTION dbi_insert_utente(character varying,character varying,integer,integer,integer,boolean,integer,character varying,character varying,character varying,text,text,character varying,character varying,timestamp with time zone,integer)

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

  
------------------------------------------ anagrafiche
delete from ricerche_anagrafiche_old_materializzata;

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
  denominazione_stabilimento text,
  nome_responsabile text,
  cognome_responsabile text,
  cf_responsabile text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.opu_dati_aggiuntivi
  OWNER TO postgres;
  
  

CREATE OR REPLACE FUNCTION public.insert_opu_no_scia_dati_aggiuntivi(
    _riferimento_id integer,
    _riferimento_id_nome_tab text,
    _autorizzazione_id_aia text,
    _autorizzazione_tipo integer,
    _autorizzazione_numero text,
    _autorizzazione_data text, 
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
  
  

-- View: public.anagrafica_stabilimenti_puliti

-- DROP VIEW public.anagrafica_stabilimenti_puliti;

  create extension hstore;

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


--Fix di campi
delete from scheda_operatore_metadati where tipo_operatore not in (6,24);
delete from lookup_tipo_scheda_operatore  where code not in (6,24);


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
  
  
INSERT INTO public.permission_category(
            category_id, category, description, level, enabled, active, folders, 
            lookups, viewpoints, categories, scheduled_events, object_events, 
            reports, webdav, logos, constant, action_plans, custom_list_views)
VALUES (36, 'GESTIONE CU NUOVA', 'GESTIONE CU', 0,TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,14,FALSE,FALSE);
insert into permission (category_id,permission,permission_view,permission_add,permission_edit,permission_delete,description , level,enabled,active)
values (36,'gestionenuovacu',true,true,true,true,'GESTIONE CAVALIERE DEDICATO AI CU',10,true,true) returning permission_id;


insert into role_permission (id, role_id, permission_id, role_view, role_add) values ((select max(id)+1 from role_permission),1,4,true, true); 
insert into role_permission (id, role_id, permission_id, role_view, role_add) values ((select max(id)+1 from role_permission),32,4,true, true); 

---------------------------------- controlli ------------------
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




  --select * from public.get_esami_documentazione(1)
  --select * from public.get_esami_documentazione(-1)

drop function public.get_motivi_cu(integer, integer,text[]);
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

  
CREATE OR REPLACE FUNCTION public.cu_insert_globale(IN _json_dati json)
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

	-- STEP 3: INSERIAMO I DATI DEL CU + linee
	update controlli_ufficiali set stato=1, note = (datigenerici ->> 'note'), id_dipartimento = (dipartimento ->> 'id')::int, 
	data_inizio  = (datigenerici ->> 'dataInizio')::timestamp without time zone, 
	data_fine = (datigenerici ->> 'dataFine')::timestamp without time zone, 
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
  
 
alter table controlli_ufficiali  add column id_fascicolo integer;
alter table controlli_ufficiali  add column ora_fine text;


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
  
  -- routine svuota CU
--delete from controlli_ufficiali ;
--delete from controlli_ufficiali_esami ;
--delete from controlli_per_conto_di 
--delete from controlli_ufficiali_motivi ;
--delete from controlli_ufficiali_motivi_ispezione;
--delete from controlli_ufficiali_tipi_verifica;
--delete from non_conformita;
--delete from campioni;
--delete from controlli_fase_lavorazione;
--delete from analiti_campioni;  
--delete from matrici_campioni;      

-- campioni

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

  
CREATE TABLE public.matrici_campioni
(
  id serial,
  id_campione integer,
  id_matrice integer,
  cammino text,
  note text,
  CONSTRAINT matrici_campioni_pkey PRIMARY KEY (id),
  CONSTRAINT matrici_campioni_id_matrice FOREIGN KEY (id_matrice)
      REFERENCES public.matrici (matrice_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.matrici_campioni
  OWNER TO postgres;

-- Index: public.idx_matrici_campioni_id_campione

-- DROP INDEX public.idx_matrici_campioni_id_campione;

CREATE INDEX idx_matrici_campioni_id_campione
  ON public.matrici_campioni
  USING btree
  (id_campione);

-- Index: public.idx_matrici_campioni_id_matrice

-- DROP INDEX public.idx_matrici_campioni_id_matrice;

CREATE INDEX idx_matrici_campioni_id_matrice
  ON public.matrici_campioni
  USING btree
  (id_matrice);



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
  
  -- NC
  
  

  
  CREATE TABLE public.non_conformita
(
  id serial,
  id_controllo integer,
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

-- fasi lavorazione
CREATE TABLE public.fasi_lavorazione
(
  id serial,
  tipo_quadro text,
  tipo_impianto text,
  punti_emissione text,
  fasi_lavorazione text,
  inquinanti text,
  impianti_abbattimento text
  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.fasi_lavorazione
  OWNER TO postgres;


insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Zincatura a caldo di acciaio','AIA','H1','Carpenteria met. - Taglio laser fisso','Polveri','Filtri a tessuto');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Zincatura a caldo di acciaio','AIA','H2','Attrezzeria Saldatura','Polveri','Filtri a tessuto');


CREATE TABLE public.anagrafica_fasi_lavorazione
(
  id serial,
  id_fase_lavorazione integer,
  riferimento_id integer,
  riferimento_id_nome_tab text,
  trashed_date timestamp,
  entered  timestamp default now(),
  enteredby integer,
  modifiedby integer,
  modified timestamp default now(),
  note_hd text
  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.anagrafica_fasi_lavorazione
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.get_fasi_lavorazione(
IN _riferimento_id integer, 
IN _riferimento_id_nome_tab text
)
   RETURNS TABLE(id integer,
  tipo_quadro text,
  tipo_impianto text,
  punti_emissione text,
  fasi_lavorazione text,
  inquinanti text,
  impianti_abbattimento text, 
  entered timestamp,
  enteredby integer,
  trashed_date timestamp,
  modified timestamp,
  modifiedby integer,
  selezionato boolean
  ) AS
$BODY$
DECLARE
BEGIN

	RETURN QUERY
	select f.*, a.entered, a.enteredby, a.trashed_date, a.modified, a.modifiedby, 
	case when a.riferimento_id is not null then true else false end as selezionato
	from fasi_lavorazione f 
	left join anagrafica_fasi_lavorazione a on a.id_fase_lavorazione = f.id and a.riferimento_id = _riferimento_id and a.riferimento_id_nome_tab = _riferimento_id_nome_tab
	where a.trashed_date is null; 
	
END;
$BODY$
  LANGUAGE plpgsql
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_fasi_lavorazione(integer, text)
  OWNER TO postgres;

  
CREATE OR REPLACE FUNCTION public.delete_anagrafica_fasi_lavorazione(
IN _riferimento_id integer, 
IN _riferimento_id_nome_tab text,
IN _userid integer)
   RETURNS text AS
$BODY$
DECLARE
BEGIN
	update anagrafica_fasi_lavorazione set note_hd=concat_ws('***', note_hd, 'Cancellazione effettuata tramite dbi'), modifiedby = _userid, trashed_date = now() 
	where riferimento_id= _riferimento_id 
	and   riferimento_id_nome_tab = _riferimento_id_nome_tab
	and trashed_date is null;

	return 'OK';

END;
$BODY$
  LANGUAGE plpgsql
  COST 100;

--select * from anagrafica_fasi_lavorazione  
CREATE OR REPLACE FUNCTION public.insert_anagrafica_fasi_lavorazione(
IN _riferimento_id integer, 
IN _riferimento_id_nome_tab text,
IN _id integer,
IN _userid integer)
   RETURNS text AS
$BODY$
DECLARE
BEGIN
	insert into anagrafica_fasi_lavorazione(enteredby, riferimento_id, riferimento_id_nome_tab, id_fase_lavorazione, note_hd) values
	(_userid, _riferimento_id, _riferimento_id_nome_tab, _id, 'Inserimento effettuato dalla dbi');

	return 'OK';

END;
$BODY$
  LANGUAGE plpgsql
  COST 100;

  
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Produzione mangimi','AIA','E2','Macinazione','Polveri tot. - Umidità','Filtri a maniche');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Produzione mangimi','AIA','E1','Scarico silos integratori','Polveri tot. - Umidità','Filtro a maniche');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Sinterizzazione metalli duri','AIA','E2','Presinterizzazione','Polveri, cobalto','Vasche di condensazione sui forni per il recupero dei vapori organici');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Sinterizzazione metalli duri','AIA','E3','Presinterizzazione','Polveri, cobalto','Vasche di condensazione sui forni per il recupero dei vapori organici');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Stampaggio plastica settore automotive','AUA','E4','Impianto di aspirazione pressa linea 1','Polveri totali, SOV, Aldeidi, Fenoli','Non previsto');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Stampaggio plastica settore automotive','AUA','E9','Impianto di aspirazione pressa linea 4','Polveri totali, SOV, Aldeidi, Fenoli','Non previsto');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Fonderia di alluminio e magnesio','AUA','C1','Finitura - Sabbiatura a camera','Polveri','Filtro a maniche');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Fonderia di alluminio e magnesio','AUA','C2','Finitura - Granigliatura','Polveri','Filtro a cartucce');




CREATE OR REPLACE FUNCTION public.insert_opu_no_scia_dati_aggiuntivi(
    _riferimento_id integer,
    _riferimento_id_nome_tab text,
    _autorizzazione_id_aia text,
    _autorizzazione_tipo integer,
    _autorizzazione_numero text,
    _autorizzazione_data text,
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
	insert into anag_dati_aggiuntivi(riferimento_id , riferimento_id_nome_tab, id_aia, tipo_autorizzazione, num_decreto, data_decreto, nota, burc, denominazione_stabilimento, nome_responsabile, cognome_responsabile, cf_responsabile) 
	values(_riferimento_id, _riferimento_id_nome_tab, _autorizzazione_id_aia, _autorizzazione_tipo, _autorizzazione_numero, _autorizzazione_data, _autorizzazione_nota,_autorizzazione_burc, _denominazione_stabilimento,
	_nome_responsabile, _cognome_responsabile, _cf_responsabile) returning id into id_opu_dati_aggiuntivi;

	return id_opu_dati_aggiuntivi;
	      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.insert_opu_no_scia_dati_aggiuntivi(integer, text, text, integer, text, text, text, text, text, text, text, text)
  OWNER TO postgres;




  

  
  