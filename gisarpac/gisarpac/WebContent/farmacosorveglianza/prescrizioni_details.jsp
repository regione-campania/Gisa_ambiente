<%-- 
  - Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. DARK HORSE
  - VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL DARK HORSE VENTURES LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Version: $Id: accounts_details.jsp 19045 2007-02-07 18:06:22Z matt $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.farmacosorveglianza.base.*,org.aspcfs.modules.contacts.base.*, org.aspcfs.modules.base.Constants" %>
<%@page import="org.aspcfs.modules.audit.base.Audit"%>
<jsp:useBean id="SourceList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgCategoriaRischioList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="StageList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="RatingList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoStruttura" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoLocale" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.farmacosorveglianza.base.Prescrizioni" scope="request"/>
<jsp:useBean id="Audit" class="org.aspcfs.modules.audit.base.Audit" scope="request"/>
<jsp:useBean id="SegmentList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SICCodeList" class="org.aspcfs.modules.admin.base.SICCodeList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="applicationPrefs" class="org.aspcfs.controller.ApplicationPrefs" scope="application"/>
<jsp:useBean id="refreshUrl" class="java.lang.String" scope="request"/>
<%@ include file="../initPage.jsp" %>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<%if (refreshUrl!=null && !"".equals(refreshUrl)){ %>
<script language="JavaScript" TYPE="text/javascript">
parent.opener.window.location.href='<%=refreshUrl%><%= request.getAttribute("actionError") != null ? "&actionError=" + request.getAttribute("actionError") :""%>';
</script>
<%}%>
<dhv:evaluate if="<%= !isPopup(request) %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="FarmacosorveglianzaPre.do?command=SearchFormPre"><dhv:label name="">Prescrizioni</dhv:label></a> > 
<%-- if (request.getParameter("return") == null) { %>
<a href="FarmacosorveglianzaPre.do?command=SearchFar"><dhv:label name="">Risultati Ricerca</dhv:label></a> >
<%} else if (request.getParameter("return").equals("dashboard")) {%>
<a href="FarmacosorveglianzaPre.do?command=DashboardFar"><dhv:label name="communications.campaign.Dashboard">Dashboard</dhv:label></a> >
<%}--%>
<dhv:label name="">Scheda Prescrizione</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>

</dhv:evaluate>
<dhv:permission name="farmacosorveglianza-farmacosorveglianza-report-view">
  <table width="100%" border="0">
    <tr>
      <td nowrap align="right">
        <%-- 
        <img src="images/icons/stock_print-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        <a href="FarmacosorveglianzaPre.do?command=PrintReport&id=<%= OrgDetails.getId() %>"><dhv:label name="accounts.osa.print">Stampa Scheda O.S.A.</dhv:label></a>
       --%>
      </td>
    </tr>
  </table>
</dhv:permission>
<% String param1 = "idPrescrizione=" + OrgDetails.getIdPrescrizione();
   %>
  
<dhv:container name="farmacosorveglianza" selected="details" object="OrgDetails" param="<%= param1 %>" appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>' hideContainer="<%= OrgDetails.isTrashed() %>">
<input type="hidden" name="idPrescrizione" value="<%= OrgDetails.getIdPrescrizione() %>"> 
<dhv:evaluate if="<%=OrgDetails.isTrashed()%>">
    <dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit">
      <input type="button" value="<dhv:label name="button.restore">Restore</dhv:label>"	onClick="javascript:window.location.href='FarmacosorveglianzaPre.do?command=Restore&idPrescrizione=<%= OrgDetails.getIdPrescrizione() %>';">
    </dhv:permission>
</dhv:evaluate>
<dhv:evaluate if="<%=!OrgDetails.isTrashed()%>">
 
    <dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit"><input type="button"  value="<dhv:label name="global.button.modify">Modify</dhv:label>"	onClick="javascript:window.location.href='FarmacosorveglianzaPre.do?command=ModifyPre&idPrescrizione=<%= OrgDetails.getIdPrescrizione() %><%= addLinkParams(request, "popup|actionplan") %>';"></dhv:permission>
  
  
    <%--dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit">
      <input type="button" value="<dhv:label name="global.button.Enable">Enable</dhv:label>" 	onClick="javascript:window.location.href='FarmacosorveglianzaPre.do?command=Enable&idPrescrizione=<%= OrgDetails.getIdPrescrizione() %>';">
    </dhv:permission--%>
 
  <dhv:evaluate if='<%= (request.getParameter("actionplan") == null) %>'>
    <dhv:permission name="farmacosorveglianza-farmacosorveglianza-delete"><input type="button" value="<dhv:label name="accounts.accounts_details.DeleteAccount">Delete Account</dhv:label>" onClick="javascript:popURLReturn('FarmacosorveglianzaPre.do?command=ConfirmDeleteFar&id=<%=OrgDetails.getIdPrescrizione()%>&popup=true','FarmacosorveglianzaPre.do?command=SearchFar', 'Delete_account','320','200','yes','no');"></dhv:permission>
  </dhv:evaluate>
