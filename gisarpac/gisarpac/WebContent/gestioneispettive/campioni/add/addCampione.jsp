<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaComponenti" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="ListaTipiAttivita" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="ListaProgrammiCampionamento" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="ListaCategorieMerceologiche" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="ListaTipiAnalisi" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
function checkForm(form){
	
	var esito = true;
	var msg = '';
	
	if (form.dataPrelievo.value==""){
		msg +="Selezionare la data prelievo.\n";
		esito = false;	
	}
	
	var almenoUnProgramma = false;
	
	var x = document.getElementsByName("programmaCampionamentoId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnProgramma = true;
		}
	}
	
	if (!almenoUnProgramma){
		msg +="Selezionare un programma di campionamento.\n"; 
		esito = false;
	}

	var almenoUnaCategoria = false;
	
	var x = document.getElementsByName("categoriaMerceologicaId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnaCategoria = true;
		}
	}
	
	if (!almenoUnaCategoria){
		msg +="Selezionare almeno una categoria merceologica.\n"; 
		esito = false;
	}
	
	var almenoUnAnalisi = false;
	
	var x = document.getElementsByName("tipoAnalisiId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnAnalisi = true;
		}
	}
	
	if (!almenoUnAnalisi){
		msg +="Selezionare almeno un tipo analisi.\n"; 
		esito = false;
	}
	
	
	var almenoUnComponente = false;
	
	var x = document.getElementsByName("componenteId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnComponente = true;
		}
	}
	
	if (!almenoUnComponente){
		msg +="Selezionare almeno un componente del gruppo ispettivo.\n"; 
		esito = false;
	}
	
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.submit();
}


