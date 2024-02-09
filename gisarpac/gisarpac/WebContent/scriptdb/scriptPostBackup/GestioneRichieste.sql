insert into permission_category(category, description, level, enabled, active, constant) values ('Gestione Flussi', 'Gestione Flussi e relativi moduli', 1, true, true, 1);

insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints) values (
(select category_id from permission_category where category = 'Gestione Flussi'), 
'devdoc', 
't', 
'f', 
't', 
't', 
'Abilita la Gestione Flussi', 
'0', 
't', 
't', 
'f');
insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints) values (
(select category_id from permission_category where category = 'Gestione Flussi'), 
'devdoc-priorita', 
't', 
'f', 
'f', 
'f', 
'Abilita la modifica alla priorità di un flusso', 
'0', 
't', 
't', 
'f');
insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints) values (
(select category_id from permission_category where category = 'Gestione Flussi'), 
'devdoc-mod-a', 
't', 
't', 
'f', 
'f', 
'Abilita vista/inserimento modulo A', 
'0', 
't', 
't', 
'f');
insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints) values (
(select category_id from permission_category where category = 'Gestione Flussi'), 
'devdoc-mod-b', 
't', 
't', 
'f', 
'f', 
'Abilita vista/inserimento modulo B', 
'0', 
't', 
't', 
'f');
insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints) values (
(select category_id from permission_category where category = 'Gestione Flussi'), 
'devdoc-mod-c', 
't', 
't', 
'f', 
'f', 
'Abilita vista/inserimento modulo C', 
'0', 
't', 
't', 
'f');
insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints) values (
(select category_id from permission_category where category = 'Gestione Flussi'), 
'devdoc-mod-ch', 
't', 
't', 
'f', 
'f', 
'Abilita vista/inserimento modulo CH', 
'0', 
't', 
't', 
'f');
insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints) values (
(select category_id from permission_category where category = 'Gestione Flussi'), 
'devdoc-mod-d', 
't', 
't', 
'f', 
'f', 
'Abilita vista/inserimento modulo D', 
'0', 
't', 
't', 
'f');
insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints) values (
(select category_id from permission_category where category = 'Gestione Flussi'), 
'devdoc-mod-vce', 
't', 
't', 
'f', 
'f', 
'Abilita vista/inserimento modulo VCE', 
'0', 
't', 
't', 
'f');




insert into role_permission (role_id, permission_id, role_view, role_add, role_delete) 
select 1, permission_id, true, true, true from permission where permission ilike 'devdoc%';


insert into role_permission (role_id, permission_id, role_view, role_add, role_delete) 
select 32, permission_id, true, true, true from permission where permission ilike 'devdoc%';





CREATE TABLE lookup_tipo_modulo_sviluppo (code serial primary key, description text, default_item boolean, level integer, enabled boolean default true);

insert into lookup_tipo_modulo_sviluppo values (1,'B - Requisiti',false,0,true);
insert into lookup_tipo_modulo_sviluppo values (2,'C - Proposte implementazioni',false,0,true);
insert into lookup_tipo_modulo_sviluppo values (3,'D - Affidamenti',false,0,true);
insert into lookup_tipo_modulo_sviluppo values (4,'CH - Chiarimenti',false,0,true);
insert into lookup_tipo_modulo_sviluppo values (5,'A - Richieste Regionali',false,0,true);
insert into lookup_tipo_modulo_sviluppo values (6,'VCE - Validazione Collaudo Esterno',false,0,true);
insert into lookup_tipo_modulo_sviluppo values (7,'AL - Allegati (Generici)',false,0,true);

-- Table: public.sviluppo_flussi

-- DROP TABLE public.sviluppo_flussi;

CREATE TABLE public.sviluppo_flussi
(
  id SERIAL primary key,
  id_flusso integer,
  data timestamp without time zone DEFAULT now(),
  descrizione text,
  tags text,
  data_cancellazione timestamp without time zone,
  data_consegna timestamp without time zone,
  note_consegna text,
  id_utente_consegna integer,
  data_ultima_modifica timestamp without time zone,
  data_standby timestamp without time zone,
  id_utente_standby integer,
  note_standby text,
  data_annullamento timestamp without time zone,
  id_utente_annullamento integer,
  note_annullamento text,
  id_priorita integer DEFAULT 1,
  note_aggiornamenti_priorita text,
  note_hd text)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.sviluppo_flussi
  OWNER TO postgres;

-- Function: public.log_operazioni_flusso()

-- DROP FUNCTION public.log_operazioni_flusso();

CREATE OR REPLACE FUNCTION public.log_operazioni_flusso()
  RETURNS trigger AS
$BODY$
declare
	nuova_nota text := '';
