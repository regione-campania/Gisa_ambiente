<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaComponentiTecnici" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>

function svuotaAltri(cb){
	
	if (!cb.checked)
		return null;
	
	var inputs = cb.form.getElementsByTagName("input");
	for(var i = 0; i < inputs.length; i++) {
	    if(inputs[i].type == "checkbox" && cb.id != inputs[i].id && inputs[i].id.includes(cb.id.substring(0,20))) {
	        inputs[i].checked = false; 
	    }  
	}
	
}

function checkForm(form){ 
	var msg = "";
	var esito = true;
	
	var almenoUnTecnico = false;
	
	var x = document.getElementsByName("componenteTecnicoId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnTecnico = true;
		}
	}
	
	if (!almenoUnTecnico){
		msg +="Selezionare almeno un tecnico del campionamento..\n"; 
		esito = false;
	}

	var almenoUnAddetto = false;
	
	var nomeAddetto1 = document.getElementById("componenteAddettoNome1").value.trim();
	var nomeAddetto2 = document.getElementById("componenteAddettoNome2").value.trim();
	var nomeAddetto3 = document.getElementById("componenteAddettoNome3").value.trim();
	var cognomeAddetto1 = document.getElementById("componenteAddettoCognome1").value.trim();
	var cognomeAddetto2 = document.getElementById("componenteAddettoCognome2").value.trim();
	var cognomeAddetto3 = document.getElementById("componenteAddettoCognome3").value.trim();
	
	if (nomeAddetto1 != '' && cognomeAddetto1 != '')
		almenoUnAddetto = true;
	if (nomeAddetto2 != '' && cognomeAddetto2 != '')
		almenoUnAddetto = true;
	if (nomeAddetto3 != '' && cognomeAddetto3 != '')
		almenoUnAddetto = true;
	
	if (!almenoUnAddetto){
		msg +="Indicare nome e cognome di almeno un addetto al campionamento.\n"; 
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
	form.action="GestioneCampioni.do?command=AddDatiParticella";
	loadModalWindow();
	form.submit();
}


function filtraRigheTecnici() {
	  // Declare variables
	  var table = document.getElementById("tableGruppoIspettivoTecnici");
	  var input1 = document.getElementById("myInputQualificaTecnici");
	  var input2 = document.getElementById("myInputComponenteTecnici");
	  
	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter1 = input1.value.toUpperCase();
	  filter2 = input2.value.toUpperCase();

	  tr = table.getElementsByTagName("tr");

	  // Loop through all table rows, and hide those who don't match the search query
	  for (i = 0; i < tr.length; i++) {
	    td0 = tr[i].getElementsByTagName("td")[0];
	    td1 = tr[i].getElementsByTagName("td")[1];
	    td2 = tr[i].getElementsByTagName("td")[2];

	    if (td0) {
	      txtValue0 = td0.textContent || td0.innerText;
	      txtValue1 = td1.textContent || td1.innerText;
	      txtValue2 = td2.textContent || td2.innerText;

	      if (txtValue1.toUpperCase().indexOf(filter1) > -1 && txtValue2.toUpperCase().indexOf(filter2) > -1 ) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
	}



</script>

<form name="aggiungiCU" action="GestioneCampioni.do?command=AddVerbaleParticella&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogoParticella.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" id ="tableGruppoIspettivoTecnici" name="tableGruppoIspettivoTecnici" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="5%"><col width="15%">
<tr><th colspan="3"><center><b>TECNICI DEL CAMPIONAMENTO</b></center></th></tr>

<tr>
<th></th>
<th>Qualifica</th>
<th>Componente</th>
</tr>

<tr>
<th></th>
<th><input type="text" id="myInputQualificaTecnici" onkeyup="filtraRigheTecnici()" placeholder="FILTRA QUALIFICA" style="width: 100%"></th>
<th><input type="text" id="myInputComponenteTecnici" onkeyup="filtraRigheTecnici()" placeholder="FILTRA COMPONENTE" style="width: 100%"></th>
</tr>

<% 
for (int i = 0; i<ListaComponentiTecnici.size(); i++) {
Componente comp = (Componente) ListaComponentiTecnici.get(i); %>

<tr>
<td>
<input type="checkbox" id ="<%= comp.getId()%>" name="componenteTecnicoId" value="<%= comp.getId()%>" />
<input type="hidden" readonly id ="componenteTecnicoNome_<%= comp.getId()%>" name ="componenteTecnicoNome_<%= comp.getId()%>" value="<%= comp.getNominativo() %>"/>
<input type="hidden" readonly id ="componenteTecnicoQualifica_<%= comp.getId()%>" name ="componenteTecnicoQualifica_<%= comp.getId()%>" value="<%= comp.getNomeQualifica() %>"/>
</td>
<td><%= comp.getNomeQualifica() %></td>
<td><%= comp.getNominativo() %></td>
</tr>
<% } %>

</table>
	

<br/>

<table class="details" id ="tableGruppoIspettivoAddetti" name="tableGruppoIspettivoAddetti" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="5%"><col width="15%">
<tr><th colspan="3"><center><b>ADDETTI AL CAMPIONAMENTO</b></center></th></tr>

<tr><td></td><td>ARPAC MULTISERVIZI</td><td><input type="text" id="componenteAddettoNome1" name="componenteAddettoNome1" placeholder="Nome" size="30"/> <input type="text" id="componenteAddettoCognome1" name="componenteAddettoCognome1" placeholder="Cognome" size="30"/></td></tr>
<tr><td></td><td>ARPAC MULTISERVIZI</td><td><input type="text" id="componenteAddettoNome2" name="componenteAddettoNome2" placeholder="Nome" size="30"/> <input type="text" id="componenteAddettoCognome2" name="componenteAddettoCognome2" placeholder="Cognome" size="30"/></td></tr>
<tr><td></td><td>ARPAC MULTISERVIZI</td><td><input type="text" id="componenteAddettoNome3" name="componenteAddettoNome3" placeholder="Nome" size="30"/> <input type="text" id="componenteAddettoCognome3" name="componenteAddettoCognome3" placeholder="Cognome" size="30"/></td></tr>

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