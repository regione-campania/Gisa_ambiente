/*
 *  Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
 *  rights reserved. This material cannot be distributed without written
 *  permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
 *  this material for internal use is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies. DARK HORSE
 *  VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
 *  IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
 *  PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
 *  INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
 *  EVENT SHALL DARK HORSE VENTURES LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
 *  ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
 *  DAMAGES RELATING TO THE SOFTWARE.
 */
package org.aspcfs.modules.troubletickets.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TimeZone;

import org.aspcfs.modules.base.Constants;
import org.aspcfs.modules.base.SyncableList;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.DateUtils;
import org.aspcfs.utils.web.PagedListInfo;

/**
 *  A collection of Ticket objects, can also be used for querying and filtering
 *  the tickets that are included in the list.
 *
 * @author     chris
 * @created    December 5, 2001
 * @version    $Id: TicketList.java,v 1.31.12.1 2004/01/30 16:35:15 kbhoopal Exp
 *      $
 */
public class TicketList extends ArrayList implements SyncableList {
  //sync api
  public final static String tableName = "ticket";
  public final static String uniqueField = "ticketid";
  protected java.sql.Timestamp lastAnchor = null;
  protected java.sql.Timestamp nextAnchor = null;
  protected int syncType = Constants.NO_SYNC;
  //filters
  protected PagedListInfo pagedListInfo = null;
  protected int enteredBy = -1;
  protected boolean onlyOpen = false;
  protected boolean onlyClosed = false;
  protected int id = -1;
  protected int orgId = -1;
  protected int contactId = -1;
  protected int serviceContractId = -1;
  protected int assetId = -1;
  protected int department = -1;
  protected int assignedTo = -1;
  protected int excludeAssignedTo = -1;
  protected boolean onlyAssigned = false;
  protected boolean onlyUnassigned = false;
  protected boolean unassignedToo = false;
  protected int severity = 0;
  protected int priority = 0;
  protected int escalationLevel = 0;
  protected String accountOwnerIdRange = null;
  protected String description = null;
  protected int minutesOlderThan = -1;
  protected int productId = -1;
  protected int customerProductId = -1;
  protected boolean onlyWithProducts = false;
  protected boolean hasEstimatedResolutionDate = false;
  protected int projectId = -1;
  protected int forProjectUser = -1;
  protected int userGroupId = -1;
  protected int inMyUserGroups = -1;
  protected int catCode = -1;
  protected int subCat1 = -1;
  protected int subCat2 = -1;
  protected int subCat3 = -1;
  protected int siteId = -1;
  protected int stateId = -1;
  //search filters
  protected String searchText = "";
  //calendar
  protected java.sql.Timestamp alertRangeStart = null;
  protected java.sql.Timestamp alertRangeEnd = null;
  protected java.sql.Date enteredDateStart = null;
  protected java.sql.Date enteredDateEnd = null;

  protected java.sql.Timestamp trashedDate = null;
  protected boolean includeOnlyTrashed = false;
  protected boolean exclusiveToSite = false;
  protected boolean includeAllSites = true;
  protected boolean projectTicketsOnly = false;

  protected int defectId = -1;
  protected boolean buildDepartmentTickets = false;
  protected HashMap errors = new HashMap();
  protected HashMap warnings = new HashMap();

protected int idStabilimento ;
protected int idApiario ;  
  
protected int altId;

public int getAltId() {
	return altId;
}

public void setAltId(int altId) {
	this.altId = altId;
}

  public int getIdApiario() {
	return idApiario;
}


public void setIdApiario(int idApiario) {
	this.idApiario = idApiario;
}


public int getIdStabilimento() {
	return idStabilimento;
}


public void setIdStabilimento(int idStabilimento) {
	this.idStabilimento = idStabilimento;
}

  /**
   *  Constructor for the TicketList object
   */
  public TicketList() { }


  /**
   *  Sets the lastAnchor attribute of the TicketList object
   *
   * @param  tmp  The new lastAnchor value
   */
  public void setLastAnchor(java.sql.Timestamp tmp) {
    this.lastAnchor = tmp;
  }


  /**
   *  Sets the lastAnchor attribute of the TicketList object
   *
   * @param  tmp  The new lastAnchor value
   */
  public void setLastAnchor(String tmp) {
    try {
      this.lastAnchor = java.sql.Timestamp.valueOf(tmp);
    } catch (Exception e) {
      this.lastAnchor = null;
    }
  }


  /**
   *  Sets the nextAnchor attribute of the TicketList object
   *
   * @param  tmp  The new nextAnchor value
   */
  public void setNextAnchor(java.sql.Timestamp tmp) {
    this.nextAnchor = tmp;
  }


  /**
   *  Sets the nextAnchor attribute of the TicketList object
   *
   * @param  tmp  The new nextAnchor value
   */
  public void setNextAnchor(String tmp) {
    try {
      this.nextAnchor = java.sql.Timestamp.valueOf(tmp);
    } catch (Exception e) {
      this.nextAnchor = null;
    }
  }


  /**
   *  Sets the syncType attribute of the TicketList object
   *
   * @param  tmp  The new syncType value
   */
  public void setSyncType(int tmp) {
    this.syncType = tmp;
  }


  /**
   *  Sets the Id attribute of the TicketList object
   *
   * @param  id  The new Id value
   */
  public void setId(int id) {
    this.id = id;
  }


  /**
   *  Sets the Id attribute of the TicketList object
   *
   * @param  id  The new Id value
   */
  public void setId(String id) {
    this.id = Integer.parseInt(id);
  }


  /**
   *  Sets the assignedTo attribute of the TicketList object
   *
   * @param  assignedTo  The new assignedTo value
   */
  public void setAssignedTo(int assignedTo) {
    this.assignedTo = assignedTo;
  }


  /**
   *  Sets the assignedTo attribute of the TicketList object
   *
   * @param  assignedTo  The new assignedTo value
   */
  public void setAssignedTo(String assignedTo) {
    this.assignedTo = Integer.parseInt(assignedTo);
  }


  /**
   *  Sets the excludeAssignedTo attribute of the TicketList object
   *
   * @param  tmp  The new excludeAssignedTo value
   */
  public void setExcludeAssignedTo(int tmp) {
    this.excludeAssignedTo = tmp;
  }


  /**
   *  Sets the excludeAssignedTo attribute of the TicketList object
   *
   * @param  tmp  The new excludeAssignedTo value
   */
  public void setExcludeAssignedTo(String tmp) {
    this.excludeAssignedTo = Integer.parseInt(tmp);
  }


  /**
   *  Sets the onlyAssigned attribute of the TicketList object
   *
   * @param  tmp  The new onlyAssigned value
   */
  public void setOnlyAssigned(boolean tmp) {
    this.onlyAssigned = tmp;
  }


