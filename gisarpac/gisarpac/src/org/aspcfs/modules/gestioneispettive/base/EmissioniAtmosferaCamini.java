package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class EmissioniAtmosferaCamini {
	
	private int id = -1;
	private String codiceCamino = "";
	private String fasiLavorativa = "";
	private String inquinanti;
	private String sistemaAbbattimento;

	public EmissioniAtmosferaCamini() {
		// TODO Auto-generated constructor stub
	}


	public EmissioniAtmosferaCamini(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.id = rs.getInt("id");
		this.codiceCamino = rs.getString("codice_camino");
		this.fasiLavorativa = rs.getString("fasi_lavorativa");
		this.inquinanti = rs.getString("inquinanti");
		this.sistemaAbbattimento = rs.getString("sistema_abbattimento");
	}


	public static ArrayList<EmissioniAtmosferaCamini> buildLista(Connection db, int riferimentoId, String riferimentoIdNomeTab) {
		ArrayList<EmissioniAtmosferaCamini> lista = new ArrayList<EmissioniAtmosferaCamini>();
		try
		{
			String select = "select * from public.get_emissioni_atmosfera_camini(?, ?);"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, riferimentoId);
			pst.setString(2, riferimentoIdNomeTab);
			rs = pst.executeQuery();
			while (rs.next()){
				EmissioniAtmosferaCamini str = new EmissioniAtmosferaCamini(rs); 
				lista.add(str);
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


	public String getCodiceCamino() {
		return codiceCamino;
	}


	public void setCodiceCamino(String codiceCamino) {
		this.codiceCamino = codiceCamino;
	}


	public String getFasiLavorativa() {
		return fasiLavorativa;
	}


	public void setFasiLavorativa(String fasiLavorativa) {
		this.fasiLavorativa = fasiLavorativa;
	}


	public String getInquinanti() {
		return inquinanti;
	}


	public void setInquinanti(String inquinanti) {
		this.inquinanti = inquinanti;
	}


	public String getSistemaAbbattimento() {
		return sistemaAbbattimento;
	}


	public void setSistemaAbbattimento(String sistemaAbbattimento) {
		this.sistemaAbbattimento = sistemaAbbattimento;
	}


	
	

	


	


}
