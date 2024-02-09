package org.aspcfs.modules.dpat2019.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class WrapperTuttiModelli {

	public ArrayList<DpatWrapperSezioniNewBeanAbstract > modelliNonTemplates = new ArrayList<DpatWrapperSezioniNewBeanAbstract >();  /*qui quelli senza nodi in stato 1*/
	public ArrayList<DpatWrapperSezioniNewBeanAbstract > modelliTemplates = new ArrayList<DpatWrapperSezioniNewBeanAbstract >();
	
	public WrapperTuttiModelli() {}
	public WrapperTuttiModelli(Connection db)
	{
		PreparedStatement pst = null;
		ResultSet rs = null;
		try
		{
			/*prendo tutti quelli che non hanno nodi a 1 (quelli non precong, cioe' i non templates) */
			System.out.println("DPAT WRAPPER TUTTI MODELLI : INDIVIDUO QUELLI CHE NON HANNO NODI IN STATO 1 E CHE QUINDI SONO STATI CONGELATI");
			pst = db.prepareStatement("select distinct anno from dpat_sez_new where data_scadenza is null and stato != 1 order by anno desc");
			rs = pst.executeQuery();
			while(rs.next())
			{
				Integer anno = rs.getInt(1);
				DpatWrapperSezioniNewBeanAbstract<DpatSezioneNewBean>  toAdd = new DpatWrapperSezioniBean(anno, db, true,false);
				System.out.println("TROVATO MODELLO CONGELATO PER ANNO "+anno);
				modelliNonTemplates.add(toAdd);
			}
			/*e ora faccio lo stesso per i templates, cioe' quelli in precongelamento */
			pst.close();
			rs.close();
			System.out.println("DPAT WRAPPER TUTTI MODELLI : INDIVIDUO QUELLI CHE HANNO TUTTI NODI IN STATO 1 E CHE QUINDI NON SONO STATI CONGELATI");
			pst = db.prepareStatement("select distinct anno from dpat_sez_new where data_scadenza is null and stato = 1 order by anno desc");
			rs = pst.executeQuery();
			while(rs.next())
			{
				Integer anno = rs.getInt("anno");
				DpatWrapperSezioniNewBeanAbstract<DpatSezioneNewBeanPreCong> toAdd = new DpatWrapperSezioniBeanPreCong(anno, db, true, false);
				System.out.println("TROVATO MODELLO NON CONGELATO (PRECONG, TEMPLATE) PER ANNO "+anno );
				modelliTemplates.add(toAdd);
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
	}
	
	public static void creaNuovoTemplate(Connection db, int anno) throws Exception
	{
		PreparedStatement pst = null;
		ResultSet rs = null;
		try
		{
			pst = db.prepareStatement("delete from dpat_indicatore_new where  stato = 1");
			pst.executeUpdate();
			pst.close();
			
			pst = db.prepareStatement("delete from dpat_piano_attivita_new where  stato = 1");
			pst.executeUpdate();
			pst.close();
			
			pst = db.prepareStatement("delete from dpat_sez_new where  stato = 1");
			pst.executeUpdate();
			pst.close();
			
			pst = db.prepareStatement("select * from  duplica_modello_tostato1(?)");
			
			pst.setInt(1, anno); 
			rs = pst.executeQuery();
		}
		catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
			try{pst.close();} catch(Exception ex) {}
			try{rs.close();} catch(Exception ex) {}
		}
	}
	public static void congela(Connection db, int anno) throws Exception
	{
		PreparedStatement pst= null;
		try
		{
			pst = db.prepareStatement("select * from congela_modello(?)");
			pst.setInt(1, anno);
			pst.executeQuery();
			
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			try{ pst.close(); }catch(Exception ex){}
		}
		
	}
	
}
