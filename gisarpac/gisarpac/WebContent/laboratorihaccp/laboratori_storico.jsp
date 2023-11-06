<%@ include file="../initPage.jsp" %>

<table class="trails" cellspacing="0">
<tr>
<td>
<a href="LaboratoriHACCP.do?command=SearchForm"><dhv:label name="">Laboratori HACCP</dhv:label></a> > 
<%--if (request.getParameter("return") == null) { %>
<a href="LaboratoriHACCP.do?command=Search&tipoRicerca=<%= request.getAttribute("tipoRicerca")%>"><dhv:label name="">Risultati Ricerca</dhv:label></a> >
<%} else if (request.getParameter("return").equals("dashboard")) {%>
<a href="LaboratoriHACCP.do?command=Dashboard"><dhv:label name="communications.campaign.Dashboard">Dashboard</dhv:label></a> >
<%}--%>
<a href="LaboratoriHACCP.do?command=Details&tipoRicerca=prova&orgId=<%= request.getAttribute("orgId") %>"><dhv:label name="">Scheda Laboratorio HACCP</dhv:label></a> > 
<dhv:label name="">Storico Laboratorio HACCP</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<dhv:container name="laboratorihaccp" selected="Storico">
<html>
	<a href="LaboratoriHACCPHistory.do?command=StoricoProve&tipoStorico=lab&orgId=<%= request.getAttribute("orgId") %>">Visualizza Storico Laboratori</a> &nbsp
	<a href="LaboratoriHACCPHistory.do?command=StoricoProve&tipoStorico=prove&orgId=<%= request.getAttribute("orgId") %>">Visualizza Storico Prove</a>
</html>
</dhv:container>