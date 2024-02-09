package org.aspcfs.modules.gestioneanagrafica.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

public class Pratica {
	
	private String numeroPratica;
	private int idTipologiaPratica;
	private Timestamp dataOperazione;
	private int idStabilimento;
	private int altId;
	private String numeroRegistrazione;
	private String ragioneSociale;
	private String partitaIva;
	private String indirizzo;
	private int idUtente;
	private int statoPratica;
	private String comuneRichiedente;
	private int siteIdStab;
	private int idComuneRichiedente;

	public Pratica() {
		// TODO Auto-generated constructor stub
	}
	
	public Pratica(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}
	
	public void buildRecord(ResultSet rs) throws SQLException{
		numeroPratica = rs.getString("numero_pratica");
		idTipologiaPratica = rs.getInt("id_tipologia_pratica");
		dataOperazione = rs.getTimestamp("data_operazione");
		idStabilimento = rs.getInt("id_stabilimento");
		altId = rs.getInt("alt_id");
		numeroRegistrazione = rs.getString("numero_registrazione");
		ragioneSociale = rs.getString("ragione_sociale");
		partitaIva = rs.getString("partita_iva");
		indirizzo = rs.getString("indirizzo");
		idUtente = rs.getInt("id_utente"); 
		statoPratica = rs.getInt("stato_pratica"); 
		comuneRichiedente = rs.getString("comune_richiedente");
		siteIdStab = rs.getInt("site_id_stab");
		idComuneRichiedente = rs.getInt("id_comune_richiedente");
	}
	
	
	public static ArrayList<Pratica> getListaPratiche(Connection db, int altId) throws SQLException {
			ArrayList<Pratica> lista = new  ArrayList<Pratica>();
		 		
				PreparedStatement pst = db.prepareStatement("select * from get_lista_pratiche(?)");
				pst.setInt(1, altId);
				ResultSet rs = pst.executeQuery();
				while (rs.next()){
					Pratica pra = new Pratica(rs);
					lista.add(pra);		
				}
			
			return lista;
	}
	
	public static ArrayList<Pratica> getListaPraticheSearch(Connection db, String numeroPratica, 
				int comune, String data_pec, int tipo_pratica, 
				String site_id_user, int numero_pagina, int size_pagina) throws SQLException {
		
			ArrayList<Pratica> lista = new  ArrayList<Pratica>();
	 		String sqlquery = "select * from get_lista_pratiche_amministrative(?,?,?,?,?)"
					+ " order by data_operazione desc  LIMIT " + 
					size_pagina + " OFFSET " + size_pagina * (numero_pagina-1);
			PreparedStatement pst = db.prepareStatement(sqlquery);
			pst.setInt(1, tipo_pratica);	
			pst.setInt(2, comune);
			pst.setString(3, site_id_user);
			pst.setString(4, data_pec);
			pst.setString(5, numeroPratica);
			ResultSet rs = pst.executeQuery();
			while (rs.next()){
				Pratica pra = new Pratica(rs);
				lista.add(pra);		
			}
		
		return lista;
	}
	
	public static int getNumeroPraticheTotSearch(Connection db, String numeroPratica, int comune, String data_pec, int tipo_pratica, String site_id_user) throws SQLException {
		
		int totale_pratiche = 0;
	 		
		PreparedStatement pst = db.prepareStatement("select count(*)::integer num_pratiche_trovate from get_lista_pratiche_amministrative(?,?,?,?,?)");
			pst.setInt(1, tipo_pratica);	
			pst.setInt(2, comune);
			pst.setString(3, site_id_user);
			pst.setString(4, data_pec);
			pst.setString(5, numeroPratica);
			ResultSet rs = pst.executeQuery();
			while (rs.next()){
				totale_pratiche = rs.getInt("num_pratiche_trovate");	
			}
		
		return totale_pratiche;
	}

	public String getNumeroPratica() {
		return numeroPratica;
	}

	public void setNumeroPratica(String numeroPratica) {
		this.numeroPratica = numeroPratica;
	}

	public Timestamp getDataOperazione() {
		return dataOperazione;
	}

	public void setDataOperazione(Timestamp dataOperazione) {
		this.dataOperazione = dataOperazione;
	}

	public String getNumeroRegistrazione() {
		return numeroRegistrazione;
	}

	public void setNumeroRegistrazione(String numeroRegistrazione) {
		this.numeroRegistrazione = numeroRegistrazione;
	}

	public String getRagioneSociale() {
		return ragioneSociale;
	}

	public void setRagioneSociale(String ragioneSociale) {
		this.ragioneSociale = ragioneSociale;
	}

	public String getPartitaIva() {
		return partitaIva;
	}

	public void setPartitaIva(String partitaIva) {
		this.partitaIva = partitaIva;
	}

	public int getIdStabilimento() {
		return idStabilimento;
	}

	public void setIdStabilimento(int idStabilimento) {
		this.idStabilimento = idStabilimento;
	}

	public int getIdTipologiaPratica() { 
		return idTipologiaPratica;
	}

	public void setIdTipologiaPratica(int idTipologiaPratica) {
		this.idTipologiaPratica = idTipologiaPratica;
	}
	

	public int getIdUtente() {
		return idUtente;
	}

	public void setIdUtente(int idUtente) {
		this.idUtente = idUtente;
	}

	public int getAltId() {
		return altId;
	}

	public void setAltId(int altId) {
		this.altId = altId;
	}

	public String getIndirizzo() {
		return indirizzo;
	}

	public void setIndirizzo(String indirizzo) {
		this.indirizzo = indirizzo;
	}

	public int getStatoPratica() {
		return statoPratica;
	}

	public void setStatoPratica(int statoPratica) {
		this.statoPratica = statoPratica;
	}

	public String getComuneRichiedente() {
		return comuneRichiedente;
	}

	public void setComuneRichiedente(String comuneRichiedente) {
		this.comuneRichiedente = comuneRichiedente;
	}

	public int getSiteIdStab() {
		return siteIdStab;
	}

	public void setSiteIdStab(int siteIdStab) {
		this.siteIdStab = siteIdStab;
	}

	public int getIdComuneRichiedente() {
		return idComuneRichiedente;
	}

	public void setIdComuneRichiedente(int idComuneRichiedente) {
		this.idComuneRichiedente = idComuneRichiedente;
	}

	
}
