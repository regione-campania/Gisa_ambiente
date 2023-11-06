<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.troubletickets.base.*,com.zeroio.iteam.base.*, org.aspcfs.modules.quotes.base.*,org.aspcfs.modules.base.EmailAddress" %>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.diffida.base.Ticket" scope="request"/>

<jsp:useBean id="ticketCategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="product" class="org.aspcfs.modules.products.base.ProductCatalog" scope="request"/>
<jsp:useBean id="customerProduct" class="org.aspcfs.modules.products.base.CustomerProduct" scope="request"/>
<jsp:useBean id="quoteList" class="org.aspcfs.modules.quotes.base.QuoteList" scope="request"/>
<jsp:useBean id="OrgDetails" class="ext.aspcfs.modules.apiari.base.Stabilimento" scope="request"/>
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SanzioniAmministrative" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SanzioniPenali" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Sequestri" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="causeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ticketStateList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolutionList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="defectCheck" class="java.lang.String" scope="request"/>
<jsp:useBean id="defect" class="org.aspcfs.modules.troubletickets.base.TicketDefect" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>

<%@ include file="../initPage.jsp" %>

<%
TicketDetails.setPermission();
%>
<form name="details" action="ApicolturaApiariDiffida.do?command=ModifyTicket&auto-populate=true" method="post">
<input type = "hidden" name = "idC" value = "<%=request.getAttribute("idC")%>">


<input type ="hidden" name = "idNC" value="<%=request.getAttribute("idNC") %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
  <a href="ApicolturaAttivita.do">Apiari</a> > 
  <a href="ApicolturaAttivita.do?command=SearchForm"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
  <a href="ApicolturaApiari.do?command=Details&stabId=<%=OrgDetails.getIdStabilimento()%>">Scheda Apiari</a> >
  <a href="ApicolturaApiari.do?command=ViewVigilanza&stabId=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="">Controlli Ufficiali</dhv:label></a> >
  <a href="ApicolturaApiariVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC")%>&stabId=<%=OrgDetails.getIdStabilimento()%>&idStabilimentoopu=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="">Controllo Ufficiale</dhv:label></a> >
<%--<%if (TicketDetails.getTipologiaNonConformita()==Ticket.TIPO_NON_CONFORMITA_A_CARICO){ 
<a href="ApicolturaApiariNonConformita.do?command=TicketDetails&id=<%= request.getAttribute("idNC")%>&stabId=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="">Non Conformit� Rilevata</dhv:label></a> >
 <%}
else
{
%>
<a href="ApicolturaApiariAltreNonConformita.do?command=TicketDetails&id=<%= request.getAttribute("idNC")%>&stabId=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="">Non Conformit� Rilevata</dhv:label></a> >

<%} %>--%>
<a href="ApicolturaApiariNonConformita.do?command=TicketDetails&id=<%= request.getAttribute("idNC")%>&stabId=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="">Non Conformit� Rilevata</dhv:label></a> >
  Scheda Diffida
</td>
</tr>
</table>
<%-- End Trails --%>

<dhv:container name="apiari" selected="vigilanza" object="OrgDetails" param='<%= "stabId=" + OrgDetails.getIdStabilimento()+"&opId=" + OrgDetails.getIdOperatore()%>' hideContainer='<%= isPopup(request) || (defectCheck != null && !"".equals(defectCheck.trim())) %>'>

	
	<%
	String permission_op_edit = TicketDetails.getPermission_ticket()+"-diffida-edit" ;
	String permission_op_del = TicketDetails.getPermission_ticket()+"-diffida-delete" ;
	
	%>
	<%@ include file="../controlliufficiali/opu_header_diffida.jsp"%>
	
	<%@ include file="../controlliufficiali/diffida_view.jsp"%>
	
	
	<br />
	
&nbsp;
<br />
		<%@ include file="../controlliufficiali/opu_header_diffida.jsp"%>
<%-- </dhv:container> --%>
</dhv:container>
</form>
