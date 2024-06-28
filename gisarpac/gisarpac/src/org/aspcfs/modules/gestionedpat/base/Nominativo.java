package org.aspcfs.modules.gestionedpat.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class Nominativo {
	private int id = -1;
	private String nome = "";
	private String qualifica = "";
	
	public Nominativo() {
		
	}
	
	public Nominativo(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	public Nominativo(Connection db, int idAreaSemplice, int idNominativo) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from dpat_get_nominativo(?, ?)");
		pst.setInt(1,  idNominativo);
		pst.setInt(2,  idAreaSemplice);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			buildRecord(rs);
		}
	}

	private void buildRecord(ResultSet rs) throws SQLException {
		this.id = rs.getInt("id");
		this.nome = rs.getString("nome");
		this.qualifica = rs.getString("qualifica");		

	}

	public static ArrayList<Nominativo> buildByAreaSemplice(Connection db, int idAreaSemplice) throws SQLException {
		ArrayList<Nominativo> lista = new ArrayList<Nominativo>();
		
		PreparedStatement pst = db.prepareStatement("select * from dpat_get_nominativi_by_area_semplice(?)");
		pst.setInt(1, idAreaSemplice);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			Nominativo n = new Nominativo(rs);
			lista.add(n);
		}
		return lista;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getQualifica() {
		return qualifica;
	}

	public void setQualifica(String qualifica) {
		this.qualifica = qualifica;
	}

	public static ArrayList<Nominativo> buildSelezionabiliByAreaSemplice(Connection db, int idAreaSemplice) throws SQLException {
		ArrayList<Nominativo> lista = new ArrayList<Nominativo>();
		
		PreparedStatement pst = db.prepareStatement("select * from dpat_get_nominativi_selezionabili(?)");
		pst.setInt(1, idAreaSemplice);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			Nominativo n = new Nominativo(rs);
			lista.add(n);
		}
		return lista;
	}
}
