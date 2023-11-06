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
  - Version: $Id: projects_center_lists_details.jsp 18488 2007-01-15 20:12:32Z matt $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.tasks.base.*,com.zeroio.iteam.base.*,org.aspcfs.utils.web.*" %>
<jsp:useBean id="Project" class="com.zeroio.iteam.base.Project" scope="request"/>
<jsp:useBean id="category" class="org.aspcfs.modules.tasks.base.TaskCategory" scope="request"/>
<jsp:useBean id="Task" class="org.aspcfs.modules.tasks.base.Task" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="project.listItem">List Item</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel"><dhv:label name="accounts.accountasset_include.Description">Description</dhv:label></td>
    <td>
      <img border="0" src="images/box<%= Task.getComplete()?"-checked":"" %>.gif" alt="" align="absmiddle">
      <%= toHtml(Task.getDescription()) %>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel"><dhv:label name="accounts.accounts_contacts_calls_details_followup_include.Priority">Priority</dhv:label></td>
    <td>
      <%= Task.getPriority() %>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel" valign="top"><dhv:label name="accounts.accounts_add.Notes">Notes</dhv:label></td>
    <td>
      <%= toHtml(Task.getNotes()) %>
    </td>
  </tr>
  <tr class="containerBody">
    <td class="formLabel" valign="top"><dhv:label name="accounts.accounts_calls_list.Entered">Entered</dhv:label></td>
    <td>
      <dhv:username id="<%= Task.getEnteredBy() %>"/>
      <zeroio:tz timestamp="<%= Task.getEntered() %>" timeZone="<%= User.getTimeZone() %>" showTimeZone="true"/>
    </td>
  </tr>
  <tr class="containerBody">
    <td class="formLabel" valign="top"><dhv:label name="accounts.accounts_contacts_calls_details.Modified">Modified</dhv:label></td>
    <td>
      <dhv:username id="<%= Task.getModifiedBy() %>"/>
      <zeroio:tz timestamp="<%= Task.getModified() %>" timeZone="<%= User.getTimeZone() %>" showTimeZone="true"/>
    </td>
  </tr>
</table>
<dhv:evaluate if='<%= "true".equals(request.getParameter("popup")) %>'>
<br>
<input type="button" value="<dhv:label name="button.close">Close</dhv:label>" onClick="javascript:window.close()">
</dhv:evaluate>
