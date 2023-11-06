<script>
flag = 0;
function checkForm(tipoAlimenti,specie_alimenti,id)
{
	form = document.chiusura;
if (form.motivo_chiusura.value == "")
{
	
	alert("Attenzione , inserire una motivazione per la chiusura dell'allerta");
}
else
{
window.opener.document.details.action='TroubleTicketsAllerteNew.do?command=ChiudiAllerta&tipoAlimenti='+tipoAlimenti+'&specie_alimenti='+specie_alimenti+'&id='+id+'&parentId=-1&folderId=-1&documentiAllerta=1&chiusuraUfficio=1&motivo_chiusura='+form.motivo_chiusura.value;
window.opener.document.details.submit();
window.close();
}

}
</script>

<%
String tipoAlimenti = (String)request.getAttribute("tipoAlimenti");
String id = (String)request.getAttribute("idAllerta");
String numCu = (String)request.getAttribute("numCu");
String specie_alimenti = (String)request.getAttribute("specie_alimenti");

%>
<table class="trails" cellspacing="0">
<tr>
<td>
<%
if ("0".equals(numCu))
{
%>
Indicare il motivo per cui si intende chiudere l'allerta senza aver eseguito controlli ufficiali
<%}
else
{
	%>
	Indicare il motivo per cui si intende chiudere l'allerta senza aver chiuso controlli ufficiali
	
	<%
	
}
%>
</td></tr>
</table>
<form method="post" name ="chiusura" action = "TroubleTicketsAllerteNew.do?command=ChiudiAllerta&tipoAlimenti=<%=tipoAlimenti%>&specie_alimenti=<%=specie_alimenti %>&id=<%=id%>&parentId=-1&folderId=-1&documentiAllerta=1&chiusuraUfficio=1">
 <table  class="details" border="0" cellpadding="4" cellspacing="0" width="100%">
<tr>
    <th colspan="2">
    Chiusura Allerta 
    </th>
    </tr>
 <tr class="containerBody">
    <td class="formLabel">Motivazione del mancato completamento dei CU pianificati</td><td><textarea rows="9" cols="50" name="motivo_chiusura"></textarea></td></tr>
<tr><td><input type = "button" onclick="checkForm('<%=tipoAlimenti %>','<%=specie_alimenti %>',<%=id %>)" value = "Chiudi Allerta e Invia Allegato F"> </textarea></td></tr>


</table>
</form>