package org.aspcfs.modules.gestionedpat.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class AreaSemplice {
	
	private int id = -1;
	private int idAreaComplessa = -1;
	private String nome = "";
	private ArrayList<Nominativo> listaNominativi = new ArrayList<Nominativo>();
	
	
	public AreaSemplice(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	public AreaSemplice(Connection db, int idAreaSemplice) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from dpat_get_area_semplice(?)");
		pst.setInt(1,  idAreaSemplice);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			buildRecord(rs);
			listaNominativi = Nominativo.buildByAreaSemplice(db, id);
		}
	}

	public AreaSemplice() {
		// TODO Auto-generated constructor stub
	}

	private void buildRecord(ResultSet rs) throws SQLException {
		this.id = rs.getInt("id");
		this.idAreaComplessa = rs.getInt("id_area_complessa");
		this.nome = rs.getString("nome");	
	}


	public static ArrayList<AreaSemplice> buildByAreaComplessa(Connection db, int idAreaComplessa) throws SQLException{
		ArrayList<AreaSemplice> lista = new ArrayList<AreaSemplice>();
		
		PreparedStatement pst = db.prepareStatement("select * from dpat_get_aree_semplici_by_area_complessa(?)");
		pst.setInt(1, idAreaComplessa);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			AreaSemplice s = new AreaSemplice(rs);
			ArrayList<Nominativo> listaNominativi = new ArrayList<Nominativo>();
			listaNominativi = Nominativo.buildByAreaSemplice(db, s.getId());
			s.setListaNominativi(listaNominativi);
			lista.add(s);
		}
		
		return lista;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getIdAreaComplessa() {
		return idAreaComplessa;
	}

	public void setIdAreaComplessa(int idAreaComplessa) {
		this.idAreaComplessa = idAreaComplessa;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public ArrayList<Nominativo> getListaNominativi() {
		return listaNominativi;
	}

	public void setListaNominativi(ArrayList<Nominativo> listaNominativi) {
		this.listaNominativi = listaNominativi;
	}

	public void update(Connection db, String nome, int idUtente) throws SQLException {
		
		PreparedStatement pst = db.prepareStatement("select * from dpat_update_area_semplice(?, ?, ?)"); 
		pst.setInt(1, id);
		pst.setString(2, nome);
		pst.setInt(3, idUtente);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			
		}
		
	}

	public void disable(Connection db, int idUtente) throws SQLException {
		
		PreparedStatement pst = db.prepareStatement("select * from dpat_disable_area_semplice(?, ?)");
		pst.setInt(1, id);
		pst.setInt(2,  idUtente);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			
		}
		
	}

	public void insertNominativo(Connection db, int idNominativo, int idUtente) throws SQLException {
		
		PreparedStatement pst = db.prepareStatement("select * from dpat_insert_nominativo_area_semplice(?, ?, ?)");
		pst.setInt(1, idNominativo);
		pst.setInt(2, id);
		pst.setInt(3,  idUtente);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			
		}
		
	}

	public void deleteNominativo(Connection db, int idNominativo, int idUtente) throws SQLException {
		
		PreparedStatement pst = db.prepareStatement("select * from dpat_elimina_nominativo_area_semplice(?, ?, ?)");
		pst.setInt(1, idNominativo);
		pst.setInt(2, id);
		pst.setInt(3,  idUtente);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			
		}
		
	}
	
	public void insert(Connection db, int idUtente) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from dpat_insert_area_semplice(?, ?, ?)");
		pst.setInt(1,  idAreaComplessa);
		pst.setString(2,  nome);
		pst.setInt(3,  idUtente);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			id = rs.getInt(1);
		}
	}

}
