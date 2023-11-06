<%@ include file="header.jsp" %>

<jsp:useBean id="listaAsl" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="listaRuoli" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="utente" class="org.aspcfs.modules.util.base.GURUUtente" scope="request"/>
<%@ page import="org.aspcfs.modules.util.base.*" %>

<script>
function checkForm(form){
	
	if (confirm("Attenzione. Disabilitare questo utente? Non potra' piu' accedere al sistema e non sara' piu' possibile ripristinarlo.")) {
		loadModalWindow();
		form.submit();
	}
}

function annulla(form){
	
	if (confirm('Annullare questa operazione?')){
		form.action = 'Utility.do?command=GURUHome';
		loadModalWindow();
		form.submit();
	}
}

</script>

		
<form action="Utility.do?command=GURUUpdateDisable" method="post">
<center>
<table class="tableguru">

<tr><th colspan="2">Contatto</th></tr>
<tr><td>NOME</td><td><input type="text" readonly id="nome" name="nome" maxlength="20" value="<%=utente.getNome()%>"/></td></tr>
<tr><td>COGNOME</td><td><input type="text" readonly id="cognome" name="cognome" maxlength="20" value="<%=utente.getCognome()%>"/></td></tr>
<tr><td>CODICE FISCALE</td><td><input type="text" readonly id="cf" name="cf" maxlength="16" value="<%=utente.getCf()%>"/></td></tr>
<tr><th colspan="2">Accesso al sistema</th></tr>
<tr><td>USERNAME</td><td><input type="text" readonly id="username" name="username" maxlength="20" value="<%=utente.getUsername()%>"/></td></tr>
<tr><td>ALIAS</td><td><input type="text" readonly id="alias" name="alias" maxlength="20" value="<%=utente.getAlias()%>"/></td></tr>
<tr><th colspan="2">
<input type="button" class="buttonguru" value="ANNULLA" onClick="annulla(this.form)"/>
<input type="button" class="buttonguru" value="DISABILITA" onClick="checkForm(this.form)"/></th></tr>
</table>
</center>
<input type="hidden" id="userId" name="userId" value="<%=utente.getId()%>"/>
</form>