begin
	
	if old.data_consegna is null and new.data_consegna is not null then -- si sta consegnando (chiudendo) un flusso
		nuova_nota := format(E'DATA: %s - OPERAZIONE: consegna - UTENTE: %s\n', now(), new.id_utente_consegna);
		new.note_hd := concat(nuova_nota, old.note_hd);
	elsif old.data_consegna is not null and new.data_consegna is null then -- si sta riaprendo un flusso da consegna
		nuova_nota := format(E'DATA: %s - OPERAZIONE: riapertura da consegna - UTENTE: %s\n', now(), new.id_utente_consegna);
		new.note_hd := concat(nuova_nota, old.note_hd);
	end if;
	
	if old.data_standby is null and new.data_standby is not null then -- si sta mettendo in standby un flusso
		nuova_nota := format(E'DATA: %s - OPERAZIONE: standby - UTENTE: %s\n', now(), new.id_utente_standby);
		new.note_hd := concat(nuova_nota, old.note_hd);
	elsif old.data_standby is not null and new.data_standby is null then -- si sta riaprendo un flusso da standby
		nuova_nota := format(E'DATA: %s - OPERAZIONE: riapertura da standby - UTENTE: %s\n', now(), new.id_utente_standby);
		new.note_hd := concat(nuova_nota, old.note_hd);
	end if;
	
	if old.data_annullamento is null and new.data_annullamento is not null then -- si sta annullando un flusso
		nuova_nota := format(E'DATA: %s - OPERAZIONE: annullamento - UTENTE: %s\n', now(), new.id_utente_annullamento);
		new.note_hd := concat(nuova_nota, old.note_hd);
	elsif old.data_annullamento is not null and new.data_annullamento is null then -- si sta riaprendo un flusso da annullamento
		nuova_nota := format(E'DATA: %s - OPERAZIONE: riapertura da annullamento - UTENTE: %s\n', now(), new.id_utente_annullamento);
		new.note_hd := concat(nuova_nota, old.note_hd);
	end if;
	
	return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.log_operazioni_flusso()
  OWNER TO postgres;


  -- DROP TRIGGER log_operazioni_flusso ON public.sviluppo_flussi;

CREATE TRIGGER log_operazioni_flusso
  BEFORE UPDATE
  ON public.sviluppo_flussi
  FOR EACH ROW
  EXECUTE PROCEDURE public.log_operazioni_flusso();




-- Trigger: log_operazioni_flusso on public.sviluppo_flussi




-- Table: public.sviluppo_moduli

-- DROP TABLE public.sviluppo_moduli;

CREATE TABLE public.sviluppo_moduli
(
id SERIAL primary key,
  id_tipo integer NOT NULL,
  id_flusso integer NOT NULL,
  data timestamp without time zone DEFAULT now(),
  id_utente integer,
  data_cancellazione timestamp without time zone,
  non_disponibile boolean
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.sviluppo_moduli
  OWNER TO postgres;


-- Table: public.sviluppo_moduli_note

-- DROP TABLE public.sviluppo_moduli_note;

CREATE TABLE public.sviluppo_moduli_note
(
id SERIAL primary key,
  note text,
  id_modulo integer,
  id_utente integer,
  data_inserimento timestamp without time zone DEFAULT now(),
  data_cancellazione timestamp without time zone
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.sviluppo_moduli_note
  OWNER TO postgres;


-- Table: public.sviluppo_note_flusso

-- DROP TABLE public.sviluppo_note_flusso;

CREATE TABLE public.sviluppo_note_flusso
(
id SERIAL primary key,
  nota text,
  id_flusso integer,
  id_utente integer,
  data_inserimento timestamp without time zone DEFAULT now(),
  data_cancellazione timestamp without time zone
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.sviluppo_note_flusso
  OWNER TO postgres;

CREATE TABLE lookup_priorita_flusso (code integer, description text, default_item boolean default false, level integer, enabled boolean default true);

insert into lookup_priorita_flusso (code, description, level, enabled) values (1, 'Non Definita', 0, true);
insert into lookup_priorita_flusso (code, description, level, enabled) values (2, 'Bassa', 1, true);
insert into lookup_priorita_flusso (code, description, level, enabled) values (3, 'Media', 2, true);
insert into lookup_priorita_flusso (code, description, level, enabled) values (4, 'Alta', 3, true);

insert into permission_category(category, description, level, enabled, active, constant) values ('Gestione Server Documentale', 'Gestione Server Documentale', 1, true, true, 1);

insert into permission(category_id, permission, permission_view, permission_add, permission_edit, permission_delete, description, level, enabled, active, viewpoints) values (
(select category_id from permission_category where category = 'Gestione Server Documentale'), 
'documentale_documents',
true, true, true, true,
'Gestione Allegati (Cavalieri) Visualizza e gestisci documenti allegati.',
0, true, true, false);

insert into role_permission (role_id, permission_id, role_view, role_add, role_edit, role_delete) 
select 1, permission_id, true, true, true, true from permission where permission ilike 'documentale_documents';

insert into role_permission (role_id, permission_id, role_view, role_add,role_edit,  role_delete) 
select 32, permission_id, true, true, true, true from permission where permission ilike 'documentale_documents';