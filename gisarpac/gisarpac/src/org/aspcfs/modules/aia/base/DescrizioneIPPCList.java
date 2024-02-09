package org.aspcfs.modules.aia.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Vector;

import org.aspcfs.modules.base.SyncableList;

public class DescrizioneIPPCList extends Vector implements SyncableList{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer idStabilimento;

	
	
	
	
	
	
	
	
	
	
	public void buildList(Connection db) throws SQLException {
		PreparedStatement pst = null;

		ResultSet rs = queryList(db, pst);
		while (rs.next()) {

			DescrizioneIPPC thisIter = this.getObject(rs);
			this.add(thisIter);

		}

		rs.close();
		if (pst != null) {
			pst.close();
		}
		//  buildResources(db);
	}
	
	
	public ResultSet queryList(Connection db, PreparedStatement pst) throws SQLException {
		ResultSet rs = null;
		int items = -1;

		StringBuffer sqlSelect = new StringBuffer();
		StringBuffer sqlCount = new StringBuffer();
		StringBuffer sqlFilter = new StringBuffer();
		StringBuffer sqlOrder = new StringBuffer();

		
		return rs;
	} 

	
	
	
	public Integer getIdStabilimento() {
		return idStabilimento;
	}

	public void setIdStabilimento(Integer idStabilimento) {
		this.idStabilimento = idStabilimento;
	}
	
	
	public DescrizioneIPPC getObject(ResultSet rs) throws SQLException {

		DescrizioneIPPC ippc = new DescrizioneIPPC(rs) ;
		return ippc ;

	}


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
	
	
}
