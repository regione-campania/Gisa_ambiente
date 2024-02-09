 DROP SCHEMA IF EXISTS public_functions cascade;
 DROP SCHEMA IF EXISTS giava cascade;
 DROP FUNCTION IF EXISTS public.altri_org_insert_into_ricerche_anagrafiche_old_materializzata(integer);
  DROP FUNCTION IF EXISTS public.controlli_verfica_blocco_non_conformita(integer);
  DROP FUNCTION IF EXISTS public.controlli_verfica_blocco_non_conformita_carico_terzi(integer);
  DROP FUNCTION IF EXISTS public.dbi_get_controlli_ufficiali_su_linee_produttive(integer);
  DROP FUNCTION IF EXISTS public.gestione_ml_id(integer, integer);
  DROP FUNCTION IF EXISTS public.get_categoria_rischio_qualitativa(integer, text);
  DROP FUNCTION IF EXISTS public.get_categoria_rischio_quantitativa(integer, text, integer);
  DROP FUNCTION IF EXISTS public.get_categorizzazzione_osa(integer, timestamp without time zone, integer);
  DROP FUNCTION IF EXISTS public.get_codice_richiesto_ml8(integer);
  DROP FUNCTION IF EXISTS public.get_codici_evento_motivo_cu(integer, integer); 
  DROP FUNCTION IF EXISTS public.get_has_linee_categorizzabili(integer, text);
  DROP FUNCTION IF EXISTS public.get_has_only_linee_noscia(integer, text);
   DROP FUNCTION IF EXISTS public.get_lista_sottoattivita(integer, integer, boolean);
   DROP FUNCTION IF EXISTS public.getpunteggioaccumulato_ct(integer, character varying, integer);
   DROP FUNCTION IF EXISTS public.getpunteggioaccumulato_ct_(character varying, integer);
DROP FUNCTION IF EXISTS public.has_evento_motivo_cu(text, integer, integer);
 DROP FUNCTION IF EXISTS public.insert_opu_noscia_impresa(text, text, text, integer, text, integer, integer);
 DROP FUNCTION IF EXISTS public.insert_opu_noscia_rel_impresa_soggfis(integer, integer);
 DROP FUNCTION IF EXISTS public.insert_opu_noscia_rel_stabilimento_linea(integer, text, text, integer, timestamp without time zone, timestamp without time zone, integer);
 DROP FUNCTION IF EXISTS public.insert_opu_noscia_stabilimento(integer, integer, integer, text);
  DROP FUNCTION IF EXISTS public.insert_opu_noscia_stabilimento(integer, integer, integer, text, text);
