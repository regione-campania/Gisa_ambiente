package org.aspcfs.modules.noscia.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.aspcfs.modules.gestioneanagrafica.base.Indirizzo;
import org.aspcfs.utils.Bean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class IndirizzoDAO extends GenericDAO
{
	
	private static final Logger logger = LoggerFactory.getLogger( IndirizzoDAO.class );
	
	
	//Campi che servono per l'inserimento
	public Indirizzo indirizzo;
	
	public IndirizzoDAO(ResultSet rs) throws SQLException 
	{
		Bean.populate(this, rs);
	}
	
		
	public IndirizzoDAO(Indirizzo indirizzo) 
	{
		this.indirizzo=indirizzo;
	}

	public ArrayList<Indirizzo> getItems(Connection conn) throws SQLException 
	{

	  	String sql = " select * from public.get_indirizzo(?, ?, ?)";
		
		PreparedStatement st = conn.prepareStatement(sql);
		st.setObject(1, indirizzo.getIdComune());
		st.setObject(2, indirizzo.getIdToponimo());
		st.setString(3, indirizzo.getVia());
		
		ResultSet rs = st.executeQuery();
		ArrayList<Indirizzo> indirizzi = new ArrayList<Indirizzo>();
		
		while(rs.next())
		{
			indirizzi.add(new Indirizzo(rs));
		}
		
		return indirizzi;
	}
	
	
	public ArrayList<Indirizzo> getIndirizzoNapoli(Connection conn) throws SQLException 
	{

	  	String sql = " select * from public.get_indirizzo_napoli_new(?, ?)";
		
		PreparedStatement st = conn.prepareStatement(sql);
		st.setObject(1, indirizzo.getIdToponimo());
		st.setString(2, indirizzo.getVia());
		
		ResultSet rs = st.executeQuery();
		ArrayList<Indirizzo> indirizzi = new ArrayList<Indirizzo>();
		
		while(rs.next())
		{
			indirizzi.add(new Indirizzo(rs));
		}
		
		return indirizzi;
	}
	

	public boolean exist(Connection conn) throws SQLException 
	{
		return !getItems(conn).isEmpty();
	}
	
}
