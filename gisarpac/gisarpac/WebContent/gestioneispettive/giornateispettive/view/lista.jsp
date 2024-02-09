<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="Anagrafica" class="org.aspcfs.modules.gestioneispettive.base.Anagrafica" scope="request"/>
<jsp:useBean id="jsonGiornateIspettive" class="org.json.JSONArray" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>
<%@ page import="org.json.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<center>


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
  
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Anagrafica</b></center></th></tr>  
<tr><td class="formLabel">Ragione sociale</td><td><%=Anagrafica.getRagioneSociale() %>  <a href="StabilimentoAIA.do?command=Details&stabId=<%=Anagrafica.getRiferimentoId()%>"><b>Torna all'anagrafica</b></a></td></tr>
</table>
 
<br/>
  
<!-- LISTA -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="10%"><col width="10%"><col width="20%"><col width="20%">

<tr><th colspan="6"><center><b>Lista GIORNATE ISPETTIVE</b></center></th></tr>

<tr>
<th>Id Giornata Ispettiva</th>
<th>Data inizio</th>
<th>Tecnica</th>
<th>Stato</th>
<th>Inserito da</th>
<th>Inserito il</th>
</tr>

<%
if (jsonGiornateIspettive.length()>0) {
	for (int i = 0; i<jsonGiornateIspettive.length(); i++) {
	JSONObject jsonGiornataIspettiva = (JSONObject) jsonGiornateIspettive.get(i); %>
<tr>
<td><a href="GestioneGiornateIspettive.do?command=View&idGiornataIspettiva=<%=jsonGiornataIspettiva.get("idGiornataIspettiva") %>"><%=jsonGiornataIspettiva.get("idGiornataIspettiva") %></a></td>
<td><%=fixData(jsonGiornataIspettiva.get("dataInizio")) %></td>
<td><%=jsonGiornataIspettiva.get("tecnica") %></td>
<td><%=jsonGiornataIspettiva.get("stato") %></td>
<td><%=jsonGiornataIspettiva.get("utenteInserimento") %></td>
<td><%=fixData(jsonGiornataIspettiva.get("dataInserimento")) %></td>
</tr>
<%} } else {%>
<tr><td colspan="6">Non sono presenti giornate ispettive.</td></tr>
<%} %>

</table>
<!-- LISTA -->

</center>

<br/><br/>


<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonGiornateIspettive" name="jsonGiornateIspettive" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonGiornateIspettive%></textarea>
<!--JSON -->


<script>
function prettyPrint() {
    var ugly = document.getElementById('jsonGiornateIspettive').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonGiornateIspettive').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonGiornateIspettive").get(0).scrollHeight;
$("#jsonGiornateIspettive").css('height', scroll_height + 'px');
</script>







