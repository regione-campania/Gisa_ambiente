package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;

import com.darkhorseventures.framework.beans.GenericBean;

public class TipoVerifica extends GenericBean {
	
	private int code ;
	private String tipoVerifica ; 
	private boolean gestione_altro ;
	
	public TipoVerifica() {
		// TODO Auto-generated constructor stub
	}

	
	
	public TipoVerifica(ResultSet rs) throws SQLException {
	buildRecord(rs);
	}



	private void buildRecord(ResultSet rs) throws SQLException {
		this.code = rs.getInt("code");
		this.tipoVerifica = rs.getString("tipo_verifica");
		this.gestione_altro = rs.getBoolean("gestione_altro");
		}



	
	
//	public static ArrayList<TipoVerifica> buildLista(Connection db, int tecnicaId) {
//		ArrayList<TipoVerifica> lista = new ArrayList<TipoVerifica>();
//		try
//		{
//			String select = "select * from get_tipi_verifica()"; 
//			PreparedStatement pst = null ;
//			ResultSet rs = null;
//			pst = db.prepareStatement(select);
//			rs = pst.executeQuery();
//			while (rs.next()){
//				TipoVerifica tipoVerifica = new TipoVerifica(rs);
//				lista.add(tipoVerifica);
//			}
//		}
//		catch(SQLException e)
//		{	e.printStackTrace();
//		}
//		return lista;
//	}
	
	public static ArrayList<TipoVerifica> buildListaByMatrici(Connection db, int[] matrici) {
		
		String listaMatrici = Arrays.toString(matrici);
		listaMatrici = listaMatrici.replace("[", "{").replace("]", "}");
		
		ArrayList<TipoVerifica> lista = new ArrayList<TipoVerifica>();
		try
		{
			String select = "select * from get_tipi_verifica(?)"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setString(1, listaMatrici);
			rs = pst.executeQuery();
			while (rs.next()){
				TipoVerifica tipoVerifica = new TipoVerifica(rs);
				lista.add(tipoVerifica);
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



	public String getTipoVerifica() {
		return tipoVerifica;
	}



	public void setTipoVerifica(String tipoVerifica) {
		this.tipoVerifica = tipoVerifica;
	}



	public boolean isGestione_altro() {
		return gestione_altro;
	}



	public void setGestione_altro(boolean gestione_altro) {
		this.gestione_altro = gestione_altro;
	}



	

}
