<jsp:useBean id="postIt" class="org.aspcfs.modules.mycfs.base.PostIt" scope="request"/>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>


<form id = "addAccount" name="addAccount" action="MyCFS.do?command=PostItAggiorna&auto-populate=true" method="post">
<input type="hidden" id="tipo" name="tipo" value="<%=postIt.getTipo()%>"/>
<table style="border:1px solid black">
<tr>
<td><b>Messaggio</b></td>
<td><textarea name="messaggio" id="messaggio" rows="5" cols="20"><%=(postIt.getMessaggio()!=null) ? postIt.getMessaggio()  : "" %></textarea></td>
</tr>
<tr>
<td><a href="MyCFS.do?command=PostItVisualizza&tipo=<%=postIt.getTipo()%>">Annulla</a></td>
<td><input type="submit" value="SALVA"/></td></tr>
</table>
</form>