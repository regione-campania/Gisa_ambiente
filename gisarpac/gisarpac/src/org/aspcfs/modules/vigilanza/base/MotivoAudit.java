package org.aspcfs.modules.vigilanza.base;

import com.darkhorseventures.framework.beans.GenericBean;

public class MotivoAudit extends GenericBean {

	
	private int  idAuditTipo ;
	private String descrizioneAuditTipo;
	
	private int idTipoAudit ;
	private String descrizioneTipoAudit ; 
	
	private String tipo_bpi_haccp ; 
	
	private int idBpi_o_haccp ;
	private String descrizioneBpi_o_haccp ;
	
	
	public MotivoAudit() {
		// TODO Auto-generated constructor stub
	}


	
	public String getTipo_bpi_haccp() {
		return tipo_bpi_haccp;
	}



	public void setTipo_bpi_haccp(String tipo_bpi_haccp) {
		this.tipo_bpi_haccp = tipo_bpi_haccp;
	}



	public int getIdAuditTipo() {
		return idAuditTipo;
	}


	public void setIdAuditTipo(int idAuditTipo) {
		this.idAuditTipo = idAuditTipo;
	}


	public String getDescrizioneAuditTipo() {
		return descrizioneAuditTipo;
	}


	public void setDescrizioneAuditTipo(String descrizioneAuditTipo) {
		this.descrizioneAuditTipo = descrizioneAuditTipo;
	}


	public int getIdTipoAudit() {
		return idTipoAudit;
	}


	public void setIdTipoAudit(int idTipoAudit) {
		this.idTipoAudit = idTipoAudit;
	}


	public String getDescrizioneTipoAudit() {
		return descrizioneTipoAudit;
	}


	public void setDescrizioneTipoAudit(String descrizioneTipoAudit) {
		this.descrizioneTipoAudit = descrizioneTipoAudit;
	}


	public int getIdBpi_o_haccp() {
		return idBpi_o_haccp;
	}


	public void setIdBpi_o_haccp(int idBpi_o_haccp) {
		this.idBpi_o_haccp = idBpi_o_haccp;
	}


	public String getDescrizioneBpi_o_haccp() {
		return descrizioneBpi_o_haccp;
	}


	public void setDescrizioneBpi_o_haccp(String descrizioneBpi_o_haccp) {
		this.descrizioneBpi_o_haccp = descrizioneBpi_o_haccp;
	}
	
	
	

}
