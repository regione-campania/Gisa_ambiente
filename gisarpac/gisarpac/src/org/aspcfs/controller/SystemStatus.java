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
package org.aspcfs.controller;

import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.Map;

import javax.servlet.ServletContext;

import net.sf.asterisk.manager.ManagerConnection;

import org.apache.log4j.Logger;
import org.aspcfs.modules.admin.base.AccessTypeList;
import org.aspcfs.modules.admin.base.CategoryEditor;
import org.aspcfs.modules.admin.base.CustomListViewEditor;
import org.aspcfs.modules.admin.base.Permission;
import org.aspcfs.modules.admin.base.Role;
import org.aspcfs.modules.admin.base.RoleList;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.admin.base.UserList;
import org.aspcfs.modules.admin.base.UserPermissionList;
import org.aspcfs.modules.service.base.SyncTableList;
import org.aspcfs.utils.AsteriskListener;
import org.aspcfs.utils.AsteriskManager;
import org.aspcfs.utils.StringUtils;
import org.aspcfs.utils.XMLUtils;
import org.aspcfs.utils.XMPPManager;
import org.aspcfs.utils.web.LookupList;
import org.jivesoftware.smack.XMPPConnection;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.darkhorseventures.database.ConnectionElement;
import com.darkhorseventures.framework.actions.ActionContext;
import com.zeroio.controller.Tracker;
import com.zeroio.webdav.WebdavManager;

/**
 * System status maintains global values for a shared group of users. This is
 * based on the database that the user is connecting to.<p>
 * <p/>
 * <p/>
 * <p/>
 * When a user logs in, permissions and hierarchies are read in. If someone
 * changes user or role data then the user's permissions and hierarchies will
 * be read in during the Security Check.
 *
 * @author mrajkowski
 * @version $Id: SystemStatus.java,v 1.40.10.1 2004/08/27 18:33:59 mrajkowski
 *          Exp $
 * @created October 10, 2001
 */
public class SystemStatus {
  //Unique to this system
  private ConnectionElement connectionElement = null;
  private String fileLibraryPath = null;
  private String url = null;

  //Role permission cache
  private Date permissionCheck = new Date();
  private Hashtable rolePermissions = new Hashtable();
  private boolean permissionUpdating = false;

  //User list cache
  private Date hierarchyCheck = new Date();
  private UserList hierarchyList = new UserList();
  
  private Hashtable userList = new Hashtable();
  
  private Hashtable siteUserList = new Hashtable();
  private boolean hierarchyUpdating = false;

  //Cached lookup tables
  private HashMap lookups = new HashMap();

  //Cached object collections
  private HashMap objects = new HashMap();

  //Site Preferences
  private Map preferences = new LinkedHashMap();
  private  int sessionTimeout = 300;


  //Session Manager
  private  SessionManager sessionManager = new SessionManager();

  //Webdav Manager
  private WebdavManager webdavManager = new WebdavManager();

  //Category Editor
  private Map categoryEditorList = new HashMap();

  //Custom List View Editor
  private Map customListViewEditors = new HashMap();

  //Cached access types
  private HashMap accessTypes = new HashMap();

  //Portal Tracker
  private Tracker tracker = new Tracker();

  //Access to applicationPrefs (readOnly)
  private ApplicationPrefs applicationPrefs = null;

  private ManagerConnection asteriskConnection = null;
  private AsteriskListener asteriskListener = null;
  private XMPPConnection xmppConnection = null;

  //System Language
  private String language = null;

  // System specific container menus
  private LinkedHashMap menu = null;
  private HashMap properties = null;

  // Logger.
  private static final Logger LOGGER = Logger.getLogger(SystemStatus.class.getName());

  //XML Object Map (readOnly)
  SyncTableList systemObjectMap = null;


  /**
   * Constructor for the SystemStatus object
   *
   * @since 1.1
   */
  public SystemStatus() {
  }
 

  public void setUserList(Hashtable userList) {
	this.userList = userList;
}


/**
   * Constructor for the SystemStatus object
   *
   * @param db      Description of Parameter
   * @param context Description of the Parameter
   * @throws SQLException Description of the Exception
   * @since 1.3
   */
  public SystemStatus(Connection db, ServletContext context) throws SQLException {
    queryRecord(db, context);
  }


  /**
   * Description of the Method
   *
   * @param db      Description of the Parameter
   * @param context Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void queryRecord(Connection db, ServletContext context) throws SQLException {
  
	  String suff =(String) context.getAttribute("SUFFISSO_TAB_ACCESSI");
	buildHierarchyList(db,context);
    buildPreferences(db);
    buildRolePermissions(db,suff);
    //buildWebdavResources(db);
    loadTabs(context, db);
  }


  /**
   * Sets the PermissionCheck attribute of the SystemStatus object
   *
   * @param tmp The new PermissionCheck value
   * @since 1.1
   */
  public void setPermissionCheck(Date tmp) {
    this.permissionCheck = tmp;
  }


  /**
   * Sets the HierarchyCheck attribute of the SystemStatus object
   *
   * @param tmp The new HierarchyCheck value
   * @since 1.1
   */
  public void setHierarchyCheck(Date tmp) {
    this.hierarchyCheck = tmp;
  }


  /**
   * Sets the connectionElement attribute of the SystemStatus object
   *
   * @param tmp The new connectionElement value
   */
  public void setConnectionElement(ConnectionElement tmp) {
    this.connectionElement = tmp;
  }


  /**
   * Sets the fileLibraryPath attribute of the SystemStatus object
   *
   * @param tmp The new fileLibraryPath value
   */
  public void setFileLibraryPath(String tmp) {
    this.fileLibraryPath = tmp;
  }


