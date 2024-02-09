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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;

import org.aspcfs.modules.base.Constants;
import org.aspcfs.modules.base.SyncableList;
import org.aspcfs.utils.DatabaseUtils;

/**
 * Description of the Class
 *
 * @author Mathur
 * @version $Id: RolePermissionList.java 24287 2007-12-09 11:28:24Z srinivasar@cybage.com $
 * @created January 13, 2003
 */
public class RolePermissionList extends Hashtable implements SyncableList {

  private static final long serialVersionUID = -970518793145247635L;

  public final static String tableName = "role_permission";
  public final static String uniqueField = "id";
  protected java.sql.Timestamp lastAnchor = null;
  protected java.sql.Timestamp nextAnchor = null;
  protected int syncType = Constants.NO_SYNC;

  private int roleId = -1;
  private int enabledState = Constants.TRUE;


  /**
   * Constructor for the RolePermissionList object
   */
  public RolePermissionList() {
  }

  /**
   * Description of the Method
   *
   * @param rs
   * @return
   * @throws SQLException Description of the Returned Value
   */
  public static RolePermission getObject(ResultSet rs) throws SQLException {
    RolePermission rp = new RolePermission(rs);
    return rp;
  }

  /**
   * Constructor for the RolePermissionList object
   *
   * @param db     Description of the Parameter
   * @param roleId Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public RolePermissionList(Connection db, int roleId,String suffisso) throws SQLException {
    this.roleId = roleId;
    buildCombinedList(db,suffisso);
  }


  /**
   * Constructor for the RolePermissionList object
   *
   * @param request Description of the Parameter
   */
  public RolePermissionList(HttpServletRequest request) {
    int i = 0;
    while (request.getParameter("permission" + (++i) + "id") != null) {
      Permission thisPermission = new Permission();
      thisPermission.buildRecord(request, i);
      this.put("permission" + i, thisPermission);
    }
  }

  /* (non-Javadoc)
   * @see org.aspcfs.modules.base.SyncableList#getTableName()
   */
  public String getTableName() {
    return tableName;
  }

  /* (non-Javadoc)
   * @see org.aspcfs.modules.base.SyncableList#getUniqueField()
   */
  public String getUniqueField() {
    return uniqueField;
  }

  /* (non-Javadoc)
   * @see org.aspcfs.modules.base.SyncableList#setLastAnchor(java.sql.Timestamp)
   */
  public void setLastAnchor(Timestamp lastAnchor) {
    this.lastAnchor = lastAnchor;
  }

  /* (non-Javadoc)
   * @see org.aspcfs.modules.base.SyncableList#setLastAnchor(java.lang.String)
   */
  public void setLastAnchor(String lastAnchor) {
    this.lastAnchor = java.sql.Timestamp.valueOf(lastAnchor);
  }

  /* (non-Javadoc)
   * @see org.aspcfs.modules.base.SyncableList#setNextAnchor(java.sql.Timestamp)
   */
  public void setNextAnchor(Timestamp nextAnchor) {
    this.nextAnchor = nextAnchor;
  }

  /* (non-Javadoc)
   * @see org.aspcfs.modules.base.SyncableList#setNextAnchor(java.lang.String)
   */
  public void setNextAnchor(String nextAnchor) {
    this.nextAnchor = java.sql.Timestamp.valueOf(nextAnchor);
  }

  /* (non-Javadoc)
   * @see org.aspcfs.modules.base.SyncableList#setSyncType(int)
   */
  public void setSyncType(int syncType) {
    this.syncType = syncType;
  }

  /* (non-Javadoc)
   * @see org.aspcfs.modules.base.SyncableList#setSyncType(String)
   */
  public void setSyncType(String syncType) {
    this.syncType = Integer.parseInt(syncType);
  }
  
  /**
   * Sets the enabledState attribute of the RolePermissionList object
   *
   * @param tmp The new enabledState value
   */
  public void setEnabledState(int tmp) {
    this.enabledState = tmp;
  }


  /**
   * Gets the enabledState attribute of the RolePermissionList object
   *
   * @return The enabledState value
   */
  public int getEnabledState() {
    return enabledState;
  }


