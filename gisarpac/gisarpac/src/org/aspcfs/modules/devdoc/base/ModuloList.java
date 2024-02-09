package org.aspcfs.modules.devdoc.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

public class ModuloList  extends Vector  {

	
	public void buildList(Connection db, int idFlusso) throws SQLException{
		
		PreparedStatement pst = null;
		ResultSet rs = null;
		
		
		String sql = "select * from sviluppo_moduli WHERE data_cancellazione is null and id_flusso = ? order by data DESC ";
		
		pst = db.prepareStatement(sql);
		pst.setInt(1, idFlusso);
		rs = pst.executeQuery();
		
		while (rs.next()){
			Modulo mod = new Modulo(rs);
			this.add(mod);
		}
		
	}
		
	
	

}
