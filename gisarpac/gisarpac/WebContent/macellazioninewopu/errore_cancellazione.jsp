<jsp:useBean id="Partita" class="org.aspcfs.modules.macellazioninewopu.base.Partita" scope="request" />
<jsp:useBean id="Error" class="java.lang.String" scope="request" />


<table class="details" width="100%" cellpadding="4">
<tr><th colspan="2">Errore cancellazione</th></tr>

<tr>
<td>Numero</td>
<td><%=Partita.getCd_partita()%></td>
</tr>

<tr>
<td colspan="2"><%=Error %></td>
</tr>

<tr>
<td colspan="2"><input type="button" value="CHIUDI" onClick="window.close()"/></td>
</tr>

</table>

