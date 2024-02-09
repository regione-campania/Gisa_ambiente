-- Function: public.get_all_data_from_gisa_anag(text, text, text, text, text)

-- DROP FUNCTION public.get_all_data_from_gisa_anag(text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.get_all_data_from_gisa_anag(
    IN _ragione_sociale text DEFAULT ''::text,
    IN _partita_iva text DEFAULT ''::text,
    IN _codice_fiscale text DEFAULT ''::text,
    IN _asl text DEFAULT ''::text,
    IN _comune text DEFAULT ''::text)
  RETURNS TABLE(riferimento_id integer, riferimento_id_nome_tab text, ragione_sociale character varying, partita_iva character varying, codice_fiscale character varying, nominativo_rappresentante text, comune_leg character varying, provincia_leg text, indirizzo_leg text, comune character varying, provincia_stab text, indirizzo text, latitudine_stab double precision, longitudine_stab double precision, asl_rif integer, asl character varying) AS
$BODY$	
BEGIN
return  query 
  SELECT t1.* 
  FROM dblink('host=dbGISACAMPANIAL dbname=gisa'::text, 'SELECT distinct 
			riferimento_id, riferimento_id_nome_tab, ragione_sociale, partita_iva, codice_fiscale, nominativo_rappresentante
			, comune_leg, provincia_leg, indirizzo_leg, comune, provincia_stab, indirizzo, latitudine_stab, longitudine_stab
			, asl_rif, asl
			from ricerche_anagrafiche_old_materializzata') as t1(
			riferimento_id integer, riferimento_id_nome_tab text, 
			ragione_sociale character varying, partita_iva character varying, 
			codice_fiscale character varying, nominativo_rappresentante text,
			comune_leg character varying, provincia_leg text, indirizzo_leg text, 
			comune character varying, provincia_stab text, indirizzo text,
			latitudine_stab double precision,longitudine_stab double precision, asl_rif integer, asl character varying) 
			where 1=1 
	                and ( _partita_iva ='' or t1.partita_iva ilike  concat('%',_partita_iva,'%')) 
			and ( _codice_fiscale ='' or t1.codice_fiscale ilike concat('%',_codice_fiscale,'%'))  
			and ( _ragione_sociale ='' or t1.ragione_sociale ilike concat('%',_ragione_sociale,'%'))
			and ( _comune ='' or t1.comune ilike concat('%',_comune,'%')) 
			and ( _asl ='' or t1.asl ilike concat('%',_asl,'%')) ;
			
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_all_data_from_gisa_anag(text, text, text, text, text)
  OWNER TO postgres;

  -- Function: public.import_from_gisa_anag(integer, text)

-- DROP FUNCTION public.import_from_gisa_anag(integer, text);

CREATE OR REPLACE FUNCTION public.import_from_gisa_anag(
    _riferimento_id integer,
    _riferimento_id_nome_tab text)
  RETURNS integer AS
$BODY$	
declare
	result integer;
	query text;
	idLog integer;
	
        soggetto_indirizzo_comune text;
	soggetto_indirizzo_nazione text;
	lineaattivita_1_data_inizio_attivita  text;
	toponimo_soggfis  text;
	latitudine_stab  text;
	cap_soggfis  text;
	codice_fiscale  text;
	latitudine_leg  text;
	toponimo_sede_legale  text;
	via_soggfis  text;
	autorizzazione_nota  text;
	data_nascita_rapp_leg  text;
	partita_iva  text;
	lineaattivita_1_data_fine_attivita  text;
	autorizzazione_id_aia  text;
	comune_nascita_rapp_leg  text;
	comune_estero_sede_legale  text;
	civico_stab  text;
	autorizzazione_numero  text;
	cf_resp_stab  text;
	civico_sede_legale  text;
	nome_resp_stab  text;
	nome_rapp_leg  text;
	email_impresa  text;
	longitudine_stab  text;
	cod_provincia_soggfis  text;
	responsabile_codice_fiscale text;
	id_impresa_recuperata  text;
	email_rapp_leg  text;
	cod_comune_stab  text;
	lineaattivita_1_codice_univoco_ml  text;	
	cap_leg  text;
	longitudine_leg  text;
	autorizzazione_data  text;
	lineaattivita_1_tipo_carattere_attivita  text;
	nazione_nascita_rapp_leg  text;
	sesso_rapp_leg  text;
	id_rapp_legale_recuperato  text;
	cognome_resp_stab  text;
	toponimo_stab  text;
	autorizzazione_tipo  text;
	ragione_sociale  text;
	cognome_rapp_leg  text;
	civico_soggfis  text;
	denominazione_stab  text;
	id_stabilimento  text;
	autorizzazione_burc  text;
	telefono_rapp_leg  text;
	comune_residenza_estero_soggfis  text;
	nazione_sede_legale  text;
	via_sede_legale  text;
	cod_provincia_sede_legale  text;
	lineaattivita_1_num_riconoscimento  text;
	codice_fiscale_rappresentante  text;
	cap_stab  text;
	lineaattivita_1_tipo_attivita  text;
	cod_provincia_stab  text;
	tipo_impresa  text;
	cod_comune_sede_legale  text;
	via_stab text;

BEGIN

 result := -1;
 idLog := -1;
 query := '';
 
	select 
	t1.soggetto_indirizzo_comune , --ok
	t1.soggetto_indirizzo_nazione , --ok
	t1.linea_1_data_inizio , --ok
	t1.toponimo_soggfis , --ok
	t1.latitudine_stab , --ok
	t1.cap_soggfis ,--ok
	t1.codice_fiscale ,--ok
	t1.latitudine_leg ,--ok
	t1.toponimo_sede_legale ,--ok
	t1.via_soggfis ,--ok
	t1.autorizzazione_nota ,--ok
	t1.data_nascita_rapp_leg ,--ok
	t1.partita_iva ,--ok
	t1.lineaattivita_1_data_fine_attivita ,--ok
	t1.autorizzazione_id_aia ,--ok
	t1.comune_nascita_rapp_leg ,--ok
	t1.comune_estero_sede_legale ,--ok
	t1.civico_stab ,--ok
	t1.autorizzazione_numero ,--ok
	t1.cf_resp_stab ,--ok
	t1.civico_sede_legale ,--ok
	t1.nome_resp_stab ,--ok
	t1.nome_rapp_leg ,--ok
	t1.email_impresa ,--ok
	t1.longitudine_stab ,--ok
	t1.cod_provincia_soggfis ,--ok
	t1.responsabile_codice_fiscale ,--ok
	t1.id_impresa_recuperata , --ok
	t1.email_rapp_leg , --ok
	t1.cod_comune_stab , --ok
	t1.lineaattivita_1_codice_univoco_ml ,--ok
	t1.cap_leg , --ok
	t1.longitudine_leg , --ok
	t1.autorizzazione_data , --ok
	t1.lineaattivita_1_tipo_carattere_attivita , --ok
	t1.nazione_nascita_rapp_leg ,--ok
	t1.sesso_rapp_leg ,--ok
	t1.id_rapp_legale_recuperato ,--ok
	t1.cognome_resp_stab , --ok
	t1.toponimo_stab , --ok
	t1.autorizzazione_tipo , --ok
	t1.ragione_sociale , --ok
	t1.cognome_rapp_leg , --ok
	t1.civico_soggfis , --ok
	t1.denominazione_stab , --ok
	t1.id_stabilimento , --ok
	t1.autorizzazione_burc , --ok
	t1.telefono_rapp_leg , --ok
	t1.comune_residenza_estero_soggfis , --ok
	t1.nazione_sede_legale , --ok
	t1.via_sede_legale , --ok
	t1.cod_provincia_sede_legale ,--ok
	t1.lineaattivita_1_num_riconoscimento , --ok
	t1.codice_fiscale_rappresentante , --ok
	t1.cap_stab , --ok
	t1.lineaattivita_1_tipo_attivita , --ok
	t1.cod_provincia_stab , --ok
	t1.tipo_impresa , --ok
	t1.cod_comune_sede_legale , --ok
	t1.via_stab  --ok
	
 into 
        soggetto_indirizzo_comune,
        soggetto_indirizzo_nazione , 
	lineaattivita_1_data_inizio_attivita ,
	toponimo_soggfis ,
	latitudine_stab ,
	cap_soggfis ,
	codice_fiscale ,
	latitudine_leg ,
	toponimo_sede_legale ,
	via_soggfis ,
	autorizzazione_nota ,
	data_nascita_rapp_leg ,
	partita_iva ,
	lineaattivita_1_data_fine_attivita ,
	autorizzazione_id_aia ,
	comune_nascita_rapp_leg ,
	comune_estero_sede_legale ,
	civico_stab ,
	autorizzazione_numero ,
	cf_resp_stab ,
	civico_sede_legale ,
	nome_resp_stab ,
	nome_rapp_leg ,
	email_impresa ,
	longitudine_stab ,
	cod_provincia_soggfis,
	responsabile_codice_fiscale,
	id_impresa_recuperata ,
	email_rapp_leg ,
	cod_comune_stab ,
	lineaattivita_1_codice_univoco_ml ,	
	cap_leg ,
	longitudine_leg ,
	autorizzazione_data ,
	lineaattivita_1_tipo_carattere_attivita ,
	nazione_nascita_rapp_leg ,
	sesso_rapp_leg ,
	id_rapp_legale_recuperato ,
	cognome_resp_stab ,
	toponimo_stab ,
	autorizzazione_tipo ,
	ragione_sociale ,
	cognome_rapp_leg ,
	civico_soggfis ,
	denominazione_stab ,
	id_stabilimento ,
	autorizzazione_burc ,
	telefono_rapp_leg ,
	comune_residenza_estero_soggfis ,
	nazione_sede_legale ,
	via_sede_legale ,
	cod_provincia_sede_legale ,
	lineaattivita_1_num_riconoscimento ,
	codice_fiscale_rappresentante ,
	cap_stab ,
	lineaattivita_1_tipo_attivita ,
	cod_provincia_stab ,
	tipo_impresa ,
	cod_comune_sede_legale ,
	via_stab
 
	FROM dblink('host=dbGISACAMPANIAL  dbname=gisa'::text, 'SELECT 
	soggetto_indirizzo_comune,
	soggetto_indirizzo_nazione,
	linea_1_data_inizio,
	soggetto_indirizzo_toponimo,
	stabilimento_indirizzo_latitudine,
	soggetto_indirizzo_cap,
	operatore_codice_fiscale,
	operatore_indirizzo_latitudine,
	operatore_indirizzo_toponimo,
	soggetto_indirizzo_via,
	autorizzazione_nota,
	soggetto_data_nascita,
	operatore_partita_iva,
	linea_1_data_fine,
	autorizzazione_id_aia,
	soggetto_comune_nascita,
	operatore_indirizzo_comune_estero,
	stabilimento_indirizzo_civico,
	autorizzazione_numero,
	soggetto_codice_fiscale,
	operatore_indirizzo_civico,
	responsabile_nome,
	soggetto_nome,
	operatore_mail,
	stabilimento_indirizzo_longitudine,
	soggetto_indirizzo_provincia,
	responsabile_codice_fiscale,
	id_impresa_recuperata, 
	soggetto_mail,
	stabilimento_indirizzo_comune,
	linea_1_codice_univoco_ml,
	operatore_indirizzo_cap,
	operatore_indirizzo_latitudine,
	autorizzazione_data, 
	linea_1_tipo_carattere,
	soggetto_nazione_nascita,
	soggetto_sesso,
	id_rapp_legale_recuperato,
	responsabile_cognome,
	stabilimento_indirizzo_toponimo,
	autorizzazione_tipo,
	operatore_ragione_sociale,
	soggetto_cognome,
	soggetto_indirizzo_civico,
	stabilimento_denominazione,
	id_stabilimento,
	autorizzazione_burc,
	soggetto_telefono,
	soggetto_indirizzo_comune_estero,
	operatore_indirizzo_nazione,
	operatore_indirizzo_via,
	operatore_indirizzo_provincia,
	linea_1_num_riconoscimento,
	soggetto_codice_fiscale,
	stabilimento_indirizzo_cap,
	linea_1_tipo_attivita,
	stabilimento_indirizzo_provincia,
	operatore_tipo_impresa,
	operatore_indirizzo_comune,
	stabilimento_indirizzo_via
	from get_dati_per_import_gisa_anag('||_riferimento_id||','''||_riferimento_id_nome_tab||''')'::text)  as
	t1(soggetto_indirizzo_comune text, --ok
	soggetto_indirizzo_nazione text, --ok
	linea_1_data_inizio text, --ok
	toponimo_soggfis text, --ok
	latitudine_stab text, --ok
	cap_soggfis text,--ok
	codice_fiscale text,--ok
	latitudine_leg text,--ok
	toponimo_sede_legale text,--ok
	via_soggfis text,--ok
	autorizzazione_nota text,--ok
	data_nascita_rapp_leg text,--ok
	partita_iva text,--ok
	lineaattivita_1_data_fine_attivita text,--ok
	autorizzazione_id_aia text,--ok
	comune_nascita_rapp_leg text,--ok
	comune_estero_sede_legale text,--ok
	civico_stab text,--ok
	autorizzazione_numero text,--ok
	cf_resp_stab text,--ok
	civico_sede_legale text,--ok
	nome_resp_stab text,--ok
	nome_rapp_leg text,--ok
	email_impresa text,--ok
	longitudine_stab text,--ok
	cod_provincia_soggfis text,--ok
	responsabile_codice_fiscale text,--ok
	id_impresa_recuperata text, --ok
	email_rapp_leg text, --ok
	cod_comune_stab text, --ok
	lineaattivita_1_codice_univoco_ml text,	--ok
	cap_leg text, --ok
	longitudine_leg text, --ok
	autorizzazione_data text, --ok
	lineaattivita_1_tipo_carattere_attivita text, --ok
	nazione_nascita_rapp_leg text,--ok
	sesso_rapp_leg text,--ok
	id_rapp_legale_recuperato text,--ok
	cognome_resp_stab text, --ok
	toponimo_stab text, --ok
	autorizzazione_tipo text, --ok
	ragione_sociale text, --ok
	cognome_rapp_leg text, --ok
	civico_soggfis text, --ok
	denominazione_stab text, --ok
	id_stabilimento text, --ok
	autorizzazione_burc text, --ok
	telefono_rapp_leg text, --ok
	comune_residenza_estero_soggfis text, --ok
	nazione_sede_legale text, --ok
	via_sede_legale text, --ok
	cod_provincia_sede_legale text,--ok
	lineaattivita_1_num_riconoscimento text, --ok
	codice_fiscale_rappresentante text, --ok
	cap_stab text, --ok
	lineaattivita_1_tipo_attivita text, --ok
	cod_provincia_stab text, --ok
	tipo_impresa text, --ok
	cod_comune_sede_legale text, --ok
	via_stab text --ok
	);

raise info '[import_from_gisa_anag] select * from import_from_gisa_anag (%,''%'');', _riferimento_id, _riferimento_id_nome_tab;	
raise info 'comune  nascita %', length(lineaattivita_1_data_fine_attivita);

query := concat(concat('select * from public.insert_gestione_anagrafica(
''"cod_comune_soggfis"=>', 
case when soggetto_indirizzo_comune is null then '-1' else concat('"',soggetto_indirizzo_comune,'"') end,'', ', ', 
'"nazione_soggfis"=>"106"', ', ', 
'"lineaattivita_1_data_inizio_attivita"=>', 
case when (lineaattivita_1_data_inizio_attivita) is null then 'null' else concat('"',lineaattivita_1_data_inizio_attivita,'"') end,'', ', ', 
'"toponimo_soggfis"=>',
case when (toponimo_soggfis) is null then '-1' else concat('"',toponimo_soggfis,'"') end,'', ', ', 
'"latitudine_stab"=>',
case when (latitudine_stab) is null then '0' else concat('"',latitudine_stab,'"') end,'', ', ', 
'"cap_soggfis"=>"',cap_soggfis,'"', ', ',
'"codice_fiscale"=>"',codice_fiscale,'"', ', ',
'"latitudine_leg"=>',
case when (latitudine_leg) is null then '0' else concat('"',latitudine_leg,'"') end,'', ', ', 
'"toponimo_sede_legale"=>',
case when (toponimo_sede_legale) is null then '-1' else concat('"',toponimo_sede_legale,'"') end,'', ', ', 
'"via_soggfis"=>"',via_soggfis,'"', ', ',
'"autorizzazione_nota"=>NULL', ', ', 
'"data_nascita_rapp_leg"=>', 
case when length(data_nascita_rapp_leg) = 0 then 'null' else concat('"',data_nascita_rapp_leg,'"') end,'', ', ', 
'"partita_iva"=>"',partita_iva,'"', ', ',
'"lineaattivita_1_data_fine_attivita"=>',
case when lineaattivita_1_data_fine_attivita is null then 'null' else concat('"',lineaattivita_1_data_fine_attivita,'"') end,'', ', ', 
'"autorizzazione_id_aia"=>NULL', ', ',  
'"comune_nascita_rapp_leg"=>',
case when comune_nascita_rapp_leg is null then '-1' else concat('"',comune_nascita_rapp_leg,'"') end,'', ', ', 
'"comune_estero_sede_legale"=>"',comune_estero_sede_legale,'"', ', ',
'"civico_stab"=>"',civico_stab,'"', ', ',
'"autorizzazione_numero"=>NULL', ', ',
'"cf_resp_stab"=>"',cf_resp_stab,'"', ', ', 
'"civico_sede_legale"=>"',civico_sede_legale,'"', ', ',
'"nome_resp_stab"=>"',nome_resp_stab,'"', ', ', 
'"email_impresa"=>"',email_impresa,'"', ', ',
'"longitudine_stab"=>',
case when (longitudine_stab) is null then '0' else concat('"',longitudine_stab,'"') end,'', ', ', 
'"cod_provincia_soggfis"=>',
case when cod_provincia_soggfis is null then '-1' else concat('"',cod_provincia_soggfis,'"') end,'', ', ', 
'"email_rapp_leg"=>"',email_rapp_leg,'"', ', ', 
''), 
concat('',
'"cod_comune_stab"=>',
case when cod_comune_stab is null then '-1' else concat('"',cod_comune_stab,'"') end,'', ', ', 
'"lineaattivita_1_codice_univoco_ml"=>"NON.MAPP."', ', ',  
'"cap_leg"=>"',cap_leg,'"', ', ',
'"longitudine_leg"=>',
case when (longitudine_leg) is null then '0' else concat('"',longitudine_leg,'"') end,'', ', ', 
'"autorizzazione_data"=>NULL', ', ',  
'"lineaattivita_1_tipo_carattere_attivita"=>',
case when lineaattivita_1_tipo_carattere_attivita is null then '-1' else concat('"',lineaattivita_1_tipo_carattere_attivita,'"') end,'', ', ', 
'"nazione_nascita_rapp_leg"=>"106"', ', ',
'"sesso_rapp_leg"=>"',sesso_rapp_leg,'"', ', ', 
'"id_rapp_legale_recuperato"=>',
case when id_rapp_legale_recuperato is null then '-1' else concat('"',id_rapp_legale_recuperato,'"') end,'', ', ', 
'"cognome_resp_stab"=>"',cognome_resp_stab,'"', ', ',
'"toponimo_stab"=>',
case when toponimo_stab is null then '-1' else concat('"',toponimo_stab,'"') end,'', ', ', 
'"autorizzazione_tipo"=>NULL', ', ', 
'"ragione_sociale"=>"',replace(replace(ragione_sociale,'"','\"'),'''',''''''),'"', ', ',
'"cognome_rapp_leg"=>"',cognome_rapp_leg,'"', ', ',
'"civico_soggfis"=>"',civico_soggfis,'"', ', ', 
'"denominazione_stab"=>NULL', ', ', -------------------------------------> recuperaòa
'"id_stabilimento"=>',
case when id_stabilimento is null then '-1' else concat('"',id_stabilimento,'"') end,'', ', ', 
'"autorizzazione_burc"=>NULL', ', ', 
'"telefono_rapp_leg"=>NULL', ', ',
'"comune_residenza_estero_soggfis"=>"','"', ', ', 
'"nazione_sede_legale"=>"106"', ', ',
'"via_sede_legale"=>"',via_sede_legale,'"', ', ', 
'"cod_provincia_sede_legale"=>',
case when cod_provincia_sede_legale is null then '-1' else concat('"',cod_provincia_sede_legale,'"') end,'', ', ', 
'"lineaattivita_1_num_riconoscimento"=>"',lineaattivita_1_num_riconoscimento,'"', ', ',
'"codice_fiscale_rappresentante"=>"',codice_fiscale_rappresentante,'"', ', ',
'"cap_stab"=>"',cap_stab,'"', ', ',
'"lineaattivita_1_tipo_attivita"=>',
case when lineaattivita_1_tipo_attivita is null then '-1' else concat('"',lineaattivita_1_tipo_attivita,'"') end,'', ', ', 
''),
concat('',
'"cod_provincia_stab"=>',
case when cod_provincia_stab is null then '-1' else concat('"',cod_provincia_stab,'"') end,'', ', ', 
'"tipo_impresa"=>',
case when tipo_impresa is null then '-1' else concat('"',tipo_impresa,'"') end,'', ', ', 
'"cod_comune_sede_legale"=>',
case when cod_comune_sede_legale is null then '-1' else concat('"',cod_comune_sede_legale,'"') end,'', ', ', 
'"via_stab"=>"',via_stab,'"', '''::hstore', ', ',
'''''','::hstore ', ', ',
'964',', ',
'-1',', ',
'''''', ', ',
'-1','',
')')
);


raise info '[import_from_gisa_anag] %', query;

insert into log_import_gisa_remoto(riferimento_id_remoto, riferimento_id_nome_tab_remoto, dbi) values(_riferimento_id, _riferimento_id_nome_tab, query) returning id into idLog;

execute query into result;

update log_import_gisa_remoto set riferimento_id = result, riferimento_id_nome_tab = 'opu_stabilimento', modified = now(), output = result where id = idLog;

if (result > 0) THEN
	UPDATE opu_stabilimento set linee_pregresse=true where id = result;
END IF;

return result;

EXCEPTION WHEN OTHERS THEN
raise notice '% %', SQLERRM, SQLSTATE;
insert into log_import_gisa_remoto(riferimento_id_remoto, riferimento_id_nome_tab_remoto, dbi, output, error) values(_riferimento_id, _riferimento_id_nome_tab, query, result, concat('[',SQLSTATE, '] ', SQLERRM ));
return result;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.import_from_gisa_anag(integer, text)
  OWNER TO postgres;
  
  select * from role where enabled and role_id not in (1,32);

update role set role='Tecnico di controlli di gestione rifiuti', description='Tecnico di controlli di gestione rifiuti' where role_id = 3;
update role set role='Tecnico di controlli di emissioni in atmosfera e agenti fisici', description='Tecnico di controlli di emissioni in atmosfera e agenti fisici' where role_id = 33;
update role set role='Dirigente Apicale', description='Dirigente Apicale' where role_id = 27;


insert into role(role_id, role, description, enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
(select nextval('role_role_id_seq'),'Tecnico di controlli del suolo e siti contaminanti','Tecnico di controlli del suolo e siti contaminanti', enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo 
from role where role_id=33);

insert into role(role_id, role, description, enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo)
(select nextval('role_role_id_seq'),'Dirigente dipartimento','Dirigente dipartimento', enteredby, entered, modified, modifiedby, enabled, role_type, admin, super_ruolo, descrizione_super_ruolo, in_access, in_dpat, in_nucleo_ispettivo, enabled_as_qualifica, view_lista_utenti_nucleo_ispettivo 
from role where role_id=33);

update role set enabled=false where role_id in (42,43); -- disabilito i ruoli referente e responsabile
update role_permission set role_id=2 where role_id in (42);
update role_permission set role_id=3 where role_id in (43);
update role  set in_access  = false where role_id=4 -- disabilito accesso al ruolo ufficiale giudiziario

--select * from role where enabled

-- verifica quanti ruoli non hanno i permessi configurati
select * from role_permission where role_id not in (select role_id from role where enabled)

-- crea script in base al ruolo creato
select 'insert into role_permission(id, role_id, permission_id, role_view, role_add, role_edit) values((select max(id)+1 from role_permission),?,'||permission_id||',true, true, true);',* 
from role_permission where role_id in (3)
select 'insert into role_permission(id, role_id, permission_id, role_view, role_add, role_edit) values((select max(id)+1 from role_permission),?,'||permission_id||',true, true, true);',* 
from role_permission where role_id in (3)
select 'insert into role_permission(id, role_id, permission_id, role_view, role_add, role_edit) values((select max(id)+1 from role_permission),?,'||permission_id||',true, true, true);',* 
from role_permission where role_id in (3)
select 'insert into role_permission(id, role_id, permission_id, role_view, role_add, role_edit) values((select max(id)+1 from role_permission),?,'||permission_id||',true, false, false);',* 
from role_permission where role_id in (27)
select * from role_permission where role_id not in (select role_id from role where enabled)


alter table cu_nucleo add column referente boolean default false;
alter table cu_nucleo add column responsabile boolean default false;
  
  -------------------------- da lanciare in collaudo---------------------
truncate anagrafica_fasi_lavorazione;
drop table anagrafica_fasi_lavorazione;
DROP TABLE public.opu_dati_aggiuntivi;
 


CREATE TABLE public.anag_dati_aggiuntivi
(
  id integer NOT NULL DEFAULT nextval('anag_dati_aggiuntivi_id_seq'::regclass),
  riferimento_id integer,
  riferimento_id_nome_tab text,
  nome_responsabile text,
  cognome_responsabile text,
  cf_responsabile text,
  denominazione_stabilimento text,
  enteredby integer,
  modifiedby integer,
  entered timestamp without time zone DEFAULT now(),
  modified timestamp without time zone,
  trashed_date timestamp without time zone
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.anag_dati_aggiuntivi
  OWNER TO postgres;

  
CREATE TABLE public.anag_dati_autorizzativi
(
  id serial,
  riferimento_id integer,
  riferimento_id_nome_tab text,
  id_aia text,
  tipo_autorizzazione integer,
  num_decreto text,
  data_decreto text,
  nota text,
  burc text,
  enteredby integer,
  modifiedby integer,
  entered timestamp without time zone DEFAULT now(),
  modified timestamp without time zone,
  trashed_date timestamp without time zone,
  CONSTRAINT opu_dati_aggiuntivi_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.anag_dati_autorizzativi
  OWNER TO postgres;

  
CREATE TABLE public.anag_dati_autorizzativi_matrici
(
  id serial,
  id_anag_dati_autorizzativi integer,
  id_matrice integer,
  note text,
  entered timestamp without time zone DEFAULT now(),
  enteredby integer,
  modified timestamp without time zone,
  modifiedby integer,
  trashed_date timestamp without time zone,
  CONSTRAINT opu_dati_aggiuntivi_matrice_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.anag_dati_autorizzativi_matrici
  OWNER TO postgres;

  
CREATE TABLE public.emissioni_in_atmosfera_camini
(
  id integer NOT NULL DEFAULT nextval('emissioni_in_atmosfera_camini_id_seq'::regclass),
  codice_camino text,
  fasi_lavorativa text,
  inquinanti text,
  sistema_abbattimento text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.emissioni_in_atmosfera_camini
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION public.get_dati_autorizzativi(
    IN _riferimento_id integer,
    IN _riferimento_id_nome_tab text)
  RETURNS TABLE(id integer, id_aia text, tipo_autorizzazione integer, num_decreto text, data_decreto text, nota text, burc text, enteredby integer, modifiedby integer, entered timestamp without time zone, modified timestamp without time zone, trashed_date timestamp without time zone, riferimento_id integer, riferimento_id_nome_tab text) AS
$BODY$
DECLARE
	
BEGIN 
	
	RETURN QUERY
		select o.id,  o.id_aia, o.tipo_autorizzazione, o.num_decreto, o.data_decreto, o.nota, o.burc, o.enteredby, o.modifiedby, o.entered, o.modified, o.trashed_date,
		o.riferimento_id, o.riferimento_id_nome_tab
		from anag_dati_autorizzativi o 
		left join lookup_autorizzazione_tipo l on l.code::integer = o.tipo_autorizzazione
		where o.riferimento_id = _riferimento_id and o.riferimento_id_nome_tab =  _riferimento_id_nome_tab
		and o.trashed_date is null;	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_dati_autorizzativi(integer, text)
  OWNER TO postgres;

  


CREATE OR REPLACE FUNCTION public.get_dati_autorizzativi_matrici(IN _id_dati_autorizzativi integer)
  RETURNS TABLE(id integer, id_matrice integer, id_anag_dati_autorizzativi integer, entered timestamp without time zone, enteredby integer, modified timestamp without time zone, modifiedby integer, trashed_date timestamp without time zone) AS
$BODY$
DECLARE
	
BEGIN 
	
	RETURN QUERY
		select o.id, o.id_matrice, o.id_anag_dati_autorizzativi, o.entered, o.enteredby, o.modified, o.modifiedby, o.trashed_date 
		from anag_dati_autorizzativi_matrici o  
		where o.id_anag_dati_autorizzativi = _id_dati_autorizzativi and o.trashed_date is null;	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_dati_autorizzativi_matrici(integer)
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

  

CREATE OR REPLACE FUNCTION public.upsert_dati_autorizzativi(
    _riferimento_id integer,
    _riferimento_id_nome_tab text,
    _id_utente integer,
    _id_aia text,
    _id_autorizzazione integer,
    _num_decreto text,
    _data_decreto text,
    _nota text,
    _burc text,
    _id_matrici text)
  RETURNS text AS
$BODY$
DECLARE
	  id_opu_result integer;
	  matrici text[];
          i text;
BEGIN

 
	matrici := string_to_array(_id_matrici,',');
	raise info 'matrici %', matrici;
	update anag_dati_autorizzativi set modifiedby = _id_utente, trashed_date = now() 
	where riferimento_id= _riferimento_id 
	and   riferimento_id_nome_tab = _riferimento_id_nome_tab
	and trashed_date is null;

	insert into anag_dati_autorizzativi(riferimento_id , riferimento_id_nome_tab, id_aia, tipo_autorizzazione, num_decreto, data_decreto, nota, burc) values
	                               (_riferimento_id, _riferimento_id_nome_tab,_id_aia, _id_autorizzazione, _num_decreto, _data_decreto, _nota, _burc) 
	                          
	returning id into id_opu_result;

	FOREACH i IN ARRAY matrici --loop through each element in array matrici
	LOOP
	 raise info '%', i;
		insert into anag_dati_autorizzativi_matrici (id_anag_dati_autorizzativi, id_matrice, enteredby) values (id_opu_result, i::integer, _id_utente);	
	END LOOP;

	if id_opu_result > 0 then
		return 'OK, operazione effettuata con successo.';
	else
		return 'KO, operazione non effettuata.';
	end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.upsert_dati_autorizzativi(integer, text, integer, text, integer, text, text, text, text, text)
  OWNER TO postgres;



  
CREATE OR REPLACE FUNCTION public.get_anagrafica_matrici(
    IN _riferimento_id integer,
    IN _riferimento_id_nome_tab text)
  RETURNS TABLE(code integer, matrice text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select t.code, t.description::text
	from lookup_matrice_controlli t 
	left join anag_dati_autorizzativi_matrici am on am.id_matrice = t.code
	left join anag_dati_autorizzativi ag on ag.id = am.id_anag_dati_autorizzativi
	where t.enabled and am.trashed_date is null
	and ag.riferimento_id = _riferimento_id and ag.riferimento_id_nome_tab = _riferimento_id_nome_tab
	and ag.trashed_date is null
	order by t.description;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_anagrafica_matrici(integer, text)
  OWNER TO postgres;

  
 
CREATE OR REPLACE FUNCTION public.get_emissioni_atmosfera_camini(
    _riferimento_id integer,
    _riferimento_id_nome_tab text)
  RETURNS SETOF emissioni_in_atmosfera_camini AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select *
	from  emissioni_in_atmosfera_camini;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_emissioni_atmosfera_camini(integer, text)
  OWNER TO postgres;


  
CREATE OR REPLACE FUNCTION public.cu_insert_emissioni_in_atmosfera_camini(
    _json_datifasilavorazione json,
    _idcu integer,
    _idutente integer,
    _riferimento_id integer,
    _riferimento_id_nome_tab text)
  RETURNS integer AS
$BODY$	
DECLARE
	i json; 
	id_emissioni_camini integer;
BEGIN


	  FOR i IN SELECT * FROM json_array_elements(_json_datifasilavorazione) 
	  LOOP
	      RAISE INFO 'id %', i->>'id';
	    

		if ((i->>'id')::integer) <0 then
			-- fai insert in anag_emissioni_in_atmosfera_camini
			insert into emissioni_in_atmosfera_camini(codice_camino, fasi_lavorativa, inquinanti, sistema_abbattimento) values((i->>'codiceCamino')::text, (i->>'fasiLavorativa')::text, (i->>'inquinanti')::text, (i->>'sistemaAbbattimento')::text) 
			returning id into id_emissioni_camini;
			insert into anag_emissioni_in_atmosfera_camini( id_emissioni_in_atmosfera_camini,enteredby, riferimento_id, riferimento_id_nome_tab) values(id_emissioni_camini, _idutente, _riferimento_id, _riferimento_id_nome_tab);
		else
			id_emissioni_camini := (i->>'id')::integer;
		end if;		
	                                                            
	        INSERT INTO controlli_ufficiali_emissioni_in_atmosfera_camini  (id_controllo, id_emissioni_in_atmosfera_camini, esito_conforme, note, data_sopralluogo_2016, parametri_analizzati, superamenti_limiti_normativi,
	                                                                      entered, enteredby) values
	                                                                     (_idcu,
	                                                                      id_emissioni_camini,
	                                                                     (i->>'esitoConforme')::boolean,
	                                                                     (i->>'note')::text,
	                                                                     (i->>'dataSopralluogo2016')::text,
	                                                                     (i->>'parametriAnalizzati')::text,
	                                                                     (i->>'superamentiLimitiNormativi')::text,
	                                                                     now(),
								             _idutente);
	  END LOOP;

    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cu_insert_emissioni_in_atmosfera_camini(json, integer, integer,integer, text)
  OWNER TO postgres;

DROP FUNCTION public.cu_insert_globale(json);

-- Function: public.cu_insert_globale(json)

-- DROP FUNCTION public.cu_insert_globale(json);

CREATE OR REPLACE FUNCTION public.cu_insert_globale(_json_dati json)
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
	emissioni_in_atmosfera json;
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

	emissioni_in_atmosfera := _json_dati -> 'EmissioniAtmosferaCamini';
	RAISE INFO 'json dipartimento %', emissioni_in_atmosfera;

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

	raise info 'stampaaaaaaa %', length(datigenerici ->> 'dataFine');
	-- STEP 3: INSERIAMO I DATI DEL CU + linee
	update controlli_ufficiali set stato=1, note = (datigenerici ->> 'note'), id_dipartimento = (dipartimento ->> 'id')::int, 
	data_inizio  = (datigenerici ->> 'dataInizio')::timestamp without time zone, 
	data_fine = (case when length(datigenerici ->> 'dataFine') > 0 then (datigenerici ->> 'dataFine')::timestamp without time zone else null end), 
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
	output := (SELECT * FROM public.cu_insert_emissioni_in_atmosfera_camini(emissioni_in_atmosfera,idcontrollo,idutente, (anagrafica ->> 'riferimentoId')::integer, anagrafica ->> 'riferimentoIdNomeTab'));

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


CREATE OR REPLACE FUNCTION public.get_dati_acque_reflue(
    IN _riferimento_id integer,
    IN _riferimento_id_nome_tab text)
  RETURNS TABLE(id integer, depurazione_reflui boolean, id_stato_impianto integer, 
                gestore_impianto text, id_processo_depurativo integer, potenzialita_impianto_ae text,
                recettore_scarico text, recettore_finale text, codice_ulia text, enteredby integer, modifiedby integer, entered timestamp without time zone, modified timestamp without time zone, trashed_date timestamp without time zone, riferimento_id integer, riferimento_id_nome_tab text) AS
$BODY$
DECLARE
	
BEGIN 
	
	RETURN  query 
		select * from anag_acque_reflue;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_dati_acque_reflue(integer, text)
  OWNER TO postgres;
  
  create table lookup_processo_depurativo  (

	code serial,
	description text,
	short_description text,
	enabled boolean default true,
	default_item boolean DEFAULT false,

	level integer
) 
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lookup_processo_depurativo
  OWNER TO postgres;

insert into lookup_processo_depurativo( description, short_description) values ('CHIMICO-FISICO', 'CHIMICO-FISICO');
insert into lookup_processo_depurativo( description, short_description) values ('BIOLOGICO', 'BIOLOGICO');
insert into lookup_processo_depurativo( description, short_description) values ('VASCA IMHOFF', 'VASCA IMHOFF');
insert into lookup_processo_depurativo( description, short_description) values ('ALTRO', 'ALTRO');

create table lookup_stato_impianto_acque_reflue 
(
	code serial,
	description text,
	short_description text,
	enabled boolean default true,
	default_item boolean DEFAULT false,
	level integer
) 
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lookup_stato_impianto_acque_reflue
  OWNER TO postgres;

insert into lookup_stato_impianto_acque_reflue(description, short_description) values ('FUNZIONANTE', 'FUNZIONANTE');
insert into lookup_stato_impianto_acque_reflue(description, short_description) values ('PARZIALMENTE FUNZIONANTE', 'PARZIALMENTE FUNZIONANTE');
insert into lookup_stato_impianto_acque_reflue(description, short_description) values ('NON FUNZIONANTE', 'NON FUNZIONANTE');




CREATE TABLE public.anag_acque_reflue
(
  id serial,
  depurazione_reflui boolean, 
  id_stato_impianto integer, 
  gestore_impianto text, 
  id_processo_depurativo integer, 
  potenzialita_impianto_ae text,
  recettore_scarico text, 
  recettore_finale text, 
  codice_ulia text, 
  enteredby integer, 
  modifiedby integer, 
  entered timestamp without time zone, 
  modified timestamp without time zone, 
  trashed_date timestamp without time zone, 
  riferimento_id integer, 
  riferimento_id_nome_tab text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.anag_acque_reflue
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.get_dati_acque_reflue(
    IN _riferimento_id integer,
    IN _riferimento_id_nome_tab text)
  RETURNS TABLE(id integer, depurazione_reflui boolean, id_stato_impianto integer, 
                gestore_impianto text, id_processo_depurativo integer, potenzialita_impianto_ae text,
                recettore_scarico text, recettore_finale text, codice_ulia text, enteredby integer, modifiedby integer, entered timestamp without time zone, modified timestamp without time zone, trashed_date timestamp without time zone, riferimento_id integer, riferimento_id_nome_tab text) AS
$BODY$
DECLARE
	
BEGIN 
	
	RETURN  query 
		select * from anag_acque_reflue;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_dati_acque_reflue(integer, text)
  OWNER TO postgres;

--select * from get_dati_acque_reflue(90,'opu_stabilimento')

CREATE OR REPLACE FUNCTION public.has_matrice_anagrafica(
    _riferimento_id integer,
    _riferimento_id_nome_tab text,
    _matrice text)
  RETURNS boolean AS
$BODY$
DECLARE
	conta_record integer;
BEGIN 
	conta_record := (select count(id_matrice) from anag_dati_autorizzativi_matrici a
	join anag_dati_autorizzativi ad on ad.id = a.id_anag_dati_autorizzativi
	where ad.riferimento_id = _riferimento_id and ad.riferimento_id_nome_tab = _riferimento_id_nome_tab
	and a.id_matrice = (select code from lookup_matrice_controlli where description ilike _matrice and enabled)
	and ad.trashed_date is null);

	if(conta_record > 0) then
		return true;
	else 
		return false;
	end if;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.has_matrice_anagrafica(integer, text, text)
  OWNER TO postgres;



  
  -- Function: public.upsert_dati_acque_reflue(integer, text, integer, boolean, integer, text, integer, text, text, text, text)

-- DROP FUNCTION public.upsert_dati_acque_reflue(integer, text, integer, boolean, integer, text, integer, text, text, text, text);

CREATE OR REPLACE FUNCTION public.upsert_dati_acque_reflue(
    _riferimento_id integer,
    _riferimento_id_nome_tab text,
    _id_utente integer,
    _depurazione_reflui boolean,
    _id_stato_impianto integer,
    _gestore_impianto text,
    _id_processo_depurativo integer,
    _potenzialita_impianto_ae text,
    _ricettore_scarico text,
    _ricettore_finale text,
    _codice_ulia text)
  RETURNS text AS
$BODY$
DECLARE
	  id_opu_result integer;
	  
BEGIN

	
	update anag_acque_reflue set modifiedby = _id_utente, trashed_date = now() 
	where riferimento_id= _riferimento_id 
	and   riferimento_id_nome_tab = _riferimento_id_nome_tab
	and trashed_date is null;

	insert into anag_acque_reflue(riferimento_id , riferimento_id_nome_tab, depurazione_reflui, id_stato_impianto, gestore_impianto, id_processo_depurativo,
					potenzialita_impianto_ae, recettore_scarico, recettore_finale, codice_ulia, enteredby, modifiedby, entered
				      ) values
	                              (_riferimento_id, _riferimento_id_nome_tab,_depurazione_reflui, _id_stato_impianto, _gestore_impianto, 
	                               _id_processo_depurativo, _potenzialita_impianto_ae, _ricettore_scarico, _ricettore_finale, _codice_ulia, _id_utente,
	                               _id_utente, now()) returning id into id_opu_result;

	if id_opu_result > 0 then
		return 'OK, operazione effettuata con successo.';
	else
		return 'KO, operazione non effettuata.';
	end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.upsert_dati_acque_reflue(integer, text, integer, boolean, integer, text, integer, text, text, text, text)
  OWNER TO postgres;
  
  
CREATE TABLE public.anag_emissioni_in_atmosfera_camini
(
  id serial,
  id_emissioni_in_atmosfera_camini integer,
  note text,
  entered timestamp without time zone DEFAULT now(),
  enteredby integer,
  modified timestamp without time zone,
  modifiedby integer,
  trashed_date timestamp without time zone,
  riferimento_id integer,
  riferimento_id_nome_tab text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.anag_emissioni_in_atmosfera_camini
  OWNER TO postgres;

CREATE TABLE public.anag_storico_modifiche
(
  id serial,
  riferimento_id integer,
  riferimento_id_nome_tab text, 
  id_nuovo_stato integer,
  id_vecchio_stato integer,
  data_cambio_stato text,
  nota text,
  enteredby integer,
  entered timestamp default now(),
  trashed_date timestamp
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.anag_storico_modifiche
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.update_anag(
    _riferimento_id integer,
    _riferimento_id_nome_tab text,
    _id_nuovo_stato integer,
    _data_cambio_stato text,
    _id_utente integer,
    _nota text)
  RETURNS text AS
$BODY$
DECLARE
	  
	  id_storico_result integer;
	  id_stato_prec integer;
	  output boolean;
BEGIN


	IF _riferimento_id_nome_tab = 'opu_stabilimento' then
	        id_stato_prec := (select stato from opu_stabilimento where trashed_date is null and id = _riferimento_id);
		update opu_stabilimento set modified_by = _id_utente, modified= current_timestamp, stato = _id_nuovo_stato where id = _riferimento_id;
		insert into anag_storico_modifiche (riferimento_id,riferimento_id_nome_tab, id_nuovo_stato, id_vecchio_stato, data_cambio_stato, nota,
				          enteredby) values(_riferimento_id, _riferimento_id_nome_tab, _id_nuovo_stato, id_stato_prec, _data_cambio_stato, _nota, _id_utente) 
				          returning id into id_storico_result ;
		output := (select * from refresh_anagrafica(_riferimento_id, 'opu'));
	end if;
	
	if id_storico_result > 0 then
		return 'OK, operazione effettuata con successo.';
	else
		return 'KO, operazione non effettuata.';
	end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.update_anag(integer, text, integer, text, integer, text)
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.get_storico_cambio_stato_anag(
    IN _riferimento_id integer,
    IN _riferimento_id_nome_tab text)
  RETURNS  setof anag_storico_modifiche AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select * from anag_storico_modifiche where trashed_date is null order by entered desc;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_storico_cambio_stato_anag(integer, text)
  OWNER TO postgres;

--select * from get_storico_cambio_stato_anag(90,'opu_stabilimento')
update scheda_operatore_metadati set enabled = false where tipo_operatore = 24;insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','MATRICI','','m.description ','anag_dati_aggiuntivi o
join anag_dati_aggiuntivi_matrici rel on o.id = rel.id_anag_dati_aggiuntivi and rel.trashed_date is null
join lookup_matrice_controlli m on m.code = rel.id_matrice','o.riferimento_id = #stabid#
and o.riferimento_id_nome_tab = ''opu_stabilimento'' 
and o.trashed_date is null','G6','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DATA INIZIO ATTIVITA''','','distinct(case when data_inizio_attivita is not null then to_char(data_inizio_attivita, ''dd/mm/yyyy'')  else '''' end)','opu_operatori_denormalizzati_view','id_stabilimento =#stabid#','C7','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DATI AGGIUNTIVI','capitolo','','','','H','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','INFORMAZIONI DI SERVIZIO','capitolo','','','','Z','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DOMICILIO DIGITALE (PEC)','','distinct 

(case when domicilio_digitale is not null then domicilio_digitale else '''' end )','opu_operatori_denormalizzati_view','id_stabilimento =#stabid#','A6','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','NOTE','','distinct(note_operatore)','opu_operatori_denormalizzati_view','id_stabilimento =#stabid#','A7','screen');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DATI SEDE LEGALE','capitolo','','','','B','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DENOMINAZIONE STABILIMENTO','','denominazione_stabilimento','anag_dati_aggiuntivi','riferimento_id =  #stabid# and riferimento_id_nome_tab = ''opu_stabilimento'' and trashed_date is null','C1','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','NUMERO REGISTRAZIONE GISA','','distinct numero_registrazione ','opu_operatori_denormalizzati_view ','id_stabilimento =#stabid#','C3','screen');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','STATO IMPIANTO','','distinct(stato)','opu_operatori_denormalizzati_view ','id_stabilimento =#stabid#','C5','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','ULTIMO CAMBIO STATO','','concat(''<b>Data cambio stato</b>: '', to_char(data_cambio_stato::timestamp without time zone, ''dd/MM/yy''), ''; <b>Nota</b>: '', nota)','get_storico_cambio_stato_anag(#stabid#, ''opu_stabilimento'')','1=1 order by entered desc limit 1','C55','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','NOTE STABILIMENTO','','distinct(note_stabilimento)','opu_operatori_denormalizzati_view','id_stabilimento =#stabid#','C9','screen');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DATA FINE ATTIVITA''','','distinct(case when stab_id_carattere = 2 then to_char(data_fine_attivita, ''dd/mm/yyyy'')  else '''' end)','opu_operatori_denormalizzati_view','id_stabilimento =#stabid#','C8','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','GESTORE STABILIMENTO','capitolo','','','','D','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','RESPONSABILE STABILIMENTO','capitolo','','','','e','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DATI AUTORIZZATIVI','capitolo','','','','G','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','AUTORIZZAZIONE REGIONALE/STATALE','','l.description','anag_dati_aggiuntivi o join lookup_autorizzazione_tipo l on o.tipo_autorizzazione = l.code','o.riferimento_id =  #stabid# and riferimento_id_nome_tab = ''opu_stabilimento'' and o.trashed_date is null','G2','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DECRETO DIRIGENZIALE DATA','','to_char(data_decreto::timestamp without time zone, ''dd/mm/yyyy'')  ','anag_dati_aggiuntivi','riferimento_id =  #stabid# and riferimento_id_nome_tab = ''opu_stabilimento'' and trashed_date is null','G4','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DATA INSERIMENTO','','distinct to_char(stab_entered, ''dd/mm/yyyy'')','opu_operatori_denormalizzati_view','id_stabilimento =#stabid# ','Z1','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DATI IMPRESA','capitolo','','','','a','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','INDIRIZZO SEDE LEGALE','','distinct( case when impresa_id_tipo_impresa = 1 then '''' else concat_ws('' '',nazione_sede_legale, '' - INDIRIZZO: '', indirizzo_sede_legale,cap_sede_legale, comune_sede_legale, prov_sede_legale) end )','opu_operatori_denormalizzati_view ','id_stabilimento =#stabid#','B1','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','PARTITA IVA','','distinct partita_iva ','opu_operatori_denormalizzati_view ','id_stabilimento =#stabid#','A4','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DIPARTIMENTO','asl','distinct stab_asl','opu_operatori_denormalizzati_view','id_stabilimento =#stabid#','C2','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','LISTA LINEE PRODUTTIVE','capitolo','','','','F','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','CODICE FISCALE IMPRESA','','distinct codice_fiscale_impresa ','opu_operatori_denormalizzati_view ','id_stabilimento =#stabid#','A5','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DATI STABILIMENTO','capitolo','','','','C','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','TIPO ATTIVITA''','','distinct(stab_descrizione_attivita)','opu_operatori_denormalizzati_view ','id_stabilimento =#stabid#','C6','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','TIPO SOC./COOP.','','distinct(case when coalesce(trim(tipo_societa),'''') not ilike coalesce(trim(tipo_impresa),'''') then trim(tipo_societa) end) tipo_impresa','opu_operatori_denormalizzati_view','id_stabilimento =#stabid#','A2','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','BURC','','burc','anag_dati_aggiuntivi','riferimento_id =  #stabid# and riferimento_id_nome_tab = ''opu_stabilimento'' and trashed_date is null','G5','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','EMISSIONI IN ATMOSFERA CAMINI','','concat(
''<b>Codice camino</b>: '', e.codice_camino, 
'' <b>Fasi lavorativa</b>: '', e.fasi_lavorativa,
'' <b>Inquinanti</b>:  '', e.inquinanti, 
'' <b>Sistema abbattimento</b>: '', e.sistema_abbattimento)','anag_emissioni_in_atmosfera_camini a
join emissioni_in_atmosfera_camini e on e.id = a.id_emissioni_in_atmosfera_camini  and a.trashed_date is null','a.riferimento_id = #stabid#
and a.riferimento_id_nome_tab = ''opu_stabilimento'' 
and a.trashed_date is null and  has_matrice_anagrafica(#stabid#, ''opu_stabilimento'', ''Emissione in atmosfera convogliate'')','H1','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','ACQUE REFLUE','','concat(''<b>Depurazione reflui</b>: '', case when a.depurazione_reflui then ''SI'' else ''NO'' end, 
'' <b>Stato impianto</b>: '', s.description, 
'' <b>Gestore impianto</b>: '', a.gestore_impianto,
'' <b>Processo depurativo</b>: '', p.description,
'' <b>Potenzialita impianto AE</b>: '', a.potenzialita_impianto_ae,
'' <b>Recettore scarico</b>: '', a.recettore_scarico,
'' <b>Recettore finale</b>: '', a.recettore_finale,
'' <b>Codice Ulia</b>: '', a.codice_ulia)','anag_acque_reflue a
left join lookup_stato_impianto_acque_reflue s on s.code = a.id_stato_impianto
left join lookup_processo_depurativo p on p.code = a.id_processo_depurativo','a.riferimento_id = #stabid# 
and a.riferimento_id_nome_tab = ''opu_stabilimento'' 
and a.trashed_date is null 
and has_matrice_anagrafica(#stabid#, ''opu_stabilimento'', ''ACQUE REFLUE'')','H2','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','RAGIONE SOCIALE','','distinct ragione_sociale ','opu_operatori_denormalizzati_view ','id_stabilimento =#stabid#','A3','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','INDIRIZZO STABILIMENTO','','distinct(
case when stab_id_attivita=2 then '''' else
 case when indirizzo_stab is not null then indirizzo_stab || '','' ||  case when civico_sede_stab is not null then civico_sede_stab else '''' end else '''' end || '', '' || 
case when cap_stab is not null then cap_stab else '''' end || '' '' || case when comune_stab  is not null then comune_stab else '''' end || '', '' ||
case when prov_stab is not null then prov_stab else '''' end ||'', <br> <b>Coordinate Geografiche X:</b> '' || case when lat_stab is not null then lat_stab else 0  end
 ||'', <br><b>Coordinate Geografiche Y: </b>'' ||case when  long_stab is not null then long_stab else  0 end end )','opu_operatori_denormalizzati_view ','id_stabilimento =#stabid#','C4','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','NOMINATIVO E CODICE FISCALE','','distinct concat_ws('' '', nome_rapp_sede_legale, cognome_rapp_sede_legale, '' <b>CF:</b>'', cf_rapp_sede_legale)','opu_operatori_denormalizzati_view ','id_stabilimento =#stabid#','D1','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','NAZIONE E INDIRIZZO RESIDENZA','','nazione_residenza || ''<br>'' || indirizzo_rapp_sede_legale','opu_operatori_denormalizzati_view ','id_stabilimento =#stabid#','D2','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','UTENTE INSERIMENTO','','concat(c.namefirst, '' '', c.namelast)','opu_stabilimento s
join access_ a on s.entered_by = a.user_id
join contact_ c on c.contact_id = a.contact_id','s.id =  #stabid#','Z2','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','NOMINATIVO E CODICE FISCALE ','','distinct concat_ws('' '', nome_responsabile, cognome_responsabile, '' <b>CF:</b>'', cf_responsabile)','anag_dati_aggiuntivi','riferimento_id =  #stabid# and riferimento_id_nome_tab = ''opu_stabilimento'' and trashed_date is null','E1','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','ID AIA','','id_aia','anag_dati_aggiuntivi','riferimento_id =  #stabid# and riferimento_id_nome_tab = ''opu_stabilimento'' and trashed_date is null','G1','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','DECRETO DIRIGENZIALE N.','','num_decreto','anag_dati_aggiuntivi','riferimento_id =  #stabid# and riferimento_id_nome_tab = ''opu_stabilimento'' and trashed_date is null','G3','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','TIPO IMPRESA','','distinct case when length(lti.description) > 0 then lti.description when o.tipo_impresa = 1 then ''IMPRESA INDIVIDUALE'' else (select description from lookup_tipo_impresa_societa where code=o.tipo_impresa) end as tipo_impresa ','opu_operatore o left join lookup_tipo_impresa_societa lti on lti.code = o.tipo_societa left join opu_stabilimento os on os.id_operatore=o.id ','os.trashed_date is null and o.trashed_date is null and os.id = #stabid#','A1','');insert into scheda_operatore_metadati(tipo_operatore, label, attributo, sql_campo, sql_origine, sql_condizione, ordine, destinazione) values ('24','LINEE PRODUTTIVE','','string_agg(
case when linea_numero_registrazione <> '''' then ''<b>Num. Reg.:</b> '' || linea_numero_registrazione else ''NUMERO MANCANTE'' end || ''<br/><b>CATEGORIA IMPIANTO->CODICE IPPC->DESCRIZIONE</b><br>'' 
|| case when path_attivita_completo <> '''' then path_attivita_completo else '''' end || ''<br/>''
||
concat_ws('''',
case 
	when (pregresso_o_import = false or pregresso_o_import is null) then concat_ws('' '', ''<b>Data inizio</b>:'', 
	coalesce(to_char(data_inizio,''dd/mm/yyyy''),to_char(linea_modified, ''dd/mm/yyyy''))) 
else '''' end,
case when data_fine is not null then concat_ws('''',concat(''<b>Data fine</b>: '',to_char(data_fine, ''dd/mm/yyyy'')),concat(''<br/><b>Stato</b>: '',linea_stato_text))
else concat(''<br/><b>Stato</b>: '',linea_stato_text) end)
 ,''<br><hr>'')','opu_operatori_denormalizzati_view','id_stabilimento =  #stabid#','F1','');
 
 
ALTER TABLE public.opu_relazione_stabilimento_linee_produttive DROP CONSTRAINT stato_fkey;

ALTER TABLE public.opu_relazione_stabilimento_linee_produttive
  ADD CONSTRAINT stato_fkey FOREIGN KEY (stato)
      REFERENCES public.lookup_stato_lab (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

update opu_relazione_stabilimento_linee_produttive set stato = stato +99
update lookup_stato_lab set code = code +99 

 
CREATE TABLE public.controlli_ufficiali_emissioni_in_atmosfera_camini
(
  id serial,
  id_emissioni_in_atmosfera_camini integer,
  id_controllo integer,
  esito_conforme boolean DEFAULT true,
  note text,
  data_sopralluogo_2016 text,
  parametri_analizzati text,
  superamenti_limiti_normativi text,
  entered timestamp without time zone DEFAULT now(),
  enteredby integer,
  modified timestamp without time zone,
  modifiedby integer,
  trashed_date timestamp without time zone
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.controlli_ufficiali_emissioni_in_atmosfera_camini
  OWNER TO postgres;
  
  insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints)
 values(13,'server_documentale', true, false, false, false, 'VISUALIZZA BOX DOCUMENTALE',0,true, true, false);
insert into role_permission (id, role_id, permission_id, role_view, role_add, role_edit, role_delete) values((select max(id)+1 from role_permission),32,32,true, false, false, false);
insert into role_permission (id, role_id, permission_id, role_view, role_add, role_edit, role_delete) values((select max(id)+1 from role_permission),1,32,true, false, false, false);

insert into lookup_tipi_verifica(description, enabled) values ('Rumore', true);
update lookup_tipi_verifica set description  = 'Rifiuti 3.2.5' where code = 4

-- Function: public.insert_opu_noscia_rel_stabilimento_linea(integer, text, text, integer, timestamp without time zone, timestamp without time zone, integer)

-- DROP FUNCTION public.insert_opu_noscia_rel_stabilimento_linea(integer, text, text, integer, timestamp without time zone, timestamp without time zone, integer);

CREATE OR REPLACE FUNCTION public.insert_opu_noscia_rel_stabilimento_linea(
    _id_stabilimento integer,
    _codice_univoco_linea text,
    _cun text,
    _enteredby integer,
    _data_inizio timestamp without time zone,
    _data_fine timestamp without time zone,
    _tipo_carattere integer)
  RETURNS integer AS
$BODY$
DECLARE 
	id_rel integer;
	_descrizione_linea text;
	_id_linea_produttiva integer;
	_num_reg_stab text;
	_progressivo_linea integer;
	_num_reg_linea text;
        
BEGIN	
	select id_nuova_linea_attivita, descrizione into _id_linea_produttiva, _descrizione_linea 
		from ml8_linee_attivita_nuove_materializzata where trim(codice) ilike trim(_codice_univoco_linea);

	select id into id_rel from opu_relazione_stabilimento_linee_produttive 
		where id_linea_produttiva =_id_linea_produttiva and id_stabilimento = _id_stabilimento and enabled;


	select numero_registrazione into _num_reg_stab from opu_stabilimento where id = _id_stabilimento;
	_progressivo_linea := dbi_opu_get_progressivo_linea_per_stabilimento(_num_reg_stab);
	_num_reg_linea := concat(_num_reg_stab, lpad(_progressivo_linea::text,3,'0'));
	
	insert into opu_relazione_stabilimento_linee_produttive(id_linea_produttiva, id_stabilimento, stato, data_inizio, data_fine, enabled,
								descrizione_linea_attivita, numero_registrazione, codice_nazionale, entered, 
								enteredby, codice_univoco_ml, tipo_carattere)
	values(_id_linea_produttiva, _id_stabilimento, 99, _data_inizio, _data_fine, true, _descrizione_linea, 
	       _num_reg_linea, _cun, now() , _enteredby, _codice_univoco_linea, _tipo_carattere) returning id into id_rel;
	
	return id_rel;
	      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.insert_opu_noscia_rel_stabilimento_linea(integer, text, text, integer, timestamp without time zone, timestamp without time zone, integer)
  OWNER TO postgres;

  
CREATE OR REPLACE FUNCTION public.insert_opu_noscia_stabilimento(
    _id_operatore integer,
    _id_indirizzo integer,
    _enteredby integer,
    _codice_linea text)
  RETURNS integer AS
$BODY$
DECLARE 
	id_stabilimento integer;
	_comune integer;
	_id_asl integer;
	_numero_registrazione text;
	_codComune text;
	_codProvincia text;
	_tipo_attivita integer;
        
BEGIN	
	_tipo_attivita := 1;
	select 
		CASE 
			WHEN fisso THEN 1::integer
			ELSE 2::integer 
		END AS tatt into _tipo_attivita
	FROM master_list_flag_linee_attivita where codice_univoco ilike trim(_codice_linea);

	select comune into _comune from opu_indirizzo where id = _id_indirizzo;

	select codiceistatasl::integer into _id_asl from comuni1 where id = _comune; 
	select comuni1.cod_comune, lp.cod_provincia  into _codComune, _codProvincia 
		from comuni1 join lookup_province lp on lp.code =  comuni1.cod_provincia::int 
			where comuni1.id = _comune;
	_numero_registrazione:= (select genera_numero_registrazione from anagrafica.genera_numero_registrazione(_codComune, _codProvincia));

	insert into opu_stabilimento(entered, entered_by, id_operatore, id_asl, id_indirizzo, stato, numero_registrazione, categoria_rischio, tipo_attivita)
	values(now(), _enteredby, _id_operatore, _id_asl, _id_indirizzo, 99, _numero_registrazione, 3, _tipo_attivita) returning id into id_stabilimento;
		
	return id_stabilimento;
	      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.insert_opu_noscia_stabilimento(integer, integer, integer, text)
  OWNER TO postgres;

  -- Function: public.insert_gestione_anagrafica(hstore, hstore, integer, integer, text, integer)

-- DROP FUNCTION public.insert_gestione_anagrafica(hstore, hstore, integer, integer, text, integer);

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
	perform insert_anag_dati_aggiuntivi(_id_stabilimento,'opu_stabilimento',campi_fissi -> 'denominazione_stab',
	                                            campi_fissi -> 'nome_resp_stab', campi_fissi -> 'cognome_resp_stab', campi_fissi -> 'cf_resp_stab');
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


---------------------------- da lanciare in collaudo 04/07-----------------------
    
CREATE OR REPLACE FUNCTION public.get_storico_cambio_stato_anag(
    _riferimento_id integer,
    _riferimento_id_nome_tab text)
  RETURNS SETOF anag_storico_modifiche AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
	select * from anag_storico_modifiche 
	where riferimento_id = _riferimento_id and  
	trashed_date is null  and
	riferimento_id_nome_tab = _riferimento_id_nome_tab 
	order by entered desc;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_storico_cambio_stato_anag(integer, text)
  OWNER TO postgres;

  
 insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints)
values(12,'gestionepostit_asl', true, true, false, false, 'GESTIONE POST IT ASL',0,true, true, false) RETURNING PERMISSION_ID;
insert into role_permission (id, role_id, permission_id, role_view, role_add, role_edit, role_delete) values((select max(id)+1 from role_permission),32,24,true, false, false, false);
insert into role_permission (id, role_id, permission_id, role_view, role_add, role_edit, role_delete) values((select max(id)+1 from role_permission),1,24,true, false, false, false);

  -- Function: public.campione_dettaglio_globale(integer)

-- DROP FUNCTION public.campione_dettaglio_globale(integer);

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
	   
	id_tecnica := (select c.id_tecnica  from controlli_ufficiali c where id = _idcontrollo); 
	anno_controllo := (select date_part('year',data_inizio)::integer from controlli_ufficiali where id = _idcontrollo);
	rifid := (select riferimento_id from controlli_ufficiali where id = _idcontrollo);
	id_dipartimento := (select c.id_dipartimento from controlli_ufficiali c where id = _idcontrollo);
	rifnometab := (select c.riferimento_id_nome_tab from controlli_ufficiali c where id = _idcontrollo);
	--tipologia_operatore := (select distinct m.tipologia_operatore from ricerche_anagrafiche_old_materializzata m where m.riferimento_id = rifid and m.riferimento_id_nome_tab = rifnometab );
	--lineacontrollo := (select codice_linea from linee_attivita_controlli_ufficiali  where  id_controllo_ufficiale  = _idcontrollo and trashed_date is null);

	--path_linea := (select path_descrizione from ml8_linee_attivita_nuove_materializzata where codice = lineacontrollo and livello = 3 limit 1);
	
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
	--linee := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select lineacontrollo as codice, path_linea as nome, (select id_linea_attivita from linee_attivita_controlli_ufficiali  where trashed_date is null and id_controllo_ufficiale = _idcontrollo) as id 
	--									from controlli_ufficiali where id = _idcontrollo) t);
	--linee := (select json_object_agg('Linee', linee));


	--06/07
	linee := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select codice_linea as codice, ml.path_descrizione as nome, l.id_linea_attivita as id 
									from controlli_ufficiali c
									left join linee_attivita_controlli_ufficiali l on l.id_controllo_ufficiale=c.id and l.trashed_date is null			
									left join master_list_linea_attivita m on m.codice_univoco = l.codice_linea
									left join ml8_linee_attivita_nuove_materializzata ml on ml.id_attivita = m.id
									where c.id = _idcontrollo and c.trashed_date is null) t);
	raise info 'json linee ricostruito%', linee;


	nucleo := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select distinct d.nominativo as nominativo, c.id_componente as id, d.qualifica as qualifica, c.nome_struttura as struttura,
										c.responsabile, c.referente
										from cu_nucleo c
										join public.dpat_get_nominativi(-1,anno_controllo,null,null,null,c.id_struttura,null,-1) d on d.id_anagrafica_nominativo = c.id_componente
										left join access_ ac on ac.user_id = c.id_componente -- è giusto?
										where id_controllo_ufficiale = _idcontrollo) t);

	--nucleo := (select json_object_agg('Nucleo', nucleo));
	raise info 'json nucleo ricostruito %', nucleo;


										
	tipiverifica := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id 
										from controlli_ufficiali_tipi_verifica c
										join lookup_tipi_verifica l on l.code = c.id_tipo_verifica
										where c.id_controllo = _idcontrollo) t);
	--tipiverifica := (select json_object_agg('TipiVerifica', tipiverifica));
	raise info 'json tipi verifica %', tipiverifica;
	
	percontodi := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select o.descrizione_lunga as nome, o.id as id 
										from controlli_per_conto_di c
										join oia_nodo o on o.id = c.id_percontodi
										where c.id_controllo = _idcontrollo) t);
	raise info 'json per conto di %', percontodi;

	emissioniatmosfera := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select e.fasi_lavorativa as "fasiLavorativa", c.note, 
											c.parametri_analizzati as "parametriAnalizzati", 
											e.codice_camino as "codiceCamino", e.id, 
											c.data_sopralluogo_2016 as "dataSopralluogo2016", 
											e.sistema_abbattimento as "sistemaAbbattimento", 
											e.inquinanti, c.esito_conforme as "esitoConforme",
											c.superamenti_limiti_normativi as "superamentiLimitiNormativi" 
											from  
											controlli_ufficiali_emissioni_in_atmosfera_camini c
											join emissioni_in_atmosfera_camini e on e.id = c.id_emissioni_in_atmosfera_camini 
											join controlli_ufficiali cu on cu.id = c.id_controllo
											where cu.trashed_date is null and c.trashed_date is null
											and c.id_controllo = _idcontrollo) t);
												
	raise info 'json emissioni atmosfera %', emissioniatmosfera;

										
	fascicolo := (select json_object_agg(nome,descrizione) from (select 'numero' as nome,  numero as descrizione from fascicoli  where id in (select id_fascicolo from controlli_ufficiali where id = _idcontrollo and trashed_date is null) 
								union select 'id' as nome, id_fascicolo::text as descrizione from controlli_ufficiali where id = _idcontrollo) e); 
								
	raise info 'json fascicolo %', fascicolo;

	matrici := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select l.description as nome,  l.code as id, c.conclusa
										from controlli_ufficiali_matrici c
										join lookup_matrice_controlli l on l.code = c.id_matrice
										where c.id_controllo = _idcontrollo) t);

	raise info 'json matrici %', matrici;
		
	
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
		',"Matrici":', coalesce(matrici,array_to_json('{}'::int[])),
		',"CampiServizio":', campiServizio,
		--',"FasiLavorazione":', coalesce(fasilavorazione,to_json('[]'::text)),
		',"EmissioniAtmosferaCamini":', coalesce(emissioniatmosfera,array_to_json('{}'::int[])),
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
		',"Matrici":', coalesce(matrici,array_to_json('{}'::int[])),
		',"CampiServizio":', campiServizio,
		--',"FasiLavorazione":', coalesce(fasilavorazione,to_json('[]'::text)),
		',"EmissioniAtmosferaCamini":', coalesce(emissioniatmosfera,array_to_json('{}'::int[])),
		',"TipiVerifica":', tipiverifica)),'}'))::json);
		
	else
		-- do nothing per altre tecniche
		RAISE INFO 'la tecnica non prevede aggiunte di campi';
		finale := (select unaccent(concat('{',
		(select concat_ws(' ', '"Tecnica":', tecnicacu, ',"Dati":', daticu, ',"Anagrafica":', anagrafica, ',"Utente":',utente, ',"Dipartimento":', dipartimento, ',"Linee":', linee, ',"Nucleo":', nucleo, 
		',"PerContoDi":', percontodi,
		',"Fascicolo":', fascicolo,
		',"Matrici":', coalesce(matrici,array_to_json('{}'::int[])),
		',"CampiServizio":', campiServizio,
		--',"FasiLavorazione":', coalesce(fasilavorazione,to_json('[]'::text)),
		',"EmissioniAtmosferaCamini":', coalesce(emissioniatmosfera,array_to_json('{}'::int[])),
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
	
		 INSERT INTO cu_nucleo (id_controllo_ufficiale, id_componente, enabled, referente, responsabile, id_struttura, nome_struttura) values (_idcu, (i->>'id')::integer,true, (i->> 'referente')::boolean, (i->>'responsabile')::boolean, 
		 (i->>'idStruttura')::integer, (i->>'struttura')::text);
	  END LOOP;


    	 return 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cu_insert_nucleo(json, integer)
  OWNER TO postgres;

alter table cu_nucleo ADD column id_struttura integer;
alter table cu_nucleo ADD column nome_struttura text;

select * from permission where permission ilike '%dpat-sdc-stato%'
update role_permission set role_view  =false where permission_id=698



CREATE OR REPLACE FUNCTION public.cu_lista_globale(
    _riferimento_id integer,
    _riferimento_id_nome_tab text)
  RETURNS json AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select id as "idControllo", s.description as "stato", l.description as "tecnica", data_inizio as "dataInizio", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from controlli_ufficiali c 
										join lookup_stato_cu s on s.code = c.stato
										join lookup_tipo_controllo l on l.code=c.id_tecnica
										join access a on a.user_id = c.enteredby 
										join contact co on co.contact_id = a.contact_id
										where c.riferimento_id = _riferimento_id and c.riferimento_id_nome_tab = _riferimento_id_nome_tab and c.trashed_date is null
										order by c.data_inizio desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cu_lista_globale(integer, text)
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.fascicoli_lista_globale(
    _riferimento_id integer,
    _riferimento_id_nome_tab text)
  RETURNS json AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select f.id as "idFascicolo", f.numero as "numero", f.data_inizio as "dataInizio", f.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
										from fascicoli f 
										join access a on a.user_id = f.enteredby 
										join contact co on co.contact_id = a.contact_id
										where f.riferimento_id = _riferimento_id and f.riferimento_id_nome_tab = _riferimento_id_nome_tab and f.trashed_date is null
										order by f.data_inizio desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicoli_lista_globale(integer, text)
  OWNER TO postgres;

--------------------------------- 13/07/2022 -----------------da lanciare in collaudo

 alter table fascicoli add column data_chiusura timestamp without time zone;
  
  alter table fascicoli add column stato integer default 1;
  CREATE TABLE public.lookup_stato_fascicolo
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
ALTER TABLE public.lookup_stato_fascicolo
  OWNER TO postgres;

insert into lookup_stato_fascicolo ( select * from lookup_stato_cu  )


CREATE OR REPLACE FUNCTION public.fascicoli_lista_globale(
    _riferimento_id integer,
    _riferimento_id_nome_tab text)
  RETURNS json AS
$BODY$
DECLARE
	output json;
BEGIN

	 output := (SELECT array_to_json(array_agg(row_to_json(t))) FROM (select f.id as "idFascicolo", f.numero as "numero", f.data_inizio as "dataInizio", f.entered as "dataInserimento", concat_ws(' ', co.namefirst, 
	                                                                  co.namelast)::text as "utenteInserimento", ls.description as "statoFascicolo", f.data_chiusura as "dataChiusura" 
										from fascicoli f 
										join lookup_stato_fascicolo ls on ls.code = f.stato
										join access a on a.user_id = f.enteredby 
										join contact co on co.contact_id = a.contact_id
										where f.riferimento_id = _riferimento_id and f.riferimento_id_nome_tab = _riferimento_id_nome_tab and f.trashed_date is null
										order by f.data_inizio desc) t);
	return output;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicoli_lista_globale(integer, text)
  OWNER TO postgres;
  
  
 CREATE OR REPLACE FUNCTION public.non_conformita_dettaglio_globale(_idnc integer)
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
	id_linea_nc integer;
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
	id_linea_nc = (select n.id_linea from non_conformita n where n.id = _idnc);
	--codicelinea := (select l.codice_linea from linee_attivita_controlli_ufficiali l where l.id_controllo_ufficiale  = id_controllo and l.trashed_date is null and id_linea_attivita = );

	linea := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, path_descrizione::text as descrizione from ml8_linee_attivita_nuove_materializzata  
								where codice =
								(select codice_linea from linee_attivita_controlli_ufficiali where id_linea_attivita =id_linea_nc and id_controllo_ufficiale = id_controllo)
								union
								select 'id' as nome, id_linea::text as descrizione 
								from non_conformita nc
								where trashed_date is null and nc.id = _idnc) a);	
									             

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
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.non_conformita_dettaglio_globale(integer)
  OWNER TO postgres;

  -- Function: public.campione_insert_globale(json)

-- DROP FUNCTION public.campione_insert_globale(json);

CREATE OR REPLACE FUNCTION public.campione_insert_globale(_json_dati json)
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
	update campioni set id_laboratorio= (laboratorio->>'id')::int, id_motivazione = (motivazione ->> 'id')::integer, num_verbale=lpad(id::text, 6, '0'),
	id_controllo = (daticu ->> 'idControllo')::integer  where id = idcampione;
	
    	 return idcampione;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_insert_globale(json)
  OWNER TO postgres;

-- Function: public.campione_dettaglio_globale(integer)

-- DROP FUNCTION public.campione_dettaglio_globale(integer);

CREATE OR REPLACE FUNCTION public.campione_dettaglio_globale(_idcampione integer)
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

	numeroverbale := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, num_verbale as descrizione from campioni where id = _idcampione
							               union select 'id' as nome,  1::text) a);				             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from campioni where id = _idcampione) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from campioni where id = _idcampione
							               union select 'dataPrelievo' as nome, (data_prelievo)::text  from campioni where id = _idcampione) a);	

	daticu := (select json_object_agg(nome,descrizione) from (select 'idControllo' as nome, id_controllo::text as descrizione from campioni where id = _idcampione
							               union select 'dipartimento' as nome, l.description::text  
							                     from controlli_ufficiali cu 
							                     join campioni c on c.id_controllo = cu.id
							                     join lookup_site_id l on l.code = cu.id_dipartimento
							               union select distinct 'ragioneSociale' as nome, r.ragione_sociale as descrizione
							                     from controlli_ufficiali cu 
							                     join campioni c on c.id_controllo = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							                     where c.id = _idcampione
									union select distinct 'riferimentoId' as nome, r.riferimento_id::text as descrizione
							                     from controlli_ufficiali cu 
							                     join campioni c on c.id_controllo = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							                     where c.id = _idcampione    
							          ) a);	     
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
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_dettaglio_globale(integer)
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.fascicolo_close(
    _id_fascicolo integer,
    _data_chiusura text, 
    _anno_protocollo integer,
    _numero_protocollo integer,
    _id_utente integer)
  RETURNS text AS
