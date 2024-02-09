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
import java.text.DateFormat;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;

import org.aspcfs.utils.DatabaseUtils;

import com.darkhorseventures.framework.beans.GenericBean;

/**
 * Represents a Role (User Group)
 *
 * @author matt rajkowski
 * @version $Id: Role.java 24287 2007-12-09 11:28:24Z srinivasar@cybage.com $
 * @created September 19, 2001
 */
public class Role extends GenericBean {
	
	
	public static final int GRUPPO_GISA =1 ;
	public static final int GRUPPO_ALTRE_AUTORITA =2 ;
	
	
	public static final int RUOLO_APICOLTORE =10000002 ;
	public static final int RUOLO_DELEGATO =10000001 ;
	public static final int RUOLO_COMUNE =10000003;
	public static final int RUOLO_TRASPORTATORI_DISTRIBUTORI =10000004;
	public static final int RUOLO_GESTORE_PRODOTTI_SOA =10000005;
	public static final int RUOLO_REGIONE =40;
	public static final int RUOLO_ORSA = 31;
	public static final int RUOLO_CRAS = 333;
	public static final int HD_1LIVELLO = 32;
	public static final int HD_2LIVELLO = 1;
	public static final int role_admin_ext = 270;
	

	
  private static final long serialVersionUID = 3296299115328316895L;
  //Role Properties
  protected int id = -1;
  protected String role = null;
  protected String description = null;
  protected int roleType = -1; //regular or portal user type (engineer, customer...etc)
  protected java.sql.Timestamp entered = null;
  protected java.sql.Timestamp modified = null;
  protected int enteredBy = -1;
  protected int modifiedBy = -1;
  protected boolean enabled = true;
  //Helper Properties
  protected int userCount = -1;
  //Related Collections
  protected RolePermissionList permissionList = new RolePermissionList();
  protected UserList userList = new UserList();
  //Rules for building object
  protected boolean buildHierarchy = false;


  /**
   * Constructor for the Role object
   */
  public Role() {
  }


  
  public void setPermissionList(RolePermissionList list)
  {
	  permissionList = list;
  }
  /**
   * Constructor for the Role object
   *
   * @param rs Description of Parameter
   * @throws SQLException Description of Exception
   */
  public Role(ResultSet rs) throws SQLException {
    buildRecord(rs);
  }


  /**
   * Constructor for the Role object
   *
   * @param db     Description of Parameter
   * @param roleId Description of Parameter
   * @throws SQLException Description of Exception
   */
  public Role(Connection db, int roleId,String suffisso) throws SQLException {
    PreparedStatement pst = db.prepareStatement(
        "SELECT * " +
            "FROM " + DatabaseUtils.addQuotes(db, "role")+suffisso + " " +
            "WHERE role_id = ? ");
    pst.setInt(1, roleId);
    ResultSet rs = pst.executeQuery();
    if (rs.next()) {
      buildRecord(rs);
    }
    rs.close();
    pst.close();
    if (id == -1) {
      throw new SQLException("Role record not found.");
    }
    buildResources(db,suffisso);
  }


  /**
   * Sets the Entered attribute of the Role object
   *
   * @param tmp The new Entered value
   */
  public void setEntered(java.sql.Timestamp tmp) {
    this.entered = tmp;
  }


  /**
   * Sets the Entered attribute of the Role object
   *
   * @param tmp The new Entered value
   */
  public void setEntered(String tmp) {
    this.entered = DatabaseUtils.parseTimestamp(tmp);
  }


  /**
   * Sets the Modified attribute of the Role object
   *
   * @param tmp The new Modified value
   */
  public void setModified(java.sql.Timestamp tmp) {
    this.modified = tmp;
  }


  /**
   * Sets the Modified attribute of the Role object
   *
   * @param tmp The new Modified value
   */
  public void setModified(String tmp) {
    this.modified = DatabaseUtils.parseTimestamp(tmp);
  }


  /**
   * Sets the Id attribute of the Role object
   *
   * @param tmp The new Id value
   */
  public void setId(int tmp) {
    this.id = tmp;
  }


  /**
   * Sets the Id attribute of the Role object
   *
   * @param tmp The new Id value
   */
  public void setId(String tmp) {
    this.id = Integer.parseInt(tmp);
  }


  /**
   * Sets the Role attribute of the Role object
   *
   * @param tmp The new Role value
   */
  public void setRole(String tmp) {
    this.role = tmp;
  }


