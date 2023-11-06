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
  - Version: $Id: projects_center_setup.jsp 11310 2005-04-13 20:05:00Z mrajkowski $
  - Description: 
  --%>
<%@ page import="java.util.*,com.zeroio.iteam.base.*" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<jsp:useBean id="Project" class="com.zeroio.iteam.base.Project" scope="request"/>
<jsp:useBean id="currentMember" class="com.zeroio.iteam.base.TeamMember" scope="request"/>
<%@ include file="../initPage.jsp" %>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></SCRIPT>
<table border="0" cellpadding="1" cellspacing="0" width="100%">
  <tr class="subtab">
    <td>
      <img src="images/icons/stock_macro-objects-16.gif" border="0" align="absmiddle">
      <dhv:label name="documents.permissions.setup">Setup</dhv:label>
    </td>
  </tr>
</table>
<dhv:evaluate if="<%= currentMember.getRoleId() <= TeamMember.PROJECT_LEAD %>">
<br>
<a href="ProjectManagement.do?command=CustomizeProject&pid=<%= Project.getId() %>&return=ProjectCenter"><dhv:label name="project.customizeProject">Customize Project</dhv:label></a>
|
<a href="ProjectManagement.do?command=ConfigurePermissions&pid=<%= Project.getId() %>&return=ProjectCenter"><dhv:label name="documents.permissions.configurePermissions">Configure Permissions</dhv:label></a>
<br>
</dhv:evaluate>
<br>
<dhv:label name="project.adjustProjectProp.text">To adjust project properties choose Customize Project.  Project tabs can be enabled/disabled as well as renamed.</dhv:label><br>
<br>
<dhv:label name="project.chooseConfigurePermissions.text">To adjust project permissions choose Configure Permissions.  Each project has a set of permissions that indicate which user roles are allowed to perform a project function.  By default, the Project Lead role is capable of all project functions, while a Guest has very limited functionality.</dhv:label><br>
<br>
<dhv:label name="project.fourMajorRoles.colon">There are four major roles:</dhv:label><br>
<br>
<b><dhv:label name="project.projectLead.colon">Project Lead:</dhv:label></b> <dhv:label name="project.projectLead.text">Usually the owner(s) of the project and having the most control of the project data</dhv:label><br>
<br>
<b><dhv:label name="project.contributor.colon">Contributor:</dhv:label></b> <dhv:label name="project.contributor.text">Those that will be responsible for adding or updating related project information</dhv:label><br>
<br>
<b><dhv:label name="project.observer.colon">Observer:</dhv:label></b> <dhv:label name="project.observer.text">Those that typically are interested in reviewing the project, they have mostly read access but possibly allowed to add or update some related project information</dhv:label><br>
<br>
<b><dhv:label name="project.guest.colon">Guest:</dhv:label></b> <dhv:label name="project.guest.text">Typically a read-only role... those that are not directly part of the project but have access to review some of the project information</dhv:label><br>
