
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
	       tab.description::character varying, 
	       tab.codice_esame, 
	       tab.short_description  
	   from(
	select qds.description, ordina_stringhe_alfanumeriche(qds.description, 3), qds.code, qds.short_description, qds.codice_esame 
		from quesiti_diagnostici_sigla qds order by ordina_stringhe_alfanumeriche(qds.description, 3)) tab;

                                         		
END;
$BODY$;

ALTER FUNCTION preaccettazione.get_quesiti_diagnostici()
    OWNER TO postgres;


CREATE OR REPLACE FUNCTION preaccettazione.dbi_ins_res_arpac(
	_codpreacc text,
	_descr_ris_esame text,
	_id_utente integer DEFAULT NULL::integer,
	_forza_riscrittura boolean DEFAULT false)
    RETURNS TABLE(_idout integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE
	id_preacc integer;
	_id_cmp integer;
	_esito_preaccettazione text;
	
BEGIN

	select id into id_preacc from preaccettazione.codici_preaccettazione where trim(concat(prefix,anno,progres)) ilike trim(_codpreacc);

	select id_cmp into _id_cmp from preaccettazione.get_id_cmp_da_codice_preaccettazione(_codpreacc);

	select coalesce(trim(esito_preaccettazione),'') into _esito_preaccettazione from campioni where id =  _id_cmp;

	IF _id_utente is null or _id_utente = -1 THEN
			_id_utente := 6567;
	END IF;

	IF (length(trim(_esito_preaccettazione)) = 0 and length(trim(_descr_ris_esame)) <> 0) THEN

		UPDATE campioni set esito_preaccettazione = _descr_ris_esame where id = _id_cmp;

		return query
		insert into preaccettazione.stati_preaccettazione (id_preaccettazione, id_stato, entered, enteredby)
			values (id_preacc, 5, now(), _id_utente) returning id;
			
	ELSIF (length(trim(_descr_ris_esame)) <> 0 and _forza_riscrittura) THEN
		UPDATE campioni set esito_preaccettazione = _descr_ris_esame where id = _id_cmp;
		UPDATE preaccettazione.stati_preaccettazione 
			set modified = now(), 
			    modifiedby = _id_utente, 
			    note_hd = concat(trim(note_hd) || '--',' lettura forzata esito esame dai ws di ARPAC in data: ', to_char(now(), 'YYYY-MM-DD  HH24:MI:SS'), ' da id utente: ', _id_utente)
		WHERE id_preaccettazione = id_preacc and id_stato = 5;
	ELSE
		return query
		select 0;
	END IF;
			
END;
$BODY$;

ALTER FUNCTION preaccettazione.dbi_ins_res_arpac(text, text, integer, boolean)
    OWNER TO postgres;
  
  DROP FUNCTION IF EXISTS public.inserisci_nel_log(text, text, text, integer);

CREATE OR REPLACE FUNCTION public.inserisci_nel_log(
	_url text,
	_request text,
	_response text DEFAULT NULL::text,
	_id_utente integer DEFAULT NULL::integer)
    RETURNS TABLE(_idout integer) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE

	
BEGIN

	IF (length(trim(_response)) = 0) THEN
		_response := '### TENTATIVO DI CHIAMATA AI SERVIZI ###';
	END IF;

	IF _id_utente is null or _id_utente = -1 THEN
			_id_utente := 6567;
	END IF;
	
	return query
	insert into ws_storico_chiamate (url, request, response, id_utente, data)
		values (_url, _request, _response, _id_utente, now()) returning id;
					
END;
$BODY$;

ALTER FUNCTION public.inserisci_nel_log(text, text, text, integer)
    OWNER TO postgres;


alter table campioni add column esito_preaccettazione text;
drop function set_codice_preaccettazione(_id integer, _riferimento_id integer, _riferimento_id_nome text, _riferimento_id_nome_tab text, _id_linea_materializzata integer, _tipologia_operatore integer, _userid integer, _quesito_diagnostico text, _matrice_campione text);
DROP FUNCTION IF EXISTS preaccettazione.aggiorna_coordinate_stabilimento(integer, text, text, double precision, double precision);
DROP FUNCTION IF EXISTS preaccettazione.dbi_get_all_stabilimenti_gis(text, double precision, double precision, double precision, timestamp without time zone, timestamp without time zone, boolean);
DROP FUNCTION IF EXISTS preaccettazione.dbi_get_all_stabilimenti_gis_cu_cmp(text, double precision, double precision, double precision);
DROP FUNCTION IF EXISTS preaccettazione.dbi_get_campioni_da_stabilimento(integer, text, text, timestamp without time zone, timestamp without time zone);
DROP FUNCTION IF EXISTS preaccettazione.dbi_get_controlli_ufficiali_da_stabilimento(integer, text, text, timestamp without time zone, timestamp without time zone);
DROP FUNCTION IF EXISTS preaccettazione.dbi_get_stabilimenti_campioni_gis(text, double precision, double precision, double precision, timestamp without time zone, timestamp without time zone, boolean);
DROP FUNCTION IF EXISTS preaccettazione.dbi_get_stabilimenti_ex_ante_gis(text, double precision, double precision, double precision, timestamp without time zone, timestamp without time zone, boolean);
DROP FUNCTION IF EXISTS preaccettazione.dbi_get_stabilimenti_gis(text, text, double precision, double precision, double precision, timestamp without time zone, timestamp without time zone, boolean, integer);
DROP FUNCTION IF EXISTS preaccettazione.dbi_get_stabilimenti_mai_controllati_gis(text, double precision, double precision, double precision, timestamp without time zone, timestamp without time zone, boolean);
DROP FUNCTION IF EXISTS preaccettazione.dbi_get_stabilimenti_ragione_sociale(text, text, integer, text);
DROP FUNCTION IF EXISTS preaccettazione.get_elenco_preaccettazioni(integer);
DROP FUNCTION IF EXISTS preaccettazione.verifica_presenza_campioni_preaccettazione_su_cu(integer);
DROP FUNCTION IF EXISTS preaccettazione.temp_report_interno_codici_preaccettazione();

/*update campioni set esito_preaccettazione = '<div><table class=''table details'' width=''100%'' cellpadding=''2'' style=''border-collapse: collapse'' border=''1''><tr><td align=''center'' style=''width:25%; text-transform: none;''>SALMONELLA ALIMENTI, MANGIMI E SUPPORTI DA CAMPIONAMENTO RICERCA ISO </td><td align=''center'' style=''width:60%; text-transform: none;''></td><td align=''center'' style=''width:10%; text-transform: none;''></td><td align=''center'' style=''width:5%; text-transform: none;''></td></tr><tr><td align=''center'' style=''width:25%; text-transform: none;''>SALMONELLA SCREENING IN ALIMENTI E SPONGE CARCASSE RICERCA MEDIANTE REAL TIME PCR</td><td align=''center'' style=''width:60%; text-transform: none;''>NON RILEVABILE IN 25 G</td><td align=''center'' style=''width:10%; text-transform: none;''>negativo/i</td><td align=''center'' style=''width:5%; text-transform: none;''>N</td></tr></table></div>' where id=141;
insert into preaccettazione.stati_preaccettazione(id_preaccettazione, id_stato) values(9753,5);*/
 