</dhv:evaluate>
<dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit,farmacosorveglianza-farmacosorveglianza-delete"><br>&nbsp;</dhv:permission>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
   <tr>
    <th colspan="2">
      <strong><dhv:label name="">Informazioni Principali</dhv:label></strong>
    </th>
  </tr>
    <% String st = SiteList.getSelectedValue(OrgDetails.getSiteId()); 
if(st.equals("--Nessuno--")){ %>    
<%}else{ %>
<dhv:include name="accounts-sites" none="true">
  <dhv:evaluate if="<%= SiteList.size() > 0 %>">
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="accounts.site">Site</dhv:label>
    </td>
    <td>
      <%= SiteList.getSelectedValue(OrgDetails.getSiteId()) %>
      <input type="hidden" name="siteId" value="<%=OrgDetails.getSiteId()%>" >
    </td>
   
  </tr>
  </dhv:evaluate> 
  <dhv:evaluate if="<%= SiteList.size() <= 0 %>">
    <input type="hidden" name="siteId" id="siteId" value="-1" />
  </dhv:evaluate>
  </dhv:include>
  <%} %>
  <%--dhv:include name="accounts-sites" none="true">
  <dhv:evaluate if="<%= SiteList.size() > 1 %>">
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="accounts.site">Site</dhv:label>
    </td>
    <td>
      <%= SiteList.getSelectedValue(OrgDetails.getSiteId()) %>
      <input type="hidden" name="siteId" value="<%=OrgDetails.getSiteId()%>" >
    </td>
  </tr>
  </dhv:evaluate> 
  <dhv:evaluate if="<%= SiteList.size() <= 1 %>">
    <input type="hidden" name="siteId" id="siteId" value="-1" />
  </dhv:evaluate>
</dhv:include--%>
<dhv:include name="organization.date1" none="true">
        <dhv:evaluate if="<%= (OrgDetails.getDataPrescrizione() != null) %>">
    <tr class="containerBody">
      <td nowrap class="formLabel">
        <dhv:label name="">Data Prescrizione</dhv:label>
      </td>
      <td>
        <zeroio:tz timestamp="<%= OrgDetails.getDataPrescrizione() %>" dateOnly="true" showTimeZone="false" default="&nbsp;" />
        <%= showAttribute(request, "contractEndDateError") %>
      </td>
    </tr>
    </dhv:evaluate>
    </dhv:include>  
      </table>
  </br>
  <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="">Veterinario Prescrittore</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="campioni.richiedente">Cognome Nome</dhv:label>
    </td>
    <td>
    	<%= toHtmlValue(OrgDetails.getVeterinarioC()+" "+OrgDetails.getVeterinarioN()) %>&nbsp;
    </td>
  </tr>
</table>
</br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr class="containerBody">
    <th colspan="2">
      <strong><dhv:label name="">Allevamento Destinatario</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="campioni.richiedente">Denominazione Allevamento</dhv:label>
    </td>
    <td>
    <%= toHtmlValue(OrgDetails.getAllevamentoN()) %>&nbsp;
    </td></tr>
</table>
</br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="">Farmacia o Deposito Farmaceutico</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
  <td class="formLabel">
      <dhv:label name="campioni.richiedente">Ragione Sociale</dhv:label>
    </td>
    <td>
    <%= toHtmlValue(OrgDetails.getFarmaciaN()) %>&nbsp;
    </td>
        </tr>
      </table>
