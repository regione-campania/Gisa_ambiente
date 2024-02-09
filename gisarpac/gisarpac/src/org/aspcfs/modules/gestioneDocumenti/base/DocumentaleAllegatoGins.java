package org.aspcfs.modules.gestioneDocumenti.base;

import com.darkhorseventures.framework.beans.GenericBean;

public class DocumentaleAllegatoGins  extends GenericBean {
	
	private static final long serialVersionUID = 4320567602597719160L;
	
	private String numeroPratica = null;
	private String codiceAllegato = null;
	private String oggetto = null; 
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
	private int idComunePratica = -1;

	
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

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}
	
	public String getOggetto() {
		return oggetto;
	}

	public void setOggetto(String oggetto) {
		this.oggetto = oggetto;
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
	
	public int getIdComunePratica() {
		return idComunePratica;
	}
	public void setIdComunePratica(int idComunePratica) {
		this.idComunePratica = idComunePratica;
	}
	public void setIdComunePratica(String idComunePratica) {
		if (idComunePratica!=null && !idComunePratica.equals("null") && !idComunePratica.equals(""))
			this.idComunePratica = Integer.parseInt(idComunePratica);
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
public DocumentaleAllegatoGins() {
		
		}
	
	public DocumentaleAllegatoGins(String riga) {
		
		String[] split;
		split = riga.split(";;");
		
		this.setDataCreazione(split[0]);
		this.setNomeDocumento(split[1]);
		this.setUserId(split[2]);
		this.setIdHeader(split[3]);
		this.setIdDocumento(split[4]);
		this.setOggetto(split[5]);
		this.setCodiceAllegato(split[6]);
		this.setEstensione(split[7]);
		this.setNomeClient(split[8]);
		this.setNumeroPratica(split[9]);
		this.setIdComunePratica(split[10]);

	
		  
		
		}
	public String getTipoAllegato() {
		return tipoAllegato;
	}
	public void setTipoAllegato(String tipoAllegato) {
		this.tipoAllegato = tipoAllegato;
	}
	public String getNumeroPratica() {
		return numeroPratica;
	}
	public void setNumeroPratica(String numeroPratica) {
		this.numeroPratica = numeroPratica;
	}
	public String getCodiceAllegato() {
		return codiceAllegato;
	}
	public void setCodiceAllegato(String codiceAllegato) {
		this.codiceAllegato = codiceAllegato;
	}


}
