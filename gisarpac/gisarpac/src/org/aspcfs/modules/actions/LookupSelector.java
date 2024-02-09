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

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.StringTokenizer;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.utils.web.CustomLookupList;
import org.aspcfs.utils.web.LookupList;
import org.aspcfs.utils.web.PagedListInfo;
import org.json.JSONArray;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;

/**
 * Action method to construct a paged lookup list
 *
 * @author akhilesh mathur
 * @version $Id: LookupSelector.java,v 1.7.16.2 2004/11/12 20:37:02 partha Exp
 *          $
 * @created --
 */
public final class LookupSelector extends CFSModule {

  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
	
	
	public String executeCommandpopUpSceltaAudit(ActionContext context) {
	   
		String isInModifica=context.getRequest().getParameter("update");
		
		String id=context.getRequest().getParameter("idc");
		String orgid=context.getRequest().getParameter("orgid");
		
		context.getRequest().setAttribute("idc", id);
		context.getRequest().setAttribute("orgid", orgid);
		context.getRequest().setAttribute("Modifica", isInModifica);
		
	    return ("popUpSceltaAuditOK");
	    
	    
	  }
	
	public String executeCommandpopUpModale(ActionContext context) {
		   
		
		 
	    return ("popUpModale");
	    
	    
	  }
	
	public String executeCommandpopUpSceltaAuditAllevamenti(ActionContext context) {
		   
		String isInModifica=context.getRequest().getParameter("update");
		
		String id=context.getRequest().getParameter("idc");
		String orgid=context.getRequest().getParameter("orgid");
		
		context.getRequest().setAttribute("idc", id);
		context.getRequest().setAttribute("orgid", orgid);
		context.getRequest().setAttribute("Modifica", isInModifica);
		
	    return ("popUpSceltaAuditAllOK");
	  }
	
	public String executeCommandpopUpSceltaAuditStab(ActionContext context) {
		   
		String isInModifica=context.getRequest().getParameter("update");
		
		String id=context.getRequest().getParameter("idc");
		String orgid=context.getRequest().getParameter("orgid");
		
		context.getRequest().setAttribute("idc", id);
		context.getRequest().setAttribute("orgid", orgid);
		context.getRequest().setAttribute("Modifica", isInModifica);
		
	    return ("popUpSceltaAuditStabOK");
	  }
	
