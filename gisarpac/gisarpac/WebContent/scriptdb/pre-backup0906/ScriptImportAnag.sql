-- DA LANCIARE SU GISA CAMPANIA

drop fUNCTION public.get_dati_per_import_gisa_anag(IN _riferimento_id integer, _riferimento_id_nome_tab text);

CREATE OR REPLACE FUNCTION public.get_dati_per_import_gisa_anag(IN _riferimento_id integer, _riferimento_id_nome_tab text)
  RETURNS TABLE(riferimento_id integer,
riferimento_id_nome_tab text,
stabilimento_denominazione text,
stabilimento_indirizzo_toponimo text,
stabilimento_indirizzo_via text,
stabilimento_indirizzo_civico text,
stabilimento_indirizzo_comune text,
stabilimento_indirizzo_provincia text,
stabilimento_indirizzo_cap text,
stabilimento_indirizzo_latitudine text,
stabilimento_indirizzo_longitudine text,
id_stabilimento text,
operatore_ragione_sociale text,
operatore_partita_iva text,
operatore_codice_fiscale text,
operatore_mail text ,
operatore_tipo_impresa text,
operatore_indirizzo_nazione text,
operatore_indirizzo_toponimo text,
operatore_indirizzo_via text,
operatore_indirizzo_civico text,
operatore_indirizzo_comune text,
operatore_indirizzo_provincia text,
operatore_indirizzo_cap text,
operatore_indirizzo_latitudine text,
operatore_indirizzo_longitudine text,
operatore_indirizzo_comune_estero text,
id_impresa_recuperata text,
soggetto_nome text,
soggetto_cognome text,
soggetto_codice_fiscale text,
soggetto_data_nascita text,
soggetto_nazione_nascita text,
soggetto_comune_nascita text,
soggetto_sesso text,
soggetto_indirizzo_nazione text,
soggetto_indirizzo_toponimo text,
soggetto_indirizzo_via text,
soggetto_indirizzo_civico text,
soggetto_indirizzo_comune text,
soggetto_indirizzo_cap text,
soggetto_indirizzo_provincia text,
soggetto_mail text,
soggetto_telefono text,
id_rapp_legale_recuperato text,
soggetto_indirizzo_comune_estero text,
linea_1_data_inizio text,
linea_1_data_fine text,
linea_1_tipo_carattere text,
linea_1_codice_univoco_ml text,
linea_1_num_riconoscimento text,
linea_1_tipo_attivita text,
autorizzazione_nota text,
autorizzazione_numero text,
autorizzazione_id_aia text,
autorizzazione_data text,
autorizzazione_tipo text,
autorizzazione_burc text,
responsabile_nome text,
responsabile_cognome text,
responsabile_codice_fiscale text) AS
$BODY$
DECLARE
	
	 	
BEGIN
FOR

riferimento_id,
riferimento_id_nome_tab,
stabilimento_denominazione,
stabilimento_indirizzo_toponimo,
stabilimento_indirizzo_via,
stabilimento_indirizzo_civico,
stabilimento_indirizzo_comune,
stabilimento_indirizzo_provincia,
stabilimento_indirizzo_cap,
stabilimento_indirizzo_latitudine,
stabilimento_indirizzo_longitudine,
id_stabilimento,
operatore_ragione_sociale,
operatore_partita_iva,
operatore_codice_fiscale,
operatore_mail,
operatore_tipo_impresa,
operatore_indirizzo_nazione,
operatore_indirizzo_toponimo,
operatore_indirizzo_via,
operatore_indirizzo_civico,
operatore_indirizzo_comune,
operatore_indirizzo_provincia,
operatore_indirizzo_cap,
operatore_indirizzo_latitudine,
operatore_indirizzo_longitudine,
operatore_indirizzo_comune_estero,
id_impresa_recuperata,
soggetto_nome,
soggetto_cognome,
soggetto_codice_fiscale,
soggetto_data_nascita,
soggetto_nazione_nascita,
soggetto_comune_nascita,
soggetto_sesso,
soggetto_indirizzo_nazione,
soggetto_indirizzo_toponimo,
soggetto_indirizzo_via,
soggetto_indirizzo_civico,
soggetto_indirizzo_comune,
soggetto_indirizzo_cap,
soggetto_indirizzo_provincia,
soggetto_mail,
soggetto_telefono,
id_rapp_legale_recuperato,
soggetto_indirizzo_comune_estero,
linea_1_data_inizio,
linea_1_data_fine,
linea_1_tipo_carattere,
linea_1_codice_univoco_ml,
linea_1_num_riconoscimento,
linea_1_tipo_attivita,
autorizzazione_nota,
autorizzazione_numero,
autorizzazione_id_aia,
autorizzazione_data,
autorizzazione_tipo,
autorizzazione_burc,
responsabile_nome,
responsabile_cognome,
responsabile_codice_fiscale

	
	
		in

