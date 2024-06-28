<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaMatrici" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>


function backForm(form){
	form.action="GestioneCampioni.do?command=AddMotivoParticella";
	loadModalWindow();
	form.submit();
}
function gestisciNumeroVerbaleAutomatico(cb){
	if (cb.checked){
		document.getElementById("numeroVerbale").readonly = true;
		document.getElementById("numeroVerbale").value = "AUTOMATICO";
	} else {
		document.getElementById("numeroVerbale").readonly = false;
		document.getElementById("numeroVerbale").value = "";
	}
}

function filtraRigheMatrici() {
	
	  // Declare variables
	  var table = document.getElementById("tableMatrici");
	  var input1 = document.getElementById("myInputMatrice");

	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter1 = input1.value.toUpperCase();
	  
	  tr = table.getElementsByTagName("tr");

	  // Loop through all table rows, and hide those who don't match the search query
	  for (i = 0; i < tr.length; i++) {
	    td0 = tr[i].getElementsByTagName("td")[0];
	    td1 = tr[i].getElementsByTagName("td")[1];
	    
	    if (td0) {
	      txtValue0 = td0.textContent || td0.innerText;
	      txtValue1 = td1.textContent || td1.innerText;
	      
	      if (txtValue1.toUpperCase().indexOf(filter1) > -1 ) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
	}


</script>

<form name="aggiungiCU" action="GestioneCampioni.do?command=AddGruppoTecniciAddettiParticella&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogoParticella.jsp"%>
<!-- RIEPILOGO -->

<br/>

<table class="details" id ="tableMatrici" name="tableMatrici" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="5%">
<tr><th colspan="2"><center><b>MATRICE</b></center></th></tr>

<tr>
<th>Seleziona</th>
<th>Matrice</th>
</tr>

<tr>
<th></th>
<th><input type="text" id="myInputMatrice" onkeyup="filtraRigheMatrici()" placeholder="FILTRA MATRICE" style="width: 100%"></th>
<th></th>
</tr>

<% 

if (ListaMatrici.size()>0) {
for (int i = 0; i<ListaMatrici.size(); i++) {
Matrice matrice = (Matrice) ListaMatrici.get(i); %>

<tr>

<td>
<input type="radio" id ="<%= matrice.getCode()%>" name="matriceId" value="<%= matrice.getCode()%>" <%=matrice.getMatrice().toLowerCase().contains("acque") ? "disabled" : "checked" %>/>
<input type="hidden" readonly id ="matriceNome_<%= matrice.getCode()%>" name ="matriceNome_<%= matrice.getCode()%>" value="<%= matrice.getMatrice() %>" />
</td>

<td><%= matrice.getMatrice() %> <%=matrice.getMatrice().toLowerCase().contains("acque") ? "<font color='red'>Non attualmente disponibile</font>" : "" %></td>

</tr>
<% } %>

<%} else { %>
<tr><td colspan="3">MATRICI NON SELEZIONABILI IN QUANTO MANCANTI. PROSEGUIRE.
<input type="hidden" checked readonly id ="-1" name ="matriceId" value="-1"/>
</td></tr>
<%} %>
</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">
<tr><th colspan="2"><center><b>DATI</b></center></th></tr>

<tr><td class="formLabel">Data del prelievo </td><td><input type="date" id="dataPrelievo" name="dataPrelievo" /></td></tr>
<script>document.getElementById("dataPrelievo").max = new Date().toISOString().split("T")[0];</script>
<tr><td class="formLabel">Ora del prelievo </td><td><input type="time" id="ore" name="ore" /></td></tr>
<tr><td class="formLabel">Numero Verbale</td><td><input type="text" id="numeroVerbale" name="numeroVerbale" value="" /> (<input type="checkbox" onClick="gestisciNumeroVerbaleAutomatico(this)" id="numeroVerbaleAutomatico" name="numeroVerbaleAutomatico" value="AUTOMATICO"/> AUTOMATICO)</td></tr>

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
function checkForm(form){
	var msg = "";
	var esito = true;
	let dataPrelievo = form.dataPrelievo.value.toString();
	let ore = form.ore.value;
	var numeroVerbale = form.numeroVerbale.value;
	var numeroVerbaleAutomatico = form.numeroVerbaleAutomatico;
	
	if (form.dataPrelievo.value==""){
		msg +="Selezionare la data del prelievo.\n";
		esito = false;	
	}
	if (form.ore.value==""){
		msg +="Selezionare l'ora del prelievo.\n";
		esito = false;	
	} 
	if (!numeroVerbaleAutomatico.checked && numeroVerbale==""){
		msg +="Indicare il numero verbale.\n";
		esito = false;	
	}
	
	var almenoUnaMatrice = false;

	var x = document.getElementsByName("matriceId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnaMatrice = true;
			
		}
	}
	
	if (!almenoUnaMatrice){
		msg +="Selezionare la matrice.\n";
		esito = false;
	}	
	
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.submit();
}


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

