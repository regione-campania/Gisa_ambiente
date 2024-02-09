package org.aspcfs.controller;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Locale;
import java.util.StringTokenizer;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import org.aspcfs.modules.util.imports.ApplicationProperties;
import org.aspcfs.utils.ObjectUtils;

import com.darkhorseventures.framework.actions.ActionContext;
import com.zeroio.iteam.base.FileFolder;
import com.zeroio.iteam.base.FileItem;

/**
 * Description of the Class
 *
 * @author matt rajkowski
 * @version $Id: ObjectValidator.java,v 1.1.2.3 2004/09/08 16:37:11 partha
 *          Exp $
 * @created September 3, 2004
 */
public class ObjectValidator {

  private static int REQUIRED_FIELD = 2004090301;
  private static int IS_BEFORE_TODAY = 2004090302;
  private static int PUBLIC_ACCESS_REQUIRED = 2004090303;
  private static int INVALID_DATE = 2004090801;
  private static int INVALID_NUMBER = 2004091001;
  private static int INVALID_EMAIL = 2004091002;
  private static int INVALID_NOT_REQUIRED_DATE = 2004091003;
  private static int INVALID_EMAIL_NOT_REQUIRED = 2005060801;
  private static int PAST_DATE = 2006110117;
  private static int SIZE_FILE = 1048576 *3;
  
  
  public static int cuPregresso = -1 ;
  /**
   * Description of the Method
   *
   * @param systemStatus Description of the Parameter
   * @param db           Description of the Parameter
   * @param object       Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public static boolean validate(ActionContext ctx, SystemStatus systemStatus, Connection db, Object object) throws SQLException {
    if (System.getProperty("DEBUG") != null) {
      System.out.println(
          "ObjectValidator-> Checking object: " + object.getClass().getName());
    }
    boolean isValid = true ; 
    // TODO: use required fields and warnings from systemStatus; this might
    //       be a list of ValidationTasks that perform complex tasks

    // NOTE: For now, just code the validation tasks in

    // Organization
  
   
  
    if (object.getClass().getName() .equals("org.aspcfs.modules.vigilanza.base.Ticket"))
	  {}
    
    //  FileItem
    if (object.getClass().getName().equals("com.zeroio.iteam.base.FileItem")) {
      FileItem fileItem = (FileItem) object;
      checkError(systemStatus, object, "subject", REQUIRED_FIELD);
      checkError(systemStatus, object, "filename", REQUIRED_FIELD);
      if (fileItem.getLinkModuleId() == -1 || fileItem.getLinkItemId() == -1) {
        addError(systemStatus, object, "action", "object.validation.noId");
      }
    }

    //  FileFolder
    if (object.getClass().getName().equals("com.zeroio.iteam.base.FileFolder"))
    {
      FileFolder fileFolder = (FileFolder) object;
      if (fileFolder.getLinkModuleId() == -1 || fileFolder.getLinkItemId() == -1)
      {
        addError(systemStatus, object, "action", "object.validation.noId");
      }
      checkError(systemStatus, object, "subject", REQUIRED_FIELD);
      checkLength(systemStatus, object, "object.validation.exceedsLengthLimit", "subject", 255);
    }
    
  
	return isValid;
	
	
  
  }
  public static boolean validateInBacheca(SystemStatus systemStatus, Connection db, Object object) throws SQLException {
	  
	  boolean valid = true;
	  if (object.getClass().getName().equals("com.zeroio.iteam.base.FileItem")) {
	      FileItem fileItem = (FileItem) object;
	      checkError(systemStatus, object, "subject", REQUIRED_FIELD);
	      checkError(systemStatus, object, "filename", REQUIRED_FIELD);
	      String bacheca_abilitata = ApplicationProperties.getProperty("flagbacheca");
	      if(bacheca_abilitata.equalsIgnoreCase("si") && fileItem.getSize()>SIZE_FILE)
	      {
	    	  addError(systemStatus, object, "file_size", "object.validation.noExtension");
	    	  valid = false;
	      }
	     
	    	 
	    	
	      
	    }
	  return valid;
  }

  /**
   * Description of the Method
   *
   * @param systemStatus Description of the Parameter
   * @param db           Description of the Parameter
   * @param object       Description of the Parameter
   * @param map          Description of the Parameter
   * @return Description of the Return Value
   * @throws SQLException Description of the Exception
   */
  public static boolean validate( SystemStatus systemStatus, Connection db, Object object, HashMap map) throws SQLException {
    if (System.getProperty("DEBUG") != null) {
      System.out.println(
          "ObjectValidator-> Checking object: " + object.getClass().getName());
    }
    //  TicketReplacementPart
    if (object.getClass().getName().equals(
        "org.aspcfs.modules.troubletickets.base.TicketReplacementPart")) {
      //TicketReplacementPart replacement = (TicketReplacementPart) object;
      String parseItem = (String) map.get("parseItem");
      String partNumber = (String) map.get("partNumber");
      String partDescription = (String) map.get("partDescription");
      if ((partNumber != null && !"".equals(partNumber)) &&
          (partDescription == null || "".equals(partDescription))) {
        addError(
            systemStatus, object, "partDescription" + parseItem, REQUIRED_FIELD);
        System.out.println("Adding Errror -->-0> partDescription is required");
      }
      if ((partDescription != null && !"".equals(partDescription)) &&
          (partNumber == null || "".equals(partNumber))) {
        addError(
            systemStatus, object, "partNumber" + parseItem, REQUIRED_FIELD);
        System.out.println("Adding Errror -->-0> partNumber is required");
      }
    }

    //TicketPerDayDescription
    if (object.getClass().getName().equals(
        "org.aspcfs.modules.troubletickets.base.TicketPerDayDescription")) {
      //TicketPerDayDescription thisDescription = (TicketPerDayDescription) object;
      String parseItem = (String) map.get("parseItem");
      String descriptionOfService = (String) map.get("descriptionOfService");
      if (descriptionOfService == null || "".equals(
          descriptionOfService.trim())) {
        addError(
            systemStatus, object, "descriptionOfService" + parseItem, REQUIRED_FIELD);
        addError(
            systemStatus, object, "action", "object.validation.genericActionError");
      }

    
      //String timeZone = user.getTimeZone();
     
    }

    return true;
  }


