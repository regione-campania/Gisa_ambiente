<%@ include file="header.jsp" %>

<jsp:useBean id="listaAsl" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="listaRuoli" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="utente" class="org.aspcfs.modules.util.base.GURUUtente" scope="request"/>
<%@ page import="org.aspcfs.modules.util.base.*" %>

<script>
function checkForm(form){
	
	var msg = '';
	var ret = true;
	
	if (form.roleId.value=="-1"){
		msg+='Inserire ruolo!';
		ret = false;
	}
	if (form.roleId.value=="329"){ //GESTORE DISTRIBUTORI
		msg+='Impossibile selezionare questo ruolo!'; 
		ret = false;
	}
		
	if (ret) {
		if (confirm('Eseguire questa modifica?')){
			loadModalWindow();
			form.submit();
		}
	}
	else {
		alert(msg);
		return false;
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
		
<form action="Utility.do?command=GURUUpdate" method="post">
<center>
<table class="tableguru">

<tr><th colspan="2">Contatto</th></tr>
<tr><td>NOME</td><td><input type="text" id="nome" name="nome" maxlength="20" value="<%=utente.getNome()%>"/></td></tr>
<tr><td>COGNOME</td><td><input type="text" id="cognome" name="cognome" maxlength="20" value="<%=utente.getCognome()%>"/></td></tr>
<tr><td>CODICE FISCALE</td><td><input type="text" id="cf" name="cf" maxlength="16" value="<%=utente.getCf()%>"/></td></tr>
<tr><th colspan="2">Accesso al sistema</th></tr>
<tr><td>DIPARTIMENTO</td><td>
<select id="aslId" name="aslId">
<option value="-1" <%=utente.getIdAsl() == -1 ? "selected" : "" %>>-- TUTTI I DIPARTIMENTI --- </option>
<%
	for (int i = 0; i<listaAsl.size(); i++) {
	GURUAsl asl = (GURUAsl) listaAsl.get(i);
%>
<option value="<%=asl.getAslId()%>" <%=utente.getIdAsl() == asl.getAslId() ? "selected" : "" %>><%=asl.getAsl()%></option>
<%}%>
</select> 
</td></tr>
<tr><td>RUOLO</td><td>
<select id="roleId" name="roleId">
<option value="-1" <%=utente.getIdRuolo() == -1 ? "selected" : "" %>>--- SELEZIONARE ---</option>
<%
	for (int i = 0; i<listaRuoli.size(); i++) {
	GURURuolo ruolo = (GURURuolo) listaRuoli.get(i);
%>
	<option value="<%=ruolo.getRoleId()%>" <%=utente.getIdRuolo() == ruolo.getRoleId() ? "selected" : "" %>><%=ruolo.getRole()%></option>
	<%}%>
</select> *
</td></tr>
<tr><td>USERNAME</td><td><input type="text" readonly id="username" name="username" maxlength="20" value="<%=utente.getUsername()%>"/> *</td></tr>
<tr><td>ALIAS</td><td><input type="text" readonly id="alias" name="alias" maxlength="20" value="<%=utente.getAlias()%>"/> *</td></tr>
<tr><th colspan="2">
<input type="button" class="buttonguru" value="ANNULLA" onClick="annulla(this.form)"/>
<input type="button" class="buttonguru" value="AGGIORNA" onClick="checkForm(this.form)"/></th></tr>
</table>
</center>
<input type="hidden" id="userId" name="userId" value="<%=utente.getId()%>"/>
</form>


<br/>
<center>
* campo obbligatorio
</center>



