package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class FascicoloIspettivo {
	
	private int idFascicoloIspettivo = -1;
	
	public FascicoloIspettivo() {
		// TODO Auto-generated constructor stub
	}


	public FascicoloIspettivo(ResultSet rs) throws SQLException {
	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.idFascicoloIspettivo = rs.getInt("id_fascicolo_ispettivo");
	}

	public void insert (Connection db, JSONObject jsonFascicoloIspettivo) throws SQLException {
		String select = "select * from public.fascicolo_ispettivo_insert_globale(to_json(?::json))";  
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setString(1, jsonFascicoloIspettivo.toString());
		rs = pst.executeQuery();
		while (rs.next()){
			this.idFascicoloIspettivo = rs.getInt(1);
			}
	}

	public static final JSONObject getJson(Connection db, int idFascicoloIspettivo) throws SQLException, ParseException, JSONException {
		JSONObject jsonFascicoloIspettivo = new JSONObject();
		String select = "select * from public.fascicolo_ispettivo_dettaglio_globale(?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idFascicoloIspettivo);
		rs = pst.executeQuery();
		while (rs.next()){
			jsonFascicoloIspettivo = new JSONObject(rs.getString(1));
			}
		return jsonFascicoloIspettivo;
	}
	
	public static final JSONArray getJsonLista(Connection db, int riferimentoId, String riferimentoIdNomeTab) throws SQLException, ParseException, JSONException {
		JSONArray jsonFascicoliIspettivi = new JSONArray();
		String select = "select * from public.fascicoli_ispettivi_lista_globale(?, ?)";   
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, riferimentoId);
		pst.setString(2, riferimentoIdNomeTab);
		rs = pst.executeQuery();
		while (rs.next()){
			if (rs.getString(1)!=null)
				jsonFascicoliIspettivi = new JSONArray(rs.getString(1));
			}
		return jsonFascicoliIspettivi;
	}

	public int getIdFascicoloIspettivo() {
		return idFascicoloIspettivo;
	}


	public void setIdFascicoloIspettivo(int idFascicoloIspettivo) {
		this.idFascicoloIspettivo = idFascicoloIspettivo;
	}


	public static String close(Connection db, int idFascicoloIspettivo, String dataChiusura,String oraChiusura, int annoProtocollo, int numeroProtocollo, String codAllegato, int userId) throws SQLException {
		// TODO Auto-generated method stub
		String messaggio = null;
		String select = "select * from public.fascicolo_ispettivo_close(?,?,?, ?, ?, ?,?)";  
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idFascicoloIspettivo);
		pst.setString(2, dataChiusura);
		pst.setString(3, oraChiusura);
		pst.setInt(4, annoProtocollo);
		pst.setInt(5, numeroProtocollo);
		pst.setString(6, codAllegato);
		pst.setInt(7, userId);
		System.out.println("[GESTIONE FASCICOLO] [CLOSE] "+pst.toString());
		rs = pst.executeQuery();
		if (rs.next()){
			messaggio = rs.getString(1);
		}
		return messaggio;
	}
	
	public static String delete(Connection db, int idFascicoloIspettivo, String noteEliminazione, int userId) throws SQLException {
		// TODO Auto-generated method stub
		String messaggio = null;
		String select = "select * from public.fascicolo_ispettivo_delete(?,?,?)";  
		PreparedStatement pst = null ;
		ResultSet rs = null;
		pst = db.prepareStatement(select);
		pst.setInt(1, idFascicoloIspettivo);
		pst.setString(2, noteEliminazione);
		pst.setInt(3, userId);
		rs = pst.executeQuery();
		if (rs.next()){
			messaggio = rs.getString(1);
		}
		return messaggio;
	}

}
