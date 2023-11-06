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
  - Version: $Id: projects_center_tickets_add.jsp 11310 2005-04-13 20:05:00Z mrajkowski $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="com.zeroio.iteam.base.*" %>
<%@ page import="org.aspcfs.utils.web.*" %>
<%@ page import="org.aspcfs.modules.troubletickets.base.TicketLog" %>
<%@ page import="org.aspcfs.modules.admin.base.User" %>
<%@ page import="org.aspcfs.modules.contacts.base.Contact" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="Project" class="com.zeroio.iteam.base.Project" scope="request"/>
<jsp:useBean id="ticket" class="org.aspcfs.modules.troubletickets.base.Ticket" scope="request"/>
<jsp:useBean id="DepartmentList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SeverityList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SourceList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="PriorityList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList1" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList2" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList3" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<%--
<jsp:useBean id="ContactList" class="org.aspcfs.modules.contacts.base.ContactList" scope="request"/>
--%>
<%@ include file="../initPage.jsp" %>
<script language="JavaScript" type="text/javascript" src="javascript/spanDisplay.js"></script>
<script language="JavaScript" type="text/javascript" src="javascript/popURL.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<script language="JavaScript">
<!-- Begin
function updateSubList1() {
  var sel = document.forms['ticketForm'].elements['catCode'];
  var value = sel.options[sel.selectedIndex].value;
  var url = "TroubleTickets.do?command=CategoryJSList&form=ticketForm&catCode=" + escape(value);
  window.frames['server_commands'].location.href=url;
}
function updateSubList2() {
  var sel = document.forms['ticketForm'].elements['subCat1'];
  var value = sel.options[sel.selectedIndex].value;
  var url = "TroubleTickets.do?command=CategoryJSList&form=ticketForm&subCat1=" + escape(value);
  window.frames['server_commands'].location.href=url;
}
function updateSubList3() {
  var sel = document.forms['ticketForm'].elements['subCat2'];
  var value = sel.options[sel.selectedIndex].value;
  var url = "TroubleTickets.do?command=CategoryJSList&form=ticketForm&subCat2=" + escape(value);
  window.frames['server_commands'].location.href=url;
}
function updateUserList() {
  var sel = document.forms['ticketForm'].elements['departmentCode'];
  var value = sel.options[sel.selectedIndex].value;
  var url = "TroubleTickets.do?command=DepartmentJSList&form=ticketForm&departmentCode=" + escape(value);
  window.frames['server_commands'].location.href=url;
}
//  End -->
</script>
<body onLoad="document.ticketForm.problem.focus();">
<form name="ticketForm" action="ProjectManagementTickets.do?command=Save&auto-populate=true" method="post">
<table border="0" cellpadding="1" cellspacing="0" width="100%">
  <tr class="subtab">
    <td>
      <img src="images/icons/stock_macro-organizer-16.gif" border="0" align="absmiddle">
      <a href="ProjectManagement.do?command=ProjectCenter&section=Tickets&pid=<%= Project.getId() %>"><dhv:label name="dependency.tickets">Tickets</dhv:label></a> >
      <% if(ticket.getId() == -1) {%>
        <dhv:label name="button.add">Add</dhv:label>
      <%} else {%>
        <dhv:label name="button.update">Update</dhv:label>
      <%}%>
    </td>
  </tr>
</table>
<br>
<% if (ticket.getClosed() != null) { %>
  <input type="submit" value="<dhv:label name="button.reopen">Re-open</dhv:label>" onClick="javascript:this.form.action='ProjectManagementTickets.do?command=Reopen&pid=<%= Project.getId() %>&id=<%= ticket.getId() %>'">
<%} else {%>
  <input type="submit" value="<dhv:label name="global.button.save">Save</dhv:label>">
<%}%>
<% if ("list".equals(request.getParameter("return")) || ticket.getId() == -1) {%>
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='ProjectManagement.do?command=ProjectCenter&section=Tickets&pid=<%= Project.getId() %>'">
<%} else {%> 
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='ProjectManagementTickets.do?command=Details&pid=<%= Project.getId() %>&id=<%= ticket.getId() %>'">
<%}%>
<br />
<dhv:formMessage />
  <%@ include file="projects_center_tickets_add_include.jsp" %>
<br />
<% if (ticket.getClosed() != null) { %>
  <input type="submit" value="<dhv:label name="button.reopen">Reopen</dhv:label>" onClick="javascript:this.form.action='ProjectManagementTickets.do?command=Reopen&pid=<%= Project.getId() %>&id=<%= ticket.getId() %>'">
<%} else {%>
  <input type="submit" value="<dhv:label name="global.button.save">Save</dhv:label>">
<%}%>
<% if ("list".equals(request.getParameter("return")) || ticket.getId() == -1) {%>
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='ProjectManagement.do?command=ProjectCenter&section=Tickets&pid=<%= Project.getId() %>'">
<%} else {%> 
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='ProjectManagementTickets.do?command=Details&pid=<%= Project.getId() %>&id=<%= ticket.getId() %>&return=<%= request.getParameter("return") %>'">
<%}%>
<input type="hidden" name="modified" value="<%= ticket.getModified() %>">
<input type="hidden" name="pid" value="<%= Project.getId() %>">
<input type="hidden" name="id" value="<%= ticket.getId() %>">
<input type="hidden" name="orgId" value="<%= ticket.getOrgId() %>">
<input type="hidden" name="contactId" value="<%= ticket.getContactId() %>">
<input type="hidden" name="companyName" value="<%= toHtmlValue(ticket.getCompanyName()) %>">
<input type="hidden" name="close" value="">
<input type="hidden" name="return" value="<%= toHtmlValue(request.getParameter("return")) %>">
<iframe src="empty.html" name="server_commands" id="server_commands" style="visibility:hidden" height="0" width="0" border="0" frameborder="0"></iframe>
</form>
</body>