  /**
   * Sets the Description attribute of the Role object
   *
   * @param tmp The new Description value
   */
  public void setDescription(String tmp) {
    this.description = tmp;
  }


  /**
   * Sets the roleType attribute of the Role object
   *
   * @param tmp The new roleType value
   */
  public void setRoleType(int tmp) {
    this.roleType = tmp;
  }


  /**
   * Sets the roleType attribute of the Role object
   *
   * @param tmp The new roleType value
   */
  public void setRoleType(String tmp) {
    this.roleType = Integer.parseInt(tmp);
  }


  /**
   * Sets the EnteredBy attribute of the Role object
   *
   * @param tmp The new EnteredBy value
   */
  public void setEnteredBy(int tmp) {
    this.enteredBy = tmp;
  }


  /**
   * Sets the EnteredBy attribute of the Role object
   *
   * @param tmp The new EnteredBy value
   */
  public void setEnteredBy(String tmp) {
    this.enteredBy = Integer.parseInt(tmp);
  }


  /**
   * Sets the ModifiedBy attribute of the Role object
   *
   * @param tmp The new ModifiedBy value
   */
  public void setModifiedBy(int tmp) {
    this.modifiedBy = tmp;
  }


  /**
   * Sets the ModifiedBy attribute of the Role object
   *
   * @param tmp The new ModifiedBy value
   */
  public void setModifiedBy(String tmp) {
    this.modifiedBy = Integer.parseInt(tmp);
  }


  /**
   * Sets the Enabled attribute of the Role object
   *
   * @param tmp The new Enabled value
   */
  public void setEnabled(boolean tmp) {
    this.enabled = tmp;
  }


  /**
   * Sets the Enabled attribute of the Role object
   *
   * @param tmp The new Enabled value
   */
  public void setEnabled(String tmp) {
    this.enabled = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   * Sets the RequestItems attribute of the Role object
   *
   * @param request The new RequestItems value
   */
  public void setRequestItems(HttpServletRequest request) {
    permissionList = new RolePermissionList(request);
  }


  /**
   * Sets the userCount attribute of the Role object
   *
   * @param tmp The new userCount value
   */
  public void setUserCount(int tmp) {
    this.userCount = tmp;
  }


  /**
   * Sets the userCount attribute of the Role object
   *
   * @param tmp The new userCount value
   */
  public void setUserCount(String tmp) {
    this.userCount = Integer.parseInt(tmp);
  }


  /**
   * Gets the Entered attribute of the Role object
   *
   * @return The Entered value
   */
  public java.sql.Timestamp getEntered() {
    return entered;
  }


  /**
   * Gets the Modified attribute of the Role object
   *
   * @return The Modified value
   */
  public java.sql.Timestamp getModified() {
    return modified;
  }


  /**
   * Gets the ModifiedString attribute of the Role object
   *
   * @return The ModifiedString value
   */
  public String getModifiedString() {
    String tmp = "";
    try {
      return DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.LONG).format(
          modified);
    } catch (NullPointerException e) {
    }
    return tmp;
  }


