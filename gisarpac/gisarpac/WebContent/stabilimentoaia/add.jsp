<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:useBean id="TipoImpresaList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="NazioniList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ComuniList" class="org.aspcfs.utils.web.LookupList" scope="request" />


<script src="javascript/vendor/moment.min.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>
<script src="javascript/noscia/codiceFiscale.js"></script>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
  <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
<script type="text/javascript" src="dwr/interface/DWRnoscia.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
<script src="javascript/gestioneanagrafica/add.js"></script>


<script>
function gestione_tipo_scheda_inserimento()
{
	document.getElementById('tr_codice_fiscale_impresa').innerHTML = '<td class="formLabel">CODICE FISCALE IMPRESA</td>' + 
					'<td>' +
						'<input type="text" id="codice_fiscale_impresa" name="codice_fiscale_impresa" value="" maxlength="16" pattern="[A-Za-z0-9]{1,}" title="inserire caratteri alfanumerici">' + 
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
							  'provinciaIdStabilimento','campania',  
							  document.getElementById('idComunePratica').value ); 
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
							  'provinciaIdStabilimento','campania','-1'); 
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
							  document.getElementById('idComunePratica').value );
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
		
		document.getElementById('ippc_id_sezione').onclick = function(){
			if(document.getElementById('numero_ippc_effettivo').value == '0'){
				aggiungi_ippc();
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
						  'campania');
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
	
	document.getElementById('tipo_linee').style='display: none';
}



</script>


</head>
<body>
<form name="addStab" action="StabilimentoAIA.do?command=Insert" onSubmit="return validateForm()" method="post">
 <div id="tipo_linee" style="display:none">
<center>
	<h2>Stai per inserire uno stabilimento:</h2>
	<select id="tipo_linee_attivita" style="text-align:center; font-size: 20px ;width: 400px;">
		<option value="1">con sede fissa</option>
	</select>
	</center>
	
	<br><br><br>
	<input type="button" value="avanti" class="yellowBigButton" style="width: 250px;"
		onclick="gestione_tipo_scheda_inserimento()" />
		</div>
<table class="table details" id="tabella_linee" style="border-collapse: collapse" width="100%" cellpadding="5"> 
 	 			<input type="button" id="pulisciform" name="pulisciform" value="pulisci schermata" style="display: none" onclick="var link = 'StabilimentoAIA.do?command=Add';window.location.href=link;">
 	 				<input type="hidden" id="id_stabilimento" name="id_stabilimento">	
				<tbody><tr id="tr_dati_impresa_id">
					<th colspan="2">DATI IMPRESA  
					<input type="text" hidden id="dati_impresa_id" name="dati_impresa_id" placeholder="    VERIFICA ESISTENZA MEDIANTE PARTITA IVA" maxlength="11" pattern="[0-9]{11}" title="inserire 11 caratteri alfanumerici" size="40">		
					</th>
				</tr>
 	 				<input type="hidden" id="id_impresa_recuperata" name="id_impresa_recuperata">	
 	 				<input type="hidden" id="id_rapp_legale_recuperato" name="id_rapp_legale_recuperato">	
			<tr id="tr_ragione_sociale_impresa" title="" size="70" required="true">
				<td class="formLabel">RAGIONE SOCIALE</td>
				<td>
					<input type="text" id="ragione_sociale_impresa" name="ragione_sociale" value="" size="70" required="true" title="inserire ragione sociale impresa">
			</td></tr>
			<tr id="tr_partita_iva_impresa" title="" maxlength="11" pattern="[0-9]{11}" required="true">
				<td class="formLabel">PARTITA IVA</td>
				<td>
					<input type="text" id="partita_iva_impresa" name="partita_iva" value="" maxlength="11" pattern="[0-9]{11}" required="true" title="inserire 11 caratteri numerici" onblur="myfunction();
var objImpresa;
function myfunction()
{
	if(document.getElementById('partita_iva_impresa').readOnly){
		return false;
	}
	var partita_iva = document.getElementById('partita_iva_impresa').value; 
	if (trim(partita_iva.toString()) != ''){
		loadModalWindowCustom('Verifica Esistenza Impresa. Attendere');
		DWRnoscia.controlloEsistenzaAiaImpresa(partita_iva, {callback:recuperaDatiImpresaCallBack,async:true});
	}
}
   
$(function() {
	
	 $('#dialogimprese').dialog({
		title : 'IMPRESA ESISTENTE IN ANAGRAFICA CON LA PARTITA IVA INSERITA : ',
         autoOpen: false,
         resizable: false,
         closeOnEscape: false,
         width:850,
         height:350,
         draggable: false,
         modal: true,
	     buttons: {
			 'IMPRESA SELEZIONATA': function() {
				var impresaDaInserire = getRadioValue('radioimpsele'); 
				selezionaImpresa(impresaDaInserire);
				$( this ).dialog('close');
			},
			'ESCI': function() {
                                loadModalWindowUnlock();
				$( this ).dialog('close');
			}
      }
 });
	 
});

