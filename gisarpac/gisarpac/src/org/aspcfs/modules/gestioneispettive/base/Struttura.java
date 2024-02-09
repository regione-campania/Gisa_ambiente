package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class Struttura {
	
	private int id = -1;
	private String tipologia;
	private String descrizione = "";
	private String appartenenza;
	private String dipartimento;
	private int idDipartimento;
	
	public Struttura() {
		// TODO Auto-generated constructor stub
	}


	public Struttura(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.id = rs.getInt("id");
		this.tipologia = rs.getString("tipologia");
		this.descrizione = rs.getString("descrizione");
		this.appartenenza = rs.getString("appartenenza");
		this.dipartimento = rs.getString("dipartimento");
		this.idDipartimento = rs.getInt("id_dipartimento");
	}

	public Struttura(Connection db, int idStruttura) throws SQLException {}

	public static ArrayList<Struttura> buildLista(Connection db, int anno, int idDipartimento) {
		ArrayList<Struttura> lista = new ArrayList<Struttura>();
		try
		{
			String select = "select * from public.get_percontodi_strutture_dipartimento(?, ?);"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, anno);
			pst.setInt(2, idDipartimento);
			rs = pst.executeQuery();
			while (rs.next()){
				Struttura str = new Struttura(rs); 
				lista.add(str);
			}
		}
		catch(SQLException e)
		{	e.printStackTrace();
		}
		return lista;
	}


	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public String getTipologia() {
		return tipologia;
	}


	public void setTipologia(String tipologia) {
		this.tipologia = tipologia;
	}


	public String getDescrizione() {
		return descrizione;
	}


	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}


	public String getAppartenenza() {
		return appartenenza;
	}


	public void setAppartenenza(String appartenenza) {
		this.appartenenza = appartenenza;
	}


	public String getDipartimento() {
		return dipartimento;
	}


	public void setDipartimento(String dipartimento) {
		this.dipartimento = dipartimento;
	}


	public int getIdDipartimento() {
		return idDipartimento;
	}


	public void setIdDipartimento(int idDipartimento) {
		this.idDipartimento = idDipartimento;
	}


	


	


}
