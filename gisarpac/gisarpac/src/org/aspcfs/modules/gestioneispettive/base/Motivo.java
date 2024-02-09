package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.darkhorseventures.framework.beans.GenericBean;

public class Motivo extends GenericBean {
	
	private int code ;
	private String motivo ; 
	
	public Motivo() {
		// TODO Auto-generated constructor stub
	}

	
	
	public Motivo(ResultSet rs) throws SQLException {
	buildRecord(rs);
	}



	private void buildRecord(ResultSet rs) throws SQLException {
		this.code = rs.getInt("code");
		this.motivo = rs.getString("motivo");
		}



	
	
	public static ArrayList<Motivo> buildLista(Connection db, int tecnicaId) {
		ArrayList<Motivo> lista = new ArrayList<Motivo>();
		try
		{
			String select = "select * from get_motivi_giornata_ispettiva(?)";
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, tecnicaId);
			rs = pst.executeQuery();
			while (rs.next()){
				Motivo motivo = new Motivo(rs);
				lista.add(motivo);
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



	public String getMotivo() {
		return motivo;
	}



	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}



	

}
