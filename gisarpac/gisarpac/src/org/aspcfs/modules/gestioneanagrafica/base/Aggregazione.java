package org.aspcfs.modules.gestioneanagrafica.base;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import org.aspcfs.utils.Bean;


public class Aggregazione 
{
	private String aggregazione;
	private Integer id;
	private Integer id_flusso_originale;
	private Macroarea macroarea = new Macroarea();
	private String codice_attivita;
	
	public Aggregazione()
	{
		
	}
	
	public Aggregazione(Map<String, String[]> properties) throws SQLException
	{
		Bean.populate(this, properties);
	}
	
	public Aggregazione(ResultSet rs) throws SQLException
	{
		Bean.populate(this, rs);
	}
	
	public String getAggregazione() {
		return aggregazione;
	}
	public void setAggregazione(String aggregazione) {
		this.aggregazione = aggregazione;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getId_flusso_originale() {
		return id_flusso_originale;
	}
	public void setId_flusso_originale(Integer id_flusso_originale) {
		this.id_flusso_originale = id_flusso_originale;
	}
	
	public Macroarea getMacroarea()
	{
		return this.macroarea;
	}
	public void setMacroarea(Macroarea macroarea)
	{
		this.macroarea = macroarea;
	}
	
	public String getCodice_attivita() {
		return codice_attivita;
	}

	public void setCodice_attivita(String codice_attivita) {
		this.codice_attivita = codice_attivita;
	}
}