  /**
   * Gets the url attribute of the SystemStatus object
   *
   * @return The url value
   */
  public String getUrl() {
    return url;
  }


  /**
   * Sets the url attribute of the SystemStatus object
   *
   * @param url The new url value
   */
  public void setUrl(String url) {
    this.url = url;
  }


  /**
   * SessionManager manages the sessions active in the system
   *
   * @param sessionManager The new sessionManager value
   */
  public void setSessionManager(SessionManager sessionManager) {
    this.sessionManager = sessionManager;
  }


  /**
   * Sets the webdavManager attribute of the SystemStatus object
   *
   * @param webdavManager The new webdavManager value
   */
  public void setWebdavManager(WebdavManager webdavManager) {
    this.webdavManager = webdavManager;
  }


  /**
   * Sets the sessionTimeout attribute of the SystemStatus object
   *
   * @param sessionTimeout The new sessionTimeout value
   */
  public void setSessionTimeout(int sessionTimeout) {
    this.sessionTimeout = sessionTimeout;
  }


  /**
   * Gets the categoryEditorList attribute of the SystemStatus object
   *
   * @return The categoryEditorList value
   */
  public Map getCategoryEditorList() {
    return categoryEditorList;
  }


  /**
   * Gets the customListViewEditors attribute of the SystemStatus object
   *
   * @return The customListViewEditors value
   */
  public Map getCustomListViewEditors() {
    return customListViewEditors;
  }


  /**
   * Gets the Import Manager for this Application Instance <br>
   * NOTE: There is one Import Manager per application instance
   *
   * @param context Description of the Parameter
   * @return The importManager value
   */
  public ImportManager getImportManager(ActionContext context) {
    return (ImportManager) context.getServletContext().getAttribute(
        "ImportManager");
  }


  /**
   * Sets the preferences attribute of the SystemStatus object
   *
   * @param preferences The new preferences value
   */
  public void setPreferences(Map preferences) {
    this.preferences = preferences;
  }


  /**
   * Gets the preferences attribute of the SystemStatus object
   *
   * @return The preferences value
   */
  public Map getPreferences() {
    return preferences;
  }


  /**
   * Gets the categoryEditor attribute of the SystemStatus object
   *
   * @param db         Description of the Parameter
   * @param constantId Description of the Parameter
   * @return The categoryEditor value
   * @throws SQLException Description of the Exception
   */
  public CategoryEditor getCategoryEditor(Connection db, int constantId) throws SQLException {
    synchronized (this) {
      CategoryEditor categoryEditor = (CategoryEditor) categoryEditorList.get(
          new Integer(constantId));
      if (categoryEditor == null) {
        categoryEditor = new CategoryEditor(db, constantId);
        categoryEditor.build(db);
        categoryEditorList.put(new Integer(constantId), categoryEditor);
      }
      return categoryEditor;
    }
  }


  /**
   * Gets the customListViewEditor attribute of the SystemStatus object
   *
   * @param db         Description of the Parameter
   * @param constantId Description of the Parameter
   * @param context    Description of the Parameter
   * @return The customListViewEditor value
   * @throws SQLException Description of the Exception
   */
  public CustomListViewEditor getCustomListViewEditor(ActionContext context, Connection db, int constantId) throws SQLException {
    synchronized (this) {
      CustomListViewEditor listViewEditor = (CustomListViewEditor) customListViewEditors.get(
          new Integer(constantId));
      if (listViewEditor == null) {
        listViewEditor = new CustomListViewEditor(db, constantId);
        listViewEditor.build(context.getServletContext(), db, "/WEB-INF/");
        customListViewEditors.put(new Integer(constantId), listViewEditor);
      }
      return listViewEditor;
    }
  }


  /**
   * Gets the sessionTimeout attribute of the SystemStatus object
   *
   * @return The sessionTimeout value
   */
  public int getSessionTimeout() {
    return sessionTimeout;
  }


  /**
   * Gets the sessionManager attribute of the SystemStatus object
   *
   * @return The sessionManager value
   */
  public SessionManager getSessionManager() {
    return sessionManager;
  }


  /**
   * Gets the webdavManager attribute of the SystemStatus object
   *
   * @return The webdavManager value
   */
  public WebdavManager getWebdavManager() {
    return webdavManager;
  }


  /**
   * Gets the PermissionCheck attribute of the SystemStatus object
   *
   * @return The PermissionCheck value
   * @since 1.1
   */
  public Date getPermissionCheck() {
//    while (permissionUpdating) {
//    }
    return permissionCheck;
  }


  /**
   * Gets the HierarchyCheck attribute of the SystemStatus object
   *
   * @return The HierarchyCheck value
   * @since 1.1
   */
  public Date getHierarchyCheck() {
//    while (hierarchyUpdating) {
//    }
    return hierarchyCheck;
  }


  /**
   * Gets the hierarchyList attribute of the SystemStatus object
   *
   * @return The hierarchyList value
   */
  public UserList getHierarchyList() {
//    while (hierarchyUpdating) {
//    }
    return hierarchyList;
  }


  /**
   * Gets the userList attribute of the SystemStatus object
   *
   * @return The userList value
   */
  public Hashtable getUserList() {
//    while (hierarchyUpdating) {
//    }
    return userList;
  }


  /**
   * Gets the siteUserList attribute of the SystemStatus object
   *
   * @return The siteUserList value
   */
  public Hashtable getSiteUserList() {
//    while (hierarchyUpdating) {
//    }
    return siteUserList;
  }


  /**
   * Gets the label attribute of the SystemStatus object
   *
   * @param thisLabel Description of Parameter
   * @return The label value
   */
  public String getLabel(String thisLabel) {
    String text = this.getValue("system.fields.label", thisLabel);
    if (text == null) {
      text = applicationPrefs.getLabel("system.fields.label", thisLabel, language);
    }
    return text;
  }


