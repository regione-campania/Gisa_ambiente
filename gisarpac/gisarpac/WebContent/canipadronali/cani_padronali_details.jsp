
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<jsp:useBean id="Proprietario" class ="org.aspcfs.modules.canipadronali.base.Proprietario" scope ="request" />
<jsp:useBean id="ListaAsl" class ="org.aspcfs.utils.web.LookupList" scope ="request" />

<%@ include file="../initPage.jsp" %>
<% String param1 = "orgId=" + Proprietario.getIdProprietario(); %>
<dhv:container name="canipadronalidet" selected="details" object="CaneDetails" param="<%= param1 %>" >
<table class="trails" cellspacing="0">
<tr>
<td>Cani Padronali> Anagrafica Cani di proprieta</td>
</tr>
</table>
<br>





 <jsp:include page="../schede_centralizzate/iframe.jsp">
    <jsp:param name="objectId" value="<%=Proprietario.getIdProprietario() %>" />
     <jsp:param name="tipo_dettaglio" value="31" />
</jsp:include>

</dhv:container>