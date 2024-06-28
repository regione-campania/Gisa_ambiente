<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="area" class="org.aspcfs.modules.terreni.base.Area" scope="request"/>

<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>

<script>

function validaNumeri(s) {
	 s.value = s.value.replace(/[^0-9]/g, '');
}

function verificaEsistenzaCodice(codice){
	document.getElementById("loadingCodice").style.display = "block";
	PopolaCombo.verificaEsistenzaCodiceSitoParticella(codice, -1, {callback:verificaEsistenzaCodiceCallback,async:false });
}
function verificaEsistenzaCodiceCallback(value)
{
if (value)
	{
		 alert("Attenzione. Il codice ottenuto risulta già assegnato a un'altra area.");
		 document.getElementById("codiceSito").value = "";
		 //document.getElementById("numeroSito").value = "";
	}

	document.getElementById("loadingCodice").style.display = "none";

}

function gestisciCodiceSito(){
	
	var codiceSitoArea = document.getElementById("codiceSitoArea").value;
	var letteraSito = document.getElementById("letteraSito").value;
	//var numeroSito = document.getElementById("numeroSito").value;
	var codiceSito = codiceSitoArea + letteraSito;
	document.getElementById("codiceSito").value = codiceSito;
	verificaEsistenzaCodice(codiceSito);
	
}
</script>



<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Terreni.do?command=toSearchArea">Terra dei fuochi</a> > 
<a href="Terreni.do?command=DetailsArea&id=<%=area.getId()%>">Dettaglio Area</a> > 
Aggiungi Subparticella
</td>
</tr>
</table>
<br/>

<form action="Terreni.do?command=InsertSubparticella" method="post">

<table class="details" width="100%" cellpadding="5">
<col width="10%">

<tr><th colspan="2">DATI AREA</th></tr>
<tr>
	<td class="formLabel">Codice Sito</td>
	<td><%= area.getCodiceSito() %></td>
</tr>
<tr>
	<td class="formLabel">DATI CATASTALI</td>
	<td>FOGLIO <%= area.getFoglioCatastale() %> - PARTICELLA <%= area.getParticellaCatastale() %></td>
</tr>
<tr>
	<td class="formLabel">AREA (mq)</td>
	<td><%= area.getArea() %></td>
</tr>

</table>

<br>

<table class="details" width="100%" cellpadding="5">
<col width="10%">

<tr><th colspan="2">DATI SUBPARTICELLA</th></tr>
<tr>
	<td class="formLabel">Codice Sito</td>
	<td>
	<input type="text" readonly id="codiceSitoArea" name="codiceSitoArea" value="<%=area.getCodiceSito()%>" style="background: lightgray" size="<%=area.getCodiceSito().length()%>"/> 
	
	<%String alfabeto = "ABCDEFGHILMNOPQRSTUVZ"; %>
	<select id="letteraSito" name="letteraSito" onChange="gestisciCodiceSito()">
	<%for (int i = 0; i<alfabeto.length(); i++){ %>
	<option value="<%=alfabeto.charAt(i)%>"><%=alfabeto.charAt(i)%></option>
	<%} %>
	
	</select>
<!-- 	<input type="text" id="numeroSito" name="numeroSito" onChange="gestisciCodiceSito()" onKeyUp="validaNumeri(this)" size="3" maxlength="3"/>  -->
	
	<input type="hidden" id="codiceSito" name="codiceSito"/> <div id="loadingCodice" style="display:none"><img src="images/loadingmw.gif" width="50px"/></div></td>
</tr>

</table>
<input type="hidden" id="idArea" name="idArea" value="<%=area.getId()%>"/>
<br>

<input type="button" value="ANNULLA" onclick="loadModalWindow(); window.location.href='Terreni.do?command=DetailsArea&id=<%=area.getId()%>'" />

<input type="button" value="INSERISCI" onclick="checkForm(this.form)" />
</form>

<script>

function checkForm(form){ 
	
		gestisciCodiceSito();
		
		var msg = "Attenzione! La form non puo' essere salvate per i seguenti motivi:\n\n";
		var esito = true;
		
		if (form.codiceSito.value==""){
			msg +="Indicare Codice Sito.\n";
			esito = false;	
		}
	
		if (!esito){
			alert(msg);
			return false;
		}
		
		loadModalWindow();
		form.submit();
}

</script>