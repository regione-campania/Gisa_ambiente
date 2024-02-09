update gruppi_template_no_scia set html_label = replace(html_label, 'STABILIMENTO', 'IMPIANTO') where html_label ilike '%stabilimento%';
