package org.aspcfs.modules.mycfs.base;

public class Allegato {

	private String descrizione;
	private int idAllegato;
	private int folderid;
	private String versione;
	private String estensione;
	private String codAllegato;
	
	public String getCodAllegato() {
		return codAllegato;
	}
	public void setCodAllegato(String codAllegato) {
		this.codAllegato = codAllegato;
	}
	
	public int getFolderid() {
		return folderid;
	}
	public void setFolderid(int folderid) {
		this.folderid = folderid;
	}
	public String getVersione() {
		return versione;
	}
	public void setVersione(String versione) {
		this.versione = versione;
	}
	public String getEstensione() {
		return estensione;
	}
	public void setEstensione(String estensione) {
		this.estensione = estensione;
	}
	public String getDescrizione() {
		return descrizione;
	}
	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}
	public int getIdAllegato() {
		return idAllegato;
	}
	public void setIdAllegato(int idAllegato) {
		this.idAllegato = idAllegato;
	}
	
}
