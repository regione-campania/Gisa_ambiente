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
  - Version: $Id: projects_center_file_modify.jsp 12404 2005-08-05 17:37:07Z mrajkowski $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,com.zeroio.iteam.base.*" %>
<jsp:useBean id="Project" class="com.zeroio.iteam.base.Project" scope="request"/>
<jsp:useBean id="FileItem" class="com.zeroio.iteam.base.FileItem" scope="request"/>
<%@ include file="../initPage.jsp" %>
<body onLoad="document.inputForm.subject.focus();">
<form method="POST" name="inputForm" action="ProjectManagementFiles.do?command=Update" onSubmit="return checkFileForm(this);">
<script language="JavaScript">
  function checkFileForm(form) {
    if (form.dosubmit.value == "false") {
      return true;
    }
    var formTest = true;
    var messageText = "";
    if (form.subject.value == "") {
      messageText += label("Subject.required", "- Subject is required\r\n");
      formTest = false;
    }
    if ((form.clientFilename.value) == "") {
      messageText += label("Filename.required", "- Filename is required\r\n");
      formTest = false;
    }
    if (formTest == false) {
      form.dosubmit.value = "true";
      messageText = label("Fileinfo.not.submitted", "The file information could not be submitted.          \r\nPlease verify the following items:\r\n\r\n") + messageText;
      alert(messageText);
      return false;
    } else {
      return true;
    }
  }
</script>
<table border="0" cellpadding="1" cellspacing="0" width="100%">
  <tr class="subtab">
    <td>
      <zeroio:folderHierarchy showLastLink="true"/> >
      <%= FileItem.getSubject() %>
    </td>
  </tr>
</table>
<br />
<input type="submit" value="<dhv:label name="global.button.update">Update</dhv:label>" name="update">
<input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.dosubmit.value='false';this.form.action='ProjectManagement.do?command=ProjectCenter&section=File_Library&pid=<%= Project.getId() %>';"><br>
<br />
<table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
  <tr>
    <th colspan="7">
      <strong><dhv:label name="documents.documents.modifyFileInformation">Modify File Information</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel"><dhv:label name="accounts.accounts_contacts_calls_details_include.Subject">Subject</dhv:label></td>
    <td>
      <input type="text" name="subject" size="59" maxlength="255" value="<%= FileItem.getSubject() %>">
      <%= showAttribute(request, "subjectError") %>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel"><dhv:label name="documents.documents.fileName">File Name</dhv:label></td>
    <td>
      <input type="text" name="clientFilename" size="59" maxlength="255" value="<%= FileItem.getClientFilename() %>">
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel"><dhv:label name="documents.documents.currentVersion" param="break=<br />">Current<br />Version</dhv:label></td>
    <td valign="top">
      <%= FileItem.getVersion() %>
    </td>
  </tr>
</table>
<br>
<input type="hidden" name="folderId" value="<%= FileItem.getFolderId() %>">
<input type="submit" value="<dhv:label name="global.button.update">Update</dhv:label>" name="update">
<input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.dosubmit.value='false';this.form.action='ProjectManagement.do?command=ProjectCenter&section=File_Library&pid=<%= Project.getId() %>';">
<input type="hidden" name="dosubmit" value="true">
<input type="hidden" name="pid" value="<%= Project.getId() %>">
<input type="hidden" name="fid" value="<%= FileItem.getId() %>">
</form>
</body>