$BODY$
DECLARE
	id_fascicolo_protocollo integer;
BEGIN
	
	update fascicoli set modifiedby = _id_utente, modified= current_timestamp, stato=2, data_chiusura = to_timestamp(_data_chiusura,'YYYY-MM-DD HH:MI:SS') where id = _id_fascicolo;
	insert into fascicoli_protocolli (id_fascicolo, anno_protocollo, numero_protocollo, enteredby, entered) values (_id_fascicolo, _anno_protocollo, _numero_protocollo, _id_utente, now()) returning id into id_fascicolo_protocollo;

	if(id_fascicolo_protocollo > 0) then
		return 'OK, operazione effettuata con successo.';
	else 
		return 'KO, operazione fallita.';
	end if;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
CREATE OR REPLACE FUNCTION public.fascicolo_dettaglio_globale(_idfascicolo integer)
  RETURNS json AS
$BODY$	
DECLARE
	
	campiservizio json;
	anagrafica json;
	fascicolo json;
	dati json;
	utente json;
	datifascicolo json;
	finale json;
	statofascicolo json;
	
	rifid integer;
	rifnometab text;
BEGIN

	rifid := (select riferimento_id from fascicoli  where id = _idfascicolo);
	rifnometab := (select c.riferimento_id_nome_tab from fascicoli c where id = _idfascicolo);
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from fascicoli c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where id = _idfascicolo 
								  union select 'dataInserimento' as nome, entered::text as descrizione from fascicoli where id = _idfascicolo
								  union select 'idFascicolo' as nome, id::text as descrizione from fascicoli where id = _idfascicolo
								  ) b);

	anagrafica:= (select json_object_agg(nome,descrizione) from (select 'partitaIva' as nome, trim(partita_iva) as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab
								  union select 'riferimentoId' as nome,  rifid::text
								  union select 'riferimentoIdNomeTab' as nome,  rifnometab::text 
								  union select 'ragioneSociale' as nome, ragione_sociale as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab) c);

	datifascicolo := (select json_object_agg(nome,descrizione) from (select 'numero' as nome, numero as descrizione from fascicoli  where id = _idfascicolo
								  union select 'dataInizio' as nome,  data_inizio::text from fascicoli where id = _idfascicolo 
								  ) b);
								  
	statofascicolo := (select json_object_agg(nome,descrizione) from (select 'stato' as nome, ls.description as descrizione from fascicoli f join lookup_stato_fascicolo ls on ls.code=f.stato where id = _idfascicolo
								  union select 'dataChiusura' as nome,  data_chiusura::text from fascicoli where id = _idfascicolo 
								  ) b);
						

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, enteredby as descrizione from fascicoli where id = _idfascicolo) d); 

	finale := (select unaccent(concat('{',
	(select concat_ws(' ','"Dati":', datifascicolo, ',
	"Anagrafica":', anagrafica, ',
	"Utente":',utente, ',
	"Stato":', statofascicolo, ',
	"CampiServizio":', campiServizio)),'}'))::json);
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.fascicolo_dettaglio_globale(integer)
  OWNER TO postgres;

  -- Function: public.campione_dettaglio_globale(integer)

-- DROP FUNCTION public.campione_dettaglio_globale(integer);

CREATE OR REPLACE FUNCTION public.campione_dettaglio_globale(_idcampione integer)
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

	numeroverbale := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, num_verbale as descrizione from campioni where id = _idcampione
							               union select 'id' as nome,  1::text) a);				             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from campioni where id = _idcampione) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from campioni where id = _idcampione
							               union select 'dataPrelievo' as nome, (data_prelievo)::text  from campioni where id = _idcampione) a);	

	daticu := (select json_object_agg(nome,descrizione) from (select 'idControllo' as nome, id_controllo::text as descrizione from campioni where id = _idcampione
							               union select 'dipartimento' as nome, l.description::text  
							                     from controlli_ufficiali cu 
							                     join campioni c on c.id_controllo = cu.id
							                     join lookup_site_id l on l.code = cu.id_dipartimento
							                     where c.id = _idcampione
							               union select distinct 'ragioneSociale' as nome, r.ragione_sociale as descrizione
							                     from controlli_ufficiali cu 
							                     join campioni c on c.id_controllo = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							                     where c.id = _idcampione
									union select distinct 'riferimentoId' as nome, r.riferimento_id::text as descrizione
							                     from controlli_ufficiali cu 
							                     join campioni c on c.id_controllo = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							                     where c.id = _idcampione    
							          ) a);	     
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
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.campione_dettaglio_globale(integer)
  OWNER TO postgres;

  CREATE OR REPLACE FUNCTION public.non_conformita_dettaglio_globale(_idnc integer)
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
	id_linea_nc integer;
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
	id_linea_nc = (select n.id_linea from non_conformita n where n.id = _idnc);
	--codicelinea := (select l.codice_linea from linee_attivita_controlli_ufficiali l where l.id_controllo_ufficiale  = id_controllo and l.trashed_date is null and id_linea_attivita = );

	linea := (select json_object_agg(nome,descrizione) from (select 'nome' as nome, path_descrizione::text as descrizione from ml8_linee_attivita_nuove_materializzata  
								where codice =
								(select codice_linea from linee_attivita_controlli_ufficiali where id_linea_attivita =id_linea_nc and id_controllo_ufficiale = id_controllo)
								union
								select 'id' as nome, id_linea::text as descrizione 
								from non_conformita nc
								where trashed_date is null and nc.id = _idnc) a);	
									             

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, (enteredby)::text as descrizione from non_conformita  where id = _idnc) a);				             

	dati := (select json_object_agg(nome,descrizione) from (select 'note' as nome, note as descrizione from non_conformita where id = _idnc) a);	

	daticu := (select json_object_agg(nome,descrizione) from (select 'idControllo' as nome, n.id_controllo::text as descrizione from non_conformita n where n.id = _idnc
							               union select 'dipartimento' as nome, l.description::text  
							                     from controlli_ufficiali cu 
							                     join non_conformita c on c.id_controllo = cu.id
							                     join lookup_site_id l on l.code = cu.id_dipartimento
							                     where c.id = _idnc
							               union select 'ragioneSociale' as nome, r.ragione_sociale as descrizione
							                     from controlli_ufficiali cu 
							                     join non_conformita c on c.id_controllo = cu.id
							                     join ricerche_anagrafiche_old_materializzata r on r.riferimento_id = cu.riferimento_id and r.riferimento_id_nome_tab = cu.riferimento_id_nome_tab
							                     where c.id = _idnc) a);	     

										
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
		',"TipoVerifica":', motivazione
		)),'}'))::json);
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.non_conformita_dettaglio_globale(integer)
  OWNER TO postgres;
  
  -------------------------------21/07
  insert into permission (category_id,permission,permission_view,permission_add,permission_edit,permission_delete,description , level,enabled,active)
