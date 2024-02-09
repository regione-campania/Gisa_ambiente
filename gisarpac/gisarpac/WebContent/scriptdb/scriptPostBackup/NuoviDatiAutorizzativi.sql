
CREATE OR REPLACE FUNCTION public.delete_dati_autorizzativi(
    _riferimento_id integer,
    _riferimento_id_nome_tab text,
    _id_utente integer)
  RETURNS text AS
$BODY$
DECLARE
	
BEGIN

 
	
	update anag_dati_autorizzativi set modifiedby = _id_utente, trashed_date = now() 
	where riferimento_id= _riferimento_id 
	and   riferimento_id_nome_tab = _riferimento_id_nome_tab
	and trashed_date is null;

	
		return 'OK, operazione effettuata con successo.';
	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE OR REPLACE FUNCTION public.insert_dati_autorizzativi(
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
