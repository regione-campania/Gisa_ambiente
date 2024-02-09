package org.aspcfs.modules.dpat2019.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class DpatSezioneNewBeanPreCong extends DpatSezioneNewBeanInterface<DpatPianoAttivitaNewBeanPreCong> {
	
	
	public  ArrayList<DpatSezioneNewBeanPreCong> buildList(Connection conn, ResultSet rs,boolean nonscaduti,boolean withChilds) throws Exception
	{
		ArrayList<DpatSezioneNewBeanPreCong> toRet = new ArrayList<DpatSezioneNewBeanPreCong>();
		
		while(rs.next())
		{
			toRet.add(build(conn,rs, nonscaduti,withChilds));
		}
		
		return toRet;
	}
	
	public  DpatSezioneNewBeanPreCong buildByOid(Connection conn, Integer oid, boolean nonscaduti,boolean withChilds) throws Exception
	{
		PreparedStatement pst = null;
		ResultSet rs = null;
		DpatSezioneNewBeanPreCong toRet = null;
		
		try
		{
			pst = conn.prepareStatement("select * from dpat_sez_new where id = ? "+(nonscaduti ? " and data_scadenza is null" : ""));
			pst.setInt(1, oid.intValue());
			rs = pst.executeQuery();
			if(rs.next())
			{
				toRet = build(conn,rs,nonscaduti,withChilds);
			}
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			try{pst.close();}catch(Exception ex){}
			try{rs.close();}catch(Exception ex){}
		}
		return toRet;
	}
	
	public  DpatSezioneNewBeanPreCong build(Connection conn, ResultSet rs, boolean nonscaduti, boolean withChilds) throws Exception 
	{
		PreparedStatement pst = null;
		ResultSet rs1 = null;
		DpatSezioneNewBeanPreCong toRet = new DpatSezioneNewBeanPreCong();
		try
		{
			
			toRet.setOid(rs.getLong("id"));
			toRet.setCodiceRaggruppamento(rs.getInt("cod_raggruppamento"));
			toRet.setAnno(rs.getInt("anno"));
			toRet.setDescrizione(rs.getString("descrizione"));
			toRet.setOrdine(rs.getInt("ordinamento"));
			toRet.setScadenza(rs.getTimestamp("data_scadenza"));
			toRet.setColor(rs.getString("color"));
			
			pst = conn.prepareStatement("select * from dpat_piano_attivita_new where id_sezione = ? "+(nonscaduti ? " and data_scadenza is null": "")+" and stato = 1 order by ordinamento");
			pst.setInt(1, toRet.getOid().intValue());
			rs1 = pst.executeQuery();
			
			if(withChilds)
				toRet.setPianiAttivitaFigli(new DpatPianoAttivitaNewBeanPreCong().buildList(conn,rs1,nonscaduti,true));
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		finally
		{
			try{pst.close();}catch(Exception ex){}
			try{rs1.close();}catch(Exception ex){}
		}
		return toRet;
	}
	
	
}
