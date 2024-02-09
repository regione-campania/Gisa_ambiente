package org.aspcfs.modules.gestioneanagrafica.base;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import org.aspcfs.utils.Bean;

public class Comune 
{
	private Integer id;
	private Integer code;
	private String cod_comune;
	private String cod_regione;
	private String cod_provincia;
	private String nome;
	private String istat;
	private String codice;
	private String codice_old;
	private String codiceistatasl_old;
	private String cap;
	private String cap_;
	private Boolean notused;
	private Integer cod_nazione;
	private String codiceistatasl_bdn;
	private String codice_nuovo;
	private String codice_nuovo_;
	private String istat_comune_provincia;
	private String istat_pre;
	
	private Provincia provincia = new Provincia();
    private Asl asl = new Asl();

    public Comune()
	{
	}
	
	public Comune(Integer id) throws SQLException
	{
		this.id=id;
	}
	
	public Comune(ResultSet rs) throws SQLException
	{
		Bean.populate(this, rs);
	}
	
	public Comune(Map<String, String[]> properties) throws SQLException
	{
		Bean.populate(this, properties);
	}
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getCod_comune() {
		return cod_comune;
	}
	public void setCod_comune(String cod_comune) {
		this.cod_comune = cod_comune;
	}
	public String getCod_regione() {
		return cod_regione;
	}
	public void setCod_regione(String cod_regione) {
		this.cod_regione = cod_regione;
	}
	public String getCod_provincia() {
		return cod_provincia;
	}
	public void setCod_provincia(String cod_provincia) {
		this.cod_provincia = cod_provincia;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getIstat() {
		return istat;
	}
	public void setIstat(String istat) {
		this.istat = istat;
	}
	
	public String getCodice() {
		return codice;
	}
	public void setCodice(String codice) {
		this.codice = codice;
	}
	public String getCodice_old() {
		return codice_old;
	}
	public void setCodice_old(String codice_old) {
		this.codice_old = codice_old;
	}
	public String getCodiceistatasl_old() {
		return codiceistatasl_old;
	}
	public void setCodiceistatasl_old(String codiceistatasl_old) {
		this.codiceistatasl_old = codiceistatasl_old;
	}
	public String getCap() {
		return cap;
	}
	public void setCap(String cap) {
		this.cap = cap;
	}
	public String getCap_() {
		return cap_;
	}
	public void setCap_(String cap_) {
		this.cap_ = cap_;
	}
	public Boolean getNotused() {
		return notused;
	}
	public void setNotused(Boolean notused) {
		this.notused = notused;
	}
	public Integer getCod_nazione() {
		return cod_nazione;
	}
	public void setCod_nazione(Integer cod_nazione) {
		this.cod_nazione = cod_nazione;
	}
	public String getCodiceistatasl_bdn() {
		return codiceistatasl_bdn;
	}
	public void setCodiceistatasl_bdn(String codiceistatasl_bdn) {
		this.codiceistatasl_bdn = codiceistatasl_bdn;
	}
	public String getCodice_nuovo() {
		return codice_nuovo;
	}
	public void setCodice_nuovo(String codice_nuovo) {
		this.codice_nuovo = codice_nuovo;
	}
	public String getCodice_nuovo_() {
		return codice_nuovo_;
	}
	public void setCodice_nuovo_(String codice_nuovo_) {
		this.codice_nuovo_ = codice_nuovo_;
	}
	public String getIstat_comune_provincia() {
		return istat_comune_provincia;
	}
	public void setIstat_comune_provincia(String istat_comune_provincia) {
		this.istat_comune_provincia = istat_comune_provincia;
	}
	public String getIstat_pre() {
		return istat_pre;
	}

	public void setIstat_pre(String istat_pre) {
		this.istat_pre = istat_pre;
	}

    public Provincia getProvincia() {
        return provincia;
    }

    public void setProvincia(Provincia provincia) {
        this.provincia = provincia;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public Asl getAsl() {
        return asl;
    }

    public void setAsl(Asl asl) {
        this.asl = asl;
    }

}
