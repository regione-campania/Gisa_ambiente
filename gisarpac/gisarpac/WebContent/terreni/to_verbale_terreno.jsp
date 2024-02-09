<%@ page import="java.util.ArrayList" %>
<%@ page import="org.aspcfs.modules.terreni.base.Terreno" %>
<%@ page import="org.aspcfs.modules.gestioneispettive.base.Componente" %>
<jsp:useBean id="Terreno" class="org.aspcfs.modules.terreni.base.Terreno" scope="request"/>
<% ArrayList<Componente> listaComponenti =  (ArrayList<Componente>)request.getAttribute("listaComponenti"); %>


<style>
.dettaglioTabella table {
 font-family: Calibri, sans-serif;
 font-size:14px;
 color:#000000;
}
.dettaglioTabella td {
 font-family: Calibri, sans-serif;
 font-size:14px;
 color:#000000;
}
.grey {
 background-color:#EBEBEB;
 border: 1px solid black;
}
.blue {
 background-color:#e6f3ff;
 border: 1px solid black;
 text-transform:uppercase;
 font-weight: bold;
 text-align: center;
}
.layout {
 border: 1px solid black;
 text-transform:uppercase;
}
</style>

<table class="dettaglioTabella" cellpadding="5" width="100%">
<tr><td class="blue" colspan="2">Dettaglio Terreno Controllato (<a href="Terreni.do?command=TerreniList">indietro</a>)</td></tr>
<tr>
	<td class="grey">ID Sito</td>
	<td class="layout"><%= Terreno.getId_sito() %></td>
</tr>
<tr>
	<td class="grey">Classe Rischio</td>
	<td class="layout"><%= Terreno.getClasse_rischio() %></td>
</tr>
<tr>
	<td class="grey">Comune</td>
	<td class="layout"><%= Terreno.getComune() %></td>
</tr>
<tr>
	<td class="grey">Foglio</td>
	<td class="layout"><%= Terreno.getFoglio() %></td>
</tr>
<tr>
	<td class="grey">Particella</td>
	<td class="layout"><%= Terreno.getParticella() %></td>
</tr>
<tr>
	<td class="grey">Parte</td>
	<td class="layout"><%= Terreno.getParte() %></td>
</tr>
<tr>
	<td class="grey">Area (mq)</td>
	<td class="layout"><%= Terreno.getArea() %></td>
</tr>
<tr>
	<td class="grey">Stato Sito</td>
	<td class="layout"><%= Terreno.getStato_sito() %></td>
</tr>
<tr>
	<td class="grey">Decreto Approvazione</td>
	<td class="layout"><%= Terreno.getDecreto_approvazione() %></td>
</tr>
</table>
<br>
<div align="center" style="border:1px solid; resize:vertical; width:100%; height:300px; overflow: auto;">
<table class="dettaglioTabella" cellpadding="5" width="99%">
<tr><td class="blue" colspan="4">Gruppo Ispettivo</td></tr>
<tr>
	<td class="blue">Qualifica</td>
	<td class="blue">Componente</td>
	<td class="blue">Struttura</td>
	<td class="blue">Seleziona</td>
</tr>
<% if(listaComponenti.size() > 0){ 
		for(Componente c : listaComponenti){
			
%>
		<tr>
			<td class="layout"><%= c.getNomeQualifica() %></td>			
			<td class="layout"><%= c.getNominativo() %></td>			
			<td class="layout"><%= c.getNomeStruttura() %></td>
			<td class="layout"><input type="checkbox" id="componente_<%= c.getId() %>" name="componente" value="<%= c.getNominativo() %>"/></td>		
		</tr>
<%
		}
	}
%>
</tr>
</table>
</div>
<br>
<form action="" id="form1" name="form1">
<table class="dettaglioTabella" cellpadding="5" width="100%">
<tr><td class="blue" colspan="2">Dati</td></tr>
<tr>
	<td class="grey">Data Verbale</td>
	<td class="layout"><input type="date" id="dataInizio" name="dataInizio"/></td>
	<script>
		document.getElementById("dataInizio").max = new Date().toISOString().split("T")[0];
		document.getElementById("dataInizio").value = new Date().toISOString().split("T")[0];
	</script>
</tr>
</table>

<input type="hidden" id="id_sito" name="id_sito" value="<%= Terreno.getId_sito()%>"/>
<input type="hidden" id="classe_rischio" name="classe_rischio" value="<%= Terreno.getClasse_rischio() %>"/>
<input type="hidden" id="comune" name="comune" value="<%= Terreno.getComune() %>"/>
<input type="hidden" id="foglio" name="foglio" value="<%= Terreno.getFoglio() %>"/>
<input type="hidden" id="particella" name="particella" value="<%= Terreno.getParticella() %>"/>
<input type="hidden" id="parte" name="parte" value="<%= Terreno.getParte() %>"/>
<input type="hidden" id="area" name="area" value="<%= Terreno.getArea() %>"/>
<input type="hidden" id="stato_sito" name="stato_sito" value="<%= Terreno.getStato_sito() %>"/>
<input type="hidden" id="decreto_approvazione" name="decreto_approvazione" value="<%= Terreno.getDecreto_approvazione() %>"/>
<input type="hidden" id="gruppoIspettivo" name="gruppoIspettivo" value=""/>

<br><input type="button" onclick="checkForm(this.form)" value="PROSEGUI"/>

</form>

<script>

function checkForm(form){ 
	var msg = "";
	var esito = true;
	var gruppoIspettivo = "";
	
	if (form.dataInizio.value==""){
		msg +="Selezionare la data inizio.\n";
		esito = false;	
	}
	
	$('input[name="componente"]:checked').each( function(){
		gruppoIspettivo += $(this).val()+";";
	});
	
	if(gruppoIspettivo != ""){
		$("#gruppoIspettivo").val(gruppoIspettivo);
	}else{
		msg += "Selezionare almeno un componente.\n";
		esito = false;
	}
	
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	//form.submit();
	
	var dataInizio = $("#dataInizio").val();
	var id_sito = $("#id_sito").val();
	var classe_rischio = $("#classe_rischio").val();
	var comune = $("#comune").val();
	var foglio = $("#foglio").val();
	var particella = $("#particella").val();
	var parte = $("#parte").val();
	var area = $("#area").val();
	var stato_sito = $("#stato_sito").val();
	var decreto_approvazione = $("#decreto_approvazione").val();
	var gruppoIspettivo = $("#gruppoIspettivo").val();
	
	window.open('Terreni.do?command=VerbaleTerreno&dataInizio='+dataInizio+'&id_sito='+id_sito+'&classe_rischio='+classe_rischio+'&comune='+comune+'&foglio='+foglio+'&particella='+particella+'&parte='+parte+'&area='+area+'&stato_sito='+stato_sito+'&decreto_approvazione='+decreto_approvazione+'&gruppoIspettivo='+gruppoIspettivo,'','popup,width=900,height=600');
}

</script>