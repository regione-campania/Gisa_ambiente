-- Aggiornamento livelli aggiuntivi 
-- 27/01/2021
-- Aggiornamento livelli aggiuntivi 
-- 27/01/2021

delete from master_list_configuratore_livelli_aggiuntivi where id is null;
--select * from ml8_linee_attivita_nuove_materializzata  where id_nuova_linea_attivita  in (41634,41635,41636,41637,41638)
insert into master_list_configuratore_livelli_aggiuntivi(id, id_linea_attivita, codice_univoco, id_padre, nome, valore) values ((select max(id) + 1 from master_list_configuratore_livelli_aggiuntivi), 41634, 'MS.060.200.2', -1,'Attività specifica', 'Effettua anche vendita di Carni fresche');
insert into master_list_configuratore_livelli_aggiuntivi(id, id_linea_attivita, codice_univoco, id_padre, nome, valore) values ((select max(id) + 1 from master_list_configuratore_livelli_aggiuntivi), 41635, 'MS.060.200.3', -1,'Attività specifica', 'Effettua anche vendita di Carni fresche');
insert into master_list_configuratore_livelli_aggiuntivi(id, id_linea_attivita, codice_univoco, id_padre, nome, valore) values ((select max(id) + 1 from master_list_configuratore_livelli_aggiuntivi), 41636, 'MS.060.200.4', -1,'Attività specifica', 'Effettua anche vendita di Carni fresche');
insert into master_list_configuratore_livelli_aggiuntivi(id, id_linea_attivita, codice_univoco, id_padre, nome, valore) values ((select max(id) + 1 from master_list_configuratore_livelli_aggiuntivi), 41637, 'MS.060.200.5', -1,'Attività specifica', 'Effettua anche vendita di Carni fresche');
insert into master_list_configuratore_livelli_aggiuntivi(id, id_linea_attivita, codice_univoco, id_padre, nome, valore) values ((select max(id) + 1 from master_list_configuratore_livelli_aggiuntivi), 41638, 'MS.060.200.6', -1,'Attività specifica', 'Effettua anche vendita di Carni fresche');

insert into master_list_configuratore_livelli_aggiuntivi(id, id_linea_attivita, codice_univoco, id_padre, nome, valore) values ((select max(id) + 1 from master_list_configuratore_livelli_aggiuntivi), 41634, 'MS.060.200.2', -1,'Attività specifica', 'Effettua anche vendita di Prodotti della pesca');
insert into master_list_configuratore_livelli_aggiuntivi(id, id_linea_attivita, codice_univoco, id_padre, nome, valore) values ((select max(id) + 1 from master_list_configuratore_livelli_aggiuntivi), 41635, 'MS.060.200.3', -1,'Attività specifica', 'Effettua anche vendita di Prodotti della pesca');
insert into master_list_configuratore_livelli_aggiuntivi(id, id_linea_attivita, codice_univoco, id_padre, nome, valore) values ((select max(id) + 1 from master_list_configuratore_livelli_aggiuntivi), 41636, 'MS.060.200.4', -1,'Attività specifica', 'Effettua anche vendita di Prodotti della pesca');
insert into master_list_configuratore_livelli_aggiuntivi(id, id_linea_attivita, codice_univoco, id_padre, nome, valore) values ((select max(id) + 1 from master_list_configuratore_livelli_aggiuntivi), 41637, 'MS.060.200.5', -1,'Attività specifica', 'Effettua anche vendita di Prodotti della pesca');
insert into master_list_configuratore_livelli_aggiuntivi(id, id_linea_attivita, codice_univoco, id_padre, nome, valore) values ((select max(id) + 1 from master_list_configuratore_livelli_aggiuntivi), 41638, 'MS.060.200.6', -1,'Attività specifica', 'Effettua anche vendita di Prodotti della pesca');



-- Schema reportistica, rinominato digemon e aggiunte dbi

-- Function: digemon.dbi_get_all_stabilimenti_(timestamp without time zone, timestamp without time zone)

