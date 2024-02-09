package org.aspcfs.utils.ws;


import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.utils.GeoCoder;
import org.aspcfs.utils.GestoreConnessioni;

import com.darkhorseventures.framework.actions.ActionContext;
import com.google.gson.Gson;


public class Getcoordinate extends CFSModule{

	public String executeCommandSearch(ActionContext context) throws Exception {
		
		Gson gson = new Gson();
	      String json = "";

		String indirizzo = getString(context ,"indirizzo");
		String citta = getString(context, "citta");
		String provincia = getString(context, "provincia");
		String cap = getString(context, "cap");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if( 	((indirizzo == null) || (indirizzo.trim().length() == 0)) &&
				((citta == null) || (citta.trim().length() == 0)) &&
				((provincia == null) || (provincia.trim().length() == 0)) &&
				((cap == null) || (cap.trim().length() == 0)) )
			
					{
			            map.put("status", "OK");
						map.put("lat", "");
						map.put("long", "");
					}
		else
		{
			GeoCoder geo = new GeoCoder();
			String[] temp = geo.getCoords( indirizzo, citta, provincia );
			if( temp[2].equalsIgnoreCase("e"))
			{
				map.put("status", "KO");
			}
			else
			{
			    if (temp[0].equals("0.0") && temp[1].equals("0.0") ){
	                temp = GetCoordinateFromDb(temp, indirizzo, citta, provincia);
	                }
			    
				map.put("status", "OK");
				map.put("long", temp[0]);
				map.put("lat", temp[1]);		
				
			}
		}
		
		
		json = gson.toJson(map);
		PrintWriter writer = context.getResponse().getWriter();
		writer.print(json);
		writer.close();
		
		return "";
	}

	
	   protected String getString(ActionContext context, String paramName )
	    {
	        String temp = context.getRequest().getParameter( paramName );
	        return (temp == null) ? (temp) : (temp.trim());
	    }
	   
	   
	    private String[] GetCoordinateFromDb(String[] temp, String indirizzo, String citta, String provincia) {

	        String[] res = temp;
	        
	        Connection conn = null;
	        try
	        {
	            conn = GestoreConnessioni.getConnection(); 
	            if (conn != null)
	            {
	                
	                String sql = "select count(latitudine||';'||longitudine), latitudine, longitudine from indirizzi where 1=1 ";
	                        
	                        if (!citta.equals(""))
	                            sql+=" and comune in (select id from comuni1 where nome ilike ?) ";
	                        
	                        sql+=" and latitudine > 0 and longitudine > 0 group by latitudine, longitudine order by count(latitudine||';'||longitudine) desc limit 1";

	                PreparedStatement pst = conn.prepareStatement(sql);
	                int i = 0;
	                if (!citta.equals(""))
	                    pst.setString(++i, "%"+citta+"%");
	                System.out.println("GET COORDS ULTIMA SPIAGGIA: Cerco sul db "+pst.toString());
	                ResultSet rs = pst.executeQuery();
	                if (rs.next()){
	                    res[1] = rs.getString("latitudine");
	                    res[0] = rs.getString("longitudine");
	                }
	                
	            }
	            
	        }catch(Exception e)
	        {           
	            e.printStackTrace();
	        }
	        finally
	        {
	            if( conn != null )
	            {
	                GestoreConnessioni.freeConnection(conn);
	                conn = null;
	            }
	        }
	        
	        
	        return res;
	        
	    }
}
