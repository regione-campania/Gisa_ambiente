
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.checklist_sorveglianza.base.*" %>
<jsp:useBean id="Istanza" class="org.aspcfs.modules.checklist_sorveglianza.base.Istanza" scope="request"/>
<jsp:useBean id="tipologiaChecklistList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ricarica" class="java.lang.String" scope="request"/>

<%@ include file="../initPage.jsp" %>

<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<link rel="stylesheet" type="text/css" media="screen" documentale_url="" href="checklist_sorveglianza/css/screen.css" />
<link rel="stylesheet" type="text/css" media="print" documentale_url="" href="checklist_sorveglianza/css/print.css" />

<DIV ID='modalWindow' CLASS='unlocked'><P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV>

<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
   
<script>
function setValue(idDomanda, idRisposta, punteggio){
	
	//azzero tutti gli altri punteggi della stessa domanda
	var x = document.getElementById("checklist").getElementsByTagName("input");
	for (var i = 0; i<x.length; i++){
		if (x[i].name.indexOf("punteggioRisposta_"+idDomanda+"_")==0){
			x[i].value = '';
		}
	}	
	
	//valorizzo il punteggio di questa risposta
	document.getElementById("punteggioRisposta_"+idDomanda+"_"+idRisposta).value = punteggio;
	
	var tot = parseFloat("0.0");
	var x = document.getElementById("checklist").getElementsByTagName("input");
	for (var i = 0; i<x.length; i++){
		if (x[i].name.indexOf("punteggioRisposta")==0 && x[i].value!= ''){
			tot = tot+parseFloat(x[i].value);
		}
	}
	document.getElementById("punteggioTotale").value = tot;
}

function checkForm(form, bozza){
	var msg = "";
	
	
	var x = document.getElementById("checklist").getElementsByTagName("input");
	for (var i = 0; i<x.length; i++){
		if (x[i].type=='radio' && x[i].name.indexOf('radioRisposta_'==0)) {
			var radioRisposta = document.getElementsByName(x[i].name);
			var checked = false;
			for (var j = 0; j<radioRisposta.length; j++) {
				radio = radioRisposta[j];
				if (radio.checked)
					checked = true;
			}
			
			if (!checked) {
				msg = "Attenzione! Per salvare in modo definitivo occorre rispondere a tutte le domande!";
				break;
			}
		}
	}
	if (bozza == 'false' && msg!=""){
		alert(msg);
		return false;
	}
	form.bozza.value = bozza;
	loadModalWindow();
	form.submit();
}
function chiudiRicarica(idControllo){
	//window.opener.location.href = "Vigilanza.do?command=TicketDetails&id="+idControllo;
	window.opener.location.reload();
	window.close();
}
</script>

<% if (ricarica!= null && ricarica.equals("si")) { %>
<script> 
chiudiRicarica('<%=Istanza.getIdControllo()%>');
</script>
<% } %>

<% if (!Istanza.isBozza()) { %>
<center>
<jsp:include page="../gestione_documenti/boxDocumentaleNoAutomatico.jsp">
<jsp:param name="extra" value="<%=Istanza.getId() %>" />
<jsp:param name="tipo" value="ChecklistSorveglianza" />
<jsp:param name="idCU" value="<%=Istanza.getIdControllo() %>" />
</jsp:include>
</center>
<% } %>

<div class="boxIdDocumento"></div>
<div class="boxOrigineDocumento"><%@ include file="../hostName.jsp" %></div>

<form name="updateChecklist" action="ChecklistSorveglianza.do?command=Update&auto-populate=true" method="post">
	
<table class="details" width="100%" cellpadding="10" id="checklist" style="border-collapse: collapse">

<tr><th colspan="5"><%=tipologiaChecklistList.getSelectedValue(Istanza.getIdTipoChecklist()) %> </th></tr>
<tr><th>Categoria</th><th>Criteri di valutazione</th><th>Valutazione</th><th>Selezionare</th><th>Punteggio</th></tr>


<% for (int c = 0; c<Istanza.getCapitoli().size(); c++) {	
	Capitolo cap = (Capitolo) Istanza.getCapitoli().get(c);	
	for (int d = 0; d<cap.getDomande().size(); d++) {	
		Domanda dom = (Domanda) cap.getDomande().get(d);	
		for (int r = 0; r<dom.getRisposte().size(); r++) {	
			Risposta ris = (Risposta) dom.getRisposte().get(r);	%>
<tr class="row<%=d%2%>">
<td><%=cap.getCapitolo() %></td>
<td><%=dom.getDomanda() %></td>
<td><%=ris.getRisposta() %></td>
<td><input type="radio" <%=ris.isSelezionata() ? "checked" : "" %> name="radioRisposta_<%=ris.getIdDomanda() %>" id ="radioRisposta_<%=ris.getIdDomanda() %>_<%=ris.getId() %>" value="<%=ris.getId() %>" onClick="setValue('<%=ris.getIdDomanda() %>', '<%=ris.getId()%>', '<%=ris.getPunteggio()%>')"/> </td>
<td><input type="text" id="punteggioRisposta_<%=ris.getIdDomanda() %>_<%=ris.getId() %>" name="punteggioRisposta_<%=ris.getIdDomanda() %>_<%=ris.getId() %>" size="2 !important" disabled value="<%=ris.isSelezionata() ? ris.getPunteggio() : "" %>"/></td>
</tr>			
<%	
		} //risposte
	} //domande %>
	
<tr style="background-color: yellow"><td colspan="5"></td></tr>
<%} //capitoli%>

	
<tr> <td colspan="4" align="right"> <b>Punteggio totale</b> <br/> 
< 30 rischio basso - tra 30 e 42 rischio medio - > 42 rischio elevato
</td><td><input type="text" readonly id ="punteggioTotale" name="punteggioTotale" value="<%=Istanza.getPunteggioTotale()%>"/> </td></tr>
 
 <tr >
 <td align="center" colspan="5"> 
 <input type="button" value="salva temporaneo" onClick="checkForm(this.form, 'true')"/>
<input type="button" value="salva definitivo" onClick="checkForm(this.form, 'false')"/>
</td>
 </tr>
</table>
	


<input type="hidden" id="idControllo" name="idControllo" value="<%=Istanza.getIdControllo()%>"/> 
<input type="hidden" id="idIstanza" name="idIstanza" value="<%=Istanza.getId()%>"/> 
<input type="hidden" id="idTipoChecklist" name="idTipoChecklist" value="<%=Istanza.getIdTipoChecklist()%>"/> 
<input type="hidden" id="bozza" name="bozza" value="<%=Istanza.isBozza()%>"/> 

</form>

<% if (!Istanza.isBozza()) {%>
<script>
var x = document.getElementById("checklist").getElementsByTagName("input");
for (var i = 0; i<x.length; i++){
		x[i].disabled = "disabled";
		if (x[i].type== "button"){
			x[i].style.display="none";
}
}	
</script>
<% } %>


