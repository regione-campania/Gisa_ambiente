<jsp:useBean id="messaggio" class="java.lang.String" scope="request"/>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>


<form id = "addAccount" name="addAccount" action="DpatSDC2019.do?command=MessaggioAggiorna&auto-populate=true" method="post">
<table style="border:1px solid black">
<tr>
<td><b>Messaggio</b></td>
<td><textarea name="messaggio" id="messaggio" rows="5" cols="80"><%=(messaggio!=null) ? messaggio  : "" %></textarea></td>
</tr>
<tr>
<td><a href="DpatSDC2019.do?command=MessaggioVisualizza">Annulla</a></td>
<td><input type="submit" value="SALVA"/></td></tr>
</table>
</form>