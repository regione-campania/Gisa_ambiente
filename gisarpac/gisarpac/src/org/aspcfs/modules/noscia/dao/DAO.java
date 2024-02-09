package org.aspcfs.modules.noscia.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

public interface DAO 
{
	//Lista tutti i records che soddisfano i filtri impostati nel dao
	//Miglioramenti: si puo' studiare qualcosa per impostare in automatico tutti i parametri della query senza scriverli sempre a mano
	public ArrayList<?> getItems( Connection connection ) throws SQLException;
	
	//Restituisce il primo record della lista se esiste, null altrimenti
	//Da usare quando si effettuano ricerche per chiave primaria che possono restituire un solo valore
	public Object getItem( Connection connection ) throws SQLException;
	
	
}
