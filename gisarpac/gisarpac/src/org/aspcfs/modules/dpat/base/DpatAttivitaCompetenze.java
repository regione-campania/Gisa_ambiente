package org.aspcfs.modules.dpat.base;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.darkhorseventures.framework.beans.GenericBean;

public class DpatAttivitaCompetenze extends GenericBean {

	private static final long serialVersionUID = 8172469522264990994L;
	
	private int id;
	private int id_piano;
	private String description;
	private Boolean enabled;
	private DpatAttribuzioneCompetenzeIndicatoriList elencoIndicatori = new DpatAttribuzioneCompetenzeIndicatoriList();
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getId_piano() {
		return id_piano;
	}
	public void setId_piano(int id_piano) {
		this.id_piano = id_piano;
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
	public DpatAttribuzioneCompetenzeIndicatoriList getElencoIndicatori() {
		return elencoIndicatori;
	}
	public void setElencoIndicatori(DpatAttribuzioneCompetenzeIndicatoriList elencoIndicatori) {
		this.elencoIndicatori = elencoIndicatori;
	}
	
	public DpatAttivitaCompetenze(ResultSet rs) throws SQLException
	{
		this.buildRecord(rs);
		
	}
	public void buildRecord(ResultSet rs) throws SQLException
	{
		id = rs.getInt("id");
		description = rs.getString("description");
		id_piano = rs.getInt("id_piano");
	}
	
	
	
	


	

}
