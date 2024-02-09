package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class Tecnica {
	
	private int id = -1;
	private String nome = "";
	
	public Tecnica() {
		// TODO Auto-generated constructor stub
	}


	public Tecnica(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.id = rs.getInt("id");
		this.nome = rs.getString("nome");
	}

	public Tecnica(Connection db, int idTecnica) throws SQLException {}

	public static ArrayList<Tecnica> buildLista(Connection db, int riferimentoId, String riferimentoIdNomeTab) {
		ArrayList<Tecnica> lista = new ArrayList<Tecnica>();
		try
		{
			String select = "select * from public.get_tecniche_by_id_anagrafica(?, ?);"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, riferimentoId);
			pst.setString(2, riferimentoIdNomeTab);
			rs = pst.executeQuery();
			while (rs.next()){
				Tecnica tec = new Tecnica(rs); 
				lista.add(tec);
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


	public String getNome() {
		return nome;
	}


	public void setNome(String nome) {
		this.nome = nome;
	}


}
