<%@ page import="java.util.ArrayList" %>
<%@ page import="org.aspcfs.modules.gestioneanagrafica.base.Provincia" %>
<%@ page import="org.aspcfs.modules.gestioneanagrafica.base.Comune" %>
<jsp:useBean id="area" class="org.aspcfs.modules.terreni.base.Area" scope="request"/>
<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>

<script>

function validaNumeri(s) {
	 s.value = s.value.replace(/[^0-9]/g, '');
}

function validaLettereNumeri(s) {
	 s.value = s.value.replace(/[\W_]+/g,"");
}

function verificaEsistenzaCodice(codice, id){
	document.getElementById("loadingCodice").style.display = "block";
	PopolaCombo.verificaEsistenzaCodiceSitoParticella(codice,id, {callback:verificaEsistenzaCodiceCallback,async:false });
}
function verificaEsistenzaCodiceCallback(value)
{
if (value)
	{
		 alert("Attenzione. Il codice ottenuto risulta già assegnato a un'altra area.");
		 document.getElementById("codiceSito").value = "<%=area.getCodiceSito()%>";
		 document.getElementById("idSito").value = "<%=area.getIdSito()%>";
		 document.getElementById("foglioCatastale").value = "<%=area.getFoglioCatastale()%>";
		 document.getElementById("particellaCatastale").value = "<%=area.getParticellaCatastale()%>";
	}

	document.getElementById("loadingCodice").style.display = "none";

}

function gestisciCodiceSito(){
	
	var idSito = document.getElementById("idSito").value;
	var foglioCatastale = document.getElementById("foglioCatastale").value;
	var particellaCatastale = document.getElementById("particellaCatastale").value;
	var codiceSito = idSito + "F" + foglioCatastale + "P" + particellaCatastale;
	document.getElementById("codiceSito").value = codiceSito;
	verificaEsistenzaCodice(codiceSito, <%=area.getId() %>);
	
}
</script>

<%@ include file="../../../terreni/util/coordinate.jsp"%>

<% ArrayList<Provincia> province =  (ArrayList<Provincia>)request.getAttribute("province"); %>
<% ArrayList<Comune> comuni =  (ArrayList<Comune>)request.getAttribute("comuni"); %>

<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Terreni.do?command=toSearchArea">Terra dei fuochi</a> > 
<a href="Terreni.do?command=DetailsArea&id=<%=area.getId()%>">Dettaglio Area</a> > 
Modifica
</td>
</tr>
</table>
<br/>

<form action="Terreni.do?command=UpdateArea" method="post">
<input type="hidden" id="id" name="id" value="<%= area.getId() %>" />
<table class="details" width="100%" cellpadding="5">
<col width="10%">
<tr><th colspan="2">DATI AREA</th></tr>
<tr>
	<td class="formLabel">Codice Sito</td>
	<td><input type="text" readonly id="codiceSito" name="codiceSito" style="background: lightgray" value="<%=area.getCodiceSito()%>"/> <div id="loadingCodice" style="display:none"><img src="images/loadingmw.gif" width="50px"/></div></td>
</tr>
<tr>
	<td class="formLabel">ID SITO</td>
	<td><input type="text" <%=area.getListaSubparticelle().size()>0 ? "readonly style='background: lightgray' " : "" %> id="idSito" name="idSito" onChange="gestisciCodiceSito()" value="<%=area.getIdSito()%>"/>
	<%=area.getListaSubparticelle().size()>0 ? "<font color= 'red'>In quest'area sono presenti subparticelle. Impossibile modificare elementi del Codice Sito.</font>" : "" %></td>
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
<tr>
	<td class="formLabel">DATI CATASTALI</td>
	<td><input type="text" <%=area.getListaSubparticelle().size()>0 ? "readonly style='background: lightgray' " : "" %> placeholder="FOGLIO" id="foglioCatastale" name="foglioCatastale" maxlength="3" onKeyUp="validaNumeri(this)" onChange="gestisciCodiceSito()" value="<%=area.getFoglioCatastale()%>"/>
	<input type="text" <%=area.getListaSubparticelle().size()>0 ? "readonly style='background: lightgray' " : ""%> placeholder="PARTICELLA" id="particellaCatastale" name="particellaCatastale" maxlength="6" onKeyUp="validaLettereNumeri(this)" onChange="gestisciCodiceSito()" value="<%=area.getParticellaCatastale()%>"/>
	<%=area.getListaSubparticelle().size()>0 ? "<font color= 'red'>In quest'area sono presenti subparticelle. Impossibile modificare elementi del Codice Sito.</font>" : "" %>
	</td>
