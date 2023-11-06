<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.allevamenti.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>

<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.allevamenti.base.Organization" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<%@ include file="../initPage.jsp" %>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>

<script>
function checkForm(form, allevId){
	if (confirm("Attenzione. Questo allevamento sara' aggiornato (se possibile) con i dati attualmente presenti in BDN. Proseguire?")){
		loadModalWindow();
		form.submit();
	}
}
</script>

<body>

<br>
<br>
<%@ include file="../../controlliufficiali/diffida_list.jsp" %>

<dhv:permission name="allevamenti-allevamenti-report-view">
  <table width="100%" border="0">
    <tr>
      <td nowrap align="right">
      <script language="JavaScript" TYPE="text/javascript" SRC="gestione_documenti/generazioneDocumentale.js"></script>
	<img src="images/icons/stock_print-16.gif" border="0" align="absmiddle" height="16" width="16"/>
     <input type="button" title="Stampa Scheda" value="Stampa Scheda"		onClick="openRichiestaPDF2('<%= OrgDetails.getId() %>', '-1', '-1', '-1', '6');">
      </td>
    </tr>
  </table>
</dhv:permission>


<% String param1 = "orgId=" + OrgDetails.getOrgId(); %>
<dhv:container name="allevamenti" selected="details" object="OrgDetails" param="<%= param1 %>" appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>' hideContainer="false" >

<dhv:permission name="note_hd-view">
<jsp:include page="../note_hd/link_note_hd.jsp">
<jsp:param name="riferimentoId" value="<%=OrgDetails.getOrgId() %>" />
<jsp:param name="riferimentoIdNomeTab" value="organization" />
</jsp:include> <br><br>
</dhv:permission>

<jsp:include page="../preaccettazionesigla/button_preaccettazione.jsp">
    <jsp:param name="riferimentoIdPreaccettazione" value="<%=OrgDetails.getOrgId() %>" />
    <jsp:param name="riferimentoIdNomePreaccettazione" value="orgId" />
    <jsp:param name="riferimentoIdNomeTabPreaccettazione" value="organization" />
    <jsp:param name="userIdPreaccettazione" value="<%=User.getUserId() %>" />
</jsp:include>


<jsp:include page="../schede_centralizzate/iframe.jsp">
    <jsp:param name="objectId" value="<%=OrgDetails.getOrgId() %>" />
     <jsp:param name="tipo_dettaglio" value="6" />
     </jsp:include>

<br/><br/>
<form method="post" action = "GestioneAllevamentiBdn.do?command=ImportaDaBdn">
<center>
<input type="button" value="AGGIORNA DA BDN" onClick="checkForm(this.form, '<%=OrgDetails.getId_allevamento()%>')"/>
<input type="hidden" id="allevId" name="allevId" value="<%=OrgDetails.getId_allevamento()%>"/>
<input type="hidden" name="orgId" name="orgId" value="<%= OrgDetails.getOrgId() %>"/>
</center>
</form>

</dhv:container>

</body>