DROP FUNCTION IF EXISTS public.is_controllo_acquacoltura(integer);
DROP FUNCTION IF EXISTS public.is_controllo_amr(integer);
DROP FUNCTION IF EXISTS public.is_controllo_chiudibile_allegati_sanzione(integer);
DROP FUNCTION IF EXISTS public.is_controllo_chiudibile_pnaa(integer);
 DROP FUNCTION IF EXISTS public.lista_controlli_acquacoltura(integer, integer, text, text);
  DROP FUNCTION IF EXISTS public.mapping_linea_attivita(integer, text, text);
  DROP FUNCTION IF EXISTS public.mapping_linea_attivita_sintesis(text, text);
  DROP FUNCTION IF EXISTS public.normalizzazione_indirizzo(character varying);
   DROP FUNCTION IF EXISTS public.opu_insert_into_ricerche_anagrafiche_old_materializzata(integer);
   DROP FUNCTION IF EXISTS public.org_insert_into_ricerche_anagrafiche_old_materializzata(integer);
   DROP FUNCTION IF EXISTS public.suap_dbi_cerca_indirizzo_per_id(integer);
    DROP FUNCTION IF EXISTS public.verifica_esistenza_impresa_noscia(text);
	
	DROP TABLE IF EXISTS public.elenco_attivita_osm_reg;
 DROP TABLE IF EXISTS public.lookup_orgaddress_types cascade;
 drop table lookup_tipo_audit cascade;
 DROP TABLE IF EXISTS public.lookup_opu_tipo_impresa cascade;
 DROP TABLE IF EXISTS public.lookup_opu_tipo_impresa_societa;
 DROP TABLE IF EXISTS public.lookup_tipologia_cu_e_sottoattivita;
 DROP TABLE IF EXISTS public.non_conformita;
 DROP TABLE IF EXISTS public.modello_pnaa_values;
  DROP TABLE IF EXISTS public.parametri_categorizzazzione_osa;
  DROP TABLE IF EXISTS public.rel_checklist_sorv_ml;
  DROP TABLE IF EXISTS public.rel_motivi_eventi_cu;
    DROP TABLE IF EXISTS public.lookup_tipo_audit;
    DROP TABLE IF EXISTS public.organization_address;
    DROP TABLE IF EXISTS public.salvataggio_specie_trasportata;
	DROP TABLE IF EXISTS public.sanzioni_allegati;
	DROP TABLE IF EXISTS public.sintesis_operatore cascade;
	DROP TABLE IF EXISTS public.sintesis_indirizzo cascade;
	DROP TABLE IF EXISTS public.sintesis_operatori_mercato cascade;
	DROP TABLE IF EXISTS public.sintesis_storico_operatore cascade;
	DROP TABLE IF EXISTS public.sintesis_storico_soggetto_fisico;
	DROP TABLE IF EXISTS public.sintesis_workflow_stabilimento;
	DROP TABLE IF EXISTS public.sintesis_automezzi;
	DROP TABLE IF EXISTS public.sintesis_prodotti;
	DROP TABLE IF EXISTS public.sintesis_rel_operatore_soggetto_fisico;
	DROP TABLE IF EXISTS public.sintesis_storico_stabilimento;
	DROP TABLE IF EXISTS public.sintesis_soggetto_fisico;
	DROP TABLE IF EXISTS public.sintesis_workflow_attivita;
	DROP TABLE IF EXISTS public.tipocontrolloufficialeimprese;
	DROP TABLE IF EXISTS public.unita_operative_controllo;

drop view opu_operatori_denormalizzati_view;
drop view opu_linee_attivita_stabilimenti_view;
drop view sintesis_stabilimento_mobile;
drop view sintesis_linee_attivita_stabilimenti_view;
drop view org_linee_attivita_view;
drop view suap_ric_scia_linee_attivita_stabilimenti_view;
drop view suap_ric_linee_attivita_stabilimenti_view;
drop view view_globale_trashed_no_trashed_minimale;
drop view lookup_condizionalita_new;
drop view lookup_piano_monitoraggio_vista_view;
drop view lookup_qualifiche_nucleo_old_view;
drop view lookup_tipo_ispezione_vista_new;
drop view controlli_ufficiali_motivi_audit;
drop view controlli_ufficiali_motivi_ispezione_vista;
drop table opu_soggetto_fisico_storico;
drop table operatori_allevamenti;
drop table operatori_associati_mercato_ittico;
drop table opu_insert_log;
drop table opu_lookup_norme_master_list cascade;
drop table opu_lookup_norme_master_list_rel_tipologia_organzation;
drop table opu_lookup_stato_ruolo_soggetto cascade;
--drop table organization cascade;
drop table ticket cascade;
drop table parametri_categorizzazione_osa;
drop table rel_checklist_sorv_ml;
drop table rel_motivi_eventi_cu;
drop table organization_address;
drop table salvataggio_nc_note;
drop table salvataggio_azioni_adottate;
drop table salvataggio_specie_trasportata;
drop table sanzioni_allegati;
drop table sintesis_Automezzi;
drop table sintesis_indirizzo cascade;
drop table sintesis_operatore cascade;
drop table sintesis_operatori_mercato cascade;
drop table sintesis_prodotti;drop table sintesis_rel_operatore_soggetto_fisico;
drop table sintesis_stabilimenti_import;
drop table sintesis_stabilimeti_import_log;
drop table sintesis_storico_operatore;
drop table sintesis_storico_relazione_stabilimento_linee_produttive;
drop table sintesis_soggetto_fisico;
drop table sintesis_storico_soggetto_fisico;
drop table sintesis_workflow_attivita;
drop table sintesis_workflow_stabilimento;
drop table suap_ric_scia_operatore cascade;
drop table suap_ric_scia_relazione_stabilimento_linee_produttive;
drop table ticket_temp;
drop table _stato;
drop table acquacoltura_dati_controlli_bdn;
drop table anag_storico_modifiche;
drop table audit cascade;
drop table audit_checklist;

