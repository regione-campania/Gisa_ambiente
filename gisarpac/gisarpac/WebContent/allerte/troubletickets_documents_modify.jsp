<%-- 
  - Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. DARK HORSE
  - VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL DARK HORSE VENTURES LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Version: $Id: troubletickets_documents_modify.jsp 12404 2005-08-05 17:37:07Z mrajkowski $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.allerte.base.*,com.zeroio.iteam.base.*" %>
<%@ page import="java.text.DateFormat" %>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.allerte.base.Ticket" scope="request"/>
<jsp:useBean id="FileItem" class="com.zeroio.iteam.base.FileItem" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<body onLoad="document.inputForm.subject.focus();">
<form method="post" name="inputForm" action="TroubleTicketsDocumentsAllerte.do?command=Update" onSubmit="return checkFileForm(this);">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="TroubleTicketsAllerte.do"><dhv:label name="sanzionis">Allerte</dhv:label></a> > 
<% if ("yes".equals((String)session.getAttribute("searchTickets"))) {%>
  <a href="TroubleTicketsAllerte.do?command=SearchTicketsForm"><dhv:label name="tickets.searchForm">Search Form</dhv:label></a> >
  <a href="TroubleTicketsAllerte.do?command=SearchTickets"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
<%}else{%> 
  <a href="TroubleTicketsAllerte.do?command=Home"><dhv:label name="sanzioni.visualizza">Visualizza Allerta</dhv:label></a> >
<%}%>
<a href="TroubleTicketsAllerte.do?command=Details&id=<%= TicketDetails.getId() %>"><dhv:label name="sanzioni.dettagli">Scheda Allerta</dhv:label></a> >
<a href="TroubleTicketsDocumentsAllerte.do?command=View&tId=<%=TicketDetails.getId()%>"><dhv:label name="accounts.accounts_documents_details.Documents">Documents</dhv:label></a> >
<dhv:label name="accounts.accounts_documents_modify.ModifyDocument">Modify Document</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<% String param1 = "id=" + TicketDetails.getId(); %>
<dhv:container name="allerte" selected="documents" object="TicketDetails" param="<%= param1 %>">
  <%@ include file="ticket_header_include.jsp" %>
  <table border="0" cellpadding="4" cellspacing="0" width="100%">
    <tr class="subtab">
      <td>
        <%
          String documentLink = "TroubleTicketsDocumentsAllerte.do?command=View&tId="+TicketDetails.getId()+"&column=subject";
          String documentModule = "HelpDesk";
        %>
        <zeroio:folderHierarchy module="<%= documentModule %>" link="<%= documentLink %>"/>
      </td>
    </tr>
  </table><br />
  <dhv:formMessage showSpace="false"/>
  <%@ include file="documents_modify_include.jsp" %>
  <br>
  <input type="submit" value="<dhv:label name="global.button.update">Update</dhv:label>" name="update">
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.dosubmit.value='false';this.form.action='TroubleTicketsDocumentsAllerte.do?command=View&tId=<%= TicketDetails.getId() %>';">
  <input type="hidden" name="dosubmit" value="true" />
  <input type="hidden" name="tId" value="<%= TicketDetails.getId() %>" />
  <input type="hidden" name="fid" value="<%= FileItem.getId() %>" />
  <input type="hidden" name="folderId" value="<%= request.getParameter("folderId") %>" />
</dhv:container>
</form>
</body>
