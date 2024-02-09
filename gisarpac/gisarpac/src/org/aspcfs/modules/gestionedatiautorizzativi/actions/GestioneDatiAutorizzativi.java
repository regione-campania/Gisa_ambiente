package org.aspcfs.modules.gestionedatiautorizzativi.actions;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.logging.Logger;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestionedatiautorizzativi.base.DatoAutorizzativo;
import org.aspcfs.utils.web.LookupList;

import com.darkhorseventures.framework.actions.ActionContext;


public final class GestioneDatiAutorizzativi extends CFSModule {
	

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

		ArrayList<DatoAutorizzativo> listaDati = new ArrayList<DatoAutorizzativo>();
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			listaDati = DatoAutorizzativo.buildListaDati(db, riferimentoId, riferimentoIdNomeTab);
			context.getRequest().setAttribute("listaDati", listaDati);
		
			LookupList autorizzazioniList = new LookupList(db, "lookup_autorizzazione_tipo"); 
			context.getRequest().setAttribute("autorizzazioniList", autorizzazioniList);

			LookupList matriciList = new LookupList(db, "lookup_matrice_controlli");    	      
			context.getRequest().setAttribute("matriciList", matriciList);

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
	
public String executeCommandUpsert(ActionContext context) {
		
		int riferimentoId = -1;
		String riferimentoIdNomeTab = null;
		int indice = -1;
		int maxIndice = -1;
		
		try { riferimentoId = Integer.parseInt(context.getRequest().getParameter("riferimentoId"));} catch (Exception e) {}
		if (riferimentoId == -1)
			try { riferimentoId = Integer.parseInt((String)context.getRequest().getAttribute("riferimentoId"));} catch (Exception e) {}
		
		try { riferimentoIdNomeTab = context.getRequest().getParameter("riferimentoIdNomeTab");} catch (Exception e) {}
		if (riferimentoIdNomeTab == null)
			try { riferimentoIdNomeTab = (String)context.getRequest().getAttribute("riferimentoIdNomeTab");} catch (Exception e) {}
	
		try { maxIndice = Integer.parseInt(context.getRequest().getParameter("maxIndice"));} catch (Exception e) {}
		if (maxIndice == -1)
			try { maxIndice = Integer.parseInt((String)context.getRequest().getAttribute("maxIndice"));} catch (Exception e) {}
		
		
		String messaggio = null;
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			
			DatoAutorizzativo.delete(db, riferimentoId, riferimentoIdNomeTab, getUserId(context));
			
			for (int i = 0; i<maxIndice; i++){
				
				DatoAutorizzativo dato = new DatoAutorizzativo();
				dato.setRiferimentoId(riferimentoId);
				dato.setRiferimentoIdNomeTab(riferimentoIdNomeTab);
				String idAia =  context.getRequest().getParameter("idAia_"+i);
				int idAutorizzazione = Integer.parseInt(context.getRequest().getParameter("idAutorizzazione_"+i));
				String numeroDecreto = context.getRequest().getParameter("numeroDecreto_"+i);
				String dataDecreto = context.getRequest().getParameter("dataDecreto_"+i);
				String nota = context.getRequest().getParameter("nota_"+i);
				String burc = context.getRequest().getParameter("burc_"+i);
				
				String[] matriceIds = null;
				try {matriceIds = context.getRequest().getParameterValues("matriceId_"+i);} catch (Exception e) {}
				
				if (idAia!=null && !idAia.trim().equals(""))
					messaggio = DatoAutorizzativo.insert(db, riferimentoId, riferimentoIdNomeTab, getUserId(context), idAia, idAutorizzazione, numeroDecreto, dataDecreto, nota, burc, matriceIds);
			
			}
			
		
	  
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
