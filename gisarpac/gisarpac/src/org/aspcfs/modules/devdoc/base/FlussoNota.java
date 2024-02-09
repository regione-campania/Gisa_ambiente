package org.aspcfs.modules.devdoc.base;

import java.sql.Timestamp;

import com.darkhorseventures.framework.beans.GenericBean;

public class FlussoNota extends GenericBean {
	private int id = -1;	
	private String nota = null;
	private int idFlusso = -1;
	private int idUtente = -1;
	private Timestamp dataInserimento = null;
	private Timestamp  dataCancellazione = null;
	
	public FlussoNota(int id, String nota, int idFlusso, int idUtente, Timestamp dataInserimento,
			Timestamp dataCancellazione) {
		super();
		this.id = id;
		this.nota = nota;
		this.idFlusso = idFlusso;
		this.idUtente = idUtente;
		this.dataInserimento = dataInserimento;
		this.dataCancellazione = dataCancellazione;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getNota() {
		return nota;
	}
	public void setNota(String nota) {
		this.nota = nota;
	}
	public int getIdFlusso() {
		return idFlusso;
	}
	public void setIdFlusso(int idFlusso) {
		this.idFlusso = idFlusso;
	}
	public int getIdUtente() {
		return idUtente;
	}
	public void setIdUtente(int idUtente) {
		this.idUtente = idUtente;
	}
	public Timestamp getDataInserimento() {
		return dataInserimento;
	}
	public void setDataInserimento(Timestamp dataInserimento) {
		this.dataInserimento = dataInserimento;
	}
	public Timestamp getDataCancellazione() {
		return dataCancellazione;
	}
	public void setDataCancellazione(Timestamp dataCancellazione) {
		this.dataCancellazione = dataCancellazione;
	}
}
