<script src="javascript/vendor/moment.min.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>
<#--  <script src="javascript/noscia/lineAttivita.js"></script> -->
<#--  <script src="javascript/vendor/bootstrap-datepicker.js"></script> -->
<#-- <script src="javascript/vendor/bootstrap.min.js"></script> -->
<script src="javascript/noscia/codiceFiscale.js"></script>
<#-- <script src="javascript/noscia/utilFunction.js"></script> -->

<script type="text/javascript" src="dwr/interface/DWRnoscia.js"> </script>
<script type="text/javascript" src="dwr/interface/SuapDwr.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
<script src="javascript/gestioneanagrafica/add.js"></script>

<#--  <script src="javascript/jquery-1.11.1.min.js"></script>  -->
<#-- <script src="javascript/jquery-ui.js"></script>  -->


	<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="OpuStab.do?command=SearchForm">ANAGRAFICA IMPIANTI</a> > INSERISCI IMPIANTO 
		</td>
	</tr>
	</table>


<input type="hidden" id="id_asl_stab" value="${id_asl_stab}">
<form class="form-horizontal" role="form" method="post" action="GestioneAnagraficaAction.do?command=Insert" onsubmit="return validateForm();">

<#if numeroPratica??>
	<div style="border: 1px solid black; background: #BDCFFF">
	<br>
	&nbsp;&nbsp;&nbsp;&nbsp;NUMERO PRATICA: ${numeroPratica} <br>
	&nbsp;&nbsp;&nbsp;&nbsp;DATA PEC: ${dataPratica} <br>
	&nbsp;&nbsp;&nbsp;&nbsp;COMUNE: ${comuneTesto} <br>
	<br>
	<input type="hidden" id="numeroPratica" name="numeroPratica" value="${numeroPratica}"/>
	<input type="hidden" id="idTipologiaPratica" name="idTipologiaPratica" value="${tipoPratica}"/>
	<input type="hidden" id="idComunePratica" name="idComunePratica" value="${comunePratica}"/>
	</div>
	<br/>
<#else></#if>

<div id="tipo_linee" style="display:none">
<center>
	<h2>Stai per inserire uno stabilimento:</h2>
	<select id="tipo_linee_attivita" style="text-align:center; font-size: 20px ;width: 400px;">
		<option value="1">con sede fissa</option>
		<#-- <option value="2">senza sede fissa</option>  -->
		<#-- <option value="3">con sede fissa e senza sede fissa</option>  -->
	</select>
	<br><br><br>
	<input type="button" value="avanti" class="yellowBigButton" style="width: 250px;"
		onclick="gestione_tipo_scheda_inserimento()" />
		
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<#if numeroPratica??>
	<button type="button" class="yellowBigButton" style="width: 250px;" 
		onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti'">ANNULLA</button>
	<#else>
	<button type="button" class="yellowBigButton" style="width: 250px;" 
		onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='OpuStab.do?command=SearchForm'">ANNULLA</button>
	</#if>
</center>
</div>

<div id="scheda_inserimento_osa" style="display: none">

<#list lineaattivita as lista>
	<#if lista?is_first >
		<input type="button" id="pulisciform" name="pulisciform" value="pulisci schermata" style="display: none"
			<#if numeroPratica??>
				onclick="var link = 'GestioneAnagraficaAction.do?command=Choose&numeroPratica=${numeroPratica}&tipoPratica=${tipoPratica}&dataPratica=${dataPratica}&comunePratica=${comunePratica}';
       		<#else>
       			onclick="var link = 'GestioneAnagraficaAction.do?command=Choose';			
       		</#if>
       		window.location.href=link;"/>
	</#if>
</#list>

<table class="table details" id="tabella_linee" style="border-collapse: collapse" width="100%" cellpadding="5"> 
<#list lineaattivita as lista>
	<#if lista.ftl_name??> 
		<#assign gruppo = '${lista.ftl_name}'> 
		<#if gruppo == 'impresa'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'rappleg'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'resp_stab'>
			<#include "sezioni/templateSezioni.ftl">				
		<#elseif gruppo == 'sedeleg'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'stab'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'attivita'>
			<#include "sezioni/templateSezioni.ftl">			
		<#elseif gruppo == 'abusivo'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'luogoabusivo'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'dettagliaddizionali'>
			<#include "sezioni/templateSezioni.ftl">
		<#elseif gruppo == 'attivitamultiple'>
			<#include "sezioni/templateSezioni.ftl">
			<#-- <#include "sezioni/templateLineeAttivita.ftl"> -->
		</#if>
	<#else>
	</#if> 
