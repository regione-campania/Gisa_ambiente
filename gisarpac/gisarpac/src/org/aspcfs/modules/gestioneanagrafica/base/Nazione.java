package org.aspcfs.modules.gestioneanagrafica.base;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import org.aspcfs.utils.Bean;

public class Nazione 
{
	private Integer code;
	private String description;
	private Boolean default_item;
	private Integer level;
	private Boolean enabled;
	private String short_desc;
	
	public Nazione() 
	{
	}
	
	public Nazione(Integer code) throws SQLException
	{
		this.code=code;
	}
	
	public Nazione(ResultSet rs) throws SQLException
	{
		Bean.populate(this, rs);
	}
	
	public Nazione(Map<String, String[]> properties) throws SQLException
	{
		Bean.populate(this, properties);
	}

	public Integer getCode() {
		return code;
	}

	public void setCode(Integer code) {
		this.code = code;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Boolean getDefault_item() {
		return default_item;
	}

	public void setDefault_item(Boolean default_item) {
		this.default_item = default_item;
	}

	public Integer getLevel() {
		return level;
	}

	public void setLevel(Integer level) {
		this.level = level;
	}

	public Boolean getEnabled() {
		return enabled;
	}

	public void setEnabled(Boolean enabled) {
		this.enabled = enabled;
	}

	public String getShort_desc() {
		return short_desc;
	}

	public void setShort_desc(String short_desc) {
		this.short_desc = short_desc;
	}
	
	
	

	
}
