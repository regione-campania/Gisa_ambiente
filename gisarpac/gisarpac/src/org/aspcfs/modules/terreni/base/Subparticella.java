package org.aspcfs.modules.terreni.base;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;

public class Subparticella implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int id;
	private int idPadre;
	private String codiceSito;
	private Timestamp entered;
	private int enteredBy;
	
	private Area area = new Area();
	
	public Subparticella() {
		// TODO Auto-generated constructor stub
	}
	
	public Subparticella(Connection db, int id) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from get_dettaglio_particella(?)");  
		pst.setInt(1, id);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			buildRecord(rs);
			setArea(db, idPadre);
		}
	}
	private void setArea(Connection db, int idPadre) throws SQLException {
		Area padre = new Area(db, idPadre);
		this.area = padre;		
	}

	public Subparticella(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	public Subparticella(ActionContext context) {
		codiceSito = context.getRequest().getParameter("codiceSito");
		idPadre = Integer.parseInt(context.getRequest().getParameter("idArea"));
	}

	private void buildRecord(ResultSet rs) throws SQLException {
		id = rs.getInt("id");
		idPadre = rs.getInt("id_padre");
		codiceSito = rs.getString("codice_sito");
		entered = rs.getTimestamp("entered");
		enteredBy = rs.getInt("entered_by");		
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getCodiceSito() {
		return codiceSito;
	}

	public void setCodiceSito(String codiceSito) {
		this.codiceSito = codiceSito;
	}

	
	


	public Timestamp getEntered() {
		return entered;
	}

	public void setEntered(Timestamp entered) {
		this.entered = entered;
	}

	public int getEnteredBy() {
		return enteredBy;
	}

	public void setEnteredBy(int enteredBy) {
		this.enteredBy = enteredBy;
	}

	public int getIdPadre() {
		return idPadre;
	}

	public void setIdPadre(int idPadre) {
		this.idPadre = idPadre;
	}

	public Area getArea() {
		return area;
	}

	public void setArea(Area area) {
		this.area = area;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public static ArrayList<Subparticella> buildListByIdAreaParticella(Connection db, int idAreaParticella) throws SQLException {
		ArrayList<Subparticella> lista = new ArrayList<Subparticella>();
		PreparedStatement pst = db.prepareStatement("select * from get_lista_subparticelle(?)");
		pst.setInt(1, idAreaParticella);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			Subparticella s = new Subparticella(rs);
			lista.add(s);
		}
	return lista;
	}

	public void insert(Connection db, int userId) throws SQLException {
		PreparedStatement pst = null;
		String sql = "select * from insert_subparticella(?, ?, ?);";
		pst = db.prepareStatement(sql);
		int i = 0;
		pst.setInt(++i, idPadre);
		pst.setString(++i, codiceSito);
		pst.setInt(++i, userId);
		
		ResultSet rs = pst.executeQuery();
		
		if(rs.next()){
			id = rs.getInt(1);
		}		
	}
	
	public void update(Connection db, int userId) throws SQLException {
		PreparedStatement pst = null;
		String sql = "select * from update_subparticella(?, ?, ?, ?);";
		pst = db.prepareStatement(sql);
		int i = 0;
		pst.setInt(++i, id);
		pst.setInt(++i, idPadre);
		pst.setString(++i, codiceSito);
		pst.setInt(++i, userId);
		
		ResultSet rs = pst.executeQuery();
		
		if(rs.next()){
			id = rs.getInt(1);
		}		
	}

	public static JSONArray getJsonNonCampionate(Connection db) throws SQLException, JSONException {

		JSONArray jsonNonCampionate = new JSONArray();
		
		PreparedStatement pst = db.prepareStatement("select * from get_json_aree_non_campionate()");
		ResultSet rs = pst.executeQuery();
		
		if (rs.next()){
			String jsonString = rs.getString(1);
			JSONArray jsonAree = new JSONArray();
			
			if (jsonString != null) {
				
				try {jsonAree = new JSONArray(jsonString);} catch (Exception e){}
			
				for (int i = 0; i <jsonAree.length(); i++) {
					JSONObject jsonArea = (JSONObject) jsonAree.get(i);

					PreparedStatement pst2 = db.prepareStatement("select * from get_json_subparticelle_non_campionate(?)");
					pst2.setInt(1, (int) jsonArea.get("riferimentoId"));
					ResultSet rs2 = pst2.executeQuery();
					if (rs2.next()){
						String jsonString2 = rs2.getString(1);
						JSONArray jsonSubparticelle = new JSONArray(jsonString2);
						jsonArea.put("Subparticelle", jsonSubparticelle);
					}
					jsonNonCampionate.put(jsonArea);
				}
			}
		}
		
		return jsonNonCampionate;
	}

	
}