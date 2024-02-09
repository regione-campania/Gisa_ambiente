<%@page import="org.aspcfs.modules.opu.base.Stabilimento"%>
<%@page import="org.aspcfs.modules.troubletickets.base.Ticket"%>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.ricercaunica.base.*, org.aspcfs.modules.base.*" %>
<jsp:useBean id="anagraficheList" class="java.util.ArrayList" scope="request"/>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>
<%@ include file="../initPopupMenu.jsp" %>

<center><b>In questa tabella sono riportate le anagrafiche che rispettano i seguenti vincoli: <br/>
Codice fiscale rappresentante legale: <%=User.getContact().getCodiceFiscale() %><br/>
Linea produttiva: Distributori</b></center>
<br/><br/>

<% if (anagraficheList.size()>0) { %>

<table cellpadding="8" cellspacing="0" border="0" style="width: 100%" class="pagedList">
<tr>
<th>RAGIONE SOCIALE</th>
<th>PARTITA IVA</th>
<th>ASL</th>
<th>NUM REGISTRAZIONE/APPROVAL NUMBER</th>
<th>SEDE LEGALE</th>
<th>DISTRIBUTORI</th>
</tr>

<%
	for (int i = 0; i<anagraficheList.size(); i++) {
	RicercaAIA anagrafica = (RicercaAIA) anagraficheList.get(i);
%>

<tr>
<td><%=anagrafica.getRagioneSociale() %></td>
<td><%=anagrafica.getPartitaIva() %></td>
<td><%=anagrafica.getAsl() %></td>
<td><%=anagrafica.getNumeroRegistrazione() != null ? anagrafica.getNumeroRegistrazione() : anagrafica.getNumAut() %></td>
<td><%=anagrafica.getComuneSedeLegale() %></td>
<td>
<dhv:permission name="gestione-distributori-view"> 
	<jsp:include page="../gestionedistributori/bottone.jsp">
	<jsp:param name="riferimentoId" value="<%=anagrafica.getRiferimentoId() %>" />
	<jsp:param name="riferimentoIdNomeTab" value="<%=anagrafica.getRiferimentoIdNomeTab() %>" />
	</jsp:include>
</dhv:permission>
</td>
</tr>


<% } %>
 
</table>

<% } else { %>
<font color="red">Attenzione. Per questo codice fiscale non risultano presenti nel sistema rappresentanti legali di anagrafiche con linea distributori. </font>
<% } %>



    

