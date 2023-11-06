
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.vigilanza.base.Ticket,com.zeroio.iteam.base.*,org.aspcfs.modules.canipadronali.base.*" %>
<jsp:useBean id="CaneDetails" class="org.aspcfs.modules.canipadronali.base.Proprietario" scope="request"/>
<jsp:useBean id="TipoCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AuditTipo" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="EsitoCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoAudit" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoIspezione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TicList" class="org.aspcfs.modules.vigilanza.base.TicketList" scope="request"/>
<jsp:useBean id="AccountTicketInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>
<%@ include file="../initPopupMenu.jsp" %>
<%@ include file="accounts_vigilanza_list_menu.jsp" %>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<script language="JavaScript" type="text/javascript">
  <%-- Preload image rollovers for drop-down menu --%>
  
</script>
<dhv:evaluate if="<%= !isPopup(request) %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>

<a href="CaniPadronali.do?command=SearchForm">Anagrafica Cani di proprieta</a> > 
<a href="CaniPadronali.do?command=Detail&orgId=<%=CaneDetails.getIdProprietario()%>">Scheda Anagrafica Cani di proprieta</a> >
<dhv:label name="vigilanza">Controlli Ufficiali</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
</dhv:evaluate>
<dhv:container name="canipadronalidet" selected="vigilanza" object="CaneDetails" param='<%= "orgId=" + CaneDetails.getIdProprietario()%>' appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>'>

    <dhv:permission name="canipadronali-vigilanza-add">
    <a href="CaniPadronaliVigilanza.do?command=Add&orgId=<%= CaneDetails.getIdProprietario() %><%= addLinkParams(request, "popup|popupType|actionId") %>">
    <dhv:label name="accounts.richiesta.add">Aggiungi Nuovo Controllo Ufficiale</dhv:label></a>
    </dhv:permission>
    <input type=hidden name="orgId" value="<%= CaneDetails.getIdProprietario() %>">
    <br>
  <dhv:pagedListStatus title='<%= showError(request, "actionError") %>' object="AccountTicketInfo"/>
  
  <%
  if(request.getAttribute("punteggioUltimiAnni")!=null){
	  
	  out.println("Attuale Punteggio Storico Delle Non Conformita : "+request.getAttribute("punteggioUltimiAnni")+"<br>");
	  
	  
  }
  
  %>
  <%org.aspcfs.modules.canipadronali.base.Proprietario OrgDetails = CaneDetails; %>
  
 <%@ include file="../controlliufficiali/lista_controlli_ufficiali.jsp" %>

	<br>
  <dhv:pagedListControl object="AccountTicketInfo"/>
</dhv:container>