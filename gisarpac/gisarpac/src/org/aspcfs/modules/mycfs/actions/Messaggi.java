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
package org.aspcfs.modules.mycfs.actions;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;

import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.accounts.base.Organization;
import org.aspcfs.modules.accounts.base.OrganizationList;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.admin.base.UserList;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.modules.contacts.base.Contact;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.modules.mycfs.base.AlertType;
import org.aspcfs.modules.mycfs.base.CalendarEventList;
import org.aspcfs.modules.mycfs.base.messaggi.CFSNote;
import org.aspcfs.modules.mycfs.base.messaggi.CFSNoteList;
import org.aspcfs.modules.mycfs.beans.CalendarBean;
import org.aspcfs.modules.tasks.base.Task;
import org.aspcfs.utils.DateUtils;
import org.aspcfs.utils.SMTPMessage;
import org.aspcfs.utils.StringUtils;
import org.aspcfs.utils.Template;
import org.aspcfs.utils.web.CalendarView;
import org.aspcfs.utils.web.CountrySelect;
import org.aspcfs.utils.web.HtmlSelect;
import org.aspcfs.utils.web.LookupList;
import org.aspcfs.utils.web.PagedListInfo;
import org.aspcfs.utils.web.StateSelect;

import com.darkhorseventures.framework.actions.ActionContext;

/**
 * The MyCFS module.
 *
 * @author chris
 * @version $Id: MyCFS.java 18832 2007-01-26 19:21:02Z matt $
 * @created July 3, 2001
 */
public final class Messaggi extends CFSModule {

  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandDefault(ActionContext context) {
    String module = context.getRequest().getParameter("module");
    String includePage = context.getRequest().getParameter("include");
    context.getRequest().setAttribute("IncludePage", includePage);
    addModuleBean(context, module, module);
    return ("IncludeOK");
  }


  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandInbox(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-inbox-view"))) {
      return ("PermissionError");
    }
    PagedListInfo inboxInfo = this.getPagedListInfo(context, "InboxInfo");
    inboxInfo.setLink("Messaggi.do?command=Inbox");

    Connection db = null;
    CFSNoteList noteList = new CFSNoteList();
    SystemStatus systemStatus = this.getSystemStatus(context);
    try {
      db = this.getConnection(context);
      noteList.setPagedListInfo(inboxInfo);
      noteList.setSentTo(
          ((UserBean) context.getSession().getAttribute("User")).getUserRecord().getContact().getId());
      noteList.setSentFrom(getUserId(context));

      if (context.getRequest().getParameter("return") != null) {
        inboxInfo.setListView("new");
      }

      if ("old".equals(inboxInfo.getListView())) {
        noteList.setOldMessagesOnly(true);
      }

      // TODO: Modify CFSNoteList so that only 1 query is always generated so
      // this doesn't have to happen...
      if ("sent".equals(inboxInfo.getListView())) {
        /*
         *  Changing sort column as  "sent_namelast" is not a column in the query
         */
        if ("sent_namelast".equals(inboxInfo.getColumnToSortBy())) {
          inboxInfo.setColumnToSortBy("m.sent");
        }
        noteList.setSentMessagesOnly(true);
      } else {
        /*
         *  Changing sort column back to requested column
         */
        if ("m.sent".equals(inboxInfo.getColumnToSortBy())) {
          inboxInfo.setColumnToSortBy("sent_namelast");
        }
      }

      noteList.buildList(db);
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    context.getRequest().setAttribute("systemStatus", systemStatus);
    context.getRequest().setAttribute("CFSNoteList", noteList);
    addModuleBean(context, "MyInbox", "Inbox Home");
    return ("InboxOK");
  }

