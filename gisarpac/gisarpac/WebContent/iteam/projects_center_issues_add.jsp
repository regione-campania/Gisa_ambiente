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
  - Version: $Id: projects_center_issues_add.jsp 11310 2005-04-13 20:05:00Z mrajkowski $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,com.zeroio.iteam.base.*,org.aspcfs.utils.web.*" %>
<jsp:useBean id="Project" class="com.zeroio.iteam.base.Project" scope="request"/>
<jsp:useBean id="Issue" class="com.zeroio.iteam.base.Issue" scope="request"/>
<jsp:useBean id="IssueCategory" class="com.zeroio.iteam.base.IssueCategory" scope="request"/>
<%@ include file="../initPage.jsp" %>
<body onLoad="document.inputForm.subject.focus();">
<script language="JavaScript">
  function checkForm(form) {
    if (form.dosubmit.value == "false") {
      return true;
    }
    var formTest = true;
    var messageText = "";
    //Check required fields
    if (form.subject.value == "") {    
      messageText += label("check.subject","- Subject is a required field\r\n");
      formTest = false;
    }
    if (form.body.value == "") {    
      messageText += label("check.message.required","- Message is a required field\r\n");
      formTest = false;
    }
    if (formTest == false) {
      messageText = label("check.message","The message could not be submitted.          \r\nPlease verify the following items:\r\n\r\n") + messageText;
      form.dosubmit.value = "true";
      alert(messageText);
      return false;
    } else {
      return true;
    }
  }
</script>
<form method="POST" name="inputForm" action="ProjectManagementIssues.do?command=Save&pid=<%= Project.getId() %>&iid=<%= Issue.getId() %>&cid=<%= IssueCategory.getId() %>&auto-populate=true" onSubmit="return checkForm(this);">
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
  <input type="submit" value="<dhv:label name="global.button.save">Save</dhv:label>">
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.dosubmit.value='false';this.form.action='ProjectManagement.do?command=ProjectCenter&section=Issues&pid=<%= Project.getId() %>&cid=<%= IssueCategory.getId() %>';"><br>
  <dhv:formMessage />
  <input type="hidden" name="categoryId" value="<%= IssueCategory.getId() %>">
  <input type="hidden" name="projectId" value="<%= Project.getId() %>">
  <input type="hidden" name="id" value="<%= Issue.getId() %>">
  <input type="hidden" name="modified" value="<%= Issue.getModified() %>">
  <input type="hidden" name="dosubmit" value="true">
  <input type="hidden" name="return" value="<%= request.getParameter("return") %>">
  <table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
    <tr>
      <th colspan="2">
        <strong><dhv:label name="project.topic">Topic</dhv:label></strong>
      </th>
    </tr>
    <tr class="containerBody">
      <td nowrap class="formLabel" valign="top"><dhv:label name="accounts.accounts_contacts_calls_details_include.Subject">Subject</dhv:label></td>
      <td>
        <input type="text" name="subject" size="57" maxlength="50" value="<%= toHtmlValue(Issue.getSubject()) %>"><font color="red">*</font>
        <%= showAttribute(request, "subjectError") %>
      </td>
    </tr>
    <tr class="containerBody">
      <td nowrap class="formLabel" valign="top"><dhv:label name="project.message">Message</dhv:label></td>
      <td>
        <table border="0" cellpadding="0" cellspacing="0" class="empty">
          <tr>
            <td>
              <textarea rows="10" name="body" cols="70"><%= toString(Issue.getBody()) %></textarea>
            </td>
            <td valign="top">
              <font color=red>*</font>
            </td>
          </tr>
        </table>
        <%= showAttribute(request, "bodyError") %>
      </td>
    </tr>
    <dhv:evaluate if="<%= IssueCategory.getAllowFileAttachments() && Issue.getId() == -1 %>">
    <tr class="containerBody">
      <td nowrap class="formLabel" valign="top">File attachment</td>
      <td>
        <input type="file" name="id<%= Project.getId() %>" size="45">
        <%= showAttribute(request, "id" + Project.getId() + "Error") %>
      </td>
    </tr>
    </dhv:evaluate>
  </table>
  <br />
  <input type="submit" value="<dhv:label name="global.button.save">Save</dhv:label>">
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.dosubmit.value='false';this.form.action='ProjectManagement.do?command=ProjectCenter&section=Issues&pid=<%= Project.getId() %>&cid=<%= IssueCategory.getId() %>';"><br>
</form>  
</body>
