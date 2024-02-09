<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonGiornataIspettiva" class="org.json.JSONObject" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>


function backForm(form){
		form.action="GestioneGiornateIspettive.do?command=AddTecnica";


	loadModalWindow();
	form.submit();
}

</script>

<form name="aggiungiCU" action="GestioneGiornateIspettive.do?command=AddPerContoDi&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">
<tr><th colspan="2"><center><b>DATI</b></center></th></tr>
<% if ( ((JSONObject) jsonGiornataIspettiva).has("FascicoloIspettivo")) { %>
<% JSONObject jsonDati = (JSONObject) jsonGiornataIspettiva.get("FascicoloIspettivo");
if (jsonDati.length()>0) {%>
<td hidden id="datafascicolo"><%=jsonDati.get("dataInizio")%></td></tr>
<%} } %>
<tr><td class="formLabel">Data inizio </td><td><input type="date" id="dataInizio" name="dataInizio" /></td></tr>
<script>document.getElementById("dataInizio").max = new Date().toISOString().split("T")[0];</script>
<tr><td class="formLabel">Ora inizio </td><td><input type="time" id="oraInizio" name="oraInizio" /></td></tr>
<tr><td class="formLabel">Data fine </td><td><input type="date" id="dataFine" name="dataFine" /></td></tr>
<script>document.getElementById("dataFine").max = new Date().toISOString().split("T")[0];</script>
<tr><td class="formLabel">Ora fine </td><td><input type="time" id="oraFine" name="oraFine" /></td></tr>
<tr><td class="formLabel">Note </td><td><textarea id="note" name="note" cols="50" rows="5" placeholder="NOTE"></textarea></td></tr>




<input type="hidden" id="tecnica" name="tecnica" value=<%=request.getAttribute("tecnica")%>>
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
function checkForm(form){
	var msg = "";
	var esito = true;
	let dataFascicolo= document.getElementById("datafascicolo").innerText.substring(0,10);
	let dataInizio = form.dataInizio.value.toString();
	
	let oraInizio = form.oraInizio.value;
	let oraFine = form.oraFine.value;
	
	

	
	if(dataInizio<dataFascicolo && dataInizio!='')
	{
		msg +="La data di inizio non puo' essere antecedente alla data dell'apertura del fascicolo.\n";
		esito = false;
	}
	if (form.dataInizio.value==""){
		msg +="Selezionare la data inizio.\n";
		esito = false;	
	}
	
	
	if (form.dataInizio.value>form.dataFine.value && form.dataFine.value!=''){
		msg +="La data fine non puo' essere antecedente alla data inizio.\n";
		esito = false;	
	}else if(oraInizio>oraFine && form.dataInizio.value==form.dataFine.value)
		{
		msg +="L'ora fine non puo' essere antecedente all'ora inizio nello stesso giorno.\n";
		esito = false;	
		}
	
	if (form.oraInizio.value==""){
		msg +="Selezionare l'ora inizio.\n";
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
    var ugly = document.getElementById('jsonGiornataIspettiva').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonGiornataIspettiva').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonGiornataIspettiva").get(0).scrollHeight;
$("#jsonGiornataIspettiva").css('height', scroll_height + 'px');

function reloadDati(){
<% if ( ((JSONObject) jsonGiornataIspettiva).has("Dati")) { %>
<% JSONObject jsonDati1 = (JSONObject) jsonGiornataIspettiva.get("Dati"); %>
document.getElementById("dataInizio").value='<%=jsonDati1.get("dataInizio")%>'
	document.getElementById("oraInizio").value='<%=jsonDati1.get("oraInizio")%>'
	document.getElementById("dataFine").value='<%=jsonDati1.get("dataFine")%>'
	document.getElementById("oraFine").value='<%=jsonDati1.get("oraFine")%>'
	document.getElementById("note").value='<%=jsonDati1.get("note")%>'<%}%>
}
reloadDati();
</script>

