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
import java.util.Calendar;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Stack;
import java.util.Vector;

import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.modules.base.SyncableList;
import org.aspcfs.modules.contacts.base.Contact;
import org.aspcfs.utils.ContactUtils;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.StringUtils;
import org.aspcfs.utils.web.HtmlSelect;
import org.aspcfs.utils.web.PagedListInfo;

import com.darkhorseventures.database.ConnectionElement;
import com.darkhorseventures.framework.actions.ActionContext;

/**
 * A list of User objects.
 *
 * @author matt rajkowski
 * @version $Id: UserList.java,v 1.51.12.1 2004/11/19 21:36:20 mrajkowski Exp
 *          $
 * @created September 19, 2001
 */
public class UserList extends Vector implements SyncableList {
  public final static int TRUE = 1;
  public final static int FALSE = 0;
  //Sync variables
  public final static String tableName = "access";
  public final static String uniqueField = "user_id";
  private java.sql.Timestamp lastAnchor = null;
  private java.sql.Timestamp nextAnchor = null;
  private int syncType = Constants.NO_SYNC;
  private PagedListInfo pagedListInfo = null;
  private String emptyHtmlSelectRecord = null;
  //Query properties
  private int enteredBy = -1;
  private int roleId = -1;
  private int managerId = -1;
  private User managerUser = null;
  private boolean buildContact = false;
  private boolean buildContactDetails = false;
  private boolean buildHierarchy = false;
  private boolean buildEmployeeUsersOnly = false;
  private boolean buildAccountUsersOnly = false;
  private boolean topLevel = false;
  private int department = -1;
  private int enabled = -1;
  private int hasWebdavAccess = -1;
  private int hasHttpApiAccess = -1;
  private String jsEvent = null;
  private int includeAliases = Constants.FALSE;
  private int hidden = Constants.UNDEFINED;
  private Timestamp expires = null;
  private int expired = Constants.UNDEFINED;
  //Revenue specific properties
  private boolean buildRevenueYTD = false;
  private int revenueYear = -1;
  private int revenueType = 0;
  private boolean buildGrossPipelineValue = false;

  private boolean includeMe = false;
  private String myValue = "";
  private int myId = -1;
  private String username = null;
  private String password = null;

  private boolean excludeDisabledIfUnselected = false;
  private boolean includeUsersWithRolesOnly = true;
  private boolean excludeExpiredIfUnselected = false;
  private java.sql.Timestamp enteredRangeStart = null;
  private java.sql.Timestamp enteredRangeEnd = null;

  //0 for regular users and 1 for portal users
  private int roleType = -1;
  private int userGroupId = -1;

  // -1 indicates access to all sites, positive number indicates access
  // to a particular site
  private int siteId = -1;
  private boolean includeUsersWithAccessToAllSites = false;
  private boolean includeDHVAdmin = false;
  private String filterUsers = "";
  
  private int superRuolo ;
  public void setFilterUsers(String tmp) {
    this.filterUsers = tmp;
  }

  public String getFilterUsers() {
    return filterUsers;
  }
  

  /**
   * Constructor for the UserList object
   *
   * @since 1.1
   */
  public UserList() {
  }


  public int getSuperRuolo() {
	return superRuolo;
}

public void setSuperRuolo(int superRuolo) {
	this.superRuolo = superRuolo;
}

public void setSuperRuolo(String superRuolo) {
	if (superRuolo!= null && ! "".equals(superRuolo))
	this.superRuolo = Integer.parseInt(superRuolo);
}

/**
   * Constructor for the UserList object
   *
   * @param db          Description of Parameter
   * @param doHierarchy Description of Parameter
   * @param parentUser  Description of Parameter
   * @throws SQLException Description of the Exception
   * @throws SQLException Description of the Exception
   * @throws SQLException Description of Exception
   * @since 1.9
   */
  public UserList(Connection db, User parentUser, boolean doHierarchy,String suffix) throws SQLException {
    this.managerId = parentUser.getId();
    this.managerUser = parentUser;
    this.buildHierarchy = doHierarchy;
    buildList(db,suffix);
  }


  /**
   * Gets the hasWebdavAccess attribute of the UserList object
   *
   * @return The hasWebdavAccess value
   */
  public int getHasWebdavAccess() {
    return hasWebdavAccess;
  }


  /**
   * Sets the hasWebdavAccess attribute of the UserList object
   *
   * @param tmp The new hasWebdavAccess value
   */
  public void setHasWebdavAccess(int tmp) {
    this.hasWebdavAccess = tmp;
  }


  /**
   * Sets the hasWebdavAccess attribute of the UserList object
   *
   * @param tmp The new hasWebdavAccess value
   */
  public void setHasWebdavAccess(String tmp) {
    this.hasWebdavAccess = Integer.parseInt(tmp);
  }


  /**
   * Gets the hasHttpApiAccess attribute of the UserList object
   *
   * @return The hasHttpApiAccess value
   */
  public int getHasHttpApiAccess() {
    return hasHttpApiAccess;
  }


  /**
   * Sets the hasHttpApiAccess attribute of the UserList object
   *
   * @param tmp The new hasHttpApiAccess value
   */
  public void setHasHttpApiAccess(int tmp) {
    this.hasHttpApiAccess = tmp;
  }


  /**
   * Sets the hasHttpApiAccess attribute of the UserList object
   *
   * @param tmp The new hasHttpApiAccess value
   */
  public void setHasHttpApiAccess(String tmp) {
    this.hasHttpApiAccess = Integer.parseInt(tmp);
  }