  public String executeCommandFiltraInbox(ActionContext context) {
	    if (!(hasPermission(context, "myhomepage-inbox-view"))) {
	      return ("PermissionError");
	    }
	    PagedListInfo inboxInfo = this.getPagedListInfo(context, "InboxInfo");
	     inboxInfo.setLink("Messaggi.do?command=Inbox");

	    Connection db = null;
	    CFSNoteList noteList = new CFSNoteList();
	    SystemStatus systemStatus = this.getSystemStatus(context);
	    try {
	      db = this.getConnection(context);
	      noteList.setPagedListInfo(inboxInfo);
	      noteList.setSentTo(
	          ((UserBean) context.getSession().getAttribute("User")).getUserRecord().getContact().getId());
	      noteList.setSentFrom(getUserId(context));

	      if (context.getRequest().getParameter("return") != null) {
	        inboxInfo.setListView("new");
	      }

	      if ("old".equals(inboxInfo.getListView())) {
	        noteList.setOldMessagesOnly(true);
	      }

	      // TODO: Modify CFSNoteList so that only 1 query is always generated so
	      // this doesn't have to happen...
	      if ("sent".equals(inboxInfo.getListView())) {
	        /*
	         *  Changing sort column as  "sent_namelast" is not a column in the query
	         */
	        if ("sent_namelast".equals(inboxInfo.getColumnToSortBy())) {
	          inboxInfo.setColumnToSortBy("m.sent");
	        }
	        noteList.setSentMessagesOnly(true);
	      } else {
	        /*
	         *  Changing sort column back to requested column
	         */
	        if ("m.sent".equals(inboxInfo.getColumnToSortBy())) {
	          inboxInfo.setColumnToSortBy("sent_namelast");
	        }
	      }

	      String oggetto = context.getRequest().getParameter("oggetto");
	      if (oggetto!=null && !oggetto.equals("")){
	    	  noteList.setSubjectMessage(oggetto);
	    	  context.getRequest().setAttribute("oggetto", oggetto);
	      }
	      String testo = context.getRequest().getParameter("testo");
	      if (testo!=null && !testo.equals("")){
	    	  noteList.setBodyMessage(testo);
	    	  context.getRequest().setAttribute("testo", testo);
	      }
	      	
	       noteList.setTutteInUnaPagina(true);
	       noteList.buildList(db);
	    } catch (Exception errorMessage) {
	      context.getRequest().setAttribute("Error", errorMessage);
	      return ("SystemError");
	    } finally {
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("systemStatus", systemStatus);
	    context.getRequest().setAttribute("CFSNoteList", noteList);
	    addModuleBean(context, "MyInbox", "Inbox Home");
	    return ("InboxOK");
	  }

  
  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandDeleteHeadline(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-miner-delete"))) {
      return ("PermissionError");
    }
    Enumeration parameters = context.getRequest().getParameterNames();
    int orgId = -1;
    Connection db = null;
    try {
      db = this.getConnection(context);
      while (parameters.hasMoreElements()) {
        String param = (String) parameters.nextElement();

        if (context.getRequest().getParameter(param).equals("on")) {
          orgId = Integer.parseInt(param);
          Organization newOrg = new Organization();
          newOrg.setOrgId(orgId);
          newOrg.deleteMinerOnly(db);
          if (System.getProperty("DEBUG") != null) {
            System.out.println(
                "MyCFS-> " + param + ": " + context.getRequest().getParameter(
                    param) + "<br>");
          }
        }
      }
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    addModuleBean(context, "", "Headline Delete OK");
    return ("DeleteOK");
  }


  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandCFSNoteDelete(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-inbox-view"))) {
      return ("PermissionError");
    }
    Connection db = null;
    int myId = -1;
    PagedListInfo inboxInfo = this.getPagedListInfo(context, "InboxInfo");
    try {
      db = this.getConnection(context);
      int noteId = Integer.parseInt(context.getRequest().getParameter("id"));
      /*
       *  For a sent message myId is a user_id else its a contactId
       */
      if (inboxInfo.getListView().equals("sent")) {
        myId = getUserId(context);
      } else {
        myId = ((UserBean) context.getSession().getAttribute("User")).getUserRecord().getContact().getId();
      }
      CFSNote newNote = new CFSNote(db, noteId, myId, inboxInfo.getListView());
      if (System.getProperty("DEBUG") != null) {
        System.out.println(
            "\nMYCFS view mode" + context.getRequest().getParameter(
                "listView"));
      }
      newNote.setCurrentView(inboxInfo.getListView());
      newNote.delete(db, myId);
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    addModuleBean(context, "MyInbox", "Inbox Home");
    return (executeCommandInbox(context));
  }


  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandCFSNoteTrash(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-inbox-view"))) {
      return ("PermissionError");
    }
    String returnPage = context.getRequest().getParameter("return");
    PagedListInfo inboxInfo = this.getPagedListInfo(context, "InboxInfo");
    Connection db = null;
    int myId = -1;
    try {
      db = this.getConnection(context);
      int noteId = Integer.parseInt(context.getRequest().getParameter("id"));
      //For a sent message myId is a user_id else its a contactId
      if (inboxInfo.getListView().equals("sent")) {
        myId = getUserId(context);
      } else {
        myId = ((UserBean) context.getSession().getAttribute("User")).getUserRecord().getContact().getId();
      }
      CFSNote newNote = new CFSNote(db, noteId, myId, inboxInfo.getListView());

      if (System.getProperty("DEBUG") != null) {
        System.out.println("MyCFS-> Status before: " + newNote.getStatus());
      }
      if (newNote.getStatus() == 2) {
        newNote.setStatus(CFSNote.READ);
      } else {
        newNote.setStatus(CFSNote.OLD);
      }

      newNote.updateStatus(db);
      if (System.getProperty("DEBUG") != null) {
        System.out.println("MyCFS-> Status after: " + newNote.getStatus());
      }
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    addModuleBean(context, "MyInbox", "Inbox Home");
    return (executeCommandInbox(context));
  }


  /**
   * Takes a look at the User Session Object and prepares the MyCFSBean for the
   * JSP. The bean will contain all the information that the JSP can see.
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   * @since 1.1
   */
  public String executeCommandHeadline(ActionContext context) {
    if (!hasPermission(context, "myhomepage-miner-view")) {
      return ("PermissionError");
    }
    addModuleBean(context, "Customize Headlines", "Customize Headlines");
    PagedListInfo orgListInfo = this.getPagedListInfo(
        context, "HeadlineListInfo");
    orgListInfo.setLink("MyCFS.do?command=Headline");
    Connection db = null;
    OrganizationList organizationList = new OrganizationList();
    try {
      db = this.getConnection(context);
      organizationList.setPagedListInfo(orgListInfo);
      organizationList.setMinerOnly(true);
      organizationList.setEnteredBy(getUserId(context));
      organizationList.buildList(db);
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    context.getRequest().setAttribute("OrgList", organizationList);
    return ("HeadlineOK");
  }


  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandInsertHeadline(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-miner-add"))) {
      return ("PermissionError");
    }
    addModuleBean(context, "Customize Headlines", "");
    boolean existsAlready = false;
    Connection db = null;
    String name = context.getRequest().getParameter("name");
    String sym = context.getRequest().getParameter("stockSymbol");
    Organization newOrg = (Organization) new Organization();
    newOrg.setName(name);
    newOrg.setTicker(sym);
    newOrg.setIndustry("1");
    newOrg.setEnteredBy(getUserId(context));
    newOrg.setModifiedBy(getUserId(context));
    newOrg.setOwner(-1);
    newOrg.setMinerOnly(true);
    try {
      db = this.getConnection(context);
      existsAlready = newOrg.checkIfExists(db, name);
      newOrg.insert(db,context);
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    context.getRequest().setAttribute("OrgDetails", newOrg);
    return (executeCommandHeadline(context));
  }


  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandCFSNoteDetails(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-inbox-view"))) {
      return ("PermissionError");
    }
    PagedListInfo inboxInfo = this.getPagedListInfo(context, "InboxInfo");
    Connection db = null;
    int myId = -1;
    CFSNote newNote = null;
    try {
      int msgId = Integer.parseInt(context.getRequest().getParameter("id"));
      db = this.getConnection(context);
      //For a sent message myId is a user_id else its a contactId
      if (inboxInfo.getListView().equals("sent")) {
        myId = getUserId(context);
      } else {
        myId = ((UserBean) context.getSession().getAttribute("User")).getUserRecord().getContact().getId();
      }
      newNote = new CFSNote(db, msgId, myId, inboxInfo.getListView());
      if (!inboxInfo.getListView().equalsIgnoreCase("sent")) {
        /*
         *  do not change status if its the OutBox
         */
        if (newNote.getStatus() == CFSNote.NEW) {
          newNote.setStatus(CFSNote.READ);
          newNote.updateStatus(db);
        }
      }
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    addModuleBean(context, "MyInbox", "Inbox Details");
    context.getRequest().setAttribute("NoteDetails", newNote);
    return ("CFSNoteDetailsOK");
  }


  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandNewMessage(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-inbox-view"))) {
      return ("PermissionError");
    }
    Connection db = null;
    try {
      db = this.getConnection(context);
      CFSNote newNote = (CFSNote) context.getFormBean();
      if (newNote == null) {
        newNote = new CFSNote();
      }
      String subject = (String) context.getRequest().getParameter("subject");
      String body = (String) context.getRequest().getParameter("body");
      String mailRecipients = (String) context.getRequest().getParameter(
          "mailrecipients");
      if (subject != null && !"".equals(subject)) {
        newNote.setSubject(subject);
      }
      if (body != null && !"".equals(body)) {
        newNote.setBody(body);
      }
      if (mailRecipients != null) {
        context.getRequest().setAttribute(
            "mailRecipients", new String("true"));
      }
      context.getRequest().setAttribute("Note", newNote);
      context.getRequest().setAttribute("forwardType", "" + Constants.CFSNOTE);
      //check if there are any recipients specified
      //Uncomment when action lists send message needs to be implemented
      /*
       *  if(recipients != null){
       *  StringTokenizer tokens = new StringTokenizer(recipients, "|");
       *  while(tokens.hasMoreTokens()){
       *  String recipient = (String) tokens.nextToken();
       *  Contact thisRecipient = new Contact(db, Integer.parseInt(recipient));
       *  recipientList.add(thisRecipient);
       *  }
       *  }
       */
      context.getSession().removeAttribute("selectedContacts");
      context.getSession().removeAttribute("finalContacts");
      context.getSession().removeAttribute("contactListInfo");
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    addModuleBean(context, "MyInbox", "");
    return ("CFSNewMessageOK");
  }


  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */

  public String executeCommandSendMessage(ActionContext context) {
    int noteType = -1;
    boolean recordInserted = false;
    Connection db = null;
    boolean savecopy = false;
    boolean copyrecipients = false;
  // ArrayList<Contact> listaContact = new ArrayList<Contact>();
    HashMap errors = null;
    boolean isValid = false;
    try
    {
    	db = this.getConnection(context);
     
    /*  for(int i=0;i<contactIdList.length; i++)
      {
    	  listaContact.add(new Contact(db,Integer.parseInt(contactIdList[i])));
      }
    */
    
    CFSNote thisNote = new CFSNote();
    thisNote.setEnteredBy(getUserId(context));
    thisNote.setModifiedBy(getUserId(context));
    thisNote.setReplyId(getUserId(context));
    thisNote.setType(CFSNote.CALL);
    if (context.getRequest().getParameter("subject") != null) {
      thisNote.setSubject(context.getRequest().getParameter("subject"));
      context.getRequest().setAttribute("subject", thisNote.getSubject());
    } else {
      thisNote.setSubject("error");
    }
    if (context.getRequest().getParameter("body") != null) {
      thisNote.setBody(context.getRequest().getParameter("body"));
      context.getRequest().setAttribute("body", thisNote.getBody());
    } else {
      thisNote.setBody("error");
    }
    if (context.getRequest().getParameter("actionId") != null) {
      thisNote.setActionId(context.getRequest().getParameter("actionId"));
    }
    if (context.getRequest().getParameter("savecopy") != null) {
      savecopy = true;
    }
    if (context.getRequest().getParameter("mailrecipients") != null) {
      copyrecipients = true;
      context.getRequest().setAttribute("mailrecipients", "true");
    }
   
    Contact thisContact = null;
    User thisRecord = (User) ((UserBean) context.getSession().getAttribute(
        "User")).getUserRecord();
    thisRecord.setBuildContact(true);

   
      noteType = Integer.parseInt(
          (String) context.getRequest().getParameter("forwardType"));
      
      SystemStatus systemStatus = this.getSystemStatus(context);
      isValid = this.validateObject(context, db, thisNote);
      if (isValid) {
        if (context.getRequest().getParameterValues("listView") != null) {
        	 String[] contactIdList = context.getRequest().getParameterValues("listView");
          String replyAddr = thisRecord.getContact().getPrimaryEmailAddress();
          int contactId = -1;
          String email = "";
         for(int i = 0 ; i <contactIdList.length;i++)
         {
        	 String[] id_mail = contactIdList[i].split(";");
        	
       if(id_mail.length>=2)
              email =id_mail[1];
            	thisContact = new Contact();
            	if(id_mail.length>=1)
            	thisContact.setId(id_mail[0]);
//            thisContact.setBuildDetails(true);
//            thisContact.build(db);
            CFSNote tmpNote = new CFSNote();
            tmpNote.setEnteredBy(getUserId(context));
            tmpNote.setModifiedBy(getUserId(context));
            tmpNote.setReplyId(getUserId(context));
            tmpNote.setType(CFSNote.CALL);
            tmpNote.setSubject(thisNote.getSubject());
            tmpNote.setBody(thisNote.getBody());
            tmpNote.setActionId(thisNote.getActionId());
            if(id_mail.length>=1)
            tmpNote.setSentTo(id_mail[0]);
            if ((!email.startsWith("P:")) && (copyrecipients || !thisContact.hasAccount())) {
              /*All contacts with email addresses (without user accounts)*/
              SMTPMessage mail = new SMTPMessage();
              mail.setHost(getPref(context, "MAILSERVER"));
              mail.setFrom(getPref(context, "EMAILADDRESS"));
              if (replyAddr != null && !(replyAddr.equals(""))) {
                mail.addReplyTo(replyAddr);
              }
              mail.setType("text/html");
              mail.setTo(email);
              mail.setSubject(tmpNote.getSubject());
              String message = systemStatus.getLabel(
                  "mail.body.emailContactWithBody");
              HashMap map = new HashMap();
              map.put(
                  "${thisRecord.contact.nameFirstLast}", thisRecord.getContact().getNameFirstLast());
              map.put(
                  "${thisNote.body}", StringUtils.toHtml(tmpNote.getBody()));
              Template template = new Template(message);
              template.setParseElements(map);
              mail.setBody(template.getParsedText());
              if (System.getProperty("DEBUG") != null) {
                System.out.println("Sending Mail .. " + tmpNote.getBody());
              }
              if (mail.send() == 2) {
                if (System.getProperty("DEBUG") != null) {
                  System.out.println(
                      "MyCFS-> Send error: " + mail.getErrorMsg() + "<br><br>");
                }
                System.err.println(mail.getErrorMsg());
                if (errors == null) {
                  errors = new HashMap();
                }
                errors.put(
                    "contact" + thisContact.getId(), systemStatus.getLabel(
                        "mail.contactErrorMessage") + mail.getErrorMsg());
              } else {
                if (System.getProperty("DEBUG") != null) {
                  System.out.println("MyCFS-> Sending message to " + email);
                }
                //Message is sent. Insert the note
                recordInserted = tmpNote.insert(db,context);
                recordInserted = tmpNote.insertLink(
                    db, thisContact.hasAccount());
                this.processInsertHook(context, tmpNote);
              }
            } else if (email.startsWith("P:") && !thisContact.hasAccount()) {
              /*All contacts without user accounts and without email addresses*/
              if (errors == null) {
                errors = new HashMap();
              }
              errors.put(
                  "contact" + thisContact.getId(), systemStatus.getLabel(
                      "mail.contactNoEmailAddress"));
            } else if (email.startsWith("P:") && thisContact.getOrgId() != -1 && (!thisContact.hasEnabledAccount() || copyrecipients)) {
              /*all contacts without email addresses with invalid user accounts*/
              if (errors == null) {
                errors = new HashMap();
              }
              errors.put(
                  "contact" + thisContact.getId(), systemStatus.getLabel(
                      "mail.contactNoEmailAddress"));
            } else {
              recordInserted = tmpNote.insert(db,context);
              recordInserted = tmpNote.insertLink(
                  db, thisContact.hasAccount());
              this.processInsertHook(context, tmpNote);
            }
            if(recordInserted==true)
            {
            	String numAllegati =context.getRequest().getParameter("elementi");
            	if(numAllegati!=null && !numAllegati.equals(""))
            	{
            		int numeroAllegati=Integer.parseInt(numAllegati);
            		if(numeroAllegati>0)
            		{
            		for(int j=0;j<numeroAllegati;j++)
            		{
            			int actual = j+1;
            			String descrizione = context.getRequest().getParameter("title_"+actual);
            			int idAllegato = Integer.parseInt(context.getRequest().getParameter("allegato_"+actual));
            			String folderid = context.getRequest().getParameter("folderid_"+actual);
            			String estensione = context.getRequest().getParameter("estensione_"+actual);
            			String versione = context.getRequest().getParameter("versione_"+actual);
            			tmpNote.insertMessaggiAllegati(db, descrizione, idAllegato,folderid,estensione,versione);
            		}
            		}
            		
            	}
            }
            
          }
        } else {
          isValid = false;
          if (errors == null) {
            errors = new HashMap();
          }
          errors.put(
              "contactsError", systemStatus.getLabel(
                  "mail.contactsNotSelected"));
        }
      }
      context.getSession().removeAttribute("DepartmentList");
      context.getSession().removeAttribute("ProjectListSelect");
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    if (context.getAction().getActionName().equals(
        "ExternalContactsCallsForward")) {
      addModuleBean(context, "External Contacts", "");
    } else if (context.getAction().getActionName().equals("MyCFSInbox")) {
      addModuleBean(context, "MyInbox", "");
    } else if (context.getAction().getActionName().equals("MyTasksForward")) {
      addModuleBean(context, "My Tasks", "");
    }
    if (errors != null) {
      processErrors(context, errors);
    }
    if (isValid) {
      return getReturn(context, "SendMessage");
    }
    if (noteType == Constants.CFSNOTE) {
      return executeCommandNewMessage(context);
    } else if (noteType == Constants.TASKS) {
      return executeCommandForwardMessage(context);
    } else {
      context.getRequest().setAttribute(
          "Error", new Exception("Programming Error: Please check code"));
      return "SystemError";
    }
  }


  public String executeCommandSendMessageDocumentale(ActionContext context) {
    int noteType = -1;
    boolean recordInserted = false;
    Connection db = null;
    boolean savecopy = false;
    boolean copyrecipients = false;
  // ArrayList<Contact> listaContact = new ArrayList<Contact>();
    HashMap errors = null;
    boolean isValid = false;
    try
    {
    	db = this.getConnection(context);
     
    /*  for(int i=0;i<contactIdList.length; i++)
      {
    	  listaContact.add(new Contact(db,Integer.parseInt(contactIdList[i])));
      }
    */
    
    CFSNote thisNote = new CFSNote();
    thisNote.setEnteredBy(getUserId(context));
    thisNote.setModifiedBy(getUserId(context));
    thisNote.setReplyId(getUserId(context));
    thisNote.setType(CFSNote.CALL);
    if (context.getRequest().getParameter("subject") != null) {
      thisNote.setSubject(context.getRequest().getParameter("subject"));
      context.getRequest().setAttribute("subject", thisNote.getSubject());
    } else {
      thisNote.setSubject("error");
    }
    if (context.getRequest().getParameter("body") != null) {
      thisNote.setBody(context.getRequest().getParameter("body"));
      context.getRequest().setAttribute("body", thisNote.getBody());
    } else {
      thisNote.setBody("error");
    }
    if (context.getRequest().getParameter("actionId") != null) {
      thisNote.setActionId(context.getRequest().getParameter("actionId"));
    }
    if (context.getRequest().getParameter("savecopy") != null) {
      savecopy = true;
    }
    if (context.getRequest().getParameter("mailrecipients") != null) {
      copyrecipients = true;
      context.getRequest().setAttribute("mailrecipients", "true");
    }
   
    Contact thisContact = null;
    User thisRecord = (User) ((UserBean) context.getSession().getAttribute(
        "User")).getUserRecord();
    thisRecord.setBuildContact(true);

   
      noteType = Integer.parseInt(
          (String) context.getRequest().getParameter("forwardType"));
      
      SystemStatus systemStatus = this.getSystemStatus(context);
      isValid = this.validateObject(context, db, thisNote);
      if (isValid) {
        if (context.getRequest().getParameterValues("listView") != null) {
        	 String[] contactIdList = context.getRequest().getParameterValues("listView");
          String replyAddr = thisRecord.getContact().getPrimaryEmailAddress();
          int contactId = -1;
          String email = "";
         for(int i = 0 ; i <contactIdList.length;i++)
         {
        	 String[] id_mail = contactIdList[i].split(";");
        	
       if(id_mail.length>=2)
              email =id_mail[1];
            	thisContact = new Contact();
            	if(id_mail.length>=1)
            	thisContact.setId(id_mail[0]);
//            thisContact.setBuildDetails(true);
//            thisContact.build(db);
            CFSNote tmpNote = new CFSNote();
            tmpNote.setEnteredBy(getUserId(context));
            tmpNote.setModifiedBy(getUserId(context));
            tmpNote.setReplyId(getUserId(context));
            tmpNote.setType(CFSNote.CALL);
            tmpNote.setSubject(thisNote.getSubject());
            tmpNote.setBody(thisNote.getBody());
            tmpNote.setActionId(thisNote.getActionId());
            if(id_mail.length>=1)
            tmpNote.setSentTo(id_mail[0]);
           
              recordInserted = tmpNote.insert(db,context);
              recordInserted = tmpNote.insertLink(db, thisContact.hasAccount());
              
              this.processInsertHook(context, tmpNote);
            
            if(recordInserted==true)
            {
            	String numAllegati =context.getRequest().getParameter("elementi");
            	if(numAllegati!=null && !numAllegati.equals(""))
            	{
            		int numeroAllegati=Integer.parseInt(numAllegati);
            		if(numeroAllegati>0)
            		{
            		for(int j=0;j<numeroAllegati;j++)
            		{
            			int actual = j+1;
            			String descrizione = context.getRequest().getParameter("title_"+actual);
            			String codAllegato = context.getRequest().getParameter("allegato_"+actual);
            			String estensione = context.getRequest().getParameter("estensione_"+actual);
            			tmpNote.insertMessaggiAllegatiDocumentale(db, descrizione, codAllegato,estensione);
            		}
            		}
            		
            	}
            }
            
          }
        } else {
          isValid = false;
          if (errors == null) {	
            errors = new HashMap();
          }
          errors.put(
              "contactsError", systemStatus.getLabel(
                  "mail.contactsNotSelected"));
        }
      }
      context.getSession().removeAttribute("DepartmentList");
      context.getSession().removeAttribute("ProjectListSelect");
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    if (context.getAction().getActionName().equals(
        "ExternalContactsCallsForward")) {
      addModuleBean(context, "External Contacts", "");
    } else if (context.getAction().getActionName().equals("MyCFSInbox")) {
      addModuleBean(context, "MyInbox", "");
    } else if (context.getAction().getActionName().equals("MyTasksForward")) {
      addModuleBean(context, "My Tasks", "");
    }
    if (errors != null) {
      processErrors(context, errors);
    }
    if (isValid) {
      return getReturn(context, "SendMessage");
    }
    if (noteType == Constants.CFSNOTE) {
      return executeCommandNewMessage(context);
    } else if (noteType == Constants.TASKS) {
      return executeCommandForwardMessage(context);
    } else {
      context.getRequest().setAttribute(
          "Error", new Exception("Programming Error: Please check code"));
      return "SystemError";
    }
  }
  

  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandForwardMessage(ActionContext context) {
    Connection db = null;
    int myId = -1;
    CFSNote newNote = null;
    PagedListInfo inboxInfo = this.getPagedListInfo(context, "InboxInfo");
    if (!(hasPermission(context, "myhomepage-inbox-view"))) {
      return ("PermissionError");
    }
    String forward = context.getRequest().getParameter("return");
    if (forward != null && !"".equals(forward.trim())) {
      context.getRequest().setAttribute("return",forward);
    }
    context.getSession().removeAttribute("selectedContacts");
    context.getSession().removeAttribute("finalContacts");
    SystemStatus systemStatus = this.getSystemStatus(context);
      try {
      String msgId = context.getRequest().getParameter("id");
      int noteType = Integer.parseInt(
          context.getRequest().getParameter("forwardType"));
      context.getRequest().setAttribute("forwardType", "" + noteType);
      db = this.getConnection(context);
      newNote = new CFSNote();
      if (noteType == Constants.CFSNOTE) {
        // For a sent message myId is a user_id else its a contactId
        if (inboxInfo.getListView().equals("sent")) {
          myId = getUserId(context);
        } else {
          myId = ((UserBean) context.getSession().getAttribute("User")).getUserRecord().getContact().getId();
        }
        newNote = new CFSNote(
            db, Integer.parseInt(msgId), myId, inboxInfo.getListView());
        HashMap recipients = newNote.buildRecipientList(db);
        Iterator i = recipients.keySet().iterator();
        StringBuffer recipientList = new StringBuffer();
        while (i.hasNext()) {
          Object st = i.next();
          recipientList.append(st);
          if (i.hasNext()) {
            recipientList.append(",");
          }
        }
        String originalMessage = systemStatus.getLabel("mail.label.originalMessage");
        String from = systemStatus.getLabel("mail.label.from");
        String fwd = systemStatus.getLabel("mail.label.forward");
        String sent = systemStatus.getLabel("mail.label.sent");
        String to = systemStatus.getLabel("mail.label.to");
        String subject = systemStatus.getLabel("mail.label.subject.colon");
        newNote.setSubject(fwd + StringUtils.toString(newNote.getSubject()));
        newNote.setBody(
            originalMessage +
            from + StringUtils.toString(newNote.getSentName()) + "\n" +
            sent + DateUtils.getServerToUserDateTimeString(
                this.getUserTimeZone(context), DateFormat.SHORT, DateFormat.LONG, newNote.getEntered()) + "\n" +
            to + recipientList.toString() + "\n" +
            subject + StringUtils.toString(newNote.getSubject()) +
            "\n\n" +
            StringUtils.toString(newNote.getBody()) + "\n\n");
      } else if (noteType == Constants.TASKS) {
        Task thisTask = new Task(db, Integer.parseInt(msgId));
        context.getRequest().setAttribute("TaskId", msgId);
        String userName = ((UserBean) context.getSession().getAttribute(
            "User")).getUserRecord().getContact().getNameLastFirst();
        String taskDetails = systemStatus.getLabel("mail.label.taskDetails");
        String task = systemStatus.getLabel("mail.label.task");
        String from = systemStatus.getLabel("mail.label.from");
        String dueDate = systemStatus.getLabel("mail.label.dueDate");
        String relevantNotes = systemStatus.getLabel("mail.label.relevantNotes");
        newNote.setBody(
            taskDetails + "\n" +
            task + StringUtils.toString(thisTask.getDescription()) + "\n" +
            from + StringUtils.toString(userName) + "\n" +
            dueDate + (thisTask.getDueDate() != null ? DateUtils.getServerToUserDateString(
                this.getUserTimeZone(context), DateFormat.SHORT, thisTask.getDueDate()) : "-NA-") + "\n" +
            ("".equals(thisTask.getNotes()) ? "" : relevantNotes + StringUtils.toString(
                thisTask.getNotes())) + "\n\n");
      }
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    if (context.getAction().getActionName().equals("MyCFSInbox")) {
      addModuleBean(context, "My Inbox", "");
    } else if (context.getAction().getActionName().equals("LeadsCallsForward")) {
      addModuleBean(context, "View Opportunities", "Opportunity Activities");
    } else {
      addModuleBean(context, "My Tasks", "Forward Message");
    }
    context.getRequest().setAttribute("Note", newNote);
    return ("ForwardMessageOK");
  }


  /**
   * Sends a reply to a message
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandReplyToMessage(ActionContext context) {
    Connection db = null;
    CFSNote newNote = null;
    PagedListInfo inboxInfo = this.getPagedListInfo(context, "InboxInfo");
    if (!(hasPermission(context, "myhomepage-inbox-view"))) {
      return ("PermissionError");
    }
    SystemStatus systemStatus = this.getSystemStatus(context);
    String originalMessage = systemStatus.getLabel("mail.label.originalMessage");
    String from = systemStatus.getLabel("mail.label.from");
    String sent = systemStatus.getLabel("mail.label.sent");
    String to = systemStatus.getLabel("mail.label.to");
    String subject = systemStatus.getLabel("mail.label.subject.colon");
    String reply = systemStatus.getLabel("mail.label.reply");
    try {
      int noteType = Integer.parseInt(
          context.getRequest().getParameter("forwardType"));
      context.getRequest().setAttribute("forwardType", "" + Constants.CFSNOTE);
      String msgId = context.getRequest().getParameter("id");
      db = this.getConnection(context);

      int myId = -1;
      if (inboxInfo.getListView().equals("sent")) {
        myId = getUserId(context);
      } else {
        myId = ((UserBean) context.getSession().getAttribute("User")).getUserRecord().getContact().getId();
      }
      String listView = inboxInfo.getListView();
      newNote = new CFSNote(db, Integer.parseInt(msgId), myId, listView);
      HashMap recipients = newNote.buildRecipientList(db);
      Iterator i = recipients.keySet().iterator();
      StringBuffer recipientList = new StringBuffer();
      while (i.hasNext()) {
        Object st = i.next();
        recipientList.append(st);
        if (i.hasNext()) {
          recipientList.append(",");
        }
      }
      newNote.setSubject(reply + StringUtils.toString(newNote.getSubject()));
      newNote.setBody(
          originalMessage +
          from + StringUtils.toString(newNote.getSentName()) + "\n" +
          sent + DateUtils.getServerToUserDateTimeString(
              this.getUserTimeZone(context), DateFormat.SHORT, DateFormat.LONG, newNote.getEntered()) + "\n" +
          to + recipientList.toString() + "\n" +
          subject + StringUtils.toString(newNote.getSubject()) +
          "\n\n" +
          StringUtils.toString(newNote.getBody()) + "\n\n");

      //add the sender as a recipient
      User sender = this.getUser(context, newNote.getReplyId());
      
      
      Contact recipient = systemStatus.getUser(sender.getId()).getContact(); ;//new Contact(db, sender.getContactId());
      
      context.getRequest().setAttribute("Recipient", recipient);
      
      //Add the recipient to the selectedList
      HashMap thisList = null;
      if (context.getSession().getAttribute("finalContacts") != null) {
        thisList = (HashMap) context.getSession().getAttribute(
            "finalContacts");
        thisList.clear();
      } else {
        thisList = new HashMap();
        context.getSession().setAttribute("finalContacts", thisList);
      }
      String recipientEmail = recipient.getPrimaryEmailAddress();
      thisList.put(new Integer(sender.getContactId()), recipientEmail);
      if (context.getSession().getAttribute("selectedContacts") != null) {
        HashMap tmp = (HashMap) context.getSession().getAttribute(
            "selectedContacts");
        tmp.clear();
      }
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    } finally {
      this.freeConnection(context, db);
    }
    addModuleBean(context, "MyInbox", "Message Reply");
    context.getRequest().setAttribute("Note", newNote);
    return getReturn(context, "ReplyMessage");
  }


  /**
   * Takes a look at the User Session Object and prepares the MyCFSBean for the
   * JSP. The bean will contain all the information that the JSP can see.
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   * @since 1.1
   */
  public String executeCommandHome(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-dashboard-view"))) {
      return ("PermissionError");
    }
    addModuleBean(context, "Home", "");
    if (getUserId(context) == 0) {
      return ("MaintenanceModeOK");
    }
    UserBean thisUser = (UserBean) context.getSession().getAttribute("User");
    User thisRec = thisUser.getUserRecord();

    //this is how we get the multiple-level heirarchy...recursive function.
    UserList shortChildList = thisRec.getShortChildList();
    UserList newUserList = thisRec.getFullChildList(
        shortChildList, new UserList());
    newUserList = UserList.sortEnabledUsers(newUserList, new UserList());
    newUserList.setMyId(getUserId(context));
    newUserList.setMyValue(thisUser.getContact().getNameLastFirst());
    newUserList.setIncludeMe(true);
    newUserList.setJsEvent(
        "onChange = \"javascript:fillFrame('calendar','MyCFS.do?command=MonthView&source=Calendar&userId='+document.getElementById('userId').value); javascript:fillFrame('calendardetails','MyCFS.do?command=Alerts&source=CalendarDetails&userId='+document.getElementById('userId').value);javascript:changeDivContent('userName','Scheduled Actions for ' + document.getElementById('userId').options[document.getElementById('userId').selectedIndex].firstChild.nodeValue);\"");
    HtmlSelect userListSelect = newUserList.getHtmlSelectObj(
        "userId", getUserId(context));
    userListSelect.addAttribute("id", "userId");
    context.getRequest().setAttribute("NewUserList", userListSelect);

    SystemStatus systemStatus = this.getSystemStatus(context);
    CalendarBean calendarInfo = (CalendarBean) context.getSession().getAttribute(
        "CalendarInfo");
    if (calendarInfo == null) {
      calendarInfo = new CalendarBean(thisRec.getLocale());
      if (hasPermission(context, "myhomepage-tasks-view")) {
        calendarInfo.addAlertType(
            "Task", "org.aspcfs.modules.tasks.base.TaskListScheduledActions", systemStatus.getLabel(
                "calendar.Tasks"));
      }
      if (hasPermission(context, "contacts-external_contacts-calls-view") || hasPermission(
          context, "accounts-accounts-contacts-calls-view")) {
        calendarInfo.addAlertType(
            "Call", "org.aspcfs.modules.contacts.base.CallListScheduledActions", systemStatus.getLabel(
                "calendar.Activities"));
      }
      if (hasPermission(context, "projects-projects-view")) {
        calendarInfo.addAlertType(
            "Project", "com.zeroio.iteam.base.ProjectListScheduledActions", systemStatus.getLabel(
                "calendar.Projects"));
      }
      if (hasPermission(context, "accounts-accounts-view")) {
        calendarInfo.addAlertType(
            "Accounts", "org.aspcfs.modules.accounts.base.AccountsListScheduledActions", systemStatus.getLabel(
                "calendar.Accounts"));
      }
      if (hasPermission(
          context, "contacts-external_contacts-opportunities-view") || hasPermission(
              context, "pipeline-opportunities-view")) {
        calendarInfo.addAlertType(
            "Opportunity", "org.aspcfs.modules.pipeline.base.OpportunityListScheduledActions", systemStatus.getLabel(
                "calendar.Opportunities"));
      }
      if (hasPermission(context, "products-view")) {
        calendarInfo.addAlertType(
            "Quote", "org.aspcfs.modules.quotes.base.QuotesListScheduledActions", systemStatus.getLabel(
                "calendar.Quotes"));
      }
      if (hasPermission(context, "products-view") || hasPermission(
          context, "tickets-tickets-view")) {
        calendarInfo.addAlertType(
            "Ticket", "org.aspcfs.modules.troubletickets.base.TicketListScheduledActions", systemStatus.getLabel(
                "calendar.Tickets"));
      }
      if (hasPermission(context, "projects-projects-view")) {
        calendarInfo.addAlertType(
            "Project Ticket", "org.aspcfs.modules.troubletickets.base.ProjectTicketListScheduledActions", systemStatus.getLabel(
                "calendar.projectTickets"));
      }
      context.getSession().setAttribute("CalendarInfo", calendarInfo);
    } else {
      calendarInfo.setSelectedUserId(-1);
    }
    return "HomeOK";
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandAlerts(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-dashboard-view"))) {
      return ("PermissionError");
    }
    Connection db = null;
    addModuleBean(context, "Home", "");
    CalendarBean calendarInfo = null;
    CalendarView companyCalendar = null;

    String returnPage = context.getRequest().getParameter("return");
    calendarInfo = (CalendarBean) context.getSession().getAttribute(
        returnPage != null ? returnPage + "CalendarInfo" : "CalendarInfo");

    try {
      db = this.getConnection(context);
      calendarInfo.update(db, context);
      int userId = this.getUserId(context);
      User thisUser = this.getUser(context, userId);
      // Use the user's locale
      companyCalendar = new CalendarView(calendarInfo, thisUser.getLocale());
      companyCalendar.setSystemStatus(this.getSystemStatus(context));
      companyCalendar.addHolidays();
      
      //check if the user's account is expiring
      if (context.getRequest().getParameter("userId") != null) {
        userId = Integer.parseInt(context.getRequest().getParameter("userId"));
        if (userId == this.getUserId(context)) {
          Integer tmpUserId = (Integer) context.getSession().getAttribute(
              "calendarUserId");
          if (tmpUserId != null) {
            context.getSession().removeAttribute("calendarUserId");
          }
        } else {
          context.getSession().setAttribute(
              "calendarUserId", new Integer(userId));
        }
      } else if (context.getSession().getAttribute("calendarUserId") != null) {
        userId = ((Integer) context.getSession().getAttribute(
            "calendarUserId")).intValue();
      }
      if (thisUser.getExpires() != null) {
        String expiryDate = DateUtils.getServerToUserDateString(
            this.getUserTimeZone(context), DateFormat.SHORT, thisUser.getExpires());
        companyCalendar.addEvent(
            expiryDate, CalendarEventList.EVENT_TYPES[9], "Your user login expires");
      }

      //create events depending on alert type
      String selectedAlertType = calendarInfo.getCalendarDetailsView();
      String param1 = "org.aspcfs.utils.web.CalendarView";
      String param2 = "java.sql.Connection";
      ArrayList alertTypes = calendarInfo.getAlertTypes();
      for (int i = 0; i < alertTypes.size(); i++) {
        AlertType thisAlert = (AlertType) alertTypes.get(i);
        Object thisInstance = Class.forName(thisAlert.getClassName()).newInstance();
        if (selectedAlertType.equalsIgnoreCase("all") || selectedAlertType.toLowerCase().equals(
            (thisAlert.getName().toLowerCase()))) {

          //set module
          Method method = Class.forName(thisAlert.getClassName()).getMethod(
              "setModule", new Class[]{Class.forName(
                  "org.aspcfs.modules.actions.CFSModule")});
          method.invoke(thisInstance, new Object[]{(CFSModule) this});

          //set action context
          method = Class.forName(thisAlert.getClassName()).getMethod(
              "setContext", new Class[]{Class.forName(
                  "com.darkhorseventures.framework.actions.ActionContext")});
          method.invoke(thisInstance, new Object[]{context});

          //set userId
          method = Class.forName(thisAlert.getClassName()).getMethod(
              "setUserId", new Class[]{Class.forName("java.lang.String")});
          method.invoke(thisInstance, new Object[]{String.valueOf(userId)});

          //set Start and End Dates
          method = Class.forName(thisAlert.getClassName()).getMethod(
              "setAlertRangeStart", new Class[]{Class.forName(
                  "java.sql.Timestamp")});
          

          method = Class.forName(thisAlert.getClassName()).getMethod(
              "setAlertRangeEnd", new Class[]{Class.forName(
                  "java.sql.Timestamp")});
          

          //Add Events
          method = Class.forName(thisAlert.getClassName()).getMethod(
              "buildAlerts", new Class[]{Class.forName(param1), Class.forName(
                  param2)});
          method.invoke(thisInstance, new Object[]{companyCalendar, db});
          if (!selectedAlertType.equalsIgnoreCase("all")) {
            break;
          }
        }
      }
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return "SystemError";
    } finally {
      this.freeConnection(context, db);
    }
    context.getRequest().setAttribute("CompanyCalendar", companyCalendar);
    return "CalendarDetailsOK";
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandMonthView(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-dashboard-view"))) {
      return ("PermissionError");
    }
    Connection db = null;
    CalendarBean calendarInfo = null;
    CalendarView companyCalendar = null;
    addModuleBean(context, "Home", "");
    String returnPage = context.getRequest().getParameter("return");
    String beanName = (returnPage != null ? returnPage + "CalendarInfo" : "CalendarInfo");
    calendarInfo = (CalendarBean) context.getSession().getAttribute(beanName);
    if (calendarInfo == null) {
      calendarInfo = new CalendarBean(
          this.getUser(context, this.getUserId(context)).getLocale());
      context.getSession().setAttribute(beanName, calendarInfo);
    }
    try {
      db = this.getConnection(context);
      calendarInfo.update(db, context);
      int userId = this.getUserId(context);
      User thisUser = this.getUser(context, userId);
      // Use the user's locale
      companyCalendar = new CalendarView(calendarInfo, thisUser.getLocale());
      companyCalendar.setSystemStatus(this.getSystemStatus(context));
      // check if user account is expiring
      if (context.getRequest().getParameter("userId") != null) {
        userId = Integer.parseInt(context.getRequest().getParameter("userId"));
        if (userId == this.getUserId(context)) {
          Integer tmpUserId = (Integer) context.getSession().getAttribute(
              "calendarUserId");
          if (tmpUserId != null) {
            context.getSession().removeAttribute("calendarUserId");
          }
        } else {
          context.getSession().setAttribute(
              "calendarUserId", new Integer(userId));
        }
      } else if (context.getSession().getAttribute("calendarUserId") != null) {
        userId = ((Integer) context.getSession().getAttribute(
            "calendarUserId")).intValue();
      }
      if (thisUser.getExpires() != null) {
        String expiryDate = DateUtils.getServerToUserDateString(
            this.getUserTimeZone(context), DateFormat.SHORT, thisUser.getExpires());
        companyCalendar.addEventCount(
            CalendarEventList.EVENT_TYPES[9], expiryDate, new Integer(1));
      }

      User selectedUser = new User();
      selectedUser.setBuildContact(true);
      context.getRequest().setAttribute("SelectedUser", selectedUser);
      
      //Use reflection to invoke methods on scheduler classes
      String param1 = "org.aspcfs.utils.web.CalendarView";
      String param2 = "java.sql.Connection";
      ArrayList alertTypes = calendarInfo.getAlertTypes();
      for (int i = 0; i < alertTypes.size(); i++) {
        AlertType thisAlert = (AlertType) alertTypes.get(i);
        Object thisInstance = Class.forName(thisAlert.getClassName()).newInstance();

        //set module
        Method method = Class.forName(thisAlert.getClassName()).getMethod(
            "setModule", new Class[]{Class.forName(
                "org.aspcfs.modules.actions.CFSModule")});
        method.invoke(thisInstance, new Object[]{(CFSModule) this});

        //set action context
        method = Class.forName(thisAlert.getClassName()).getMethod(
            "setContext", new Class[]{Class.forName(
                "com.darkhorseventures.framework.actions.ActionContext")});
        method.invoke(thisInstance, new Object[]{context});

        //set userId
        method = Class.forName(thisAlert.getClassName()).getMethod(
            "setUserId", new Class[]{Class.forName("java.lang.String")});
        method.invoke(thisInstance, new Object[]{String.valueOf(userId)});

        //set Start and End Dates
              //Add Events
        method = Class.forName(thisAlert.getClassName()).getMethod(
            "buildAlertCount", new Class[]{Class.forName(param1), Class.forName(
                param2)});
        method.invoke(thisInstance, new Object[]{companyCalendar, db});
      }
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return "SystemError";
    } finally {
      this.freeConnection(context, db);
    }
    context.getRequest().setAttribute("CompanyCalendar", companyCalendar);
    return "CalendarOK";
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandDayView(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-dashboard-view"))) {
      return ("PermissionError");
    }
    CalendarBean calendarInfo = null;
    addModuleBean(context, "Home", "");
    String returnPage = context.getRequest().getParameter("return");
    calendarInfo = (CalendarBean) context.getSession().getAttribute(
        returnPage != null ? returnPage + "CalendarInfo" : "CalendarInfo");
    calendarInfo.setCalendarView("day");
    calendarInfo.resetParams("day");
    return executeCommandAlerts(context);
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandTodaysView(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-dashboard-view"))) {
      return ("PermissionError");
    }
    CalendarBean calendarInfo = null;
    addModuleBean(context, "Home", "");
    String returnPage = context.getRequest().getParameter("return");
    calendarInfo = (CalendarBean) context.getSession().getAttribute(
        returnPage != null ? returnPage + "CalendarInfo" : "CalendarInfo");
    Calendar cal = Calendar.getInstance();
    cal.setTimeZone(calendarInfo.getTimeZone());
    calendarInfo.setCalendarView("day");
    calendarInfo.resetParams("day");
    calendarInfo.setPrimaryMonth(cal.get(Calendar.MONTH) + 1);
    calendarInfo.setPrimaryYear(cal.get(Calendar.YEAR));
    return executeCommandAlerts(context);
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandWeekView(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-profile-view"))) {
      return ("PermissionError");
    }
    addModuleBean(context, "Home", "");
    CalendarBean calendarInfo = null;
    String returnPage = context.getRequest().getParameter("return");
    calendarInfo = (CalendarBean) context.getSession().getAttribute(
        returnPage != null ? returnPage + "CalendarInfo" : "CalendarInfo");
    calendarInfo.setCalendarView("week");
    calendarInfo.resetParams("week");
    return executeCommandAlerts(context);
  }


  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandAgendaView(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-dashboard-view"))) {
      return ("PermissionError");
    }
    addModuleBean(context, "Home", "");
    CalendarBean calendarInfo = null;
    String returnPage = context.getRequest().getParameter("return");
    calendarInfo = (CalendarBean) context.getSession().getAttribute(
        returnPage != null ? returnPage + "CalendarInfo" : "CalendarInfo");
    calendarInfo.setAgendaView(true);
    calendarInfo.resetParams("agenda");
    return executeCommandAlerts(context);
  }


  /**
   * Displays a list of profile items the user can select to modify
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandMyProfile(ActionContext context) {
    if (!(hasPermission(context, "myhomepage-profile-view"))) {
      return ("PermissionError");
    }
    addModuleBean(context, "MyProfile", "");
    return ("MyProfileOK");
  }


  /**
   * The user wants to modify their name, etc.
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeCommandMyCFSProfile(ActionContext context) {
    if (!hasPermission(context, "myhomepage-profile-personal-view")) {
      return ("PermissionError");
    }
    Connection db = null;
    try {
      db = this.getConnection(context);
      SystemStatus systemStatus = this.getSystemStatus(context);
      context.getRequest().setAttribute("systemStatus", systemStatus);
      User thisUser = new User(db, this.getUserId(context));
      thisUser.setBuildContact(true);
      thisUser.setBuildContactDetails(true);
      ApplicationPrefs prefs = (ApplicationPrefs) context.getServletContext().getAttribute("applicationPrefs");
      StateSelect stateSelect = new StateSelect(systemStatus, thisUser.getContact().getAddressList().getCountries()+","+prefs.get("SYSTEM.COUNTRY"));
      stateSelect.setPreviousStates(thisUser.getContact().getAddressList().getSelectedStatesHashMap());
      context.getRequest().setAttribute("StateSelect", stateSelect);
      buildFormElements(context, db);
      context.getRequest().setAttribute("User", thisUser);
      context.getRequest().setAttribute("EmployeeBean", thisUser.getContact());
    } catch (Exception errorMessage) {
      context.getRequest().setAttribute("Error", errorMessage);
      return "SystemError";
    }
    this.freeConnection(context, db);
    addModuleBean(context, "MyProfile", "");
    return ("ProfileOK");
  }


  /**
   * The user's name was modified
   *
   * @param context Description of Parameter
   * @return Description of the Returned Value
   */
  


  /**

  /**
   * Description of the Method
   *
   * @param context Description of Parameter
   * @param db      Description of Parameter
   * @throws SQLException Description of Exception
   */

  protected void buildFormElements(ActionContext context, Connection db) throws SQLException {
    SystemStatus systemStatus = this.getSystemStatus(context);
    LookupList departmentList = new LookupList(db, "lookup_department");
    departmentList.addItem(0,  "-- SELEZIONA VOCE --");
    context.getRequest().setAttribute("DepartmentList", departmentList);

    LookupList phoneTypeList = new LookupList(db, "lookup_contactphone_types");
    context.getRequest().setAttribute("ContactPhoneTypeList", phoneTypeList);

    LookupList emailTypeList = new LookupList(db, "lookup_contactemail_types");
    context.getRequest().setAttribute("ContactEmailTypeList", emailTypeList);

    LookupList addressTypeList = new LookupList(
        db, "lookup_contactaddress_types");
    context.getRequest().setAttribute(
        "ContactAddressTypeList", addressTypeList);
    
    //Make the StateSelect and CountrySelect drop down menus available in the request. 
    //This needs to be done here to provide the SystemStatus to the constructors, otherwise translation is not possible
    
    StateSelect stateSelect = (StateSelect) context.getRequest().getAttribute("StateSelect");
    if (stateSelect == null) {
      stateSelect = new StateSelect(systemStatus);
      context.getRequest().setAttribute("StateSelect", stateSelect);
    }
    CountrySelect countrySelect = new CountrySelect(systemStatus);
    context.getRequest().setAttribute("CountrySelect", countrySelect);
  }
}

