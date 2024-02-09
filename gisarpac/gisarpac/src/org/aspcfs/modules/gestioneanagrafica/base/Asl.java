package org.aspcfs.modules.gestioneanagrafica.base;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.aspcfs.utils.Bean;

public class Asl 
{
	
	  private Integer code;
	  private String description;
	  private String short_description;
	  private Boolean default_item;
	  private Integer level;
	  private Boolean enabled;
	  private String codiceistat;
	  private Integer code_canina;
	  private Integer id_provincia;
	  
	  public Asl()
	  {
	  }
	  
	  public Asl(ResultSet rs) throws SQLException
	  {
		Bean.populate(this, rs);
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
	public String getShort_description() {
		return short_description;
	}
	public void setShort_description(String short_description) {
		this.short_description = short_description;
	}
	public Boolean isDefault_item() {
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
	public Boolean isEnabled() {
		return enabled;
	}
	public void setEnabled(Boolean enabled) {
		this.enabled = enabled;
	}
	public String getCodiceistat() {
		return codiceistat;
	}
	public void setCodiceistat(String codiceistat) {
		this.codiceistat = codiceistat;
	}
	public Integer getCode_canina() {
		return code_canina;
	}
	public void setCode_canina(Integer code_canina) {
		this.code_canina = code_canina;
	}
	public Integer getId_provincia() {
		return id_provincia;
	}
	public void setId_provincia(Integer id_provincia) {
		this.id_provincia = id_provincia;
	}
	  
	  

}