  public String executeCommandPopupSelector(ActionContext context) {
    Connection db = null;
    LookupList selectList = new LookupList();
    boolean listDone = false;
    String displayFieldId = null;
    String hiddenFieldId = null;
    String listType = context.getRequest().getParameter("listType");
    PagedListInfo lookupSelectorInfo = this.getPagedListInfo(context, "LookupSelectorInfo");
    String tableName = context.getRequest().getParameter("table");
    HashMap selectedList = new HashMap();
    HashMap finalElementList = (HashMap) context.getSession().getAttribute("finalElements");
    if (context.getRequest().getParameter("previousSelection") != null) {
      int j = 0;
      StringTokenizer st = new StringTokenizer(context.getRequest().getParameter("previousSelection"), "|");
      StringTokenizer st1 = new StringTokenizer(context.getRequest().getParameter("previousSelectionDisplay"), "|");
      while (st.hasMoreTokens()) {
        selectedList.put(new Integer(st.nextToken()), st1.nextToken());
        j++;
      }
    } else {
      //get selected list from the session
      selectedList = (HashMap) context.getSession().getAttribute("selectedElements");
    }
    if (context.getRequest().getParameter("displayFieldId") != null) {
      displayFieldId = context.getRequest().getParameter("displayFieldId");
    }
    if (context.getRequest().getParameter("hiddenFieldId") != null) {
      hiddenFieldId = context.getRequest().getParameter("hiddenFieldId");
    }
    //Flush the selectedList if its a new selection
    if (context.getRequest().getParameter("flushtemplist") != null) {
      if (((String) context.getRequest().getParameter("flushtemplist")).equalsIgnoreCase("true")) {
        if (context.getSession().getAttribute("finalElements") != null && context.getRequest().getParameter("previousSelection") == null) {
          selectedList = (HashMap) ((HashMap) context.getSession().getAttribute("finalElements")).clone();
        }
      }
    }
    int rowCount = 1;
    if ("list".equals(listType)) {
      while (context.getRequest().getParameter("hiddenelementid" + rowCount) != null) {
        int elementId = 0;
        String elementValue = "";
        elementId = Integer.parseInt(context.getRequest().getParameter("hiddenelementid" + rowCount));
        if (context.getRequest().getParameter("checkelement" + rowCount) != null) {
          if (context.getRequest().getParameter("elementvalue" + rowCount) != null) {
            elementValue = context.getRequest().getParameter("elementvalue" + rowCount);
          }
          if (selectedList.get(new Integer(elementId)) == null) {
            selectedList.put(new Integer(elementId), elementValue);
          } else {
            selectedList.remove(new Integer(elementId));
            selectedList.put(new Integer(elementId), elementValue);
          }
        } else {
          selectedList.remove(new Integer(elementId));
        }
        rowCount++;
      }
    }
    
    if (context.getRequest().getParameter("finalsubmit") != null) {
      if (((String) context.getRequest().getParameter("finalsubmit")).equalsIgnoreCase("true")) {
        //Handle single selection case
        if ("single".equals(listType)) {
          rowCount = Integer.parseInt(context.getRequest().getParameter("rowcount"));
          int siteId = Integer.parseInt(context.getRequest().getParameter("hiddenelementid" + rowCount));
          String siteValue = context.getRequest().getParameter("elementvalue" + rowCount);
          selectedList.clear();
          selectedList.put(new Integer(siteId), siteValue);
        }
        
        finalElementList = (HashMap) selectedList.clone();
        context.getSession().setAttribute("finalElements", finalElementList);
      }
    }
    try {
      db = this.getConnection(context);
      selectList.setTableName(tableName);
      selectList.setPagedListInfo(lookupSelectorInfo);
      selectList.setSelectedItems(selectedList);
      selectList.buildList(db);
    } catch (Exception e) {
      context.getRequest().setAttribute("Error", e);
      return ("SystemError");
    } finally {
      context.getRequest().setAttribute("BaseList", selectList);
      this.freeConnection(context, db);
    }
    context.getSession().setAttribute("selectedElements", selectedList);
    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
    context.getRequest().setAttribute("hiddenFieldId", hiddenFieldId);
    context.getRequest().setAttribute("Table", tableName);
    return ("PopLookupOK");
  }

 
  /**
   * Description of the Method
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandPopupSingleSelector(ActionContext context) {
    Connection db = null;
    LookupList selectList = null;
    boolean listDone = false;
    String lookupId = (String) context.getRequest().getParameter("lookupId");
    String moduleId = (String) context.getRequest().getParameter("moduleId");
    String displayFieldId = null;
    PagedListInfo lookupSelectorInfo = this.getPagedListInfo(context, "LookupSingleSelectorInfo");
    if (context.getRequest().getParameter("displayFieldId") != null) {
      displayFieldId = context.getRequest().getParameter("displayFieldId");
    }
    try {
      db = this.getConnection(context);
      lookupSelectorInfo.setLink("LookupSelector.do?command=PopupSingleSelector&lookupId=" + lookupId + "&moduleId=" + moduleId + "&displayFieldId=" + displayFieldId);
      selectList = new LookupList(db, Integer.parseInt(moduleId), Integer.parseInt(lookupId));
      selectList.setPagedListInfo(lookupSelectorInfo);
      selectList.buildList(db);
    } catch (Exception e) {
      context.getRequest().setAttribute("Error", e);
      return ("SystemError");
    } finally {
      context.getRequest().setAttribute("BaseList", selectList);
      this.freeConnection(context, db);
    }
    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
    context.getRequest().setAttribute("lookupId", lookupId);
    context.getRequest().setAttribute("moduleId", moduleId);
    return ("PopLookupSingleOK");
  }
  
  
  
  
  public String executeCommandPopupSelectorCustom(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String tableName = context.getRequest().getParameter("table");
	    context.getRequest().setAttribute("table", tableName);
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      if (filtroDesc == null){
	    	selectList.buildList(db);
	      } else {
	    	  
	    	  if(tableName.equals("lookup_codistat"))
	    	  {
	    		  //selectList.buildList(db, "description", filtroDesc);
	    		  selectList.buildList(db, "short_description", filtroDesc);
	    		  
	    	  }
	    	  else
	    	  {
	    	  
	        selectList.buildList(db, "short_description", filtroDesc);
	    	  }
	    	  }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupCustomOK");
}
  
  
  
  public String executeCommandPopupSelectorSOA(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    String id_asl="-1";
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("siteid") != null) {
		      id_asl = context.getRequest().getParameter("siteid");
		    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    context.getRequest().setAttribute("idAsl", id_asl);
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      if (filtroDesc == null || filtroDesc.equals("")){
	    	selectList.buildListSOA(db,id_asl);
	      } 
	      else {
	        selectList.buildListSOAFiltro(db, id_asl, filtroDesc);
	      }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupSOAOK");
}
  
  public String executeCommandPopupSelectorAllerteImprese(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    String id_asl="-1";
	    context.getRequest().setAttribute("tipologia", "1");
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("siteid") != null) {
		      id_asl = context.getRequest().getParameter("siteid");
		    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    
	    context.getRequest().setAttribute("idAsl", id_asl);
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      if (filtroDesc == null){
	    	selectList.buildListAllerteImprese(db,id_asl);
	      } 
	      else {
	    	  selectList.buildListAllerteImpreseFiltro(db,id_asl, filtroDesc);
	      }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupAllerteImpreseOK");
}
  
  
  public String executeCommandPopupSelectorAllerteStabilimenti(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    String id_asl="-1";
	    context.getRequest().setAttribute("tipologia", "3");
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("siteid") != null) {
		      id_asl = context.getRequest().getParameter("siteid");
		    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    context.getRequest().setAttribute("idAsl", id_asl);
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      if (filtroDesc == null){
	    	selectList.buildListAllerteStabilimenti(db,id_asl);
	      } 
	      else {
	    	  selectList.buildListAllerteStabilimentiFiltro(db,id_asl,filtroDesc);
	      }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupAllerteImpreseOK");
}
  
  
  
  public String executeCommandPopupSelectorCustomImprese(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String orgId = context.getRequest().getParameter("orgId");
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    String displayFieldId3 = null;
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("displayFieldId3") != null) {
		      displayFieldId3 = context.getRequest().getParameter("displayFieldId3");
		    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      if (filtroDesc == null ||"".equals(filtroDesc)){
	    	  if (orgId!=null)
	    	  {
	    		  selectList.buildList2(db,Integer.parseInt(orgId));
	    		  context.getRequest().setAttribute("orgId", orgId);
	    	  }
	    	  else
	    	  {
	    		  selectList.buildList(db);
	    	  }
	    	
	      } else {
	    	  if (orgId!=null)
	    	  {
	    		  selectList.buildList2(db, "short_description", filtroDesc,Integer.parseInt(orgId));
	    		  context.getRequest().setAttribute("orgId", orgId);
	    	  }
	    	  else
	    	  {
	    		  selectList.buildList(db, "codice_ateco", filtroDesc);
	    	  }
	     
	       
	      }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("DisplayFieldId3", displayFieldId3);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupCustomImpreseOK");
}
  
  
  public String executeCommandPopupSelectorCustomProve(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String orgId = context.getRequest().getParameter("orgId");
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	  	  selectList.buildList_prove(db,filtroDesc);
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupCustomProveOK");
}
  
 
  
  
public String executeCommandPopupSelectorCustomPianiMonitoraggio(ActionContext context) {
    Connection db = null;
    CustomLookupList selectList = null;
    String tableName = context.getRequest().getParameter("table");
    String filtroDesc = "";
    String displayFieldId = null;
    String displayFieldId2 = null;
    int idAsl = Integer.parseInt(context.getRequest().getParameter("idAsl"));
    String link = "LookupSelector.do?command=PopupSelectorCustomPianiMonitoraggio" ;
    if (context.getRequest().getParameter("displayFieldId") != null) {
      displayFieldId = context.getRequest().getParameter("displayFieldId");
    }
    if (context.getRequest().getParameter("displayFieldId2") != null) {
      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
    }
    if (context.getRequest().getParameter("filtroDesc") != null) {
      filtroDesc = context.getRequest().getParameter("filtroDesc");
      link += "&filtroDesc="+filtroDesc;
	}
    context.getRequest().setAttribute("Selezione", "no");
    String tipi_piani = null ; 
    String val = "" ;
    if (context.getRequest().getParameter("tipo") != null) {
    	tipi_piani = context.getRequest().getParameter("tipo");
    	//for (int k = 0 ; k<tipi_piani.length-1; k++)
    		//val +=tipi_piani[k]+",";
    	//val += tipi_piani[tipi_piani.length-1];
        link += "&tipo="+tipi_piani;
  	}
    link += "&table="+tableName ;
    
    selectList = new CustomLookupList();
    
    PagedListInfo searchListInfo = this.getPagedListInfo(
			  context, "SearchPianiListInfo");
	searchListInfo.setLink(link);
	  
	  searchListInfo.setSearchCriteria(selectList, context);
		  selectList.setPagedListInfo(searchListInfo);
		  
    try {
      db = this.getConnection(context);
      
      LookupList lookup_gruppi_piani = new LookupList(db,"lookup_sezioni_piani_monitoraggio");
      lookup_gruppi_piani.addItem(-1, "-SELEZIONA SEZIONE DI MONITORAGGIO-");
      context.getRequest().setAttribute("lookup_sezioni_piani", lookup_gruppi_piani);
      
      selectList.setTableName(tableName);
      selectList.setTipi_piani(tipi_piani);
      selectList.buildListPiani(db,filtroDesc,idAsl);
     
     
  	  
    } catch (Exception e) {
      context.getRequest().setAttribute("Error", e);
      return ("SystemError");
    } finally {
      context.getRequest().setAttribute("BaseList", selectList);
      this.freeConnection(context, db);
    }
    
    context.getRequest().setAttribute("idAsl", idAsl);
    context.getRequest().setAttribute("TipiPiani", tipi_piani);
    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
    context.getRequest().setAttribute("Table", tableName);
    return ("PopLookupCustomPianiMonitoraggioOK");
}

  public String executeCommandPopupSelectorCustomMatrici(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	  	  selectList.buildList_matrici(db,filtroDesc);
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupCustomMatriciOK");
}
  
  public String executeCommandPopupSelectorMacellazioneSpeditore(ActionContext context) {
	  
	  String ragioneSociale = context.getRequest().getParameter("searchAccountName");
	  String tipologia = context.getRequest().getParameter("displayFieldId");

	  Connection db = null;
	  CustomLookupList selectList = null;
	  selectList = new CustomLookupList();
	  
	  	  
	  //Prepare pagedListInfo
	  PagedListInfo searchListInfo = this.getPagedListInfo(
			  context, "SearchOrgListInfo");
	  searchListInfo.setLink("LookupSelector.do?command=PopupSelectorMacellazioneSpeditore&displayFieldId="+tipologia);
	  if (context.getRequest().getParameter("letter")!=null)
		  searchListInfo.setCurrentLetter(context.getRequest().getParameter("letter"));
	  SystemStatus systemStatus = this.getSystemStatus(context);

	  try 
	  {
		  db = this.getConnection(context);
		  searchListInfo.setSearchCriteria(selectList, context);
		  selectList.setTableName("organization");
		  selectList.addField("name");	
		  selectList.addField("account_number");	
		  selectList.addField("tipologia");
		  selectList.addField("o.org_id");	
		  selectList.addField("nome_rappresentante");
		  selectList.addField("city");	
		  selectList.addField("tipologia");	
		  selectList.addField("state");	
		  selectList.addField("country");
		  selectList.addField("asl.description as asldescr");
		  selectList.addField("*");
		  
		  selectList.setPagedListInfo(searchListInfo);
		  
		
		  if(ragioneSociale!=null)
		  {
			  selectList.setAccountName(ragioneSociale);
		  }
		  else
		  {
			  if( selectList.getAccountName()==null)
			  selectList.setAccountName("");
		  }
		  
//		  if(context.getRequest().getParameter("searchAccountNumber")!=null && ! "null".equalsIgnoreCase(context.getRequest().getParameter("searchAccountNumber")) &&!"".equals(context.getRequest().getParameter("searchAccountNumber")))
//		  {
			  selectList.setAccountNumber(context.getRequest().getParameter("searchAccountNumber"));
		  //}
		  
		  if(context.getRequest().getParameter("codicespeditore")!=null && !"".equals(context.getRequest().getParameter("codicespeditore")))
		  {
			  selectList.setOrgId(Integer.parseInt(context.getRequest().getParameter("codicespeditore")));
		  }
		  
		  
		
		  
		  if(context.getRequest().getParameter("codicespeditore")!=null)
		  {
			  int codicespeditore = Integer.parseInt(context.getRequest().getParameter("codicespeditore"));
			  selectList.setOrgId(codicespeditore);
			  selectList.buildListSpeditori(db, "11");
			  context.getRequest().setAttribute("codicespeditore", "si");
			  
		  }
		  else
		  {
			  selectList.buildListSpeditori(db,tipologia);
			  if(selectList.isEmpty())
			  {
				  selectList.buildListAziendeZootecniche(db,"2");
			  }
			  
		  }
		  /*LookupList SiteIdList = new LookupList(db, "lookup_site_id");
		  SiteIdList.addItem(-1, systemStatus
				  .getLabel("calendar.none.4dashes"));
		  SiteIdList.addItem(-2, "-- TUTTI --"
				  );
		  context.getRequest().setAttribute("SiteIdList", SiteIdList);
		  */

	  } catch (Exception e) {
		  context.getRequest().setAttribute("Error", e);
		  e.printStackTrace();
		  return ("SystemError");
	  } finally {
		  context.getRequest().setAttribute("BaseList", selectList);
		  this.freeConnection(context, db);
	  }

	  context.getRequest().setAttribute("displayFieldId", tipologia);
	  //context.getRequest().setAttribute("idAsl", asl);
	 
	  return "popUpSpeditori";
  }
	  
  
 
  public String executeCommandPopupSelectorCustomSOA(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String orgId = context.getRequest().getParameter("orgId");
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    context.getRequest().setAttribute("tipoSelezione", context.getParameter("tipo_selezione"));

	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      if (filtroDesc == null ||"".equals(filtroDesc)){
	    	  if (orgId!=null)
	    	  {
	    		  selectList.buildList_impianti_soa(db,Integer.parseInt(orgId));
	    		  context.getRequest().setAttribute("orgId", orgId);
	    	  }
	    	  else
	    	  {
	    		  selectList.buildList(db);
	    	  }
	    	
	      } else {
	    	  if (orgId!=null)
	    	  {
	    		  selectList.buildList_impianti_soa(db,Integer.parseInt(orgId));
	    		  context.getRequest().setAttribute("orgId", orgId);
	    	  }
	    	  else
	    	  {
	    		  selectList.buildList(db, "short_description", filtroDesc);
	    	  }
	     
	       
	      }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupCustomSOAOK");
}
  
  public String executeCommandPopupSelectorCustomStabilimenti(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String orgId = context.getRequest().getParameter("orgId");
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    context.getRequest().setAttribute("tipoSelezione", context.getParameter("tipo_selezione"));
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      if (filtroDesc == null ||"".equals(filtroDesc)){
	    	  if (orgId!=null)
	    	  {
	    		  selectList.buildList_impianti(db,Integer.parseInt(orgId));
	    		  context.getRequest().setAttribute("orgId", orgId);
	    	  }
	    	  else
	    	  {
	    		  selectList.buildList(db);
	    	  }
	    	
	      } else {
	    	  if (orgId!=null)
	    	  {
	    		  selectList.buildList_impianti(db,Integer.parseInt(orgId));
	    		  context.getRequest().setAttribute("orgId", orgId);
	    	  }
	    	  else
	    	  {
	    		  selectList.buildList(db, "short_description", filtroDesc);
	    	  }
	     
	       
	      }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupCustomStabilimentiOK");
}
  
  
  public String executeCommandPopupSelectorCheckImprese2(ActionContext context) {
	    Connection db = null;
	   
	    try {
	      db = this.getConnection(context);
	     
	      String partitaIva = context.getRequest().getParameter("partitaIva");
	      String orgId = context.getRequest().getParameter("orgId");
	      boolean trovato = false;
	      if(!partitaIva.equals(""))
	      {
	    	  org.aspcfs.modules.accounts.base.Organization o = new  org.aspcfs.modules.accounts.base.Organization();
	    	 trovato =  o.checkDiaByPartitaIva(partitaIva, db);
	    	
	    		
	    	
	    	
	      }
	  
	      context.getRequest().setAttribute("DiaEsistente", trovato);
	      context.getRequest().setAttribute("PartitaIva", partitaIva);
	    	
	     
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	     
	      this.freeConnection(context, db);
	    }
	 
	    return ("PopLookupCheckImpreseOK2");
}
  public String executeCommandPopupSelectorCustomZone(ActionContext context)
  {
	  String asl = context.getRequest().getParameter("searchcodeidAsl");
	  String ragioneSociale = context.getRequest().getParameter("searchAccountName");
	  String city = context.getRequest().getParameter("searchAccountcity");
	
	  Connection db = null;
	  CustomLookupList selectList = null;
	  selectList = new CustomLookupList();
	  
	
	  //Prepare pagedListInfo
	  PagedListInfo searchListInfo = this.getPagedListInfo(
			  context, "SearchOrgListInfo");
	  searchListInfo.setLink("LookupSelector.do?command=PopupSelectorCustomPuntiSbarco&name="+ragioneSociale+"&city="+city+"&siteId="+asl);
		  SystemStatus systemStatus = this.getSystemStatus(context);

	  try 
	  {
		  db = this.getConnection(context);
		  searchListInfo.setSearchCriteria(selectList, context);
		  selectList.setTableName("organization");
		  selectList.addField("name");	
		  selectList.addField("site_id");
		  selectList.addField("partita_iva");	
		  selectList.addField("tipologia");
		  selectList.addField("o.org_id");	
		  selectList.addField("oa.city");	
		  selectList.addField("oa.addrline1");	
		  selectList.addField("oa.state");	
		  selectList.addField("oa.postalcode");
		  selectList.addField("asl.description as aslDescr");
		  selectList.addField("nome_correntista");
		  selectList.addField("alert");
		  
		 // selectList.addField("lci.description as codice");	

		  selectList.setPagedListInfo(searchListInfo);
		  
		  if(asl!=null )
		  {
			  selectList.setIdAsl(Integer.parseInt(asl));
			  context.getRequest().setAttribute("idAsl", ""+Integer.parseInt(asl));
		  }
		  else
		  {
			  if(selectList.getIdAsl()==0)
			  selectList.setIdAsl(-1);
			  
		  }
		  if(ragioneSociale!=null)
		  {
			  selectList.setAccountName(ragioneSociale);
		  }
		  else
		  {
			  if( selectList.getAccountName()==null)
			  selectList.setAccountName("");
		  }
		  
		  if(city!=null)
		  {
			  selectList.setSedeOperativa(city);
		  }
		  else
		  {
			  selectList.setSedeOperativa("");
		  }
		  
		  
		  
		  /*if(tipo.equals("stab")){
			  //Caso Stabilimento
			  selectList.buildListDestinazioneCarniStab(db,inRegione);
		  } else{
			    //Caso impresa
			  selectList.buildListDestinazioneCarni(db, inRegione);
		  }*/
		  

		  selectList.buildListImpreseZone(db);
		  
		  LookupList SiteIdList = new LookupList(db, "lookup_site_id");
		  SiteIdList.addItem(-1, systemStatus
				  .getLabel("calendar.none.4dashes"));
		  SiteIdList.addItem(-2, "-- TUTTI --"
				  );
		  context.getRequest().setAttribute("SiteIdList", SiteIdList);

	  } catch (Exception e) {
		  context.getRequest().setAttribute("Error", e);
		  e.printStackTrace();
		  return ("SystemError");
	  } finally {
		  context.getRequest().setAttribute("BaseList", selectList);
		  this.freeConnection(context, db);
	  }

	   context.getRequest().setAttribute("idAsl", asl);
	 
	  return "popUpOperatoriZoneControllati";
  }
  
  public String executeCommandPopupSelectorCustomPuntiSbarco(ActionContext context)
  {
	  String asl = context.getRequest().getParameter("searchcodeidAsl");
	  String ragioneSociale = context.getRequest().getParameter("searchAccountName");
	  String indiceImpresa = context.getRequest().getParameter("displayFieldId");
	  String tipoA = context.getRequest().getParameter("searchAbusivo");
	  String tipoI = context.getRequest().getParameter("searchImpresa");
	  String cod_ateco = context.getRequest().getParameter("searchcodeAteco"); 
	 
	  Connection db = null;
	  CustomLookupList selectList = null;
	  selectList = new CustomLookupList();
	  
	  if(indiceImpresa.equalsIgnoreCase("1_types")){
		  indiceImpresa = "17";
	  }
	  
	  if(tipoA !=null){
		  if(tipoA.equals("abusivo")){
			  indiceImpresa = "4";
		  }
	  }
	  
	  if(tipoI !=null){
		  if(tipoI.equals("imbarcazione")){
			  indiceImpresa = "17";
		  }
	  }
	  
	  //Voglio sia le imprese con codice ateco 03.11.00 sia gli operatori abusivi
	  if(tipoA != null && tipoI != null){
		  indiceImpresa = "17,4";
	  }
	  
	  //Prepare pagedListInfo
	  PagedListInfo searchListInfo = this.getPagedListInfo(
			  context, "SearchOrgListInfo");
	  searchListInfo.setLink("LookupSelector.do?command=PopupSelectorCustomPuntiSbarco&displayFieldId="+indiceImpresa+"&siteId="+asl);
	  if (context.getRequest().getParameter("letter")!=null)
		  searchListInfo.setCurrentLetter(context.getRequest().getParameter("letter"));
	  SystemStatus systemStatus = this.getSystemStatus(context);

	  try 
	  {
		  db = this.getConnection(context);
		  searchListInfo.setSearchCriteria(selectList, context);
		  selectList.setTableName("organization");
		  selectList.addField("name");	
		  selectList.addField("account_number");
		  selectList.addField("partita_iva");	
		  selectList.addField("tipologia");
		  selectList.addField("o.org_id");	
		  selectList.addField("oa.city");	
		  selectList.addField("oa.addrline1");	
		  selectList.addField("oa.state");	
		  selectList.addField("oa.postalcode");
		  selectList.addField("asl.description as aslDescr");
		  selectList.addField("nome_correntista");
		  
		 // selectList.addField("lci.description as codice");	

		  selectList.setPagedListInfo(searchListInfo);
		  
		  if(asl!=null )
		  {
			  selectList.setIdAsl(Integer.parseInt(asl));
			  context.getRequest().setAttribute("idAsl", ""+Integer.parseInt(asl));
		  }
		  else
		  {
			  if(selectList.getIdAsl()==0)
			  selectList.setIdAsl(-1);
			  
		  }
		  if(ragioneSociale!=null)
		  {
			  selectList.setAccountName(ragioneSociale);
		  }
		  else
		  {
			  if( selectList.getAccountName()==null)
			  selectList.setAccountName("");
		  }
		  
		  if( cod_ateco != null)
		  {
			  selectList.setAteco(cod_ateco);
		  }
		  
		  else
		  {
			  if( selectList.getAteco()== null)
				  selectList.setAteco("");
		  }
		  
		  
		  
		  /*if(tipo.equals("stab")){
			  //Caso Stabilimento
			  selectList.buildListDestinazioneCarniStab(db,inRegione);
		  } else{
			    //Caso impresa
			  selectList.buildListDestinazioneCarni(db, inRegione);
		  }*/
		  

		  selectList.buildListImpreseAbusivi(db,indiceImpresa);
		  
		  LookupList SiteIdList = new LookupList(db, "lookup_site_id");
		  SiteIdList.addItem(-1, systemStatus
				  .getLabel("calendar.none.4dashes"));
		  SiteIdList.addItem(-2, "-- TUTTI --"
				  );
		  context.getRequest().setAttribute("SiteIdList", SiteIdList);

	  } catch (Exception e) {
		  context.getRequest().setAttribute("Error", e);
		  e.printStackTrace();
		  return ("SystemError");
	  } finally {
		  context.getRequest().setAttribute("BaseList", selectList);
		  this.freeConnection(context, db);
	  }

	  context.getRequest().setAttribute("displayFieldId", indiceImpresa);
	  context.getRequest().setAttribute("tipoA", tipoA);
	  context.getRequest().setAttribute("tipoI", tipoI);
	  context.getRequest().setAttribute("idAsl", asl);
	  context.getRequest().setAttribute("codAteco", cod_ateco);
	 
	  return "popUpOperatoriControllati";
  }
  
  
  
  public void buildFormElements(ActionContext context, Connection db) throws SQLException {
	    String index = null;
	    if (context.getRequest().getParameter("index") != null) {
	      index = context.getRequest().getParameter("index");
	    }
	    SystemStatus systemStatus = this.getSystemStatus(context);

	    CustomLookupList codiceIstatList = new CustomLookupList(); //db, "lookup_codistat");
	    codiceIstatList.tableName = "lookup_codistat";
	    codiceIstatList.addField("*");
	    //codiceIstatList.addField("description");
	    //codiceIstatList.addField("short_description");
	    //codiceIstatList.addField("default_item");
	    //codiceIstatList.addField("level");
	    //codiceIstatList.addField("enabled");
	    codiceIstatList.buildList(db);
	    codiceIstatList.addItem(-1,  "-- SELEZIONA VOCE --",  "-- SELEZIONA VOCE --");
	    context.getRequest().setAttribute("CodiceIstatList", codiceIstatList);
	    
	  
	  }

	  
  
  
  
  public String executeCommandPopupSelectorCustomLaboratoriHaccp(ActionContext context)
  {
	  //String asl = context.getRequest().getParameter("searchcodeidAsl");
	  String ragioneSociale = context.getRequest().getParameter("searchAccountName");
	  String indiceLab = context.getRequest().getParameter("displayFieldId");

	  Connection db = null;
	  CustomLookupList selectList = null;
	  selectList = new CustomLookupList();
	  
	  	  
	  //Prepare pagedListInfo
	  PagedListInfo searchListInfo = this.getPagedListInfo(
			  context, "SearchOrgListInfo");
	  searchListInfo.setLink("LookupSelector.do?command=PopupSelectorCustomLaboratoriHaccp&displayFieldId="+indiceLab);
	  if (context.getRequest().getParameter("letter")!=null)
		  searchListInfo.setCurrentLetter(context.getRequest().getParameter("letter"));
	  SystemStatus systemStatus = this.getSystemStatus(context);

	  try 
	  {
		  db = this.getConnection(context);
		  searchListInfo.setSearchCriteria(selectList, context);
		  selectList.setTableName("organization");
		  selectList.addField("name");	
		  selectList.addField("account_number");	
		  selectList.addField("tipologia");
		  selectList.addField("o.org_id");	
		  selectList.addField("cognome_rappresentante");
		  //selectList.addField("asl.description as aslDescr");	

		  selectList.setPagedListInfo(searchListInfo);
		  
		 /* if(asl!=null )
		  {
			  selectList.setIdAsl(Integer.parseInt(asl));
			  context.getRequest().setAttribute("idAsl", ""+Integer.parseInt(asl));
		  }
		  else
		  {
			  if(selectList.getIdAsl()==0)
			  selectList.setIdAsl(-1);
			  
		  }*/
		  if(ragioneSociale!=null)
		  {
			  selectList.setAccountName(ragioneSociale);
		  }
		  else
		  {
			  if( selectList.getAccountName()==null)
			  selectList.setAccountName("");
		  }
		  
		  
		  selectList.buildListLaboratori(db,indiceLab);
		  
		  /*LookupList SiteIdList = new LookupList(db, "lookup_site_id");
		  SiteIdList.addItem(-1, systemStatus
				  .getLabel("calendar.none.4dashes"));
		  SiteIdList.addItem(-2, "-- TUTTI --"
				  );
		  context.getRequest().setAttribute("SiteIdList", SiteIdList);
		  */

	  } catch (Exception e) {
		  context.getRequest().setAttribute("Error", e);
		  e.printStackTrace();
		  return ("SystemError");
	  } finally {
		  context.getRequest().setAttribute("BaseList", selectList);
		  this.freeConnection(context, db);
	  }

	  context.getRequest().setAttribute("displayFieldId", indiceLab);
	  //context.getRequest().setAttribute("idAsl", asl);
	 
	  return "popUpLaboratoriControllati";
  }
  
  
  public String executeCommandPopupSelectorCustomNew(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    
	    
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if(displayFieldId==null)
	    	displayFieldId=displayFieldId2;
	    
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      if (filtroDesc == null){
	    	selectList.buildList(db);
	      } else {
	        selectList.buildList(db, "short_description", filtroDesc);
	      }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupCustomNewOK");
}  
  
  
  public String executeCommandPopupSelectorCustomDia(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      if (filtroDesc == null){
	    	  int idAsl=((UserBean)context.getSession().getAttribute("User")).getSiteId();
	    	selectList.buildListDia(db, idAsl);
	      } /*else {
	        selectList.buildList(db, "short_description", filtroDesc);
	      }*/
	     
	      
	      
	     
	      
	      
	      
	      
	      
	      
	      
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    
	    
	   
	    
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupCustomDiaOK");
}
  
  
  public String executeCommandPopupSelectorAllertaRicercaImprese(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String filtroDesc2 = null;
	    String filtroDesc3 = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    String isChiuse    = "no";
	    
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    if (context.getRequest().getParameter("annoAllerta") != null) {
		      filtroDesc2 = context.getRequest().getParameter("annoAllerta");
			}
	    
	    if (context.getRequest().getParameter("isChiuse") != null) {
		      isChiuse = context.getRequest().getParameter("isChiuse");
		      filtroDesc3 = isChiuse;
			}
	    
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      UserBean utente=(UserBean)context.getSession().getAttribute("User");
	      if (filtroDesc == null && filtroDesc2 == null && filtroDesc3 == null) {
	    	  
	    	 
	    	selectList.buildListAllerteRicerca(db,utente.getSiteId());
	      } else {
	        selectList.buildListAllerteFiltroRicerca(db, "id_allerta", filtroDesc,"assigned_date",filtroDesc2,isChiuse, utente.getSiteId());
	      }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("FiltroDesc2", filtroDesc2);
	    context.getRequest().setAttribute("FiltroDesc3", filtroDesc3);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupAllertaRicercaOK");
}
  
  
  public String executeCommandPopupSelectorAllerta(ActionContext context) {
	    Connection db = null;
	    CustomLookupList selectList = null;
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = null;
	    String filtroDesc2 = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    if (context.getRequest().getParameter("annoAllerta") != null) {
		      filtroDesc2 = context.getRequest().getParameter("annoAllerta");
			}
	    
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName(tableName);
	      selectList.addField("*");
	      UserBean utente=(UserBean)context.getSession().getAttribute("User");
	      if (filtroDesc == null && filtroDesc2 == null) {
	    	  
	    	 
	    	selectList.buildListAllerte(db,utente.getSiteId());
	      } else {
	        selectList.buildListAllerteFiltro(db, "id_allerta", filtroDesc,"assigned_date",filtroDesc2, utente.getSiteId());
	      }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("FiltroDesc2", filtroDesc2);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupAllertaOK");
}
  
  
  public String executeCommandPopupSelectorDownloadModulo(ActionContext context) {
	    String modulo;
	    modulo = (String)context.getRequest().getParameter("nomeModulo");
	    context.getRequest().setAttribute("nomeModulo",modulo);
	    return ("PopLookupDownloadModuloOk");
}
  
  
  
  public String executeCommandPopupSelectorUtentiGisa(ActionContext context) {
	    Connection db = null;
	    int idAsl = -1;
	    idAsl = Integer.parseInt(context.getRequest().getParameter("idasl"));
	    CustomLookupList selectList = null;
	    context.getRequest().setAttribute("idasl", idAsl);
	    String filtroDesc = null;
	    String filtroDesc2 = null;
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
		}
	    if (context.getRequest().getParameter("filtroDesc1") != null) {
		      filtroDesc2 = context.getRequest().getParameter("filtroDesc1");
			}
	    
	    try {
	      db = this.getConnection(context);
	      selectList = new CustomLookupList();
	      selectList.setTableName("access");
	      selectList.addField("*");
	     
	      if (filtroDesc == null && filtroDesc2 == null) {
	    	  
	    	 
	    	selectList.buildListUserGisa(db, idAsl);
	      } else {
	        selectList.buildListUserGisaRicerca(db, idAsl, filtroDesc, filtroDesc2);
	      }
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("FiltroDesc2", filtroDesc2);

	    return ("PopLookupUtentiGisaOK");
}
  
  
  
  
  
  
  public String executeCommandMolluschi( ActionContext context ) throws IOException
  {
		HttpServletRequest request =  context.getRequest();
		HttpServletResponse response = context.getResponse();
		String tipologia = request.getParameter("tipo_acqua");				
		ServletOutputStream  sos = response.getOutputStream();
		response.setHeader("Cache-Control","no-store"); 
		response.setHeader("Pragma","no-cache");
		response.setContentType("text/plain");
		Connection db = null ;
		
	

		try
		{

			db = getConnection(context);
			String query_limit = 	" SELECT distinct moll.code , moll.description from lookup_molluschi moll , banchi_zone_molluschi bz_moll,organization o  " +
									" where  o.org_id = bz_moll.id_acqua and o.tipologia =201 and o.tipologia_acque = "+tipologia+" and" +
									" bz_moll.id_mollusco = moll.code and o.trashed_date is null and moll.enabled = true ";

			

			Statement s_limit = db.createStatement();
			ResultSet rs_limit = s_limit.executeQuery(query_limit);
			JSONArray json_array = new JSONArray();
			 int i = 0;
		
			String descrizione = "" ;
			JSONObject json_obj1 = new JSONObject(); 
			json_obj1.put("id","-1");
			json_obj1.put("descrizione","- SELEZIONA VOCE -");
			json_array.put(i++, json_obj1);
			while(rs_limit.next()) {
				JSONObject json_obj = new JSONObject(); 

				json_obj.put("id",rs_limit.getString("code"));
				json_obj.put("descrizione",rs_limit.getString("description"));
				json_array.put(i++, json_obj);
			}

			JSONObject final_json_obj = new JSONObject();
			final_json_obj.put("elements", json_array);
			String json_str = final_json_obj.toString();
			//log.debug("json_str:  " + json_str);

			s_limit.close();
			
			sos.println(json_str);
			sos.close();

			//log.info("Lista Mvs OK");	    

		} catch (Exception e) {
			e.printStackTrace();
		}
		finally
		{
			this.freeConnection(context, db);
		}
		return "-none-";
	}
  
  public String executeCommandClassiAcque( ActionContext context ) throws IOException
  {
		HttpServletRequest request =  context.getRequest();
		HttpServletResponse response = context.getResponse();
		String tipologia = request.getParameter("tipo_acqua");				
		ServletOutputStream  sos = response.getOutputStream();
		response.setHeader("Cache-Control","no-store"); 
		response.setHeader("Pragma","no-cache");
		response.setContentType("text/plain");
		Connection db = null ;
		

		try
		{

			db = getConnection(context);
			String query_limit = 	" SELECT distinct classi.code , classi.description from lookup_classi_acque classi,organization o  " +
									" where   o.tipologia =201 and o.tipologia_acque = "+tipologia+" and o.classificazione = classi.code and" +
									" o.trashed_date is null and classi.enabled = true ";

			

			Statement s_limit = db.createStatement();
			ResultSet rs_limit = s_limit.executeQuery(query_limit);
			JSONArray json_array = new JSONArray();
			 int i = 0;
		
			String descrizione = "" ;
			JSONObject json_obj1 = new JSONObject(); 
			json_obj1.put("id","-1");
			json_obj1.put("descrizione","- SELEZIONA VOCE -");
			json_array.put(i++, json_obj1);
			while(rs_limit.next()) {
				JSONObject json_obj = new JSONObject(); 

				json_obj.put("id",rs_limit.getString("code"));
				json_obj.put("descrizione",rs_limit.getString("description"));
				json_array.put(i++, json_obj);
			}

			JSONObject final_json_obj = new JSONObject();
			final_json_obj.put("elements", json_array);
			String json_str = final_json_obj.toString();
			//log.debug("json_str:  " + json_str);

			s_limit.close();
			
			sos.println(json_str);
			sos.close();

			//log.info("Lista Mvs OK");	    

		} catch (Exception e) {
			e.printStackTrace();
		}
		finally
		{
			this.freeConnection(context, db);
		}
		return "-none-";
	}
  
  public String executeCommandStatoConcessione( ActionContext context ) throws IOException
	{
		HttpServletRequest request =  context.getRequest();
		HttpServletResponse response = context.getResponse();

		ServletOutputStream  sos = response.getOutputStream();
		response.setHeader("Cache-Control","no-store"); 
		response.setHeader("Pragma","no-cache");
		response.setContentType("text/plain");
		Connection db = null ;
		
	

		try
		{

			db = getConnection(context);
			String query_limit = 	" SELECT code , description from lookup_stato_concessione where enabled = true order by level";
			Statement s_limit = db.createStatement();
			ResultSet rs_limit = s_limit.executeQuery(query_limit);
			JSONArray json_array = new JSONArray();
			int i = 0;
			String descrizione = "" ;
			JSONObject json_obj1 = new JSONObject(); 
			json_obj1.put("id","-1");
			json_obj1.put("descrizione","- SELEZIONA VOCE -");
			json_array.put(i++, json_obj1);
			while(rs_limit.next()) {
				JSONObject json_obj = new JSONObject(); 

				json_obj.put("id",rs_limit.getString("code"));
				json_obj.put("descrizione",rs_limit.getString("description"));
				json_array.put(i++, json_obj);
			}

			JSONObject final_json_obj = new JSONObject();
			final_json_obj.put("elements", json_array);
			String json_str = final_json_obj.toString();
			//log.debug("json_str:  " + json_str);

			s_limit.close();
			
			sos.println(json_str);
			sos.close();

			//log.info("Lista Mvs OK");	    

		} catch (Exception e) {
			e.printStackTrace();
		}
		finally
		{
			this.freeConnection(context, db);
		}
		return "-none-";
	}
  
  
  public String executeCommandPopupSelectorPianiMonitoraggioCU(ActionContext context) {
	  Connection db = null;
	    CustomLookupList selectList = null;
	    String tableName = context.getRequest().getParameter("table");
	    String filtroDesc = "";
	    String displayFieldId = null;
	    String displayFieldId2 = null;
	    int idAsl = Integer.parseInt(context.getRequest().getParameter("idAsl"));
	    
	    UserBean user = (UserBean)context.getRequest().getSession().getAttribute("User");
	    if(user.getSiteId()!=-1)
	    {
	    	idAsl = user.getSiteId() ;
	    }
	    
	    ArrayList<Integer> lista_piani_sel=new ArrayList<Integer>();
	    
	    context.getRequest().setAttribute("listaPianiSel", context.getRequest().getParameterValues("listaPianiSelezionati"));
		   
	    String[] array_lista_piani_sel = context.getRequest().getParameterValues("listaPianiSelezionati");//listaPianiSel.split(";");
	   if (array_lista_piani_sel != null )
	    for(int i=0;i<array_lista_piani_sel.length; i++)
	    	if(!array_lista_piani_sel[i].equals(""))
	    		lista_piani_sel.add(Integer.parseInt(array_lista_piani_sel[i]));
	   
	
	    String link = "LookupSelector.do?command=PopupSelectorPianiMonitoraggioCU";
	    if (context.getRequest().getParameter("displayFieldId") != null) {
	      displayFieldId = context.getRequest().getParameter("displayFieldId");
	    }
	    if (context.getRequest().getParameter("displayFieldId2") != null) {
	      displayFieldId2 = context.getRequest().getParameter("displayFieldId2");
	    }
	    if (context.getRequest().getParameter("filtroDesc") != null) {
	      filtroDesc = context.getRequest().getParameter("filtroDesc");
	      link += "&filtroDesc="+filtroDesc;
		}
	    
	    
	    
	    String tipi_piani = null ; 
	    String val = "" ;
	    if (context.getRequest().getParameter("tipo") != null) {
	    	tipi_piani = context.getRequest().getParameter("tipo");
	    	//for (int k = 0 ; k<tipi_piani.length-1; k++)
	    		//val +=tipi_piani[k]+",";
	    	//val += tipi_piani[tipi_piani.length-1];
	        link += "&tipo="+tipi_piani;
	  	}
	    link += "&table="+tableName ;
	    
	    selectList = new CustomLookupList();
	    
	    PagedListInfo searchListInfo = this.getPagedListInfo(
				  context, "SearchPianiListCuInfo");
		  searchListInfo.setLink(link);
		  
		  searchListInfo.setSearchCriteria(selectList, context);
			  selectList.setPagedListInfo(searchListInfo);
			  
	    try {
	      db = this.getConnection(context);
	      LookupList lista_lookup = new LookupList(db,"lookup_piano_monitoraggio");
	      context.getRequest().setAttribute("ListaPianiLookup", lista_lookup);

	      LookupList lookup_gruppi_piani = new LookupList(db,"lookup_sezioni_piani_monitoraggio");
	      lookup_gruppi_piani.addItem(-1, "-SELEZIONA SEZIONE DI MONITORAGGIO-");
	      context.getRequest().setAttribute("lookup_sezioni_piani", lookup_gruppi_piani);
	      
	      
	      selectList.setTableName(tableName);
	      selectList.setTipi_piani(tipi_piani);
	      selectList.buildListPianiCu(db,filtroDesc,idAsl,lista_piani_sel);
	     
	     
	  	  
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      context.getRequest().setAttribute("BaseList", selectList);
	      this.freeConnection(context, db);
	    }
	    
	    context.getRequest().setAttribute("idAsl", idAsl);
	    context.getRequest().setAttribute("TipiPiani", tipi_piani);
	    context.getRequest().setAttribute("DisplayFieldId", displayFieldId);
	    context.getRequest().setAttribute("DisplayFieldId2", displayFieldId2);
	    context.getRequest().setAttribute("FiltroDesc", filtroDesc);
	    context.getRequest().setAttribute("Table", tableName);
	    return ("PopLookupCustomPianiMonitoraggioOK");
	}
  
  public String executeCommandPopupAddAttivitaStabilimento(ActionContext context) {
	  Connection db = null;
	    
	    try {
	      db = this.getConnection(context);
	                                                                                                                            
	      LookupList lookup_impianto = new LookupList(db,"lookup_impianto");
	      lookup_impianto.addItem(-1, "-SELEZIONA -");
	      context.getRequest().setAttribute("impianto", lookup_impianto);
	      
	      LookupList lookup_categoria = new LookupList(db,"lookup_categoria");
	      lookup_categoria.addItem(-1, "-SELEZIONA -");
	      context.getRequest().setAttribute("categoria", lookup_categoria);
	      
	      LookupList statoLab = new LookupList(db,"lookup_stato_lab");
	      statoLab.addItem(-1, "-SELEZIONA -");
	      context.getRequest().setAttribute("statoLab", statoLab);
	      
	      LookupList tipoAutorizzazzione = new LookupList(db,"lookup_sottoattivita_tipoautorizzazione");
	      tipoAutorizzazzione.addItem(-1, "-SELEZIONA -");
	      context.getRequest().setAttribute("tipoAutorizzazzione", tipoAutorizzazzione);
	     
	     
	  	  
	    } catch (Exception e) {
	      context.getRequest().setAttribute("Error", e);
	      return ("SystemError");
	    } finally {
	      this.freeConnection(context, db);
	    }
	   
	    return ("PopLookupAddAttivitastabilimentoOK");
	}
  
  
   
  
 
}

