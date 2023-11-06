<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="Campione" class="org.aspcfs.modules.gestioneispettive.base.Campione" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
function redirectDettaglioCampione(idCampione){
	loadModalWindow();
	window.location.href="GestioneCampioni.do?command=View&idCampione="+idCampione;
}

function backForm(form){
	form.action="GestioneCampioni.do?command=AddRiepilogo";
	loadModalWindow();
	form.submit();
}

function retryInsert(form){
		form.action="GestioneCampioni.do?command=Insert";
		loadModalWindow();
		form.submit();
}
	
</script>

<form name="aggiungiCampione" action="" onSubmit="" method="post">

<center>

<% if (Campione.getIdCampione()>0) { %>
<font color="green" size="5px">Inserimento del campione eseguito con successo.</font>
<% } else { %>
<font color="red" size="5px">Inserimento del campione fallito.</font>
<br/><br/>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><br/><br/>
<input type="button" value="INDIETRO" onclick="backForm(this.form)" style="font-size:40px; background-color:red"/>

<% if (Campione.getIdCampione()<=0){ %>
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
<textarea rows="10" cols="200" readonly id="jsonCampione" name="jsonCampione" style="display:none"><%=jsonCampione%></textarea>
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


<% if (Campione.getIdCampione()>0) { %>
<script>
alert("Inserimento del campione eseguito con successo.");
redirectDettaglioCampione(<%=Campione.getIdCampione()%>);
</script>
<% } %>


