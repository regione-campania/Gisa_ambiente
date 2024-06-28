package org.aspcfs.modules.gestioneispettive.actions;

import java.sql.Connection;
import java.text.ParseException;
import java.util.ArrayList;

import jdk.nashorn.internal.parser.JSONParser;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneispettive.base.Anagrafica;
import org.aspcfs.modules.gestioneispettive.base.Area;
import org.aspcfs.modules.gestioneispettive.base.Campione;
import org.aspcfs.modules.gestioneispettive.base.Componente;
import org.aspcfs.modules.gestioneispettive.base.Dipartimento;
import org.aspcfs.modules.gestioneispettive.base.EmissioniAtmosferaCamini;
import org.aspcfs.modules.gestioneispettive.base.Esame;
import org.aspcfs.modules.gestioneispettive.base.FascicoloIspettivo;
import org.aspcfs.modules.gestioneispettive.base.GiornataIspettiva;
import org.aspcfs.modules.gestioneispettive.base.Linea;
import org.aspcfs.modules.gestioneispettive.base.Matrice;
import org.aspcfs.modules.gestioneispettive.base.Motivo;
import org.aspcfs.modules.gestioneispettive.base.NonConformita;
import org.aspcfs.modules.gestioneispettive.base.Tecnica;
import org.aspcfs.modules.gestioneispettive.base.TipoVerifica;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;

public class GestioneGiornateIspettive extends CFSModule{

