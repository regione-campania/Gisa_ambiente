<%-- 
  - Copyright(c) 2004 Concursive Corporation (http://www.concursive.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Concursive Corporation. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. CONCURSIVE
  - CORPORATION MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL CONCURSIVE CORPORATION OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Version: $Id: admin_roledetails.jsp 24344 2007-12-09 15:18:12Z rambabun@cybage.com $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="org.aspcfs.modules.admin.base.User,java.util.*,org.aspcfs.modules.admin.base.Permission" %>
<%@ include file="../initPage.jsp" %>

<script type="text/javascript" src="dwr/interface/DwrRole.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<script>

function aggiornaPermesso(idRuolo,idPermesso,nomeColonna,field)
{
	valore = false ;
	if (field.checked)
		valore = true;
	
	DwrRole.updareRole(idRuolo,idPermesso,nomeColonna,valore,{callback:aggiornaPermessoCallBack,async:false});
	
}
function aggiornaPermessoCallBack(val)
{
	
	}
</script>

<jsp:useBean id="Role" class="org.aspcfs.modules.admin.base.Role" scope="request"/>
<jsp:useBean id="PermissionList" class="org.aspcfs.modules.admin.base.PermissionList" scope="request"/>

<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Admin.do"><dhv:label name="trails.admin">Admin</dhv:label></a> >
<a href="Roles.do"><dhv:label name="admin.viewRoles">View Roles</dhv:label></a> >
<dhv:label name="admin.updateRole">Update Role</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<input type="hidden" name="id" value="<%= Role.getId() %>">
<input type="hidden" name="modified" value="<%= Role.getModified() %>">
<dhv:permission name="admin-roles-edit">
 
</dhv:permission>
<br>
<dhv:formMessage />
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong><dhv:label name="admin.updateRole">Update Role</dhv:label></strong>
	  </th>
  </tr>
  <tr>
    <td class="formLabel"><dhv:label name="admin.roleName">Role Name</dhv:label></td>
    <td><input type="text" name="role" maxlength="80" size="30" value="<%= toHtmlValue(Role.getRole()) %>"><font color="red">*</font> <%= showAttribute(request, "roleError") %></td>
  </tr>
  <tr>
    <td class="formLabel"><dhv:label name="accounts.accountasset_include.Description">Description</dhv:label></td>
    <td nowrap><input type="text" name="description" maxlength="255" size="60" value="<%= toHtmlValue(Role.getDescription()) %>"><font color="red">*</font> <%= showAttribute(request, "descriptionError") %></td>
  </tr>
 <%--
  <tr>
    <td class="formLabel">
      <dhv:label name="accounts.accounts_contacts_portal_include.PortalRole">Portal Role</dhv:label>?
    </td>
    <td>
    <%
      if (Role.getRoleType() > 0){%>
      <input type="checkbox" name="roleType" value="on" checked></input>
    <%}else{%>
      <input type="checkbox" name="roleType" value="on"></input>
    <%}%>
   </td>
  </tr>
  --%>
</table>
&nbsp;
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="pagedList">
  <tr>
    <th colspan="9">
	    <strong><dhv:label name="documents.permissions.long_html">Permissions</dhv:label></strong>
	  </th>
  </tr>
<%
  Iterator i = PermissionList.iterator();
  int idCount = 0;
  while (i.hasNext()) {
    ++idCount;
    Permission thisPermission = (Permission)i.next();
    if (PermissionList.isNewCategory(thisPermission.getCategoryName())) {
%>
  <tr class="row1">
    <td>
      <%= toHtml(thisPermission.getCategoryName()) %>
    </td>
    <td width="40" align="center"><dhv:label name="admin.accessView" param="break=<br />">Access/<br />View</dhv:label></td>
    <td width="40" align="center"><dhv:label name="button.add">Add</dhv:label></td>
    <td width="40" align="center"><dhv:label name="button.edit">Edit</dhv:label></td>
    <td width="40" align="center"><dhv:label name="button.delete">Delete</dhv:label></td>

  </tr>
<%
   }    
%>    
  <tr>
    <td>
      <input type="hidden" name="permission<%= idCount %>id" value="<%= thisPermission.getId() %>">
      &nbsp; &nbsp;<%= toHtml(thisPermission.getDescription()) %> 
      
      &emsp; <font size="1px"><b>( <%= toHtml(thisPermission.getName()) %></b> )</font>
      
    </td>
    <td align="center">
<%
      if (thisPermission.getView()) {
%>
        <input type="checkbox" value="ON" onclick="aggiornaPermesso(<%=Role.getId() %>,<%=thisPermission.getId() %>,'role_view',this)" name="permission<%= idCount %>view" <%= (Role.getPermissionList().hasPermission(thisPermission.getName(), "view"))?"checked":"" %>>
<%
      } else {
%>
        --
<%
      }
%>
    </td>
    <td align="center">
<%
      if (thisPermission.getAdd()) {
%>
        <input type="checkbox" value="ON" onclick="aggiornaPermesso(<%=Role.getId() %>,<%=thisPermission.getId() %>,'role_add',this)"  name="permission<%= idCount %>add" <%= (Role.getPermissionList().hasPermission(thisPermission.getName(), "add"))?"checked":"" %>>
<%
      } else {
%>
        --
<%
      }
%>
    </td>
    <td align="center">
<%
      if (thisPermission.getEdit()) {
%>
        <input type="checkbox" value="ON" onclick="aggiornaPermesso(<%=Role.getId() %>,<%=thisPermission.getId() %>,'role_edit',this)"  name="permission<%= idCount %>edit" <%= (Role.getPermissionList().hasPermission(thisPermission.getName(), "edit"))?"checked":"" %>>
<%
      } else {
%>
        --
<%
      }
%>
    </td>
    <td align="center">
<%
      if (thisPermission.getDelete()) {
%>
        <input type="checkbox" value="ON" onclick="aggiornaPermesso(<%=Role.getId() %>,<%=thisPermission.getId() %>,'role_delete',this)"  name="permission<%= idCount %>delete" <%= (Role.getPermissionList().hasPermission(thisPermission.getName(), "delete"))?"checked":"" %>>
<%
      } else {
%>
        --
<%
      }
%>
    </td>
    
    
  </tr>
<%
  }
%>
</table>
<dhv:permission name="admin-roles-edit">
  <br />
  
</dhv:permission>

