<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="ListaDipartimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DettaglioAreaSemplice" class="org.aspcfs.modules.gestionedpat.base.AreaSemplice" scope="request"/>
<jsp:useBean id="DettaglioAreaComplessa" class="org.aspcfs.modules.gestionedpat.base.AreaComplessa" scope="request"/>
<jsp:useBean id="DettaglioNominativo" class="org.aspcfs.modules.gestionedpat.base.Nominativo" scope="request"/>

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

function elimina(form){

	if (confirm("Il nominativo selezionato sara' eliminato dall'area semplice. Continuare?")){
		loadModalWindow();
		form.submit();
	}

}

</script>


<h2><%=DettaglioAreaComplessa.getAnno() %> / <%=ListaDipartimenti.getSelectedValue(DettaglioAreaComplessa.getIdDipartimento()) %> / <%= DettaglioAreaComplessa.getNome() %> / <%=DettaglioAreaSemplice.getNome() %> / <%=DettaglioNominativo.getNome() %> (<%=DettaglioNominativo.getQualifica() %>)</h2>

<h3>ELIMINA NOMINATIVO</h3>

<form name="addAccount"	action="GestioneDPAT.do?command=DeleteNominativoAreaSemplice&auto-populate=true" method="post">
<input type="button" value="annulla" onClick="annulla()" style="font-size: 20px"/>
<input type="button" value="elimina" onClick="elimina(this.form)" style="font-size: 20px"/>
<input type="hidden" id="idNominativo" name="idNominativo" value="<%=DettaglioNominativo.getId()%>"/>
<input type="hidden" id="idAreaSemplice" name="idAreaSemplice" value="<%=DettaglioAreaSemplice.getId()%>"/>
</form>
