package org.aspcfs.modules.suap.utils;

import com.darkhorseventures.framework.beans.GenericBean;

public class TipoImpresaSuap extends GenericBean{

	
	private String tipoImpresa;
	private String tipoSocieta ;
	private String labelRagioneSociale ;
	private boolean requiredRagioneSociale;
	private boolean requiredSedeLegale;
	private boolean requiredPartitaIva;
	private boolean requiredCodiceFiscale;
	
	
	private int codeTipoSocieta;
	private int idTipoImpresa;

	
	
	public TipoImpresaSuap(){}
	
	 
	
	
	public int getIdTipoImpresa() {
		return idTipoImpresa;
	}




	public void setIdTipoImpresa(int idTipoImpresa) {
		this.idTipoImpresa = idTipoImpresa;
	}




	public boolean isRequiredPartitaIva() {
		return requiredPartitaIva;
	}




	public void setRequiredPartitaIva(boolean requiredPartitaIva) {
		this.requiredPartitaIva = requiredPartitaIva;
	}




	public boolean isRequiredCodiceFiscale() {
		return requiredCodiceFiscale;
	}




	public void setRequiredCodiceFiscale(boolean requiredCodiceFiscale) {
		this.requiredCodiceFiscale = requiredCodiceFiscale;
	}




	public int getCodeTipoSocieta() {
		return codeTipoSocieta;
	}


	public void setCodeTipoSocieta(int codeTipoSocieta) {
		this.codeTipoSocieta = codeTipoSocieta;
	}


	public String getTipoImpresa() {
		return tipoImpresa;
	}
	public void setTipoImpresa(String tipoImpresa) {
		this.tipoImpresa = tipoImpresa;
	}
	public String getTipoSocieta() {
		return tipoSocieta;
	}
	public void setTipoSocieta(String tipoSocieta) {
		this.tipoSocieta = tipoSocieta;
	}
	public String getLabelRagioneSociale() {
		return labelRagioneSociale;
	}
	public void setLabelRagioneSociale(String labelRagioneSociale) {
		this.labelRagioneSociale = labelRagioneSociale;
	}
	public boolean isRequiredRagioneSociale() {
		return requiredRagioneSociale;
	}
	public void setRequiredRagioneSociale(boolean requiredRagioneSociale) {
		this.requiredRagioneSociale = requiredRagioneSociale;
	}
	public boolean isRequiredSedeLegale() {
		return requiredSedeLegale;
	}
	public void setRequiredSedeLegale(boolean requiredSedeLegale) {
		this.requiredSedeLegale = requiredSedeLegale;
	}
	
	
	
}
