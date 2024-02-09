package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.darkhorseventures.framework.beans.GenericBean;

public class TipoAttivita extends GenericBean {
	
	private int code ;
	private String tipo ;
	
	public TipoAttivita() {
		// TODO Auto-generated constructor stub
	}

	
	
	public TipoAttivita(ResultSet rs) throws SQLException {
	buildRecord(rs);
	}



	private void buildRecord(ResultSet rs) throws SQLException {
		this.code = rs.getInt("code");
		this.tipo = rs.getString("tipo");
		}



	
	
	public static ArrayList<TipoAttivita> buildLista(Connection db) {
		ArrayList<TipoAttivita> lista = new ArrayList<TipoAttivita>();
		try
		{
			String select = "select * from get_tipi_attivita()";
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			rs = pst.executeQuery();
			while (rs.next()){
				TipoAttivita tipo = new TipoAttivita(rs);
				lista.add(tipo);
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



	public String getTipo() {
		return tipo;
	}



	public void setTipo(String tipo) {
		this.tipo = tipo;
	}




	


	

}