  /**
   * Gets the label for this key, if it's not found then use the default text
   * that was specified
   *
   * @param thisLabel   The key corresponding to the item to be replaced
   * @param defaultText
   * @return The label value
   */
  public String getLabel(String thisLabel, String defaultText) {
    String result = getLabel(thisLabel);
    if (result == null) {
      return defaultText;
    } else {
      return result;
    }
  }


  /**
   * Gets the lettersArray attribute of the SystemStatus object
   *
   * @param thisLabel Description of the Parameter
   * @return The lettersArray value
   */
  public String[] getLettersArray(String thisLabel) {
    String letters = this.getLabel(thisLabel);
    return letters.split(",");
  }


  /**
   * Gets the title attribute of the SystemStatus object
   *
   * @param item         Description of the Parameter
   * @param thisProperty Description of the Parameter
   * @return The title value
   */
  public String getMenuProperty(String item, String thisProperty) {
    String text = this.getValue("system.modules.label", item, thisProperty);
    if (text == null) {
      text = applicationPrefs.getValue(
          "system.modules.label", item, thisProperty, language);
    }
    return text;
  }


  /**
   * Gets the subMenuProperty attribute of the SystemStatus object
   *
   * @param thisLabel Description of the Parameter
   * @return The subMenuProperty value
   */
  public String getSubMenuProperty(String thisLabel) {
    String text = this.getValue("system.submenu.label", thisLabel);
    if (text == null) {
      text = applicationPrefs.getLabel("system.submenu.label", thisLabel, language);
    }
    return text;
  }


  /**
   * Gets the containerMenuProperty attribute of the SystemStatus object
   *
   * @param collection   Description of the Parameter
   * @param thisProperty Description of the Parameter
   * @return The containerMenuProperty value
   */
  public String getContainerMenuProperty(String collection, String thisProperty) {
    String text = this.getValue(collection, thisProperty, "value");
    if (text == null) {
      text = applicationPrefs.getValue(collection, thisProperty, "value", language);
    }
    return text;
  }


  /**
   * Gets the connectionElement attribute of the SystemStatus object
   *
   * @return The connectionElement value
   */
  public ConnectionElement getConnectionElement() {
    return connectionElement;
  }


  /**
   * Gets the fileLibraryPath attribute of the SystemStatus object
   *
   * @return The fileLibraryPath value
   */
  public String getFileLibraryPath() {
    return fileLibraryPath;
  }


  /**
   * Gets the hookManager attribute of the SystemStatus object
   *
   * @return The hookManager value
   */


  /**
   * Gets the applicationPrefs attribute of the SystemStatus object
   *
   * @return The applicationPrefs value
   */
  public ApplicationPrefs getApplicationPrefs() {
    return applicationPrefs;
  }


  /**
   * Gets the localizationPrefs attribute of the SystemStatus object
   *
   * @return The localizationPrefs value
   */
  public Map getLocalizationPrefs() {
    return applicationPrefs.getLocalizationPrefs(language);
  }


  /**
   * Sets the applicationPrefs attribute of the SystemStatus object
   *
   * @param tmp The new applicationPrefs value
   */
  public void setApplicationPrefs(ApplicationPrefs tmp) {
    this.applicationPrefs = tmp;
  }


  /**
   * Gets the language attribute of the SystemStatus object
   *
   * @return The language value
   */
  public String getLanguage() {
    return language;
  }


  /**
   * Sets the language attribute of the SystemStatus object
   *
   * @param language The new language value
   */
  public void setLanguage(String language) {
    this.language = language;
  }