</#list>

</table>
<br><br>
<center>

<button type="submit" class="yellowBigButton" style="width: 250px;">SALVA</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="yellowBigButton" style="width: 250px;" value="ANNULLA" 
			<#if numeroPratica??>
				onclick="var link = 'GestioneAnagraficaAction.do?command=Choose&numeroPratica=${numeroPratica}&tipoPratica=${tipoPratica}&dataPratica=${dataPratica}&comunePratica=${comunePratica}';
       		<#else>
       			onclick="var link = 'GestioneAnagraficaAction.do?command=Choose';			
       		</#if>
       		window.location.href=link;"/>

</center>
</div>
</form>
<br><br>

<div id='dialogimprese'/>
<div id='popuplineeattivita'/>
<script src="javascript/noscia/widget.js"></script>
<script src="javascript/gestioneanagrafica/aggiungiLinea.js"></script>

<script>
function validateForm()
{

	var num_linee = document.getElementById('numero_linee_effettivo').value;
	if(num_linee == '0'){
		alert('Deve esserci almeno una linea di attivita');
		return false;
	}
	
	var campi = document.getElementById("scheda_inserimento_osa").getElementsByTagName("input");
	for(var x = 0; x < campi.length; x++){
	
		if(campi[x].id.includes("codice_univoco_ml")>0){
			for(var y = 0; y < campi.length; y++){
				if((campi[x].id != campi[y].id) && (campi[x].id.includes("codice_univoco_ml")>0) && (campi[x].value == campi[y].value)){
					alert('Attenzione! Linea di attivita selezionata piu volte');
					return false;
				}
			}
		}
	}
	
	var tipo_attivita = document.getElementById('tipo_linee_attivita').value;
	var tipo_impresa = document.getElementById('tipo_impresa').value;
	
	if(tipo_impresa == '15' || tipo_impresa == '16' || tipo_impresa == '17'){
		if(document.getElementById("partita_iva_impresa").value.trim() == '' && document.getElementById("codice_fiscale_impresa").value.trim() == ''){
			alert('ATTENZIONE. Indicare obbligatoriamente almeno uno tra Codice Fiscale Impresa e Partita IVA.');
			return false;
		}
	}
	
	if(tipo_attivita == '1' && tipo_impresa == '11'){
		document.getElementById('nazione_sede_legale').value = document.getElementById('nazione_residenza_rapp_legale').value;
		document.getElementById('comune_estero_sede_legale').value = document.getElementById('comune_residenza_estero_rapp_legale').value;
		document.getElementById('comuneIdSedeLegale').value = document.getElementById('comuneIdResidenzaRappLegale').value;
		document.getElementById('topIdSedeLegale').value = document.getElementById('topIdResidenzaRappLegale').value;
		document.getElementById('provinciaIdSedeLegale').value = document.getElementById('provinciaIdResidenzaRappLegale').value;
		document.getElementById('via_sede_legale').value = document.getElementById('via_residenza_rapp_legale').value;
		document.getElementById('civico_sede_legale').value = document.getElementById('civico_residenza_rapp_legale').value;
		document.getElementById('cap_sede_legale').value = document.getElementById('cap_residenza_rapp_legale').value;
	}
	
	if(tipo_attivita == '2' && tipo_impresa == '11'){
		document.getElementById('nazione_residenza_rapp_legale').value = document.getElementById('nazione_sede_legale').value;
		document.getElementById('comune_residenza_estero_rapp_legale').value = document.getElementById('comune_estero_sede_legale').value;
		document.getElementById('comuneIdResidenzaRappLegale').value = document.getElementById('comuneIdSedeLegale').value;
		document.getElementById('topIdResidenzaRappLegale').value = document.getElementById('topIdSedeLegale').value;		
		document.getElementById('provinciaIdResidenzaRappLegale').value = document.getElementById('provinciaIdSedeLegale').value;		
		document.getElementById('via_residenza_rapp_legale').value = document.getElementById('via_sede_legale').value;
		document.getElementById('civico_residenza_rapp_legale').value = document.getElementById('civico_sede_legale').value;
		document.getElementById('cap_residenza_rapp_legale').value = document.getElementById('cap_sede_legale').value;
	}
	
    loadModalWindowCustom("Attendere Prego...");
	return true;
}