values (12,'myhomepage-profile',true,false,false,false,'CAMBIO UTENTE',0,true,true) returning permission_id;
INSERT INTO ROLE_PERMISSION(id, role_id, permission_id, role_view, role_add, role_Edit, role_delete) values ((select max(id)+1 from role_permission),1,35,true, false, false, false);
INSERT INTO ROLE_PERMISSION(id, role_id, permission_id, role_view, role_add, role_Edit, role_delete) values ((select max(id)+1 from role_permission),32,35,true, false, false, false);


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
        and (strutt_complessa.id_asl = _id_dipartimento or _id_dipartimento = -1) 
        and strutt_complessa.id_strumento_calcolo in (select dpat_strumento_calcolo.id 
			                          from dpat_strumento_calcolo 
			                          where (dpat_strumento_calcolo.id_asl = _id_dipartimento or _id_dipartimento = -1) and 
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
  
----------------------------> import aia 26/07

CREATE TABLE public.log_import_aia
(
  id serial,
  id_import_aia integer,
  riferimento_id integer,
  riferimento_id_nome_tab text, 
  dbi text,
  output integer,
  entered timestamp without time zone DEFAULT now(),
  modified timestamp without time zone,
  note_hd text,
  error text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.log_import_aia
  OWNER TO postgres;


CREATE TABLE public.import_aia
(
  id_aia text,
  ragione_sociale text,
  codice_fiscale text,
  comune text,
  pr text,
  indirizzo text,
  coordinate_geografiche_x text,
  coordinate_geografiche_y text,
  denominazione_categoria_impianto text,
  codice_ipcc_principale text,
  codice_ipcc_secondaria text,
  descrizione_att_principale text,
  descrizione_att_secondaria text,
  autorizzazione text,
  note text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.import_aia
  OWNER TO postgres;

alter table import_aia add column id serial primary key;
--update import_aia set descrizione_att_principale  = replace (descrizione_att_principale, 'Ãˆ', 'E''');
--update import_aia set descrizione_att_principale = replace (descrizione_att_principale, 'Ã ', 'a''');
--update import_aia set descrizione_att_principale = replace (descrizione_att_principale, 'Ã¨', 'e''');
--update import_aia set descrizione_att_principale = replace (descrizione_att_principale, 'Ã¬', 'i''');
--update import_aia set descrizione_att_principale = replace (descrizione_att_principale, 'Ã²', 'u''');
--update import_aia set descrizione_att_principale = replace (descrizione_att_principale, 'Ã¹', 'u''');
--update import_aia set descrizione_att_principale = replace (descrizione_att_principale, 'à', 'a''');
--update import_aia set descrizione_att_principale = replace (descrizione_att_principale, 'è', 'e''');
--update import_aia set descrizione_att_principale = replace (descrizione_att_principale, 'ì ', 'i''');

--update import_aia set descrizione_att_secondaria   = replace (descrizione_att_secondaria, 'Ãˆ', 'E''');
--update import_aia set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'Ã ', 'a''');
--update import_aia set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'Ã¨', 'e''');
--update import_aia set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'Ã¬', 'i''');
--update import_aia set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'Ã²', 'u''');
--update import_aia set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'Ã¹', 'u''');
--update import_aia set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'à', 'a''');
--update import_aia set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'è', 'e''');
--update import_aia set descrizione_att_secondaria = replace (descrizione_att_secondaria, 'ì ', 'i''');

