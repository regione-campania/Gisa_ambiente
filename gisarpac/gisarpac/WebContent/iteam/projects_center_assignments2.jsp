<%-- 
  - Copyright(c) 2004 Team Elements LLC (http://www.teamelements.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Team Elements LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. TEAM ELEMENTS
  - LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL TEAM ELEMENTS LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Author(s): Matt Rajkowski
  - Version: $Id: projects_center_assignments2.jsp 11310 2005-04-13 20:05:00Z mrajkowski $
  - Description:
  --%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,com.zeroio.iteam.base.*" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="Project" class="com.zeroio.iteam.base.Project" scope="request"/>
<jsp:useBean id="requirement" class="com.zeroio.iteam.base.Requirement" scope="request"/>
<jsp:useBean id="projectAssignmentsInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>
<%@ include file="initPopupMenu.jsp" %>
<%@ include file="projects_center_assignments_menu.jsp" %>
<%-- Preload image rollovers for drop-down menu --%>
<script language="JavaScript" type="text/javascript">
  loadImages('menu');
</script>
<script language="JavaScript" type="text/javascript" src="javascript/popURL.js"></script>
<script language="JavaScript" type="text/javascript">
  function selectActivity(row, activityId) {
    //TODO: Hide the previous selection, so maintain a currentId
    if (document.layers) {
      alert("Method2");
      E = document.layers["tr" + row];
      while (E.tagName != "TR") {
        E = E.parentNode;
      }
      rowToChange = E;
      for (i=0; i< rowToChange.childNodes.length; i++) {
        if (rowToChange.childNodes.item(i).tagName == "TD") {
          //TODO: both cases
          rowToChange.childNodes.item(i).className = "title";
        }
      }
    } else {
      E = document.getElementById("tr" + row);
      //while (E.tagName != "TR"){
        //E = E.parentElement;
      //}
      if (E.className == "row1") {
        E.className = "title";
      } else {
        E.className = "title";
      }
    }
  }
  
</script>
<table border="0" cellpadding="1" cellspacing="0" width="100%">
  <tr class="subtab">
    <td>
      <img border="0" src="images/icons/stock_list_bullet2-16.gif" align="absmiddle">
      <a href="ProjectManagement.do?command=ProjectCenter&section=Requirements&pid=<%= Project.getId() %>"><dhv:label name="project.outlines">Outlines</dhv:label></a> >
      <%= toHtml(requirement.getShortDescription()) %>
    </td>
  </tr>
</table>
<br>
<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <form name="listView" method="post" action="ProjectManagement.do?command=ProjectCenter&section=Assignments&pid=<%= Project.getId() %>&rid=<%= requirement.getId() %>">
    <td align="left">
      <img alt="" src="images/icons/stock_filter-data-by-criteria-16.gif" align="absmiddle">
      <select size="1" name="listView" onChange="javascript:document.forms['listView'].submit();">
        <option <%= projectAssignmentsInfo.getOptionValue("all") %>><dhv:label name="project.allActivities">All Activities</dhv:label></option>
        <option <%= projectAssignmentsInfo.getOptionValue("open") %>><dhv:label name="project.openActivities">Open Activities</dhv:label></option>
        <option <%= projectAssignmentsInfo.getOptionValue("closed") %>><dhv:label name="project.closedActivities">Closed Activities</dhv:label></option>
      </select>
    </td>
    </form>
  </tr>
</table>
<%-- Plan Header --%>
<table cellpadding="0" cellspacing="0" width="100%" border="1" rules="cols">
  <tr>
    <td class="section" nowrap><strong><dhv:label name="project.outlines">Outlines</dhv:label></strong></td>
    <td class="section" align="center" nowrap><strong><dhv:label name="accounts.accounts_contacts_calls_list.AssignedTo">Assigned To</dhv:label></strong></td>
    <td class="section" align="center"><strong><dhv:label name="project.effort">Effort</dhv:label></strong></td>
    <td class="section" align="center"><strong><dhv:label name="project.start">Start</dhv:label></strong></td>
    <td class="section" align="center" nowrap><strong>&nbsp;<dhv:label name="project.end">End</dhv:label>&nbsp;</strong></td>
  </tr>
<%
  Requirement thisRequirement = requirement;
%>
  <%-- Show the requirement --%>
  <tr class="section">
    <td valign="top" width="100%">
      <img border="0" src="images/select-open.gif" align="absmiddle">
      <img border="0" src="images/icons/stock_list_bullet-16.gif" align="absmiddle">
      <%= toHtml(thisRequirement.getShortDescription()) %>
      <a href="javascript:displayMenu('menur<%= thisRequirement.getId() %>', 'menuRequirement',<%= Project.getId() %>,<%= thisRequirement.getId() %>,-1,-1);"
         onMouseOver="over(0, 'r<%= thisRequirement.getId() %>')"
         onmouseout="out(0, 'r<%= thisRequirement.getId() %>'); hideMenu('menuRequirement');"><img 
        src="images/menu.gif" name="menur<%= thisRequirement.getId() %>" id="menur<%= thisRequirement.getId() %>" align="absmiddle" border="0"></a>
      (<%= thisRequirement.getPlanActivityCount() %> activit<%= (thisRequirement.getAssignments().size() == 1?"y":"ies") %>)
    </td>
    <td>
      &nbsp;
    </td>
    <td valign="top" align="center" nowrap>
      <%= thisRequirement.getEstimatedLoeString() %>
    </td>
    <td valign="top" align="center" nowrap>
      <%= thisRequirement.getStartDateString() %>
    </td>
    <td valign="top" align="center" nowrap>
      <%= thisRequirement.getDeadlineString() %>
    </td>
  </tr>
<%
    AssignmentFolder plan = thisRequirement.getPlan();
    Iterator planIterator = plan.getPlanIterator();
    HashMap treeStatus = new HashMap();
    int rowid = 0;
    int rowCount = 0;
    while (planIterator.hasNext()) {
      ++rowCount;
      rowid = (rowid != 1?1:2);
      Object planItem = (Object) planIterator.next();
      if (planItem instanceof Assignment) {
        //Assignments
        Assignment thisAssignment = (Assignment) planItem;
%>
  <%-- Show the assignment --%>
  <tr id="tr<%= rowCount %>" class="row<%= rowid %>">
    <td valign="top" nowrap>
    <a href="javascript:selectActivity(<%= rowCount %>, <%= thisAssignment.getId() %>);"><img 
       border="0" src="images/select-open.gif" align="absmiddle"></a>
    
<%
      for (int count = 0; count < thisAssignment.getDisplayLevel() + 1; count++) {
        boolean levelOpen = thisAssignment.getLevelOpen();
        boolean folderOpen = false;
        Boolean test = (Boolean) treeStatus.get(new Integer(count));
        if (test != null) {
          folderOpen = test.booleanValue();
        }
%>
    <dhv:evaluate if="<%= folderOpen && count != thisAssignment.getDisplayLevel() %>">
      <img border="0" src="images/tree2.gif" align="absmiddle" height="16" width="19">
    </dhv:evaluate>
    <dhv:evaluate if="<%= levelOpen && count == thisAssignment.getDisplayLevel() %>">  
      <img border="0" src="images/tree3.gif" align="absmiddle" height="16" width="19">
    </dhv:evaluate>
    <dhv:evaluate if="<%= !levelOpen && count == thisAssignment.getDisplayLevel() %>">  
      <img border="0" src="images/tree4.gif" align="absmiddle" height="16" width="19">
    </dhv:evaluate>
    <%--
    <dhv:evaluate if="<%= !folderOpen && count != thisAssignment.getDisplayLevel() %>">
      <img border="0" src="images/treespace.gif" align="absmiddle" height="16" width="19">
    </dhv:evaluate>
    --%>
<%
      }
%>
      <%= thisAssignment.getStatusGraphicTag() %>
      <a href="javascript:popURL('ProjectManagementAssignments.do?command=Modify&pid=<%= Project.getId() %>&aid=<%= thisAssignment.getId() %>&popup=true&return=ProjectAssignments','CFS_Assignment','650','375','yes','no');" style="text-decoration:none;color:black;" onMouseOver="this.style.color='blue';window.status='Update this assignment';return true;" onMouseOut="this.style.color='black';window.status='';return true;"><%= toHtml(thisAssignment.getRole()) %></a>
      <a href="javascript:displayMenu('menua<%= thisAssignment.getId() %>', 'menuActivity',<%= Project.getId() %>,<%= thisRequirement.getId() %>,-1,<%= thisAssignment.getId() %>);"
         onMouseOver="over(0, 'a<%= thisAssignment.getId() %>')"
         onmouseout="out(0, 'a<%= thisAssignment.getId() %>'); hideMenu('menuActivity');"><img 
        src="images/menu.gif" name="menua<%= thisAssignment.getId() %>" id="menua<%= thisAssignment.getId() %>" align="absmiddle" border="0"></a>
    </td>
    <td valign="top" align="center" nowrap>
      <dhv:username id="<%= thisAssignment.getUserAssignedId() %>"/>
    </td>
    <td valign="top" align="center" nowrap>
      <%= thisAssignment.getEstimatedLoeString() %>
    </td>
    <td valign="top" align="center" nowrap>
      <%= thisAssignment.getEstStartDateString() %>
    </td>
    <td valign="top" align="center" nowrap>
      <%= thisAssignment.getRelativeDueDateString(User.getTimeZone(), User.getLocale()) %>
    </td>
  </tr>
<%
      } else if (planItem instanceof AssignmentFolder) {
        //AssignmentFolders
        AssignmentFolder thisFolder = (AssignmentFolder) planItem;
%>
  <%-- Show the assignment folder --%>
  <tr class="row<%= rowid %>">
    <td valign="top" nowrap>
    <img border="0" src="images/select-open.gif" align="absmiddle">
<%
      treeStatus.put(new Integer(0), new Boolean(false));
      treeStatus.put(new Integer(thisFolder.getDisplayLevel()), new Boolean(thisFolder.getLevelOpen()));
      for (int count = 0; count < thisFolder.getDisplayLevel() + 1; count++) {
        boolean folderOpen = ((Boolean) treeStatus.get(new Integer(count))).booleanValue();
%>
    <dhv:evaluate if="<%= folderOpen && count != thisFolder.getDisplayLevel() %>">  
      <img border="0" src="images/tree2.gif" align="absmiddle" height="16" width="19">
    </dhv:evaluate>
    <dhv:evaluate if="<%= folderOpen && count == thisFolder.getDisplayLevel() %>">  
      <dhv:evaluate if="<%= thisFolder.getTreeOpen() %>">
        <a href="javascript:scrollReload('ProjectManagement.do?command=ProjectCenter&section=Assignments&rid=<%= requirement.getId() %>&pid=<%= Project.getId() %>&contract=<%= thisFolder.getId() %>');"><img border="0" src="images/tree5o.gif" align="absmiddle" height="16" width="19"></a>
      </dhv:evaluate>
      <dhv:evaluate if="<%= !thisFolder.getTreeOpen() %>">
        <a href="javascript:scrollReload('ProjectManagement.do?command=ProjectCenter&section=Assignments&rid=<%= requirement.getId() %>&pid=<%= Project.getId() %>&expand=<%= thisFolder.getId() %>');"><img border="0" src="images/tree5c.gif" align="absmiddle" height="16" width="19"></a>
      </dhv:evaluate>
    </dhv:evaluate>
    <dhv:evaluate if="<%= !folderOpen && count == thisFolder.getDisplayLevel() %>">  
      <dhv:evaluate if="<%= thisFolder.getTreeOpen() %>">
        <a href="javascript:scrollReload('ProjectManagement.do?command=ProjectCenter&section=Assignments&rid=<%= requirement.getId() %>&pid=<%= Project.getId() %>&contract=<%= thisFolder.getId() %>');"><img border="0" src="images/tree5o.gif" align="absmiddle" height="16" width="19"></a>
      </dhv:evaluate>
      <dhv:evaluate if="<%= !thisFolder.getTreeOpen() %>">
        <a href="javascript:scrollReload('ProjectManagement.do?command=ProjectCenter&section=Assignments&rid=<%= requirement.getId() %>&pid=<%= Project.getId() %>&expand=<%= thisFolder.getId() %>');"><img border="0" src="images/tree5c.gif" align="absmiddle" height="16" width="19"></a>
      </dhv:evaluate>
    </dhv:evaluate>
    <%--
    <dhv:evaluate if="<%= !folderOpen && count != thisFolder.getDisplayLevel() %>">
      <img border="0" src="images/treespace.gif" align="absmiddle" height="16" width="19">
    </dhv:evaluate>
    --%>
<%    }   %>
    <dhv:evaluate if="<%= thisFolder.getTreeOpen() %>">
      <img border="0" src="images/icons/stock_open-16-19.gif" align="absmiddle">
    </dhv:evaluate>
    <dhv:evaluate if="<%= !thisFolder.getTreeOpen() %>">
      <img border="0" src="images/icons/stock_folder-16-19.gif" align="absmiddle">
    </dhv:evaluate>
      <a href="javascript:popURL('ProjectManagementAssignmentsFolder.do?command=ModifyFolder&pid=<%= Project.getId() %>&folderId=<%= thisFolder.getId() %>&popup=true&return=ProjectAssignments','CFS_Assignment_Folder','650','375','yes','no');" style="text-decoration:none;color:black;" onMouseOver="this.style.color='blue';window.status='Update this folder';return true;" onMouseOut="this.style.color='black';window.status='';return true;"><%= toHtml(thisFolder.getName()) %></a>
      <a href="javascript:displayMenu('menuf<%= thisFolder.getId() %>', 'menuFolder',<%= Project.getId() %>,<%= thisRequirement.getId() %>,<%= thisFolder.getId() %>,-1);"
         onMouseOver="over(0, 'f<%= thisFolder.getId() %>')"
         onmouseout="out(0, 'f<%= thisFolder.getId() %>');hideMenu('menuFolder');"><img 
        src="images/menu.gif" name="menuf<%= thisFolder.getId() %>" id="menuf<%= thisFolder.getId() %>" align="absmiddle" border="0"></a>
    </td>
    <td>
      &nbsp;
    </td>
    <td>
      &nbsp;
    </td>
    <td valign="top" align="center" nowrap>
      &nbsp;
    </td>
    <td valign="top" align="center" nowrap>
      &nbsp;
    </td>
  </tr>
<%
      }
    }
%>
</table>
<br>
<%-- Legend --%>
<table border="0" width="100%">
  <tr>
    <td width>
      <img border="0" src="images/box.gif" alt="<dhv:label name='quotes.incomplete'>Incomplete</dhv:label>" align="absmiddle">
      <dhv:label name="project.itemIsIncomplete">Item is incomplete</dhv:label><br>
      <img border="0" src="images/box-checked.gif" alt="<dhv:label name='alt.completed'>Completed</dhv:label>" align="absmiddle">
      <dhv:label name="project.itemHasBeenCompleted">Item has been completed</dhv:label><br>
      <img border="0" src="images/box-closed.gif" alt="<dhv:label name='quotes.closed'>Closed</dhv:label>" align="absmiddle">
      <dhv:label name="project.itemClosed">Item has been closed</dhv:label><br>
      <img border="0" src="images/box-hold.gif" alt="<dhv:label name='alt.onHold'>On Hold</dhv:label>" align="absmiddle">
      <dhv:label name="project.itemOnHold">Item is on hold</dhv:label>
    </td>
  </tr>
</table>
