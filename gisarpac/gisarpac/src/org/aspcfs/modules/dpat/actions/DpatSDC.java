package org.aspcfs.modules.dpat.actions;

import java.io.ByteArrayOutputStream;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.dpat.base.DpatStrumentoCalcolo;
import org.aspcfs.modules.dpat.base.DpatStrumentoCalcoloNominativi;
import org.aspcfs.modules.dpat.base.DpatStrumentoCalcoloNominativiList;
import org.aspcfs.modules.gestioneDocumenti.actions.GestioneDocumentiDPAT;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.modules.oia.base.OiaNodo;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.UserUtils;
import org.aspcfs.utils.web.LookupList;

import com.darkhorseventures.framework.actions.ActionContext;

public class DpatSDC extends CFSModule {



	public String executeCommandAddModify(ActionContext context){
		Connection db = null;
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		int idAsl = -1;
		DpatStrumentoCalcolo dpatStrumentoCalcolo = null ;
		int annoCorrente =  -1 ;
		try {
			
			db = this.getConnection(context);
			idAsl = Integer.parseInt(context.getRequest().getParameter("idAsl"));
			String anno=  context.getRequest().getParameter("anno") ;
			if (anno == null)
				annoCorrente = GregorianCalendar.getInstance().get(Calendar.YEAR ) ; 
			else
				annoCorrente=Integer.parseInt(anno);
			
			String idArea = "" ;
			
			
			idArea = context.getRequest().getParameter("combo_area");
			int idStrutturaAreaSelezionata = -1 ;
			if (idArea!=null && !"".equals(idArea))
				idStrutturaAreaSelezionata = Integer.parseInt(idArea);
			else 
			{
				if (context.getRequest().getAttribute("idArea")!=null)
					idStrutturaAreaSelezionata = (Integer)context.getRequest().getAttribute("idArea");
			}
			
			context.getRequest().setAttribute("idStrutturaAreaSelezionata", idStrutturaAreaSelezionata);
			
			PreparedStatement pst = null ;
			ResultSet rs = null ;
			
			LookupList listaAsl = new LookupList(db,"lookup_site_id");
			context.getRequest().setAttribute("ListaAsl", listaAsl);
			
			
			ArrayList<User> utentiInDpatperIdAsl =  UserUtils.getUserFromDpat(context.getRequest(),idAsl);
			context.getRequest().setAttribute( "ListaUtenti", utentiInDpatperIdAsl );
			
			Timestamp current_date = new Timestamp(System.currentTimeMillis());
			dpatStrumentoCalcolo = new DpatStrumentoCalcolo(db,idAsl,annoCorrente,this.getSystemStatus(context),idStrutturaAreaSelezionata);
			dpatStrumentoCalcolo.setIdStrutturaAreaSelezionata(idStrutturaAreaSelezionata);
			if (dpatStrumentoCalcolo.getId()<=0 && getUserSiteId(context)>0 )
			{ 
				dpatStrumentoCalcolo.setIdAsl(idAsl);
				dpatStrumentoCalcolo.setAnno(annoCorrente);
				dpatStrumentoCalcolo.setEntered(current_date);
				dpatStrumentoCalcolo.setModified(current_date);
				dpatStrumentoCalcolo.setEnteredby(utente.getUserId());
				dpatStrumentoCalcolo.setModifiedby(utente.getUserId());
				//dpatStrumentoCalcolo.inserDpatStrumentoCalcolo(db,context); // la configurazione e' avvenuta manualmente a partire dalle strutture complesse dell'anno precedente
				dpatStrumentoCalcolo = new DpatStrumentoCalcolo(db,idAsl,annoCorrente,this.getSystemStatus(context),idStrutturaAreaSelezionata);

			}

			 pst = db.prepareStatement("select id from dpat_strutture_asl where n_livello=1 and id_asl="+idAsl);
			 rs = pst.executeQuery();
			int id_nonno = -1;
			while (rs.next()){
				id_nonno = rs.getInt("id");
			}
			context.getRequest().setAttribute("id_nonno", id_nonno);
			LookupList qualifiche = new LookupList(db,"lookup_qualifiche");
			qualifiche.addItem(-1, "Seleziona Qualifica") ;
			context.getRequest().setAttribute("Qualifica", qualifiche);


			LookupList lookupTipologia = new LookupList(db, "lookup_tipologia_nodo_oia");
			
			lookupTipologia.addItem(-1,  "-- SELEZIONA VOCE --");
			context.getRequest().setAttribute("lookupTipologia", lookupTipologia);
			
			LookupList lookupTipologia2 = new LookupList();
			lookupTipologia2.setShowDisabledFlag(false);
			lookupTipologia2.setTableName("lookup_tipologia_nodo_oia");
			lookupTipologia2.buildListWithEnabled(db);
			
			context.getRequest().setAttribute("lookupTipologia", lookupTipologia);
			context.getRequest().setAttribute("lookupTipologia2", lookupTipologia2);

			context.getRequest().setAttribute("DpatSDC", dpatStrumentoCalcolo);
			
			
	

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}	
		
		//&& dpatStrumentoCalcolo.getStrutturaAmbito().getIdUtenteEdit() == utente.getUserId()
		if (idAsl>0   && dpatStrumentoCalcolo.getAnno()==annoCorrente && hasPermission(context, "dpat-edit")  )
			return ("DpatSDCAddModifyOK"); /*VISUALIZZAZIONE UTENTE ASL*/
		
		context.getRequest().setAttribute("anno", annoCorrente+"");
		return executeCommandDetails(context); /*VISUALIZZAZIONE UTENTE SENZA ASL*/
	}
	
	
	
	

	


