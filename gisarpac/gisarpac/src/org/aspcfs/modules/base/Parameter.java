package org.aspcfs.modules.base;

import java.util.ArrayList;

import com.darkhorseventures.framework.beans.GenericBean;

public class Parameter extends GenericBean implements Comparable<Parameter>
{

	private static final long serialVersionUID = -3842980586914000622L;
	String nome		= null;
	String prefisso	= null;
	String valore	= null;
	ArrayList<String> valori	= null;
	int id 			= -1;
	
	public Parameter() {
		valori = new ArrayList<String>();
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getPrefisso() {
		return prefisso;
	}
	public void setPrefisso(String prefisso) {
		this.prefisso = prefisso;
	}
	public String getValore() {
		return valore;
	}
	public void setValore(String valore) {
		this.valore = valore;
	}
	public ArrayList<String> getValori() {
		return valori;
	}
	public void setValori(ArrayList<String> valori) {
		this.valori = valori;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int compareTo(Parameter o) {
		return (id > o.getId()) ? (1) : (-1);
	}
	

}
