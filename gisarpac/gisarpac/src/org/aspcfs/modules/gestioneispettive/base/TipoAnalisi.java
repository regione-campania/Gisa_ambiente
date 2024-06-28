package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class TipoAnalisi {
	
	private int id = -1;
	private String prodotto = "";
	private String metodi = "";
	private String prova = "";
	private String um = "";

	public TipoAnalisi() {
		// TODO Auto-generated constructor stub
	}


	public TipoAnalisi(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.id = rs.getInt("id");
		this.prodotto = rs.getString("prodotto");
		this.metodi = rs.getString("metodi");
		this.prova = rs.getString("prova");
		this.setUm(rs.getString("um"));

	}


	public static ArrayList<TipoAnalisi> buildLista(Connection db) {
		ArrayList<TipoAnalisi> lista = new ArrayList<TipoAnalisi>();
		try
		{
			String select = "select * from public.get_tipi_analisi_new();"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			rs = pst.executeQuery();
			while (rs.next()){
				TipoAnalisi str = new TipoAnalisi(rs); 
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


	public String getProdotto() {
		return prodotto;
	}


	public void setProdotto(String livello1) {
		this.prodotto = livello1;
	}


	public String getMetodi() {
		return metodi;
	}


	public void setMetodi(String livello2) {
		this.metodi = livello2;
	}


	public String getProva() {
		return prova;
	}


	public void setProva(String livello3) {
		this.prova = livello3;
	}


	public String getUm() {
		return um;
	}


	public void setUm(String um) {
		this.um = um;
	}

	


}