  /**
   * Gets the password attribute of the UserList object
   *
   * @return The password value
   */
  public String getPassword() {
    return password;
  }


  /**
   * Sets the password attribute of the UserList object
   *
   * @param tmp The new password value
   */
  public void setPassword(String tmp) {
    this.password = tmp;
  }


  /**
   * Sets the lastAnchor attribute of the UserList object
   *
   * @param tmp The new lastAnchor value
   */
  public void setLastAnchor(java.sql.Timestamp tmp) {
    this.lastAnchor = tmp;
  }


  /**
   * Sets the lastAnchor attribute of the UserList object
   *
   * @param tmp The new lastAnchor value
   */
  public void setLastAnchor(String tmp) {
    this.lastAnchor = java.sql.Timestamp.valueOf(tmp);
  }


  /**
   * Sets the nextAnchor attribute of the UserList object
   *
   * @param tmp The new nextAnchor value
   */
  public void setNextAnchor(java.sql.Timestamp tmp) {
    this.nextAnchor = tmp;
  }


  /**
   * Sets the nextAnchor attribute of the UserList object
   *
   * @param tmp The new nextAnchor value
   */
  public void setNextAnchor(String tmp) {
    this.nextAnchor = java.sql.Timestamp.valueOf(tmp);
  }


  /**
   * Sets the syncType attribute of the UserList object
   *
   * @param tmp The new syncType value
   */
  public void setSyncType(int tmp) {
    this.syncType = tmp;
  }


  /**
   * Sets the syncType attribute of the UserList object
   *
   * @param tmp The new syncType value
   */
  public void setSyncType(String tmp) {
    this.syncType = Integer.parseInt(tmp);
  }


  /**
   * Gets the buildRevenueYTD attribute of the UserList object
   *
   * @return The buildRevenueYTD value
   */
  public boolean getBuildRevenueYTD() {
    return buildRevenueYTD;
  }


  /**
   * Sets the buildRevenueYTD attribute of the UserList object
   *
   * @param buildRevenueYTD The new buildRevenueYTD value
   */
  public void setBuildRevenueYTD(boolean buildRevenueYTD) {
    this.buildRevenueYTD = buildRevenueYTD;
  }


  /**
   * Gets the excludeDisabledIfUnselected attribute of the UserList object
   *
   * @return The excludeDisabledIfUnselected value
   */
  public boolean getExcludeDisabledIfUnselected() {
    return excludeDisabledIfUnselected;
  }


  /**
   * Gets the includeUsersWithRolesOnly attribute of the UserList object
   *
   * @return The includeUsersWithRolesOnly value
   */
  public boolean getIncludeUsersWithRolesOnly() {
    return includeUsersWithRolesOnly;
  }


  /**
   * Sets the excludeDisabledIfUnselected attribute of the UserList object
   *
   * @param excludeDisabledIfUnselected The new excludeDisabledIfUnselected
   *                                    value
   */
  public void setExcludeDisabledIfUnselected(boolean excludeDisabledIfUnselected) {
    this.excludeDisabledIfUnselected = excludeDisabledIfUnselected;
  }


  /**
   * Sets the includeUsersWithRolesOnly attribute of the UserList object
   *
   * @param tmp The new includeUsersWithRolesOnly value
   */
  public void setIncludeUsersWithRolesOnly(boolean tmp) {
    this.includeUsersWithRolesOnly = tmp;
  }


  /**
   * Sets the enteredRangeStart attribute of the UserList object
   *
   * @param tmp The new enteredRangeStart value
   */
  public void setEnteredRangeStart(java.sql.Timestamp tmp) {
    this.enteredRangeStart = tmp;
  }


  /**
   * Sets the enteredRangeEnd attribute of the UserList object
   *
   * @param tmp The new enteredRangeEnd value
   */
  public void setEnteredRangeEnd(java.sql.Timestamp tmp) {
    this.enteredRangeEnd = tmp;
  }


  /**
   * Sets the PagedListInfo attribute of the UserList object
   *
   * @param tmp The new PagedListInfo value
   * @since 1.4
   */
  public void setPagedListInfo(PagedListInfo tmp) {
    this.pagedListInfo = tmp;
  }


  /**
   * Sets the roleType attribute of the UserList object
   *
   * @param tmp The new roleType value
   */
  public void setRoleType(int tmp) {
    this.roleType = tmp;
  }


  /**
   * Sets the roleType attribute of the UserList object
   *
   * @param tmp The new roleType value
   */
  public void setRoleType(String tmp) {
    this.roleType = Integer.parseInt(tmp);
  }


  /**
   * Sets the siteId attribute of the UserList object
   *
   * @param tmp The new siteId value
   */
  public void setSiteId(int tmp) {
    this.siteId = tmp;
  }


  /**
   * Sets the siteId attribute of the UserList object
   *
   * @param tmp The new siteId value
   */
  public void setSiteId(String tmp) {
    this.siteId = Integer.parseInt(tmp);
  }


  /**
   * Sets the includeUsersWithAccessToAllSites attribute of the UserList object
   *
   * @param tmp The new includeUsersWithAccessToAllSites value
   */
  public void setIncludeUsersWithAccessToAllSites(boolean tmp) {
    this.includeUsersWithAccessToAllSites = tmp;
  }


