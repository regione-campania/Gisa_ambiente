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
function checkForm(form){
	loadModalWindow();
	form.submit();
}

function backForm(form){
	form.action="GestioneGiornateIspettive.do?command=AddTipoVerifica";
	loadModalWindow();
	form.submit();
}
	
</script>

<form name="aggiungiCU" action="GestioneGiornateIspettive.do?command=Insert&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">




<input type="hidden" id="tecnica" name="tecnica" value=<%=request.getAttribute("tecnica")%>>
</table>



<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><br/><br/>
<input type="button" value="INDIETRO" onclick="backForm(this.form)" style="font-size:40px; background-color:red"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" style="font-size:40px" value="INSERISCI GIORNATA ISPETTIVA" onclick="checkForm(this.form)"/>
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