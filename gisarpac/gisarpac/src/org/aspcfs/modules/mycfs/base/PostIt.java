package org.aspcfs.modules.mycfs.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import com.darkhorseventures.framework.beans.GenericBean;

public class PostIt extends GenericBean {
	
	
	int id = -1;
	private String messaggio = null;
	private int idUtente = -1;
	private Timestamp entered = null;
	private Timestamp trashedDate = null;
	private int tipo = -1;
	
	
	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public String getMessaggio() {
		return messaggio;
	}


	public void setMessaggio(String messaggio) {
		this.messaggio = messaggio;
	}


	public int getIdUtente() {
		return idUtente;
	}


	public void setIdUtente(int idUtente) {
		this.idUtente = idUtente;
	}


	public Timestamp getEntered() {
		return entered;
	}


	public void setEntered(Timestamp entered) {
		this.entered = entered;
	}


	public Timestamp getTrashedDate() {
		return trashedDate;
	}


	public void setTrashedDate(Timestamp trashedDate) {
		this.trashedDate = trashedDate;
	}


	public void buildUltimoPostIt(Connection db) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from post_it where entered = (select max(entered) from post_it where trashed_date is null and tipo = ?) ");
		pst.setInt(1, tipo);
		ResultSet rs = pst.executeQuery();
		if (rs.next())
			buildRecord(rs);
	}


	private void buildRecord(ResultSet rs) throws SQLException {
		id = rs.getInt("id");
		messaggio = rs.getString("messaggio");
		idUtente = rs.getInt("id_utente");
		tipo = rs.getInt("tipo");
		entered = rs.getTimestamp("entered");
		trashedDate = rs.getTimestamp("trashed_date");
	}


	public void inserisci(Connection db) throws SQLException {
	PreparedStatement pst = db.prepareStatement("insert into post_it(entered, messaggio, id_utente, tipo) values (now(), ?, ?, ?)");
	pst.setString(1, messaggio);
	pst.setInt(2, idUtente);
	pst.setInt(3, tipo);
	pst.executeUpdate();
	}


	public int getTipo() {
		return tipo;
	}


	public void setTipo(int tipo) {
		this.tipo = tipo;
	}
	
	
	
	
	
	

}