  /**
   * Sets the includeUsersWithAccessToAllSites attribute of the UserList object
   *
   * @param tmp The new includeUsersWithAccessToAllSites value
   */
  public void setIncludeUsersWithAccessToAllSites(String tmp) {
    this.includeUsersWithAccessToAllSites = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   * Gets the buildGrossPipelineValue attribute of the UserList object
   *
   * @return The buildGrossPipelineValue value
   */
  public boolean getBuildGrossPipelineValue() {
    return buildGrossPipelineValue;
  }


  /**
   * Sets the buildGrossPipelineValue attribute of the UserList object
   *
   * @param buildGrossPipelineValue The new buildGrossPipelineValue value
   */
  public void setBuildGrossPipelineValue(boolean buildGrossPipelineValue) {
    this.buildGrossPipelineValue = buildGrossPipelineValue;
  }


  /**
   * Sets the EmptyHtmlSelectRecord attribute of the UserList object
   *
   * @param tmp The new EmptyHtmlSelectRecord value
   * @since 1.4
   */
  public void setEmptyHtmlSelectRecord(String tmp) {
    this.emptyHtmlSelectRecord = tmp;
  }


  /**
   * Sets the enteredBy attribute of the UserList object
   *
   * @param tmp The new enteredBy value
   */
  public void setEnteredBy(int tmp) {
    this.enteredBy = tmp;
  }


  /**
   * Sets the RoleId attribute of the UserList object
   *
   * @param tmp The new RoleId value
   * @since 1.8
   */
  public void setRoleId(int tmp) {
    this.roleId = tmp;
  }


  /**
   * Gets the roleId attribute of the UserList object
   *
   * @return The roleId value
   */
  public int getRoleId() {
    return this.roleId;
  }


  /**
   * Sets the Department attribute of the UserList object
   *
   * @param department The new Department value
   */
  public void setDepartment(int department) {
    this.department = department;
  }


  /**
   * Sets the Department attribute of the UserList object
   *
   * @param department The new Department value
   */
  public void setDepartment(String department) {
    this.department = Integer.parseInt(department);
  }


  /**
   * Gets the revenueType attribute of the UserList object
   *
   * @return The revenueType value
   */
  public int getRevenueType() {
    return revenueType;
  }


  /**
   * Sets the revenueType attribute of the UserList object
   *
   * @param revenueType The new revenueType value
   */
  public void setRevenueType(int revenueType) {
    this.revenueType = revenueType;
  }


  /**
   * Sets the username attribute of the UserList object
   *
   * @param username The new username value
   */
  public void setUsername(String username) {
    this.username = username;
  }


  /**
   * Sets the JsEvent attribute of the UserList object
   *
   * @param jsEvent The new JsEvent value
   */
  public void setJsEvent(String jsEvent) {
    this.jsEvent = jsEvent;
  }


  /**
   * Sets the Enabled attribute of the UserList object
   *
   * @param tmp The new Enabled value
   */
  public void setEnabled(int tmp) {
    this.enabled = tmp;
  }


  /**
   * Sets the enabled attribute of the UserList object
   *
   * @param tmp The new enabled value
   */
  public void setEnabled(String tmp) {
    this.enabled = Integer.parseInt(tmp);
  }


  /**
   * Sets the IncludeMe attribute of the UserList object
   *
   * @param tmp The new IncludeMe value
   * @since 1.19
   */
  public void setIncludeMe(boolean tmp) {
    this.includeMe = tmp;
  }


  /**
   * Gets the revenueYear attribute of the UserList object
   *
   * @return The revenueYear value
   */
  public int getRevenueYear() {
    return revenueYear;
  }


  /**
   * Sets the revenueYear attribute of the UserList object
   *
   * @param revenueYear The new revenueYear value
   */
  public void setRevenueYear(int revenueYear) {
    this.revenueYear = revenueYear;
  }


  /**
   * Sets the MyValue attribute of the UserList object
   *
   * @param tmp The new MyValue value
   * @since 1.19
   */
  public void setMyValue(String tmp) {
    this.myValue = tmp;
  }


  /**
   * Sets the MyId attribute of the UserList object
   *
   * @param tmp The new MyId value
   * @since 1.19
   */
  public void setMyId(int tmp) {
    this.myId = tmp;
  }


  /**
   * Sets the includeAliases attribute of the UserList object
   *
   * @param tmp The new includeAliases value
   */
  public void setIncludeAliases(int tmp) {
    this.includeAliases = tmp;
  }


  /**
   * Sets the ManagerId attribute of the UserList object
   *
   * @param tmp The new ManagerId value
   * @since 1.8
   */
  public void setManagerId(int tmp) {
    this.managerId = tmp;
  }


  /**
   * Sets the TopLevel attribute of the UserList object
   *
   * @param tmp The new TopLevel value
   * @since 1.20
   */
  public void setTopLevel(boolean tmp) {
    this.topLevel = tmp;
  }


  /**
   * Sets the BuildContact attribute of the UserList object
   *
   * @param tmp The new BuildContact value
   * @since 1.18
   */
  public void setBuildContact(boolean tmp) {
    this.buildContact = tmp;
  }


  /**
   * Sets the buildContactDetails attribute of the UserList object
   *
   * @param tmp The new buildContactDetails value
   */
  public void setBuildContactDetails(boolean tmp) {
    this.buildContactDetails = tmp;
  }


  /**
   * Sets the BuildHierarchy attribute of the UserList object
   *
   * @param tmp The new BuildHierarchy value
   * @since 1.17
   */
  public void setBuildHierarchy(boolean tmp) {
    this.buildHierarchy = tmp;
  }


  /**
   * Sets the buildEmployeeUsersOnly attribute of the UserList object
   *
   * @param tmp The new buildEmployeeUsersOnly value
   */
  public void setBuildEmployeeUsersOnly(boolean tmp) {
    this.buildEmployeeUsersOnly = tmp;
  }


  /**
   * Sets the buildEmployeeUsersOnly attribute of the UserList object
   *
   * @param tmp The new buildEmployeeUsersOnly value
   */
  public void setBuildEmployeeUsersOnly(String tmp) {
    this.buildEmployeeUsersOnly = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   * Sets the buildAccountUsersOnly attribute of the UserList object
   *
   * @param tmp The new buildAccountUsersOnly value
   */
  public void setBuildAccountUsersOnly(boolean tmp) {
    this.buildAccountUsersOnly = tmp;
  }


  /**
   * Sets the buildAccountUsersOnly attribute of the UserList object
   *
   * @param tmp The new buildAccountUsersOnly value
   */
  public void setBuildAccountUsersOnly(String tmp) {
    this.buildAccountUsersOnly = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   * Sets the ManagerUser attribute of the UserList object
   *
   * @param tmp The new ManagerUser value
   */
  public void setManagerUser(User tmp) {
    this.managerUser = tmp;
  }


  /**
   * Gets the tableName attribute of the UserList object
   *
   * @return The tableName value
   */
  public String getTableName() {
    return tableName;
  }


  /**
   * Gets the uniqueField attribute of the UserList object
   *
   * @return The uniqueField value
   */
  public String getUniqueField() {
    return uniqueField;
  }


  /**
   * Gets the username attribute of the UserList object
   *
   * @return The username value
   */
  public String getUsername() {
    return username;
  }


  /**
   * Gets the includeAliases attribute of the UserList object
   *
   * @return The includeAliases value
   */
  public int getIncludeAliases() {
    return includeAliases;
  }


  /**
   * Gets the JsEvent attribute of the UserList object
   *
   * @return The JsEvent value
   */
  public String getJsEvent() {
    return jsEvent;
  }


  /**
   * Gets the Department attribute of the UserList object
   *
   * @return The Department value
   */
  public int getDepartment() {
    return department;
  }


  /**
   * Gets the IncludeMe attribute of the UserList object
   *
   * @return The IncludeMe value
   * @since 1.19
   */
  public boolean getIncludeMe() {
    return includeMe;
  }


  /**
   * Gets the MyValue attribute of the UserList object
   *
   * @return The MyValue value
   * @since 1.19
   */
  public String getMyValue() {
    return myValue;
  }


  /**
   * Gets the MyId attribute of the UserList object
   *
   * @return The MyId value
   * @since 1.19
   */
  public int getMyId() {
    return myId;
  }


  /**
   * Gets the ListSize attribute of the UserList object
   *
   * @return The ListSize value
   * @since 1.9
   */
  public int getListSize() {
    return this.size();
  }


  /**
   * Gets the HtmlSelect attribute of the UserList object
   *
   * @param selectName Description of Parameter
   * @return The HtmlSelect value
   * @since 1.4
   */
  public String getHtmlSelect(String selectName) {
    return getHtmlSelect(selectName, -1);
  }


  public void setIncludeDHVAdmin(boolean includeDHVAdmin) {
    this.includeDHVAdmin = includeDHVAdmin;
  }
  
  public void setIncludeDHVAdmin(String includeDHVAdmin) {
    this.includeDHVAdmin = DatabaseUtils.parseBoolean(includeDHVAdmin);
  }
  
  /**
   * Gets the HtmlSelect attribute of the UserList object
   *
   * @param selectName Description of Parameter
   * @param defaultKey Description of Parameter
   * @return The HtmlSelect value
   * @since 1.4
   */
  public String getHtmlSelect(String selectName, int defaultKey) {
    HtmlSelect userListSelect = new HtmlSelect();
    userListSelect.setJsEvent(jsEvent);

    if (emptyHtmlSelectRecord != null) {
      userListSelect.addItem(-1, emptyHtmlSelectRecord);
    }
    if (includeMe == true) {
      userListSelect.addItem(myId, myValue);
    }
    Iterator i = this.iterator();
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      String elementText = null;
      Timestamp currentTime = new Timestamp(
          Calendar.getInstance().getTimeInMillis());
      elementText = thisUser.getContact().getValidName();
      if (!thisUser.getEnabled() || (thisUser.getExpires() != null && currentTime.after(
          thisUser.getExpires()))) {
        elementText += " *";
      }
      if (thisUser.getSiteId() != -1) {
        elementText += " (" + thisUser.getSiteIdName() + ")";
      }
      if (thisUser.getEnabled() || (!thisUser.getEnabled() && !excludeDisabledIfUnselected) || (excludeDisabledIfUnselected && thisUser.getId() == defaultKey)) {
        if (thisUser.getExpires() == null || (thisUser.getExpires() != null && currentTime.before(
            thisUser.getExpires())) || ((thisUser.getExpires() != null && currentTime.after(
            thisUser.getExpires())) && !excludeExpiredIfUnselected) || (excludeExpiredIfUnselected && thisUser.getId() == defaultKey)) {
          if (thisUser.getId() != 0) {
            userListSelect.addItem(
                thisUser.getId(),
                elementText);
          }
        }
      }
    }
    return userListSelect.getHtml(selectName, defaultKey);
  }


  /**
   * Gets the htmlSelectObj attribute of the UserList object
   *
   * @param selectName Description of the Parameter
   * @param defaultKey Description of the Parameter
   * @return The htmlSelectObj value
   */
  public HtmlSelect getHtmlSelectObj(String selectName, int defaultKey) {
    HtmlSelect userListSelect = new HtmlSelect();
    userListSelect.setJsEvent(jsEvent);
    if (emptyHtmlSelectRecord != null) {
      userListSelect.addItem(-1, emptyHtmlSelectRecord);
    }
    if (includeMe == true) {
      userListSelect.addItem(myId, myValue);
    }
    Iterator i = this.iterator();
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      String elementText = null;
      Timestamp currentTime = new Timestamp(
          Calendar.getInstance().getTimeInMillis());
      elementText = thisUser.getContact().getValidName();
      if (!thisUser.getEnabled() || (thisUser.getExpires() != null && currentTime.after(
          thisUser.getExpires()))) {
        elementText += " *";
      }
      if (thisUser.getSiteId() != -1) {
        elementText += " (" + thisUser.getSiteIdName() + ")";
      }
      if (thisUser.getEnabled() || (!thisUser.getEnabled() && !excludeDisabledIfUnselected) || (excludeDisabledIfUnselected && thisUser.getId() == defaultKey)) {
        userListSelect.addItem(thisUser.getId(), elementText);
      }
    }
    return userListSelect;
  }


  /**
   * Gets the UserListIds attribute of the UserList object
   *
   * @param toInclude Description of Parameter
   * @return The UserListIds value
   * @since 1.17
   */
  public String getUserListIds(int toInclude) {
    StringBuffer values = new StringBuffer();
    values.append(String.valueOf(toInclude));
    Iterator i = this.iterator();
    if (i.hasNext()) {
      values.append(", ");
    }
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      values.append(String.valueOf(thisUser.getId()));
      if (i.hasNext()) {
        values.append(", ");
      }
    }
    return values.toString();
  }


