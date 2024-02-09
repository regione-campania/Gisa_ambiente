package org.aspcfs.modules.terreni.base;

import java.io.Serializable;

public class Terreno implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int id;
	private String id_sito;
	private String classe_rischio;
	private String comune;
	private String foglio;
	private String particella;
	private String parte;
	private String area;
	private String stato_sito;
	private String decreto_approvazione;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getId_sito() {
		return id_sito;
	}
	public void setId_sito(String id_sito) {
		this.id_sito = id_sito;
	}
	public String getClasse_rischio() {
		return classe_rischio;
	}
	public void setClasse_rischio(String classe_rischio) {
		this.classe_rischio = classe_rischio;
	}
	public String getComune() {
		return comune;
	}
	public void setComune(String comune) {
		this.comune = comune;
	}
	public String getFoglio() {
		return foglio;
	}
	public void setFoglio(String foglio) {
		this.foglio = foglio;
	}
	public String getParticella() {
		return particella;
	}
	public void setParticella(String particella) {
		this.particella = particella;
	}
	public String getParte() {
		return parte;
	}
	public void setParte(String parte) {
		this.parte = parte;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getStato_sito() {
		return stato_sito;
	}
	public void setStato_sito(String stato_sito) {
		this.stato_sito = stato_sito;
	}
	public String getDecreto_approvazione() {
		return decreto_approvazione;
	}
	public void setDecreto_approvazione(String decreto_approvazione) {
		this.decreto_approvazione = decreto_approvazione;
	}
	

	
	
}
