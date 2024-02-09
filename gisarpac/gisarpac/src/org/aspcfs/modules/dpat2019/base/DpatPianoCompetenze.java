package org.aspcfs.modules.dpat2019.base;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.darkhorseventures.framework.beans.GenericBean;

public class DpatPianoCompetenze extends GenericBean {

	private static final long serialVersionUID = -6654452174052738127L;

	private int id;
	private int id_sezione;
	private String description;
	private Boolean enabled;
	private DpatAttribuzioneCompetenzeAttivitaList elencoAttivita = new DpatAttribuzioneCompetenzeAttivitaList();
	
	
	public DpatAttribuzioneCompetenzeAttivitaList getElencoAttivita() {
		return elencoAttivita;
	}
	public void setElencoAttivita(
			DpatAttribuzioneCompetenzeAttivitaList elencoAttivita) {
		this.elencoAttivita = elencoAttivita;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getId_sezione() {
		return id_sezione;
	}
	public void setId_sezione(int id_sezione) {
		this.id_sezione = id_sezione;
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
	
	
	public DpatPianoCompetenze(ResultSet rs) throws SQLException
	{
		this.buildRecord(rs);
	}
	public void buildRecord(ResultSet rs) throws SQLException
	{
		id = rs.getInt("id");
		//description = rs.getString("descrizione");
		description = rs.getString("description");
		id_sezione = rs.getInt("id_sezione");
	}
	
	
}
