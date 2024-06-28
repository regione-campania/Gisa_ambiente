
-- FUNCTION: public.get_tipi_verifica_ids(text)

-- DROP FUNCTION IF EXISTS public.get_tipi_verifica_ids(text);

CREATE OR REPLACE FUNCTION public.get_tipi_verifica_ids(
	matrici text)
    RETURNS integer[]
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

DECLARE
  where_condition text;
  matrici_new integer[];

 where_condition_1 text;
 where_condition_2 text;
 where_condition_3 text;
 where_condition_4 text;
 where_condition_5 text;
 where_condition_6 text;
 where_condition_7 text;
 where_finale text;
 
BEGIN
	matrici_new := matrici::int[];
	raise info 'matrici convertita%', matrici_new;
	raise info 'test: %', matrici_new && ARRAY[1,2,3];
	where_condition_1 ='';
	where_condition_2 ='';
	where_condition_3 ='';
	where_condition_4 ='';
	where_condition_5 ='';
	where_condition_6 ='';
	where_condition_7 ='';
	where_finale = '';

	if( matrici_new && '{1,2,3}'::int[]) then 
		where_condition_1= '3,';		--emissioni in acqua;
	end if;
	if ( matrici_new && '{7,8}'::int[]) then
		where_condition_2 = '2,';--emissioni in aria
	end if;
	if ( matrici_new && '{4}'::int[]) then
		where_condition_3 = '4,';  --Rifiuti 3.2.5
	end if;
	if ( matrici_new && '{5}'::int[]) then
		where_condition_4 = '9,'; --Rumore
	end if;
	if ( matrici_new && '{6}'::int[]) then
		--Altro
		where_condition_5 = '10,';
	end if;
	if ( matrici_new && '{9}'::int[]) then
		where_condition_6 = '7,8,5,6,1,';
	end if;
	if ( matrici_new && '{10}'::int[]) then
		where_condition_7 = '5';
	end if;

	raise info 'query 1 %', where_condition_1;
	raise info 'query 2 %', where_condition_2;
	raise info 'query 3 %', where_condition_3;
	raise info 'query 4 %', where_condition_4;
	raise info 'query 5 %', where_condition_5;
	raise info 'query 6 %', where_condition_6;
	raise info 'query 7 %', where_condition_7;


       --costruire la lista definitiva con gli id
       where_finale = concat('{',where_condition_1,where_condition_2,where_condition_3,where_condition_4, where_condition_5, where_condition_6,where_condition_7,'}');
       where_finale = replace(where_finale,',}','}');
       raise info 'query finale %', where_finale::int[];

       return where_finale::int[];
END;
$BODY$;

ALTER FUNCTION public.get_tipi_verifica_ids(text)
    OWNER TO postgres;