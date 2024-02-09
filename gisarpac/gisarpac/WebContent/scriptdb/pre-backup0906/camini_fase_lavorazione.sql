CREATE TABLE public.fasi_lavorazione
(
  id serial,
  tipo_quadro text,
  tipo_impianto text,
  punti_emissione text,
  fasi_lavorazione text,
  inquinanti text,
  impianti_abbattimento text
  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.fasi_lavorazione
  OWNER TO postgres;


insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Zincatura a caldo di acciaio','AIA','H1','Carpenteria met. - Taglio laser fisso','Polveri','Filtri a tessuto');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Zincatura a caldo di acciaio','AIA','H2','Attrezzeria Saldatura','Polveri','Filtri a tessuto');


CREATE TABLE public.anagrafica_fasi_lavorazione
(
  id serial,
  id_fase_lavorazione integer,
  riferimento_id integer,
  riferimento_id_nome_tab text,
  trashed_date timestamp,
  entered  timestamp default now(),
  enteredby integer,
  modifiedby integer,
  modified timestamp default now(),
  note_hd text
  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.anagrafica_fasi_lavorazione
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.get_fasi_lavorazione(
IN _riferimento_id integer, 
IN _riferimento_id_nome_tab text
)
   RETURNS TABLE(id integer,
  tipo_quadro text,
  tipo_impianto text,
  punti_emissione text,
  fasi_lavorazione text,
  inquinanti text,
  impianti_abbattimento text, 
  entered timestamp,
  enteredby integer,
  trashed_date timestamp,
  modified timestamp,
  modifiedby integer,
  selezionato boolean
  ) AS
$BODY$
DECLARE
BEGIN

	RETURN QUERY
	select f.*, a.entered, a.enteredby, a.trashed_date, a.modified, a.modifiedby, 
	case when a.riferimento_id is not null then true else false end as selezionato
	from fasi_lavorazione f 
	left join anagrafica_fasi_lavorazione a on a.id_fase_lavorazione = f.id and a.riferimento_id = _riferimento_id and a.riferimento_id_nome_tab = _riferimento_id_nome_tab
	where a.trashed_date is null; 
	
END;
$BODY$
  LANGUAGE plpgsql
  COST 100
  ROWS 1000;
ALTER FUNCTION public.get_fasi_lavorazione(integer, text)
  OWNER TO postgres;

  
CREATE OR REPLACE FUNCTION public.delete_anagrafica_fasi_lavorazione(
IN _riferimento_id integer, 
IN _riferimento_id_nome_tab text,
IN _userid integer)
   RETURNS text AS
$BODY$
DECLARE
BEGIN
	update anagrafica_fasi_lavorazione set note_hd=concat_ws('***', note_hd, 'Cancellazione effettuata tramite dbi'), modifiedby = _userid, trashed_date = now() 
	where riferimento_id= _riferimento_id 
	and   riferimento_id_nome_tab = _riferimento_id_nome_tab
	and trashed_date is null;

	return 'OK';

END;
$BODY$
  LANGUAGE plpgsql
  COST 100;

select * from anagrafica_fasi_lavorazione  
CREATE OR REPLACE FUNCTION public.insert_anagrafica_fasi_lavorazione(
IN _riferimento_id integer, 
IN _riferimento_id_nome_tab text,
IN _id integer,
IN _userid integer)
   RETURNS text AS
$BODY$
DECLARE
BEGIN
	insert into anagrafica_fasi_lavorazione(enteredby, riferimento_id, riferimento_id_nome_tab, id_fase_lavorazione, note_hd) values
	(_userid, _riferimento_id, _riferimento_id_nome_tab, _id, 'Inserimento effettuato dalla dbi');

	return 'OK';

END;
$BODY$
  LANGUAGE plpgsql
  COST 100;

  
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Produzione mangimi','AIA','E2','Macinazione','Polveri tot. - Umidità','Filtri a maniche');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Produzione mangimi','AIA','E1','Scarico silos integratori','Polveri tot. - Umidità','Filtro a maniche');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Sinterizzazione metalli duri','AIA','E2','Presinterizzazione','Polveri, cobalto','Vasche di condensazione sui forni per il recupero dei vapori organici');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Sinterizzazione metalli duri','AIA','E3','Presinterizzazione','Polveri, cobalto','Vasche di condensazione sui forni per il recupero dei vapori organici');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Stampaggio plastica settore automotive','AUA','E4','Impianto di aspirazione pressa linea 1','Polveri totali, SOV, Aldeidi, Fenoli','Non previsto');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Stampaggio plastica settore automotive','AUA','E9','Impianto di aspirazione pressa linea 4','Polveri totali, SOV, Aldeidi, Fenoli','Non previsto');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Fonderia di alluminio e magnesio','AUA','C1','Finitura - Sabbiatura a camera','Polveri','Filtro a maniche');
insert into fasi_lavorazione(tipo_quadro, tipo_impianto, punti_emissione, fasi_lavorazione, inquinanti, impianti_abbattimento) values (
'Fonderia di alluminio e magnesio','AUA','C2','Finitura - Granigliatura','Polveri','Filtro a cartucce');


