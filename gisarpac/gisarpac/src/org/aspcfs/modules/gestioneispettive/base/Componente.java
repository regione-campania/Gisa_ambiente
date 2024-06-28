package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class Componente {
	
	private int id = -1;
	private String nominativo = "";
	private int idAreaSemplice = -1;
	private String descrizioneAreaSemplice = "";
	private int idQualifica = -1;
	private String nomeQualifica = "";

	
	public Componente() {
		// TODO Auto-generated constructor stub
	}


	public Componente(ResultSet rs) throws SQLException {
		this.id = rs.getInt("id");
		this.nominativo = rs.getString("nominativo");
		this.idAreaSemplice = rs.getInt("id_area_semplice");
		this.descrizioneAreaSemplice = rs.getString("descrizione_area_semplice");
		this.idQualifica = rs.getInt("id_qualifica");
		this.nomeQualifica = rs.getString("nome_qualifica");
	}


	public static ArrayList<Componente> buildLista(Connection db, int anno, int dipartimentoId) {
		ArrayList<Componente> lista = new ArrayList<Componente>();
		try
		{
			String select = "select * from public.get_gruppo_ispettivo_componenti(?, ?);";  
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, anno);
			pst.setInt(2, dipartimentoId);
			rs = pst.executeQuery();
			while (rs.next()){
				Componente com = new Componente(rs);
				lista.add(com);
			}
		}
		catch(SQLException e)
		{	e.printStackTrace();
		}
		return lista;
	}
	
	public static ArrayList<Componente> buildListaGiornataIspettiva(Connection db, int idGiornataIspettiva) {
		ArrayList<Componente> lista = new ArrayList<Componente>();
		try
		{
			String select = "select * from public.get_giornata_ispettiva_gruppo_ispettivo_componenti(?);";  
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, idGiornataIspettiva);
			rs = pst.executeQuery();
			while (rs.next()){
				Componente com = new Componente(rs);
				lista.add(com);
			}
		}
		catch(SQLException e)
		{	e.printStackTrace();
		}
		return lista;
	}
		
	public static ArrayList<Componente> buildListaParticella(Connection db, int ruoloId, int dipartimentoId) {
		ArrayList<Componente> lista = new ArrayList<Componente>();
		try
		{
			String select = "select * from public.get_gruppo_ispettivo_componenti_particella(?, ?);";  
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, ruoloId);
			pst.setInt(2, dipartimentoId);
			rs = pst.executeQuery();
			while (rs.next()){
				Componente com = new Componente(rs);
				lista.add(com);
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


	public String getNominativo() {
		return nominativo;
	}


	public void setNominativo(String nominativo) {
		this.nominativo = nominativo;
	}


	

	public int getIdQualifica() {
		return idQualifica;
	}


	public void setIdQualifica(int idQualifica) {
		this.idQualifica = idQualifica;
	}


	public String getNomeQualifica() {
		return nomeQualifica;
	}


	public void setNomeQualifica(String nomeQualifica) {
		this.nomeQualifica = nomeQualifica;
	}


	public int getIdAreaSemplice() {
		return idAreaSemplice;
	}


	public void setIdAreaSemplice(int idAreaSemplice) {
		this.idAreaSemplice = idAreaSemplice;
	}


	public String getDescrizioneAreaSemplice() {
		return descrizioneAreaSemplice;
	}


	public void setDescrizioneAreaSemplice(String descrizioneAreaSemplice) {
		this.descrizioneAreaSemplice = descrizioneAreaSemplice;
	}


	

}
