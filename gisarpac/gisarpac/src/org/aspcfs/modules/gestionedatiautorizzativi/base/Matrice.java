package org.aspcfs.modules.gestionedatiautorizzativi.base;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class Matrice {

	private int idMatrice;
	private int idDatiAutorizzativi;
	private String descrizione;
	
	private int enteredBy;
	private int modifiedBy;

	private Timestamp entered = null;
	private Timestamp modified = null;
	private Timestamp trashedDate = null;

	public Matrice() {
	}

	public Matrice(Connection db, int id) throws SQLException {}

	public Matrice(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException {
		this.idMatrice = rs.getInt("id_matrice");
		this.idDatiAutorizzativi = rs.getInt("id_anag_dati_autorizzativi"); 
		this.enteredBy = rs.getInt("enteredby");
		this.modifiedBy = rs.getInt("modifiedby");
		this.entered = rs.getTimestamp("entered");
		this.modified = rs.getTimestamp("modified");
		this.trashedDate = rs.getTimestamp("trashed_date");

	}

	public int getIdMatrice() {
		return idMatrice;
	}

	public void setIdMatrice(int idMatrice) {
		this.idMatrice = idMatrice;
	}

	
	public int getEnteredBy() {
		return enteredBy;
	}

	public void setEnteredBy(int enteredBy) {
		this.enteredBy = enteredBy;
	}

	public int getModifiedBy() {
		return modifiedBy;
	}

	public void setModifiedBy(int modifiedBy) {
		this.modifiedBy = modifiedBy;
	}

	public Timestamp getEntered() {
		return entered;
	}

	public void setEntered(Timestamp entered) {
		this.entered = entered;
	}

	public Timestamp getModified() {
		return modified;
	}

	public void setModified(Timestamp modified) {
		this.modified = modified;
	}

	public Timestamp getTrashedDate() {
		return trashedDate;
	}

	public void setTrashedDate(Timestamp trashedDate) {
		this.trashedDate = trashedDate;
	}

	public String getDescrizione() {
		return descrizione;
	}

	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}

	public int getIdDatiAutorizzativi() {
		return idDatiAutorizzativi;
	}

	public void setIdDatiAutorizzativi(int idDatiAutorizzativi) {
		this.idDatiAutorizzativi = idDatiAutorizzativi;
	}

	

	
	

}