</tr>
<tr>
	<td class="formLabel">CLASSE DI RISCHIO</td>
	<td><input type="text" id="classeRischio" name="classeRischio" value="<%=area.getClasseRischio()%>"/></td>
</tr>
<tr>
	<td class="formLabel">COORDINATE</td>
	<td>X <input type="text" placeholder="X" id="coordinateX" name="coordinateX" onKeyUp="validaCoordinate(this)" value="<%=area.getCoordinateX()%>"/> 
		Y <input type="text" placeholder="Y" id="coordinateY" name="coordinateY" onKeyUp="validaCoordinate(this)" value="<%=area.getCoordinateY()%>"/>
	</td>
</tr>
<tr>
	<td class="formLabel">AREA (mq)</td>
	<td><input type="text" id="area" name="area" onKeyUp="validaNumeri(this)" value="<%=area.getArea()%>"/></td>
</tr>
<tr>
	<td class="formLabel">NOTE</td>
	<td><textarea rows="5" cols="50" id="note" name="note"><%=area.getNote() %></textarea></td>
</tr>
</table>
<br>

<input type="button" value="ANNULLA" onclick="loadModalWindow(); window.location.href='Terreni.do?command=DetailsArea&id=<%=area.getId()%>'" />

<input type="button" value="AGGIORNA" onclick="checkForm(this.form)" />
</form>

<script>

$(document).ready( function(){
	$("#idProvincia").val("<%= area.getIdProvincia() %>");
	settaComuni();
	$("#idComune").val("<%= area.getIdComune() %>");
});

function checkForm(form){ 
	var msg = "Attenzione! La form non puo' essere salvate per i seguenti motivi:\n\n";
	var esito = true;
	
	if (form.codiceSito.value==""){
		msg +="Indicare Codice Sito.\n";
		esito = false;	
	}
	
	if (form.idProvincia.value==-1){
		msg +="Selezionare una Provincia.\n";
		esito = false;	
	}
	
	if (form.idComune.value==-1){
		msg +="Selezionare un Comune.\n";
		esito = false;	
	}
	
	if(form.foglioCatastale.value==""){
		msg +="Dati Catastali: Indicare Foglio.\n";
		esito = false;	
	}
	
	if(form.particellaCatastale.value==""){
		msg +="Dati Catastali: Indicare Particella.\n";
		esito = false;	
	}
	
	if(form.classeRischio.value==""){
		msg +="Indicare Classe di Rischio.\n";
		esito = false;	
	}
	
	if(form.coordinateX.value==""){
		msg +="Coordinate: Indicare Coordinata X.\n";
		esito = false;	
	}
	
	if(form.coordinateY.value==""){
		msg +="Coordinate: Indicare Coordinata Y.\n";
		esito = false;	
	}
	
	if (form.coordinateY.value < MIN_COORD_Y || form.coordinateY.value > MAX_COORD_Y){
		 msg += "Coordinate: Valore errato per il campo Coordinata Y, il valore deve essere compreso tra "+MIN_COORD_Y+" e "+MAX_COORD_Y +" \n";
		 esito = false;
	}
	if (form.coordinateX.value < MIN_COORD_X || form.coordinateX.value > MAX_COORD_X){
		 msg += "Coordinate: Valore errato per il campo Coordinata X, il valore deve essere compreso tra "+MIN_COORD_X+" e "+MAX_COORD_X +" \n";
		 esito = false;
	}
	
	if(form.area.value==""){
		msg +="Indicare Area.\n";
		esito = false;	
	}
		
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.submit();
}

function settaComuni(){
	var prov = $("#idProvincia").val();
	$("#idComune option[cod_provincia!=0"+prov+"]").hide();
	$("#idComune option[cod_provincia=0"+prov+"]").show();
	$("#idComune option[value=-1]").show();
	$("#idComune").val(-1);
	
}
</script>