function getRadioValue(theRadioGroup)
{
    var elements = document.getElementsByName(theRadioGroup);
    for (var i = 0, l = elements.length; i < l; i++)
    {
        if (elements[i].checked)
        {
            return elements[i].value;
        }
    }
}
	
function recuperaDatiImpresaCallBack(returnValue)
{
	console.log(returnValue)
	var dati = returnValue;
	var obj;
	var impresa_selezionata = null;
	obj = JSON.parse(dati);
	objImpresa = obj;
	console.log(obj.length)

	var len = obj.length;
	if (len > 0){
		var htmlText='<br>'; 
		htmlText+='<table border=\'1\'><tr><th>Denominazione</th><th>Partita IVA</th><th>Rappresentante Legale</th><th>Sede Legale</th><th></th></tr>';
		for (i = 0; i < len; i++){
			htmlText+='<tr><td>'+obj[i].ragione_sociale_impresa+'</td><td>'+obj[i].partita_iva_impresa+'</td><td>'+obj[i].nome_rapp_legale + ' ' + obj[i].cognome_rapp_legale+ ' ' +obj[i].cf_rapp_legale+ ' '+obj[i].provincia_residenza_rapp_legale+' ' +obj[i].comune_residenza_rapp_legale+' '+obj[i].toponimo_residenza_rapp_legale+' '+obj[i].via_residenza_rapp_legale+'</td><td>'+obj[i].provincia_sede_legale+' '+obj[i].comune_sede_legale+' '+obj[i].toponimo_sede_legale+' '+obj[i].via_sede_legale+'</td><td><input type=\'radio\' id=\'radioimpsele\' name=\'radioimpsele\' value=\''+i+'\'></td></tr>';
		}
		htmlText+='</table>';
			console.log('ciao')
		
        $('#dialogimprese').html(htmlText);
        	console.log('ciao1')
        loadModalWindowUnlock();
        $('#dialogimprese').dialog('open');
		
	} else {
                loadModalWindowUnlock();
        }
}

