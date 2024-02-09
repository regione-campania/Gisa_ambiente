DROP FUNCTION public.search_globale_cu(integer);

CREATE OR REPLACE FUNCTION public.search_globale_giornata_ispettiva(IN _id_giornata_ispettiva integer)
  RETURNS TABLE(id_fascicolo integer, id_giornata_ispettiva integer, num_fascicolo text, ragione_sociale text, data_inizio text, dipartimento text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
    
select distinct c.id_fascicolo, c.id, f.numero, s.ragione_sociale::text, to_char(c.data_inizio,'dd/mm/yyyy'), l.description::text
from controlli_ufficiali c
join fascicoli f on f.id = c.id_fascicolo and f.trashed_date is null
join ricerche_anagrafiche_old_materializzata s on s.riferimento_id = c.riferimento_id and s.riferimento_id_nome_tab = c.riferimento_id_nome_tab
join lookup_site_id l on l.code = c.id_dipartimento
where c.id = _id_giornata_ispettiva and c.trashed_date is null;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION public.search_globale_fascicolo(IN _id_fascicolo integer)
  RETURNS TABLE(id_fascicolo integer, id_giornata_ispettiva integer, num_fascicolo text, ragione_sociale text, data_inizio text, dipartimento text) AS
$BODY$
DECLARE
BEGIN
RETURN QUERY
    
select distinct f.id, -1, f.numero, s.ragione_sociale::text, to_char(f.data_inizio,'dd/mm/yyyy'), ''
from fascicoli f 
join ricerche_anagrafiche_old_materializzata s on s.riferimento_id = f.riferimento_id and s.riferimento_id_nome_tab = f.riferimento_id_nome_tab
where f.id = _id_fascicolo and f.trashed_date is null;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

