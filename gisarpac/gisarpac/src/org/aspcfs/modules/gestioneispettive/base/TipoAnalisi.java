package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class TipoAnalisi {
	
	private int id = -1;
	private String livello1 = "";
	private String livello2 = "";
	private String livello3 = "";

	public TipoAnalisi() {
		// TODO Auto-generated constructor stub
	}


	public TipoAnalisi(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.id = rs.getInt("id");
		this.livello1 = rs.getString("livello1");
		this.livello2 = rs.getString("livello2");
		this.livello3 = rs.getString("livello3");
	}


	public static ArrayList<TipoAnalisi> buildLista(Connection db) {
		ArrayList<TipoAnalisi> lista = new ArrayList<TipoAnalisi>();
		try
		{
			String select = "select * from public.get_tipi_analisi();"; 
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


	public String getLivello1() {
		return livello1;
	}


	public void setLivello1(String livello1) {
		this.livello1 = livello1;
	}


	public String getLivello2() {
		return livello2;
	}


	public void setLivello2(String livello2) {
		this.livello2 = livello2;
	}


	public String getLivello3() {
		return livello3;
	}


	public void setLivello3(String livello3) {
		this.livello3 = livello3;
	}

	


}
