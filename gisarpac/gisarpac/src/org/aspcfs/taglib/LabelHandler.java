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

import java.util.HashMap;
import java.util.Hashtable;
import java.util.StringTokenizer;

import javax.servlet.jsp.tagext.TagSupport;
import javax.servlet.jsp.tagext.TryCatchFinally;

import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.controller.SystemStatus;
import org.aspcfs.utils.StringUtils;
import org.aspcfs.utils.Template;

import com.darkhorseventures.database.ConnectionElement;

/**
 * This Class evaluates whether a SystemStatus preference exists for the
 * supplied label.
 *
 * @author Matt Rajkowski
 * @version $Id: LabelHandler.java,v 1.3.180.2 2004/08/30 14:13:43 mrajkowski
 *          Exp $
 * @created February 25, 2002
 */
public class LabelHandler extends TagSupport implements TryCatchFinally {
  private String labelName = null;
  private HashMap params = null;
  private boolean mainMenuItem = false;
  private boolean subMenuItem = false;

  public void doCatch(Throwable throwable) throws Throwable {
    // Required but not needed
  }

  public void doFinally() {
    // Reset each property or else the value gets reused
    labelName = null;
    params = null;
    mainMenuItem = false;
    subMenuItem = false;
  }

  /**
   * Sets the Name attribute of the LabelHandler object
   *
   * @param tmp The new Name value
   * @since 1.1
   */
  public final void setName(String tmp) {
    labelName = tmp;
  }

  public final void setMainMenuItem(boolean tmp) {
    mainMenuItem = tmp;
  }

  public final void setSubMenuItem(boolean tmp) {
    subMenuItem = tmp;
  }


  /**
   * Sets the param attribute of the LabelHandler object
   *
   * @param tmp The new params value
   */
  public void setParam(String tmp) {
    params = new HashMap();
    StringTokenizer tokens = new StringTokenizer(tmp, "|");
    while (tokens.hasMoreTokens()) {
      String pair = tokens.nextToken();
      String param = pair.substring(0, pair.indexOf("="));
      String value = pair.substring(pair.indexOf("=") + 1);
      params.put("${" + param + "}", value);
    }
  }


  /**
   * Checks to see if the SystemStatus has a preference set for this label. If
   * so, the found label will be used, otherwise the body tag will be used.
   *
   * @return Description of the Returned Value
   * @since 1.1
   */
  public final int doStartTag() {
    String newLabel = null;

    // Use the system status if available
    ConnectionElement ce = (ConnectionElement) pageContext.getSession().getAttribute(
        "ConnectionElement");
    if (ce == null) {
      ApplicationPrefs prefs = (ApplicationPrefs) pageContext.getServletContext().getAttribute(
          "applicationPrefs");
      if (prefs != null) {
        newLabel = prefs.getLabel(labelName, prefs.get("SYSTEM.LANGUAGE"));
      }
    } else {
      SystemStatus systemStatus = (SystemStatus) ((Hashtable) pageContext.getServletContext().getAttribute(
          "SystemStatus")).get(ce.getUrl());
    
      // Look up the label key in system status to get the value
      if (systemStatus != null) {
        if (mainMenuItem) {
          newLabel = systemStatus.getMenuProperty(labelName, "page_title");
        } else if (subMenuItem) {
          newLabel = systemStatus.getSubMenuProperty(labelName);
        } else {
          newLabel = systemStatus.getLabel(labelName);
        }
      }
    }
    // If there are any parameters to substitute then do so
    if (newLabel != null && params != null && params.size() > 0) {
      Template labelText = new Template(newLabel);
      labelText.setParseElements(params);
      newLabel = labelText.getParsedText();
    }
    // Output the label value, else output the body of the tag
    if (newLabel != null) {
      try {
        this.pageContext.getOut().write(StringUtils.toHtmlChars(newLabel));
        return SKIP_BODY;
      } catch (java.io.IOException e) {
        //Nowhere to output
      }
    }
    return EVAL_BODY_INCLUDE;
  }

}
