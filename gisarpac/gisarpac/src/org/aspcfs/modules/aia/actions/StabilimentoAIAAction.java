package org.aspcfs.modules.aia.actions;




import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.Vector;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.RowSetDynaClass;
import org.apache.log4j.Logger;
import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.accounts.actions.Accounts;
import org.aspcfs.modules.accounts.base.Organization;
import org.aspcfs.modules.accounts.base.OrganizationAddress;
import org.aspcfs.modules.accounts.base.OrganizationAddressList;
import org.aspcfs.modules.accounts.base.OrganizationList;
import org.aspcfs.modules.accounts.base.Provincia;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.admin.base.Role;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.modules.gestioneanagrafica.base.Comune;

import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.modules.aia.base.ComuniAnagrafica;

import org.aspcfs.modules.aia.base.ImpresaAIA;
import org.aspcfs.modules.aia.base.StabilimentoAIA;
import org.aspcfs.modules.aia.base.RicercaList;
import org.aspcfs.modules.aia.base.RicercaAIA;

import org.aspcfs.modules.aia.base.StabilimentoAIAList;

import org.aspcfs.modules.util.imports.ApplicationProperties;
import org.aspcfs.utils.AjaxCalls;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.DateUtils;
import org.aspcfs.utils.DwrUtil;
import org.aspcfs.utils.GestoreConnessioni;
import org.aspcfs.utils.InvalidFileException;
import org.aspcfs.utils.Utility;
import org.aspcfs.utils.web.LookupList;
import org.aspcfs.utils.web.PagedListInfo;
import org.jmesa.facade.TableFacade;
import org.jmesa.facade.TableFacadeFactory;
import org.jmesa.limit.Limit;
import org.jmesa.view.editor.CellEditor;
import org.jmesa.view.html.component.HtmlColumn;
import org.jmesa.view.html.editor.DroplistFilterEditor;
import org.jmesa.view.html.editor.HtmlCellEditor;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONString;

import com.darkhorseventures.framework.actions.ActionContext;
import com.google.gson.Gson;
import com.oreilly.servlet.MultipartRequest;

public class StabilimentoAIAAction extends CFSModule {
	
	
	
	public String executeCommandSearchForm(ActionContext context) {
		if (!(hasPermission(context, "opu-view"))) {
			return ("PermissionError");
		}

		
		SystemStatus systemStatus = this.getSystemStatus(context);
		Connection db = null;
		try {
			db = getConnection(context);
			LookupList siteList = new LookupList(db, "lookup_site_id");
			siteList.addItem(-1, "--Tutti--");
			context.getRequest().setAttribute("SiteList", siteList);

			LookupList ListaStati = new LookupList(db,
					"lookup_stato_lab");
			ListaStati.addItem(-1, "Tutti");
			ListaStati.removeElementByLevel(1);
			ListaStati.removeElementByLevel(3);
			ListaStati.removeElementByLevel(5);
			ListaStati.removeElementByLevel(6);
			ListaStati.removeElementByLevel(7);
			
		
			UserBean user = (UserBean) context.getSession().getAttribute("User");

			LookupList tipoRicerca = new LookupList(db, "lookup_tipo_ricerca_anagrafica");
			tipoRicerca.addItem(-1, "--TUTTI I TIPI DI ANAGRAFICHE--");
			context.getRequest().setAttribute("tipoRicerca", tipoRicerca);
			ComuniAnagrafica c = new ComuniAnagrafica();

			ArrayList<ComuniAnagrafica> listaComuni = c.buildList(db,((UserBean) context.getSession().getAttribute("User")).getSiteId(),1);
			LookupList comuniList = new LookupList();
			comuniList.queryListComuni(listaComuni, -1);
			comuniList.addItem(-2, "-TUTTI I COMUNI");
			context.getRequest().setAttribute("ComuniList", comuniList);
			
			
			LookupList codiceIppc = new LookupList(db, "lookup_codici_ippc_ricerca");
			codiceIppc.addItem(-1, "--TUTTI I CODICI IPPC--");
			context.getRequest().setAttribute("CodiceIppc", codiceIppc);
			
			
			context.getRequest().setAttribute("ListaStati", ListaStati);

			this.deletePagedListInfo(context, "SearchOpuListInfo");
			//reset the offset and current letter of the paged list in order to make sure we search ALL accounts
			PagedListInfo orgListInfo = this.getPagedListInfo(context, "SearchOpuListInfo");
			orgListInfo.setCurrentLetter("");
			orgListInfo.setCurrentOffset(0);

			

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}
		addModuleBean(context, "Search Accounts", "Accounts Search");
		return ("SearchOK");
	}

	
	
