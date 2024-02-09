package org.aspcfs.modules.gestionedatiacquereflue.actions;
import java.sql.Connection;
import java.util.logging.Logger;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestionedatiacquereflue.base.DatoAcqueReflue;
import org.aspcfs.utils.web.LookupList;

import com.darkhorseventures.framework.actions.ActionContext;


public final class GestioneDatiAcqueReflue extends CFSModule {
	

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

		DatoAcqueReflue dato = null;
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			dato = new DatoAcqueReflue(db, riferimentoId, riferimentoIdNomeTab);
			context.getRequest().setAttribute("dato", dato);
			
			LookupList statiImpiantiList = new LookupList(db, "lookup_stato_impianto_acque_reflue"); 
			context.getRequest().setAttribute("statiImpiantiList", statiImpiantiList);

			LookupList processiDepurativiList = new LookupList(db, "lookup_processo_depurativo");    	      
			context.getRequest().setAttribute("processiDepurativiList", processiDepurativiList);

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
			
			DatoAcqueReflue dato = new DatoAcqueReflue();
			dato.setRiferimentoId(riferimentoId);
			dato.setRiferimentoIdNomeTab(riferimentoIdNomeTab);
			Boolean depurazioneReflui =  Boolean.valueOf(context.getRequest().getParameter("depurazioneReflui"));
			int idStatoImpianto = Integer.parseInt(context.getRequest().getParameter("idStatoImpianto"));
			String gestoreImpianto = context.getRequest().getParameter("gestoreImpianto");
			int idProcessoDepurativo = Integer.parseInt(context.getRequest().getParameter("idProcessoDepurativo"));
			String potenzialitaImpiantoAE = context.getRequest().getParameter("potenzialitaImpiantoAE");
			String recettoreScarico = context.getRequest().getParameter("recettoreScarico");
			String recettoreFinale = context.getRequest().getParameter("recettoreFinale");
			String codiceUlia = context.getRequest().getParameter("codiceUlia");
				
			messaggio = DatoAcqueReflue.upsert(db, riferimentoId, riferimentoIdNomeTab, getUserId(context), depurazioneReflui, idStatoImpianto, gestoreImpianto, idProcessoDepurativo, potenzialitaImpiantoAE, recettoreScarico, recettoreFinale, codiceUlia);
	
	  
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