	public String executeCommandAdd(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{
		return executeCommandAddDipartimento(context);
	}
	
	public String executeCommandAddDipartimento(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}	
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			if (jsonGiornataIspettiva.has("Dipartimento")) {
				jsonGiornataIspettiva.remove("Dipartimento");
			}

			int idFascicoloIspettivo = -1;
			
			try {idFascicoloIspettivo = Integer.parseInt(context.getRequest().getParameter("idFascicoloIspettivo"));} catch (Exception e) {}
			if (idFascicoloIspettivo == -1)
				try {idFascicoloIspettivo = Integer.parseInt((String) context.getRequest().getAttribute("idFascicoloIspettivo"));} catch (Exception e) {}
			
			if (idFascicoloIspettivo == -1) {

				// VECCHIA GESTIONE ANAGRAFICA

				if (!jsonGiornataIspettiva.has("Anagrafica")){
					int riferimentoId = -1;
					String riferimentoIdNomeTab = null;

					try {riferimentoId = Integer.parseInt(context.getRequest().getParameter("riferimentoId"));} catch (Exception e) {}
					if (riferimentoId == -1)
						try {riferimentoId = Integer.parseInt((String) context.getRequest().getAttribute("riferimentoId"));} catch (Exception e) {}

					try {riferimentoIdNomeTab = context.getRequest().getParameter("riferimentoIdNomeTab");} catch (Exception e) {}
					if (riferimentoIdNomeTab == null)
						try {riferimentoIdNomeTab = (String) context.getRequest().getAttribute("riferimentoIdNomeTab");} catch (Exception e) {}

					Anagrafica anag = new Anagrafica(db, riferimentoId, riferimentoIdNomeTab);

					JSONObject jsonAnagrafica = new JSONObject();
					jsonAnagrafica.put("riferimentoId", riferimentoId);
					jsonAnagrafica.put("riferimentoIdNomeTab", riferimentoIdNomeTab);
					jsonAnagrafica.put("ragioneSociale", anag.getRagioneSociale());
					jsonAnagrafica.put("partitaIva", anag.getPartitaIva());
					jsonGiornataIspettiva.put("Anagrafica", jsonAnagrafica);

					JSONObject jsonUtente = new JSONObject();
					jsonUtente.put("userId", getUserId(context));
					jsonGiornataIspettiva.put("Utente", jsonUtente);

				}
			}
			// FINE VECCHIA GESTIONE ANAGRAFICA

			else {

				// NUOVA GESTIONE FASCICOLO
				
				if (!jsonGiornataIspettiva.has("FascicoloIspettivo")){
					JSONObject jsonFascicoloIspettivo = new JSONObject();
					jsonFascicoloIspettivo = FascicoloIspettivo.getJson(db, idFascicoloIspettivo);
					
					JSONObject jsonFascicoloMinimal = new JSONObject();
					jsonFascicoloMinimal.put("id", Integer.parseInt(((JSONObject) jsonFascicoloIspettivo.get("CampiServizio")).get("idFascicoloIspettivo").toString()));
					jsonFascicoloMinimal.put("numero", ((JSONObject) jsonFascicoloIspettivo.get("Dati")).get("numero").toString());
					jsonFascicoloMinimal.put("dataInizio", ((JSONObject) jsonFascicoloIspettivo.get("Dati")).get("dataInizio").toString());
					jsonGiornataIspettiva.put("FascicoloIspettivo", jsonFascicoloMinimal);
				}

				if (!jsonGiornataIspettiva.has("Anagrafica")){
					
					JSONObject jsonFascicoloIspettivo = new JSONObject();
					jsonFascicoloIspettivo = FascicoloIspettivo.getJson(db, idFascicoloIspettivo);
					
					int riferimentoId = Integer.parseInt(((JSONObject) jsonFascicoloIspettivo.get("Anagrafica")).get("riferimentoId").toString());
					String riferimentoIdNomeTab = ((JSONObject) jsonFascicoloIspettivo.get("Anagrafica")).get("riferimentoIdNomeTab").toString();
					
					Anagrafica anag = new Anagrafica(db, riferimentoId, riferimentoIdNomeTab);

					JSONObject jsonAnagrafica = new JSONObject();
					jsonAnagrafica.put("riferimentoId", riferimentoId);
					jsonAnagrafica.put("riferimentoIdNomeTab", riferimentoIdNomeTab);
					jsonAnagrafica.put("ragioneSociale", anag.getRagioneSociale());
					jsonAnagrafica.put("partitaIva", anag.getPartitaIva());
					jsonGiornataIspettiva.put("Anagrafica", jsonAnagrafica);

					JSONObject jsonUtente = new JSONObject();
					jsonUtente.put("userId", getUserId(context));
					jsonGiornataIspettiva.put("Utente", jsonUtente);

				}
			}
			
			int riferimentoId = Integer.parseInt(((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoId").toString());
			String riferimentoIdNomeTab = ((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoIdNomeTab").toString();
			int idUtente = getUserId(context);

			ArrayList<Dipartimento> listaDipartimenti = Dipartimento.buildLista(db, riferimentoId, riferimentoIdNomeTab, idUtente);
			context.getRequest().setAttribute("ListaDipartimenti", listaDipartimenti);

		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);

		return "AddDipartimentoOK";
	}
	
	

	
	public String executeCommandAddTecnica(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();
		
		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}	
		/*
		if (jsonGiornataIspettiva.has("Tecnica")) {
			jsonGiornataIspettiva.remove("Tecnica");
		}*/
		
		if (!jsonGiornataIspettiva.has("Dipartimento")) {
			int idDipartimento = -1;
			String nomeDipartimento = null;
			try {idDipartimento = Integer.parseInt(context.getRequest().getParameter("dipartimentoId"));} catch (Exception e) {}
			try {nomeDipartimento = context.getRequest().getParameter("dipartimentoNome_"+idDipartimento);} catch (Exception e) {}
			
			JSONObject jsonDipartimento = new JSONObject();
			jsonDipartimento.put("id", idDipartimento);
			jsonDipartimento.put("nome", nomeDipartimento);
			jsonGiornataIspettiva.put("Dipartimento", jsonDipartimento);	
		}
		
		
		int tecnicaId = -1;
		try {tecnicaId = Integer.parseInt(context.getRequest().getParameter("tecnicaId"));}catch (Exception e) {}
		try {tecnicaId = Integer.parseInt((String) context.getRequest().getAttribute("tecnicaId"));}catch (Exception e) {}
		if (tecnicaId>0) {
			
			String tecnicaNome = "";
			
			try {tecnicaId = Integer.parseInt(context.getRequest().getParameter("tecnicaId"));
			context.getRequest().setAttribute("tecnica",tecnicaId);

			} catch (Exception e) {}
			if (tecnicaId == -1)
				try {tecnicaId = Integer.parseInt((String) context.getRequest().getAttribute("tecnicaId"));
				context.getRequest().setAttribute("tecnica",tecnicaId);

				} catch (Exception e) {}

			try {tecnicaNome = context.getRequest().getParameter("tecnicaNome_"+tecnicaId);} catch (Exception e) {}

			JSONObject jsonTecnica = new JSONObject();
			jsonTecnica.put("id", tecnicaId);
			jsonTecnica.put("nome", tecnicaNome);
			jsonGiornataIspettiva.put("Tecnica", jsonTecnica);

		}
		
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);
		
			int riferimentoId = Integer.parseInt(((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoId").toString());
			String riferimentoIdNomeTab = ((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoIdNomeTab").toString();

			ArrayList<Tecnica> listaTecniche = Tecnica.buildLista(db, riferimentoId, riferimentoIdNomeTab);
			context.getRequest().setAttribute("ListaTecniche", listaTecniche);
		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);

		return "AddTecnicaOK";
	}
	
	
	public String executeCommandAddDati(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}

		/*
		if (jsonGiornataIspettiva.has("Dati")) {
			jsonGiornataIspettiva.remove("Dati");
		}*/

		int tecnicaId = -1;
		try {tecnicaId = Integer.parseInt(context.getRequest().getParameter("tecnicaId"));}catch (Exception e) {}
		try {tecnicaId = Integer.parseInt((String) context.getRequest().getAttribute("tecnicaId"));}catch (Exception e) {}
		if (tecnicaId>0) {
			
			String tecnicaNome = "";
			
			try {tecnicaId = Integer.parseInt(context.getRequest().getParameter("tecnicaId"));
			context.getRequest().setAttribute("tecnica",tecnicaId);

			} catch (Exception e) {}
			if (tecnicaId == -1)
				try {tecnicaId = Integer.parseInt((String) context.getRequest().getAttribute("tecnicaId"));
				context.getRequest().setAttribute("tecnica",tecnicaId);

				} catch (Exception e) {}

			try {tecnicaNome = context.getRequest().getParameter("tecnicaNome_"+tecnicaId);} catch (Exception e) {}

			JSONObject jsonTecnica = new JSONObject();
			jsonTecnica.put("id", tecnicaId);
			jsonTecnica.put("nome", tecnicaNome);
			jsonGiornataIspettiva.put("Tecnica", jsonTecnica);

		}
		
		
		
		context.getRequest().setAttribute("tecnica",context.getRequest().getParameter("tecnicaId"));
	
		context.getRequest().setAttribute("jsonDati",context.getRequest().getParameter("jsonDati"));

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);

		return "AddDatiOK";
	}
	
	
	
	public String executeCommandAddPerContoDi(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}
/*
		if (jsonGiornataIspettiva.has("PerContoDi")) {
			jsonGiornataIspettiva.remove("PerContoDi");
		}
*/
		if (!jsonGiornataIspettiva.has("Dati")) {
			String dataInizio = null;
			String oraInizio = null;
			String note = null;
			
			try {dataInizio = context.getRequest().getParameter("dataInizio");} catch (Exception e) {}
			try {oraInizio = context.getRequest().getParameter("oraInizio");} catch (Exception e) {}
			try {note = context.getRequest().getParameter("note");} catch (Exception e) {}

			JSONObject jsonDati = new JSONObject();
			jsonDati.put("dataInizio", dataInizio);
			jsonDati.put("oraInizio", oraInizio);
			jsonDati.put("note", note); 
			jsonGiornataIspettiva.put("Dati", jsonDati);
			

			context.getRequest().setAttribute("tecnica", context.getRequest().getParameter("tecnica"));


		}
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			int annoCorrente = -1;
			String dataPrelievo = (String) ((JSONObject) jsonGiornataIspettiva.get("Dati")).get("dataInizio");
			try {annoCorrente = Integer.parseInt(dataPrelievo.substring(0,4));} catch (Exception e) {}

			int dipartimentoId = Integer.parseInt(((JSONObject) jsonGiornataIspettiva.get("Dipartimento")).get("id").toString());
			
			ArrayList<Area> listaPerContoDi = Area.buildLista(db, annoCorrente, dipartimentoId);
			context.getRequest().setAttribute("ListaPerContoDi", listaPerContoDi);		
			} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);

		return "AddPerContoDiOK";
	}
	
	public String executeCommandAddLinea(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}
/*
		if (jsonGiornataIspettiva.has("Linee")) {
			jsonGiornataIspettiva.remove("Linee");
		}
*/
		//if (jsonGiornataIspettiva.has("PerContoDi")) {
			String[] perContoDiIds = null;
			try {perContoDiIds = context.getRequest().getParameterValues("perContoDiId");
			context.getRequest().setAttribute("perContoDiIds", perContoDiIds);

			} catch (Exception e) {}

			JSONArray jsonPerContoDi = new JSONArray();

			if (perContoDiIds != null) {
				for (int i = 0; i<perContoDiIds.length;i++){
					JSONObject jsonPerContoDi1 = new JSONObject();
					jsonPerContoDi1.put("id", perContoDiIds[i]);
					jsonPerContoDi1.put("nome", context.getRequest().getParameter("perContoDiNome_"+perContoDiIds[i]));
					jsonPerContoDi.put(jsonPerContoDi1);
				}
			}
			jsonGiornataIspettiva.put("PerContoDi", jsonPerContoDi); 

		//}
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			int riferimentoId = Integer.parseInt(((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoId").toString());
			String riferimentoIdNomeTab = ((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoIdNomeTab").toString();

			ArrayList<Linea> listaLinee = Linea.buildLista(db, riferimentoId, riferimentoIdNomeTab);
			context.getRequest().setAttribute("ListaLinee", listaLinee);

		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);
		
		
		return "AddLineaOK";
	}
	
	public String executeCommandAddMatrice(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}
/*
		if (jsonGiornataIspettiva.has("Matrici")) {
			jsonGiornataIspettiva.remove("Matrici");
		}
*/
		//if (!jsonGiornataIspettiva.has("Linee")) {
			String[] lineaIds = null;
			try {lineaIds = context.getRequest().getParameterValues("lineaId");} catch (Exception e) {}

			JSONArray jsonLinee = new JSONArray();

			if (lineaIds != null) {
				for (int i = 0; i<lineaIds.length;i++){
					JSONObject jsonLinea = new JSONObject();
					jsonLinea.put("id", lineaIds[i]);
					jsonLinea.put("nome", context.getRequest().getParameter("lineaNome_"+lineaIds[i]));
					jsonLinea.put("codice", context.getRequest().getParameter("lineaCodice_"+lineaIds[i]));
					jsonLinee.put(jsonLinea);
				}
			}
			jsonGiornataIspettiva.put("Linee", jsonLinee);

		//}
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			int riferimentoId = Integer.parseInt(((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoId").toString());
			String riferimentoIdNomeTab = ((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoIdNomeTab").toString();

			ArrayList<Matrice> listaMatrici = Matrice.buildLista(db, riferimentoId, riferimentoIdNomeTab);
			context.getRequest().setAttribute("ListaMatrici", listaMatrici);

		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);

		return "AddMatriceOK";
	}
	
	public String executeCommandAddEmissioniAtmosferaCamini(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}
/*
		if (jsonGiornataIspettiva.has("EmissioniAtmosferaCamini")) {
			jsonGiornataIspettiva.remove("EmissioniAtmosferaCamini");
		}*/

	//	if (!jsonGiornataIspettiva.has("Matrici")) {
			
			String[] matriceIds = null;
			try {matriceIds = context.getRequest().getParameterValues("matriceId");} catch (Exception e) {}

			JSONArray jsonMatrici = new JSONArray();

			if (matriceIds != null) { 
				for (int i = 0; i<matriceIds.length;i++){
					if (!matriceIds[i].equals("") && Integer.parseInt(matriceIds[i])>0){
						JSONObject jsonMatrice = new JSONObject();
						jsonMatrice.put("id", matriceIds[i]);
						jsonMatrice.put("nome", context.getRequest().getParameter("matriceNome_"+matriceIds[i]));
						jsonMatrice.put("conclusa", context.getRequest().getParameter("matriceConclusa_"+matriceIds[i]));
						jsonMatrici.put(jsonMatrice);
					}
				}
				if (jsonMatrici.length()>0)
					jsonGiornataIspettiva.put("Matrici", jsonMatrici);
			}
		//}

		Connection db = null;

		try 
		{
			db = this.getConnection(context);
	
			int riferimentoId = Integer.parseInt(((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoId").toString());
			String riferimentoIdNomeTab = ((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoIdNomeTab").toString();

			ArrayList<EmissioniAtmosferaCamini> listaEmissioniAtmosferaCamini = new ArrayList<EmissioniAtmosferaCamini>();
			
			boolean hasMatriceEmissioneAtmosfera = false;
			if (jsonGiornataIspettiva.has("Matrici")) {
				 jsonMatrici = (JSONArray) jsonGiornataIspettiva.get("Matrici");
				for (int i = 0; i<jsonMatrici.length(); i++){
					JSONObject jsonMatrice = (JSONObject) jsonMatrici.get(i);
					if (jsonMatrice.get("nome").toString().equalsIgnoreCase("Emissione in atmosfera convogliate"))
						hasMatriceEmissioneAtmosfera = true;
				}
			}
			
			if (!hasMatriceEmissioneAtmosfera)
				return executeCommandAddGruppoIspettivo(context);
			
			listaEmissioniAtmosferaCamini = EmissioniAtmosferaCamini.buildLista(db, riferimentoId, riferimentoIdNomeTab);
			context.getRequest().setAttribute("ListaEmissioniAtmosferaCamini", listaEmissioniAtmosferaCamini);
			
		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);

		return "AddEmissioniAtmosferaCaminiOK";
	}
	
	public String executeCommandAddGruppoIspettivo(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

//		try {
//			
//				jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));
//				
//			} catch (Exception e){}
		//if (jsonGiornataIspettiva == null)
			//try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}
		try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		/*
		if (jsonGiornataIspettiva.has("GruppoIspettivo")) {
			jsonGiornataIspettiva.remove("GruppoIspettivo");
		}*/

		//if (!jsonGiornataIspettiva.has("Matrici")) {
			
			String[] matriceIds = null;
			try {matriceIds = context.getRequest().getParameterValues("matriceId");} catch (Exception e) {}

			JSONArray jsonMatrici = new JSONArray();

			if (matriceIds != null) { 
				for (int i = 0; i<matriceIds.length;i++){
					if (!matriceIds[i].equals("") && Integer.parseInt(matriceIds[i])>0){
						JSONObject jsonMatrice = new JSONObject();
						jsonMatrice.put("id", matriceIds[i]);
						jsonMatrice.put("nome", context.getRequest().getParameter("matriceNome_"+matriceIds[i]));
						jsonMatrice.put("conclusa", context.getRequest().getParameter("matriceConclusa_"+matriceIds[i]));
						jsonMatrici.put(jsonMatrice);
					}
				}
				if (jsonMatrici.length()>0)
					jsonGiornataIspettiva.put("Matrici", jsonMatrici);
			}
		//}
		//if (!jsonGiornataIspettiva.has("EmissioniAtmosferaCamini")) {
			String[] emissioneAtmosferaCaminoIds = null;
			try {emissioneAtmosferaCaminoIds = context.getRequest().getParameterValues("emissioneAtmosferaCaminoId");} catch (Exception e) {}

			JSONArray jsonEmissioniAtmosferaCamini = new JSONArray();

			if (emissioneAtmosferaCaminoIds != null) {
				for (int i = 0; i<emissioneAtmosferaCaminoIds.length;i++){
					JSONObject jsonEmissioneAtmosferaCamino = new JSONObject();
					jsonEmissioneAtmosferaCamino.put("id", emissioneAtmosferaCaminoIds[i]);
					jsonEmissioneAtmosferaCamino.put("codiceCamino", context.getRequest().getParameter("emissioneAtmosferaCaminoCodiceCamino_"+emissioneAtmosferaCaminoIds[i]));
					jsonEmissioneAtmosferaCamino.put("fasiLavorativa", context.getRequest().getParameter("emissioneAtmosferaCaminoFasiLavorativa_"+emissioneAtmosferaCaminoIds[i]));
					jsonEmissioneAtmosferaCamino.put("inquinanti", context.getRequest().getParameter("emissioneAtmosferaCaminoInquinanti_"+emissioneAtmosferaCaminoIds[i]));
					jsonEmissioneAtmosferaCamino.put("sistemaAbbattimento", context.getRequest().getParameter("emissioneAtmosferaCaminoSistemaAbbattimento_"+emissioneAtmosferaCaminoIds[i]));
					jsonEmissioneAtmosferaCamino.put("dataSopralluogo2016", context.getRequest().getParameter("emissioneAtmosferaCaminoDataSopralluogo2016_"+emissioneAtmosferaCaminoIds[i]));
					jsonEmissioneAtmosferaCamino.put("parametriAnalizzati", context.getRequest().getParameter("emissioneAtmosferaCaminoParametriAnalizzati_"+emissioneAtmosferaCaminoIds[i]));
					//jsonEmissioneAtmosferaCamino.put("superamentiLimitiNormativi", context.getRequest().getParameter("emissioneAtmosferaCaminoSuperamentiLimitiNormativi_"+emissioneAtmosferaCaminoIds[i]));
					jsonEmissioneAtmosferaCamino.put("note", context.getRequest().getParameter("emissioneAtmosferaCaminoNote_"+emissioneAtmosferaCaminoIds[i]));
					jsonEmissioneAtmosferaCamino.put("esitoConforme", Boolean.parseBoolean(context.getRequest().getParameter("emissioneAtmosferaCaminoEsitoConforme_"+emissioneAtmosferaCaminoIds[i])));
					
					jsonEmissioniAtmosferaCamini.put(jsonEmissioneAtmosferaCamino);
				}
			//}
			jsonGiornataIspettiva.put("EmissioniAtmosferaCamini", jsonEmissioniAtmosferaCamini);

		}

		Connection db = null;

		try 
		{
			db = this.getConnection(context); 
	
			int annoCorrente = -1;
			String dataPrelievo = (String) ((JSONObject) jsonGiornataIspettiva.get("Dati")).get("dataInizio");
			try {annoCorrente = Integer.parseInt(dataPrelievo.substring(0,4));} catch (Exception e) {}
 
			int dipartimentoId = Integer.parseInt(((JSONObject) jsonGiornataIspettiva.get("Dipartimento")).get("id").toString());
			
			String strutturaIds = "";
			
			JSONArray jsonStrutture = ((JSONArray) jsonGiornataIspettiva.get("PerContoDi"));
			
			for (int i = 0; i<jsonStrutture.length(); i++){
				strutturaIds = strutturaIds + ((JSONObject) jsonStrutture.get(i)).get("id") + ",";
			}
			if (strutturaIds.length()>0)
				strutturaIds = strutturaIds.substring(0, strutturaIds.length()-1);
					
			ArrayList<Componente> listaComponenti = new ArrayList<Componente>(); 
			listaComponenti = Componente.buildLista(db, annoCorrente, -1);
			context.getRequest().setAttribute("ListaComponenti", listaComponenti);

		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);
 
		return "AddGruppoIspettivoOK";
	}
	
	
	public String executeCommandAddMotivo(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}
/*
		if (jsonGiornataIspettiva.has("Motivi")) {
			jsonGiornataIspettiva.remove("Motivi");
		}*/

		//if (!jsonGiornataIspettiva.has("GruppoIspettivo")) {
			

			String[] componentiIds = null;

			try {componentiIds = context.getRequest().getParameterValues("componenteId");} catch (Exception e) {} 

			JSONArray jsonComponenti= new JSONArray();

			if (componentiIds != null) {
				for (int i = 0; i<componentiIds.length;i++){

					JSONObject jsonComponente = new JSONObject();
					int idComponente = Integer.parseInt(componentiIds[i].split("_")[0]);
					jsonComponente.put("id", idComponente);
					jsonComponente.put("nominativo", context.getRequest().getParameter("componenteNome_"+componentiIds[i]).replaceAll("'", ""));
					//jsonComponente.put("qualifica", context.getRequest().getParameter("componenteQualifica_"+componentiIds[i]).replaceAll("'", ""));
					jsonComponente.put("descrizioneAreaSemplice", context.getRequest().getParameter("componenteAreaSemplice_"+componentiIds[i]).replaceAll("'", ""));
					jsonComponente.put("idAreaSemplice", context.getRequest().getParameter("componenteAreaSempliceId_"+componentiIds[i]).replaceAll("'", ""));
					jsonComponente.put("referente", Boolean.parseBoolean(context.getRequest().getParameter("componenteReferente_"+componentiIds[i])));
					jsonComponente.put("dirigente", Boolean.parseBoolean(context.getRequest().getParameter("componenteDirigente_"+componentiIds[i])));  
					jsonComponenti.put(jsonComponente);
				}
			}
			jsonGiornataIspettiva.put("GruppoIspettivo", jsonComponenti);
		
		//}

		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			//Aggiunta motivi

			int tecnicaId = Integer.parseInt(((JSONObject) jsonGiornataIspettiva.get("Tecnica")).get("id").toString());

			ArrayList<Motivo> listaMotivi = new ArrayList<Motivo>();
			listaMotivi = Motivo.buildLista(db, tecnicaId);
			context.getRequest().setAttribute("ListaMotivi", listaMotivi);

		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);

		return "AddMotivoOK";
	}
	
	
	public String executeCommandAddEsame(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}
/*
		if (jsonGiornataIspettiva.has("Esami")) {
			jsonGiornataIspettiva.remove("Esami");
		}*/

		//if (!jsonGiornataIspettiva.has("Motivi")) {
			
			String[] motivoIds = null;
			try {motivoIds = context.getRequest().getParameterValues("motivoId");} catch (Exception e) {}

			JSONArray jsonMotivi = new JSONArray();

			if (motivoIds != null) { 
				for (int i = 0; i<motivoIds.length;i++){
					if (!motivoIds[i].equals("") && Integer.parseInt(motivoIds[i])>0){
						JSONObject jsonMotivo = new JSONObject();
						jsonMotivo.put("id", motivoIds[i]);
						jsonMotivo.put("nome", context.getRequest().getParameter("motivoNome_"+motivoIds[i]));
						jsonMotivi.put(jsonMotivo);
					}
				}
				if (jsonMotivi.length()>0)
					jsonGiornataIspettiva.put("Motivi", jsonMotivi);
			}
		//}

		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			//Aggiunta motivi

			int tecnicaId = Integer.parseInt(((JSONObject) jsonGiornataIspettiva.get("Tecnica")).get("id").toString());

			ArrayList<Esame> listaEsami = new ArrayList<Esame>();
			listaEsami = Esame.buildLista(db, tecnicaId);
			context.getRequest().setAttribute("ListaEsami", listaEsami);

		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);

		return "AddEsameOK";
	}
	
	
	public String executeCommandAddTipoVerifica(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}
/*
		if (jsonGiornataIspettiva.has("TipiVerifica")) {
			jsonGiornataIspettiva.remove("TipiVerifica");
		}*/

		//if (!jsonGiornataIspettiva.has("Esami")) {
			
			String[] esameIds = null;
			try {esameIds = context.getRequest().getParameterValues("esameId");} catch (Exception e) {}

			JSONArray jsonEsami = new JSONArray();

			if (esameIds != null) {
				for (int i = 0; i<esameIds.length;i++){
					if (!esameIds[i].equals("") && Integer.parseInt(esameIds[i])>0){
						JSONObject jsonEsame = new JSONObject();
						jsonEsame.put("id", esameIds[i]);
						jsonEsame.put("nome", context.getRequest().getParameter("esameNome_"+esameIds[i]));
						jsonEsami.put(jsonEsame);
					}
				}
			}
			
			if (jsonEsami.length()>0)
				jsonGiornataIspettiva.put("Esami", jsonEsami);

		//}

		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			//Aggiunta motivi

//			int tecnicaId = Integer.parseInt(((JSONObject) jsonGiornataIspettiva.get("Tecnica")).get("id").toString());
//
//			ArrayList<TipoVerifica> listaTipiVerifica = new ArrayList<TipoVerifica>();
//			listaTipiVerifica = TipoVerifica.buildLista(db, tecnicaId);
//			context.getRequest().setAttribute("ListaTipiVerifica", listaTipiVerifica);
			
			JSONArray jsonMatrici = (JSONArray) jsonGiornataIspettiva.get("Matrici");
			int[] matrici = new int[jsonMatrici.length()];

			for (int i = 0; i<jsonMatrici.length(); i++){
				JSONObject jsonMatrice = (JSONObject) jsonMatrici.get(i);
				matrici[i] = jsonMatrice.getInt("id");
			}
			
			ArrayList<TipoVerifica> listaTipiVerifica = new ArrayList<TipoVerifica>();
			listaTipiVerifica = TipoVerifica.buildListaByMatrici(db, matrici);
			context.getRequest().setAttribute("ListaTipiVerifica", listaTipiVerifica);

		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);

		return "AddTipoVerificaOK";
	}
	

	public String executeCommandAddRiepilogo(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}

		//if (!jsonGiornataIspettiva.has("TipiVerifica")) {
			
			String[] tipoVerificaIds = null;
			try {tipoVerificaIds = context.getRequest().getParameterValues("tipoVerificaId");} catch (Exception e) {}

			JSONArray jsonTipiVerifica = new JSONArray();

			if (tipoVerificaIds != null) {
				for (int i = 0; i<tipoVerificaIds.length;i++){
					JSONObject jsonTipoVerifica = new JSONObject();
					jsonTipoVerifica.put("id", tipoVerificaIds[i]);
					jsonTipoVerifica.put("nome", context.getRequest().getParameter("tipoVerificaNome_"+tipoVerificaIds[i]));
					jsonTipiVerifica.put(jsonTipoVerifica);
				}
			}
			jsonGiornataIspettiva.put("TipiVerifica", jsonTipiVerifica);

		//}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);

		return "AddRiepilogoOK";
	}

	public String executeCommandInsert(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();


		try {jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));} catch (Exception e){}
		if (jsonGiornataIspettiva == null)
			try {jsonGiornataIspettiva = new JSONObject((String) context.getRequest().getAttribute("jsonGiornataIspettiva"));} catch (Exception e){}

		if (jsonGiornataIspettiva.has("Dati")) {
			
	      

		        try {
		        	String dataInizio =null;
					String oraInizio=null;
					String note = null;
					//String dataFine = null;
					//String oraFine = null;

		            // Preleva il valore del campo "dataInizio"
		            JSONObject dataInizio1 = (JSONObject) jsonGiornataIspettiva.get("Dati");
		            dataInizio= (String) dataInizio1.get("dataInizio");
		            oraInizio= (String) dataInizio1.get("oraInizio");
		            note= (String) dataInizio1.get("note");
			
			
			
			//try {dataFine = context.getRequest().getParameter("dataFine");} catch (Exception e) {}
			//try {oraFine = context.getRequest().getParameter("oraFine");} catch (Exception e) {}
			
			JSONObject jsonDati = new JSONObject();
		//	jsonDati.put("dataFine", dataFine);
			//jsonDati.put("oraFine", oraFine);
			jsonDati.put("dataInizio", dataInizio);
			jsonDati.put("oraInizio", oraInizio);
			jsonDati.put("note", note);

			jsonGiornataIspettiva.put("Dati", jsonDati);
			}catch(Exception e){}

		}

		
		

		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			GiornataIspettiva giornataIspettiva = new GiornataIspettiva();
			giornataIspettiva.insert(db, jsonGiornataIspettiva);
			context.getRequest().setAttribute("GiornataIspettiva",  giornataIspettiva);

		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("jsonGiornataIspettiva",  jsonGiornataIspettiva);
		return "InsertOK";
	}
	
	
	
	public String executeCommandClose(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		String giornata;
		
		Integer idGiornata;
		String dataFine;
		String oraFine;

		giornata = context.getRequest().getParameter("idGiornataIspettiva");
		dataFine = context.getRequest().getParameter("dataFine");
		oraFine = context.getRequest().getParameter("oraFine");

		idGiornata = Integer.parseInt(giornata);
		JSONObject jsonGiornataIspettiva = new JSONObject();
		JSONArray jsonCampioni = new JSONArray();
		JSONArray jsonNonConformita = new JSONArray();
		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			GiornataIspettiva giornataIspettiva = new GiornataIspettiva();
			giornataIspettiva.close(db, idGiornata,dataFine,oraFine);
			
			
			int idGiornataIspettiva = -1;
			
			try {idGiornataIspettiva = Integer.parseInt(context.getRequest().getParameter("idGiornataIspettiva"));} catch (Exception e) {}
			if (idGiornataIspettiva == -1)
				try {idGiornataIspettiva = Integer.parseInt((String) context.getRequest().getAttribute("idGiornataIspettiva"));} catch (Exception e) {}

			jsonGiornataIspettiva = GiornataIspettiva.getJson(db, idGiornataIspettiva);
			jsonCampioni = Campione.getJsonLista(db, idGiornataIspettiva);
			jsonNonConformita = NonConformita.getJsonLista(db, idGiornataIspettiva);

	} 

	catch (Exception e) 
	{
		e.printStackTrace();
	}
	finally 
	{
		this.freeConnection(context, db);
	}

	context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);
	context.getRequest().setAttribute("jsonCampioni", jsonCampioni);
	context.getRequest().setAttribute("jsonNonConformita", jsonNonConformita);

	return "ViewOK";
	}
	
