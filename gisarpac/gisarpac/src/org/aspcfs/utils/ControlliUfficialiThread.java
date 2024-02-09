package org.aspcfs.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ControlliUfficialiThread  {
  

    public void refreshNucleo(int idControllo,Connection db) {
    	
    	try
    	{
    	PreparedStatement pst =  db.prepareStatement("select * from public.refresh_nucleo_ispettivo(?)");
    	pst.setInt(1, idControllo);
    	pst.execute();
    	}
    	catch(SQLException e)
    	{
    		
    	}
    	
    }
}