
<script>
function aggiornamento(orgId,id)
{
	opener.document.details.action ="FarmacieVigilanza.do?command=TicketDetails&orgId="+document.aggiornacategoria.orgId.value+"&id="+document.aggiornacategoria.ticketid.value;
	opener.document.details.submit();
	window.close();
}
</script>

<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<%
String orgId 	= (String)request.getAttribute("orgId");
String ticketid = (String)request.getAttribute("ticketid");		 
%>
<script>
function check(){
if (document.aggiornacategoria.data.value=="")
{
	alert("Controlla di aver inserito la data di prossimo controllo");
	
}
else
{
	document.aggiornacategoria.submit();
}

	
}

</script>

<form method="post"  name = "aggiornacategoria" action="FarmacieVigilanza.do?command=AggiornaCategoria">
<input type = "hidden" name = "orgId" value = "<%=orgId %>">
<input type = "hidden" name = "ticketid" value = "<%=ticketid %>">
<%if (request.getAttribute("Aggiornamento")!=null)
	{%>
	<font color = "red">Categoria Aggiornata Correttamente</font>
	<%}%>

<table cellpadding="4" cellspacing="0" width="100%" class="details">
<tr>
	<th colspan="2"><strong>Aggiorna Categoria Di Rischio</strong></th>
</tr>
<tr class="containerBody">
 	<td nowrap class="formLabel">Categoria di Rischio</td>
	<td><select name = "categoria"> 
			<option value = "1">1</option>
			<option value = "2">2</option>
			<option value = "3">3</option>
			<option value = "4">4</option>
			<option value = "5">5</option>
		</select>
	</td>
</tr>
<tr class="containerBody">
 	<td nowrap class="formLabel">Data</td>
	<td>
		<input type="text" readonly="readonly" name="data" size="10" value="" />&nbsp;
			<a href="javascript:popCalendar('aggiornacategoria','data','it','IT','Europe/Berlin');">
				<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle">
			</a>
			<font color = "red">*</font>
	</td>

</tr>
</table>
<input type = "button" onclick="check()" value = "Aggiorna">
</form>
	
	<%if (request.getAttribute("Aggiornamento")!=null)
		
	{%>
	<script>
	aggiornamento();
	
	
	
	</script>
	
	<%}%>