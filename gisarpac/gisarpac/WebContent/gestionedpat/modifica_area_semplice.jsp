<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="ListaDipartimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DettaglioAreaSemplice" class="org.aspcfs.modules.gestionedpat.base.AreaSemplice" scope="request"/>
<jsp:useBean id="DettaglioAreaComplessa" class="org.aspcfs.modules.gestionedpat.base.AreaComplessa" scope="request"/>

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

function aggiorna(form){
	var esito = true;
	var msg = '';
	
	if (form.nome.value.trim() == ''){
		msg+= "Inserire nome AREA SEMPLICE. \n";
		esito = false;
	}
	
	if (!esito){
		alert(msg);
		return false;
		}

	if (confirm("L'area semplice sara' aggiornata. Continuare?")){
		loadModalWindow();
		form.submit();
	}	
}

</script>


<%-- <h2><%=DettaglioAreaComplessa.getAnno() %> / <%=ListaDipartimenti.getSelectedValue(DettaglioAreaComplessa.getIdDipartimento()) %> / <%= DettaglioAreaComplessa.getNome() %> / <%=DettaglioAreaSemplice.getNome() %></h2> --%>

<h3>MODIFICA AREA SEMPLICE</h3>

<form name="addAccount"	action="GestioneDPAT.do?command=UpdateAreaSemplice&auto-populate=true" method="post">
<input type="text" id="nome" name="nome" value="<%=DettaglioAreaSemplice.getNome() %>" placeholder="Nome area semplice" size="20" style="font-size: 20px; width: 600px"/><br/>
<input type="button" value="annulla" onClick="annulla()" style="font-size: 20px"/>
<input type="button" value="aggiorna" onClick="aggiorna(this.form)" style="font-size: 20px"/>
<input type="hidden" id="idAreaSemplice" name="idAreaSemplice" value="<%=DettaglioAreaSemplice.getId()%>"/>
</form>
