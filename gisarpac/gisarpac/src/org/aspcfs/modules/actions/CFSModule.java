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
package org.aspcfs.modules.actions;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Locale;
import java.util.TimeZone;
import java.util.logging.Logger;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.controller.ObjectValidator;
import org.aspcfs.controller.RecentItem;
import org.aspcfs.controller.SystemStatus;
import org.aspcfs.controller.UserSession;
import org.aspcfs.modules.admin.base.AccessType;
import org.aspcfs.modules.admin.base.AccessTypeList;
import org.aspcfs.modules.admin.base.Role;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.admin.base.UserList;
import org.aspcfs.modules.beans.ModuleBean;
import org.aspcfs.modules.communications.base.Campaign;
import org.aspcfs.modules.communications.base.CampaignUserGroupMapList;
import org.aspcfs.modules.documents.base.DocumentStore;
import org.aspcfs.modules.documents.base.DocumentStoreTeamMember;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.modules.mycfs.base.Mail;
import org.aspcfs.modules.suap.base.PecMailSender;
import org.aspcfs.modules.util.imports.ApplicationProperties;
import org.aspcfs.utils.DateUtils;
import org.aspcfs.utils.ObjectUtils;
import org.aspcfs.utils.UserUtils;
import org.aspcfs.utils.web.CustomForm;
import org.aspcfs.utils.web.CustomFormList;
import org.aspcfs.utils.web.LookupList;
import org.aspcfs.utils.web.PagedListInfo;
import org.aspcfs.utils.web.ViewpointInfo;

import com.darkhorseventures.database.ConnectionElement;
import com.darkhorseventures.database.ConnectionPool;
import com.darkhorseventures.framework.actions.ActionContext;
import com.zeroio.iteam.base.Project;
import com.zeroio.iteam.base.TeamMember;
//import common.Logger;



/**
 * Base class for all modules
 *
 * @author mrajkowski
 * @version $Id: CFSModule.java,v 1.34.2.2 2002/12/20 22:22:40 mrajkowski Exp
 *          $
 * @created July 15, 2001
 */
public class CFSModule {

	Logger logger = Logger.getLogger("MainLogger");
	public boolean isBacheca = false;
  public final static String fs = System.getProperty("file.separator");
  public final static String NOT_UPDATED_MESSAGE =
      "<b>This record could not be updated because someone else updated it first.</b><p>" +
          "You can hit the back button to review the changes that could not be committed, " +
          "but you must reload the record and make the changes again.";


  private String SUFFISSO_TAB_ACCESSI = "";
  
  public boolean isBacheca() {
	return isBacheca;
}
  
  
  protected String getPref(HttpServletRequest req, String param) {
		ApplicationPrefs prefs = (ApplicationPrefs) req.getServletContext().getAttribute( "applicationPrefs");
		if (prefs != null) {
			return prefs.get(param);
		} else {
			return null;
		}
	}
  
	public  void sendMailIzsm(HttpServletRequest req,String testo,String object,String toDest)
	{

		if(getPref( req,"PORTSERVER")!=null && !"".equals(getPref( req,"PORTSERVER")))
		{
		// initialize the StringBuffer object within the try/catch loop
		StringBuffer sb = new StringBuffer(testo);
		Mail mail = new Mail();
		mail.setHost(getPref( req,"MAILSERVER"));
		mail.setFrom(getPref( req,"EMAILADDRESS"));
		mail.setUser(getPref( req,"EMAILADDRESS"));
		mail.setPass(getPref( req,"MAILPASSWORD"));
		mail.setPort(Integer.parseInt(getPref( req,"PORTSERVER")));
		if (toDest!=null && "".equals(toDest))
			mail.setTo(getPref( req,"EMAILADDRESS"));
		else
			mail.setTo(toDest);
		mail.setSogg(object);
		mail.setTesto(testo);
		mail.sendMail();
		}



	}
	
	public  void sendMailPec(HttpServletRequest req,String testo,String object,String toDest)
	{

		
		String[] toDestArray = toDest.split(";");
		HashMap<String,String> configs = new HashMap<String,String>();
		configs.put("mail.smtp.starttls.enable",ApplicationProperties.getProperty("mail.smtp.starttls.enable"));
		configs.put("mail.smtp.auth", ApplicationProperties.getProperty("mail.smtp.auth"));
		configs.put("mail.smtp.host", ApplicationProperties.getProperty("mail.smtp.host"));
		configs.put("mail.smtp.port", ApplicationProperties.getProperty("mail.smtp.port"));
		configs.put("mail.smtp.ssl.enable",ApplicationProperties.getProperty("mail.smtp.ssl.enable"));
		configs.put("mail.smtp.ssl.protocols", ApplicationProperties.getProperty("mail.smtp.ssl.protocols"));
		configs.put("mail.smtp.socketFactory.class", ApplicationProperties.getProperty("mail.smtp.socketFactory.class"));
		configs.put("mail.smtp.socketFactory.fallback", ApplicationProperties.getProperty("mail.smtp.socketFactory.fallback"));
		
		PecMailSender sender = new PecMailSender(configs,ApplicationProperties.getProperty("username"), ApplicationProperties.getProperty("password"));
		try {
			sender.sendMail(object,testo,ApplicationProperties.getProperty("mail.smtp.from"), toDestArray, null);
		} catch (AddressException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}



	}
  
protected String getSuffiso(ActionContext ctx)
{
  	String suff = (String )ctx.getServletContext().getAttribute("SUFFISSO_TAB_ACCESSI");
  	return suff ;
}
  
public String getParameter (ActionContext context,String campo)
{
	if(context.getRequest().getParameter(campo) != null)
		return context.getRequest().getParameter(campo) ;
	else
		return (String)context.getRequest().getAttribute(campo);
		
}


public void setBacheca(boolean isBacheca) {
	this.isBacheca = isBacheca;
}


/**
   * This is the default call by all actions if a command= paramter is not
   * passed along with the request. Descendant classes should override this
   * method to carry out default behavior that should occur BEFORE the initial
   * JSP page is displayed. This is most useful when the initial page needs to
   * show a list of items that are populated from the database, such as a
   * drop-down list of activity for a client, etc.
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandDefault(ActionContext context) {
    return "DefaultOK";
  }


  /**
   * Gets the PagedListInfo attribute of the CFSModule object
   *
   * @param context  Description of Parameter
   * @param viewName Description of Parameter
   * @return The PagedListInfo value
   * @since 1.1
   */
  protected PagedListInfo getPagedListInfo(ActionContext context, String viewName) {
    return getPagedListInfo(context, viewName, true);
  }


  /**
   * Retrieves the specified PagedList object and creates it if it does not
   * exist<br>
   * Optionally sets parameters from the request based on "setParams" parameter
   *
   * @param context   Description of the Parameter
   * @param viewName  Description of the Parameter
   * @param setParams Description of the Parameter
   * @return The pagedListInfo value
   */
  protected PagedListInfo getPagedListInfo(ActionContext context, String viewName, boolean setParams) {
    PagedListInfo tmpInfo = (PagedListInfo) context.getSession().getAttribute(
        viewName);
    if (tmpInfo == null || tmpInfo.getId() == null) {
      tmpInfo = new PagedListInfo();
      tmpInfo.setId(viewName);
      context.getSession().setAttribute(viewName, tmpInfo);
    }
   
    if (setParams) {
      tmpInfo.setParameters(context);
      
    }
    return tmpInfo;
  }

  protected String getWebContentPath(ActionContext context, String moduleFolderName) {
	    return (context.getServletContext().getRealPath("/") +  moduleFolderName + fs);
	  }

  /**
   * Get the pagedListInfo, if it doesn't already exist then set the default
   * items per page
   *
   * @param context
   * @param viewName
   * @param defaultItemsPerPage
   * @return pagedListInfo value
   */
  protected PagedListInfo getPagedListInfo(ActionContext context, String viewName, int defaultItemsPerPage) {
    PagedListInfo tmpInfo = (PagedListInfo) context.getSession().getAttribute(
        viewName);
    if (tmpInfo == null) {
      tmpInfo = new PagedListInfo();
      tmpInfo.setId(viewName);
      tmpInfo.setItemsPerPage(defaultItemsPerPage);
      context.getSession().setAttribute(viewName, tmpInfo);
    }
    ActionContext actionContext = new ActionContext(
        context.getServlet(), null, null, context.getRequest(), context.getResponse());
    tmpInfo.setParameters(actionContext);
    return tmpInfo;
  }


