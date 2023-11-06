<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@ include file="../../../initPage.jsp"%>

<jsp:useBean id="jsonFascicoloIspettivo" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="jsonGiornateIspettive" class="org.json.JSONArray" scope="request"/>
<jsp:useBean id="Messaggio" class="java.lang.String" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>
<%@ page import="org.json.*"%>

<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

 
<% if(Messaggio!=null && !Messaggio.equals("")){ %>
<script>
alert('<%=Messaggio%>');
</script>
<% } %>

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
  
  <script>
function openPopup(url){
 window.open(url,'popupSelectFascicolo'+(Math.floor(Math.random() * 100)),
'height=420px,width=400px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
}
</script>
  
  <% 
int idFascicoloIspettivo = -1;
if (jsonFascicoloIspettivo.has("CampiServizio"))
 	 idFascicoloIspettivo = Integer.parseInt((String) (((JSONObject) jsonFascicoloIspettivo.get("CampiServizio")).get("idFascicoloIspettivo")));
  
String statoFascicolo = "";
if (jsonFascicoloIspettivo.has("Stato"))
	  statoFascicolo =(String) (((JSONObject) jsonFascicoloIspettivo.get("Stato")).get("stato")); 
	
String[] datiProtocollo = PopolaCombo.getDatiProtocolloFascicolo(idFascicoloIspettivo);
int annoProtocollo = Integer.parseInt(datiProtocollo[0]);
int numeroProtocollo = Integer.parseInt(datiProtocollo[1]);
%> 


<% if (jsonGiornateIspettive.length()==0) {%>
<br/>
<input type="button" style="background-color:red" id="eliminafascicolo" onclick="window.location.href='GestioneFascicoliIspettivi.do?command=ToDelete&idFascicoloIspettivo=<%=idFascicoloIspettivo%>'" value="Elimina fascicolo"/>
<br/><br/>
<% } %>

<% 

if (statoFascicolo.equalsIgnoreCase("aperto")) {%>
<input type="button" id="chiudifascicolo" onclick="window.location.href='GestioneFascicoliIspettivi.do?command=ToClose&idFascicoloIspettivo=<%=idFascicoloIspettivo%>'" value="Chiudi fascicolo"/>
<br><br/>
<%} else if (statoFascicolo.equalsIgnoreCase("chiuso")){ %>
<table style="border:1px solid black" cellpadding="10" cellspacing="10">
<tr><th>Relazione allegata al Fascicolo Ispettivo (SICRA)</th></tr>
<tr><td>
<input type="button" value="Download relazione allegata al fascicolo ispettivo" onClick="openPopup('GestioneInvioSicra.do?command=DownloadProtocollo&annoProtocollo=<%=annoProtocollo %>&numeroProtocollo=<%=numeroProtocollo %>', 'Protocollo_<%=idFascicoloIspettivo %>')"/>
<input type="button" value="Vedi informazioni protocollo relazione allegata al fascicolo ispettivo" onClick="openPopup('GestioneInvioSicra.do?command=InviaLeggiProtocollo&annoProtocollo=<%=annoProtocollo %>&numeroProtocollo=<%=numeroProtocollo %>', 'Protocollo_<%=idFascicoloIspettivo %>')"/>
</td></tr>
</table>
<br/><br/>
<% } %>

<!-- RIEPILOGO -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Dettaglio FASCICOLO ISPETTIVO</b></center></th></tr>

<% if ( ((JSONObject) jsonFascicoloIspettivo).has("Anagrafica")) { %>
<% JSONObject jsonAnagrafica = (JSONObject) jsonFascicoloIspettivo.get("Anagrafica"); %>
<tr><td class="formLabel">Anagrafica</td><td><%=jsonAnagrafica.get("ragioneSociale") %> (<%=jsonAnagrafica.get("partitaIva") %>) <a href="OpuStab.do?command=Details&stabId=<%=jsonAnagrafica.get("riferimentoId")%>"><b>Torna all'anagrafica</b></a></td></tr>
<%} %>


<% if ( ((JSONObject) jsonFascicoloIspettivo).has("Dati")) { %>
<% JSONObject jsonDati = (JSONObject) jsonFascicoloIspettivo.get("Dati");
if (jsonDati.length()>0) {%>
<tr><td class="formLabel">Numero</td><td><%=jsonDati.get("numero")%></td></tr>
<tr><td class="formLabel">Data inizio </td><td><%=fixData(jsonDati.get("dataInizio"))%></td></tr>
<%} } %>

<% if ( ((JSONObject) jsonFascicoloIspettivo).has("Stato")) { %>
<% JSONObject jsonStato = (JSONObject) jsonFascicoloIspettivo.get("Stato");
if (jsonStato.length()>0) {%>
<tr><td class="formLabel">Stato</td><td><%=jsonStato.get("stato")%></td></tr>
<%if (jsonStato.has("dataChiusura") && jsonStato.get("dataChiusura")!=null && !jsonStato.get("dataChiusura").toString().equals("")) %>
<tr><td class="formLabel">Data chiusura </td><td><%=fixData(jsonStato.get("dataChiusura"))%></td></tr>
<%} } %>

<% if ( ((JSONObject) jsonFascicoloIspettivo).has("CampiServizio")) { %>
<% JSONObject jsonCampiServizio = (JSONObject) jsonFascicoloIspettivo.get("CampiServizio");
if (jsonCampiServizio.length()>0) {%>
<tr><td class="formLabel">Id Fascicolo Ispettivo</td><td><%=jsonCampiServizio.get("idFascicoloIspettivo")%></td></tr>
<tr><td class="formLabel">Inserito da</td><td><%=jsonCampiServizio.get("utenteInserimento")%></td></tr>
<tr><td class="formLabel">Inserito il </td><td><%=fixData(jsonCampiServizio.get("dataInserimento"))%></td></tr>
<%} } %>

</table>
<!-- RIEPILOGO -->

</center>

<br/><br/>

<!-- LISTA GIORNATE ISPETTIVE -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="10%"><col width="10%"><col width="40%"><col width="20%">

<tr><th colspan="5"><center><b>Lista GIORNATE ISPETTIVE <input type="button" value="Inserisci giornata ispettiva" onClick="loadModalWindow();window.location.href='GestioneGiornateIspettive.do?command=Add&idFascicoloIspettivo=<%=((JSONObject) jsonFascicoloIspettivo.get("CampiServizio")).get("idFascicoloIspettivo")%>'"/></b></center></th></tr>

<tr>
<th>Id Giornata Ispettiva</th>
<th>Data inizio</th>
<th>Stato</th>
<th>Inserita da</th>
<th>Inserita il</th>
</tr>

<%
if (jsonGiornateIspettive.length()>0) {
	for (int i = 0; i<jsonGiornateIspettive.length(); i++) {
	JSONObject jsonGiornataIspettiva = (JSONObject) jsonGiornateIspettive.get(i); %>
<tr>
<td><a href="GestioneGiornateIspettive.do?command=View&idGiornataIspettiva=<%=jsonGiornataIspettiva.get("idGiornataIspettiva") %>"><%=jsonGiornataIspettiva.get("idGiornataIspettiva") %></a></td>
<td><%=fixData(jsonGiornataIspettiva.get("dataInizio")) %></td>
<td><%=jsonGiornataIspettiva.get("stato") %></td>
<td><%=jsonGiornataIspettiva.get("utenteInserimento") %></td>
<td><%=fixData(jsonGiornataIspettiva.get("dataInserimento")) %></td>
</tr>
<%} } else {%>
<script>
document.getElementById("chiudifascicolo").hidden = true;
</script>
<tr><td colspan="6">Non sono presenti giornate ispettive.</td></tr>
<%} %>

</table>




<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonFascicoloIspettivo" name="jsonFascicoloIspettivo" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonFascicoloIspettivo%></textarea>
<textarea rows="10" cols="200" readonly id="jsonGiornateIspettive" name="jsonGiornateIspettive" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonGiornateIspettive%></textarea>

<!--JSON -->


<script>
function prettyPrint() { 
    var ugly = document.getElementById('jsonFascicoloIspettivo').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonFascicoloIspettivo').value = pretty;
    
    ugly = document.getElementById('jsonGiornateIspettive').value;
    obj = JSON.parse(ugly);
    pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonGiornateIspettive').value = pretty;
    
  
}
prettyPrint();
var scroll_height = $("#jsonFascicoloIspettivo").get(0).scrollHeight;
$("#jsonFascicoloIspettivo").css('height', scroll_height + 'px');
scroll_height = $("#jsonGiornateIspettive").get(0).scrollHeight;
$("#jsonGiornateIspettive").css('height', scroll_height + 'px');
</script>