	public String executeCommandDetails(ActionContext context){
		Connection db = null;
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		int idAsl = -1;
		DpatStrumentoCalcolo dpatStrumentoCalcolo = null ;
		try {
			db = this.getConnection(context);
			idAsl = Integer.parseInt(context.getRequest().getParameter("idAsl"));
			Timestamp current_date = new Timestamp(System.currentTimeMillis());
			String anno=  context.getRequest().getParameter("anno") ;
			if (anno == null)
				anno= (String)context.getRequest().getAttribute("anno");

			
			String idArea = "" ;
			
			int idStrutturaAreaSelezionata = -1 ;

			if (context.getRequest().getAttribute("DpatSDC")!=null)
			{
				dpatStrumentoCalcolo = (DpatStrumentoCalcolo)context.getRequest().getAttribute("DpatSDC");
				idStrutturaAreaSelezionata=dpatStrumentoCalcolo.getIdStrutturaAreaSelezionata();
			}
			if (idStrutturaAreaSelezionata<=0 && context.getRequest().getParameter("combo_area")!=null)
			{
				idArea = context.getRequest().getParameter("combo_area");
				if (idArea!=null && !"".equals(idArea))
					idStrutturaAreaSelezionata = Integer.parseInt(idArea);
			}
			else
			{
				idStrutturaAreaSelezionata = (Integer)context.getRequest().getAttribute("idStrutturaAreaSelezionata");
			}
			
			
			dpatStrumentoCalcolo = new DpatStrumentoCalcolo(db,idAsl,Integer.parseInt(anno),this.getSystemStatus(context),idStrutturaAreaSelezionata);

			LookupList qualifiche = new LookupList(db,"lookup_qualifiche");
			qualifiche.addItem(-1, "Seleziona Qualifica") ;
			context.getRequest().setAttribute("Qualifica", qualifiche);


			LookupList listaAsl = new LookupList(db,"lookup_site_id");
			context.getRequest().setAttribute("ListaAsl", listaAsl);
			
			
			LookupList lookupTipologia = new LookupList(db, "lookup_tipologia_nodo_oia");
			lookupTipologia.addItem(-1,  "-- SELEZIONA VOCE --");
			context.getRequest().setAttribute("lookupTipologia", lookupTipologia);
			context.getRequest().setAttribute("DpatSDC", dpatStrumentoCalcolo);
			
			LookupList lookupTipologia2 = new LookupList();
			lookupTipologia2.setShowDisabledFlag(false);
			lookupTipologia2.setTableName("lookup_tipologia_nodo_oia");
			lookupTipologia2.buildListWithEnabled(db);
			
			context.getRequest().setAttribute("lookupTipologia2", lookupTipologia2);

			
			String sql = "select id from dpat where id_asl="+idAsl+" and anno="+anno;
			PreparedStatement pst = db.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			int idDpat = -1;
			while (rs.next()){
				idDpat = rs.getInt("id");  
			}
			org.aspcfs.modules.dpat.base.Dpat d = new org.aspcfs.modules.dpat.base.Dpat();
			d.builRecordSdc(idDpat, db,this.getSystemStatus(context));
			context.getRequest().setAttribute("dpat", d);
			pst.close();

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}	

		// SERVER DOCUMENTALE
		String layout = context.getRequest().getParameter("layout");
		if (layout!=null && layout.equals("style"))
			return ("DpatSDCDetailStyleOK");
//SERVER DOCUMENTALE

	return ("DpatSDCDetailOK");


	}