  /**
   * Generates a list of all users in the system for the given database
   * connection
   *
   * @param db Description of Parameter
   * @throws SQLException Description of Exception
   * @since 1.3
   */
  public void buildHierarchyList(Connection db,ServletContext ctx) throws SQLException {
	  String suffix =(String)ctx.getAttribute("SUFFISSO_TAB_ACCESSI");
    //data at the same time.  That's why the buildContact is disabled.
    hierarchyList.clear();
    userList.clear();
    siteUserList.clear();
    //Get the top level managers
    String endPoing = (String)ctx.getAttribute("END_POINT_ROLE_EXT");
    UserList tmpListA = new UserList();
    tmpListA.setBuildContact(true);
    tmpListA.setBuildContactDetails(false);
    tmpListA.setBuildHierarchy(false);
    tmpListA.setSuperRuolo(endPoing);
    tmpListA.setTopLevel(true);
    tmpListA.setIncludeDHVAdmin(true);
    tmpListA.setIncludeUsersWithRolesOnly(false);
    tmpListA.buildList(db,suffix);
    if (System.getProperty("DEBUG") != null) {
      System.out.println(
          "SystemStatus-> buildHierarchyList: A " + tmpListA.size());
    }
//    //Get everyone
//    UserList tmpListB = new UserList();
//    tmpListB.setIncludeDHVAdmin(true);
//    tmpListB.setBuildContact(true);
//    tmpListB.setSuperRuolo(endPoing);
//
//    tmpListB.setBuildContactDetails(false);
//    tmpListB.setBuildHierarchy(false);
//    tmpListB.setTopLevel(false);
//    tmpListB.setIncludeUsersWithRolesOnly(false);
//    tmpListB.buildList(db,suffix);
//    if (System.getProperty("DEBUG") != null) {
//      System.out.println(
//          "SystemStatus-> buildHierarchyList: B " + tmpListB.size());
//    }
    //Combine the lists
    Iterator listA = tmpListA.iterator();
    while (listA.hasNext()) {
      User thisUser = (User) listA.next();
//      User userToAdd = tmpListB.getTopUser(thisUser.getId());
//      if (userToAdd != null) {
//        hierarchyList.add(userToAdd);
//        userList.put(new Integer(userToAdd.getId()), userToAdd);
//        addUserToSite(userToAdd);
//        addChildUsers(userToAdd, tmpListB);
//      } else {
        hierarchyList.add(thisUser);
        userList.put(new Integer(thisUser.getId()), thisUser);
        addUserToSite(thisUser);
//      }
    }
    if (System.getProperty("DEBUG") != null) {
      System.out.println(
          "SystemStatus-> Top Level Users added : " + hierarchyList.size());
    }
  }
  
  
  public boolean buildHierarchyListbyUserId(Connection db, String username,String suff) throws SQLException {
	  
	  
	  /**
	   * VERONICA: NUOVA GESTIONE ELIMINAZIONE UTENTE PRECEDENTE CON SISTEMA DI CREAZIONE NUOVO UTENTE DA GUC
	   */
	  int userIdToRemove = -1;
	  java.sql.PreparedStatement pstToRemove = db.prepareStatement("select user_id from  access"+suff+"_ where username = ? and trashed_date is null and data_scadenza = (select max (data_scadenza) from  access"+suff+"_ where username = ? and trashed_date is null ) ");
	  pstToRemove.setString(1, username);
	  pstToRemove.setString(2, username);
	  java.sql.ResultSet rsToRemove = pstToRemove.executeQuery();
	  
	  while (rsToRemove.next()){
		  userIdToRemove = rsToRemove.getInt(1);
	  }
	  
	  
	    //data at the same time.  That's why the buildContact is disabled.
	   java.sql.PreparedStatement pst = db.prepareStatement("select user_id from access"+suff+" where username = ? and trashed_date is null");
	   pst.setString(1,username );
	   java.sql.ResultSet rs = pst.executeQuery();
	   while (rs.next())
	   {
	    int userId = rs.getInt(1);
	    User uu = new User();
	    uu.setBuildContact(true);
	    uu.setBuildHierarchy(true);
	    uu.buildRecord(db,userId,suff);
	    //Combine the lists
	    
	    //while (listA.hasNext()) {
	      User thisUser = uu ;
	      User userToAdd = uu ;
	      if (userToAdd != null) {
	    	 // int loc = hierarchyList.getLocationUserById(userToAdd.getId());
	    	  int loc = hierarchyList.getLocationUserById(userIdToRemove);
	    	  if (loc>-1){
	    		  hierarchyList.remove(loc);
	    	  }
	    	  hierarchyList.add(userToAdd);
	        
	        userList.put(new Integer(userToAdd.getId()), userToAdd);
	        addUserToSite(userToAdd);
	       
	      } else {
	    	  int loc = hierarchyList.getLocationUserById(userToAdd.getId());
	    	  if (loc>-1){
	    		  hierarchyList.remove(loc);
	    	  }
	    	  
	        hierarchyList.add(thisUser);
	        
	        
	        
	        userList.put(new Integer(thisUser.getId()), thisUser);
	        addUserToSite(thisUser);
	      }
	    //}
	    if (System.getProperty("DEBUG") != null) {
	      System.out.println(
	          "SystemStatus-> Top Level Users added : " + hierarchyList.size());
	    }
	    
	    
	    
	    /*invalido sessione*/
	    HashMap sessions = this.getSessionManager().getSessions();
	    if(sessions != null && sessions.size() > 0){
	    	
	    	try{
	    		for(Object o : sessions.keySet()){
	    			UserSession s = (UserSession)sessions.get(Integer.parseInt(o.toString()));
	    			if ( s.getUserId() ==  userIdToRemove){
	    				s.getSessionUser().invalidate();
	    				this.getSessionManager().getSessions().remove(Integer.parseInt(o.toString()));
	    			}
	    		}
	    	}
	    	catch(Exception e){     
	    		e.printStackTrace();
	    	} finally {
	    		return true;
	    	}
	    }
	    return true ;
	  }
	   
	   /*invalido sessione per cambio username - ho concatenato i due username con ;-; es. old_username;-;new_username*/
	    HashMap sessions = this.getSessionManager().getSessions();
	    if(sessions != null && sessions.size() > 0){
	    	String split[] = username.split(";-;");
	    	try{
	    		if (split.length==2){
		    		for(Object o : sessions.keySet()){
		    			UserSession s = (UserSession)sessions.get(Integer.parseInt(o.toString()));
		    			User ut = new User(db, s.getUserId(), suff);
		    			if (ut.getUsername().equals(split[1]) && s.getUserId()==ut.getId()){
		    				s.getSessionUser().invalidate();
		    				this.getSessionManager().getSessions().remove(Integer.parseInt(o.toString()));
		    				ut.setBuildContact(true);
		    				ut.setBuildHierarchy(true);
		    				int loc = hierarchyList.getLocationUserById(ut.getId());
		    		    	if (loc>-1){
		    		    		  hierarchyList.remove(loc);
		    		    	}
		    		    	hierarchyList.add(ut);
		    		    	userList.put(new Integer(ut.getId()), ut);
		    			    addUserToSite(ut);
		    			}
		    		}
	    		}
	    	}
	    	catch(Exception e){
	    		e.printStackTrace();
	    	} finally {
	    		return true;
	    	}
	    }
	    
	   return false ;
  }
  
  
  
