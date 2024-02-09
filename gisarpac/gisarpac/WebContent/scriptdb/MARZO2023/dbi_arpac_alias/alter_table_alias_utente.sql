-- Column: public.access_.alias_utente

-- ALTER TABLE IF EXISTS public.access_ DROP COLUMN IF EXISTS alias_utente;

ALTER TABLE IF EXISTS public.access_
    ADD COLUMN alias_utente character varying(80) COLLATE pg_catalog."default";