  /**
   * Returns the ViewpointInfo object setting the required parameters <br>
   * Creates the object and stores it in the session if it's not already in
   * there.
   *
   * @param context  Description of the Parameter
   * @param viewName Description of the Parameter
   * @return The viewpointInfo value
   */
  protected ViewpointInfo getViewpointInfo(ActionContext context, String viewName) {
    SystemStatus systemStatus = this.getSystemStatus(context);
    UserSession thisSession = systemStatus.getSessionManager().getUserSession(
        this.getActualUserId(context));
    ViewpointInfo tmpInfo = (ViewpointInfo) context.getSession().getAttribute(
        viewName);
    //if viewpoints were updated then invalidate the reload ViewpointInfo
    if (!thisSession.isViewpointsValid()) {
      tmpInfo = null;
    }
    if (tmpInfo == null) {
      tmpInfo = new ViewpointInfo();
      tmpInfo.setId(viewName);
      context.getSession().setAttribute(viewName, tmpInfo);
    }
    tmpInfo.setParameters(context);
    return tmpInfo;
  }


  /**
   * Gets the pagedListInfo attribute of the CFSModule object
   *
   * @param context       Description of the Parameter
   * @param viewName      Description of the Parameter
   * @param defaultColumn Description of the Parameter
   * @param defaultOrder  Description of the Parameter
   * @return The pagedListInfo value
   */
  protected PagedListInfo getPagedListInfo(ActionContext context, String viewName, String defaultColumn, String defaultOrder) {
    PagedListInfo tmpInfo = (PagedListInfo) context.getSession().getAttribute(
        viewName);

    if (tmpInfo == null) {
      tmpInfo = new PagedListInfo();
      tmpInfo.setId(viewName);
      tmpInfo.setColumnToSortBy(defaultColumn);
      tmpInfo.setSortOrder(defaultOrder);
      context.getSession().setAttribute(viewName, tmpInfo);
    }
    tmpInfo.setParameters(context);
    return tmpInfo;
  }


  /**
   * Retrieves a connection from the connection pool
   *
   * @param context Description of Parameter
   * @return The Connection value
   * @throws SQLException Description of Exception
   * @since 1.1
   */
  protected Connection getConnection(ActionContext context) throws SQLException {
    ConnectionElement ce = (ConnectionElement) context.getSession().getAttribute(
        "ConnectionElement");
    ConnectionPool sqlDriver = null;
    String browser = "";
    UserBean u = (UserBean)context.getSession().getAttribute("User");
    if (u.getBrowserId().equalsIgnoreCase("moz"))
    	browser = "Firefox";
    
    if (browser.contains("Firefox")){
    	sqlDriver = (ConnectionPool) context.getServletContext().getAttribute("ConnectionPool");
    } else {
    
    	
    	String contesto = (String)context.getServletContext().getAttribute("SUFFISSO_TAB_ACCESSI");
    	UserBean user = (UserBean) context.getSession().getAttribute("User");
    	
		if (contesto!=null && contesto.equals("_ext") && user.getRoleId()==10000003)
		{
			sqlDriver = (ConnectionPool) context.getServletContext().getAttribute("ConnectionPool");

		}
		else
			sqlDriver = (ConnectionPool) context.getServletContext().getAttribute("ConnectionPoolRO");
    }
    Connection db = sqlDriver.getConnection(ce,context);    
    return db;
  }
  
  
  protected Connection getConnectionBdu(ActionContext context) throws SQLException {
	    ConnectionElement ce = (ConnectionElement) context.getSession().getAttribute(
	        "ConnectionElement");
	    ConnectionPool sqlDriver = (ConnectionPool) context.getServletContext().getAttribute(
	            "ConnectionPoolBdu");
	        Connection db = sqlDriver.getConnection(ce,context);
	        
	        return db;
	  }
  

  


  /**
   * Gets the UserId attribute of the CFSModule object
   *
   * @param context Description of Parameter
   * @return The UserId value
   * @since 1.7
   */
  public int getUserId(ActionContext context) {
    return UserUtils.getUserId(context.getRequest());
  }


  /**
   * Gets the actualUserId attribute of the CFSModule object
   *
   * @param context Description of the Parameter
   * @return The actualUserId value
   */
  protected int getActualUserId(ActionContext context) {
    return ((UserBean) context.getSession().getAttribute("User")).getActualUserId();
  }


  /**
   * Gets the UserRange attribute of the CFSModule object
   *
   * @param context Description of Parameter
   * @return The UserRange value
   */
  protected String getUserRange(ActionContext context) {
    return UserUtils.getUserIdRange(context.getRequest());
  }


  /**
   * Gets the userSiteId attribute of the CFSModule object
   *
   * @param context Description of the Parameter
   * @return The userSiteId value
   */
  protected int getUserSiteId(ActionContext context) {
    return UserUtils.getUserSiteId(context.getRequest());
  }


  /**
   * Gets the comma-delimited list of users for the specified siteId
   *
   * @param context Description of the Parameter
   * @param siteId  Description of the Parameter
   * @return The siteUserRange value
   */
  protected String getSiteUserRange(ActionContext context, int siteId) {
    return getSystemStatus(context).getSiteIdRange(siteId);
  }


  /**
   * Gets the userRange attribute of the CFSModule object
   *
   * @param context Description of the Parameter
   * @param userId  Description of the Parameter
   * @return The userRange value
   */
  protected String getUserRange(ActionContext context, int userId) {
    User userRecord = this.getUser(context, userId);
    UserList shortChildList = userRecord.getShortChildList();
    UserList fullChildList = userRecord.getFullChildList(
        shortChildList, new UserList());
    return fullChildList.getUserListIds(userRecord.getId());
  }


  /**
   * Gets the NameLast attribute of the CFSModule object
   *
   * @param context Description of Parameter
   * @return The NameLast value
   */
  protected String getNameLast(ActionContext context) {
    return ((UserBean) context.getSession().getAttribute("User")).getUserRecord().getContact().getNameLast();
  }


  /**
   * Gets the NameFirst attribute of the CFSModule object
   *
   * @param context Description of Parameter
   * @return The NameFirst value
   */
  protected String getNameFirst(ActionContext context) {
    return ((UserBean) context.getSession().getAttribute("User")).getUserRecord().getContact().getNameFirst();
  }


  /**
   * Gets the systemStatus attribute of the CFSModule object
   *
   * @param context Description of the Parameter
   * @return The systemStatus value
   */
  protected SystemStatus getSystemStatus(ActionContext context) {
    ConnectionElement ce = (ConnectionElement) context.getSession().getAttribute(
        "ConnectionElement");
    return this.getSystemStatus(context, ce);
  }


  /**
   * Gets the systemStatus attribute of the CFSModule object
   *
   * @param context Description of the Parameter
   * @param ce      Description of the Parameter
   * @return The systemStatus value
   */
  protected SystemStatus getSystemStatus(ActionContext context, ConnectionElement ce) {
    if (ce != null) {
      return (SystemStatus) ((Hashtable) context.getServletContext().getAttribute(
          "SystemStatus")).get(ce.getUrl());
    } else {
     
      return null;
    }
  }
  
  protected SystemStatus getSystemStatus(ActionContext context, ConnectionElement ce, Hashtable systemStatus) {
	    if (ce != null) {
	      return (SystemStatus) (systemStatus).get(ce.getUrl());
	    } else {
	     
	      return null;
	    }
	  }



  /**
   * Gets the User attribute of the CFSModule object
   *
   * @param context Description of Parameter
   * @param userId  Description of Parameter
   * @return The User value
   */
  public User getUser(ActionContext context, int userId) {
    ConnectionElement ce = (ConnectionElement) context.getSession().getAttribute(
        "ConnectionElement");
    SystemStatus systemStatus = (SystemStatus) ((Hashtable) context.getServletContext().getAttribute(
        "SystemStatus")).get(ce.getUrl());
    return systemStatus.getUser(userId);
  }


  /**
   * Gets the userTable attribute of the CFSModule object
   *
   * @param context Description of the Parameter
   * @return The userTable value
   */
  protected Hashtable getUserTable(ActionContext context) {
    ConnectionElement ce = (ConnectionElement) context.getSession().getAttribute(
        "ConnectionElement");
    SystemStatus systemStatus = (SystemStatus) ((Hashtable) context.getServletContext().getAttribute(
        "SystemStatus")).get(ce.getUrl());
    return systemStatus.getUserList();
  }


