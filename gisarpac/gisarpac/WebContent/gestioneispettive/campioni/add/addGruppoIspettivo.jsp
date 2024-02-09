<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaComponenti" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>

function backForm(form){
	form.action="GestioneCampioni.do?command=AddLaboratorio";
	loadModalWindow();
	form.submit();
}


function checkForm(form){
	
	var esito = true;
	var msg = '';
	
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
	
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.submit();
}


</script>

<form name="aggiungiCampione" action="GestioneCampioni.do?command=AddRiepilogo&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" cellpadding="10" cellspacing="10" width="100%" id="tableCampione">
<col width="20%">
<tr><th colspan="2"><center><b>GRUPPO ISPETTIVO</b></center></th></tr>

<tr><td class="formLabel">Gruppo Ispettivo</td>
<td>

<% 
for (int i = 0; i<ListaComponenti.size(); i++) {
Componente comp = (Componente) ListaComponenti.get(i); %>

<input type="checkbox" id ="<%= comp.getId()%>" name="componenteId" value="<%= comp.getId()%>"/>
<input type="hidden" readonly id ="componenteNome_<%= comp.getId()%>" name ="componenteNome_<%= comp.getId()%>" value="<%= comp.getNominativo() %>"/>
<input type="hidden" readonly id ="componenteQualifica_<%= comp.getId()%>" name ="componenteQualifica_<%= comp.getId()%>" value="<%= comp.getNomeQualifica() %>"/>
<input type="hidden" readonly id ="componenteStruttura_<%= comp.getId()%>" name ="componenteStruttura_<%= comp.getId()%>" value="<%= comp.getNomeStruttura() %>"/>
<input type="hidden" readonly id ="componenteStrutturaId_<%= comp.getId()%>" name ="componenteStrutturaId_<%= comp.getId()%>" value="<%= comp.getIdStruttura() %>"/>
<%= comp.getNominativo() %> (<b><%= comp.getNomeQualifica() %></b>) <%= comp.getNomeStruttura() %><br/><br/> 
<% } %>

</td></tr>


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
