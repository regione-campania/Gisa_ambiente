package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.darkhorseventures.framework.beans.GenericBean;

public class MotivoCampionamentoParticella extends GenericBean {
	
	private int id ;
	private String descrizione ; 
	
	public MotivoCampionamentoParticella() {
		// TODO Auto-generated constructor stub
	}

	
	
	public MotivoCampionamentoParticella(ResultSet rs) throws SQLException {
	buildRecord(rs);
	}



	private void buildRecord(ResultSet rs) throws SQLException {
		this.id = rs.getInt("id");
		this.descrizione = rs.getString("descrizione");
		}



	
	
	public static ArrayList<MotivoCampionamentoParticella> buildLista(Connection db, int idAreaParticella) {
		ArrayList<MotivoCampionamentoParticella> lista = new ArrayList<MotivoCampionamentoParticella>();
		try
		{
			String select = "select * from get_campionamento_particella(?)";
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, idAreaParticella);
			rs = pst.executeQuery();
			while (rs.next()){
				MotivoCampionamentoParticella motivo = new MotivoCampionamentoParticella(rs);
				lista.add(motivo);
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






	

}
