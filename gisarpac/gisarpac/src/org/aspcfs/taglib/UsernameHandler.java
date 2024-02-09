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
package org.aspcfs.taglib;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Hashtable;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;
import javax.servlet.jsp.tagext.TryCatchFinally;

import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.contacts.base.Contact;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.GestoreConnessioni;
import org.aspcfs.utils.StringUtils;

import com.darkhorseventures.database.ConnectionElement;

/**
 * This Class evaluates a User ID and returns a Contact record from application
 * scope.
 *
 * @author matt rajkowski
 * @version $Id: UsernameHandler.java,v 1.3 2002/12/23 16:12:28 mrajkowski Exp
 *          $
 * @created December 14, 2001
 */
public class UsernameHandler extends TagSupport implements TryCatchFinally {

  private int userId = -1;
  private boolean lastFirst = false;
  private boolean firstInitialLast = false;
  private String defaultText = null;
  private boolean forJS = false;

  public void doCatch(Throwable throwable) throws Throwable {
    // Required but not needed
  }

  public void doFinally() {
    // Reset each property or else the value gets reused
    userId = -1;
    lastFirst = false;
    firstInitialLast = false;
    defaultText = null;
    forJS = false;
  }


  /**
   * Sets the Id attribute of the UsernameHandler object
   *
   * @param tmp The new Id value
   */
  public void setId(String tmp) {
    this.userId = Integer.parseInt(tmp);
  }


  /**
   * Sets the id attribute of the UsernameHandler object
   *
   * @param tmp The new id value
   */
  public void setId(int tmp) {
    this.userId = tmp;
  }


  /**
   * Sets the lastFirst attribute of the UsernameHandler object
   *
   * @param tmp The new lastFirst value
   */
  public void setLastFirst(String tmp) {
    this.lastFirst = "true".equals(tmp);
  }


  /**
   * Sets the firstInitialLast attribute of the UsernameHandler object
   *
   * @param firstInitialLast The new firstInitialLast value
   */
  public void setFirstInitialLast(boolean firstInitialLast) {
    this.firstInitialLast = firstInitialLast;
  }


  /**
   * Sets the firstInitialLast attribute of the UsernameHandler object
   *
   * @param tmp The new firstInitialLast value
   */
  public void setFirstInitialLast(String tmp) {
    this.firstInitialLast = "true".equals(tmp);
  }


  /**
   * Sets the default attribute of the UsernameHandler object
   *
   * @param tmp The new default value
   */
  public void setDefault(String tmp) {
    this.defaultText = tmp;
  }


  /**
   * Sets the forJS attribute of the UsernameHandler object
   *
   * @param tmp The new forJS value
   */
  public void setForJS(boolean tmp) {
    this.forJS = tmp;
  }


  /**
   * Sets the forJS attribute of the UsernameHandler object
   *
   * @param tmp The new forJS value
   */
  public void setForJS(String tmp) {
    this.forJS = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   * Prints the user's name from the user cache, if not found displays the
   * default text value.
   *
   * @return Description of the Returned Value
   * @throws JspException Description of Exception
   */
  public int doStartTag() throws JspException {
    try {
      ConnectionElement ce = (ConnectionElement) pageContext.getSession().getAttribute(
          "ConnectionElement");
      if (ce == null) {
        System.out.println("UsernameHandler-> ConnectionElement is null");
      }
      SystemStatus systemStatus = (SystemStatus) ((Hashtable) pageContext.getServletContext().getAttribute(
          "SystemStatus")).get(ce.getUrl());
      if (systemStatus == null) {
        System.out.println("UsernameHandler-> SystemStatus is null");
      } else {
        User thisUser = systemStatus.getUser(userId);
        if (thisUser != null) {
          Contact thisContact = thisUser.getContact();
          if (thisContact != null) {
            if (lastFirst) {
              if (forJS) {
                this.pageContext.getOut().write(
                    StringUtils.jsStringEscape(
                        thisContact.getNameLastFirst() + (!thisUser.getEnabled() ? " *" : "")));
              } else {
                this.pageContext.getOut().write(
                    StringUtils.toHtml(
                        thisContact.getNameLastFirst() + (!thisUser.getEnabled() ? " *" : "")));
              }
            } else if (firstInitialLast) {
              if (forJS) {
                this.pageContext.getOut().write(
                    StringUtils.jsStringEscape(
                        thisContact.getNameLastFirst() + (!thisUser.getEnabled() ? " *" : "")));
              } else {
                this.pageContext.getOut().write(
                    StringUtils.toHtml(
                        thisContact.getNameFirstInitialLast() + (!thisUser.getEnabled() ? " *" : "")));
              }
            } else {
              if (forJS) {
                this.pageContext.getOut().write(
                    StringUtils.jsStringEscape(
                        thisContact.getNameLastFirst() + (!thisUser.getEnabled() ? " *" : "")));
              } else {
                this.pageContext.getOut().write(
                    StringUtils.toHtml(
                        thisContact.getNameFirstLast() + (!thisUser.getEnabled() ? " *" : "")));
              }
            }
          }
        } else {
        	Connection db = GestoreConnessioni.getConnection();
        	try
        	{
        		 thisUser = new User(db,userId);
        		Contact thisContact = thisUser.getContact();
        		if (thisContact != null) {
                    if (lastFirst) {
                      if (forJS) {
                        this.pageContext.getOut().write(
                            StringUtils.jsStringEscape(
                                thisContact.getNameLastFirst() + (!thisUser.getEnabled() ? " *" : "")));
                      } else {
                        this.pageContext.getOut().write(
                            StringUtils.toHtml(
                                thisContact.getNameLastFirst() + (!thisUser.getEnabled() ? " *" : "")));
                      }
                    } else if (firstInitialLast) {
                      if (forJS) {
                        this.pageContext.getOut().write(
                            StringUtils.jsStringEscape(
                                thisContact.getNameLastFirst() + (!thisUser.getEnabled() ? " *" : "")));
                      } else {
                        this.pageContext.getOut().write(
                            StringUtils.toHtml(
                                thisContact.getNameFirstInitialLast() + (!thisUser.getEnabled() ? " *" : "")));
                      }
                    } else {
                      if (forJS) {
                        this.pageContext.getOut().write(
                            StringUtils.jsStringEscape(
                                thisContact.getNameLastFirst() + (!thisUser.getEnabled() ? " *" : "")));
                      } else {
                        this.pageContext.getOut().write(
                            StringUtils.toHtml(
                                thisContact.getNameFirstLast() + (!thisUser.getEnabled() ? " *" : "")));
                      }
                    }
                  }
        		else
        		{
        			 //NOTE: the default text will already be in the output format
        	          this.pageContext.getOut().write(
        	              StringUtils.toHtml(systemStatus.getLabel(defaultText)));
        		}
        		
        	}
        	catch(SQLException e)
        	
        	{
        		
        	}finally
        	{
        		GestoreConnessioni.freeConnection(db);
        	}
         
        }
      }
    } catch (Exception e) {
      e.printStackTrace(System.out);
    }
    return SKIP_BODY;
  }


  /**
   * Description of the Method
   *
   * @return Description of the Return Value
   */
  public int doEndTag() {
    return EVAL_PAGE;
  }

}

