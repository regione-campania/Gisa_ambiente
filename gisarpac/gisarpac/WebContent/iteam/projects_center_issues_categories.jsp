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
  - Version: $Id: projects_center_issues_categories.jsp 18488 2007-01-15 20:12:32Z matt $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,com.zeroio.iteam.base.*" %>
<jsp:useBean id="SKIN" class="java.lang.String" scope="application"/>
<jsp:useBean id="Project" class="com.zeroio.iteam.base.Project" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>
<%@ include file="initPopupMenu.jsp" %>
<%@ include file="projects_center_issues_categories_menu.jsp" %>
<%-- Preload image rollovers --%>
<script language="JavaScript" type="text/javascript">
  loadImages('select_<%= SKIN %>');
</script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<table border="0" cellpadding="1" cellspacing="0" width="100%">
  <tr class="subtab">
    <td>
      <img border="0" src="images/icons/stock_data-explorer-16.gif" align="absmiddle">
      <dhv:label name="project.forums">Forums</dhv:label>
    </td>
  </tr>
</table>
<br />
<dhv:evaluate if="<%= !Project.isTrashed() %>" >
  <zeroio:permission name="project-discussion-forums-add">
    <img border="0" src="images/icons/stock_new-callouts2-16.gif" align="absmiddle">
    <a href="ProjectManagementIssueCategories.do?command=Add&pid=<%= Project.getId() %>"><dhv:label name="project.newForum">New Forum</dhv:label></a><br>
  </zeroio:permission>
</dhv:evaluate>
<dhv:pagedListStatus label="Forums" title='<%= showError(request, "actionError") %>' object="projectIssueCategoryInfo"/>
<table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
  <tr>
    <th width="8" nowrap>&nbsp;</th>
    <th width="100%" nowrap><strong><dhv:label name="project.forum">Forum</dhv:label></strong></th>
    <th align="center" nowrap><strong><dhv:label name="project.topics">Topics</dhv:label></strong></th>
    <th align="center" nowrap><strong><dhv:label name="project.posts">Posts</dhv:label></strong></th>
    <th align="center" nowrap><strong><dhv:label name="project.lastPost">Last Post</dhv:label></strong></th>
  </tr>
<%
	IssueCategoryList issueCategoryList = Project.getIssueCategories();
  if (issueCategoryList.size() == 0) {
%>
  <tr class="row2">
    <td colspan="5"><dhv:label name="project.noForumsToDisplay">No forums to display.</dhv:label></td>
  </tr>
<%
  }
  int count = 0;
  int rowid = 0;
  Iterator i = issueCategoryList.iterator();
  while (i.hasNext()) {
    ++count;
    rowid = (rowid != 1?1:2);
    IssueCategory thisCategory = (IssueCategory) i.next();
%>    
  <tr class="row<%= rowid %>">
    <td valign="top" nowrap>
      <a href="javascript:displayMenu('select_<%= SKIN %><%= count %>', 'menuItem', <%= thisCategory.getId() %>,'<%= Project.isTrashed() %>');"
         onMouseOver="over(0, <%= count %>)"
         onmouseout="out(0, <%= count %>); hideMenu('menuItem');"><img 
         src="images/select_<%= SKIN %>.gif" name="select_<%= SKIN %><%= count %>" id="select_<%= SKIN %><%= count %>" align="absmiddle" border="0"></a>
    </td>
    <td valign="top" width="100%">
      <table border="0" cellpadding="0" cellspacing="0" width="100%" class="empty">
        <tr>
          <td valign="top" nowrap>
            <img border="0" src="images/icons/stock_draw-callouts2-16.gif" align="absmiddle">&nbsp;
          </td>
          <td valign="top" width="100%">
            <a href="ProjectManagement.do?command=ProjectCenter&section=Issues&pid=<%= thisCategory.getProjectId() %>&cid=<%= thisCategory.getId() %>&resetList=true"><%= toHtml(thisCategory.getSubject()) %></a>
          </td>
        </tr>
      </table>
    </td>
    <td valign="top" align="center" nowrap>
      <%= ((thisCategory.getTopicsCount()==0) ? "0" : "" + thisCategory.getTopicsCount()) %>
    </td>
    <td valign="top" align="center" nowrap>
      <%= ((thisCategory.getPostsCount()==0) ? "0" : "" + thisCategory.getPostsCount()) %>
    </td>
    <td valign="top" align="center" nowrap>
      <dhv:evaluate if="<%= thisCategory.getPostsCount() > 0 %>">
      <zeroio:tz timestamp="<%= thisCategory.getLastPostDate() %>" timeZone="<%= User.getTimeZone() %>" showTimeZone="true"/><br />
      </dhv:evaluate>
			<dhv:username id="<%= thisCategory.getModifiedBy() %>"/>
    </td>
  </tr>
<%
  }
%>
</table>
<br>
<dhv:pagedListControl object="projectIssueCategoryInfo"/>
