<%@ include file="header.jsp" %>

<jsp:useBean id="listaUtenti" class="java.util.ArrayList" scope="request"/>
<%@ page import="org.aspcfs.modules.util.base.*" %>


<script>
function modifica(form, id){
	form.action = 'Utility.do?command=GURUModify&userId='+id;
	loadModalWindow();
	form.submit();
}
function modificaPassword(form, id){
	form.action = 'Utility.do?command=GURUModifyPassword&userId='+id;
	loadModalWindow();
	form.submit();
}
function modificaAlias(form, id){
	form.action = 'Utility.do?command=GURUModifyAlias&userId='+id;
	loadModalWindow();
	form.submit();
}
function disabilita(form, id){
	form.action = 'Utility.do?command=GURUModifyDisable&userId='+id;
	loadModalWindow();
	form.submit();
}
</script>

<style>
#myTable {
  border-collapse: collapse; /* Collapse borders */
  width: 100%; /* Full-width */
  border: 1px solid #ddd; /* Add a grey border */
  font-size: 18px; /* Increase font-size */
}

#myTable th, #myTable td {
  text-align: left; /* Left-align text */
  padding: 12px; /* Add padding */
}

#myTable tr {
  /* Add a bottom border to all table rows */
  border-bottom: 1px solid #ddd;
}

#myTable tr.header, #myTable tr:hover {
  /* Add a grey background color to the table header and on hover */
  background-color: #f1f1f1;
}</style>


<script>
function filtra(index) {
	
	for (var k = 0; k<10;k++){
		if (index!=k)
			if (document.getElementById("filtro"+k)!=null)
				document.getElementById("filtro"+k).value ="";
	}
	
  // Declare variables
  var input, filter, table, tr, td, i, txtValue;
  input = document.getElementById("filtro"+index);
  filter = input.value.toUpperCase();
  table = document.getElementById("myTable");
  tr = table.getElementsByTagName("tr");

  // Loop through all table rows, and hide those who don't match the search query
  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[index];
    if (td) {
      txtValue = td.textContent || td.innerText;
      if (txtValue.toUpperCase().indexOf(filter) > -1) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    }
  }
}
</script>


<form name="GURU" action="" method="post">

<table class="tableguru" width="100%" id="myTable">

<tr><th>Username<br/><input type="text" id="filtro0" onkeyup="filtra(0)" placeholder="FILTRA ..."><th>Alias<br/><input type="text" id="filtro1" onkeyup="filtra(1)" placeholder="FILTRA ..."></th><th>Nome</th><th>Cognome<br/><input type="text" id="filtro3" onkeyup="filtra(3)" placeholder="FILTRA ..."></th><th>Codice fiscale<br/><input type="text" id="filtro4" onkeyup="filtra(4)" placeholder="FILTRA ..."></th><th>DIPARTIMENTO</th><th>Ruolo</th><th></th></tr>

<%
	for (int i = 0; i<listaUtenti.size(); i++){
	GURUUtente utente = (GURUUtente) listaUtenti.get(i);
%>
		
		<tr>
		<td><%=utente.getUsername() %></td>
		<td><%=utente.getAlias() %></td>
		<td><%=utente.getNome() %></td>
		<td><%=utente.getCognome() %></td>
		<td><%=utente.getCf() %></td>
		<td><%=utente.getAsl()%></td>
		<td><%=utente.getRuolo() %></td>
		
		<td>
		<% if (utente.getIdRuolo()!=329){ //GESTORE DISTRIBUTORI %>
		<input type="button" class="littlebuttonguru" onClick="modifica(this.form, '<%=utente.getId() %>')" value="MODIFICA"/>
		<input type="button" class="littlebuttonguru" onClick="disabilita(this.form, '<%=utente.getId() %>')" value="DISABILITA"/>
		<br/>
		<input type="button" class="littlebuttonguru" onClick="modificaPassword(this.form, '<%=utente.getId() %>')" value="CAMBIA PASSWORD"/>
		<input type="button" class="littlebuttonguru" onClick="modificaAlias(this.form, '<%=utente.getId() %>')" value="CAMBIA ALIAS"/>
		<%} %>
		</td>
		
		</tr>		
			
		<%}	%>

</table>
</form>

