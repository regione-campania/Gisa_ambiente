package org.aspcfs.modules.vigilanza.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.darkhorseventures.framework.beans.GenericBean;

public class Qualifica extends GenericBean {

	private int code = -1;
	private String nome = null;
	private boolean inDpat = false;
	private boolean inNucleoIspettivo = false;
	private boolean viewLista = false;


	
	
	public int getCode() {
		return code;
	}


	public void setCode(int code) {
		this.code = code;
	}


	public String getNome() {
		return nome;
	}


	public void setNome(String nome) {
		this.nome = nome;
	}


	public boolean isInDpat() {
		return inDpat;
	}


	public void setInDpat(boolean inDpat) {
		this.inDpat = inDpat;
	}


	public boolean isInNucleoIspettivo() {
		return inNucleoIspettivo;
	}


	public void setInNucleoIspettivo(boolean inNucleoIspettivo) {
		this.inNucleoIspettivo = inNucleoIspettivo;
	}


	public boolean isViewLista() {
		return viewLista;
	}


	public void setViewLista(boolean viewLista) {
		this.viewLista = viewLista;
	}


	public Qualifica(Connection db, int id )
	{
		try
		{
			String select = "select * from lookup_qualifiche where code = ?";
			PreparedStatement pst = null ;
			ResultSet rs = null;
			pst = db.prepareStatement(select);
			pst.setInt(1, id);
			rs = pst.executeQuery();
			if (rs.next()){
				buildRecord(rs);
			}
	}
		catch(SQLException e)
		{	e.printStackTrace();
		}

	}


	public void buildRecord(ResultSet rs) throws SQLException
	{
		code =rs.getInt("code");
		nome =rs.getString("description");
		inDpat =rs.getBoolean("in_dpat");
		inNucleoIspettivo =rs.getBoolean("in_nucleo_ispettivo");
		viewLista =rs.getBoolean("view_lista_utenti_nucleo_ispettivo");
	}
	
}
