<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.troubletickets.base.*" %>
<%@ include file="../initPage.jsp" %>
<%@ page import="java.text.DateFormat, org.aspcfs.modules.actionplans.base.*" %>
<jsp:useBean id="CU" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"/>
<jsp:useBean id="DepartmentList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolvedByDeptList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.nonconformita.base.Ticket" scope="request"/>
<jsp:useBean id="PriorityList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="NonConformitaAmministrative" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="NonConformitaPenali" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="NonConformita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SeverityList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SourceList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ticketStateList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Recipient" class="org.aspcfs.modules.contacts.base.Contact" scope="request"/>
<jsp:useBean id="causeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolutionList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="EscalationList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgList" class="org.aspcfs.modules.imbarcazioni.base.OrganizationList" scope="request"/>
<jsp:useBean id="TitoloNucleo" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoDue" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoTre" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoQuattro" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoCinque" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoSei" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoSette" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoOtto" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoNove" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoDieci" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SubList1" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList2" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList3" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="UserList" class="org.aspcfs.modules.admin.base.UserList" scope="request"/>
<jsp:useBean id="resolvedUserList" class="org.aspcfs.modules.admin.base.UserList" scope="request"/>
<jsp:useBean id="ContactList" class="org.aspcfs.modules.contacts.base.ContactList" scope="request"/>
<jsp:useBean id="actionPlans" class="org.aspcfs.modules.actionplans.base.ActionPlanList" scope="request"/>
<jsp:useBean id="insertActionPlan" class="java.lang.String" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="defectSelect" class="org.aspcfs.utils.web.HtmlSelect" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.imbarcazioni.base.Organization" scope="request"/>
<jsp:useBean id="TimeZoneSelect" class="org.aspcfs.utils.web.HtmlSelectTimeZone" scope="request"/>
<jsp:useBean id="systemStatus" class="org.aspcfs.controller.SystemStatus" scope="request"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popAccounts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popServiceContracts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popAssets.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popProducts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popContacts.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/nonConformita.js"></SCRIPT>
<script type="text/javascript" src="tabber.js"></script>
<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
<link rel="stylesheet" href="example.css" type="text/css" media="screen"></link>

<div  id = "nc" >
<div>
<body onunload="deleteAttivita('<%=CU.getId() %>')" >


<form name="addticket" action="ImbarcazioniNonConformita.do?command=Insert&auto-populate=true" method="post">
<input type = "hidden" id = "dosubmit" name = "dosubmit" value = "0">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
    <a  href="Imbarcazioni.do"  onclick="return !this.disabled;">Imbarcazioni</a> > 
<a href="Imbarcazioni.do?command=Search"  onclick="return !this.disabled;"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
<a href="Imbarcazioni.do?command=Details&orgId=<%=OrgDetails.getOrgId()%>"  onclick="return !this.disabled;">Scheda</a> > <a href="Imbarcazioni.do?command=ViewVigilanza&orgId=<%=OrgDetails.getOrgId()%>"  onclick="return !this.disabled;"><dhv:label name="">Controlli Ufficiali</dhv:label></a> >
 <a href="ImbarcazioniVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC")%>&orgId=<%=OrgDetails.getOrgId()%>"  onclick="return !this.disabled;"><dhv:label name="">Controllo Ufficiale</dhv:label></a> >
 

<dhv:label name="nonconformita.aggiungi">Aggiungi Non Conformit� Rilevata</dhv:label>

</td>
</tr>
</table>
<%-- End Trails --%>
<input type="submit" id = "btn_salva" disabled="disabled" value="Inserisci>" name="Save" onClick="return checkForm(this.form)">
<input type="button" value="Annulla" onClick="if(confirm('ATTENZIONE: si sta per abbandonare la pagina di aggiunta di una non conformita. Lasciando questa pagina il lavoro svolto finora verra perso.Sicuro di voler uscire ?')==true){window.location.href='ImbarcazioniVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC") %>&orgId=<%=OrgDetails.getOrgId()%>';this.form.dosubmit.value='0';}" />
<br>

