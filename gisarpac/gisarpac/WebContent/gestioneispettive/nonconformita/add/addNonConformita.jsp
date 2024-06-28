<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonNonConformita" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="jsonGiornataIspettiva" class="org.json.JSONObject" scope="request"/>


<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
function checkForm(form){
	
	var esito = true;
	var msg = '';
		
	var almenoUnRadio = false;
	var radios = document.getElementsByName("tipoVerificaId");
    for (var i = 0, len = radios.length; i < len; i++) {
         if (radios[i].checked) {
        	 almenoUnRadio = true;
          }
     }
	
	if (!almenoUnRadio){
		msg+= "Selezionare il tipo di verifica.\n";
		esito = false;
	}
	
	almenoUnRadio = false;
	radios = document.getElementsByName("lineaId");
    for (var i = 0, len = radios.length; i < len; i++) {
         if (radios[i].checked) {
        	 almenoUnRadio = true;
          }
     }
	
	if (!almenoUnRadio){
		msg+= "Selezionare il codice IPPC.\n";
		esito = false;
	}
	
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.submit();
}


</script>

<form name="aggiungiNonConformita" action="GestioneNonConformita.do?command=AddRiepilogo&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" cellpadding="10" cellspacing="10" width="100%" id="tableCampione">
<col width="20%">
<tr><th colspan="2"><center><b>DATI NON CONFORMITA</b></center></th></tr>

<tr><td class="formLabel">Tipo verifica</td>
<td>

<% JSONArray jsonTipiVerifica = (JSONArray) jsonGiornataIspettiva.get("TipiVerifica");
for (int i = 0; i<jsonTipiVerifica.length(); i++) {
	JSONObject jsonTipoVerifica = (JSONObject) jsonTipiVerifica.get(i); %>

<input type="radio" id="tipoVerificaId_<%=jsonTipoVerifica.get("id") %>" name="tipoVerificaId" value="<%=jsonTipoVerifica.get("id") %>"> 
<input type="hidden" id="tipoVerificaNome_<%=jsonTipoVerifica.get("id") %>" name="tipoVerificaNome_<%=jsonTipoVerifica.get("id") %>" value="<%=jsonTipoVerifica.get("nome") %>">
<%=jsonTipoVerifica.get("nome") %><br/>

<%}%>

</td></tr>

<tr><td class="formLabel">Codice IPPC</td>

<td>
<% JSONArray jsonLinee = (JSONArray) jsonGiornataIspettiva.get("Linee");
for (int i = 0; i<jsonLinee.length(); i++) {
	JSONObject jsonLinea = (JSONObject) jsonLinee.get(i); %>

<input type="radio" id="lineaId_<%=jsonLinea.get("id") %>" name="lineaId" value="<%=jsonLinea.get("id") %>"> 
<input type="hidden" id="lineaNome_<%=jsonLinea.get("id") %>" name="lineaNome_<%=jsonLinea.get("id") %>" value="<%=jsonLinea.get("nome") %>">
<%=jsonLinea.get("nome") %><br/>

<%}%>

</td></tr>

<tr><td class="formLabel">Descrizione N.C. </td><td><textarea id="note" name="note" cols="50" rows="5" placeholder="Descrizione N.C."></textarea></td></tr>

</table>



<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr><td colspan="2" align="center"><br/><br/>
<input type="button" style="font-size:40px" value="PROSEGUI" onclick="checkForm(this.form)"/></td></tr>
</table>
<!-- BOTTONI -->

</center>

<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonNonConformita" name="jsonNonConformita" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonNonConformita%></textarea>
<!--JSON -->

</form>

<script>
function prettyPrint() {
    var ugly = document.getElementById('jsonNonConformita').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonNonConformita').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonNonConformita").get(0).scrollHeight;
$("#jsonNonConformita").css('height', scroll_height + 'px');
</script>
