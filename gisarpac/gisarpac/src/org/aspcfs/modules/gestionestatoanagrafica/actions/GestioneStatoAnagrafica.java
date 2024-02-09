package org.aspcfs.modules.gestionestatoanagrafica.actions;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.logging.Logger;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestionestatoanagrafica.base.StatoAnagrafica;
import org.aspcfs.utils.web.LookupList;

import com.darkhorseventures.framework.actions.ActionContext;


public final class GestioneStatoAnagrafica extends CFSModule {
	

	Logger logger = Logger.getLogger("MainLogger");


	public String executeCommandView(ActionContext context) {
		
		
		int riferimentoId = -1;
		String riferimentoIdNomeTab = null;
		String messaggio = null;

		try { riferimentoId = Integer.parseInt(context.getRequest().getParameter("riferimentoId"));} catch (Exception e) {}
		if (riferimentoId == -1)
			try { riferimentoId = Integer.parseInt((String)context.getRequest().getAttribute("riferimentoId"));} catch (Exception e) {}
		
		try { riferimentoIdNomeTab = context.getRequest().getParameter("riferimentoIdNomeTab");} catch (Exception e) {}
		if (riferimentoIdNomeTab == null)
			try { riferimentoIdNomeTab = (String)context.getRequest().getAttribute("riferimentoIdNomeTab");} catch (Exception e) {}
	
		try { messaggio = (String)context.getRequest().getAttribute("Messaggio");} catch (Exception e) {}

		ArrayList<StatoAnagrafica> listaStorico  = new ArrayList<StatoAnagrafica> ();
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			listaStorico = StatoAnagrafica.getStoricoCambioStato(db, riferimentoId, riferimentoIdNomeTab);
			context.getRequest().setAttribute("listaStorico", listaStorico);
			
			LookupList statiList = new LookupList(db, "lookup_stato_lab"); 
			context.getRequest().setAttribute("statiList", statiList);

			context.getRequest().setAttribute("riferimentoId", String.valueOf(riferimentoId));
			context.getRequest().setAttribute("riferimentoIdNomeTab", riferimentoIdNomeTab);
			context.getRequest().setAttribute("Messaggio", messaggio);
    
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return "ViewOK";
	}
	
public String executeCommandInsert(ActionContext context) {
		
		int riferimentoId = -1;
		String riferimentoIdNomeTab = null;
		
		try { riferimentoId = Integer.parseInt(context.getRequest().getParameter("riferimentoId"));} catch (Exception e) {}
		if (riferimentoId == -1)
			try { riferimentoId = Integer.parseInt((String)context.getRequest().getAttribute("riferimentoId"));} catch (Exception e) {}
		
		try { riferimentoIdNomeTab = context.getRequest().getParameter("riferimentoIdNomeTab");} catch (Exception e) {}
		if (riferimentoIdNomeTab == null)
			try { riferimentoIdNomeTab = (String)context.getRequest().getAttribute("riferimentoIdNomeTab");} catch (Exception e) {}
	

		String messaggio = null;
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			int idStato = Integer.parseInt(context.getRequest().getParameter("idStato"));
			String nota = context.getRequest().getParameter("nota");
			String dataCambioStato = context.getRequest().getParameter("dataCambioStato");
			
			messaggio = StatoAnagrafica.insert(db, riferimentoId, riferimentoIdNomeTab, getUserId(context), idStato, dataCambioStato, nota);
	
	  
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("riferimentoId", String.valueOf(riferimentoId));
		context.getRequest().setAttribute("riferimentoIdNomeTab", riferimentoIdNomeTab);
		context.getRequest().setAttribute("Messaggio", messaggio);

		return executeCommandView(context);
	}


}
