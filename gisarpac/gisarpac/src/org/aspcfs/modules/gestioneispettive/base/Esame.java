package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.darkhorseventures.framework.beans.GenericBean;

public class Esame extends GenericBean {
	
	private int code ;
	private String esame ; 
	
	public Esame() {
		// TODO Auto-generated constructor stub
	}

	
	
	public Esame(ResultSet rs) throws SQLException {
	buildRecord(rs);
	}



	private void buildRecord(ResultSet rs) throws SQLException {
		this.code = rs.getInt("code");
		this.esame = rs.getString("esame");
		}



	
	
	public static ArrayList<Esame> buildLista(Connection db, int tecnicaId) {
		ArrayList<Esame> lista = new ArrayList<Esame>();
		try
		{
			String select = "select * from get_esami_documentazione(?)";
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, tecnicaId);
			rs = pst.executeQuery();
			while (rs.next()){
				Esame esame = new Esame(rs);
				lista.add(esame);
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



	public String getEsame() {
		return esame;
	}



	public void setEsame(String esame) {
		this.esame = esame;
	}



	

}
