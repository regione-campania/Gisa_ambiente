-- Aggiungere nei parametri server.xml di gisa il maxHttpHeaderSize (potrebbe non servire)
<Connector connectionTimeout="20000" port="8070" protocol="HTTP/1.1" redirectPort="8443"  maxHttpHeaderSize="1000000"/>

CREATE TABLE fascicoli_protocolli(
id serial primary key,
id_fascicolo integer,
anno_protocollo integer,
numero_protocollo integer,
enteredby integer,
entered timestamp without time zone default now(),
trashed_date timestamp without time zone,
note_hd text);

CREATE TABLE controlli_ufficiali_verbali_protocolli(
id serial primary key,
id_controllo_ufficiale integer,
tipo_verbale text,
anno_protocollo integer,
id_documento integer,
numero_protocollo integer,
data_protocollo text,
esito text,
fault_string text,
enteredby integer,
entered timestamp without time zone default now(),
trashed_date timestamp without time zone,
note_hd text,
base64file text);

CREATE TABLE campioni_verbali_protocolli(
id serial primary key,
id_campione integer,
tipo_verbale text,
anno_protocollo integer,
id_documento integer,
numero_protocollo integer,
data_protocollo text,
esito text,
fault_string text,
enteredby integer,
entered timestamp without time zone default now(),
trashed_date timestamp without time zone,
note_hd text,
base64file text);


CREATE OR REPLACE FUNCTION public.get_fascicoli_protocolli(IN _idfascicolo integer)
  RETURNS TABLE(anno_protocollo integer, numero_protocollo integer, id_fascicolo integer) AS
$BODY$
select 	anno_protocollo , numero_protocollo ,  id_fascicolo      
	from fascicoli_protocolli 

					where id_fascicolo = _idfascicolo and trashed_date is null order by entered desc limit 1;
    
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION public.get_controlli_ufficiali_protocolli(IN _idcu integer, _tipoverbale text)
  RETURNS TABLE(anno_protocollo integer, numero_protocollo integer, tipo_verbale text, data_protocollo text, id_documento integer, base64file text, id_controllo_ufficiale integer) AS
$BODY$
select 	anno_protocollo , numero_protocollo , tipo_verbale , data_protocollo , id_documento, base64file , id_controllo_ufficiale      
	from controlli_ufficiali_verbali_protocolli 

					where id_controllo_ufficiale = _idcu and tipo_verbale = _tipoverbale and trashed_date is null order by entered desc limit 1;
    
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;

  


CREATE OR REPLACE FUNCTION public.get_campioni_protocolli(
    IN _idcampione integer,
    IN _tipoverbale text)
  RETURNS TABLE(anno_protocollo integer, numero_protocollo integer, tipo_verbale text, data_protocollo text, id_documento integer, base64file text, id_campione integer) AS
$BODY$
select 	anno_protocollo , numero_protocollo , tipo_verbale , data_protocollo , id_documento, base64file , id_campione      
	from campioni_verbali_protocolli 

					where id_campione = _idcampione and tipo_verbale = _tipoverbale and trashed_date is null order by entered desc limit 1;
    
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;


  DROP FUNCTION public.get_chiamata_ws_sicra_inserisci_protocollo_e_anagrafiche(_idcu integer, _file text, _oggetto text, _nomeallegato text, _tipofile text, _tipoverbale text);

CREATE OR REPLACE  FUNCTION public.get_chiamata_ws_sicra_inserisci_protocollo_e_anagrafiche(_entita text, _file text, _oggetto text, _nomeallegato text, _tipofile text, _tipoverbale text)
  RETURNS text AS
$BODY$
DECLARE
	ret text;
	_cognomenome text;
	_commento text;
BEGIN

_cognomenome := 'GISA';
_commento := 'Documento caricato per verbale: '||_tipoverbale||' su ' ||_entita;

select 
concat('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
 <soapenv:Header/>
   <soapenv:Body>
 <tem:InserisciProtocolloEAnagrafiche>
 <tem:ProtoIn>
   <tem:TipoDocumento>', _tipoverbale, '</tem:TipoDocumento>
   <tem:Oggetto>', _oggetto, '</tem:Oggetto>
   <tem:Origine>A</tem:Origine>
   <tem:MittentiDestinatari>
   <tem:item>
   <tem:CognomeNome>', _cognomenome, '</tem:CognomeNome>
   </tem:item>
   </tem:MittentiDestinatari>
   <tem:AggiornaAnagrafiche>N</tem:AggiornaAnagrafiche>
   <tem:Allegati>
   <tem:item>
   <tem:TipoFile>', _tipofile, '</tem:TipoFile>
   <tem:Image>', _file, '</tem:Image>
   <tem:Commento>', _commento, '</tem:Commento>
   <tem:NomeAllegato>', _nomeallegato, '</tem:NomeAllegato>
   </tem:item>
   </tem:Allegati>
   </tem:ProtoIn>
   </tem:InserisciProtocolloEAnagrafiche>
   </soapenv:Body>
</soapenv:Envelope>') into ret;


 RETURN ret;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;

  
   

CREATE OR REPLACE  FUNCTION public.get_chiamata_ws_sicra_leggi_protocollo(_anno integer, _numero integer)
  RETURNS text AS
$BODY$
DECLARE
	ret text;	
BEGIN


select 
concat('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:LeggiProtocollo>
         <tem:AnnoProtocollo>', _anno, '</tem:AnnoProtocollo>
         <tem:NumeroProtocollo>', _numero, '</tem:NumeroProtocollo>
      </tem:LeggiProtocollo>
   </soapenv:Body>
</soapenv:Envelope>') into ret;


 RETURN ret;
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;

 CREATE OR REPLACE FUNCTION public.aggiorna_controlli_ufficiali_verbali_protocolli(_idcu integer, _tipoverbale text, _id_documento integer, _numero_protocollo integer, _anno_protocollo integer, _data_protocollo text, _esito text, _faultstring text, _base64file text, user_id integer)
  RETURNS text AS
$BODY$
DECLARE
	
BEGIN

insert into controlli_ufficiali_verbali_protocolli (id_controllo_ufficiale, tipo_verbale, id_documento, numero_protocollo, anno_protocollo, data_protocollo, esito, fault_string, base64file, enteredby) values (
_idcu, _tipoverbale, _id_documento, _numero_protocollo, _anno_protocollo, _data_protocollo, _esito, _faultstring, _base64file, user_id);


 RETURN 'OK';
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
  
   CREATE OR REPLACE FUNCTION public.aggiorna_campioni_verbali_protocolli(_idcampione integer, _tipoverbale text, _id_documento integer, _numero_protocollo integer, _anno_protocollo integer, _data_protocollo text, _esito text, _faultstring text, _base64file text, user_id integer)
  RETURNS text AS
$BODY$
DECLARE
	
BEGIN

insert into campioni_verbali_protocolli (id_campione, tipo_verbale, id_documento, numero_protocollo, anno_protocollo, data_protocollo, esito, fault_string, base64file, enteredby) values (
_idcampione, _tipoverbale, _id_documento, _numero_protocollo, _anno_protocollo, _data_protocollo, _esito, _faultstring, _base64file, user_id);


 RETURN 'OK';
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;

  
 

  
  


  



  

