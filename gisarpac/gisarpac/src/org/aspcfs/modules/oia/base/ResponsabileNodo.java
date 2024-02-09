package org.aspcfs.modules.oia.base;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ResponsabileNodo implements Serializable {

	private int id_utente 				;
	private String nome_responsabile 	;
	private String cognome_responsabile ;
	private String ruolo_responsabile ;
	public int getId_utente() {
		return id_utente;
	}
	public void setId_utente(int id_utente) {
		this.id_utente = id_utente;
	}
	public String getNome_responsabile() {
		return nome_responsabile;
	}
	public void setNome_responsabile(String nome_responsabile) {
		this.nome_responsabile = nome_responsabile;
	}
	public String getCognome_responsabile() {
		return cognome_responsabile;
	}
	public void setCognome_responsabile(String cognome_responsabile) {
		this.cognome_responsabile = cognome_responsabile;
	}
	public String getRuolo_responsabile() {
		return ruolo_responsabile;
	}
	public void setRuolo_responsabile(String ruolo_responsabile) {
		this.ruolo_responsabile = ruolo_responsabile;
	}
	
	public ResponsabileNodo(ResultSet rs) throws SQLException
	{
		
		id_utente = rs.getInt("id_utente");
		nome_responsabile = rs.getString("nome_responsabile");
		cognome_responsabile= rs.getString("cognome_responsabile");
		ruolo_responsabile = rs.getString("ruolo_responsabile");
	}
	
	public void insert (Connection db,int idNodo) throws SQLException
	{
		
		
		String insert = "insert into oia_nodo_responsabili (id_utente , id_oia_nodo) values (?,?)" ;
		PreparedStatement pst = db.prepareStatement(insert);
		pst.setInt(1, id_utente);
		pst.setInt(2, idNodo);
		pst.execute() ;
	}
	
	public ResponsabileNodo() 
	{
		
	}
	
	
	
}
