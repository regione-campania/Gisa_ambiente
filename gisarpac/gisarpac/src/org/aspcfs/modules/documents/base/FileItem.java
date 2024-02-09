package org.aspcfs.modules.documents.base;

import java.sql.Connection;
import java.sql.SQLException;

public class FileItem  extends com.zeroio.iteam.base.FileItem{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public FileItem (Connection db , int id , int type, int val) throws SQLException
	{
		super(db,id,type,val);
	}
	
	public void delete(Connection db,int modifiedby)
	{
		try
		{
			java.sql.PreparedStatement pst = db.prepareStatement("update project_files set trashed_date = current_date ,modifiedby = ? where item_id = ?");
			pst.setInt(1, modifiedby);
			pst.setInt(2, super.getId());
			pst.execute();
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
	}

}