  /**
   * Description of the Method
   *
   * @param context    Description of the Parameter
   * @param permission Description of the Parameter
   * @return Description of the Return Value
   */
  protected boolean hasPermission(ActionContext context, String permission) {
	  String ambiente = (String) context.getServletContext().getAttribute("ambiente");
	  String browser = "";
	  UserBean u = (UserBean)context.getSession().getAttribute("User");
	  if (u.getBrowserId().equalsIgnoreCase("moz"))
	    		browser = "Firefox";
	  	  
	  if ( (ambiente.equals("SLAVE") && (permission.endsWith("add") || permission.endsWith("edit") || permission.endsWith("delete"))) || 
		 ( !browser.contains("Firefox") && (permission.endsWith("add") || permission.endsWith("edit") || permission.endsWith("delete"))) ){
		  return false;
	  }
	  else{
		  UserBean thisUser = (UserBean) context.getSession().getAttribute("User");
		  SystemStatus systemStatus = this.getSystemStatus(context);
		  boolean esito = (systemStatus.hasPermission(thisUser.getRoleId(), permission));
		  if (!esito)
			  context.getRequest().setAttribute("permissionMancante", permission);
		  return esito;
	  }
  }
  
  
  protected boolean hasPermission(ActionContext context, String permission, String ambiente,UserBean u,Hashtable systemStatusHash,ConnectionElement ce) {
	  String browser = "";
	  if (u.getBrowserId().equalsIgnoreCase("moz"))
	    		browser = "Firefox";
	  	  
	  if ( (ambiente.equals("SLAVE") && (permission.endsWith("add") || permission.endsWith("edit") || permission.endsWith("delete"))) || 
		 ( !browser.contains("Firefox") && (permission.endsWith("add") || permission.endsWith("edit") || permission.endsWith("delete"))) ){
		  return false;
	  }
	  else{
		  UserBean thisUser = u;
		  SystemStatus systemStatus = this.getSystemStatus(context, ce, systemStatusHash);
		  boolean esito = (systemStatus.hasPermission(thisUser.getRoleId(), permission));
		  if (!esito)
			  context.getRequest().setAttribute("permissionMancante", permission);
		  return esito;
	  }
  }


  /**
   * Description of the Method
   *
   * @param sourceFile Description of the Parameter
   * @return Description of the Return Value
   */
  public static String includeFile(String sourceFile) {
    StringBuffer HTMLBuffer = new StringBuffer();
    int c;
    FileReader in;
    try {
      File inputFile = new File(sourceFile);
      in = new FileReader(inputFile);
      while ((c = in.read()) != -1) {
        HTMLBuffer.append((char) c);
      }
      in.close();
    } catch (IOException ex) {
      HTMLBuffer.append(ex.toString());
    }
    return HTMLBuffer.toString();
  }


  /**
   * Gets the DbName attribute of the CFSModule object
   *
   * @param context Description of Parameter
   * @return The DbName value
   */
  public static String getDbName(ActionContext context) {
    ConnectionElement ce = (ConnectionElement) context.getSession().getAttribute(
        "ConnectionElement");
    if (ce != null) {
      return ce.getDbName();
    } else {
      return null;
    }
  }


  /**
   * Gets the dbName attribute of the CFSModule class
   *
   * @param ce Description of the Parameter
   * @return The dbName value
   */
  public static String getDbName(ConnectionElement ce) {
    if (ce != null) {
      return ce.getDbName();
    } else {
      return null;
    }
  }


  /**
   * Gets the Path attribute of the CFSModule object
   *
   * @param context Description of Parameter
   * @return The Path value
   */
  protected String getPath(ActionContext context) {
    ApplicationPrefs prefs = (ApplicationPrefs) context.getServletContext().getAttribute(
        "applicationPrefs");
    return prefs.get("FILELIBRARY");
  }


  /**
   * Gets the path attribute of the CFSModule object
   *
   * @param context          Description of the Parameter
   * @param moduleFolderName Description of the Parameter
   * @return The path value
   */
  protected String getPath(ActionContext context, String moduleFolderName) {
    ApplicationPrefs prefs = (ApplicationPrefs) context.getServletContext().getAttribute(
        "applicationPrefs");
    return (prefs.get("FILELIBRARY") +
        (getDbName(context) == null ? "" : getDbName(context) + fs) +
        (moduleFolderName == null ? "" : moduleFolderName + fs));
  }


  /**
   * Gets the path attribute of the CFSModule object
   *
   * @param context          Description of the Parameter
   * @param ce               Description of the Parameter
   * @param moduleFolderName Description of the Parameter
   * @return The path value
   */
  protected String getPath(ActionContext context, ConnectionElement ce, String moduleFolderName) {
    ApplicationPrefs prefs = (ApplicationPrefs) context.getServletContext().getAttribute(
        "applicationPrefs");
    return (prefs.get("FILELIBRARY") +
        (getDbName(ce) == null ? "" : getDbName(ce) + fs) +
        moduleFolderName + fs);
  }


  /**
   * Gets the dbNamePath attribute of the CFSModule class
   *
   * @param context Description of the Parameter
   * @return The dbNamePath value
   */
  public static String getDbNamePath(ActionContext context) {
    ApplicationPrefs prefs = (ApplicationPrefs) context.getServletContext().getAttribute(
        "applicationPrefs");
    return (prefs.get("FILELIBRARY") + getDbName(context) + fs);
  }


  /**
   * Gets the datePath attribute of the CFSModule class
   *
   * @param fileDate Description of the Parameter
   * @return The datePath value
   */
  public static String getDatePath(java.util.Date fileDate) {
    return DateUtils.getDatePath(fileDate);
  }


  /**
   * Gets the DatePath attribute of the CFSModule object
   *
   * @param fileDate Description of Parameter
   * @return The DatePath value
   */
  public static String getDatePath(java.sql.Timestamp fileDate) {
    return DateUtils.getDatePath(fileDate);
  }


  /**
   * Gets the datePath attribute of the CFSModule class
   *
   * @param filenameDate Description of the Parameter
   * @return The datePath value
   */
  public static String getDatePath(String filenameDate) {
    if (filenameDate.length() > 7) {
      return (filenameDate.substring(0, 4) + fs +
          filenameDate.substring(4, 8) + fs);
    } else {
      return null;
    }
  }


  /**
   * Gets the User's TimeZone
   *
   * @param context Description of the Parameter
   * @return The userTimeZone value
   */
  public TimeZone getUserTimeZone(ActionContext context) {
    TimeZone timeZone = Calendar.getInstance().getTimeZone();
    User thisUser = this.getUser(context, this.getUserId(context));
    String tZone = thisUser.getTimeZone();
    if (tZone != null && !"".equals(tZone)) {
      timeZone = TimeZone.getTimeZone(tZone);
    }
    return timeZone;
  }


  /**
   * Gets the WEB-INF path and appends the specified directory name
   *
   * @param context          Description of the Parameter
   * @param moduleFolderName Description of the Parameter
   * @return The webInfPath value
   */
  protected String getWebInfPath(ActionContext context, String moduleFolderName) {
	  if(context.getRequest().getLocalAddr() != null && context.getRequest().getLocalAddr().equals("10.1.15.9") ){
		  if(moduleFolderName.equals("reports") || moduleFolderName.equals("template_report")){
			  moduleFolderName = moduleFolderName + "_demo";
		  }
	  }
	 String toRet = context.getServletContext().getRealPath("/") + "WEB-INF" + fs + moduleFolderName + fs;
	 File pathFile = new File(toRet);
	 if(!pathFile.exists())
	 {
		 pathFile.mkdirs();
	 }
  	 return toRet;
  }


  /**
   * Removes an object from the session
   *
   * @param context  Description of Parameter
   * @param viewName Description of Parameter
   * @since 1.6
   */
  protected void deletePagedListInfo(ActionContext context, String viewName) {
    PagedListInfo tmpInfo = (PagedListInfo) context.getSession().getAttribute(
        viewName);
    if (tmpInfo != null) {
      context.getSession().removeAttribute(viewName);
    }
  }


  /**
   * Returns a connection back to the connection pool
   *
   * @param context Description of Parameter
   * @param db      Description of Parameter
   * @since 1.1
   */
  
  protected void freeConnection(ActionContext context, Connection db) {
	    if (db != null) {
	      ConnectionPool sqlDriver = (ConnectionPool) context.getServletContext().getAttribute(
	          "ConnectionPool");
	      sqlDriver.free(db,context);
	     
	    }
	    db = null;
  }
  