  /**
   * Gets the EnteredString attribute of the Role object
   *
   * @return The EnteredString value
   */
  public String getEnteredString() {
    String tmp = "";
    try {
      return DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.LONG).format(
          entered);
    } catch (NullPointerException e) {
    }
    return tmp;
  }


  /**
   * Gets the Id attribute of the Role object
   *
   * @return The Id value
   */
  public int getId() {
    return id;
  }


  /**
   * Gets the Role attribute of the Role object
   *
   * @return The Role value
   */
  public String getRole() {
    return role;
  }


  /**
   * Gets the Description attribute of the Role object
   *
   * @return The Description value
   */
  public String getDescription() {
    return description;
  }


  /**
   * Gets the roleType attribute of the Role object
   *
   * @return The roleType value
   */
  public int getRoleType() {
    return roleType;
  }


  /**
   * Gets the EnteredBy attribute of the Role object
   *
   * @return The EnteredBy value
   */
  public int getEnteredBy() {
    return enteredBy;
  }


  /**
   * Gets the ModifiedBy attribute of the Role object
   *
   * @return The ModifiedBy value
   */
  public int getModifiedBy() {
    return modifiedBy;
  }


  /**
   * Gets the Enabled attribute of the Role object
   *
   * @return The Enabled value
   */
  public boolean getEnabled() {
    return enabled;
  }


  /**
   * Gets the PermissionList attribute of the Role object
   *
   * @return The PermissionList value
   */
  public RolePermissionList getPermissionList() {
    return permissionList;
  }


  /**
   * Gets the UserList attribute of the Role object
   *
   * @return The UserList value
   */
  public UserList getUserList() {
    return userList;
  }


  /**
   * Gets the userCount attribute of the Role object
   *
   * @return The userCount value
   */
  public int getUserCount() {
    return userCount;
  }






  /**
   * Description of the Method
   *
   * @param db Description of Parameter
   * @return Description of the Returned Value
   * @throws SQLException Description of Exception
   */
  



  /**
   * Adds a feature to the Permission attribute of the Role object
   *
   * @param db            The feature to be added to the Permission
   *                      attribute
   * @param permissionId  The feature to be added to the Permission
   *                      attribute
   * @param add           The feature to be added to the Permission
   *                      attribute
   * @param view          The feature to be added to the Permission
   *                      attribute
   * @param edit          The feature to be added to the Permission
   *                      attribute
   * @param delete        The feature to be added to the Permission
   *                      attribute
   * @param offlineAdd    The feature to be added to the Permission
   *                      attribute
   * @param offlineView   The feature to be added to the Permission
   *                      attribute
   * @param offlineEdit   The feature to be added to the Permission
   *                      attribute
   * @param offlineDelete The feature to be added to the Permission
   *                      attribute
   * @throws SQLException Description of Exception
   */
  public void addPermission(String suffisso,Connection db, int permissionId, boolean add, boolean view, boolean edit, boolean delete, boolean offlineAdd, boolean offlineView, boolean offlineEdit, boolean offlineDelete) throws SQLException {
    int i = 0;

    PreparedStatement pst = db.prepareStatement(
        "INSERT INTO role_permission"+ suffisso+
        " (role_id, permission_id, role_add, role_view, role_edit, role_delete" +
        
        ") " +
        "VALUES (?, ?, ?, ?, ?, ? " +
        
        ") ");
   
    pst.setInt(++i, getId());
    pst.setInt(++i, permissionId);
    pst.setBoolean(++i, add);
    pst.setBoolean(++i, view);
    pst.setBoolean(++i, edit);
    pst.setBoolean(++i, delete);
 
    pst.execute();
    pst.close();
  }


  /**
   * Description of the Method
   *
   * @param rs Description of Parameter
   * @throws SQLException Description of Exception
   */
  protected void buildRecord(ResultSet rs) throws SQLException {
    //role table
    id = rs.getInt("role_id");
    role = rs.getString("role");
    description = rs.getString("description");
    entered = rs.getTimestamp("entered");
    enteredBy = rs.getInt("enteredby");
    modified = rs.getTimestamp("modified");
    modifiedBy = rs.getInt("modifiedby");
    enabled = rs.getBoolean("enabled");
    roleType = DatabaseUtils.getInt(rs, "role_type");
  }


  /**
   * Description of the Method
   *
   * @param db Description of Parameter
   * @throws SQLException Description of Exception
   */
  protected void buildResources(Connection db,String suffisso) throws SQLException {
    permissionList = new RolePermissionList(db, id,suffisso);
    buildUserList(db,suffisso);
  }


  /**
   * Description of the Method
   *
   * @param db Description of Parameter
   * @throws SQLException Description of Exception
   */
  protected void buildUserList(Connection db,String suffisso) throws SQLException {
    userList.setRoleId(id);
    userList.setBuildHierarchy(buildHierarchy);
    userList.buildList(db,suffisso);
  }


  /**
   * Description of the Method
   *
   * @param db Description of Parameter
   * @throws SQLException Description of Exception
   */
  private void insertPermissions(Connection db,String suff) throws SQLException {
    Iterator ipermission = permissionList.keySet().iterator();
    while (ipermission.hasNext()) {
      Permission thisPermission = (Permission) permissionList.get(
          (String) ipermission.next());
      if (thisPermission.getEnabled()) {
        addPermission(suff,
            db,
            thisPermission.getId(),
            thisPermission.getAdd(),
            thisPermission.getView(),
            thisPermission.getEdit(),
            thisPermission.getDelete(),
            thisPermission.getOfflineAdd(),
            thisPermission.getOfflineView(),
            thisPermission.getOfflineEdit(),
            thisPermission.getOfflineDelete()
        );
      }
    }
  }
}