  /**
   * A method to reload the user hierarchy, typically used when a user is added
   * or changed in the hierarchy.
   *
   * @param db Description of Parameter
   * @throws SQLException Description of Exception
   */
  public void updateHierarchy(Connection db,ServletContext ctx) throws SQLException {
    java.util.Date checkDate = new java.util.Date();
    if (checkDate.after(this.getHierarchyCheck())) {
      synchronized (this) {
        try {
          hierarchyUpdating = true;
          if (checkDate.after(hierarchyCheck)) {
            this.buildHierarchyList(db,ctx);
            this.setHierarchyCheck(new java.util.Date());
          }
        } catch (SQLException e) {
          throw e;
        } finally {
          hierarchyUpdating = false;
        }
      }
    }
  }

  
  
  /**
   * Reloads role permissions that have been cached. Typically used when roles
   * are modified or created.
   *
   * @param db Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void updateRolePermissions(Connection db,String suffisso) throws SQLException {
    java.util.Date checkDate = new java.util.Date();
    if (checkDate.after(this.getPermissionCheck())) {
      synchronized (this) {
        try {
//          permissionUpdating = true;
          if (checkDate.after(permissionCheck)) {
            this.buildRolePermissions(db,suffisso);
            this.setPermissionCheck(new java.util.Date());
          }
        } catch (SQLException e) {
          throw e;
        } finally {
          permissionUpdating = false;
        }
      }
    }
  }
  
  
  


  /**
   * Loads the preferences for this specific system. Preference files are
   * stored as XML in the system's fileLibrary.
   *
   * @param db Description of the Parameter
   */
  public void buildPreferences(Connection db) {
    if (System.getProperty("DEBUG") != null) {
      System.out.println(
          "SystemStatus-> Loading system preferences: " + fileLibraryPath + "system.xml ");
    }
    //Build the system preferences
    preferences.clear();
    try {
      if (fileLibraryPath != null) {
        File prefsFile = new File(fileLibraryPath + "system.xml");
        if (prefsFile.exists()) {
          XMLUtils xml = new XMLUtils(prefsFile);
          //Traverse the prefs and add the config nodes to the LinkedHashMap,
          //then for each config, add the param nodes into a child LinkedHashMap.
          //This will provide quick access to the values, and will allow an
          //editor to display the fields as ordered in the XML file
          NodeList configNodes = xml.getDocumentElement().getElementsByTagName(
              "config");
          for (int i = 0; i < configNodes.getLength(); i++) {
            Node configNode = configNodes.item(i);
            if (configNode != null &&
                configNode.getNodeType() == Node.ELEMENT_NODE &&
                "config".equals(((Element) configNode).getTagName()) &&
                (((Element) configNode).getAttribute("enabled") == null ||
                    "".equals(((Element) configNode).getAttribute("enabled")) ||
                    "true".equals(((Element) configNode).getAttribute("enabled")))) {
              //For each config name, create a map for each of the params
              String configName = ((Element) configNode).getAttribute("name");
              Map preferenceGroup = null;
              if (configName != null) {
                if (preferences.containsKey(configName)) {
                  preferenceGroup = (LinkedHashMap) preferences.get(
                      configName);
                } else {
                  preferenceGroup = new LinkedHashMap();
                  preferences.put(configName, preferenceGroup);
                }
                //Process the params for this config
                NodeList paramNodes = ((Element) configNode).getElementsByTagName(
                    "param");
                for (int j = 0; j < paramNodes.getLength(); j++) {
                  Node paramNode = paramNodes.item(j);
                  if (paramNode != null &&
                      paramNode.getNodeType() == Node.ELEMENT_NODE &&
                      "param".equals(((Element) paramNode).getTagName())) {
                    String paramName = ((Element) paramNode).getAttribute(
                        "name");
                    if (System.getProperty("DEBUG") != null) {
                      System.out.println(
                          "SystemStatus-> Added pref " + configName + ":" + paramName);
                    }
                    if (paramName != null) {
                      preferenceGroup.put(paramName, paramNode);
                    }
                  }
                }
              }
            }
          }
        }
      }
    } catch (Exception e) {
      e.printStackTrace(System.out);
      System.out.println(
          "SystemStatus-> Preferences Error: " + e.getMessage());
    }
    //Build the workflow manager preferences
    /*try {
      //Build processes from database
      if (System.getProperty("DEBUG") != null) {
        System.out.println(
            "SystemStatus-> Loading workflow processes from database");
      }
      //Add the user workflows
      hookManager.setFileLibraryPath(fileLibraryPath);
      hookManager.initializeBusinessProcessList(db, true);
      hookManager.initializeObjectHookList(db, true);
      if (hookManager.getProcessList().size() == 0 || hookManager.getHookList().size() == 0) {
        if (System.getProperty("DEBUG") != null) {
          System.out.println(
              "SystemStatus-> Loading workflow processes: " + fileLibraryPath + "workflow.xml");
        }
        //Build processes from file (backwards compatible)
        //NOTE: The file is fine, but it should be imported into the database so
        //users can use the web editor
        if (fileLibraryPath != null) {
          File prefsFile = new File(fileLibraryPath + "workflow.xml");
          if (prefsFile.exists()) {
            XMLUtils xml = new XMLUtils(prefsFile);
            hookManager.setFileLibraryPath(fileLibraryPath);
            if (hookManager.getProcessList().size() == 0) {
              hookManager.initializeBusinessProcessList(
                  xml.getDocumentElement(), true, false);
            }
            if (hookManager.getHookList().size() == 0) {
              hookManager.initializeObjectHookList(
                  xml.getDocumentElement(), true, false);
            }
          }
        }
      }
      this.addApplicationWorkflow();
    } catch (Exception e) {
      e.printStackTrace(System.out);
      System.out.println("SystemStatus-> Workflow Error: " + e.getMessage());
    }*/
  }


  /**
   * Adds a feature to the ApplicationWorkflow attribute of the SystemStatus
   * object
   */





