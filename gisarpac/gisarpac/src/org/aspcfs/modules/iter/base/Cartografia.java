package org.aspcfs.modules.iter.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class Cartografia {

	private String nome;
	private String descrizione;
	private String url;
	
	
	public Cartografia(){
		
	}
	
	public Cartografia(ResultSet rs) throws SQLException{
		buildRecord(rs);
	}
	
	public void buildRecord(ResultSet rs) throws SQLException{
		nome = rs.getString("nome");
		descrizione = rs.getString("descrizione");
		url = rs.getString("url");

	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getDescrizione() {
		return descrizione;
	}

	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public static ArrayList<Cartografia> getListaCartografie(Connection db) throws SQLException {
		
		ArrayList<Cartografia> listaCartografie = new ArrayList<Cartografia>();
		PreparedStatement pst = db.prepareStatement("select * from iter_cartografie where enabled order by level asc");
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			Cartografia c = new Cartografia(rs);
			listaCartografie.add(c);
		}
		
		return listaCartografie;
	}
	
}
