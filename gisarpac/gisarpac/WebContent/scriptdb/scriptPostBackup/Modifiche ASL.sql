update lookup_site_id  set description = 'Dipartimento Provinciale di Napoli' where code in (205, 206);
update lookup_site_id set description = '--TUTTI I DIPARTIMENTI--' where code = -1;
