<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonGiornataIspettiva" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaEmissioniAtmosferaCamini" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
function checkForm(form){
	var msg = "";
	var esito = true;
	
	var almenoUnaEmissione = false;
	var almenoUnRecordSelezionatoVuoto = false;
	
	var x = document.getElementsByName("emissioneAtmosferaCaminoId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnaEmissione = true;
			if (document.getElementById("emissioneAtmosferaCaminoCodiceCamino_"+x[i].id).value.trim()==''
					|| document.getElementById("emissioneAtmosferaCaminoFasiLavorativa_"+x[i].id).value.trim()==''
						|| document.getElementById("emissioneAtmosferaCaminoInquinanti_"+x[i].id).value.trim()==''
							|| document.getElementById("emissioneAtmosferaCaminoSistemaAbbattimento_"+x[i].id).value.trim()==''
								|| document.getElementById("emissioneAtmosferaCaminoDataSopralluogo2016_"+x[i].id).value.trim()==''
									|| document.getElementById("emissioneAtmosferaCaminoParametriAnalizzati_"+x[i].id).value.trim()==''
										|| document.getElementById("emissioneAtmosferaCaminoSuperamentiLimitiNormativi_"+x[i].id).value.trim()=='') {
				almenoUnRecordSelezionatoVuoto = true;
			}
			
		}
	}
	
	if (!almenoUnaEmissione){
		msg +="Selezionare almeno un'emissione.\n";
		esito = false;
	}
	
	if (almenoUnRecordSelezionatoVuoto){
		msg +="Compilare tutta la riga per le emissioni selezionate..\n";
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
	form.action="GestioneGiornateIspettive.do?command=AddMatrice";
	loadModalWindow();
	form.submit();
}


