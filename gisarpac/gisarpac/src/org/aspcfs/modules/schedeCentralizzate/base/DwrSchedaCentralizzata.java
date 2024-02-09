package org.aspcfs.modules.schedeCentralizzate.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;

import org.aspcfs.controller.SystemStatus;
import org.aspcfs.utils.GestoreConnessioni;
import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;
import org.directwebremoting.extend.LoginRequiredException;

import com.darkhorseventures.database.ConnectionElement;

public class DwrSchedaCentralizzata { 
	
	public static String provaQuery(String campo, String origine, String condizione, String id) throws SQLException
	{
		
		
		Connection db = null ;
		WebContext ctx = WebContextFactory.get();
		ConnectionElement ce = (ConnectionElement) ctx.getSession().getAttribute("ConnectionElement");
		SystemStatus systemStatus = (SystemStatus) ((Hashtable) ctx.getServletContext().getAttribute("SystemStatus")).get(ce.getUrl());
		HttpServletRequest req = ctx.getHttpServletRequest();
	
		String ris = "";
		try {
			db = GestoreConnessioni.getConnection();
			String query = "SELECT "+campo+" FROM "+origine+" WHERE "+condizione;
			query = query.replaceAll("#orgid#", id);
			query = query.replaceAll("#stabid#", id);
			query = query.replaceAll("#altid#", id);
			query = query.replaceAll("#idcampoesteso#", id);

			PreparedStatement pst = null ;
			ResultSet rs = null ;
			pst = db.prepareStatement(query);
			rs = pst.executeQuery();

			while (rs.next())
			{
				ris += rs.getString(1) + "\n";
			}		
			return ris;
			
		}catch(LoginRequiredException e)
		{
			throw e;
		} catch (SQLException e) {
			throw e ;
		}
		catch (NumberFormatException g) {
			throw g ;
		}	
		finally
		{
			GestoreConnessioni.freeConnection(db);
		}
	}
	
	public static int getTipoSchedaFromTipoOperatore(int id) throws SQLException
	{
		
		
		Connection db = null ;
		WebContext ctx = WebContextFactory.get();
		ConnectionElement ce = (ConnectionElement) ctx.getSession().getAttribute("ConnectionElement");
		SystemStatus systemStatus = (SystemStatus) ((Hashtable) ctx.getServletContext().getAttribute("SystemStatus")).get(ce.getUrl());
		HttpServletRequest req = ctx.getHttpServletRequest();
	
		int ris = 1;
		try {
			db = GestoreConnessioni.getConnection();
			String query = "SELECT scheda_code from mapping_lookup_tipologia_scheda_operatore where tipo_code = ? ";
			PreparedStatement pst = null ;
			ResultSet rs = null ;
			pst = db.prepareStatement(query);
			pst.setInt(1, id);
			rs = pst.executeQuery();

			while (rs.next())
			{
				ris = rs.getInt("scheda_code");
			}		
			return ris;
			
		} catch (SQLException e) {
			throw e ;
		}
		catch (NumberFormatException g) {
			throw g ;
		}	
		finally
		{
			GestoreConnessioni.freeConnection(db);
		}
	}
}


