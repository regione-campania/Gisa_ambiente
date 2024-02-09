package org.aspcfs.utils.ws;

import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneanagrafica.base.Impresa;
import org.aspcfs.modules.noscia.dao.ImpresaDAO;

import com.darkhorseventures.framework.actions.ActionContext;
import com.google.gson.Gson;



public class Verificaesistenzaimpresa extends CFSModule {


	public String executeCommandSearch(ActionContext context) throws Exception 
	{
		Gson gson = new Gson();
		String json = "";
		Connection db = null;
		Map<String, Object> map = new HashMap<String, Object>();
	    Map<String, String[]>  parameterMap = context.getRequest().getParameterMap();
	    Impresa imp = new Impresa(parameterMap);
	    ArrayList<Impresa> imprese = new ArrayList<>();

	    try{
		    
		    db =  this.getConnection(context);
		    ImpresaDAO impDAO = new ImpresaDAO(imp);
		    imprese = impDAO.checkEsistenza(db);
		} catch (Exception errorMessage)
		{
		    context.getRequest().setAttribute("Error", errorMessage);
		    return ("SystemError");
		} finally{
		    this.freeConnection(context, db);
		}
		
		
		
		if(imprese.size()>0)
		{
			map.put("status", "1");  
			map.put("imprese", imprese);
		}
		else
		{
			map.put("status", "2");
		}
		
		json = gson.toJson(map);	
		
		PrintWriter writer = context.getResponse().getWriter();
		writer.print(json);
		writer.close();
        return "";
		
	}

}