	public String executeCommandPrepareSimulazione(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
		
		return "SimulazioneOK";
	}
	
	public String executeCommandSimulazione(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonGiornataIspettiva = new JSONObject();

		try {
			jsonGiornataIspettiva = new JSONObject(context.getRequest().getParameter("jsonGiornataIspettiva"));
		} catch (Exception e){}

	
		if (jsonGiornataIspettiva.has("TipiVerifica"))
			return executeCommandAddRiepilogo(context);
		if (jsonGiornataIspettiva.has("Esami"))
			return executeCommandAddTipoVerifica(context);
		if (jsonGiornataIspettiva.has("Motivi"))
			return executeCommandAddEsame(context);
		if (jsonGiornataIspettiva.has("GruppoIspettivo"))
			return executeCommandAddMotivo(context);
		if (jsonGiornataIspettiva.has("EmissioniAtmosferaCamini"))
			return executeCommandAddGruppoIspettivo(context);
		if (jsonGiornataIspettiva.has("Matrici"))
			return executeCommandAddEmissioniAtmosferaCamini(context);
		if (jsonGiornataIspettiva.has("Linee"))
			return executeCommandAddMatrice(context);
		if (jsonGiornataIspettiva.has("PerContoDi"))
			return executeCommandAddLinea(context);
		if (jsonGiornataIspettiva.has("Dati"))
			return executeCommandAddPerContoDi(context);
		if (jsonGiornataIspettiva.has("Tecnica"))
			return executeCommandAddDati(context);
		if (jsonGiornataIspettiva.has("Dipartimento"))
			return executeCommandAddTecnica(context);
		if (jsonGiornataIspettiva.has("Anagrafica"))
			return executeCommandAdd(context);
		
		return "";
	}
	
