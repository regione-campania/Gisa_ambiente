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
<tr><td class="formLabel">Codice Sito</td><td><%=jsonAnagrafica.get("codiceSito") %> <a href="Terreni.do?command=DetailsSubparticella&id=<%=jsonAnagrafica.get("riferimentoId")%>"><b>Torna alla Subparticella</b></a></td></tr>
<tr><td class="formLabel">Foglio catastale</td><td><%=jsonAnagrafica.get("foglioCatastale") %> </td></tr>
<tr><td class="formLabel">Particella catastale</td><td><%=jsonAnagrafica.get("particellaCatastale") %> </td></tr>
<%-- <tr><td class="formLabel">Coordinate</td><td><b>X</b> <%=jsonAnagrafica.get("coordinataX") %> <b>Y</b> <%=jsonAnagrafica.get("coordinataY") %></td></tr> --%>
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
JSONObject jsonGruppoAddetti = (JSONObject) jsonCampione.get("GruppoAddetti");%>
<tr><td class="formLabel">Addetti al campionamento</td><td>
<%=jsonGruppoAddetti.get("nome1") %> <%=jsonGruppoAddetti.get("cognome1") %> <%= !"".equals(jsonGruppoAddetti.get("nome1")) ? " (<b>ARPAC MULTISERVIZI</b>)" : "" %><br/>
<%=jsonGruppoAddetti.get("nome2") %> <%=jsonGruppoAddetti.get("cognome2") %> <%= !"".equals(jsonGruppoAddetti.get("nome2")) ? " (<b>ARPAC MULTISERVIZI</b>)" : "" %><br/>
<%=jsonGruppoAddetti.get("nome3") %> <%=jsonGruppoAddetti.get("cognome3") %> <%= !"".equals(jsonGruppoAddetti.get("nome3")) ? " (<b>ARPAC MULTISERVIZI</b>)" : "" %> 
</td></tr>
<%}%>

<% if ( ((JSONObject) jsonCampione).has("DatiVerbaleCampione")) { %>
<% JSONObject jsonDatiVerbaleCampione = (JSONObject) jsonCampione.get("DatiVerbaleCampione"); %>

<tr><td class="formLabel">Carabinieri forestali</td><td><%=jsonDatiVerbaleCampione.get("carabinieriForestali") %> </td></tr>
<tr><td class="formLabel">Altri partecipanti</td><td>
<%=jsonDatiVerbaleCampione.get("altriPartecipanti1") %> in qualita' di <%=jsonDatiVerbaleCampione.get("qualitaAltriPartecipanti1") %><br/>
<%=jsonDatiVerbaleCampione.get("altriPartecipanti2") %> in qualita' di <%=jsonDatiVerbaleCampione.get("qualitaAltriPartecipanti2") %> <br/>
<%=jsonDatiVerbaleCampione.get("altriPartecipanti3") %> in qualita' di <%=jsonDatiVerbaleCampione.get("qualitaAltriPartecipanti3") %> 
</td></tr>
<tr><td class="formLabel">Dati del proprietario particella</td><td>
<%=jsonDatiVerbaleCampione.get("datiProprietarioParticella") %> 
<% if (!Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("proprietarioPresente"))){ %>
<b>ALTRA PERSONA PRESENTE</b> <%=jsonDatiVerbaleCampione.get("datiAltraPersonaPresente") %> in qualita' di <%=jsonDatiVerbaleCampione.get("qualitaAltraPersonaPresente") %>
<%} %>
</td></tr>

<tr><td class="formLabel">Numero campioni elementari</td><td><%=jsonDatiVerbaleCampione.get("numCampioniElementari") %> </td></tr>
<tr><td class="formLabel">Campioni</td><td>
Campione per VOC - <%=jsonDatiVerbaleCampione.get("codiceIdentificativoVoc") %> - <%=jsonDatiVerbaleCampione.get("coordinataXVoc") %> - <%=jsonDatiVerbaleCampione.get("coordinataYVoc") %><br/>

<%for (int i = 1; i<= Integer.parseInt((String)jsonDatiVerbaleCampione.get("numCampioniElementari")); i++){ %>
Campione elementare - <%=jsonDatiVerbaleCampione.get("codiceIdentificativo"+i) %> - <%=jsonDatiVerbaleCampione.get("coordinataX"+i) %> - <%=jsonDatiVerbaleCampione.get("coordinataY"+i) %><br/>
<% } %>