--update import_aia set denominazione_categoria_impianto    = replace (denominazione_categoria_impianto, 'Ãˆ', 'E''');
--update import_aia set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã ', 'a''');
--update import_aia set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã¨', 'e''');
--update import_aia set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã¬', 'i''');
--update import_aia set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã²', 'u''');
--update import_aia set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'Ã¹', 'u''');
--update import_aia set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'à', 'a''');
--update import_aia set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'è', 'e''');
--update import_aia set denominazione_categoria_impianto = replace (denominazione_categoria_impianto, 'ì ', 'i''');

--update import_aia set ragione_sociale = '(EX MP SRL) FIB. SUD. SRL' where id=12;
--update import_aia set ragione_sociale = '(EX MP SRL) FIB. SUD. SRL' where id=3;
--update import_aia set ragione_sociale = 'HARDMETALS SRL ORA NASHIRA HARD METALS SRL UNIPERSONALE' where id=32;
--update import_aia set ragione_sociale = 'CAPUA BIO SERVICE SPA EX DSM SPA' where id=55;
--update import_aia set indirizzo = 'Loc. Pantano Via Pagliarone n.29' where id=78;
--update import_aia set ragione_sociale = 'C.E.A.  CONSORZIO  ENERGIE  ALTERNATIVE ' where id=121;
--update import_aia set ragione_sociale = 'MILLESTAMPE PACKAGING SRL (EX MAURO BENEDETTI SPA, EX CARTIERE DEL MEDITERRANEO)' where id=197;
--update import_aia set indirizzo = 'S.S. Sannitica 87 KM 20' where id=50;
--update import_aia set codice_fiscale = '02749300964' where id=12;
--update import_aia set codice_fiscale = '07628910965', ragione_sociale='BI-QUEM (EX CHEMIPLASTICA SPECIALTIES SPA - EX CHIMECO)' where id=163;