  /**
   * Description of the Method
   *
   * @param db Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void buildCombinedList(Connection db,String suffisso) throws SQLException {
    PreparedStatement pst = null;
    ResultSet rs = null;

    StringBuffer sqlSelect = new StringBuffer();
    StringBuffer sqlFilter = new StringBuffer();
    StringBuffer sqlOrder = new StringBuffer();

    //Need to build a base SQL statement for returning records
    sqlSelect.append(
        "SELECT p.*, c.category, role_add, role_view, role_edit, role_delete" +
        "" +
        " FROM permission"+ suffisso+" p, permission_category"+ suffisso+" c, role_permission"+ suffisso+" r" +
        " WHERE p.category_id = c.category_id" +
        " AND p.permission_id = r.permission_id ");
    sqlOrder.append("ORDER BY r.role_id, c." + DatabaseUtils.addQuotes(db, "level") + ", p." + DatabaseUtils.addQuotes(db, "level") + " ");
    createFilter(sqlFilter);
    pst = db.prepareStatement(
        sqlSelect.toString() + sqlFilter.toString() + sqlOrder.toString());
    prepareFilter(pst);
    rs = pst.executeQuery();
    while (rs.next()) {
      Permission thisPermission = new Permission(rs);
      thisPermission.setView(rs.getBoolean("role_view"));
      thisPermission.setAdd(rs.getBoolean("role_add"));
      thisPermission.setEdit(rs.getBoolean("role_edit"));
      thisPermission.setDelete(rs.getBoolean("role_delete"));
  
      this.put(thisPermission.getName(), thisPermission);
    }
    rs.close();
    pst.close();
  }

  /**
   * Description of the Method
   *
   * @param db
   * @return
   * @throws SQLException Description of the Returned Value
   */
  public PreparedStatement prepareList(Connection db,String suffisso) throws SQLException {
    StringBuffer sqlSelect = new StringBuffer();
    StringBuffer sqlFilter = new StringBuffer();
    StringBuffer sqlOrder = new StringBuffer();

    //Need to build a base SQL statement for returning records
    sqlSelect.append(
        "SELECT r.* " +
            "FROM role_permission"+ suffisso+" r, permission"+ suffisso+" p, permission_category"+ suffisso+" c " +
            "WHERE r.permission_id = p.permission_id AND  p.category_id = c.category_id ");
    createFilter(sqlFilter);
    sqlOrder.append("ORDER BY c." + DatabaseUtils.addQuotes(db, "level") + ", c.category, p." + DatabaseUtils.addQuotes(db, "level") + " ");

    PreparedStatement pst = db.prepareStatement(
        sqlSelect.toString() + sqlFilter.toString() + sqlOrder.toString());
    prepareFilter(pst);
    return pst;
  }
  /**
   * Description of the Method
   *
   * @param sqlFilter Description of the Parameter
   */
  private void createFilter(StringBuffer sqlFilter) {
    if (sqlFilter == null) {
      sqlFilter = new StringBuffer();
    }

    if (enabledState != Constants.UNDEFINED) {
      sqlFilter.append(" AND  p.enabled = ? ");
      sqlFilter.append(" AND  c.enabled = ? ");
    }

    if (roleId > -1) {
      sqlFilter.append(" AND  r.role_id = ? ");
    }

    if (syncType == Constants.SYNC_INSERTS) {
      if (lastAnchor != null) {
        sqlFilter.append(" AND  r.entered > ? ");
      }
      sqlFilter.append(" AND  r.entered < ? ");
    }
    if (syncType == Constants.SYNC_UPDATES) {
      sqlFilter.append(" AND  r.modified > ? ");
      sqlFilter.append(" AND  r.entered < ? ");
      sqlFilter.append(" AND  r.modified < ? ");
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

    if (enabledState != Constants.UNDEFINED) {
      pst.setBoolean(++i, enabledState == Constants.TRUE);
      pst.setBoolean(++i, enabledState == Constants.TRUE);
    }

    if (roleId > -1) {
      pst.setInt(++i, roleId);
    }

    if (syncType == Constants.SYNC_INSERTS) {
      if (lastAnchor != null) {
        pst.setTimestamp(++i, lastAnchor);
      }
      pst.setTimestamp(++i, nextAnchor);
    }
    if (syncType == Constants.SYNC_UPDATES) {
      pst.setTimestamp(++i, lastAnchor);
      pst.setTimestamp(++i, lastAnchor);
      pst.setTimestamp(++i, nextAnchor);
    }

    return i;
  }


  /**
   * Description of the Method
   *
   * @param thisName Description of the Parameter
   * @param thisType Description of the Parameter
   * @return Description of the Return Value
   */
  public boolean hasPermission(String thisName, String thisType) {
    Iterator i = this.keySet().iterator();
    while (i.hasNext()) {
      Permission thisPermission = (Permission) this.get((String) i.next());
      if ("add".equals(thisType) && thisName.equals(thisPermission.getName()) && thisPermission.getAdd()) {
        return true;
      }
      if ("view".equals(thisType) && thisName.equals(thisPermission.getName()) && thisPermission.getView()) {
        return true;
      }
      if ("edit".equals(thisType) && thisName.equals(thisPermission.getName()) && thisPermission.getEdit()) {
        return true;
      }
      if ("delete".equals(thisType) && thisName.equals(thisPermission.getName()) && thisPermission.getDelete()) {
        return true;
      }
      if ("offline_add".equals(thisType) && thisName.equals(thisPermission.getName()) && thisPermission.getOfflineAdd()) {
        return true;
      }
      if ("offline_view".equals(thisType) && thisName.equals(thisPermission.getName()) && thisPermission.getOfflineView()) {
        return true;
      }
      if ("offline_edit".equals(thisType) && thisName.equals(thisPermission.getName()) && thisPermission.getOfflineEdit()) {
        return true;
      }
      if ("offline_delete".equals(thisType) && thisName.equals(thisPermission.getName()) && thisPermission.getOfflineDelete()) {
        return true;
      }
    }
    return false;
  }

  public static ArrayList recordList(Connection db) throws SQLException {
    ArrayList records = new ArrayList();

    PreparedStatement pst = null;
    ResultSet rs = null;

    StringBuffer sqlSelect = new StringBuffer();

    //Need to build a base SQL statement for returning records
    sqlSelect.append(
        "SELECT * " +
            "FROM role_permission r " +
            "WHERE r.id > -1 ");
    pst = db.prepareStatement(sqlSelect.toString());
    rs = pst.executeQuery();
    while (rs.next()) {
      RolePermission permission = new RolePermission(rs);
      records.add(permission);
    }
    rs.close();
    pst.close();
    return records;
  }
}

