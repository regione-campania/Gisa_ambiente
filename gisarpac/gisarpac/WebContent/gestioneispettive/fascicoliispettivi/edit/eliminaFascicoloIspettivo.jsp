<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonFascicoloIspettivo" class="org.json.JSONObject" scope="request"/>

<jsp:useBean id="idFascicoloIspettivo" class="java.lang.String" scope="request"/>
<jsp:useBean id="riferimentoId" class="java.lang.String" scope="request"/>
<jsp:useBean id="riferimentoIdNomeTab" class="java.lang.String" scope="request"/>

<jsp:useBean id="Messaggio" class="java.lang.String" scope="request"/>

<%@ page import="org.aspcfs.utils.web.*"%>
<%@ page import="org.json.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<%
if (Messaggio!=null && !Messaggio.equals("")){%>
<script>
alert("<%=Messaggio%>");
</script>

<% if (Messaggio.startsWith("OK")) {%>
<script>
loadModalWindow();
window.location.href="StabilimentoAIA.do?command=Details&stabId=<%=((JSONObject) jsonFascicoloIspettivo.get("Anagrafica")).get("riferimentoId")%>";
</script>

<%} }%>


<%! public static String fixData(Object objData)
  {
	  String toRet = "";
	  if (objData == null || objData.equals(""))
		  return toRet;
	  String data = objData.toString();
	  String anno = data.substring(0,4);
	  String mese = data.substring(5,7);
	  String giorno = data.substring(8,10);
	  toRet =giorno+"/"+mese+"/"+anno;
	  return toRet;
	  
  }%>
  
<script>


function annulla() {
	if (confirm("Annullare l'operazione?")) {	
		loadModalWindow();
		window.location.href="GestioneFascicoliIspettivi.do?command=View&idFascicoloIspettivo=<%=idFascicoloIspettivo%>";
	}
}




</script>

<!-- RIEPILOGO -->
<form name="eliminazioneFascicolo" action="GestioneFascicoliIspettivi.do?command=Delete&auto-populate=true" onSubmit="" method="post">

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Dettaglio FASCICOLO ISPETTIVO</b></center></th></tr>
<% if ( ((JSONObject) jsonFascicoloIspettivo).has("Dati")) { %>
<% JSONObject jsonDati = (JSONObject) jsonFascicoloIspettivo.get("Dati");
if (jsonDati.length()>0) {%>
<tr>
	<td class="formLabel">Numero</td><td><%=jsonDati.get("numero")%></td>
</tr>
<tr>
	<td class="formLabel">Data inizio </td><td><%=fixData(jsonDati.get("dataInizio"))%></td>
	<input type="hidden" id="dataconf" value="<%=jsonDati.get("dataInizio")%>"/>
</tr>

<%} } %>
<% if ( ((JSONObject) jsonFascicoloIspettivo).has("CampiServizio")) { %>
<% JSONObject jsonCampiServizio = (JSONObject) jsonFascicoloIspettivo.get("CampiServizio");
if (jsonCampiServizio.length()>0) {%>
<tr><td class="formLabel">Id fascicolo ispettivo</td><td><%=jsonCampiServizio.get("idFascicoloIspettivo")%></td></tr>
<%} } %>
</table>
<!-- RIEPILOGO -->


<table class="details" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="50%">
<tr><th colspan="2">Eliminazione Fascicolo Ispettivo</th></tr>
<tr><td CLASS="formLabel">NOTE</td> <td><textarea id="noteEliminazione" name="noteEliminazione" rows="3" cols="70"></textarea></td></tr>
</table>

<br/>

<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><br/><br/>
<input type="button" value="ANNULLA" onclick="annulla()" style="font-size:40px; background-color:red"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" style="font-size:40px" value="CONFERMA" onclick="checkForm(this.form)"/>
</td>
</tr>
</table>
<!-- BOTTONI -->

<br/>

<input type="hidden" id="idFascicoloIspettivo" name="idFascicoloIspettivo" value="<%=idFascicoloIspettivo%>"/>
</form>

<br/><br/>


<script>

function checkForm(form){
	
	if (form.noteEliminazione.value==''){
		alert('Indicare le note.');
		return false;
	}
	
	if (confirm("Eseguire la cancellazione del fascicolo ispettivo?")) {	
		loadModalWindow();
		form.submit();
	}
   }
</script>

