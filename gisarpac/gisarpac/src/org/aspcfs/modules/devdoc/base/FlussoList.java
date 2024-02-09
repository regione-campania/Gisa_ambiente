package org.aspcfs.modules.devdoc.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

public class FlussoList  extends Vector  {

	
	public void buildList(Connection db) throws SQLException{
		
		PreparedStatement pst = null;
		ResultSet rs = null;
		
		
		String sql = "select * from sviluppo_flussi WHERE data_cancellazione is null order by data DESC ";
		
		pst = db.prepareStatement(sql);
		rs = pst.executeQuery();
		
		while (rs.next()){
			Flusso flu = new Flusso(rs, db);
			this.add(flu);
		}
		
	}
		
	
	

}
