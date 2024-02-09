<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="Anagrafica" class="org.aspcfs.modules.gestioneispettive.base.Anagrafica" scope="request"/>
<jsp:useBean id="jsonFascicoliIspettivi" class="org.json.JSONArray" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>
<%@ page import="org.json.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
function openPopupLarge(url){
	
	  var res;
    var result;
    	  window.open(url,'popupSelect',
          'height=600px,width=1000px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
	}		
	
</script>

<center>


<%! public static String fixData(Object objData)
  {
	  String toRet = "";
	  if (objData == null || objData.equals("") || objData.toString().length()<10)
		  return toRet;
	  String data = objData.toString();
	  String anno = data.substring(0,4);
	  String mese = data.substring(5,7);
	  String giorno = data.substring(8,10);
	  toRet =giorno+"/"+mese+"/"+anno;
	  return toRet;
	  
  }%>
  
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="StabilimentoAIA.do?command=Details&stabId=<%=Anagrafica.getRiferimentoId()%>"><%=Anagrafica.getRagioneSociale() %></a> > 
Fascicoli ispettivi
</td>
</tr>
</table>
<br/> 
  
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Anagrafica</b></center></th></tr>  
<tr><td class="formLabel">Ragione sociale</td><td><%=Anagrafica.getRagioneSociale() %>  <a href="StabilimentoAIA.do?command=Details&stabId=<%=Anagrafica.getRiferimentoId()%>"><b>Torna all'anagrafica</b></a></td></tr>
</table>
 
<br/>
  
<!-- LISTA -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="10%"><col width="10%"><col width="20%"><col width="20%">

<tr><th colspan="8"><center><b>Lista FASCICOLI ISPETTIVI</b></center></th></tr>

<tr>
<th>ID Fascicolo Ispettivo</th>
<th>Numero</th>
<th>Stato</th>
<th>Data inizio</th>
<th>Data chiusura</th>
<th>Inserito da</th>
<th>Inserito il</th>
</tr>

<%
if (jsonFascicoliIspettivi.length()>0) {
	for (int i = 0; i<jsonFascicoliIspettivi.length(); i++) {
	JSONObject jsonFascicoloIspettivo = (JSONObject) jsonFascicoliIspettivi.get(i); %>
<tr>
<td><a href="GestioneFascicoliIspettivi.do?command=View&idFascicoloIspettivo=<%=jsonFascicoloIspettivo.get("idFascicoloIspettivo") %>"><%=jsonFascicoloIspettivo.get("idFascicoloIspettivo") %></a></td>
<td><%=jsonFascicoloIspettivo.get("numero") %></td>
<td><%=jsonFascicoloIspettivo.get("statoFascicolo")%> </td>
<td><%=fixData(jsonFascicoloIspettivo.get("dataInizio")) %></td>
<td><%=fixData(jsonFascicoloIspettivo.get("dataChiusura"))%></td>
<td><%=jsonFascicoloIspettivo.get("utenteInserimento") %></td>
<td><%=fixData(jsonFascicoloIspettivo.get("dataInserimento")) %></td>
</tr>
<%} } else {%>
<tr><td colspan="7">Non sono presenti fascicoli ispettivi.</td></tr>
<%} %>

</table>
<!-- LISTA -->

</center>

<br/><br/>


<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonFascicoliIspettivi" name="jsonFascicoliIspettivi" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonFascicoliIspettivi%></textarea>
<!--JSON -->


<script>
function prettyPrint() {
    var ugly = document.getElementById('jsonFascicoliIspettivi').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonFascicoliIspettivi').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonFascicoliIspettivi").get(0).scrollHeight;
$("#jsonFascicoliIspettivi").css('height', scroll_height + 'px');



if(<%=request.getAttribute("controlloKO")%>)
alert("ATTENZIONE! non possono essere aggiunti fascicoli ispettivi fino alla completa aggiunta dei dati autorizzativi.")

</script>