function selezionaImpresa(impresaScelta){
	var obj = objImpresa[impresaScelta];
	for (var key in obj)
		{      
			var elemento = obj[key];
			var keyfield =  document.getElementById(key);
			if (typeof(keyfield) != 'undefined' && keyfield != null)
			{
				
				keyfield.value = elemento;
				if(elemento)
				{
					if(keyfield.tagName == 'SELECT')
					{
						var hfield = document.createElement('input');
						hfield.setAttribute('type','hidden');
						hfield.setAttribute('name',keyfield.name);
						hfield.setAttribute('id',keyfield.id);
						hfield.setAttribute('value',keyfield.value);
						document.getElementById('pulisciform').appendChild(hfield);
						keyfield.disabled = true;
					}else{
						keyfield.readOnly = true;
					}
					
				}
				
			}
		}
       if(document.getElementById('data_nascita_rapp_legale').value){
               var field =  document.getElementById('data_nascita_rapp_legale');
               var hfield = document.createElement('input');
						hfield.setAttribute('type','hidden');
						hfield.setAttribute('name',field.name);
						hfield.setAttribute('id',field.id);
						hfield.setAttribute('value',field.value);
						document.getElementById('pulisciform').appendChild(hfield);
						field.disabled = true;
       }
       if (document.getElementById('via_residenza_rapp_legale').value){
		document.getElementById('ins_indirizzo_residenza_rapp_legale').disabled = true;
	}
	if (document.getElementById('via_sede_legale').value){
		document.getElementById('ins_indirizzo_sede_legale').disabled = true;
	}
	
	if(document.getElementById('nazione_nascita_rapp_legale').value != 106)
	{
		document.getElementById('tr_comune_nascita_rapp_legale').style='display: none';
		document.getElementById('tr_comune_nascita_estero_rapp_legale').style='display: block inline-block';
		document.getElementById('comune_nascita_estero_rapp_legale').style='display: block inline-block';
		document.getElementById('comune_nascita_estero_rapp_legale').disabled = false;
		document.getElementById('comune_nascita_estero_rapp_legale').readOnly = true;
		document.getElementById('comune_nascita_rapp_legale').disabled = true;
		document.getElementById('calcola_cf_rapp_legale').style='display: none';
	}
	
        if(document.getElementById('cf_rapp_legale').value){
		document.getElementById('calcola_cf_rapp_legale').disabled = true;
	}

	if(document.getElementById('nazione_residenza_rapp_legale').value != '106'){
		document.getElementById('indirizzo_residenza_rapp_legale').style='display: none';
		document.getElementById('tr_comune_residenza_estero_rapp_legale').style='display: block inline-block';
		document.getElementById('comune_residenza_estero_rapp_legale').style='display: block inline-block';
	        document.getElementById('comune_residenza_rapp_legale').value = '';
	}

	if(document.getElementById('nazione_sede_legale').value != '106'){
		document.getElementById('indirizzo_sede_legale').style='display: none';
		document.getElementById('tr_comune_estero_sede_legale').style='display: block inline-block';
		document.getElementById('comune_estero_sede_legale').style='display: block inline-block';
	        document.getElementById('cap_sede_legale').removeAttribute('required');
	       
	        document.getElementById('comune_sede_legale').value = '';
	}
	
        document.getElementById('dati_impresa_id').value = document.getElementById('partita_iva_impresa').value;
        document.getElementById('dati_impresa_id').readOnly = true;
	document.getElementById('partita_iva_impresa').readOnly = true;		
}">
			</td></tr>
			<tr id="tr_codice_fiscale_impresa" title="" maxlength="16" pattern="[A-Za-z0-9]{1,}"><td class="formLabel">CODICE FISCALE IMPRESA</td><td><input type="text" id="codice_fiscale_impresa" name="codice_fiscale_impresa" value="" maxlength="16" pattern="[A-Za-z0-9]{1,}" title="inserire caratteri alfanumerici"><input id="ugualecodicefiscale" type="checkbox" onclick="if(this.checked){document.getElementById('codice_fiscale_impresa').value=document.getElementById('partita_iva_impresa').value;}else{document.getElementById('codice_fiscale_impresa').value='';}">UGUALE ALLA P.IVA</td></tr>
 				<tr id="tr_tipo_impresa" required="true">
    				<td class="formLabel">TIPO IMPRESA</td>
        			<td>
            			<%=TipoImpresaList.getHtmlSelect("tipo_impresa",1)%>
        			</td>
 				</tr>
			<tr id="tr_email_impresa" title="" size="50">
				<td class="formLabel">DOMICILIO DIGITALE (PEC)</td>
				<td>
					<input type="text" id="email_impresa" name="email_impresa" value="" size="50">
			</td></tr>
				<tr id="tr_rapp_legale_id">
					<th colspan="2">GESTORE IMPIANTO 
					</th>
				</tr>
			<tr id="tr_nome_rapp_legale" title="" required="true" pattern="[A-Za-z รง']{1,70}">
				<td class="formLabel">NOME</td>
				<td>
					<input type="text" id="nome_rapp_legale" name="nome_rapp_leg" value="" required="true" pattern="[A-Za-z รง']{1,70}" title="inserire nome rappresentante legale" onchange="document.getElementById('cf_rapp_legale').value = '';">
			</td></tr>
			<tr id="tr_cognome_rapp_legale" title="" required="true" pattern="[A-Za-z ']{1,70}">
				<td class="formLabel">COGNOME</td>
				<td>
					<input type="text" id="cognome_rapp_legale" name="cognome_rapp_leg" value="" required="true" pattern="[A-Za-z ']{1,70}" title="inserire cognome rappresentante legale" onchange="document.getElementById('cf_rapp_legale').value = '';">
			</td></tr>
 				<tr id="tr_sesso_rapp_legale">
    				<td class="formLabel">SESSO</td>
        			<td>
            			<select name="sesso_rapp_leg" id="sesso_rapp_legale" onchange="document.getElementById('cf_rapp_legale').value = '';">
                    			<option value="M">M</option>                 
                    			<option value="F">F</option>                 
            			</select>
        			</td>
 				</tr>
 				<tr id="tr_nazione_nascita_rapp_legale">
    				<td class="formLabel">NAZIONE NASCITA</td>
        			<td>
        			<%NazioniList.setJsEvent("onChange=javascript:nazioneReset() ");%>
        			<%=NazioniList.getHtmlSelect("nazione_nascita_rapp_legale",-1)%>
        			 
        			</td>
 				</tr>
 				<tr id="tr_comune_nascita_rapp_legale">
    				<td class="formLabel">COMUNE NASCITA</td>
        			<td>
            	<%=ComuniList.getHtmlSelect("comune_nascita_rapp_legale",0)%>
            			
        			</td>
 				</tr>
			<tr id="tr_comune_nascita_estero_rapp_legale" title="" style="display: none;">
				<td class="formLabel">COMUNE NASCITA ESTERO</td>
				<td>
					<input type="text" id="comune_nascita_estero_rapp_legale" name="comune_nascita_rapp_leg" value="" style="display: none;">
			</td></tr>
 			<tr>
        		<td class="formLabel">DATA NASCITA</td>
        		<td>
        		
                	<input placeholder="Inserisci data" type="text" id="data_nascita_rapp_legale" name="data_nascita_rapp_legale" autocomplete="off" >                
                	<script>

                	$( '#data_nascita_rapp_legale' ).datepicker({
						  dateFormat: 'dd-mm-yy',
						  changeMonth: true,
						  changeYear: true,
						  yearRange: '-100:+3',					
						  maxDate: '-18Y', 
onSelect: function(){
   document.getElementById('cf_rapp_legale').value = '';
},
						  dayNamesMin : [ 'do', 'lu', 'ma', 'me', 'gi', 've', 'sa' ],
						  monthNamesShort :['Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno', 'Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'],
						  beforeShow: function(input, inst) {
                                 setTimeout(function () {
                                            var offsets = $('#data_nascita_rapp_legale').offset();
                                            var top = offsets.top - 100;
                                            inst.dpDiv.css({ top: top, left: offsets.left});
                                            $(".ui-datepicker-next").hide();
											$(".ui-datepicker-prev").hide();
											$(".ui-state-default").css({'font-size': 15});
											$(".ui-datepicker-title").css({'text-align': 'center'});
											$(".ui-datepicker-calendar").css({'text-align': 'center'});
                                  });
                                },
                           onChangeMonthYear: function(year, month, inst) {
                                 setTimeout(function () {
                                            var offsets = $('#data_nascita_rapp_legale').offset();
                                            var top = offsets.top - 100;
                                            inst.dpDiv.css({ top: top, left: offsets.left});
                                            $(".ui-datepicker-next").hide();
											$(".ui-datepicker-prev").hide();
											$(".ui-state-default").css({'font-size': 15});
											$(".ui-datepicker-title").css({'text-align': 'center'});
											$(".ui-datepicker-calendar").css({'text-align': 'center'});
                                  });
                                }                                                  
						});
                	
                	</script>
        		</td>
        	</tr>
        	
				<tr id="codice_fiscale_rapp_legale">
				<td class="formLabel">CODICE FISCALE</td>	
				<td>
								<input type="text" id="cf_rapp_legale" name="codice_fiscale_rappresentante" placeholder="CODICE FISCALE" value="" maxlength="30" pattern="[A-Za-z0-9]{1,30}" required="true" title="inserire caratteri alfanumerici" autocomplete="off" size="30" onkeydown="if(document.getElementById('nazione_nascita_rapp_legale').value != 106)
	{
             
               return true;
	}else{
		return false;
	}">
					 			<input type="button" id="calcola_cf_rapp_legale" value="CALCOLA CODICE FISCALE" onclick="CalcolaCF('sesso_rapp_legale', 'nome_rapp_legale', 'cognome_rapp_legale', 'comune_nascita_rapp_legale', 'data_nascita_rapp_legale','cf_rapp_legale')">     
        		</td>
				</tr>
        	
 				<tr id="tr_nazione_residenza_rapp_legale">
    				<td class="formLabel">NAZIONE RESIDENZA</td>
        			<td>
        			<%NazioniList.setJsEvent("onChange=javascript:nazioneResetResi()");%>
        			<%=NazioniList.getHtmlSelect("nazione_residenza_rapp_legale",-1)%>
            			
        			</td>
 				</tr>
			<tr id="tr_provincia_residenza_estrero_rapp_legale" title="" style="display: none;">
				<td class="formLabel">PROVINCIA RESIDENZA ESTERO</td>
				<td>
					<input type="text" id="provincia_residenza_estrero_rapp_legale" name="provincia_residenza_estero_rapp_legale" value="" style="display: none;">
			</td></tr>
			<tr id="tr_comune_residenza_estero_rapp_legale" title="" style="display: none;">
				<td class="formLabel">COMUNE RESIDENZA ESTERO</td>
				<td>
					<input type="text" id="comune_residenza_estero_rapp_legale" name="comune_residenza_estero_soggfis" value="" style="display: none;">
			</td></tr>
				<tr id="indirizzo_residenza_rapp_legale">
				<td class="formLabel">INDIRIZZO RESIDENZA</td>	
				<td>
								<input type="text" id="toponimo_residenza_rapp_legale" name="toponimo_residenza_rapp_legale" placeholder="TOPONIMO" value="" size="10" readonly="">
								<input type="text" id="via_residenza_rapp_legale" name="via_soggfis" placeholder="VIA" value="" size="38" readonly="">
								<input type="text" id="civico_residenza_rapp_legale" name="civico_soggfis" placeholder="CIVICO" value="" size="10" readonly="">
								<input type="text" id="cap_residenza_rapp_legale" name="cap_soggfis" placeholder="CAP" value="" size="5" maxlength="5" readonly="">
								<input type="text" id="comune_residenza_rapp_legale" name="comune_residenza_rapp_legale" placeholder="COMUNE" value="" size="30" readonly="">
								<input type="text" id="provincia_residenza_rapp_legale" name="provincia_residenza_rapp_legale" placeholder="PROVINCIA" value="" size="18" readonly="">
					 			<input type="button" id="ins_indirizzo_residenza_rapp_legale" value="INSERISCI INDIRIZZO" onclick="openCapWidget('toponimo_residenza_rapp_legale','topIdResidenzaRappLegale','via_residenza_rapp_legale','civico_residenza_rapp_legale','comune_residenza_rapp_legale','comuneIdResidenzaRappLegale','cap_residenza_rapp_legale','provincia_residenza_rapp_legale','provinciaIdResidenzaRappLegale')" >     
        		</td>
				</tr>
        	
 	 				<input type="hidden" id="topIdResidenzaRappLegale" name="toponimo_soggfis">	
 	 				<input type="hidden" id="comuneIdResidenzaRappLegale" name="cod_comune_soggfis">	
 	 				<input type="hidden" id="provinciaIdResidenzaRappLegale" name="cod_provincia_soggfis">	
			<tr id="tr_email_rapp_legale" title="" size="50">
				<td class="formLabel">DOMICILIO DIGITALE (PEC)</td>
				<td>
					<input type="text" id="email_rapp_legale" name="email_rapp_leg" value="" size="50">
			</td></tr>
			<tr id="tr_telefono_rapp_legale" title="">
				<td class="formLabel">TELEFONO</td>
				<td>
					<input type="text" id="telefono_rapp_legale" name="telefono_rapp_leg" value="">
			</td></tr>
				<tr id="tr_">
					<th colspan="2">RESPONSABILE IMPIANTO 
					</th>
				</tr>
			<tr id="tr_nome_resp_stab" title="">
				<td class="formLabel">NOME</td>
				<td>
					<input type="text" id="nome_resp_stab" name="nome_resp_stab" value="">
			</td></tr>
			<tr id="tr_cognome_resp_stab" title="">
				<td class="formLabel">COGNOME</td>
				<td>
					<input type="text" id="cognome_resp_stab" name="cognome_resp_stab" value="">
			</td></tr>
			<tr id="tr_cf_resp_stab" title="">
				<td class="formLabel">CODICE FISCALE</td>
				<td>
					<input type="text" id="cf_resp_stab" name="cf_resp_stab" value="">
			</td></tr>
				<tr id="tr_sede_legale_id">
					<th colspan="2">SEDE LEGALE 
					</th>
				</tr>
 				<tr id="tr_nazione_sede_legale">
    				<td class="formLabel">NAZIONE</td>
        			<td>
        			<%NazioniList.setJsEvent("onChange=javascript:nazioneResetNazi()");%>
        			<%=NazioniList.getHtmlSelect("nazione_sede_legale",-1)%>            			
        			</td>
 				</tr>
				<tr id="indirizzo_sede_legale">
				<td class="formLabel">INDIRIZZO</td>	
				<td>
								<input type="text" id="toponimo_sede_legale" name="toponimo_sede_leg" placeholder="TOPONIMO" value="" size="10" readonly="">
								<input type="text" id="via_sede_legale" name="via_sede_legale" placeholder="VIA" value="" size="38" readonly="">
								<input type="text" id="civico_sede_legale" name="civico_sede_legale" placeholder="CIVICO" value="" size="10" readonly="">
								<input type="text" id="cap_sede_legale" name="cap_leg" placeholder="CAP" value="" size="5" maxlength="5" onkeydown="return false;" required="" autocomplete="off">
								<input type="text" id="comune_sede_legale" name="comune_sede_legale" placeholder="COMUNE" value="" size="30" readonly="">
								<input type="text" id="provincia_sede_legale" name="provincia_sede_legale" placeholder="PROVINCIA" value="" size="18" readonly="">
					 			<input type="button" id="ins_indirizzo_sede_legale" value="INSERISCI INDIRIZZO" onclick="openCapWidget('toponimo_sede_legale','topIdSedeLegale','via_sede_legale','civico_sede_legale','comune_sede_legale','comuneIdSedeLegale','cap_sede_legale','provincia_sede_legale','provinciaIdSedeLegale')" style="display: none;">     
        		</td>
				</tr>
        	
			<tr id="tr_comune_estero_sede_legale"  style="display: none;">
				<td class="formLabel">COMUNE ESTERO SEDE LEGALE</td>
					<td><input type="text" id="comune_estero_sede_legale" name="comune_estero_sede_legale" value="" style="display: none;"></td>
			</td></tr>
 	 				<input type="hidden" id="provinciaIdSedeLegale" name="cod_provincia_sede_legale">	
 	 				<input type="hidden" id="comuneIdSedeLegale" name="cod_comune_sede_legale">	
 	 				<input type="hidden" id="topIdSedeLegale" name="toponimo_sede_legale">	
				<tr id="coordinate_sede_legale" style="display: none;">
				<td class="formLabel">COORDINATE</td>	
				<td>
								<input type="text" id="lat_sede_legale" readonly name="latitudine_leg" placeholder="LATITUDINE" value="" onfocusout="this.value=this.value.replace(/[^0-9.]+/,''); if (this.value.length==0 || !this.value.includes('.') || this.value.charAt(0) == '.' || this.value.charAt(this.value.length-1) == '.') {); this.value=''; return false}" autocomplete="off">
								<input type="text" id="long_sede_legale" readonly name="longitudine_leg" placeholder="LONGITUDINE" value="" onfocusout="this.value=this.value.replace(/[^0-9.]+/,''); if (this.value.length==0 || !this.value.includes('.') || this.value.charAt(0) == '.' || this.value.charAt(this.value.length-1) == '.') {); this.value=''; return false}" autocomplete="off">
					 			<input type="button" id="calcola_coord_sede_legale" value="CALCOLA COORDINATE" onclick="getCoordinate('toponimo_sede_legale','via_sede_legale','comune_sede_legale','provincia_sede_legale','cap_sede_legale','lat_sede_legale','long_sede_legale'); ">     
        		</td>
				</tr>
        	
				<tr id="tr_stabilimento_id_sezione">
					<th colspan="2">DATI IMPIANTO 
					</th>
				</tr>
				<tr id="indirizzo_stabilimento">
				<td class="formLabel">INDIRIZZO</td>	
				<td>
								<input type="text" id="toponimo_stabilimento" name="toponimo_stabilimento" placeholder="TOPONIMO" value="" size="10" readonly="">
								<input type="text" id="via_stabilimento" name="via_stab" placeholder="VIA" value="" size="38" readonly="">
								<input type="text" id="civico_stabilimento" name="civico_stab" placeholder="CIVICO" value="" size="10" readonly="">
								<input type="text" id="cap_stabilimento" name="cap_stab" placeholder="CAP" value="" size="5" maxlength="5" onkeydown="return false;" required autocomplete="off">
								<input type="text" id="comune_stabilimento" name="comune_stabilimento" placeholder="COMUNE" value="" size="30" readonly="">
								<input type="text" id="provincia_stabilimento" name="provincia_stabilimento" placeholder="PROVINCIA" value="" size="18" readonly="">
					 			<input type="button" id="ins_indirizzo_stabilimento" value="INSERISCI INDIRIZZO" onclick="openCapWidget('toponimo_stabilimento','topIdStabilimento','via_stabilimento','civico_stabilimento','comune_stabilimento', 'comuneIdStabilimento','cap_stabilimento','provincia_stabilimento','provinciaIdStabilimento','valledaosta')" style="display: none;">     
        		</td>
				</tr>
        	
 	 				<input type="hidden" id="provinciaIdStabilimento" name="cod_provincia_stab">	
 	 				<input type="hidden" id="comuneIdStabilimento" name="cod_comune_stab">	
 	 				<input type="hidden" id="topIdStabilimento" name="toponimo_stab">	
				<tr id="coordinate_stabilimento">
				<td class="formLabel">COORDINATE GEOGRAFICHE</td>	
				<td>
								<input type="text" id="lat_stabilimento" name="latitudine_stab" placeholder="X" value="" onfocusout="this.value=this.value.replace(/[^0-9.]+/,''); if (this.value.length==0 || !this.value.includes('.') || this.value.charAt(0) == '.' || this.value.charAt(this.value.length-1) == '.') {alert('Valorizzare le coordinate nel formato xx.yyyy'); this.value=''; return false}" required="" autocomplete="off">
								<input type="text" id="long_stabilimento" name="longitudine_stab" placeholder="Y" value="" onfocusout="this.value=this.value.replace(/[^0-9.]+/,''); if (this.value.length==0 || !this.value.includes('.') || this.value.charAt(0) == '.' || this.value.charAt(this.value.length-1) == '.') {alert('Valorizzare le coordinate nel formato xx.yyyy'); this.value=''; return false}" required="" autocomplete="off">
					 			<input type="button" id="calcola_coord_stabilimento" value="CALCOLA COORDINATE" onclick="getCoordinate('toponimo_stabilimento','via_stabilimento','comune_stabilimento','provincia_stabilimento','cap_stabilimento','lat_stabilimento','long_stabilimento')">     
        		</td>
				</tr>
        	
			<tr id="tr_denominazione_stab" title="">
				<td class="formLabel">DENOMINAZIONE</td>
				<td>
					<input type="text" id="denominazione_stab" name="denominazione_stab" value="">
			</td></tr>
				<tr id="numero_registrazione_stab">
				<td class="formLabel">NUMERO REGISTRAZIONE GISA</td>	
				<td>
								<input type="text" id="numero_registrazione_stabilimento" name="numero_registrazione_stabilimento" placeholder="NUMERO REGISTRAZIONE" value="" size="30" onkeydown="return false;" required="" autocomplete="off" disabled="">
					 			<input type="button" id="ins_numero_registrazione" value="GENERA NUMERO REGISTRAZIONE" onclick="getNumeroRegistrazioneStabilimento('comuneIdStabilimento', 'numero_registrazione_stabilimento');
              this.disabled = true;
              recuperaAsl('comuneIdStabilimento', 'asl_stabilimento');" style="display: none;">     
        		</td>
				</tr>
        	
			<tr id="tr_asl_stabilimento" title="" placeholder="dipartimento" readonly="" size="40px">
				<td class="formLabel">DIPARTIMENTO</td>
				<td>
					<input type="text" id="asl_stabilimento" name="asl_stabilimento" value="" placeholder="dipartimento" readonly="" size="40px">
 
			</td></tr>
				<tr id="tr_ippc_id_sezione">
					<th colspan="2">CODICI IPPC
							<input type="button" id="ippc_id_sezione" value="aggiungi codice ippc" onclick="aggiungi_ippc();">
					</th>
				</tr>
 	 				<input type="hidden" id="numero_ippc" name="numero_ippc" value="1">	
 	 				<input type="hidden" id="numero_ippc_effettivo" name="numero_ippc_effettivo" value="0">	
 	 				<input type="hidden" id="principale_check" name="principale_check" value="false">	
 	 				