-- Function: public.import_from_aia(integer)

-- DROP FUNCTION public.import_from_aia(integer);

-- Function: public.import_from_aia(integer)

-- DROP FUNCTION public.import_from_aia(integer);

-- Function: public.import_from_aia(integer)

-- DROP FUNCTION public.import_from_aia(integer);

CREATE OR REPLACE FUNCTION public.import_from_aia(_id_import_aia integer)
  RETURNS integer AS
$BODY$	
declare
	result integer;
	query text;
	idLog integer;

        soggetto_indirizzo_comune text;
	soggetto_indirizzo_nazione text;
	lineaattivita_1_data_inizio_attivita  text;
	toponimo_soggfis  text;
	latitudine_stab  text;
	cap_soggfis  text;
	codice_fiscale  text;
	latitudine_leg  text;
	toponimo_sede_legale  text;
	via_soggfis  text;
	autorizzazione_nota  text;
	data_nascita_rapp_leg  text;
	partita_iva  text;
	lineaattivita_1_data_fine_attivita  text;
	autorizzazione_id_aia  text;
	comune_nascita_rapp_leg  text;
	comune_estero_sede_legale  text;
	civico_stab  text;
	autorizzazione_numero  text;
	cf_resp_stab  text;
	civico_sede_legale  text;
	nome_resp_stab  text;
	nome_rapp_leg  text;
	email_impresa  text;
	longitudine_stab  text;
	cod_provincia_soggfis  text;
	responsabile_codice_fiscale text;
	id_impresa_recuperata  text;
	email_rapp_leg  text;
	cod_comune_stab  text;
	lineaattivita_1_codice_univoco_ml  text;	
	cap_leg  text;
	longitudine_leg  text;
	autorizzazione_data  text;
	lineaattivita_1_tipo_carattere_attivita  text;
	nazione_nascita_rapp_leg  text;
	sesso_rapp_leg  text;
	id_rapp_legale_recuperato  text;
	cognome_resp_stab  text;
	toponimo_stab  text;
	autorizzazione_tipo  text;
	ragione_sociale  text;
	cognome_rapp_leg  text;
	civico_soggfis  text;
	denominazione_stab  text;
	id_stabilimento  text;
	autorizzazione_burc  text;
	telefono_rapp_leg  text;
	comune_residenza_estero_soggfis  text;
	nazione_sede_legale  text;
	via_sede_legale  text;
	cod_provincia_sede_legale  text;
	lineaattivita_1_num_riconoscimento  text;
	codice_fiscale_rappresentante  text;
	cap_stab  text;
	lineaattivita_1_tipo_attivita  text;
	cod_provincia_stab  text;
	tipo_impresa  text;
	cod_comune_sede_legale  text;
	via_stab text;