  /**
   * Adds a feature to the Error attribute of the ObjectValidator class
   *
   * @param systemStatus The feature to be added to the Error attribute
   * @param object       The feature to be added to the Error attribute
   * @param field        The feature to be added to the Error attribute
   * @param errorType    The feature to be added to the Error attribute
   * @return Description of the Return Value
   */
  public static boolean checkError(SystemStatus systemStatus, Object object, String field, int errorType) {
    boolean returnValue = true;
    if (errorType == REQUIRED_FIELD) {
      String result = ObjectUtils.getParam(object, field);
      if (result == null || "".equals(result.trim())) {
        returnValue = false;
        addError(systemStatus, object, field, REQUIRED_FIELD);
      }
    } else if (errorType == INVALID_DATE) {
      try {
        String date = ObjectUtils.getParam(object, field);
        if (date == null || "".equals(date.trim())) {
          returnValue = false;
          addError(systemStatus, object, field, REQUIRED_FIELD);
        } else {
          try {
            date = new java.sql.Date(Timestamp.valueOf(date).getTime()).toString();
            Locale locale = new Locale(
                System.getProperty("LANGUAGE"), System.getProperty("COUNTRY"));
            SimpleDateFormat localeFormatter = new SimpleDateFormat(
                "yyyy-MM-dd", locale);
            localeFormatter.applyPattern("yyyy-MM-dd");
            localeFormatter.setLenient(false);
            localeFormatter.parse(date);
          } catch (java.text.ParseException e1) {
            returnValue = false;
            addError(systemStatus, object, field, INVALID_DATE);
          }
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else if (errorType == INVALID_NOT_REQUIRED_DATE) {
      try {
        String date = ObjectUtils.getParam(object, field);
        if (date != null && !"".equals(date.trim())) {
          try {
            date = new java.sql.Date(Timestamp.valueOf(date).getTime()).toString();
            Locale locale = new Locale(
                System.getProperty("LANGUAGE"), System.getProperty("COUNTRY"));
            SimpleDateFormat localeFormatter = new SimpleDateFormat(
                "yyyy-MM-dd", locale);
            localeFormatter.applyPattern("yyyy-MM-dd");
            localeFormatter.setLenient(false);
            localeFormatter.parse(date);
          } catch (java.text.ParseException e1) {
            returnValue = false;
            addError(systemStatus, object, field, INVALID_DATE);
          }
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else if (errorType == INVALID_EMAIL) {
      try {
        String email = ObjectUtils.getParam(object, field);
        if (email != null && !"".equals(email.trim())) {
          try {
            StringTokenizer str = new StringTokenizer(email, ",");
            if (str.hasMoreTokens()) {
              String temp = str.nextToken();
              InternetAddress inetAddress = new InternetAddress(
                  temp.trim(), true);
            } else {
              InternetAddress inetAddress = new InternetAddress(
                  email.trim(), true);
            }
          } catch (AddressException e1) {
            returnValue = false;
            addError(systemStatus, object, field, INVALID_EMAIL);
          }
        } else {
          returnValue = false;
          addError(systemStatus, object, field, INVALID_EMAIL);
        }
      } catch (Exception e) {
        returnValue = false;
        e.printStackTrace();
      }
    } else if (errorType == INVALID_EMAIL_NOT_REQUIRED) {
      try {
        String email = ObjectUtils.getParam(object, field);
        if (email != null && !"".equals(email.trim())) {
          try {
            StringTokenizer str = new StringTokenizer(email, ",");
            if (str.hasMoreTokens()) {
              String temp = str.nextToken();
              InternetAddress inetAddress = new InternetAddress(
                  temp.trim(), true);
            } else {
              InternetAddress inetAddress = new InternetAddress(
                  email.trim(), true);
            }
          } catch (AddressException e1) {
            returnValue = false;
            addError(systemStatus, object, field, INVALID_EMAIL);
          }
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    return returnValue;
  }


  /**
   * Description of the Method
   *
   * @param systemStatus Description of the Parameter
   * @param object       Description of the Parameter
   * @param field        Description of the Parameter
   * @param errorName    Description of the Parameter
   * @param errorType    Description of the Parameter
   */
  public static void checkError(SystemStatus systemStatus, Object object, String field, String errorName, int errorType) {
    if (errorType == REQUIRED_FIELD) {
      String result = ObjectUtils.getParam(object, field);
      if (result == null || "".equals(result.trim())) {
        addError(systemStatus, object, errorName, REQUIRED_FIELD);
      }
    } else if (errorType == INVALID_DATE) {
      try {
        String date = ObjectUtils.getParam(object, field);
        if (date == null || "".equals(date.trim())) {
          addError(systemStatus, object, errorName, REQUIRED_FIELD);
        } else {
          try {
            date = new java.sql.Date(Timestamp.valueOf(date).getTime()).toString();
            Locale locale = new Locale(
                System.getProperty("LANGUAGE"), System.getProperty("COUNTRY"));
            SimpleDateFormat localeFormatter = new SimpleDateFormat(
                "yyyy-MM-dd", locale);
            localeFormatter.applyPattern("yyyy-MM-dd");
            localeFormatter.setLenient(false);
            localeFormatter.parse(date);
          } catch (java.text.ParseException e1) {
            addError(systemStatus, object, errorName, INVALID_DATE);
          }
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else if (errorType == INVALID_NOT_REQUIRED_DATE) {
      try {
        String date = ObjectUtils.getParam(object, field);
        if (date != null && !"".equals(date.trim())) {
          try {
            date = new java.sql.Date(Timestamp.valueOf(date).getTime()).toString();
            Locale locale = new Locale(
                System.getProperty("LANGUAGE"), System.getProperty("COUNTRY"));
            SimpleDateFormat localeFormatter = new SimpleDateFormat(
                "yyyy-MM-dd", locale);
            localeFormatter.setLenient(false);
            localeFormatter.parse(date);
          } catch (java.text.ParseException e1) {
            addError(systemStatus, object, errorName, INVALID_DATE);
          }
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else if (errorType == INVALID_EMAIL) {
      try {
        String email = ObjectUtils.getParam(object, field);
        if (email != null && !"".equals(email.trim())) {
          try {
            StringTokenizer str = new StringTokenizer(email, ",");
            if (str.hasMoreTokens()) {
              String temp = str.nextToken();
              InternetAddress inetAddress = new InternetAddress(
                  temp.trim(), true);
            } else {
              InternetAddress inetAddress = new InternetAddress(
                  email.trim(), true);
            }
          } catch (AddressException e1) {
            addError(systemStatus, object, field, INVALID_EMAIL);
          }
        } else {
          addError(systemStatus, object, field, INVALID_EMAIL);
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else if (errorType == INVALID_EMAIL_NOT_REQUIRED) {
      try {
        String email = ObjectUtils.getParam(object, field);
        if (email != null && !"".equals(email.trim())) {
          try {
            StringTokenizer str = new StringTokenizer(email, ",");
            if (str.hasMoreTokens()) {
              String temp = str.nextToken();
              InternetAddress inetAddress = new InternetAddress(
                  temp.trim(), true);
            } else {
              InternetAddress inetAddress = new InternetAddress(
                  email.trim(), true);
            }
          } catch (AddressException e1) {
            addError(systemStatus, object, field, INVALID_EMAIL);
          }
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  }


  /**
   * Adds a feature to the Error attribute of the ObjectValidator class
   *
   * @param systemStatus The feature to be added to the Error attribute
   * @param field        The feature to be added to the Error attribute
   * @param errorType    The feature to be added to the Error attribute
   * @param object       The feature to be added to the Error attribute
   */
  public static void addError(SystemStatus systemStatus, Object object, String field, int errorType) {
    if (errorType == REQUIRED_FIELD) {
      addError(
          systemStatus, object, field, "object.validation.required");
    } else if (errorType == PAST_DATE) {
      addError(
          systemStatus, object, field, "object.validation.dateInThePast");
    } else if (errorType == INVALID_DATE || errorType == INVALID_NOT_REQUIRED_DATE) {
      addError(
          systemStatus, object, field, "object.validation.incorrectDateFormat");
    } else if (errorType == INVALID_NUMBER) {
      addError(
          systemStatus, object, field, "object.validation.incorrectNumberFormat");
    } else if (errorType == INVALID_EMAIL || errorType == INVALID_EMAIL_NOT_REQUIRED) {
      addError(
          systemStatus, object, field, "object.validation.invalidEmailAddress");
    }
  }


  /**
   * Adds a feature to the Error attribute of the ObjectValidator class
   *
   * @param systemStatus The feature to be added to the Error attribute
   * @param field        The feature to be added to the Error attribute
   * @param errorKey     The feature to be added to the Error attribute
   * @param object       The feature to be added to the Error attribute
   */
  private static void addError(SystemStatus systemStatus, Object object, String field, String errorKey) {
    HashMap errors = (HashMap) ObjectUtils.getObject(object, "errors");
    if (systemStatus != null) {
      errors.put(field + "Error", systemStatus.getLabel(errorKey));
    } else {
      errors.put(field + "Error", "field error");
    }
  }
  public static void addError2(SystemStatus systemStatus, Object object, String field, String error) {
	    HashMap errors = (HashMap) ObjectUtils.getObject(object, "errors");
	    errors.put(field + "Error", error);
	   
	  }

  /**
   * Adds a feature to the Warning attribute of the ObjectValidator class
   *
   * @param systemStatus The feature to be added to the Warning attribute
   * @param object       The feature to be added to the Warning attribute
   * @param field        The feature to be added to the Warning attribute
   * @param warningType  The feature to be added to the Warning attribute
   */
  public static void checkWarning(SystemStatus systemStatus, Object object, String field, int warningType) {
    if (warningType == IS_BEFORE_TODAY) {
      Timestamp result = (Timestamp) ObjectUtils.getObject(object, field);
      if (result != null && result.before(new java.util.Date())) {
        addWarning(
            systemStatus, object, field, "object.validation.beforeToday");
      }
    }
  }


  /**
   * Adds a feature to the Warning attribute of the ObjectValidator class
   *
   * @param systemStatus The feature to be added to the Warning attribute
   * @param object       The feature to be added to the Warning attribute
   * @param field        The feature to be added to the Warning attribute
   * @param warningKey   The feature to be added to the Warning attribute
   */
  public static void addWarning(SystemStatus systemStatus, Object object, String field, String warningKey) {
    HashMap warnings = (HashMap) ObjectUtils.getObject(object, "warnings");
    if (systemStatus != null) {
      warnings.put(field + "Warning", systemStatus.getLabel(warningKey));
    } else {
      warnings.put(field + "Warning", "field warning");
    }
  }


  /**
   * Description of the Method
   *
   * @param systemStatus Description of the Parameter
   * @param object       Description of the Parameter
   * @param errorName    Description of the Parameter
   * @param fieldName    Description of the Parameter
   * @param length       Description of the Parameter
   */
  public static void checkLength(SystemStatus systemStatus, Object object, String errorName, String fieldName, int length) {
    String value = (String) ObjectUtils.getObject(object, fieldName);
    if (value != null && value.length() > length) {
      addError(systemStatus, object, fieldName, errorName);
    }
  }
  
  private static String fixStringa(String stringa){
	  String result = stringa.trim();
	  result = result.replaceAll("\t", "");
	  result = result.replaceAll("\n", "");
	  result = result.replaceAll(" ", "");
	  return result;
  }

}

