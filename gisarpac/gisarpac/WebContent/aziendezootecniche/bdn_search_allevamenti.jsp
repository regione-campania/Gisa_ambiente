<jsp:useBean id="SpecieList" class="org.aspcfs.utils.web.LookupList" scope="request"/>




<form method="post" action = "AziendeZootecniche.do?command=FindAllevamentiBdn" onsubmit="javascript:if(this.codAzienda.value==''){alert('Inserire il codice Azienda');return false;} return true ;">

<table>

<tr>
<td>Codice Azienda</td>
<td><input type = "text" name = "codAzienda"></td>
</tr>

<tr>
<td>Specie</td>
<td><%=SpecieList.getHtmlSelect("specieAzienda",-1) %></td>
</tr>

</table>
<input type = "submit" value = "Ricerca in Bdn">

</form>