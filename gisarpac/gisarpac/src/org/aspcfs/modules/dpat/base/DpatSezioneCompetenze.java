package org.aspcfs.modules.dpat.base;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.darkhorseventures.framework.beans.GenericBean;

public class DpatSezioneCompetenze extends GenericBean implements Cloneable {

	private static final long serialVersionUID = -9092380054888506648L;
	
	private int id;
	private String description;
	private Boolean enabled;
	private DpatAttribuzioneCompetenzePianiList elencoPiani = new DpatAttribuzioneCompetenzePianiList();
	
	//Parametri di configurazione/visualizzazione
	private String bgColor;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
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
	public DpatAttribuzioneCompetenzePianiList getElencoPiani() {
		return elencoPiani;
	}
	public void setElencoPiani(DpatAttribuzioneCompetenzePianiList elencoPiani) {
		this.elencoPiani = elencoPiani;
	}
	
	
	public String getBgColor() {
		return bgColor;
	}
	public void setBgColor(String bgColor) {
		this.bgColor = bgColor;
	}
	
	public DpatSezioneCompetenze(ResultSet rs) throws SQLException
	{
		this.buildRecord(rs);
		
	}
	public void buildRecord(ResultSet rs) throws SQLException
	{
		id = rs.getInt("id");
		description = rs.getString("description");
		bgColor = rs.getString("color");
	}
	
	
	public Object clone(){
		try{
			return super.clone();
		}catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	
}
