<%@ page import="org.json.*"%>

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
  
<!-- RIEPILOGO -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Aggiunta CAMPIONAMENTO su SUBPARTICELLA</b></center></th></tr>

<% if ( ((JSONObject) jsonCampione).has("Anagrafica")) { %>
<% JSONObject jsonAnagrafica = (JSONObject) jsonCampione.get("Anagrafica"); %>
<tr><td class="formLabel">Codice Sito</td><td><%=jsonAnagrafica.get("codiceSito") %> <!--  <a href="Terreni.do?command=DetailsSubparticella&id=<%=jsonAnagrafica.get("riferimentoId")%>"><b>Torna alla Subparticella</b></a>--></td></tr>
<tr><td class="formLabel">Foglio catastale</td><td><%=jsonAnagrafica.get("foglioCatastale") %> </td></tr>
<tr><td class="formLabel">Particella catastale</td><td><%=jsonAnagrafica.get("particellaCatastale") %> </td></tr>
<tr><td class="formLabel">Coordinate</td><td><b>X</b> <%=jsonAnagrafica.get("coordinataX") %> <b>Y</b> <%=jsonAnagrafica.get("coordinataY") %></td></tr>
<%} %>

<% if ( ((JSONObject) jsonCampione).has("Tecnica")) { %>
<% JSONObject jsonTecnica = (JSONObject) jsonCampione.get("Tecnica"); %>
<tr><td class="formLabel">Tecnica</td><td><%=jsonTecnica.get("nome") %> </td></tr>
<%} %>

<% if ( ((JSONObject) jsonCampione).has("Laboratorio")) { %>
<% JSONObject jsonLaboratorio = (JSONObject) jsonCampione.get("Laboratorio"); %>
<tr><td class="formLabel">Laboratorio</td><td><%=jsonLaboratorio.get("nome") %> </td></tr>
<%} %>

<% if ( ((JSONObject) jsonCampione).has("Motivo")) { %>
<% JSONObject jsonMotivo = (JSONObject) jsonCampione.get("Motivo"); %>
<tr><td class="formLabel">Motivo</td><td><%=jsonMotivo.get("descrizione") %> </td></tr>
<%} %>

<% if ( ((JSONObject) jsonCampione).has("Matrici")) { 
JSONArray jsonMatrici = (JSONArray) jsonCampione.get("Matrici");
if (jsonMatrici.length()>0) {%>
<tr><td class="formLabel">Matrici</td><td>
<% 
for (int i = 0; i<jsonMatrici.length(); i++) {
JSONObject jsonMatrice = (JSONObject) jsonMatrici.get(i);
%>
<%=jsonMatrice.get("nome") %> <br/><br/>
<% } %>
</td></tr>
<%} }%>

<% if ( ((JSONObject) jsonCampione).has("Dati")) { %>
<% JSONObject jsonDati = (JSONObject) jsonCampione.get("Dati"); %>
<tr><td class="formLabel">Numero Verbale</td><td><%=jsonDati.get("numeroVerbale") %> </td></tr>
<tr><td class="formLabel">Data prelievo</td><td><%=fixData(jsonDati.get("dataPrelievo")) %> </td></tr>
<tr><td class="formLabel">Ore</td><td><%=jsonDati.get("ore") %> </td></tr>
<%} %>

<% if ( ((JSONObject) jsonCampione).has("GruppoTecnici")) { 
JSONArray jsonGruppoTecnici = (JSONArray) jsonCampione.get("GruppoTecnici");
if (jsonGruppoTecnici.length()>0) {%>
<tr><td class="formLabel">Tecnici del campionamento</td><td>
<% 
for (int i = 0; i<jsonGruppoTecnici.length(); i++) {
JSONObject jsonComponente = (JSONObject) jsonGruppoTecnici.get(i);
%>
<%=jsonComponente.get("nominativo") %> (<b><%=jsonComponente.get("qualifica") %></b>) <br/><br/>
<% } %>
</td></tr>
<%} }%>

<% if ( ((JSONObject) jsonCampione).has("GruppoAddetti")) { 
JSONArray jsonGruppoAddetti = (JSONArray) jsonCampione.get("GruppoAddetti");
if (jsonGruppoAddetti.length()>0) {%>
<tr><td class="formLabel">Addetti al campionamento</td><td>
<% 
for (int i = 0; i<jsonGruppoAddetti.length(); i++) {
JSONObject jsonComponente = (JSONObject) jsonGruppoAddetti.get(i);
%>
<%=jsonComponente.get("nominativo") %> (<b><%=jsonComponente.get("qualifica") %></b>) <br/><br/>
<% } %>
</td></tr>
<%} }%>

<% if ( ((JSONObject) jsonCampione).has("DatiVerbaleCampione")) { %>
<% JSONObject jsonDatiVerbaleCampione = (JSONObject) jsonCampione.get("DatiVerbaleCampione"); %>

<tr><td class="formLabel">Carabinieri forestali</td><td><%=jsonDatiVerbaleCampione.get("carabinieriForestali") %> </td></tr>
<tr><td class="formLabel">Altri partecipanti</td><td>
<%=jsonDatiVerbaleCampione.get("altriPartecipanti1") %> in qualita' di <%=jsonDatiVerbaleCampione.get("qualitaAltriPartecipanti1") %><br/>
<%=jsonDatiVerbaleCampione.get("altriPartecipanti2") %> in qualita' di <%=jsonDatiVerbaleCampione.get("qualitaAltriPartecipanti2") %> <br/>
<%=jsonDatiVerbaleCampione.get("altriPartecipanti3") %> in qualita' di <%=jsonDatiVerbaleCampione.get("qualitaAltriPartecipanti3") %> 
</td></tr>
<tr><td class="formLabel">Dati del proprietario particella</td><td>
<% if (Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("proprietarioPresente"))){ %>
<b>PROPRIETARIO PRESENTE</b> <%=jsonDatiVerbaleCampione.get("datiProprietarioParticella") %>
<%} else { %>
<b>ALTRA PERSONA PRESENTE</b> <%=jsonDatiVerbaleCampione.get("datiAltraPersonaPresente") %> in qualita' di <%=jsonDatiVerbaleCampione.get("qualitaAltraPersonaPresente") %>
<%} %>
</td></tr>