function filtraRighe() {
	  // Declare variables
	  var table = document.getElementById("tableEmissioniAtmosferaCamini");
	  var input1 = document.getElementById("myInputCodiceCamino");
	  var input2 = document.getElementById("myInputFasiLavorativa");
	  var input3 = document.getElementById("myInputInquinanti");
	  var input4 = document.getElementById("myInputSistemaAbbattimento");
	 
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

<form name="aggiungiCU" action="GestioneGiornateIspettive.do?command=AddGruppoIspettivo&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" id ="tableEmissioniAtmosferaCamini" name="tableEmissioniAtmosferaCamini" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<tr><th colspan="10"><center><b>EMISSIONI ATMOSFERA CAMINI</b></center></th></tr>


<tr>
<th>Seleziona</th>
<th>CODICE CAMINO</th>
<th>FASI LAVORATIVA</th>
<th>INQUINANTI</th>
<th>SISTEMA ABBATTIMENTO</th>
<th>DATA SOPRALLUOGO</th>
<th>PARAMETRI ANALIZZATI</th>
<th>SUPERAMENTI LIMITI NORMATIVI</th>
<th>NOTE</th>
<th>ESITO CONFORME</th>
</tr>

<tr>
<th></th>
<th><input type="text" id="myInputCodiceCamino" onkeyup="filtraRighe()" placeholder="FILTRA" style="width: 100%"></th>
<th><input type="text" id="myInputFasiLavorativa" onkeyup="filtraRighe()" placeholder="FILTRA" style="width: 100%"></th>
<th><input type="text" id="myInputInquinanti" onkeyup="filtraRighe()" placeholder="FILTRA" style="width: 100%"></th>
<th><input type="text" id="myInputSistemaAbbattimento" onkeyup="filtraRighe()" placeholder="FILTRA" style="width: 100%"></th>
<th></th>
<th></th>
<th></th>
<th></th>
<th></th>
</tr>

<% 
for (int i = 0; i<ListaEmissioniAtmosferaCamini.size(); i++) { 
	EmissioniAtmosferaCamini em = (EmissioniAtmosferaCamini) ListaEmissioniAtmosferaCamini.get(i); %>

<tr>
<td><input type="checkbox" id ="<%= em.getId()%>" name="emissioneAtmosferaCaminoId" value="<%= em.getId()%>"/>

<input type="hidden" readonly id ="emissioneAtmosferaCaminoCodiceCamino_<%= em.getId()%>" name ="emissioneAtmosferaCaminoCodiceCamino_<%= em.getId()%>" value="<%= em.getCodiceCamino() %>"/>
<input type="hidden" readonly id ="emissioneAtmosferaCaminoFasiLavorativa_<%= em.getId()%>" name ="emissioneAtmosferaCaminoFasiLavorativa_<%= em.getId()%>" value="<%= em.getFasiLavorativa() %>"/>
<input type="hidden" readonly id ="emissioneAtmosferaCaminoInquinanti_<%= em.getId()%>" name ="emissioneAtmosferaCaminoInquinanti_<%= em.getId()%>" value="<%= em.getInquinanti() %>"/>
<input type="hidden" readonly id ="emissioneAtmosferaCaminoSistemaAbbattimento_<%= em.getId()%>" name ="emissioneAtmosferaCaminoSistemaAbbattimento_<%= em.getId()%>" value="<%= em.getSistemaAbbattimento() %>"/>

</td>
<td><%= em.getCodiceCamino() %></td>
<td><%= em.getFasiLavorativa() %></td>
<td><%= em.getInquinanti() %></td>
<td><%= em.getSistemaAbbattimento() %></td>

<td><input type="date" id="emissioneAtmosferaCaminoDataSopralluogo2016_<%= em.getId()%>" name="emissioneAtmosferaCaminoDataSopralluogo2016_<%= em.getId()%>"/></td>
<td><input type="text" id="emissioneAtmosferaCaminoParametriAnalizzati_<%= em.getId()%>" name="emissioneAtmosferaCaminoParametriAnalizzati_<%= em.getId()%>"/></td>
<td><input type="text" id="emissioneAtmosferaCaminoSuperamentiLimitiNormativi_<%= em.getId()%>" name="emissioneAtmosferaCaminoSuperamentiLimitiNormativi_<%= em.getId()%>"/></td>
<td><input type="text" id="emissioneAtmosferaCaminoNote_<%= em.getId()%>" name="emissioneAtmosferaCaminoNote_<%= em.getId()%>"/></td>
<td><input type="checkbox" id="emissioneAtmosferaCaminoEsitoConforme_<%= em.getId()%>" name="emissioneAtmosferaCaminoEsitoConforme_<%= em.getId()%>" value="true"/></td>

</tr>
<% } %>


<% for (int i = -1; i>-10; i--) { %>

<tr>
<td><input type="checkbox" id ="<%=i%>" name="emissioneAtmosferaCaminoId" value="<%=i%>"/></td>
<td><input type="text" id ="emissioneAtmosferaCaminoCodiceCamino_<%= i%>" name ="emissioneAtmosferaCaminoCodiceCamino_<%= i%>" value=""/></td>
<td><input type="text" id ="emissioneAtmosferaCaminoFasiLavorativa_<%= i%>" name ="emissioneAtmosferaCaminoFasiLavorativa_<%= i%>" value=""/></td>
<td><input type="text" id ="emissioneAtmosferaCaminoInquinanti_<%= i%>" name ="emissioneAtmosferaCaminoInquinanti_<%= i%>" value=""/></td>
<td><input type="text" id ="emissioneAtmosferaCaminoSistemaAbbattimento_<%= i%>" name ="emissioneAtmosferaCaminoSistemaAbbattimento_<%= i%>" value=""/></td>
<td><input type="date" id="emissioneAtmosferaCaminoDataSopralluogo2016_<%= i%>" name="emissioneAtmosferaCaminoDataSopralluogo2016_<%= i%>"/></td>
<td><input type="text" id="emissioneAtmosferaCaminoParametriAnalizzati_<%= i%>" name="emissioneAtmosferaCaminoParametriAnalizzati_<%= i%>"/></td>
<td><input type="text" id="emissioneAtmosferaCaminoSuperamentiLimitiNormativi_<%= i%>" name="emissioneAtmosferaCaminoSuperamentiLimitiNormativi_<%= i%>"/></td>
<td><input type="text" id="emissioneAtmosferaCaminoNote_<%= i%>" name="emissioneAtmosferaCaminoNote_<%= i%>"/></td>
<td><input type="checkbox" id="emissioneAtmosferaCaminoEsitoConforme_<%= i%>" name="emissioneAtmosferaCaminoEsitoConforme_<%= i%>" value="true"/></td>

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
