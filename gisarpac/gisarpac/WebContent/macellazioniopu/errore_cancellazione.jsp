<jsp:useBean id="Capo" class="org.aspcfs.modules.macellazioniopu.base.Capo" scope="request" />
<jsp:useBean id="Error" class="java.lang.String" scope="request" />


<table class="details" width="100%" cellpadding="4">
<tr><th colspan="2">Errore cancellazione</th></tr>

<tr>
<td>Matricola</td>
<td><%=Capo.getCd_matricola() %></td>
</tr>

<tr>
<td colspan="2"><%=Error %></td>
</tr>

<tr>
<td colspan="2"><input type="button" value="CHIUDI" onClick="window.close()"/></td>
</tr>

</table>