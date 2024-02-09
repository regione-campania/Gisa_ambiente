package org.aspcfs.modules.gestioneanagraficaremota.actions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.aspcfs.modules.accounts.base.Comuni;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneanagraficaremota.base.AnagraficaRemota;

import com.darkhorseventures.framework.actions.ActionContext;

public class GestioneAnagraficaRemotaAction extends CFSModule {

	public String executeCommandPrepareSearchAnagraficaRemota(ActionContext context) throws SQLException {
		if (!hasPermission(context, "opu-add")) {
			return ("PermissionError");
		}
		
		Connection db = null;
		ArrayList<Comuni> comuni = new ArrayList<Comuni>();

		try {
			db = this.getConnection(context);
				
			Comuni comune = new Comuni();
			
			comuni.addAll(comune.buildList(db, 201));
			comuni.addAll(comune.buildList(db, 202));
			comuni.addAll(comune.buildList(db, 203));
			comuni.addAll(comune.buildList(db, 204));
			comuni.addAll(comune.buildList(db, 205));
			comuni.addAll(comune.buildList(db, 206));
			comuni.addAll(comune.buildList(db, 207));
		
			context.getRequest().setAttribute("ComuniList", comuni);
		
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			this.freeConnection(context, db);
		}
		
		
		
		
		
		
		
		
		
		return "PrepareSearchAnagraficaRemotaOK"; 
	}

	public String executeCommandSearchAnagraficaRemota(ActionContext context) throws SQLException {
		if (!hasPermission(context, "opu-add")) {
			return ("PermissionError");
		}
		Connection db = null;
		
	  	String ragioneSociale = context.getRequest().getParameter("ragioneSociale");
	  	String partitaIva = context.getRequest().getParameter("partitaIva");
	  	String cfImpresa = context.getRequest().getParameter("cfImpresa");
	  	String asl = context.getRequest().getParameter("asl");
	  	String comune = context.getRequest().getParameter("comune");

	  	ArrayList<AnagraficaRemota> listaAnagrafiche = new ArrayList<AnagraficaRemota>();

		try {
			db = this.getConnection(context);
		
			PreparedStatement pst = db.prepareStatement("select * from get_all_data_from_gisa_anag(?, ?, ?, ?, ?);");
			pst.setString(1, ragioneSociale);
			pst.setString(2, partitaIva);
			pst.setString(3, cfImpresa);
			pst.setString(4, asl);
			pst.setString(5, comune);

			ResultSet rs = pst.executeQuery();
			
			while (rs.next()){
				AnagraficaRemota anag = new AnagraficaRemota(rs);
				listaAnagrafiche.add(anag);
	}
			
			context.getRequest().setAttribute("ListaAnagrafiche", listaAnagrafiche);

		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			this.freeConnection(context, db);
		}

		return "SearchAnagraficaRemotaOK"; 
	}

	public String executeCommandImportAnagraficaRemota(ActionContext context) throws SQLException {
		if (!hasPermission(context, "opu-add")) {
			return ("PermissionError");
		}
		Connection db = null;
		
	  	String riferimentoId = context.getRequest().getParameter("riferimentoId");
	  	String riferimentoIdNomeTab = context.getRequest().getParameter("riferimentoIdNomeTab");
	  	int idStabilimento = -1;


		try {
			db = this.getConnection(context);
		
			PreparedStatement pst = db.prepareStatement("select * from import_from_gisa_anag(?, ?);");
			pst.setInt(1, Integer.parseInt(riferimentoId));
			pst.setString(2, riferimentoIdNomeTab);
			
			ResultSet rs = pst.executeQuery();
			
			while (rs.next()){
				idStabilimento = rs.getInt(1);
	}
			
			context.getRequest().setAttribute("idStabilimento", String.valueOf(idStabilimento));

		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			this.freeConnection(context, db);
		}

		return "ImportAnagraficaRemotaOK"; 
	}
	
}
