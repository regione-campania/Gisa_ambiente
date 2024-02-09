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
package org.aspcfs.modules.admin.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.aspcfs.modules.communications.base.Message;
import org.aspcfs.modules.contacts.base.Contact;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.web.LookupElement;

import com.darkhorseventures.framework.actions.ActionContext;

/**
 * Represents Access Type for a component
 *
 * @author Mathur
 * @version $id:exp$
 * @created June 25, 2003
 */
public class AccessType extends LookupElement {
  //link module ids (format is mmddyyhhmm: if month is single digit do not add 0 in front)
  public final static int GENERAL_CONTACTS = 626030330;
  public final static int ACCOUNT_CONTACTS = 626030331;
  public final static int ALLEVAMENTI_CONTACTS = 626030338;
  public final static int EMPLOYEES = 626030332;
  public final static int COMMUNICATION_MESSAGES = 707031028;
  public final static int OPPORTUNITIES = 804051057;
  public static int REQUESTOR= 626030336;
  public static int ALLEVAMENTI= 626030337;
  public static int STABILIMENTI= 626030338;
  public static int ABUSIVISMI= 626030339;
  public static int SOA= 626030341;
  public static int TRASPORTOANIMALI = 626030340;

  //sharing types
  public final static int PERSONAL = 626030333;
  public final static int PUBLIC = 626030334;
  public final static int CONTROLLED_HIERARCHY = 626030335;

  int linkModuleId = -1;
  int ruleId = -1;
  int code = -1;


  /**
   * Constructor for the AccessType object
   */
  public AccessType() {
  }


  /**
   * Constructor for the AccessType object
   *
   * @param db   Description of the Parameter
   * @param code Description of the Parameter
   * @throws java.sql.SQLException Description of the Exception
   */
  public AccessType(Connection db, int code) throws java.sql.SQLException {
    if (System.getProperty("DEBUG") != null) {
      System.out.println(
          "AccessType-> Retrieving ID: " + code + " from lookup_access_types ");
    }
    this.setCode(code);
    PreparedStatement pst = db.prepareStatement(
        "SELECT code, link_module_id, description, default_item, " + DatabaseUtils.addQuotes(db, "level") + ", enabled, rule_id " +
        "FROM lookup_access_types " +
        "WHERE code = ? ");
    pst.setInt(1, code);
    ResultSet rs = pst.executeQuery();
    if (rs.next()) {
      build(rs);
    }
    rs.close();
    pst.close();
    if (code < 0) {
      throw new java.sql.SQLException("ID not found");
    }
  }


  /**
   * Constructor for the AccessType object
   *
   * @param rs Description of the Parameter
   * @throws java.sql.SQLException Description of the Exception
   */
  public AccessType(ResultSet rs) throws java.sql.SQLException {
    build(rs);
  }


  /**
   * Sets the ruleId attribute of the AccessType object
   *
   * @param ruleId The new ruleId value
   */
  public void setRuleId(int ruleId) {
    this.ruleId = ruleId;
  }


  /**
   * Sets the linkModuleId attribute of the AccessType object
   *
   * @param linkModuleId The new linkModuleId value
   */
  public void setLinkModuleId(int linkModuleId) {
    this.linkModuleId = linkModuleId;
  }


  /**
   * Gets the ruleId attribute of the AccessType object
   *
   * @return The ruleId value
   */
  public int getRuleId() {
    return ruleId;
  }


  /**
   * Gets the linkModuleId attribute of the AccessType object
   *
   * @return The linkModuleId value
   */
  public int getLinkModuleId() {
    return linkModuleId;
  }


  /**
   * Returns the linkModuleId given  a instance of an object
   *
   * @param obj Description of the Parameter
   * @return The linkModuleId value
   */
  public static int getLinkModuleId(Object obj) {
    if (obj instanceof Contact) {
      Contact thisContact = (Contact) obj;
      if (thisContact.getOrgId() > 0) {
        return ACCOUNT_CONTACTS;
      } else {
        return GENERAL_CONTACTS;
      }
    } else if (obj instanceof Message) {
      return COMMUNICATION_MESSAGES;
    }
    return -1;
  }


  /**
   *  Gets the code attribute of the AccessType object
   *
   * @return    The code value
   */
  public int getCode() {
    return code;
  }


  /**
   *  Sets the code attribute of the AccessType object
   *
   * @param  tmp  The new code value
   */
  public void setCode(int tmp) {
    this.code = tmp;
  }


  /**
   *  Sets the code attribute of the AccessType object
   *
   * @param  tmp  The new code value
   */
  public void setCode(String tmp) {
    this.code = Integer.parseInt(tmp);
  }


  /**
   * Build the Access Type record
   *
   * @param rs Description of the Parameter
   * @throws java.sql.SQLException Description of the Exception
   */
  public void build(ResultSet rs) throws java.sql.SQLException {
    this.code = rs.getInt("code");
    linkModuleId = rs.getInt("link_module_id");
    description = rs.getString("description");
    defaultItem = rs.getBoolean("default_item");
    level = rs.getInt("level");
    enabled = rs.getBoolean("enabled");
    if (!(this.getEnabled())) {
      description += " (X)";
    }
    ruleId = rs.getInt("rule_id");
  }

  public boolean insert(Connection db,ActionContext context) throws SQLException {
    int id = DatabaseUtils.getNextSeq(db, context , "lookup_access_types","code");

    int i = 0;
    PreparedStatement pst = db.prepareStatement(
        "INSERT INTO lookup_access_types " +
        "(" + (id > -1 ? "code, " : "") + "link_module_id, description, default_item, " + DatabaseUtils.addQuotes(db, "level") + ", enabled, rule_id) " +
        "VALUES (" + (id > -1 ? "?, " : "") + "?, ?, ?, ?, ?, ?) "
    );
    if (id > -1) {
      pst.setInt(++i, id);
    }
    pst.setInt(++i, linkModuleId);
    pst.setString(++i, this.getDescription());
    pst.setBoolean(++i, defaultItem);
    pst.setInt(++i, level);
    pst.setBoolean(++i, enabled);
    pst.setInt(++i, ruleId);
    pst.execute();
    pst.close();
    return true;
  }
}