	public String executeCommandSaveOiaStruttura(ActionContext context){
		Connection db = null;
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		try {
			db = this.getConnection(context);
			int idAsl = Integer.parseInt(context.getRequest().getParameter("idAsl").trim());
			int nLivello = Integer.parseInt(context.getRequest().getParameter("n_livello").trim());
			int anno = Integer.parseInt(context.getRequest().getParameter("anno").trim());
			int idStrumentoCalcolo = Integer.parseInt(context.getRequest().getParameter("idStrumentoCalcolo").trim());
			int id_padre =-1;
			if (context.getRequest().getParameter("id_padre")!=null)
			id_padre=Integer.parseInt(context.getRequest().getParameter("id_padre").trim());
			int tipologia =-1 ;
			if (context.getRequest().getParameter("tipologia_struttura")!=null)
				tipologia = Integer.parseInt(context.getRequest().getParameter("tipologia_struttura").trim());
			String descrizioneLunga = context.getParameter("descrizione");

			context.getRequest().setAttribute("idAsl", idAsl);
			context.getRequest().setAttribute("anno", anno);
			int id= Integer.parseInt(context.getParameter("id"));
			OiaNodo nodoStruttura = new OiaNodo();

			int idArea=-1 ;
			String areaId = context.getRequest().getParameter("id_area_sel");
			if (areaId!=null)
				idArea = Integer.parseInt(areaId);
			
			
			DpatStrumentoCalcolo sdc = new DpatStrumentoCalcolo(db, idAsl, anno, this.getSystemStatus(context), idArea);
			context.getRequest().setAttribute("SDC", sdc);
			
			if(id<=0)
			{
				nodoStruttura = new OiaNodo();
				nodoStruttura.setId_padre(id_padre);
				nodoStruttura.setId_asl(idAsl);
				nodoStruttura.setIdAsl(idAsl);
				nodoStruttura.setN_livello(nLivello);
				nodoStruttura.setTipologia_struttura(tipologia);
				nodoStruttura.setDescrizione_lunga(descrizioneLunga);
				nodoStruttura.setEntered_by(getUserId(context));
				nodoStruttura.setModified_by(getUserId(context));
				nodoStruttura.setIdStrumentoCalcolo(idStrumentoCalcolo);
				nodoStruttura.setObsoleto(false);
				nodoStruttura.setConfermato(true);
				nodoStruttura.setAnno(anno);
				nodoStruttura.setStato(sdc.getStrutturaAmbito().getStato());
				nodoStruttura.setDescrizioneAreaStruttureComplesse(context.getParameter("descrizione_area_struttura_complessa"));
			nodoStruttura.insert(db);

			}
			else
			{
				 nodoStruttura = new OiaNodo(db,id,this.getSystemStatus(context));
				 if (nodoStruttura.getDataScadenza()!=null) /*E STATA ESEGUITA UNA MODIFICA SU UN RECORD CHE HA LA DATA SCADENZA FUTURA*/
				 {
					 String sql = "delete from strutture_asl where codice_interno_fk=? and data_scadenza is null";
					 PreparedStatement pst = db.prepareStatement(sql);
					 pst.setInt(1, nodoStruttura.getCodiceInternoFK());
					 pst.execute();
				 }
				 
				 
				 nodoStruttura.setDescrizioneAreaStruttureComplesse(context.getParameter("descrizione_area_struttura_complessa"));
				nodoStruttura.setId_padre(id_padre); 
				nodoStruttura.setId_asl(idAsl);
				nodoStruttura.setTipologia_struttura(tipologia); 
				nodoStruttura.setDescrizione_lunga(descrizioneLunga);
				nodoStruttura.setN_livello(nLivello);
				nodoStruttura.setModified_by(getUserId(context));
				nodoStruttura.setDataScadenza(context.getParameter("dataScadenza"));
				
				int tipoOperazione = Integer.parseInt(context.getParameter("tipoOperazione"));
				nodoStruttura.setModified_by(getUserId(context));
				nodoStruttura.setEntered_by(getUserId(context));
				nodoStruttura.update(db,tipoOperazione);
				
				
				if(tipoOperazione==1)
				{
					Timestamp data = null ;
					nodoStruttura.setDataScadenza(data);
					nodoStruttura.insert(db);
					
				}
				
				
				if (id_padre<=0)
				{
					OiaNodo nn = new OiaNodo(db, nodoStruttura.getId());
					nodoStruttura.setId_padre(nn.getId_padre());
				}
			}
			org.aspcfs.modules.dpat.base.Dpat d = new org.aspcfs.modules.dpat.base.Dpat();
			nodoStruttura.aggiornaDatiStruttura(db,d.isCongelato(db, idAsl, anno),sdc.getCoefficienteUba());
			
//			String update  = "select * from public_functions.dbi_dpat_aggiorna_carico_lavoro_su_area( ?)";
//			PreparedStatement pst1 = db.prepareStatement(update);
//			pst1.setInt(1, nodoStruttura.getId_padre());
//			pst1.execute();
			
			
			
			 HashMap<Integer,ArrayList<OiaNodo>> strutture_asl = (HashMap<Integer,ArrayList<OiaNodo>>)context.getServletContext().getAttribute("StruttureOIA");
				
			 OiaNodo nodo =new OiaNodo();
			strutture_asl.put(idAsl, nodo.loadbyidAsl(""+idAsl,anno, db));
			context.getServletContext().setAttribute("StruttureOIA",strutture_asl);
			
			


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}	
		return ("DpatSDCAddNominativoOK");
	}


	
	public String executeCommandSaveNominativo(ActionContext context){
		Connection db = null;
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		try {
			db = this.getConnection(context);
		
			int idStruttura = Integer.parseInt(context.getRequest().getParameter("struttura").trim());
			int idAsl = Integer.parseInt(context.getRequest().getParameter("idAsl").trim());
			int anno = Integer.parseInt(context.getRequest().getParameter("anno").trim());
			int caricoAnnuo =0;
			int percentuale = 0;
			int caricoEffettivo = 0;
			if (context.getRequest().getParameter("carico_annuo") !=null && !"".equals(context.getRequest().getParameter("carico_annuo")))
				caricoAnnuo = Integer.parseInt(context.getRequest().getParameter("carico_annuo").trim());
			
			String fattoriIncidenti = "" ;
			
			if(context.getRequest().getParameter("fattori_incidenti")!=null)
				fattoriIncidenti=context.getRequest().getParameter("fattori_incidenti").trim();
			
			if (context.getRequest().getParameter("percentuale") !=null && !"".equals(context.getRequest().getParameter("percentuale")))
				percentuale = Integer.parseInt(context.getRequest().getParameter("percentuale").trim());
			if (context.getRequest().getParameter("carico_effettivo") !=null && !"".equals(context.getRequest().getParameter("carico_effettivo")))
				caricoEffettivo = Integer.parseInt(context.getRequest().getParameter("carico_effettivo").trim());
			
			
			context.getRequest().setAttribute("idAsl", idAsl);
			context.getRequest().setAttribute("anno", anno);


			
			SystemStatus system =  this.getSystemStatus(context);
			
			
			int idArea=-1 ;
			String areaId = context.getRequest().getParameter("id_area_sel");
			if (areaId!=null)
				idArea = Integer.parseInt(areaId);
			DpatStrumentoCalcolo sdc = new DpatStrumentoCalcolo(db, idAsl, anno, this.getSystemStatus(context), idArea);
			context.getRequest().setAttribute("SDC", sdc);
			
			String[] utenti = context.getRequest().getParameterValues("utente");
			
			for(int i=0;i<utenti.length;i++)
			{
				User user  =system.getUser(Integer.parseInt(utenti[i]));
				
				DpatStrumentoCalcoloNominativi nominativoDpat = new DpatStrumentoCalcoloNominativi();
				int id= Integer.parseInt(context.getParameter("id"));
				
				/**
				 * FACCIO SCADERE IL RECORD ATTUALE
				 */
				Timestamp dataScadenza = new Timestamp(System.currentTimeMillis());
				nominativoDpat.queryRecord(db, id);
				nominativoDpat.setDataScadenza(dataScadenza);
				nominativoDpat.setModifiedBy(getUserId(context));
				nominativoDpat.update(db);
			
				/**
				 * CLONO IL RECORD CON I PARAMETRI NUOVI
				 */
				nominativoDpat.setEnteredBy(getUserId(context));
				
				if ( (context.getRequest().getParameter("carico_annuo_"+user.getId()))!=null 
						&& !"".equals(context.getRequest().getParameter("carico_annuo_"+user.getId()).trim())  ){ 
					caricoAnnuo=Integer.parseInt(context.getRequest().getParameter("carico_annuo_"+user.getId()).trim());
				}
				
				if (caricoEffettivo>0 || (caricoEffettivo==0 && percentuale>0))
					nominativoDpat.setCaricoEffettivoAnnuale(caricoEffettivo);
				else
					nominativoDpat.setCaricoEffettivoAnnuale(caricoAnnuo);
				
				nominativoDpat.setCaricoLavoroAnnuale(caricoAnnuo);
				
				nominativoDpat.setFattoriIncidentiSuCarico(fattoriIncidenti);
				nominativoDpat.setPercentualeDaSottrarre(percentuale);
				nominativoDpat.setIdLookupQualifica(user.getRoleId());
				nominativoDpat.setIdStrumentoCalcoloStruttura(idStruttura);
				nominativoDpat.setIdAnagraficaNominativo(Integer.parseInt(utenti[i]));
				nominativoDpat.setUba_ui((caricoEffettivo * (sdc.getCoefficienteUba())) );
				nominativoDpat.insert(db);
				
				
			}

				OiaNodo struttura = new OiaNodo(db,idStruttura,this.getSystemStatus(context));
				org.aspcfs.modules.dpat.base.Dpat d = new org.aspcfs.modules.dpat.base.Dpat();
				struttura.aggiornaDatiStruttura(db,d.isCongelato(db, idAsl, anno),sdc.getCoefficienteUba());
				/*RICOSRUISCO L'OGGETTO DOPO L'AGGIORNAMENTO SULLA STRUTTURA*/
				 sdc = new DpatStrumentoCalcolo(db, idAsl, anno, this.getSystemStatus(context), idArea);
				context.getRequest().setAttribute("SDC", sdc);
				
				

			} catch (Exception e) {
				context.getRequest().setAttribute("Error", e);
				e.printStackTrace();
				return ("SystemError");
			} finally {
				this.freeConnection(context, db);
			}	
			return ("DpatSDCAddNominativoOK");
		}
	 

	


