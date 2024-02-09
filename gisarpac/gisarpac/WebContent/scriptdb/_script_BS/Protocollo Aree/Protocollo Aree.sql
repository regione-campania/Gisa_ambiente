
CREATE TABLE IF NOT EXISTS public.aree_verbali_protocolli
(
    id SERIAL,
    id_area integer,
    tipo_verbale text COLLATE pg_catalog."default",
    anno_protocollo integer,
    id_documento integer,
    numero_protocollo integer,
    data_protocollo text COLLATE pg_catalog."default",
    esito text COLLATE pg_catalog."default",
    fault_string text COLLATE pg_catalog."default",
    enteredby integer,
    entered timestamp without time zone DEFAULT 'now()',
    trashed_date timestamp without time zone,
    note_hd text COLLATE pg_catalog."default",
    base64file text COLLATE pg_catalog."default",
    cf_rappresentante text COLLATE pg_catalog."default",
    CONSTRAINT aree_verbali_protocolli_pkey PRIMARY KEY (id)
);


CREATE OR REPLACE FUNCTION public.aggiorna_aree_verbali_protocolli(
	_idarea integer,
	_tipoverbale text,
	_id_documento integer,
	_numero_protocollo integer,
	_anno_protocollo integer,
	_data_protocollo text,
	_esito text,
	_faultstring text,
	_base64file text,
	user_id integer)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE STRICT PARALLEL UNSAFE
AS $BODY$

DECLARE

_cf_rappresentante text;
	
BEGIN

_cf_rappresentante := '-ASSENTE-';

insert into aree_verbali_protocolli (id_area, tipo_verbale, id_documento, cf_rappresentante, numero_protocollo, anno_protocollo, data_protocollo, esito, fault_string, base64file, enteredby) values (
_idarea, _tipoverbale, _id_documento, _cf_rappresentante, _numero_protocollo, _anno_protocollo, _data_protocollo, _esito, _faultstring, _base64file, user_id);

 RETURN 'OK';
 END;
$BODY$;

CREATE OR REPLACE FUNCTION public.get_aree_protocolli(
	_idarea integer,
	_tipoverbale text)
    RETURNS TABLE(anno_protocollo integer, numero_protocollo integer, tipo_verbale text, data_protocollo text, id_documento integer, base64file text, id_area integer) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

select 	anno_protocollo , numero_protocollo , tipo_verbale , data_protocollo , id_documento, base64file , id_area      
	from aree_verbali_protocolli 

					where id_area = _idarea and tipo_verbale = _tipoverbale and trashed_date is null order by entered desc;
    
$BODY$;





select * from get_aree_protocolli(56, 'VerbaleMancatoCampionamentoSuolo');