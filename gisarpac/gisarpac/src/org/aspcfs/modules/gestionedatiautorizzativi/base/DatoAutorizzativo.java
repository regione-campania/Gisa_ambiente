package org.aspcfs.modules.gestionedatiautorizzativi.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

public class DatoAutorizzativo {

	private int id;
	
	private String idAia;
	private int idAutorizzazione;
	private String numeroDecreto;
	private String dataDecreto;
	private String nota;
	private String burc;
	
	private ArrayList<Matrice> listaMatrici = new ArrayList<Matrice>();

	private int enteredBy;
	private int modifiedBy;

	private Timestamp entered = null;
	private Timestamp modified = null;
	private Timestamp trashedDate = null;
	
	private int riferimentoId;
	private String riferimentoIdNomeTab;

	public DatoAutorizzativo() {
	}

	public DatoAutorizzativo(Connection db, int id) throws SQLException {}

	public DatoAutorizzativo(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException {
		this.id = rs.getInt("id");
		
		this.riferimentoId = rs.getInt("riferimento_id");
		this.riferimentoIdNomeTab = rs.getString("riferimento_id_nome_tab");

		this.idAia = rs.getString("id_aia");
		this.idAutorizzazione = rs.getInt("tipo_autorizzazione");
		this.numeroDecreto = rs.getString("num_decreto");
		this.dataDecreto = rs.getString("data_decreto");
		this.nota = rs.getString("nota");
		this.burc = rs.getString("burc");
		this.enteredBy = rs.getInt("enteredby");
		this.modifiedBy = rs.getInt("modifiedby");
		this.entered = rs.getTimestamp("entered");
		this.modified = rs.getTimestamp("modified");
		this.trashedDate = rs.getTimestamp("trashed_date");

	}


	public DatoAutorizzativo (Connection db, int riferimentoId, String riferimentoIdNomeTab) throws SQLException{
		PreparedStatement pst = db.prepareStatement("select * from get_dati_autorizzativi(?, ?)");
		pst.setInt(1,  riferimentoId);
		pst.setString(2, riferimentoIdNomeTab);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			buildRecord(rs);
			buildListaMatrici(db);
		}
	}

	

	private void buildListaMatrici(Connection db) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from get_dati_autorizzativi_matrici(?)");
		pst.setInt(1,  id);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			Matrice m = new Matrice(rs);
			listaMatrici.add(m);
		}
	}
	
	public static String delete(Connection db, int riferimentoId, String riferimentoIdNomeTab, int userId) throws SQLException {
		String messaggio = null;
		
		PreparedStatement pst = db.prepareStatement("select * from delete_dati_autorizzativi(?, ?::text, ?)");
		int i = 0;
		pst.setInt(++i, riferimentoId);
		pst.setString(++i, riferimentoIdNomeTab);
		pst.setInt(++i, userId);
		
		ResultSet rs = pst.executeQuery();
		if (rs.next())
			messaggio = rs.getString(1);
		return messaggio;
	}

	public static String insert(Connection db, int riferimentoId, String riferimentoIdNomeTab, int userId, String idAia, int idAutorizzazione, String numeroDecreto, String dataDecreto, String nota, String burc, String[] matriceIds) throws SQLException {
		String messaggio = null;
		
		
		String listaMatrici = "";
		
		if (matriceIds!= null && matriceIds.length>0){ 
			StringBuilder builder = new StringBuilder();
			for (String value : matriceIds) {
			    builder.append(value);
			    builder.append(",");
			}
			listaMatrici = builder.toString().substring(0, builder.toString().length()-1);
		}
		
		PreparedStatement pst = db.prepareStatement("select * from insert_dati_autorizzativi(?, ?::text, ?, ?::text, ?, ?::text, ?::text, ?::text, ?::text, ?::text)");
		int i = 0;
		pst.setInt(++i, riferimentoId);
		pst.setString(++i, riferimentoIdNomeTab);
		pst.setInt(++i, userId);
		pst.setString(++i, idAia);
		pst.setInt(++i, idAutorizzazione);
		pst.setString(++i, numeroDecreto);
		pst.setString(++i, dataDecreto);
		pst.setString(++i, nota);
		pst.setString(++i, burc);
		pst.setString(++i, listaMatrici);


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

	public String getIdAia() {
		return idAia;
	}

	public void setIdAia(String idAia) {
		this.idAia = idAia;
	}

	public int getIdAutorizzazione() {
		return idAutorizzazione;
	}

	public void setIdAutorizzazione(int idAutorizzazione) {
		this.idAutorizzazione = idAutorizzazione;
	}

	public String getNumeroDecreto() {
		return numeroDecreto;
	}

	public void setNumeroDecreto(String numeroDecreto) {
		this.numeroDecreto = numeroDecreto;
	}

	public String getDataDecreto() {
		return dataDecreto;
	}

	public void setDataDecreto(String dataDecreto) {
		this.dataDecreto = dataDecreto;
	}

	public String getNota() {
		return nota;
	}

	public void setNota(String nota) {
		this.nota = nota;
	}

	public String getBurc() {
		return burc;
	}

	public void setBurc(String burc) {
		this.burc = burc;
	}

	public ArrayList<Matrice> getListaMatrici() {
		return listaMatrici;
	}

	public void setListaMatrici(ArrayList<Matrice> listaMatrici) {
		this.listaMatrici = listaMatrici;
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

	public static ArrayList<DatoAutorizzativo> buildListaDati(Connection db, int riferimentoId,
			String riferimentoIdNomeTab) throws SQLException {
		
		ArrayList<DatoAutorizzativo> listaDati = new ArrayList<DatoAutorizzativo>();
		PreparedStatement pst = db.prepareStatement("select * from get_dati_autorizzativi(?, ?)");
		pst.setInt(1,  riferimentoId);
		pst.setString(2, riferimentoIdNomeTab);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			DatoAutorizzativo dato = new DatoAutorizzativo(rs);
			dato.buildListaMatrici(db);
			listaDati.add(dato);
		}
		
		return listaDati;
	}

	
	

}