	public String executeCommandDeleteStruttura(ActionContext context){
		Connection db = null;
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		try {
			db = this.getConnection(context);
			int idAsl = Integer.parseInt(context.getRequest().getParameter("idAsl"));
			int anno = Integer.parseInt(context.getRequest().getParameter("anno"));
			context.getRequest().setAttribute("idAsl", idAsl);
			context.getRequest().setAttribute("anno", anno);
			int id= Integer.parseInt(context.getParameter("id"));

			OiaNodo strutturaDpat = new OiaNodo(db,id,this.getSystemStatus(context));
//			strutturaDpat.delete(db);
//
//						DpatStrumentoCalcoloStruttura struttura = new DpatStrumentoCalcoloStruttura(db,strutturaDpat.getId());
//						struttura.aggiornaDatiStruttura(db);


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}	
		return ("DpatSDCAddNominativoOK");
	}


	public String executeCommandDeleteNominativo(ActionContext context){
		Connection db = null;
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		try {
			db = this.getConnection(context);
			int idAsl = Integer.parseInt(context.getRequest().getParameter("idAsl"));
			int anno = Integer.parseInt(context.getRequest().getParameter("anno"));
			context.getRequest().setAttribute("idAsl", idAsl);
			context.getRequest().setAttribute("anno", anno);
			int id= Integer.parseInt(context.getParameter("id"));

			DpatStrumentoCalcoloNominativi nominativoDpat = new DpatStrumentoCalcoloNominativi(db,id,this.getSystemStatus(context));
			nominativoDpat.delete(db);

			OiaNodo struttura = new OiaNodo(db,nominativoDpat.getIdStrumentoCalcoloStruttura(),this.getSystemStatus(context));
			
			org.aspcfs.modules.dpat.base.Dpat d = new org.aspcfs.modules.dpat.base.Dpat();

			
			int idArea=-1 ;
			String areaId = context.getRequest().getParameter("id_area_sel");
			if (areaId!=null)
				idArea = Integer.parseInt(areaId);
			DpatStrumentoCalcolo sdc = new DpatStrumentoCalcolo(db, idAsl, anno, this.getSystemStatus(context), idArea);
			context.getRequest().setAttribute("SDC", sdc);
			
			struttura.aggiornaDatiStruttura(db,d.isCongelato(db, idAsl, anno),sdc.getCoefficienteUba());


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}	
		return ("DpatSDCAddNominativoOK");
	}
  
	
	
