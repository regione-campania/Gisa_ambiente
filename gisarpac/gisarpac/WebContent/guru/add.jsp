<%@ include file="header.jsp" %>

<jsp:useBean id="listaAsl" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="listaRuoli" class="java.util.ArrayList" scope="request"/>
<%@ page import="org.aspcfs.modules.util.base.*" %>

<script>
function checkForm(form){
	
	var msg = '';
	var ret = true;
	if (form.username.value=="" || form.username.value.length<6){
		msg+='Inserire username di almeno 6 caratteri!\n';
		ret = false;
	}
	if (form.password.value=="" || form.password.value.length<6){
		msg+='Inserire password di almeno 6 caratteri!\n';
		ret = false;
	}
	if (form.password2.value==""){
		msg+= 'Inserire conferma password!\n';
		ret = false;
	}
	if (form.password.value!=form.password2.value){
		msg+='La password non corrisponde!';
		ret = false;
	}
	if (form.cf.value=="" || form.cf.value.length<16){
		msg+='Codice Fiscale non inserito o errato!\n';
		ret = false;
	}
		if (form.role.value=="-1"){
			msg+='Inserire ruolo!';
			ret = false;
	}
	if (form.role.value=="329"){ //GESTORE DISTRIBUTORI
		msg+='Impossibile selezionare questo ruolo!'; 
		ret = false;
	}
		
	if (ret) {
		if (confirm('Inserire questo utente?')){
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

function mostraNascondiPassword(form){
	if (form.mostra.checked) {
		form.password.type = 'text';
		form.password2.type = 'text';
	}
	else {
		form.password.type = 'password';
		form.password2.type = 'password';
	}
}
</script>

<form action="Utility.do?command=GURUInsert" method="post">

<center>
<table class="tableguru">
<tr><th colspan="2">Contatto</th></tr>
<tr><td>NOME</td><td><input type="text" id="nome" name="nome" maxlength="20"/></td></tr>
<tr><td>COGNOME</td><td><input type="text" id="cognome" name="cognome" maxlength="20"/></td></tr>
<tr><td>CODICE FISCALE</td><td><input type="text" id="cf" name="cf" maxlength="16"/> *</td></tr>
<tr><th colspan="2">Accesso al sistema</th></tr>
<tr><td>DIPARTIMENTO</td><td>
<select id="asl" name="asl">
<option value="-1">--- TUTTI I DIPARTIMENTI ---</option>
<%
	for (int i = 0; i<listaAsl.size(); i++) {
	GURUAsl asl = (GURUAsl) listaAsl.get(i);
%>
	<option value="<%=asl.getAslId()%>"><%=asl.getAsl()%></option>
<%} %>
</select> 
</td></tr>
<tr><td>RUOLO</td><td>
<select id="role" name="role">
<option value="-1">--- SELEZIONARE ---</option>
<%
	for (int i = 0; i<listaRuoli.size(); i++) {
	GURURuolo ruolo = (GURURuolo) listaRuoli.get(i);
%>
	<option value="<%=ruolo.getRoleId()%>"><%=ruolo.getRole()%></option>
<%}%>
</select> *
</td></tr>
<tr><td>USERNAME</td><td><input type="text" id="username" name="username" maxlength="20"/> *</td></tr>
<tr><td>PASSWORD</td><td><input type="password" id="password" name="password" maxlength="20"/> *</td></tr>
<tr><td>CONFERMA PASSWORD</td><td><input type="password" id="password2" name="password2" maxlength="20"/> *</td></tr>
<tr><td> (Mostra password) </td> <td> <input type="checkbox" id="mostra" name="mostra" onClick="mostraNascondiPassword(this.form)"/></td></tr>
<tr><th colspan="2">
<input type="button" class="buttonguru" value="ANNULLA" onClick="annulla(this.form)"/>
<input type="button" class="buttonguru" value="INSERISCI" onClick="checkForm(this.form)"/></th></tr>
</table>
</center>
</form>

<br/>
<center>
* campo obbligatorio
</center>

