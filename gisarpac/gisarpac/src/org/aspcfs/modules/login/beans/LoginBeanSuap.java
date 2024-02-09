package org.aspcfs.modules.login.beans;


public class LoginBeanSuap extends LoginBean {
	
	private String urlProvenienza ;
	private String denominazione ;
	private String indirizzo ;
	private String codiceSuap ;
	private String codiceFiscaleRichiedente ;
	private String message ;
	private String partitaIva ;
	private String urlDispatcher ; 
	private String username ;
	private String password ;
	
	
	
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getUrlDispatcher() {
		return urlDispatcher;
	}
	public void setUrlDispatcher(String urlDispatcher) {
		this.urlDispatcher = urlDispatcher;
	}
	public String getPartitaIva() {
		return partitaIva;
	}
	public void setPartitaIva(String partitaIva) {
		this.partitaIva = partitaIva;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getUrlProvenienza() {
		return urlProvenienza;
	}
	public void setUrlProvenienza(String urlProvenienza) {
		this.urlProvenienza = urlProvenienza;
	}
	public String getDenominazione() {
		return denominazione;
	}
	public void setDenominazione(String denominazione) {
		this.denominazione = denominazione;
	}
	public String getIndirizzo() {
		return indirizzo;
	}
	public void setIndirizzo(String indirizzo) {
		this.indirizzo = indirizzo;
	}
	public String getCodiceSuap() {
		return codiceSuap;
	}
	public void setCodiceSuap(String codiceSuap) {
		this.codiceSuap = codiceSuap;
	}
	public String getCodiceFiscaleRichiedente() {
		return codiceFiscaleRichiedente;
	}
	public void setCodiceFiscaleRichiedente(String codiceFiscaleRichiedente) {
		this.codiceFiscaleRichiedente = codiceFiscaleRichiedente;
	}
	
	

}
