ALTER TABLE public.lookup_stato_lab ADD note_hd text NULL;
UPDATE public.lookup_stato_lab
SET description='SOSPESA', default_item=false, "level"=2, enabled=true, gins=NULL, desc_gins=NULL, note_hd='Conferimenti sospesi dal 2011 - AIA non rinnovata'
WHERE code=101;