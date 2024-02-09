package org.aspcfs.modules.gestioneanagrafica.base;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import org.aspcfs.utils.Bean;


public class Provincia 
{
	private Integer code;
	private String description;
	private Boolean default_item;
	private Integer level;
	private Boolean enabled;
	private Integer id_regione;
	private String cod_provincia;
	private String codistat;
	private Nazione nazione = new Nazione();
	
	public Provincia() 
	{
	}
	
	public Provincia(Integer code) throws SQLException
	{
		this.code=code;
	}
	
	public Provincia(ResultSet rs) throws SQLException
	{
		Bean.populate(this, rs);
	}
	
	public Provincia(Map<String, String[]> properties) throws SQLException
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

	public Integer getId_regione() {
		return id_regione;
	}

	public void setId_regione(Integer id_regione) {
		this.id_regione = id_regione;
	}

	public String getCod_provincia() {
		return cod_provincia;
	}

	public void setCod_provincia(String cod_provincia) {
		this.cod_provincia = cod_provincia;
	}

	public String getCodistat() {
		return codistat;
	}

	public void setCodistat(String codistat) {
		this.codistat = codistat;
	}

    public Nazione getNazione() {
        return nazione;
    }

    public void setNazione(Nazione nazione) {
        this.nazione = nazione;
    }

}
