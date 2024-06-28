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
<a href="StabilimentoAIA.do?command=Details&stabId=<%=((JSONObject) (jsonCampione.get("DatiGiornataIspettiva"))).get("riferimentoId")%>"><%= ((JSONObject) (jsonCampione.get("DatiGiornataIspettiva"))).get("ragioneSociale") %></a> >
<a href="GestioneFascicoliIspettivi.do?command=View&idFascicoloIspettivo=<%=((JSONObject) (jsonCampione.get("DatiGiornataIspettiva"))).get("idFascicoloIspettivo")%>">Fascicolo ispettivo</a> > 
<a href="GestioneGiornateIspettive.do?command=View&idGiornataIspettiva=<%= ((JSONObject) jsonCampione.get("DatiGiornataIspettiva")).get("idGiornataIspettiva")%>">Giornata Ispettiva</a> > 
Campione
</td>
</tr>
</table>
<br/> 
  
  <jsp:include page="gestionePreaccettazione.jsp">
    <jsp:param name="preaccCampioneId" value="<%=((JSONObject) (jsonCampione.get("CampiServizio"))).get("idCampione")%>" />
    <jsp:param name="preaccEnteId" value="1" />
    <jsp:param name="preaccLaboratorioId" value="<%=((JSONObject) (jsonCampione.get("Laboratorio"))).get("id")%>" />
    <jsp:param name="preaccAnagraficaId" value="<%=((JSONObject) (jsonCampione.get("DatiGiornataIspettiva"))).get("riferimentoId")+"stabIdaia_stabilimento"+"%" +"999"%>" />
    <jsp:param name="preaccUserId" value="<%=User.getUserId() %>" />
</jsp:include>
  
<%@ include file="../verbali/elenco.jsp" %> 
  
<!-- RIEPILOGO -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">

<tr><th colspan="2"><center><b>Dettaglio CAMPIONE</b></center></th></tr>

<% if ( ((JSONObject) jsonCampione).has("DatiGiornataIspettiva")) { %>
<% JSONObject jsonGiornataIspettiva = (JSONObject) jsonCampione.get("DatiGiornataIspettiva"); %>
<tr><td class="formLabel">Id Giornata Ispettiva</td><td><%=jsonGiornataIspettiva.get("idGiornataIspettiva") %> <a href="GestioneGiornateIspettive.do?command=View&idGiornataIspettiva=<%=jsonGiornataIspettiva.get("idGiornataIspettiva")%>"><b>Torna alla Giornata Ispettiva</b></a></td></tr>
<tr><td class="formLabel">Dipartimento</td><td><%=jsonGiornataIspettiva.get("dipartimento") %> </td></tr>
<tr><td class="formLabel">Ragione Sociale</td><td><%=jsonGiornataIspettiva.get("ragioneSociale") %> </td></tr>
<%} %>

<% if ( ((JSONObject) jsonCampione).has("Dati")) { %>
<% JSONObject jsonDati = (JSONObject) jsonCampione.get("Dati"); %>
<tr><td class="formLabel">Numero verbale</td><td><%=jsonDati.get("numeroVerbale") %> </td></tr>
<tr><td class="formLabel">Data prelievo</td><td><%=fixData(jsonDati.get("dataPrelievo")) %></a></td></tr>
<tr><td class="formLabel">Note</td><td><%=jsonDati.get("note") %> </td></tr>
<%} %>

<% if ( ((JSONObject) jsonCampione).has("TipoAttivita")) { %>
<% JSONObject jsonTipoAttivita = (JSONObject) jsonCampione.get("TipoAttivita"); %>
<tr><td class="formLabel">Tipo Attivita'</td><td><%=jsonTipoAttivita.get("nome") %></a></td></tr>
<%} %>

<% if ( ((JSONObject) jsonCampione).has("ProgrammaCampionamentoCategoriaMerceologica")) { 
JSONArray jsonCategorie = (JSONArray) jsonCampione.get("ProgrammaCampionamentoCategoriaMerceologica");
if (jsonCategorie.length()>0) {%>
<tr><td class="formLabel">Programma campionamento e Categoria Merceologica/Matrice</td><td>
<% for (int i = 0; i<jsonCategorie.length(); i++) {
JSONObject jsonCategoria = (JSONObject) jsonCategorie.get(i);
%>
<%=jsonCategoria.get("nomeProgrammaCampionamentoMacrocategoria") %> -> <%=jsonCategoria.get("nomeProgrammaCampionamento") %> -> <%=jsonCategoria.get("nome") %><br/>
<% } %>
</td></tr>
<%} } %>

<% if ( ((JSONObject) jsonCampione).has("TipoAnalisi")) { 
JSONArray jsonTipiAnalisi = (JSONArray) jsonCampione.get("TipoAnalisi");
if (jsonTipiAnalisi.length()>0) {%>
<tr><td class="formLabel">Tipo Analisi</td><td>
<% for (int i = 0; i<jsonTipiAnalisi.length(); i++) {
JSONObject jsonTipoAnalisi = (JSONObject) jsonTipiAnalisi.get(i);
%>
<%=jsonTipoAnalisi.get("prodotto") %> -> <%=jsonTipoAnalisi.get("metodi") %> -> <%=jsonTipoAnalisi.get("prova") %><br/>
<% } %>
</td></tr>
<%} } %>

<% if ( ((JSONObject) jsonCampione).has("Laboratorio")) { %>
<% JSONObject jsonLaboratorio = (JSONObject) jsonCampione.get("Laboratorio"); %>
<tr><td class="formLabel">Laboratorio di destinazione</td><td><%=jsonLaboratorio.get("nome") %></a></td></tr>
<%} %>

<% if ( ((JSONObject) jsonCampione).has("GruppoIspettivo")) { 
JSONArray jsonGruppoIspettivo = (JSONArray) jsonCampione.get("GruppoIspettivo");
if (jsonGruppoIspettivo.length()>0) {%>
<tr><td class="formLabel">Gruppo Ispettivo </td><td>
<% 
for (int i = 0; i<jsonGruppoIspettivo.length(); i++) {
JSONObject jsonComponente = (JSONObject) jsonGruppoIspettivo.get(i);
%>
<%=jsonComponente.get("nominativo") %> (<b><%=jsonComponente.get("qualifica") %></b>) <%=jsonComponente.get("descrizioneAreaSemplice") %><br/><br/>
<% } %>
</td></tr>
<%} }%>

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







