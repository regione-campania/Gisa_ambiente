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
  - Version: $Id: projects_center_lists_categories.jsp 18488 2007-01-15 20:12:32Z matt $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,com.zeroio.iteam.base.*,org.aspcfs.modules.tasks.base.TaskCategory" %>
<jsp:useBean id="SKIN" class="java.lang.String" scope="application"/>
<jsp:useBean id="Project" class="com.zeroio.iteam.base.Project" scope="request"/>
<jsp:useBean id="categoryList" class="org.aspcfs.modules.tasks.base.TaskCategoryList" scope="request"/>
<jsp:useBean id="projectListsCategoriesInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>
<%@ include file="initPopupMenu.jsp" %>
<%@ include file="projects_center_lists_categories_menu.jsp" %>
<%-- Preload image rollovers --%>
<script language="JavaScript" type="text/javascript">
  loadImages('select_<%= SKIN %>');
</script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<table border="0" cellpadding="1" cellspacing="0" width="100%">
  <tr class="subtab">
    <td>
      <img border="0" src="images/icons/stock_list_enum2-16.gif" align="absmiddle">
      <dhv:label name="project.lists">Lists</dhv:label>
    </td>
  </tr>
</table>
<br>
<% if (!Project.isTrashed()){ %>
  <zeroio:permission name="project-lists-add">
  <img border="0" src="images/icons/stock_new_enum-16.gif" align="absmiddle">
  <a href="ProjectManagementListsCategory.do?command=AddCategory&pid=<%= Project.getId() %>"><dhv:label name="project.newList">New List</dhv:label></a><br>
  </zeroio:permission>
<% } %>
<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <form name="pagedListView" method="post" action="ProjectManagement.do?command=ProjectCenter&section=Lists_Categories&pid=<%= Project.getId() %>">
    <td align="left">
      &nbsp;
    </td>
    <td>
      <dhv:pagedListStatus label="Lists" title='<%= showError(request, "actionError") %>' object="projectListsCategoriesInfo"/>
    </td>
    </form>
  </tr>
</table>
<table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
  <tr>
    <th width="8" nowrap>&nbsp;</th>
    <th width="100%" nowrap><strong><dhv:label name="project.list">List</dhv:label></strong></th>
    <th align="center" nowrap><strong><dhv:label name="project.items">Items</dhv:label></strong></th>
    <th align="center" nowrap><strong><dhv:label name="project.lastPost">Last Post</dhv:label></strong></th>
  </tr>
<%    
  if (categoryList.size() == 0) {
%>
  <tr class="row2">
    <td colspan="4"><dhv:label name="project.noListsToDisplay">No lists to display.</dhv:label></td>
  </tr>
<%
  }
  int count = 0;
  int rowid = 0;
  Iterator i = categoryList.iterator();
  while (i.hasNext()) {
    ++count;
    rowid = (rowid != 1?1:2);
    TaskCategory thisCategory = (TaskCategory) i.next();
%>    
  <tr class="row<%= rowid %>">
    <td valign="top" nowrap>
      <a href="javascript:displayMenu('select_<%= SKIN %><%= count %>', 'menuItem', <%= thisCategory.getId() %>,'<%= Project.isTrashed() %>');"
         onMouseOver="over(0, <%= count %>)"
         onmouseout="out(0, <%= count %>); hideMenu('menuItem');"><img 
         src="images/select_<%= SKIN %>.gif" name="select_<%= SKIN %><%= count %>" id="select_<%= SKIN %><%= count %>" align="absmiddle" border="0"></a>
    </td>
    <td width="100%" valign="top">
      <table border="0" cellpadding="0" cellspacing="0" width="100%" class="empty">
        <tr>
          <td valign="top" nowrap>
            <img border="0" src="images/icons/stock_list_enum-16.gif" align="absmiddle" />&nbsp;
          </td>
          <td valign="top" width="100%">
            <a href="ProjectManagement.do?command=ProjectCenter&section=Lists&pid=<%= Project.getId() %>&cid=<%= thisCategory.getId() %>"><%= toHtml(thisCategory.getDescription()) %></a>
          </td>
        </tr>
      </table>
    </td>
    <td valign="top" align="center" nowrap><%= thisCategory.getTaskCount() %></td>
    <td valign="top" align="center" nowrap>
      <zeroio:tz timestamp="<%= thisCategory.getLastTaskEntered() %>" default="--" timeZone="<%= User.getTimeZone() %>" showTimeZone="true"/>
    </td>
  </tr>
<%    
  }
%>
</table>