<tr><td class="formLabel">Numero campioni elementari</td><td><%=jsonDatiVerbaleCampione.get("numCampioniElementari") %> </td></tr>
<tr><td class="formLabel">Campioni</td><td>
Campione per VOC - <%=jsonDatiVerbaleCampione.get("codiceIdentificativoVoc") %> - <%=jsonDatiVerbaleCampione.get("coordinataXVoc") %> - <%=jsonDatiVerbaleCampione.get("coordinataYVoc") %><br/>

<%for (int i = 1; i<=5; i++){ %>
Campione elementare - <%=jsonDatiVerbaleCampione.get("codiceIdentificativo"+i) %> - <%=jsonDatiVerbaleCampione.get("coordinataX"+i) %> - <%=jsonDatiVerbaleCampione.get("coordinataY"+i) %><br/>
<% } %>

Campione medio composito - <%=jsonDatiVerbaleCampione.get("codiceIdentificativoMedioComposito") %>

</td></tr>

<tr><td class="formLabel">Aliquote</td><td style="text-transform:none">
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaA")) ? ("<b>a</b>" + " Data e ora: "+jsonDatiVerbaleCampione.get("aliquotaA_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaA_ora") + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaBG")) ? ("<b>b</b>-<b>g</b>" + " Data e ora: "+jsonDatiVerbaleCampione.get("aliquotaBG_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaBG_ora") + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaC")) ? ("<b>c</b>" + " Data e ora: "+jsonDatiVerbaleCampione.get("aliquotaC_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaC_ora") + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaD")) ? ("<b>d</b>" + " Data e ora: "+jsonDatiVerbaleCampione.get("aliquotaD_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaD_ora") + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaCD_fitofarmaci")) ? (" (con ricerca fitofarmaci)" + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaE")) ? ("<b>e</b>" + " Data e ora: "+jsonDatiVerbaleCampione.get("aliquotaE_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaE_ora") + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaF")) ? ("<b>f</b>" + " Data e ora: "+jsonDatiVerbaleCampione.get("aliquotaF_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaF_ora") + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaH")) ? ("<b>h</b>" + " Data e ora: "+jsonDatiVerbaleCampione.get("aliquotaH_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaH_ora") + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaI")) ? ("<b>i</b>" + " Data e ora: "+jsonDatiVerbaleCampione.get("aliquotaI_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaI_ora") + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaLM")) ? ("<b>l</b>-<b>m</b>" + " Data e ora: "+jsonDatiVerbaleCampione.get("aliquotaLM_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaLM_ora") + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaN")) ? ("<b>n</b>" + " Data e ora: "+jsonDatiVerbaleCampione.get("aliquotaN_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaN_ora")) : "" %>
</td></tr>

<tr><td class="formLabel">La particella campionata risulta</td><td><%=jsonDatiVerbaleCampione.get("tipoColturaDescrizione") %> <%=jsonDatiVerbaleCampione.get("tipoColturaNote") %> <%=jsonDatiVerbaleCampione.get("tipoColturaMotivazione") %></td></tr>
<tr><td class="formLabel">Presenza rifiuti</td><td><%="S".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "SI"+ " "+jsonDatiVerbaleCampione.get("presenzaRifiutiNote") : "N".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "NO" : "P".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "PARZIALMENTE" : "" %> <%=jsonDatiVerbaleCampione.get("presenzaRifiutiDescrizione") %></td></tr>

<tr><td class="formLabel">Irrigazione</td><td><%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("irrigazioneInLoco")) ? "Informazioni acquisite in loco" : "Informazioni acquisite dal sig "+jsonDatiVerbaleCampione.get("irrigazioneInformazioni")  %> - Derivazione acqua: <%=jsonDatiVerbaleCampione.get("irrigazioneDerivazione") %></td></tr>
<tr><td class="formLabel">Campionamento acque sotterranee</td><td><%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("pozzoCampionamento")) ? "SI num. verbale "+jsonDatiVerbaleCampione.get("pozzoCampionamentoVerbaleNumero")+ " del "+jsonDatiVerbaleCampione.get("pozzoCampionamentoVerbaleData") : "NO" %></td></tr>

<tr><td class="formLabel">Dichiarazioni</td><td><%=jsonDatiVerbaleCampione.get("dichiarazioni") %> </td></tr>
<tr><td class="formLabel">Strumentazione utilizzata</td><td><%=jsonDatiVerbaleCampione.get("strumentazione") %></td></tr>
<tr><td class="formLabel">Note aggiuntive</td><td><%=jsonDatiVerbaleCampione.get("noteAggiuntive") %> </td></tr>
<%} %>



</table>
<!-- RIEPILOGO -->


<%if ( (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si"))) {%>
<%@ include file="../../util/random.jsp" %>
<%} %>

