ALTER TABLE saved_criterialist ADD COLUMN  source int DEFAULT -1;
update saved_criterialist set source = contact_source;
alter table saved_criterialist drop contact_source;
