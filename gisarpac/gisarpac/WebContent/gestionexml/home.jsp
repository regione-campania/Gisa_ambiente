<script>

function goToInserisci(){
	window.location.href="GestioneXML.do?command=PrepareRead"
}

function goToLista(){
	window.location.href="GestioneXML.do?command=List"
}

</script>


<center>
<table width="100%" style="border: 1px solid black" cellspacing="20" cellpadding="20">

<tr><td align="center">
<input type="button" value="INSERISCI NUOVA ANAGRAFICA DA XML" onClick="goToInserisci()"/>
</td></tr>
<tr><td align="center">
<input type="button" value="VAI A LISTA ANAGRAFICHE CARICATE" onClick="goToLista()"/>
</td></tr>

</table>
</center>