<!--<iframe src="empty.html" name="server_commands" id="server_commands" style="visibility:hidden" height="0"></iframe>-->
<% if (request.getAttribute("closedError") != null) { %>
  <%= showAttribute(request, "closedError") %>
<%}%>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="2">

      <strong><dhv:label name="">Aggiungi Non Conformit� Rilevata</dhv:label></strong>

    </th>
	</tr>

  
  <dhv:include name="stabilimenti-sites" none="true">
    <tr>
      <td nowrap class="formLabel">
        <dhv:label name="stabilimenti.site">Site</dhv:label>
      </td>
      <td>
		       <%=SiteIdList.getSelectedValue(CU.getSiteId()) %>
          <input type="hidden" name="siteId" value="<%=CU.getSiteId()%>" >
      
      </td>
    </tr>
  <dhv:evaluate if="<%= SiteIdList.size() <= 1 %>">
    <input type="hidden" name="siteId" id="siteId" value="-1" />
  </dhv:evaluate>
 </dhv:include>
	
	<% if (!"true".equals(request.getParameter("contactSet"))) { %>
  <tr>
    <td class="formLabel">
      <dhv:label name="nonconformita.richiedente">Ragione Sociale O.S.A.</dhv:label>
    </td>
   
     
      <td>
        <%= toHtml(OrgDetails.getName()) %>
        <input type="hidden" name="orgId" value="<%=OrgDetails.getOrgId()%>">
        <input type="hidden" name="orgSiteId" id="orgSiteId" value="<%=  OrgDetails.getSiteId() %>" />
      </td>
    
  </tr>
 
  <% }else{ %>
    <input type="hidden" name="orgSiteId" id="orgSiteId" value="<%=  TicketDetails.getId() > 0 ? TicketDetails.getOrgSiteId() : User.getSiteId()%>" />
    <input type="hidden" name="orgId" value="<%= toHtmlValue(request.getParameter("orgId")) %>">
    <input type="hidden" name="contactId" value="<%= request.getParameter("contactId") %>">
  <% } %>
  <input type="hidden" name="ncrilevate" value="1"/>
  <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="">Identificativo C.U.</dhv:label>
    </td>
    <td>
      <%= (String)request.getAttribute("idControllo") %>
      <input type="hidden" name="idControlloUfficiale" id="idControlloUfficiale" value="<%= (String)request.getParameter("idControllo") %>">
      <input type="hidden" name="idC" id="idC" value="<%= (String)request.getParameter("idC") %>">
    </td>
  </tr>
   <% 
   String dataC  = "" ;
   if(request.getAttribute("dataC")!=null)
   {
    dataC = request.getAttribute("dataC").toString();
   }
   else
   {
	   dataC = CU.getAssignedDate().toString() ;
	   
   }%>
   
   <tr class="containerBody" style="display: none">
    <td nowrap class="formLabel">
      <dhv:label name="">Data </dhv:label>
    </td>
    <td>
<input readonly type="text" id="assignedDate" name="assignedDate" size="10" 
		value="<%= toDateString(TicketDetails.getAssignedDate()) %>"/>
		<a href="#" onClick="cal19.select(document.forms[0].assignedDate,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
		
      <font color="red">*</font> <%= showAttribute(request, "assignedDateError") %>
    </td>
  </tr>
  <%if ( request.getAttribute("idIspezione") != null)
	  {%>
 <input type="hidden" name="idIspezione" value="<%= request.getAttribute("idIspezione")%>">
	<%}
  else
  {
	  %>
	   <input type="hidden" name="idIspezione" value="<%= CU.getTipoIspezione()%>">
	  
	  <%
	  
  }%>
 
  <%if(request.getAttribute("idIspezione")!=null && !request.getAttribute("idIspezione").equals("3")){ %>
  <tr>
    <td valign="top" class="formLabel">
      <dhv:label name="nonconformita.azioni">Punteggio Totale</dhv:label>
    </td>
    <td>
      <table border="0" cellspacing="0" cellpadding="0" class="empty">
        <tr>
          <td>
            <input type="text" readonly="readonly" name="punteggio" value="" id="totale" title="INUTILE CHE SBAREI : punteggio determinato automaticamente dal sistema">
          </td>
         
        </tr>
       </table>
    </td>
  </tr>
 <%}else
	 {
	if(! (""+CU.getTipoIspezione()).equals("3")){ %>
	  <tr>
	    <td valign="top" class="formLabel">
	      <dhv:label name="nonconformita.azioni">Punteggio Totale</dhv:label>
	    </td>
	    <td>
	      <table border="0" cellspacing="0" cellpadding="0" class="empty">
	        <tr>
	          <td>
	            <input type="text" readonly="readonly" name="punteggio" value="" id="totale">
	          </td>
	         
	        </tr>
	       </table>
	    </td>
	  </tr>
	 <%
	 }} %>
  <tr>
    <td valign="top" class="formLabel">
      <dhv:label name="nonconformita.note">Note</dhv:label>
    </td>
    <td>
      <table border="0" cellspacing="0" cellpadding="0" class="empty">
        <tr>
          <td>
           
            <textarea name="problem" cols="55" rows="8"><%= toString(TicketDetails.getProblem()) %></textarea>
          </td>
          <td valign="top">
            <%= showAttribute(request, "problemError") %>
          </td>
        </tr>
      </table>
    </td>
	</tr>
	</table>
 <%@ include  file="../nonconformita/non_conformita_add.jsp" %>
		
<br />

<input type="hidden" name="close" value="">
<input type="hidden" name="refresh" value="-1">
<input type="hidden" name="modified" value="<%=  TicketDetails.getModified() %>" />
<input type="hidden" name="currentDate" value="<%=  request.getAttribute("currentDate") %>" />
<input type="hidden" name="statusId" value="<%=  TicketDetails.getStatusId() %>" />
<input type="hidden" name="trashedDate" value="<%=  TicketDetails.getTrashedDate() %>" />
<%= addHiddenParams(request, "popup|popupType|actionId") %>


<br>

<input type="submit" id = "btn_salva2" disabled="disabled" value="Inserisci>" name="Save" onClick="return checkForm(this.form)">
<input type="button" value="Annulla" onClick="if(confirm('ATTENZIONE: si sta per abbandonare la pagina di aggiunta di una non conformita. Lasciando questa pagina il lavoro svolto finora verra perso.Sicuro di voler uscire ?')==true){window.location.href='ImbarcazioniVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC") %>&orgId=<%=OrgDetails.getOrgId()%>';this.form.dosubmit.value='0';}" />
</form>
</body>

</div>
</div>