BEGIN

 result := -1;
 idLog := -1;
 query := '';
 
	select 
	-1, --t1.soggetto_indirizzo_comune , --ok
	'', --t1.soggetto_indirizzo_nazione , --ok
	NULL, --t1.linea_1_data_inizio , --ok
	-1, --t1.toponimo_soggfis , --ok
	t1.coordinate_geografiche_y , --ok
	'', --t1.cap_soggfis ,--ok
	'', --t1.codice_fiscale ,--ok
	t1.coordinate_geografiche_y, --t1.latitudine_leg ,--ok
	-1, --t1.toponimo_sede_legale ,--ok
	'', --t1.via_soggfis ,--ok
	'', --t1.autorizzazione_nota ,--ok
	NULL, --t1.data_nascita_rapp_leg ,--ok
	t1.codice_fiscale ,--ok
	NULL, --t1.lineaattivita_1_data_fine_attivita ,--ok
	t1.id_aia ,--ok
	'', --t1.comune_nascita_rapp_leg ,--ok
	'', --t1.comune_estero_sede_legale ,--ok
	'', --t1.civico_stab ,--ok
	'', --t1.autorizzazione_numero ,--ok
	'', --t1.cf_resp_stab ,--ok
	'', --t1.civico_sede_legale ,--ok
	'', --t1.nome_resp_stab ,--ok
	'', --t1.nome_rapp_leg ,--ok
	'', --t1.email_impresa ,--ok
	t1.coordinate_geografiche_x ,--ok
	'', --t1.cod_provincia_soggfis ,--ok
	'', --t1.responsabile_codice_fiscale ,--ok
	-1, --t1.id_impresa_recuperata , --ok
	'', --t1.email_rapp_leg , --ok
	(select id from comuni1 where nome ilike t1.comune) , --ok
	(select codice from ml8_linee_attivita_nuove_materializzata where regexp_replace(macroarea, '\W+', '', 'g') ilike regexp_replace(t1.denominazione_categoria_impianto, '\W+', '', 'g') and regexp_replace(aggregazione, '\W+', '', 'g') ilike regexp_replace(t1.codice_ipcc_principale, '\W+', '', 'g') and regexp_replace(attivita, '\W+', '', 'g') ilike regexp_replace(t1.descrizione_att_principale, '\W+', '', 'g') and livello = 3) ,--ok
	(select case when cap <> '80100' then cap else '' end from comuni1 where nome ilike t1.comune) , --ok
	t1.coordinate_geografiche_x, --t1.longitudine_leg , --ok
	'', --t1.autorizzazione_data , --ok
	-1, --t1.lineaattivita_1_tipo_carattere_attivita , --ok
	-1, --t1.nazione_nascita_rapp_leg ,--ok
	'', --t1.sesso_rapp_leg ,--ok
	'', --t1.id_rapp_legale_recuperato ,--ok
	'', --t1.cognome_resp_stab , --ok
	-1, --t1.toponimo_stab , --ok
	(select code from lookup_autorizzazione_tipo where description ilike t1.autorizzazione), --t1.autorizzazione_tipo , --ok
	replace(replace(t1.ragione_sociale, '''', ''''''), '"', '''''') , --ok
	'', --t1.cognome_rapp_leg , --ok
	'', --t1.civico_soggfis , --ok
	'', --t1.denominazione_stab , --ok
	'', --t1.id_stabilimento , --ok
	'', --t1.autorizzazione_burc , --ok
	'', --t1.telefono_rapp_leg , --ok
	'', --t1.comune_residenza_estero_soggfis , --ok
	-1, --t1.nazione_sede_legale , --ok
	replace(replace(t1.indirizzo, '''', ''''''), '"', ''''''), --t1.via_sede_legale , --ok
	t1.pr, --t1.cod_provincia_sede_legale ,--ok
	'', --t1.lineaattivita_1_num_riconoscimento , --ok
	'', --t1.codice_fiscale_rappresentante , --ok
	(select case when cap <> '80100' then cap else '' end from comuni1 where nome ilike t1.comune) , --ok
	-1, --t1.lineaattivita_1_tipo_attivita , --ok
	t1.pr , --ok
	-1, --t1.tipo_impresa , --ok
	(select id from comuni1 where nome ilike t1.comune), --t1.cod_comune_sede_legale , --ok
	replace(replace(t1.indirizzo, '''', ''''''), '"', '''''')  --ok
	
 into 
        soggetto_indirizzo_comune,
        soggetto_indirizzo_nazione , 
	lineaattivita_1_data_inizio_attivita ,
	toponimo_soggfis ,
	latitudine_stab ,
	cap_soggfis ,
	codice_fiscale ,
	latitudine_leg ,
	toponimo_sede_legale ,
	via_soggfis ,
	autorizzazione_nota ,
	data_nascita_rapp_leg ,
	partita_iva ,
	lineaattivita_1_data_fine_attivita ,
	autorizzazione_id_aia ,
	comune_nascita_rapp_leg ,
	comune_estero_sede_legale ,
	civico_stab ,
	autorizzazione_numero ,
	cf_resp_stab ,
	civico_sede_legale ,
	nome_resp_stab ,
	nome_rapp_leg ,
	email_impresa ,
	longitudine_stab ,
	cod_provincia_soggfis,
	responsabile_codice_fiscale,
	id_impresa_recuperata ,
	email_rapp_leg ,
	cod_comune_stab ,
	lineaattivita_1_codice_univoco_ml ,	
	cap_leg ,
	longitudine_leg ,
	autorizzazione_data ,
	lineaattivita_1_tipo_carattere_attivita ,
	nazione_nascita_rapp_leg ,
	sesso_rapp_leg ,
	id_rapp_legale_recuperato ,
	cognome_resp_stab ,
	toponimo_stab ,
	autorizzazione_tipo ,
	ragione_sociale ,
	cognome_rapp_leg ,
	civico_soggfis ,
	denominazione_stab ,
	id_stabilimento ,
	autorizzazione_burc ,
	telefono_rapp_leg ,
	comune_residenza_estero_soggfis ,
	nazione_sede_legale ,
	via_sede_legale ,
	cod_provincia_sede_legale ,
	lineaattivita_1_num_riconoscimento ,
	codice_fiscale_rappresentante ,
	cap_stab ,
	lineaattivita_1_tipo_attivita ,
	cod_provincia_stab ,
	tipo_impresa ,
	cod_comune_sede_legale ,
	via_stab
 
	FROM import_aia t1 where t1.id = _id_import_aia;

raise info '[import_from_aia]';	

raise info '[import_from_aia] lineaattivita_1_codice_univoco_ml %', lineaattivita_1_codice_univoco_ml;	

query := concat(concat('select * from public.insert_gestione_anagrafica(
''"cod_comune_soggfis"=>', 
case when soggetto_indirizzo_comune is null then '-1' else concat('"',soggetto_indirizzo_comune,'"') end,'', ', ', 
'"nazione_soggfis"=>"106"', ', ', 
'"lineaattivita_1_data_inizio_attivita"=>', 
case when (lineaattivita_1_data_inizio_attivita) is null then 'null' else concat('"',lineaattivita_1_data_inizio_attivita,'"') end,'', ', ', 
'"toponimo_soggfis"=>',
case when (toponimo_soggfis) is null then '-1' else concat('"',toponimo_soggfis,'"') end,'', ', ', 
'"latitudine_stab"=>',
case when (latitudine_stab) is null then '0' else concat('"',latitudine_stab,'"') end,'', ', ', 
'"cap_soggfis"=>"',cap_soggfis,'"', ', ',
'"codice_fiscale"=>"',codice_fiscale,'"', ', ',
'"latitudine_leg"=>',
case when (latitudine_leg) is null then '0' else concat('"',latitudine_leg,'"') end,'', ', ', 
'"toponimo_sede_legale"=>',
case when (toponimo_sede_legale) is null then '-1' else concat('"',toponimo_sede_legale,'"') end,'', ', ', 
'"via_soggfis"=>"',via_soggfis,'"', ', ',
'"autorizzazione_nota"=>NULL', ', ', 
'"data_nascita_rapp_leg"=>', 
case when length(data_nascita_rapp_leg) = 0 then 'null' else concat('"',data_nascita_rapp_leg,'"') end,'', ', ', 
'"partita_iva"=>"',partita_iva,'"', ', ',
'"lineaattivita_1_data_fine_attivita"=>',
case when lineaattivita_1_data_fine_attivita is null then 'null' else concat('"',lineaattivita_1_data_fine_attivita,'"') end,'', ', ', 
'"autorizzazione_id_aia"=>"', autorizzazione_id_aia, '"', ', ',  
'"comune_nascita_rapp_leg"=>',
case when comune_nascita_rapp_leg is null then '-1' else concat('"',comune_nascita_rapp_leg,'"') end,'', ', ', 
'"comune_estero_sede_legale"=>"',comune_estero_sede_legale,'"', ', ',
'"civico_stab"=>"',civico_stab,'"', ', ',
'"autorizzazione_numero"=>NULL', ', ',
'"cf_resp_stab"=>"',cf_resp_stab,'"', ', ', 
'"civico_sede_legale"=>"',civico_sede_legale,'"', ', ',
'"nome_resp_stab"=>"',nome_resp_stab,'"', ', ', 
'"email_impresa"=>"',email_impresa,'"', ', ',
'"longitudine_stab"=>',
case when (longitudine_stab) is null then '0' else concat('"',longitudine_stab,'"') end,'', ', ', 
'"cod_provincia_soggfis"=>',
case when cod_provincia_soggfis is null then '-1' else concat('"',cod_provincia_soggfis,'"') end,'', ', ', 
'"email_rapp_leg"=>"',email_rapp_leg,'"', ', ', 
''), 
concat('',
'"cod_comune_stab"=>',
case when cod_comune_stab is null then '-1' else concat('"',cod_comune_stab,'"') end,'', ', ', 
'"lineaattivita_1_codice_univoco_ml"=>"', case when lineaattivita_1_codice_univoco_ml <> '' then lineaattivita_1_codice_univoco_ml else 'NON.MAPP.' end, '"', ', ',  
--'"lineaattivita_1_codice_univoco_ml"=>"NON.MAPP."', ', ',  
'"cap_leg"=>"',cap_leg,'"', ', ',
'"longitudine_leg"=>',
case when (longitudine_leg) is null then '0' else concat('"',longitudine_leg,'"') end,'', ', ', 
'"autorizzazione_data"=>NULL', ', ',  
'"lineaattivita_1_tipo_carattere_attivita"=>',
case when lineaattivita_1_tipo_carattere_attivita is null then '-1' else concat('"',lineaattivita_1_tipo_carattere_attivita,'"') end,'', ', ', 
'"nazione_nascita_rapp_leg"=>"106"', ', ',
'"sesso_rapp_leg"=>"',sesso_rapp_leg,'"', ', ', 
'"id_rapp_legale_recuperato"=>',
case when id_rapp_legale_recuperato is null then '-1' else concat('"',id_rapp_legale_recuperato,'"') end,'', ', ', 
'"cognome_resp_stab"=>"',cognome_resp_stab,'"', ', ',
'"toponimo_stab"=>',
case when toponimo_stab is null then '-1' else concat('"',toponimo_stab,'"') end,'', ', ', 
'"autorizzazione_tipo"=>"', autorizzazione_tipo, '"', ', ',  
'"ragione_sociale"=>"',replace(replace(ragione_sociale,'"','\"'),'''',''''''),'"', ', ',
'"cognome_rapp_leg"=>"',cognome_rapp_leg,'"', ', ',
'"civico_soggfis"=>"',civico_soggfis,'"', ', ', 
'"denominazione_stab"=>NULL', ', ', -------------------------------------> recuperaòa
'"id_stabilimento"=>',
case when id_stabilimento is null then '-1' else concat('"',id_stabilimento,'"') end,'', ', ', 
'"autorizzazione_burc"=>NULL', ', ', 
'"telefono_rapp_leg"=>NULL', ', ',
'"comune_residenza_estero_soggfis"=>"','"', ', ', 
'"nazione_sede_legale"=>"106"', ', ',
'"via_sede_legale"=>"',via_sede_legale,'"', ', ', 
'"cod_provincia_sede_legale"=>',
case when cod_provincia_sede_legale is null then '-1' else concat('"',cod_provincia_sede_legale,'"') end,'', ', ', 
'"lineaattivita_1_num_riconoscimento"=>"',lineaattivita_1_num_riconoscimento,'"', ', ',
'"codice_fiscale_rappresentante"=>"',codice_fiscale_rappresentante,'"', ', ',
'"cap_stab"=>"',cap_stab,'"', ', ',
'"lineaattivita_1_tipo_attivita"=>',
case when lineaattivita_1_tipo_attivita is null then '-1' else concat('"',lineaattivita_1_tipo_attivita,'"') end,'', ', ', 
''),
concat('',
'"cod_provincia_stab"=>',
case when cod_provincia_stab is null then '-1' else concat('"',cod_provincia_stab,'"') end,'', ', ', 
'"tipo_impresa"=>',
case when tipo_impresa is null then '-1' else concat('"',tipo_impresa,'"') end,'', ', ', 
'"cod_comune_sede_legale"=>',
case when cod_comune_sede_legale is null then '-1' else concat('"',cod_comune_sede_legale,'"') end,'', ', ', 
'"via_stab"=>"',via_stab,'"', '''::hstore', ', ',
'''''','::hstore ', ', ',
'964',', ',
'-1',', ',
'''''', ', ',
'-1','',
')')
);

