package org.aspcfs.modules.dpat2019.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Vector;

import org.aspcfs.modules.base.SyncableList;

public class DpatAttribuzioneCompetenzePianiList extends Vector implements SyncableList {

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
	
	
	
	public void buildList(Connection db,int idSezione)
	{
		PreparedStatement pst = null;
		ResultSet rs = null ;
		try
		{
			String sql = "select * from dpat_piano where enabled and id_sezione = ? order by ordinamento ";
					//+ "order by level" ;
			pst=db.prepareStatement(sql);
			pst.setInt(1, idSezione);
			rs = pst.executeQuery();
			while (rs.next()) 
			{
			
				DpatPianoCompetenze piano = new DpatPianoCompetenze(rs);
				piano.getElencoAttivita().buildList(db, piano.getId());
				
				this.add(piano);
			}
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
		
		
	}
	
	

	
	
}
