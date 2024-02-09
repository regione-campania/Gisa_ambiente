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

import java.io.Serializable;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.TimeZone;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.DateUtils;

/**
 * @author     Kevin Duffey
 * @author     Matt Rajkowski
 * @created    Novemeber 19, 2000
 * @version    $Id: GenericBean.java,v 1.4.166.1 2004/07/29 19:49:44 kbhoopal
 *      Exp $
 */

public class GenericBean implements Serializable {
  protected HashMap errors = new HashMap();
  protected HashMap warnings = new HashMap();
  protected boolean onlyWarnings = false;
  protected String permission = null;

  private String message = "";
  private boolean displayMessage = false;
  private Object entity = null;
  private Object ejbRef = null;
  final static long serialVersionUID = 8345648404174283569L;
  private final static String[] HTMLChars = new String[]{"&", "\"", "<", ">"};
  private final static String[] HTMLRepl = new String[]{"&amp;", "&quot;", "&lt;", "&gt;"};

  //helper properties to disable some of the business login while in restore or offline mode
  protected boolean restore = false; //backup-restore
  protected boolean offline = false; //Concursive offline

  protected int altId ;
  protected int idStabilimento ;
  protected int idApiario ;
  protected int idAsl ;
  private int cessato = 0;
  
 

public void setCessato(int tmp) {
	    this.cessato = tmp;
	  }

  public int getIdApiario() {
	return idApiario;
}

public void setIdApiario(int idApiario) {
	this.idApiario = idApiario;
}

public void setCessato(String tmp) {
	    this.cessato = Integer.parseInt(tmp);
	  }
  public int getCessato() {
	    return cessato;
	  }
  private Vector comuni2=new Vector();
  public int getIdAsl() {
	return idAsl;
}
	private int tipo_opu_operatore ;
	
	
	
	
	
	public int getTipo_opu_operatore() {
		return tipo_opu_operatore;
	}

	public void setTipo_opu_operatore(int tipo_opu_operatore) {
		this.tipo_opu_operatore = tipo_opu_operatore;
	}

public Vector getComuni2() {
	return comuni2;
}


public void setComuni2(Vector comuni2) {
	this.comuni2 = comuni2;
}


public void setIdAsl(int idAsl) {
	this.idAsl = idAsl;
}


public int getIdStabilimento() {
	return idStabilimento;
}


public void setIdStabilimento(int idStabilimento) {
	this.idStabilimento = idStabilimento;
}
public void setIdStabilimento(String idStabilimento) {
	if (idStabilimento != null && ! "".equals(idStabilimento))
	this.idStabilimento = Integer.parseInt(idStabilimento);
}

public int getAltId() {
	return altId;
}


public void setAltId(int altId) {
	this.altId = altId;
}
public void setAltId(String altId) {
	if (altId != null && ! "".equals(altId))
	this.altId = Integer.parseInt(altId);
}

/**
   *  Gets the restore attribute of the GenericBean object
   *
   * @return    The restore value
   */
  public boolean getRestore() {
    return restore;
  }


  /**
   *  Sets the restore attribute of the GenericBean object
   *
   * @param  tmp  The new restore value
   */
  public void setRestore(boolean tmp) {
    this.restore = tmp;
  }


