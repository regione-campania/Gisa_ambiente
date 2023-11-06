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

<tr><th colspan="2"><center><b>Aggiunta NON CONFORMITA</b></center></th></tr>

<% if ( ((JSONObject) jsonNonConformita).has("DatiGiornataIspettiva")) { %>
<% JSONObject jsonDatiGiornataIspettiva = (JSONObject) jsonNonConformita.get("DatiGiornataIspettiva"); %>
<tr><td class="formLabel">Id Giornata Ispettiva</td><td><%=jsonDatiGiornataIspettiva.get("idGiornataIspettiva") %> <a href="GestioneGiornateIspettive.do?command=View&idGiornataIspettiva=<%=jsonDatiGiornataIspettiva.get("idGiornataIspettiva")%>"><b>Torna alla Giornata Ispettiva</b></a></td></tr>
<tr><td class="formLabel">Dipartimento</td><td><%=jsonDatiGiornataIspettiva.get("dipartimento") %> </td></tr>
<tr><td class="formLabel">Ragione Sociale</td><td><%=jsonDatiGiornataIspettiva.get("ragioneSociale") %> </td></tr>
<%} %>

<% if ( ((JSONObject) jsonNonConformita).has("Dati")) { %>
<% JSONObject jsonDati = (JSONObject) jsonNonConformita.get("Dati"); %>
<tr><td class="formLabel">Note</td><td><%=jsonDati.get("note") %> </td></tr>
<%} %>

<% if ( ((JSONObject) jsonNonConformita).has("TipoVerifica")) { %>
<% JSONObject jsonTipoVerifica = (JSONObject) jsonNonConformita.get("TipoVerifica"); %>
<tr><td class="formLabel">Tipo Verifica</td><td><%=jsonTipoVerifica.get("nome") %></a></td></tr>
<%} %>

<% if ( ((JSONObject) jsonNonConformita).has("Linea")) { %>
<% JSONObject jsonLinea = (JSONObject) jsonNonConformita.get("Linea"); %>
<tr><td class="formLabel">Linea</td><td><%=jsonLinea.get("nome") %></a></td></tr>
<%} %>

</table>
<!-- RIEPILOGO -->

