package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class Area {
	
	private int id = -1;
	private String tipologia;
	private String descrizioneAreaSemplice = "";
	private String descrizioneAreaComplessa = "";
	private String dipartimento;
	private int idDipartimento;
	
	public Area() {
		// TODO Auto-generated constructor stub
	}


	public Area(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.id = rs.getInt("id");
		this.tipologia = rs.getString("tipologia");
		this.descrizioneAreaSemplice = rs.getString("descrizione_area_semplice");
		this.descrizioneAreaComplessa = rs.getString("descrizione_area_complessa");
		this.dipartimento = rs.getString("dipartimento");
		this.idDipartimento = rs.getInt("id_dipartimento");
	}

	public Area(Connection db, int idAreaSemplice) throws SQLException {}

	public static ArrayList<Area> buildLista(Connection db, int anno, int idDipartimento) {
		ArrayList<Area> lista = new ArrayList<Area>();
		try
		{
			String select = "select * from public.get_percontodi_aree_dipartimento(?, ?);"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, anno);
			pst.setInt(2, idDipartimento);
			rs = pst.executeQuery();
			while (rs.next()){
				Area str = new Area(rs); 
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


	public String getDescrizioneAreaSemplice() {
		return descrizioneAreaSemplice;
	}


	public void setDescrizioneAreaSemplice(String descrizioneAreaSemplice) {
		this.descrizioneAreaSemplice = descrizioneAreaSemplice;
	}


	public String getDescrizioneAreaComplessa() {
		return descrizioneAreaComplessa;
	}


	public void setDescrizioneAreaComplessa(String descrizioneAreaComplessa) {
		this.descrizioneAreaComplessa = descrizioneAreaComplessa;
	}


	


	


}
