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
  - Version: $Id: accounts_documents_folders_add.jsp 18488 2007-01-15 20:12:32Z matt $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,com.zeroio.iteam.base.*" %>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.abusivismi.base.Organization" scope="request"/>
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
<form method="POST" name="inputForm" action="AccountsDocumentsFoldersAbus.do?command=Save&auto-populate=true<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>" onSubmit="return checkForm(this);">
<dhv:evaluate if="<%= !isPopup(request) %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Abusivismi.do"><dhv:label name="abusivismi.abusivismi">Accounts</dhv:label></a> > 
<a href="Abusivismi.do?command=Search"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
<a href="Abusivismi.do?command=Details&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="abusivismi.details">Account Details</dhv:label></a> >
<a href="AccountsDocumentsAbus.do?command=List&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="abusivismi.abusivismi_documents_details.Documents">Documents</dhv:label></a> >
<% if(fileFolder.getId() > -1) {%>
  <dhv:label name="abusivismi.abusivismi_documents_folders_add.ModifyFolder">Modify Folder</dhv:label>
<%} else {%>
  <dhv:label name="documents.documents.newFolder">New Folder</dhv:label>
<%}%>


</td>
</tr>
</table>
<%-- End Trails --%>
</dhv:evaluate>
<dhv:container name="abusivismi" selected="documents" object="OrgDetails" hideContainer='<%= "true".equals(request.getParameter("actionplan")) %>' param='<%= "orgId=" + OrgDetails.getOrgId() %>' appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>'>
<table border="0" cellpadding="4" cellspacing="0" width="100%">
  <tr class="subtab">
    <td>
<%
String documentFolderList = "AccountsDocumentsAbus.do?command=View&orgId="+OrgDetails.getOrgId()+ addLinkParams(request, "popup|popupType|actionId|actionplan");
String documentModule = "Accounts";
%>
      <zeroio:folderHierarchy module="<%= documentModule %>" link="<%= documentFolderList %>"/>
    </td>
  </tr>
</table>
<br>
  <input type="submit" value=" <dhv:label name="global.button.save">Save</dhv:label> " name="save" />
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.dosubmit.value='false';this.form.action='AccountsDocumentsAbus.do?command=View&orgId=<%= OrgDetails.getOrgId() %><%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>';" /><br />
  <dhv:formMessage />
  <br />
  <table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
    <tr>
      <th colspan="2">
        <strong>
          <% if(fileFolder.getId() > -1) {%>
            <dhv:label name="abusivismi.abusivismi_documents_list_menuxx.RenameFolder">Rinomina Cartella</dhv:label>
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
  <input type="hidden" name="orgId" value="<%= OrgDetails.getOrgId() %>">
  <input type="hidden" name="id" value="<%= fileFolder.getId() %>">
  <input type="hidden" name="parentId" value="<%= fileFolder.getParentId() %>">
  <input type="hidden" name="folderId" value="<%= request.getParameter("folderId") %>">
  <input type="hidden" name="dosubmit" value="true">
  <input type="submit" value=" <dhv:label name="global.button.save">Save</dhv:label> " name="save" />
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.dosubmit.value='false';this.form.action='AccountsDocumentsAbus.do?command=View&orgId=<%= OrgDetails.getOrgId() %><%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>';" /><br />
</dhv:container>
</form>
</body>
