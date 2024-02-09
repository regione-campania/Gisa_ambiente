package org.aspcfs.modules.documents.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.aspcfs.utils.web.PagedListInfo;

import com.zeroio.iteam.base.FileItem;

public class FileItemList extends com.zeroio.iteam.base.FileItemList{
	
	
	public FileItem getFileiItem(ResultSet rs) throws SQLException
	{
		FileItem fileItem = new FileItem();
		fileItem.setId(rs.getInt("item_id"));
		fileItem.setModified(rs.getTimestamp("modified"));
		fileItem.setModifiedBy(rs.getInt("modifiedby"));
		fileItem.setEntered(rs.getTimestamp("entered"));
		fileItem.setEnteredBy(rs.getInt("enteredby"));
		fileItem.setFilename(rs.getString("filename"));
		fileItem.setFolderId(rs.getInt("folder_id"));
		fileItem.setLinkItemId(rs.getInt("link_item_id"));
		fileItem.setLinkModuleId(rs.getInt("link_module_id"));
		fileItem.setClientFilename(rs.getString("client_filename"));
		fileItem.setSubject(rs.getString("subject"));
		fileItem.setVersion(rs.getInt("version"));
		return fileItem ;
	
	}
	
	
	 /**
	   * Description of the Method
	   *
	   * @param db Description of Parameter
	   * @throws SQLException Description of Exception
	   */
	  public void buildList(Connection db) throws SQLException {
	    PagedListInfo pagedListInfo = super.getPagedListInfo() ;
		PreparedStatement pst = null;
	    ResultSet rs = null;
	    int items = -1;

	    StringBuffer sqlSelect = new StringBuffer();
	    StringBuffer sqlCount = new StringBuffer();
	    StringBuffer sqlFilter = new StringBuffer();
	    StringBuffer sqlOrder = new StringBuffer();

	    //Need to build a base SQL statement for counting records
	    sqlCount.append(
	        "SELECT COUNT(*) AS recordcount " +
	            "FROM project_files " +
	            "WHERE 1=1 and trashed_date is null ");
	    createFilter(sqlFilter, db);
	    if (super.getPagedListInfo() == null) {
	      pagedListInfo = new PagedListInfo();
	      pagedListInfo.setItemsPerPage(0);
	    }

	    //Get the total number of records matching filter
	    pst = db.prepareStatement(sqlCount.toString() + sqlFilter.toString());
	    items = prepareFilter(pst);
	    rs = pst.executeQuery();
	    if (rs.next()) {
	      int maxRecords = rs.getInt("recordcount");
	      pagedListInfo.setMaxRecords(maxRecords);
	    }
	    rs.close();
	    pst.close();

	  

	    //Determine column to sort by
	    pagedListInfo.setDefaultSort("modified", null)
	    ;
	    pagedListInfo.setSortOrder("desc");
	    pagedListInfo.appendSqlTail(db, sqlOrder);

	    //Need to build a base SQL statement for returning records
	    pagedListInfo.appendSqlSelectHead(db, sqlSelect);
	    sqlSelect.append(
	        "ds.* " +
	            "FROM project_files ds where 1 = 1 and trashed_date is null " );

	    pst = db.prepareStatement(
	        sqlSelect.toString() + sqlFilter.toString() + sqlOrder.toString());
	    items = prepareFilter(pst);
	    
	    if (pagedListInfo != null) {
	      pagedListInfo.doManualOffset(db, pst);
	    }
	    rs = pst.executeQuery();
	    if (pagedListInfo != null) {
	      pagedListInfo.doManualOffset(db, rs);
	    }
	    while (rs.next()) {
	    	
	      this.add(getFileiItem(rs));
	    }
	    rs.close();
	    pst.close();
	  }


	  /**
	   * Description of the Method
	   *
	   * @param sqlFilter Description of Parameter
	   * @param db        Description of the Parameter
	   */
	  private void createFilter(StringBuffer sqlFilter, Connection db) {
	   
		  if(super.getLinkItemId()>0)
		  {
			  sqlFilter.append(" and link_item_id = ? ");
		  }
		  
		  if(super.getFolderId()>0)
		  {
			  sqlFilter.append(" and folder_id = ? ");
		  }
		  else
		  {
			  sqlFilter.append(" and folder_id is null ");
		  }
	  }


	  /**
	   * Description of the Method
	   *
	   * @param pst Description of Parameter
	   * @return Description of the Returned Value
	   * @throws SQLException Description of Exception
	   */
	  private int prepareFilter(PreparedStatement pst) throws SQLException {
	    
		  int i = 0 ;
		  if(super.getLinkItemId()>0)
		  {
			pst.setInt(++i, super.getLinkItemId());
		  }
		  
		  if(super.getFolderId()>0)
		  {
			  pst.setInt(++i, super.getFolderId());
		  }
		  return i ;
	  }



}
