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
  - Version: $Id: accounts_documents_list.jsp 18488 2007-01-15 20:12:32Z matt $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.farmacosorveglianza.base.*,com.zeroio.iteam.base.*" %>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.farmacosorveglianza.base.Organization" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.sanzioni.base.Ticket" scope="request"/>
<%@ include file="../initPage.jsp" %>
<%@ include file="accounts_documents_list_menu.jsp" %>

<script>
function alertMessaggio(idControllo)
{
alert("Il File Allegato fa riferimento al Controllo Ufficiale "+idControllo+" per cui non puo essere cancellato. Eliminare prima il Controllo Ufficiale.")
}
</script>

<dhv:evaluate if="<%= !isPopup(request) %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Farmacosorveglianza.do?command=DashboardScelta">Farmacosorveglianza</a> > 
<a href="Farmacosorveglianza.do?command=Search"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
<a href="Farmacosorveglianza.do?command=Details&orgId=<%=OrgDetails.getOrgId()%>">Scheda Farmacosorveglianza</a> >
<dhv:label name="accounts.accounts_documents_details.Documents">Documents</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
</dhv:evaluate>
<dhv:container name="farmacosorveglianza" selected="documents" object="OrgDetails" hideContainer='<%= "true".equals(request.getParameter("actionplan")) %>' param='<%= "orgId=" + OrgDetails.getOrgId() %>' appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>'>
  <%
    String permission_doc_folders_add ="farmacie-farmacie-documents-add";
    String permission_doc_files_upload = "farmacie-farmacie-documents-add";
    String permission_doc_folders_edit = "farmacie-farmacie-documents-edit";
    String documentFolderAdd ="FarmacieDocumentsFolders.do?command=Add&orgId="+OrgDetails.getOrgId()+  addLinkParams(request, "popup|popupType|actionId|actionplan");
    String documentFileAdd = "FarmacieDocuments.do?command=Add&orgId="+ OrgDetails.getOrgId()+  addLinkParams(request, "popup|popupType|actionId|actionplan");
    String documentFolderModify = "FarmacieDocumentsFolders.do?command=Modify&orgId="+ OrgDetails.getOrgId()+  addLinkParams(request, "popup|popupType|actionId|actionplan");
    String documentFolderList = "FarmacieDocuments.do?command=View&orgId="+OrgDetails.getOrgId()+  addLinkParams(request, "popup|popupType|actionId|actionplan");
    String documentFileDetails = "FarmacieDocuments.do?command=Details&orgId="+ OrgDetails.getOrgId()+  addLinkParams(request, "popup|popupType|actionId|actionplan");
    String documentModule = "Accounts";
    String specialID = ""+OrgDetails.getId();
    boolean hasPermission = true;
  %>
  <%@ include file="documents_list_include.jsp" %>&nbsp;
  
 
</dhv:container>

 <%
  

	if (request.getAttribute("isDelete")!=null && ((Boolean)request.getAttribute("isDelete")) == false)
	{
		%>
	<script>

			alertMessaggio('<%=request.getAttribute("idControllo")%>')
			
	
	</script>	
		<%
	}
	
%>
  
