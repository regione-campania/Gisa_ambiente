

CREATE OR REPLACE FUNCTION public.campione_get_verbale_c4(_id_campione integer)
  RETURNS json AS
$BODY$
DECLARE
	output json;
	idControlloUfficiale integer;
	outputControlloUfficiale json;
	outputCampione json;
BEGIN

	outputCampione := (select * from public.campione_dettaglio_globale(_id_campione));

	idControlloUfficiale := ((outputCampione->>'DatiCU')::json->>'idControllo')::integer;
	
	outputControlloUfficiale := (select * from public.cu_dettaglio_globale(idControlloUfficiale));

	output := '{"ControlloUfficiale" : ' || outputControlloUfficiale ||', "Campione" : ' || outputCampione || '}';

	return output;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


  
 
  
  


  
 



  
 
  
  


  
 
