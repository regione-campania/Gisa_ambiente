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
package org.aspcfs.modules.accounts.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.aspcfs.modules.base.EmailAddress;
import org.aspcfs.utils.DatabaseUtils;

import com.darkhorseventures.framework.actions.ActionContext;

/**
 * Description of the Class
 *
 * @author Mathur
 * @version $Id: OrganizationEmailAddress.java 12404 2005-08-05 17:37:07Z mrajkowski $
 * @created January 13, 2003
 */
public class OrganizationEmailAddress extends EmailAddress {

  /**
   * Constructor for the OrganizationEmailAddress object
   */
  public OrganizationEmailAddress() {
    isContact = false;
  }


  /**
   * Constructor for the OrganizationEmailAddress object
   *
   * @param rs Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public OrganizationEmailAddress(ResultSet rs) throws SQLException {
    isContact = false;
    buildRecord(rs);
  }


  /**
   * Constructor for the OrganizationEmailAddress object
   *
   * @param db             Description of the Parameter
   * @param emailAddressId Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public OrganizationEmailAddress(Connection db, int emailAddressId) throws SQLException {
    queryRecord(db, emailAddressId);
  }


  /**
   * Constructor for the OrganizationEmailAddress object
   *
   * @param db             Description of the Parameter
   * @param emailAddressId Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public OrganizationEmailAddress(Connection db, String emailAddressId) throws SQLException {
    queryRecord(db, Integer.parseInt(emailAddressId));
  }


  /**
   * Description of the Method
   *
   * @param db             Description of the Parameter
   * @param emailAddressId Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void queryRecord(Connection db, int emailAddressId) throws SQLException {
    isContact = false;
    if (emailAddressId <= 0) {
      throw new SQLException("Valid Email Address ID specified.");
    }

    Statement st = null;
    ResultSet rs = null;
    StringBuffer sql = new StringBuffer();
    sql.append(
        "SELECT * " +
        "FROM organization_emailaddress c, lookup_orgemail_types l " +
        "WHERE c.emailaddress_type = l.code " +
        " AND  emailaddress_id = " + emailAddressId + " ");
    st = db.createStatement();
    rs = st.executeQuery(sql.toString());
    if (rs.next()) {
      buildRecord(rs);
    }
    rs.close();
    st.close();
    if (this.getId() == -1) {
      throw new SQLException("Email record not found.");
    }
  }


  /**
   * Determines what to do if this record is marked for INSERT, UPDATE, or
   * DELETE
   *
   * @param db         Description of Parameter
   * @param orgId      Description of Parameter
   * @param enteredBy  Description of Parameter
   * @param modifiedBy Description of Parameter
   * @throws SQLException Description of Exception
   */
  public void process(Connection db, int orgId, int enteredBy, int modifiedBy,ActionContext context) throws SQLException {
    if (this.getEnabled() == true) {
      if (this.getId() == -1) {
        this.setOrgId(orgId);
        this.setEnteredBy(enteredBy);
        this.setModifiedBy(modifiedBy);
        this.insert(db,context);
      } else {
        this.setModifiedBy(modifiedBy);
        this.update(db, modifiedBy);
      }
    } else {
      this.delete(db);
    }
  }


  /**
   * Description of the Method
   *
   * @param db Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void insert(Connection db,ActionContext context ) throws SQLException {
    insert(db, this.getOrgId(), this.getEnteredBy(),context);
  }


  /**
   * Description of the Method
   *
   * @param db        Description of the Parameter
   * @param orgId     Description of the Parameter
   * @param enteredBy Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void insert(Connection db, int orgId, int enteredBy,ActionContext context) throws SQLException {
    StringBuffer sql = new StringBuffer();
//    int id = DatabaseUtils.getNextSeq(db, "organization__emailaddress__seq");
    
    int id = DatabaseUtils.getNextSeq(db, context,"organization_emailaddress","emailaddress_id");
    sql.append(
        "INSERT INTO organization_emailaddress " +
        "(org_id, emailaddress_type, email, primary_email, ");
    if (id > -1) {
      sql.append("emailaddress_id, ");
    }
    if (this.getEntered() != null) {
      sql.append("entered, ");
    }
    if (this.getModified() != null) {
      sql.append("modified, ");
    }
    sql.append("enteredBy, modifiedBy ) ");
    sql.append("VALUES (?, ?, ?, ?, ");
    if (id > -1) {
      sql.append("?,");
    }
    if (this.getEntered() != null) {
      sql.append("?, ");
    }
    if (this.getModified() != null) {
      sql.append("?, ");
    }
    sql.append("?, ?) ");
    int i = 0;
    PreparedStatement pst = db.prepareStatement(sql.toString());
    if (orgId > -1) {
      pst.setInt(++i, this.getOrgId());
    } else {
      pst.setNull(++i, java.sql.Types.INTEGER);
    }
    if (this.getType() > -1) {
      pst.setInt(++i, this.getType());
    } else {
      pst.setNull(++i, java.sql.Types.INTEGER);
    }
    pst.setString(++i, this.getEmail());
    pst.setBoolean(++i, this.getPrimaryEmail());
    if (id > -1) {
      pst.setInt(++i, id);
    }
    if (this.getEntered() != null) {
      pst.setTimestamp(++i, this.getEntered());
    }
    if (this.getModified() != null) {
      pst.setTimestamp(++i, this.getModified());
    }
    pst.setInt(++i, this.getEnteredBy());
    pst.setInt(++i, this.getModifiedBy());
    pst.execute();
    pst.close();

  }
  /**
   * Description of the Method
   *
   * @param db         Description of Parameter
   * @param modifiedBy Description of Parameter
   * @throws SQLException Description of Exception
   */
  public void update(Connection db, int modifiedBy) throws SQLException {
    PreparedStatement pst = db.prepareStatement(
        "UPDATE organization_emailaddress " +
        "SET emailaddress_type = ?, email = ?, primary_email = ?, modifiedby = ?, " +
        "modified = CURRENT_TIMESTAMP " +
        "WHERE emailaddress_id = ? ");
    int i = 0;
    if (this.getType() > -1) {
      pst.setInt(++i, this.getType());
    } else {
      pst.setNull(++i, java.sql.Types.INTEGER);
    }
    pst.setString(++i, this.getEmail());
    pst.setBoolean(++i, this.getPrimaryEmail());
    pst.setInt(++i, modifiedBy);
    pst.setInt(++i, this.getId());
    pst.execute();
    pst.close();
  }


  /**
   * Description of the Method
   *
   * @param db Description of Parameter
   * @throws SQLException Description of Exception
   */
  public void delete(Connection db) throws SQLException {
    PreparedStatement pst = db.prepareStatement(
        "DELETE FROM organization_emailaddress " +
        "WHERE emailaddress_id = ? ");
    int i = 0;
    pst.setInt(++i, this.getId());
    pst.execute();
    pst.close();
  }

}

