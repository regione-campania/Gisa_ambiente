
<%@page import="java.util.Iterator"%>
<%@page import="org.aspcfs.modules.allevamenti.base.Organization"%>
<jsp:useBean id="ListaAllevamenti" class="org.aspcfs.modules.allevamenti.base.OrganizationList" scope="request"/>

<script>
function setParentValue(ragione_sociale,id_allevamento)
{
	window.opener.document.getElementById("ragione_sociale_allevamento").value = ragione_sociale ;
	window.opener.document.getElementById("id_allevamento").value = id_allevamento ;
	window.opener.document.getElementById('azienda').innerHTML = ragione_sociale ;
	window.close();
}

</script>

<table class="details" width="100%">
<tr>
<th>Codice Azienda</th>
<th>Id Allevamento</th>
<th>Ragione Sociale</th>
<th>Specie Allevata</th>
</tr>

<%

if (ListaAllevamenti.size()!=0)
{
Iterator it = ListaAllevamenti.iterator();
while (it.hasNext())
{
	Organization allevamento = (Organization)it.next();
	%>
	<tr>
	<td><a href="#" onclick="setParentValue('<%=allevamento.getName() %>',<%=allevamento.getOrgId() %>)"><%=allevamento.getAccountNumber() %></a></td>
	<td><%=allevamento.getId_allevamento() %></td>
	<td><%=allevamento.getName() %></td>
	<td><%=allevamento.getSpecieAllev() %></td>
	</tr>
	
	<%
	}

}
else
{
	%>
	<tr>
	
	<td colspan="4">Nessun Allevamento Trovato Per il codice Azienda</td><tr>
	<%
}
%>