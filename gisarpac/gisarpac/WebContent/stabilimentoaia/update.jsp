<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="org.aspcfs.modules.aia.base.StabilimentoAIA"%>
<%@page import="org.aspcfs.modules.aia.base.ImpresaAIA"%>
    

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:useBean id="TipoImpresaList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="NazioniList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ComuniList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="StabilimentoDettaglio"
	class="org.aspcfs.modules.aia.base.StabilimentoAIA" scope="request" />
<jsp:useBean id="ImpresaDettaglio"
	class="org.aspcfs.modules.aia.base.ImpresaAIA" scope="request" />
<jsp:useBean id="JsonIPPC" class="org.json.JSONArray" scope="request" />
<jsp:useBean id="JsonDecreti" class="org.json.JSONArray" scope="request" />

<script src="javascript/vendor/moment.min.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>
<script src="javascript/noscia/codiceFiscale.js"></script>



<script src="javascript/gestioneanagrafica/add.js"></script>

<script>

</script>


</head>
<body>
<form name="updateStab" action="StabilimentoAIA.do?command=Update" onSubmit="return validateForm()" method="post">
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
 	 				<input type="hidden" id="id_stabilimento" name="id_stabilimento" value="<%=StabilimentoDettaglio.getIdStabilimento()%>">	
				<tbody><tr id="tr_dati_impresa_id">
					<th colspan="2">DATI IMPRESA  
							<input type="hidden" id="id_impresa" name="id_impresa" value="<%=StabilimentoDettaglio.getIdImpresa() %>">
							<input hidden type="text" id="dati_impresa_id" name="dati_impresa_id" placeholder="    VERIFICA ESISTENZA MEDIANTE PARTITA IVA" maxlength="11" pattern="[0-9]{11}" title="inserire 11 caratteri alfanumerici" size="40" onblur="myfunction();
							var objImpresa;
