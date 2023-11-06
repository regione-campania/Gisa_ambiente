 
<script src="javascript/vendor/moment.min.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>
<script src="javascript/noscia/codiceFiscale.js"></script>

<script type="text/javascript" src="dwr/interface/DWRnoscia.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<script src="javascript/gestioneanagrafica/add.js"></script>


<script src="javascript/gestioneanagrafica/modify.js"></script>
	<table class="trails" cellspacing="0">
	<tr>
	<td>
		<a href="GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti">Gestione Anagrafica</a> > 
		<a href="GestioneAnagraficaAction.do?command=Details&altId=${altId}">SCHEDA</a> > Variazione Titolarita'
	</td>
	</tr>
	</table>

<body onload ="VisualizzaValoriModifica(ValoriAnagrafica)">   

<form class="form-horizontal" role="form" method="post" action="GestioneAnagraficaAction.do?command=VariazioneTitolarita" onsubmit="return validateForm();">
<b>MODIFICA SCHEDA: VARIAZIONE TITOLARITA'</b><br>
<input type="hidden" id="id_asl_stab" value="${id_asl_stab}"/>
<input type="hidden" id="alt_id" name="alt_id" value="${altId}"/>

<#if numeroPratica??>
	<div style="border: 1px solid black; background: #BDCFFF">
	<br>
	&nbsp;&nbsp;&nbsp;&nbsp;NUMERO PRATICA: ${numeroPratica} <br>
	&nbsp;&nbsp;&nbsp;&nbsp;DATA PEC: ${dataPratica} <br>
	<br>
	<input type="hidden" id="numeroPratica" name="numeroPratica" value="${numeroPratica}"/>
	<input type="hidden" id="idTipologiaPratica" name="idTipologiaPratica" value="${tipoPratica}"/>
	<input type="hidden" id="idComunePratica" name="idComunePratica" value="${comunePratica}"/>
	</div>
	<br/>
<#else></#if>

<table class="table details" id="tabella_linee" style="border-collapse: collapse" width="100%" cellpadding="5"> 

<#list lineaattivita as lista>
	
	<#if lista.ftl_name??> 
		<#assign gruppo = '${lista.ftl_name}'> 
		<#if gruppo == 'impresa'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'rappleg'>
			<#include "sezioni/templateSezioni.ftl"> 
		<#elseif gruppo == 'sedeleg'>
			<#include "sezioni/templateSezioni.ftl">	
		</#if>
	<#else>
	</#if> 
</#list>



</table><hr>
<br><br>
<center>

<button type="submit" class="yellowBigButton" style="width: 250px;">Salva</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<#if numeroPratica??>
<button type="button" class="yellowBigButton" style="width: 250px;"
	onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti'">Torna alla lista pratiche</button>
<#else>
<button type="button" class="yellowBigButton" style="width: 250px;" 
	onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=Details&altId=${altId}'">Annulla</button>
</#if>

</center>
</form>
<br><br>

<script src="javascript/noscia/widget.js"></script>
<script>
var ValoriAnagrafica = {
<#list ValoriAnagrafica?keys as key>
"${key}" : "${ValoriAnagrafica[key]}",
</#list>
}
</script> 

<script>
function validateForm()
{
	var numeroPratica = document.getElementById("numeroPratica").value;
	if (numeroPratica!=''){
		var esito = controllaEsistenzaNumeroPratica(numeroPratica);
	
		if (document.getElementById("numeroPraticaCheck").value!=''){
			alert("Attenzione. Il numero pratica inserito risulta gia' utilizzato.");
			return false;
		}
	}
	
	loadModalWindowCustom("Attendere Prego...");
	return true;
}
</script>
 
</div>
</body> 