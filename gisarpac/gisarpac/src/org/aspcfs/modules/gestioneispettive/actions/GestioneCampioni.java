package org.aspcfs.modules.gestioneispettive.actions;

import java.sql.Connection;
import java.text.ParseException;
import java.util.ArrayList;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneispettive.base.Campione;
import org.aspcfs.modules.gestioneispettive.base.Componente;
import org.aspcfs.modules.gestioneispettive.base.GiornataIspettiva;
import org.aspcfs.modules.gestioneispettive.base.Matrice;
import org.aspcfs.modules.gestioneispettive.base.MotivoCampionamentoParticella;
import org.aspcfs.modules.gestioneispettive.base.ProgrammaCampionamentoCategoriaMerceologica;
import org.aspcfs.modules.gestioneispettive.base.TipoAnalisi;
import org.aspcfs.modules.gestioneispettive.base.TipoAttivita;
import org.aspcfs.modules.gestioneispettive.base.TipoColturaParticella;
import org.aspcfs.modules.terreni.base.Subparticella;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;

public class GestioneCampioni extends CFSModule{

	public String executeCommandAdd(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{
		return executeCommandAddDati(context);
	}
	
	public String executeCommandAddDati(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}	
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			if (!jsonCampione.has("DatiGiornataIspettiva")){
				int idGiornataIspettiva = -1;

				try {idGiornataIspettiva = Integer.parseInt(context.getRequest().getParameter("idGiornataIspettiva"));} catch (Exception e) {}
				if (idGiornataIspettiva == -1)
					try {idGiornataIspettiva = Integer.parseInt((String) context.getRequest().getAttribute("idGiornataIspettiva"));} catch (Exception e) {}

				JSONObject jsonGiornataIspettiva = GiornataIspettiva.getJson(db, idGiornataIspettiva);
				JSONObject jsonDatiGiornataIspettiva = new JSONObject();
				jsonDatiGiornataIspettiva.put("idGiornataIspettiva", idGiornataIspettiva);
				jsonDatiGiornataIspettiva.put("ragioneSociale", ((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("ragioneSociale"));
				jsonDatiGiornataIspettiva.put("dipartimento", ((JSONObject) jsonGiornataIspettiva.get("Dipartimento")).get("nome"));
				jsonCampione.put("DatiGiornataIspettiva", jsonDatiGiornataIspettiva);

				JSONObject jsonUtente = new JSONObject();
				jsonUtente.put("userId", getUserId(context));
				jsonCampione.put("Utente", jsonUtente);

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

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddDatiOK";
	}
	
	public String executeCommandAddTipoAttivita(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}
		
		if (jsonCampione.has("TipoAttivita")) {
			jsonCampione.remove("TipoAttivita");
		}
		
		if (!jsonCampione.has("Dati")) {
			String numeroVerbale = null;
			String dataPrelievo = null;
			String note = null;
			
			try {numeroVerbale = context.getRequest().getParameter("numeroVerbale");} catch (Exception e) {}
			try {dataPrelievo = context.getRequest().getParameter("dataPrelievo");} catch (Exception e) {}
			try {note = context.getRequest().getParameter("note");} catch (Exception e) {}
			
			JSONObject jsonDati = new JSONObject();
			jsonDati.put("numeroVerbale", numeroVerbale);
			jsonDati.put("dataPrelievo", dataPrelievo);
			jsonDati.put("note", note);
			jsonCampione.put("Dati", jsonDati);
				
		}
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			ArrayList<TipoAttivita> listaTipiAttivita = new ArrayList<TipoAttivita>(); 
			listaTipiAttivita = TipoAttivita.buildLista(db);
			context.getRequest().setAttribute("ListaTipiAttivita", listaTipiAttivita);
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddTipoAttivitaOK";	
	}
	
	public String executeCommandAddProgrammaCampionamentoCategoriaMerceologica(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}
		
		if (jsonCampione.has("ProgrammaCampionamentoCategoriaMerceologica")) {
			jsonCampione.remove("ProgrammaCampionamentoCategoriaMerceologica");
		}
		
		if (!jsonCampione.has("TipoAttivita")) {
			String tipoAttivitaId = null;
			String tipoAttivitaNome = null;

			try {tipoAttivitaId = context.getRequest().getParameter("tipoAttivitaId");} catch (Exception e) {}
			try {tipoAttivitaNome = context.getRequest().getParameter("tipoAttivitaNome_"+tipoAttivitaId);} catch (Exception e) {}

			JSONObject jsonTipoAttivita = new JSONObject();
			jsonTipoAttivita.put("id", tipoAttivitaId);
			jsonTipoAttivita.put("nome", tipoAttivitaNome);
			jsonCampione.put("TipoAttivita", jsonTipoAttivita);
				
		}
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			ArrayList<ProgrammaCampionamentoCategoriaMerceologica> listaProgrammiCampionamentoCategorieMerceologiche = new ArrayList<ProgrammaCampionamentoCategoriaMerceologica>(); 
			listaProgrammiCampionamentoCategorieMerceologiche = ProgrammaCampionamentoCategoriaMerceologica.buildLista(db);
			context.getRequest().setAttribute("ListaProgrammiCampionamentoCategorieMerceologiche", listaProgrammiCampionamentoCategorieMerceologiche); 
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddProgrammaCampionamentoCategoriaMerceologicaOK";	
	}
	
	
	public String executeCommandAddTipoAnalisi(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}
		
		if (jsonCampione.has("TipoAnalisi")) {
			jsonCampione.remove("TipoAnalisi");
		}
		
		if (!jsonCampione.has("ProgrammaCampionamentoCategoriaMerceologica")) {
			
			String[] categorieMerceologicheIds = null;

			try {categorieMerceologicheIds = context.getRequest().getParameterValues("categoriaMerceologicaId");} catch (Exception e) {}

			JSONArray jsonCategorieMerceologiche= new JSONArray();

			if (categorieMerceologicheIds != null) {
				for (int i = 0; i<categorieMerceologicheIds.length;i++){

					JSONObject jsonCategoriaMerceologica = new JSONObject();
					int idCategoriaMerceologica = Integer.parseInt(categorieMerceologicheIds[i]);
					jsonCategoriaMerceologica.put("id", idCategoriaMerceologica);
					jsonCategoriaMerceologica.put("nome", context.getRequest().getParameter("categoriaMerceologicaNome_"+categorieMerceologicheIds[i]).replaceAll("'", ""));
					jsonCategoriaMerceologica.put("nomeProgrammaCampionamento", context.getRequest().getParameter("programmaCampionamentoNome_"+categorieMerceologicheIds[i]).replaceAll("'", ""));
					jsonCategoriaMerceologica.put("nomeProgrammaCampionamentoMacrocategoria", context.getRequest().getParameter("programmaCampionamentoMacrocategoriaNome_"+categorieMerceologicheIds[i]).replaceAll("'", ""));
					jsonCategorieMerceologiche.put(jsonCategoriaMerceologica);
				}
			}
			jsonCampione.put("ProgrammaCampionamentoCategoriaMerceologica", jsonCategorieMerceologiche);
		
		}
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			ArrayList<TipoAnalisi> listaTipiAnalisi = new ArrayList<TipoAnalisi>(); 
			listaTipiAnalisi = TipoAnalisi.buildLista(db);
			context.getRequest().setAttribute("ListaTipiAnalisi", listaTipiAnalisi);
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddTipoAnalisiOK";	
	
	}
	
	public String executeCommandAddLaboratorio(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}
		
		if (jsonCampione.has("Laboratorio")) {
			jsonCampione.remove("Laboratorio");
		}
		