raise info '[import_from_aia] %', query;

insert into log_import_aia(id_import_aia, dbi) values(_id_import_aia, query) returning id into idLog;

execute query into result;

update log_import_aia set riferimento_id = result, riferimento_id_nome_tab = 'opu_stabilimento', modified = now(), output = result where id = idLog;

IF result > 0 THEN

insert into anag_dati_autorizzativi(riferimento_id, riferimento_id_nome_tab, id_aia, tipo_autorizzazione) values(result, 'opu_stabilimento', autorizzazione_id_aia, autorizzazione_tipo::integer);

IF lineaattivita_1_codice_univoco_ml = 'NON.MAPP.' THEN
UPDATE opu_stabilimento set linee_pregresse=true where id = result;
END IF;

update opu_stabilimento set id_asl = (select c.codiceistatasl::integer from lookup_province p join comuni1 c on c.cod_provincia::integer = p.code where p.cod_provincia ilike cod_provincia_stab limit 1) where id = result;

END IF;

return result;

EXCEPTION WHEN OTHERS THEN
raise notice '% %', SQLERRM, SQLSTATE;
insert into log_import_aia(id_import_aia, dbi, output, error) values(_id_import_aia, query, result, concat('[',SQLSTATE, '] ', SQLERRM ));
return result;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.import_from_aia(integer)
  OWNER TO postgres;




  
