




CREATE OR REPLACE FUNCTION public.controllo_dati_autorizzativi(rifid integer)
 RETURNS TABLE(fascicolo boolean,acque_reflue boolean)
 LANGUAGE plpgsql
AS $function$

declare
		id_ int4;
		id_matrice int4;
		fascicolo_ boolean;
		acque_reflue_ boolean;
	BEGIN

		fascicolo_=true;
		acque_reflue_ = false;

	IF NOT exists (	select ag.id from anag_dati_autorizzativi_matrici ag right join anag_dati_autorizzativi ada2 on ag.id_anag_dati_autorizzativi =ada2.id where ada2.riferimento_id= rifId and ada2.trashed_date is null)
then
		fascicolo_=false;
end if;
	
		
		for id_ in 
	select ag.id from anag_dati_autorizzativi_matrici ag right join anag_dati_autorizzativi ada2 on ag.id_anag_dati_autorizzativi =ada2.id where ada2.riferimento_id= rifId and ada2.trashed_date is null
	loop 
		
		if id_::text is null
		then
		fascicolo_=false;
		end if;
		
		
		
	END LOOP;
		
		for id_matrice in 
	select ag.id_matrice from anag_dati_autorizzativi_matrici ag right join anag_dati_autorizzativi ada2 on ag.id_anag_dati_autorizzativi =ada2.id where ada2.riferimento_id= rifId and ada2.trashed_date is null
	loop 
		
		if id_matrice=3
		then
		acque_reflue_ = true;
		end if;
		
		
		
	END LOOP;
		
		
		
		
		
		RETURN QUERY     
	select fascicolo_ boolean, acque_reflue_ boolean;  

	END;
$function$
;



CREATE OR REPLACE FUNCTION public.fascicolo_ispettivo_dettaglio_globale(_idfascicolo integer)
 RETURNS json
 LANGUAGE plpgsql
AS $function$	
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

	rifid := (select riferimento_id from fascicoli_ispettivi  where id = _idfascicolo);
	rifnometab := (select c.riferimento_id_nome_tab from fascicoli_ispettivi c where id = _idfascicolo);
	campiservizio := (select json_object_agg(nome,descrizione) from (select 'utenteInserimento' as nome, concat_ws(' ', co.namefirst, co.namelast)::text as descrizione
								        from fascicoli_ispettivi c 
								        join access a on a.user_id = c.enteredby 
								        join contact co on co.contact_id = a.contact_id
									where id = _idfascicolo 
								  union select 'dataInserimento' as nome, entered::text as descrizione from fascicoli_ispettivi where id = _idfascicolo
								  union select 'idFascicoloIspettivo' as nome, id::text as descrizione from fascicoli_ispettivi where id = _idfascicolo
								  ) b);

	anagrafica:= (select json_object_agg(nome,descrizione) from (select 'partitaIva' as nome, trim(partita_iva) as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab
								  union select 'riferimentoId' as nome,  rifid::text
								  union select 'riferimentoIdNomeTab' as nome,  rifnometab::text 
								  union select 'ragioneSociale' as nome, ragione_sociale as descrizione from ricerche_anagrafiche_old_materializzata  where riferimento_id = rifid and riferimento_id_nome_tab = rifnometab) c);
									
	datifascicolo := (select json_object_agg(nome,descrizione) from (select 'numero' as nome, numero as descrizione from fascicoli_ispettivi  where id = _idfascicolo
								  union select 'dataInizio' as nome,  data_inizio::text from fascicoli_ispettivi where id = _idfascicolo 
								  ) b);
								  
	statofascicolo := (select json_object_agg(nome,descrizione) from (select 'stato' as nome, ls.description as descrizione from fascicoli_ispettivi f join lookup_stato_fascicolo ls on ls.code=f.stato where id = _idfascicolo
								  union select 'dataChiusura' as nome,  data_chiusura::text from fascicoli_ispettivi where id = _idfascicolo 
								  union select 'allegatoChiusura' as nome, header_allegato::text  from fascicoli_ispettivi where id = _idfascicolo 
								  
								  ) b);
						

	utente := (select json_object_agg(nome,descrizione) from (select 'userId' as nome, enteredby as descrizione from fascicoli_ispettivi where id = _idfascicolo) d); 

	finale := (select unaccent(concat('{',
	(select concat_ws(' ','"Dati":', datifascicolo, ',
	"Anagrafica":', anagrafica, ',
	"Utente":',utente, ',
	"Stato":', statofascicolo, ',
	"CampiServizio":', campiServizio)),'}'))::json);
	
	raise info 'json finale: %', finale;

    	return finale;
END;
$function$
;


ALTER TABLE public.fascicoli_ispettivi ADD header_allegato text NULL;




CREATE OR REPLACE FUNCTION public.dbi_lista_utenti_guru()
 RETURNS TABLE(id integer, username text, alias_utente text, nome text, cognome text, codice_fiscale text, ruolo text, asl text, id_ruolo integer)
 LANGUAGE plpgsql
AS $function$
DECLARE

BEGIN
RETURN QUERY
    
 select a.user_id, a.username::text, a.alias_utente::text, c.namefirst::text, c.namelast::text, c.codice_fiscale::text, r.role::text, CASE WHEN asl.code > 0 THEN asl.description ELSE 'TUTTI I DIPARTIMENTI' END::text , r.role_id
from access_ a
left join access_dati ac on ac.user_id = a.user_id
left join contact_ c on c.contact_id = a.contact_id
left join role r on r.role_id = a.role_id
left join lookup_site_id asl on asl.code = ac.site_id
order by a.entered desc;

END;
$function$
;
