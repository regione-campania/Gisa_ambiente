package org.aspcfs.modules.gestioneispettive.actions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneispettive.base.Anagrafica;
import org.aspcfs.modules.gestioneispettive.base.FascicoloIspettivo;
import org.aspcfs.modules.gestioneispettive.base.GiornataIspettiva;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;

public class GestioneFascicoliIspettivi extends CFSModule{
	
	
	public String executeCommandAdd(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{
		return executeCommandAddFascicoloIspettivo(context);
	}
	
	public String executeCommandAddFascicoloIspettivo(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonFascicoloIspettivo = new JSONObject();

		try {jsonFascicoloIspettivo = new JSONObject(context.getRequest().getParameter("jsonFascicoloIspettivo"));} catch (Exception e){}
		if (jsonFascicoloIspettivo == null)
			try {jsonFascicoloIspettivo = new JSONObject((String) context.getRequest().getAttribute("jsonFascicoloIspettivo"));} catch (Exception e){}	
		
		Connection db = null;

		try 
		{
			
			
			
			
			
			db = this.getConnection(context);

			if (!jsonFascicoloIspettivo.has("Anagrafica")){
				int riferimentoId = -1;
				String riferimentoIdNomeTab = null;

				try {riferimentoId = Integer.parseInt(context.getRequest().getParameter("riferimentoId"));} catch (Exception e) {}
				if (riferimentoId == -1)
					try {riferimentoId = Integer.parseInt((String) context.getRequest().getAttribute("riferimentoId"));} catch (Exception e) {}

				
				
				String sel1 = "select * from controllo_dati_autorizzativi(?)";
				PreparedStatement pst1 = db.prepareStatement(sel1);
				pst1.setInt(1,riferimentoId);
				ResultSet rs =  pst1.executeQuery();


				
					if (rs.next())
					{
						
						if (rs.getBoolean("ippc") == false){
							context.getRequest().setAttribute("controlloIppcKO", true);

							return executeCommandLista(context);
						}
						
					}

				
				
				
				
				
				
				
				
				try {riferimentoIdNomeTab = context.getRequest().getParameter("riferimentoIdNomeTab");} catch (Exception e) {}
				if (riferimentoIdNomeTab == null)
					try {riferimentoIdNomeTab = (String) context.getRequest().getAttribute("riferimentoIdNomeTab");} catch (Exception e) {}

				Anagrafica anag = new Anagrafica(db, riferimentoId, riferimentoIdNomeTab);

				
				
				
				
				
				JSONObject jsonAnagrafica = new JSONObject();
				jsonAnagrafica.put("riferimentoId", riferimentoId);
				jsonAnagrafica.put("riferimentoIdNomeTab", riferimentoIdNomeTab);
				jsonAnagrafica.put("ragioneSociale", anag.getRagioneSociale());
				jsonAnagrafica.put("partitaIva", anag.getPartitaIva());
				jsonFascicoloIspettivo.put("Anagrafica", jsonAnagrafica);

				JSONObject jsonUtente = new JSONObject();
				jsonUtente.put("userId", getUserId(context));
				jsonFascicoloIspettivo.put("Utente", jsonUtente);

				
				
			}

			int riferimentoId = Integer.parseInt(((JSONObject) jsonFascicoloIspettivo.get("Anagrafica")).get("riferimentoId").toString());
			String riferimentoIdNomeTab = ((JSONObject) jsonFascicoloIspettivo.get("Anagrafica")).get("riferimentoIdNomeTab").toString();
			int idUtente = getUserId(context);
		
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonFascicoloIspettivo", jsonFascicoloIspettivo);

		return "AddFascicoloIspettivoOK";
	
	}

	public String executeCommandAddRiepilogo(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonFascicoloIspettivo = new JSONObject();

		try {jsonFascicoloIspettivo = new JSONObject(context.getRequest().getParameter("jsonFascicoloIspettivo"));} catch (Exception e){}
		if (jsonFascicoloIspettivo == null)
			try {jsonFascicoloIspettivo = new JSONObject((String) context.getRequest().getAttribute("jsonFascicoloIspettivo"));} catch (Exception e){}
		
		if (!jsonFascicoloIspettivo.has("Dati")) {
			
			String numero = context.getRequest().getParameter("numeroFascicoloIspettivo");
			String dataInizio = context.getRequest().getParameter("dataInizioFascicoloIspettivo");

			JSONObject jsonDati = new JSONObject();
			jsonDati.put("numero",  numero);
			jsonDati.put("dataInizio",  dataInizio);
			jsonFascicoloIspettivo.put("Dati", jsonDati);

		}

		context.getRequest().setAttribute("jsonFascicoloIspettivo", jsonFascicoloIspettivo);

		return "AddRiepilogoOK";
	}

	public String executeCommandInsert(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonFascicoloIspettivo = new JSONObject();

		try {
			jsonFascicoloIspettivo = new JSONObject(context.getRequest().getParameter("jsonFascicoloIspettivo"));
		} catch (Exception e){}

		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			FascicoloIspettivo fascicoloIspettivo = new FascicoloIspettivo();
			fascicoloIspettivo.insert(db, jsonFascicoloIspettivo);
			context.getRequest().setAttribute("FascicoloIspettivo",  fascicoloIspettivo);

		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("jsonFascicoloIspettivo",  jsonFascicoloIspettivo);
		return "InsertOK";
	}
	
	public String executeCommandView(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
	
		JSONObject jsonFascicoloIspettivo = new JSONObject();
		JSONArray jsonGiornateIspettive = new JSONArray();

		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			
				int idFascicoloIspettivo = -1;
				
				try {idFascicoloIspettivo = Integer.parseInt(context.getRequest().getParameter("idFascicoloIspettivo"));} catch (Exception e) {}
				if (idFascicoloIspettivo == -1)
					try {idFascicoloIspettivo = Integer.parseInt((String) context.getRequest().getAttribute("idFascicoloIspettivo"));} catch (Exception e) {}

				jsonFascicoloIspettivo = FascicoloIspettivo.getJson(db, idFascicoloIspettivo);
				jsonGiornateIspettive = GiornataIspettiva.getJsonLista(db, idFascicoloIspettivo);

		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonFascicoloIspettivo", jsonFascicoloIspettivo);
		context.getRequest().setAttribute("jsonGiornateIspettive", jsonGiornateIspettive);
		
		context.getRequest().setAttribute("Messaggio", (String) context.getRequest().getAttribute("Messaggio"));

		return "ViewOK";
	}
	
	public String executeCommandLista(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
	
		int riferimentoId = -1;
		String riferimentoIdNomeTab = null;

		try {riferimentoId = Integer.parseInt(context.getRequest().getParameter("riferimentoId"));} catch (Exception e) {}
		if (riferimentoId == -1)
			try {riferimentoId = Integer.parseInt((String) context.getRequest().getAttribute("riferimentoId"));} catch (Exception e) {}

		try {riferimentoIdNomeTab = context.getRequest().getParameter("riferimentoIdNomeTab");} catch (Exception e) {}
		if (riferimentoIdNomeTab == null)
			try {riferimentoIdNomeTab = (String) context.getRequest().getAttribute("riferimentoIdNomeTab");} catch (Exception e) {}

		
		Anagrafica anag = null;
		JSONArray jsonFascicoliIspettivi = new JSONArray();

		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			
			anag = new Anagrafica(db, riferimentoId, riferimentoIdNomeTab);
			jsonFascicoliIspettivi = FascicoloIspettivo.getJsonLista(db, riferimentoId, riferimentoIdNomeTab);
	
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("Anagrafica", anag);
		context.getRequest().setAttribute("jsonFascicoliIspettivi", jsonFascicoliIspettivi);

		return "ListaOK";
	}
	
	public String executeCommandToClose(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{
		//da modificare il permesso
		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		int idFascicoloIspettivo = -1;
	
		Connection db = null;
		try {
			db = this.getConnection(context);
			idFascicoloIspettivo = Integer.parseInt(context.getRequest().getParameter("idFascicoloIspettivo"));
			context.getRequest().setAttribute("idFascicoloIspettivo", String.valueOf(idFascicoloIspettivo));
			JSONArray jsonGiornateIspettive = new JSONArray();

			JSONObject jsonFascicoloIspettivo = FascicoloIspettivo.getJson(db, idFascicoloIspettivo);
			context.getRequest().setAttribute("jsonFascicoloIspettivo", jsonFascicoloIspettivo);
		
			jsonGiornateIspettive = GiornataIspettiva.getJsonLista(db, idFascicoloIspettivo);
			context.getRequest().setAttribute("jsonGiornateIspettive", jsonGiornateIspettive);

			
		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		}
		finally
		{
			this.freeConnection(context, db);
		}
		
		return "CloseOK";
	}
	
	public String executeCommandClose(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException
	{
		//da modificare
		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		String messaggio ="";
		String dataChiusura="";
		String oraChiusura="";
		int idFascicoloIspettivo = -1;
		int annoProtocollo = -1;
		int numeroProtocollo = -1;
		String codAllegato = "";
		
		try {
			db = this.getConnection(context);
			
			idFascicoloIspettivo = Integer.parseInt(context.getRequest().getParameter("idFascicoloIspettivo"));
			dataChiusura = (String)(context.getRequest().getParameter("dataChiusura"));
			oraChiusura = (String)(context.getRequest().getParameter("oraChiusura"));

//			String nota = context.getRequest().getParameter("note");
			
			annoProtocollo = Integer.parseInt(context.getRequest().getParameter("annoProtocolloChiusura"));
			numeroProtocollo = Integer.parseInt(context.getRequest().getParameter("numeroProtocolloChiusura"));
			
			codAllegato = (String)(context.getRequest().getParameter("codAllegato"));
			
			JSONObject jsonFascicoloIspettivo = FascicoloIspettivo.getJson(db, idFascicoloIspettivo);
			messaggio = FascicoloIspettivo.close(db, idFascicoloIspettivo, dataChiusura,oraChiusura, annoProtocollo, numeroProtocollo, codAllegato, getUserId(context));
	
	  
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("Messaggio", messaggio);
		context.getRequest().setAttribute("idFascicoloIspettivo", String.valueOf(idFascicoloIspettivo));

		return executeCommandView(context);
	}
	
	public String executeCommandToDelete(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{
		//da modificare il permesso
		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		int idFascicoloIspettivo = -1;
	
		Connection db = null;
		try {
			db = this.getConnection(context);
			idFascicoloIspettivo = Integer.parseInt(context.getRequest().getParameter("idFascicoloIspettivo"));
			context.getRequest().setAttribute("idFascicoloIspettivo", String.valueOf(idFascicoloIspettivo));

			JSONObject jsonFascicoloIspettivo = FascicoloIspettivo.getJson(db, idFascicoloIspettivo);
			context.getRequest().setAttribute("jsonFascicoloIspettivo", jsonFascicoloIspettivo);
		
			
		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		}
		finally
		{
			this.freeConnection(context, db);
		}
		
		return "DeleteOK";
	}
	
	public String executeCommandDelete(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException
	{
		//da modificare
		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		Connection db = null;
		String messaggio ="";
		String noteEliminazione="";
		int idFascicoloIspettivo = -1;
		
		JSONObject jsonFascicoloIspettivo = null;
		try {
			db = this.getConnection(context);
			
			idFascicoloIspettivo = Integer.parseInt(context.getRequest().getParameter("idFascicoloIspettivo"));
			context.getRequest().setAttribute("idFascicoloIspettivo", String.valueOf(idFascicoloIspettivo));

			noteEliminazione = (String)(context.getRequest().getParameter("noteEliminazione"));
			
			jsonFascicoloIspettivo = FascicoloIspettivo.getJson(db, idFascicoloIspettivo);
			messaggio = FascicoloIspettivo.delete(db, idFascicoloIspettivo, noteEliminazione, getUserId(context));
	
	  
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("Messaggio", messaggio);
		context.getRequest().setAttribute("jsonFascicoloIspettivo", jsonFascicoloIspettivo);

		return "DeleteOK";
	}
	
}
