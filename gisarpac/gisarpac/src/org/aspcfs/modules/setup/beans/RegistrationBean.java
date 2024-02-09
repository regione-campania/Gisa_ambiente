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

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.XMLUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.darkhorseventures.framework.beans.GenericBean;

/**
 * Bean to encapsulate the Setup HTML form
 *
 * @author mrajkowski
 * @version $Id: RegistrationBean.java,v 1.1.2.1 2003/08/13 15:28:42
 *          mrajkowski Exp $
 * @created August 13, 2003
 */
public class RegistrationBean extends GenericBean {

  private int configured = -1;
  private String nameFirst = null;
  private String nameLast = null;
  private String company = null;
  private String email = null;
  private boolean ssl = true;
  private String zlib = null;
  private String zlib2 = null;
  private String text = null;
  private String profile = null;
  private String webserver = null;
  private boolean proxy = false;
  private String proxyHost = null;
  private String proxyPort = null;


  /**
   * Sets the configured attribute of the RegistrationBean object
   *
   * @param tmp The new configured value
   */
  public void setConfigured(int tmp) {
    this.configured = tmp;
  }


  /**
   * Sets the configured attribute of the RegistrationBean object
   *
   * @param tmp The new configured value
   */
  public void setConfigured(String tmp) {
    this.configured = Integer.parseInt(tmp);
  }


  /**
   * Sets the nameFirst attribute of the RegistrationBean object
   *
   * @param tmp The new nameFirst value
   */
  public void setNameFirst(String tmp) {
    this.nameFirst = tmp;
  }


  /**
   * Sets the nameLast attribute of the RegistrationBean object
   *
   * @param tmp The new nameLast value
   */
  public void setNameLast(String tmp) {
    this.nameLast = tmp;
  }


  /**
   * Sets the company attribute of the RegistrationBean object
   *
   * @param tmp The new company value
   */
  public void setCompany(String tmp) {
    this.company = tmp;
  }


  /**
   * Sets the email attribute of the RegistrationBean object
   *
   * @param tmp The new email value
   */
  public void setEmail(String tmp) {
    this.email = tmp;
  }


  /**
   * Sets the ssl attribute of the RegistrationBean object
   *
   * @param tmp The new ssl value
   */
  public void setSsl(boolean tmp) {
    this.ssl = tmp;
  }


