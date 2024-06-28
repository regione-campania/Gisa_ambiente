<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonNonConformita" class="org.json.JSONObject" scope="request"/>

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
  
  <table class="trails" cellspacing="0">
<tr>
<td>
<a href="StabilimentoAIA.do?command=Details&stabId=<%=((JSONObject) (jsonNonConformita.get("DatiGiornataIspettiva"))).get("riferimentoId")%>"><%= ((JSONObject) (jsonNonConformita.get("DatiGiornataIspettiva"))).get("ragioneSociale") %></a> >
<a href="GestioneFascicoliIspettivi.do?command=View&idFascicoloIspettivo=<%=((JSONObject) (jsonNonConformita.get("DatiGiornataIspettiva"))).get("idFascicoloIspettivo")%>">Fascicolo ispettivo</a> > 
<a href="GestioneGiornateIspettive.do?command=View&idGiornataIspettiva=<%= ((JSONObject) jsonNonConformita.get("DatiGiornataIspettiva")).get("idGiornataIspettiva")%>">Giornata Ispettiva</a> > 
Non conformita'
</td>
</tr>
</table>
<br/> 
  
<!-- RIEPILOGO -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Dettaglio NON CONFORMITA</b></center></th></tr>

<% if ( ((JSONObject) jsonNonConformita).has("DatiGiornataIspettiva")) { %>
<% JSONObject jsonGiornataIspettiva = (JSONObject) jsonNonConformita.get("DatiGiornataIspettiva"); %>
<tr><td class="formLabel">Id Giornata Ispettiva</td><td><%=jsonGiornataIspettiva.get("idGiornataIspettiva") %> <a href="GestioneGiornateIspettive.do?command=View&idGiornataIspettiva=<%=jsonGiornataIspettiva.get("idGiornataIspettiva")%>"><b>Torna alla Giornata Ispettiva</b></a></td></tr>
<tr><td class="formLabel">Dipartimento</td><td><%=jsonGiornataIspettiva.get("dipartimento") %> </td></tr>
<tr><td class="formLabel">Ragione Sociale</td><td><%=jsonGiornataIspettiva.get("ragioneSociale") %> </td></tr>
<%} %>

<% if ( ((JSONObject) jsonNonConformita).has("Dati")) { %>
<% JSONObject jsonDati = (JSONObject) jsonNonConformita.get("Dati"); %>
<tr><td class="formLabel">Descrizione N.C.</td><td><%=jsonDati.get("note") %> </td></tr>
<%} %>

<% if ( ((JSONObject) jsonNonConformita).has("TipoVerifica")) { %>
<% JSONObject jsonTipoVerifica = (JSONObject) jsonNonConformita.get("TipoVerifica"); %>
<tr><td class="formLabel">Tipo Verifica</td><td><%=jsonTipoVerifica.get("nome") %></a></td></tr>
<%} %>

<% if ( ((JSONObject) jsonNonConformita).has("Linea")) { %>
<% JSONObject jsonLinea = (JSONObject) jsonNonConformita.get("Linea"); %>
<tr><td class="formLabel">Codice IPPC</td><td><%=jsonLinea.get("nome") %></a></td></tr>
<%} %>

<% if ( ((JSONObject) jsonNonConformita).has("CampiServizio")) { %>
<% JSONObject jsonCampiServizio = (JSONObject) jsonNonConformita.get("CampiServizio");
if (jsonCampiServizio.length()>0) {%> 
<tr><td class="formLabel">Id non conformita'</td><td><%=jsonCampiServizio.get("idNonConformita")%></td></tr>
<tr><td class="formLabel">Inserito da</td><td><%=jsonCampiServizio.get("utenteInserimento")%></td></tr>
<tr><td class="formLabel">Inserito il </td><td><%=fixData(jsonCampiServizio.get("dataInserimento"))%></td></tr>
<%} } %>


</table>
<!-- RIEPILOGO -->

</center>


<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonNonConformita" name="jsonNonConformita" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonNonConformita%></textarea>
<!--JSON -->


<script>
function prettyPrint() {
    var ugly = document.getElementById('jsonNonConformita').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonNonConformita').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonNonConformita").get(0).scrollHeight;
$("#jsonNonConformita").css('height', scroll_height + 'px');
</script>







