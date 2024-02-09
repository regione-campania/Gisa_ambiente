package org.aspcfs.modules.gestioneanagraficaremota.base;

import java.sql.ResultSet;
import java.sql.SQLException;

import com.darkhorseventures.framework.beans.GenericBean;


public class AnagraficaRemota extends GenericBean
{
	/**
     * 
     */
    private static final long serialVersionUID = 1L;
    private int riferimento_id;
    private String riferimento_id_nome_tab;
    private String ragione_sociale;
    private String partita_iva;
    private String codice_fiscale;
    private String nominativo_rappresentante;
    private String asl;
    private String comune_leg;
    private String provincia_leg;
    private String indirizzo_leg;
    private String comune;
    private String provincia_stab;
    private String indirizzo;
    private float latitudine_stab;
    private float longitudine_stab;
	

	public AnagraficaRemota() 
	{
	}
	


	public AnagraficaRemota(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}
	private void buildRecord(ResultSet rs) throws SQLException {
		// TODO Auto-generated constructor stub
		this.riferimento_id=rs.getInt("riferimento_id");
		this.riferimento_id_nome_tab=rs.getString("riferimento_id_nome_tab");
		this.ragione_sociale=rs.getString("ragione_sociale");
		this.partita_iva=rs.getString("partita_iva");
		this.codice_fiscale=rs.getString("codice_fiscale");
		this.nominativo_rappresentante  = rs.getString("nominativo_rappresentante");
		this.asl=rs.getString("asl");
		this.comune_leg=rs.getString("comune_leg");
		this.provincia_leg=rs.getString("provincia_leg");
		this.indirizzo_leg=rs.getString("indirizzo_leg");
		this.comune=rs.getString("comune");
		this.provincia_stab=rs.getString("provincia_stab");
		this.indirizzo=rs.getString("indirizzo");
		this.latitudine_stab=rs.getFloat("latitudine_stab");
		this.longitudine_stab=rs.getFloat("longitudine_stab");

	}



	public int getRiferimento_id() {
		return riferimento_id;
	}



	public void setRiferimento_id(int riferimento_id) {
		this.riferimento_id = riferimento_id;
	}



	public String getRiferimento_id_nome_tab() {
		return riferimento_id_nome_tab;
	}



	public void setRiferimento_id_nome_tab(String riferimento_id_nome_tab) {
		this.riferimento_id_nome_tab = riferimento_id_nome_tab;
	}



	public String getRagione_sociale() {
		return ragione_sociale;
	}



	public void setRagione_sociale(String ragione_sociale) {
		this.ragione_sociale = ragione_sociale;
	}



	public String getPartita_iva() {
		return partita_iva;
	}



	public void setPartita_iva(String partita_iva) {
		this.partita_iva = partita_iva;
	}



	public String getCodice_fiscale() {
		return codice_fiscale;
	}



	public void setCodice_fiscale(String codice_fiscale) {
		this.codice_fiscale = codice_fiscale;
	}



	public String getAsl() {
		return asl;
	}



	public void setAsl(String asl) {
		this.asl = asl;
	}



	public String getComune_leg() {
		return comune_leg;
	}



	public void setComune_leg(String comune_leg) {
		this.comune_leg = comune_leg;
	}



	public String getProvincia_leg() {
		return provincia_leg;
	}



	public void setProvincia_leg(String provincia_leg) {
		this.provincia_leg = provincia_leg;
	}



	public String getIndirizzo_leg() {
		return indirizzo_leg;
	}



	public void setIndirizzo_leg(String indirizzo_leg) {
		this.indirizzo_leg = indirizzo_leg;
	}



	public String getComune() {
		return comune;
	}



	public void setComune(String comune) {
		this.comune = comune;
	}



	public String getProvincia_stab() {
		return provincia_stab;
	}



	public void setProvincia_stab(String provincia_stab) {
		this.provincia_stab = provincia_stab;
	}



	public String getIndirizzo() {
		return indirizzo;
	}



	public void setIndirizzo(String indirizzo) {
		this.indirizzo = indirizzo;
	}



	public float getLatitudine_stab() {
		return latitudine_stab;
	}



	public void setLatitudine_stab(float latitudine_stab) {
		this.latitudine_stab = latitudine_stab;
	}



	public float getLongitudine_stab() {
		return longitudine_stab;
	}



	public void setLongitudine_stab(float longitudine_stab) {
		this.longitudine_stab = longitudine_stab;
	}



	public String getNominativo_rappresentante() {
		return nominativo_rappresentante;
	}



	public void setNominativo_rappresentante(String nominativo_rappresentante) {
		this.nominativo_rappresentante = nominativo_rappresentante;
	}



	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	
}