  /**
   * Sets the ssl attribute of the RegistrationBean object
   *
   * @param tmp The new ssl value
   */
  public void setSsl(String tmp) {
    this.ssl = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   * Sets the zlib attribute of the RegistrationBean object
   *
   * @param tmp The new zlib value
   */
  public void setZlib(String tmp) {
    this.zlib = tmp;
  }


  public void setZlib2(String zlib2) {
    this.zlib2 = zlib2;
  }

  /**
   * Sets the text attribute of the RegistrationBean object
   *
   * @param tmp The new text value
   */
  public void setText(String tmp) {
    this.text = tmp;
  }


  /**
   * Sets the profile attribute of the RegistrationBean object
   *
   * @param tmp The new profile value
   */
  public void setProfile(String tmp) {
    this.profile = tmp;
  }


  /**
   * Sets the webserver attribute of the RegistrationBean object
   *
   * @param tmp The new webserver value
   */
  public void setWebserver(String tmp) {
    this.webserver = tmp;
  }


  /**
   * Gets the proxy attribute of the RegistrationBean object
   *
   * @return The proxy value
   */
  public boolean getProxy() {
    return proxy;
  }


  /**
   * Sets the proxy attribute of the RegistrationBean object
   *
   * @param tmp The new proxy value
   */
  public void setProxy(boolean tmp) {
    this.proxy = tmp;
  }


  /**
   * Sets the proxy attribute of the RegistrationBean object
   *
   * @param tmp The new proxy value
   */
  public void setProxy(String tmp) {
    this.proxy = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   * Gets the proxyHost attribute of the RegistrationBean object
   *
   * @return The proxyHost value
   */
  public String getProxyHost() {
    return proxyHost;
  }


  /**
   * Sets the proxyHost attribute of the RegistrationBean object
   *
   * @param tmp The new proxyHost value
   */
  public void setProxyHost(String tmp) {
    this.proxyHost = tmp;
  }


  /**
   * Gets the proxyPort attribute of the RegistrationBean object
   *
   * @return The proxyPort value
   */
  public String getProxyPort() {
    return proxyPort;
  }


  /**
   * Sets the proxyPort attribute of the RegistrationBean object
   *
   * @param tmp The new proxyPort value
   */
  public void setProxyPort(String tmp) {
    this.proxyPort = tmp;
  }


  /**
   * Gets the configured attribute of the RegistrationBean object
   *
   * @return The configured value
   */
  public int getConfigured() {
    return configured;
  }


  /**
   * Gets the nameFirst attribute of the RegistrationBean object
   *
   * @return The nameFirst value
   */
  public String getNameFirst() {
    return nameFirst;
  }


  /**
   * Gets the nameLast attribute of the RegistrationBean object
   *
   * @return The nameLast value
   */
  public String getNameLast() {
    return nameLast;
  }


  /**
   * Gets the company attribute of the RegistrationBean object
   *
   * @return The company value
   */
  public String getCompany() {
    return company;
  }


  /**
   * Gets the email attribute of the RegistrationBean object
   *
   * @return The email value
   */
  public String getEmail() {
    return email;
  }


  /**
   * Gets the ssl attribute of the RegistrationBean object
   *
   * @return The ssl value
   */
  public boolean getSsl() {
    return ssl;
  }


  /**
   * Gets the profile attribute of the RegistrationBean object
   *
   * @return The profile value
   */
  public String getProfile() {
    return profile;
  }


  /**
   * Gets the webserver attribute of the RegistrationBean object
   *
   * @return The webserver value
   */
  public String getWebserver() {
    return webserver;
  }


  /**
   * Description of the Method
   *
   * @return Description of
   *         the Return Value
   * @throws javax.xml.parsers.ParserConfigurationException
   *          Description of
   *          the Exception
   */
  public String toXmlString() throws javax.xml.parsers.ParserConfigurationException {
    //Build an XML document needed for request
    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
    DocumentBuilder builder = dbf.newDocumentBuilder();
    Document document = builder.newDocument();
    //Root element
    Element rootElement = document.createElement("crmRegistration");
    document.appendChild(rootElement);
    //First name
    Element nameFirstElement = document.createElement("nameFirst");
    nameFirstElement.appendChild(document.createTextNode(nameFirst));
    rootElement.appendChild(nameFirstElement);
    //Last name
    Element nameLastElement = document.createElement("nameLast");
    nameLastElement.appendChild(document.createTextNode(nameLast));
    rootElement.appendChild(nameLastElement);
    //Company name
    Element companyElement = document.createElement("company");
    companyElement.appendChild(document.createTextNode(company));
    rootElement.appendChild(companyElement);
    //Email address
    Element emailElement = document.createElement("email");
    emailElement.appendChild(document.createTextNode(email));
    rootElement.appendChild(emailElement);
    //Profile
    Element profileElement = document.createElement("profile");
    profileElement.appendChild(document.createTextNode(profile));
    rootElement.appendChild(profileElement);
    //OS
    String os = System.getProperty("os.name") + " " + System.getProperty(
        "os.arch") + " " + System.getProperty("os.version");
    Element osElement = document.createElement("os");
    osElement.appendChild(document.createTextNode(os));
    rootElement.appendChild(osElement);
    //java
    String java = System.getProperty("java.version");
    Element javaElement = document.createElement("java");
    javaElement.appendChild(document.createTextNode(java));
    rootElement.appendChild(javaElement);
    //Web Server type
    if (webserver != null) {
      Element webElement = document.createElement("webserver");
      webElement.appendChild(document.createTextNode(webserver));
      rootElement.appendChild(webElement);
    }
    //Key
    if (zlib != null) {
      Element zlibElement = document.createElement("zlib");
      zlibElement.appendChild(document.createTextNode(zlib));
      rootElement.appendChild(zlibElement);
    }
    if (zlib2 != null) {
      Element zlibElement = document.createElement("zlib2");
      zlibElement.appendChild(document.createTextNode(zlib2));
      rootElement.appendChild(zlibElement);
    }
    if (text != null) {
      Element textElement = document.createElement("text");
      textElement.appendChild(document.createTextNode(text));
      rootElement.appendChild(textElement);
    }
    return XMLUtils.toString(rootElement);
  }

}

