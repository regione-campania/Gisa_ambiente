package org.aspcfs.modules.gestioneispettive.actions;

import java.sql.Connection;
import java.text.ParseException;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneispettive.base.GiornataIspettiva;
import org.aspcfs.modules.gestioneispettive.base.NonConformita;
import org.json.JSONException;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;

public class GestioneNonConformita extends CFSModule{

	public String executeCommandAdd(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{
		return executeCommandAddNonConformita(context);
	}
	
	public String executeCommandAddNonConformita(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
		
		int idGiornataIspettiva = -1;
		JSONObject jsonNonConformita = new JSONObject();
		JSONObject jsonGiornataIspettiva = new JSONObject();
		
		try {jsonNonConformita = new JSONObject(context.getRequest().getParameter("jsonNonConformita"));} catch (Exception e){}
		if (jsonNonConformita == null)
			try {jsonNonConformita = new JSONObject((String) context.getRequest().getAttribute("jsonNonConformita"));} catch (Exception e){}	
		
		try {idGiornataIspettiva = Integer.parseInt(context.getRequest().getParameter("idGiornataIspettiva"));} catch (Exception e) {}
		if (idGiornataIspettiva == -1)
			try {idGiornataIspettiva = Integer.parseInt((String) context.getRequest().getAttribute("idGiornataIspettiva"));} catch (Exception e) {}
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			if (jsonNonConformita.has("DatiGiornataIspettiva")){
				if (idGiornataIspettiva == -1)
					idGiornataIspettiva =  (Integer) (((JSONObject) jsonNonConformita.get("DatiGiornataIspettiva")).get("idGiornataIspettiva"));
			}
			
			jsonGiornataIspettiva = GiornataIspettiva.getJson(db, idGiornataIspettiva);
			context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);
		
			if (!jsonNonConformita.has("DatiGiornataIspettiva")){

				JSONObject jsonDatiGiornataIspettiva = new JSONObject();
				jsonDatiGiornataIspettiva.put("idGiornataIspettiva", idGiornataIspettiva);
				jsonDatiGiornataIspettiva.put("ragioneSociale", ((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("ragioneSociale"));
				jsonDatiGiornataIspettiva.put("dipartimento", ((JSONObject) jsonGiornataIspettiva.get("Dipartimento")).get("nome"));
				jsonNonConformita.put("DatiGiornataIspettiva", jsonDatiGiornataIspettiva);

				JSONObject jsonUtente = new JSONObject();
				jsonUtente.put("userId", getUserId(context));
				jsonNonConformita.put("Utente", jsonUtente);
			} 
	} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonNonConformita", jsonNonConformita);

		return "AddNonConformitaOK";
	}
	
	

	public String executeCommandAddRiepilogo(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonNonConformita = new JSONObject();

		try {jsonNonConformita = new JSONObject(context.getRequest().getParameter("jsonNonConformita"));} catch (Exception e){}
		if (jsonNonConformita == null)
			try {jsonNonConformita = new JSONObject((String) context.getRequest().getAttribute("jsonNonConformita"));} catch (Exception e){}

		if (!jsonNonConformita.has("Dati")) {
			String note = null;
			
			try {note = context.getRequest().getParameter("note");} catch (Exception e) {}
			
			JSONObject jsonDati = new JSONObject();
			jsonDati.put("note", note);
			jsonNonConformita.put("Dati", jsonDati);
				
		}
		
		if (!jsonNonConformita.has("TipoVerifica")) {
			String tipoVerificaId = null;
			String tipoVerificaNome = null;

			try {tipoVerificaId = context.getRequest().getParameter("tipoVerificaId");} catch (Exception e) {}
			try {tipoVerificaNome = context.getRequest().getParameter("tipoVerificaNome_"+tipoVerificaId);} catch (Exception e) {}

			JSONObject jsonTipoVerifica = new JSONObject();
			jsonTipoVerifica.put("id", tipoVerificaId);
			jsonTipoVerifica.put("nome", tipoVerificaNome);
			jsonNonConformita.put("TipoVerifica", jsonTipoVerifica);
				
		}
		
		if (!jsonNonConformita.has("Linea")) {
			String lineaId = null;
			String lineaNome = null;

			try {lineaId = context.getRequest().getParameter("lineaId");} catch (Exception e) {}
			try {lineaNome = context.getRequest().getParameter("lineaNome_"+lineaId);} catch (Exception e) {}

			JSONObject jsonLinea = new JSONObject();
			jsonLinea.put("id", lineaId);
			jsonLinea.put("nome", lineaNome);
			jsonNonConformita.put("Linea", jsonLinea);
				
		}
		
		context.getRequest().setAttribute("jsonNonConformita", jsonNonConformita);

		return "AddRiepilogoOK";
	}

	public String executeCommandInsert(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonNonConformita = new JSONObject();

		try {
			jsonNonConformita = new JSONObject(context.getRequest().getParameter("jsonNonConformita"));
		} catch (Exception e){}

		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			NonConformita ca = new NonConformita();
			ca.insert(db, jsonNonConformita);
			context.getRequest().setAttribute("NonConformita",  ca);

		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("jsonNonConformita",  jsonNonConformita);
		return "InsertOK";
	}
	
	
	public String executeCommandView(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
	
		JSONObject jsonNonConformita = new JSONObject();
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			
				int idNonConformita = -1;
				
				try {idNonConformita = Integer.parseInt(context.getRequest().getParameter("idNonConformita"));} catch (Exception e) {}
				if (idNonConformita == -1)
					try {idNonConformita = Integer.parseInt((String) context.getRequest().getAttribute("idNonConformita"));} catch (Exception e) {}

				jsonNonConformita = NonConformita.getJson(db, idNonConformita);

		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonNonConformita", jsonNonConformita);

		return "ViewOK";
	}
}
