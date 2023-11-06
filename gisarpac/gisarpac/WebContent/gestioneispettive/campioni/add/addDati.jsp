<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
function checkForm(form){
	
	var esito = true;
	var msg = '';
	
	if (form.dataPrelievo.value==""){
		msg +="Selezionare la data prelievo.\n";
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

<form name="aggiungiCampione" action="GestioneCampioni.do?command=AddTipoAttivita&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" cellpadding="10" cellspacing="10" width="100%" id="tableCampione">
<col width="20%">
<tr><th colspan="2"><center><b>DATI CAMPIONE</b></center></th></tr>

<tr><td class="formLabel">Numero verbale</td>
<td>
<input type="radio" checked onClick="return false()" id="numeroVerbaleId" name="numeroVerbale" value="AUTOMATICO"/> AUTOMATICO
</td>
</tr>


<tr><td class="formLabel">Data prelievo</td>
<td><input type="date" id="dataPrelievo" name="dataPrelievo" /></td>
<script>document.getElementById("dataPrelievo").max = new Date().toISOString().split("T")[0];</script>
</tr>


<tr><td class="formLabel">Note</td>
<td>
<input type="text" id="note" name="note"size="50"/>
</td></tr>

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
