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
package com.darkhorseventures.framework.beans;

import javax.servlet.http.HttpServletRequest;

/**
 * Description of the Interface
 *
 * @author kevin duffey
 * @version $Id: Populate.java 24274 2007-12-09 09:49:18Z srinivasar@cybage.com $
 * @created june 1, 2001
 */
public interface Populate {
  /**
   * Description of the Method
   *
   * @param bean            Description of the Parameter
   * @param request         Description of the Parameter
   * @param nestedAttribute Description of the Parameter
   * @param indexAttribute  Description of the Parameter
   */
  public void populateObject(Object bean, HttpServletRequest request, String nestedAttribute, String indexAttribute);
}

