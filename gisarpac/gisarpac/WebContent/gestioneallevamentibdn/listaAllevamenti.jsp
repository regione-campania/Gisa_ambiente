<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonAllevamenti" class="org.json.JSONObject" scope="request"/>

<%@ page import="org.json.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>


<script>
function checkForm(form, allevId){
	if (confirm("Attenzione. L'allevamento selezionato sara' importato nel sistema e verra' inserito (o aggiornato se gia' presente). Proseguire?")){
		loadModalWindow();
		form.allevId.value=allevId;
		form.submit();
	}
}
</script>

<form method="post" action = "GestioneAllevamentiBdn.do?command=ImportaDaBdn">
<input type="hidden" id="allevId" name="allevId"/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr><th colspan="8" align="center">DATI PRESENTI IN BDN</th></tr>

<tr> <th>Codice azienda</th> 
<th>Id fiscale</th> 
<th>Denominazione</th>
<th>Specie</th> 
<th>ASL</th> 
<th>Data inizio</io> 
<th>Data fine</th> 
<th></th>
</tr>

<%
JSONArray 	jsonAllevamentiArray = null;
JSONObject 	jsonAllevamentoObject = null;


if (jsonAllevamenti.has("ALLEVAMENTI")) {
	jsonAllevamentoObject = jsonAllevamenti.optJSONObject("ALLEVAMENTI");
	if (jsonAllevamentoObject == null) {
	 	jsonAllevamentiArray = jsonAllevamenti.optJSONArray("ALLEVAMENTI");
	}
}

int totAllevamenti = 0;
if (jsonAllevamentiArray!=null)
	totAllevamenti = jsonAllevamentiArray.length();
if (jsonAllevamentoObject!=null)
	totAllevamenti = 1;

for (int i = 0; i<totAllevamenti; i++) {
		
	if (jsonAllevamentiArray!=null)
		jsonAllevamentoObject = (JSONObject) jsonAllevamentiArray.get(i);
%>

			<tr>
			<td><%=jsonAllevamentoObject.get("AZIENDA_CODICE") %></td>
			<td><%=jsonAllevamentoObject.get("ID_FISCALE") %></td>
			<td><%=jsonAllevamentoObject.get("DENOMINAZIONE") %></td>
			<td><%=jsonAllevamentoObject.get("SPE_DESCRIZIONE") %></td>
			<td><%=jsonAllevamentoObject.get("DENOMINAZIONE_ASL") %></td>
			<td><%=jsonAllevamentoObject.get("DT_INIZIO_ATTIVITA") %></td>
			<td><%=jsonAllevamentoObject.has("DT_FINE_ATTIVITA") ? jsonAllevamentoObject.get("DT_FINE_ATTIVITA") : "" %></td> 
			<td> <% if (jsonAllevamentoObject.get("CODICE_ASL").toString().equalsIgnoreCase("B101")) { %><input type="button" value="importa in gisa" onClick="checkForm(this.form, '<%=jsonAllevamentoObject.get("ALLEV_ID")%>')" title="<%=jsonAllevamentoObject.get("ALLEV_ID")%>"/> (<%=jsonAllevamentoObject.get("ALLEV_ID")%>) <% } %></td>
			</tr>

<% } %>

<% if (totAllevamenti == 0)  {%>
<tr><td colspan="8">Non sono stati trovati allevamenti in BDN con i dati inseriti.</td></tr>
<% } %>

</table>
</form>

<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonAllevamenti" name="jsonAllevamenti" style="display:none"><%=jsonAllevamenti%></textarea>
<!--JSON -->


