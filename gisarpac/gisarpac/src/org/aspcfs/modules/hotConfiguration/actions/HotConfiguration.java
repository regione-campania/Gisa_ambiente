package org.aspcfs.modules.hotConfiguration.actions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.logging.Logger;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.util.imports.ApplicationProperties;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;


public final class HotConfiguration extends CFSModule 
{
	
	Logger logger = Logger.getLogger("MainLogger");
	
	public String executeCommandDefault( ActionContext context )
	{
		return executeCommandDashboard(context);
	}
	
	public String executeCommandDashboard(ActionContext context) {
		
		 if (!hasPermission(context, "accounts-dashboard-view")) {
			 if (!hasPermission(context, "hot-configuration-view")) {
		        return ("PermissionError");
		     }
		 } 
		 
		 return "ConfigOK";
		  
	}
	
	public String executeCommandDashboardNew(ActionContext context) throws JSONException {

		if (!hasPermission(context, "accounts-dashboard-view")) {
			if (!hasPermission(context, "hot-configuration-view")) {
				return ("PermissionError");
			}
		}

		JSONArray jsonProperties = new JSONArray();

		InputStream is = ApplicationProperties.class.getResourceAsStream(ApplicationProperties.getFileProperties());

		BufferedReader reader;
		try {
			reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
			String line = "";

			while (line != null) {
				line = reader.readLine();
				
				if (line!= null){
					line = line.trim();
				
					String tipo = "";
					String chiave = "";
					String valore = "";
	
					if (line.length() > 0) {
						if (line.startsWith("##")) { // capitolo
							tipo = "capitolo";
							chiave = line.replaceAll("#", "").trim();
						} else if (!line.startsWith("#") && line.contains("=")) { // parametro
							tipo = "parametro";
							chiave = line.substring(0, line.indexOf("=")).trim();
							valore = ApplicationProperties.getProperty(chiave).trim();
						}
						
						if (!"".equals(tipo)){
							JSONObject json = new JSONObject();
							json.put("tipo", tipo);
							json.put("chiave", chiave);
							json.put("valore", valore);
							jsonProperties.put(json);
						}
					}
				}
			}
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	
		context.getRequest().setAttribute("jsonProperties", jsonProperties);
		return "ConfigNewOK";

	}
	
	public String executeCommandConfig(ActionContext context) {
		
		 if (!hasPermission(context, "accounts-dashboard-view")) {
			 if (!hasPermission(context, "hot-configuration-view")) {
		        return ("PermissionError");
		     }
		 } 
		 
		 logger.info("Invocata la Configurazione a caldo");
			
			try{
			
				for(Object chiave : ApplicationProperties.getApplicationProperties().keySet()){
					ApplicationProperties.getApplicationProperties().setProperty(chiave.toString().trim(), context.getRequest().getParameter(chiave.toString().trim()) );
				}
				
				logger.info("Riconfigurazione a caldo avvenuta con successo");
				context.getRequest().setAttribute("configMessage", "Configurazione a caldo avvenuta con successo");
				
			}
			catch (Exception e) {
				logger.severe("Errore nella Configurazione a caldo");
				context.getRequest().setAttribute("configMessage", "Errore durante la Configurazione a caldo");
			}
		 
		 return "ConfigOK";
		  
	}

}