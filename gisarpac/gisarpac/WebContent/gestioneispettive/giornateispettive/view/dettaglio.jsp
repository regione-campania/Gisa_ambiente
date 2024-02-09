<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@ include file="../../../initPage.jsp"%>


<jsp:useBean id="jsonGiornataIspettiva" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="jsonCampioni" class="org.json.JSONArray" scope="request"/>
<jsp:useBean id="jsonNonConformita" class="org.json.JSONArray" scope="request"/>

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
	  if (objData == null || objData.equals("") || objData.toString().length()<10 )
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
<a href="StabilimentoAIA.do?command=Details&stabId=<%=((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoId")%>"><%= ((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("ragioneSociale") %></a> >
<a href="GestioneFascicoliIspettivi.do?command=Lista&riferimentoId=<%=((JSONObject) jsonGiornataIspettiva.get("Anagrafica")).get("riferimentoId")%>&riferimentoIdNomeTab=aia_stabilimento">Fascicoli ispettivi</a> > 
<a href="GestioneFascicoliIspettivi.do?command=View&idFascicoloIspettivo=<%=((JSONObject) jsonGiornataIspettiva.get("FascicoloIspettivo")).get("id")%>">Fascicolo ispettivo</a> > 
Giornata Ispettiva
</td>
</tr>
</table>
<br/> 
  
  
<%@ include file="../verbali/elenco.jsp" %>

<!-- RIEPILOGO -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Dettaglio GIORNATA ISPETTIVA</b></center></th></tr>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("FascicoloIspettivo")) { %>
<% JSONObject jsonFascicoloIspettivo = (JSONObject) jsonGiornataIspettiva.get("FascicoloIspettivo"); %>
<tr><td class="formLabel">Fascicolo Ispettivo</td><td><%=jsonFascicoloIspettivo.get("id") %> (<%=jsonFascicoloIspettivo.get("numero") %>) <a href="GestioneFascicoliIspettivi.do?command=View&idFascicoloIspettivo=<%=jsonFascicoloIspettivo.get("id")%>"><b>Torna al Fascicolo Ispettivo</b></a></td></tr>
<%} %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("Anagrafica")) { %>
<% JSONObject jsonAnagrafica = (JSONObject) jsonGiornataIspettiva.get("Anagrafica"); %>
<tr><td class="formLabel">Anagrafica</td><td><%=jsonAnagrafica.get("ragioneSociale") %> (<%=jsonAnagrafica.get("partitaIva") %>) <a href="StabilimentoAIA.do?command=Details&stabId=<%=jsonAnagrafica.get("riferimentoId")%>"><b>Torna all'Anagrafica</b></a></td></tr>
<%} %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("Dipartimento")) { %>
<% JSONObject jsonDipartimento = (JSONObject) jsonGiornataIspettiva.get("Dipartimento");
if (jsonDipartimento.length()>0) {%>
<tr><td class="formLabel">Dipartimento</td><td><%=jsonDipartimento.get("nome")%></td></tr>
<%} } %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("Tecnica")) { %>
<% JSONObject jsonTecnica = (JSONObject) jsonGiornataIspettiva.get("Tecnica"); %>
<tr><td class="formLabel">Tecnica</td><td><%=jsonTecnica.get("nome") %></td></tr>
<%} %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("Dati")) { %>
<% JSONObject jsonDati = (JSONObject) jsonGiornataIspettiva.get("Dati");
if (jsonDati.length()>0) {%>
<tr><td class="formLabel">Data inizio </td><td><%=fixData(jsonDati.get("dataInizio"))%></td></tr>
<tr><td class="formLabel">Ora inizio </td><td><%=jsonDati.get("oraInizio")%></td></tr>
<tr><td class="formLabel">Data fine </td><td><%=fixData(jsonDati.get("dataFine") != null ? jsonDati.get("dataFine") : "")%></td></tr>
<tr><td class="formLabel">Ora fine </td><td><%=jsonDati.get("oraFine")%></td></tr>
<tr><td class="formLabel">Note </td><td><%=jsonDati.get("note")%></td></tr>

<%} } %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("PerContoDi")) { %>
<% JSONArray jsonPerContoDi = (JSONArray) jsonGiornataIspettiva.get("PerContoDi"); 
if (jsonPerContoDi.length()>0) {%>
<tr><td class="formLabel">Per Conto Di </td><td>
<% for (int i = 0; i<jsonPerContoDi.length(); i++) {
JSONObject jsonPerContoDi1 = (JSONObject) jsonPerContoDi.get(i);%>
<%=jsonPerContoDi1.get("nome") %><br/><br/>
<% } %>
</td></tr>
<%} }%>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("Linee")) { %>
<% JSONArray jsonLinee = (JSONArray) jsonGiornataIspettiva.get("Linee"); 
if (jsonLinee.length()>0) {%>
<tr><td class="formLabel">Linee sottoposte </td><td>
<% for (int i = 0; i<jsonLinee.length(); i++) {
JSONObject jsonLinea = (JSONObject) jsonLinee.get(i);%>
<%=jsonLinea.get("nome") %><br/><br/>
<% } %>
</td></tr>
<%} }%>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("Matrici")) { 
JSONArray jsonMatrici = (JSONArray) jsonGiornataIspettiva.get("Matrici");
if (jsonMatrici.length()>0) {%>
<tr><td class="formLabel">Matrici  </td><td>
<% for (int i = 0; i<jsonMatrici.length(); i++) {
JSONObject jsonMatrice = (JSONObject) jsonMatrici.get(i);
%>
<%=jsonMatrice.get("nome") %> (<%=jsonMatrice.get("conclusa") %>)<br/>
<% } %>
</td></tr>
<%} } %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("EmissioniAtmosferaCamini")) { 
JSONArray jsonEmissioniAtmosferaCamini = (JSONArray) jsonGiornataIspettiva.get("EmissioniAtmosferaCamini");
if (jsonEmissioniAtmosferaCamini.length()>0) {%>
<tr><td class="formLabel">Emissioni Atmosfera Camini </td><td>
<% 
for (int i = 0; i<jsonEmissioniAtmosferaCamini.length(); i++) {
JSONObject jsonEmissioneAtmosferaCamino = (JSONObject) jsonEmissioniAtmosferaCamini.get(i);
%>
<i>Codice camino:</i> <%=jsonEmissioneAtmosferaCamino.get("codiceCamino") %> - 
<i>Fasi lavorativa:</i> <%=jsonEmissioneAtmosferaCamino.get("fasiLavorativa") %> - 
<i>Inquinanti:</i> <%=jsonEmissioneAtmosferaCamino.get("inquinanti") %> - 
<i>Sistema abbattimento:</i> <%=jsonEmissioneAtmosferaCamino.get("sistemaAbbattimento") %> - 
<i>Data sopralluogo 2016:</i> <%=fixData(jsonEmissioneAtmosferaCamino.get("dataSopralluogo2016")) %> - 
<i>Parametri analizzati:</i> <%=jsonEmissioneAtmosferaCamino.get("parametriAnalizzati") %> - 
<!-- <i>Superamenti limiti normativi:</i> <%=jsonEmissioneAtmosferaCamino.get("superamentiLimitiNormativi") %> --> - 
<i>Note:</i> <%=jsonEmissioneAtmosferaCamino.get("note") %> - 
<!-- <i>Esito conforme:</i> <%=jsonEmissioneAtmosferaCamino.has("esitoConforme") && Boolean.TRUE.equals(jsonEmissioneAtmosferaCamino.get("esitoConforme")) ? "SI" : "NO" %> -->

<br/><br/>
<% } %>
</td></tr>
<%} }%>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("GruppoIspettivo")) { 
JSONArray jsonGruppoIspettivo = (JSONArray) jsonGiornataIspettiva.get("GruppoIspettivo");
if (jsonGruppoIspettivo.length()>0) {%>
<tr><td class="formLabel">Gruppo Ispettivo </td><td>
<% 
for (int i = 0; i<jsonGruppoIspettivo.length(); i++) {
JSONObject jsonComponente = (JSONObject) jsonGruppoIspettivo.get(i);
%>
<%=jsonComponente.get("nominativo") %> - <%=jsonComponente.get("struttura") %> <%=Boolean.TRUE.equals(jsonComponente.get("referente")) ? "(<b>Incaricato di Funzione</b>)" : "" %> <%=Boolean.TRUE.equals(jsonComponente.get("responsabile")) ? "(<b>Responsabile Procedimento</b>)" : "" %> <br/><br/>
<% } %>
</td></tr>
<%} }%>


