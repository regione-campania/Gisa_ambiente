package org.aspcfs.utils;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

public class ConvertRsToHash {
    public static List<Object> resultSetToHashMapLookup(ResultSet rs) throws SQLException
    	{
    		ResultSetMetaData md = rs.getMetaData();
    		int columns = md.getColumnCount();//int size =rs.size(); 
    	  
    		ArrayList listRecord = new ArrayList<>();
    			
    			  while (rs.next())
    			  {
    				  HashMap row = new LinkedHashMap(columns);
    				  	for(int i=1; i<=columns; ++i)
    				  	{           
    				  		row.put(md.getColumnName(i),rs.getObject(i));
    				
    				  	}	
    				  	listRecord.add(row);
    			  }
    			    
    		  		
    		return listRecord;
    	}
    
}

