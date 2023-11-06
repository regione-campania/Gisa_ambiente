 
<script src="javascript/vendor/moment.min.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>
<script src="javascript/noscia/codiceFiscale.js"></script>

<script type="text/javascript" src="dwr/interface/DWRnoscia.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>


<script src="javascript/gestioneanagrafica/modify.js"></script>
	<table class="trails" cellspacing="0">
	<tr>
	<td>
		<a href="GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti">Gestione Anagrafica</a> > 
		<a href="GestioneAnagraficaAction.do?command=Details&altId=${altId}">SCHEDA</a> > Modifica SCHEDA
	</td>
	</tr>
	</table>

<body onload ="VisualizzaValoriModifica(ValoriAnagrafica)">   
<#-- <div id="modifica">  -->

<form class="form-horizontal" role="form" method="post" action="GestioneAnagraficaAction.do?command=Update" onsubmit="return validateForm();">
<b>ERRATA CORRIGE: MODIFICA SCHEDA ANAGRAFICA<b><br>
<input type="hidden" id="id_asl_stab" value="${id_asl_stab}">
<input type="hidden" id="alt_id" name="alt_id" value="${altId}"/>

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
		<#elseif gruppo == 'stab'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'dettagliaddizionali'>
			<#include "sezioni/templateSezioni.ftl">			
		<#elseif gruppo == 'abusivo'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'luogoabusivo'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'soggettooperatoreprivato'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'residenzaoperatoreprivato'>
			<#include "sezioni/templateSezioni.ftl">		
		<#elseif gruppo == 'luogocontrollooperatoreprivato'>
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

<button type="button" class="yellowBigButton" style="width: 250px;" onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=Details&altId=${altId}'">Annulla</button>

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
	loadModalWindowCustom("Attendere Prego...");
	return true;
}
</script>
 
</div>
</body> 