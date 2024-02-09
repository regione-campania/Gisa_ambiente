package org.aspcfs.modules.vigilanza.base;

import com.darkhorseventures.framework.beans.GenericBean;

public class MotivoIspezione extends GenericBean {
	
	private int idTecnicaControllo ; 				// [ES. ispezione semplice]
	private String descrizioneTecnicaControllo ;
	
	private int idMotivoIspezione ;
	private String descrizioneMotivoIspezione ; 
	private String codiceInternoMotivoIspezione ;
	
	private int idPiano ;
	private String descrizionePiano ;
	private String codiceInternoPiano ;
	

	public MotivoIspezione() {
		// TODO Auto-generated constructor stub
	}

	
	
	public String getCodiceInternoMotivoIspezione() {
		return codiceInternoMotivoIspezione;
	}



	public void setCodiceInternoMotivoIspezione(String codiceInternoMotivoIspezione) {
		this.codiceInternoMotivoIspezione = codiceInternoMotivoIspezione;
	}



	public String getCodiceInternoPiano() {
		return codiceInternoPiano;
	}



	public void setCodiceInternoPiano(String codiceInternoPiano) {
		this.codiceInternoPiano = codiceInternoPiano;
	}



	public int getIdTecnicaControllo() {
		return idTecnicaControllo;
	}


	public void setIdTecnicaControllo(int idTecnicaControllo) {
		this.idTecnicaControllo = idTecnicaControllo;
	}


	public String getDescrizioneTecnicaControllo() {
		return descrizioneTecnicaControllo;
	}


	public void setDescrizioneTecnicaControllo(String descrizioneTecnicaControllo) {
		this.descrizioneTecnicaControllo = descrizioneTecnicaControllo;
	}


	public int getIdMotivoIspezione() {
		return idMotivoIspezione;
	}


	public void setIdMotivoIspezione(int idMotivoIspezione) {
		this.idMotivoIspezione = idMotivoIspezione;
	}


	public String getDescrizioneMotivoIspezione() {
		return descrizioneMotivoIspezione;
	}


	public void setDescrizioneMotivoIspezione(String descrizioneMotivoIspezione) {
		this.descrizioneMotivoIspezione = descrizioneMotivoIspezione;
	}


	public int getIdPiano() {
		return idPiano;
	}


	public void setIdPiano(int idPiano) {
		this.idPiano = idPiano;
	}


	public String getDescrizionePiano() {
		return descrizionePiano;
	}


	public void setDescrizionePiano(String descrizionePiano) {
		this.descrizionePiano = descrizionePiano;
	}
	
	

}