-- DROP FUNCTION digemon.dbi_get_all_stabilimenti_(timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION reportistica.dbi_get_all_stabilimenti_(
    IN data_1 timestamp without time zone,
    IN data_2 timestamp without time zone)
  RETURNS TABLE(riferimento_id integer, riferimento_id_nome_tab text, ragione_sociale text, asl_rif integer, asl text, codice_fiscale text, codice_fiscale_rappresentante text, partita_iva text, n_reg text, nominativo_rappresentante text, comune text, provincia_stab text, indirizzo text, cap_stab text, comune_leg text, provincia_leg text, indirizzo_leg text, cap_leg text, latitudine_stab double precision, longitudine_stab double precision, categoria_rischio integer, prossimo_controllo timestamp without time zone, id_controllo_ultima_categorizzazione integer, data_controllo_ultima_categorizzazione timestamp without time zone, tipo_categorizzazione text, data_inserimento timestamp without time zone, livello_rischio text) AS
$BODY$

with cte_ext as (

	with cte_int as	(
		 select t.assigned_date, t.ticketid as id_controllo,
			t.categoria_rischio, (select description from lookup_categoria_rischio where code = t.livello_rischio) as livello_rischio, t.data_prossimo_controllo,
			case 	when t.alt_id > 0 then t.alt_id
				when t.id_stabilimento > 0 then t.id_stabilimento
				when t.id_apiario > 0 then t.id_apiario
				when t.org_id > 0 then t.org_id end as riferimento_id ,
		      case 	when t.alt_id > 0 then (select return_nome_tabella from gestione_id_alternativo(t.alt_id,-1))
				when t.id_stabilimento > 0 then 'opu_stabilimento'
				when t.id_apiario > 0 then 'apicoltura_imprese'
				when t.org_id > 0 then 'organization' end as
			riferimento_nome_tab
		 from ticket t
		 where t.tipologia=3 and trashed_date is null and t.provvedimenti_prescrittivi=5 and t.closed is not null
		 group by ticketid , riferimento_id, riferimento_nome_tab
		 order by riferimento_id, riferimento_nome_tab, assigned_date desc
	)
	      select distinct on (riferimento_id, riferimento_nome_tab)
	        id_controllo,
	        riferimento_id,
	        riferimento_nome_tab,
	        data_prossimo_controllo,
	        assigned_date,
		categoria_rischio,
		livello_rischio,
		id_controllo as id_controllo_ultima_categorizzazione,
		assigned_date as data_controllo_ultima_categorizzazione,
		case when id_controllo is null then 'EX ANTE' ELSE 'CATEGORIZZATO DA CU' end as tipo_categorizzazione
		from cte_int
	) 
    select distinct -- aggiunta della distinct 
	v.riferimento_id ,
	v.riferimento_id_nome_tab ,
	v.ragione_sociale,
	v.asl_rif ,
	v.asl ,
	v.codice_fiscale::text,
	v.codice_fiscale_rappresentante ,
	v.partita_iva::text,
	v.n_reg,
	v.nominativo_rappresentante ,
	v.comune,
	v.provincia_stab,
	v.indirizzo,
	v.cap_stab,
	v.comune_leg,
	v.provincia_leg ,
	v.indirizzo_leg,
	v.cap_leg,
	v.latitudine_stab ,
	v.longitudine_stab ,
	case when l.id_controllo is null then coalesce(l.categoria_rischio,v.categoria_rischio) else l.categoria_rischio end as categoria_rischio, -- integrazione per gestione categoria di rischio EX ANTE
	l.data_prossimo_controllo as prossimo_controllo,
	l.id_controllo as id_controllo_ultima_categorizzazione,
	l.assigned_date as data_controllo_ultima_categorizzazione,
        case when l.id_controllo is null then 'EX ANTE' ELSE 'CATEGORIZZATO DA CU' end as tipo_categorizzazione,
        v.data_inserimento,
       l.livello_rischio

    from ricerche_anagrafiche_old_materializzata v 
        left join cte_ext l on l.riferimento_id  = v.riferimento_id and l.riferimento_nome_tab = v.riferimento_id_nome_tab
    where v.data_inserimento between data_1 and data_2 
 
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION reportistica.dbi_get_all_stabilimenti_(timestamp without time zone, timestamp without time zone)
  OWNER TO postgres;

  -- Function: digemon.dbi_get_all_linee(timestamp without time zone, timestamp without time zone)

-- DROP FUNCTION digemon.dbi_get_all_linee(timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION reportistica.dbi_get_all_linee(
    IN data_1 timestamp without time zone,
    IN data_2 timestamp without time zone)
  RETURNS TABLE(id_linea integer, riferimento_id integer, riferimento_id_nome_tab text, num_riconoscimento character varying, n_linea character varying, data_inizio_attivita timestamp without time zone, data_fine_attivita timestamp without time zone, macroarea text, aggregazione text, attivita text, path_attivita_completo text, norma text, id_norma integer, codice_macroarea text, codice_aggregazione text, codice_attivita text, stato text, id_stato integer, miscela boolean, tipo_attivita_descrizione character varying, tipo_attivita integer) AS
$BODY$
DECLARE
	r RECORD; 	
BEGIN
     FOR 
	id_linea,    
	riferimento_id,
	riferimento_id_nome_tab,
	num_riconoscimento,
	n_linea,
	data_inizio_attivita ,
	data_fine_attivita ,
	macroarea ,
	aggregazione ,
	attivita ,
	path_attivita_completo ,
	norma ,
	id_norma ,
	codice_macroarea ,
	codice_aggregazione ,
	codice_attivita ,
	stato,
	id_stato,
	miscela,
	tipo_attivita_descrizione,
	tipo_attivita
  in
	select
	v.id_linea,    
	v.riferimento_id,
	v.riferimento_id_nome_tab,
	v.num_riconoscimento,
	v.n_linea ,
	v.data_inizio_attivita ,
	v.data_fine_attivita ,
	v.macroarea ,
	v.aggregazione ,
	-- nuova richiesta 18/12 per visualizzare il campo attivita splittato sempre 
	case when split_part(v.attivita, '->', 3) = '' or length(split_part(v.attivita, '->', 3)) =0 then v.attivita
	else split_part(v.attivita, '->', 3)
	end as attivita,
--	v.attivita ,
	v.path_attivita_completo ,
	v.norma ,
	v.id_norma ,
	v.codice_macroarea ,
	v.codice_aggregazione ,
	v.codice_attivita ,
	v.stato,
	v.id_stato,
	v.miscela,
	v.tipo_attivita_descrizione,
	v.tipo_attivita
	from ricerche_anagrafiche_old_materializzata v where v.data_inserimento between data_1 and data_2
    LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100
  ROWS 1000;
ALTER FUNCTION reportistica.dbi_get_all_linee(timestamp without time zone, timestamp without time zone)
  OWNER TO postgres;



DROP FUNCTION reportistica.estrazione_controlli_ispezione_semplice(timestamp without time zone,timestamp without time zone,integer,boolean);
CREATE OR REPLACE FUNCTION reportistica.estrazione_controlli_ispezione_semplice(
    IN _asl integer DEFAULT NULL::integer,
    IN _data_1 timestamp without time zone DEFAULT '1900-01-01 00:00:00'::timestamp without time zone,
    IN _data_2 timestamp without time zone DEFAULT NULL::timestamp without time zone,
    IN _solo_chiusi boolean DEFAULT true)
  RETURNS TABLE(id_controllo integer, data_inserimento timestamp without time zone, data_inizio_controllo timestamp without time zone, 
  data_chiusura_controllo timestamp without time zone, data_fine_controllo timestamp without time zone, 
  id_stato_controllo integer, stato_controllo text, 
  id_asl integer, 
  asl character varying, riferimento_id integer, riferimento_nome_tab text, 
  congruo_supervisione text, supervisionato_in_data timestamp without time zone, 
  supervisionato_da integer, supervisione_note text, note text, id_tecnica_cu integer, targa_matricola text,
  struttura_complessa character varying, struttura_semplice character varying, per_conto_di_completo character varying, 
  id_unita_operativa integer, id_asl_struttura integer, ruolo_utente_nucleo text, cognome text, nome text, 
  id_componente_nucleo integer, id_asl_utente_nucleo integer, codice_linea text, 
  id_motivo_ispezione integer, descrizione_motivo character varying, id_piano integer, 
  descrizione_piano character varying, id_oggetto_del_controllo integer, oggetto_del_controllo text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
select distinct a.*, b.struttura_complessa, b.struttura_semplice, b.per_conto_di_completo, 
b.id_unita_operativa, b.id_asl_struttura, c.ruolo, c.cognome, c.nome, c.id_componente,c.id_asl as id_asl_utente_nucleo,
d.codice_linea, e.id_motivo_ispezione,e.descrizione_motivo, e.id_piano, e.descrizione_piano,
f.id_oggetto_del_controllo, f.oggetto_del_controllo
from reportistica.get_controlli_ispezioni_semplici(_asl, _data_1, _data_2, _solo_chiusi) a
left join 
(select * from reportistica.get_controlli_ispezioni_semplici_percontodi(_data_1,_data_2) ) b on a.id_controllo = b.id_controllo 
left join 
(select * from reportistica.get_controlli_nucleoispettivo_list(_data_1,_data_2,'{4}'::int[])) c on c.id_controllo = a.id_controllo
left join
(select * from reportistica.get_linee_attivita_controllo(_data_1,_data_2,4)) d on d.id_controllo = a.id_controllo
left join
(select * from reportistica.get_controlli_ispezioni_semplici_motivi(_data_1,_data_2)) e on e.id_controllo = a.id_controllo
left join
(select * from reportistica.get_controlli_ispezioni_semplici_oggetto_del_controllo(_data_1,_data_2)) f on f.id_controllo = a.id_controllo;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION reportistica.estrazione_controlli_ispezione_semplice( integer, timestamp without time zone, timestamp without time zone,boolean)
  OWNER TO postgres;
  


CREATE OR REPLACE FUNCTION reportistica.estrazione_controlli_ispezione_semplice_senza_oggetto(
    IN _asl integer DEFAULT NULL::integer,
    IN _data_1 timestamp without time zone DEFAULT '1900-01-01 00:00:00'::timestamp without time zone,
    IN _data_2 timestamp without time zone DEFAULT NULL::timestamp without time zone,
    IN _solo_chiusi boolean DEFAULT true)
  RETURNS TABLE(id_controllo integer, data_inserimento timestamp without time zone, data_inizio_controllo timestamp without time zone, 
  data_chiusura_controllo timestamp without time zone, data_fine_controllo timestamp without time zone, 
  id_stato_controllo integer, stato_controllo text, id_asl integer, asl character varying, 
  riferimento_id integer, riferimento_nome_tab text, congruo_supervisione text, 
  supervisionato_in_data timestamp without time zone, supervisionato_da integer, 
  supervisione_note text, note text, id_tecnica_cu integer, targa_matricola text, 
  struttura_complessa character varying, struttura_semplice character varying, 
  per_conto_di_completo character varying, id_unita_operativa integer, id_asl_struttura integer, 
  ruolo_utente_nucleo text, cognome text, nome text, id_componente_nucleo integer, id_asl_utente_nucleo integer, 
  codice_linea text, id_motivo_ispezione integer, descrizione_motivo character varying, id_piano integer, 
  descrizione_piano character varying) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
select distinct a.*, b.struttura_complessa, b.struttura_semplice, b.per_conto_di_completo, 
b.id_unita_operativa, b.id_asl_struttura, c.ruolo, c.cognome, c.nome, c.id_componente,c.id_asl as id_asl_utente_nucleo,
d.codice_linea, e.id_motivo_ispezione,e.descrizione_motivo, e.id_piano, e.descrizione_piano
from reportistica.get_controlli_ispezioni_semplici(_asl, _data_1, _data_2, _solo_chiusi) a
left join 
(select * from reportistica.get_controlli_ispezioni_semplici_percontodi(_data_1,_data_2) ) b on a.id_controllo = b.id_controllo 
left join 
(select * from reportistica.get_controlli_nucleoispettivo_list(_data_1,_data_2,'{4}'::int[])) c on c.id_controllo = a.id_controllo
left join
(select * from reportistica.get_linee_attivita_controllo(_data_1,_data_2,4)) d on d.id_controllo = a.id_controllo
left join
(select * from reportistica.get_controlli_ispezioni_semplici_motivi(_data_1,_data_2)) e on e.id_controllo = a.id_controllo;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

-- Function: reportistica.get_controlli_audit_motivi_2020(timestamp without time zone, timestamp without time zone)

-- DROP FUNCTION reportistica.get_controlli_audit_motivi_2020(timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION reportistica.get_controlli_audit_motivi_2020(
    IN _data_1 timestamp without time zone DEFAULT '1900-01-01 00:00:00'::timestamp without time zone,
    IN _data_2 timestamp without time zone DEFAULT NULL::timestamp without time zone)
  RETURNS TABLE(id_controllo integer, id_motivo_audit integer, id_piano integer, descrizione_motivo_padre character varying, descrizione_motivo_figlio text, codice_interno_piano_attivita text, alias_padre text, alias_indicatore text) AS
$BODY$
DECLARE
BEGIN
for
	id_controllo,
	id_motivo_audit,
	id_piano,
	descrizione_motivo_padre,
	descrizione_motivo_figlio,
	codice_interno_piano_attivita,
	alias_padre,
	alias_indicatore
in select
	t.ticketid as id_controllo,
	tc.tipoispezione as id_motivo_audit,
	tc.pianomonitoraggio as id_piano,
	coalesce(upper(padre_piano.descrizione),upper(padre_attivita.descrizione)) as descrizione_motivo_padre,
	coalesce(figlio_piano.descrizione,figlio_attivita.descrizione) as descrizione_motivo_figlio,
	case when padre_piano.codice_alias_attivita is not null then concat_ws('.',padre_piano.codice_alias_attivita,figlio_piano.codice_alias_indicatore)
	else concat_ws('.',padre_attivita.codice_alias_attivita,figlio_attivita.codice_alias_indicatore) 
	end as codice_interno_piano_attivita,
	coalesce((upper(padre_piano.tipo_attivita) || ' ' ||upper(padre_piano.alias_piano)), (upper(padre_attivita.tipo_attivita) || ' ' ||upper(padre_attivita.alias_attivita))) as alias_padre,
	coalesce(figlio_piano.alias_indicatore, figlio_attivita.alias_indicatore) as alias_indicatore
from ticket t
	left join tipocontrolloufficialeimprese tc on tc.idcontrollo = t.ticketid 
	left join dpat_indicatore_new figlio_piano on tc.pianomonitoraggio = figlio_piano.id
	left join dpat_piano_attivita_new padre_piano on padre_piano.id = figlio_piano.id_piano_attivita
	left join dpat_indicatore_new figlio_attivita on tc.tipoispezione = figlio_attivita.id
	left join dpat_piano_attivita_new padre_attivita on padre_attivita.id = figlio_attivita.id_piano_attivita	
where 
	t.provvedimenti_prescrittivi = 3 and t.tipologia = 3 and tc.enabled 
	and t.trashed_date is null  and (tc.tipoispezione > 0 or tc.pianomonitoraggio >0)
	and t.assigned_date between coalesce (_data_1,'1900-01-01') and coalesce (_data_2,now())
        and t.assigned_date >= '2020-01-01' --post flusso 190

   LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
  
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION reportistica.get_controlli_audit_motivi_2020(timestamp without time zone, timestamp without time zone)
  OWNER TO postgres;
-- Function: reportistica.get_controlli_audit_percontodi_2020(timestamp without time zone, timestamp without time zone)

-- DROP FUNCTION reportistica.get_controlli_audit_percontodi_2020(timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION reportistica.get_controlli_audit_percontodi_2020(
    IN _data_1 timestamp without time zone DEFAULT '1900-01-01 00:00:00'::timestamp without time zone,
    IN _data_2 timestamp without time zone DEFAULT NULL::timestamp without time zone)
  RETURNS TABLE(id_controllo integer, struttura_complessa text, struttura_semplice text, per_conto_di_completo text, id_unita_operativa integer, id_asl_struttura integer, codice_interno_univoco_uo integer, area_appartenenza_uo character varying, id_motivo_audit integer, id_piano_audit integer) AS
$BODY$
DECLARE
BEGIN

for 
	id_controllo,
	struttura_complessa,
	struttura_semplice,
	per_conto_di_completo,
	id_unita_operativa,
	id_asl_struttura,
	codice_interno_univoco_uo,
	area_appartenenza_uo,
	id_motivo_audit,
	id_piano_audit
in select 

      distinct t.ticketid as id_controllo,
     	n.descrizione_padre as struttura_complessa,
	n.descrizione as struttura_semplice,
	n.pathdes as per_conto_di_completo,
	tc.id_unita_operativa as id_unita_operativa,
	n.id_asl as id_asl_struttura,
	n.codice_interno_fk as codice_interno_univoco_uo,
	n.descrizione_area_struttura as area_appartenenza_uo,
	tc.tipoispezione as id_motivo_audit,
	tc.pianomonitoraggio as id_piano_audit
from ticket t
	left join tipocontrolloufficialeimprese tc on tc.idcontrollo = t.ticketid 
        left join dpat_strutture_asl n on n.id = tc.id_unita_operativa  
where 
	tipologia = 3 and provvedimenti_prescrittivi = 3
	and t.trashed_date is null and tc.enabled and (tc.tipoispezione > 0 or tc.pianomonitoraggio > 0) and tc.id_unita_operativa > 0 
	and t.assigned_date  between coalesce (_data_1,'1900-01-01') and coalesce (_data_2,now())
        and t.assigned_date >= '2020-01-01' 
  LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
  
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION reportistica.get_controlli_audit_percontodi_2020(timestamp without time zone, timestamp without time zone)
  OWNER TO postgres;

-- Function: reportistica.get_controlli_audit_oggetto_del_controllo_2020(timestamp without time zone, timestamp without time zone)

-- DROP FUNCTION reportistica.get_controlli_audit_oggetto_del_controllo_2020(timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION reportistica.get_controlli_audit_oggetto_del_controllo_2020(
    IN _data_1 timestamp without time zone DEFAULT '1900-01-01 00:00:00'::timestamp without time zone,
    IN _data_2 timestamp without time zone DEFAULT NULL::timestamp without time zone)
  RETURNS TABLE(id_controllo integer, id_oggetto_del_controllo integer, oggetto_del_controllo text, id_macrocategoria integer, descrizione_macrocategoria text) AS
$BODY$
DECLARE
BEGIN
for   
	id_controllo,
	id_oggetto_del_controllo,
	oggetto_del_controllo,
	id_macrocategoria,
	descrizione_macrocategoria
in select
	t.ticketid as id_controllo,
	li.code as id_oggetto_del_controllo,
	li.description::text as oggetto_del_controllo,
	lim.code,
	lim.description
	from ticket t
	left join tipocontrolloufficialeimprese tcu on tcu.idcontrollo = t.ticketid
	left join lookup_ispezione li on li.code=tcu.ispezione 
	left join lookup_ispezione_macrocategorie lim on lim.code = li.level 
where 
	t.provvedimenti_prescrittivi = 3 and t.tipologia = 3 
	and t.trashed_date is null and tcu.enabled and tcu.ispezione > 0
        and t.assigned_date  between coalesce (_data_1,'1900-01-01') and coalesce (_data_2,now())
        and lim.enabled 
        and t.assigned_date >= '2020-01-01' --post flusso 190

  LOOP
        RETURN NEXT;
     END LOOP;
     RETURN;
  
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION reportistica.get_controlli_audit_oggetto_del_controllo_2020(timestamp without time zone, timestamp without time zone)
  OWNER TO postgres;

DROP FUNCTION reportistica.estrazione_controlli_audit(timestamp without time zone,timestamp without time zone,integer,boolean);
  
CREATE OR REPLACE FUNCTION reportistica.estrazione_controlli_audit(
    IN _data_1 timestamp without time zone DEFAULT '1900-01-01 00:00:00'::timestamp without time zone,
    IN _data_2 timestamp without time zone DEFAULT NULL::timestamp without time zone,
    IN _asl integer DEFAULT NULL::integer,
    IN _solo_chiusi boolean DEFAULT true)
  RETURNS TABLE(id_controllo integer, data_inserimento timestamp without time zone, data_inizio_controllo timestamp without time zone, 
  data_chiusura_controllo timestamp without time zone, data_fine_controllo timestamp without time zone, id_stato_controllo integer, 
  stato_controllo text, asl character varying, riferimento_id integer, riferimento_nome_tab text, id_asl integer, 
  congruo_supervisione text, supervisionato_in_data timestamp without time zone, supervisionato_da integer, supervisionato_note text, note text,
  id_tecnica_cu integer, struttura_complessa text, struttura_semplice text, per_conto_di_completo text, 
  id_unita_operativa integer, id_asl_struttura integer, ruolo_utente_nucleo text, cognome text, nome text, 
  id_componente_nucleo integer, id_asl_utente_nucleo integer, codice_linea text, id_motivo integer, motivo_audit_padre character varying, 
  motivo_audit_figlio text, alias_motivo_padre text, alias_indicatore text, id_oggetto_controllo integer, oggetto_del_controllo text, 
  descrizione_macrocategoria_oggetto text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
select distinct a.*,b.struttura_complessa, b.struttura_semplice, b.per_conto_di_completo, b.id_unita_operativa, b.id_asl_struttura, 
c.ruolo as ruolo_utente_nucleo, c.cognome, c.nome, c.id_componente as id_componente_nucleo, c.id_asl as id_asl_utente_nucleo, d.codice_linea,
e.id_motivo_audit, e.descrizione_motivo_padre, e.descrizione_motivo_figlio,e.alias_padre, e.alias_indicatore,
f.id_oggetto_del_controllo, f.oggetto_del_controllo, f.descrizione_macrocategoria
from reportistica.get_controlli_audit(_asl, _data_1, _data_2, _solo_chiusi) a
left join 
(select * from reportistica.get_controlli_audit_percontodi_2020(_data_1,_data_2) ) b on a.id_controllo = b.id_controllo 
left join 
(select * from reportistica.get_controlli_nucleoispettivo_list(_data_1,_data_2,'{3}'::int[])) c on c.id_controllo = a.id_controllo
left join
(select * from reportistica.get_linee_attivita_controllo(_data_1,_data_2,3)) d on d.id_controllo = a.id_controllo
left join
(select * from reportistica.get_controlli_audit_motivi_2020(_data_1,_data_2)) e on e.id_controllo = a.id_controllo
left join
(select * from reportistica.get_controlli_audit_oggetto_del_controllo_2020(_data_1,_data_2)) f on f.id_controllo = a.id_controllo;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION reportistica.estrazione_controlli_audit(timestamp without time zone, timestamp without time zone, integer, boolean)
  OWNER TO postgres;

--select * from reportistica.estrazione_controlli_audit('2020-01-01','2020-12-31',null, false)


CREATE OR REPLACE FUNCTION reportistica.estrazione_controlli_audit_senza_oggetto(
    IN _data_1 timestamp without time zone DEFAULT '1900-01-01 00:00:00'::timestamp without time zone,
    IN _data_2 timestamp without time zone DEFAULT NULL::timestamp without time zone,
    IN _asl integer DEFAULT NULL::integer,
    IN _solo_chiusi boolean DEFAULT true)
  RETURNS TABLE(id_controllo integer, data_inserimento timestamp without time zone, data_inizio_controllo timestamp without time zone, 
  data_chiusura_controllo timestamp without time zone, data_fine_controllo timestamp without time zone, id_stato_controllo integer, 
  stato_controllo text, asl character varying, riferimento_id integer, riferimento_nome_tab text, id_asl integer, 
  congruo_supervisione text, supervisionato_in_data timestamp without time zone, supervisionato_da integer, supervisionato_note text, note text,
  id_tecnica_cu integer, struttura_complessa text, struttura_semplice text, per_conto_di_completo text, 
  id_unita_operativa integer, id_asl_struttura integer, ruolo_utente_nucleo text, cognome text, nome text, 
  id_componente_nucleo integer, id_asl_utente_nucleo integer, codice_linea text, id_motivo integer, motivo_audit_padre character varying, 
  motivo_audit_figlio text, alias_motivo_padre text, alias_indicatore text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
select distinct a.*,b.struttura_complessa, b.struttura_semplice, b.per_conto_di_completo, b.id_unita_operativa, b.id_asl_struttura, 
c.ruolo as ruolo_utente_nucleo, c.cognome, c.nome, c.id_componente as id_componente_nucleo, c.id_asl as id_asl_utente_nucleo, d.codice_linea,
e.id_motivo_audit, e.descrizione_motivo_padre, e.descrizione_motivo_figlio,e.alias_padre, e.alias_indicatore
from reportistica.get_controlli_audit(_asl, _data_1, _data_2, _solo_chiusi) a
left join 
(select * from reportistica.get_controlli_audit_percontodi_2020(_data_1,_data_2) ) b on a.id_controllo = b.id_controllo 
left join 
(select * from reportistica.get_controlli_nucleoispettivo_list(_data_1,_data_2,'{3}'::int[])) c on c.id_controllo = a.id_controllo
left join
(select * from reportistica.get_linee_attivita_controllo(_data_1,_data_2,3)) d on d.id_controllo = a.id_controllo
left join
(select * from reportistica.get_controlli_audit_motivi_2020(_data_1,_data_2)) e on e.id_controllo = a.id_controllo;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION reportistica.estrazione_controlli_audit_senza_oggetto(timestamp without time zone, timestamp without time zone, integer, boolean)
  OWNER TO postgres;

delete from reportistica_interna_report;
     -- ITEM DI REPORTISTICA
insert into reportistica_interna_report ( nome, descrizione, query_dbi, campo_distinct_dbi, level) 
values ('ISPEZIONE CON OGGETTO DEL CONTROLLO', 'Il report estrae tutti i controlli ufficiali con tecnica "Ispezione" con oggetto del controllo 
e i riferimenti anagrafici dell''OSA sottoposto a controllo.', 'select s.ragione_sociale, s.partita_iva, s.n_reg,c.id_controllo, 
to_char(c.data_inserimento,''dd-mm-yyyy'') as data_inserimento, 
to_char(c.data_inizio_controllo,''dd-mm-yyyy'') as data_inizio_controllo, to_char(c.data_chiusura_controllo,''dd-mm-yyyy'') as data_chiusura_controllo, 
to_char(c.data_fine_controllo,''dd-mm-yyyy'') as data_fine_controllo, c. stato_controllo, c.asl, c.per_conto_di_completo, 
c.ruolo_utente_nucleo, c.cognome, c.nome, c.codice_linea as linea_attivita_controllo, c.descrizione_motivo,
c.oggetto_del_controllo from reportistica.dbi_get_all_stabilimenti_(''2000-01-01'',''2021-12-31'') s
join (select * from reportistica.estrazione_controlli_ispezione_semplice(?,''2020-01-01'',''2021-12-31'', false)) c
on s.riferimento_id=c.riferimento_id and s.riferimento_id_nome_tab=c.riferimento_nome_tab', 
'id_controllo', 1);

  insert into reportistica_interna_report ( nome, descrizione, query_dbi, campo_distinct_dbi, level) 
values ('ISPEZIONE SENZA OGGETTO DEL CONTROLLO', 'Il report estrae tutti i controlli ufficiali con tecnica "Ispezione" senza oggetto del controllo 
e i riferimenti anagrafici dell''OSA sottoposto a controllo.','select s.ragione_sociale, s.partita_iva, s.n_reg,c.id_controllo,
 to_char(c.data_inserimento,''dd-mm-yyyy'') as data_inserimento, 
to_char(c.data_inizio_controllo,''dd-mm-yyyy'') as data_inizio_controllo, to_char(c.data_chiusura_controllo,''dd-mm-yyyy'') as data_chiusura_controllo, 
to_char(c.data_fine_controllo,''dd-mm-yyyy'') as data_fine_controllo, c. stato_controllo, c.asl, c.per_conto_di_completo, 
c.ruolo_utente_nucleo, c.cognome, c.nome, c.codice_linea as linea_attivita_controllo, c.descrizione_motivo from reportistica.dbi_get_all_stabilimenti_(''2000-01-01'',''2021-12-31'') s
join (select * from reportistica.estrazione_controlli_ispezione_semplice_senza_oggetto(?,''2020-01-01'',''2021-12-31'', false)) c
on s.riferimento_id=c.riferimento_id and s.riferimento_id_nome_tab=c.riferimento_nome_tab', 
'id_controllo', 2);

  insert into reportistica_interna_report ( nome, descrizione, query_dbi, campo_distinct_dbi, level) 
values ('AUDIT CON OGGETTO DEL CONTROLLO', 'Il report estrae tutti i controlli ufficiali con tecnica "AUDIT" con oggetto del controllo 
e i riferimenti anagrafici dell''OSA sottoposto a controllo.', 'select s.ragione_sociale, s.partita_iva, s.n_reg,c.id_controllo,
to_char(c.data_inserimento,''dd-mm-yyyy'') as data_inserimento, 
to_char(c.data_inizio_controllo,''dd-mm-yyyy'') as data_inizio_controllo, to_char(c.data_chiusura_controllo,''dd-mm-yyyy'') as data_chiusura_controllo, 
to_char(c.data_fine_controllo,''dd-mm-yyyy'') as data_fine_controllo, c. stato_controllo, c.asl, c.per_conto_di_completo, 
c.ruolo_utente_nucleo, c.cognome, c.nome, c.codice_linea as linea_attivita_controllo, c.motivo_audit_padre,
c.motivo_audit_figlio, c.alias_motivo_padre, c.alias_indicatore, c.descrizione_macrocategoria_oggetto as macrocategoria_oggetto_controllo,
c.oggetto_del_controllo from reportistica.dbi_get_all_stabilimenti_(''2000-01-01'',''2021-12-31'') s
join (select * from reportistica.estrazione_controlli_audit(''2020-01-01'',''2021-12-31'', ?, false)) c
on s.riferimento_id=c.riferimento_id and s.riferimento_id_nome_tab=c.riferimento_nome_tab', 
 'id_controllo', 3);

  -- ITEM DI REPORTISTICA
  insert into reportistica_interna_report ( nome, descrizione, query_dbi, campo_distinct_dbi, level) 
values ('AUDIT SENZA OGGETTO DEL CONTROLLO', 'Il report estrae tutti i controlli ufficiali con tecnica "Audit" con oggetto del controllo 
e i riferimenti anagrafici dell''OSA sottoposto a controllo.', 'select s.ragione_sociale, s.partita_iva, s.n_reg,c.id_controllo, 
to_char(c.data_inserimento,''dd-mm-yyyy'') as data_inserimento, 
to_char(c.data_inizio_controllo,''dd-mm-yyyy'') as data_inizio_controllo, to_char(c.data_chiusura_controllo,''dd-mm-yyyy'') as data_chiusura_controllo, 
to_char(c.data_fine_controllo,''dd-mm-yyyy'') as data_fine_controllo, c. stato_controllo, c.asl, c.per_conto_di_completo, 
c.ruolo_utente_nucleo, c.cognome, c.nome, c.codice_linea as linea_attivita_controllo, c.motivo_audit_padre,
c.motivo_audit_figlio, c.alias_motivo_padre, c.alias_indicatore from reportistica.dbi_get_all_stabilimenti_(''2000-01-01'',''2021-12-31'') s
join (select * from reportistica.estrazione_controlli_audit_senza_oggetto(''2020-01-01'',''2021-12-31'', ? ,false)) c
on s.riferimento_id=c.riferimento_id and s.riferimento_id_nome_tab=c.riferimento_nome_tab', 
'id_controllo', 4);

 



 
---------------------------- LANCIATI IN UFFICIALE ---------------------------------------
 alter table linee_attivita_controlli_ufficiali ADD  column note_internal_use_only text;
alter table linee_attivita_controlli_ufficiali ADD  column modified timestamp;
alter table linee_attivita_controlli_ufficiali ADD  column  entered timestamp;
alter table linee_attivita_controlli_ufficiali ADD  column  entered_by integer;
alter table linee_attivita_controlli_ufficiali ADD  column  modified_by integer;
 
-- Function: public_functions.insert_linee_attivita_controlli_ufficiali(integer, integer, character varying, text, integer, integer)

-- DROP FUNCTION public_functions.insert_linee_attivita_controlli_ufficiali(integer, integer, character varying, text, integer, integer, integer);
DROP FUNCTION public_functions.insert_linee_attivita_controlli_ufficiali(integer, integer, character varying, text, integer, integer);
DROP FUNCTION public_functions.insert_linee_attivita_controlli_ufficiali(integer, integer, character varying, text, integer, integer, integer);
 
CREATE OR REPLACE FUNCTION public_functions.insert_linee_attivita_controlli_ufficiali(
    _id_controllo_ufficiale integer,
    _id_linea_attivita integer,
    _riferimento_nome_tab character varying,
    _note text DEFAULT NULL::text,
    _id_linea_attivita_old integer DEFAULT NULL::integer,
    _id_vecchio_tipo_operatore integer DEFAULT NULL::integer,
    user_id integer DEFAULT NULL::integer
)
  RETURNS text AS
$BODY$
  DECLARE
     _codice_linea character varying;
      _provvedimenti_prescrittivi integer;
     _id_lacu integer;
   BEGIN

select provvedimenti_prescrittivi into _provvedimenti_prescrittivi from ticket where ticketid = _id_controllo_ufficiale;
IF _provvedimenti_prescrittivi <> 3 THEN
        update linee_attivita_controlli_ufficiali set note_internal_use_only = concat(note_internal_use_only, current_timestamp, '. Cancellazione record per import controlli ufficiali fatto da utente ', user_id ), modified=current_timestamp, modified_by = user_id,  trashed_date = now() where id_controllo_ufficiale = _id_controllo_ufficiale;
        END IF;
        
	-- recupero codice linea
        _codice_linea := (
           select codice from opu_relazione_stabilimento_linee_produttive rel 
           join ml8_linee_attivita_nuove_materializzata ml 
           on ml.id_nuova_linea_attivita = rel.id_linea_produttiva 
           where rel.id = _id_linea_attivita and _riferimento_nome_tab = 'opu_relazione_stabilimento_linee_produttive'
           union
           select distinct codice from org_linee_attivita_view  
	   where (id = _id_linea_attivita and  (_riferimento_nome_tab not in ('opu_relazione_stabilimento_linee_produttive', 'sintesis_relazione_stabilimento_linee_produttive','anagrafica.rel_stabilimenti_linee_attivita' )) and ( _id_vecchio_tipo_operatore is null or tipo = _id_vecchio_tipo_operatore)) or
	   _id_linea_attivita = -1 and tipo = _id_vecchio_tipo_operatore 
	   union
           select codice from suap_ric_scia_linee_attivita_stabilimenti_view where id = _id_linea_attivita and _riferimento_nome_tab = 'suap_ric_scia_relazione_stabilimento_linee_produttive'
           union   
           select codice from sintesis_linee_attivita_stabilimenti_view where id = _id_linea_attivita and _riferimento_nome_tab = 'sintesis_relazione_stabilimento_linee_produttive'
           union
           select 'OPR-OPR-X' from anagrafica.linee_attivita_stabilimenti_view where id = _id_linea_attivita and _riferimento_nome_tab = 'anagrafica.rel_stabilimenti_linee_attivita'
           
	);
select id_controllo_ufficiale into _id_lacu from linee_attivita_controlli_ufficiali where id_controllo_ufficiale = 	_id_controllo_ufficiale and id_linea_attivita = _id_linea_attivita and trashed_date is null;

IF _id_lacu IS NULL or _id_lacu<=0 THEN
insert into linee_attivita_controlli_ufficiali(id_controllo_ufficiale, id_linea_attivita, riferimento_nome_tab, codice_linea, note, id_linea_attivita_old, id_vecchio_tipo_operatore)
	values(_id_controllo_ufficiale,_id_linea_attivita,_riferimento_nome_tab, _codice_linea, _note, _id_linea_attivita_old, _id_vecchio_tipo_operatore);
	END IF;
	
	return 'OK';
  END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public_functions.insert_linee_attivita_controlli_ufficiali(integer, integer, character varying, text, integer, integer, integer)
  OWNER TO postgres;

 ------------------------------------------------------- FINE UFFICIALE
 -- Gestione checklist
 -- Rita Mele 11/02/2021
 
  CREATE TABLE public.lookup_tipologia_checklist
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
ALTER TABLE public.lookup_tipologia_checklist
  OWNER TO postgres;
  
CREATE TABLE public.chk_sorv_capitoli
(
  id serial,
  capitolo character varying(350) NOT NULL,
  level integer DEFAULT 0,
  enabled boolean DEFAULT true,
  id_tipo_checklist integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.chk_sorv_capitoli
  OWNER TO postgres;

  CREATE TABLE public.chk_sorv_domande
(
  id serial,
  domanda text NOT NULL,
  level integer DEFAULT 0,
  enabled boolean DEFAULT true,
  id_capitolo integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.chk_sorv_domande
  OWNER TO postgres;

 
CREATE TABLE public.chk_sorv_istanza
(
  id serial,
  id_tipo_checklist integer,
  idcu integer,
  entered timestamp(3) without time zone NOT NULL DEFAULT now(),
  enteredby integer NOT NULL,
  modified timestamp(3) without time zone NOT NULL DEFAULT now(),
  modifiedby integer NOT NULL,
  trashed_date timestamp(3) without time zone,
  data_chk timestamp(3) without time zone,
  punteggio_totale double precision, 
  categoria_rischio_qualitativa character varying,
  bozza boolean,
  note text
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.chk_sorv_istanza
  OWNER TO postgres;
  

CREATE TABLE public.chk_sorv_risposte
(
  id serial,
  risposta text,
  id_domanda integer,
  level integer,
  punteggio double precision,
  enabled boolean,
  entered timestamp,
  modified timestamp,
  enteredby integer,
  modifiedby integer,
  trashed_date timestamp
  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.chk_sorv_risposte
  OWNER TO postgres;

 
  CREATE TABLE public.chk_sorv_istanza_domanda_risposta
(
  id serial,
  id_istanza integer,
  id_domanda integer,
  id_risposta integer,
  level integer,
  entered timestamp,
  modified timestamp,
  enteredby integer,
  modifiedby integer,
  trashed_date timestamp
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.chk_sorv_istanza_domanda_risposta
  OWNER TO postgres;



alter table chk_sorv_domande  ADD column trashed_date timestamp;
alter table chk_sorv_capitoli ADD column trashed_date timestamp;

insert into lookup_tipologia_checklist (description, short_description, level, enabled) values('VALUTAZIONE DEL RISCHIO','VALUTAZIONE DEL RISCHIO',1,true);
-- 
insert into chk_sorv_capitoli (capitolo,level, enabled, id_tipo_checklist) values('CARATTERISTICHE DELLO STABILIMENTO',1,true, 1);
insert into chk_sorv_capitoli (capitolo,level, enabled, id_tipo_checklist) values('ENTITA'' PRODUTTIVA',2,true, 1);
insert into chk_sorv_capitoli (capitolo,level, enabled, id_tipo_checklist) values('PRODOTTI',3,true, 1);
insert into chk_sorv_capitoli (capitolo,level, enabled, id_tipo_checklist) values('IGIENE DELLA PRODUZIONE',4,true, 1);
insert into chk_sorv_capitoli (capitolo,level, enabled, id_tipo_checklist) values('SISTEMA DI AUTOCONTROLLO',5,true, 1);
insert into chk_sorv_capitoli (capitolo,level, enabled, id_tipo_checklist) values('DATI STORICI',6,true, 1);

--select 'insert into chk_sorv_domande(description,level, enabled, idcap) values('''||domanda||''','||level||',true, 1);'
--from checklist where parent_id=-1
--order by level

delete from chk_sorv_domande;
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('DATA DI COSTRUZIONE O DI RISTRUTTURAZIONE SIGNIFICATIVA',0,true, 1);
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('CONDIZIONI GENERALI E DI MANUTENZIONE DELLO STABILIMENTO',5,true, 1);
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('DIMENSIONE DELLO STABILIMENTO ED ENTITA'' DELLA PRODUZIONE',10,true, 2);
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('DIMENSIONE DEL MERCATO SERVITO',15,true, 2);
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('CATEGORIA DI ALIMENTO',20,true, 3);
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('DESTINAZIONE D''USO',25,true, 3);
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('PROFESSIONALITA'' E DISPONIBILITA'' ALLA COLLABORAZIONE DELLA DIREZIONE DELLO STABILIMENTO',29,true, 4);
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('FORMAZIONE IGIENICO SANITARIA E COMPETENZA  DEGLI ADDETTI',34,true, 4);
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('COMPLETEZZA FORMALE DEL PIANO DI AUTOCONTROLLO',39,true, 5);
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('GRADO DI APPLICAZIONE ED ADEGUATEZZA',44,true, 5);
insert into chk_sorv_domande(domanda,level, enabled, id_capitolo) values('IRREGOLARITA'' E NON CONFORMITA'' PREGRESSE RISCONTRATE',49,true, 6);


-- select * from chk_sorv_risposte  where id_domanda  =10
select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',1,'||level||',true, '||round((punti_si/10.0),1)||');'
from checklist where parent_id=5917
order by level

select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',2,'||level||',true, '||round((punti_si/10.0),1)||');'
from checklist where parent_id=5922
order by level

select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',3,'||level||',true, '||round((punti_si/10.0),1)||');'
from checklist where parent_id=5927
order by level

select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',4,'||level||',true, '||round((punti_si/10.0),1)||');'
from checklist where parent_id=5932
order by level

select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',5,'||level||',true, '||round((punti_si/10.0),1)||');'
from checklist where parent_id=5937
order by level

select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',6,'||level||',true, '||round((punti_si/10.0),1)||');'
from checklist where parent_id=5942
order by level

select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',7,'||level||',true, '||round((punti_si/10.0),1)||');'
from checklist where parent_id=5946
order by level

select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',8,'||level||',true, '||round((punti_si/10.0),1)||');'
from checklist where parent_id=5951
order by level

select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',9,'||level||',true,'||round((punti_si/10.0),1)||');'
from checklist where parent_id=5956
order by level

select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',10,'||level||',true, '||round((punti_si/10.0),1)||');'
from checklist where parent_id=5961
order by level

select *, 'insert into chk_sorv_risposte(risposta,id_domanda, level, enabled,punteggio) values('''||domanda||''',11,'||level||',true, '||round((punti_si/10.0),1)||');'
from checklist where parent_id=5966
order by level


CREATE OR REPLACE FUNCTION public.insert_chk_sorv_istanza(
    _id_cu integer,
    _id_utente integer,
    _id_tipo_checklist integer,  
    _bozza boolean DEFAULT true)
  RETURNS integer AS
$BODY$

BEGIN

    INSERT INTO chk_sorv_istanza (id_tipo_checklist, idcu, enteredby, modifiedby, modified, entered, bozza)
		VALUES (_id_tipo_checklist, _id_cu, _id_utente, _id_utente, now(),now(), _bozza);

RETURN 1;
  
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE OR REPLACE FUNCTION public.insert_chk_sorv_istanza_domanda_risposta(
    _id_istanza integer,
    _id_domanda integer,
    _id_risposta integer,
    _id_utente integer)
  RETURNS integer AS
$BODY$

BEGIN
 --select * from chk_sorv_istanza_domanda_risposta
    INSERT INTO chk_sorv_istanza_domanda_risposta  (id_istanza, id_domanda,id_risposta, enteredby, modifiedby, entered, modified)
		VALUES (_id_istanza, _id_domanda, _id_risposta, _id_utente, _id_utente, now(), now());

RETURN 1;
  
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  --select * from lookup_categoria_rischio  

drop view lookup_categoria_rischio;

create table lookup_categoria_rischio AS (
select * from lookup_categoriarischio_soa);  
update lookup_categoria_rischio set range_a=41 where code=92;
update lookup_categoria_rischio set range_da=42 where code=93;


CREATE OR REPLACE FUNCTION public.get_categoria_rischio(_punteggio double precision)
  RETURNS character varying AS
$BODY$

DECLARE
	categoria_rischio_quantitativa character varying;
BEGIN

select short_description into categoria_rischio_quantitativa from lookup_categoria_rischio where (range_da <= _punteggio or range_da is null) and (range_a >=_punteggio or range_a is null);
return categoria_rischio_quantitativa;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
ALTER FUNCTION public.get_categoria_rischio(double precision)
  OWNER TO postgres;


  
-- DROP FUNCTION public.get_has_linee_categorizzabili(integer, text);
DROP FUNCTION public.get_has_linee_categorizzabili(integer, text);

CREATE OR REPLACE FUNCTION public.get_has_linee_categorizzabili(
    _riferimentoid integer,
    _riferimentoidnometab text)
  RETURNS boolean AS
$BODY$
DECLARE
riferimentoId integer;
BEGIN

riferimentoId :=-1;

--select r.riferimento_id into riferimentoId from ricerche_anagrafiche_old_materializzata r
--left join master_list_flag_linee_attivita flag on flag.codice_univoco = concat_ws('-', r.codice_macroarea, r.codice_aggregazione, r.codice_attivita)
--where r.riferimento_id = _riferimentoId and r.riferimento_id_nome_tab = _riferimentoIdNomeTab and flag.categorizzabili;

--IF riferimentoId > 0 THEN
--return true;
--END IF;

--return false ;
return true;

 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
ALTER FUNCTION public.get_has_linee_categorizzabili(integer, text)
  OWNER TO postgres;
  
  CREATE OR REPLACE FUNCTION public.get_categoria_rischio_osa(_riferimento_id integer)
  RETURNS table(idcu integer, categoria_rischio_qualitativa character varying) AS
$BODY$

BEGIN
RETURN QUERY

select max(t.ticketid), ist.categoria_rischio_qualitativa 
from chk_sorv_istanza ist
left join ticket t on t.ticketid=ist.idcu
where ist.trashed_date is null and coalesce(t.org_id, t.id_stabilimento, t.alt_id)=_riferimento_id
and t.provvedimenti_prescrittivi=5 and t.tipologia=3
group by ist.categoria_rischio_qualitativa 
order by 1 desc limit 1;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
ALTER FUNCTION public.get_categoria_rischio_osa(integer)
  OWNER TO postgres;