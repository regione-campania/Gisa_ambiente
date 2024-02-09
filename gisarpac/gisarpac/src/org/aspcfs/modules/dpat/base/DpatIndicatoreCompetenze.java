package org.aspcfs.modules.dpat.base;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.darkhorseventures.framework.beans.GenericBean;

public class DpatIndicatoreCompetenze extends GenericBean {

	private static final long serialVersionUID = -3712067931478757670L;
	private int id;
	private int id_attivita;
	private String description;
	private Boolean enabled;
	private String note="";
	

	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getId_attivita() {
		return id_attivita;
	}
	public void setId_attivita(int id_attivita) {
		this.id_attivita = id_attivita;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
	public Boolean getEnabled() {
		return enabled;
	}
	public void setEnabled(Boolean enabled) {
		this.enabled = enabled;
	}
	public DpatIndicatoreCompetenze(ResultSet rs) throws SQLException
	{
		this.buildRecord(rs);
		
	}
	public void buildRecord(ResultSet rs) throws SQLException
	{
		id = rs.getInt("id");
		description = rs.getString("description");
		id_attivita = rs.getInt("id_attivita");
		note =  rs.getString("note");
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	
	
}
