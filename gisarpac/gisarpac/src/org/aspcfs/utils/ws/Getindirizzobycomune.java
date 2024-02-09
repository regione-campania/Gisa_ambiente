package org.aspcfs.utils.ws;


import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneanagrafica.base.Indirizzo;
import org.aspcfs.modules.noscia.dao.IndirizzoDAO;

import com.darkhorseventures.framework.actions.ActionContext;
import com.google.gson.Gson;

public class Getindirizzobycomune extends CFSModule{

	public String executeCommandSearch(ActionContext context) throws Exception {
		
		Gson gson = new Gson();
		String json = "";
	    Connection db = null;
		Map<String, Object> map = new HashMap<String, Object>();
	    Map<String, String[]>  parameterMap = context.getRequest().getParameterMap();
		Indirizzo ind = new Indirizzo(parameterMap);
		ArrayList<Indirizzo> indirizzo = new ArrayList<>();
		
		try{
		    
	        db = this.getConnection(context);
	        
	        IndirizzoDAO indirizzoDAO = new IndirizzoDAO(ind);
	        indirizzo =  indirizzoDAO.getItems(db);
		
		
		} catch (Exception errorMessage) {
	        context.getRequest().setAttribute("Error", errorMessage);
	        return ("SystemError");
	      } finally {
	        this.freeConnection(context, db);
	      }
	    
		if (indirizzo.size()>0)
		{
			json = gson.toJson(indirizzo);
		}
		else
		{
			map.put("status", "KO");
			json = gson.toJson(map);
		}
		
		PrintWriter writer = context.getResponse().getWriter();
		writer.print(json);
		writer.close();
		
		return "";
		
	}

}
