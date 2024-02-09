package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class NonConformita {
	
	private int idNonConformita = -1;
	
	public NonConformita() {
		// TODO Auto-generated constructor stub
	}


	public NonConformita(ResultSet rs) throws SQLException {
	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.idNonConformita = rs.getInt("id_non_conformita");
	}

	public void insert (Connection db, JSONObject jsonNonConformita) throws SQLException {
		String select = "select * from public.non_conformita_insert_globale(to_json(?::json))";  
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setString(1, jsonNonConformita.toString());
		rs = pst.executeQuery();
		while (rs.next()){
			this.idNonConformita = rs.getInt(1);
			}
	}

	public static final JSONObject getJson(Connection db, int idNonConformita) throws SQLException, ParseException, JSONException {
		JSONObject jsonNonConformita = new JSONObject();
		String select = "select * from public.non_conformita_dettaglio_globale(?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idNonConformita);
		rs = pst.executeQuery();
		while (rs.next()){
			jsonNonConformita = new JSONObject(rs.getString(1));
			}
		return jsonNonConformita;
	}
	
	public static final JSONArray getJsonLista(Connection db, int idGiornataIspettiva) throws SQLException, ParseException, JSONException {
		JSONArray jsonNonConformita = new JSONArray();
		String select = "select * from public.non_conformita_lista_globale(?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idGiornataIspettiva);
		rs = pst.executeQuery();
		while (rs.next()){
			try {jsonNonConformita = new JSONArray(rs.getString(1)); } catch (Exception e) {}
			}
		return jsonNonConformita;
	}


	public int getIdNonConformita() {
		return idNonConformita;
	}


	public void setIdNonConformita(int idNonConformita) {
		this.idNonConformita = idNonConformita;
	}

	

}
