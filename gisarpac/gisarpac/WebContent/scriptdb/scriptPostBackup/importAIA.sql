-- Da usare al posto di svuota tutto + import massivo

-- ANAGRAFICHE 

delete from opu_relazione_stabilimento_linee_produttive ;
delete from opu_stabilimento;
delete from opu_rel_operatore_soggetto_fisico;
delete from opu_operatore;
delete from opu_soggetto_fisico;
delete from opu_indirizzo;
delete from log_import_gisa_remoto;
delete from log_import_aia;

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

-- CONTROLLI UFFICIALI

delete from controlli_ufficiali;
delete from controlli_ufficiali_esami ;
delete from controlli_ufficiali_matrici ;
delete from controlli_ufficiali_motivi ;
delete from controlli_ufficiali_tipi_verifica ;
delete from cu_log_json;
delete from controlli_ufficiali_verbali_protocolli; 

-- CAMPIONI

delete from campioni;

-- FASCICOLI

delete from fascicoli;
delete from fascicoli_protocolli ;

-- IMPORT

select * from import_aia();

delete from opu_relazione_stabilimento_linee_produttive  where id_stabilimento in (select id from opu_stabilimento where numero_registrazione is null);
delete from opu_stabilimento where numero_registrazione is null;
delete from ricerche_anagrafiche_old_materializzata; 
insert into ricerche_anagrafiche_old_materializzata select * from ricerca_anagrafiche;