	public String executeCommandView(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
	
		JSONObject jsonGiornataIspettiva = new JSONObject();
		JSONArray jsonCampioni = new JSONArray();
		JSONArray jsonNonConformita = new JSONArray();

		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			
				int idGiornataIspettiva = -1;
				
				try {idGiornataIspettiva = Integer.parseInt(context.getRequest().getParameter("idGiornataIspettiva"));} catch (Exception e) {}
				if (idGiornataIspettiva == -1)
					try {idGiornataIspettiva = Integer.parseInt((String) context.getRequest().getAttribute("idGiornataIspettiva"));} catch (Exception e) {}

				jsonGiornataIspettiva = GiornataIspettiva.getJson(db, idGiornataIspettiva);
				jsonCampioni = Campione.getJsonLista(db, idGiornataIspettiva);
				jsonNonConformita = NonConformita.getJsonLista(db, idGiornataIspettiva);

		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonGiornataIspettiva", jsonGiornataIspettiva);
		context.getRequest().setAttribute("jsonCampioni", jsonCampioni);
		context.getRequest().setAttribute("jsonNonConformita", jsonNonConformita);

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
		JSONArray jsonGiornateIspettive = new JSONArray();

		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			
			anag = new Anagrafica(db, riferimentoId, riferimentoIdNomeTab);
			jsonGiornateIspettive = GiornataIspettiva.getJsonLista(db, riferimentoId, riferimentoIdNomeTab);
	
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
		context.getRequest().setAttribute("jsonGiornateIspettive", jsonGiornateIspettive);

		return "ListaOK";
	}
}
