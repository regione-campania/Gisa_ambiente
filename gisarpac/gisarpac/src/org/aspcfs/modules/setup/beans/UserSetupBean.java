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
package org.aspcfs.modules.setup.beans;

import com.darkhorseventures.framework.beans.GenericBean;

/**
 * Bean to encapsulate the Configure User HTML form
 *
 * @author mrajkowski
 * @version $Id: UserSetupBean.java 24313 2007-12-09 12:42:47Z srinivasar@cybage.com $
 * @created August 26, 2003
 */
public class UserSetupBean extends GenericBean {

  private int configured = -1;
  private String nameFirst = null;
  private String nameLast = null;
  private String company = null;
  private String email = null;
  private String username = null;
  private String password1 = null;
  private String password2 = null;


  /**
   * Sets the configured attribute of the UserSetupBean object
   *
   * @param tmp The new configured value
   */
  public void setConfigured(int tmp) {
    this.configured = tmp;
  }


  /**
   * Sets the configured attribute of the UserSetupBean object
   *
   * @param tmp The new configured value
   */
  public void setConfigured(String tmp) {
    this.configured = Integer.parseInt(tmp);
  }


  /**
   * Sets the nameFirst attribute of the UserSetupBean object
   *
   * @param tmp The new nameFirst value
   */
  public void setNameFirst(String tmp) {
    this.nameFirst = tmp;
  }


  /**
   * Sets the nameLast attribute of the UserSetupBean object
   *
   * @param tmp The new nameLast value
   */
  public void setNameLast(String tmp) {
    this.nameLast = tmp;
  }


  /**
   * Sets the company attribute of the UserSetupBean object
   *
   * @param tmp The new company value
   */
  public void setCompany(String tmp) {
    this.company = tmp;
  }


  /**
   * Sets the email attribute of the UserSetupBean object
   *
   * @param tmp The new email value
   */
  public void setEmail(String tmp) {
    this.email = tmp;
  }


  /**
   * Sets the username attribute of the UserSetupBean object
   *
   * @param tmp The new username value
   */
  public void setUsername(String tmp) {
    this.username = tmp;
  }


  /**
   * Sets the password1 attribute of the UserSetupBean object
   *
   * @param tmp The new password1 value
   */
  public void setPassword1(String tmp) {
    this.password1 = tmp;
  }


  /**
   * Sets the password2 attribute of the UserSetupBean object
   *
   * @param tmp The new password2 value
   */
  public void setPassword2(String tmp) {
    this.password2 = tmp;
  }


  /**
   * Gets the configured attribute of the UserSetupBean object
   *
   * @return The configured value
   */
  public int getConfigured() {
    return configured;
  }


  /**
   * Gets the nameFirst attribute of the UserSetupBean object
   *
   * @return The nameFirst value
   */
  public String getNameFirst() {
    return nameFirst;
  }


  /**
   * Gets the nameLast attribute of the UserSetupBean object
   *
   * @return The nameLast value
   */
  public String getNameLast() {
    return nameLast;
  }


  /**
   * Gets the company attribute of the UserSetupBean object
   *
   * @return The company value
   */
  public String getCompany() {
    return company;
  }


  /**
   * Gets the email attribute of the UserSetupBean object
   *
   * @return The email value
   */
  public String getEmail() {
    return email;
  }


  /**
   * Gets the username attribute of the UserSetupBean object
   *
   * @return The username value
   */
  public String getUsername() {
    return username;
  }


  /**
   * Gets the password1 attribute of the UserSetupBean object
   *
   * @return The password1 value
   */
  public String getPassword1() {
    return password1;
  }


  /**
   * Gets the password2 attribute of the UserSetupBean object
   *
   * @return The password2 value
   */
  public String getPassword2() {
    return password2;
  }

}

