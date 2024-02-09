<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonGiornataIspettiva" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaTipiVerifica" class="java.util.ArrayList" scope="request"/>

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
	
	var almenoUnTipoVerifica = false;

	var x = document.getElementsByName("tipoVerificaId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnTipoVerifica = true;
			
		}
	}
	
	if (!almenoUnTipoVerifica){
		msg +="Selezionare almeno un tipo di verifica di ispezione.\n";
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
	form.action="GestioneGiornateIspettive.do?command=AddEsame";
	loadModalWindow();
	form.submit();
}


function filtraRighe() {
	
	  // Declare variables
	  var table = document.getElementById("tableTipiVerifica");
	  var input1 = document.getElementById("myInputTipoVerifica");

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

<form name="aggiungiCU" action="GestioneGiornateIspettive.do?command=AddRiepilogo&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" id ="tableTipiVerifica" name="tableTipiVerifica" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="5%">
<tr><th colspan="2"><center><b>TIPO VERIFICA</b></center></th></tr>

<tr>
<th>Seleziona</th>
<th>Tipo verifica</th>
</tr>

<tr>
<th></th>
<th><input type="text" id="myInputTipoVerifica" onkeyup="filtraRighe()" placeholder="FILTRA TIPO VERIFICA" style="width: 100%"></th>
</tr>

<% 
for (int i = 0; i<ListaTipiVerifica.size(); i++) {
TipoVerifica tipoVerifica = (TipoVerifica) ListaTipiVerifica.get(i); %>

<tr>
<td>
<input type="checkbox" id ="<%= tipoVerifica.getCode()%>" name="tipoVerificaId" value="<%= tipoVerifica.getCode()%>" <%=!tipoVerifica.isGestione_altro() ? "checked=\"checked\" onClick=\"return false\"" : "" %>/>
<input type="hidden" readonly id ="tipoVerificaNome_<%= tipoVerifica.getCode()%>" name ="tipoVerificaNome_<%= tipoVerifica.getCode()%>" value="<%= tipoVerifica.getTipoVerifica() %>"/>
</td>
<td><%= tipoVerifica.getTipoVerifica() %></td>
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
	<% if ( ((JSONObject) jsonGiornataIspettiva).has("TipiVerifica")) { %>
<% JSONArray jsonTipiVerifica = (JSONArray) jsonGiornataIspettiva.get("TipiVerifica");
for (int i = 0; i < jsonTipiVerifica.length(); i++) {
JSONObject jsonObject = jsonTipiVerifica.getJSONObject(i);
%>
document.getElementById("<%=jsonObject.get("id")%>").setAttribute("checked","true")




<%}}%>
}
reloadDati();
</script>