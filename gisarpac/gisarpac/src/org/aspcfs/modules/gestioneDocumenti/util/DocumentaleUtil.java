package org.aspcfs.modules.gestioneDocumenti.util;

import java.io.IOException;
import java.sql.SQLException;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.util.imports.ApplicationProperties;
import org.aspcfs.utils.UrlUtil;

import com.darkhorseventures.framework.actions.ActionContext;


public class DocumentaleUtil extends CFSModule {

	public DocumentaleUtil(){
		
	}
	
	public String executeCommandVerificaDocumentaleOnline(ActionContext context) throws SQLException, IOException{
		boolean esito=  verificaDocumentaleOnline(context);
		System.out.println("[GISA] Esito verifica Documentale online: "+ esito);
		context.getRequest().setAttribute("verificaDocumentaleOnline", esito);
		return "verificaDocumentaleOnlineOK";
	}
	
	public static boolean verificaDocumentaleOnline(ActionContext context) throws SQLException, IOException{
		
		Boolean documentaleDisponibile = Boolean.valueOf(ApplicationProperties.getProperty("DOCUMENTALE_DISPONIBILE"));
	
		if (!documentaleDisponibile){
			return false;
		}
		
		String esito="";
		String urlTest = "http://"+context.getRequest().getLocalAddr()+":"+context.getRequest().getLocalPort() + context.getRequest().getContextPath() + "/"+ ApplicationProperties.getProperty("APP_DOCUMENTALE_TEST");
		esito = UrlUtil.getUrlResponse(urlTest);
		
		if (esito!=null && esito.toUpperCase().contains("ONLINE"))
			return true;
		return false;
	}
	
}