		if (!jsonCampione.has("TipoAnalisi")) {
			
			String[] tipiAnalisiIds = null;

			try {tipiAnalisiIds = context.getRequest().getParameterValues("tipoAnalisiId");} catch (Exception e) {}

			JSONArray jsonTipiAnalisi= new JSONArray();

			if (tipiAnalisiIds != null) {
				for (int i = 0; i<tipiAnalisiIds.length;i++){

					JSONObject jsonTipoAnalisi = new JSONObject();
					int idTipoAnalisi = Integer.parseInt(tipiAnalisiIds[i]);
					jsonTipoAnalisi.put("id", idTipoAnalisi);
					jsonTipoAnalisi.put("prodotto", context.getRequest().getParameter("tipoAnalisiProdotto_"+tipiAnalisiIds[i]).replaceAll("'", ""));
					jsonTipoAnalisi.put("metodi", context.getRequest().getParameter("tipoAnalisiMetodi_"+tipiAnalisiIds[i]).replaceAll("'", ""));
					jsonTipoAnalisi.put("prova", context.getRequest().getParameter("tipoAnalisiProva_"+tipiAnalisiIds[i]).replaceAll("'", ""));
					jsonTipiAnalisi.put(jsonTipoAnalisi);
				}
			}
			jsonCampione.put("TipoAnalisi", jsonTipiAnalisi);
		
		}
		
		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddLaboratorioOK";	
	
	}
	
	public String executeCommandAddGruppoIspettivo(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}
		
		if (jsonCampione.has("GruppoIspettivo")) {
			jsonCampione.remove("GruppoIspettivo");
		}
		
		if (!jsonCampione.has("Laboratorio")) {
			String laboratorioId = null;
			String laboratorioNome = null;

			try {laboratorioId = context.getRequest().getParameter("laboratorioId");} catch (Exception e) {}
			try {laboratorioNome = context.getRequest().getParameter("laboratorioNome_"+laboratorioId);} catch (Exception e) {}

			JSONObject jsonLaboratorio = new JSONObject();
			jsonLaboratorio.put("id", laboratorioId);
			jsonLaboratorio.put("nome", laboratorioNome);
			jsonCampione.put("Laboratorio", jsonLaboratorio);
				
		}
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			ArrayList<Componente> listaComponenti = new ArrayList<Componente>(); 
			listaComponenti = Componente.buildListaGiornataIspettiva(db,Integer.parseInt(String.valueOf((((JSONObject) jsonCampione.get("DatiGiornataIspettiva")).get("idGiornataIspettiva")))));
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

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddGruppoIspettivoOK";	
	
	}
	
	public String executeCommandAddRiepilogo(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}
		
		if (!jsonCampione.has("GruppoIspettivo")) {
			

			String[] componentiIds = null;

			try {componentiIds = context.getRequest().getParameterValues("componenteId");} catch (Exception e) {}

			JSONArray jsonComponenti= new JSONArray();

			if (componentiIds != null) {
				for (int i = 0; i<componentiIds.length;i++){

					JSONObject jsonComponente = new JSONObject();
					int idComponente = Integer.parseInt(componentiIds[i]);
					jsonComponente.put("id", idComponente);
					jsonComponente.put("nominativo", context.getRequest().getParameter("componenteNome_"+componentiIds[i]).replaceAll("'", ""));
					jsonComponente.put("qualifica", context.getRequest().getParameter("componenteQualifica_"+componentiIds[i]).replaceAll("'", ""));
					jsonComponente.put("descrizioneAreaSemplice", context.getRequest().getParameter("componenteAreaSemplice_"+componentiIds[i]).replaceAll("'", ""));
					jsonComponente.put("idAreaSemplice", context.getRequest().getParameter("componenteAreaSempliceId_"+componentiIds[i]).replaceAll("'", ""));
					jsonComponenti.put(jsonComponente);
				}
			}
			jsonCampione.put("GruppoIspettivo", jsonComponenti);
		
		}
	
		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddRiepilogoOK";	
	
	}

	public String executeCommandInsert(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, ParseException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {
			jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));
		} catch (Exception e){}

		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			Campione ca = new Campione();
			ca.insert(db, jsonCampione);
			context.getRequest().setAttribute("Campione",  ca);

		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("jsonCampione",  jsonCampione);
		return "InsertOK";
	}
	
	
	public String executeCommandView(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
	
		JSONObject jsonCampione = new JSONObject();
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			
				int idCampione = -1;
				
				try {idCampione = Integer.parseInt(context.getRequest().getParameter("idCampione"));} catch (Exception e) {}
				if (idCampione == -1)
					try {idCampione = Integer.parseInt((String) context.getRequest().getAttribute("idCampione"));} catch (Exception e) {}

				jsonCampione = Campione.getJson(db, idCampione);

		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "ViewOK";
	}
	
	public String executeCommandAddParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{
		
		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}	
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			
			int idSubparticella = -1;
		
			try {idSubparticella = Integer.parseInt(context.getRequest().getParameter("idSubparticella"));} catch (Exception e) {}
			if (idSubparticella == -1)
				try {idSubparticella = Integer.parseInt((String) context.getRequest().getAttribute("idSubparticella"));} catch (Exception e) {}
			
			JSONArray jsonCampioni = Campione.getJsonListaParticella(db, idSubparticella);
			if (jsonCampioni.length()>0){
				context.getRequest().setAttribute("idSubparticella", String.valueOf(idSubparticella));
				context.getRequest().setAttribute("Messaggio", "Sulla subparticella risulta gia' presente un campionamento. Impossibile aggiungerne uno nuovo.");
				return executeCommandListaParticella(context);
			}
		
			if (!jsonCampione.has("Anagrafica")){
				Subparticella sub = new Subparticella(db, idSubparticella);
				
				JSONObject jsonAnagraficaMinimal = new JSONObject();
				jsonAnagraficaMinimal.put("riferimentoId", sub.getId());
				jsonAnagraficaMinimal.put("riferimentoIdNomeTab", "area_particelle");
				jsonAnagraficaMinimal.put("codiceSito", sub.getCodiceSito());
				jsonAnagraficaMinimal.put("foglioCatastale", sub.getArea().getFoglioCatastale());
				jsonAnagraficaMinimal.put("particellaCatastale", sub.getArea().getParticellaCatastale());
				jsonAnagraficaMinimal.put("comune", sub.getArea().getIdComune());
				jsonAnagraficaMinimal.put("coordinataX", sub.getArea().getCoordinateX());
				jsonAnagraficaMinimal.put("coordinataY", sub.getArea().getCoordinateY()); 
				jsonCampione.put("Anagrafica", jsonAnagraficaMinimal);
			}

			if (!jsonCampione.has("Utente")){
				
				JSONObject jsonUtente = new JSONObject();
				jsonUtente.put("userId", getUserId(context));
				jsonCampione.put("Utente", jsonUtente);
			}
			
			if (!jsonCampione.has("Tecnica")){
				
				JSONObject jsonTecnica = new JSONObject();
				jsonTecnica.put("id", 4);
				jsonTecnica.put("nome", "CAMPIONAMENTO");
				jsonCampione.put("Tecnica", jsonTecnica);
			}
			
			if (!jsonCampione.has("Laboratorio")){
				
				JSONObject jsonLaboratorio = new JSONObject();
				jsonLaboratorio.put("id", 1);
				jsonLaboratorio.put("nome", "ARPAC");
				jsonCampione.put("Laboratorio", jsonLaboratorio);
			}
			
		} catch (Exception e) 
			{
				e.printStackTrace();
			}
			finally 
			{
				this.freeConnection(context, db);
			}

		context.getRequest().setAttribute("jsonCampione", jsonCampione);
	
		return executeCommandAddMotivoParticella(context);
	}
	
	public String executeCommandAddMotivoParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null || jsonCampione.length()==0)
			try {jsonCampione =(JSONObject) context.getRequest().getAttribute("jsonCampione");} catch (Exception e){}	
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			if (jsonCampione.has("Motivo")) {
				jsonCampione.remove("Motivo");
			}

			int riferimentoId = Integer.parseInt(((JSONObject) jsonCampione.get("Anagrafica")).get("riferimentoId").toString());
			
			ArrayList<MotivoCampionamentoParticella> listaMotivi = new ArrayList<MotivoCampionamentoParticella>(); 
			listaMotivi = MotivoCampionamentoParticella.buildLista(db, riferimentoId);
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

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddMotivoParticellaOK";
	}
	
	public String executeCommandAddDatiParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{


		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}
		
		if (jsonCampione.has("Dati")) {
			jsonCampione.remove("Dati");
		}
		if (jsonCampione.has("Matrici")) {
			jsonCampione.remove("Matrici");
		}
		
		if (!jsonCampione.has("Motivo")) {
			int id = -1;
			String descrizione = null;
			
			try {id = Integer.parseInt(context.getRequest().getParameter("motivoId"));} catch (Exception e) {}
			try {descrizione = context.getRequest().getParameter("motivoDescrizione_"+id);} catch (Exception e) {}
			
			JSONObject jsonMotivo = new JSONObject();
			jsonMotivo.put("id", id);
			jsonMotivo.put("descrizione", descrizione);
			jsonCampione.put("Motivo", jsonMotivo);
				
		}
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			ArrayList<Matrice> listaMatrici = Matrice.buildListaCampionamentoParticella(db);
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

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddDatiParticellaOK";	
		}
	
	public String executeCommandAddGruppoTecniciAddettiParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}
		
		if (jsonCampione.has("GruppoTecnici")) {
			jsonCampione.remove("GruppoTecnici");
		}
		if (jsonCampione.has("GruppoAddetti")) {
			jsonCampione.remove("GruppoAddetti");
		}
		
		if (!jsonCampione.has("Matrici")) {
			int id = -1;
			String nome = null;

			try {id = Integer.parseInt(context.getRequest().getParameter("matriceId"));} catch (Exception e) {}
			try {nome = context.getRequest().getParameter("matriceNome_"+id);} catch (Exception e) {}

			JSONArray jsonMatrici= new JSONArray();
			JSONObject jsonMatrice = new JSONObject();
			jsonMatrice.put("id", id);
			jsonMatrice.put("nome", nome);
			jsonMatrici.put(jsonMatrice);
			jsonCampione.put("Matrici", jsonMatrici);
		}
		
		if (!jsonCampione.has("Dati")) {
			String data = null;
			String ore = null;
			String numeroVerbaleAutomatico = null;
			String numeroVerbale = null;

			try {data = context.getRequest().getParameter("dataPrelievo");} catch (Exception e) {}
			try {ore = context.getRequest().getParameter("ore");} catch (Exception e) {}
			try {numeroVerbaleAutomatico = context.getRequest().getParameter("numeroVerbaleAutomatico");} catch (Exception e) {}
			try {numeroVerbale = context.getRequest().getParameter("numeroVerbale");} catch (Exception e) {}

			JSONObject jsonDati = new JSONObject();
			jsonDati.put("dataPrelievo", data);
			jsonDati.put("ore", ore);
			jsonDati.put("numeroVerbaleAutomatico", numeroVerbaleAutomatico);
			jsonDati.put("numeroVerbale", numeroVerbale);
			jsonCampione.put("Dati", jsonDati);
		}
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			
			int annoCorrente = -1;
			String dataPrelievo = (String) ((JSONObject) jsonCampione.get("Dati")).get("dataPrelievo");
			try {annoCorrente = Integer.parseInt(dataPrelievo.substring(0,4));} catch (Exception e) {}
						
			ArrayList<Componente> listaComponentiTecnici = new ArrayList<Componente>(); 
			ArrayList<Componente> listaComponentiTecniciCampionamento = Componente.buildListaParticella(db, 9, -1);
			ArrayList<Componente> listaComponentiDirezioneTecnicaArpac = Componente.buildListaParticella(db, 44, -1);
			
			listaComponentiTecnici.addAll(listaComponentiTecniciCampionamento);
			listaComponentiTecnici.addAll(listaComponentiDirezioneTecnicaArpac);
			
			context.getRequest().setAttribute("ListaComponentiTecnici", listaComponentiTecnici);
			
