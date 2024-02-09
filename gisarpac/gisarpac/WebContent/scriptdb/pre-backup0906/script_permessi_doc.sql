
insert into permission_category(category_id, category, level, enabled, constant) values(13, 'Documentale', 1,true,13)

insert into permission (category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints)
values (13,'documents-documents', true, true, true, false, 'Accesso ai documenti', 0, true, true, false);

insert into role_permission(id, role_id, permission_id, role_view, role_edit, role_delete) values((select max(id)+1 from role_permission), 32, 6,true, false, false)

-- Function: public.cu_get_verbale_a6(integer)

-- DROP FUNCTION public.cu_get_verbale_a6(integer);

CREATE OR REPLACE FUNCTION public.cu_get_verbale_a6(_id_controllo integer)
  RETURNS json AS
$BODY$
DECLARE
	output json;
BEGIN

	-- output := (SELECT (row_to_json(t)) FROM (select id as "idControllo", l.description as "stato", c.data_inizio as "dataInizio", c.entered as "dataInserimento", concat_ws(' ', co.namefirst, co.namelast)::text as "utenteInserimento"
	--									from  controlli_ufficiali c
	--									join access a on a.user_id = c.enteredby 
	--									join contact co on co.contact_id = a.contact_id
	--								        join lookup_stato_cu l on l.code = c.stato 
	--									where c.id =  _id_controllo
	--									order by c.data_inizio desc) t);

	output := (select * from public.cu_dettaglio_globale(_id_controllo));

	return output;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.cu_get_verbale_a6(integer)
  OWNER TO postgres;
  
  insert into permission (permission_id, category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints)
values(5, 13,'documentale_bacheca',true,true,true,true,'Gestione bacheca (archivi) tramite server documentale',0,true,true,false)

insert into role_permission(id, permission_id, role_id) values((select max(id) +1 from role_permission),5,32);
insert into role_permission(id, permission_id, role_id) values((select max(id) +1 from role_permission),5,33);
update role_permission set role_view  =true, role_add=true, role_edit=true where permission_id = (5)