<% if ( ((JSONObject) jsonGiornataIspettiva).has("Motivi")) { 
JSONArray jsonMotivi = (JSONArray) jsonGiornataIspettiva.get("Motivi");
if (jsonMotivi.length()>0) {%>
<tr><td class="formLabel">Motivi </td><td>
<% for (int i = 0; i<jsonMotivi.length(); i++) {
JSONObject jsonMotivo = (JSONObject) jsonMotivi.get(i);
%>
<%=jsonMotivo.get("nome") %><br/>
<% } %>
</td></tr>
<%} } %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("Esami")) { 
JSONArray jsonEsami = (JSONArray) jsonGiornataIspettiva.get("Esami");
if (jsonEsami.length()>0) {%>
<tr><td class="formLabel">Esami della documentazione</td><td>
<% for (int i = 0; i<jsonEsami.length(); i++) {
JSONObject jsonEsame = (JSONObject) jsonEsami.get(i);
%>
<%=jsonEsame.get("nome") %><br/>
<% } %>
</td></tr>
<%} } %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("TipiVerifica")) { 
JSONArray jsonTipiVerifica = (JSONArray) jsonGiornataIspettiva.get("TipiVerifica");
if (jsonTipiVerifica.length()>0) {%>
<tr><td class="formLabel">Tipo verifica </td><td>
<% for (int i = 0; i<jsonTipiVerifica.length(); i++) {
JSONObject jsonTipoVerifica = (JSONObject) jsonTipiVerifica.get(i);
%>
<%=jsonTipoVerifica.get("nome") %><br/>
<% } %>
</td></tr>
<%} } %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("CampiServizio")) { %>
<% JSONObject jsonCampiServizio = (JSONObject) jsonGiornataIspettiva.get("CampiServizio");
if (jsonCampiServizio.length()>0) {%>
<tr><td class="formLabel">Id Giornata Ispettiva</td><td><%=jsonCampiServizio.get("idGiornataIspettiva")%></td></tr>
<tr><td class="formLabel">Stato </td><td><%=jsonCampiServizio.get("stato")%></td></tr>
<tr><td class="formLabel">Inserita da</td><td><%=jsonCampiServizio.get("utenteInserimento")%></td></tr>
<tr><td class="formLabel">Inserita il </td><td><%=fixData(jsonCampiServizio.get("dataInserimento"))%></td></tr>
<%} } %>


