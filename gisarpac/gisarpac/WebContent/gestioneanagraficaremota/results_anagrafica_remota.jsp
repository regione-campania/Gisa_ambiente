<%@page import="org.aspcfs.modules.gestioneanagraficaremota.base.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>


<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<jsp:useBean id="ListaAnagrafiche" class="java.util.ArrayList" scope="request"/>

<%@ include file="../initPage.jsp" %>


<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></SCRIPT>


<script>
function importAnagraficaRemota(id, tab){
	if (confirm("Attenzione. Sarà eseguito un tentativo di import dell'anagrafica selezionata. Proseguire?")){
		loadModalWindow();
		window.location.href="GestioneAnagraficaRemotaAction.do?command=ImportAnagraficaRemota&riferimentoId="+id+"&riferimentoIdNomeTab="+tab;
	}
	return false;
}

</script>
	
<center><b>Lista anagrafiche</b></center>
  		
<table  class="details" width="100%">

		<tr>
			<th>Ragione Sociale</th>
			<th>Partita IVA</th>
			<th>Codice fiscale</th>
			<th>Dipartimento</th>
			<th>Sede Operativa</th>
			<th>Sede Legale</th>
			<th>Rappresentante legale</th>
			<th></th>
		</tr>
			<%

	if (ListaAnagrafiche.size()>0) {
		for (int i=0;i<ListaAnagrafiche.size(); i++){
			AnagraficaRemota anag = (AnagraficaRemota) ListaAnagrafiche.get(i);
			
			%>
			
			<tr class="row<%=i%2%>">
			<td><%= anag.getRagione_sociale()%></td> 
			<td><%=anag.getPartita_iva() %></td> 
			<td><%=anag.getCodice_fiscale() %> </td> 
			<td><%=anag.getAsl() %> </td> 
			<td><%=anag.getIndirizzo() %> <%=anag.getProvincia_stab() %> </td> 
			<td><%=anag.getIndirizzo_leg()%> <%=anag.getProvincia_leg() %> </td> 
			<td><%=anag.getNominativo_rappresentante()%> </td> 
			<td><input type="button" value="IMPORTA" onClick="importAnagraficaRemota('<%=anag.getRiferimento_id()%>', '<%=anag.getRiferimento_id_nome_tab()%>')"/></td>
		<%} } else {%>
		<tr><td colspan="7"> Non sono state trovate anagrafiche.</td></tr> 
		<% } %>
		
	
	</table>
	


</body>
</html>