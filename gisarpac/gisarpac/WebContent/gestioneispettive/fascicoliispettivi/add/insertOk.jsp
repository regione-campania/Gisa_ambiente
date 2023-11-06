<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonFascicoloIspettivo" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="FascicoloIspettivo" class="org.aspcfs.modules.gestioneispettive.base.FascicoloIspettivo" scope="request"/> 

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
function redirectDettaglioFascicolo(idFascicoloIspettivo){
	loadModalWindow();
	window.location.href="GestioneFascicoliIspettivi.do?command=View&idFascicoloIspettivo="+idFascicoloIspettivo;
}

function backForm(form){
	form.action="GestioneFascicoliIspettivi.do?command=AddRiepilogo";
	loadModalWindow();
	form.submit();
}

function retryInsert(form){
		form.action="GestioneFascicoliIspettivi.do?command=Insert";
		loadModalWindow();
		form.submit();
}
	
</script>

<form name="aggiungiFascicolo" action="" onSubmit="" method="post">

<center>

<% if (FascicoloIspettivo.getIdFascicoloIspettivo()>0) { %>
<font color="green" size="5px">Inserimento del fascicolo ispettivo eseguito con successo.</font>
<% } else { %>
<font color="red" size="5px">Inserimento del fascicolo ispettio fallito.</font>
<br/><br/>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><br/><br/>
<input type="button" value="INDIETRO" onclick="backForm(this.form)" style="font-size:40px; background-color:red"/>

<% if (FascicoloIspettivo.getIdFascicoloIspettivo()<=0){ %>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" style="font-size:40px" value="RIPROVA" onclick="retryInsert(this.form)"/>
<%} %>

</td>
</tr>
</table>
<!-- BOTTONI -->
<%} %>

</center>

<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonFascicoloIspettivo" name="jsonFascicoloIspettivo" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonFascicoloIspettivo%></textarea>
<!--JSON -->

</form>

<script>
function prettyPrint() {
    var ugly = document.getElementById('jsonFascicoloIspettivo').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonFascicoloIspettivo').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonFascicoloIspettivo").get(0).scrollHeight;
$("#jsonFascicoloIspettivo").css('height', scroll_height + 'px');
</script>


<% if (FascicoloIspettivo.getIdFascicoloIspettivo()>0) { %>
<script>
alert("Inserimento del fascicolo ispettivo eseguito con successo.");
redirectDettaglioFascicolo(<%=FascicoloIspettivo.getIdFascicoloIspettivo()%>);
</script>
<% } %>


