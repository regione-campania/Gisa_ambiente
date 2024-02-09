package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class GiornataIspettiva {
	
	private int idGiornataIspettiva = -1;
	
	public GiornataIspettiva() {
		// TODO Auto-generated constructor stub
	}


	public GiornataIspettiva(ResultSet rs) throws SQLException {
	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.idGiornataIspettiva = rs.getInt("id_giornata_ispettiva");
	}

	public void insert (Connection db, JSONObject jsonGiornataIspettiva) throws SQLException {
		String select = "select * from public.giornata_ispettiva_insert_globale(to_json(?::json))";  
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setString(1, jsonGiornataIspettiva.toString());

		System.out.println("[GESTIONE GIORNATE ISPETTIVE] [INSERT] "+pst.toString());

		rs = pst.executeQuery();
		while (rs.next()){
			this.idGiornataIspettiva = rs.getInt(1);
			}
	}

	public static final JSONObject getJson(Connection db, int idGiornataIspettiva) throws SQLException, ParseException, JSONException {
		JSONObject jsonGiornataIspettiva = new JSONObject();
		String select = "select * from public.giornata_ispettiva_dettaglio_globale(?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idGiornataIspettiva);
		
		System.out.println("[GESTIONE GIORNATE ISPETTIVE] [DETTAGLIO] "+pst.toString());

		rs = pst.executeQuery();
		while (rs.next()){
			jsonGiornataIspettiva = new JSONObject(rs.getString(1));
			}
		return jsonGiornataIspettiva;
	}
	
	public static final JSONArray getJsonLista(Connection db, int riferimentoId, String riferimentoIdNomeTab) throws SQLException, ParseException, JSONException {
		JSONArray jsonGiornateIspettive = new JSONArray();
		String select = "select * from public.giornate_ispettive_lista_globale(?, ?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, riferimentoId);
		pst.setString(2, riferimentoIdNomeTab);
		
		System.out.println("[GESTIONE GIORNATE ISPETTIVE] [LISTA] "+pst.toString());

		rs = pst.executeQuery();
		while (rs.next()){
			jsonGiornateIspettive = new JSONArray(rs.getString(1));
			}
		return jsonGiornateIspettive;
	}
	
	public static final JSONArray getJsonLista(Connection db, int idFascicolo) throws SQLException, ParseException, JSONException {
		JSONArray jsonGiornateIspettive = new JSONArray(); 
		String select = "select * from public.giornate_ispettive_lista_globale(?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idFascicolo);
		
		System.out.println("[GESTIONE GIORNATE ISPETTIVE] [LISTA] "+pst.toString());

		rs = pst.executeQuery();
		while (rs.next()){
			if (rs.getString(1)!=null)
				jsonGiornateIspettive = new JSONArray(rs.getString(1));
			}
		return jsonGiornateIspettive;
	}

	public int getIdGiornataIspettiva() {
		return idGiornataIspettiva;
	}


	public void setIdGiornataIspettiva(int idGiornataIspettiva) {
		this.idGiornataIspettiva = idGiornataIspettiva;
	}

}
