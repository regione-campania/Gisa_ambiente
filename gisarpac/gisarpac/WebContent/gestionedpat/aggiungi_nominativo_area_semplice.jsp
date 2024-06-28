<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="ListaDipartimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DettaglioAreaSemplice" class="org.aspcfs.modules.gestionedpat.base.AreaSemplice" scope="request"/>
<jsp:useBean id="DettaglioAreaComplessa" class="org.aspcfs.modules.gestionedpat.base.AreaComplessa" scope="request"/>
<jsp:useBean id="ListaNominativi" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestionedpat.base.*" %>

<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>
<DIV ID='modalWindow' CLASS='unlocked'><P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV>

<script>
function annulla(){
	if (confirm("Annullare l'operazione?")){
		window.close();
	}
}

function inserisci(form){
	var esito = true;
	var msg = '';
	var almenoUno = false;
	
	var x = document.getElementsByName("idNominativo")
		for (var i = 0; i<x.length; i++){
			if (x[i].checked){
				almenoUno = true;
				break;
			}
		}
		
	if (!almenoUno){
		msg+= "Selezionare almeno un nominativo. \n";
		esito = false;
	}
	if (!esito){
		alert(msg);
		return false;
		}

	if (confirm("I nominativi selezionati saranno inseriti sull'area semplice. Continuare?")){
		loadModalWindow();
		form.submit();
	}	
}

</script>

<%-- <h2><%=DettaglioAreaComplessa.getAnno() %> / <%=ListaDipartimenti.getSelectedValue(DettaglioAreaComplessa.getIdDipartimento()) %> / <%= DettaglioAreaComplessa.getNome() %> / <%=DettaglioAreaSemplice.getNome() %></h2> --%>

<h3>AGGIUNGI NOMINATIVO</h3>

<form name="addAccount"	action="GestioneDPAT.do?command=InserisciNominativoAreaSemplice&auto-populate=true" method="post">
<input type="hidden" id="idAreaSemplice" name="idAreaSemplice" value="<%=DettaglioAreaSemplice.getId()%>"/>

<table class="details" width="100%" cellpadding="10" cellspacing="10" style="border-collapse: collapse">
<col width="10%"><col width="40%">
<tr>
<th></th><th>Nominativo</th><th>Qualifica</th></tr>

<% for (int i = 0; i<ListaNominativi.size(); i++) {
Nominativo n = (Nominativo) ListaNominativi.get(i);%>

<tr>
<td><input type="checkbox" id= "idNominativo_<%=n.getId() %>" name="idNominativo" value="<%=n.getId() %>"/></td>
<td><%=n.getNome() %></td>
<td><%=n.getQualifica() %></td>
</tr>

<% } %>
<tr><td colspan="3">
<input type="button" value="annulla" onClick="annulla()" style="font-size: 20px"/>
&nbsp;&nbsp; &nbsp; &nbsp;  
<input type="button" value="inserisci" onClick="inserisci(this.form)" style="font-size: 20px"/>
</td>
</table>
</form>