  /**
   *  Sets the restore attribute of the GenericBean object
   *
   * @param  tmp  The new restore value
   */
  public void setRestore(String tmp) {
    this.restore = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Gets the offline attribute of the GenericBean object
   *
   * @return    The offline value
   */
  public boolean getOffline() {
    return offline;
  }


  /**
   *  Sets the offline attribute of the GenericBean object
   *
   * @param  tmp  The new offline value
   */
  public void setOffline(boolean tmp) {
    this.offline = tmp;
  }


  /**
   *  Sets the offline attribute of the GenericBean object
   *
   * @param  tmp  The new offline value
   */
  public void setOffline(String tmp) {
    this.offline = DatabaseUtils.parseBoolean(tmp);
  }



  /**
   *  Creates new DefaultBean
   *
   * @since    1.1
   */
  public GenericBean() { }


  /**
   *  Sets the entity that this bean (or descendant of this bean) will use as
   *  its internal entity type
   *
   * @param  value  The new Entity value
   * @since         1.1
   */
  public void setEntity(Object value) {
    entity = value;
  }


  /**
   *  Set the EJB Reference
   *
   * @param  o  The new EjbRef value
   * @since     1.1
   */
  public void setEjbRef(Object o) {
    ejbRef = o;
  }


  /**
   *  Used to set a bean message that can be used in JSP pages that are being
   *  used as part of an XSL transformation. This is done because request
   *  attributes are not passed on to the JSP page. Therefore the bean must keep
   *  track of the message.
   *
   * @param  value  The new Message value
   * @since         1.1
   */
  public void setMessage(String value) {
    displayMessage = true;
    // lets the getMessage() method know its ok to display this message
    message = value;
  }


  /**
   *  Returns this bean's (or descendant bean's) entity reference (Whether it be
   *  EJB or a core class)
   *
   * @return    The Entity value
   * @since     1.1
   */
  public Object getEntity() {
    return entity;
  }


  /**
   *  Returns the EJB reference if one is used
   *
   * @return    The EjbRef value
   * @since     1.1
   */
  public Object getEjbRef() {
    return ejbRef;
  }


  /**
   *  Returns a message if one exists, otherwise its an empty string. Because
   *  this is a session scope object, we need a way to return this message only
   *  once, unless the flag is set again. Every time the flag is set, we return
   *  the message and also reset the flag. If its not set, we don't return the
   *  message, even if a call to getMessage() is made. This way, only one
   *  message per request is displayed. Also, we reset the message back to "" if
   *  the flag is not set and the getMessage() call is made.
   *
   * @return    The Message value
   * @since     1.1
   */
  public String getMessage() {
    if (displayMessage) {
      displayMessage = false;
    } else {
      message = "";
    }

    return message;
  }


  /**
   *  Gets the Errors attribute of the GenericBean object<p>
   *
   *  <p/>
   *
   *  The HashMap is used for form validation when errors need to be presented
   *  in the resulting JSP
   *
   * @return    The Errors value
   * @since     1.4
   */
  public HashMap getErrors() {
    return errors;
  }


  /**
   *  Returns whether the object has added any errors to the error HashMap
   *
   * @return    Description of the Returned Value
   * @since     1.4
   */
  public boolean hasErrors() {
    return (errors.size() > 0);
  }


  /**
   *  Gets the warnings attribute of the GenericBean object
   *
   * @return    The warnings value
   */
  public HashMap getWarnings() {
    return warnings;
  }


  /**
   *  Returns whether the object has added any warnings to the warning HashMap
   *
   * @return    Description of the Return Value
   */
  public boolean hasWarnings() {
    return (warnings.size() > 0);
  }


  /**
   *  Sets the onlyWarnings attribute of the GenericBean object
   *
   * @param  tmp  The new onlyWarnings value
   */
  public void setOnlyWarnings(boolean tmp) {
    this.onlyWarnings = tmp;
  }


  /**
   *  Sets the onlyWarnings attribute of the GenericBean object
   *
   * @param  tmp  The new onlyWarnings value
   */
  public void setOnlyWarnings(String tmp) {
    this.onlyWarnings = "on".equalsIgnoreCase(tmp);
  }


  /**
   *  Gets the onlyWarnings attribute of the GenericBean object
   *
   * @return    The onlyWarnings value
   */
  public boolean getOnlyWarnings() {
    return onlyWarnings;
  }


  /**
   *  Returns a decoded HTML string that replaces & with &amp; < with &lt; >
   *  with &gt; and " with &quot; Just make sure if you want to replace a single
   *  character that also appears in another position of a replacement string,
   *  you will end up replacing the replaced string unless it is first in the
   *  list. For example, & = &amp; " = &quot; If you replace " first, then &,
   *  all the &quot; that were replaced will now appear in the final string as
   *  &amp;quot; because the & of the &quot; was replaced with &amp; since the &
   *  replacement started "after" the " replacement did.
   *
   * @param  value  Description of Parameter
   * @return        Description of the Returned Value
   * @since         1.1
   */
  public final static String decodeHtml(String value) {
    return decode(value, HTMLChars, HTMLRepl);
  }


  /**
   *  Description of the Method
   *
   * @param  value  Description of Parameter
   * @return        Description of the Returned Value
   * @since         1.1
   */
  public final static String decode(String value) {
    // if the input is null, no need to go further.
    if (value == null) {
      return null;
    }

    // if the input doesn't have any & " > <, no need to create a new object and go further
    if ((value.indexOf('&') > -1) || (value.indexOf('"') > -1) || (value.indexOf(
        '<') > -1) || (value.indexOf('>') > -1)) {
      StringBuffer sb = new StringBuffer();
      int sze = value.length();

      for (int cntr = 0; cntr < sze; cntr++) {
        char c = value.charAt(cntr);

        switch (c) {
            case '&':
              sb.append("&amp;");
              break;
            case '"':
              sb.append("&quot;");
              break;
            case '<':
              sb.append("&lt;");
              break;
            case '>':
              sb.append("&gt;");
              break;
            default:
              sb.append(c);
        }
      }

      return sb.toString();
    }

    return value;
  }


  /**
   *  Returns a string that has any strings matching the chars[] array with
   *  those in the repl[] array element at the same element the match was found
   *  in the chars[] array
   *
   * @param  value  Description of Parameter
   * @param  chars  Description of Parameter
   * @param  repl   Description of Parameter
   * @return        Description of the Returned Value
   * @since         1.1
   */
  public final static String decode(String value, String[] chars, String[] repl) {
    // return null if the value, chars[], repl[] are null or the number
    // of elemetns of the chars[] and repl[] are not the same.
    if (value == null || chars == null || repl == null || chars.length != repl.length) {
      return null;
    }

    int sze = chars.length;
    StringBuffer sb = new StringBuffer(value);
    for (int cntr = 0; cntr < sze; cntr++) {
      int curPos = 0;
      int oldPos = 0;

      while ((curPos = sb.toString().indexOf(chars[cntr], oldPos)) > -1) {
        // found a match, so replace this occurrence of the string
        // with the same element in the repl[] array
        sb.replace(curPos, curPos + chars[cntr].length(), repl[cntr]);
        oldPos = curPos + chars[cntr].length() + 1;
      }
    }

    return sb.toString();
  }


  /**
   *  Converts a string to a date object
   *
   * @param  thisString  Description of Parameter
   * @param  dateFormat  Description of the Parameter
   * @return             Description of the Returned Value
   * @since              1.5
   */
  public final static java.util.Date convertStringToDate(String thisString, int dateFormat) {
    java.util.Date thisDate = null;
    try {
      thisDate = java.text.DateFormat.getDateInstance(dateFormat).parse(
          thisString);
    } catch (java.text.ParseException pe) {
    }
    return thisDate;
  }


  /**
   *  Converts a string to a SQLDate object
   *
   * @param  thisString  Description of Parameter
   * @param  dateFormat  Description of the Parameter
   * @return             Description of the Returned Value
   * @since              1.5
   */
  public final static java.sql.Date convertStringToSqlDate(String thisString, int dateFormat) {
    java.util.Date thisDate = null;
    try {
      thisDate = java.text.DateFormat.getDateInstance(dateFormat).parse(
          thisString);
      return new java.sql.Date(thisDate.getTime());
    } catch (java.text.ParseException pe) {
    }
    return null;
  }


  /**
   *  Rounds a float to the specified decimal places
   *
   * @param  x         Description of the Parameter
   * @param  decimals  Description of the Parameter
   * @return           Description of the Returned Value
   * @since            1.6
   */
  public final static double round(double x, int decimals) {
    // rounds to the nearest integer
    int factor = 1;
    for (int i = 0; i < Math.abs(decimals); i++) {
      factor *= 10;
    }
    if (decimals < 0) {
      return factor * Math.rint(x / factor);
    } else {
      return Math.rint(factor * x) / factor;
    }
  }


  /**
   *  Converts dates based on the time zone. This method is called when the
   *  autopopulate does not have access to the attributes through the bean. This
   *  method also considers the time of day component if provided to determine
   *  the date and time.
   *
   * @param  request                    Description of the Parameter
   * @param  value                      Description of the Parameter
   * @param  param                      Description of the Parameter
   * @throws  java.text.ParseException  Description of the Exception
   */
  protected void sanitizeDate(HttpServletRequest request, String value, String param) throws java.text.ParseException {
    String field = param;
    try {
      UserBean userBean = (UserBean) request.getSession().getAttribute("User");
      User user = userBean.getUserRecord();
      param = param.substring(0, 1).toUpperCase() + param.substring(1);
      String timeZone = user.getTimeZone();

      Class[] argTypes = null;
      Method method = null;
      Timestamp tmp = null;
      try {
        method = this.getClass().getMethod(
            "get" + param + "TimeZone", argTypes);
        timeZone = (String) method.invoke(this, (java.lang.Object[]) null);
      } catch (NoSuchMethodException nme) {
      }

      String hourValue = (String) request.getParameter(field + "Hour");
      if (hourValue == null) {
        // check for date field only
        tmp = DateUtils.getUserToServerDateTime(
            TimeZone.getTimeZone(timeZone), DateFormat.SHORT, DateFormat.LONG, value, user.getLocale());
      } else {
        // check for timeofday fields in the request and update the timestamp
        Timestamp timestamp = DatabaseUtils.parseDateToTimestamp(
            value, user.getLocale());
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(timestamp.getTime());
        int hour = Integer.parseInt((String) request.getParameter(field + "Hour"));
        int minute = Integer.parseInt((String) request.getParameter(field + "Minute"));
        if (request.getParameter(field + "AMPM") != null) {
          int ampm = Integer.parseInt((String) request.getParameter(field
              + "AMPM"));
          if (ampm == Calendar.AM) {
            if (hour == 12) {
              hour = 0;
            }
          } else {
            if (hour < 12) {
              hour += 12;
            }
          }
        }

        cal.set(Calendar.HOUR_OF_DAY, hour);
        cal.set(Calendar.MINUTE, minute);
        cal.setTimeZone(TimeZone.getTimeZone(timeZone));

        tmp = new Timestamp(cal.getTimeInMillis());
      }
      argTypes = new Class[]{tmp.getClass()};
      method = this.getClass().getMethod("set" + param, argTypes);
      method.invoke(this, new Object[]{tmp});
    } catch (Exception e) {
      throw new java.text.ParseException("invalid date", 1);
    }
    
  }


  /**
   *  Sets the timeZoneForDateFields attribute of the GenericBean object
   *
   * @param  request  The new timeZoneForDateFields value
   * @param  value    The new timeZoneForDateFields value
   * @param  field    The new timeZoneForDateFields value
   */
  public void setTimeZoneForDateFields(HttpServletRequest request, String value, String field) {
    try {
      if ((value != null) && (!"".equals(value))) {
        sanitizeDate(request, value, field);
      }
    } catch (Exception e) {
      errors.put(field + "Error", "invalid date");
    }
  }


  /**
   *  Gets the fileLibraryPath attribute of the GenericBean object
   *
   * @param  basePath          Description of the Parameter
   * @param  moduleFolderName  Description of the Parameter
   * @return                   The fileLibraryPath value
   */
  public static final String getFileLibraryPath(String basePath, String moduleFolderName) {
    if (basePath.indexOf(moduleFolderName) == -1) {
      return (basePath + moduleFolderName + System.getProperty(
          "file.separator"));
    } else {
      return basePath;
    }
  }
  
  public void setComuni2 (Connection db, int codeUser) throws SQLException {

		Statement st = null;
		ResultSet rs = null;
		StringBuffer sql = new StringBuffer();

		//sql.append("select comune from comuni where codiceistatasl= (select codiceistat from lookup_site_id where code= (select site_id from organization where org_id="+ this.getOrgId() + "))");

		sql.append("select comune from comuni where notused is null and  codiceistatasl in (select codiceistat from lookup_site_id where 1=1");

		if(codeUser!=-1 && codeUser!=0)
			sql.append("  and code= "+ codeUser + ") order by comune");
		else
			sql.append(") order by comune");
		//sql.append("select comune from comuni");

		st = db.createStatement();
		rs = st.executeQuery(sql.toString());

		while (rs.next()) {
			comuni2.add(rs.getString("comune"));
		}
		rs.close();
		st.close();

	}
  
  
 
  
  public void setComuni2 (Connection db) throws SQLException {
		
	  	Statement st = null;
	    ResultSet rs = null;
	    StringBuffer sql = new StringBuffer();
	    
	    //sql.append("select comune from comuni where codiceistatasl= (select codiceistat from lookup_site_id where code= (select site_id from organization where org_id="+ this.getOrgId() + "))");
	    //if(codeUser==-1){
	        sql.append("select comune from comuni where notused is null order by comune;");
	   /*}else{
	    sql.append("select comune from comuni where codiceistatasl= (select codiceistat from lookup_site_id where code= "+ codeUser + ")");
	    }*/
	    st = db.createStatement();
	    rs = st.executeQuery(sql.toString());
	    
	    while (rs.next()) {
	      comuni2.add(rs.getString("comune"));
	    }
	    rs.close();
	    st.close();
	  
	}

  public void setComuni2All (Connection db) throws SQLException {
		
	  	Statement st = null;
	    ResultSet rs = null;
	    StringBuffer sql = new StringBuffer();
	    
	    //sql.append("select comune from comuni where codiceistatasl= (select codiceistat from lookup_site_id where code= (select site_id from organization where org_id="+ this.getOrgId() + "))");
	    //if(codeUser==-1){
	        sql.append("select nome from comuni1 where notused is null order by nome;");
	   /*}else{
	    sql.append("select comune from comuni where codiceistatasl= (select codiceistat from lookup_site_id where code= "+ codeUser + ")");
	    }*/
	    st = db.createStatement();
	    rs = st.executeQuery(sql.toString());
	    
	    while (rs.next()) {
	      comuni2.add(rs.getString("nome"));
	    }
	    rs.close();
	    st.close();
	  
	}
  
  public void setComuni2AllAsl (Connection db, int idAsl) throws SQLException {
		
	  	Statement st = null;
	    ResultSet rs = null;
	    StringBuffer sql = new StringBuffer();
	    
	    //sql.append("select comune from comuni where codiceistatasl= (select codiceistat from lookup_site_id where code= (select site_id from organization where org_id="+ this.getOrgId() + "))");
	    //if(codeUser==-1){
	        sql.append("select nome from comuni1 where notused is null and codiceistatasl='"+idAsl+"'order by nome;");
	   /*}else{
	    sql.append("select comune from comuni where codiceistatasl= (select codiceistat from lookup_site_id where code= "+ codeUser + ")");
	    }*/
	    st = db.createStatement();
	    rs = st.executeQuery(sql.toString());
	    
	    while (rs.next()) {
	      comuni2.add(rs.getString("nome"));
	    }
	    rs.close();
	    st.close();
	  
	}
  
  
  /**
   *  Gets the permission attribute of the GenericBean object
   *
   * @return    The permission value
   */
  public String getPermission() {
    return permission;
  }
  
  
  
}

