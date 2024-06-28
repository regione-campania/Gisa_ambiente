<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>
<%@ include file="header.jsp" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<script>
function aggiungiUtente(form){
	form.action = 'Utility.do?command=GURUAdd';
	loadModalWindow();
	form.submit();
}
function listaUtenti(form){
	form.action = 'Utility.do?command=GURUList';
	loadModalWindow();
	form.submit();
}
function modificaPassword(form, id){
	form.action = 'Utility.do?command=GURUModifyPassword';
	loadModalWindow();
	form.submit();
}
function modificaAlias(form, id){
	form.action= 'Utility.do?command=GURUModifyAlias';
	loadModalWindow();
	form.submit();
}
function listaUtentiDaProc(form, id){
	form.action= 'Utility.do?command=GURUListProc';
	loadModalWindow();
	form.submit();
}

</script>

	<%if(org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("modulo_guru").equals("no")){	%>
		<script>
		alert('Gestione utenti non consentita su questo sistema');
		window.location.replace("MyCFS.do?command=Home"); </script>
 	<%}%>

<form name="GURU" action="" method="post">

<center>
<table class="tableguru">
<tr><td>
<dhv:permission name="guru-view"><input type="button" class="buttonguru" onClick="aggiungiUtente(this.form)" value="INSERISCI UTENTE"/></dhv:permission>
</td>
<td>
<dhv:permission name="guru-view"><input type="button" class="buttonguru" onClick="listaUtenti(this.form)" value="LISTA UTENTI"/></dhv:permission></td></tr>
<tr><td><input type="button" class="buttonguru" onClick="modificaPassword(this.form)" value="MODIFICA PASSWORD UTENTE"/></td>
<td name="guru-view"><input type="button" class="buttonguru" onClick="modificaAlias(this.form)" value="MODIFICA ALIAS"/></td></tr>
<td name="guru-view"><input type="button" class="buttonguru" onClick="listaUtentiDaProc(this.form)" value="LISTA UTENTI DA PROCESSARE"/></td></tr>

</table>
</center>

<input type="hidden" id="userId" name="userId" value="<%=User.getUserId()%>"/>
</form>
