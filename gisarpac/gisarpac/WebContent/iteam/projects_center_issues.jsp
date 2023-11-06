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
  - Version: $Id: projects_center_issues.jsp 15115 2006-05-31 16:47:51Z matt $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,com.zeroio.iteam.base.*" %>
<jsp:useBean id="SKIN" class="java.lang.String" scope="application"/>
<jsp:useBean id="Project" class="com.zeroio.iteam.base.Project" scope="request"/>
<jsp:useBean id="IssueCategory" class="com.zeroio.iteam.base.IssueCategory" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>
<%@ include file="initPopupMenu.jsp" %>
<%@ include file="projects_center_issues_menu.jsp" %>
<%-- Preload image rollovers --%>
<script language="JavaScript" type="text/javascript">
  loadImages('select_<%= SKIN %>');
</script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<table border="0" cellpadding="1" cellspacing="0" width="100%">
  <tr class="subtab">
    <td>
      <img border="0" src="images/icons/stock_data-explorer-16.gif" align="absmiddle">
      <a href="ProjectManagement.do?command=ProjectCenter&section=Issues_Categories&pid=<%= Project.getId() %>"><dhv:label name="project.forums">Forums</dhv:label></a> >
      <img border="0" src="images/icons/stock_draw-callouts2-16.gif" align="absmiddle">
      <%= toHtml(IssueCategory.getSubject()) %>
    </td>
  </tr>
</table>
<br>
<dhv:evaluate if="<%= !Project.isTrashed() %>" >
  <zeroio:permission name="project-discussion-topics-add">
    <img border="0" src="images/icons/stock_new-callouts-16.gif" align="absmiddle">
    <a href="ProjectManagementIssues.do?command=Add&pid=<%= Project.getId() %>&cid=<%= IssueCategory.getId() %>"><dhv:label name="project.newTopic">New Topic</dhv:label></a><br>
  </zeroio:permission>
</dhv:evaluate>
<%-- Temp. fix for Weblogic --%>
<%
String actionError = showError(request, "actionError");
%>
<dhv:pagedListStatus label="Topics" title="<%= actionError %>" object="projectIssuesInfo"/>
<table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
  <tr>
    <th width="8" nowrap>&nbsp;</th>
    <th width="100%" nowrap><strong><dhv:label name="project.topic">Topic</dhv:label></strong></th>
    <th align="center" nowrap><strong><dhv:label name="project.author">Author</dhv:label></strong></th>
    <th align="center" nowrap><strong><dhv:label name="project.replies">Replies</dhv:label></strong></th>
    <th align="center" nowrap><strong><dhv:label name="project.lastPost">Last Post</dhv:label></strong></th>
  </tr>
<%
  IssueList issues = Project.getIssues();
  if (issues.size() == 0) {
%>
  <tr class="row2">
    <td colspan="5"><dhv:label name="project.noMessagesToDisplay">No messages to display.</dhv:label></td>
  </tr>
<%
  }
  int count = 0;
  int rowid = 0;
  Iterator i = issues.iterator();
  while (i.hasNext()) {
    ++count;
    rowid = (rowid != 1?1:2);
    Issue thisIssue = (Issue) i.next();
%>
  <tr class="row<%= rowid %>">
    <td valign="top" nowrap>
      <a href="javascript:displayMenu('select_<%= SKIN %><%= count %>', 'menuItem', <%= thisIssue.getId() %>, <%= IssueCategory.getId() %>,'<%= Project.isTrashed() %>');"
         onMouseOver="over(0, <%= count %>)"
         onmouseout="out(0, <%= count %>); hideMenu('menuItem');"><img
         src="images/select_<%= SKIN %>.gif" name="select_<%= SKIN %><%= count %>" id="select_<%= SKIN %><%= count %>" align="absmiddle" border="0"></a>
    </td>
    <td valign="top" width="100%">
      <table border="0" cellpadding="0" cellspacing="0" width="100%" class="empty">
        <tr>
          <td valign="top" nowrap>
            <img border="0" src="images/icons/stock_draw-callouts-16.gif" align="absmiddle">&nbsp;
          </td>
          <td valign="top" width="100%">
            <a href="ProjectManagementIssues.do?command=Details&pid=<%= thisIssue.getProjectId() %>&iid=<%= thisIssue.getId() %>&cid=<%= IssueCategory.getId() %>&resetList=true"><%= toHtml(thisIssue.getSubject()) %></a>
          </td>
        </tr>
      </table>
    </td>
    <td valign="top" align="center" nowrap>
      <dhv:username id="<%= thisIssue.getEnteredBy() %>"/>
    </td>
    <td valign="top" align="center" nowrap>
      <%= ((thisIssue.getReplyCount()==0)?"0":""+thisIssue.getReplyCount()) %>
    </td>
    <td valign="top" align="center" nowrap>
      <zeroio:tz timestamp="<%= thisIssue.getReplyDate() %>" timeZone="<%= User.getTimeZone() %>" showTimeZone="true"/><br />
      <%= ((thisIssue.getReplyCount()==0)?"":"by") %>
      <dhv:username id="<%= thisIssue.getReplyBy() %>"/>
    </td>
  </tr>
<%
  }
%>
</table>
<br>
<dhv:pagedListControl object="projectIssuesInfo"/>