package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.darkhorseventures.framework.beans.GenericBean;

public class TipoColturaParticella extends GenericBean {
	
	private int id ;
	private String descrizione ; 
	private String codice ; 

	public TipoColturaParticella() {
		// TODO Auto-generated constructor stub
	}

	
	
	public TipoColturaParticella(ResultSet rs) throws SQLException {
	buildRecord(rs);
	}



	private void buildRecord(ResultSet rs) throws SQLException {
		this.id = rs.getInt("id");
		this.descrizione = rs.getString("descrizione");
		this.codice = rs.getString("codice");
		}



	
	
	public static ArrayList<TipoColturaParticella> buildLista(Connection db) {
		ArrayList<TipoColturaParticella> lista = new ArrayList<TipoColturaParticella>();
		try
		{
			String select = "select * from get_tipo_coltura_particella()"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			rs = pst.executeQuery();
			while (rs.next()){
				TipoColturaParticella c = new TipoColturaParticella(rs);
				lista.add(c);
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



	public String getDescrizione() {
		return descrizione;
	}



	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}



	public String getCodice() {
		return codice;
	}



	public void setCodice(String codice) {
		this.codice = codice;
	}
	
	


	

}
