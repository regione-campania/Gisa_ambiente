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

<tr><th colspan="2"><center><b>Aggiunta CAMPIONE</b></center></th></tr>

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
<%=jsonTipoAnalisi.get("livello1") %> -> <%=jsonTipoAnalisi.get("livello2") %> -> <%=jsonTipoAnalisi.get("livello3") %><br/>
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
<%=jsonComponente.get("nominativo") %> (<b><%=jsonComponente.get("qualifica") %></b>) <%=jsonComponente.get("struttura") %><br/><br/>
<% } %>
</td></tr>
<%} }%>


</table>
<!-- RIEPILOGO -->