select

distinct

r.riferimento_id, r.riferimento_id_nome_tab

-------------------------------------------------------------------------------------------------
-------------------------------------------- STABILIMENTO ---------------------------------------
-------------------------------------------------------------------------------------------------

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN ''::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_stab.denominazione::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN ''::text
END AS stabilimento_denominazione

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_stab_ind.toponimo::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_stab_ind.toponimo::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind5.toponimo::text
END AS stabilimento_indirizzo_toponimo

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_stab_ind.via::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_stab_ind.via::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind5.addrline1::text
END AS stabilimento_indirizzo_via

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_stab_ind.civico::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_stab_ind.civico::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind5.civico::text
END AS stabilimento_indirizzo_civico

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_stab_ind.comune::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_stab_ind.comune::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN (select id from comuni1 where nome ilike org_ind5.city)::text
END AS stabilimento_indirizzo_comune

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_stab_ind.provincia::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_stab_ind.provincia::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind5.country::text
END AS stabilimento_indirizzo_provincia

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_stab_ind.cap::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_stab_ind.cap::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind5.postalcode::text
END AS stabilimento_indirizzo_cap

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_stab_ind.latitudine::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_stab_ind.latitudine::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind5.latitude::text
END AS stabilimento_indirizzo_latitudine

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_stab_ind.longitudine::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_stab_ind.longitudine::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind5.longitude::text
END AS stabilimento_indirizzo_longitudine

, '' as id_stabilimento


-------------------------------------------------------------------------------------------------
--------------------------------------------- OPERATORE -----------------------------------------
-------------------------------------------------------------------------------------------------

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op.ragione_sociale::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op.ragione_sociale::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.name::text
END AS operatore_ragione_sociale

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op.partita_iva::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op.partita_iva::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.partita_iva::text
END AS operatore_partita_iva

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op.codice_fiscale_impresa::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op.codice_fiscale_impresa::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.codice_fiscale::text
END AS operatore_codice_fiscale

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op.domicilio_digitale::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op.domicilio_digitale::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN ''::text
END AS operatore_mail

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op.tipo_impresa::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op.tipo_impresa::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN '-1'::text
END AS operatore_tipo_impresa

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN (select code from lookup_nazioni where description ilike opu_op_ind.nazione)::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op_ind.nazione::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN (select code from lookup_nazioni where description ilike org_ind1.state)::text
END AS operatore_indirizzo_nazione

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op_ind.toponimo::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op_ind.toponimo::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind1.toponimo::text
END AS operatore_indirizzo_toponimo

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op_ind.via::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op_ind.via::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind1.addrline1::text
END AS operatore_indirizzo_via

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op_ind.civico::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op_ind.civico::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind1.civico::text
END AS operatore_indirizzo_civico

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op_ind.comune::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op_ind.comune::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN (select id from comuni1 where nome ilike org_ind1.city)::text
END AS operatore_indirizzo_comune

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op_ind.provincia::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op_ind.provincia::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind1.country::text
END AS operatore_indirizzo_provincia

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op_ind.cap::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op_ind.cap::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind1.postalcode::text
END AS operatore_indirizzo_cap

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op_ind.latitudine::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op_ind.latitudine::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind1.latitude::text
END AS operatore_indirizzo_latitudine

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_op_ind.longitudine::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_op_ind.longitudine::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org_ind1.longitude::text
END AS operatore_indirizzo_longitudine

, '' as operatore_indirizzo_comune_estero
, '-1' as id_impresa_recuperata


-------------------------------------------------------------------------------------------------
------------------------------------------ SOGGETTO FISICO --------------------------------------
-------------------------------------------------------------------------------------------------

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg.nome::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg.nome::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.nome_rappresentante::text
END AS soggetto_nome

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg.cognome::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg.cognome::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.cognome_rappresentante::text
END AS soggetto_cognome

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg.codice_fiscale::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg.codice_fiscale::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.codice_fiscale_rappresentante::text
END AS soggetto_codice_fiscale

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg.data_nascita::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg.data_nascita::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN ''::text
END AS soggetto_data_nascita

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg.id_nazione_nascita::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg.nazione_nascita::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN '-1'::text
END AS soggetto_nazione_nascita

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN (select id from comuni1 where nome ilike opu_sogg.comune_nascita)::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN (select id from comuni1 where nome ilike sin_sogg.comune_nascita)::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN '-1'::text
END AS soggetto_comune_nascita

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg.sesso::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg.sesso::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN ''::text
END AS soggetto_sesso

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN (select code from lookup_nazioni where description ilike opu_sogg_ind.nazione)::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg_ind.nazione::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN '-1'::text
END AS soggetto_indirizzo_nazione

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg_ind.toponimo::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg_ind.toponimo::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN '-1'::text
END AS soggetto_indirizzo_toponimo

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg_ind.via::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg_ind.via::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN ''::text
END AS soggetto_indirizzo_via

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg_ind.civico::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg_ind.civico::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN ''::text
END AS soggetto_indirizzo_civico

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg_ind.comune::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg_ind.comune::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN '-1'::text
END AS soggetto_indirizzo_comune

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg_ind.cap::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg_ind.cap::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN ''::text
END AS soggetto_indirizzo_cap

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg_ind.provincia::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg_ind.provincia::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN ''::text
END AS soggetto_indirizzo_provincia

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg.email::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg.email::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.email_rappresentante::text
END AS soggetto_mail

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_sogg.telefono::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_sogg.telefono::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.telefono_rappresentante::text
END AS soggetto_telefono

