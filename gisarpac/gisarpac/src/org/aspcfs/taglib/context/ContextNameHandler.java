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
package org.aspcfs.taglib.context;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

/** 
 * Description of the Class
 *
 * @author mrajkowski
 * @version $Id: BrowserHandler.java,v 1.4 2003/03/10 15:22:05 mrajkowski Exp
 *          $
 * @created January 15, 2003
 */
public class ContextNameHandler extends TagSupport  {
  private String contextId = null;
  private double minVersion = -1;
  private double maxVersion = -1;
  private String os = null;
  private boolean include = true;

  
  /**
   * Sets the id attribute of the BrowserHandler object
   *
   * @param tmp The new id value
   */
  public final void setId(String tmp) {
	  contextId = tmp;
  }
  

  /**
   * Sets the minVersion attribute of the BrowserHandler object
   *
   * @param tmp The new minVersion value
   */
  public final void setMinVersion(String tmp) {
    minVersion = Double.parseDouble(tmp);
  }


  /**
   * Sets the maxVersion attribute of the BrowserHandler object
   *
   * @param tmp The new maxVersion value
   */
  public final void setMaxVersion(String tmp) {
    maxVersion = Double.parseDouble(tmp);
  }


  /**
   * Sets the os attribute of the BrowserHandler object
   *
   * @param tmp The new os value
   */
  public void setOs(String tmp) {
    this.os = tmp;
  }


  /**
   * Sets the include attribute of the BrowserHandler object
   *
   * @param tmp The new include value
   */
  public final void setInclude(String tmp) {
    include = tmp.equalsIgnoreCase("true");
  }


  /**
   * Description of the Method
   *
   * @return Description of the Return Value
   * @throws JspException Description of the Exception
   */
  public final int doStartTag() throws JspException {
	
	
	  try {
		  System.out.println("Context "+pageContext.getServletContext().getServletContextName());
		pageContext.getOut().write("<input type = 'hidden' name = 'context' value = '"+pageContext.getServletContext().getServletContextName()+"'/>");
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
   
      
        return EVAL_BODY_INCLUDE;
      
    
  }

  

}