drop table asset;
drop table audit_checklist_type;
drop table aziende;
drop table aziendezootecniche_osm;
drop table buffer;
drop table checklist;

drop table checklist_type;
drop table chk_bns_mod_ist;
drop table chk_bns_risposte;
drop table codici_malattie_allevamenti;
drop table codici_qualifica_sanitaria_allevamenti;
drop table configuratore_template_no_scia;
drop table controlli_ufficiali_operatori_mercato;
drop table cu_fields_value;
drop table cu_html_fields;
drop table cu_motivi_operatori;
drop table cu_riferimenti_soa;
drop table cun_amr;
--drop table lenco_attivita_osm_reg;
drop table evento_blocco;
drop table evento_blocco_controlli;
drop table gruppi_template_no_scia;
drop table la_imprese_linee_attivita;
drop table la_linee_attivita cascade;
drop table la_rel_ateco_attivita cascade;
drop table laboratori_haccp_controllati ;
drop table linee_mobili_html_fields;
drop table lista_controlli_ufficiali;
drop table cun_amr;
drop table indirizzo_temp;
drop table lookup_account_size;
drop table lookup_articoli_azioni;
drop table lookup_audit_tipo cascade;
drop table lookup_azioni_adottate;
drop table lookup_bpi cascade;
drop table lookup_buffer_stato;
drop table lookup_categoria_specie_allevata;
drop table lookup_categoriarischio_soa;
drop table lookup_chk_bns_mod;
drop table lookup_condizionalita;
drop table lookup_distribuzione_partita;
drop table lookup_email_model;
drop table lookup_esiti_sequestri;
drop table lookup_eventi_motivi_cu;
drop table lookup_gruppo_ruoli;
drop table lookup_haccp cascade;
drop table lookup_ispezione;
drop table lookup_ispezione_macrocategorie;
drop table lookup_nazioni_ cascade;
drop table lookup_oggetto_audit;
drop table lookup_opportunity_budget;
drop table lookup_org_catrischio cascade;
drop table lookup_orgaddress_types;
drop table lookup_orientamento_produttivo;
drop table lookup_piano_monitoraggio cascade;
drop table lookup_piano_monitoraggio_ cascade;
drop table lookup_specie_allevata;
drop table lookup_specie_trasportata;
drop table lookup_stato_attivita_sintesis;
drop table lookup_stato_stabilimento_sintesis;
drop table lookup_tipo_audit;
drop table lookup_tipo_ispezione;
drop table lookup_tipo_ispezione_;
drop table lookup_tipologia_scia;
drop table suap_ric_scia_stabilimento;
drop table messaggio_mod4;
drop table sintesis_stabilimento;
drop table sintesis_relazione_stabilimento_linee_produttive;

 
--cancellare
select * from anag_storico_modifiche

 -- se tutto va bene con i test rimuoviamo tutto di opu e masterlist
 DROP TABLE IF EXISTS public.opu_lookup_tipologia_attivita;
 DROP TABLE IF EXISTS public.opu_lookup_tipologia_carattere;
 
 -- ripristino temporaneo preaccettazione
 -- FUNCTION: preaccettazione.get_quesiti_diagnostici()

-- DROP FUNCTION IF EXISTS preaccettazione.get_quesiti_diagnostici();

CREATE OR REPLACE FUNCTION preaccettazione.get_quesiti_diagnostici(
	)
    RETURNS TABLE(code integer, description character varying, codice_esame text, short_description text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE

BEGIN

	return query
	select tab.code, 
	       tab.description, 
	       tab.codice_esame, 
	       tab.short_description  
	   from(
	select qds.description, ordina_stringhe_alfanumeriche(qds.description, 3), qds.code, qds.short_description, qds.codice_esame 
		from quesiti_diagnostici_sigla qds order by ordina_stringhe_alfanumeriche(qds.description, 3)) tab;

                                         		
END;
$BODY$;

ALTER FUNCTION preaccettazione.get_quesiti_diagnostici()
    OWNER TO postgres;
	

CREATE OR REPLACE VIEW public.quesiti_diagnostici_sigla
 AS
 SELECT 1 as code,
    ''::character varying as description,
    true as enabled,
    '' as codice_esame,
    0 as level,
    false as default_item,
    'lookup_piano_monitoraggio'::text AS short_description;
ALTER TABLE public.quesiti_diagnostici_sigla
    OWNER TO postgres;