  /**
   * Description of the Method
   *
   * @param db Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void buildWebdavResources(Connection db) throws SQLException {
    webdavManager.buildModules(db, fileLibraryPath);
  }


  /**
   * Initializes the permissions cache.
   *
   * @param db Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  public void buildRolePermissions(Connection db,String suffisso) throws SQLException {
    rolePermissions.clear();
    RoleList roles = new RoleList();
    roles.buildList(db,suffisso);
    Iterator roleIterator = roles.iterator();
    while (roleIterator.hasNext()) {
      Role thisRole = (Role) roleIterator.next();
      ArrayList permissions = new ArrayList();
      UserPermissionList permissionList = new UserPermissionList(db, thisRole.getId(),suffisso);
      Iterator i = permissionList.iterator();
      while (i.hasNext()) {
        Permission thisPermission = (Permission) i.next();
        if (thisPermission.getAdd()) {
          permissions.add(thisPermission.getName() + "-add");
        }
        if (thisPermission.getView()) {
          permissions.add(thisPermission.getName() + "-view");
        }
        if (thisPermission.getEdit()) {
          permissions.add(thisPermission.getName() + "-edit");
        }
        if (thisPermission.getDelete()) {
          permissions.add(thisPermission.getName() + "-delete");
        }
        if (thisPermission.getOfflineAdd()) {
          permissions.add(thisPermission.getName() + "-add" + "-offline");
        }
        if (thisPermission.getOfflineView()) {
          permissions.add(thisPermission.getName() + "-view" + "-offline");
        }
        if (thisPermission.getOfflineEdit()) {
          permissions.add(thisPermission.getName() + "-edit" + "-offline");
        }
        if (thisPermission.getOfflineDelete()) {
          permissions.add(thisPermission.getName() + "-delete" + "-offline");
        }
      }
      rolePermissions.put(new Integer(thisRole.getId()), permissions);
    }
  }


  /**
   * Builds the lookupList on demand and caches it in the lookups HashTable.
   *
   * @param db        Description of the Parameter
   * @param tableName Description of the Parameter
   * @return The lookupList value
   * @throws SQLException Description of the Exception
   */
  public LookupList getLookupList(Connection db, String tableName) throws SQLException {
    if (!lookups.containsKey(tableName) && db != null) {
      synchronized (this) {
        if (!lookups.containsKey(tableName)) {
          lookups.put(tableName, new LookupList(db, tableName));
          if (System.getProperty("DEBUG") != null) {
            System.out.println(
                "SystemStatus-> Added LookupList object: " + tableName);
          }
        }
      }
    }
    return (LookupList) lookups.get(tableName);
  }


  /**
   * Removes a lookup list from the cache
   *
   * @param tableName Description of the Parameter
   * @return Description of the Return Value
   */
  public boolean removeLookup(String tableName) {
    if (lookups.containsKey(tableName)) {
      synchronized (this) {
        if (lookups.containsKey(tableName)) {
          lookups.remove(tableName);
          if (System.getProperty("DEBUG") != null) {
            System.out.println(
                "SystemStatus-> Removed LookupList object: " + tableName);
          }
        }
      }
    }
    return true;
  }


  /**
   * Gets the xMLObjectMap attribute of the SystemStatus object
   *
   * @param db       Description of the Parameter
   * @param systemId Description of the Parameter
   * @return The xMLObjectMap value
   * @throws SQLException Description of the Exception
   */
  public HashMap getXMLObjectMap(Connection db, int systemId) throws SQLException {
    if (systemObjectMap == null) {
      synchronized (this) {
        if (systemObjectMap == null) {
          systemObjectMap = new SyncTableList();
          systemObjectMap.setBuildTextFields(false);
          try {
            systemObjectMap.buildList(db);
          } catch (SQLException e) {
            e.printStackTrace(System.out);
          }
        }
      }
    }
    return (systemObjectMap.getObjectMapping(systemId));
  }


  /**
   * Retrieves the access type list from the cache
   *
   * @param db       Description of the Parameter
   * @param accessId Description of the Parameter
   * @return The lookupList value
   * @throws SQLException Description of the Exception
   */
  public AccessTypeList getAccessTypeList(Connection db, int accessId) throws SQLException {
    if (!(accessTypes.containsKey(new Integer(accessId)))) {
      synchronized (this) {
        if (!(accessTypes.containsKey(new Integer(accessId)))) {
          accessTypes.put(
              new Integer(accessId), new AccessTypeList(db, accessId));
          if (System.getProperty("DEBUG") != null) {
            System.out.println(
                "SystemStatus --> Added new AccessTypeList object: " + accessId);
          }
        }
      }
    }
    return (AccessTypeList) accessTypes.get(new Integer(accessId));
  }


  /**
   * Gets the tracker attribute of the SystemStatus object
   *
   * @return The tracker value
   */
  public Tracker getTracker() {
    return tracker;
  }


  /**
   * A presentation object (.jsp) can see if a field should be ignored in the
   * output
   *
   * @param thisField Description of Parameter
   * @return Description of the Returned Value
   */
  public boolean hasField(String thisField) {
    Map ignoredFieldsGroup = (Map) preferences.get("system.fields.ignore");
    if (ignoredFieldsGroup != null) {
      return ignoredFieldsGroup.containsKey(thisField);
    }
    return false;
  }


  /**
   * Adds a feature to the ChildUsers attribute of the SystemStatus object Gets
   * the customValidators attribute of the SystemStatus object
   *
   * @return The customValidators value
   */
  public Map getCustomValidators() {
    Map customValidators = (Map) preferences.get("system.fields.customValidator");
    return customValidators;
  }