function gestione_tipo_scheda_inserimento()
{
	document.getElementById('tr_codice_fiscale_impresa').innerHTML = '<td class="formLabel">CODICE FISCALE IMPRESA</td>' + 
					'<td>' +
						'<input type="text" id="codice_fiscale_impresa" name="_b_codice_fiscale" value="" maxlength="16" pattern="[A-Za-z0-9]{1,}" title="inserire caratteri alfanumerici">' + 
						'<input id="ugualecodicefiscale" type="checkbox" ' + 
							' onclick="if(this.checked){document.getElementById(\'codice_fiscale_impresa\').value=document.getElementById(\'partita_iva_impresa\').value;}else{document.getElementById(\'codice_fiscale_impresa\').value=\'\';}"/>UGUALE ALLA P.IVA' +
					'</td>'; 
	
	var tipo_attivita = document.getElementById('tipo_linee_attivita').value;
	document.getElementById('ins_indirizzo_residenza_rapp_legale').style = 'display: none'; 
	document.getElementById('indirizzo_residenza_rapp_legale').onclick = function(){
			openCapWidget('toponimo_residenza_rapp_legale','topIdResidenzaRappLegale','via_residenza_rapp_legale',
						  'civico_residenza_rapp_legale','comune_residenza_rapp_legale','comuneIdResidenzaRappLegale',
						  'cap_residenza_rapp_legale','provincia_residenza_rapp_legale','provinciaIdResidenzaRappLegale');
			 };
	
	if(tipo_attivita == '1'){
		document.getElementById('coordinate_sede_legale').style = 'display: none'; 
		document.getElementById('ins_numero_registrazione').style = 'display: none';
		document.getElementById('numero_registrazione_stabilimento').disabled = true;
		document.getElementById('calcola_coord_stabilimento').onclick = function(){
			getCoordinate('toponimo_stabilimento','via_stabilimento','comune_stabilimento','provincia_stabilimento','cap_stabilimento','lat_stabilimento','long_stabilimento');
			recuperaAsl('comuneIdStabilimento', 'asl_stabilimento');
		};
		
		document.getElementById('ins_indirizzo_sede_legale').style = 'display: none';
		document.getElementById('indirizzo_sede_legale').onclick = function(){
			openCapWidget('toponimo_sede_legale','topIdSedeLegale','via_sede_legale','civico_sede_legale',
						  'comune_sede_legale','comuneIdSedeLegale','cap_sede_legale','provincia_sede_legale',
						  'provinciaIdSedeLegale');
		};
		
		document.getElementById('ins_indirizzo_stabilimento').style = 'display: none';
		
		if(document.getElementById('idComunePratica') != null){
			//chiama widget ridotto
			document.getElementById('comune_stabilimento').value = '<#if numeroPratica??>${comuneTesto}<#else></#if>';
			document.getElementById('provincia_stabilimento').value = '<#if numeroPratica??>${desc_provincia}<#else></#if>';
			document.getElementById('indirizzo_stabilimento').onclick = function(){
				openCapWidgetRidotta('toponimo_stabilimento','topIdStabilimento','via_stabilimento','civico_stabilimento',
							  'comune_stabilimento', 'comuneIdStabilimento','cap_stabilimento','provincia_stabilimento',
							  'provinciaIdStabilimento','campania', document.getElementById('id_asl_stab').value, 
							  document.getElementById('idComunePratica').value, <#if numeroPratica??>${idprovinciain}<#else></#if>); 
				document.getElementById('lat_stabilimento').value = '';
			    document.getElementById('long_stabilimento').value = '';
				document.getElementById('asl_stabilimento').value = null; 
			    document.getElementById('numero_registrazione_stabilimento').value = ''; 
			    document.getElementById('ins_numero_registrazione').disabled = false;
			};
		} else {
			document.getElementById('indirizzo_stabilimento').onclick = function(){
				openCapWidget('toponimo_stabilimento','topIdStabilimento','via_stabilimento','civico_stabilimento',
							  'comune_stabilimento', 'comuneIdStabilimento','cap_stabilimento','provincia_stabilimento',
							  'provinciaIdStabilimento','campania', document.getElementById('id_asl_stab').value); 
				document.getElementById('lat_stabilimento').value = '';
			    document.getElementById('long_stabilimento').value = '';
				document.getElementById('asl_stabilimento').value = null; 
			    document.getElementById('numero_registrazione_stabilimento').value = ''; 
			    document.getElementById('ins_numero_registrazione').disabled = false;
			};
		}
		
		document.getElementById('tipo_impresa').onchange = function(){
			if(document.getElementById('tipo_impresa').value == '11'){
				document.getElementById('tr_sede_legale_id').style = 'display: none';
				document.getElementById('tr_nazione_sede_legale').style = 'display: none';
				document.getElementById('indirizzo_sede_legale').style = 'display: none';
				document.getElementById('cap_residenza_rapp_legale').setAttribute('required', '');
				document.getElementById('cap_sede_legale').removeAttribute('required');
				document.getElementById('cap_residenza_rapp_legale').removeAttribute('readonly');
				document.getElementById('cap_residenza_rapp_legale').onkeydown= function(){return false;};
			}else{
				document.getElementById('tr_sede_legale_id').style = 'display: ';
				document.getElementById('tr_nazione_sede_legale').style = 'display: ';
				document.getElementById('indirizzo_sede_legale').style = 'display: ';
				document.getElementById('cap_residenza_rapp_legale').removeAttribute('required');
				document.getElementById('cap_sede_legale').setAttribute('required', '');
				document.getElementById('cap_residenza_rapp_legale').removeAttribute('readonly');
				document.getElementById('cap_residenza_rapp_legale').onkeydown= function(){return false;};
			}
			
			if(document.getElementById('tipo_impresa').value == '16' || document.getElementById('tipo_impresa').value == '15' || document.getElementById('tipo_impresa').value == '17'){
				document.getElementById('partita_iva_impresa').removeAttribute('required');
			}else{
				document.getElementById('partita_iva_impresa').setAttribute('required', '');
			}
		};
	}
	
	if(tipo_attivita == '2'){
		document.getElementById('tr_nazione_sede_legale').style = 'display: none'; 
		document.getElementById('tr_stabilimento_id_sezione').style = 'display: none';
		document.getElementById('indirizzo_stabilimento').style = 'display: none';
		document.getElementById('coordinate_stabilimento').style = 'display: none';
		
		document.getElementById('lat_sede_legale').setAttribute('required', '');
		document.getElementById('long_sede_legale').setAttribute('required', '');
		document.getElementById('ins_indirizzo_sede_legale').style = 'display: none';
		
		if(document.getElementById('idComunePratica') != null){
			//chiama widget ridotto
			document.getElementById('comune_sede_legale').value = '<#if numeroPratica??>${comuneTesto}<#else></#if>';
			document.getElementById('provincia_sede_legale').value = '<#if numeroPratica??>${desc_provincia}<#else></#if>';
			document.getElementById('indirizzo_sede_legale').onclick = function(){
				openCapWidgetRidotta('toponimo_sede_legale','topIdSedeLegale','via_sede_legale','civico_sede_legale','comune_sede_legale',
							  'comuneIdSedeLegale','cap_sede_legale','provincia_sede_legale','provinciaIdSedeLegale',
							  'campania', '-1', 
							  document.getElementById('idComunePratica').value, <#if numeroPratica??>${idprovinciain}<#else></#if>);
				document.getElementById('lat_sede_legale').value = '';
			    document.getElementById('long_sede_legale').value = '';
				document.getElementById('asl_stabilimento').value = null; 
			    document.getElementById('numero_registrazione_stabilimento').value = ''; 
			    document.getElementById('ins_numero_registrazione').disabled = false;
			};
		} else {
				
			document.getElementById('indirizzo_sede_legale').onclick = function(){
				openCapWidget('toponimo_sede_legale','topIdSedeLegale','via_sede_legale','civico_sede_legale','comune_sede_legale',
							  'comuneIdSedeLegale','cap_sede_legale','provincia_sede_legale','provinciaIdSedeLegale',
							  'campania', '-1');
				document.getElementById('lat_sede_legale').value = '';
			    document.getElementById('long_sede_legale').value = '';
				document.getElementById('asl_stabilimento').value = null; 
			    document.getElementById('numero_registrazione_stabilimento').value = ''; 
			    document.getElementById('ins_numero_registrazione').disabled = false;
			};
		}
		
		document.getElementById('ins_numero_registrazione').onclick = function(){
			getNumeroRegistrazioneStabilimento('comuneIdSedeLegale', 'numero_registrazione_stabilimento');
        	this.disabled = true;
        	recuperaAsl('comuneIdSedeLegale', 'asl_stabilimento');
		};
		
		document.getElementById('cap_stabilimento').removeAttribute('required');
		document.getElementById('lat_stabilimento').removeAttribute('required');
		document.getElementById('long_stabilimento').removeAttribute('required');
		
		document.getElementById('attivita_id_sezione').onclick = function(){
			if(document.getElementById('numero_linee_effettivo').value == '0'){
				aggiungi_linea();
			}
		};
		
		document.getElementById('ins_numero_registrazione').style = 'display: none';
		document.getElementById('numero_registrazione_stabilimento').disabled = true;
		document.getElementById('calcola_coord_sede_legale').onclick = function(){
			getCoordinate('toponimo_sede_legale','via_sede_legale','comune_sede_legale','provincia_sede_legale','cap_sede_legale','lat_sede_legale','long_sede_legale');
			recuperaAsl('comuneIdSedeLegale', 'asl_stabilimento');
		};
		
		document.getElementById('tipo_impresa').onchange = function(){
			if(document.getElementById('tipo_impresa').value == '11'){
				document.getElementById('tr_sede_legale_id').style = 'display: none';
				document.getElementById('tr_nazione_residenza_rapp_legale').style = 'display: none';
				document.getElementById('indirizzo_residenza_rapp_legale').style = 'display: none';
			}else{
				document.getElementById('tr_sede_legale_id').style = 'display: ';
				document.getElementById('tr_nazione_residenza_rapp_legale').style = 'display: ';
				document.getElementById('indirizzo_residenza_rapp_legale').style = 'display: ';

			}
			
			if(document.getElementById('tipo_impresa').value == '16' || document.getElementById('tipo_impresa').value == '15' || document.getElementById('tipo_impresa').value == '17'){
				document.getElementById('partita_iva_impresa').removeAttribute('required');
			}else{
				document.getElementById('partita_iva_impresa').setAttribute('required', '');
			}
		};	
	}
	
	if(tipo_attivita == '3'){
		document.getElementById('tr_nazione_sede_legale').style = 'display: none'; 
		document.getElementById('ins_indirizzo_sede_legale').onclick = function(){
			openCapWidget('toponimo_sede_legale','topIdSedeLegale','via_sede_legale','civico_sede_legale','comune_sede_legale',
						  'comuneIdSedeLegale','cap_sede_legale','provincia_sede_legale','provinciaIdSedeLegale',
						  'campania', document.getElementById('id_asl_stab').value);
			document.getElementById('lat_sede_legale').value = '';
		    document.getElementById('long_sede_legale').value = '';
		};
		
		document.getElementById('lat_sede_legale').setAttribute('required', '');
		document.getElementById('long_sede_legale').setAttribute('required', '');	
		document.getElementById('ins_numero_registrazione').style = 'display: none';
		document.getElementById('numero_registrazione_stabilimento').disabled = true;
		document.getElementById('calcola_coord_stabilimento').onclick = function(){
			getCoordinate('toponimo_stabilimento','via_stabilimento','comune_stabilimento','provincia_stabilimento','cap_stabilimento','lat_stabilimento','long_stabilimento');
			recuperaAsl('comuneIdStabilimento', 'asl_stabilimento');
		};	
	}
	
	document.getElementById('scheda_inserimento_osa').style='display:'; 
	document.getElementById('tipo_linee').style='display: none';
}

</script>









<!-- FORZO SALTO DELLA SCELTA TIPO STABILIMENTO -->
<script>gestione_tipo_scheda_inserimento()</script> 
<!-- FORZO SALTO DELLA SCELTA TIPO STABILIMENTO -->