//			ArrayList<Componente> listaComponentiAddetti = new ArrayList<Componente>(); 
//			listaComponentiAddetti = Componente.buildListaParticella(db, 8, -1);
//			context.getRequest().setAttribute("ListaComponentiAddetti", listaComponentiAddetti);
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddGruppoTecniciAddettiParticellaOK";	
	
	}
	
	public String executeCommandAddVerbaleParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}

		if (jsonCampione.has("DatiVerbaleCampione")) {
			jsonCampione.remove("DatiVerbaleCampione");
		}

		if (!jsonCampione.has("GruppoTecnici")) {
		
			String[] componentiTecniciIds = null;

			try {componentiTecniciIds = context.getRequest().getParameterValues("componenteTecnicoId");} catch (Exception e) {}

			JSONArray jsonComponentiTecnici= new JSONArray();

			if (componentiTecniciIds != null) {
				for (int i = 0; i<componentiTecniciIds.length;i++){

					JSONObject jsonComponenteTecnico = new JSONObject();
					int idComponente = Integer.parseInt(componentiTecniciIds[i]);
					jsonComponenteTecnico.put("id", idComponente);
					jsonComponenteTecnico.put("nominativo", context.getRequest().getParameter("componenteTecnicoNome_"+componentiTecniciIds[i]).replaceAll("'", ""));
					jsonComponenteTecnico.put("qualifica", context.getRequest().getParameter("componenteTecnicoQualifica_"+componentiTecniciIds[i]).replaceAll("'", ""));
					jsonComponentiTecnici.put(jsonComponenteTecnico);
				}
			}
			jsonCampione.put("GruppoTecnici", jsonComponentiTecnici);
		
		}
		
		if (!jsonCampione.has("GruppoAddetti")) {
		
			String componenteAddettoNome1 = "";
			String componenteAddettoNome2 = "";
			String componenteAddettoNome3 = "";
			String componenteAddettoCognome1 = "";
			String componenteAddettoCognome2 = "";
			String componenteAddettoCognome3 = "";			

			try {componenteAddettoNome1 = context.getRequest().getParameter("componenteAddettoNome1");} catch (Exception e) {}
			try {componenteAddettoNome2 = context.getRequest().getParameter("componenteAddettoNome2");} catch (Exception e) {}
			try {componenteAddettoNome3 = context.getRequest().getParameter("componenteAddettoNome3");} catch (Exception e) {}
			try {componenteAddettoCognome1 = context.getRequest().getParameter("componenteAddettoCognome1");} catch (Exception e) {}
			try {componenteAddettoCognome2 = context.getRequest().getParameter("componenteAddettoCognome2");} catch (Exception e) {}
			try {componenteAddettoCognome3 = context.getRequest().getParameter("componenteAddettoCognome3");} catch (Exception e) {}

			JSONObject jsonComponentiAddetti = new JSONObject();
			jsonComponentiAddetti.put("nome1", componenteAddettoNome1.replaceAll("'", ""));
			jsonComponentiAddetti.put("cognome1", componenteAddettoCognome1.replaceAll("'", ""));
			jsonComponentiAddetti.put("nome2", componenteAddettoNome2.replaceAll("'", ""));
			jsonComponentiAddetti.put("cognome2", componenteAddettoCognome2.replaceAll("'", ""));
			jsonComponentiAddetti.put("nome3", componenteAddettoNome3.replaceAll("'", ""));
			jsonComponentiAddetti.put("cognome3", componenteAddettoCognome3.replaceAll("'", ""));
			jsonCampione.put("GruppoAddetti", jsonComponentiAddetti);
		
		}

		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			
			ArrayList<TipoColturaParticella> listaTipiColture = new ArrayList<TipoColturaParticella>(); 
			listaTipiColture = TipoColturaParticella.buildLista(db);
			context.getRequest().setAttribute("ListaTipiColture", listaTipiColture);

		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddVerbaleParticellaOK";
	}
	
	public String executeCommandAddRiepilogoParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException, JSONException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));} catch (Exception e){}
		if (jsonCampione == null)
			try {jsonCampione = new JSONObject((String) context.getRequest().getAttribute("jsonCampione"));} catch (Exception e){}
		
		if (!jsonCampione.has("DatiVerbaleCampione")) {
			
			JSONObject jsonDatiVerbaleCampione = new JSONObject();

			String carabinieriForestali = null;
			String altriPartecipanti1 = null;
			String qualitaAltriPartecipanti1 = null;
			String altriPartecipanti2 = null;
			String qualitaAltriPartecipanti2 = null;
			String altriPartecipanti3 = null;
			String qualitaAltriPartecipanti3 = null;
			boolean proprietarioPresente = false;
			String datiProprietarioParticella = null;
			String datiAltraPersonaPresente = null;
			String qualitaAltraPersonaPresente = null;
			
			
			try {carabinieriForestali = context.getRequest().getParameter("carabinieriForestali");} catch (Exception e) {}
			try {altriPartecipanti1 = context.getRequest().getParameter("altriPartecipanti1");} catch (Exception e) {}
			try {qualitaAltriPartecipanti1 = context.getRequest().getParameter("qualitaAltriPartecipanti1");} catch (Exception e) {}
			try {altriPartecipanti2 = context.getRequest().getParameter("altriPartecipanti2");} catch (Exception e) {}
			try {qualitaAltriPartecipanti2 = context.getRequest().getParameter("qualitaAltriPartecipanti2");} catch (Exception e) {}
			try {altriPartecipanti3 = context.getRequest().getParameter("altriPartecipanti3");} catch (Exception e) {}
			try {qualitaAltriPartecipanti3 = context.getRequest().getParameter("qualitaAltriPartecipanti3");} catch (Exception e) {}
			try {proprietarioPresente = Boolean.parseBoolean(context.getRequest().getParameter("proprietarioPresente"));} catch (Exception e) {}
			try {datiProprietarioParticella = context.getRequest().getParameter("datiProprietarioParticella");} catch (Exception e) {}
			try {datiAltraPersonaPresente = context.getRequest().getParameter("datiAltraPersonaPresente");} catch (Exception e) {}
			try {qualitaAltraPersonaPresente = context.getRequest().getParameter("qualitaAltraPersonaPresente");} catch (Exception e) {}

			jsonDatiVerbaleCampione.put("carabinieriForestali", carabinieriForestali);
			
			jsonDatiVerbaleCampione.put("altriPartecipanti1", altriPartecipanti1);
			jsonDatiVerbaleCampione.put("qualitaAltriPartecipanti1", qualitaAltriPartecipanti1);
			
			jsonDatiVerbaleCampione.put("altriPartecipanti2", altriPartecipanti2);
			jsonDatiVerbaleCampione.put("qualitaAltriPartecipanti2", qualitaAltriPartecipanti2);
			
			jsonDatiVerbaleCampione.put("altriPartecipanti3", altriPartecipanti3);
			jsonDatiVerbaleCampione.put("qualitaAltriPartecipanti3", qualitaAltriPartecipanti3);
			
			jsonDatiVerbaleCampione.put("proprietarioPresente", proprietarioPresente);
			jsonDatiVerbaleCampione.put("datiProprietarioParticella", datiProprietarioParticella);
			jsonDatiVerbaleCampione.put("datiAltraPersonaPresente", datiAltraPersonaPresente);
			jsonDatiVerbaleCampione.put("qualitaAltraPersonaPresente", qualitaAltraPersonaPresente);

			String codiceIdentificativoVoc = null;
			String coordXVoc = null;
			String coordYVoc = null;
			
			String codiceIdentificativoMedioComposito = null;
			
			String[] codiceIdentificativo = new String[5];
			String[] coordX = new String[5];
			String[] coordY = new String[5];
			
			try {codiceIdentificativoVoc = context.getRequest().getParameter("codiceIdentificativoVoc");} catch (Exception e) {}
			try {coordXVoc = context.getRequest().getParameter("coordinataXVoc");} catch (Exception e) {}
			try {coordYVoc = context.getRequest().getParameter("coordinataYVoc");} catch (Exception e) {}
			
			try {codiceIdentificativoMedioComposito = context.getRequest().getParameter("codiceIdentificativoMedioComposito");} catch (Exception e) {}

			for (int i = 0; i<5; i++){
				try {codiceIdentificativo[i] = context.getRequest().getParameter("codiceIdentificativo"+(i+1));} catch (Exception e) {}
				try {coordX[i] = context.getRequest().getParameter("coordinataX"+(i+1));} catch (Exception e) {}
				try {coordY[i] = context.getRequest().getParameter("coordinataY"+(i+1));} catch (Exception e) {}
			}
			
			jsonDatiVerbaleCampione.put("codiceIdentificativoVoc", codiceIdentificativoVoc);
			jsonDatiVerbaleCampione.put("coordinataXVoc", coordXVoc);
			jsonDatiVerbaleCampione.put("coordinataYVoc", coordYVoc);
			
			jsonDatiVerbaleCampione.put("codiceIdentificativoMedioComposito", codiceIdentificativoMedioComposito);
			
			for (int i = 0; i<5; i++){
				jsonDatiVerbaleCampione.put("codiceIdentificativo"+(i+1), codiceIdentificativo[i]);
				jsonDatiVerbaleCampione.put("coordinataX"+(i+1), coordX[i]);
				jsonDatiVerbaleCampione.put("coordinataY"+(i+1), coordY[i]);
			}
			
			String numCampioniElementari = null;
			String tipoColturaCodice = null;
			String tipoColturaDescrizione = null;
			String tipoColturaNote = null;
			String tipoColturaMotivazione = null;

			String presenzaRifiuti = null;
			String presenzaRifiutiNote = null;
			String presenzaRifiutiDescrizione = null;
			
			boolean irrigazioneInLoco = false;
			String irrigazioneInformazioni = null;
			String irrigazioneDerivazione = null;
			boolean pozzoCampionamento = false;
			String pozzoCampionamentoVerbaleNumero = null;
			String pozzoCampionamentoVerbaleData = null;
			String dichiarazioni = null;
			String strumentazione = null;
			String noteAggiuntive = null;

			try {numCampioniElementari = context.getRequest().getParameter("numCampioniElementari");} catch (Exception e) {}
			try {tipoColturaCodice = context.getRequest().getParameter("tipoColturaParticellaCodice");} catch (Exception e) {}
			try {tipoColturaDescrizione = context.getRequest().getParameter("tipoColturaParticellaDescrizione_"+tipoColturaCodice);} catch (Exception e) {}
			try {tipoColturaNote = context.getRequest().getParameter("tipoColturaParticellaNote");} catch (Exception e) {}
			try {tipoColturaMotivazione = context.getRequest().getParameter("tipoColturaParticellaMotivazione");} catch (Exception e) {}
			try {presenzaRifiuti = context.getRequest().getParameter("presenzaRifiuti");} catch (Exception e) {}
			try {presenzaRifiutiNote = context.getRequest().getParameter("presenzaRifiutiNote");} catch (Exception e) {}
			try {presenzaRifiutiDescrizione = context.getRequest().getParameter("presenzaRifiutiDescrizione");} catch (Exception e) {}
			
			try {irrigazioneInLoco = Boolean.parseBoolean(context.getRequest().getParameter("irrigazioneInLoco"));} catch (Exception e) {}
			try {irrigazioneInformazioni = context.getRequest().getParameter("irrigazioneInformazioni");} catch (Exception e) {}
			try {irrigazioneDerivazione = context.getRequest().getParameter("irrigazioneDerivazione");} catch (Exception e) {}
			try {pozzoCampionamento = Boolean.parseBoolean(context.getRequest().getParameter("pozzoCampionamento"));} catch (Exception e) {}
			try {pozzoCampionamentoVerbaleNumero = context.getRequest().getParameter("pozzoCampionamentoVerbaleNumero");} catch (Exception e) {}
			try {pozzoCampionamentoVerbaleData = context.getRequest().getParameter("pozzoCampionamentoVerbaleData");} catch (Exception e) {}
			try {dichiarazioni = context.getRequest().getParameter("dichiarazioni");} catch (Exception e) {}
			try {strumentazione = context.getRequest().getParameter("strumentazione");} catch (Exception e) {}
			try {noteAggiuntive = context.getRequest().getParameter("noteAggiuntive");} catch (Exception e) {}

			jsonDatiVerbaleCampione.put("numCampioniElementari", numCampioniElementari);
			jsonDatiVerbaleCampione.put("tipoColturaCodice", tipoColturaCodice);
			jsonDatiVerbaleCampione.put("tipoColturaDescrizione", tipoColturaDescrizione);
			jsonDatiVerbaleCampione.put("tipoColturaNote", tipoColturaNote);
			jsonDatiVerbaleCampione.put("tipoColturaMotivazione", tipoColturaMotivazione);
			jsonDatiVerbaleCampione.put("presenzaRifiuti", presenzaRifiuti);
			jsonDatiVerbaleCampione.put("presenzaRifiutiNote", presenzaRifiutiNote);
			jsonDatiVerbaleCampione.put("presenzaRifiutiDescrizione", presenzaRifiutiDescrizione); 
			
			jsonDatiVerbaleCampione.put("irrigazioneInLoco", irrigazioneInLoco); 
			jsonDatiVerbaleCampione.put("irrigazioneInformazioni", irrigazioneInformazioni); 
			jsonDatiVerbaleCampione.put("irrigazioneDerivazione", irrigazioneDerivazione); 
			jsonDatiVerbaleCampione.put("pozzoCampionamento", pozzoCampionamento); 
			jsonDatiVerbaleCampione.put("pozzoCampionamentoVerbaleNumero", pozzoCampionamentoVerbaleNumero); 
			jsonDatiVerbaleCampione.put("pozzoCampionamentoVerbaleData", pozzoCampionamentoVerbaleData); 
			jsonDatiVerbaleCampione.put("dichiarazioni", dichiarazioni); 
			jsonDatiVerbaleCampione.put("strumentazione", strumentazione); 
			jsonDatiVerbaleCampione.put("noteAggiuntive", noteAggiuntive); 


			boolean aliquotaA = false;
			boolean aliquotaBG = false;
			boolean aliquotaC = false;
			boolean aliquotaD = false;
			boolean aliquotaE = false;
			boolean aliquotaF = false;
			boolean aliquotaH = false;
			boolean aliquotaI = false;
			boolean aliquotaLM = false;
			boolean aliquotaN = false;
			boolean aliquotaCD_fitofarmaci = false;
			
			String aliquotaA_data = null;
			String aliquotaC_data = null;
			String aliquotaD_data = null;
			String aliquotaI_data = null;
			String aliquotaLM_data = null;
			
			String aliquotaA_ora = null;
			String aliquotaC_ora = null;
			String aliquotaD_ora = null;
			String aliquotaI_ora = null;
			String aliquotaLM_ora = null;
			
			try {aliquotaA = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaA"));} catch (Exception e) {} 
			try {aliquotaBG = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaBG"));} catch (Exception e) {}
			try {aliquotaC = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaC"));} catch (Exception e) {}
			try {aliquotaD = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaD"));} catch (Exception e) {}
			try {aliquotaE = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaE"));} catch (Exception e) {}
			try {aliquotaF = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaF"));} catch (Exception e) {}
			try {aliquotaH = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaH"));} catch (Exception e) {}
			try {aliquotaI = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaI"));} catch (Exception e) {}
			try {aliquotaLM = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaLM"));} catch (Exception e) {}
			try {aliquotaN = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaN"));} catch (Exception e) {}			
			try {aliquotaCD_fitofarmaci = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaCD_fitofarmaci"));} catch (Exception e) {}
			
			try {aliquotaA_data = context.getRequest().getParameter("aliquotaA_data");} catch (Exception e) {} 
			try {aliquotaC_data = context.getRequest().getParameter("aliquotaC_data");} catch (Exception e) {}
			try {aliquotaD_data = context.getRequest().getParameter("aliquotaD_data");} catch (Exception e) {}
			try {aliquotaI_data = context.getRequest().getParameter("aliquotaI_data");} catch (Exception e) {}
			try {aliquotaLM_data = context.getRequest().getParameter("aliquotaLM_data");} catch (Exception e) {}
			
			try {aliquotaA_ora = context.getRequest().getParameter("aliquotaA_ora");} catch (Exception e) {} 
			try {aliquotaC_ora = context.getRequest().getParameter("aliquotaC_ora");} catch (Exception e) {}
			try {aliquotaD_ora = context.getRequest().getParameter("aliquotaD_ora");} catch (Exception e) {}
			try {aliquotaI_ora = context.getRequest().getParameter("aliquotaI_ora");} catch (Exception e) {}
			try {aliquotaLM_ora = context.getRequest().getParameter("aliquotaLM_ora");} catch (Exception e) {}
			
			jsonDatiVerbaleCampione.put("aliquotaA", aliquotaA); 
			jsonDatiVerbaleCampione.put("aliquotaBG", aliquotaBG);
			jsonDatiVerbaleCampione.put("aliquotaC", aliquotaC);
			jsonDatiVerbaleCampione.put("aliquotaD", aliquotaD);
			jsonDatiVerbaleCampione.put("aliquotaE", aliquotaE);
			jsonDatiVerbaleCampione.put("aliquotaF", aliquotaF);
			jsonDatiVerbaleCampione.put("aliquotaH", aliquotaH);
			jsonDatiVerbaleCampione.put("aliquotaI", aliquotaI);
			jsonDatiVerbaleCampione.put("aliquotaLM", aliquotaLM);
			jsonDatiVerbaleCampione.put("aliquotaN", aliquotaN);			
			jsonDatiVerbaleCampione.put("aliquotaCD_fitofarmaci", aliquotaCD_fitofarmaci);		
			
			jsonDatiVerbaleCampione.put("aliquotaA_data", aliquotaA_data);
			jsonDatiVerbaleCampione.put("aliquotaC_data", aliquotaC_data);
			jsonDatiVerbaleCampione.put("aliquotaD_data", aliquotaD_data);
			jsonDatiVerbaleCampione.put("aliquotaI_data", aliquotaI_data);
			jsonDatiVerbaleCampione.put("aliquotaLM_data", aliquotaLM_data);
			
			jsonDatiVerbaleCampione.put("aliquotaA_ora", aliquotaA_ora);
			jsonDatiVerbaleCampione.put("aliquotaC_ora", aliquotaC_ora);
			jsonDatiVerbaleCampione.put("aliquotaD_ora", aliquotaD_ora);
			jsonDatiVerbaleCampione.put("aliquotaI_ora", aliquotaI_ora);
			jsonDatiVerbaleCampione.put("aliquotaLM_ora", aliquotaLM_ora);
			
			jsonCampione.put("DatiVerbaleCampione", jsonDatiVerbaleCampione);
		
		}
	
		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "AddRiepilogoParticellaOK";	
	
	}
	
	public String executeCommandInsertParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}

		JSONObject jsonCampione = new JSONObject();

		try {
			jsonCampione = new JSONObject(context.getRequest().getParameter("jsonCampione"));
		} catch (Exception e){}

		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			Campione ca = new Campione();
			ca.insertParticella(db, jsonCampione);
			context.getRequest().setAttribute("Campione",  ca);

		} 

		catch (Exception e)  
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("jsonCampione",  jsonCampione);
		return "InsertParticellaOK";
	}
	
	public String executeCommandViewParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
	
		JSONObject jsonCampione = new JSONObject();
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			
				int idCampione = -1;
				
				try {idCampione = Integer.parseInt(context.getRequest().getParameter("idCampione"));} catch (Exception e) {}
				if (idCampione == -1)
					try {idCampione = Integer.parseInt((String) context.getRequest().getAttribute("idCampione"));} catch (Exception e) {}

				jsonCampione = Campione.getJsonParticella(db, idCampione);

		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "ViewParticellaOK";
	}
	
	public String executeCommandListaParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{ 

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
	
		int idSubparticella = -1;

		try {idSubparticella = Integer.parseInt(context.getRequest().getParameter("idSubparticella"));} catch (Exception e) {}
		if (idSubparticella == -1)
			try {idSubparticella = Integer.parseInt((String) context.getRequest().getAttribute("idSubparticella"));} catch (Exception e) {}

		context.getRequest().setAttribute("Messaggio", String.valueOf((String) context.getRequest().getAttribute("Messaggio")));

		Subparticella sub = null;
		JSONArray jsonCampioni = new JSONArray();

		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			
			sub = new Subparticella(db, idSubparticella);
			jsonCampioni = Campione.getJsonListaParticella(db, idSubparticella);
	
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("Anagrafica", sub);
		context.getRequest().setAttribute("jsonCampioni", jsonCampioni);

		return "ListaParticellaOK";
	}
	
	public String executeCommandModifyParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
	
		JSONObject jsonCampione = new JSONObject();
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			
				int idCampione = -1;
				
				try {idCampione = Integer.parseInt(context.getRequest().getParameter("idCampione"));} catch (Exception e) {}
				if (idCampione == -1)
					try {idCampione = Integer.parseInt((String) context.getRequest().getAttribute("idCampione"));} catch (Exception e) {}

				jsonCampione = Campione.getJsonParticella(db, idCampione);
				
				int riferimentoId = Integer.parseInt(((JSONObject) jsonCampione.get("Anagrafica")).get("riferimentoId").toString());

				ArrayList<MotivoCampionamentoParticella> listaMotivi = new ArrayList<MotivoCampionamentoParticella>(); 
				listaMotivi = MotivoCampionamentoParticella.buildLista(db, riferimentoId);
				context.getRequest().setAttribute("ListaMotivi", listaMotivi);
				
				ArrayList<Matrice> listaMatrici = Matrice.buildListaCampionamentoParticella(db);
				context.getRequest().setAttribute("ListaMatrici", listaMatrici);
				
				int annoCorrente = -1;
				String dataPrelievo = (String) ((JSONObject) jsonCampione.get("Dati")).get("dataPrelievo");
				try {annoCorrente = Integer.parseInt(dataPrelievo.substring(0,4));} catch (Exception e) {}
							
				ArrayList<Componente> listaComponentiTecnici = new ArrayList<Componente>(); 
				listaComponentiTecnici = Componente.buildListaParticella(db, 9, -1); 
				context.getRequest().setAttribute("ListaComponentiTecnici", listaComponentiTecnici);
					
				ArrayList<TipoColturaParticella> listaTipiColture = new ArrayList<TipoColturaParticella>(); 
				listaTipiColture = TipoColturaParticella.buildLista(db);
				context.getRequest().setAttribute("ListaTipiColture", listaTipiColture);

		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "ModifyParticellaOK";
	}
	
	public String executeCommandUpdateParticella(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		if (!hasPermission(context, "gestionenuovacu-add")) {
			return ("PermissionError");
		}
	
		JSONObject jsonCampione = new JSONObject();
		
		Connection db = null;

		try 
		{
			db = this.getConnection(context);
			
			int idCampione = -1;
			try {idCampione = Integer.parseInt(context.getRequest().getParameter("idCampione"));} catch (Exception e) {}
	
			JSONObject jsonCampiServizio = new JSONObject();
			jsonCampiServizio.put("idCampione",idCampione);
			jsonCampione.put("CampiServizio", jsonCampiServizio);
				
			JSONObject jsonUtente = new JSONObject();
			jsonUtente.put("userId", getUserId(context));
			jsonCampione.put("Utente", jsonUtente);

			int id = -1;
			String descrizione = null;
			
			try {id = Integer.parseInt(context.getRequest().getParameter("motivoId"));} catch (Exception e) {}
			try {descrizione = context.getRequest().getParameter("motivoDescrizione_"+id);} catch (Exception e) {}
			
			JSONObject jsonMotivo = new JSONObject();
			jsonMotivo.put("id", id);
			jsonMotivo.put("descrizione", descrizione);
			jsonCampione.put("Motivo", jsonMotivo);

			id = -1;
			String nome = null;

			try {id = Integer.parseInt(context.getRequest().getParameter("matriceId"));} catch (Exception e) {}
			try {nome = context.getRequest().getParameter("matriceNome_"+id);} catch (Exception e) {}

			JSONArray jsonMatrici= new JSONArray();
			JSONObject jsonMatrice = new JSONObject();
			jsonMatrice.put("id", id);
			jsonMatrice.put("nome", nome);
			jsonMatrici.put(jsonMatrice);
			jsonCampione.put("Matrici", jsonMatrici);

			String data = null;
			String ore = null;
			String numeroVerbaleAutomatico = null;
			String numeroVerbale = null;

			try {data = context.getRequest().getParameter("dataPrelievo");} catch (Exception e) {}
			try {ore = context.getRequest().getParameter("ore");} catch (Exception e) {}
			try {numeroVerbaleAutomatico = context.getRequest().getParameter("numeroVerbaleAutomatico");} catch (Exception e) {}
			try {numeroVerbale = context.getRequest().getParameter("numeroVerbale");} catch (Exception e) {}

			JSONObject jsonDati = new JSONObject();
			jsonDati.put("dataPrelievo", data);
			jsonDati.put("ore", ore);
			jsonDati.put("numeroVerbaleAutomatico", numeroVerbaleAutomatico);
			jsonDati.put("numeroVerbale", numeroVerbale);
			jsonCampione.put("Dati", jsonDati);

			String[] componentiTecniciIds = null;

			try {componentiTecniciIds = context.getRequest().getParameterValues("componenteTecnicoId");} catch (Exception e) {}

			JSONArray jsonComponentiTecnici= new JSONArray();

			if (componentiTecniciIds != null) {
				for (int i = 0; i<componentiTecniciIds.length;i++){

					JSONObject jsonComponenteTecnico = new JSONObject();
					int idComponente = Integer.parseInt(componentiTecniciIds[i]);
					jsonComponenteTecnico.put("id", idComponente);
					jsonComponenteTecnico.put("nominativo", context.getRequest().getParameter("componenteTecnicoNome_"+componentiTecniciIds[i]).replaceAll("'", ""));
					jsonComponenteTecnico.put("qualifica", context.getRequest().getParameter("componenteTecnicoQualifica_"+componentiTecniciIds[i]).replaceAll("'", ""));
					jsonComponentiTecnici.put(jsonComponenteTecnico);
				}
			}
			jsonCampione.put("GruppoTecnici", jsonComponentiTecnici);

			JSONObject jsonComponentiAddetti = new JSONObject();
			String componenteAddettoNome1 = "";
			String componenteAddettoNome2 = "";
			String componenteAddettoNome3 = "";
			String componenteAddettoCognome1 = "";
			String componenteAddettoCognome2 = "";
			String componenteAddettoCognome3 = "";			

			try {componenteAddettoNome1 = context.getRequest().getParameter("componenteAddettoNome1");} catch (Exception e) {}
			try {componenteAddettoNome2 = context.getRequest().getParameter("componenteAddettoNome2");} catch (Exception e) {}
			try {componenteAddettoNome3 = context.getRequest().getParameter("componenteAddettoNome3");} catch (Exception e) {}
			try {componenteAddettoCognome1 = context.getRequest().getParameter("componenteAddettoCognome1");} catch (Exception e) {}
			try {componenteAddettoCognome2 = context.getRequest().getParameter("componenteAddettoCognome2");} catch (Exception e) {}
			try {componenteAddettoCognome3 = context.getRequest().getParameter("componenteAddettoCognome3");} catch (Exception e) {}

			jsonComponentiAddetti.put("nome1", componenteAddettoNome1.replaceAll("'", ""));
			jsonComponentiAddetti.put("cognome1", componenteAddettoCognome1.replaceAll("'", ""));
			jsonComponentiAddetti.put("nome2", componenteAddettoNome2.replaceAll("'", ""));
			jsonComponentiAddetti.put("cognome2", componenteAddettoCognome2.replaceAll("'", ""));
			jsonComponentiAddetti.put("nome3", componenteAddettoNome3.replaceAll("'", ""));
			jsonComponentiAddetti.put("cognome3", componenteAddettoCognome3.replaceAll("'", ""));
			jsonCampione.put("GruppoAddetti", jsonComponentiAddetti);

			JSONObject jsonDatiVerbaleCampione = new JSONObject();

			String carabinieriForestali = null;
			String altriPartecipanti1 = null;
			String qualitaAltriPartecipanti1 = null;
			String altriPartecipanti2 = null;
			String qualitaAltriPartecipanti2 = null;
			String altriPartecipanti3 = null;
			String qualitaAltriPartecipanti3 = null;
			boolean proprietarioPresente = false;
			String datiProprietarioParticella = null;
			String datiAltraPersonaPresente = null;
			String qualitaAltraPersonaPresente = null;			
			
			try {carabinieriForestali = context.getRequest().getParameter("carabinieriForestali");} catch (Exception e) {}
			try {altriPartecipanti1 = context.getRequest().getParameter("altriPartecipanti1");} catch (Exception e) {}
			try {qualitaAltriPartecipanti1 = context.getRequest().getParameter("qualitaAltriPartecipanti1");} catch (Exception e) {}
			try {altriPartecipanti2 = context.getRequest().getParameter("altriPartecipanti2");} catch (Exception e) {}
			try {qualitaAltriPartecipanti2 = context.getRequest().getParameter("qualitaAltriPartecipanti2");} catch (Exception e) {}
			try {altriPartecipanti3 = context.getRequest().getParameter("altriPartecipanti3");} catch (Exception e) {}
			try {qualitaAltriPartecipanti3 = context.getRequest().getParameter("qualitaAltriPartecipanti3");} catch (Exception e) {}
			try {proprietarioPresente = Boolean.parseBoolean(context.getRequest().getParameter("proprietarioPresente"));} catch (Exception e) {}
			try {datiProprietarioParticella = context.getRequest().getParameter("datiProprietarioParticella");} catch (Exception e) {}
			try {datiAltraPersonaPresente = context.getRequest().getParameter("datiAltraPersonaPresente");} catch (Exception e) {}
			try {qualitaAltraPersonaPresente = context.getRequest().getParameter("qualitaAltraPersonaPresente");} catch (Exception e) {}

			jsonDatiVerbaleCampione.put("carabinieriForestali", carabinieriForestali);
			
			jsonDatiVerbaleCampione.put("altriPartecipanti1", altriPartecipanti1);
			jsonDatiVerbaleCampione.put("qualitaAltriPartecipanti1", qualitaAltriPartecipanti1);
			
			jsonDatiVerbaleCampione.put("altriPartecipanti2", altriPartecipanti2);
			jsonDatiVerbaleCampione.put("qualitaAltriPartecipanti2", qualitaAltriPartecipanti2);
			
			jsonDatiVerbaleCampione.put("altriPartecipanti3", altriPartecipanti3);
			jsonDatiVerbaleCampione.put("qualitaAltriPartecipanti3", qualitaAltriPartecipanti3);
			
			jsonDatiVerbaleCampione.put("proprietarioPresente", proprietarioPresente);
			jsonDatiVerbaleCampione.put("datiProprietarioParticella", datiProprietarioParticella);
			jsonDatiVerbaleCampione.put("datiAltraPersonaPresente", datiAltraPersonaPresente);
			jsonDatiVerbaleCampione.put("qualitaAltraPersonaPresente", qualitaAltraPersonaPresente);

			String codiceIdentificativoVoc = null;
			String coordXVoc = null;
			String coordYVoc = null;
			
			String codiceIdentificativoMedioComposito = null;
			
			String[] codiceIdentificativo = new String[5];
			String[] coordX = new String[5];
			String[] coordY = new String[5];
			
			try {codiceIdentificativoVoc = context.getRequest().getParameter("codiceIdentificativoVoc");} catch (Exception e) {}
			try {coordXVoc = context.getRequest().getParameter("coordinataXVoc");} catch (Exception e) {}
			try {coordYVoc = context.getRequest().getParameter("coordinataYVoc");} catch (Exception e) {}
			
			try {codiceIdentificativoMedioComposito = context.getRequest().getParameter("codiceIdentificativoMedioComposito");} catch (Exception e) {}

			for (int i = 0; i<5; i++){
				try {codiceIdentificativo[i] = context.getRequest().getParameter("codiceIdentificativo"+(i+1));} catch (Exception e) {}
				try {coordX[i] = context.getRequest().getParameter("coordinataX"+(i+1));} catch (Exception e) {}
				try {coordY[i] = context.getRequest().getParameter("coordinataY"+(i+1));} catch (Exception e) {}
			}
			
			jsonDatiVerbaleCampione.put("codiceIdentificativoVoc", codiceIdentificativoVoc);
			jsonDatiVerbaleCampione.put("coordinataXVoc", coordXVoc);
			jsonDatiVerbaleCampione.put("coordinataYVoc", coordYVoc);
			
			jsonDatiVerbaleCampione.put("codiceIdentificativoMedioComposito", codiceIdentificativoMedioComposito);
			
			for (int i = 0; i<5; i++){
				jsonDatiVerbaleCampione.put("codiceIdentificativo"+(i+1), codiceIdentificativo[i]);
				jsonDatiVerbaleCampione.put("coordinataX"+(i+1), coordX[i]);
				jsonDatiVerbaleCampione.put("coordinataY"+(i+1), coordY[i]);
			}
			
			String numCampioniElementari = null;
			String tipoColturaCodice = null;
			String tipoColturaDescrizione = null;
			String tipoColturaNote = null;
			String tipoColturaMotivazione = null;

			String presenzaRifiuti = null;
			String presenzaRifiutiNote = null;
			String presenzaRifiutiDescrizione = null;
			
			boolean irrigazioneInLoco = false;
			String irrigazioneInformazioni = null;
			String irrigazioneDerivazione = null;
			boolean pozzoCampionamento = false;
			String pozzoCampionamentoVerbaleNumero = null;
			String pozzoCampionamentoVerbaleData = null;
			String dichiarazioni = null;
			String strumentazione = null;
			String noteAggiuntive = null;

			try {numCampioniElementari = context.getRequest().getParameter("numCampioniElementari");} catch (Exception e) {}
			try {tipoColturaCodice = context.getRequest().getParameter("tipoColturaParticellaCodice");} catch (Exception e) {}
			try {tipoColturaDescrizione = context.getRequest().getParameter("tipoColturaParticellaDescrizione_"+tipoColturaCodice);} catch (Exception e) {}
			try {tipoColturaNote = context.getRequest().getParameter("tipoColturaParticellaNote");} catch (Exception e) {}
			try {tipoColturaMotivazione = context.getRequest().getParameter("tipoColturaParticellaMotivazione");} catch (Exception e) {}
			try {presenzaRifiuti = context.getRequest().getParameter("presenzaRifiuti");} catch (Exception e) {}
			try {presenzaRifiutiNote = context.getRequest().getParameter("presenzaRifiutiNote");} catch (Exception e) {}
			try {presenzaRifiutiDescrizione = context.getRequest().getParameter("presenzaRifiutiDescrizione");} catch (Exception e) {}
			
			try {irrigazioneInLoco = Boolean.parseBoolean(context.getRequest().getParameter("irrigazioneInLoco"));} catch (Exception e) {}
			try {irrigazioneInformazioni = context.getRequest().getParameter("irrigazioneInformazioni");} catch (Exception e) {}
			try {irrigazioneDerivazione = context.getRequest().getParameter("irrigazioneDerivazione");} catch (Exception e) {}
			try {pozzoCampionamento = Boolean.parseBoolean(context.getRequest().getParameter("pozzoCampionamento"));} catch (Exception e) {}
			try {pozzoCampionamentoVerbaleNumero = context.getRequest().getParameter("pozzoCampionamentoVerbaleNumero");} catch (Exception e) {}
			try {pozzoCampionamentoVerbaleData = context.getRequest().getParameter("pozzoCampionamentoVerbaleData");} catch (Exception e) {}
			try {dichiarazioni = context.getRequest().getParameter("dichiarazioni");} catch (Exception e) {}
			try {strumentazione = context.getRequest().getParameter("strumentazione");} catch (Exception e) {}
			try {noteAggiuntive = context.getRequest().getParameter("noteAggiuntive");} catch (Exception e) {}

			jsonDatiVerbaleCampione.put("numCampioniElementari", numCampioniElementari);
			jsonDatiVerbaleCampione.put("tipoColturaCodice", tipoColturaCodice);
			jsonDatiVerbaleCampione.put("tipoColturaDescrizione", tipoColturaDescrizione);
			jsonDatiVerbaleCampione.put("tipoColturaNote", tipoColturaNote);
			jsonDatiVerbaleCampione.put("tipoColturaMotivazione", tipoColturaMotivazione);
			jsonDatiVerbaleCampione.put("presenzaRifiuti", presenzaRifiuti);
			jsonDatiVerbaleCampione.put("presenzaRifiutiNote", presenzaRifiutiNote);
			jsonDatiVerbaleCampione.put("presenzaRifiutiDescrizione", presenzaRifiutiDescrizione); 
			
			jsonDatiVerbaleCampione.put("irrigazioneInLoco", irrigazioneInLoco); 
			jsonDatiVerbaleCampione.put("irrigazioneInformazioni", irrigazioneInformazioni); 
			jsonDatiVerbaleCampione.put("irrigazioneDerivazione", irrigazioneDerivazione); 
			jsonDatiVerbaleCampione.put("pozzoCampionamento", pozzoCampionamento); 
			jsonDatiVerbaleCampione.put("pozzoCampionamentoVerbaleNumero", pozzoCampionamentoVerbaleNumero); 
			jsonDatiVerbaleCampione.put("pozzoCampionamentoVerbaleData", pozzoCampionamentoVerbaleData); 
			jsonDatiVerbaleCampione.put("dichiarazioni", dichiarazioni); 
			jsonDatiVerbaleCampione.put("strumentazione", strumentazione); 
			jsonDatiVerbaleCampione.put("noteAggiuntive", noteAggiuntive); 


			boolean aliquotaA = false;
			boolean aliquotaBG = false;
			boolean aliquotaC = false;
			boolean aliquotaD = false;
			boolean aliquotaE = false;
			boolean aliquotaF = false;
			boolean aliquotaH = false;
			boolean aliquotaI = false;
			boolean aliquotaLM = false;
			boolean aliquotaN = false;
			boolean aliquotaCD_fitofarmaci = false;
			
			String aliquotaA_data = null;
			String aliquotaBG_data = null;
			String aliquotaC_data = null;
			String aliquotaD_data = null;
			String aliquotaE_data = null;
			String aliquotaF_data = null;
			String aliquotaH_data = null;
			String aliquotaI_data = null;
			String aliquotaLM_data = null;
			String aliquotaN_data = null;
			
			String aliquotaA_ora = null;
			String aliquotaBG_ora = null;
			String aliquotaC_ora = null;
			String aliquotaD_ora = null;
			String aliquotaE_ora = null;
			String aliquotaF_ora = null;
			String aliquotaH_ora = null;
			String aliquotaI_ora = null;
			String aliquotaLM_ora = null;
			String aliquotaN_ora = null;
			
			try {aliquotaA = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaA"));} catch (Exception e) {} 
			try {aliquotaBG = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaBG"));} catch (Exception e) {}
			try {aliquotaC = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaC"));} catch (Exception e) {}
			try {aliquotaD = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaD"));} catch (Exception e) {}
			try {aliquotaE = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaE"));} catch (Exception e) {}
			try {aliquotaF = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaF"));} catch (Exception e) {}
			try {aliquotaH = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaH"));} catch (Exception e) {}
			try {aliquotaI = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaI"));} catch (Exception e) {}
			try {aliquotaLM = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaLM"));} catch (Exception e) {}
			try {aliquotaN = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaN"));} catch (Exception e) {}			
			try {aliquotaCD_fitofarmaci = Boolean.parseBoolean(context.getRequest().getParameter("aliquotaCD_fitofarmaci"));} catch (Exception e) {}
			
			try {aliquotaA_data = context.getRequest().getParameter("aliquotaA_data");} catch (Exception e) {} 
			try {aliquotaBG_data = context.getRequest().getParameter("aliquotaBG_data");} catch (Exception e) {}
			try {aliquotaC_data = context.getRequest().getParameter("aliquotaC_data");} catch (Exception e) {}
			try {aliquotaD_data = context.getRequest().getParameter("aliquotaD_data");} catch (Exception e) {}
			try {aliquotaE_data = context.getRequest().getParameter("aliquotaE_data");} catch (Exception e) {}
			try {aliquotaF_data = context.getRequest().getParameter("aliquotaF_data");} catch (Exception e) {}
			try {aliquotaH_data = context.getRequest().getParameter("aliquotaH_data");} catch (Exception e) {}
			try {aliquotaI_data = context.getRequest().getParameter("aliquotaI_data");} catch (Exception e) {}
			try {aliquotaLM_data = context.getRequest().getParameter("aliquotaLM_data");} catch (Exception e) {}
			try {aliquotaN_data = context.getRequest().getParameter("aliquotaN_data");} catch (Exception e) {}	
			
			try {aliquotaA_ora = context.getRequest().getParameter("aliquotaA_ora");} catch (Exception e) {} 
			try {aliquotaBG_ora = context.getRequest().getParameter("aliquotaBG_ora");} catch (Exception e) {}
			try {aliquotaC_ora = context.getRequest().getParameter("aliquotaC_ora");} catch (Exception e) {}
			try {aliquotaD_ora = context.getRequest().getParameter("aliquotaD_ora");} catch (Exception e) {}
			try {aliquotaE_ora = context.getRequest().getParameter("aliquotaE_ora");} catch (Exception e) {}
			try {aliquotaF_ora = context.getRequest().getParameter("aliquotaF_ora");} catch (Exception e) {}
			try {aliquotaH_ora = context.getRequest().getParameter("aliquotaH_ora");} catch (Exception e) {}
			try {aliquotaI_ora = context.getRequest().getParameter("aliquotaI_ora");} catch (Exception e) {}
			try {aliquotaLM_ora = context.getRequest().getParameter("aliquotaLM_ora");} catch (Exception e) {}
			try {aliquotaN_ora = context.getRequest().getParameter("aliquotaN_ora");} catch (Exception e) {}	
			
			jsonDatiVerbaleCampione.put("aliquotaA", aliquotaA); 
			jsonDatiVerbaleCampione.put("aliquotaBG", aliquotaBG);
			jsonDatiVerbaleCampione.put("aliquotaC", aliquotaC);
			jsonDatiVerbaleCampione.put("aliquotaD", aliquotaD);
			jsonDatiVerbaleCampione.put("aliquotaE", aliquotaE);
			jsonDatiVerbaleCampione.put("aliquotaF", aliquotaF);
			jsonDatiVerbaleCampione.put("aliquotaH", aliquotaH);
			jsonDatiVerbaleCampione.put("aliquotaI", aliquotaI);
			jsonDatiVerbaleCampione.put("aliquotaLM", aliquotaLM);
			jsonDatiVerbaleCampione.put("aliquotaN", aliquotaN);			
			jsonDatiVerbaleCampione.put("aliquotaCD_fitofarmaci", aliquotaCD_fitofarmaci);		
			
			jsonDatiVerbaleCampione.put("aliquotaA_data", aliquotaA_data);
			jsonDatiVerbaleCampione.put("aliquotaBG_data", aliquotaBG_data);
			jsonDatiVerbaleCampione.put("aliquotaC_data", aliquotaC_data);
			jsonDatiVerbaleCampione.put("aliquotaD_data", aliquotaD_data);
			jsonDatiVerbaleCampione.put("aliquotaE_data", aliquotaE_data);
			jsonDatiVerbaleCampione.put("aliquotaF_data", aliquotaF_data);
			jsonDatiVerbaleCampione.put("aliquotaH_data", aliquotaH_data);
			jsonDatiVerbaleCampione.put("aliquotaI_data", aliquotaI_data);
			jsonDatiVerbaleCampione.put("aliquotaLM_data", aliquotaLM_data);
			jsonDatiVerbaleCampione.put("aliquotaN_data", aliquotaN_data);			
			
			jsonDatiVerbaleCampione.put("aliquotaA_ora", aliquotaA_ora);
			jsonDatiVerbaleCampione.put("aliquotaBG_ora", aliquotaBG_ora);
			jsonDatiVerbaleCampione.put("aliquotaC_ora", aliquotaC_ora);
			jsonDatiVerbaleCampione.put("aliquotaD_ora", aliquotaD_ora);
			jsonDatiVerbaleCampione.put("aliquotaE_ora", aliquotaE_ora);
			jsonDatiVerbaleCampione.put("aliquotaF_ora", aliquotaF_ora);
			jsonDatiVerbaleCampione.put("aliquotaH_ora", aliquotaH_ora);
			jsonDatiVerbaleCampione.put("aliquotaI_ora", aliquotaI_ora);
			jsonDatiVerbaleCampione.put("aliquotaLM_ora", aliquotaLM_ora);
			jsonDatiVerbaleCampione.put("aliquotaN_ora", aliquotaN_ora);			
			
			jsonCampione.put("DatiVerbaleCampione", jsonDatiVerbaleCampione);

			Campione ca = new Campione();
			ca.updateParticella(db, jsonCampione);
			context.getRequest().setAttribute("Campione",  ca);

		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonCampione", jsonCampione);

		return "UpdateParticellaOK";	
		}
	
}
