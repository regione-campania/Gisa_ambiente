<%@ page import="org.json.*"%>

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
  
<!-- RIEPILOGO -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Aggiunta GIORNATA ISPETTIVA</b></center></th></tr>

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
<tr><td class="formLabel">Dipartimento </td><td><%=jsonDipartimento.get("nome")%></td></tr>
<%} } %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("Tecnica")) { %>
<% JSONObject jsonTecnica = (JSONObject) jsonGiornataIspettiva.get("Tecnica"); %>
<tr><td class="formLabel">Tecnica </td><td><%=jsonTecnica.get("nome") %></td></tr>
<%} %>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("Dati")) { %>
<% JSONObject jsonDati = (JSONObject) jsonGiornataIspettiva.get("Dati");
if (jsonDati.length()>0) {%>
<tr><td class="formLabel">Data inizio </td><td><%=fixData(jsonDati.get("dataInizio"))%></td></tr>
<tr><td class="formLabel">Ora inizio </td><td><%=jsonDati.get("oraInizio")%></td></tr>

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
<tr><td class="formLabel">Codici IPPC sottoposti </td><td>
<% for (int i = 0; i<jsonLinee.length(); i++) {
JSONObject jsonLinea = (JSONObject) jsonLinee.get(i);%>
<%=jsonLinea.get("nome") %><br/><br/> 
<% } %>
</td></tr>
<%} }%>

<% if ( ((JSONObject) jsonGiornataIspettiva).has("Matrici")) { 
JSONArray jsonMatrici = (JSONArray) jsonGiornataIspettiva.get("Matrici");
if (jsonMatrici.length()>0) {%>
<tr><td class="formLabel">Matrici </td><td>
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
<%=jsonComponente.get("nominativo") %> - <%=jsonComponente.get("descrizioneAreaSemplice") %>  <%=jsonComponente.has("referente") && Boolean.TRUE.equals(jsonComponente.get("referente")) ? "(<b>Referente Ispettivo</b>)" : "" %> <%=jsonComponente.has("dirigente") && Boolean.TRUE.equals(jsonComponente.get("dirigente")) ? "(<b>Dirigente Coordinatore</b>)" : "" %><br/><br/>
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



</table>
<!-- RIEPILOGO -->


<%if ( (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si"))) {%>
<%@ include file="../../util/random.jsp" %>
<%} %>

