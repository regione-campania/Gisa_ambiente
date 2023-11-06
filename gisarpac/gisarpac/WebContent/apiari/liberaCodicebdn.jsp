<%
if (request.getAttribute("Error")!=null)
{
	%>
	<font color="red"><%=request.getAttribute("Error") %></font>
	<%
}

%>
<form method="post" action="ApicolturaAttivita.do?command=LiberaCodice">

<input type ="text" value ="" name="codice_azienda" size="8" maxlength="8" required="required">

<input type="submit" value="Cancella">
</form>