<div id='dialogimprese'/>
<div id='popupippc'/>
<script src="javascript/noscia/widget.js"></script>
<script src="javascript/gestioneanagrafica/aggiungiIppc.js"></script>
</tbody></table>            
<br><br>
<center>

<button type="submit" class="yellowBigButton" style="width: 250px;">SALVA</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="yellowBigButton" style="width: 250px;" value="ANNULLA" onclick="var link = 'StabilimentoAIA.do?command=SearchForm';			
       		window.location.href=link;">

</center>
</div>
</form>
<br><br>
<script>





function validateForm()
{

	
	
	
	
	
	
	
	
	
	var num_linee = document.getElementById('numero_ippc_effettivo').value;
	if(num_linee == '0'){
		alert('Selezionare almeno un CODICE IPPC');
		return false;
	}
	
	
	if(document.getElementById("principale_check").value=="false"){
		alert('Deve esserci almeno un codice IPPC principale');
		return false;
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
	if(document.getElementById("nazione_nascita_rapp_legale").value==-1){
		alert("Valorizzare nazione nascita gestore impianto.")
		return false;
	}
	if(document.getElementById("nazione_residenza_rapp_legale").value==106 && document.getElementById("cap_residenza_rapp_legale").value==""){
		alert("Valorizzare indirizzo residenza gestore impianto.")
		return false;
	}
	
	if(document.getElementById("nazione_residenza_rapp_legale").value==-1 && document.getElementById("cap_residenza_rapp_legale").value!=""){
		alert("Valorizzare nazione residenza gestore impianto.")
		return false;
	}
	if(document.getElementById("nazione_residenza_rapp_legale").value!=106 && document.getElementById("nazione_residenza_rapp_legale").value!=-1 && document.getElementById("comune_residenza_estero_rapp_legale").value==""){
		alert("Valorizzare comune residenza estero gestore impianto.")
		return false;
	}
	
	if(document.getElementById("nazione_sede_legale").value==-1){
		alert("Valorizzare nazione sede legale.")
		return false;
	}
	
	
    loadModalWindowCustom("Attendere Prego...");
    return true;
}



function nazioneReset(){
	if(document.getElementById('nazione_nascita_rapp_legale').value != 106)
	{
		document.getElementById('tr_comune_nascita_rapp_legale').style='display: none';
		document.getElementById('tr_comune_nascita_estero_rapp_legale').style='display: block inline-block';
		document.getElementById('comune_nascita_estero_rapp_legale').style='display: block inline-block';
                document.getElementById('comune_nascita_estero_rapp_legale').disabled = false;
                document.getElementById('comune_nascita_estero_rapp_legale').value='';
                document.getElementById('comune_nascita_rapp_legale').disabled = true;
		document.getElementById('calcola_cf_rapp_legale').style='display: none';
                document.getElementById('cf_rapp_legale').value = '';
	}else{
		document.getElementById('tr_comune_nascita_rapp_legale').style='display: block inline-block';
		document.getElementById('tr_comune_nascita_estero_rapp_legale').style='display: none';
		document.getElementById('comune_nascita_estero_rapp_legale').style='display: none';
		document.getElementById('comune_nascita_estero_rapp_legale').value='';
                document.getElementById('comune_nascita_estero_rapp_legale').disabled = true;
                document.getElementById('comune_nascita_rapp_legale').disabled = false;
		document.getElementById('calcola_cf_rapp_legale').style='display: block inline-block';
                document.getElementById('cf_rapp_legale').value = '';
	} 
}
function nazioneResetResi(){

if(document.getElementById('nazione_residenza_rapp_legale').value != 106)
{
	document.getElementById('indirizzo_residenza_rapp_legale').style='display: none';
	document.getElementById('tr_comune_residenza_estero_rapp_legale').style='display: block inline-block';
	document.getElementById('comune_residenza_estero_rapp_legale').style='display: block inline-block'; 
	document.getElementById('comune_residenza_estero_rapp_legale').value='';
	document.getElementById('toponimo_residenza_rapp_legale').value='';
	document.getElementById('via_residenza_rapp_legale').value='';
	document.getElementById('civico_residenza_rapp_legale').value='';
	document.getElementById('cap_residenza_rapp_legale').value='';
	document.getElementById('comune_residenza_rapp_legale').value='';
	document.getElementById('provincia_residenza_rapp_legale').value='';
	document.getElementById('comuneIdResidenzaRappLegale').value='';
	document.getElementById('topIdResidenzaRappLegale').value='';
	document.getElementById('provinciaIdResidenzaRappLegale').value='';        
}else{
	document.getElementById('indirizzo_residenza_rapp_legale').style='display: block inline-block';
	document.getElementById('tr_comune_residenza_estero_rapp_legale').style='display: none';
	document.getElementById('comune_residenza_estero_rapp_legale').style='display: none';
	document.getElementById('comune_residenza_estero_rapp_legale').value='';
}
}

function nazioneResetNazi(){

if(document.getElementById('nazione_sede_legale').value != 106)
{
	document.getElementById('indirizzo_sede_legale').style='display: none';
	document.getElementById('tr_comune_estero_sede_legale').style='display: block inline-block';
	document.getElementById('comune_estero_sede_legale').style='display: block inline-block';
	document.getElementById('comune_estero_sede_legale').value='';
            document.getElementById('cap_sede_legale').removeAttribute('required');
            
            document.getElementById('toponimo_sede_legale').value='';
	document.getElementById('via_sede_legale').value='';
	document.getElementById('civico_sede_legale').value='';
	document.getElementById('cap_sede_legale').value='';
	document.getElementById('comune_sede_legale').value='';
	document.getElementById('provincia_sede_legale').value='';
	document.getElementById('comuneIdSedeLegale').value='';
	document.getElementById('topIdSedeLegale').value='';
	document.getElementById('provinciaIdSedeLegale').value=''; 
            
}else{
	document.getElementById('indirizzo_sede_legale').style='display: block inline-block';
	document.getElementById('tr_comune_estero_sede_legale').style='display: none';
	document.getElementById('comune_estero_sede_legale').style='display: none';
	document.getElementById('comune_estero_sede_legale').value='';
            document.getElementById('cap_sede_legale').setAttribute('required', '');
}
}


function popup_date1(){
	$( '#data_nascita_rapp_legale' ).datepicker({
		  dateFormat: 'dd-mm-yy',
		  changeMonth: true,
		  changeYear: true,
		  yearRange: '-100:+3',					
		  maxDate: '-18Y', 
onSelect: function(){
document.getElementById('cf_rapp_legale').value = '';
},
		  dayNamesMin : [ 'do', 'lu', 'ma', 'me', 'gi', 've', 'sa' ],
		  monthNamesShort :['Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno', 'Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'],
		  beforeShow: function(input, inst) {
               setTimeout(function () {
                          var offsets = $('#data_nascita_rapp_legale').offset();
                          var top = offsets.top - 100;
                          inst.dpDiv.css({ top: top, left: offsets.left});
                          $(".ui-datepicker-next").hide();
							$(".ui-datepicker-prev").hide();
							$(".ui-state-default").css({'font-size': 15});
							$(".ui-datepicker-title").css({'text-align': 'center'});
							$(".ui-datepicker-calendar").css({'text-align': 'center'});
                });
              },
         onChangeMonthYear: function(year, month, inst) {
               setTimeout(function () {
                          var offsets = $('#data_nascita_rapp_legale').offset();
                          var top = offsets.top - 100;
                          inst.dpDiv.css({ top: top, left: offsets.left});
                          $(".ui-datepicker-next").hide();
							$(".ui-datepicker-prev").hide();
							$(".ui-state-default").css({'font-size': 15});
							$(".ui-datepicker-title").css({'text-align': 'center'});
							$(".ui-datepicker-calendar").css({'text-align': 'center'});
                });
              }                                                  
		});
}
	
	popup_date1();
</script>


<!-- FORZO SALTO DELLA SCELTA TIPO STABILIMENTO -->
<script>gestione_tipo_scheda_inserimento()</script> 
<!-- FORZO SALTO DELLA SCELTA TIPO STABILIMENTO -->




</body>
</html>