<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ include file="../initPage.jsp" %>
<%@page import="org.aspcfs.utils.web.LookupList"%>
<jsp:useBean id="fileItem" class="com.zeroio.iteam.base.FileItem" scope="request"/>
<jsp:useBean id="EsitoControllo" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="IspezioneMacrocategorie" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="DistribuzionePartita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DestinazioneDistribuzione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ArticoliAzioni" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AzioniAdottate" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Provvedimenti2" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Provvedimenti3" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgDetails" class="ext.aspcfs.modules.apiari.base.Stabilimento" scope="request"/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"/>
<jsp:useBean id="EsitoCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
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
<jsp:useBean id="TipoAudit" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AuditTipo" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Bpi" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Haccp" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Ispezione" class="java.util.HashMap"	scope="request" />	
<jsp:useBean id="TipoIspezione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="PianoMonitoraggio1" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="PianoMonitoraggio2" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="PianoMonitoraggio3" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DepartmentList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolvedByDeptList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SeverityList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SourceList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="PriorityList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DestinatarioCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="causeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolutionList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ticketStateList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="EscalationList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="UserList" class="org.aspcfs.modules.admin.base.UserList" scope="request"/>
<jsp:useBean id="resolvedUserList" class="org.aspcfs.modules.admin.base.UserList" scope="request"/>
<jsp:useBean id="SubList1" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList2" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList3" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="actionPlans" class="org.aspcfs.modules.actionplans.base.ActionPlanList" scope="request"/>
<jsp:useBean id="insertActionPlan" class="java.lang.String" scope="request"/>
<jsp:useBean id="ContactList" class="org.aspcfs.modules.contacts.base.ContactList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="defectSelect" class="org.aspcfs.utils.web.HtmlSelect" scope="request"/>
<jsp:useBean id="defectCheck" class="java.lang.String" scope="request"/>
<jsp:useBean id="TimeZoneSelect" class="org.aspcfs.utils.web.HtmlSelectTimeZone" scope="request"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popServiceContracts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popAssets.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popProducts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/controlliUfficiali.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/controlli_ufficiali_imprese.js"></script>
<script type="text/javascript" src="dwr/interface/ControlliUfficiali.js"> </script>
<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>


<%
TipoIspezione.setJsEvent("onChange=javascript:mostraMenuTipoIspezione('details');");
TipoCampione.setJsEvent("onChange=javascript:gestioneVisibilitaCodiceAteco('details');provaFunzione('details');");
TipoAudit.setJsEvent("onChange=javascript:mostraMenu2('details')");
AuditTipo.setJsEvent("onChange=javascript:mostraMenu4('details')");
PianoMonitoraggio1.setJsEvent("onChange=javascript:piani('details')");
PianoMonitoraggio2.setJsEvent("onChange=javascript:piani('details')");
PianoMonitoraggio3.setJsEvent("onChange=javascript:piani('details')");

%>

<body onLoad="abilitaCodiceAllerta('details');initprovaFunzione('details');abilitaSistemaAllarmeRabido('details');resetElementiNucleoIspettivo('<%=TicketDetails.getNucleoasList().size() %>');">
<%
String param = "stabId="+OrgDetails.getIdStabilimento()+"&opId=" + OrgDetails.getIdOperatore()+"&id="+TicketDetails.getIdMacchinetta();

String container = OrgDetails.getContainer();
if (User.getUserRecord().getGruppo_ruolo()==Role.GRUPPO_ALTRE_AUTORITA && (container.startsWith("apiari")|| container.startsWith("opu")))
	container="apiari";
TicketDetails.setPermission();
request.setAttribute("Operatore",OrgDetails.getOperatore());


%>


<form name="details" action="<%=OrgDetails.getAction() %>Vigilanza.do?command=UpdateTicket&auto-populate=true<%= addLinkParams(request, "popup|popupType|actionId") %>"  method="post">
<dhv:evaluate if="<%= !isPopup(request) %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
  <dhv:label name=""><a href="<%=OrgDetails.getAction()+".do?command=SearchForm" %>" >Gestione Anagrafica Impresa </a>-><a  href="<%=OrgDetails.getAction()+".do?command=Details&stabId="+OrgDetails.getIdStabilimento()%>">Scheda Impresa</a> -><a href="<%=OrgDetails.getAction()+".do?command=ViewVigilanza&stabId="+OrgDetails.getIdStabilimento()%>"> Controlli Ufficiali </a>-> <a href="<%=OrgDetails.getAction()+"Vigilanza.do?command=TicketDetails&id="+TicketDetails.getId()+"&idStabilimentoopu="+OrgDetails.getIdStabilimento()%>">Scheda controllo</a>-> Modifica Controllo</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
