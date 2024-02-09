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
package org.aspcfs.modules.vigilanza.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.darkhorseventures.framework.beans.GenericBean;

/**
 * Represents a Contact
 *
 * @author mrajkowski
 * @version $Id: Contact.java,v 1.106.4.3.2.3 2005/01/10 17:58:55 kbhoopal
 *          Exp $
 * @created August 29, 2001
 */
public class Motivazioni extends GenericBean {
  
  private int idMotivazione = -1;
  private String categoria = "";
  private String motivazione = "";
 
  
  /**
   * Gets the postalcode attribute of the Contact object
   *
   * @return The postalcode value
   */
  public int getIdMotivazione() {
    return idMotivazione;
  }


  /**
   * Sets the postalcode attribute of the Contact object
   *
   * @param tmp The new postalcode value
   */
  public void setPostalcode(int tmp) {
    this.idMotivazione = tmp;
  }

  
  public String getCategoria() {
	    return categoria;
	  }


	  /**
	   * Sets the postalcode attribute of the Contact object
	   *
	   * @param tmp The new postalcode value
	   */
 public void setCategoria(String tmp) {
	    this.categoria = tmp;
	  }
 
 public String getMotivazione() {
	    return motivazione;
	  }


	  /**
	   * Sets the postalcode attribute of the Contact object
	   *
	   * @param tmp The new postalcode value
	   */
public void setMotivazione(String tmp) {
	    this.motivazione = tmp;
	  }



  /**
   * Constructor for the Contact object
   *
   * @since 1.1
   */
  public Motivazioni() {
  }


  /**
   * Constructor for the Contact object
   *
   * @param rs Description of Parameter
   * @throws SQLException Description of the Exception
   * @since 1.1
   */
  public Motivazioni(ResultSet rs) throws SQLException {
    buildRecord(rs);
  }
   


  /**
   * Constructor for the Employee object, populates all attributes by
   * performing a SQL query based on the employeeId parameter
   *
   * @param db        Description of Parameter
   * @param contactId Description of Parameter
   * @throws SQLException Description of the Exception
   * @since 1.1
   */
  public Motivazioni(Connection db, String IdMotivazioni) throws SQLException {
    queryRecord(db);
  }


  /**
   * Constructor for the Contact object
   *
   * @param db        Description of the Parameter
   * @param contactId Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public Motivazioni(Connection db, int IdMotivazioni) throws SQLException {
    queryRecord(db);
  }

  public void queryRecord(Connection db) throws SQLException {

    StringBuffer sql = new StringBuffer();
    //NOTE: Update the UserList query if any changes are made to the contact query
    sql.append(
        "SELECT c.*" +
            "FROM motivazioni c " );
            
    PreparedStatement pst = db.prepareStatement(sql.toString());
    ResultSet rs = pst.executeQuery();
    if (rs.next()) {
      buildRecord(rs);
    }
    rs.close();
    pst.close();
    
  }

  protected void buildRecord(ResultSet rs) throws SQLException {
	    
	    idMotivazione = rs.getInt("id_motivazione");
	    categoria = rs.getString("categoria");
	    motivazione = rs.getString("motivazione");
	   
	  }


  }


  