CREATE OR REPLACE FUNCTION public.import_from_aia()
  RETURNS integer AS
$BODY$
DECLARE
   rec integer;
BEGIN
     FOR rec IN
        SELECT aia.id from import_aia aia 
     LOOP
         perform (select * from import_from_aia(rec));
     END LOOP;

     return 1;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION import_from_aia()
  OWNER TO postgres;

  
CREATE OR REPLACE FUNCTION public.get_nucleo_componenti(
    IN _anno integer DEFAULT NULL::integer,
    IN _id_qualifica integer DEFAULT (- 1),
    IN _id_dipartimento integer DEFAULT (- 1),
    IN _id_struttura text DEFAULT ''::text)
  RETURNS TABLE(id integer, nominativo text, id_struttura integer, nome_struttura text, id_qualifica integer, nome_qualifica text) AS
$BODY$
DECLARE
	lista_strutture text;
BEGIN
	lista_strutture := (select replace(replace(_id_struttura,'(',''''),')',''''));
	raise info 'lista: %', lista_strutture;
	raise info 'string to array input: %', string_to_array(lista_strutture,',');
	return query
		select d.id_anagrafica_nominativo, d.nominativo, d.id_struttura_semplice, concat_ws('->', (select description from lookup_site_id where enabled and code = d.id_asl),d.desc_strutt_complessa,d.desc_strutt_semplice), _id_qualifica, d.qualifica
		from public.dpat_get_nominativi(_id_dipartimento::integer, _anno::integer, null::text,null::integer,null::text,null,null, _id_qualifica) d
		--where 1=1 and (_id_struttura = '' or string_to_array(d.id_Struttura_semplice::text,',') <@ string_to_array('8167,8365'::text,',')); 
		where 1=1 and (_id_struttura = '' or string_to_array(d.id_Struttura_semplice::text,',') <@ string_to_array(lista_strutture,',')); 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_nucleo_componenti(integer, integer, integer, text)
  OWNER TO postgres;

delete from ml8_linee_attivita_nuove_materializzata where id_nuova_linea_attivita = 41885; 
delete from master_list_linea_attivita where codice_prodotto_specie ='L41885';


CREATE TABLE IF NOT EXISTS public.dpat_strumento_calcolo_storico_esportazioni
(
    id serial,
    data timestamp without time zone,
    estratto_da integer,
    id_asl integer,
    descrizione_struttura text COLLATE pg_catalog."default",
    id_struttura integer,
    note text COLLATE pg_catalog."default",
    anno text COLLATE pg_catalog."default",
    cod_documento text COLLATE pg_catalog."default",
    tipo text COLLATE pg_catalog."default",
    check_tutte_le_strutture boolean
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.dpat_strumento_calcolo_storico_esportazioni
    OWNER to postgres;