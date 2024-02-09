package org.aspcfs.modules.terreni.base;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class Particella implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int id;
	private String codice;
	private int cod_provincia;
	private String desc_provincia;
	private int cod_comune;
	private String desc_comune;
	private String foglio_catastale;
	private String particella_catastale;
	private String classe_rischio;
	private String coordinate_x;
	private String coordinate_y;
	private String area;
	private String note;
	private Timestamp entered;
	private int entered_by;
	
	public Particella() {
		// TODO Auto-generated constructor stub
	}
	
	public Particella(Connection db, int idParticella) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from particelle where id = ?");
		pst.setInt(1, idParticella);
		ResultSet rs = pst.executeQuery();
		if (rs.next())
			buildRecord(rs);
	}
	private void buildRecord(ResultSet rs) throws SQLException {
		id = rs.getInt("id");
		codice = rs.getString("codice_sito");
		foglio_catastale = rs.getString("foglio_catastale");
		particella_catastale = rs.getString("particella_catastale");
		cod_comune = rs.getInt("comune");
	}

	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getCodice() {
		return codice;
	}
	public void setCodice(String codice) {
		this.codice = codice;
	}
	public int getCod_provincia() {
		return cod_provincia;
	}
	public void setCod_provincia(int cod_provincia) {
		this.cod_provincia = cod_provincia;
	}
	public String getDesc_provincia() {
		return desc_provincia;
	}
	public void setDesc_provincia(String desc_provincia) {
		this.desc_provincia = desc_provincia;
	}
	public int getCod_comune() {
		return cod_comune;
	}
	public String getFoglio_catastale() {
		return foglio_catastale;
	}
	public void setFoglio_catastale(String foglio_catastale) {
		this.foglio_catastale = foglio_catastale;
	}
	public String getParticella_catastale() {
		return particella_catastale;
	}
	public void setParticella_catastale(String particella_catastale) {
		this.particella_catastale = particella_catastale;
	}
	public void setCod_comune(int cod_comune) {
		this.cod_comune = cod_comune;
	}
	public String getDesc_comune() {
		return desc_comune;
	}
	public void setDesc_comune(String desc_comune) {
		this.desc_comune = desc_comune;
	}
	public String getClasse_rischio() {
		return classe_rischio;
	}
	public void setClasse_rischio(String classe_rischio) {
		this.classe_rischio = classe_rischio;
	}
	public String getCoordinate_x() {
		return coordinate_x;
	}
	public void setCoordinate_x(String coordinate_x) {
		this.coordinate_x = coordinate_x;
	}
	public String getCoordinate_y() {
		return coordinate_y;
	}
	public void setCoordinate_y(String coordinate_y) {
		this.coordinate_y = coordinate_y;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public Timestamp getEntered() {
		return entered;
	}
	public void setEntered(Timestamp entered) {
		this.entered = entered;
	}
	public int getEntered_by() {
		return entered_by;
	}
	public void setEntered_by(int entered_by) {
		this.entered_by = entered_by;
	}
}