</dhv:evaluate>
<iframe src="empty.html" name="server_commands" id="server_commands" style="visibility:hidden" height="0"></iframe>
<dhv:container name="apiari" selected="vigilanza" object="OrgDetails" param='<%= param%>' >
     <dhv:evaluate if="<%= !TicketDetails.isTrashed() %>" >
      <dhv:evaluate if="<%= TicketDetails.getClosed() != null %>" >
          <dhv:permission name="accounts-accounts-vigilanza-edit">
            <input type="submit" value="<dhv:label name="button.reopen">Reopen</dhv:label>" onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>Vigilanza.do?command=ReopenTicket&id=<%=TicketDetails.getId()%><%= addLinkParams(request, "popup|popupType|actionId") %>'">
           </dhv:permission>
           <dhv:evaluate if='<%= "list".equals(request.getParameter("return"))%>' >
            <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>.do?command=ViewVigilanza&idStabilimentoopu=<%=OrgDetails.getIdStabilimento()%><%= addLinkParams(request, "popup|popupType|actionId") %>'" />
           </dhv:evaluate>
           <dhv:evaluate if='<%= !"list".equals(request.getParameter("return"))%>' >
            <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>Vigilanza.do?command=TicketDetails&id=<%= TicketDetails.getId() %><%= addLinkParams(request, "popup|popupType|actionId") %>'" />
           </dhv:evaluate>
      </dhv:evaluate>
      <dhv:evaluate if="<%= TicketDetails.getClosed() == null %>" >
          <dhv:permission name="accounts-accounts-vigilanza-edit">
            <input type="button" value="<dhv:label name="global.button.update">Update</dhv:label>" onClick="return controlloCuSorveglianza()">
          </dhv:permission>
           <dhv:evaluate if='<%= "list".equals(request.getParameter("return"))%>' >
            <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>.do?command=ViewVigilanza&orgId=<%=OrgDetails.getIdStabilimento()%><%= addLinkParams(request, "popup|popupType|actionId") %>'" />
           </dhv:evaluate>
           <dhv:evaluate if='<%= !"list".equals(request.getParameter("return"))%>' >
            <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>Vigilanza.do?command=TicketDetails&id=<%= TicketDetails.getId() %><%= addLinkParams(request, "popup|popupType|actionId") %>'" />
           </dhv:evaluate>
          <%= showAttribute(request, "closedError") %>
       </dhv:evaluate>
      </dhv:evaluate>
    <br />
    <dhv:formMessage />
    
    <table cellpadding="4" cellspacing="0" width="100%" class="details">
    	
<%@ include file="../controlliufficiali/opu_controlli_ufficiali_modify.jsp" %>

	
</table>
<br><br>

<%@ include file="../controlliufficiali/opu_controlli_ufficiali_allarmerapido_modify.jsp" %>	
	

        &nbsp;<br>
   <dhv:evaluate if="<%= !TicketDetails.isTrashed() %>" >
    <dhv:evaluate if="<%= TicketDetails.getClosed() != null %>" >
        <dhv:permission name="accounts-accounts-vigilanza-edit">
          <input type="submit" value="<dhv:label name="button.reopen">Reopen</dhv:label>" onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>Vigilanza.do?command=ReopenTicket&id=<%=TicketDetails.getId()%><%= addLinkParams(request, "popup|popupType|actionId") %>'">
         </dhv:permission>
         <dhv:evaluate if='<%= "list".equals(request.getParameter("return"))%>' >
          <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>.do?command=ViewVigilanza&orgId=<%=OrgDetails.getIdStabilimento()%><%= addLinkParams(request, "popup|popupType|actionId") %>'" />
         </dhv:evaluate>
         <dhv:evaluate if='<%= !"list".equals(request.getParameter("return"))%>' >
          <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>Vigilanza.do?command=TicketDetails&id=<%= TicketDetails.getId() %><%= addLinkParams(request, "popup|popupType|actionId") %>'" />
         </dhv:evaluate>
    </dhv:evaluate>
    <dhv:evaluate if="<%= TicketDetails.getClosed() == null %>" >
        <dhv:permission name="accounts-accounts-vigilanza-edit">
          <input type="button" value="<dhv:label name="global.button.update">Update</dhv:label>" onClick="return controlloCuSorveglianza()">
        </dhv:permission>
         <dhv:evaluate if='<%= "list".equals(request.getParameter("return"))%>' >
          <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>.do?command=ViewVigilanza&orgId=<%=OrgDetails.getIdStabilimento()%><%= addLinkParams(request, "popup|popupType|actionId") %>'" />
         </dhv:evaluate>
         <dhv:evaluate if='<%= !"list".equals(request.getParameter("return"))%>' >
          <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>Vigilanza.do?command=TicketDetails&id=<%= TicketDetails.getId() %><%= addLinkParams(request, "popup|popupType|actionId") %>'" />
         </dhv:evaluate>
        <%= showAttribute(request, "closedError") %>
     </dhv:evaluate>
    </dhv:evaluate>
    <input type="hidden" name="modified" value="<%= TicketDetails.getModified() %>">
      
      
    <input type="hidden" name="orgSiteId" id="orgSiteId" value="<%=  TicketDetails.getOrgSiteId() %>" />
    <input type="hidden" name="id" value="<%= TicketDetails.getId() %>">
    <input type="hidden" name="idApiario" value="<%= OrgDetails.getIdStabilimento() %>">
    <input type="hidden" name="isAllegato" value="<%=TicketDetails.isListaDistribuzioneAllegata() %>">
    <input type="hidden" name="companyName" value="<%= toHtml(TicketDetails.getCompanyName()) %>">
    <input type="hidden" name="statusId" value="<%=  TicketDetails.getStatusId() %>" />
    <input type="hidden" name="trashedDate" value="<%=  TicketDetails.getTrashedDate() %>" />
    <input type="hidden" name="close" value="">
     <input type="hidden" id="ticketid" value="0" name="ticketidd">
    <input type="hidden" name="refresh" value="-1">
     <input type="hidden" name="isAllegato" value="<%=TicketDetails.isListaDistribuzioneAllegata() %>">
    <input type="hidden" name="currentDate" value="<%=  request.getAttribute("currentDate") %>" />
</dhv:container>
</form>
</body>
