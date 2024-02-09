<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonGiornataIspettiva" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaDipartimenti" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
function checkForm(form){
	
	var esito = true;
	var msg = '';
	
	var almenoUnRadio = false;
	var radios = document.getElementsByName("dipartimentoId");
    for (var i = 0, len = radios.length; i < len; i++) {
         if (radios[i].checked) {
        	 almenoUnRadio = true;
          }
     }
	
	if (!almenoUnRadio){
		msg+= "Selezionare un dipartimento.";
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
	var table = document.getElementById("tableDipartimenti");
	var input1 = document.getElementById("myInputDipartimento");
	
	 var input, filter, tr, td, i, txtValue;
	  
	 filter1 = input1.value.toUpperCase();
	  
	 tr = table.getElementsByTagName("tr");

	  // Loop through all table rows, and hide those who don't match the search query
	  for (i = 0; i < tr.length; i++) {
	    td1 = tr[i].getElementsByTagName("td")[1];
	    
	    if (td1) {
	      txtValue1 = td1.textContent || td1.innerText;
	      
	      if (txtValue1.toUpperCase().indexOf(filter1) > -1 ) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
	}

</script>

<form name="aggiungiCU" action="GestioneGiornateIspettive.do?command=AddTecnica&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogo.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" cellpadding="10" cellspacing="10" width="100%" id="tableDipartimenti">
<col width="5%">
<tr><th colspan="2"><center><b>DIPARTIMENTO</b></center></th></tr>
<tr>

<th>Seleziona</th>
<th><input type="text" id="myInputDipartimento" onkeyup="filtraRighe()" placeholder="FILTRA DIPARTIMENTO" style="width: 100%"></th>
</tr>

<%for (int i = 0; i<ListaDipartimenti.size(); i++){
	Dipartimento dip = (Dipartimento) ListaDipartimenti.get(i);
%>
<tr><td align="right"><input type="radio" id="dipartimentoId_<%=dip.getId() %>" name="dipartimentoId" value="<%=dip.getId()%>"  <%=ListaDipartimenti.size()==1 ? "checked='checked'" : "" %>/></td><td><%=dip.getNome() %> <input type="hidden" readonly id="dipartimentoNome_<%=dip.getId()%>" name="dipartimentoNome_<%=dip.getId()%>" value="<%=dip.getNome()%>"/></td></tr>
<%} %>
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
<textarea rows="10" cols="200" readonly id="jsonGiornataIspettiva" name="jsonGiornataIspettiva" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonGiornataIspettiva%></textarea>
<!--JSON -->

</form>

<script>
function prettyPrint() {
    var ugly = document.getElementById('jsonGiornataIspettiva').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonGiornataIspettiva').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonGiornataIspettiva").get(0).scrollHeight;
$("#jsonGiornataIspettiva").css('height', scroll_height + 'px');
</script>
