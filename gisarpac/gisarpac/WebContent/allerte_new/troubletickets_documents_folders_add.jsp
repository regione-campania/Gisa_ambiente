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
  - Version: $Id: troubletickets_documents_folders_add.jsp 11310 2005-04-13 20:05:00Z mrajkowski $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,com.zeroio.iteam.base.*, org.aspcfs.modules.allerte_new.base.*" %>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.allerte_new.base.Ticket" scope="request"/>
<jsp:useBean id="fileFolder" class="com.zeroio.iteam.base.FileFolder" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<body onLoad="document.inputForm.subject.focus();">
<script language="JavaScript">
  function checkForm(form) {
    if (form.dosubmit.value == "false") {
      return true;
    }
    var formTest = true;
    var messageText = "";
    if (form.subject.value == "") {
      messageText += label("Name.required", "- Name is required\r\n");
      formTest = false;
    }
    if (formTest == false) {
      messageText = label("Form.not.submitted", "The form could not be submitted.          \r\nPlease verify the following:\r\n\r\n") + messageText;
      form.dosubmit.value = "true";
      alert(messageText);
      return false;
    }
    return true;
  }
</script>
<form method="POST" name="inputForm" action="TroubleTicketsDocumentsFoldersAllerte.do?command=Save&auto-populate=true" onSubmit="return checkForm(this);">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="TroubleTicketsAllerteNew.do"><dhv:label name="sanzionis">Allerte</dhv:label></a> > 
<% if ("yes".equals((String)session.getAttribute("searchTickets"))) {%>
  <a href="TroubleTicketsAllerteNew.do?command=SearchTicketsForm"><dhv:label name="tickets.searchForm">Search Form</dhv:label></a> >
  <a href="TroubleTicketsAllerteNew.do?command=SearchTickets"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
<%}else{%> 
  <a href="TroubleTicketsAllerteNew.do?command=Home"><dhv:label name="sanzioni.visualizza">Visualizza Allerte</dhv:label></a> >
<%}%>
<a href="TroubleTicketsAllerteNew.do?command=Details&id=<%= TicketDetails.getId() %>"><dhv:label name="sanzioni.dettagli">Scheda Allerta</dhv:label></a> >
<a href="TroubleTicketsDocumentsAllerte.do?command=View&tId=<%=TicketDetails.getId()%>"><dhv:label name="accounts.accounts_documents_details.Documents">Documents</dhv:label></a> >
<% if(fileFolder.getId() > -1) {%>
  <dhv:label name="account.ticket.modifyFolderName">Modify Folder Name</dhv:label>
<%} else {%>
  <dhv:label name="documents.documents.newFolder">New Folder</dhv:label>
<%}%>

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
  String documentFolderList = "TroubleTicketsDocumentsAllerte.do?command=View&tId="+TicketDetails.getId()+"&column=subject";
  String documentModule = "HelpDesk";
  %>
        <zeroio:folderHierarchy module="<%= documentModule %>" link="<%= documentFolderList %>"/>
      </td>
    </tr>
  </table>
  <br>
  <input type="submit" value=" <dhv:label name="global.button.save">Save</dhv:label> " name="save">
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.dosubmit.value='false';this.form.action='TroubleTicketsDocumentsAllerte.do?command=View';"><br>
  <%= showError(request, "actionError") %><br>
  <table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
    <tr>
      <th colspan="2">
        <strong>
          <% if(fileFolder.getId() > -1) {%>
            <dhv:label name="accounts.accounts_documents_list_menu.RenameFolder">Rename Folder</dhv:label>
          <%} else {%>
            <dhv:label name="documents.documents.newFolder">New Folder</dhv:label>
          <%}%>
        </strong>
      </th>
    </tr>
    <tr class="containerBody">
      <td nowrap class="formLabel"><dhv:label name="contacts.name">Name</dhv:label></td>
      <td>
        <input type="text" name="subject" size="59" maxlength="255" value="<%= toHtmlValue(fileFolder.getSubject()) %>">
        <input type="hidden" name="display" value="-1"/>
        <font color="red">*</font> <%= showAttribute(request, "subjectError") %>
      </td>
    </tr>
  </table>
  <br>
  <input type="hidden" name="modified" value="<%= fileFolder.getModifiedString() %>">
  <input type="hidden" name="tId" value="<%= TicketDetails.getId() %>">
  <input type="hidden" name="id" value="<%= fileFolder.getId() %>">
  <input type="hidden" name="parentId" value="<%= fileFolder.getParentId() %>">
  <input type="hidden" name="folderId" value="<%= request.getParameter("folderId") %>">
  <input type="hidden" name="dosubmit" value="true">
  <input type="submit" value=" <dhv:label name="global.button.save">Save</dhv:label> " name="save">
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.dosubmit.value='false';this.form.action='TroubleTicketsDocumentsAllerte.do?command=View';"><br>
</dhv:container>
</form>
</body>
