package org.aspcfs.modules.gestioneDocumenti.base;

import com.darkhorseventures.framework.beans.GenericBean;

public class DocumentaleAllegatoModulo  extends GenericBean {
	
	private static final long serialVersionUID = 4320567602597719160L;
	
	private int altId = -1; 
	
	private String filename = null; 
	private String fileDimension = null; 

	private String tipoAllegato = null;
	private int userId = -1;
	private String userIp = null;
	private String idHeader = null;
	private int idDocumento = -1;
	private String dataCreazione = null;
	private String nomeDocumento = null;
	private String nomeClient = null;

	private String estensione = null;
	private int revisione = -1;

	public String getNomeClient() {
		return nomeClient;
	}
	public void setNomeClient(String nomeClient) {
		this.nomeClient = nomeClient;
	}
	
	public String getEstensione() {
		return estensione;
	}
	public void setEstensione(String estensione) {
		this.estensione = estensione;
	}
	public int getAltId() {
		return altId;
	}
	public void setAltId(int altId) {
		this.altId = altId;
	}
	public void setAltId(String altId) {
		if (altId!=null && !altId.equals("null") && !altId.equals(""))
			this.altId = Integer.parseInt(altId);
	}
	
	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}
	
	public String getFileDimension() {
		return fileDimension;
	}

	public void setFileDimension(String fileDimension) {
		this.fileDimension = fileDimension;
	}
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
		
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public void setUserId(String userId) {
		if (userId!=null && !userId.equals("null") && !userId.equals(""))
			this.userId = Integer.parseInt(userId);
	}
	public String getUserIp() {
		return userIp;
	}
	public void setUserIp(String userIp) {
		this.userIp = userIp;
	}
	public String getIdHeader() {
		return idHeader;
	}
	public void setIdHeader(String idHeader) {
		this.idHeader = idHeader;
	}
	public int getIdDocumento() {
		return idDocumento;
	}
	public void setIdDocumento(int idDocumento) {
		this.idDocumento = idDocumento;
	}
	public void setIdDocumento(String idDocumento) {
		if (idDocumento!=null && !idDocumento.equals("null") && !idDocumento.equals(""))
			this.idDocumento = Integer.parseInt(idDocumento);
	}
	
	public String getDataCreazione() {
		return dataCreazione;
	}
	public void setDataCreazione(String dataCreazione) {
		this.dataCreazione = dataCreazione;
	}
	public String getNomeDocumento() {
		return nomeDocumento;
	}
	public void setNomeDocumento(String nomeDocumento) {
		this.nomeDocumento = nomeDocumento;
	}
public DocumentaleAllegatoModulo() {
		
		}
	
	public DocumentaleAllegatoModulo(String riga) {
		
		String[] split;
		split = riga.split(";;");
		
		this.setDataCreazione(split[0]);
		this.setNomeDocumento(split[1]);
		this.setUserId(split[2]);
		this.setIdHeader(split[3]);
		this.setIdDocumento(split[4]);
		this.setEstensione(split[5]);
		this.setNomeClient(split[6]);
		this.setRevisione(split[7]);
		}

	public String getTipoAllegato() {
		return tipoAllegato;
	}
	public void setTipoAllegato(String tipoAllegato) {
		this.tipoAllegato = tipoAllegato;
	}
	public int getRevisione() {
		return revisione;
	}
	public void setRevisione(int revisione) {
		this.revisione = revisione;
	}
	
	public void setRevisione(String revisione) {
		if (revisione!=null && !revisione.equals("null") && !revisione.equals(""))
			this.revisione = Integer.parseInt(revisione);
	}
	
}
