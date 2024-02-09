package org.aspcfs.modules.dpat.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Vector;

import org.aspcfs.modules.base.SyncableList;

public class DpatAttribuzioneCompetenzeSezioneList extends Vector implements SyncableList {

	@Override
	public String getTableName() {
		// TODO Auto-generated method stub
		return null;
	}  

	@Override
	public String getUniqueField() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setLastAnchor(Timestamp arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setLastAnchor(String arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setNextAnchor(Timestamp arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setNextAnchor(String arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setSyncType(int arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setSyncType(String arg0) {
		// TODO Auto-generated method stub
		
	}
	
	
	public void buildList(Connection db,int anno)
	{
		PreparedStatement pst = null;
		ResultSet rs = null ;
		try
		{
			String sql = "select * from dpat_sezione where enabled  " +
					" AND  anno = ? order by id ";
			pst=db.prepareStatement(sql);
			pst.setInt(1, anno);
			rs = pst.executeQuery();
			while (rs.next()) 
			{
			
				DpatSezioneCompetenze sezione = new DpatSezioneCompetenze(rs);
				sezione.getElencoPiani().buildList(db, sezione.getId());
				this.add(sezione);
			}
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		 
	}
	  
	public void buildList2(Connection db,int idDpat)
	{
		PreparedStatement pst = null;
		ResultSet rs = null ;
		try
		{
			String sql = "select * from dpat_sezione where enabled " +
					" AND  id_dpat = ? order by id ";
			pst=db.prepareStatement(sql);
			pst.setInt(1, idDpat);
			rs = pst.executeQuery();
			while (rs.next()) 
			{
			
				DpatSezioneCompetenze sezione = new DpatSezioneCompetenze(rs);
				
	  		   	
				this.add(sezione);
			}
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
		
		
	}
	
	
	

	    
	
}