  /**
   *  Sets the onlyAssigned attribute of the TicketList object
   *
   * @param  tmp  The new onlyAssigned value
   */
  public void setOnlyAssigned(String tmp) {
    this.onlyAssigned = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Sets the onlyUnassigned attribute of the TicketList object
   *
   * @param  tmp  The new onlyUnassigned value
   */
  public void setOnlyUnassigned(boolean tmp) {
    this.onlyUnassigned = tmp;
  }


  /**
   *  Sets the onlyUnassigned attribute of the TicketList object
   *
   * @param  tmp  The new onlyUnassigned value
   */
  public void setOnlyUnassigned(String tmp) {
    this.onlyUnassigned = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Sets the unassignedToo attribute of the TicketList object
   *
   * @param  unassignedToo  The new unassignedToo value
   */
  public void setUnassignedToo(boolean unassignedToo) {
    this.unassignedToo = unassignedToo;
  }


  /**
   *  Sets the severity attribute of the TicketList object
   *
   * @param  tmp  The new severity value
   */
  public void setSeverity(int tmp) {
    this.severity = tmp;
  }


  /**
   *  Sets the priority attribute of the TicketList object
   *
   * @param  tmp  The new priority value
   */
  public void setPriority(int tmp) {
    this.priority = tmp;
  }


  /**
   *  Sets the severity attribute of the TicketList object
   *
   * @param  tmp  The new severity value
   */
  public void setSeverity(String tmp) {
    this.severity = Integer.parseInt(tmp);
  }


  /**
   *  Sets the escalationLevel attribute of the TicketList object
   *
   * @param  tmp  The new escalationLevel value
   */
  public void setEscalationLevel(int tmp) {
    this.escalationLevel = tmp;
  }


  /**
   *  Sets the escalationLevel attribute of the TicketList object
   *
   * @param  tmp  The new escalationLevel value
   */
  public void setEscalationLevel(String tmp) {
    this.escalationLevel = Integer.parseInt(tmp);
  }


  /**
   *  Sets the projectId attribute of the TicketList object
   *
   * @param  tmp  The new projectId value
   */
  public void setProjectId(int tmp) {
    this.projectId = tmp;
  }


  /**
   *  Sets the forProjectUser attribute of the TicketList object
   *
   * @param  tmp  The new forProjectUser value
   */
  public void setForProjectUser(int tmp) {
    this.forProjectUser = tmp;
  }


  /**
   *  Sets the forProjectUser attribute of the TicketList object
   *
   * @param  tmp  The new forProjectUser value
   */
  public void setForProjectUser(String tmp) {
    this.forProjectUser = Integer.parseInt(tmp);
  }


  /**
   *  Sets the siteId attribute of the TicketList object
   *
   * @param  tmp  The new siteId value
   */
  public void setSiteId(int tmp) {
    this.siteId = tmp;
  }


  /**
   *  Sets the siteId attribute of the TicketList object
   *
   * @param  tmp  The new siteId value
   */
  public void setSiteId(String tmp) {
    this.siteId = Integer.parseInt(tmp);
  }


  /**
   *  Sets the productId attribute of the TicketList object
   *
   * @param  tmp  The new productId value
   */
  public void setProductId(int tmp) {
    this.productId = tmp;
  }


  /**
   *  Sets the productId attribute of the TicketList object
   *
   * @param  tmp  The new productId value
   */
  public void setProductId(String tmp) {
    this.productId = Integer.parseInt(tmp);
  }


  /**
   *  Sets the customerProductId attribute of the TicketList object
   *
   * @param  tmp  The new customerProductId value
   */
  public void setCustomerProductId(int tmp) {
    this.customerProductId = tmp;
  }


  /**
   *  Sets the customerProductId attribute of the TicketList object
   *
   * @param  tmp  The new customerProductId value
   */
  public void setCustomerProductId(String tmp) {
    this.customerProductId = Integer.parseInt(tmp);
  }


  /**
   *  Sets the alertRangeStart attribute of the TicketList object
   *
   * @param  tmp  The new alertRangeStart value
   */
  public void setAlertRangeStart(java.sql.Timestamp tmp) {
    this.alertRangeStart = tmp;
  }


  /**
   *  Sets the alertRangeStart attribute of the TicketList object
   *
   * @param  tmp  The new alertRangeStart value
   */
  public void setAlertRangeStart(String tmp) {
    this.alertRangeStart = DatabaseUtils.parseTimestamp(tmp);
  }


  /**
   *  Sets the alertRangeEnd attribute of the TicketList object
   *
   * @param  tmp  The new alertRangeEnd value
   */
  public void setAlertRangeEnd(java.sql.Timestamp tmp) {
    this.alertRangeEnd = tmp;
  }


  /**
   *  Sets the alertRangeEnd attribute of the TicketList object
   *
   * @param  tmp  The new alertRangeEnd value
   */
  public void setAlertRangeEnd(String tmp) {
    this.alertRangeEnd = DatabaseUtils.parseTimestamp(tmp);
  }


  /**
   *  Gets the alertRangeStart attribute of the TicketList object
   *
   * @return    The alertRangeStart value
   */
  public java.sql.Timestamp getAlertRangeStart() {
    return alertRangeStart;
  }


  /**
   *  Gets the alertRangeEnd attribute of the TicketList object
   *
   * @return    The alertRangeEnd value
   */
  public java.sql.Timestamp getAlertRangeEnd() {
    return alertRangeEnd;
  }


  /**
   *  Gets the productId attribute of the TicketList object
   *
   * @return    The productId value
   */
  public int getProductId() {
    return productId;
  }


  /**
   *  Gets the customerProductId attribute of the TicketList object
   *
   * @return    The customerProductId value
   */
  public int getCustomerProductId() {
    return customerProductId;
  }


  /**
   *  Sets the onlyWithProducts attribute of the TicketList object
   *
   * @param  tmp  The new onlyWithProducts value
   */
  public void setOnlyWithProducts(boolean tmp) {
    this.onlyWithProducts = tmp;
  }


  /**
   *  Sets the hasEstimatedResolutionDate attribute of the TicketList object
   *
   * @param  tmp  The new hasEstimatedResolutionDate value
   */
  public void setHasEstimatedResolutionDate(boolean tmp) {
    this.hasEstimatedResolutionDate = tmp;
  }


  /**
   *  Sets the hasEstimatedResolutionDate attribute of the TicketList object
   *
   * @param  tmp  The new hasEstimatedResolutionDate value
   */
  public void setHasEstimatedResolutionDate(String tmp) {
    this.hasEstimatedResolutionDate = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   * Sets the enteredBy attribute of the TicketList object
   *
   * @param tmp The new enteredBy value
   */
  public void setTicketEnteredBy(String tmp) {
    this.enteredBy = Integer.parseInt(tmp);
  }


  /**
   * Sets the enteredBy attribute of the TicketList object
   *
   * @param tmp The new enteredBy value
   */
  public void setTicketEnteredBy(int tmp) {
    this.enteredBy = tmp;
  }


  /**
   *  Gets the tableName attribute of the TicketList object
   *
   * @return    The tableName value
   */
  public String getTableName() {
    return tableName;
  }


  /**
   *  Gets the uniqueField attribute of the TicketList object
   *
   * @return    The uniqueField value
   */
  public String getUniqueField() {
    return uniqueField;
  }


  /**
   *  Sets the priority attribute of the TicketList object
   *
   * @param  tmp  The new priority value
   */
  public void setPriority(String tmp) {
    this.priority = Integer.parseInt(tmp);
  }


  /**
   *  Sets the searchText attribute of the TicketList object
   *
   * @param  searchText  The new searchText value
   */
  public void setSearchText(String searchText) {
    this.searchText = searchText;
  }


  /**
   *  Sets the accountOwnerIdRange attribute of the TicketList object
   *
   * @param  accountOwnerIdRange  The new accountOwnerIdRange value
   */
  public void setAccountOwnerIdRange(String accountOwnerIdRange) {
    this.accountOwnerIdRange = accountOwnerIdRange;
  }


  /**
   *  Sets the OrgId attribute of the TicketList object
   *
   * @param  orgId  The new OrgId value
   */
  public void setOrgId(int orgId) {
    this.orgId = orgId;
  }


  /**
   *  Sets the OrgId attribute of the TicketList object
   *
   * @param  orgId  The new OrgId value
   */
  public void setOrgId(String orgId) {
    this.orgId = Integer.parseInt(orgId);
  }


  /**
   *  Sets the contactId attribute of the TicketList object
   *
   * @param  tmp  The new contactId value
   */
  public void setContactId(int tmp) {
    this.contactId = tmp;
  }


  /**
   *  Sets the contactId attribute of the TicketList object
   *
   * @param  tmp  The new contactId value
   */
  public void setContactId(String tmp) {
    this.contactId = Integer.parseInt(tmp);
  }


  /**
   *  Sets the serviceContractId attribute of the TicketList object
   *
   * @param  tmp  The new serviceContractId value
   */
  public void setServiceContractId(int tmp) {
    this.serviceContractId = tmp;
  }


  /**
   *  Sets the serviceContractId attribute of the TicketList object
   *
   * @param  tmp  The new serviceContractId value
   */
  public void setServiceContractId(String tmp) {
    this.serviceContractId = Integer.parseInt(tmp);
  }


  /**
   *  Sets the assetId attribute of the TicketList object
   *
   * @param  tmp  The new assetId value
   */
  public void setAssetId(int tmp) {
    this.assetId = tmp;
  }


  /**
   *  Sets the assetId attribute of the TicketList object
   *
   * @param  tmp  The new assetId value
   */
  public void setAssetId(String tmp) {
    this.assetId = Integer.parseInt(tmp);
  }


  /**
   *  Sets the PagedListInfo attribute of the TicketList object
   *
   * @param  tmp  The new PagedListInfo value
   */
  public void setPagedListInfo(PagedListInfo tmp) {
    this.pagedListInfo = tmp;
  }


  /**
   *  Sets the EnteredBy attribute of the TicketList object
   *
   * @param  tmp  The new EnteredBy value
   */
  public void setEnteredBy(int tmp) {
    this.enteredBy = tmp;
  }


  /**
   *  Gets the description attribute of the TicketList object
   *
   * @return    The description value
   */
  public String getDescription() {
    return description;
  }


  /**
   *  Sets the description attribute of the TicketList object
   *
   * @param  description  The new description value
   */
  public void setDescription(String description) {
    this.description = description;
  }


  /**
   *  Sets the minutesOlderThan attribute of the TicketList object
   *
   * @param  tmp  The new minutesOlderThan value
   */
  public void setMinutesOlderThan(int tmp) {
    this.minutesOlderThan = tmp;
  }


  /**
   *  Sets the minutesOlderThan attribute of the TicketList object
   *
   * @param  tmp  The new minutesOlderThan value
   */
  public void setMinutesOlderThan(String tmp) {
    this.minutesOlderThan = Integer.parseInt(tmp);
  }


  /**
   *  Sets the onlyClosed attribute of the TicketList object
   *
   * @param  onlyClosed  The new onlyClosed value
   */
  public void setOnlyClosed(boolean onlyClosed) {
    this.onlyClosed = onlyClosed;
  }


  /**
   *  Sets the OnlyOpen attribute of the TicketList object
   *
   * @param  onlyOpen  The new OnlyOpen value
   */
  public void setOnlyOpen(boolean onlyOpen) {
    this.onlyOpen = onlyOpen;
  }


  /**
   *  Sets the Department attribute of the TicketList object
   *
   * @param  department  The new Department value
   */
  public void setDepartment(int department) {
    this.department = department;
  }


  /**
   *  Gets the assignedTo attribute of the TicketList object
   *
   * @return    The assignedTo value
   */
  public int getAssignedTo() {
    return assignedTo;
  }


  /**
   *  Gets the excludeAssignedTo attribute of the TicketList object
   *
   * @return    The excludeAssignedTo value
   */
  public int getExcludeAssignedTo() {
    return excludeAssignedTo;
  }


  /**
   *  Gets the onlyAssigned attribute of the TicketList object
   *
   * @return    The onlyAssigned value
   */
  public boolean getOnlyAssigned() {
    return onlyAssigned;
  }


  /**
   *  Gets the onlyUnassigned attribute of the TicketList object
   *
   * @return    The onlyUnassigned value
   */
  public boolean getOnlyUnassigned() {
    return onlyUnassigned;
  }


  /**
   *  Gets the unassignedToo attribute of the TicketList object
   *
   * @return    The unassignedToo value
   */
  public boolean getUnassignedToo() {
    return unassignedToo;
  }


  /**
   *  Gets the severity attribute of the TicketList object
   *
   * @return    The severity value
   */
  public int getSeverity() {
    return severity;
  }


  /**
   *  Gets the priority attribute of the TicketList object
   *
   * @return    The priority value
   */
  public int getPriority() {
    return priority;
  }


  /**
   *  Gets the escalationLevel attribute of the TicketList object
   *
   * @return    The escalationLevel value
   */
  public int getEscalationLevel() {
    return escalationLevel;
  }


  /**
   *  Gets the searchText attribute of the TicketList object
   *
   * @return    The searchText value
   */
  public String getSearchText() {
    return searchText;
  }


  /**
   *  Gets the accountOwnerIdRange attribute of the TicketList object
   *
   * @return    The accountOwnerIdRange value
   */
  public String getAccountOwnerIdRange() {
    return accountOwnerIdRange;
  }


  /**
   *  Gets the onlyClosed attribute of the TicketList object
   *
   * @return    The onlyClosed value
   */
  public boolean getOnlyClosed() {
    return onlyClosed;
  }


  /**
   *  Gets the OrgId attribute of the TicketList object
   *
   * @return    The OrgId value
   */
  public int getOrgId() {
    return orgId;
  }


  /**
   *  Gets the contactId attribute of the TicketList object
   *
   * @return    The contactId value
   */
  public int getContactId() {
    return contactId;
  }


  /**
   *  Gets the serviceContractId attribute of the TicketList object
   *
   * @return    The serviceContractId value
   */
  public int getServiceContractId() {
    return serviceContractId;
  }


  /**
   *  Gets the assetId attribute of the TicketList object
   *
   * @return    The assetId value
   */
  public int getAssetId() {
    return assetId;
  }


  /**
   *  Gets the Id attribute of the TicketList object
   *
   * @return    The Id value
   */
  public int getId() {
    return id;
  }


  /**
   *  Gets the OnlyOpen attribute of the TicketList object
   *
   * @return    The OnlyOpen value
   */
  public boolean getOnlyOpen() {
    return onlyOpen;
  }


  /**
   *  Gets the Department attribute of the TicketList object
   *
   * @return    The Department value
   */
  public int getDepartment() {
    return department;
  }


  /**
   *  Gets the hasEstimatedResolutionDate attribute of the TicketList object
   *
   * @return    The hasEstimatedResolutionDate value
   */
  public boolean getHasEstimatedResolutionDate() {
    return hasEstimatedResolutionDate;
  }


  /**
   *  Gets the pagedListInfo attribute of the TicketList object
   *
   * @return    The pagedListInfo value
   */
  public PagedListInfo getPagedListInfo() {
    return pagedListInfo;
  }


  /**
   *  Gets the forProjectUser attribute of the TicketList object
   *
   * @return    The forProjectUser value
   */
  public int getForProjectUser() {
    return forProjectUser;
  }


  /**
   *  Gets the siteId attribute of the TicketList object
   *
   * @return    The siteId value
   */
  public int getSiteId() {
    return siteId;
  }


  /**
   *  Sets the trashedDate attribute of the TicketList object
   *
   * @param  tmp  The new trashedDate value
   */
  public void setTrashedDate(java.sql.Timestamp tmp) {
    this.trashedDate = tmp;
  }


  /**
   *  Sets the trashedDate attribute of the TicketList object
   *
   * @param  tmp  The new trashedDate value
   */
  public void setTrashedDate(String tmp) {
    this.trashedDate = DatabaseUtils.parseTimestamp(tmp);
  }


  /**
   *  Sets the includeOnlyTrashed attribute of the TicketList object
   *
   * @param  tmp  The new includeOnlyTrashed value
   */
  public void setIncludeOnlyTrashed(boolean tmp) {
    this.includeOnlyTrashed = tmp;
  }


  /**
   *  Sets the includeOnlyTrashed attribute of the TicketList object
   *
   * @param  tmp  The new includeOnlyTrashed value
   */
  public void setIncludeOnlyTrashed(String tmp) {
    this.includeOnlyTrashed = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Gets the trashedDate attribute of the TicketList object
   *
   * @return    The trashedDate value
   */
  public java.sql.Timestamp getTrashedDate() {
    return trashedDate;
  }


  /**
   *  Gets the includeOnlyTrashed attribute of the TicketList object
   *
   * @return    The includeOnlyTrashed value
   */
  public boolean getIncludeOnlyTrashed() {
    return includeOnlyTrashed;
  }


  /**
   *  Gets the userGroupId attribute of the TicketList object
   *
   * @return    The userGroupId value
   */
  public int getUserGroupId() {
    return userGroupId;
  }


  /**
   *  Sets the userGroupId attribute of the TicketList object
   *
   * @param  tmp  The new userGroupId value
   */
  public void setUserGroupId(int tmp) {
    this.userGroupId = tmp;
  }


  /**
   *  Sets the userGroupId attribute of the TicketList object
   *
   * @param  tmp  The new userGroupId value
   */
  public void setUserGroupId(String tmp) {
    this.userGroupId = Integer.parseInt(tmp);
  }


  /**
   *  Gets the inMyUserGroups attribute of the TicketList object
   *
   * @return    The inMyUserGroups value
   */
  public int getInMyUserGroups() {
    return inMyUserGroups;
  }


  /**
   *  Sets the inMyUserGroups attribute of the TicketList object
   *
   * @param  tmp  The new inMyUserGroups value
   */
  public void setInMyUserGroups(int tmp) {
    this.inMyUserGroups = tmp;
  }


  /**
   *  Sets the inMyUserGroups attribute of the TicketList object
   *
   * @param  tmp  The new inMyUserGroups value
   */
  public void setInMyUserGroups(String tmp) {
    this.inMyUserGroups = Integer.parseInt(tmp);
  }


  /**
   *  Gets the catCode attribute of the TicketList object
   *
   * @return    The catCode value
   */
  public int getCatCode() {
    return catCode;
  }


  /**
   *  Sets the catCode attribute of the TicketList object
   *
   * @param  tmp  The new catCode value
   */
  public void setCatCode(int tmp) {
    this.catCode = tmp;
  }


  /**
   *  Sets the catCode attribute of the TicketList object
   *
   * @param  tmp  The new catCode value
   */
  public void setCatCode(String tmp) {
    this.catCode = Integer.parseInt(tmp);
  }


  /**
   *  Gets the subCat1 attribute of the TicketList object
   *
   * @return    The subCat1 value
   */
  public int getSubCat1() {
    return subCat1;
  }


  /**
   *  Sets the subCat1 attribute of the TicketList object
   *
   * @param  tmp  The new subCat1 value
   */
  public void setSubCat1(int tmp) {
    this.subCat1 = tmp;
  }


  /**
   *  Sets the subCat1 attribute of the TicketList object
   *
   * @param  tmp  The new subCat1 value
   */
  public void setSubCat1(String tmp) {
    this.subCat1 = Integer.parseInt(tmp);
  }


  /**
   *  Gets the subCat2 attribute of the TicketList object
   *
   * @return    The subCat2 value
   */
  public int getSubCat2() {
    return subCat2;
  }


  /**
   *  Sets the subCat2 attribute of the TicketList object
   *
   * @param  tmp  The new subCat2 value
   */
  public void setSubCat2(int tmp) {
    this.subCat2 = tmp;
  }


  /**
   *  Sets the subCat2 attribute of the TicketList object
   *
   * @param  tmp  The new subCat2 value
   */
  public void setSubCat2(String tmp) {
    this.subCat2 = Integer.parseInt(tmp);
  }


  /**
   *  Gets the subCat3 attribute of the TicketList object
   *
   * @return    The subCat3 value
   */
  public int getSubCat3() {
    return subCat3;
  }


  /**
   *  Sets the subCat3 attribute of the TicketList object
   *
   * @param  tmp  The new subCat3 value
   */
  public void setSubCat3(int tmp) {
    this.subCat3 = tmp;
  }


  /**
   *  Sets the subCat3 attribute of the TicketList object
   *
   * @param  tmp  The new subCat3 value
   */
  public void setSubCat3(String tmp) {
    this.subCat3 = Integer.parseInt(tmp);
  }


  /**
   *  Gets the defectId attribute of the TicketList object
   *
   * @return    The defectId value
   */
  public int getDefectId() {
    return defectId;
  }


  /**
   *  Sets the defectId attribute of the TicketList object
   *
   * @param  tmp  The new defectId value
   */
  public void setDefectId(int tmp) {
    this.defectId = tmp;
  }


  /**
   *  Sets the defectId attribute of the TicketList object
   *
   * @param  tmp  The new defectId value
   */
  public void setDefectId(String tmp) {
    this.defectId = Integer.parseInt(tmp);
  }


  /**
   *  Sets the buildDepartmentTickets attribute of the TicketList object
   *
   * @param  tmp  The new buildDepartmentTickets value
   */
  public void setBuildDepartmentTickets(boolean tmp) {
    this.buildDepartmentTickets = tmp;
  }


  /**
   *  Sets the buildDepartmentTickets attribute of the TicketList object
   *
   * @param  tmp  The new buildDepartmentTickets value
   */
  public void setBuildDepartmentTickets(String tmp) {
    this.buildDepartmentTickets = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Gets the buildDepartmentTickets attribute of the TicketList object
   *
   * @return    The buildDepartmentTickets value
   */
  public boolean getBuildDepartmentTickets() {
    return buildDepartmentTickets;
  }

  /**
   *  Gets the exclusiveToSite attribute of the TicketList object
   *
   * @return    The exclusiveToSite value
   */
  public boolean getExclusiveToSite() {
    return exclusiveToSite;
  }


  /**
   *  Sets the exclusiveToSite attribute of the TicketList object
   *
   * @param  tmp  The new exclusiveToSite value
   */
  public void setExclusiveToSite(boolean tmp) {
    this.exclusiveToSite = tmp;
  }


  /**
   *  Sets the exclusiveToSite attribute of the TicketList object
   *
   * @param  tmp  The new exclusiveToSite value
   */
  public void setExclusiveToSite(String tmp) {
    this.exclusiveToSite = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Gets the errors attribute of the TicketList object
   *
   * @return    The errors value
   */
  public HashMap getErrors() {
    return errors;
  }


  /**
   *  Description of the Method
   *
   * @return    Description of the Return Value
   */
  public boolean hasErrors() {
    return (errors.size() > 0);
  }


  /**
   *  Sets the errors attribute of the TicketList object
   *
   * @param  tmp  The new errors value
   */
  public void setErrors(HashMap tmp) {
    this.errors = tmp;
  }


  /**
   *  Gets the warnings attribute of the TicketList object
   *
   * @return    The warnings value
   */
  public HashMap getWarnings() {
    return warnings;
  }


  /**
   *  Description of the Method
   *
   * @return    Description of the Return Value
   */
  public boolean hasWarnings() {
    return (warnings.size() > 0);
  }


  /**
   *  Sets the warnings attribute of the TicketList object
   *
   * @param  tmp  The new warnings value
   */
  public void setWarnings(HashMap tmp) {
    this.warnings = tmp;
  }


  /**
   *  Gets the enteredDateStart attribute of the TicketList object
   *
   * @return    The enteredDateStart value
   */
  public java.sql.Date getEnteredDateStart() {
    return enteredDateStart;
  }


  /**
   *  Sets the enteredDateStart attribute of the TicketList object
   *
   * @param  tmp  The new enteredDateStart value
   */
  public void setEnteredDateStart(String tmp) {
    try {
      java.util.Date tmpDate = DateFormat.getDateInstance(3).parse(tmp);
      enteredDateStart = new java.sql.Date(new java.util.Date().getTime());
      enteredDateStart.setTime(tmpDate.getTime());
    } catch (Exception e) {
      enteredDateStart = null;
    }
  }


  /**
   *  Sets the enteredDateStart attribute of the TicketList object
   *
   * @param  tmp  The new enteredDateStart value
   */
  public void setEnteredDateStart(java.sql.Date tmp) {
    this.enteredDateStart = tmp;
  }


  /**
   *  Gets the enteredDateEnd attribute of the TicketList object
   *
   * @return    The enteredDateEnd value
   */
  public java.sql.Date getEnteredDateEnd() {
    return enteredDateEnd;
  }


  /**
   *  Sets the enteredDateEnd attribute of the TicketList object
   *
   * @param  tmp  The new enteredDateEnd value
   */
  public void setEnteredDateEnd(java.sql.Date tmp) {
    this.enteredDateEnd = tmp;
  }


  /**
   *  Sets the enteredDateEnd attribute of the TicketList object
   *
   * @param  tmp  The new enteredDateEnd value
   */
  public void setEnteredDateEnd(String tmp) {
    try {
      java.util.Date tmpDate = DateFormat.getDateInstance(3).parse(tmp);
      enteredDateEnd = new java.sql.Date(new java.util.Date().getTime());
      enteredDateEnd.setTime(tmpDate.getTime());
    } catch (Exception e) {
      enteredDateEnd = null;
    }
  }


  /**
   *  Gets the includeAllSites attribute of the TicketList object
   *
   * @return    The includeAllSites value
   */
  public boolean getIncludeAllSites() {
    return includeAllSites;
  }


  /**
   *  Sets the includeAllSites attribute of the TicketList object
   *
   * @param  tmp  The new includeAllSites value
   */
  public void setIncludeAllSites(boolean tmp) {
    this.includeAllSites = tmp;
  }


  /**
   *  Sets the includeAllSites attribute of the TicketList object
   *
   * @param  tmp  The new includeAllSites value
   */
  public void setIncludeAllSites(String tmp) {
    this.includeAllSites = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Gets the projectTicketsOnly attribute of the TicketList object
   *
   * @return    The projectTicketsOnly value
   */
  public boolean getProjectTicketsOnly() {
    return projectTicketsOnly;
  }


  /**
   *  Sets the projectTicketsOnly attribute of the TicketList object
   *
   * @param  tmp  The new projectTicketsOnly value
   */
  public void setProjectTicketsOnly(boolean tmp) {
    this.projectTicketsOnly = tmp;
  }


  /**
   *  Sets the projectTicketsOnly attribute of the TicketList object
   *
   * @param  tmp  The new projectTicketsOnly value
   */
  public void setProjectTicketsOnly(String tmp) {
    this.projectTicketsOnly = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Description of the Method
   *
   * @param  db             Description of Parameter
   * @throws  SQLException  Description of Exception
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
        "FROM ticket t " +
        "LEFT JOIN organization o ON (t.org_id = o.org_id) " +
       
        "LEFT JOIN asset a ON (t.link_asset_id = a.asset_id) " +
       
        "LEFT JOIN user_group ug ON (t.user_group_id = ug.group_id) " +
        "WHERE t.ticketid > 0 AND t.tipo_richiesta IS NULL ");
    createFilter(sqlFilter, db);
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
      // Declare default sort, if unset
      pagedListInfo.setDefaultSort("t.entered", null);
      //Determine the offset, based on the filter, for the first record to show
      if (pagedListInfo.getMode() == PagedListInfo.DETAILS_VIEW && id > 0) {
        String direction = null;
        if ("desc".equalsIgnoreCase(pagedListInfo.getSortOrder())) {
          direction = ">";
        } else {
          direction = "<";
        }
        String sqlSubCount =
            " AND  " +
            (pagedListInfo.getColumnToSortBy().equals("t.problem") ? DatabaseUtils.convertToVarChar(
            db, pagedListInfo.getColumnToSortBy()) : pagedListInfo.getColumnToSortBy()) + " " +
            direction + " " +
            "(SELECT " + (pagedListInfo.getColumnToSortBy().equals(
            "t.problem") ? DatabaseUtils.convertToVarChar(
            db, pagedListInfo.getColumnToSortBy()) : pagedListInfo.getColumnToSortBy()) + " " +
            "FROM ticket t WHERE ticketid = ?) ";
        pst = db.prepareStatement(
            sqlCount.toString() +
            sqlFilter.toString() +
            sqlSubCount);
        items = prepareFilter(pst);
        pst.setInt(++items, id);
        rs = pst.executeQuery();
        if (rs.next()) {
          int offsetCount = rs.getInt("recordcount");
          pagedListInfo.setCurrentOffset(offsetCount);
        }
        rs.close();
        pst.close();
      }
      //Determine the offset
      pagedListInfo.appendSqlTail(db, sqlOrder);
    } else {
      sqlOrder.append("ORDER BY t.entered ");
    }

    //Need to build a base SQL statement for returning records
    if (pagedListInfo != null) {
      pagedListInfo.appendSqlSelectHead(db, sqlSelect);
    } else {
      sqlSelect.append("SELECT ");
    }
    sqlSelect.append(
        "t.*, " +
        "o.name AS orgname, " +
        "o.enabled AS orgenabled, " +
        "o.site_id AS orgsiteid, " +
       
        "a.serial_number AS serialnumber, " +
        "a.manufacturer_code AS assetmanufacturercode, " +
        "a.vendor_code AS assetvendorcode, " +
        "a.model_version AS modelversion, " +
        "a.location AS assetlocation, " +
        "a.onsite_service_model AS assetonsiteservicemodel  " +
       
        "FROM ticket t " +
        "LEFT JOIN organization o ON (t.org_id = o.org_id) " +
        
        "LEFT JOIN asset a ON (t.link_asset_id = a.asset_id) " +
        
        "WHERE t.ticketid > 0 AND t.tipo_richiesta IS NULL ");
    pst = db.prepareStatement(
        sqlSelect.toString() + sqlFilter.toString() + sqlOrder.toString());
    items = prepareFilter(pst);
    if (pagedListInfo != null) {
      pagedListInfo.doManualOffset(db, pst);
    }
		if (System.getProperty("DEBUG") != null) {
			//System.out.println(pst);
		}
    rs = pst.executeQuery();
    if (pagedListInfo != null) {
      pagedListInfo.doManualOffset(db, rs);
    }
    while (rs.next()) {
      Ticket thisTicket = new Ticket(rs);
      this.add(thisTicket);
    }
    rs.close();
    pst.close();
    //Build resources
    Iterator i = this.iterator();
    while (i.hasNext()) {
      Ticket thisTicket = (Ticket) i.next();
     
    }
  }


  /**
   *  Description of the Method
   *
   * @param  db             Description of Parameter
   * @param  basePath       Description of the Parameter
   * @throws  SQLException  Description of Exception
   */
  public void delete(Connection db, String basePath) throws SQLException {
    Iterator tickets = this.iterator();
    while (tickets.hasNext()) {
      Ticket thisTicket = (Ticket) tickets.next();
      thisTicket.delete(db, basePath);
    }
  }





  /**
   *  Builds a base SQL where statement for filtering records to be used by
   *  sqlSelect and sqlCount
   *
   * @param  sqlFilter  Description of Parameter
   * @param  db         Description of the Parameter
   * @since             1.2
   */
  protected void createFilter(StringBuffer sqlFilter, Connection db) {
    if (enteredBy > -1) {
      sqlFilter.append(" AND  t.enteredby = ? ");
    }
    if (description != null) {
      if (description.indexOf("%") >= 0) {
        sqlFilter.append(
            " AND  (" + DatabaseUtils.toLowerCase(db) + "(" + DatabaseUtils.convertToVarChar(
            db, "t.problem") + ") LIKE ?) ");
      } else {
        sqlFilter.append(
            " AND  (" + DatabaseUtils.toLowerCase(db) + "(" + DatabaseUtils.convertToVarChar(
            db, "t.problem") + ") = ?) ");
      }
    }
    if (onlyOpen) {
      sqlFilter.append(" AND  t.closed IS NULL ");
    }
    if (onlyClosed) {
      sqlFilter.append(" AND  t.closed IS NOT NULL ");
    }
    if (id > -1) {
      if (pagedListInfo == null || pagedListInfo.getMode() != PagedListInfo.DETAILS_VIEW) {
        sqlFilter.append(" AND  t.ticketid = ? ");
      }
    }
    if (orgId > -1) {
      sqlFilter.append(" AND  t.org_id = ? ");
    }
    if (contactId > -1) {
      sqlFilter.append(" AND  t.contact_id = ? ");
    }
    if (serviceContractId > -1) {
      sqlFilter.append(" AND  t.link_contract_id = ? ");
    }
    if (assetId > -1) {
      sqlFilter.append(" AND  t.link_asset_id = ? ");
    }
    if (buildDepartmentTickets){
      if (department > 0) {
        if (unassignedToo) {
          sqlFilter.append(
              " AND  (t.department_code in (?, 0, -1) OR ((t.assigned_to IS NULL OR t.assigned_to = 0 OR t.assigned_to = -1) AND (t.user_group_id IS NULL OR t.user_group_id = 0 OR t.user_group_id = -1)))");
        } else {
          sqlFilter.append(" AND  t.department_code = ? ");
        }
      } else {
        sqlFilter.append(" AND  t.department_code IS NULL ");
      }
    }
    if (assignedTo > -1) {
      sqlFilter.append(" AND  t.assigned_to = ? ");
    }
    if (excludeAssignedTo > -1) {
      sqlFilter.append(" AND  (t.assigned_to <> ? OR t.assigned_to IS NULL) ");
    }
    if (onlyAssigned) {
      sqlFilter.append(" AND  (t.assigned_to > 0 AND t.assigned_to IS NOT NULL) ");
    }
    if (onlyUnassigned) {
      sqlFilter.append(
          " AND  (t.assigned_to IS NULL OR t.assigned_to = 0 OR t.assigned_to = -1) ");
    }
    if (severity > 0) {
      sqlFilter.append(" AND  t.scode = ? ");
    }
    if (priority > 0) {
      sqlFilter.append(" AND  t.pri_code = ? ");
    }
    if (escalationLevel > 0) {
      sqlFilter.append(" AND  t.escalation_level = ? ");
    }
    if (accountOwnerIdRange != null) {
      sqlFilter.append(
          " AND  t.org_id IN (SELECT org_id FROM organization WHERE owner IN (" + accountOwnerIdRange + ")) ");
    }
    if (productId != -1) {
      sqlFilter.append(" AND  t.product_id = ? ");
    }
    if (customerProductId != -1) {
      sqlFilter.append(" AND  t.customer_product_id = ? ");
    }
    if (onlyWithProducts) {
      sqlFilter.append(" AND  t.product_id IS NOT NULL ");
    }
    if (projectId > 0) {
      sqlFilter.append(
          " AND  t.ticketid IN (SELECT ticket_id FROM ticketlink_project WHERE project_id = ?) ");
    }
    if (forProjectUser > -1) {
      sqlFilter.append(
          " AND  t.ticketid IN (SELECT ticket_id FROM ticketlink_project WHERE project_id in (SELECT DISTINCT project_id FROM project_team WHERE user_id = ? " +
          " AND  status IS NULL)) ");
    }
    if ((projectId == -1) && (forProjectUser == -1) && !projectTicketsOnly) {
      sqlFilter.append(
          " AND  t.ticketid NOT IN (SELECT ticket_id FROM ticketlink_project) ");
    } else if (projectTicketsOnly) {
      sqlFilter.append(" AND  t.ticketid IN (SELECT ticket_id FROM ticketlink_project) ");
    }

    if (catCode != -1) {
      sqlFilter.append(" AND  t.cat_code = ? ");
    }
    if (subCat1 != -1) {
      sqlFilter.append(" AND  t.subcat_code1 = ? ");
    }
    if (subCat2 != -1) {
      sqlFilter.append(" AND  t.subcat_code2 = ? ");
    }
    if (subCat3 != -1) {
      sqlFilter.append(" AND  t.subcat_code3 = ? ");
    }
    if ((!includeAllSites) || (orgId == -1 && contactId == -1 && forProjectUser == -1
         && id == -1 && serviceContractId == -1 && assetId == -1 && projectId == -1 && userGroupId == -1
         && inMyUserGroups == -1)) {
      if (siteId != -1) {
        sqlFilter.append(" AND  (t.site_id = ? ");
        if (!exclusiveToSite) {
          sqlFilter.append("OR t.site_id IS NULL ");
        }
        sqlFilter.append(") ");
      } else {
	      if (exclusiveToSite) {
					sqlFilter.append(" AND  t.site_id IS NULL ");
        }
      }
    }
    if (enteredDateStart != null) {
      sqlFilter.append(" AND  t.entered >= ? ");
    }
    if (enteredDateEnd != null) {
      sqlFilter.append(" AND  t.entered <= ? ");
    }
    //Sync API
    if (syncType == Constants.SYNC_INSERTS) {
      if (lastAnchor != null) {
        sqlFilter.append(" AND  t.entered >= ? ");
      }
      sqlFilter.append(" AND  t.entered < ? ");
    } else if (syncType == Constants.SYNC_UPDATES) {
      sqlFilter.append(" AND  t.modified >= ? ");
      sqlFilter.append(" AND  t.entered < ? ");
      sqlFilter.append(" AND  t.modified < ? ");
    } else if (syncType == Constants.SYNC_QUERY) {
      if (lastAnchor != null) {
        sqlFilter.append(" AND  t.entered >= ? ");
      }
      if (nextAnchor != null) {
        sqlFilter.append(" AND  t.entered < ? ");
      }
    } else {
      //No sync, but still need to factor in age
      if (minutesOlderThan > 0) {
        sqlFilter.append(" AND  t.entered <= ? ");
      }
    }
    if (searchText != null && !searchText.equals("")) {
      sqlFilter.append(
          " AND  (" + DatabaseUtils.toLowerCase(
          db, DatabaseUtils.convertToVarChar(db, "t.problem")) + " LIKE ? OR " +
          DatabaseUtils.toLowerCase(
          db, DatabaseUtils.convertToVarChar(db, "t." + DatabaseUtils.addQuotes(db, "comment"))) + " LIKE ? OR " +
          DatabaseUtils.toLowerCase(
          db, DatabaseUtils.convertToVarChar(db, "t.solution")) + " LIKE ?) ");
    }
    if (hasEstimatedResolutionDate) {
      sqlFilter.append(" AND  t.est_resolution_date IS NOT NULL ");
    }
    if (includeOnlyTrashed) {
      sqlFilter.append(" AND  t.trashed_date IS NOT NULL ");
    } else if (trashedDate != null) {
      sqlFilter.append(" AND  t.trashed_date = ? ");
    } else {
      sqlFilter.append(" AND  t.trashed_date IS NULL ");
    }
    if (userGroupId != -1) {
      sqlFilter.append(" AND  t.user_group_id = ? ");
    }
    if (inMyUserGroups != -1) {
      sqlFilter.append(" AND  t.user_group_id IN (SELECT group_id FROM user_group_map where user_id = ?) ");
    }
    if (defectId > -1) {
      sqlFilter.append(" AND  t.defect_id = ? ");
    }
    if (stateId > -1) {
      sqlFilter.append(" AND  t.state_id = ? ");
    }
  }


  /**
   *  Sets the parameters for the preparedStatement - these items must
   *  correspond with the createFilter statement
   *
   * @param  pst            Description of Parameter
   * @return                Description of the Returned Value
   * @throws  SQLException  Description of Exception
   * @since                 1.2
   */
  protected int prepareFilter(PreparedStatement pst) throws SQLException {
    int i = 0;
    if (enteredBy > -1) {
      pst.setInt(++i, enteredBy);
    }
    if (description != null) {
      pst.setString(++i, description.toLowerCase());
    }
    if (id > -1) {
      if (pagedListInfo == null || pagedListInfo.getMode() != PagedListInfo.DETAILS_VIEW) {
        pst.setInt(++i, id);
      }
    }
    if (orgId > -1) {
      pst.setInt(++i, orgId);
    }
    if (contactId > -1) {
      pst.setInt(++i, contactId);
    }
    if (serviceContractId > -1) {
      pst.setInt(++i, serviceContractId);
    }
    if (assetId > -1) {
      pst.setInt(++i, assetId);
    }
    if (department > 0) {
      pst.setInt(++i, department);
    }
    if (assignedTo > -1) {
      pst.setInt(++i, assignedTo);
    }
    if (excludeAssignedTo > -1) {
      pst.setInt(++i, excludeAssignedTo);
    }
    if (severity > 0) {
      pst.setInt(++i, severity);
    }
    if (priority > 0) {
      pst.setInt(++i, priority);
    }
    if (escalationLevel > 0) {
      pst.setInt(++i, escalationLevel);
    }
    if (productId > 0) {
      pst.setInt(++i, productId);
    }
    if (customerProductId > 0) {
      pst.setInt(++i, customerProductId);
    }
    if (projectId > 0) {
      pst.setInt(++i, projectId);
    }
    if (forProjectUser > -1) {
      pst.setInt(++i, forProjectUser);
    }
    if (catCode != -1) {
      pst.setInt(++i, catCode);
    }
    if (subCat1 != -1) {
      pst.setInt(++i, subCat1);
    }
    if (subCat2 != -1) {
      pst.setInt(++i, subCat2);
    }
    if (subCat3 != -1) {
      pst.setInt(++i, subCat3);
    }
    if ((!includeAllSites) || (orgId == -1 && contactId == -1 && forProjectUser == -1
         && id == -1 && serviceContractId == -1 && assetId == -1 && projectId == -1 && userGroupId == -1
         && inMyUserGroups == -1)) {
      if (siteId != -1) {
				pst.setInt(++i, siteId);
			}
    }
    if (enteredDateStart != null) {
      DatabaseUtils.setTimestamp(
          pst, ++i, new Timestamp(enteredDateStart.getTime()));
    }
    if (enteredDateEnd != null) {
      DatabaseUtils.setTimestamp(
          pst, ++i, new Timestamp(enteredDateEnd.getTime()));
    }
    //Sync API
    if (syncType == Constants.SYNC_INSERTS) {
      if (lastAnchor != null) {
        pst.setTimestamp(++i, lastAnchor);
      }
      pst.setTimestamp(++i, nextAnchor);
    } else if (syncType == Constants.SYNC_UPDATES) {
      pst.setTimestamp(++i, lastAnchor);
      pst.setTimestamp(++i, lastAnchor);
      pst.setTimestamp(++i, nextAnchor);
    } else if (syncType == Constants.SYNC_QUERY) {
      if (lastAnchor != null) {
        java.sql.Timestamp adjustedDate = lastAnchor;
        if (minutesOlderThan > 0) {
          Calendar now = Calendar.getInstance();
          now.setTimeInMillis(lastAnchor.getTime());
          now.add(Calendar.MINUTE, minutesOlderThan - (2 * minutesOlderThan));
          adjustedDate = new java.sql.Timestamp(now.getTimeInMillis());
        }
        pst.setTimestamp(++i, adjustedDate);
      }
      if (nextAnchor != null) {
        java.sql.Timestamp adjustedDate = nextAnchor;
        if (minutesOlderThan > 0) {
          Calendar now = Calendar.getInstance();
          now.setTimeInMillis(nextAnchor.getTime());
          now.add(Calendar.MINUTE, minutesOlderThan - (2 * minutesOlderThan));
          adjustedDate = new java.sql.Timestamp(now.getTimeInMillis());
        }
        pst.setTimestamp(++i, adjustedDate);
      }
    } else {
      //No sync, but still need to factor in age
      if (minutesOlderThan > 0) {
        Calendar now = Calendar.getInstance();
        now.add(Calendar.MINUTE, minutesOlderThan - (2 * minutesOlderThan));
        java.sql.Timestamp adjustedDate = new java.sql.Timestamp(
            now.getTimeInMillis());
        pst.setTimestamp(++i, adjustedDate);
      }
    }

    if (searchText != null && !searchText.equals("")) {
      pst.setString(++i, searchText.toLowerCase());
      pst.setString(++i, searchText.toLowerCase());
      pst.setString(++i, searchText.toLowerCase());
    }
    if (includeOnlyTrashed) {
      // do nothing
    } else if (trashedDate != null) {
      pst.setTimestamp(++i, trashedDate);
    } else {
      // do nothing
    }
    if (userGroupId != -1) {
      pst.setInt(++i, userGroupId);
    }
    if (inMyUserGroups != -1) {
      pst.setInt(++i, inMyUserGroups);
    }
    if (defectId > -1) {
      pst.setInt(++i, defectId);
    }
    if (stateId > -1) {
      pst.setInt(++i, stateId);
    }
    return i;
  }


  /**
   *  Description of the Method
   *
   * @param  db             Description of the Parameter
   * @param  moduleId       Description of the Parameter
   * @param  itemId         Description of the Parameter
   * @return                Description of the Return Value
   * @throws  SQLException  Description of the Exception
   */
  public static int retrieveRecordCount(Connection db, int moduleId, int itemId) throws SQLException {
    int count = 0;
    StringBuffer sql = new StringBuffer();
    sql.append(
        "SELECT COUNT(*) as itemcount " +
        "FROM ticket t " +
        "WHERE ticketid > 0 " +
        " AND  trashed_date IS NULL ");
    if (moduleId == Constants.ACCOUNTS) {
      sql.append(" AND  t.org_id = ?");
    }
    if (moduleId == Constants.SERVICE_CONTRACTS) {
      sql.append(" AND  t.link_contract_id = ?");
    }
    if (moduleId == Constants.ASSETS) {
      sql.append(" AND  t.link_asset_id = ?");
    }
    PreparedStatement pst = db.prepareStatement(sql.toString());
    if (moduleId == Constants.ACCOUNTS) {
      pst.setInt(1, itemId);
    }
    if (moduleId == Constants.SERVICE_CONTRACTS) {
      pst.setInt(1, itemId);
    }
    if (moduleId == Constants.ASSETS) {
      pst.setInt(1, itemId);
    }
    ResultSet rs = pst.executeQuery();
    if (rs.next()) {
      count = rs.getInt("itemcount");
    }
    rs.close();
    pst.close();
    return count;
  }


  /**
   *  Each ticket in a project has its own unique count
   *
   * @param  db             Description of the Parameter
   * @param  projectId      Description of the Parameter
   * @throws  SQLException  Description of the Exception
   */
  public static void insertProjectTicketCount(Connection db, int projectId) throws SQLException {
    // Every new project needs a project_ticket_count record
    PreparedStatement pst = db.prepareStatement(
        "INSERT INTO project_ticket_count " +
        "(project_id) VALUES " +
        "(?) ");
    pst.setInt(1, projectId);
    pst.execute();
    pst.close();
  }


  /**
   *  Creates a hashmap of the number of tickets based on the estimated
   *  resolution date
   *
   * @param  db             Description of the Parameter
   * @param  timeZone       Description of the Parameter
   * @return                Description of the Return Value
   * @throws  SQLException  Description of the Exception
   */
  public HashMap queryRecordCount(Connection db, TimeZone timeZone) throws SQLException {

    PreparedStatement pst = null;
    ResultSet rs = null;

    HashMap events = new HashMap();
    StringBuffer sqlSelect = new StringBuffer();
    StringBuffer sqlFilter = new StringBuffer();
    StringBuffer sqlTail = new StringBuffer();

    createFilter(sqlFilter, db);

    sqlSelect.append(
        "SELECT est_resolution_date, count(*) as nocols " +
        "FROM ticket t " +
        "WHERE ticketid > -1 ");

    sqlTail.append("GROUP BY est_resolution_date ");
    pst = db.prepareStatement(
        sqlSelect.toString() + sqlFilter.toString() + sqlTail.toString());
    prepareFilter(pst);
    rs = pst.executeQuery();
    while (rs.next()) {
      Timestamp estRes = rs.getTimestamp("est_resolution_date");
      String estResolutionDate = null;
      if (estRes != null) {
        estResolutionDate = DateUtils.getServerToUserDateString(
            timeZone, DateFormat.SHORT, estRes);
        int thisCount = rs.getInt("nocols");
        if (events.containsKey(estResolutionDate)) {
          int tmpCount = ((Integer) events.get(estResolutionDate)).intValue();
          thisCount += tmpCount;
        }
        events.put(estResolutionDate, new Integer(thisCount));
      }
    }
    rs.close();
    pst.close();
    return events;
  }


  /**
   *  Each ticket in a project has its own unique count
   *
   * @param  db             Description of the Parameter
   * @param  projectId      Description of the Parameter
   * @throws  SQLException  Description of the Exception
   */
  public static void deleteProjectTicketCount(Connection db, int projectId) throws SQLException {
    // Every new project needs a project_ticket_count record
    PreparedStatement pst = db.prepareStatement(
        "DELETE FROM project_ticket_count " +
        "WHERE project_id = ? ");
    pst.setInt(1, projectId);
    pst.execute();
    pst.close();
  }


  /**
   *  Description of the Method
   *
   * @param  db             Description of the Parameter
   * @param  toTrash        Description of the Parameter
   * @param  tmpUserId      Description of the Parameter
   * @return                Description of the Return Value
   * @throws  SQLException  Description of the Exception
   */
  public boolean updateStatus(Connection db, boolean toTrash, int tmpUserId) throws SQLException {
    Iterator itr = this.iterator();
    while (itr.hasNext()) {
      Ticket tmpTicket = (Ticket) itr.next();
      tmpTicket.updateStatus(db, toTrash, tmpUserId);
    }
    return true;
  }
  
  
  
  /**
   *  Description of the Method
   *
   * @param  db                Description of the Parameter
   * @exception  SQLException  Description of the Exception
   */
  public void select(Connection db) throws SQLException {
    buildList(db);
  }


@Override
public void setSyncType(String arg0) {
	// TODO Auto-generated method stub
	
}

}

