package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.darkhorseventures.framework.beans.GenericBean;

public class Matrice extends GenericBean {
	
	private int code ;
	private String matrice ; 
	
	public Matrice() {
		// TODO Auto-generated constructor stub
	}

	
	
	public Matrice(ResultSet rs) throws SQLException {
	buildRecord(rs);
	}



	private void buildRecord(ResultSet rs) throws SQLException {
		this.code = rs.getInt("code");
		this.matrice = rs.getString("matrice");
		}



	
	
	public static ArrayList<Matrice> buildLista(Connection db, int riferimentoId, String riferimentoIdNomeTab) {
		ArrayList<Matrice> lista = new ArrayList<Matrice>();
		try
		{
			String select = "select * from get_anagrafica_matrici(?, ?)"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, riferimentoId);
			pst.setString(2, riferimentoIdNomeTab);
			rs = pst.executeQuery();
			while (rs.next()){
				Matrice matrice = new Matrice(rs);
				lista.add(matrice);
			}
		}
		catch(SQLException e)
		{	e.printStackTrace();
		}
		return lista;
	}
	
	public static ArrayList<Matrice> buildListaCampionamentoParticella(Connection db) {
		ArrayList<Matrice> lista = new ArrayList<Matrice>();
		try
		{
			String select = "select * from get_matrici(?)"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setString(1, "2,10");
			rs = pst.executeQuery();
			while (rs.next()){
				Matrice matrice = new Matrice(rs);
				lista.add(matrice);
			}
		}
		catch(SQLException e)
		{	e.printStackTrace();
		}
		return lista;
	}



	public int getCode() {
		return code;
	}



	public void setCode(int code) {
		this.code = code;
	}



	public String getMatrice() {
		return matrice;
	}



	public void setMatrice(String matrice) {
		this.matrice = matrice;
	}



	

}