  protected void freeConnection(Connection db, ConnectionElement ce,  UserBean u, ConnectionPool cp, String contesto, ConnectionPool cpRo,HttpSession session, ApplicationPrefs prefs, ActionContext context, Object systemStatus, String command, String actionName, String actionClassName, String remoteAddr,String browser ) {
	    if (db != null) {
	      ConnectionPool sqlDriver = cp;
	      sqlDriver.free(db, ce, session, u, prefs, context, browser, systemStatus, command, actionName, actionClassName, remoteAddr);
	     
	    }
	    db = null;
}
  
  protected void freeConnectionBdu(ActionContext context, Connection db) {
	    if (db != null) {
	      ConnectionPool sqlDriver = (ConnectionPool) context.getServletContext().getAttribute(
	          "ConnectionPoolBdu");
	      sqlDriver.free(db,context);
	     
	    }
	    db = null;
}
  

  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @param db      Description of the Parameter
   */
  protected void renewConnection(ActionContext context, Connection db) {
    //Connections are usually checked out and expire, this will renew the expiration
    //time
    if (db != null) {
      ConnectionPool sqlDriver = (ConnectionPool) context.getServletContext().getAttribute(
          "ConnectionPool");
      sqlDriver.renew(db);
    }
  }


  /**
   * This method adds module specific information to the request.
   *
   * @param context    The feature to be added to the ModuleMenu attribute
   * @param actionName The feature to be added to the ModuleMenu attribute
   * @param submenuKey The feature to be added to the ModuleBean attribute
   * @since 1.4
   */
  protected void addModuleBean(ActionContext context, String submenuKey, String actionName) {
    ModuleBean thisModule = new ModuleBean();
    thisModule.setCurrentAction(actionName);
    thisModule.setSubmenuKey(context, submenuKey);
    context.getRequest().setAttribute("ModuleBean", thisModule);
  }


  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @param errors  Description of Parameter
   * @since 1.7
   */
  protected void processErrors(ActionContext context, HashMap errors) {
    Iterator i = errors.keySet().iterator();
    while (i.hasNext()) {
      String errorKey = (String) i.next();
      String errorMsg = (String) errors.get(errorKey);
      context.getRequest().setAttribute(errorKey, errorMsg);
    
    }
    context.getRequest().setAttribute("errors", errors);
    if (errors.size() > 0) {
      if (context.getRequest().getAttribute("actionError") == null) {
        SystemStatus systemStatus = this.getSystemStatus(context);
        if (systemStatus != null) {
          context.getRequest().setAttribute(
              "actionError", systemStatus.getLabel(
              "object.validation.genericActionError"));
        } else {
          ApplicationPrefs prefs = (ApplicationPrefs) context.getServletContext().getAttribute(
              "applicationPrefs");
          if (prefs != null) {
            context.getRequest().setAttribute(
                "actionError", prefs.getLabel(
                "object.validation.genericActionError", prefs.get("SYSTEM.LANGUAGE")));
          }
        }
      }
    }
  }


  /**
   * Description of the Method
   *
   * @param context  Description of the Parameter
   * @param warnings Description of the Parameter
   */
  protected void processWarnings(ActionContext context, HashMap warnings) {
    Iterator i = warnings.keySet().iterator();
    while (i.hasNext()) {
      String warningKey = (String) i.next();
      String warningMsg = (String) warnings.get(warningKey);
      context.getRequest().setAttribute(warningKey, warningMsg);
      if (System.getProperty("DEBUG") != null) {
        System.out.println(
            " Object Validation Warning-> " + warningKey + "=" + warningMsg);
      }
    }
    context.getRequest().setAttribute("warnings", warnings);
    if (warnings.size() > 0) {
      if (context.getRequest().getAttribute("actionWarning") == null) {
        SystemStatus systemStatus = this.getSystemStatus(context);
        if (systemStatus != null) {
          context.getRequest().setAttribute(
              "actionWarning", systemStatus.getLabel(
              "object.validation.actionWarning.warning"));
        } else {
          ApplicationPrefs prefs = (ApplicationPrefs) context.getServletContext().getAttribute(
              "applicationPrefs");
          if (prefs != null) {
            context.getRequest().setAttribute(
                "actionWarning", prefs.getLabel(
                "object.validation.actionWarning.warning", prefs.get("SYSTEM.LANGUAGE")));
          }
        }
      }
    }
  }


  /**
   * Call whenever any module modifies anything to do with permissions, for
   * example, if a role's permissions are modified.
   *
   * @param context Description of Parameter
   * @param db      Description of the Parameter
   * @throws SQLException Description of the Exception
   */
  protected void updateSystemPermissionCheck(Connection db, ActionContext context) throws SQLException {
    ConnectionElement ce = (ConnectionElement) context.getSession().getAttribute(
        "ConnectionElement");
    SystemStatus systemStatus = (SystemStatus) ((Hashtable) context.getServletContext().getAttribute(
        "SystemStatus")).get(ce.getUrl());
    systemStatus.updateRolePermissions(db,this.getSuffiso(context));
  }


