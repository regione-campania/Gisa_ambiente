package org.aspcfs.modules.vigilanza.base;

public class NucleoIspettivo {
	private int nucleo;
	private String componente;
	private int userId ;
	
	
	
	
	public NucleoIspettivo(int nucleo , String componente,int userId)
	{
		this.nucleo = nucleo;
		this.componente = componente;
		this.userId = userId;
	}
	
	
	
	public int getUserId() {
		return userId;
	}



	public void setUserId(int userId) {
		this.userId = userId;
	}



	public int getNucleo() {
		return nucleo;
	}
	public void setNucleo(int nucleo) {
		this.nucleo = nucleo;
	}
	public String getComponente() {
		return componente;
	}
	public void setComponente(String componente) {
		this.componente = componente;
	}
	

}