	//RIAPERTURA DELLO SDC
	public String executeCommandReopenClosedSDC(ActionContext context){
		Connection db = null;
		String id = (String)context.getRequest().getParameter("id");
		String idAsl = (String)context.getRequest().getParameter("idAsl");
		String anno = (String)context.getRequest().getParameter("anno");
		String query = "update dpat_strumento_calcolo set completo=false where id=? and anno=? and id_asl=?";
		try { 
			db = this.getConnection(context);
			PreparedStatement pst = db.prepareStatement(query);
			pst.setInt(1, Integer.parseInt(id));
			pst.setInt(2, Integer.parseInt(anno));
			pst.setInt(3, Integer.parseInt(idAsl));
			pst.executeUpdate();
			pst.close();
			
			query =  "update dpat set strutture = null where id_asl=? and anno=?";
			PreparedStatement pst2 = db.prepareStatement(query);
			pst2.setInt(1, Integer.parseInt(idAsl));
			pst2.setInt(2, Integer.parseInt(anno));
			pst2.executeUpdate();

			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			this.freeConnection(context, db);
		}	
		return executeCommandAddModify(context);
	}
	
	
	
	public String executeCommandCongelaStruttureReportistica(ActionContext context) {
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		String idDpat = (String)context.getRequest().getParameter("id");
		String idAsl = (String)context.getRequest().getParameter("idAsl");
		Connection db = null;
		PreparedStatement pst = null;
		
		try {
			db = this.getConnection(context);
			
			int idStrutturaAreaSelezionata = -1 ;

			
			
		
			
			int annoCorrente = -1 ;
				String anno=  context.getRequest().getParameter("anno") ;
				if (anno == null)
					annoCorrente = GregorianCalendar.getInstance().get(Calendar.YEAR ) ; 
				else
					annoCorrente=Integer.parseInt(anno);
			
				
				pst=db.prepareStatement("select * from dbi_congela_strumento_di_calcolo_reportistica(?,?)");
				pst.setInt(1,annoCorrente);
				pst.setInt(2, utente.getUserId());
				pst.execute();
				
				Dpat dpat = new Dpat();
				return dpat.executeCommandDefault(context);
				
				
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally
		{
			this.freeConnection(context, db);
		}
		
		
		return executeCommandAddModify(context);
	}
	
	
	
	public String executeCommandSalvaDefinitivo(ActionContext context) {
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		String idDpat = (String)context.getRequest().getParameter("id");
		String idAsl = (String)context.getRequest().getParameter("idAsl");
		Connection db = null;
		PreparedStatement pst = null;
		
		try {
			db = this.getConnection(context);
			
			int idStrutturaAreaSelezionata = -1 ;

			
			
			int asl=Integer.parseInt(idAsl); 
				String idArea = context.getRequest().getParameter("combo_area");
				if (idArea!=null && !"".equals(idArea))
					idStrutturaAreaSelezionata = Integer.parseInt(idArea);
			
			int annoCorrente = -1 ;
				String anno=  context.getRequest().getParameter("anno") ;
				if (anno == null)
					annoCorrente = GregorianCalendar.getInstance().get(Calendar.YEAR ) ; 
				else
					annoCorrente=Integer.parseInt(anno);
			DpatStrumentoCalcolo sdc = new DpatStrumentoCalcolo(db,asl,annoCorrente,this.getSystemStatus(context),idStrutturaAreaSelezionata);
			sdc.setIdStrutturaAreaSelezionata(idStrutturaAreaSelezionata);
			sdc.congelaStrumentoCalcolo(db);
			
			
			
			/*ricarico le strutture in memoria per farle vedere nei cu recuperando quelle con stato = 2*/
			HashMap<Integer,ArrayList<OiaNodo>> strutture_asl =  (HashMap<Integer, ArrayList<OiaNodo>>) context.getServletContext().getAttribute("StruttureOIA");
			
			
			OiaNodo n = new OiaNodo();
			

			Calendar calCorrente = GregorianCalendar.getInstance();
			Date dataCorrente = new Date(System.currentTimeMillis());
			int tolleranzaGiorni = 0;
			dataCorrente.setDate(dataCorrente.getDate()- tolleranzaGiorni);
			calCorrente.setTime(new Timestamp(dataCorrente.getTime()));
			int anno_corrente = calCorrente.get(Calendar.YEAR);
			 System.out.println("Caricamento Strutture Per Conto Di In memoria Anno "+anno_corrente); 
			
			strutture_asl.put(asl, n.loadbyidAsl(idAsl,anno_corrente, db));
			context.getServletContext().setAttribute("StruttureOIA",strutture_asl);

			context.getRequest().setAttribute("idAsl", idAsl);
			context.getRequest().setAttribute("idArea", idStrutturaAreaSelezionata);
				
				
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally
		{
			this.freeConnection(context, db);
		}
		
		
		return executeCommandAddModify(context);
	}
	
	
	
	public String executeCommandGeneraXls(ActionContext context){
		Connection db = null;
		UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");
		int idAsl = -1;
		DpatStrumentoCalcolo dpatStrumentoCalcolo = null ;
		try {
			db = this.getConnection(context);
			idAsl = Integer.parseInt(context.getRequest().getParameter("idAsl"));
			Timestamp current_date = new Timestamp(System.currentTimeMillis());
			String anno=  context.getRequest().getParameter("anno") ;
			if (anno == null)
				anno= (String)context.getRequest().getAttribute("anno");

			
			String idArea = "" ;
			
			int idStrutturaAreaSelezionata = -1 ;
			
			String checkStrutture = context.getParameter("checkStrutture");
			if (context.getRequest().getAttribute("DpatSDC")!=null)
			{
				dpatStrumentoCalcolo = (DpatStrumentoCalcolo)context.getRequest().getAttribute("DpatSDC");
				idStrutturaAreaSelezionata=dpatStrumentoCalcolo.getIdStrutturaAreaSelezionata();
			}
			if (idStrutturaAreaSelezionata<=0 && context.getRequest().getParameter("combo_area")!=null)
			{
				idArea = context.getRequest().getParameter("combo_area");
				if (idArea!=null && !"".equals(idArea))
					idStrutturaAreaSelezionata = Integer.parseInt(idArea);
			}
			else
			{
				idStrutturaAreaSelezionata = (Integer)context.getRequest().getAttribute("idStrutturaAreaSelezionata");
			}
			
			
			if(checkStrutture!=null && "1".equals(checkStrutture))
			{
				idStrutturaAreaSelezionata= -1;
			}
			
			
			dpatStrumentoCalcolo = new DpatStrumentoCalcolo(db,idAsl,Integer.parseInt(anno),this.getSystemStatus(context),idStrutturaAreaSelezionata);

			LookupList qualifiche = new LookupList(db,"lookup_qualifiche");
			qualifiche.addItem(-1, "Seleziona Qualifica") ;
			context.getRequest().setAttribute("Qualifica", qualifiche);


			LookupList listaAsl = new LookupList(db,"lookup_site_id");
			context.getRequest().setAttribute("ListaAsl", listaAsl);
			
			
			LookupList lookupTipologia = new LookupList(db, "lookup_tipologia_nodo_oia");
			lookupTipologia.addItem(-1,  "-- SELEZIONA VOCE --");
			context.getRequest().setAttribute("lookupTipologia", lookupTipologia);
			context.getRequest().setAttribute("DpatSDC", dpatStrumentoCalcolo);
			
			LookupList lookupTipologia2 = new LookupList();
			lookupTipologia2.setShowDisabledFlag(false);
			lookupTipologia2.setTableName("lookup_tipologia_nodo_oia");
			lookupTipologia2.buildListWithEnabled(db);
			
			context.getRequest().setAttribute("lookupTipologia2", lookupTipologia2);

			
			String sql = "select id from dpat where id_asl="+idAsl+" and anno="+anno;
			PreparedStatement pst = db.prepareStatement(sql);
			ResultSet rs = pst.executeQuery();
			int idDpat = -1;
			while (rs.next()){
				idDpat = rs.getInt("id");  
			}
			org.aspcfs.modules.dpat.base.Dpat d = new org.aspcfs.modules.dpat.base.Dpat();
			d.builRecordSdc(idDpat, db,this.getSystemStatus(context));
			context.getRequest().setAttribute("dpat", d);
			pst.close();
			
			String note = context.getParameter("note");
			
			int id = DatabaseUtils.getNextInt(db, "dpat_strumento_calcolo_storico_esportazioni", "id", 1);
			if(id==0)
				id=1 ;
			String insertStorico = "insert into dpat_strumento_calcolo_storico_esportazioni(id ,data ,estratto_da ,id_asl  ,descrizione_struttura ,id_struttura  ,note ,anno,tipo,check_tutte_le_strutture ) values (?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement pstStorico = db.prepareStatement(insertStorico);
			pstStorico.setInt(1, id);
			pstStorico.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
			pstStorico.setInt(3, utente.getUserId());
			pstStorico.setInt(4, dpatStrumentoCalcolo.getIdAsl());
			pstStorico.setString(5, dpatStrumentoCalcolo.getStrutturaAmbito().getDescrizione_lunga());
			pstStorico.setInt(6, dpatStrumentoCalcolo.getStrutturaAmbito().getId());
			pstStorico.setString(8, note);
			pstStorico.setInt(7, dpatStrumentoCalcolo.getStrutturaAmbito().getAnno());
			pstStorico.setString(9, "Modello 4");
			if(checkStrutture!=null)
				pstStorico.setBoolean(10, true);
			else
				pstStorico.setBoolean(10, false);

			
			pstStorico.execute();
			
			GestioneDocumentiDPAT generazionePDF = new GestioneDocumentiDPAT();
			String codDocumento = generazionePDF.generaPdfDpat("DPAT_SDC",idAsl+"",anno,idArea,id,context);
			
			String update = "update dpat_strumento_calcolo_storico_esportazioni set cod_documento=? where id =?";
			pstStorico = db.prepareStatement(update);
			pstStorico.setString(1, codDocumento);
			pstStorico.setInt(2, id);
			pstStorico.execute();
//			GestioneDocumentiDPAT.do?command=GeneraPDF&combo_area='+idArea+'&idAsl='+idAsl+'&anno='+anno+'&tipo='+tipo
			
			HSSFWorkbook wb = new HSSFWorkbook();
			HSSFSheet sheet = wb.createSheet();
			HSSFRow row = sheet.createRow(0);
			
			HSSFCell cell = row.createCell(0);
			cell.setCellValue("STRUTTURA DI APPARTENENZA");
			
			HSSFCell cell10 = row.createCell(1);
			cell10.setCellValue("AMBITO");
			
			
			HSSFCell cel1 = row.createCell(2);
			cel1.setCellValue("NOMINATIVO");
			
			HSSFCell cel2 = row.createCell(3);
			cel2.setCellValue("QUALIFICA");
			HSSFCell cel3 = row.createCell(4);
			cel3.setCellValue("CARICO DI LAVORO TEORICO ANNUALE MINIMO AD PERSONAM IN UI");
			HSSFCell cel4 = row.createCell(5);
			cel4.setCellValue("FATTORI CHE INCIDONO SUL CARICO DI LAVORO MINIMO AD PERSONAM");
			HSSFCell cel5 = row.createCell(6);
			cel5.setCellValue("PERCENTUALE DI UI DA SOTTRARRE");
			HSSFCell cel6 = row.createCell(7);
			cel6.setCellValue("CARICO DI LAVORO EFFETTIVO ANNUALE MINIMO DI STRUTTURA (SUBTOTALE DEI CARICHI AD PERSONAM)");
			HSSFCell cel7 = row.createCell(8);
			cel7.setCellValue("FATTORI CHE INCIDNO NEGATIVAMENTE SUL CARICO DI LAVORO MINIMO DI STRUTTURA");
			HSSFCell cel8 = row.createCell(9);
			cel8.setCellValue("PERCENTUALE DI UI DA SOTTRARRE");
			HSSFCell cel9 = row.createCell(10);
			cel9.setCellValue("CARICO DI LAVORO EFFETTIVO ANNUALE MINIMO DI STRUTTURA");
			
			int i = 1 ;
			
			for ( Object nodo : dpatStrumentoCalcolo.getListaStrutture())
			{
				OiaNodo struttura = (OiaNodo) nodo;
				DpatStrumentoCalcoloNominativiList listaPersone = struttura.getListaNominativi();
				Iterator<DpatStrumentoCalcoloNominativi> persone = listaPersone.iterator();
				
				while ( persone.hasNext())
				{
					
					DpatStrumentoCalcoloNominativi personaCurr = persone.next();
					HSSFRow row_ = sheet.createRow(i);
					HSSFCell cell_0 = row_.createCell(0);
					cell_0.setCellValue(struttura.getDescrizione_lunga());
					
					HSSFCell cell_10 = row_.createCell(1);
					cell_10.setCellValue(struttura.getDescrizioneAreaStruttureComplesse());
					
					HSSFCell cel_1 = row_.createCell(2);
					cel_1.setCellValue(personaCurr.getNominativo().getContact().getNameLast() +" " + personaCurr.getNominativo().getContact().getNameFirst());
					
					HSSFCell cel_2 = row_.createCell(3);
					cel_2.setCellValue(qualifiche.getSelectedValue(personaCurr.getIdLookupQualifica()).toUpperCase());
					HSSFCell cel_3 = row_.createCell(4);
					cel_3.setCellValue(personaCurr.getCaricoLavoroAnnuale());
					HSSFCell cel_4 = row_.createCell(5);
					cel_4.setCellValue(personaCurr.getFattoriIncidentiSuCarico());
					HSSFCell cel_5 = row_.createCell(6);
					cel_5.setCellValue(personaCurr.getPercentualeDaSottrarre());
					HSSFCell cel_6 = row_.createCell(7);
					cel_6.setCellValue(personaCurr.getCaricoEffettivoAnnuale());
					HSSFCell cel_7 = row_.createCell(8);
					cel_7.setCellValue(struttura.getFattoriIncidentiSuCarico());
					HSSFCell cel_8 = row_.createCell(9);
					cel_8.setCellValue(struttura.getPercentualeDaSottrarre());
					HSSFCell cel_9 = row_.createCell(10);
					cel_9.setCellValue(struttura.getCaricoLavoroEffettivo());
					i++;
				}
			}
			
			// write it as an excel attachment
			ByteArrayOutputStream outByteStream = new ByteArrayOutputStream();
			wb.write(outByteStream);
			byte [] outArray = outByteStream.toByteArray();
			context.getResponse().setContentType("application/vnd.ms-excel");
			context.getResponse().setContentLength(outArray.length);
			context.getResponse().setHeader("Expires:", "0"); // eliminates browser caching
			context.getResponse().setHeader("Content-Disposition", "attachment; filename=MODELLO_4_"+dpatStrumentoCalcolo.getStrutturaAmbito().getDescrizione_lunga()+".xls");
			java.io.OutputStream outStream = context.getResponse().getOutputStream();
			outStream.write(outArray);
			outStream.flush();
			
		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			e.printStackTrace();
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}	

		// SERVER DOCUMENTALE
		return "-none-";


	}
	
	public String executeCommandMessaggioVisualizza(ActionContext context) {
		
		 Connection db = null;
		 String messaggio = "";	
			try {
				db = this.getConnection(context);
				
				PreparedStatement pst = db.prepareStatement("select messaggio from messaggio_mod4 order by entered desc limit 1;");
				ResultSet rs = pst.executeQuery();
				if (rs.next())
					messaggio = rs.getString("messaggio");

				context.getRequest().setAttribute("messaggio", messaggio);
			} catch (Exception errorMessage) {
				context.getRequest().setAttribute("Error", errorMessage);
				return ("SystemError");
			} finally {
				this.freeConnection(context, db);
			}
			
			return "messaggioOK";
		}
	
	public String executeCommandMessaggioModifica(ActionContext context) {
		 
		 if (!hasPermission(context, "messaggio_mod4-add")) {
				return ("PermissionError");
			}
		 
			Connection db = null;
			String messaggio = "";
			try {
				db = this.getConnection(context);
				PreparedStatement pst = db.prepareStatement("select messaggio from messaggio_mod4 order by entered desc limit 1;");
				ResultSet rs = pst.executeQuery();
				if (rs.next())
					messaggio = rs.getString("messaggio");

				context.getRequest().setAttribute("messaggio", messaggio);
				
			} catch (Exception errorMessage) {
				context.getRequest().setAttribute("Error", errorMessage);
				return ("SystemError");
			} finally {
				this.freeConnection(context, db);
			}
			return "messaggioModificaOK";
		}
	
	 public String executeCommandMessaggioAggiorna(ActionContext context) {
		 
		 if (!hasPermission(context, "messaggio_mod4-add")) {
				return ("PermissionError");
			}
		 
			Connection db = null;

			String messaggio = context.getRequest().getParameter("messaggio");
			UserBean utente = (UserBean) context.getRequest().getSession().getAttribute("User");

			
			try {
				db = this.getConnection(context);
				PreparedStatement pst = db.prepareStatement("insert into messaggio_mod4(messaggio, id_utente) values (?, ?);");
				pst.setString(1,  messaggio);
				pst.setInt(2, utente.getUserId());
				pst.execute();
			} catch (Exception errorMessage) {
				context.getRequest().setAttribute("Error", errorMessage);
				return ("SystemError");
			} finally {
				this.freeConnection(context, db);
			}
			
			return executeCommandMessaggioVisualizza(context);
		}
}