  /**
   * Call whenever any module modifies anything to do with user's data, for
   * example, if a user record is updated, or a user's contact info is updated.
   * TODO: Add a method for updating just the user's contact info and not the
   * whole hierarchy.
   *
   * @param db      Description of Parameter
   * @param context Description of Parameter
   * @throws SQLException Description of Exception
   */
  protected void updateSystemHierarchyCheck(Connection db, ActionContext context) throws SQLException {
    ConnectionElement ce = (ConnectionElement) context.getSession().getAttribute(
        "ConnectionElement");
    SystemStatus systemStatus = (SystemStatus) ((Hashtable) context.getServletContext().getAttribute(
        "SystemStatus")).get(ce.getUrl());
    systemStatus.updateHierarchy(db,context.getServletContext());
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @param userId  Description of the Parameter
   */
  protected void invalidateUserData(ActionContext context, int userId) {
  
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @param userId  Description of the Parameter
   */
  protected void invalidateUserRevenueData(ActionContext context, int userId) {
   
  }


  /**
   * Description of the Method
   *
   * @param userId  Description of Parameter
   * @param context Description of Parameter
   */
  protected void invalidateUserInMemory(int userId, ActionContext context) {
    UserList shortChildList = new UserList();
    UserList fullChildList = new UserList();
    SystemStatus thisStatus = getSystemStatus(context);
    UserList thisList = thisStatus.getHierarchyList();
    Iterator j = thisList.iterator();
    while (j.hasNext()) {
      User thisUser = (User) j.next();
      shortChildList = thisUser.getShortChildList();
      fullChildList = thisUser.getFullChildList(
          shortChildList, new UserList());
      Iterator k = fullChildList.iterator();
      while (k.hasNext()) {
        User indUser = (User) k.next();
        if (indUser.getId() == userId) {
          indUser.setIsValid(false, true);
          indUser.setIsValidLead(false, true);
          if (System.getProperty("DEBUG") != null) {
            System.out.println(
                "CFSModule-> invalidateUserInMemory: " + indUser.getId());
          }
        }
      }
    }
  }





 


  /**
   * Builds and adds a RecentItem to the RecentItems list
   *
   * @param context    The feature to be added to the RecentItem attribute
   * @param itemObject The feature to be added to the RecentItem attribute
   */
  protected void addRecentItem(ActionContext context, Object itemObject) {
    
  }


  /**
   * Gets the recentItem attribute of the CFSModule object
   *
   * @param itemObject Description of the Parameter
   * @param context    Description of the Parameter
   * @return The recentItem value
   */
  public RecentItem getRecentItem(ActionContext context, Object itemObject) {
    //Build the recent item object
    RecentItem thisItem = null;
    
    return thisItem;
  }


  /**
   * Description of the Method
   *
   * @param text     Description of the Parameter
   * @param filename Description of the Parameter
   * @throws java.io.IOException Description of the Exception
   */
  public static void saveTextFile(String text, String filename) throws java.io.IOException {
    File outputFile = new File(filename);
    FileWriter out = new FileWriter(outputFile);
    out.write(text);
    out.close();
  }


  /**
   * Gets the dynamicForm attribute of the CFSModule object
   *
   * @param context  Description of the Parameter
   * @param formName Description of the Parameter
   * @return The dynamicForm value
   */
  public CustomForm getDynamicForm(ActionContext context, String formName) {
    CustomForm thisForm = new CustomForm();
    if (((CustomFormList) context.getServletContext().getAttribute(
        "DynamicFormList")).containsKey(formName)) {
      thisForm = (CustomForm) (((CustomForm) ((CustomFormList) context.getServletContext().getAttribute(
          "DynamicFormList")).get(formName)).clone());
    }
    return thisForm;
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @param object  Description of the Parameter
   */
  protected void processInsertHook(ActionContext context, Object object) {
    ConnectionPool sqlDriver = (ConnectionPool) context.getServletContext().getAttribute(
        "ConnectionPool");
    ConnectionElement ce = (ConnectionElement) context.getSession().getAttribute(
        "ConnectionElement");
   
  }


  /**
   * Description of the Method
   *
   * @param context        Description of the Parameter
   * @param previousObject Description of the Parameter
   * @param object         Description of the Parameter
   */
  protected void processUpdateHook(ActionContext context, Object previousObject, Object object) {
   

  }


  /**
   * Description of the Method
   *
   * @param context        Description of the Parameter
   * @param previousObject Description of the Parameter
   */
  protected void processDeleteHook(ActionContext context, Object previousObject) {
   
  }


  /**
   * Checks that ownerId is the current user or in the current user's
   * hierarchy.
   *
   * @param context Description of the Parameter
   * @param ownerId Description of the Parameter
   * @return Description of the Return Value
   */
  protected boolean hasAuthority(ActionContext context, int ownerId) {
    int userId = this.getUserId(context);
    if (userId == ownerId) {
      return true;
    }
    User userRecord = this.getUser(context, userId);
    User childRecord = userRecord.getChild(ownerId);
    return (childRecord != null);
  }


  /**
   * Description of the Method
   *
   * @param db         Description of the Parameter
   * @param campaignId Description of the Parameter
   * @param userId     Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  protected boolean hasCampaignUserGroupAccess(Connection db, int campaignId, int userId) throws SQLException {
    if (campaignId <= 0) {
      return false;
    }
    CampaignUserGroupMapList mapList = new CampaignUserGroupMapList();
    mapList.setCampaignId(campaignId);
    mapList.buildList(db);
    if (mapList.size() > 0) {
      User user = new User(db, userId);
      return mapList.checkUserAccess(db, userId, user.getSiteId());
    }
    return false;
  }


  /**
   * Description of the Method
   *
   * @param context  Description of the Parameter
   * @param db       Description of the Parameter
   * @param campaign Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  protected boolean hasCampaignUserGroupAccess(ActionContext context, Connection db, Campaign campaign) throws SQLException {
    int userId = this.getUserId(context);
    int siteId = this.getUserSiteId(context);
    return campaign.getUserGroupMaps().checkUserAccess(db, userId, siteId);
  }


  /**
   * Description of the Method
   *
   * @param context  Description of the Parameter
   * @param permName Description of the Parameter
   * @param owner    Description of the Parameter
   * @param vpUser   Description of the Parameter
   * @param db       Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public boolean hasViewpointAuthority(Connection db, ActionContext context, String permName, int owner, int vpUser) throws SQLException {
    //check if user has authority
    if (hasAuthority(context, owner) || (vpUser == owner)) {
      return true;
    }
    SystemStatus systemStatus = this.getSystemStatus(context);
    UserSession thisSession = systemStatus.getSessionManager().getUserSession(
        getActualUserId(context));
    HashMap viewpoints = thisSession.getViewpoints(
        db, permName, this.getUserId(context));
    ArrayList vpUsers = null;
    if (viewpoints.get(permName) != null) {
      vpUsers = (ArrayList) viewpoints.get(permName);
      Iterator i = vpUsers.iterator();
      while (i.hasNext()) {
        int user = ((Integer) i.next()).intValue();
        if (vpUser == user) {
          User userRecord = this.getUser(context, user);
          User childRecord = userRecord.getChild(owner);
          if (childRecord != null) {
            return true;
          }
        }
      }
    }
    return false;
  }


  /**
   * Description of the Method
   *
   * @param db      Description of the Parameter
   * @param context Description of the Parameter
   * @param thisElt Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public boolean hasAuthority(Connection db, ActionContext context, Object thisElt) throws SQLException {
    try {

      //get all the access types possible for this type of a record
      AccessTypeList accessList = this.getSystemStatus(context).getAccessTypeList(
          db, AccessType.getLinkModuleId(thisElt));

      //get the access type associated with this record
      Method method = thisElt.getClass().getMethod(
          "getAccessTypeString", (java.lang.Class[]) null);
      Object result = method.invoke(thisElt, (java.lang.Object[]) null);
      int accessType = Integer.parseInt((String) result);

      //check if record is public
      if (accessList.getCode(AccessType.PUBLIC) == accessType) {
        return true;
      }

      //get the owner
      method = thisElt.getClass().getMethod(
          "getOwnerString", (java.lang.Class[]) null);
      result = method.invoke(thisElt, (java.lang.Object[]) null);
      int owner = Integer.parseInt((String) result);

      //check if user has authority by virtue of the hierarchy
      if (!hasAuthority(context, owner)) {
        return false;
      }

      //make sure that it is not personal although record is owned by someone in the hierarchy
      if (accessList.getCode(AccessType.PERSONAL) == accessType && owner != this.getUserId(
          context)) {
        return false;
      }
    } catch (Exception e) {
      System.out.println("hasAuthority - > Error: " + e.getMessage());
    }
    return true;
  }


  /**
   * Adds a feature to the Viewpoints attribute of the CFSModule object
   *
   * @param context  The feature to be added to the Viewpoints attribute
   * @param permName The feature to be added to the Viewpoints attribute
   * @param db       The feature to be added to the Viewpoints attribute
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public UserList addViewpoints(Connection db, ActionContext context, String permName) throws SQLException {
    UserList userList = new UserList();
    userList.add(this.getUser(context, this.getUserId(context)));
    SystemStatus systemStatus = this.getSystemStatus(context);
    UserSession thisSession = systemStatus.getSessionManager().getUserSession(
        this.getActualUserId(context));
    HashMap viewpoints = thisSession.getViewpoints(
        db, permName, this.getUserId(context));
    ArrayList vpUsers = null;
    if (viewpoints.get(permName) != null) {
      vpUsers = (ArrayList) viewpoints.get(permName);
      Iterator i = vpUsers.iterator();
      while (i.hasNext()) {
        int userId = ((Integer) i.next()).intValue();
        User thisUser = new User();
        thisUser.setBuildContact(true);
        thisUser.setBuildContactDetails(false);
        userList.add(thisUser);
      }
    }
    userList = UserList.sortEnabledUsers(userList, new UserList());
    context.getRequest().setAttribute("Viewpoints", userList);
    return userList;
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   */
  public void invalidateViewpoints(ActionContext context) {
    SystemStatus systemStatus = this.getSystemStatus(context);
    UserSession thisSession = systemStatus.getSessionManager().getUserSession(
        this.getActualUserId(context));
    thisSession.invalidateViewpoints();
  }



  


  /**
   * Gets the return attribute of the CFSModule object
   *
   * @param context      Description of the Parameter
   * @param returnString Description of the Parameter
   * @return The return value
   */
  protected static String getReturn(ActionContext context, String returnString) {
		UserBean thisUser = (UserBean) context.getSession().getAttribute("User");

		if (thisUser.getRoleId()==Role.RUOLO_TRASPORTATORI_DISTRIBUTORI)
			returnString= returnString+"trasdist";
    boolean popup = "true".equals(context.getRequest().getParameter("popup"));
    context.getRequest().setAttribute("PopUp", context.getRequest().getParameter("popup"));
    if (popup) {
    	
      return (returnString += "PopupOK");
    }
    
   
    return (returnString+"" + "OK");
  }
  
  protected static String getReturnLp(ActionContext context, String returnString) {
	    boolean popup = "true".equals(context.getRequest().getParameter("popup"));
	    context.getRequest().setAttribute("PopUp", context.getRequest().getParameter("popup"));
	    if (popup) {
	    	
	      return (returnString += "LpPopupOK");
	    }
	    return (returnString+"" + "LpOK");
	  }

  
  

  /**
   * Gets the specified preference from the loaded applicationPrefs
   *
   * @param context Description of the Parameter
   * @param param   Description of the Parameter
   * @return The pref value
   */
  protected static String getPref(ActionContext context, String param) {
    ApplicationPrefs prefs = (ApplicationPrefs) context.getServletContext().getAttribute(
        "applicationPrefs");
    if (prefs != null) {
      return prefs.get(param);
    } else {
      return null;
    }
  }


  

  /**
   * Gets the parameter value for the specified system preference
   *
   * @param context    Description of the Parameter
   * @param configName Description of the Parameter
   * @param param      Description of the Parameter
   * @return The systemPref value
   */
  protected String getSystemPref(ActionContext context, String configName, String param) {
    SystemStatus systemStatus = this.getSystemStatus(context);
    return systemStatus.getValue(configName, param);
  }


  /**
   * Gets the recordAccessPermitted attribute of the CFSModule class
   *
   * @param context  Description of the Parameter
   * @param tmpOrgId Description of the Parameter
   * @param db       Description of the Parameter
   * @return The recordAccessPermitted value
   * @throws SQLException Description of the Exception
   */
  protected static boolean isRecordAccessPermitted(ActionContext context, Connection db, int tmpOrgId) throws SQLException {
//    if (isPortalUser(context)) {
//      if (tmpOrgId == getPortalUserPermittedOrgId(context)) {
//        return true;
//      } else {
//        return false;
//      }
//    } else {
//    
//      if ((UserUtils.getUserSiteId(context.getRequest())) != -1) {
//        int orgSiteId = Organization.getOrganizationSiteId(db, tmpOrgId);
//        int opugSiteId = Organization.getOpuSiteId(db, tmpOrgId);
//        if(orgSiteId!=16)
//        {
//        	if (orgSiteId == UserUtils.getUserSiteId(context.getRequest())) {
//          return true;
//        } else {
//          return false;
//        }}else
//        	return true;
//      } else {
//        // has permission to view records of all sites
//        return true;
//      }
//    }
	  return true ;
  }
  
  
  protected static boolean isRecordAccessPermittedOpu(ActionContext context, Connection db, int tmpOrgId) throws SQLException {
//	    if (isPortalUser(context)) {
//	      if (tmpOrgId == getPortalUserPermittedOrgId(context)) {
//	        return true;
//	      } else {
//	        return false;
//	      }
//	    } else {
//	    
//	      if ((UserUtils.getUserSiteId(context.getRequest())) != -1) {
//	        int orgSiteId = Organization.getOpuSiteId(db, tmpOrgId);
//	        if(orgSiteId!=16)
//	        {
//	        	if (orgSiteId == UserUtils.getUserSiteId(context.getRequest())) {
//	          return true;
//	        } else {
//	          return false;
//	        }}else
//	        	return true;
//	      } else {
//	        // has permission to view records of all sites
//	        return true;
//	      }
//	    }	 
	  return true ;
  }



  /**
   * Gets the recordAccessPermitted attribute of the CFSModule class
   *
   * @param context Description of the Parameter
   * @param object  Description of the Parameter
   * @return The recordAccessPermitted value
   * @throws Exception Description of the Exception
   */
  protected static boolean isRecordAccessPermitted(ActionContext context, Object object) throws Exception {
    int tmpUserSiteId = UserUtils.getUserSiteId(context.getRequest());
    if (tmpUserSiteId != -1) {

      Method method = object.getClass().getMethod(
          "getSiteId", (java.lang.Class[]) null);
      Object result = method.invoke(object, (java.lang.Object[]) null);
      int tmpObjectSiteId = ((Integer) result).intValue();

      if (tmpObjectSiteId == tmpUserSiteId) {
        return true;
      } else {
        return false;
      }
    } else {
      // has permission to view records of all sites
      return true;
    }
  }


  /**
   * Gets the recordAccessPermitted attribute of the CFSModule class
   *
   * @param context Description of the Parameter
   * @param siteId  Description of the Parameter
   * @return The recordAccessPermitted value
   */
  protected static boolean isSiteAccessPermitted(ActionContext context, String siteId) {
    int tmpUserSiteId = UserUtils.getUserSiteId(context.getRequest());
    if (siteId != null && !"".equals(siteId)) {
      if (tmpUserSiteId != -1 && tmpUserSiteId != Integer.parseInt(siteId)) {
        return false;
      }
    }
    return true;
  }


  /**
   * returns true if the logged in user is a portal user, false otherwise
   *
   * @param context Description of the Parameter
   * @return The portalUser value
   */
  protected static boolean isPortalUser(ActionContext context) {
    if (UserUtils.getUserRoleType(context.getRequest()) > 0) {
      return true;
    }
    return false;
  }


  /**
   * returns the orgId of the portal user, the portal user is allowed only to
   * view the information only of this organization
   *
   * @param context Description of the Parameter
   * @return The portalUserPermittedOrgId value
   */
  protected static int getPortalUserPermittedOrgId(ActionContext context) {
    if (UserUtils.getUserRoleType(context.getRequest()) > 0) {
      return UserUtils.getUserOrganization(context.getRequest());
    }
    return -1;
  }


  /**
   * Gets the userLevel attribute of the CFSModule object
   *
   * @param context   Description of the Parameter
   * @param db        Description of the Parameter
   * @param roleLevel Description of the Parameter
   * @return The userLevel value
   * @throws SQLException Description of the Exception
   */
  protected int getUserLevel(ActionContext context, Connection db, int roleLevel) throws SQLException {
    SystemStatus thisSystem = this.getSystemStatus(context);
    LookupList roleList = thisSystem.getLookupList(db, "lookup_project_role");
    if (roleList != null) {
      return roleList.getIdFromLevel(roleLevel);
    }
    return -1;
  }


  /**
   * Gets the documentStoreUserLevel attribute of the CFSModule object
   *
   * @param context   Description of the Parameter
   * @param db        Description of the Parameter
   * @param roleLevel Description of the Parameter
   * @return The documentStoreUserLevel value
   * @throws SQLException Description of the Exception
   */
  protected int getDocumentStoreUserLevel(ActionContext context, Connection db, int roleLevel) throws SQLException {
    SystemStatus thisSystem = this.getSystemStatus(context);
    LookupList roleList = thisSystem.getLookupList(
        db, "lookup_document_store_role");
    if (roleList != null) {
      return roleList.getIdFromLevel(roleLevel);
    }
    return -1;
  }


  /**
   * Gets the roleId attribute of the CFSModule object
   *
   * @param context   Description of the Parameter
   * @param db        Description of the Parameter
   * @param userlevel Description of the Parameter
   * @return The roleId value
   * @throws SQLException Description of the Exception
   */
  protected int getRoleId(ActionContext context, Connection db, int userlevel) throws SQLException {
    SystemStatus thisSystem = this.getSystemStatus(context);
    LookupList roleList = thisSystem.getLookupList(db, "lookup_project_role");
    if (roleList != null) {
      return roleList.getLevelFromId(userlevel);
    }
    return -1;
  }


  /**
   * Gets the documentStoreRoleId attribute of the CFSModule object
   *
   * @param context   Description of the Parameter
   * @param db        Description of the Parameter
   * @param userlevel Description of the Parameter
   * @return The documentStoreRoleId value
   * @throws SQLException Description of the Exception
   */
  protected int getDocumentStoreRoleId(ActionContext context, Connection db, int userlevel) throws SQLException {
    SystemStatus thisSystem = this.getSystemStatus(context);
    LookupList roleList = thisSystem.getLookupList(
        db, "lookup_document_store_role");
    if (roleList != null) {
      return roleList.getLevelFromId(userlevel);
    }
    return -1;
  }


  /**
   * Description of the Method
   *
   * @param context     Description of the Parameter
   * @param db          Description of the Parameter
   * @param thisProject Description of the Parameter
   * @param permission  Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  protected boolean hasProjectAccess(ActionContext context, Connection db, Project thisProject, String permission) throws SQLException {
    // See if the team member has access to perform a project action
    TeamMember thisMember = (TeamMember) context.getRequest().getAttribute(
        "currentMember");
    if (thisMember == null) {
      try {
        // Load from project
        thisMember = new TeamMember(
            db, thisProject.getId(), this.getUserId(context));
      } catch (Exception notValid) {
        // portal user cannot access project unless user is part of project team.
        if (isPortalUser(context)) {
          return false;
        }
        // Create a guest
        thisMember = new TeamMember();
        thisMember.setProjectId(thisProject.getId());
        thisMember.setUserLevel(getUserLevel(context, db, TeamMember.GUEST));
        thisMember.setRoleId(TeamMember.GUEST);
      }
      context.getRequest().setAttribute("currentMember", thisMember);
    }
    // Return the status of the permission
//    if (thisMember.getRoleId() == TeamMember.PROJECT_LEAD) {
if(1>0){
    return true;
    }
    // See what the minimum required is and see if user meets that
    int code = thisProject.getAccessUserLevel(permission);
    int roleId = getRoleId(context, db, code);
    if (code == -1 || roleId == -1) {
      return false;
    }
    return (thisMember.getRoleId() <= roleId);
  }


  /**
   * Description of the Method
   *
   * @param context           Description of the Parameter
   * @param db                Description of the Parameter
   * @param thisDocumentStore Description of the Parameter
   * @param permission        Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  protected boolean hasDocumentStoreAccess(ActionContext context, Connection db, DocumentStore thisDocumentStore, String permission) throws SQLException {
    // See if the team member has access to perform a document store action
    DocumentStoreTeamMember thisMember = (DocumentStoreTeamMember) context.getRequest().getAttribute(
        "currentMember");
    if (thisMember == null) {
      int tmpUserId = this.getUserId(context);
      User tmpUser = getUser(context, tmpUserId);
      try {
        // Load from document store
        int tmpUserRoleId = tmpUser.getRoleId();
        
        
      } catch (Exception notValid) {
        // portal user cannot access document store unless user is part of document store team.
        if (isPortalUser(context)) {
          return false;
        }
        // Create a guest
        thisMember = new DocumentStoreTeamMember();
        thisMember.setDocumentStoreId(thisDocumentStore.getId());
        thisMember.setUserLevel(
            getDocumentStoreUserLevel(
                context, db, DocumentStoreTeamMember.GUEST));
        thisMember.setRoleId(DocumentStoreTeamMember.GUEST);
        thisMember.setSiteId(tmpUser.getSiteId());
      }
      context.getRequest().setAttribute("currentMember", thisMember);
    }
    // Return the status of the permission
    if (thisMember.getRoleId() == DocumentStoreTeamMember.DOCUMENTSTORE_MANAGER) {
      return true;
    }
    // See what the minimum required is and see if user meets that
    int code = thisDocumentStore.getAccessUserLevel(permission);
    int roleId = getDocumentStoreRoleId(context, db, code);
    if (code == -1 || roleId == -1) {
      return false;
    }
    return (thisMember.getRoleId() <= roleId);
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @param id      Description of the Parameter
   * @param title   Description of the Parameter
   */
 


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @param id      Description of the Parameter
   * @param title   Description of the Parameter
   */
  protected void updateDocumentStoreCache(ActionContext context, int id, String title) {
    if (title != null) {
      // Update the system status
      /*
       *  ((HashMap) getSystemStatus(context).getObject(Constants.SYSTEM_DOCUMENT_NAME_LIST)).put(
       *  new Integer(id), title);
       */
    } else {
      // Remove from cache
      /*
       *  ((HashMap) getSystemStatus(context).getObject(Constants.SYSTEM_DOCUMENT_NAME_LIST)).remove(
       *  new Integer(id));
       */
    }
  }


  /**
   * Gets the popup attribute of the CFSModule object
   *
   * @param context Description of the Parameter
   * @return The popup value
   */
  protected boolean isPopup(ActionContext context) {
    return ("true".equals(context.getRequest().getParameter("popup")));
  }


  /**
   * Gets the directory attribute of the CFSModule object
   *
   * @param context Description of the Parameter
   * @return The directory value
   * @throws IOException Description of the Exception
   */
  protected synchronized Directory getDirectory(ActionContext context) throws IOException {
    File path = new File(getDbNamePath(context) + "index");
    boolean create = !path.exists();
    return getDirectory(path, create);
  }


  /**
   * Gets the directory attribute of the CFSModule object
   *
   * @param context Description of the Parameter
   * @param create  Description of the Parameter
   * @return The directory value
   * @throws IOException Description of the Exception
   */
  protected synchronized Directory getDirectory(ActionContext context, boolean create) throws IOException {
    File path = new File(getDbNamePath(context) + "index");
    return getDirectory(path, create);
  }


  /**
   * Gets the directory attribute of the CFSModule object
   *
   * @param create Description of the Parameter
   * @param path   Description of the Parameter
   * @return The directory value
   * @throws IOException Description of the Exception
   */
  protected synchronized Directory getDirectory(File path, boolean create) throws IOException {
    Directory index = FSDirectory.getDirectory(path, create);
    if (create) {
      IndexWriter writer = new IndexWriter(
          index, new StandardAnalyzer(), true);
      writer.optimize();
      writer.close();
    }
    return index;
  }


  /**
   * Adds an item to the log.
   *
   * @param context Description of the Parameter
   * @param type    Description of the Parameter
   * @param item    Description of the Parameter
   * @return Description of the Return Value
   * @throws IOException Description of the Exception
   */
  protected synchronized boolean addLogItem(ActionContext context, String type, Object item) throws IOException {
    if (item == null) {
      return false;
    }
//    Scheduler scheduler = (Scheduler) context.getServletContext().getAttribute("Scheduler");
//    try {
//      //e.g., type=webPageAccessLog
//      ((Vector) scheduler.getContext().get(type)).add(item);
//      scheduler.triggerJob("logger", Scheduler.DEFAULT_GROUP);
//    } catch (Exception e) {
//      System.out.println("CFSModule-> Scheduler failed: " + e.getMessage());
//    }
    return true;
  }

  /**
   * Adds an item to the index. Code licensed from teamelements.com
   *
   * @param context Description of the Parameter
   * @param item    Description of the Parameter
   * @return Description of the Return Value
   * @throws IOException Description of the Exception
   */
  protected synchronized boolean indexAddItem(ActionContext context, Object item) throws IOException {
    if (item == null) {
      return false;
    }
//    Scheduler scheduler = (Scheduler) context.getServletContext().getAttribute("Scheduler");
//    try {
//      IndexEvent indexEvent = new IndexEvent(item, IndexEvent.ADD, getDbName(context) + fs);
//      ((Vector) scheduler.getContext().get("IndexArray")).add(indexEvent);
//      scheduler.triggerJob("indexer", Scheduler.DEFAULT_GROUP);
//    } catch (Exception e) {
//      System.out.println("CFSModule-> Scheduler failed: " + e.getMessage());
//    }
    return true;
  }


  /**
   * Removes an item from the index. Code licensed from teamelements.com
   *
   * @param context Description of the Parameter
   * @param item    Description of the Parameter
   * @return Description of the Return Value
   * @throws IOException Description of the Exception
   */
  protected synchronized boolean indexDeleteItem(ActionContext context, Object item) throws IOException {
    if (item == null) {
      return false;
    }
//    Scheduler scheduler = (Scheduler) context.getServletContext().getAttribute("Scheduler");
//    try {
//      IndexEvent indexEvent = new IndexEvent(item, IndexEvent.DELETE, getDbName(context) + fs);
//      ((Vector) scheduler.getContext().get("IndexArray")).add(indexEvent);
//      scheduler.triggerJob("indexer", Scheduler.DEFAULT_GROUP);
//    } catch (Exception e) {
//      System.out.println("CFSModule-> Scheduler failed: " + e.getMessage());
//    }
    return true;
  }


  /**
   * Gets the currentDateAsString attribute of the CFSModule class Fetches the
   * current date in based on timezone and locale as string
   *
   * @param context Description of the Parameter
   * @return The currentDateAsString value
   */
  public static String getCurrentDateAsString(ActionContext context) {
    String currentDateAsString = "";
    try {
      UserBean userBean = (UserBean) context.getSession().getAttribute("User");
      User user = userBean.getUserRecord();
      Calendar calendar = Calendar.getInstance();
      calendar.setTimeZone(java.util.TimeZone.getTimeZone(user.getTimeZone()));
      SimpleDateFormat formatter = (SimpleDateFormat) SimpleDateFormat.getDateInstance(
          DateFormat.SHORT, user.getLocale());
      formatter.applyPattern(
          DateUtils.get4DigitYearDateFormat(formatter.toPattern()));
      currentDateAsString = formatter.format(calendar.getTime());
    } catch (Exception e) {
    }
    return currentDateAsString;
  }


  /**
   * Checks to see if the specified object is valid for inserting or updating
   *
   * @param context Description of the Parameter
   * @param db      Description of the Parameter
   * @param object  Description of the Parameter
   * @return Description of the Return Value
   * @throws Exception Description of the Exception
   */
  protected boolean validateObject(ActionContext context, Connection db, Object object) throws Exception {
    
	
	 if (context.getParameter("cu_pregresso")!=null)
		 ObjectValidator.cuPregresso=Integer.parseInt(context.getParameter("cu_pregresso"));
	boolean ret = (ObjectValidator.validate(context,getSystemStatus(context), db, object) && ObjectValidator.validateInBacheca(getSystemStatus(context), db, object));
    HashMap errors = (HashMap) ObjectUtils.getObject(object, "errors");
    if (ret == false) {
      ObjectUtils.setParam(object, "onlyWarnings", false);
      // Iterate the errors and put in request
      processErrors(context, errors);
      return false;
    }
   
    return true; 
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @param db      Description of the Parameter
   * @param object  Description of the Parameter
   * @param map     Description of the Parameter
   * @return Description of the Return Value
   * @throws Exception Description of the Exception
   */
  protected boolean validateObject(ActionContext context, Connection db, Object object, HashMap map) throws Exception {
    ObjectValidator.validate(getSystemStatus(context), db, object, map);
    HashMap errors = (HashMap) ObjectUtils.getObject(object, "errors");
    HashMap warnings = (HashMap) ObjectUtils.getObject(object, "warnings");
    if (errors.size() > 0) {
      ObjectUtils.setParam(object, "onlyWarnings", false);
      // Iterate the errors and put in request
      processErrors(context, errors);
      return false;
    } else if (warnings.size() > 0) {
      String showWarnings = ObjectUtils.getParam(object, "onlyWarnings");
      if (showWarnings != null && "true".equals(showWarnings)) {
        return true;
      }
      // if onlyWarnings = false
      processWarnings(context, warnings);
      ObjectUtils.setParam(object, "onlyWarnings", true);
      return false;
    }
    return true;
  }


  /**
   * Description of the Method
   *
   * @param db        Description of the Parameter
   * @param projectId Description of the Parameter
   * @param context   Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  protected Project loadProject(Connection db, int projectId, ActionContext context) throws SQLException {
    // TODO: Implement this when a system admin is defined
    //User thisUser = getUser(context, getUserId(context));
    //if (thisUser.getAccessAdmin()) {
    //  return new Project(db, projectId);
    //}
	

	  
	
	
	
	  
	  
    return new Project(db, projectId, getUserRange(context));
  }

  
  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @param jobName Description of the Parameter
   */
  protected void executeJob(ActionContext context, String jobName) {
//    Scheduler scheduler = (Scheduler) context.getServletContext().getAttribute(
//        "Scheduler");
//    try {
//      scheduler.triggerJob(jobName, Scheduler.DEFAULT_GROUP);
//    } catch (Exception e) {
//      System.out.println("CFSModule-> Scheduler failed: " + e.getMessage());
//    }
  }


  /**
   * Gets the userLanguage attribute of the CFSModule object
   *
   * @param context Description of the Parameter
   * @return The userLanguage value
   */
  protected String getUserLanguage(ActionContext context) {
    User thisUser = getUser(context, getUserId(context));
    return getUserLanguage(context, thisUser);
  }


  /**
   * Gets the userLanguage attribute of the CFSModule object
   *
   * @param context  Description of the Parameter
   * @param thisUser Description of the Parameter
   * @return The userLanguage value
   */
  protected String getUserLanguage(ActionContext context, User thisUser) {
    // See if user has locale
    if (thisUser != null) {
      Locale locale = thisUser.getLocale();
      if (locale != null) {
        return (locale.getLanguage() + "_" + locale.getCountry());
      }
    }
    // Otherwise return the application locale
    return getPref(context, "SYSTEM.LANGUAGE");
  }
  
  

  
  //GESTIONE COORDINATE CENTRALIZZATA ()
  protected String[] convert2Wgs84UTM33N( String latitude, String longitude, Connection conn  ) throws SQLException
  {
		
		String[] ret = new String[2];
		ret[0] = longitude;
		ret[1] = latitude;
		
//		String sql = 
//		"select 	postgis.st_x \n"	+ 
//		"( \n"				+ 
//		"	postgis.st_transform \n"	+ 
//		"	(  \n"			+ 
//		"		postgis.st_geomfromtext \n"	+ 
//		"		(  \n"				+ 
//		"			'POINT( " + longitude + " " + latitude + " )', 4326 \n"	+ 
//		"	 \n"					+ 
//		"		), 32633 \n"			+ 
//		"	) \n"					+ 
//		") AS x, \n"				+ 
//		" postgis.st_y \n"						+ 
//		"( \n"						+ 
//		"	postgis.st_transform \n"			+ 
//		"	(  \n"					+ 
//		"		postgis.st_geomfromtext \n"	+ 
//		"		(  \n"				+ 
//		"			'POINT( " + longitude + " " + latitude + " )', 4326 \n"	+ 
//		"	 \n"			+ 
//		"		), 32633 \n"	+ 
//		"	) \n"			+ 
//		") AS y \n";
//		
//		try
//		{
//			
//			PreparedStatement stat = conn.prepareStatement( sql );  
//			
//			//stat.setString( 1, wgs84[0] );
//			//stat.setString( 2, wgs84[1] );
//			//stat.setString( 3, wgs84[0] );
//			//stat.setString( 4, wgs84[1] );
//			
//			ResultSet res = stat.executeQuery();
//			if( res.next() )
//			{
//				ret = new String[2];
//				ret[0] = res.getString( "x" );
//				ret[1] = res.getString( "y" );
//				
//			}
//			res.close();
//			stat.close();
//		}
//		catch (Exception e)
//		{
//			e.printStackTrace();
//		}
		return ret;
	}
  
 //latitudine e longitudine per test le inverto... 
  protected String[] converToWgs84UTM33NInverter(String latitudine , String longitudine, Connection db) throws SQLException
  {
          String lat ="";
          String lon = "";
          String [] coord = new String [2];
          
          coord[0] = latitudine;
          coord[1] = longitudine;
//          String sql1 =  "select         postgis.st_x \n"        + 
//                  "( \n"                                + 
//                  "        postgis.st_transform \n"        + 
//                  "        (  \n"                        + 
//                  "                postgis.st_geomfromtext \n"        + 
//                  "                (  \n"                                + 
//                  "                        'POINT("+longitudine+" "+latitudine+")', 32633 \n"        + 
//                  "         \n"                                        + 
//                  "                ), 4326 \n"                        + 
//                  "        ) \n"                                        + 
//                  ") AS x, \n"                                + 
//                  " postgis.st_y \n"                                                + 
//                  "( \n"                                                + 
//                  "        postgis.st_transform \n"                        + 
//                  "        (  \n"                                        + 
//                  "                postgis.st_geomfromtext \n"        + 
//                  "                (  \n"                                + 
//                  "                        'POINT("+longitudine+" "+latitudine+")', 32633 \n"        + 
//                  "         \n"                        + 
//                  "                ), 4326 \n"        + 
//                  "        ) \n"                        + 
//                  ") AS y \n";
//          
//        try {
//        	
//          PreparedStatement stat1 = db.prepareStatement( sql1 ); 
//          
//          ResultSet res1 = stat1.executeQuery();
//          if( res1.next() )
//          {
//                  lat = res1.getString( "y") ;
//                  lon=res1.getString( "x" );
//                  coord [0] =lat;
//                  coord [1] =lon;
//          
//          }
//          res1.close();
//          stat1.close();
//          
//        }catch (Exception e){
//        	e.printStackTrace();
//        }
         
        return coord;
          
  }
  
  protected Connection getConnection(ConnectionElement ce,  UserBean u, ConnectionPool cp, String contesto, ConnectionPool cpRo,HttpSession session, ApplicationPrefs prefs, ActionContext context, Object systemStatus, String command, String actionName, String actionClassName, String remoteAddr ) throws SQLException 
  {
	    ConnectionPool sqlDriver = null;
	    String browser = "";
	   
	    if (u.getBrowserId().equalsIgnoreCase("moz"))
	    	browser = "Firefox";
	    
	    if (browser.contains("Firefox"))
	    	sqlDriver = cp;
	    else 
	    {
			if (contesto!=null && contesto.equals("_ext") && u.getRoleId()==10000003)
				sqlDriver = cp;
			else
				sqlDriver = cpRo;
	    }
	    Connection db = sqlDriver.getConnection(ce, session, u, prefs, context, browser, systemStatus, command, actionName, actionClassName, remoteAddr);
	    return db;
	  }
  
  
}
