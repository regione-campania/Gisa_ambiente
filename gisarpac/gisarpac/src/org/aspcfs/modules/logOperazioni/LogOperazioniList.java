package org.aspcfs.modules.logOperazioni;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Vector;

import org.apache.log4j.Logger;
import org.aspcfs.modules.admin.base.UserOperation;
import org.aspcfs.modules.base.SyncableList;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.web.PagedListInfo;

public class LogOperazioniList extends Vector implements SyncableList {
	private static Logger log = Logger.getLogger(LogOperazioni.class);
	protected PagedListInfo pagedListInfo = null;
	protected Boolean minerOnly = null;
	protected int typeId = 0;
	protected int stageId = -1;
	protected String username;
	protected Timestamp dateStart;
	protected Timestamp dateEnd;
	
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	
	public void setDateEnd(String tmp) {
	    this.dateEnd = DatabaseUtils.parseDateToTimestamp(tmp);
	}

	public Timestamp getDateEnd() {
		return dateEnd;
	}

	public void setDateEnd(Timestamp dateEnd) {
		this.dateEnd = dateEnd;
	}
	

	public Timestamp getDateStart() {
		return dateStart;
	}
	
	public void setDateStart(String tmp) {
	    this.dateStart = DatabaseUtils.parseDateToTimestamp(tmp);
	}

	public void setDateStart(Timestamp dateStart) {
		this.dateStart = dateStart;
	}
		
	public void buildList(Connection db,String suff) throws SQLException {
		PreparedStatement pst = null;
		ResultSet rs = queryListOperazioni(db, pst, suff);
		
	    while (rs.next()) {
	    	UserOperation o = this.getObject(rs);
	        this.add(o);
	    }
	
		rs.close();
		if (pst != null) {
			pst.close();
		}
		    
	}  
	
	public UserOperation getObject(ResultSet rs) throws SQLException {
		UserOperation o = new UserOperation();
		o.buildRecord(rs, o);
		return o;
	}
	
	protected void createFilter(Connection db, StringBuffer sqlFilter) {
	    if (sqlFilter == null) {
	      sqlFilter = new StringBuffer();
	    }
	    if (! "".equals(username)){
	    	sqlFilter.append(" and username ilike ? ");
	    }
	    if (dateStart!=null){
	    	sqlFilter.append(" and data::date >= ? ");
	    }

	    if (dateEnd!=null){
	    	sqlFilter.append(" and data::date <= ? ");
	    }
	   
	}
	
	protected int prepareFilter(PreparedStatement pst) throws SQLException {
	    int i = 0;
	    if (! "".equals(username)){
	    	pst.setString(++i, username.replaceAll("%", ""));
	    }
	    if (dateStart!=null){
	    	pst.setTimestamp(++i, dateStart);
	    }

	    if (dateEnd!=null){
	    	String time = "23:59:59";
	    	Timestamp timestamp = Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd ").format(dateEnd).concat(time));
	    	pst.setTimestamp(++i, timestamp);
	    }
	    return i ;
	}
	
	public ResultSet queryListOperazioni(Connection db, PreparedStatement pst, String suff) throws SQLException {
		ResultSet rs = null;
		int items = -1;

		StringBuffer sqlSelect = new StringBuffer();
		StringBuffer sqlCount = new StringBuffer();
		StringBuffer sqlFilter = new StringBuffer();
		StringBuffer sqlOrder = new StringBuffer();

		// Need to build a base SQL statement for counting records
   
		sqlCount.append("SELECT COUNT(*) AS recordcount FROM gisa"+suff+"_storico_operazioni_utenti_view where 1 = 1 ");
		createFilter(db, sqlFilter);

		if (pagedListInfo != null) {
			pst = db.prepareStatement(sqlCount.toString() + sqlFilter.toString());
			items = prepareFilter(pst);
			rs = pst.executeQuery();
			if (rs.next()) {
				int maxRecords = rs.getInt("recordcount");
				pagedListInfo.setMaxRecords(maxRecords);
			}
			rs.close();
			pst.close();

			pagedListInfo.setSortOrder(" DESC ");
			pagedListInfo.setColumnToSortBy(" data ");
			pagedListInfo.appendSqlTail(db, sqlOrder);

		} else {
			sqlOrder.append("ORDER BY data DESC");
		}

		sqlSelect.append("select * from gisa"+suff+"_storico_operazioni_utenti_view where 1=1 ");
		
		pst = db.prepareStatement(sqlSelect.toString() + sqlFilter.toString() + sqlOrder.toString());
		items = prepareFilter(pst);

		if (pagedListInfo != null) {
			pagedListInfo.doManualOffset(db, pst);
		} 
		rs = DatabaseUtils.executeQuery(db, pst, pagedListInfo);
		if (pagedListInfo != null) {
			pagedListInfo.doManualOffset(db, rs);
		}
		return rs;
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
	
	public void setPagedListInfo(PagedListInfo tmp) {
		this.pagedListInfo = tmp;
	}
	
	public PagedListInfo getPagedListInfo() {
		return pagedListInfo;
	}
	
	public void setStageId(int stageId) {
		this.stageId = stageId;
	}

	public void setStageId(String tmp) {
		if (tmp != null) {
			this.stageId = Integer.parseInt(tmp);
		} else {
			this.stageId = -1;
		}
	}

	public Boolean getMinerOnly() {
		return minerOnly;
	}

	public void setMinerOnly(Boolean minerOnly) {
		this.minerOnly = minerOnly;
	}

	public int getTypeId() {
		return typeId;
	}

	public void setTypeId(int typeId) {
		this.typeId = typeId;
	}

}

