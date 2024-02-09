package org.aspcfs.modules.gestioneispettive.actions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.utils.PopolaCombo;
import org.json.JSONException;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;

public class GestioneVerbali extends CFSModule{


	public String executeCommandViewVerbaleA6(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		int idGiornataIspettiva = -1;
		JSONObject jsonVerbale = new JSONObject();

		Connection db = null;

		try 
		{
			db = this.getConnection(context);




			try {idGiornataIspettiva = Integer.parseInt(context.getRequest().getParameter("idGiornataIspettiva"));} catch (Exception e) {}
			if (idGiornataIspettiva == -1)
				try {idGiornataIspettiva = Integer.parseInt((String) context.getRequest().getAttribute("idGiornataIspettiva"));} catch (Exception e) {}

			jsonVerbale = getJsonA6(db, idGiornataIspettiva);

			//SE C'E' UN PROTOCOLLO, AVVISO
			String[] datiProtocollo = PopolaCombo.getDatiProtocollo(idGiornataIspettiva, "VerbaleA6");
			int annoProtocollo = Integer.parseInt(datiProtocollo[0]);
			int numeroProtocollo = Integer.parseInt(datiProtocollo[1]);
			if (annoProtocollo > 0 && numeroProtocollo > 0)
				context.getRequest().setAttribute("hasProtocollo", "true");


		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonVerbale", jsonVerbale); 
		context.getRequest().setAttribute("tipoVerbale", "A6");
		context.getRequest().setAttribute("idGiornataIspettiva", String.valueOf(idGiornataIspettiva));

		return "ViewVerbaleGiornataIspettivaOK";
	}

	public String executeCommandViewVerbaleC4(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		int idCampione = -1;
		JSONObject jsonVerbale = new JSONObject();

		Connection db = null;

		try 
		{
			db = this.getConnection(context);




			try {idCampione = Integer.parseInt(context.getRequest().getParameter("idCampione"));} catch (Exception e) {}
			if (idCampione == -1)
				try {idCampione = Integer.parseInt((String) context.getRequest().getAttribute("idCampione"));} catch (Exception e) {}

			jsonVerbale = getJsonC4(db, idCampione);

			//SE C'E' UN PROTOCOLLO, AVVISO
			String[] datiProtocollo = PopolaCombo.getDatiProtocolloCampione(idCampione, "VerbaleC4");
			int annoProtocollo = Integer.parseInt(datiProtocollo[0]);
			int numeroProtocollo = Integer.parseInt(datiProtocollo[1]);
			if (annoProtocollo > 0 && numeroProtocollo > 0)
				context.getRequest().setAttribute("hasProtocollo", "true");


		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonVerbale", jsonVerbale); 
		context.getRequest().setAttribute("tipoVerbale", "C4");
		context.getRequest().setAttribute("idCampione", String.valueOf(idCampione));

		return "ViewVerbaleCampioneOK";
	}


	public String executeCommandViewVerbaleAcqueSott(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		int idCampione = -1;
		JSONObject jsonVerbale = new JSONObject();

		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			try {idCampione = Integer.parseInt(context.getRequest().getParameter("idCampione"));} catch (Exception e) {}
			if (idCampione == -1)
				try {idCampione = Integer.parseInt((String) context.getRequest().getAttribute("idCampione"));} catch (Exception e) {}

			jsonVerbale = getJsonAcqueSott(db, idCampione);

			//SE C'E' UN PROTOCOLLO, AVVISO
			String[] datiProtocollo = PopolaCombo.getDatiProtocolloCampione(idCampione, "AcqueSott");
			int annoProtocollo = Integer.parseInt(datiProtocollo[0]);
			int numeroProtocollo = Integer.parseInt(datiProtocollo[1]);
			if (annoProtocollo > 0 && numeroProtocollo > 0)
				context.getRequest().setAttribute("hasProtocollo", "true");
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonVerbale", jsonVerbale); 
		context.getRequest().setAttribute("tipoVerbale", "AcqueSott");
		context.getRequest().setAttribute("idCampione", String.valueOf(idCampione));

		return "ViewVerbaleCampioneOK";
	}

	public String executeCommandViewVerbaleCampionamentoSuolo(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		int idCampione = -1;
		JSONObject jsonVerbale = new JSONObject();

		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			try {idCampione = Integer.parseInt(context.getRequest().getParameter("idCampione"));} catch (Exception e) {}
			if (idCampione == -1)
				try {idCampione = Integer.parseInt((String) context.getRequest().getAttribute("idCampione"));} catch (Exception e) {}

			jsonVerbale = getJsonCampionamentoSuolo(db, idCampione);

			//SE C'E' UN PROTOCOLLO, AVVISO
			String[] datiProtocollo = PopolaCombo.getDatiProtocolloCampione(idCampione, "CampionamentoSuolo");
			int annoProtocollo = Integer.parseInt(datiProtocollo[0]);
			int numeroProtocollo = Integer.parseInt(datiProtocollo[1]);
			if (annoProtocollo > 0 && numeroProtocollo > 0)
				context.getRequest().setAttribute("hasProtocollo", "true");
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonVerbale", jsonVerbale); 
		context.getRequest().setAttribute("tipoVerbale", "CampionamentoSuolo");
		context.getRequest().setAttribute("idCampione", String.valueOf(idCampione));

		return "ViewVerbaleCampioneOK";
	}

	public String executeCommandViewVerbaleMancatoCampionamentoSuolo(ActionContext context) throws NumberFormatException, IllegalAccessException, InstantiationException
	{

		int idArea = -1;
		JSONObject jsonVerbale = new JSONObject();

		Connection db = null;

		try 
		{
			db = this.getConnection(context);

			try {idArea = Integer.parseInt(context.getRequest().getParameter("idArea"));} catch (Exception e) {}
			if (idArea == -1)
				try {idArea = Integer.parseInt((String) context.getRequest().getAttribute("idArea"));} catch (Exception e) {}

			jsonVerbale = getJsonMancatoCampionamentoSuolo(db, idArea);
			
		} 

		catch (Exception e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			this.freeConnection(context, db);
		}

		context.getRequest().setAttribute("jsonVerbale", jsonVerbale); 
		context.getRequest().setAttribute("tipoVerbale", "MancatoCampionamentoSuolo");
		context.getRequest().setAttribute("idArea", String.valueOf(idArea));

		return "ViewVerbaleCampioneOK";
	}

	
	private JSONObject getJsonA6(Connection db, int idGiornataIspettiva) throws SQLException, JSONException {

		JSONObject jsonVerbale = new JSONObject();

		PreparedStatement pst = db.prepareStatement("select * from giornata_ispettiva_get_verbale_a6(?)");
		pst.setInt(1, idGiornataIspettiva);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			String jsonString = rs.getString(1);
			jsonVerbale = new JSONObject(jsonString);
		}
		return jsonVerbale;
	}


	private JSONObject getJsonC4(Connection db, int idCampione) throws SQLException, JSONException {

		JSONObject jsonVerbale = new JSONObject();

		PreparedStatement pst = db.prepareStatement("select * from campione_get_verbale_c4(?)");
		pst.setInt(1, idCampione);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			String jsonString = rs.getString(1);
			jsonVerbale = new JSONObject(jsonString);
		}
		return jsonVerbale;
	}