  /**
   * Adds a feature to the ChildUsers attribute of the SystemStatus object
   *
   * @param thisUser The feature to be added to the ChildUsers attribute
   * @param addFrom  The feature to be added to the ChildUsers attribute
   */
  private void addChildUsers(User thisUser, UserList addFrom) {
    if (thisUser.getShortChildList() == null) {
      thisUser.setChildUsers(new UserList());
    }
    Iterator i = addFrom.iterator();
    while (i.hasNext()) {
      User tmpUser = (User) i.next();
      if (tmpUser.getManagerId() == thisUser.getId()) {
        userList.put(new Integer(tmpUser.getId()), tmpUser);
        addUserToSite(tmpUser);
        thisUser.getShortChildList().add(tmpUser);
        tmpUser.setManagerUser(thisUser);
        this.addChildUsers(tmpUser, addFrom);
      }
    }
  }


  /**
   * Adds a feature to the UserToSite attribute of the SystemStatus object
   *
   * @param thisUser The feature to be added to the UserToSite attribute
   */
  private void addUserToSite(User thisUser) {
    if (thisUser.getSiteId() > -1) {
      String siteUsers = null;
      //SiteUserList is a hashmap where SiteId = comma delimeted list of users
      if (siteUserList.containsKey(new Integer(thisUser.getSiteId()))) {
        siteUsers = (String) siteUserList.get(new Integer(thisUser.getSiteId()));
      } else {
        siteUsers = "";
      }
      if (siteUsers.length() > 0) {
        siteUsers += ",";
      }
      siteUsers += String.valueOf(thisUser.getId());
      siteUserList.put(new Integer(thisUser.getSiteId()), siteUsers);
    }
  }


  /**
   * Activates the object hook manager with the specified objects to see if a
   * business process can execute
   *
   * @param context        Description of the Parameter
   * @param action         Description of the Parameter
   * @param previousObject Description of the Parameter
   * @param object         Description of the Parameter
   * @param sqlDriver      Description of the Parameter
   * @param ce             Description of the Parameter
   */


  /**
   * Activates the specified business process through the object hook manager
   *
   * @param context     Description of the Parameter
   * @param processName Description of the Parameter
   * @param sqlDriver   Description of the Parameter
   * @param ce          Description of the Parameter
   */



  /**
   * Gets the user attribute of the SystemStatus object
   *
   * @param id Description of the Parameter
   * @return The user value
   */
  public User getUser(int id) {
//    while (hierarchyUpdating) {
//    	this.wait(500);
//    }
    return (User) userList.get(new Integer(id));
  }


  /**
   * Method checks the cached role permissions to see if the user has the
   * specified permission.
   *
   * @param userId         Description of the Parameter
   * @param thisPermission Description of the Parameter
   * @return Description of the Return Value
   */
  public boolean hasPermission(int roleId, String thisPermission) {
//    while (permissionUpdating) {
//    }
//    int roleId = this.getUser(userId).getRoleId();
    ArrayList permissions = (ArrayList) rolePermissions.get(
        new Integer(roleId));
    return (permissions != null && permissions.contains(thisPermission));
  }


  public boolean hasPermission(int userId, int roleId, SubmenuItem item, boolean isOfflineMode) {
    if (!hasPermission(roleId, item.getPermission() + (isOfflineMode ? "-offline" : ""))) {
      RoleList roleList = item.getRoleList();
      return (roleList != null && roleList.getRoleNameFromId(roleId) != null);
    } else {
      return true;
    }
  }
 

  /**
   * Returns whether this system has any permissions loaded
   *
   * @return Description of the Return Value
   */
  public boolean hasPermissions() {
    return rolePermissions.size() > 0;
  }


 

  /**
   * Gets the preferences value for this SystemStatus object. If the value is
   * not found, then null is returned.
   *
   * @param section   Description of the Parameter
   * @param parameter Description of the Parameter
   * @return The value value
   */
  public String getValue(String section, String parameter) {
    return getValue(section, parameter, "value");
  }


  /**
   * Gets the value attribute of the SystemStatus object
   *
   * @param section   Description of the Parameter
   * @param parameter Description of the Parameter
   * @param tagName   Description of the Parameter
   * @return The value value
   */
  public String getValue(String section, String parameter, String tagName) {
    Map prefGroup = (Map) preferences.get(section);
    if (prefGroup != null) {
      Node param = (Node) prefGroup.get(parameter);
      if (param != null) {
        return XMLUtils.getNodeText(
            XMLUtils.getFirstChild((Element) param, tagName));
      }
    }
    return null;
  }


  /**
   * Gets the preferences value for this SystemStatus object. If the value is
   * not found, then -1 is returned.
   *
   * @param section   Description of the Parameter
   * @param parameter Description of the Parameter
   * @return The valueAsInt value
   */
  public int getValueAsInt(String section, String parameter) {
    String intValue = this.getValue(section, parameter);
    if (intValue == null) {
      return -1;
    } else {
      return Integer.parseInt(intValue);
    }
  }


  /**
   * Gets the objects attribute of the SystemStatus object
   *
   * @return The objects value
   */
  public HashMap getObjects() {
    return objects;
  }


  /**
   * Sets the objects attribute of the SystemStatus object
   *
   * @param tmp The new objects value
   */
  public void setObjects(HashMap tmp) {
    this.objects = tmp;
  }


  /**
   * Gets the object attribute of the SystemStatus object
   *
   * @param label Description of the Parameter
   * @return The object value
   */
  public Object getObject(String label) {
    return objects.get(label);
  }


  /**
   * Gets the asteriskConnection attribute of the SystemStatus object
   *
   * @return The asteriskConnection value
   */
  public ManagerConnection getAsteriskConnection() {
    return asteriskConnection;
  }


  /**
   * Gets the asteriskListener attribute of the SystemStatus object
   *
   * @return The asteriskListener value
   */
  public AsteriskListener getAsteriskListener() {
    return asteriskListener;
  }


