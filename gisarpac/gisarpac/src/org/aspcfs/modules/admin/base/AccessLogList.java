/*
 *  Copyright(c) 2004 Concursive Corporation (http://www.concursive.com/) All
 *  rights reserved. This material cannot be distributed without written
 *  permission from Concursive Corporation. Permission to use, copy, and modify
 *  this material for internal use is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies. CONCURSIVE
 *  CORPORATION MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
 *  IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
 *  PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
 *  INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
 *  EVENT SHALL CONCURSIVE CORPORATION OR ANY OF ITS AFFILIATES BE LIABLE FOR
 *  ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
 *  DAMAGES RELATING TO THE SOFTWARE.
 */
package org.aspcfs.modules.admin.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;

import org.aspcfs.modules.base.Constants;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.web.PagedListInfo;

/**
 * Description of the Class
 *
 * @author chris
 * @version $Id: AccessLogList.java 24287 2007-12-09 11:28:24Z srinivasar@cybage.com $
 * @created November, 2002
 */
public class AccessLogList extends ArrayList {

  private PagedListInfo pagedListInfo = null;
  private int userId = -1;

  /**
   * Used by XML API
   */
  public final static String tableName = "access_log";
  /**
   * Used by XML API
   */
  public final static String uniqueField = "id";
  private java.sql.Timestamp lastAnchor = null;
  private java.sql.Timestamp nextAnchor = null;
  private int syncType = Constants.NO_SYNC;

  private java.sql.Timestamp enteredRangeStart = null;
  private java.sql.Timestamp enteredRangeEnd = null;


  /**
   * Constructor for the AccessLogList object
   */
  public AccessLogList() {
  }


  /**
   * Sets the pagedListInfo attribute of the AccessLogList object
   *
   * @param tmp The new pagedListInfo value
   */
  public void setPagedListInfo(PagedListInfo tmp) {
    this.pagedListInfo = tmp;
  }


  /**
   * Gets the pagedListInfo attribute of the AccessLogList object
   *
   * @return The pagedListInfo value
   */
  public PagedListInfo getPagedListInfo() {
    return pagedListInfo;
  }


  /**
   * Gets the userId attribute of the AccessLogList object
   *
   * @return The userId value
   */
  public int getUserId() {
    return userId;
  }


  /**
   * Sets the userId attribute of the AccessLogList object
   *
   * @param userId The new userId value
   */
  public void setUserId(int userId) {
    this.userId = userId;
  }


  /**
   * Sets the userId attribute of the AccessLogList object
   *
   * @param userId The new userId value
   */
  public void setUserId(String userId) {
    this.userId = Integer.parseInt(userId);
  }


  /**
   * Sets the enteredRangeStart attribute of the AccessLogList object
   *
   * @param tmp The new enteredRangeStart value
   */
  public void setEnteredRangeStart(java.sql.Timestamp tmp) {
    this.enteredRangeStart = tmp;
  }


  /**
   * Sets the enteredRangeEnd attribute of the AccessLogList object
   *
   * @param tmp The new enteredRangeEnd value
   */
  public void setEnteredRangeEnd(java.sql.Timestamp tmp) {
    this.enteredRangeEnd = tmp;
  }


  /**
   * Gets the tableName attribute of the AccessLogList object
   *
   * @return The tableName value
   */
  public String getTableName() {
    return tableName;
  }


  /**
   * Gets the uniqueField attribute of the AccessLogList object
   *
   * @return The uniqueField value
   */
  public String getUniqueField() {
    return uniqueField;
  }


  /**
   * Gets the lastAnchor attribute of the AccessLogList object
   *
   * @return The lastAnchor value
   */
  public java.sql.Timestamp getLastAnchor() {
    return lastAnchor;
  }


  /**
   * Gets the nextAnchor attribute of the AccessLogList object
   *
   * @return The nextAnchor value
   */
  public java.sql.Timestamp getNextAnchor() {
    return nextAnchor;
  }


  /**
   * Gets the syncType attribute of the AccessLogList object
   *
   * @return The syncType value
   */
  public int getSyncType() {
    return syncType;
  }


  /**
   * Sets the lastAnchor attribute of the AccessLogList object
   *
   * @param tmp The new lastAnchor value
   */
  public void setLastAnchor(java.sql.Timestamp tmp) {
    this.lastAnchor = tmp;
  }


