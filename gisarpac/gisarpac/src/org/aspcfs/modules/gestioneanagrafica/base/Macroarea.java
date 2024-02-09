package org.aspcfs.modules.gestioneanagrafica.base;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import org.aspcfs.utils.Bean;

public class Macroarea 
{
	private Integer id;
	private String codice_sezione;
	private String macroarea;
	
	public Macroarea(){}
	
	public Macroarea(Map<String, String[]> properties) throws SQLException
	{
		Bean.populate(this, properties);
	}
	
	
	public Macroarea(ResultSet rs) throws SQLException
	{
		Bean.populate(this, rs);
	}
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getCodice_sezione() {
		return codice_sezione;
	}
	public void setCodice_sezione(String codice_sezione) {
		this.codice_sezione = codice_sezione;
	}
	public String getMacroarea() {
		return macroarea;
	}
	public void setMacroarea(String macroarea) {
		this.macroarea = macroarea;
	}

}
