<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="Anagrafica" class="org.aspcfs.modules.terreni.base.Subparticella" scope="request"/>
<jsp:useBean id="jsonCampioni" class="org.json.JSONArray" scope="request"/>

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
  
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Subparticella</b></center></th></tr>  
<tr><td class="formLabel">Codice Sito</td><td><%=Anagrafica.getCodiceSito() %> <a href="Terreni.do?command=DetailsSubparticella&id=<%=Anagrafica.getId()%>"><b>Torna alla Subparticella</b></a></td></tr>
<tr><td class="formLabel">Foglio catastale</td><td><%=Anagrafica.getArea().getFoglioCatastale()%> </td></tr>
<tr><td class="formLabel">Particella catastale</td><td><%=Anagrafica.getArea().getParticellaCatastale() %> </td></tr>
</table>
 
<br/>
  
<!-- LISTA -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="10%"><col width="10%"><col width="20%"><col width="20%">

<tr><th colspan="8"><center><b>Lista CAMPIONAMENTI</b></center></th></tr>

<tr>
<th>ID Campionamento</th>
<th>Numero verbale</th>
<th>Data prelievo</th>
<th>Inserito da</th>
<th>Inserito il</th>
</tr>

<%
if (jsonCampioni.length()>0) {
	for (int i = 0; i<jsonCampioni.length(); i++) {
	JSONObject jsonCampione = (JSONObject) jsonCampioni.get(i); %>
<tr>
<td><a href="GestioneCampioni.do?command=ViewParticella&idCampione=<%=jsonCampione.get("idCampione") %>"><%=jsonCampione.get("idCampione") %></a></td>
<td><%=jsonCampione.get("numeroVerbale") %></td>
<td><%=fixData(jsonCampione.get("dataPrelievo")) %></td>
<td><%=jsonCampione.get("utenteInserimento") %></td>
<td><%=fixData(jsonCampione.get("dataInserimento")) %></td>
</tr>
<%} } else {%>
<tr><td colspan="5">Non sono presenti campionamenti.</td></tr>
<%} %>

</table>
<!-- LISTA -->

</center>

<br/><br/>


<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonCampioni" name="jsonCampioni" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonCampioni%></textarea>
<!--JSON -->


<script>
function prettyPrint() {
    var ugly = document.getElementById('jsonCampioni').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonCampioni').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonCampioni").get(0).scrollHeight;
$("#jsonCampioni").css('height', scroll_height + 'px');
</script>







