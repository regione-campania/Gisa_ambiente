<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="listaDati" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="riferimentoId" class="java.lang.String" scope="request"/>
<jsp:useBean id="riferimentoIdNomeTab" class="java.lang.String" scope="request"/>
<jsp:useBean id="autorizzazioniList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="matriciList" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="Messaggio" class="java.lang.String" scope="request"/>

<%@ page import="org.aspcfs.modules.gestionedatiautorizzativi.base.*"%>
<%@ page import="org.aspcfs.utils.web.*"%>

<%@ include file="../initPage.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>


<% if (Messaggio!=null && !Messaggio.equals("")){ %>
<script>
alert('<%=Messaggio%>');

<% if (riferimentoIdNomeTab.equalsIgnoreCase("aia_stabilimento")){%>
window.opener.location.href="StabilimentoAIA.do?command=Details&stabId=<%=riferimentoId%>";
<% } %>

window.close();

</script>
<% } %>

<script>
function checkForm(form){
	
	var msg = '';
	
	var idAias = [];
	
	var maxIndice = form.maxIndice.value;
	for (var i = 0; i<maxIndice; i++){
		var trDato = document.getElementById("trDato_"+i);
		var idAia = document.getElementById("idAia_"+i);
		
		if (trDato.style.display!="none"){ 
			if (idAia.value==''){
				alert('Attenzione. Un ID AIA risulta vuoto. Impossibile proseguire.');
				return false;
			}
		
			if (idAias.includes(idAia.value))
			{
				//alert('Attenzione. Un ID AIA risulta ('+idAia.value+') duplicato. Impossibile proseguire.');
				//return false;
			}
			else
				idAias.push(idAia.value);
		}
		
	}
	
	if (confirm("Confermare i dati indicati?")) {	
		loadModalWindow();
		form.submit();
	}
}


function mostraNascondiRiga(op){
	
	if (op=='Aggiungi'){
		document.getElementById("trDato_<%=listaDati.size() %>").style.display="table-row"; 
		document.getElementById("buttonAggiungi").style.display="none";
		document.getElementById("buttonRimuovi").style.display="table-row";
	}
	else if (op=='Rimuovi'){
		document.getElementById("trDato_<%=listaDati.size() %>").style.display="none"; 
		document.getElementById("buttonAggiungi").style.display="table-row";
		document.getElementById("buttonRimuovi").style.display="none";
		document.getElementById("idAia_<%=listaDati.size() %>").value="";
		document.getElementById("idAutorizzazione_<%=listaDati.size() %>").value="1";
		document.getElementById("numeroDecreto_<%=listaDati.size() %>").value="";
		document.getElementById("dataDecreto_<%=listaDati.size() %>").value="";
		document.getElementById("nota_<%=listaDati.size() %>").value="";
		document.getElementById("burc_<%=listaDati.size() %>").value="";
		
		<% for (int p = 0; p<matriciList.size(); p++) {
			LookupElement m = (LookupElement) matriciList.get(p); %>
			document.getElementById("matriceId_<%=listaDati.size() %>_<%=p%>").checked=false;
			<% } %>

	}
	
}
	

</script>

<form name="aggiungiDatoAutorizzativo" action="GestioneDatiAutorizzativi.do?command=Upsert&auto-populate=true" onSubmit="" method="post">

<table class="details" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<tr>
<th>ID AIA</th>
<th>AUTORIZZAZIONE</th>
<th>DECRETO DIRIGENZIALE NUMERO</th>
<th>DECRETO DIRIGENZIALE DATA</th>
<th>NOTA</th>
<th>BURC</th>
</tr>

<% for (int i = 0; i<listaDati.size(); i++) {
DatoAutorizzativo dato = (DatoAutorizzativo) listaDati.get(i);%>
<tr id="trDato_<%=i%>">
<td><input type="text" id="idAia_<%=i %>" name="idAia_<%=i %>" value="<%=toHtml(dato.getIdAia())%>"/></td>
<td><%=autorizzazioniList.getHtmlSelect("idAutorizzazione_"+i, dato.getIdAutorizzazione()) %></td>
<td><input type="text" id="numeroDecreto_<%=i %>" name="numeroDecreto_<%=i %>" value="<%=toHtml(dato.getNumeroDecreto())%>"/></td>
<td><input type="date" id="dataDecreto_<%=i %>" name="dataDecreto_<%=i %>" value="<%=dato.getDataDecreto()%>"/></td>
<td><input type="text" id="nota_<%=i %>" name="nota_<%=i %>" value="<%=toHtml(dato.getNota())%>"/></td>
<td><input type="text" id="burc_<%=i %>" name="burc_<%=i %>" value="<%=toHtml(dato.getBurc())%>"/></td>

</td>
</tr>

<%} %>

<tr><td colspan="8">
<input type="button" id="buttonAggiungi" value="Aggiungi Nuovo Decreto" onClick="mostraNascondiRiga('Aggiungi')"/>
<input type="button" id="buttonRimuovi" value="Rimuovi Nuovo Decreto" style="display:none" onClick="mostraNascondiRiga('Rimuovi')"/>
</td></tr>

<% for (int i = listaDati.size(); i<listaDati.size()+1; i++) {
%>
<tr style="display:none" id="trDato_<%=listaDati.size()%>">
<td><input type="text" id="idAia_<%=i %>" name="idAia_<%=i %>" value=""/></td>
<td><%=autorizzazioniList.getHtmlSelect("idAutorizzazione_"+i, -1) %></td>
<td><input type="text" id="numeroDecreto_<%=i %>" name="numeroDecreto_<%=i %>" value=""/></td>
<td><input type="date" id="dataDecreto_<%=i %>" name="dataDecreto_<%=i %>" value=""/></td>
<td><input type="text" id="nota_<%=i %>" name="nota_<%=i %>" value=""/></td>
<td><input type="text" id="burc_<%=i %>" name="burc_<%=i %>" value=""/></td>

</tr>

<%} %>
</table>

<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><br/><br/>
<input type="button" style="font-size:40px" value="CONFERMA" onclick="checkForm(this.form)"/>
</td>
</tr>
</table>
<!-- BOTTONI -->

</center>

<input type="hidden" id="riferimentoId" name="riferimentoId" value="<%=riferimentoId%>"/>
<input type="hidden" id="riferimentoIdNomeTab" name="riferimentoIdNomeTab" value="<%=riferimentoIdNomeTab%>"/>

<input type="hidden" id="maxIndice" name="maxIndice" value="<%=listaDati.size()+1%>"/>

</form>

