package org.aspcfs.modules.admin.base;

import com.darkhorseventures.framework.beans.GenericBean;

public class Suap  extends GenericBean {
	
	private String codiceFiscaleRichiedente ;
	private String codiceFiscaleDelegato ;
	
	private String mailSuap ;
	private String istaComune ; 
	private String ipAddressSuap ;
	private String pec ; 
	private String descrizioneComune ; 
	private int idComuneSuap ;
	private String descrizioneProvincia ; 
	private int idProvinciaSuap ;
	private String callbackSuap;
	private String callbackSuapKo;
	private String pecDemo ;
	private String contesto ;
	private String encryptedToken ;
	
	
	
	public String getCallbackSuapKo() {
		return callbackSuapKo;
	}
	public void setCallbackSuapKo(String callbackSuapKo) {
		this.callbackSuapKo = callbackSuapKo;
	}
	public String getEncryptedToken() {
		return encryptedToken;
	}
	public void setEncryptedToken(String encryptedToken) {
		this.encryptedToken = encryptedToken;
	}
	public String getContesto() {
		return contesto;
	}
	public void setContesto(String contesto) {
		this.contesto = contesto;
	}
	public String getCallbackSuap() {
		return callbackSuap;
	}
	public void setCallbackSuap(String callbackSuap) {
		this.callbackSuap = callbackSuap;
	}
	public String getPecDemo() {
		return pecDemo;
	}
	public void setPecDemo(String pecDemo) {
		this.pecDemo = pecDemo;
	}
	public String getDescrizioneProvincia() {
		return descrizioneProvincia;
	}
	public void setDescrizioneProvincia(String descrizioneProvincia) {
		this.descrizioneProvincia = descrizioneProvincia;
	}
	public int getIdProvinciaSuap() {
		return idProvinciaSuap;
	}
	public void setIdProvinciaSuap(int idProvinciaSuap) {
		this.idProvinciaSuap = idProvinciaSuap;
	}
	public int getIdComuneSuap() {
		return idComuneSuap;
	}
	public void setIdComuneSuap(int idComuneSuap) {
		this.idComuneSuap = idComuneSuap;
	}
	public String getPec() {
		return pec;
	}
	public void setPec(String pec) {
		this.pec = pec;
	}
	public String getDescrizioneComune() {
		return descrizioneComune;
	}
	public void setDescrizioneComune(String descrizioneComune) {
		this.descrizioneComune = descrizioneComune;
	}
	public String getMailSuap() {
		return mailSuap;
	}
	public void setMailSuap(String mailSuap) {
		this.mailSuap = mailSuap;
	}
	
	
	public String getCodiceFiscaleRichiedente() {
		return codiceFiscaleRichiedente;
	}
	public void setCodiceFiscaleRichiedente(String codiceFiscaleRichiedente) {
		this.codiceFiscaleRichiedente = codiceFiscaleRichiedente;
	}
	
	public String getCodiceFiscaleDelegato() {
		return codiceFiscaleDelegato;
	}
	public void setCodiceFiscaleDelegato(String codiceFiscaleDelegato) {
		this.codiceFiscaleDelegato = codiceFiscaleDelegato;
	}
	public String getIstaComune() {
		return istaComune;
	}
	public void setIstaComune(String istaComune) {
		this.istaComune = istaComune;
	}
	
	
	public String getIpAddressSuap() {
		return ipAddressSuap;
	}
	public void setIpAddressSuap(String ipAddressSuap) {
		this.ipAddressSuap = ipAddressSuap;
	}

	
	
	

}