function myfunction()
{
	if(document.getElementById('dati_impresa_id').readOnly){
		return false;
	}
	var partita_iva = document.getElementById('dati_impresa_id').value; 
	if (trim(partita_iva.toString()) != ''){
		loadModalWindowCustom('Verifica Esistenza Impresa. Attendere');
		StabilimentoAIA.controlloEsistenzaAiaImpresa(partita_iva, {callback:recuperaDatiImpresaCallBack,async:true});
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
                                loadModalWindowUnlock();
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
	var dati = returnValue;
	var obj;
	var impresa_selezionata = null;
	obj = JSON.parse(dati);
	objImpresa = obj;
	var len = obj.length;
	if (len > 0){
		var htmlText='<br>'; 
		htmlText+='<table border=\'1\'><tr><th>Denominazione</th><th>Partita IVA</th><th>Rappresentante Legale</th><th>Sede Legale</th><th></th></tr>';
		for (i = 0; i < len; i++){
			htmlText+='<tr><td>'+obj[i].ragione_sociale_impresa+'</td><td>'+obj[i].partita_iva_impresa+'</td><td>'+obj[i].nome_rapp_legale + ' ' + obj[i].cognome_rapp_legale+ ' ' +obj[i].cf_rapp_legale+ ' '+obj[i].provincia_residenza_rapp_legale+' ' +obj[i].comune_residenza_rapp_legale+' '+obj[i].toponimo_residenza_rapp_legale+' '+obj[i].via_residenza_rapp_legale+'</td><td>'+obj[i].provincia_sede_legale+' '+obj[i].comune_sede_legale+' '+obj[i].toponimo_sede_legale+' '+obj[i].via_sede_legale+'</td><td><input type=\'radio\' id=\'radioimpsele\' name=\'radioimpsele\' value=\''+i+'\'></td></tr>';
		}
		htmlText+='</table>';
        $('#dialogimprese').html(htmlText);
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
			if (typeof(keyfield) != 'undefined' &amp;&amp; keyfield != null)
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
	
	document.getElementById('dati_impresa_id').readOnly = true;		
}">
					</th>
				</tr>
 	 				<input type="hidden" id="id_impresa_recuperata" name="id_impresa_recuperata">	
 	 				<input type="hidden" id="id_rapp_legale_recuperato" name="id_rapp_legale_recuperato">	
			<tr id="tr_ragione_sociale_impresa" title="" size="70" required="true">
				<td class="formLabel">RAGIONE SOCIALE</td>
				<td>
					<input type="text" id="ragione_sociale_impresa" name="ragione_sociale" value="<%=StabilimentoDettaglio.getRagioneSociale()%>" size="70" required="true" title="inserire ragione sociale impresa">
			</td></tr>
			<tr id="tr_partita_iva_impresa" title="" maxlength="11" pattern="[0-9]{11}" required="true">
				<td class="formLabel">PARTITA IVA</td>
				<td>
					<input type="text" id="partita_iva_impresa" name="partita_iva" value="<%=StabilimentoDettaglio.getImpresa().getPartitaIva()%>" maxlength="11" pattern="[0-9]{11}" required="true" title="inserire 11 caratteri numerici" disabled onblur="myfunction();
var objImpresa;
function myfunction()
{
	if(document.getElementById('partita_iva_impresa').readOnly){
		return false;
	}
	var partita_iva = document.getElementById('partita_iva_impresa').value; 
	if (trim(partita_iva.toString()) != ''){
		loadModalWindowCustom('Verifica Esistenza Impresa. Attendere');
		StabilimentoAIA.controlloEsistenzaAiaImpresa(partita_iva, {callback:recuperaDatiImpresaCallBack,async:true});
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
                                loadModalWindowUnlock();
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
        $('#dialogimprese').html(htmlText);
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
			if (typeof(keyfield) != 'undefined' &amp;&amp; keyfield != null)
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
			<tr id="tr_codice_fiscale_impresa" title="" maxlength="16" pattern="[A-Za-z0-9]{1,}"><td class="formLabel">CODICE FISCALE IMPRESA</td><td><input type="text" id="codice_fiscale_impresa" name="codice_fiscale_impresa" disabled value="<%=StabilimentoDettaglio.getImpresa().getCodiceFiscaleImpresa()%>" maxlength="16" pattern="[A-Za-z0-9]{1,}" title="inserire caratteri alfanumerici"></td></tr>
 				<tr id="tr_tipo_impresa" required="true">
    				<td class="formLabel">TIPO IMPRESA</td>
        			<td>
        			    <%TipoImpresaList.setJsEvent("disabled");%>
            			<%=TipoImpresaList.getHtmlSelect("tipo_impresa",StabilimentoDettaglio.getImpresa().getIdTipoImpresa())%>
        			</td>
 				</tr>
			<tr id="tr_email_impresa" title="" size="50">
				<td class="formLabel">DOMICILIO DIGITALE (PEC)</td>
				<td>
					<input type="text" id="email_impresa" name="email_impresa" value="<%=StabilimentoDettaglio.getImpresa().getDomicilioDigitale()%>" size="50">
			</td></tr>
				<tr id="tr_rapp_legale_id">
					<th colspan="2">GESTORE IMPIANTO 
					</th>
				</tr>
			<tr id="tr_nome_rapp_legale" title="" required="true" pattern="[A-Za-z รง']{1,70}">
				<td class="formLabel">NOME</td>
				<td>
					<input type="text" id="nome_rapp_legale" name="nome_rapp_leg" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getNome()%>" disabled required="true" pattern="[A-Za-z รง']{1,70}" title="inserire nome rappresentante legale" onchange="document.getElementById('cf_rapp_legale').value = '';">
			</td></tr>
			<tr id="tr_cognome_rapp_legale" title="" required="true" pattern="[A-Za-z ']{1,70}">
				<td class="formLabel">COGNOME</td>
				<td>
					<input type="text" id="cognome_rapp_legale" name="cognome_rapp_leg" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getCognome()%>" disabled required="true" pattern="[A-Za-z ']{1,70}" title="inserire cognome rappresentante legale" onchange="document.getElementById('cf_rapp_legale').value = '';">
			</td></tr>
 				<tr id="tr_sesso_rapp_legale">
    				<td class="formLabel">SESSO</td>
        			<td>
            			<select name="sesso_rapp_leg" id="sesso_rapp_legale" disabled onchange="document.getElementById('cf_rapp_legale').value = '';">
                    			<option value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getSesso()%>"><%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getSesso()%></option>                 
            			</select>
        			</td>
 				</tr>
 				<tr id="tr_nazione_nascita_rapp_legale">
    				<td class="formLabel">NAZIONE NASCITA</td>
        			<td>
        			<%NazioniList.setJsEvent("onChange=javascript:nazioneReset() disabled");%>
        			<%=NazioniList.getHtmlSelect("nazione_nascita_rapp_legale",StabilimentoDettaglio.getImpresa().getSoggettoFisico().getIdNazioneNascita())%>
        			 
        			</td>
 				</tr>
 				<tr id="tr_comune_nascita_rapp_legale">
    				<td class="formLabel">COMUNE NASCITA</td>
        			<td>
        		<%ComuniList.setJsEvent("disabled");%>
            	<%=ComuniList.getHtmlSelect("comune_nascita_rapp_legale",StabilimentoDettaglio.getImpresa().getSoggettoFisico().getComuneNascita())%>
            			
        			</td>
 				</tr>
			<tr id="tr_comune_nascita_estero_rapp_legale" title="" style="display: none;">
				<td class="formLabel">COMUNE NASCITA ESTERO</td>
				<td>
					<input type="text" disabled id="comune_nascita_estero_rapp_legale" name="comune_nascita_rapp_leg" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getComuneNascita()%>" style="display: none;">
			</td></tr>
 			<tr>
        		<td class="formLabel">DATA NASCITA</td>
        		<td>
        		
                	<input disabled placeholder="Inserisci data" type="text" id="data_nascita_rapp_legale" name="data_nascita_rapp_legale" autocomplete="off" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getDataNascitaString()%>">                
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
								<input type="text" id="cf_rapp_legale" name="codice_fiscale_rappresentante" placeholder="CODICE FISCALE" disabled value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getCodFiscale()%>" maxlength="30" pattern="[A-Za-z0-9]{1,30}" required="true" title="inserire caratteri alfanumerici" autocomplete="off" size="30" onkeydown="if(document.getElementById('nazione_nascita_rapp_legale').value != 106)
	{
             
               return true;
	}else{
		return false;
	}">
        		</td>
				</tr>
        	
 				<tr id="tr_nazione_residenza_rapp_legale">
    				<td class="formLabel">NAZIONE RESIDENZA</td>
        			<td>
        			<%NazioniList.setJsEvent("onChange=javascript:nazioneResetResi()");%>
        			<%=NazioniList.getHtmlSelect("nazione_residenza_rapp_legale",StabilimentoDettaglio.getImpresa().getSoggettoFisico().getIndirizzo().getNazione())%>
            			
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
								<input type="text" id="toponimo_residenza_rapp_legale" name="toponimo_residenza_rapp_legale" placeholder="TOPONIMO" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getIndirizzo().getDescrizioneToponimo()%>" size="10" readonly="">
								<input type="text" id="via_residenza_rapp_legale" name="via_soggfis" placeholder="VIA" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getIndirizzo().getVia()%>" size="38" readonly="">
								<input type="text" id="civico_residenza_rapp_legale" name="civico_soggfis" placeholder="CIVICO" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getIndirizzo().getCivico()%>" size="10" readonly="">
								<input type="text" id="cap_residenza_rapp_legale" name="cap_soggfis" placeholder="CAP" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getIndirizzo().getCap()%>" size="5" maxlength="5" readonly="">
								<input type="text" id="comune_residenza_rapp_legale" name="comune_residenza_rapp_legale" placeholder="COMUNE" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getIndirizzo().getDescrizioneComune()%>" size="30" readonly="">
								<input type="text" id="provincia_residenza_rapp_legale" name="provincia_residenza_rapp_legale" placeholder="PROVINCIA" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getIndirizzo().getDescrizione_provincia()%>" size="18" readonly="">
					 			<input type="button" id="ins_indirizzo_residenza_rapp_legale" value="INSERISCI INDIRIZZO" onclick="openCapWidget('toponimo_residenza_rapp_legale','topIdResidenzaRappLegale','via_residenza_rapp_legale','civico_residenza_rapp_legale','comune_residenza_rapp_legale','comuneIdResidenzaRappLegale','cap_residenza_rapp_legale','provincia_residenza_rapp_legale','provinciaIdResidenzaRappLegale')" >     
        		</td>
				</tr>
        	
 	 				<input type="hidden" id="topIdResidenzaRappLegale" name="toponimo_soggfis">	
 	 				<input type="hidden" id="comuneIdResidenzaRappLegale" name="cod_comune_soggfis">	
 	 				<input type="hidden" id="provinciaIdResidenzaRappLegale" name="cod_provincia_soggfis">	
			<tr id="tr_email_rapp_legale" title="" size="50">
				<td class="formLabel">DOMICILIO DIGITALE (PEC)</td>
				<td>
					<input type="text"  id="email_rapp_legale" name="email_rapp_leg" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getEmail()%>" size="50">
			</td></tr>
			<tr id="tr_telefono_rapp_legale" title="">
				<td class="formLabel">TELEFONO</td>
				<td>
					<input type="text" id="telefono_rapp_legale" name="telefono_rapp_leg" value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getTelefono1()%>">
			</td></tr>
				<tr id="tr_">
					<th colspan="2">RESPONSABILE IMPIANTO 
					</th>
				</tr>
			<tr id="tr_nome_resp_stab" title="">
				<td class="formLabel">NOME</td>
				<td>
					<input type="text" id="nome_resp_stab" name="nome_resp_stab" value="<%=StabilimentoDettaglio.getResponsabile().getNome()%>">
			</td></tr>
			<tr id="tr_cognome_resp_stab" title="">
				<td class="formLabel">COGNOME</td>
				<td>
					<input type="text" id="cognome_resp_stab" name="cognome_resp_stab" value="<%=StabilimentoDettaglio.getResponsabile().getCognome()%>">
			</td></tr>
			<tr id="tr_cf_resp_stab" title="">
				<td class="formLabel">CODICE FISCALE</td>
				<td>
					<input type="text" id="cf_resp_stab" name="cf_resp_stab" value="<%=StabilimentoDettaglio.getResponsabile().getCodFiscale()%>">
			</td></tr>
				
 	 				<div id='dialogimprese'/>
<div id='popupippc'/>
<script src="javascript/noscia/widget.js"></script>
<script src="javascript/gestioneanagrafica/aggiungiIppc.js"></script>
</tbody></table>            
<br><br>
<center>

<button type="submit" class="yellowBigButton" style="width: 250px;">SALVA</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="yellowBigButton" style="width: 250px;" value="ANNULLA" onclick="var link = 'StabilimentoAIA.do?command=Details&stabId=<%=StabilimentoDettaglio.getIdStabilimento()%>';			
       		window.location.href=link;">

</center>
</div>
</form>
<br><br>
<script>





function validateForm()
{

	if(document.getElementById("nazione_residenza_rapp_legale").value==-1 && document.getElementById("cap_residenza_rapp_legale").value!=""){
		alert("Valorizzare nazione residenza gestore impianto.")
		return false;
	}
	if(document.getElementById("nazione_residenza_rapp_legale").value==106 && document.getElementById("cap_residenza_rapp_legale").value==""){
		alert("Valorizzare indirizzo residenza gestore impianto.")
		return false;
	}
	
	if((document.getElementById("nazione_residenza_rapp_legale").value!=106 && document.getElementById("nazione_residenza_rapp_legale").value!=-1) && document.getElementById("comune_residenza_estero_rapp_legale").value==""){
		alert("Valorizzare comune residenza estero gestore impianto.")
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
                document.getElementById('comune_nascita_estero_rapp_legale').disabled = true;
                document.getElementById('comune_nascita_estero_rapp_legale').value='';
                document.getElementById('comune_nascita_rapp_legale').disabled = true;
		document.getElementById('calcola_cf_rapp_legale').style='display: none';
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
<!-- FORZO SALTO DELLA SCELTA TIPO STABILIMENTO -->


<script>


if(document.getElementById("nazione_residenza_rapp_legale").value!=106){
	nazioneResetResi();
	document.getElementById("comune_residenza_estero_rapp_legale").value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getIndirizzo().getComuneTesto()%>"
}


if(document.getElementById("nazione_nascita_rapp_legale").value!=106){
	nazioneReset();
	document.getElementById("comune_nascita_estero_rapp_legale").value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getComuneNascita()%>"
}
</script>

</body>
</html>