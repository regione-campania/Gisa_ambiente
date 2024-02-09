-- Svuotare le tabelle (svuotaTutto), verificare che import_aia sia popolato

select * from import_aia();

-- verifiche

select * from log_import_aia ;

select * from log_import_aia where output <0;

select * from log_import_aia where output > 0 and output not in (select id_stabilimento from opu_relazione_stabilimento_linee_produttive) ;

select * from opu_relazione_stabilimento_linee_produttive where id_linea_produttiva = -999;