Campione medio composito - <%=jsonDatiVerbaleCampione.get("codiceIdentificativoMedioComposito") %>

</td></tr>

<tr><td class="formLabel">Aliquote</td><td style="text-transform:none">
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaA")) ? ("<b>a</b>" + " Data apertura e ora: "+jsonDatiVerbaleCampione.get("aliquotaA_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaA_ora")+ " - Laboratorio di destinazione: ARPAC" + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaBG")) ? ("<b>b</b>-<b>g</b>" + " - Laboratorio di destinazione: ARPAC" + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaC")) ? ("<b>c</b>" + " Data apertura e ora: "+jsonDatiVerbaleCampione.get("aliquotaC_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaC_ora")+ " - Laboratorio di destinazione: ARPAC" + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaD")) ? ("<b>d</b>" + " Data apertura e ora: "+jsonDatiVerbaleCampione.get("aliquotaD_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaD_ora")+ " - Laboratorio di destinazione: ARPAC" + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaCD_fitofarmaci")) ? (" (con ricerca fitofarmaci)" + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaE")) ? ("<b>e</b>" + " - Laboratorio di destinazione: Universita' Federico II di Napoli"  + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaF")) ? ("<b>f</b>" + " - Laboratorio di destinazione: ARPAC" + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaH")) ? ("<b>h</b>" + " - Laboratorio di destinazione: ARPAC" + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaI")) ? ("<b>i</b>" + " Data apertura e ora: "+jsonDatiVerbaleCampione.get("aliquotaI_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaI_ora")+ " - Laboratorio di destinazione: ARPAC" + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaLM")) ? ("<b>l</b>-<b>m</b>" + " Data apertura e ora: "+jsonDatiVerbaleCampione.get("aliquotaLM_data")+ " "+jsonDatiVerbaleCampione.get("aliquotaLM_ora")+ " - Laboratorio di destinazione: Universita' Federico II di Napoli" + "<br/>") : "" %>
<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaN")) ? ("<b>n</b>" + " - Laboratorio di destinazione: Controparte") : "" %>
</td></tr>

<tr><td class="formLabel">La particella campionata risulta</td><td><%=jsonDatiVerbaleCampione.get("tipoColturaDescrizione") %> <%=jsonDatiVerbaleCampione.get("tipoColturaNote") %> <%=jsonDatiVerbaleCampione.get("tipoColturaMotivazione") %></td></tr>
<tr><td class="formLabel">Presenza rifiuti</td><td><%="S".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "SI"+ " "+jsonDatiVerbaleCampione.get("presenzaRifiutiNote") : "N".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "NO" : "P".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "PARZIALMENTE" : "" %> <%=jsonDatiVerbaleCampione.get("presenzaRifiutiDescrizione") %></td></tr>

<tr><td class="formLabel">Irrigazione</td><td>Informazioni acquisite in loco: <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("irrigazioneInLoco")) ? "SI" : "NO" %> - Informazioni acquisite dal sig <%=jsonDatiVerbaleCampione.get("irrigazioneInformazioni")  %> - Derivazione acqua: <%=jsonDatiVerbaleCampione.get("irrigazioneDerivazione") %></td></tr>
<tr><td class="formLabel">Campionamento acque sotterranee</td><td><%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("pozzoCampionamento")) ? "SI num. verbale "+jsonDatiVerbaleCampione.get("pozzoCampionamentoVerbaleNumero")+ " del "+jsonDatiVerbaleCampione.get("pozzoCampionamentoVerbaleData") : "NO" %></td></tr>

<tr><td class="formLabel">Dichiarazioni Controparte</td><td><%=jsonDatiVerbaleCampione.get("dichiarazioni") %> </td></tr>
<tr><td class="formLabel">Strumentazione utilizzata</td><td><%=jsonDatiVerbaleCampione.get("strumentazione") %></td></tr>
<tr><td class="formLabel">Note aggiuntive</td><td><%=jsonDatiVerbaleCampione.get("noteAggiuntive") %> </td></tr>
<%} %>



</table>
<!-- RIEPILOGO -->


<%if ( (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si"))) {%>
<%@ include file="../../util/random.jsp" %>
<%} %>

