package org.aspcfs.modules.ricerca_globale.actions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Logger;

import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.utils.web.LookupList;

import com.darkhorseventures.framework.actions.ActionContext;
//import org.aspcfs.modules.accounts.base.Organization;
//import org.aspcfs.modules.accounts.base.OrganizationList;
//import com.lowagie.text.Cell;

public final class RicercaGlobale extends CFSModule {

	Logger logger = Logger.getLogger("MainLogger");


	
	public String executeCommandSearchFormIspettiva(ActionContext context) {
	    if (!(hasPermission(context, "global-search-view"))) {
	      return ("PermissionError");
	    }
	    
	    //Bypass search form for portal users
	   
	    SystemStatus systemStatus = this.getSystemStatus(context);
	    Connection db = null;
	    
	    try {
	      db = getConnection(context);
	      LookupList siteList = new LookupList(db, "lookup_site_id");
	      siteList.addItem(Constants.INVALID_SITE,  "-- TUTTI --");
	      context.getRequest().setAttribute("SiteList", siteList);
	      this.deletePagedListInfo(context, "searchListInfo");
	       
	      
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {	
	      this.freeConnection(context, db);
	    }
	    addModuleBean(context, "Search Accounts", "Accounts Search");
	    return ("SearchIspettivaOK");
	    
	  }
	
	public String executeCommandSearchIspettiva(ActionContext context) {
	    if (!(hasPermission(context, "global-search-view"))) {
	      return ("PermissionError");
	    }
	    
	    //Bypass search form for portal users
	   
	    SystemStatus systemStatus = this.getSystemStatus(context);
	    Connection db = null;
	    
	    int idGiornataIspettiva = -1;
	    int idFascicoloIspettivo = -1;
	    
	    try {idGiornataIspettiva = Integer.parseInt(context.getRequest().getParameter("idGiornataIspettiva"));} catch (Exception e) {}
	    try {idFascicoloIspettivo = Integer.parseInt(context.getRequest().getParameter("idFascicoloIspettivo"));} catch (Exception e) {}

	   	String risultato = "";
	   	
	    try {
	      db = getConnection(context);
	      PreparedStatement pst = null;
	      
	      if (idFascicoloIspettivo > 0){
		      pst = db.prepareStatement("select * from search_globale_fascicolo_ispettivo(?)");
		      pst.setInt(1, idFascicoloIspettivo);
	      }
	      else if (idGiornataIspettiva > 0){
		      pst = db.prepareStatement("select * from search_globale_giornata_ispettiva(?)");
		      pst.setInt(1, idGiornataIspettiva);
	      }
	      
	     
	      ResultSet rs = pst.executeQuery();
	      
	      while (rs.next()){
	    	  String _idGiornataIspettiva = rs.getString("id_giornata_ispettiva");
	    	  String _idFascicoloIspettivo = rs.getString("id_fascicolo_ispettivo");
	    	  String _numFascicolo = rs.getString("num_fascicolo");
	    	  String _ragioneSociale = rs.getString("ragione_sociale");
	    	  String _dataInizio = rs.getString("data_inizio");
	    	  String _dipartimento = rs.getString("dipartimento");
	    	  risultato = _idGiornataIspettiva+";;"+_idFascicoloIspettivo+";;"+_numFascicolo+";;"+_dataInizio+";;"+_dipartimento+";;"+_ragioneSociale;
	       }
	      
	      
	      
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {	
	      this.freeConnection(context, db);
	    }
	    
	    context.getRequest().setAttribute("risultato", risultato);
	    return ("ListIspettivaOK");
	    
	  }
	
}