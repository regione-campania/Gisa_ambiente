package org.aspcfs.modules.aua.actions;






import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.accounts.base.Provincia;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.aia.base.ComuniAnagrafica;
import org.aspcfs.modules.aua.base.ImpresaAUA;
import org.aspcfs.modules.aua.base.RicercaAUA;
import org.aspcfs.modules.aua.base.RicercaList;
import org.aspcfs.modules.aua.base.StabilimentoAUA;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.web.LookupList;
import org.aspcfs.utils.web.PagedListInfo;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;


public class StabilimentoAUAAction extends CFSModule {
	
	
	
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
			searchListInfo.setLink("StabilimentoAUA.do?command=Search&tipoOperaione="+context.getParameter("tipoOperaione"));
		else
		{
			searchListInfo.setLink("StabilimentoAUA.do?command=Search");
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

						
						RicercaAUA anagraficaPartenza = new RicercaAUA(db, rifId, rifIdNome);
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



			StabilimentoAUA newStabilimento = new StabilimentoAUA();


			LookupList listaToponimi = new LookupList();
			listaToponimi.setTable("lookup_toponimi");

			listaToponimi.buildList(db);

			listaToponimi.setRequired(true);
			context.getRequest().setAttribute("ToponimiList", listaToponimi);


			if ((StabilimentoAUA) context.getRequest().getAttribute("newStabilimento") != null)
				newStabilimento = (StabilimentoAUA) context.getRequest().getAttribute("newStabilimento");
			else
				if ((StabilimentoAUA) context.getRequest().getAttribute("Stabilimento") != null)
					newStabilimento = (StabilimentoAUA) context.getRequest().getAttribute("Stabilimento");


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
			 jsonDati.put("codice_fiscale_impresa", context.getRequest().getParameter("codice_fiscale_impresa"));
			 jsonDati.put("ciureg", context.getRequest().getParameter("ciureg"));
			 jsonDati.put("ciuprov", context.getRequest().getParameter("ciuprov"));
			 jsonDati.put("anno", context.getRequest().getParameter("anno"));
			 jsonDati.put("mesi_attivita", context.getRequest().getParameter("mesi_attivita"));
			 jsonDati.put("schede_aut", context.getRequest().getParameter("schede_aut"));

			 
			 
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
			 jsonDati.put("numero_registrazione_stabilimento", context.getRequest().getParameter("numero_registrazione_stabilimento"));
			 jsonDati.put("asl_stabilimento", context.getRequest().getParameter("asl_stabilimento"));
			 
			 jsonDati.put("estremi", context.getRequest().getParameter("estremi"));
			 jsonDati.put("rilascio", context.getRequest().getParameter("rilascio"));
			 jsonDati.put("scadenza", context.getRequest().getParameter("scadenza"));
			 jsonDati.put("ente", context.getRequest().getParameter("ente"));
			 jsonDati.put("tipo_aut", context.getRequest().getParameter("tipo_aut"));
			 jsonDati.put("op_r_autorizzate", context.getRequest().getParameter("op_r_autorizzate"));
			 jsonDati.put("op_d_autorizzate", context.getRequest().getParameter("op_d_autorizzate"));
			 jsonDati.put("vfu", context.getRequest().getParameter("vfu"));
			 jsonDati.put("raee", context.getRequest().getParameter("raee"));
			 jsonDati.put("incenerimento", context.getRequest().getParameter("incenerimento"));
			 jsonDati.put("eow", context.getRequest().getParameter("eow"));
			 jsonDati.put("capacita", context.getRequest().getParameter("capacita"));
			 jsonDati.put("coincenerimento", context.getRequest().getParameter("coincenerimento"));
			 jsonDati.put("categoria_discarica", context.getRequest().getParameter("categoria_discarica"));
			 jsonDati.put("capacita_residua", context.getRequest().getParameter("capacita_residua"));
			 jsonDati.put("capacita_pericolosi", context.getRequest().getParameter("capacita_pericolosi"));
			 jsonDati.put("capacita_non_pericolosi", context.getRequest().getParameter("capacita_non_pericolosi"));

			
			 

			 
			String id_stabilimento = "";
			//inserisci stabilimento con linee fisse (se presenti)
			StabilimentoAUA s = new StabilimentoAUA();

	
	        
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
	StabilimentoAUA newStabilimento = null;
	ImpresaAUA newImpresa = null;

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
			newStabilimento = new StabilimentoAUA(db,  idStab);
			
		}
		
		

		//newStabilimento.getPrefissoAction(context.getAction().getActionName());
		context.getRequest().setAttribute("StabilimentoDettaglio",	newStabilimento);
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
	
	



	
}