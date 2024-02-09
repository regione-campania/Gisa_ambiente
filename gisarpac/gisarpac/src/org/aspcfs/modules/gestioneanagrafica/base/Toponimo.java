package org.aspcfs.modules.gestioneanagrafica.base;

public class Toponimo 
{
	private Integer code;
	private String description;
	private Boolean default_item;
	private Integer level;
	private Boolean enabled;

	public Toponimo()
	{
		
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
}
