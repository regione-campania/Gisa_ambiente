<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonGiornataIspettiva" class="org.json.JSONObject" scope="request"/>

<jsp:useBean id="ListaPerContoDi" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
function checkForm(form){
	var msg = "";
	var esito = true;
	
	var almenoUnPerContoDi = false;

	var x = document.getElementsByName("perContoDiId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnPerContoDi = true;
			
		}
	}
	
	if (!almenoUnPerContoDi){
		msg +="Selezionare almeno un per conto di.\n";
		esito = false;
	}
	
	
		
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.submit();
}

function backForm(form){
	
	form.action="GestioneGiornateIspettive.do?command=AddDati";

	loadModalWindow();
	form.submit();
	
}


function filtraRighe() {
	  // Declare variables
	  var table = document.getElementById("tablePerContoDi");
	  var input1 = document.getElementById("myInputPerContoDi");
	  var input2 = document.getElementById("myInputTipologia");
	  var input3 = document.getElementById("myInputAppartenenza");
	  var input4 = document.getElementById("myInputDipartimento");

	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter1 = input1.value.toUpperCase();
	  filter2 = input2.value.toUpperCase();
	  filter3 = input3.value.toUpperCase();
	  filter4 = input4.value.toUpperCase();

	  tr = table.getElementsByTagName("tr");

	  // Loop through all table rows, and hide those who don't match the search query
	  for (i = 0; i < tr.length; i++) {
	    td0 = tr[i].getElementsByTagName("td")[0];
	    td1 = tr[i].getElementsByTagName("td")[1];
	    td2 = tr[i].getElementsByTagName("td")[2];
	    td3 = tr[i].getElementsByTagName("td")[3];
	    td4 = tr[i].getElementsByTagName("td")[4];

	    if (td0) {
	      txtValue0 = td0.textContent || td0.innerText;
	      txtValue1 = td1.textContent || td1.innerText;
	      txtValue2 = td2.textContent || td2.innerText;
	      txtValue3 = td3.textContent || td3.innerText;
	      txtValue4 = td4.textContent || td4.innerText;

	      if (txtValue1.toUpperCase().indexOf(filter1) > -1 && txtValue2.toUpperCase().indexOf(filter2) > -1 && txtValue3.toUpperCase().indexOf(filter3) > -1 && txtValue4.toUpperCase().indexOf(filter4) > -1) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
	}
	

</script>

<form name="aggiungiCU" action="GestioneGiornateIspettive.do?command=AddLinea&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" id ="tablePerContoDi" name="tablePerContoDi" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="5%"><col width="10%"><col width="30%">
<tr><th colspan="5"><center><b>PER CONTO DI</b></center></th></tr>

<tr>
<th>Seleziona</th>
<th>Descrizione</th>
<th>Tipologia</th>
<th>Appartenenza</th>
<th>Dipartimento</th>

</tr>

<tr>
<th></th>
<th><input type="text" id="myInputPerContoDi" onkeyup="filtraRighe()" placeholder="FILTRA PER CONTO DI" style="width: 100%"></th>
<th><input type="text" id="myInputTipologia" onkeyup="filtraRighe()" placeholder="FILTRA TIPOLOGIA" style="width: 100%"></th>
<th><input type="text" id="myInputAppartenenza" onkeyup="filtraRighe()" placeholder="FILTRA APPARTENENZA" style="width: 100%"></th>
<th><input type="text" id="myInputDipartimento" onkeyup="filtraRighe()" placeholder="FILTRA DIPARTIMENTO" style="width: 100%"></th>
</tr>


<input type="hidden" id="tecnica" nome="tecnica" value=<%=request.getAttribute("tecnica")%>>




<% 
for (int i = 0; i<ListaPerContoDi.size(); i++) {
Struttura perContoDi = (Struttura) ListaPerContoDi.get(i); %>

<tr>
<td>
<input type="checkbox" id ="<%= perContoDi.getId()%>" name="perContoDiId" value="<%= perContoDi.getId()%>" <%=ListaPerContoDi.size()==1 ? "checked: checked" : "" %>/>
<input type="hidden" readonly id ="perContoDiNome_<%= perContoDi.getId()%>" name ="perContoDiNome_<%= perContoDi.getId()%>" value="<%= perContoDi.getDipartimento()%> -> <%= perContoDi.getTipologia() %> -> <%= perContoDi.getAppartenenza() %> -> <%= perContoDi.getDescrizione() %>"/>
</td>
<td><%= perContoDi.getDescrizione() %></td>
<td><%= perContoDi.getTipologia() %></td>
<td><%= perContoDi.getAppartenenza() %></td>
<td><%= perContoDi.getDipartimento() %></td>
</tr>
<% } %>
</table>	

</td></tr>

</table>

<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><br/><br/>
<input type="button" value="INDIETRO" onclick="backForm(this.form)" style="font-size:40px; background-color:red"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" style="font-size:40px" value="PROSEGUI" onclick="checkForm(this.form)"/>
</td>
</tr>
</table>
<!-- BOTTONI -->

</center>

<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonGiornataIspettiva" name="jsonGiornataIspettiva" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonGiornataIspettiva%></textarea>
<!--JSON -->

</form>

<script>
function prettyPrint() {
    var ugly = document.getElementById('jsonGiornataIspettiva').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonGiornataIspettiva').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonGiornataIspettiva").get(0).scrollHeight;
$("#jsonGiornataIspettiva").css('height', scroll_height + 'px');

function reloadDati(){
	<% if ( ((JSONObject) jsonGiornataIspettiva).has("PerContoDi")) { %>
<% JSONArray jsonPerContoDi = (JSONArray) jsonGiornataIspettiva.get("PerContoDi");
for (int i = 0; i < jsonPerContoDi.length(); i++) {
JSONObject jsonObject = jsonPerContoDi.getJSONObject(i);
%>
document.getElementById("<%=jsonObject.get("id")%>").setAttribute("checked","true")
<%}}%>
}
reloadDati();

</script>
