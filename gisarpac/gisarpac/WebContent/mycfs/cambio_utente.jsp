<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/submit.js"></SCRIPT>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="MyCFS.do?command=Home"><dhv:label name="My Home Page" mainMenuItem="true">La Mia Home Page</dhv:label></a> >
<dhv:label name="">Cambio Utente</dhv:label>
</td>
</tr>
</table>
<form action="MyCFS.do?command=CambioUtenteConferma" method="post" >
<%String errore = (String)request.getAttribute( "errore" ); %>
<%=(errore == null) ? ("") : (errore) %>
<br/>
Username: <input type="text" name="username" />
<input type="submit" value="Procedi">
</form>
