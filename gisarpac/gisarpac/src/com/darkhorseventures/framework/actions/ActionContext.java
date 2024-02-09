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
package com.darkhorseventures.framework.actions;

import java.io.Serializable;

import javax.servlet.Servlet;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.darkhorseventures.framework.beans.GenericBean;

/**
 * ActionContext is created in the <code>DefaultAction</code> so that a single
 * object is passed around to actions. ActionContext provides a place holder
 * for the <code>HttpServletRequest</code> , <code>HttpServletResponse</code> ,
 * <code>HttpSession</code> , and the Struts variables as well... <code>
 * ActionServlet</code> , <code>ActionAction</code> and <code>ActionForm
 * </code>.
 *
 * @author Kevin Duffey
 * @version 1.0
 * @created June 1, 2001
 */
public class ActionContext
    implements Serializable {
  private String command = "Default";
  private HttpServletRequest request = null;
  private HttpServletResponse response = null;
  private HttpSession session = null;
  private Servlet servlet = null;
  private Action action = null;
  private Object bean = null;
  public final static String MESSAGE = "MESSAGE";
  final static long serialVersionUID = 215434482513634196L;


  /**
   * Constructor that creates the ActionContext object and sets the needed
   * object references that actions will need access to.
   *
   * @param servlet  Description of Parameter
   * @param bean     Description of Parameter
   * @param action   Description of Parameter
   * @param request  Description of Parameter
   * @param response Description of Parameter
   */
  public ActionContext(Servlet servlet, Object bean, Action action, HttpServletRequest request, HttpServletResponse response) {
    this.bean = bean;
    this.request = request;
    this.response = response;
    this.servlet = servlet;
    this.action = action;

    // set the HttpSession for this context, making it easier to get a HttpSession
    // reference, instead of always having to call request.getSession().
    session = request.getSession(true);

    // If a 'command' parameter is in the request scope, then a command
    // is available and we must set this context instances' command value.
    // If a command parameter is not found, then the default command is
    // always assumed.
    if (request.getQueryString() != null) {
      if (request.getQueryString().indexOf("command=") > -1) {
        command = request.getParameter("command");
      }
    }
  }


  /**
   * Constructor that creates a ActionContext for a Webdav Request.
   *
   * @param servlet  Description of the Parameter
   * @param request  Description of the Parameter
   * @param response Description of the Parameter
   */
  public ActionContext(Servlet servlet, HttpServletRequest request, HttpServletResponse response) {
    this.request = request;
    this.response = response;
    this.servlet = servlet;
  }


  /**
   * Sets a request attribute that can be used by JSP pages to display an error
   * message or take some other course of action if the attribute exists when
   * the JSP page is forwarded to.
   *
   * @param value the message to set into the request attribute
   */
  public void setMessage(String value) {
    // if the bean object is an instance of the GenericBean class, set the message
    // on the bean, as well as a request attribute
    if (bean instanceof GenericBean) {
      ((GenericBean) bean).setMessage(value);
    }
    getRequest().setAttribute(MESSAGE, value);
  }


  /**
   * Returns the ServletContext if this servlet is an HttpServlet instance
   *
   * @return ServletContext the ServletContext for this servlet
   */
  public ServletContext getServletContext() {
    return servlet.getServletConfig().getServletContext();
  }


  /**
   * Gets the servlet attribute of the ActionContext object
   *
   * @return The servlet value
   */
  public Servlet getServlet() {
    return servlet;
  }


  /**
   * Returns a reference to a bean that is mapped to this action. The reference
   * is an HttpSession bean reference.
   *
   * @return Object the bean reference mapped to this action
   */
  public Object getFormBean() {
    return bean;
  }


  /**
   * Gets the FormBean attribute of the ActionContext object
   *
   * @param beanName Description of Parameter
   * @return The FormBean value
   */
  public Object getFormBean(String beanName) {
    return action.getBeans().get(beanName);
  }


  /**
   * Returns the Action for this action. This Action contains the action name
   * and fully qualifed class, the bean name and fully qualified class (if
   * specified), zero or more Resources to forward to which each contain the
   * name of the resource (which is what the action class methods would return
   * as a String for the lookup process), the JSP page to forward to, and
   * alternatively a XSL file to be used to transform the JSP output if the
   * XSLControllerServlet is used.
   *
   * @return Action the Action for this action
   */
  public Action getAction() {
    return action;
  }


  /**
   * Returns the clients browser information.
   *
   * @return String The description of the clients browser
   */
  public String getBrowser() {
    return getRequest().getHeader("USER-AGENT");
  }


  /**
   * Returns the command value associated with this request
   *
   * @return int The value of the command for this request
   */
  public String getCommand() {
    return command;
  }


  /**
   * A helper method that returns a request parameter of the passed in param
   * name if it exists, or null otherwise.
   *
   * @param paramName Description of Parameter
   * @return String the value of the parameter or null if the
   *         parameter does not exist
   */
  public String getParameter(String paramName) {
    return getRequest().getParameter(paramName);
  }


  /**
   * Returns the clients remote IP address
   *
   * @return String The clients ip address to their computer.
   */
  public String getIpAddress() {
    return getRequest().getRemoteAddr();
  }


  /**
   * Returns the current request object associated with a client
   *
   * @return HttpServletRequest The request of this client
   */
  public HttpServletRequest getRequest() {
    return request;
  }


  /**
   * Returns the current response object associated with a client
   *
   * @return HttpServletResponse The response of this client
   */
  public HttpServletResponse getResponse() {
    return response;
  }


  /**
   * Returns the session associated with a client
   *
   * @return HttpSession The session context for this client
   */
  public HttpSession getSession() {
    return session;
  }

}

