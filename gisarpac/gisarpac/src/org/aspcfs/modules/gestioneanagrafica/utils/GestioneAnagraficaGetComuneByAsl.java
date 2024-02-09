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

public class GestioneAnagraficaGetComuneByAsl extends CFSModule{
	
	public String executeCommandSearch(ActionContext context) throws IOException{
		
		String output = "[]";
		String idAsl = context.getRequest().getParameter("idAsl");
		
		String sql = "select (concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json)::text as comune from( "
				+ "select id, cod_comune, cod_regione, nome, istat, cap, cod_nazione, codiceistatasl as asl "
				+ "from comuni1 where trim(codiceistatasl) = ? "
				+ ") tab";

		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setString(1, idAsl);
			ResultSet rs= pst.executeQuery();
			
			while(rs.next())
			{
				output = rs.getString("comune");		 
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
