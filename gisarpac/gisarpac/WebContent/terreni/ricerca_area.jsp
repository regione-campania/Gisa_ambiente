<%@ page import="java.util.ArrayList" %>
<%@ page import="org.aspcfs.modules.gestioneanagrafica.base.Provincia" %>
<%@ page import="org.aspcfs.modules.gestioneanagrafica.base.Comune" %>
<% ArrayList<Provincia> province =  (ArrayList<Provincia>)request.getAttribute("province"); %>
<% ArrayList<Comune> comuni =  (ArrayList<Comune>)request.getAttribute("comuni"); %>


<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Terreni.do?command=toSearchArea">Terra dei fuochi</a>
</td>
</tr>
</table>
<br/>

<form action="Terreni.do?command=SearchArea" method="post">
<table class="details" width="100%" cellpadding="5">
<tr><th colspan="2">DATI AREA</th></tr>
<tr>
	<td class="formLabel">Codice Sito</td>
	<td><input type="text" id="codiceSito" name="codiceSito"/></td>
</tr>
<tr>
	<td class="formLabel">PROVINCIA</td>
	<td>	
		<select id="idProvincia" name="idProvincia" onchange="settaComuni()">
		<option value="-1">-- SELEZIONA --</option>
		<% for(int i=0; i<province.size();i++){ %>
			<option value="<%= province.get(i).getCode() %>"><%= province.get(i).getDescription() %> </option>
		<% } %>
		</select>
	</td>
</tr>
<tr>
	<td class="formLabel">COMUNE</td>
	<td>	
		<select id="idComune" name="idComune">
		<option value="-1">-- SELEZIONA --</option>
		<% for(int i=0; i<comuni.size();i++){ %>
			<option cod_provincia="<%= comuni.get(i).getCod_provincia() %>" value="<%= comuni.get(i).getCode() %>"><%= comuni.get(i).getNome() %> </option>
		<% } %>
		</select>
	</td>
</tr>

</table>
<br><input type="submit" value="RICERCA" />
</form>

<script>

function settaComuni(){
	var prov = $("#idProvincia").val();
	$("#idComune option[cod_provincia!=0"+prov+"]").hide();
	$("#idComune option[cod_provincia=0"+prov+"]").show();
	$("#idComune option[value=-1]").show();
	$("#idComune").val(-1);
	
}
</script>