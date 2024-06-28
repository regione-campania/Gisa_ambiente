package org.aspcfs.modules.gestionedpat.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class AreaComplessa {
	
	private int id = -1;
	private int idDipartimento = -1;
	private int anno = -1;
	private String nome = "";
	private ArrayList<AreaSemplice> listaAreeSemplici = new  ArrayList<AreaSemplice>();
	
	public AreaComplessa() {

	}
	
	public AreaComplessa(Connection db, int idAreaComplessa) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from dpat_get_area_complessa(?)");
		pst.setInt(1,  idAreaComplessa);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			buildRecord(rs);
			listaAreeSemplici = AreaSemplice.buildByAreaComplessa(db, id);
		}
	}
	
	public AreaComplessa(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException {
		this.id = rs.getInt("id");
		this.idDipartimento = rs.getInt("id_dipartimento");
		this.anno = rs.getInt("anno");
		this.nome = rs.getString("nome");		
	}

	public static ArrayList<AreaComplessa> buildByAnnoDipartimento(Connection db, int anno, int idDipartimento) throws SQLException{
		ArrayList<AreaComplessa> lista = new ArrayList<AreaComplessa>();
		
		PreparedStatement pst = db.prepareStatement("select * from dpat_get_aree_complesse_by_dipartimento_anno(?, ?)");
		pst.setInt(1, anno);
		pst.setInt(2, idDipartimento);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			AreaComplessa s = new AreaComplessa(rs);
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

	public int getIdDipartimento() {
		return idDipartimento;
	}

	public void setIdDipartimento(int idDipartimento) {
		this.idDipartimento = idDipartimento;
	}

	public int getAnno() {
		return anno;
	}

	public void setAnno(int anno) {
		this.anno = anno;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public ArrayList<AreaSemplice> getListaAreeSemplici() {
		return listaAreeSemplici;
	}

	public void setListaAreeSemplici(ArrayList<AreaSemplice> listaAreeSemplici) {
		this.listaAreeSemplici = listaAreeSemplici;
	}

	public void insert(Connection db, int idUtente) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from dpat_insert_area_complessa(?, ?, ?, ?)");
		pst.setInt(1,  anno);
		pst.setInt(2,  idDipartimento);
		pst.setString(3,  nome);
		pst.setInt(4,  idUtente);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			id = rs.getInt(1);
		}
	}

}
