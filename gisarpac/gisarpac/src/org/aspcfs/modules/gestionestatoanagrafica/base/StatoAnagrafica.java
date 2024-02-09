package org.aspcfs.modules.gestionestatoanagrafica.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

public class StatoAnagrafica {

	private int id;
	
	private int idNuovoStato;
	private int idVecchioStato;
	
	private String dataCambioStato;
	
	private String nota;
	private int enteredBy;
	private Timestamp entered = null;
	private Timestamp trashedDate = null;
	
	private int riferimentoId;
	private String riferimentoIdNomeTab;

	public StatoAnagrafica() {
	}

	public StatoAnagrafica(Connection db, int id) throws SQLException {}

	public StatoAnagrafica(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException {
		this.id = rs.getInt("id");
		
		this.riferimentoId = rs.getInt("riferimento_id");
		this.riferimentoIdNomeTab = rs.getString("riferimento_id_nome_tab");

		this.idNuovoStato = rs.getInt("id_nuovo_stato");
		this.idVecchioStato = rs.getInt("id_vecchio_stato");

		this.dataCambioStato = rs.getString("data_cambio_stato");
		
		this.nota = rs.getString("nota");
		this.enteredBy = rs.getInt("enteredby");
		this.entered = rs.getTimestamp("entered");
		this.trashedDate = rs.getTimestamp("trashed_date");

	}


	public static ArrayList<StatoAnagrafica> getStoricoCambioStato (Connection db, int riferimentoId, String riferimentoIdNomeTab) throws SQLException{
		ArrayList<StatoAnagrafica>  listaStorico = new ArrayList<StatoAnagrafica> ();
		
		PreparedStatement pst = db.prepareStatement("select * from get_storico_cambio_stato_anag(?, ?)");
		pst.setInt(1,  riferimentoId);
		pst.setString(2, riferimentoIdNomeTab);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			StatoAnagrafica stato = new StatoAnagrafica(rs);
			listaStorico.add(stato);
		}
		return listaStorico;
	}

	public static String insert(Connection db, int riferimentoId, String riferimentoIdNomeTab, int userId, int idStato, String dataCambioStato, String nota) throws SQLException {
		String messaggio = null;
		
		PreparedStatement pst = db.prepareStatement("select * from update_anag(?, ?, ?, ?, ?, ?)");
		int i = 0;
		pst.setInt(++i, riferimentoId);
		pst.setString(++i, riferimentoIdNomeTab);
		pst.setInt(++i, idStato);
		pst.setString(++i, dataCambioStato);
		pst.setInt(++i, userId);		
		pst.setString(++i, nota);

		ResultSet rs = pst.executeQuery();
		if (rs.next())
			messaggio = rs.getString(1);
		return messaggio;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getIdNuovoStato() {
		return idNuovoStato;
	}

	public void setIdNuovoStato(int idNuovoStato) {
		this.idNuovoStato = idNuovoStato;
	}

	public int getIdVecchioStato() {
		return idVecchioStato;
	}

	public void setIdVecchioStato(int idVecchioStato) {
		this.idVecchioStato = idVecchioStato;
	}

	public String getDataCambioStato() {
		return dataCambioStato;
	}

	public void setDataCambioStato(String dataCambioStato) {
		this.dataCambioStato = dataCambioStato;
	}

	public String getNota() {
		return nota;
	}

	public void setNota(String nota) {
		this.nota = nota;
	}

	public int getEnteredBy() {
		return enteredBy;
	}

	public void setEnteredBy(int enteredBy) {
		this.enteredBy = enteredBy;
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

	public int getRiferimentoId() {
		return riferimentoId;
	}

	public void setRiferimentoId(int riferimentoId) {
		this.riferimentoId = riferimentoId;
	}

	public String getRiferimentoIdNomeTab() {
		return riferimentoIdNomeTab;
	}

	public void setRiferimentoIdNomeTab(String riferimentoIdNomeTab) {
		this.riferimentoIdNomeTab = riferimentoIdNomeTab;
	}
	
	

	
	

}
