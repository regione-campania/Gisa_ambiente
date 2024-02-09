package org.aspcfs.modules.dpat.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Vector;

import org.aspcfs.modules.base.SyncableList;

public class DpatAttribuzioneCompetenzeIndicatoriList extends Vector implements SyncableList {

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
	
	
	
	public void buildList(Connection db,int idAttivita)
	{
		PreparedStatement pst = null;
		ResultSet rs = null ;
		try
		{
			String sql = "select * from dpat_indicatore where enabled and id_attivita = ? order by ordinamento " ;
			pst=db.prepareStatement(sql);
			pst.setInt(1, idAttivita);
			rs = pst.executeQuery();
			while (rs.next()) 
			{
			
				DpatIndicatoreCompetenze indicatore = new DpatIndicatoreCompetenze(rs);
				this.add(indicatore);
			}
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
		
		
	}
	
	

	
	
}
