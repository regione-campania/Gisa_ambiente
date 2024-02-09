package org.aspcfs.modules.hotConfiguration.actions;

import java.util.logging.Logger;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.util.imports.ApplicationProperties;

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