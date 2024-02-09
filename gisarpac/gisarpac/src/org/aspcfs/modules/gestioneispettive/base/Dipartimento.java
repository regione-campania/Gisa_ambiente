package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.darkhorseventures.framework.beans.GenericBean;

public class Dipartimento extends GenericBean {

	private String nome;
	private int id;

	public Dipartimento() { 

	}

	public Dipartimento(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException{

		this.id = rs.getInt("id");
		this.nome = rs.getString("nome");
	}

	public static ArrayList<Dipartimento> buildLista(Connection db, int riferimentoId, String riferimentoIdNomeTab, int idUtente) {
		ArrayList<Dipartimento> lista = new ArrayList<Dipartimento>();
		try
		{
			String select = "select * from public.get_dipartimento(?, ?, ?);"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, riferimentoId);
			pst.setString(2, riferimentoIdNomeTab);
			pst.setInt(3, idUtente);
			rs = pst.executeQuery();
			while (rs.next()){
				Dipartimento dipartimento = new Dipartimento(rs);
				lista.add(dipartimento);
			}
		}
		catch(SQLException e)
		{	e.printStackTrace();
		}
		return lista;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}


}
