package org.aspcfs.modules.suap.utils;

import java.util.ArrayList;

public class AttivitaProduttive {
	
	private int idAttivita;
	private int nextLivello ;
	private String nomeColonnaId ;
	private String nomeColonnaDescrizione ;
	private String nomeTabella ;
	private String nomeColonnaDipendente ;
	
	private String label ;
	
	private boolean ultimoLivello ;
	private boolean attivitaPrincipale;
	private String nameCombo ;
	private String bgcolor ;
	private String bgcolorPrec ;
	private boolean previstoCodiceNazionale;

	
	
	
	public boolean isPrevistoCodiceNazionale() {
		return previstoCodiceNazionale;
	}

	public void setPrevistoCodiceNazionale(boolean previstoCodiceNazionale) {
		this.previstoCodiceNazionale = previstoCodiceNazionale;
	}

	public String getBgcolorPrec() {
		return bgcolorPrec;
	}

	public void setBgcolorPrec(String bgcolorPrec) {
		this.bgcolorPrec = bgcolorPrec;
	}

	public String getBgcolor() {
		return bgcolor;
	}

	public void setBgcolor(String bgcolor) {
		this.bgcolor = bgcolor;
	}

	public boolean isUltimoLivello() {
		return ultimoLivello;
	}

	public void setUltimoLivello(boolean ultimoLivello) {
		this.ultimoLivello = ultimoLivello;
	}

	public boolean isAttivitaPrincipale() {
		return attivitaPrincipale;
	}

	public void setAttivitaPrincipale(boolean attivitaPrincipale) {
		this.attivitaPrincipale = attivitaPrincipale;
	}

	private ArrayList<Item> listaItem= new  ArrayList<Item>();
	
	public AttivitaProduttive(){}
	
	public int getNextLivello() {
		return nextLivello;
	}

	

	public String getNomeTabella() {
		return nomeTabella;
	}

	public void setNomeTabella(String nomeTabella) {
		this.nomeTabella = nomeTabella;
	}

	public String getNomeColonnaDipendente() {
		return nomeColonnaDipendente;
	}

	public void setNomeColonnaDipendente(String nomeColonnaDipendente) {
		this.nomeColonnaDipendente = nomeColonnaDipendente;
	}

	public void setNextLivello(int nextLivello) {
		this.nextLivello = nextLivello;
	}



	public String getNomeColonnaId() {
		return nomeColonnaId;
	}



	public void setNomeColonnaId(String nomeColonnaId) {
		this.nomeColonnaId = nomeColonnaId;
	}



	public String getNomeColonnaDescrizione() {
		return nomeColonnaDescrizione;
	}



	public void setNomeColonnaDescrizione(String nomeColonnaDescrizione) {
		this.nomeColonnaDescrizione = nomeColonnaDescrizione;
	}



	public String getLabel() {
		return label;
	}



	public void setLabel(String label) {
		this.label = label;
	}


	
	


	public ArrayList<Item> getListaItem() {
		return listaItem;
	}

	public void setListaItem(ArrayList<Item> listaItem) {
		this.listaItem = listaItem;
		
	}

	public int getIdAttivita() {
		return idAttivita;
	}

	public void setIdAttivita(int idAttivita) {
		this.idAttivita = idAttivita;
	}








}
 
	
	

