<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaMotivi" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*" %>

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
	var radios = document.getElementsByName("motivoId");
    for (var i = 0, len = radios.length; i < len; i++) {
         if (radios[i].checked) {
        	 almenoUnRadio = true;
          }
     }
	
	if (!almenoUnRadio){
		msg+= "Selezionare una motivo.";
		esito = false;
	}
	
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.submit();
}


function filtraRigheMotivi() {
	
	  // Declare variables
	  var table = document.getElementById("tableMotivi");
	  var input1 = document.getElementById("myInputMotivo");

	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter1 = input1.value.toUpperCase();
	  
	  tr = table.getElementsByTagName("tr");

	  // Loop through all table rows, and hide those who don't match the search query
	  for (i = 0; i < tr.length; i++) {
	    td0 = tr[i].getElementsByTagName("td")[0];
	    td1 = tr[i].getElementsByTagName("td")[1];
	    
	    if (td0) {
	      txtValue0 = td0.textContent || td0.innerText;
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

<form name="aggiungiCampione" action="GestioneCampioni.do?command=AddDatiParticella&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogoParticella.jsp"%>
<!-- RIEPILOGO -->

<br/>
<table class="details" id="tableMotivi" name="tableMotivi" cellpadding="10" cellspacing="10" width="100%">
<col width="5%"/>

<tr>
<th colspan="2"><center><b>MOTIVO CAMPIONAMENTO SUBPARTICELLA</b></center></th>
</tr>

<tr>
<th>Seleziona</th>
<th><input type="text" id="myInputMotivo" onkeyup="filtraRigheMotivi()" placeholder="FILTRA MOTIVO" style="width: 100%"></th>
</tr>

<%for (int i = 0; i<ListaMotivi.size(); i++){
	MotivoCampionamentoParticella mot = (MotivoCampionamentoParticella) ListaMotivi.get(i);%>
	<tr>
	<td>
	<input type="radio" id="motivoId_<%=i %>" name="motivoId" value="<%=mot.getId()%>" <%=mot.getDescrizione().toLowerCase().contains("acque") ? "disabled" : "checked" %>/> 
	<input type="hidden" id="motivoDescrizione_<%=mot.getId()%>" name="motivoDescrizione_<%=mot.getId()%>" value="<%=mot.getDescrizione() %>"/> 
	</td>
	<td><%=mot.getDescrizione() %> <%=mot.getDescrizione().toLowerCase().contains("acque") ? "<font color='red'>Non attualmente disponibile</font>" : "" %></td>	
	</tr>
	<% } %>
</table>

<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center">
<input type="button" style="font-size:40px" value="PROSEGUI" onclick="checkForm(this.form)"/>
</td>
</tr>
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

