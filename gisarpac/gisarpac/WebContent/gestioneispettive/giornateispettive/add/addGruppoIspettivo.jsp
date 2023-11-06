<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonGiornataIspettiva" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaComponenti" class="java.util.ArrayList" scope="request"/>


<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
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

function gestisciResponsabile(cb){
	
	var idComponente = cb.value;
	
	if (!cb.checked) {
		document.getElementById("componenteReferente_"+idComponente).disabled=true;
		document.getElementById("componenteResponsabile_"+idComponente).disabled=true;
		document.getElementById("componenteReferente_"+idComponente).checked=false;
		document.getElementById("componenteResponsabile_"+idComponente).checked=false;
	} else {
		document.getElementById("componenteReferente_"+idComponente).disabled=false;
		document.getElementById("componenteResponsabile_"+idComponente).disabled=false;
	}
	
}

function checkForm(form){ 
	var msg = "";
	var esito = true;
	var almenoUnComponente = false;
	
	var x = document.getElementsByName("componenteId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnComponente = true;
		}
	}
	
	if (!almenoUnComponente){
		msg +="Selezionare almeno un componente del gruppo ispettivo.\n"; 
		esito = false;
	}

	var almenoUnReferente = false;
	
	var ref = form.getElementsByTagName("input");
	for(var i = 0; i < ref.length; i++) {
	    if(ref[i].type == "checkbox" && ref[i].id.includes("componenteReferente")) {
	    	if (ref[i].checked){
				almenoUnReferente = true;
			}
	    }  
	}
	
	if (!almenoUnReferente){
		msg +="Indicare un componente come Incaricato di Funzione.\n";
		esito = false;
	}
	
	var almenoUnResponsabile = false;
	
	var resp = form.getElementsByTagName("input");
	for(var i = 0; i < resp.length; i++) {
	    if(resp[i].type == "checkbox" && resp[i].id.includes("componenteResponsabile")) {
	    	if (resp[i].checked){
				almenoUnResponsabile = true;
			}
	    }  
	}
	
	if (!almenoUnResponsabile){
		msg +="Indicare un componente come Responsabile Procedimento.\n";
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
	
	
		<% 
		boolean hasMatriceEmissioneAtmosfera = false;

		if ( ((JSONObject) jsonGiornataIspettiva).has("Matrici")) { 
		JSONArray jsonMatrici = (JSONArray) jsonGiornataIspettiva.get("Matrici");
		if (jsonMatrici.length()>0) {
			for (int i = 0; i<jsonMatrici.length(); i++) {
				JSONObject jsonMatrice = (JSONObject) jsonMatrici.get(i);
				if (jsonMatrice.get("nome").toString().equalsIgnoreCase("Emissione in atmosfera convogliate"))
					hasMatriceEmissioneAtmosfera = true;
			} } } %>
	
		<% if (hasMatriceEmissioneAtmosfera) {%>
			form.action="GestioneGiornateIspettive.do?command=AddEmissioniAtmosferaCamini";
		<% } else  { %>
			form.action="GestioneGiornateIspettive.do?command=AddMatrice";
		<% } %>
	
	loadModalWindow();
	form.submit();
}

function filtraRighe() {
	  // Declare variables
	  var table = document.getElementById("tableGruppoIspettivo");
	  var input1 = document.getElementById("myInputQualifica");
	  var input2 = document.getElementById("myInputComponente");
	  var input3 = document.getElementById("myInputStruttura");
	  
	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter1 = input1.value.toUpperCase();
	  filter2 = input2.value.toUpperCase();
	  filter3 = input3.value.toUpperCase();

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

	      if (txtValue1.toUpperCase().indexOf(filter1) > -1 && txtValue2.toUpperCase().indexOf(filter2) > -1 && txtValue3.toUpperCase().indexOf(filter3) > -1) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
	}

</script>

<form name="aggiungiCU" action="GestioneGiornateIspettive.do?command=AddMotivo&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" id ="tableGruppoIspettivo" name="tableGruppoIspettivo" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="5%"><col width="10%"><col width="20%"><col width="45%"><col width="5%"><col width="5%">
<tr><th colspan="6"><center><b>GRUPPO ISPETTIVO</b></center></th></tr>

<tr>
<th></th>
<th>Qualifica</th>
<th>Componente</th>
<th>Struttura</th>
<th>Incaricato di Funzione</th>
<th>Responsabile procedimento</th>

</tr>

<tr>
<th></th>
<th><input type="text" id="myInputQualifica" onkeyup="filtraRighe()" placeholder="FILTRA QUALIFICA" style="width: 100%"></th>
<th><input type="text" id="myInputComponente" onkeyup="filtraRighe()" placeholder="FILTRA COMPONENTE" style="width: 100%"></th>
<th><input type="text" id="myInputStruttura" onkeyup="filtraRighe()" placeholder="FILTRA STRUTTURA" style="width: 100%"></th>
<th></th>
<th></th>
</tr>

<% 
for (int i = 0; i<ListaComponenti.size(); i++) {
Componente comp = (Componente) ListaComponenti.get(i); %>

<tr>
<td>
<input type="checkbox" id ="<%= comp.getId()%>" name="componenteId" value="<%= comp.getId()%>" onClick="gestisciResponsabile(this)"/>
<input type="hidden" readonly id ="componenteNome_<%= comp.getId()%>" name ="componenteNome_<%= comp.getId()%>" value="<%= comp.getNominativo() %>"/>
<input type="hidden" readonly id ="componenteQualifica_<%= comp.getId()%>" name ="componenteQualifica_<%= comp.getId()%>" value="<%= comp.getNomeQualifica() %>"/>
<input type="hidden" readonly id ="componenteStruttura_<%= comp.getId()%>" name ="componenteStruttura_<%= comp.getId()%>" value="<%= comp.getNomeStruttura() %>"/>
<input type="hidden" readonly id ="componenteStrutturaId_<%= comp.getId()%>" name ="componenteStrutturaId_<%= comp.getId()%>" value="<%= comp.getIdStruttura() %>"/>

</td>
<td><%= comp.getNomeQualifica() %></td>
<td><%= comp.getNominativo() %></td>
<td><%= comp.getNomeStruttura() %></td>
<td><input type="checkbox" disabled id ="componenteReferente_<%= comp.getId()%>" name="componenteReferente_<%= comp.getId()%>" value="true" onClick="svuotaAltri(this)"/></td>
<td><input type="checkbox"  disabled id ="componenteResponsabile_<%= comp.getId()%>" name="componenteResponsabile_<%= comp.getId()%>" value="true" onClick="svuotaAltri(this)"/></td>
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
</script>