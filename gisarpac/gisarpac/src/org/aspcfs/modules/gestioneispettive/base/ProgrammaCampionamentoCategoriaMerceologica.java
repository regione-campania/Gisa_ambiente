package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.darkhorseventures.framework.beans.GenericBean;

public class ProgrammaCampionamentoCategoriaMerceologica extends GenericBean {
	
	private int code ;
	private String categoriaMerceologica ;
	private String nomeProgrammaCampionamento ;
	private String nomeProgrammaCampionamentoMacrocategoria ;
	
	public ProgrammaCampionamentoCategoriaMerceologica() {
		// TODO Auto-generated constructor stub
	}

	
	
	public ProgrammaCampionamentoCategoriaMerceologica(ResultSet rs) throws SQLException {
	buildRecord(rs);
	}



	private void buildRecord(ResultSet rs) throws SQLException {
		this.code = rs.getInt("code");
		this.categoriaMerceologica = rs.getString("categoria_merceologica");
		this.nomeProgrammaCampionamento  = rs.getString("nome_programma_campionamento");
		this.nomeProgrammaCampionamentoMacrocategoria = rs.getString("nome_programma_campionamento_macrocategoria");
	}

	public static ArrayList<ProgrammaCampionamentoCategoriaMerceologica> buildLista(Connection db) {
		ArrayList<ProgrammaCampionamentoCategoriaMerceologica> lista = new ArrayList<ProgrammaCampionamentoCategoriaMerceologica>();
		try
		{
			String select = "select * from get_programmi_campionamento_categorie_merceologiche()"; 
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			rs = pst.executeQuery();
			while (rs.next()){
				ProgrammaCampionamentoCategoriaMerceologica categoria = new ProgrammaCampionamentoCategoriaMerceologica(rs);
				lista.add(categoria);
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



	public String getCategoriaMerceologica() {
		return categoriaMerceologica;
	}



	public void setCategoriaMerceologica(String categoriaMerceologica) {
		this.categoriaMerceologica = categoriaMerceologica;
	}



	public String getNomeProgrammaCampionamento() {
		return nomeProgrammaCampionamento;
	}



	public void setNomeProgrammaCampionamento(String nomeProgrammaCampionamento) {
		this.nomeProgrammaCampionamento = nomeProgrammaCampionamento;
	}



	public String getNomeProgrammaCampionamentoMacrocategoria() {
		return nomeProgrammaCampionamentoMacrocategoria;
	}



	public void setNomeProgrammaCampionamentoMacrocategoria(String nomeProgrammaCampionamentoMacrocategoria) {
		this.nomeProgrammaCampionamentoMacrocategoria = nomeProgrammaCampionamentoMacrocategoria;
	}



	





	


	

}
