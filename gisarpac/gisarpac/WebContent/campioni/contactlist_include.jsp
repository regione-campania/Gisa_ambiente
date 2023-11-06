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
  - Version: $Id: contactlist_include.jsp 18488 2007-01-15 20:12:32Z matt $
  - Description: 
  --%>
<jsp:useBean id="DepartmentList" class="org.aspcfs.utils.web.LookupList" scope="session"/>
<jsp:useBean id="ProjectListSelect" class="org.aspcfs.utils.web.HtmlSelect" scope="session"/>
<jsp:useBean id="finalContacts" class="java.util.HashMap" scope="session"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ContactList" class="org.aspcfs.modules.campioni.base.Motivazioni" scope="request"/>
<jsp:useBean id="Filters" class="org.aspcfs.modules.base.FilterList" scope="request"/>
<jsp:useBean id="viewUserId" class="java.lang.String" scope="session"/>
<table width="100%" border="0">
  <tr>
    <td>
      <select size="1" name="listView" onChange="javascript:setFieldSubmit('listFilter1','-1','contactListView');">
      <%
        Iterator filters = Filters.iterator();
        while(filters.hasNext()){
        Filter thisFilter = (Filter) filters.next();
      %>
          <option <%= ContactList.getOptionValue(thisFilter.getValue()) %>><%= thisFilter.getDisplayName() %></option>
      <%}%>
       </select>

    </td>
    <td>
      <dhv:pagedListStatus title='<%= showError(request, "actionError") + showAttribute(request, "oneContactRequired") %>' object="ContactListInfo" showHiddenParams="true" enableJScript="true" form="contactListView"/>
    </td>
  </tr>
</table>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="pagedList">
  <tr>
    <th align="center" width="8">
      &nbsp;
    </th>
    <th>
      <dhv:label name="">Motivazione</dhv:label>
    </th>
    <th>
      <dhv:label name="">Categoria</dhv:label>
    </th>
<%
	Iterator j = ContactList.iterator();
	if (j.hasNext()) {
		int rowid = 0;
		int count = 0;
    while (j.hasNext()) {
			count++;
      rowid = (rowid != 1?1:2);
      Contact thisContact = (Contact)j.next();
      int thisContactId = thisContact.getId();
      if("true".equals(request.getParameter("usersOnly"))){
        thisContactId = thisContact.getUserId();
      }
%>
  <tr class="row<%= rowid+((selectedContacts.get(new Integer(thisContactId))!= null)?"hl":"") %>">
    <td align="center" nowrap width="8">
<% 
  if ("list".equals(request.getParameter("listType"))) { %>  
      <input type="checkbox" name="checkcontact<%= count %>" value=<%= thisContactId %><%= ((selectedContacts.get(new Integer(thisContactId))!= null)?" checked":"") %> onClick="highlight(this,'<%=User.getBrowserId()%>');">
<%} else {%>
      <a href="javascript:document.contactListView.finalsubmit.value = 'true';setFieldSubmit('rowcount','<%= count %>','contactListView');"><dhv:label name="accounts.accounts_add.select">Select</dhv:label></a>
<%}%>
      <input type="hidden" name="hiddencontactid<%= count %>" value="<%= thisContactId %>">
      <input type="hidden" name="hiddenname<%= count %>" value="<%= toHtml(thisContact.getValidName()) %>">
    </td>
    <td nowrap>
<% if (request.getParameter("source") != null && "attachplan".equals(request.getParameter("source"))) { %>
      <a href="Contacts.do?command=Modify&id=<%= thisContact.getId() %>&popup=true&source=attachplan&actionStepWork=<%= request.getParameter("actionStepWork") %>&orgId=<%= request.getParameter("orgId") %>"><%= toHtml(thisContact.getNameFull()) %></a>
<% } else { %>   
      <%= toHtml(thisContact.getNameFull()) %>
<% } %>
    </td>
    <td nowrap>
      <%= toHtml(thisContact.getTitle()) %>
    </td>

  </tr>
<%
    }
  } else {
%>
  <tr>
    <td class="containerBody" colspan="<%= !ContactList.getExclusiveToSite() || ContactList.getIncludeAllSites()?"6":"5" %>">
      <dhv:label name="campaign.noContactsMatchedQuery">No contacts matched query.</dhv:label>
    </td>
  </tr>
<%}%>
  <input type="hidden" name="finalsubmit" value="false">
  <input type="hidden" name="rowcount" value="0">
  <input type="hidden" name="displayFieldId" value="<%= toHtmlValue(request.getParameter("displayFieldId")) %>">
  <input type="hidden" name="hiddenFieldId" value="<%= toHtmlValue(request.getParameter("hiddenFieldId")) %>">
  <input type="hidden" name="listType" value="<%= toHtmlValue(request.getParameter("listType")) %>">
  <input type="hidden" name="usersOnly" value="<%= toHtmlValue(request.getParameter("usersOnly")) %>">
  <input type="hidden" name="hierarchy" value="<%= toHtmlValue(request.getParameter("hierarchy")) %>">
  <input type="hidden" name="nonUsersOnly" value="<%= toHtmlValue(request.getParameter("nonUsersOnly")) %>">
  <input type="hidden" name="campaign" value="<%= toHtmlValue(request.getParameter("campaign")) %>">
  <input type="hidden" name="actionplan" value="<%= toHtmlValue(request.getParameter("actionplan")) %>">
  <input type="hidden" name="filters" value="<%= toHtmlValue(request.getParameter("filters")) %>">
  <input type="hidden" name="displayType" value="<%= toHtmlValue(request.getParameter("displayType")) %>">
  <input type="hidden" name="actionStepWork" value="<%= toHtmlValue(request.getParameter("actionStepWork")) %>">
  <input type="hidden" name="actionPlanWork" value="<%= toHtmlValue(request.getParameter("actionPlanWork")) %>">
  <input type="hidden" name="orgId" value="<%= toHtmlValue(request.getParameter("orgId")) %>">
  <input type="hidden" name="source" value="<%= toHtmlValue(request.getParameter("source")) %>">
  <input type="hidden" name="hiddensource" value="<%= toHtmlValue(request.getParameter("hiddensource")) %>">
  <input type="hidden" name="addNewContact" value="<%= toHtmlValue(request.getParameter("addNewContact")) %>">
  <input type="hidden" name="siteIdUser" value="<%= toHtmlValue(request.getParameter("siteIdUser")) %>"/>
  <input type="hidden" name="siteIdContact" value="<%= toHtmlValue(request.getParameter("siteIdContact")) %>"/>
  <input type="hidden" name="siteIdOrg" value="<%= toHtmlValue(request.getParameter("siteIdOrg")) %>"/>
  <input type="hidden" name="siteId" value="<%=request.getAttribute("siteId")%>">
  <input type="hidden" name="includeAllSites" value="<%=request.getAttribute("includeAllSites")%>">
  <input type="hidden" name="mySiteOnly" value="<%=request.getAttribute("mySiteOnly")%>">
</table>
