package org.aspcfs.utils.ws;

import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneanagrafica.base.Aggregazione;
import org.aspcfs.modules.noscia.dao.AggregazioneDAO;

import com.darkhorseventures.framework.actions.ActionContext;
import com.google.gson.Gson;

public class Getaggregazionebymacroarea extends CFSModule{

	public String executeCommandSearch(ActionContext context) throws Exception {
		
		Gson gson = new Gson();
		String json = "";
		Connection db = null;
		Map<String, Object> map = new HashMap<String, Object>();
	    Map<String, String[]>  parameterMap = context.getRequest().getParameterMap();
	    String codiceAtt = context.getRequest().getParameter("codice_attivita");
	    System.out.println("Codice Attivita: "+codiceAtt);
	    
	    
		Aggregazione aggregazione = new Aggregazione(parameterMap);
		ArrayList<Aggregazione> aggregazioni = new ArrayList<>();
		
		  try {
		         db = this.getConnection(context);
		         AggregazioneDAO aggregazioneDao = new AggregazioneDAO(getInteger(context,"tipoAttivita"), aggregazione);
		         
		         if (codiceAtt != null)
		         {
		             aggregazioni = aggregazioneDao.getItemsCodAtt(db);
		         }
		         else
		         {
		             aggregazioni = aggregazioneDao.getItems(db);
		         }
		         
		         
		    } catch (Exception errorMessage) {
		        context.getRequest().setAttribute("Error", errorMessage);
		        return ("SystemError");
		      } finally {
		        this.freeConnection(context, db);
		      }
		    
	
		if(aggregazioni.size()>0)
		{
			map.put("status", "OK");
			map.put("aggregazioni", aggregazioni);
		}
		else
		{
			map.put("status", "KO");
		}
		
		json = gson.toJson(map);
		PrintWriter writer = context.getResponse().getWriter();
		writer.print(json);
		writer.close();
		
		 return "";
		
	}
	
	
	   protected int getInteger( ActionContext context,String paramName )
	    {
	        int ret = -1;
	        String temp = context.getRequest().getParameter( paramName );
	        try
	        {
	            ret = Integer.parseInt( temp );
	        }
	        catch (Exception e)
	        {
	            e.printStackTrace();
	        }
	        return ret;
	    }
	
}
