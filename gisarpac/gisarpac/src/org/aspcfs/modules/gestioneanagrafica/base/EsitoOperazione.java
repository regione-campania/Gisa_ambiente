package org.aspcfs.modules.gestioneanagrafica.base;

public class EsitoOperazione {

	private int esito =-1;
	private String messaggio = "";
	private int idStabilimento = -1;

	public int getEsito() {
		return esito;
	}
	public void setEsito(int esito) {
		this.esito = esito;
	}
	public String getMessaggio() {
		return messaggio;
	}
	public void setMessaggio(String messaggio) {
		this.messaggio = messaggio;
	}
	public int getIdStabilimento() {
		return idStabilimento;
	}
	public void setIdStabilimento(int idStabilimento) {
		this.idStabilimento = idStabilimento;
	}
	
	public EsitoOperazione (String ret){
		if (ret!=null){
			String[] retArray = ret.split(";;");
			try {
				this.esito = Integer.parseInt(retArray[0]);
				this.messaggio = retArray[1];
				this.idStabilimento = Integer.parseInt(retArray[2]);
			}
			catch (Exception e) {}
		}
		
		
		
	}
}
