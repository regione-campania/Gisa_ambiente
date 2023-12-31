<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.campioni.base.*" %>
<%@ include file="../initPage.jsp" %>
<jsp:useBean id="OrgDetails" class="ext.aspcfs.modules.apiari.base.Stabilimento" scope="request"/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.campioni.base.Ticket" scope="request"/>
<jsp:useBean id="CU" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"/>

<body onload="controlloLookup();impostaResponsabilita('addticket');">
<form name="addticket" action="<%=OrgDetails.getAction() %>Campioni.do?command=Insert&auto-populate=true" method="post">
<%-- Trails --%>
<table class="trails" cellspacing="0" >
<tr>
<td>
  <dhv:label name=""><a href="<%=OrgDetails.getAction()+".do?command=SearchForm" %>" >Gestione Anagrafica Impresa </a>-><a  href="<%=OrgDetails.getAction()+".do?command=Details&stabId="+OrgDetails.getIdStabilimento()%>">Scheda Impresa</a> -><a href="<%=OrgDetails.getAction()+".do?command=ViewVigilanza&stabId="+OrgDetails.getIdStabilimento()%>"> Controlli Ufficiali </a>-> <a href="<%=OrgDetails.getAction()+"Vigilanza.do?command=TicketDetails&id="+CU.getIdControlloUfficiale()+"&idStabilimentoopu="+OrgDetails.getIdStabilimento()%>">Scheda controllo</a>-> Aggiungi Campione</dhv:label>

</td>
</tr>
</table >
<%-- End Trails --%>
<!-- <input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" onClick="if( confirm('Attenzione! Controlla bene tutti i dati inseriti perch� non potrai pi� modificarli. Vuoi concludere l\'inserimento?') ){return checkForm(this.form)}else return false;"> -->
<!-- <input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" class="Save"> -->
<%-- <input type="button" value="<dhv:label name="button.insert">Insert</dhv:label>" id="Save" name="Save" class="Save" onClick="javascript:controllaAnaliti();" /> --%>
<%-- <input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.location.href='<%=OrgDetails.getAction() %>Vigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC") %>&idStabilimentoopu=<%=OrgDetails.getIdStabilimento()%>';this.form.dosubmit.value='false';" /> --%>
<br>
<dhv:formMessage />
<% if (request.getAttribute("closedError") != null) { %>
  <%= showAttribute(request, "closedError") %>
<%}%>
<%-- include basic troubleticket add form --%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.text.DateFormat, org.aspcfs.modules.actionplans.base.*" %>
<jsp:useBean id="EsitoCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ConseguenzePositivita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ResponsabilitaPositivita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SanzioniAmministrative" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DestinatarioCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgList" class="org.aspcfs.modules.accounts.base.OrganizationList" scope="request"/>
<jsp:useBean id="UserList" class="org.aspcfs.modules.admin.base.UserList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="systemStatus" class="org.aspcfs.controller.SystemStatus" scope="request"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popAccounts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popServiceContracts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popAssets.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popProducts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popContacts.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/controlli_campioni.js"></SCRIPT>


<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="2">
      <strong><dhv:label name="">Aggiungi Campione</dhv:label></strong>
    </th>
	</tr>
  
     <%@ include file="/campioni/opu_campioni_add.jsp" %>
  
   </table> <!--  chiusura tabella generale -->
   </br>

  <table cellpadding="4" cellspacing="0" width="100%" class="details" style="display:none">
	<tr>
    <th colspan="2">
      <strong><dhv:label name="">Esito Campione</dhv:label></strong>
    </th>
	</tr>
 
  <%@ include file="/campioni/campioni_esito_add.jsp" %>
     
    
 </table>
  
  </br>
<input type="hidden" name="close" value="">
<input type="hidden" name="refresh" value="-1">
<input type="hidden" name="idApiario" value="<%=OrgDetails.getIdStabilimento()%>">
<input type="hidden" name="id_apiario" value="<%=OrgDetails.getIdStabilimento()%>">
<input type="hidden" name="modified" value="<%=  TicketDetails.getModified() %>" />
<input type="hidden" name="currentDate" value="<%=  request.getAttribute("currentDate") %>" />
<input type="hidden" name="statusId" value="<%=  TicketDetails.getStatusId() %>" />
<input type="hidden" name="trashedDate" value="<%=  TicketDetails.getTrashedDate() %>" />
<%= addHiddenParams(request, "popup|popupType|actionId") %>


<br>
<!-- <input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" onClick="if( confirm('Attenzione! Controlla bene tutti i dati inseriti perch� non potrai pi� modificarli. Vuoi concludere l\'inserimento?') ){return checkForm(this.form)}else return false;"> -->
<!-- <input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" class="Save"> -->

	  <%@ include file="/campioni/opu_bottoni_campioni.jsp" %>

<%-- <input type="button" value="<dhv:label name="button.insert">Insert</dhv:label>" id="Save" name="Save" class="Save" onClick="javascript:controllaAnaliti();" /> --%>
<%-- <input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.location.href='<%=OrgDetails.getAction() %>Vigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC") %>&idStabilimentoopu=<%=OrgDetails.getIdStabilimento()%>';this.form.dosubmit.value='false';" /> --%>
</form>
</body>



