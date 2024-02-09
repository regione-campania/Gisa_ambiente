<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaProgrammiCampionamentoCategorieMerceologiche" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>

function backForm(form){
	form.action="GestioneCampioni.do?command=AddTipoAttivita";
	loadModalWindow();
	form.submit();
}

function checkForm(form){
	
	var esito = true;
	var msg = '';
	
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
	
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.submit();
}


function filtraRighe() {
	  // Declare variables
	  var table = document.getElementById("tableProgrammiCampionamentoCategorieMerceologiche");
	  var input0 = document.getElementById("myInputProgrammaMacrocategoria");
	  var input1 = document.getElementById("myInputProgramma");
	  var input2 = document.getElementById("myInputCategoria");
	  
	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter0 = input0.value.toUpperCase();
	  filter1 = input1.value.toUpperCase();
	  filter2 = input2.value.toUpperCase();

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

	      if (txtValue0.toUpperCase().indexOf(filter0) > -1 && txtValue1.toUpperCase().indexOf(filter1) > -1 && txtValue2.toUpperCase().indexOf(filter2) > -1) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
	}


</script>

<form name="aggiungiCampione" action="GestioneCampioni.do?command=AddTipoAnalisi&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>

<table class="details" id ="tableProgrammiCampionamentoCategorieMerceologiche" name="tableProgrammiCampionamentoCategorieMerceologiche" cellpadding="10" cellspacing="10" width="70%" style="border-collapse: collapse">
<tr>
<th>Macrocategoria Programma Campionamento</th>
<th>Programma Campionamento</th>
<th>Categoria Merceologica / Matrice</th>
<th></th>
</tr>

<tr>
<th><input type="text" id="myInputProgrammaMacrocategoria" onkeyup="filtraRighe()" placeholder="FILTRA MACROCATEGORIA" style="width: 100%"></th>
<th><input type="text" id="myInputProgramma" onkeyup="filtraRighe()" placeholder="FILTRA PROGRAMMA" style="width: 100%"></th>
<th><input type="text" id="myInputCategoria" onkeyup="filtraRighe()" placeholder="FILTRA CATEGORIA MERCEOLOGICA/MATRICE" style="width: 100%"></th>
<th></th>
</tr>

<% 
for (int i = 0; i<ListaProgrammiCampionamentoCategorieMerceologiche.size(); i++) {
	ProgrammaCampionamentoCategoriaMerceologica cat = (ProgrammaCampionamentoCategoriaMerceologica) ListaProgrammiCampionamentoCategorieMerceologiche.get(i); %>

<tr>

<td><%=cat.getNomeProgrammaCampionamentoMacrocategoria() %></td>
<td><%=cat.getNomeProgrammaCampionamento() %></td>
<td><%=cat.getCategoriaMerceologica() %></td>
<td>
<input type="hidden" readonly id ="programmaCampionamentoMacrocategoriaNome_<%= cat.getCode()%>" name ="programmaCampionamentoMacrocategoriaNome_<%= cat.getCode()%>" value="<%= cat.getNomeProgrammaCampionamentoMacrocategoria() %>"/>
<input type="hidden" readonly id ="programmaCampionamentoNome_<%= cat.getCode()%>" name ="programmaCampionamentoNome_<%= cat.getCode()%>" value="<%= cat.getNomeProgrammaCampionamento() %>"/>
<input type="hidden" readonly id ="categoriaMerceologicaNome_<%= cat.getCode()%>" name ="categoriaMerceologicaNome_<%= cat.getCode()%>" value="<%= cat.getCategoriaMerceologica() %>"/>
<input type="checkbox" id ="<%= cat.getCode()%>" name="categoriaMerceologicaId" value="<%= cat.getCode()%>"/>
</td>

<% } %>

</table>	



<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr><td colspan="2" align="center"><br/><br/>
<input type="button" value="INDIETRO" onclick="backForm(this.form)" style="font-size:40px; background-color:red"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
