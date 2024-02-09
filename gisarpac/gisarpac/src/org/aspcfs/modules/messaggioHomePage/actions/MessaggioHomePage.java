package org.aspcfs.modules.messaggioHomePage.actions;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.sql.Timestamp;
import java.util.logging.Logger;

import org.aspcfs.modules.actions.CFSModule;

import com.darkhorseventures.framework.actions.ActionContext;


public final class MessaggioHomePage extends CFSModule 
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
		 
		 BufferedReader br = null;
		 String messaggioAttuale = "";
		 try {
			String pathFile = context.getServletContext().getRealPath("templates/avviso_messaggio_urgente"+super.getSuffiso(context)+".txt");
			
			br = new BufferedReader(new FileReader(pathFile));
			StringBuilder sb = new StringBuilder();
			String line = br.readLine();

			 while (line != null) {
			        sb.append(line);
			        sb.append(System.lineSeparator());
			        line = br.readLine();
			    }
			    messaggioAttuale = sb.toString();
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			finally {
			    try {
					br.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		 
		 try {
			 String start="<h1><center><font color = 'red'>";
			 String end="</font></center></h1>";
			 int indexStart = messaggioAttuale.indexOf(start);
			 int indexEnd = messaggioAttuale.indexOf(end);
			 messaggioAttuale = messaggioAttuale.substring(indexStart+start.length(), indexEnd);
		 } catch (Exception e){}
		 
		 context.getRequest().setAttribute("messaggioAttuale", messaggioAttuale);
		 
		 
		 return "MessaggioOK";
		  
	}
	
	public String executeCommandMessaggio(ActionContext context) {
		
		 if (!hasPermission(context, "accounts-dashboard-view")) {
			 if (!hasPermission(context, "hot-configuration-view")) {
		        return ("PermissionError");
		     }
		 } 
		 
			try{
			
				String messaggio = context.getParameter("messaggio");
				
				String pathFile = context.getServletContext().getRealPath("templates/avviso_messaggio_urgente"+super.getSuffiso(context)+".txt");
				
				File f = new File(pathFile);
				
				FileOutputStream fos = new FileOutputStream(f);
				PrintStream ps = new PrintStream(fos);
				String msg = "<h1><center><font color = 'red'>"+messaggio+"</font></center></h1>" ;
				ps.print(msg);
				ps.flush();
				context.getRequest().setAttribute("mess", "Messaggio inserito con successo");

				Timestamp dataUltimaModifica = new Timestamp(System.currentTimeMillis());
				context.getServletContext().setAttribute("MessaggioHome", dataUltimaModifica+"&&"+msg);
				
			}
			catch (Exception e) {
				logger.severe("Errore nell'inserimento del messaggio nella home page");
				context.getRequest().setAttribute("mess", "Errore durante inserimento del messaggio");
			}
		 
		 return executeCommandDashboard(context);
		  
	}

}