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

<tr><th colspan="2"><center><b>Aggiunta FASCICOLO ISPETTIVO</b></center></th></tr>

<% if ( ((JSONObject) jsonFascicoloIspettivo).has("Anagrafica")) { %>
<% JSONObject jsonAnagrafica = (JSONObject) jsonFascicoloIspettivo.get("Anagrafica"); %>
<tr><td class="formLabel">Anagrafica</td><td><%=jsonAnagrafica.get("ragioneSociale") %> (<%=jsonAnagrafica.get("partitaIva") %>) <a href="StabilimentoAIA.do?command=Details&stabId=<%=jsonAnagrafica.get("riferimentoId")%>"><b>Torna all'anagrafica</b></a></td></tr>
<%} %>


<% if ( ((JSONObject) jsonFascicoloIspettivo).has("Dati")) { %>
<% JSONObject jsonDati = (JSONObject) jsonFascicoloIspettivo.get("Dati");
if (jsonDati.length()>0) {%>
<tr><td class="formLabel">Numero</td><td><%=jsonDati.get("numero")%></td></tr>
<tr><td class="formLabel">Data inizio </td><td><%=fixData(jsonDati.get("dataInizio"))%></td></tr>
<%} } %>


</table>
<!-- RIEPILOGO -->

<%if ( (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si"))) {%>
<%@ include file="../../util/random.jsp" %>
<%} %>