function filtraRighe() {
	  // Declare variables
	  var table = document.getElementById("tableTipoAnalisi");
	  var input1 = document.getElementById("myInputLivello1");
	  var input2 = document.getElementById("myInputLivello2");
	  var input3 = document.getElementById("myInputLivello3");
	  
	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter1 = input1.value.toUpperCase();
	  filter2 = input2.value.toUpperCase();
	  filter3 = input3.value.toUpperCase();

	  tr = table.getElementsByTagName("tr");

	  // Loop through all table rows, and hide those who don't match the search query
	  for (i = 0; i < tr.length; i++) {
	    td0 = tr[i].getElementsByTagName("td")[0];
	    td1 = tr[i].getElementsByTagName("td")[1];
	    td2 = tr[i].getElementsByTagName("td")[2];
	    td3 = tr[i].getElementsByTagName("td")[3];

	    if (td0) {
	      txtValue0 = td0.textContent || td0.innerText;
	      txtValue1 = td1.textContent || td1.innerText;
	      txtValue2 = td2.textContent || td2.innerText;
	      txtValue3 = td3.textContent || td3.innerText;

	      if (txtValue1.toUpperCase().indexOf(filter1) > -1 && txtValue2.toUpperCase().indexOf(filter2) > -1 && txtValue3.toUpperCase().indexOf(filter3) > -1) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
	}


</script>

<form name="aggiungiCampione" action="GestioneCampioni.do?command=AddRiepilogo&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" cellpadding="10" cellspacing="10" width="100%" id="tableCampione">
<col width="20%">
<tr><th colspan="2"><center><b>DATI CAMPIONE</b></center></th></tr>

<tr><td class="formLabel">Numero verbale</td>
<td>
<input type="radio" checked onClick="return false()" id="numeroVerbaleId_1" name="numeroVerbaleId" value="1"/>
<input type="hidden" readonly id="numeroVerbaleNome_1" name="numeroVerbaleNome_1" value="GENERA"/>
AUTOMATICO
</td>
</tr>


<tr><td class="formLabel">Data prelievo</td>
<td><input type="date" id="dataPrelievo" name="dataPrelievo" /></td>
<script>document.getElementById("dataPrelievo").max = new Date().toISOString().split("T")[0];</script>
</tr>

<tr><td class="formLabel">Tipo attivita'</td>
<td>
<% 
for (int i = 0; i<ListaTipiAttivita.size(); i++) {
TipoAttivita tipo = (TipoAttivita) ListaTipiAttivita.get(i); %>

<input type="radio" id ="<%= tipo.getCode()%>" name="tipoAttivitaId" value="<%= tipo.getCode()%>" <%=tipo.getTipo().equalsIgnoreCase("Controllo") ? "checked" : "" %>/>
<input type="hidden" readonly id ="tipoAttivitaNome_<%= tipo.getCode()%>" name ="tipoAttivitaNome_<%= tipo.getCode()%>" value="<%= tipo.getTipo() %>"/>
<%= tipo.getTipo() %> 
<% } %>
</td></tr>

<tr><td class="formLabel">Programma campionamento</td>
<td>
<% 
for (int i = 0; i<ListaProgrammiCampionamento.size(); i++) {
ProgrammaCampionamento programma = (ProgrammaCampionamento) ListaProgrammiCampionamento.get(i); %>

<input type="checkbox" id ="<%= programma.getCode()%>" name="programmaCampionamentoId" value="<%= programma.getCode()%>"/>
<input type="hidden" readonly id ="programmaCampionamentoNome_<%= programma.getCode()%>" name ="programmaCampionamentoNome_<%= programma.getCode()%>" value="<%= programma.getProgramma() %>"/>
<%= programma.getProgramma() %> <br/>
<% } %>
</td></tr>

<tr><td class="formLabel">Categoria merceologica</td>
<td>
<% 
for (int i = 0; i<ListaCategorieMerceologiche.size(); i++) {
CategoriaMerceologica categoria = (CategoriaMerceologica) ListaCategorieMerceologiche.get(i); %>

<input type="checkbox" id ="<%= categoria.getCode()%>" name="categoriaMerceologicaId" value="<%= categoria.getCode()%>"/>
<input type="hidden" readonly id ="categoriaMerceologicaNome_<%= categoria.getCode()%>" name ="categoriaMerceologicaNome_<%= categoria.getCode()%>" value="<%= categoria.getCategoria() %>"/>
<%= categoria.getCategoria() %> <br/>
<% } %>
</td></tr>

<tr><td class="formLabel">Tipo analisi</td>
<td>

<a href="#" onClick="document.getElementById('divTipoAnalisi').style.display='table-row'; return false;">Mostra lista</a><br/>
<div id="divTipoAnalisi" style="display:none">
<br/><a href="#" onClick="document.getElementById('divTipoAnalisi').style.display='none'; return false;">Nascondi lista</a><br/>

<table class="details" id ="tableTipoAnalisi" name="tableTipoAnalisi" cellpadding="10" cellspacing="10" width="70%" style="border-collapse: collapse">
<tr><th colspan="4"><center><b>TIPO ANALISI</b></center></th></tr>

<tr>
<th></th>
<th>Livello 1</th>
<th>Livello 2</th>
<th>Livello 3</th>
</tr>

<tr>
<th></th>
<th><input type="text" id="myInputLivello1" onkeyup="filtraRighe()" placeholder="FILTRA LIVELLO 1" style="width: 100%"></th>
<th><input type="text" id="myInputLivello2" onkeyup="filtraRighe()" placeholder="FILTRA LIVELLO 2" style="width: 100%"></th>
<th><input type="text" id="myInputLivello3" onkeyup="filtraRighe()" placeholder="FILTRA LIVELLO 3" style="width: 100%"></th>
</tr>

<% 
for (int i = 0; i<ListaTipiAnalisi.size(); i++) {
TipoAnalisi tipo = (TipoAnalisi) ListaTipiAnalisi.get(i); %>

<tr>
<td>
<input type="checkbox" id ="<%= tipo.getId()%>" name="tipoAnalisiId" value="<%= tipo.getId()%>"/>
<input type="hidden" readonly id ="tipoAnalisiLivello1_<%= tipo.getId()%>" name ="tipoAnalisiLivello1_<%= tipo.getId()%>" value="<%= tipo.getLivello1() %>"/>
<input type="hidden" readonly id ="tipoAnalisiLivello2_<%= tipo.getId()%>" name ="tipoAnalisiLivello2_<%= tipo.getId()%>" value="<%= tipo.getLivello2() %>"/>
<input type="hidden" readonly id ="tipoAnalisiLivello3_<%= tipo.getId()%>" name ="tipoAnalisiLivello3_<%= tipo.getId()%>" value="<%= tipo.getLivello3() %>"/>
</td>

<td><%=tipo.getLivello1() %></td>
<td><%=tipo.getLivello2() %></td>
<td><%=tipo.getLivello3() %></td>

<% } %>

</table>	

<a href="#" onClick="document.getElementById('divTipoAnalisi').style.display='none';return false;">Nascondi lista</a>
</div>

</td></tr>

<tr><td class="formLabel">Laboratorio di destinazione</td>
<td>
<input type="radio" checked onClick="return false()" id="laboratorioId_1" name="laboratorioId" value="1"/>
<input type="hidden" readonly id="laboratorioNome_1" name="laboratorioNome_1" value="ARPAC"/>
ARPAC
</td></tr>


<tr><td class="formLabel">Note</td>
<td>
<input type="text" id="note" name="note"size="50"/>
</td></tr>

<tr><td class="formLabel">Gruppo Ispettivo</td>
<td>

<% 
for (int i = 0; i<ListaComponenti.size(); i++) {
Componente comp = (Componente) ListaComponenti.get(i); %>

<input type="checkbox" id ="<%= comp.getId()%>" name="componenteId" value="<%= comp.getId()%>"/>
<input type="hidden" readonly id ="componenteNome_<%= comp.getId()%>" name ="componenteNome_<%= comp.getId()%>" value="<%= comp.getNominativo() %>"/>
<input type="hidden" readonly id ="componenteQualifica_<%= comp.getId()%>" name ="componenteQualifica_<%= comp.getId()%>" value="<%= comp.getNomeQualifica() %>"/>
<input type="hidden" readonly id ="componenteStruttura_<%= comp.getId()%>" name ="componenteStruttura_<%= comp.getId()%>" value="<%= comp.getNomeStruttura() %>"/>
<input type="hidden" readonly id ="componenteStrutturaId_<%= comp.getId()%>" name ="componenteStrutturaId_<%= comp.getId()%>" value="<%= comp.getIdStruttura() %>"/>
<%= comp.getNominativo() %> (<b><%= comp.getNomeQualifica() %></b>) <%= comp.getNomeStruttura() %><br/><br/> 
<% } %>

</td></tr>


</table>


<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr><td colspan="2" align="center"><br/><br/>
<input type="button" style="font-size:40px" value="PROSEGUI" onclick="checkForm(this.form)"/></td></tr>
</table>
<!-- BOTTONI -->

</center>

<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonCampione" name="jsonCampione" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonCampione%></textarea>
<!--JSON -->

</form>

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
