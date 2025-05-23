<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@ include file="../../../initPage.jsp"%>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>
<%@ page import="org.json.*"%>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script src="javascript/proj4.js" ></script>

<script>
function UTMtoWGS(z, x, y){
var utm_data = "+proj=utm +zone="+z;
var wgs84_data = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs";
var result = proj4(utm_data,wgs84_data,[x, y]).toString();
const wgs84_temp = result.split(',');
var wgs84_coords = wgs84_temp[1]+','+wgs84_temp[0];
return wgs84_coords;
}

function visualizzaSuMappa(x, y){
	var wgs = UTMtoWGS('33', x, y);
	window.open('https://www.google.com/maps/search/?api=1&query='+wgs);
}

</script>

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
  
<%@ include file="../verbali/elencoParticella.jsp" %> 

<input type="button" value="MODIFICA" onClick="window.location.href='GestioneCampioni.do?command=ModifyParticella&idCampione=<%=((JSONObject) jsonCampione.get("CampiServizio")).get("idCampione")%>'"/>
<br/><br/>

<!-- RIEPILOGO -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Dettaglio CAMPIONAMENTO su PARTICELLA</b></center></th></tr>

<% if ( ((JSONObject) jsonCampione).has("Anagrafica")) { %>
<% JSONObject jsonAnagrafica = (JSONObject) jsonCampione.get("Anagrafica"); %>
<tr><td class="formLabel">Codice Sito</td><td><%=jsonAnagrafica.get("codiceSito") %> <a href="Terreni.do?command=DetailsSubparticella&id=<%=jsonAnagrafica.get("riferimentoId")%>"><b>Torna alla Particella</b></a></td></tr>
<tr><td class="formLabel">Foglio catastale</td><td><%=jsonAnagrafica.get("foglioCatastale") %> </td></tr>
<tr><td class="formLabel">Particella catastale</td><td><%=jsonAnagrafica.get("particellaCatastale") %> </td></tr>
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
Campione per VOC - <%=jsonDatiVerbaleCampione.get("codiceIdentificativoVoc") %> - <%=jsonDatiVerbaleCampione.get("coordinataXVoc") %> - <%=jsonDatiVerbaleCampione.get("coordinataYVoc") %> <a href="#" onClick="visualizzaSuMappa(<%=jsonDatiVerbaleCampione.get("coordinataXVoc") %>,<%=jsonDatiVerbaleCampione.get("coordinataYVoc") %>); return false;">Visualizza su mappa</a><br/>

<%for (int i = 1; i<= Integer.parseInt((String) jsonDatiVerbaleCampione.get("numCampioniElementari")); i++){ %>
Campione elementare - <%=jsonDatiVerbaleCampione.get("codiceIdentificativo"+i) %> - <%=jsonDatiVerbaleCampione.get("coordinataX"+i) %> - <%=jsonDatiVerbaleCampione.get("coordinataY"+i) %> <a href="#" onClick="visualizzaSuMappa(<%=jsonDatiVerbaleCampione.get("coordinataX"+i) %>,<%=jsonDatiVerbaleCampione.get("coordinataY"+i) %>); return false;">Visualizza su mappa</a><br/>
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

<tr><td class="formLabel">La particella campionata risulta</td><td><%=jsonDatiVerbaleCampione.get("tipoColturaDescrizione") %> <%=jsonDatiVerbaleCampione.get("tipoColturaNote") %> </td></tr>
<tr><td class="formLabel">Presenza rifiuti</td><td><%="S".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "SI"+ " "+jsonDatiVerbaleCampione.get("presenzaRifiutiNote") : "N".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "NO" : "P".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "PARZIALMENTE" : "" %> <%=jsonDatiVerbaleCampione.get("presenzaRifiutiDescrizione") %></td></tr>

<tr><td class="formLabel">Irrigazione</td><td>Informazioni acquisite in loco: <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("irrigazioneInLoco")) ? "SI" : "NO" %> - Informazioni acquisite dal sig <%=jsonDatiVerbaleCampione.get("irrigazioneInformazioni")  %> - Derivazione acqua: <%=jsonDatiVerbaleCampione.get("irrigazioneDerivazione") %></td></tr>
<tr><td class="formLabel">Campionamento acque sotterranee</td><td><%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("pozzoCampionamento")) ? "SI num. verbale "+jsonDatiVerbaleCampione.get("pozzoCampionamentoVerbaleNumero")+ " del "+jsonDatiVerbaleCampione.get("pozzoCampionamentoVerbaleData") : "NO" %></td></tr>

<tr><td class="formLabel">Dichiarazioni Controparte</td><td><%=jsonDatiVerbaleCampione.get("dichiarazioni") %> </td></tr>
<tr><td class="formLabel">Strumentazione utilizzata</td><td><%=jsonDatiVerbaleCampione.get("strumentazione") %></td></tr>
<tr><td class="formLabel">Note aggiuntive</td><td><%=jsonDatiVerbaleCampione.get("noteAggiuntive") %> </td></tr>

<%} %>

<% if ( ((JSONObject) jsonCampione).has("CampiServizio")) { %>
<% JSONObject jsonCampiServizio = (JSONObject) jsonCampione.get("CampiServizio");
if (jsonCampiServizio.length()>0) {%>
<tr><td class="formLabel">Id campione</td><td><%=jsonCampiServizio.get("idCampione")%> <input type="hidden" id="idCampione" name="idCampione" value="<%=jsonCampiServizio.get("idCampione")%>"/></td></tr>
<tr><td class="formLabel">Inserito da</td><td><%=jsonCampiServizio.get("utenteInserimento")%></td></tr>
<tr><td class="formLabel">Inserito il </td><td><%=fixData(jsonCampiServizio.get("dataInserimento"))%></td></tr>
<%} } %>

</table>
<!-- RIEPILOGO -->


</center>


<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonCampione" name="jsonCampione" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonCampione%></textarea>
<!--JSON -->


<script>
function prettyPrint() {
    var ugly = document.getElementById('jsonCampione').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonCampione').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonCampione").get(0).scrollHeight;
$("#jsonCampione").css('height', scroll_height + 'px');
</script>







