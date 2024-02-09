package org.aspcfs.modules.dpat2019.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class DpatWrapperSezioniBeanPreCong extends DpatWrapperSezioniNewBeanAbstract<DpatSezioneNewBeanPreCong >  {
	 
	
	public DpatWrapperSezioniBeanPreCong(int anno, Connection conn,boolean nonscaduti, boolean conFigli)
	{
		this.anno = anno;
		PreparedStatement pst = null;
		ResultSet rs = null;
		 

		try
		{
			pst = conn.prepareStatement("select * from dpat_sez_new where anno = ? "+(nonscaduti ? " and data_scadenza is null": "")+" and stato = 1 order by ordinamento,descrizione  ");
			pst.setInt(1, anno);
			rs = pst.executeQuery();
			
			setSezioni(new DpatSezioneNewBeanPreCong().buildList(conn, rs,nonscaduti,conFigli));
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
	}
	
	public DpatWrapperSezioniBeanPreCong(){}
	
	@Override
	public int getStatoDopoModifica(Connection db, int anno) throws Exception {
		/*per questi lo stato e' sempre 1*/
		return 1;
	}
	
	
	 
}
