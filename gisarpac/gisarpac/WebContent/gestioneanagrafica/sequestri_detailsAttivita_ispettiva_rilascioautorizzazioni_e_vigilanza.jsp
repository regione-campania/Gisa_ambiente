<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.sequestri.base.Ticket" scope="request"/>
<jsp:useBean id="ticketCategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="product" class="org.aspcfs.modules.products.base.ProductCatalog" scope="request"/>
<jsp:useBean id="customerProduct" class="org.aspcfs.modules.products.base.CustomerProduct" scope="request"/>
<jsp:useBean id="quoteList" class="org.aspcfs.modules.quotes.base.QuoteList" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcf.modules.controlliufficiali.base.Organization" scope="request"/>
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SequestriAmministrative" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SequestriPenali" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Sequestri" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="SequestroDi" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoSequestro" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SequestroDi_sp" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="causeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ticketStateList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolutionList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="defectCheck" class="java.lang.String" scope="request"/>
<jsp:useBean id="defect" class="org.aspcfs.modules.troubletickets.base.TicketDefect" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<script type="text/javascript">

</script>
<%@ include file="../initPage.jsp" %>
<form name="details" action="GestioneAnagraficaSequestri.do?command=ModifyTicket&auto-populate=true" method="post">
<input type ="hidden" name = "idC" value="<%=request.getAttribute("idC") %>">
<input type ="hidden" name = "idNC" value="<%=request.getAttribute("idNC") %>">
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="GestioneAnagraficaAction.do"><dhv:label name="">Operatori Abusivi</dhv:label></a> > 
<%-- <a href="GestioneAnagraficaAction.do?command=Search"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> > --%>
<a href="GestioneAnagraficaAction.do?command=Details&altId=<%=TicketDetails.getAltId()%>"><dhv:label name="">scheda </dhv:label></a> >
<a href="GestioneAnagraficaAction.do?command=ViewVigilanza&altId=<%=TicketDetails.getAltId()%>"><dhv:label name="">Controlli Ufficiali</dhv:label></a> >
<a href="GestioneAnagraficaVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC")%>&altId=<%=TicketDetails.getAltId()%>"><dhv:label name="">Controllo Ufficiale</dhv:label></a> >

<%
if (TicketDetails.getTipologiaNonConformita()==TicketDetails.TIPO_NON_CONFORMITA_A_CARICO)
{
	%>
<a href="GestioneAnagraficaNonConformita.do?command=TicketDetails&id=<%= request.getAttribute("idNC")%>&altId=<%=TicketDetails.getAltId()%>"><dhv:label name="">Non Conformit� Rilevata</dhv:label></a> >
	
	<%
}else
{
%>
<a href="GestioneAnagraficaAltreNonConformita.do?command=TicketDetails&id=<%= request.getAttribute("idNC")%>&altId=<%=TicketDetails.getAltId()%>"><dhv:label name="">Non Conformit� Rilevata</dhv:label></a> >

<%} %>
<%--a href="Accounts.do?command=ViewSequestri&altId=<%=TicketDetails.getAltId() %>"><dhv:label name="sequestri">Sequestri</dhv:label></a> --%>
<%
	if (defectCheck != null && !"".equals(defectCheck.trim())) {
%>
  <a href="GestioneAnagraficaSequestri.do?command=TicketDetails&Id=<%=TicketDetails.getId()%>&altId=<%=OrgDetails.getAltId() %>"><dhv:label name="tickets.defects.viewDefects">View Defects</dhv:label></a> >
  <a href="GestioneAnagraficaSequestriDefects.do?command=Details&defectId=<%= defectCheck %>"><dhv:label name="tickets.defects.defectDetails">Defect Details</dhv:label></a> >
<%
  	} else {
  %>
<%
	if ("yes"
				.equals((String) session.getAttribute("searchTickets"))) {
%>
<%--   <a href="GestioneAnagraficaSequestri.do?command=SearchTicketsForm"><dhv:label name="tickets.searchForm">Search Form</dhv:label></a> > --%>
<%--   <a href="GestioneAnagraficaSequestri.do?command=SearchTickets"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> > --%>
<%
  	} else {
  %> 
 <%--  <a href="Accounts.do?command=ViewSequestri&altId=<%=OrgDetails.getAltId()%>"><dhv:label name="sequestri.visualizza">Visualizza Sequestri Amministrative</dhv:label></a> > --%>
<%
   	}
   %>
<%
	}
%>


<dhv:label name="sequestri.dettagli">Scheda Sequestro/Blocco </dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<%
	String param1 = "id=" + TicketDetails.getId() + "&altId="+TicketDetails.getAltId()+"&idNC="+request.getAttribute("idNC");
%>
<dhv:container name="gestioneanagrafica" selected="vigilanza" object="OrgDetails" param='<%= "altId=" + TicketDetails.getAltId() %>' hideContainer='<%= isPopup(request) || (defectCheck != null && !"".equals(defectCheck.trim())) %>'>
	
	<%
	TicketDetails.setPermission();
	String permission_op_edit = TicketDetails.getPermission_ticket()+"-sequestri-edit" ;
	String permission_op_del = TicketDetails.getPermission_ticket()+"-sequestri-delete" ;
	
	%>
	<%@ include file="../controlliufficiali/header_sequestri.jsp"%>
	
	<%@ include file="../controlliufficiali/sequestri_view.jsp"%>
<br />
	<%@ include file="../controlliufficiali/header_sequestri.jsp"%>
	
</dhv:container>
</form>
	
	
<%
String msg = (String)request.getAttribute("Messaggio");
if(request.getAttribute("Messaggio")!=null)
{
	%>
	<script>
	
	alert("La pratica non pu� essere chiusa . \n Controllare di aver inserito l'esito.");
	</script>
	<%
}

%>