	private JSONObject getJsonAcqueSott(Connection db, int idCampione) throws SQLException, JSONException {

		JSONObject jsonVerbale = new JSONObject();

		PreparedStatement pst = db.prepareStatement("select * from campione_get_verbale_acquesott(?)");
		pst.setInt(1, idCampione);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			String jsonString = rs.getString(1);
			jsonVerbale = new JSONObject(jsonString);
		}
		return jsonVerbale;
	}
	
	private JSONObject getJsonCampionamentoSuolo(Connection db, int idCampione) throws SQLException, JSONException {

		JSONObject jsonVerbale = new JSONObject();

		PreparedStatement pst = db.prepareStatement("select * from campione_get_verbale_campionamento_suolo(?)");
		pst.setInt(1, idCampione);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			String jsonString = rs.getString(1);
			jsonVerbale = new JSONObject(jsonString);
		}
		return jsonVerbale;
	}
	
	private JSONObject getJsonMancatoCampionamentoSuolo(Connection db, int idArea) throws SQLException, JSONException {

		JSONObject jsonVerbale = new JSONObject();

		PreparedStatement pst = db.prepareStatement("select * from campione_get_verbale_mancato_campionamento_suolo(?)");
		pst.setInt(1, idArea);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			String jsonString = rs.getString(1);
			jsonVerbale = new JSONObject(jsonString);
		}
		return jsonVerbale;
	}

}