, '-1' as id_rapp_legale_recuperato
, '' as soggetto_indirizzo_comune_estero

-------------------------------------------------------------------------------------------------
----------------------------------------------- LINEA -------------------------------------------
-------------------------------------------------------------------------------------------------

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_rel.data_inizio::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_rel.data_inizio::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.date1::text
END AS linea_1_data_inizio

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_rel.data_fine::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_rel.data_fine::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.date2::text
END AS linea_1_data_fine

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_rel.tipo_carattere::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN '-1'::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN '-1'::text
END AS linea_1_tipo_carattere

,concat(r.codice_macroarea, '-', r.codice_aggregazione, '-', r.codice_attivita) as linea_1_codice_univoco_ml

,CASE WHEN r.riferimento_id_nome_tab = 'opu_stabilimento' THEN opu_rel.codice_nazionale::text
WHEN r.riferimento_id_nome_tab = 'sintesis_stabilimento' THEN sin_stab.approval_number::text
WHEN r.riferimento_id_nome_tab = 'organization' THEN org.numaut::text
END AS linea_1_num_riconoscimento

, '' as linea_1_tipo_attivita



-------------------------------------------------------------------------------------------------
------------------------------------------------ ALTRI ------------------------------------------
-------------------------------------------------------------------------------------------------

, '' as autorizzazione_nota
, '' as autorizzazione_numero
, '' as autorizzazione_id_aia
, '' as autorizzazione_data
, '-1' as autorizzazione_tipo
, '' as autorizzazione_burc

, '' as responsabile_nome
, '' as responsabile_cognome
, '' as responsabile_codice_fiscale


from ricerche_anagrafiche_old_materializzata r

left join opu_stabilimento opu_stab on r.riferimento_id_nome_tab = 'opu_stabilimento' and opu_stab.id = r.riferimento_id
left join opu_operatore opu_op on opu_op.id = opu_stab.id_operatore
left join opu_rel_operatore_soggetto_fisico opu_relopsogg on opu_relopsogg.id_operatore = opu_op.id and opu_relopsogg .enabled
left join opu_soggetto_fisico opu_sogg on opu_sogg.id = opu_relopsogg.id_soggetto_fisico
left join opu_indirizzo opu_stab_ind on opu_stab_ind.id = opu_stab.id_indirizzo
left join opu_indirizzo opu_op_ind on opu_op_ind.id = opu_op.id_indirizzo
left join opu_indirizzo opu_sogg_ind on opu_sogg_ind.id = opu_sogg.indirizzo_id
left join opu_relazione_stabilimento_linee_produttive opu_rel on opu_rel.id_stabilimento = opu_stab.id and opu_rel.enabled

left join sintesis_stabilimento sin_stab on r.riferimento_id_nome_tab = 'sintesis_stabilimento' and sin_stab.alt_id = r.riferimento_id
left join sintesis_operatore sin_op on sin_op.id = sin_stab.id_operatore
left join sintesis_rel_operatore_soggetto_fisico sin_relopsogg on sin_relopsogg.id_operatore = sin_op.id and sin_relopsogg.enabled
left join sintesis_soggetto_fisico sin_sogg on sin_sogg.id = sin_relopsogg.id_soggetto_fisico
left join sintesis_indirizzo sin_stab_ind on sin_stab_ind.id = sin_stab.id_indirizzo
left join sintesis_indirizzo sin_op_ind on sin_op_ind.id = sin_op.id_indirizzo
left join sintesis_indirizzo sin_sogg_ind on sin_sogg_ind.id = sin_sogg.indirizzo_id
left join sintesis_relazione_stabilimento_linee_produttive sin_rel on sin_rel.id_stabilimento = sin_stab.id and sin_rel.enabled

left join organization org on r.riferimento_id_nome_tab = 'organization' and org.org_id = r.riferimento_id
left join organization_address org_ind5 on org_ind5.org_id = org.org_id and org_ind5.address_type = 5
left join organization_address org_ind1 on org_ind1.org_id = org.org_id and org_ind1.address_type = 1

where
r.riferimento_id = _riferimento_id 
and r.riferimento_id_nome_tab = _riferimento_id_nome_tab

 
    LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
    
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100
  ROWS 1000;


