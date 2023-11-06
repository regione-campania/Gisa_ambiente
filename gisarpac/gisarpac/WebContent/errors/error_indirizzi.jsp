<script>
function goBack() {
    window.history.go(-2);
}
</script>
<%String erroreIndirizzi = "";
String[] lines = errorMessage.split(System.getProperty("line.separator"));
erroreIndirizzi = lines[0];
erroreIndirizzi = erroreIndirizzi.substring(erroreIndirizzi.indexOf("[IndirizziException]"), erroreIndirizzi.length());
erroreIndirizzi = erroreIndirizzi.replace("[IndirizziException]", "ATTENZIONE : ");
%>
<table width="100%">
	<tr><td><font color="red" size="3px"><b><%=erroreIndirizzi %></b></font></td></tr>
	<tr><td></td></tr>
	<tr><td>Possibili Cause:</td></tr>
	<tr><td>
		<li>Comune Insesistente o non selezionato</li>
		<li>Provincia Inesistente</li>
		<li>Comune non associabile alla Provincia selezionata</li>
	</td></tr>
	<tr></tr>
	<tr><td><font size="3px">Si prega di tornare indietro e riprovare.</font></td></tr>
	<tr><td><input type="button"  onclick="goBack()" value="Indietro"/></td></tr>
</table>