  /**
   * Gets the UserListIds attribute of the UserList object
   *
   * @return The UserListIds value
   * @since 1.16
   */
  public String getUserListIds() {
    StringBuffer values = new StringBuffer();
    Iterator i = this.iterator();
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      values.append(String.valueOf(thisUser.getId()));
      if (i.hasNext()) {
        values.append(", ");
      }
    }
    return values.toString();
  }


  /**
   * Gets the hidden attribute of the UserList object
   *
   * @return The hidden value
   */
  public int getHidden() {
    return hidden;
  }


  /**
   * Sets the hidden attribute of the UserList object
   *
   * @param tmp The new hidden value
   */
  public void setHidden(int tmp) {
    this.hidden = tmp;
  }


  /**
   * Sets the hidden attribute of the UserList object
   *
   * @param tmp The new hidden value
   */
  public void setHidden(String tmp) {
    this.hidden = Integer.parseInt(tmp);
  }


  /**
   * Gets the expires attribute of the UserList object
   *
   * @return The expires value
   */
  public Timestamp getExpires() {
    return expires;
  }


  /**
   * Sets the expires attribute of the UserList object
   *
   * @param tmp The new expires value
   */
  public void setExpires(Timestamp tmp) {
    this.expires = tmp;
  }


  /**
   * Sets the expires attribute of the UserList object
   *
   * @param tmp The new expires value
   */
  public void setExpires(String tmp) {
    this.expires = DatabaseUtils.parseTimestamp(tmp);
  }


  /**
   * Gets the expired attribute of the UserList object
   *
   * @return The expired value
   */
  public int getExpired() {
    return expired;
  }


  /**
   * Sets the expired attribute of the UserList object
   *
   * @param tmp The new expired value
   */
  public void setExpired(int tmp) {
    this.expired = tmp;
  }


  /**
   * Sets the expired attribute of the UserList object
   *
   * @param tmp The new expired value
   */
  public void setExpired(String tmp) {
    this.expired = Integer.parseInt(tmp);
  }


  /**
   * Gets the User attribute of the UserList object
   *
   * @param childId Description of Parameter
   * @return The User value
   */
  public User getUser(int childId) {
    Iterator i = this.iterator();
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      if (thisUser.getId() == childId) {
        return thisUser;
      }
      User childUser = thisUser.getChild(childId);
      if (childUser != null) {
        return childUser;
      }
    }
    return null;
  }


  /**
   * Gets the TopUser attribute of the UserList object
   *
   * @param userId Description of Parameter
   * @return The TopUser value
   */
  public User getTopUser(int userId) {
    Iterator i = this.iterator();
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      if (thisUser.getId() == userId) {
        return thisUser;
      }
    }
    return null;
  }


  /**
   * Gets the ManagerUser attribute of the UserList object
   *
   * @return The ManagerUser value
   */
  public User getManagerUser() {
    return managerUser;
  }


  /**
   * Gets the object attribute of the UserList object
   *
   * @param rs Description of Parameter
   * @return The object value
   * @throws SQLException Description of Exception
   */
  public User getObject(ResultSet rs) throws SQLException {
    User thisUser = new User(rs);
    return thisUser;
  }


  /**
   * Gets the roleType attribute of the UserList object
   *
   * @return The roleType value
   */
  public int getRoleType() {
    return roleType;
  }


  /**
   * Gets the siteId attribute of the UserList object
   *
   * @return The siteId value
   */
  public int getSiteId() {
    return siteId;
  }


  /**
   * Gets the includeUsersWithAccessToAllSites attribute of the UserList object
   *
   * @return The includeUsersWithAccessToAllSites value
   */
  public boolean getIncludeUsersWithAccessToAllSites() {
    return includeUsersWithAccessToAllSites;
  }


  /**
   * Gets the excludeExpiredIfUnselected attribute of the UserList object
   *
   * @return The excludeExpiredIfUnselected value
   */
  public boolean getExcludeExpiredIfUnselected() {
    return excludeExpiredIfUnselected;
  }


  /**
   * Sets the excludeExpiredIfUnselected attribute of the UserList object
   *
   * @param tmp The new excludeExpiredIfUnselected value
   */
  public void setExcludeExpiredIfUnselected(boolean tmp) {
    this.excludeExpiredIfUnselected = tmp;
  }


  /**
   * Sets the excludeExpiredIfUnselected attribute of the UserList object
   *
   * @param tmp The new excludeExpiredIfUnselected value
   */
  public void setExcludeExpiredIfUnselected(String tmp) {
    this.excludeExpiredIfUnselected = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   * Gets the userGroupId attribute of the UserList object
   *
   * @return The userGroupId value
   */
  public int getUserGroupId() {
    return userGroupId;
  }


  /**
   * Sets the userGroupId attribute of the UserList object
   *
   * @param tmp The new userGroupId value
   */
  public void setUserGroupId(int tmp) {
    this.userGroupId = tmp;
  }


  /**
   * Sets the userGroupId attribute of the UserList object
   *
   * @param tmp The new userGroupId value
   */
  public void setUserGroupId(String tmp) {
    this.userGroupId = Integer.parseInt(tmp);
  }


  /**
   * Description of the Method
   *
   * @param db Description of Parameter
   * @throws SQLException Description of Exception
   */
  public void select(Connection db,String suffix) throws SQLException {
    buildList(db,suffix);
  }


  /**
   * Description of the Method
   *
   * @param db       Description of the Parameter
   * @param newOwner Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public int reassignElements(Connection db, int newOwner) throws SQLException {
    int total = 0;
    Iterator i = this.iterator();
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      if (thisUser.reassign(db, newOwner)) {
        total++;
      }
    }
    return total;
  }


  /**
   * Description of the Method
   *
   * @param context      Description of the Parameter
   * @param db           Description of the Parameter
   * @param systemStatus Description of the Parameter
   * @param newOwner     Description of the Parameter
   * @param userId       Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public HashMap reassignElements(ActionContext context, Connection db, SystemStatus systemStatus, int newOwner, int userId) throws SQLException {
    HashMap errors = new HashMap();
    int total = 0;
    Iterator i = this.iterator();
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      thisUser.setModifiedBy(userId);
      if (!checkManager(thisUser, newOwner, errors, systemStatus)) {
        break;
      }
    }
    if (errors.size() == 0) {
      Iterator j = this.iterator();
      while (j.hasNext()) {
        User thisUser = (User) j.next();
        thisUser.setModifiedBy(userId);
        thisUser.reassign(db, newOwner);
      }
    }
    return errors;
  }


  /**
   * Description of the Method
   *
   * @param thisUser     Description of the Parameter
   * @param managerId    Description of the Parameter
   * @param errors       Description of the Parameter
   * @param systemStatus Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public boolean checkManager(User thisUser, int managerId, HashMap errors, SystemStatus systemStatus) throws SQLException {
    //Check hierarchy context for circular references
    if (managerId > 0 && thisUser.getId() > -1 && thisUser.getAlias() == -1) {
      if (managerId == thisUser.getId()) {
        //Check 1: User cannot report to self
        errors.put(
            "managerIdError", systemStatus.getLabel(
            "user.userCanNotReportToSelf"));
        //"User cannot report to self");
      } else {
        //Check 2: User cannot report to someone already beneath them
        User updatedUser = systemStatus.getHierarchyList().getUser(
            thisUser.getId());
        User testChild = updatedUser.getChild(managerId);

        if (testChild != null) {
          //Since the new manager is a child of this user, display the hierarchy for the user
          //Start at the testChild and work up to current user
          Stack names = new Stack();
          int currentId = testChild.getId();
          while (currentId != thisUser.getId()) {
            String childName = testChild.getContact().getNameFirstLast();
            names.push(childName);
            testChild = testChild.getManagerUser();
            currentId = testChild.getId();
          }
          names.push(updatedUser.getContact().getNameFirstLast());
          //Now work back down and show the hierarchy
          StringBuffer sb = new StringBuffer();
          sb.append(
              systemStatus.getLabel("user.canNotCreateCircularHierarchy.text") + "\r\n");
          while (!names.empty()) {
            sb.append((String) names.pop());
            if (!names.empty()) {
              sb.append(
                  systemStatus.getLabel("user.lessThan.withSpaces.symbol"));
              //" < ");
            }
          }
          errors.put("managerIdError", sb.toString());
        }
      }
    }
    if (errors.size() > 0) {
      return false;
    }
    return true;
  }


  /**
   * Description of the Method
   *
   * @param db       Description of the Parameter
   * @param newOwner Description of the Parameter
   * @param userId   Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public int reassignElements(Connection db, int newOwner, int userId) throws SQLException {
    int total = 0;
    Iterator i = this.iterator();
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      thisUser.setModifiedBy(userId);
      if (thisUser.reassign(db, newOwner)) {
        total++;
      }
    }
    return total;
  }


  private void setComuneSuap(Suap s,Connection db,String istatcomune) throws SQLException
  {
	  
	  if (istatcomune!=null && !"".equals(istatcomune))
	  {
	  String sql = "select nome,p.description from comuni1 c join lookup_province p on p.code=c.cod_provincia::int  where c.istat::int = ?";
	  PreparedStatement pst = db.prepareStatement(sql);
	  pst.setInt(1, Integer.parseInt(istatcomune));
	  ResultSet rs = pst.executeQuery();
	  if (rs.next())
		  
	  {
		  s.setDescrizioneComune(rs.getString(1));
		  s.setDescrizioneProvincia(rs.getString(2));
	  }
	  }
	  
  }
  /**
   * Generates the user list from the database
   *
   * @param db Description of Parameter
   * @throws SQLException Description of Exception
   * @since 1.4
   */
  public void buildList(Connection db,String suffixTable) throws SQLException {
    //A super query -- builds the user and contact data at same time
    PreparedStatement pst = prepareList(db,suffixTable);
    ResultSet rs = DatabaseUtils.executeQuery(db, pst, pagedListInfo);
    while (rs.next()) {
      User thisUser = new User(rs);
      Suap suap = thisUser.getSuap();
      
    		  try
      {
    			  setComuneSuap(suap,db,rs.getString("istat_comune"));
    			  thisUser.setSuap(suap);
    			  
      }catch(Exception e)
      {
    	  e.printStackTrace();
      }
      
      
      if (thisUser.getContactId() > -1) {
        thisUser.setContact(new Contact(rs));
      }
      if (managerUser != null) {
        thisUser.setManagerId(managerUser.getId());
        thisUser.setManagerUser(managerUser);
      }
      this.add(thisUser);
    }
    rs.close();
    if (pst != null) {
      pst.close();
    }
    buildResources(db);
  }


  

  /**
   * This method is required for synchronization, it allows for the resultset
   * to be streamed with lower overhead
   *
   * @param db  Description of Parameter
   * @return Description of the Returned Value
   * @throws SQLException Description of Exception
   */
  public PreparedStatement prepareList(Connection db,String suffix) throws SQLException {
    ResultSet rs = null;
    int items = -1;
    StringBuffer sqlSelect = new StringBuffer();
    StringBuffer sqlCount = new StringBuffer(); 
    StringBuffer sqlFilter = new StringBuffer();
    StringBuffer sqlOrder = new StringBuffer();
    sqlCount.append(
        "SELECT COUNT(*) AS recordcount " +
            "FROM lista_utenti_centralizzata " +
            "WHERE 1=1 ");
    createFilter(db, sqlFilter);
    if (pagedListInfo != null) {
      //Get the total number of records matching filter
      PreparedStatement pst = db.prepareStatement(
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
     
   
      pagedListInfo.appendSqlTail(db, sqlOrder);
    } else {
      if (includeDHVAdmin) {
        //NOTE: order by user_id is important for sync api to send dhvadmin record first
        sqlOrder.append("ORDER BY access_user_id ");
      } else {
        sqlOrder.append("ORDER BY access_enabled DESC,namelast ");
      }
    }
    //Need to build a base SQL statement for returning records
    if (pagedListInfo != null) {
      pagedListInfo.appendSqlSelectHead(db, sqlSelect);
    } else {
      sqlSelect.append("SELECT ");
    }
    sqlSelect.append(
        " * " +
          
            "FROM lista_utenti_centralizzata " +
            
          
            "WHERE 1=1 ");
    PreparedStatement pst = db.prepareStatement(
        sqlSelect.toString() + sqlFilter.toString() + sqlOrder.toString());
    items = prepareFilter(pst);
    return pst;
  }


  /**
   * For each user, the contact information is retrieved
   *
   * @param db Description of Parameter
   * @throws SQLException Description of Exception
   * @since 1.4
   */
  private void buildResources(Connection db) throws SQLException {
    Iterator i = this.iterator();
    while (i.hasNext()) {
      User thisUser = (User) i.next();
      thisUser.setBuildContact(buildContact);
      thisUser.setBuildContactDetails(buildContactDetails);
      thisUser.setBuildHierarchy(buildHierarchy);
      if (buildContact || buildHierarchy) {
        
      }
   
    }
  }


  /**
   * Limits the recods that are retrieved, works with prepareFilter
   *
   * @param sqlFilter Description of Parameter
   * @since 1.4
   */
  private void createFilter(Connection db, StringBuffer sqlFilter) {
    if (sqlFilter == null) {
      sqlFilter = new StringBuffer();
    }
    
  
    if (StringUtils.hasText(filterUsers)) {
      sqlFilter.append(" AND  access_user_id NOT IN (" + filterUsers + ")");
    }
    
    if (enteredBy > -1) {
      sqlFilter.append(" AND  access_enteredby= ? ");
    }
    if (roleId > -1) {
      sqlFilter.append(" AND  role_id = ? ");
    }
   

   
    if (!includeDHVAdmin) {
      sqlFilter.append(" AND  contact_id_link > -1 ");
    }
    if (enabled != Constants.UNDEFINED) {
      sqlFilter.append(" AND  access_enabled = ? ");
    }
   
    if (username != null) {
      sqlFilter.append(" AND  username = ? ");
    }
    if (password != null) {
      sqlFilter.append(" AND  " + DatabaseUtils.addQuotes(db, "password") + " = ? ");
    }
    
    if (includeUsersWithRolesOnly) {
      sqlFilter.append(" AND  role_id > -1 AND role_id IS NOT NULL ");
    }
    if (roleType != -1) {
      sqlFilter.append(" AND  role_type = ? ");
    }
    // includes only those users who have access to the specified site
    // and those who have access to all sites
    if (siteId != -1) {
      sqlFilter.append(" AND  ");
      if (includeUsersWithAccessToAllSites) {
        sqlFilter.append(" ( ");
      }
      sqlFilter.append("site_id = ? ");
      if (includeUsersWithAccessToAllSites) {
        sqlFilter.append("OR site_id IS NULL ) ");
      }
    }
    // includes only those users who have access to all sites
    if (siteId == -1) {
      if (includeUsersWithAccessToAllSites) {
        sqlFilter.append(" AND  site_id IS NULL ");
      }
    }
  
  }


  /**
   * Limits the recods that are retrieved, works with createFilter
   *
   * @param pst Description of Parameter
   * @return Description of the Returned Value
   * @throws SQLException Description of Exception
   * @since 1.4
   */
  private int prepareFilter(PreparedStatement pst) throws SQLException {
    int i = 0;
    
   
   
    if (enteredBy > -1) {
      pst.setInt(++i, enteredBy);
    }
    if (roleId > -1) {
      pst.setInt(++i, roleId);
    }
    
    if (enabled != Constants.UNDEFINED) {
      pst.setBoolean(++i, enabled == TRUE);
    }
   
    if (username != null) {
      pst.setString(++i, username);
    }
    if (password != null) {
      pst.setString(++i, password);
    }
   
   
    if (roleType != -1) {
      pst.setInt(++i, roleType);
    }
    if (siteId != -1) {
      pst.setInt(++i, siteId);
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
            "FROM " + DatabaseUtils.addQuotes(db, "access") + " a " +
            "LEFT JOIN contact c ON (a.contact_id = c.contact_id) " +
            "LEFT JOIN contact_address ca ON (c.contact_id = ca.contact_id), " +
            "" + DatabaseUtils.addQuotes(db, "role") + " r " +
            "WHERE a.role_id = r.role_id ";
    createFilter(db, sqlFilter);
    PreparedStatement pst = db.prepareStatement(
        sqlCount + sqlFilter.toString());
    int items = prepareFilter(pst);
    ResultSet rs = pst.executeQuery();
    if (rs.next()) {
      recordCount = DatabaseUtils.getInt(rs, "recordcount", 0);
    }
    rs.close();
    pst.close();
    return recordCount;
  }


  /**
   * A convenient method to retrieve a specific contact from the cache
   *
   * @param context Description of the Parameter
   * @param userId  Description of the Parameter
   * @return Description of the Return Value
   */
  public final static Contact retrieveUserContact(ActionContext context, int userId) {
    ConnectionElement ce = (ConnectionElement) context.getSession().getAttribute(
        "ConnectionElement");
    if (ce == null) {
      return null;
    }
    SystemStatus systemStatus = (SystemStatus) ((Hashtable) context.getServletContext().getAttribute(
        "SystemStatus")).get(ce.getUrl());
    if (systemStatus == null) {
      return null;
    }
    User thisUser = systemStatus.getUser(userId);
    if (thisUser != null) {
      Contact thisContact = thisUser.getContact();
      return thisContact;
    } else {
      return null;
    }
  }


  /**
   * Description of the Method
   *
   * @param inList      Description of the Parameter
   * @param currentList Description of the Parameter
   * @return Description of the Return Value
   */
  public static UserList sortEnabledUsers(UserList inList, UserList currentList) {
    int counter = 0;
    Iterator iterator = inList.iterator();
    while (iterator.hasNext()) {
      User thisUser = (User) iterator.next();
      if (!thisUser.getHidden()) {
        if (thisUser.getEnabled()) {
          currentList.add(counter++, thisUser);
        } else {
          currentList.add(thisUser);
        }
      }
    }
    return currentList;
  }


  /**
   * Gets the userIdByName attribute of the UserList object
   *
   * @param name Description of the Parameter
   * @return The userIdByName value
   */
  public int getUserIdByName(String name) {
    int result = -1;
    String[] names = StringUtils.getFirstLastNames(name);
    Iterator iterator = (Iterator) this.iterator();
    while (iterator.hasNext()) {
      User thisUser = (User) iterator.next();
      Contact contact = thisUser.getContact();
      if (ContactUtils.checkNameMatch(contact.getNameLastFirst(), names[1], names[0])) {
        result = thisUser.getId();
        break;
      }
    }
    return result;
  }

  
  
  public int getLocationUserById(int userId) {
	    int result = -1;
	    Iterator iterator = (Iterator) this.iterator();
	    while (iterator.hasNext()) {
	      User thisUser = (User) iterator.next();
	      if (thisUser.getId() == userId) {
	        result = this.indexOf(thisUser);
	        break;
	      }
	    }
	    return result;
	  }

  /**
   * Gets the userById attribute of the UserList object
   *
   * @param userId Description of the Parameter
   * @return The userById value
   */
  public User getUserById(int userId) {
    User result = null;
    Iterator iterator = (Iterator) this.iterator();
    while (iterator.hasNext()) {
      User thisUser = (User) iterator.next();
      if (thisUser.getId() == userId) {
        result = thisUser;
        break;
      }
    }
    return result;
  }
}

