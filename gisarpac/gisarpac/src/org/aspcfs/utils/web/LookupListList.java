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
package org.aspcfs.utils.web;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;

import org.aspcfs.controller.SystemStatus;
import org.aspcfs.utils.DatabaseUtils;

/**
 * LookupListList is a list of lookuplists for a particular module.
 *
 * @author Mathur
 * @version $Id: LookupListList.java,v 1.2 2003/01/10 16:17:48 mrajkowski Exp
 *          $
 * @created December 18, 2002
 */
public class LookupListList extends HtmlSelect {
  protected int moduleId = -1;
  protected int userId;


  /**
   * Constructor for the LookupListList object
   */
  public LookupListList() {
  }


  /**
   * Constructor for the LookupListList object
   *
   * @param db       Description of the Parameter
   * @param moduleId Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public LookupListList(SystemStatus thisSystem, Connection db, int moduleId) throws SQLException {
    this.moduleId = moduleId;
    buildList(thisSystem, db);
  }


  /**
   * Sets the moduleId attribute of the LookupListList object
   *
   * @param moduleId The new moduleId value
   */
  public void setModuleId(int moduleId) {
    this.moduleId = moduleId;
  }


  /**
   * Sets the userId attribute of the LookupListList object
   *
   * @param userId The new userId value
   */
  public void setUserId(int userId) {
    this.userId = userId;
  }


  /**
   * Gets the userId attribute of the LookupListList object
   *
   * @return The userId value
   */
  public int getUserId() {
    return userId;
  }


  /**
   * Gets the moduleId attribute of the LookupListList object
   *
   * @return The moduleId value
   */
  public int getModuleId() {
    return moduleId;
  }


  /**
   * Builds a list of lookuplistElements for a module.
   *
   * @param db Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void buildList(SystemStatus thisSystem, Connection db) throws SQLException {
    PreparedStatement pst = null;
    ResultSet rs = null;
    pst = db.prepareStatement(
        "SELECT * " +
        "FROM lookup_lists_lookup " +
        "WHERE module_id = ? " +
        "ORDER BY " + DatabaseUtils.addQuotes(db, "level") + " ");
    pst.setInt(1, moduleId);
    rs = pst.executeQuery();
    while (rs.next()) {
      LookupListElement thisElement = new LookupListElement(rs);
      this.add(thisElement);
    }
    rs.close();
    pst.close();
    Iterator i = this.iterator();
    while (i.hasNext()) {
      LookupListElement thisLookup = (LookupListElement) i.next();
      thisLookup.buildLookupList(thisSystem, db, userId);
    }
  }


  /**
   * Removes a specific LookupListElement item from the list
   *
   * @param categoryId Description of the Parameter
   * @param lookupId   Description of the Parameter
   */
  public void removeList(int categoryId, int lookupId) {
    Iterator i = this.iterator();
    while (i.hasNext()) {
      LookupListElement thisLookup = (LookupListElement) i.next();
      if (thisLookup.getCategoryId() == categoryId && thisLookup.getLookupId() == lookupId) {
        this.remove(thisLookup);
        break;
      }
    }
  }
}

