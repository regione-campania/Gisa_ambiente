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
  - Version: $Id: accounts_list.jsp 18543 2007-01-17 02:55:07Z matt $
  - Description:
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.farmacosorveglianza.base.*, org.aspcfs.modules.base.*" %>
<%@page import="org.jfree.data.DataUtilities"%>
<jsp:useBean id="OrgList" class="org.aspcfs.modules.farmacosorveglianza.base.PrescrizioniList" scope="request"/>
<jsp:useBean id="SearchOrgListInfoFcie" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="SiteList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgCategoriaRischioList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TypeSelect" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="Audit" class="org.aspcfs.modules.audit.base.Audit" scope="request"/>
<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>
<%@ include file="../initPopupMenu.jsp" %>
<%@ include file="farmaci_list_menu.jsp" %>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></SCRIPT>
<script language="JavaScript" type="text/javascript">
  <%-- Preload image rollovers for drop-down menu --%>
  
</script>
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="FarmacosorveglianzaPre.do?command=SearchFormPre"><dhv:label name="">Prescrizioni</dhv:label></a> > 
<dhv:label name="">Risultato Ricerca</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<dhv:evaluate if="<%= (User.getRoleType() > 0) %>" >
<table class="note" cellspacing="0">
  <tr>
    <th><img src="images/icons/stock_about-16.gif" border="0" align="absmiddle"/></th>
    <td><dhv:label name="accounts.manage">Select an account to manage.</dhv:label></td>
  </tr>
</table>
</dhv:evaluate>
<dhv:permission name="farmacosorveglianza-farmacosorveglianza-add"><a href="FarmacosorveglianzaPre.do?command=AddPre"><dhv:label name="">Aggiungi Prescrizione</dhv:label></a></dhv:permission>
<%--<dhv:include name="pagedListInfo.alphabeticalLinks" none="true">
<center><dhv:pagedListAlphabeticalLinks object="SearchOrgListInfoFcie"/></center>
</dhv:include>--%>
<dhv:pagedListStatus title='<%= showError(request, "actionError") %>' object="SearchOrgListInfoFcie"/>
<% int columnCount = 0; %>
<table cellpadding="8" cellspacing="0" border="0" width="100%" class="pagedList">
  <tr>
  
    <th nowrap <% ++columnCount; %>>
      <%--strong><a href="FarmacosorveglianzaPre.do?command=SearchFar&column=o.ragione_sociale"--%><dhv:label name="">Data Prescrizione</dhv:label><%--/a></strong>
      <%= SearchOrgListInfoFcie.getSortIcon("o.ragione_sociale") --%>
    </th>	  
        <th nowrap <% ++columnCount; %>>
          <strong>Veterinario Prescrittore</strong>
		</th>
        <%--    <dhv:include name="organization.list.siteId" none="true"> --%>
<zeroio:debug value='<%="JSP::accounts_list.jsp "+ SearchOrgListInfoFcie.getSearchOptionValue("searchcodeOrgSiteId")+" == "+(String.valueOf(Constants.INVALID_SITE)) %>'/>
      <%--dhv:evaluate if='<%= SearchOrgListInfoFcie.getSearchOptionValue("searchcodeOrgSiteId").equals(String.valueOf(Constants.INVALID_SITE)) %>'--%>
        <th <% ++columnCount; %>>
          <strong><dhv:label name="accounts.site">ASL</dhv:label></strong>
        </th>
      <%--/dhv:evaluate--%>
<%--    </dhv:include> --%>
		
  </tr>
<%
	Iterator j = OrgList.iterator();
	if ( j.hasNext() ) {
    int rowid = 0;
    int i = 0;
    while (j.hasNext()) {
    i++;
    rowid = (rowid != 1 ? 1 : 2);
    Prescrizioni thisOrg = (Prescrizioni)j.next();
    String s = null;
    if(thisOrg.getDataPrescrizione()!= null){
    SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
    java.util.Date data = new java.util.Date(thisOrg.getDataPrescrizione().getTime());
    s = dt.format(data);
    }
%>
  <tr class="row<%= rowid %>">

	<td>
	<% %>
      <a href="FarmacosorveglianzaPre.do?command=DetailsPre&idPrescrizione=<%=thisOrg.getIdPrescrizione()%>"><%= toHtml(s) %></a>
	</td>
      
	<td nowrap>
	   <%= toHtmlValue(thisOrg.getVeterinarioC()+" "+thisOrg.getVeterinarioN()) %>&nbsp;
	</td>
	<td nowrap>
       	 <%= SiteList.getSelectedValue(thisOrg.getSiteId()) %>&nbsp;
	</td>
<%-- if(thisOrg.getAccountSize() > 0) {%>
    <td valign="top" nowrap>
      <%= OrgCategoriaRischioList.getSelectedValue(thisOrg.getAccountSize()) %>
       &nbsp;
       [<a href="FarmacosorveglianzaPre.do?command=ModificaCatRischio&orgId=<%=thisOrg.getOrgId()%>"><dhv:label name="">Modifica</dhv:label></a>]
    </td>
<%}else { %>
	<td valign="top" nowrap>
      Nessuna
       &nbsp;
       [<a href="FarmacosorveglianzaPre.do?command=ModificaCatRischio&orgId=<%=thisOrg.getOrgId()%>"><dhv:label name="accountsa.accounts_add.select">Aggiungi</dhv:label></a>]
    </td>
    <%} --%>
    
  </tr>
  <input type="hidden" name="source" value="searchForm">
<%}%>
<%} else {%>
  <tr class="containerBody">
    <td colspan="<%= SearchOrgListInfoFcie.getSearchOptionValue("searchcodeOrgSiteId").equals(String.valueOf(Constants.INVALID_SITE))?columnCount+1:columnCount %>">
      <dhv:label name="">Nessuna Prescrizione trovata con i parametri di ricerca specificati.</dhv:label><br />
      <a href="FarmacosorveglianzaPre.do?command=SearchFormPre"><dhv:label name="">Modifica Ricerca</dhv:label></a>.
    </td>
  </tr>
<%}%>
</table>
<br />
<dhv:pagedListControl object="SearchOrgListInfoFcie" tdClass="row1"/>

