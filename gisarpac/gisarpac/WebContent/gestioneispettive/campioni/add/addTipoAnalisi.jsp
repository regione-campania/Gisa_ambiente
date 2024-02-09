<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaTipiAnalisi" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>

function backForm(form){
	form.action="GestioneCampioni.do?command=AddProgrammaCampionamentoCategoriaMerceologica";
	loadModalWindow();
	form.submit();
}

function checkForm(form){
	
	var esito = true;
	var msg = '';
	
	var almenoUnAnalisi = false;
	
	var x = document.getElementsByName("tipoAnalisiId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnAnalisi = true;
		}
	}
	
	if (!almenoUnAnalisi){
		msg +="Selezionare almeno un tipo analisi.\n"; 
		esito = false;
	}
	
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.submit();
}


function filtraRighe() {
	  // Declare variables
	  var table = document.getElementById("tableTipoAnalisi");
	  var input0 = document.getElementById("myInputLivello1");
	  var input1 = document.getElementById("myInputLivello2");
	  var input2 = document.getElementById("myInputLivello3");
	  
	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter0 = input0.value.toUpperCase();
	  filter1 = input1.value.toUpperCase();
	  filter2 = input2.value.toUpperCase();

	  tr = table.getElementsByTagName("tr");

	  // Loop through all table rows, and hide those who don't match the search query
	  for (i = 0; i < tr.length; i++) {
	    td0 = tr[i].getElementsByTagName("td")[0];
	    td1 = tr[i].getElementsByTagName("td")[1];
	    td2 = tr[i].getElementsByTagName("td")[2];
	    td3 = tr[i].getElementsByTagName("td")[3];

	    if (td0) {
	      txtValue0 = td0.textContent || td0.innerText;
	      txtValue1 = td1.textContent || td1.innerText;
	      txtValue2 = td2.textContent || td2.innerText;
	      txtValue3 = td3.textContent || td3.innerText;

	      if (txtValue0.toUpperCase().indexOf(filter0) > -1 && txtValue1.toUpperCase().indexOf(filter1) > -1 && txtValue2.toUpperCase().indexOf(filter2) > -1) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
	}


</script>

<form name="aggiungiCampione" action="GestioneCampioni.do?command=AddLaboratorio&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>

<table class="details" id ="tableTipoAnalisi" name="tableTipoAnalisi" cellpadding="10" cellspacing="10" width="70%" style="border-collapse: collapse">
<tr><th colspan="4"><center><b>TIPO ANALISI</b></center></th></tr>

<tr>
<th>Livello 1</th>
<th>Livello 2</th>
<th>Livello 3</th>
<th></th>
</tr>

<tr>
<th><input type="text" id="myInputLivello1" onkeyup="filtraRighe()" placeholder="FILTRA LIVELLO 1" style="width: 100%"></th>
<th><input type="text" id="myInputLivello2" onkeyup="filtraRighe()" placeholder="FILTRA LIVELLO 2" style="width: 100%"></th>
<th><input type="text" id="myInputLivello3" onkeyup="filtraRighe()" placeholder="FILTRA LIVELLO 3" style="width: 100%"></th>
<th></th>
</tr>

<% 
for (int i = 0; i<ListaTipiAnalisi.size(); i++) {
TipoAnalisi tipo = (TipoAnalisi) ListaTipiAnalisi.get(i); %>

<tr>

<td><%=tipo.getLivello1() %></td>
<td><%=tipo.getLivello2() %></td>
<td><%=tipo.getLivello3() %></td>

<td>
<input type="checkbox" id ="<%= tipo.getId()%>" name="tipoAnalisiId" value="<%= tipo.getId()%>"/>
<input type="hidden" readonly id ="tipoAnalisiLivello1_<%= tipo.getId()%>" name ="tipoAnalisiLivello1_<%= tipo.getId()%>" value="<%= tipo.getLivello1() %>"/>
<input type="hidden" readonly id ="tipoAnalisiLivello2_<%= tipo.getId()%>" name ="tipoAnalisiLivello2_<%= tipo.getId()%>" value="<%= tipo.getLivello2() %>"/>
<input type="hidden" readonly id ="tipoAnalisiLivello3_<%= tipo.getId()%>" name ="tipoAnalisiLivello3_<%= tipo.getId()%>" value="<%= tipo.getLivello3() %>"/>
</td>

<% } %>

</table>	


<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr><td colspan="2" align="center"><br/><br/>
<input type="button" value="INDIETRO" onclick="backForm(this.form)" style="font-size:40px; background-color:red"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" style="font-size:40px" value="PROSEGUI" onclick="checkForm(this.form)"/></td></tr>
</table>
<!-- BOTTONI -->

</center>

<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonCampione" name="jsonCampione" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonCampione%></textarea>
<!--JSON -->

</form>

<script>
function prettyPrint() {
    var ugly = document.getElementById('jsonCampione').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonCampione').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonCampione").get(0).scrollHeight;
$("#jsonCampione").css('height', scroll_height + 'px');
</script>
