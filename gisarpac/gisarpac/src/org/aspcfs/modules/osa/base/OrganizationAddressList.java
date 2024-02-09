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
package org.aspcfs.modules.osa.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.aspcfs.modules.base.AddressList;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.utils.DatabaseUtils;

/**
 * Builds an address list for an organization using a custom query that extends
 * the fields and methods of a typical AddressList.
 *
 * @author mrajkowski
 * @version $Id: OrganizationAddressList.java,v 1.3 2002/09/11 19:22:26 chris
 *          Exp $
 * @created September 1, 2001
 */
public class OrganizationAddressList extends AddressList {
	
	private static final long serialVersionUID = 1L;

  private static Logger log = Logger.getLogger(org.aspcfs.modules.accounts.base.OrganizationAddressList.class);
  static {
    if (System.getProperty("DEBUG") != null) {
      log.setLevel(Level.DEBUG);
    }
  }

  public final static String tableName = "organization_address";
  public final static String uniqueField = "address_id";
  private java.sql.Timestamp lastAnchor = null;
  private java.sql.Timestamp nextAnchor = null;
  private int syncType = Constants.NO_SYNC;

  /**
   *  Constructor for the OrganizationAddressList object
   *
   * @since    1.1
   */
  public OrganizationAddressList() {
  }

  /**
   *  Constructor for the OrganizationAddressList object
   *
   * @param  request  Description of the Parameter
   */
  public OrganizationAddressList(HttpServletRequest request) {
    int i = 1;
    int primaryAddress = -1;
    if (request.getParameter("primaryAddress") != null) {
      primaryAddress = Integer.parseInt(
          (String) request.getParameter("primaryAddress"));
    }
    while (request.getParameter("address" + (i) + "type") != null) {
      OrganizationAddress thisAddress = new OrganizationAddress();
      thisAddress.buildRecord(request, i);
      if (primaryAddress == i) {
        thisAddress.setPrimaryAddress(true);
      }
      if (thisAddress.isValid()) {
        this.addElement(thisAddress);
      }
      i++;
    }
  }


  /**
   *  Gets the tableName attribute of the OrganizationAddressList object
   *
   * @return    The tableName value
   */
  public String getTableName() {
    return tableName;
  }


  /**
   *  Gets the uniqueField attribute of the OrganizationAddressList object
   *
   * @return    The uniqueField value
   */
  public String getUniqueField() {
    return uniqueField;
  }


  /**
   *  Gets the lastAnchor attribute of the OrganizationAddressList object
   *
   * @return    The lastAnchor value
   */
  public java.sql.Timestamp getLastAnchor() {
    return lastAnchor;
  }


  /**
   *  Gets the nextAnchor attribute of the OrganizationAddressList object
   *
   * @return    The nextAnchor value
   */
  public java.sql.Timestamp getNextAnchor() {
    return nextAnchor;
  }


  /**
   *  Gets the syncType attribute of the OrganizationAddressList object
   *
   * @return    The syncType value
   */
  public int getSyncType() {
    return syncType;
  }


  /**
   *  Sets the lastAnchor attribute of the OrganizationAddressList object
   *
   * @param  tmp  The new lastAnchor value
   */
  public void setLastAnchor(java.sql.Timestamp tmp) {
    this.lastAnchor = tmp;
  }


  /**
   *  Sets the nextAnchor attribute of the OrganizationAddressList object
   *
   * @param  tmp  The new nextAnchor value
   */
  public void setNextAnchor(java.sql.Timestamp tmp) {
    this.nextAnchor = tmp;
  }


  /**
   *  Sets the syncType attribute of the OrganizationAddressList object
   *
   * @param  tmp  The new syncType value
   */
  public void setSyncType(int tmp) {
    this.syncType = tmp;
  }


  /**
   *  Builds a list of addresses based on several parameters. The parameters are
   *  set after this object is constructed, then the buildList method is called
   *  to generate the list.
   *
   * @param  db             Description of Parameter
   * @throws  SQLException  Description of Exception
   * @since                 1.1
   */
  public void buildList(Connection db) throws SQLException {

    PreparedStatement pst = null;
    ResultSet rs = null;
    int items = -1;

    StringBuffer sqlSelect = new StringBuffer();
    StringBuffer sqlCount = new StringBuffer();
    StringBuffer sqlFilter = new StringBuffer();
    StringBuffer sqlOrder = new StringBuffer();

    //Need to build a base SQL statement for returning records
    sqlSelect.append(
        "SELECT " +
        "a.address_id, a.org_id, a.address_type, a.addrline1, a.addrline2, a.addrline3, " +
        "a.city, a.state, a.country, a.postalcode, a.entered, a.enteredby, a.modified, a.modifiedby, " +
        "a.primary_address, a.addrline4, a.county, a.latitude, a.longitude, " +
        "l.code, l.description, l.default_item, l." + DatabaseUtils.addQuotes(db, "level") + ", l.enabled " +
        "FROM organization_address a, lookup_orgaddress_types l " +
        "WHERE a.address_type = l.code ");
    //Need to build a base SQL statement for counting records
    sqlCount.append(
        "SELECT COUNT(*) AS recordcount " +
        "FROM organization_address a, lookup_orgaddress_types l " +
        "WHERE a.address_type = l.code ");

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
            " AND  " + DatabaseUtils.toLowerCase(db) + "(city) < ? ");
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
      if (pagedListInfo.getColumnToSortBy() != null && !pagedListInfo.getColumnToSortBy().equals(
          "")) {
        sqlOrder.append(
            "ORDER BY " + pagedListInfo.getColumnToSortBy() + ", city ");
        if (pagedListInfo.getSortOrder() != null && !pagedListInfo.getSortOrder().equals(
            "")) {
          sqlOrder.append(pagedListInfo.getSortOrder() + " ");
        }
      } else {
        sqlOrder.append("ORDER BY city ");
      }

      //Determine items per page
      if (pagedListInfo.getItemsPerPage() > 0) {
        sqlOrder.append("LIMIT " + pagedListInfo.getItemsPerPage() + " ");
      }

      sqlOrder.append("OFFSET " + pagedListInfo.getCurrentOffset() + " ");
    }

    pst = db.prepareStatement(
        sqlSelect.toString() + sqlFilter.toString() + sqlOrder.toString());
    items = prepareFilter(pst);
    rs = DatabaseUtils.executeQuery(db, pst, log);
    while (rs.next()) {
      OrganizationAddress thisAddress = new OrganizationAddress(rs);
      this.addElement(thisAddress);
    }
    rs.close();
    pst.close();
  }
  
  
  
  
  public int getIdfromaddress(Connection db,String idirizzo,String citta,String prov,int orgid) throws SQLException{
	  int id=-1;
	  
	String sql= "select address_id from organization_address where addrline1= ? and city = ? and state = ? ";
	
	if(orgid!=-1){
	sql=sql+" AND  org_id=? ";
	}
	
	PreparedStatement pst=db.prepareStatement(sql);
	pst.setString(1, idirizzo);
	pst.setString(2, citta);
	pst.setString(3, prov);
	
	if(orgid!=-1)
	pst.setInt(4, orgid);
	ResultSet rs= pst.executeQuery();
	if(rs.next())
		id=rs.getInt("address_id");
	
	  
	  
	  
	  return id;
	  
	  
	  
	  
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
}