</table>
<!-- RIEPILOGO -->

</center>

<br/><br/>

<%@ include file="../allegati/elenco.jsp" %> 

<br/><br/>

<!-- LISTA CAMPIONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="10%"><col width="10%"><col width="40%"><col width="20%">

<tr><th colspan="5"><center><b>Lista CAMPIONI <input type="button" value="Inserisci campione" onClick="loadModalWindow();window.location.href='GestioneCampioni.do?command=Add&idGiornataIspettiva=<%=((JSONObject) jsonGiornataIspettiva.get("CampiServizio")).get("idGiornataIspettiva")%>'"/></b></center></th></tr>

<tr>
<th>ID campione</th>
<th>Data prelievo</th>
<th>Numero Verbale</th>
<th>Inserito da</th>
<th>Inserito il</th>
</tr>

<%
if (jsonCampioni.length()>0) {
	for (int i = 0; i<jsonCampioni.length(); i++) {
	JSONObject jsonCampione = (JSONObject) jsonCampioni.get(i); %>
<tr>
<td><a href="GestioneCampioni.do?command=View&idCampione=<%=jsonCampione.get("idCampione") %>"><%=jsonCampione.get("idCampione") %></a></td>
<td><%=fixData(jsonCampione.get("dataPrelievo")) %></td>
<td><%=jsonCampione.get("NumVerbale") %></td>
<td><%=jsonCampione.get("utenteInserimento") %></td>
<td><%=fixData(jsonCampione.get("dataInserimento")) %></td>
</tr>
<%} } else {%>
<tr><td colspan="6">Non sono presenti campioni.</td></tr>
<%} %>

</table>

<br/><br/>

<!-- LISTA NON CONFORMITA -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="60%">

<tr><th colspan="3"><center><b>Lista NON CONFORMITA' <input type="button" value="Inserisci non conformita'" onClick="loadModalWindow();window.location.href='GestioneNonConformita.do?command=Add&idGiornataIspettiva=<%=((JSONObject) jsonGiornataIspettiva.get("CampiServizio")).get("idGiornataIspettiva")%>'"/></b></center></th></tr>

<tr>
<th>ID non conformita'</th>
<th>Inserita da</th>
<th>Inserita il</th>
</tr>

<%
if (jsonNonConformita.length()>0) {
	for (int i = 0; i<jsonNonConformita.length(); i++) {
	JSONObject jsonNonConformita1 = (JSONObject) jsonNonConformita.get(i); %>
<tr>
<td><a href="GestioneNonConformita.do?command=View&idNonConformita=<%=jsonNonConformita1.get("idNonConformita") %>"><%=jsonNonConformita1.get("idNonConformita") %></a></td>
<td><%=jsonNonConformita1.get("utenteInserimento") %></td>
<td><%=fixData(jsonNonConformita1.get("dataInserimento")) %></td>
</tr>
<%} } else {%>
<tr><td colspan="3">Non sono presenti non conformita'.</td></tr>
<%} %>

</table>




<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonGiornataIspettiva" name="jsonGiornataIspettiva" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonGiornataIspettiva%></textarea>
<textarea rows="10" cols="200" readonly id="jsonCampioni" name="jsonCampioni" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonCampioni%></textarea>
<textarea rows="10" cols="200" readonly id="jsonNonConformita" name="jsonNonConformita" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonNonConformita%></textarea>

<!--JSON -->


<script>
function prettyPrint() { 
    var ugly = document.getElementById('jsonGiornataIspettiva').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonGiornataIspettiva').value = pretty;
    
    ugly = document.getElementById('jsonCampioni').value;
    obj = JSON.parse(ugly);
    pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonCampioni').value = pretty;
    
    ugly = document.getElementById('jsonNonConformita').value;
    obj = JSON.parse(ugly);
    pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonNonConformita').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonGiornataIspettiva").get(0).scrollHeight;
$("#jsonGiornataIspettiva").css('height', scroll_height + 'px');
scroll_height = $("#jsonCampioni").get(0).scrollHeight;
$("#jsonCampioni").css('height', scroll_height + 'px');
scroll_height = $("#jsonNonConformita").get(0).scrollHeight;
$("#jsonNonConformita").css('height', scroll_height + 'px');
</script>







