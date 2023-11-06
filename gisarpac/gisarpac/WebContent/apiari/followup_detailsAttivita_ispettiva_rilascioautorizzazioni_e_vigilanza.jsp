<%@page import="ext.aspcfs.modules.apiari.base.Operatore"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.troubletickets.base.*,com.zeroio.iteam.base.*, org.aspcfs.modules.quotes.base.*,org.aspcfs.modules.base.EmailAddress" %>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.followup.base.Ticket" scope="request"/>
<jsp:useBean id="ticketCategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="product" class="org.aspcfs.modules.products.base.ProductCatalog" scope="request"/>
<jsp:useBean id="customerProduct" class="org.aspcfs.modules.products.base.CustomerProduct" scope="request"/>
<jsp:useBean id="quoteList" class="org.aspcfs.modules.quotes.base.QuoteList" scope="request"/>
<jsp:useBean id="OrgDetails" class="ext.aspcfs.modules.apiari.base.Stabilimento" scope="request"/>
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="FollowupAmministrative" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="FollowupPenali" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Sequestri" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="causeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ticketStateList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolutionList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="defectCheck" class="java.lang.String" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>

<%@ include file="../initPage.jsp" %>
<form name="details" action="ApicolturaApiariFollowup.do?command=ModifyTicket&auto-populate=true" method="post">
<input type ="hidden" name = "idC" value="<%=request.getAttribute("idC") %>">
<input type ="hidden" name = "idNC" value="<%=request.getAttribute("idNC") %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="ApicolturaApiari.do"><dhv:label name="accounts.accounts">Apiari</dhv:label></a> > 
<a href="ApicolturaApiari.do?command=Search"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
<a href="ApicolturaApiari.do?command=Details&stabId=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="accounts.details"> Scheda Apiario</dhv:label></a> >
<a href="ApicolturaApiari.do?command=ViewVigilanza&stabId=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="">Controlli Ufficiali</dhv:label></a> >
<a href="ApicolturaApiariVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC")%>&stabId=<%=OrgDetails.getIdStabilimento()%>&idStabilimentoopu=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="">Controllo Ufficiale</dhv:label></a> >

<%
if (TicketDetails.getTipologiaNonConformita()==Ticket.TIPO_NON_CONFORMITA_A_CARICO)
{
	%>
<a href="ApicolturaApiariNonConformita.do?command=TicketDetails&id=<%= request.getAttribute("idNC")%>&stabId=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="">Non Conformit� Rilevata</dhv:label></a> >
	
	<%
}else
{
%>
<a href="ApicolturaApiariAltreNonConformita.do?command=TicketDetails&id=<%= request.getAttribute("idNC")%>&stabId=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="">Non Conformit� Rilevata</dhv:label></a> >

<%} %>

<%
	if (defectCheck != null && !"".equals(defectCheck.trim())) {
%>
  <a href="ApicolturaApiariFollowup.do?command=TicketDetails&Id=<%=TicketDetails.getId()%>&stabId=<%=OrgDetails.getIdStabilimento()%>"><dhv:label name="tickets.defects.viewDefects">View Defects</dhv:label></a> >
  <a href="ApicolturaApiariFollowupDefects.do?command=Details&defectId=<%= defectCheck %>"><dhv:label name="tickets.defects.defectDetails">Defect Details</dhv:label></a> >
<%
  	} else {
  %>
<%
	if ("yes"
				.equals((String) session.getAttribute("searchTickets"))) {
%>
  <a href="ApicolturaApiariFollowup.do?command=SearchTicketsForm"><dhv:label name="tickets.searchForm">Search Form</dhv:label></a> >
  <a href="ApicolturaApiariFollowup.do?command=SearchTickets"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
<%
  	} else {
  %> 
 <%--  <a href="ApicolturaApiari.do?command=ViewFollowup&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="followup.visualizza">Visualizza Notizie di Reato</dhv:label></a> > --%>
<%
   	}
   %>
<%
	}
%>


<dhv:label name="followup.dettagli">Scheda Follow Up</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<%
Operatore operatore = OrgDetails.getOperatore();
request.setAttribute("Operatore", operatore);	
String param1 = "id=" + TicketDetails.getId() + "&orgId="+TicketDetails.getOrgId()+"&idNC="+request.getAttribute("idNC");
%>
<dhv:container name="apiari" selected="vigilanza" object="Operatore" param='<%= "stabId=" + OrgDetails.getIdStabilimento()+"&opId="+OrgDetails.getIdOperatore()%>' hideContainer='<%= isPopup(request) || (defectCheck != null && !"".equals(defectCheck.trim())) %>'>

	<%-- include file="ticket_header_include_followup.jsp" --%>
	
		<%
	String permission_op_edit = TicketDetails.getPermission_ticket()+"-followup-edit" ;
	String permission_op_del = TicketDetails.getPermission_ticket()+"-followup-delete" ;
	
	%>
	
	
	<%@ include file="../controlliufficiali/opu_header_followupi.jsp" %>
	
	<%@ include file="../controlliufficiali/opu_followup_view.jsp" %>
		
	<br />
	
&nbsp;
<br />
	
	
	<%@ include file="../controlliufficiali/opu_header_followupi.jsp" %>
</dhv:container>
</form>
