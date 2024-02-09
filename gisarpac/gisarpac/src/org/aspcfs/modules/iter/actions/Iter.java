package org.aspcfs.modules.iter.actions;

import java.sql.Connection;
import java.util.ArrayList;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.iter.base.Cartografia;

import com.darkhorseventures.framework.actions.ActionContext;

public class Iter extends CFSModule{
	
		public String executeCommandDashboard (ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	
	{

		if (!hasPermission(context, "iter-view")) {
			return ("PermissionError");
		}

		ArrayList<Cartografia> listaCartografie = new ArrayList<Cartografia>();
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			listaCartografie = Cartografia.getListaCartografie(db);
	
		
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("listaCartografie", listaCartografie);

		return "DashboardOK"; 

	}

	
	
}
