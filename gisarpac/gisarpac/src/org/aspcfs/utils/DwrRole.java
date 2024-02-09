package org.aspcfs.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;

import org.aspcfs.controller.SystemStatus;
import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;
import org.directwebremoting.extend.LoginRequiredException;

import com.darkhorseventures.database.ConnectionElement;

public class DwrRole {

	
	public static void updareRole(int roleId,int idPermesso,String nomePermesso,boolean valuePermesso) throws SQLException
	{
		
		
		Connection db = null ;
		WebContext ctx = WebContextFactory.get();
		ConnectionElement ce = (ConnectionElement) ctx.getSession().getAttribute("ConnectionElement");
		SystemStatus systemStatus = (SystemStatus) ((Hashtable) ctx.getServletContext().getAttribute("SystemStatus")).get(ce.getUrl());
		
		HttpServletRequest req = ctx.getHttpServletRequest();
		
		String suff = (String) req.getServletContext().getAttribute("SUFFISSO_TAB_ACCESSI");
		try {
			db = GestoreConnessioni.getConnection();
			
			String sqlVer = "select * from role_permission"+suff+" where role_id = ? and permission_id = ?";
			PreparedStatement pst = null ;
			ResultSet rs = null ;
			pst = db.prepareStatement(sqlVer);
			pst.setInt(1, roleId);
			pst.setInt(2, idPermesso);
			rs = pst.executeQuery();
			if (!rs.next())
			{
				String nome_role_edit = nomePermesso ;
				String insert = "insert into role_permission"+suff+"  (role_id,permission_id,"+nome_role_edit+") values (?,?,?)";
				PreparedStatement pst2 = db.prepareStatement(insert);
				pst2.setInt(1, roleId);
				pst2.setInt(2, idPermesso);
				pst2.setBoolean(3, valuePermesso);
				pst2.execute();
			}
			else
			{
				String nome_role_edit = nomePermesso ;
				String insert = "update  role_permission"+suff+"  set "+nome_role_edit +" =? where role_id = ? and permission_id = ? ";
				PreparedStatement pst2 = db.prepareStatement(insert);
				pst2.setBoolean(1, valuePermesso);
				pst2.setInt(2, roleId);
				pst2.setInt(3, idPermesso);
				pst2.execute();
			}
			
			synchronized (systemStatus) {
				systemStatus.buildRolePermissions(db,suff);
			}
			
		} catch (SQLException e) {
			throw e ;
		}
		catch (NumberFormatException g) {
			throw g ;
		}	catch(LoginRequiredException e)
		{
			throw e;
		}
		finally
		{
			GestoreConnessioni.freeConnection(db);
		}
	}
}