  /**
   * Sets the nextAnchor attribute of the AccessLogList object
   *
   * @param tmp The new nextAnchor value
   */
  public void setNextAnchor(java.sql.Timestamp tmp) {
    this.nextAnchor = tmp;
  }


  /**
   * Sets the syncType attribute of the AccessLogList object
   *
   * @param tmp The new syncType value
   */
  public void setSyncType(int tmp) {
    this.syncType = tmp;
  }


  /**
   * Description of the Method
   *
   * @param db Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void buildList(Connection db) throws SQLException {

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
        "FROM access_log a " +
        "WHERE a.id > 0 ");

    createFilter(sqlFilter);

    if (pagedListInfo != null) {
      //Get the total number of records matching filter
      pst = db.prepareStatement(
          sqlCount.toString() +
          sqlFilter.toString());
      items = prepareFilter(pst);
      rs = pst.executeQuery();
      if (rs.next()) {
        int maxRecords = rs.getInt("recordcount");
        pagedListInfo.setMaxRecords(maxRecords);
      }
      rs.close();
      pst.close();

      //Determine the offset, based on the filter, for the first record to show
      if (!pagedListInfo.getCurrentLetter().equals("")) {
        pst = db.prepareStatement(
            sqlCount.toString() +
            sqlFilter.toString() +
            " AND  " + DatabaseUtils.toLowerCase(db) + "(a.username) < ? ");
        items = prepareFilter(pst);
        pst.setString(++items, pagedListInfo.getCurrentLetter().toLowerCase());
        rs = pst.executeQuery();
        if (rs.next()) {
          int offsetCount = rs.getInt("recordcount");
          pagedListInfo.setCurrentOffset(offsetCount);
        }
        rs.close();
        pst.close();
      }

      //Determine column to sort by
      pagedListInfo.setDefaultSort("a.entered", "desc");
      pagedListInfo.appendSqlTail(db, sqlOrder);
    } else {
      sqlOrder.append("ORDER BY a.entered desc ");
    }

    //Need to build a base SQL statement for returning records
    if (pagedListInfo != null) {
      pagedListInfo.appendSqlSelectHead(db, sqlSelect);
    } else {
      sqlSelect.append("SELECT ");
    }
    sqlSelect.append(
        "a.* " +
        "FROM access_log a " +
        "WHERE a.id > 0 ");
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

    int count = 0;
    while (rs.next()) {
      ++count;
      AccessLog thisAccessLog = new AccessLog(rs);
      this.add(thisAccessLog);
    }
    rs.close();
    pst.close();
  }


  /**
   * Description of the Method
   *
   * @param sqlFilter Description of the Parameter
   */
  private void createFilter(StringBuffer sqlFilter) {
    if (userId > -1) {
      sqlFilter.append(" AND  a.user_id = ? ");
    }
    if (enteredRangeStart != null) {
      sqlFilter.append(" AND  entered >= ? ");
    }
    if (enteredRangeEnd != null) {
      sqlFilter.append(" AND  entered <= ? ");
    }
  }


  /**
   * Description of the Method
   *
   * @param pst Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  private int prepareFilter(PreparedStatement pst) throws SQLException {
    int i = 0;
    if (userId > -1) {
      pst.setInt(++i, userId);
    }
    if (enteredRangeStart != null) {
      pst.setTimestamp(++i, enteredRangeStart);
    }
    if (enteredRangeEnd != null) {
      pst.setTimestamp(++i, enteredRangeEnd);
    }
    return i;
  }


  /**
   * Description of the Method
   *
   * @param db Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public int queryRecordCount(Connection db) throws SQLException {
    int recordCount = 0;
    StringBuffer sqlFilter = new StringBuffer();
    String sqlCount =
        "SELECT COUNT(*) AS recordcount " +
        "FROM access_log a " +
        "WHERE a.id > 0 ";
    createFilter(sqlFilter);
    PreparedStatement pst = db.prepareStatement(
        sqlCount + sqlFilter.toString());
    int items = prepareFilter(pst);
    ResultSet rs = pst.executeQuery();
    if (rs.next()) {
      recordCount = DatabaseUtils.getInt(rs, "recordcount", 0);
    }
    pst.close();
    rs.close();
    return recordCount;
  }


  /**
   * Description of the Method
   *
   * @param db Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public boolean delete(Connection db) throws SQLException {
    Iterator itr = this.iterator();
    while (itr.hasNext()) {
      AccessLog tmpAccessLog = (AccessLog) itr.next();
      tmpAccessLog.delete(db);
    }

    return true;
  }
}