  /**
   * Sets the asteriskListener attribute of the SystemStatus object
   *
   * @param asteriskListener The new asteriskListener value
   */
  public void setAsteriskListener(AsteriskListener asteriskListener) {
    this.asteriskListener = asteriskListener;
  }


  /**
   * Gets the xmppConnection attribute of the SystemStatus object
   *
   * @return The xmppConnection value
   */
  public XMPPConnection getXmppConnection() {
    return xmppConnection;
  }


  /**
   * Returns a comma-delimited list of all users within the specified siteId
   *
   * @param siteId Description of the Parameter
   * @return The siteIdRange value
   */
  public String getSiteIdRange(int siteId) {
    return (String) getSiteUserList().get(new Integer(siteId));
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   */
  public void startServers(ServletContext context) {
    // Monitor Jabber
    if ("true".equals(applicationPrefs.get("XMPP.ENABLED"))) {
      xmppConnection = XMPPManager.verifyConnection(this, applicationPrefs);
    } else {
      XMPPManager.removeConnection(this);
    }
    // Monitor Asterisk
    if ("true".equals(applicationPrefs.get("ASTERISK.OUTBOUND.ENABLED")) ||
        "true".equals(applicationPrefs.get("ASTERISK.INBOUND.ENABLED"))) {
      asteriskConnection = AsteriskManager.verifyConnection(this, applicationPrefs, context);
    } else {
      AsteriskManager.removeConnection(this);
    }
  }


  /**
   * Description of the Method
   */
  public void stopServers() {
    //Unload Asterisk if loaded
    AsteriskManager.removeConnection(this);
    //Unload XMPPConnection
    XMPPManager.removeConnection(this);
  }

  /**
   * Reads the submenu XML config file specified in web.xml.
   *
   * @param context
   */
  private void loadXML(ServletContext context) {
    menu = menu == null ? new LinkedHashMap() : menu;
    properties = properties == null ? new HashMap() : properties;
    try {
      XMLUtils xml = new XMLUtils(context, "/WEB-INF/" + (String) context.getAttribute("ContainerMenuConfig"));
      LinkedList containerList = new LinkedList();
      XMLUtils.getAllChildren(xml.getDocumentElement(), "container", containerList);
      Iterator list = containerList.iterator();
      while (list.hasNext()) {
        Element container = (Element) list.next();
        if (System.getProperty("DEBUG") != null) {
          System.out.println("ContainerMenuHandler-> Container Added: " + container.getAttribute("name"));
        }
        menu.put(container.getAttribute("name"), this.buildMenu(container));
        properties.put(container.getAttribute("name"), this.buildProperties(container));
      }
    } catch (Exception e) {
      LOGGER.error(e, e);
    }
  }

  /**
   * Parses the XML submenu element.
   *
   * @param container Description of Parameter
   * @return Description of the Returned Value
   */
  private LinkedList buildMenu(Element container) {
    LinkedList menuItems = new LinkedList();
    LinkedList menuList = new LinkedList();
    XMLUtils.getAllChildren(container, "submenu", menuList);
    Iterator list = menuList.iterator();
    while (list.hasNext()) {
      Element submenu = (Element) list.next();
      SubmenuItem thisSubmenu = new SubmenuItem();
      thisSubmenu.setName(submenu.getAttribute("name"));
      //check if custom value is defined in preferences
      String containerName = container.getAttribute("name");
      String labelValue = this.getContainerMenuProperty(
          "system.container.menu.label", containerName + "." + submenu.getAttribute(
          "name") + ".long_html");
      thisSubmenu.setLongHtml(
          !"".equals(StringUtils.toString(labelValue)) ? labelValue : (XMLUtils.getFirstChild(
              submenu, "long_html").getAttribute("value")));
      //thisSubmenu.setShortHtml();
      //thisSubmenu.setAlternateName();
      thisSubmenu.setLink(
          XMLUtils.getFirstChild(submenu, "link").getAttribute("value"));
      //thisSubmenu.setHtmlClass();
      thisSubmenu.setPermission(
          XMLUtils.getFirstChild(submenu, "permission").getAttribute("value"));
      //thisSubmenu.setIsActive(true);
      menuItems.add(thisSubmenu);
      if (System.getProperty("DEBUG") != null) {
        System.out.println(
            "ContainerMenuHandler-> Submenu Added: " + thisSubmenu.getLongHtml());
      }
    }
    return menuItems;
  }

  /**
   * Description of the Method
   *
   * @param container Description of the Parameter
   * @return Description of the Return Value
   */
  private HashMap buildProperties(Element container) {
    HashMap propertyList = new HashMap();
    Element properties = XMLUtils.getFirstElement(container, "properties");
    if (properties != null) {
      String icon = XMLUtils.getNodeText(
          XMLUtils.getFirstElement(properties, "icon"));
      if (icon != null) {
        propertyList.put("icon", icon);
      }
      String label = XMLUtils.getNodeText(
          XMLUtils.getFirstElement(properties, "label"));
      if (label != null) {
        propertyList.put("label", label);
      }
    }
    return propertyList;
  }


  /**
   * @param context
   * @param db
   * @throws SQLException
   */
  public void loadTabs(ServletContext context, Connection db) throws SQLException {
    loadXML(context);
  }

  /**
   * @return the menu
   */
  public LinkedHashMap getMenu() {
    return menu;
  }


  /**
   * @param menu the menu to set
   */
  public void setMenu(LinkedHashMap menu) {
    this.menu = menu;
  }


  /**
   * @return the properties
   */
  public HashMap getProperties() {
    return properties;
  }


  /**
   * @param properties the properties to set
   */
  public void setProperties(HashMap properties) {
    this.properties = properties;
  }
}