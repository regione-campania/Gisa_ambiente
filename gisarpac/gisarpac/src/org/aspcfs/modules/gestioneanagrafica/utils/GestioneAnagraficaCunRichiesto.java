package org.aspcfs.modules.gestioneanagrafica.utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.utils.GestoreConnessioni;
import org.directwebremoting.extend.LoginRequiredException;

import com.darkhorseventures.framework.actions.ActionContext;

public class GestioneAnagraficaCunRichiesto extends CFSModule{
	
		public String executeCommandSearch(ActionContext context) throws IOException{
				
			String output = "{}";
			int codiceLinea = Integer.parseInt(context.getRequest().getParameter("codiceLinea"));
			
			
			String sql = "select (string_agg(row_to_json(tab)::text, ',')::json)::text as esito from("
					+ "select cun_obbligatorio::text from public.get_codice_richiesto_ml8(?) cun_obbligatorio) tab";
		
			Connection db = null;
			try{
				db = GestoreConnessioni.getConnection();
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setInt(1, codiceLinea);
				ResultSet rs= pst.executeQuery();
				
				while(rs.next())
				{
					output = rs.getString("esito");		 
				}
			
			}catch(LoginRequiredException e)
			{
				throw e;
			}catch(Exception e)
			{
				e.printStackTrace();		
			}
			finally
			{
				GestoreConnessioni.freeConnection(db);
			}
			
			
			PrintWriter writer = context.getResponse().getWriter();
			writer.print(output);
			writer.close();
			return "";		
		
		}

}