</br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="">Farmaci Prescritti</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
  <td class="formLabel">
      <dhv:label name="">Farmaco 1</dhv:label>
    </td>
    <td>
    	<%= toHtmlValue(OrgDetails.getFarmaco1()) %>&nbsp;
    </td>
        </tr>
     
  <tr class="containerBody">
    <td nowrap class="formLabel">
    
      <dhv:label name="">Quantit� Farmaco 1</dhv:label>
    
    </td>
    <td>
    <dhv:evaluate if="<%=OrgDetails.getQuantitaFarmaco1()>0%>">
    	  <%= toHtmlValue(OrgDetails.getQuantitaFarmaco1()) %>&nbsp; 
    </dhv:evaluate>        
    </td>
  </tr>
  <tr class="containerBody">
  <td class="formLabel">
      <dhv:label name="">Farmaco 2</dhv:label>
    </td>
    <td>
    	<%= toHtmlValue(OrgDetails.getFarmaco2()) %>&nbsp;
    </td>
        </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
    
      <dhv:label name="">Quantit� Farmaco 2</dhv:label>
      
    </td>
    <td>
    <dhv:evaluate if="<%=OrgDetails.getQuantitaFarmaco2()>0%>">
    	   <%= toHtmlValue(OrgDetails.getQuantitaFarmaco2()) %>&nbsp;
    </dhv:evaluate>                 
    </td>
  </tr>
  <dhv:include name="organization.date2" none="true">
        <dhv:evaluate if="<%= (OrgDetails.getDataDispensazione() != null) %>">
    <tr class="containerBody">
      <td nowrap class="formLabel">
        <dhv:label name="">Data Dispensazione</dhv:label>
      </td>
      <td>
        <zeroio:tz timestamp="<%= OrgDetails.getDataDispensazione() %>" dateOnly="true" showTimeZone="false" default="&nbsp;" />
        <%= showAttribute(request, "contractEndDateError") %>
      </td>
    </tr>
    </dhv:evaluate>
    </dhv:include>  
</table>
<br/>
<br/>
 <%if(hasText(OrgDetails.getNote1())){ %>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong><dhv:label name="">Informazioni Aggiuntive</dhv:label></strong>
	  </th>
  </tr>
 
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Note</dhv:label>
    </td>
    <td>
      <%=toHtml(OrgDetails.getNote1()) %>&nbsp;
    </td>
  </tr>
</table>
<br />
<%} %>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="requestor.requestor_contacts_calls_details.RecordInformation">Record Information</dhv:label></strong>
    </th>     
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="requestor.requestor_calls_list.Entered">Entered</dhv:label>
    </td>
    <td>
      <dhv:username id="<%= OrgDetails.getEnteredBy() %>" />
      <zeroio:tz timestamp="<%= OrgDetails.getEntered() %>" timeZone="<%= User.getTimeZone() %>" showTimeZone="false" />
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="requestor.requestor_contacts_calls_details.Modified">Modified</dhv:label>
    </td>
    <td>
      <dhv:username id="<%= OrgDetails.getModifiedBy() %>" />
      <zeroio:tz timestamp="<%= OrgDetails.getModified() %>" timeZone="<%= User.getTimeZone() %>" showTimeZone="false" />
    </td>
  </tr>
</table>
<dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit,farmacosorveglianza-farmacosorveglianza-delete"><br></dhv:permission>
<dhv:evaluate if="<%=OrgDetails.isTrashed()%>">
    <dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit">
      <input type="button" value="<dhv:label name="button.restore">Restore</dhv:label>"	onClick="javascript:window.location.href='FarmacosorveglianzaPre.do?command=RestoreFar&idPrescrizione=<%= OrgDetails.getIdPrescrizione() %>';">
    </dhv:permission>
</dhv:evaluate>
<dhv:evaluate if="<%=!OrgDetails.isTrashed()%>">
  
    <dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit"><input type="button"  value="<dhv:label name="global.button.modify">Modify</dhv:label>"	onClick="javascript:window.location.href='FarmacosorveglianzaPre.do?command=ModifyPre&idPrescrizione=<%= OrgDetails.getIdPrescrizione() %><%= addLinkParams(request, "popup|actionplan") %>';"></dhv:permission>
 
    <%--dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit">
      <input type="button" value="<dhv:label name="global.button.Enable">Enable</dhv:label>" 	onClick="javascript:window.location.href='FarmacosorveglianzaPre.do?command=EnableFar&idPrescrizione=<%= OrgDetails.getIdPrescrizione() %>';">
    </dhv:permission--%>
  
  <dhv:evaluate if='<%= (request.getParameter("actionplan") == null) %>'>
    <dhv:permission name="farmacosorveglianza-farmacosorveglianza-delete"><input type="button" value="<dhv:label name="accounts.accounts_details.DeleteAccount">Delete Account</dhv:label>" onClick="javascript:popURLReturn('FarmacosorveglianzaPre.do?command=ConfirmDeleteFar&id=<%=OrgDetails.getIdPrescrizione()%>&popup=true','FarmacosorveglianzaPre.do?command=SearchFar', 'Delete_account','320','200','yes','no');"></dhv:permission>
  </dhv:evaluate>
</dhv:evaluate>
</dhv:container>
<input type="hidden" name="source" value="searchForm">
<%= addHiddenParams(request, "popup|popupType|actionId") %>
<% if (request.getParameter("return") != null) { %>
<input type="hidden" name="return" value="<%=request.getParameter("return")%>">
<%}%>
<% if (request.getParameter("actionplan") != null) { %>
<input type="hidden" name="actionplan" value="<%=request.getParameter("actionplan")%>">
<%}%>