	public String executeCommandSearch(ActionContext context) {
		//		if (!hasPermission(context, "ricercaunica-view")) {
		//			return ("PermissionError");
		//		}


		
		
		RicercaList organizationList = new RicercaList();
		//Prepare pagedListInfo
		PagedListInfo searchListInfo = this.getPagedListInfo(context, "SearchOpuListInfo");

		if (context.getParameter("tipoOperaione")!=null)
			searchListInfo.setLink("StabilimentoAIA.do?command=Search&tipoOperaione="+context.getParameter("tipoOperaione"));
		else
		{
			searchListInfo.setLink("StabilimentoAIA.do?command=Search");
		}
			

		
		Connection db = null;
		try {
			db = this.getConnection(context);	      
//			organizationList.cessazioneAutomaticaAttivitaTemporane(db);
			
			searchListInfo.setSearchCriteria(organizationList, context);     
			organizationList.setPagedListInfo(searchListInfo);
			//	organizationList.setEscludiInDomanda(true);
			//	organizationList.setEscludiRespinti(true);

			//			String idAsl = context.getRequest().getParameter("searchaslSedeProduttiva");
			//			organizationList.setIdAsl(idAsl);
			//			
			//			String tipoRicerca = context.getRequest().getParameter("tipoRicerca");
			//			organizationList.setTipoRicerca(tipoRicerca);
//			organizationList.setTarga(context.getRequest().getParameter("targa"));
			
			
			
			String tipoOp = context.getParameter("tipoOperazione");
			if(tipoOp!=null)
			{
				organizationList.setRicercaUnicaSpostamentoCu(true);
			}
			
			
			if(context.getParameter("searchcodeidComune")!=null && !context.getParameter("searchcodeidComune").equals("-2") && !context.getParameter("searchcodeidComune").equals("-1")){
				
				
				Integer comune= Integer.parseInt(context.getParameter("searchcodeidComune"));
				context.getRequest().setAttribute("ComuniList", comune);

				
				String select = "select nome from comuni1 where id = ?";
				PreparedStatement pst = db.prepareStatement(select);

				pst.setInt(1, comune);
				ResultSet rs = pst.executeQuery();
				if (rs.next()) {
					organizationList.setComuneSedeProduttiva(rs.getString("nome"));
				}
				
				}
					
			
			if(context.getParameter("searchcodecodiceIppc")!=null && !context.getParameter("searchcodecodiceIppc").equals("-1") ){
				Integer codiceIppc = Integer.parseInt(context.getParameter("searchcodecodiceIppc"));
				context.getRequest().setAttribute("CodiceIppc", codiceIppc);

				organizationList.setCodiceIppc(codiceIppc);

				
			}
				if(context.getParameter("searchcodecodiceIppc2")!=null && !context.getParameter("searchcodecodiceIppc2").equals("-1") ){
					Integer codiceIppc2= Integer.parseInt(context.getParameter("searchcodecodiceIppc2"));
					context.getRequest().setAttribute("CodiceIppc2", codiceIppc2);

					organizationList.setCodiceIppc2(codiceIppc2);

				}
				
				
				
			organizationList.buildList(db);
			



			//organizationList.setCodiceFiscale(context.getParameter("searchCodiceFiscale"));

			LookupList siteList = new LookupList(db, "lookup_site_id");
			siteList.addItem(-1,  "-- SELEZIONA VOCE --");
			siteList.addItem(Constants.INVALID_SITE,  "-- TUTTI --");
			context.getRequest().setAttribute("SiteIdList", siteList);

			LookupList ListaStati = new LookupList(db,"lookup_stato_lab");
			ListaStati.addItem(-1, "Tutti");
			context.getRequest().setAttribute("ListaStati", ListaStati);



			LookupList tipoOperatore = new LookupList(db, "lookup_tipologia_operatore");
			context.getRequest().setAttribute("tipoOperatore", tipoOperatore);

			context.getRequest().setAttribute("tipoOperazione",  context.getParameter("tipoOperazione"));


			String pageOperazionePregfisso = "";
			if(tipoOp!=null)
			{
				switch (Integer.parseInt(tipoOp)) {
				case 1:
					/*Spostamento controlli*/

					if (context.getParameter("rifId")!=null)
					{
						int rifId = Integer.parseInt(context.getParameter("rifId"));
						String rifIdNome = context.getParameter("rifIdNome");

						
						RicercaAIA anagraficaPartenza = new RicercaAIA(db, rifId, rifIdNome);
							context.getRequest().setAttribute("AnagraficaPartenza", anagraficaPartenza);
						
						
						
					}


					break;

				default:
					break;
				}

			}
			context.getRequest().setAttribute("StabilimentiList", organizationList);

			
			return ("ListOK");



		} catch (Exception e) {
			//Go through the SystemError process
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}



	}

	
	
	
	public String executeCommandAdd(ActionContext context) {
		if (!(hasPermission(context, "opu-view"))) {
			return ("PermissionError");
		}

		
		SystemStatus systemStatus = this.getSystemStatus(context);
		Connection db = null;
		try {
			
			

			db = this.getConnection(context);

			UserBean thisUser = (UserBean) context.getSession().getAttribute("User");

			ComuniAnagrafica c = new ComuniAnagrafica();

			String flagDia = context.getParameter("flagDia");
			if (flagDia==null)
				flagDia = "false" ;


			LookupList NazioniList = new LookupList(db,"lookup_nazioni");
			NazioniList.addItem(-1, "Seleziona Nazione");
			NazioniList.setRequired(true);
			context.getRequest().setAttribute("NazioniList", NazioniList);

			LookupList TipoImpresaList = new LookupList(db,"lookup_tipo_impresa_societa");
			TipoImpresaList.addItem(-1, "Seleziona Tipo Societa");
			TipoImpresaList.setRequired(true);
			context.getRequest().setAttribute("TipoImpresaList", TipoImpresaList);


			ArrayList<ComuniAnagrafica> listaComuni = c.buildList_all(db,((UserBean) context.getSession().getAttribute("User")).getSiteId());
			LookupList comuniList = new LookupList();
			comuniList.queryListComuni(listaComuni, -1);
			comuniList.addItem(0, "SELEZIONA COMUNE");
			context.getRequest().setAttribute("ComuniList", comuniList);



			StabilimentoAIA newStabilimento = new StabilimentoAIA();


			LookupList listaToponimi = new LookupList();
			listaToponimi.setTable("lookup_toponimi");

			listaToponimi.buildList(db);

			listaToponimi.setRequired(true);
			context.getRequest().setAttribute("ToponimiList", listaToponimi);


			if ((StabilimentoAIA) context.getRequest().getAttribute("newStabilimento") != null)
				newStabilimento = (StabilimentoAIA) context.getRequest().getAttribute("newStabilimento");
			else
				if ((StabilimentoAIA) context.getRequest().getAttribute("Stabilimento") != null)
					newStabilimento = (StabilimentoAIA) context.getRequest().getAttribute("Stabilimento");


			newStabilimento.setIdStabilimento(DatabaseUtils.getNextSeq(db, "aia_stabilimento_id_seq"));

			



			


			context.getRequest().setAttribute("newStabilimento",newStabilimento);

			LookupList aslList = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("AslList", aslList);
			

		
			context.getRequest().setAttribute("tipologiaSoggetto",(String) context.getRequest().getParameter("tipologiaSoggetto"));





			Provincia provinciaAsl = new Provincia();
			provinciaAsl.getProvinciaAsl(db, thisUser.getSiteId());
			//			else
			//			{
			//				provinciaAsl.getProvincia(db, thisUser.getUserRecord().getSuap().getComune());
			//			}
			context.getRequest().setAttribute("provinciaAsl", provinciaAsl);

			if (context.getRequest().getAttribute("newStabilimento")!=null)
				context.getRequest().setAttribute("newStabilimento",context.getRequest().getAttribute("newStabilimento"));
		
			
			
			
			
			
			
			
			

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}
		return ("AddOK");
	}
	
	
	
	
public String executeCommandInsert(ActionContext context){
		
	    Connection db = null;
	 
		try
		{
		    JSONObject jsonDati = new JSONObject();

			
			db = this.getConnection(context);
			
			
			int userId =  getUserId(context);
			System.out.println("userid: " + userId);
		
			
			 jsonDati.put("ragione_sociale", context.getRequest().getParameter("ragione_sociale"));
			 jsonDati.put("partita_iva", context.getRequest().getParameter("partita_iva"));
			 jsonDati.put("codice_fiscale_impresa", context.getRequest().getParameter("codice_fiscale_impresa"));
			 jsonDati.put("id_impresa_recuperata", context.getRequest().getParameter("id_impresa_recuperata"));

			 jsonDati.put("tipo_impresa", context.getRequest().getParameter("tipo_impresa"));
			 jsonDati.put("email_impresa", context.getRequest().getParameter("email_impresa"));
			 
			 jsonDati.put("nome_rapp_leg", context.getRequest().getParameter("nome_rapp_leg"));
			 jsonDati.put("cognome_rapp_leg", context.getRequest().getParameter("cognome_rapp_leg"));
			 jsonDati.put("sesso_rapp_leg", context.getRequest().getParameter("sesso_rapp_leg"));
			 jsonDati.put("nazione_nascita_rapp_legale", context.getRequest().getParameter("nazione_nascita_rapp_legale"));
			 jsonDati.put("comune_nascita_rapp_legale", context.getRequest().getParameter("comune_nascita_rapp_legale"));
			 jsonDati.put("comune_nascita_rapp_leg", context.getRequest().getParameter("comune_nascita_rapp_leg"));
			 jsonDati.put("data_nascita_rapp_leg", context.getRequest().getParameter("data_nascita_rapp_legale"));
			 jsonDati.put("codice_fiscale_rappresentante", context.getRequest().getParameter("codice_fiscale_rappresentante"));
			 jsonDati.put("nazione_residenza_rapp_legale", context.getRequest().getParameter("nazione_residenza_rapp_legale"));
			 jsonDati.put("provincia_residenza_estero_rapp_legale", context.getRequest().getParameter("provincia_residenza_estero_rapp_legale"));
			 jsonDati.put("comune_residenza_estero_soggfis", context.getRequest().getParameter("comune_residenza_estero_soggfis"));
			 jsonDati.put("toponimo_residenza_rapp_legale", context.getRequest().getParameter("toponimo_residenza_rapp_legale"));
			
			 jsonDati.put("via_soggfis", context.getRequest().getParameter("via_soggfis"));
			 jsonDati.put("civico_soggfis", context.getRequest().getParameter("civico_soggfis"));
			 jsonDati.put("cap_soggfis", context.getRequest().getParameter("cap_soggfis"));
			 jsonDati.put("comune_residenza_rapp_legale", context.getRequest().getParameter("comune_residenza_rapp_legale"));
			 jsonDati.put("provincia_residenza_rapp_legale", context.getRequest().getParameter("provincia_residenza_rapp_legale"));
			 jsonDati.put("toponimo_soggfis", context.getRequest().getParameter("toponimo_soggfis"));
			 jsonDati.put("cod_comune_soggfis", context.getRequest().getParameter("cod_comune_soggfis"));
			 jsonDati.put("cod_provincia_soggfis", context.getRequest().getParameter("cod_provincia_soggfis"));
			 jsonDati.put("email_rapp_leg", context.getRequest().getParameter("email_rapp_leg"));
			 jsonDati.put("telefono_rapp_leg", context.getRequest().getParameter("telefono_rapp_leg"));
			 
			 
			 jsonDati.put("nome_resp_stab", context.getRequest().getParameter("nome_resp_stab"));
			 jsonDati.put("cognome_resp_stab", context.getRequest().getParameter("cognome_resp_stab"));
			 jsonDati.put("cf_resp_stab", context.getRequest().getParameter("cf_resp_stab"));
			 
			 
			 jsonDati.put("toponimo_sede_leg", context.getRequest().getParameter("toponimo_sede_leg"));
			 jsonDati.put("via_sede_legale", context.getRequest().getParameter("via_sede_legale"));
			 jsonDati.put("civico_sede_legale", context.getRequest().getParameter("civico_sede_legale"));
			 jsonDati.put("cap_leg", context.getRequest().getParameter("cap_leg"));
			 jsonDati.put("comune_sede_legale", context.getRequest().getParameter("comune_sede_legale"));
			 jsonDati.put("provincia_sede_legale", context.getRequest().getParameter("provincia_sede_legale"));
			 jsonDati.put("nazione_sede_legale", context.getRequest().getParameter("nazione_sede_legale"));

			 
			 jsonDati.put("comune_estero_sede_legale", context.getRequest().getParameter("comune_estero_sede_legale"));
			 jsonDati.put("cod_provincia_sede_legale", context.getRequest().getParameter("cod_provincia_sede_legale"));
			 jsonDati.put("cod_comune_sede_legale", context.getRequest().getParameter("cod_comune_sede_legale"));
			 jsonDati.put("toponimo_sede_legale", context.getRequest().getParameter("toponimo_sede_legale"));
			 jsonDati.put("latitudine_leg", context.getRequest().getParameter("latitudine_leg"));
			 jsonDati.put("longitudine_leg", context.getRequest().getParameter("longitudine_leg"));
			 
			 
			 
			 jsonDati.put("toponimo_stabilimento", context.getRequest().getParameter("toponimo_stabilimento"));
			 jsonDati.put("via_stab", context.getRequest().getParameter("via_stab"));
			 jsonDati.put("civico_stab", context.getRequest().getParameter("civico_stab"));
			 jsonDati.put("cap_stab", context.getRequest().getParameter("cap_stab"));
			 jsonDati.put("comune_stabilimento", context.getRequest().getParameter("comune_stabilimento"));
			 jsonDati.put("provincia_stabilimento", context.getRequest().getParameter("provincia_stabilimento"));
			 jsonDati.put("cod_provincia_stab", context.getRequest().getParameter("cod_provincia_stab"));
			 jsonDati.put("cod_comune_stab", context.getRequest().getParameter("cod_comune_stab"));
			 jsonDati.put("toponimo_stab", context.getRequest().getParameter("toponimo_stab"));
			 jsonDati.put("latitudine_stab", context.getRequest().getParameter("latitudine_stab"));
			 jsonDati.put("longitudine_stab", context.getRequest().getParameter("longitudine_stab"));
			 jsonDati.put("denominazione_stab", context.getRequest().getParameter("denominazione_stab"));
			 jsonDati.put("numero_registrazione_stabilimento", context.getRequest().getParameter("numero_registrazione_stabilimento"));
			 jsonDati.put("asl_stabilimento", context.getRequest().getParameter("asl_stabilimento"));
			 
			 
			 jsonDati.put("quantitativi_autorizzati", context.getRequest().getParameter("quantitativi_autorizzati"));
			 jsonDati.put("principale", context.getRequest().getParameter("principale"));
			 jsonDati.put("descrizione", context.getRequest().getParameter("descrizione"));
			 
			 jsonDati.put("numero_ippc", context.getRequest().getParameter("numero_ippc"));
			 jsonDati.put("numero_ippc_effettivo", context.getRequest().getParameter("numero_ippc_effettivo"));
			 
			 
			 for (int i = 0; i < Integer.parseInt((String) jsonDati.get("numero_ippc")); i++) {
					if (context.getRequest().getParameter("descrizione_"+(i+1) + "_codice_univoco")!= null ) {
						String codice = "descrizione_"+(i+1) + "_codice_univoco";
						
						System.out.println(context.getRequest().getParameter("descrizione_"+(i+1) + "_codice_univoco"));

						jsonDati.put(("id_ippc_"+(i+1)),context.getRequest().getParameter("descrizione_"+(i+1) + "_codice_univoco"));
						jsonDati.put(("principale_ippc_"+(i+1)),context.getRequest().getParameter("descrizione_"+(i+1) + "_principale"));
						jsonDati.put(("quantitativi_ippc_"+(i+1)),context.getRequest().getParameter("descrizione_"+(i+1) + "_quantitativi"));
						jsonDati.put(("data_inizio_attivita_"+(i+1)),context.getRequest().getParameter("descrizione_"+(i+1) + "_data_inizio_attivita"));

					}
				}
			 
			 

			 
			String id_stabilimento = "";
			//inserisci stabilimento con linee fisse (se presenti)
			StabilimentoAIA s = new StabilimentoAIA();

	
	        
			id_stabilimento = s.inserisci_stabilimento(db, jsonDati, userId);
			context.getRequest().setAttribute("idStab",id_stabilimento);

	        
	       
	        
			return getReturn(context, "Insert");
		    
	    
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("erroreInsert", 
					"Errore inserimento stabilimento: contattare hd I livello!!!<br>" + e.toString());
			return "ErrorPageInsert";
        } finally {
            this.freeConnection(context, db);
        }  
	
    }
	
	

public String executeCommandDetails(ActionContext context) {

	Connection db = null;
	SystemStatus systemStatus = this.getSystemStatus(context);
	StabilimentoAIA newStabilimento = null;
	ImpresaAIA newImpresa = null;

	try {
		db = this.getConnection(context);	
		
		Integer idStab = null;
		UserBean thisUser = (UserBean) context.getSession().getAttribute("User");

		
		 if(context.getRequest().getAttribute("idStab")!=null)
		 idStab = Integer.parseInt((String) context.getRequest().getAttribute("idStab"));
		
		if(context.getRequest().getParameter("stabId")!=null)
		 idStab = Integer.parseInt(context.getRequest().getParameter("stabId"));

		System.out.println("STABILIMENTO ID DETAILS: "+idStab);
		
		
		

		if (idStab>0) 
		{
			newStabilimento = new StabilimentoAIA(db,  idStab);
			
		}
		
		

		//newStabilimento.getPrefissoAction(context.getAction().getActionName());
		context.getRequest().setAttribute("StabilimentoDettaglio",	newStabilimento);
		context.getRequest().setAttribute("JsonIPPC",newStabilimento.getDescrizioneIPPCJson());
		context.getRequest().setAttribute("JsonDecreti",newStabilimento.getDecretiJson());
		context.getRequest().setAttribute("StabilimentiList",context.getRequest().getAttribute("StabilimentiList"));
		
		
		//context.getRequest().setAttribute("Operatore", newStabilimento.getOperatore());
		 
		//RicercaOpu AnagraficaStabilimento = new RicercaOpu(db,newStabilimento.getIdStabilimento(),"id_stabilimento");
		
		//context.getRequest().setAttribute("AnagraficaStabilimento", AnagraficaStabilimento);
		
		
		
		
		
		
	
		return getReturn(context, "Details");

	} catch (Exception e) {
		e.printStackTrace();
		// Go through the SystemError process
		context.getRequest().setAttribute("Error", e);
		return ("SystemError");
	} finally {
		this.freeConnection(context, db);
	}

}
	
	




public String executeCommandPrepareUpdate(ActionContext context) {

	Connection db = null;
	SystemStatus systemStatus = this.getSystemStatus(context);
	StabilimentoAIA newStabilimento = null;
	ImpresaAIA newImpresa = null;

	try {
		db = this.getConnection(context);	
		
		Integer idStab = null;
		
		 if(context.getRequest().getAttribute("idStab")!=null)
		 idStab = Integer.parseInt((String) context.getRequest().getAttribute("idStab"));
		
		if(context.getRequest().getParameter("stabId")!=null)
		 idStab = Integer.parseInt(context.getRequest().getParameter("stabId"));

		
		LookupList NazioniList = new LookupList(db,"lookup_nazioni");
		NazioniList.addItem(-1, "Seleziona Nazione");
		NazioniList.setRequired(true);
		context.getRequest().setAttribute("NazioniList", NazioniList);

		LookupList TipoImpresaList = new LookupList(db,"lookup_tipo_impresa_societa");
		TipoImpresaList.setRequired(true);
		context.getRequest().setAttribute("TipoImpresaList", TipoImpresaList);


		LookupList TipoSocietaList = new LookupList(db,"lookup_tipo_impresa_societa");
		TipoSocietaList.addItem(-1, "Seleziona Tipo Societa");
		TipoSocietaList.setRequired(true);
		context.getRequest().setAttribute("TipoSocietaList", TipoSocietaList);
		ComuniAnagrafica c = new ComuniAnagrafica();
		ArrayList<ComuniAnagrafica> listaComuni = c.buildList_all(db,((UserBean) context.getSession().getAttribute("User")).getSiteId());
		LookupList comuniList = new LookupList();
		comuniList.queryListComuni(listaComuni, -1);
		comuniList.addItem(0, "SELEZIONA COMUNE");
		context.getRequest().setAttribute("ComuniList", comuniList);

		




		LookupList listaToponimi = new LookupList();
		listaToponimi.setTable("lookup_toponimi");

		listaToponimi.buildList(db);

		listaToponimi.setRequired(true);
		context.getRequest().setAttribute("ToponimiList", listaToponimi);



		LookupList aslList = new LookupList(db, "lookup_site_id");
		context.getRequest().setAttribute("AslList", aslList);
		

	
		context.getRequest().setAttribute("tipologiaSoggetto",(String) context.getRequest().getParameter("tipologiaSoggetto"));





	
		
		

		if (idStab>0) 
		{
			newStabilimento = new StabilimentoAIA(db,  idStab);
			
		}
		
		

		//newStabilimento.getPrefissoAction(context.getAction().getActionName());
		context.getRequest().setAttribute("StabilimentoDettaglio",	newStabilimento);
		context.getRequest().setAttribute("JsonIPPC",newStabilimento.getDescrizioneIPPCJson());
		context.getRequest().setAttribute("JsonDecreti",newStabilimento.getDecretiJson());

		
		//context.getRequest().setAttribute("Operatore", newStabilimento.getOperatore());
		 
		//RicercaOpu AnagraficaStabilimento = new RicercaOpu(db,newStabilimento.getIdStabilimento(),"id_stabilimento");
		
		//context.getRequest().setAttribute("AnagraficaStabilimento", AnagraficaStabilimento);
		
		
		
		
		
		
	
		return getReturn(context, "PrepareUpdate");

	} catch (Exception e) {
		e.printStackTrace();
		// Go through the SystemError process
		context.getRequest().setAttribute("Error", e);
		return ("SystemError");
	} finally {
		this.freeConnection(context, db);
	}
}


public String executeCommandPrepareCambio(ActionContext context) {

	Connection db = null;
	SystemStatus systemStatus = this.getSystemStatus(context);
	StabilimentoAIA newStabilimento = null;
	ImpresaAIA newImpresa = null;

	try {
		db = this.getConnection(context);	
		
		Integer idStab = null;
		
		 if(context.getRequest().getAttribute("idStab")!=null)
		 idStab = Integer.parseInt((String) context.getRequest().getAttribute("idStab"));
		
		if(context.getRequest().getParameter("stabId")!=null)
		 idStab = Integer.parseInt(context.getRequest().getParameter("stabId"));

		
		LookupList NazioniList = new LookupList(db,"lookup_nazioni");
		NazioniList.addItem(-1, "Seleziona Nazione");
		NazioniList.setRequired(true);
		context.getRequest().setAttribute("NazioniList", NazioniList);

		LookupList TipoImpresaList = new LookupList(db,"lookup_tipo_impresa_societa");
		TipoImpresaList.addItem(-1, "Seleziona Tipo Societa");
		TipoImpresaList.setRequired(true);
		context.getRequest().setAttribute("TipoImpresaList", TipoImpresaList);


		
		ComuniAnagrafica c = new ComuniAnagrafica();
		ArrayList<ComuniAnagrafica> listaComuni = c.buildList_all(db,((UserBean) context.getSession().getAttribute("User")).getSiteId());
		LookupList comuniList = new LookupList();
		comuniList.queryListComuni(listaComuni, -1);
		comuniList.addItem(0, "SELEZIONA COMUNE");
		context.getRequest().setAttribute("ComuniList", comuniList);






		LookupList listaToponimi = new LookupList();
		listaToponimi.setTable("lookup_toponimi");

		listaToponimi.buildList(db);

		listaToponimi.setRequired(true);
		context.getRequest().setAttribute("ToponimiList", listaToponimi);



		LookupList aslList = new LookupList(db, "lookup_site_id");
		context.getRequest().setAttribute("AslList", aslList);
		

		
		context.getRequest().setAttribute("tipologiaSoggetto",(String) context.getRequest().getParameter("tipologiaSoggetto"));





	
		
		

		if (idStab>0) 
		{
			newStabilimento = new StabilimentoAIA(db,  idStab);
			
		}
		
		

		//newStabilimento.getPrefissoAction(context.getAction().getActionName());
		context.getRequest().setAttribute("StabilimentoDettaglio",	newStabilimento);
		context.getRequest().setAttribute("JsonIPPC",newStabilimento.getDescrizioneIPPCJson());
		context.getRequest().setAttribute("JsonDecreti",newStabilimento.getDecretiJson());

		
		//context.getRequest().setAttribute("Operatore", newStabilimento.getOperatore());
		 
		//RicercaOpu AnagraficaStabilimento = new RicercaOpu(db,newStabilimento.getIdStabilimento(),"id_stabilimento");
		
		//context.getRequest().setAttribute("AnagraficaStabilimento", AnagraficaStabilimento);
		
		
		
		
		
		
	
		return getReturn(context, "PrepareCambio");

	} catch (Exception e) {
		e.printStackTrace();
		// Go through the SystemError process
		context.getRequest().setAttribute("Error", e);
		return ("SystemError");
	} finally {
		this.freeConnection(context, db);
	}
}

public String executeCommandPrepareUpdateIppc(ActionContext context) {

	Connection db = null;
	SystemStatus systemStatus = this.getSystemStatus(context);
	StabilimentoAIA newStabilimento = null;
	ImpresaAIA newImpresa = null;

	try {
		db = this.getConnection(context);	
		
		Integer idStab = null;
		
		 if(context.getRequest().getAttribute("idStab")!=null)
		 idStab = Integer.parseInt((String) context.getRequest().getAttribute("idStab"));
		
		if(context.getRequest().getParameter("stabId")!=null)
		 idStab = Integer.parseInt(context.getRequest().getParameter("stabId"));

		
		
		

		if (idStab>0) 
		{
			newStabilimento = new StabilimentoAIA(db,  idStab);
			
		}
		
		

		//newStabilimento.getPrefissoAction(context.getAction().getActionName());
		context.getRequest().setAttribute("StabilimentoDettaglio",	newStabilimento);
		context.getRequest().setAttribute("JsonIPPC",newStabilimento.getDescrizioneIPPCJson());
		context.getRequest().setAttribute("JsonDecreti",newStabilimento.getDecretiJson());

		
	
		
		
		
		
		
	
		return getReturn(context, "PrepareUpdateIppc");

	} catch (Exception e) {
		e.printStackTrace();
		// Go through the SystemError process
		context.getRequest().setAttribute("Error", e);
		return ("SystemError");
	} finally {
		this.freeConnection(context, db);
	}
}






public String executeCommandUpdate(ActionContext context){
	
    Connection db = null;
 
	try
	{
	    JSONObject jsonDati = new JSONObject();

		
		db = this.getConnection(context);
		
		
		int userId =  getUserId(context);
		System.out.println("userid: " + userId);
	
		 jsonDati.put("id_stabilimento", context.getRequest().getParameter("id_stabilimento"));
		 jsonDati.put("id_impresa", context.getRequest().getParameter("id_impresa"));

		 jsonDati.put("ragione_sociale", context.getRequest().getParameter("ragione_sociale"));

		 jsonDati.put("email_impresa", context.getRequest().getParameter("email_impresa"));
		 
		 jsonDati.put("nazione_residenza_rapp_legale", context.getRequest().getParameter("nazione_residenza_rapp_legale"));
		 jsonDati.put("provincia_residenza_estero_rapp_legale", context.getRequest().getParameter("provincia_residenza_estero_rapp_legale"));
		 jsonDati.put("comune_residenza_estero_soggfis", context.getRequest().getParameter("comune_residenza_estero_soggfis"));
		 jsonDati.put("toponimo_residenza_rapp_legale", context.getRequest().getParameter("toponimo_residenza_rapp_legale"));
		 jsonDati.put("via_soggfis", context.getRequest().getParameter("via_soggfis"));
		 jsonDati.put("civico_soggfis", context.getRequest().getParameter("civico_soggfis"));
		 jsonDati.put("cap_soggfis", context.getRequest().getParameter("cap_soggfis"));
		 jsonDati.put("comune_residenza_rapp_legale", context.getRequest().getParameter("comune_residenza_rapp_legale"));
		 jsonDati.put("provincia_residenza_rapp_legale", context.getRequest().getParameter("provincia_residenza_rapp_legale"));
		 
		 jsonDati.put("toponimo_soggfis", context.getRequest().getParameter("toponimo_soggfis"));
		 jsonDati.put("cod_comune_soggfis", context.getRequest().getParameter("cod_comune_soggfis"));
		 jsonDati.put("cod_provincia_soggfis", context.getRequest().getParameter("cod_provincia_soggfis"));
		 jsonDati.put("email_rapp_leg", context.getRequest().getParameter("email_rapp_leg"));
		 jsonDati.put("telefono_rapp_leg", context.getRequest().getParameter("telefono_rapp_leg"));
		 
		 
		 jsonDati.put("nome_resp_stab", context.getRequest().getParameter("nome_resp_stab"));
		 jsonDati.put("cognome_resp_stab", context.getRequest().getParameter("cognome_resp_stab"));
		 jsonDati.put("cf_resp_stab", context.getRequest().getParameter("cf_resp_stab"));
		 
		 jsonDati.put("toponimo_sede_leg", context.getRequest().getParameter("toponimo_sede_leg"));
		 jsonDati.put("via_sede_legale", context.getRequest().getParameter("via_sede_legale"));
		 jsonDati.put("civico_sede_legale", context.getRequest().getParameter("civico_sede_legale"));
		 jsonDati.put("cap_leg", context.getRequest().getParameter("cap_leg"));
		 jsonDati.put("comune_sede_legale", context.getRequest().getParameter("comune_sede_legale"));
		 jsonDati.put("provincia_sede_legale", context.getRequest().getParameter("provincia_sede_legale"));
		 jsonDati.put("nazione_sede_legale", context.getRequest().getParameter("nazione_sede_legale"));

		 
		 jsonDati.put("comune_estero_sede_legale", context.getRequest().getParameter("comune_estero_sede_legale"));
		 jsonDati.put("cod_provincia_sede_legale", context.getRequest().getParameter("cod_provincia_sede_legale"));
		 jsonDati.put("cod_comune_sede_legale", context.getRequest().getParameter("cod_comune_sede_legale"));
		 jsonDati.put("toponimo_sede_legale", context.getRequest().getParameter("toponimo_sede_legale"));
		 jsonDati.put("latitudine_leg", context.getRequest().getParameter("latitudine_leg"));
		 jsonDati.put("longitudine_leg", context.getRequest().getParameter("longitudine_leg"));
		 

		 
		String id_stabilimento = "";
		//inserisci stabilimento con linee fisse (se presenti)
		StabilimentoAIA s = new StabilimentoAIA();


        
		id_stabilimento = s.update_stabilimento(db, jsonDati, userId);
		context.getRequest().setAttribute("idStab",id_stabilimento);

        
       
        
		return getReturn(context, "Update");
	    
    
	}catch (Exception e) {
		e.printStackTrace();
		context.getRequest().setAttribute("erroreInsert", 
				"Errore inserimento stabilimento: contattare hd I livello!!!<br>" + e.toString());
		return "ErrorPageInsert";
    } finally {
        this.freeConnection(context, db);
    }  

}


public String executeCommandCambio(ActionContext context){
	
    Connection db = null;
 
	try
	{
	    JSONObject jsonDati = new JSONObject();

		
		db = this.getConnection(context);
		
		
		int userId =  getUserId(context);
		System.out.println("userid: " + userId);
	
		 jsonDati.put("id_stabilimento", context.getRequest().getParameter("id_stabilimento"));
		 jsonDati.put("id_impresa", context.getRequest().getParameter("id_impresa"));

		 jsonDati.put("ragione_sociale", context.getRequest().getParameter("ragione_sociale"));
		 jsonDati.put("partita_iva", context.getRequest().getParameter("partita_iva"));
		 jsonDati.put("codice_fiscale_impresa", context.getRequest().getParameter("codice_fiscale_impresa"));
		 jsonDati.put("id_impresa_recuperata", context.getRequest().getParameter("id_impresa_recuperata"));

		 jsonDati.put("tipo_impresa", context.getRequest().getParameter("tipo_impresa"));
		 jsonDati.put("ragione_sociale", context.getRequest().getParameter("ragione_sociale"));
		 jsonDati.put("partita_iva", context.getRequest().getParameter("partita_iva"));
		 jsonDati.put("codice_fiscale_impresa", context.getRequest().getParameter("codice_fiscale_impresa"));
		 jsonDati.put("id_impresa_recuperata", context.getRequest().getParameter("id_impresa_recuperata"));

		 jsonDati.put("tipo_impresa", context.getRequest().getParameter("tipo_impresa"));
		 jsonDati.put("email_impresa", context.getRequest().getParameter("email_impresa"));
		 
		 jsonDati.put("nome_rapp_leg", context.getRequest().getParameter("nome_rapp_leg"));
		 jsonDati.put("cognome_rapp_leg", context.getRequest().getParameter("cognome_rapp_leg"));
		 jsonDati.put("sesso_rapp_leg", context.getRequest().getParameter("sesso_rapp_leg"));
		 jsonDati.put("nazione_nascita_rapp_legale", context.getRequest().getParameter("nazione_nascita_rapp_legale"));
		 jsonDati.put("comune_nascita_rapp_legale", context.getRequest().getParameter("comune_nascita_rapp_legale"));
		 jsonDati.put("comune_nascita_rapp_leg", context.getRequest().getParameter("comune_nascita_rapp_leg"));
		 jsonDati.put("data_nascita_rapp_leg", context.getRequest().getParameter("data_nascita_rapp_legale"));
		 jsonDati.put("codice_fiscale_rappresentante", context.getRequest().getParameter("codice_fiscale_rappresentante"));
		 jsonDati.put("nazione_residenza_rapp_legale", context.getRequest().getParameter("nazione_residenza_rapp_legale"));
		 jsonDati.put("provincia_residenza_estero_rapp_legale", context.getRequest().getParameter("provincia_residenza_estero_rapp_legale"));
		 jsonDati.put("comune_residenza_estero_soggfis", context.getRequest().getParameter("comune_residenza_estero_soggfis"));
		 jsonDati.put("toponimo_residenza_rapp_legale", context.getRequest().getParameter("toponimo_residenza_rapp_legale"));
		
		 jsonDati.put("via_soggfis", context.getRequest().getParameter("via_soggfis"));
		 jsonDati.put("civico_soggfis", context.getRequest().getParameter("civico_soggfis"));
		 jsonDati.put("cap_soggfis", context.getRequest().getParameter("cap_soggfis"));
		 jsonDati.put("comune_residenza_rapp_legale", context.getRequest().getParameter("comune_residenza_rapp_legale"));
		 jsonDati.put("provincia_residenza_rapp_legale", context.getRequest().getParameter("provincia_residenza_rapp_legale"));
		 jsonDati.put("toponimo_soggfis", context.getRequest().getParameter("toponimo_soggfis"));
		 jsonDati.put("cod_comune_soggfis", context.getRequest().getParameter("cod_comune_soggfis"));
		 jsonDati.put("cod_provincia_soggfis", context.getRequest().getParameter("cod_provincia_soggfis"));
		 jsonDati.put("email_rapp_leg", context.getRequest().getParameter("email_rapp_leg"));
		 jsonDati.put("telefono_rapp_leg", context.getRequest().getParameter("telefono_rapp_leg"));
		 
		 
		 jsonDati.put("nome_resp_stab", context.getRequest().getParameter("nome_resp_stab"));
		 jsonDati.put("cognome_resp_stab", context.getRequest().getParameter("cognome_resp_stab"));
		 jsonDati.put("cf_resp_stab", context.getRequest().getParameter("cf_resp_stab"));
		 
		 
		 jsonDati.put("toponimo_sede_leg", context.getRequest().getParameter("toponimo_sede_leg"));
		 jsonDati.put("via_sede_legale", context.getRequest().getParameter("via_sede_legale"));
		 jsonDati.put("civico_sede_legale", context.getRequest().getParameter("civico_sede_legale"));
		 jsonDati.put("cap_leg", context.getRequest().getParameter("cap_leg"));
		 jsonDati.put("comune_sede_legale", context.getRequest().getParameter("comune_sede_legale"));
		 jsonDati.put("provincia_sede_legale", context.getRequest().getParameter("provincia_sede_legale"));
		 jsonDati.put("nazione_sede_legale", context.getRequest().getParameter("nazione_sede_legale"));

		 
		 jsonDati.put("comune_estero_sede_legale", context.getRequest().getParameter("comune_estero_sede_legale"));
		 jsonDati.put("cod_provincia_sede_legale", context.getRequest().getParameter("cod_provincia_sede_legale"));
		 jsonDati.put("cod_comune_sede_legale", context.getRequest().getParameter("cod_comune_sede_legale"));
		 jsonDati.put("toponimo_sede_legale", context.getRequest().getParameter("toponimo_sede_legale"));
		 jsonDati.put("latitudine_leg", context.getRequest().getParameter("latitudine_leg"));
		 jsonDati.put("longitudine_leg", context.getRequest().getParameter("longitudine_leg"));
		 
		 
		 
		 jsonDati.put("toponimo_stabilimento", context.getRequest().getParameter("toponimo_stabilimento"));
		 jsonDati.put("via_stab", context.getRequest().getParameter("via_stab"));
		 jsonDati.put("civico_stab", context.getRequest().getParameter("civico_stab"));
		 jsonDati.put("cap_stab", context.getRequest().getParameter("cap_stab"));
		 jsonDati.put("comune_stabilimento", context.getRequest().getParameter("comune_stabilimento"));
		 jsonDati.put("provincia_stabilimento", context.getRequest().getParameter("provincia_stabilimento"));
		 jsonDati.put("cod_provincia_stab", context.getRequest().getParameter("cod_provincia_stab"));
		 jsonDati.put("cod_comune_stab", context.getRequest().getParameter("cod_comune_stab"));
		 jsonDati.put("toponimo_stab", context.getRequest().getParameter("toponimo_stab"));
		 jsonDati.put("latitudine_stab", context.getRequest().getParameter("latitudine_stab"));
		 jsonDati.put("longitudine_stab", context.getRequest().getParameter("longitudine_stab"));
		 jsonDati.put("denominazione_stab", context.getRequest().getParameter("denominazione_stab"));
		 jsonDati.put("numero_registrazione_stabilimento", context.getRequest().getParameter("numero_registrazione_stabilimento"));
		 jsonDati.put("asl_stabilimento", context.getRequest().getParameter("asl_stabilimento"));
		 
		 
		 
		 
		String id_stabilimento = "";
		//inserisci stabilimento con linee fisse (se presenti)
		StabilimentoAIA s = new StabilimentoAIA();


        
		id_stabilimento = s.cambio_titolarita(db, jsonDati, userId);
		context.getRequest().setAttribute("idStab",context.getRequest().getParameter("id_stabilimento"));

        
       
        
		return getReturn(context, "Cambio");
	    
    
	}catch (Exception e) {
		e.printStackTrace();
		context.getRequest().setAttribute("erroreInsert", 
				"Errore inserimento stabilimento: contattare hd I livello!!!<br>" + e.toString());
		return "ErrorPageInsert";
    } finally {
        this.freeConnection(context, db);
    }  

}
	
public String executeCommandUpdateIppc(ActionContext context){
	
    Connection db = null;
 
	try
	{
	    JSONObject jsonDati = new JSONObject();

		
		db = this.getConnection(context);
		
		
		int userId =  getUserId(context);
		System.out.println("userid: " + userId);
	
		 jsonDati.put("id_stabilimento", context.getRequest().getParameter("id_stabilimento"));
		 jsonDati.put("id_impresa", context.getRequest().getParameter("id_impresa"));
		 jsonDati.put("numero_ippc", context.getRequest().getParameter("numero_ippc"));
		 jsonDati.put("numero_ippc_effettivo", context.getRequest().getParameter("numero_ippc_effettivo"));
		 
		 for (int i = 0; i < Integer.parseInt((String) jsonDati.get("numero_ippc")); i++) {
				if (context.getRequest().getParameter("descrizione_"+(i+1) + "_codice_univoco")!= null ) {
					String codice = "descrizione_"+(i+1) + "_codice_univoco";
					
					System.out.println(context.getRequest().getParameter("descrizione_"+(i+1) + "_codice_univoco"));

					jsonDati.put(("id_ippc_"+(i+1)),context.getRequest().getParameter("descrizione_"+(i+1) + "_codice_univoco"));
					jsonDati.put(("principale_ippc_"+(i+1)),context.getRequest().getParameter("descrizione_"+(i+1) + "_principale"));
					jsonDati.put(("quantitativi_ippc_"+(i+1)),context.getRequest().getParameter("descrizione_"+(i+1) + "_quantitativi"));
					jsonDati.put(("data_inizio_attivita_"+(i+1)),context.getRequest().getParameter("descrizione_"+(i+1) + "_data_inizio_attivita"));
					
					if (context.getRequest().getParameter("check_id_"+(i+1) +"_codice_univoco")!= null ){
						jsonDati.put(("id_ippc_univoco"+(i+1)),context.getRequest().getParameter("check_id_"+(i+1) +"_codice_univoco"));

					}
					
				}
			}

		 
		String id_stabilimento = "";
		//inserisci stabilimento con linee fisse (se presenti)
		StabilimentoAIA s = new StabilimentoAIA();


        
		id_stabilimento = s.update_ippc(db, jsonDati, userId);
		context.getRequest().setAttribute("idStab",id_stabilimento);

        
       
        
		return getReturn(context, "UpdateIppc");
	    
    
	}catch (Exception e) {
		e.printStackTrace();
		context.getRequest().setAttribute("erroreInsert", 
				"Errore inserimento stabilimento: contattare hd I livello!!!<br>" + e.toString());
		return "ErrorPageInsert";
    } finally {
        this.freeConnection(context, db);
    }  

}



	
}