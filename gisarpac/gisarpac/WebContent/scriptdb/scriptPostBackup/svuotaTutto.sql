-- ANAGRAFICHE 

delete from opu_relazione_stabilimento_linee_produttive ;
delete from opu_stabilimento;
delete from opu_rel_operatore_soggetto_fisico;
delete from opu_operatore;
delete from opu_soggetto_fisico;
delete from opu_indirizzo;

delete from anag_dati_aggiuntivi ;
delete from anag_dati_autorizzativi;
delete from anag_storico_modifiche;
delete from anag_acque_reflue;
delete from anag_dati_autorizzativi_matrici;    

delete from sintesis_relazione_stabilimento_linee_produttive ;
delete from sintesis_stabilimento;
delete from sintesis_rel_operatore_soggetto_fisico;
delete from sintesis_operatore;
delete from sintesis_soggetto_fisico;
delete from sintesis_indirizzo;
delete from sintesis_stabilimenti_import;
delete from sintesis_stabilimenti_import_log;

delete from ricerche_anagrafiche_old_materializzata; 
insert into ricerche_anagrafiche_old_materializzata select * from ricerca_anagrafiche;

-- IMPORT-------------------------ATTENZIONE QUI!-----------------------------------
--SI SVUOTANO ANCHE LE TABELLE DI IMPORT!!!!
delete from import_aia;
delete from import_aia_anagrafiche;
delete from import_aia_linee_principali;
delete from import_aia_linee_secondarie;
delete from import_aia_decreti;
delete from log_import_gisa_remoto;
delete from log_import_aia;
--------------------------------------------------------------------------------------
-- GIORNATE ISPETTIVE

delete from giornate_ispettive;
delete from giornate_ispettive_esami ;
delete from giornate_ispettive_matrici ;
delete from giornate_ispettive_motivi ;
delete from giornate_ispettive_tipi_verifica ;
delete from giornate_ispettive_log_json;
delete from giornate_ispettive_verbali_protocolli; 

-- CAMPIONI

delete from campioni;

-- NON CONFORMITA

delete from non_conformita;

-- FASCICOLI

delete from fascicoli_ispettivi;
delete from fascicoli_ispettivi_protocolli ;

-- SERVER DOCUMENTALE

delete from storage_gisa;
delete from storage_gisa_allegati;
delete from storage_gisa_allegati_cartelle;
delete from storage_gisa_bacheca_allegati;
delete from storage_gisa_bacheca_archivi;
delete from storage_gisa_bacheca_cartelle;
delete from storage_gisa_moduli;
delete from storage_gisa_sintesis;
  
--PER RILANCIARE SOLO IMPORT PULITO, BASTANO LE TABELLE BACKUPPATE
import_aia;
import_aia_anagrafiche;
import_aia_linee_principali;
import_aia_linee_secondarie;
import_aia_decreti;

E LANCIARE LA DBI "select * from public.import_from_aia();"
