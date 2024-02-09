package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Campione {
	
	private int idCampione = -1;
	
	public Campione() {
		// TODO Auto-generated constructor stub
	}


	public Campione(ResultSet rs) throws SQLException {
	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.idCampione = rs.getInt("id_campione");
	}

	public void insert (Connection db, JSONObject jsonCampione) throws SQLException {
		String select = "select * from public.campione_insert_globale(to_json(?::json))";  
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setString(1, jsonCampione.toString());
		
		System.out.println("[GESTIONE CAMPIONI] [INSERT] "+pst.toString());
		
		rs = pst.executeQuery();
		while (rs.next()){
			this.idCampione = rs.getInt(1);
			}
	}

	public static final JSONObject getJson(Connection db, int idCampione) throws SQLException, ParseException, JSONException {
		JSONObject jsonCampione = new JSONObject();
		String select = "select * from public.campione_dettaglio_globale(?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idCampione);
		
		System.out.println("[GESTIONE CAMPIONI] [DETTAGLIO] "+pst.toString());

		rs = pst.executeQuery();
		while (rs.next()){
			jsonCampione = new JSONObject(rs.getString(1));
			}
		return jsonCampione;
	}
	
	public static final JSONArray getJsonLista(Connection db, int idGiornataIspettiva) throws SQLException, ParseException, JSONException {
		JSONArray jsonCampioni = new JSONArray();
		String select = "select * from public.campioni_lista_globale(?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idGiornataIspettiva);
		
		System.out.println("[GESTIONE CAMPIONI] [LISTA] "+pst.toString());

		rs = pst.executeQuery();
		while (rs.next()){
			try {jsonCampioni = new JSONArray(rs.getString(1)); } catch (Exception e) {}
			}
		return jsonCampioni;
	}


	public int getIdCampione() {
		return idCampione;
	}


	public void setIdCampione(int idCampione) {
		this.idCampione = idCampione;
	}

	public void insertParticella (Connection db, JSONObject jsonCampione) throws SQLException {
		String select = "select * from public.campionamento_particella_insert_globale(to_json(?::json))";  
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setString(1, jsonCampione.toString());
		
		System.out.println("[GESTIONE CAMPIONI] [INSERT PARTICELLA] "+pst.toString());
		
		rs = pst.executeQuery();
		while (rs.next()){
			this.idCampione = rs.getInt(1);
			}
	}
	
	public static final JSONObject getJsonParticella(Connection db, int idCampione) throws SQLException, ParseException, JSONException {
		JSONObject jsonCampione = new JSONObject();
		String select = "select * from public.campionamento_particella_dettaglio_globale(?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idCampione);
		
		System.out.println("[GESTIONE CAMPIONI] [DETTAGLIO PARTICELLA] "+pst.toString());

		rs = pst.executeQuery();
		while (rs.next()){
			jsonCampione = new JSONObject(rs.getString(1));
			}
		return jsonCampione;
	}
	
	public static final JSONArray getJsonListaParticella(Connection db, int idParticella) throws SQLException, ParseException, JSONException {
		JSONArray jsonCampioni = new JSONArray();
		String select = "select * from public.campionamento_particella_lista_globale(?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idParticella);
		
		System.out.println("[GESTIONE CAMPIONI] [LISTA PARTICELLA] "+pst.toString());

		rs = pst.executeQuery();
		while (rs.next()){
			try {jsonCampioni = new JSONArray(rs.getString(1)); } catch (Exception e) {}
			}
		return jsonCampioni;
	}

}
