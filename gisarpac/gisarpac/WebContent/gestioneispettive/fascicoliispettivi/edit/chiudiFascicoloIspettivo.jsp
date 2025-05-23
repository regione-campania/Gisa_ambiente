<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.Iterator" %>
<jsp:useBean id="jsonGiornateIspettive" class="org.json.JSONArray" scope="request"/>

<jsp:useBean id="jsonFascicoloIspettivo" class="org.json.JSONObject" scope="request"/>

<jsp:useBean id="idFascicoloIspettivo" class="java.lang.String" scope="request"/>
<jsp:useBean id="riferimentoId" class="java.lang.String" scope="request"/>
<jsp:useBean id="riferimentoIdNomeTab" class="java.lang.String" scope="request"/>
<%@ page import="org.aspcfs.utils.web.*"%>
<%@ page import="org.json.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

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


function openUploadAllegato(idFascicoloIspettivo){
	var res;
	var result;
	window.open('GestioneAllegatiFascicoliIspettivi.do?command=PrepareUploadAllegato&idFascicoloIspettivo='+idFascicoloIspettivo,null,
		'height=450px,width=480px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');

} 

</script>

<!-- RIEPILOGO -->
<form name="chiusuraFascicolo" action="GestioneFascicoliIspettivi.do?command=Close&auto-populate=true" onSubmit="" method="post">

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
<tr><th colspan="2">Chiusura Fascicolo Ispettivo</th></tr>
<tr><td CLASS="formLabel">DATA</td> <td><input type="date" id="dataChiusura" name="dataChiusura" value=""/></td></tr>
<tr><td CLASS="formLabel">ORA</td> <td><input type="time" id="oraChiusura" name="oraChiusura" value=""/></td></tr>
<tr><th colspan="2">Dati relazione allegata al Fascicolo Ispettivo (SICRA)</th></tr>
<tr><td CLASS="formLabel">ANNO PROTOCOLLO</td> <td><input type="text" id="annoProtocolloChiusura" name="annoProtocolloChiusura" value=""/></td></tr>
<tr><td CLASS="formLabel">NUMERO PROTOCOLLO</td> <td><input type="text" id="numeroProtocolloChiusura" name="numeroProtocolloChiusura" value=""/></td></tr>
<tr><th colspan="2">Rapporto di chiusura fascicolo ispettivo</th></tr>
<tr><td class="formLabel">Rapporto</td><td><div id="divAllegato" name="divAllegato"></div><input type="hidden" id="codAllegato" name="codAllegato" value=""/><a href="javascript:openUploadAllegato(<%=idFascicoloIspettivo %>)" id="allega">Allega</a></td></tr> 
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
	let datainizio = document.getElementById("dataconf").value.substring(0,10);
	let datafine = form.dataChiusura.value.toString();
	
	   <%
	   if (jsonGiornateIspettive.length()>0) {
	   	for (int i = 0; i<jsonGiornateIspettive.length(); i++) {
	   	JSONObject jsonGiornataIspettiva = (JSONObject) jsonGiornateIspettive.get(i);
	   	 String dataInizio = jsonGiornataIspettiva.getString("dataInizio");
	   	 String oraInizio = jsonGiornataIspettiva.getString("oraInizio");
	   	String primaParteData = dataInizio.substring(0, 10); 
	   	String dataFine ="";
        if (jsonGiornataIspettiva.has("dataFine") && !jsonGiornataIspettiva.isNull("dataFine"))
        	dataFine = jsonGiornataIspettiva.getString("dataFine");
	   	String oraFine ="";
        if (jsonGiornataIspettiva.has("oraFine") && !jsonGiornataIspettiva.isNull("oraFine"))
        	oraFine = jsonGiornataIspettiva.getString("oraFine");
	   	String primaParteDataFine = "";
	         // Prendi solo i primi 10 caratteri
	         if (jsonGiornataIspettiva.has("dataFine") && !jsonGiornataIspettiva.isNull("dataFine"))
	        primaParteDataFine = dataFine.substring(0, 10); %> // Prendi solo i primi 10 caratteri

	        console.log('<%= primaParteData %>')
	   	 console.log('<%= oraInizio %>')

			if(document.getElementById("dataChiusura").value<'<%= primaParteData %>')
				{
				alert("La data di chiusura fascicolo non puo' essere inferiore alla data inizio giornata ispettiva");
				return false;
				}
	        if(document.getElementById("dataChiusura").value=='<%= primaParteData %>' && document.getElementById("oraChiusura").value<'<%= oraInizio %>')
			{
			alert("L' orario di chiusura fascicolo non puo' essere inferiore all'ora apertura giornata ispettiva");
			return false;
			}
	        
	        
	        <%	    if (jsonGiornataIspettiva.has("dataFine") && !jsonGiornataIspettiva.isNull("dataFine")) { %>
	        if(document.getElementById("dataChiusura").value<'<%= primaParteDataFine %>')
			{
			alert("La data di chiusura fascicolo non puo' essere inferiore alla data fine giornata ispettiva");
			return false;
			}
	        
	        if(document.getElementById("dataChiusura").value=='<%= primaParteDataFine %>' && document.getElementById("oraChiusura").value<'<%= oraFine %>')
			{
			alert("L' orario di chiusura fascicolo non puo' essere inferiore all'ora chiusura giornata ispettiva");
			return false;
			}
	        
	   <% }} %>
	   <% } %>
	
	if (form.dataChiusura.value==''){
		alert('Indicare una data di chiusura.');
		return false;
	}
	

	if(datafine<datainizio)
	{
	alert("La data di chiusura fascicolo non puo' essere inferiore alla data inizio fascicolo");
	return false;
	}
	
	if (form.annoProtocolloChiusura.value=='' || isNaN(form.annoProtocolloChiusura.value) || form.numeroProtocolloChiusura.value=='' || isNaN(form.numeroProtocolloChiusura.value)){
		alert('Indicare anno e numero protocollo in formato numerico.');
		return false;
	}
	
	if (form.codAllegato.value==''){
		alert('Allegare il rapporto di chiusura.');
		return false;
	}
	 
	if (confirm("Eseguire la chiusura del fascicolo ispettivo? ATTENZIONE. Assicurarsi che i dati del protocollo siano corretti perche' non sara' piu' possibile modificarli.")) {	
		loadModalWindow();
		form.submit();
	}
   }
   

   
</script>

