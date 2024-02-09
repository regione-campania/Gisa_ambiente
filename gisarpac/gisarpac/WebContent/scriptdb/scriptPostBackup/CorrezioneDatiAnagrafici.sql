delete from schema_anagrafica where id_gruppo_template in (select id from gruppi_template_no_scia where html_label = 'DATI AUTORIZZAZIONE');

delete from gruppi_template_no_scia where html_label = 'DATI AUTORIZZAZIONE';

delete from configuratore_template_no_scia where id in (271, 272, 273, 274, 275, 276, 277);
