function validateFormNoscia()
{
	try{
        loadModalWindowCustom("Attendere Prego...");
		return true;
	}catch(err) {
		return false;
	}
}

function validateForm()
{
	 try { 
		 	
		loadModalWindowUnlock();
		 var partitaIva = null;
       	 if ((document.getElementById("partita_iva_imp") != null) && (document.getElementById("partita_iva_imp").value != ""))
			{
       		 	partitaIva = document.getElementById("partita_iva_imp").value;
			}
			
		 var codiceFiscale = null;
		 if((document.getElementById("cf_imp") != null) && (document.getElementById("cf_imp").value != ""))
			{
				codiceFiscale = document.getElementById("cf_imp").value;
			}
	
		 if(document.getElementById("nome_rapp_leg").value == "")
			{
				alert("Il nome del rappresentante legale e' obbligatorio");
				return false;
			}
		
		 if(document.getElementById("cognome_rapp_leg").value == "")
			{
				alert("Il cognome del rappresentante legale e' obbligatorio");
				return false;
			}
			
		 if(document.getElementById("cf_rapp_leg").value == "")
			{
				alert("Il campo codice fiscale e' obbligatorio");
				return false;
			}
		 
		 
		 if(document.getElementById("nazione_nascita_rapp_leg").value == "")
			{
				alert("Il campo nazione del rappresentante legale e' obbligatorio");
				return false;
			}
		 
		 if(document.getElementById("linee_dataInizioAttivita").value == "")
			{
				alert("Il campo data inizio attivtità e' obbligatorio");
				return false;
			} 
		 
		  
		 
		 
		 if((partitaIva!= null && partitaIva=="") && (codiceFiscale!=null && codiceFiscale==""))
			{
				alert("Partita IVA non valorizzata: inserire il codice fiscale");
				return false;
			}
				
				// CONTROLLO ESISTENZA STABILIMENTO
				// Recupero variabili
				var comuneStabilimento = null;
				if(document.getElementById("comune_stab")!=null )
					{
						comuneStabilimento = document.getElementById("comuneIdStab").value;
					}
			
				var toponimoStabilimento = null;
				if(document.getElementById("toponimo_stab")!=null)
					{
						toponimoStabilimento = document.getElementById("topIdStab").value;
					}
					
				var viaStabilimento = null; 
				if (document.getElementById("via_stab") !=null)
					{
						viaStabilimento = document.getElementById("via_stab").value;
					}
				
				
				var civicoStabilimento =null; 
				if (document.getElementById("civico_stab") !=null)
					{
						civicoStabilimento = document.getElementById("civico_stab").value;
					}
				
					// controllo esistenza Stabilimento
				var esitoEsistenzaStabilimento =  checkEsistenzaStabilimento(partitaIva,codiceFiscale, comuneStabilimento, viaStabilimento, civicoStabilimento, toponimoStabilimento);				
			
	
				// Gestione ritorno controllo esistenza
				if(esitoEsistenzaStabilimento==1)
				{
					if(!confirm("UNO STABILIMENTO CON I DATI CORRISPONDENTI A QUELLI INSERITI (COMUNE, INDIRIZZO, CIVICO, TOPONIMO,  E'' GIA'' PRESENTE. CONTINUARE CON L'INSERIMENTO ? "))
						return false;
				}
				else if(esitoEsistenzaStabilimento==-1)
				{
					alert("Errore durante il controllo di esistenza stabilimento");
					return false;
				}
				
			/*
			 * if (document.getElementById("validatelp").value !='true') {
			 * alert("Completare linee di attivita'"); return false; }
			 */
				

				// Se tutto è andato bene ritorno true
		        loadModalWindowCustom("Attendere Prego...");
				return true;
	 }
	 catch(err) {
	       return false;
	    }
}

function SelectElement(id, valueToSelect)
{    
    var element = document.getElementById(id);
    element.value = valueToSelect;
}


function popolaComuneByProvincia(trElementId,elementId,selectObject) {

	// alert("Provincia:" +selectObject.value );
	var selectedProvincia =selectObject.target.selectedOptions[0].value;// selectObject.id;

	url = "GetComuneByProvincia.do?command=Search&provincia.code=" + selectedProvincia;

	var request = $.ajax({
		url : url,
		dataType : "json"
	});

	request.done(function(comuneData) {
		// empty the old results
		$("#"+elementId+"> option").remove();

		$("#"+trElementId).show();
		currentComune = comuneData;

		var i = 0;
		$("<option></option>").attr("value", '').append('').appendTo($("#"+elementId+""));
		$.each(currentComune, function(i, singleComueData) 
				{
					$("<option></option>").attr("value", singleComueData.id).append(singleComueData.nome).appendTo($("#"+elementId+""));
		});
		
		
		$("#"+elementId+"").trigger("change");
	});
	request.fail(function(jqXHR, textStatus) {

		// remove all options, empty the select
		$("#"+elementId+"> option").remove();

		// add one signle element, stating that the source isn't available
		$("#"+elementId+"").append(
				"<option>Vuoto.</option>");

		// diable the select
		$("#"+elementId+"").attr("disabled", "disabled");
	});
}


function popolaAggregazioneByMacroarea(evt,elementId,tipoAttivita, codiceAttivita) 
{
	
	if (codiceAttivita.toUpperCase() === 'EMPTY')
		{
			var selectedMacroArea = evt.options[evt.selectedIndex].value;// selectObject.value;
			url = "GetAggregazioneByMacroArea.do?command=Search&macroarea.id=" + selectedMacroArea + "&tipoAttivita="+tipoAttivita;
		}
	else
		{
		    url = "GetAggregazioneByMacroArea.do?command=Search&codice_attivita=" + codiceAttivita + "&tipoAttivita="+tipoAttivita;
		}
	
	
	var request = $.ajax({
							url : url,
							dataType : "json",
	
			success : function(aggregazioneData) 
			{              
				$("#"+elementId+"> option").remove();

				// Enanle the select component (it might be disabled).
				$("#"+elementId+"").removeAttr("disabled");

				currentAggregazione = aggregazioneData.aggregazioni;

				var i = 0;
		
				$("<option></option>").attr("value", '').append('').appendTo($("#"+elementId.id+""));
				$.each(currentAggregazione, function(i, singleAggregazioneData) 
						{
							$("<option></option>").attr("value", singleAggregazioneData.id).append(singleAggregazioneData.aggregazione).appendTo($("#"+elementId+""));
						});
				
				    console.log(currentAggregazione);
				   	SelectElement("linee_macroarea_id", currentAggregazione[0].macroarea.id)
					var element = document.getElementById(elementId);
					var event = new Event('change');
					element.dispatchEvent(event);
				},
				
			error : function(request,error)
			{

				$("#"+elementId+"> option").remove();

				$("#"+elementId+"").append("<option>Vuoto.</option>");

				$("#"+elementId+"").attr("disabled", "disabled");
			
				alert("Request: "+JSON.stringify(request));
			}
	});
	
}


function popolaAttivitaByAggregazione(evt,elementId,tipoAttivita, codiceAttivita) 
{
	
	if (codiceAttivita.toUpperCase() === 'EMPTY')
	{
		
			var selectedAggregazione = evt.options[evt.selectedIndex].value;
			url = "GetLineaAttivitaByAggregazione.do?command=Search&aggregazione.id=" + selectedAggregazione+"&TipoAttivita="+tipoAttivita;
    	
	}
	else
	{
			url = "GetLineaAttivitaByAggregazione.do?command=Search&codice_attivita=" + codiceAttivita + "&tipoAttivita="+tipoAttivita;
	}
	

	var request = $.ajax({
							url : url,
							async:false,
							dataType : "json",
	
			success : function(attivitaData) 
			{              
				$("#"+elementId+"> option").remove();

				// Enanle the select component (it might be disabled).
				$("#"+elementId+"").removeAttr("disabled");

				currentAttivita = attivitaData.attivita;

				var i = 0;
		
				$("<option></option>").attr("value", '').append('').appendTo($("#"+elementId.id+""));
				$.each(currentAttivita, function(i, singleAttivitaData) 
						{
							// $("<option></option>").attr("value",
							// singleAttivitaData.id+","+singleAttivitaData.codice_univoco).append(singleAttivitaData.linea_attivita).appendTo($("#"+elementId+""));
					          $("<option></option>").attr("value", singleAttivitaData.id).append(singleAttivitaData.linea_attivita).appendTo($("#"+elementId+""));
						});
				
					console.log(currentAttivita);
				   	SelectElement("linee_attivita_id", currentAttivita[0].id)
					var element = document.getElementById(elementId);
					var event = new Event('change');
					element.dispatchEvent(event);
					// $("#"+elementId+"").trigger("change");
				},
			error : function(request,error)
			{

				$("#"+elementId+"> option").remove();

				$("#"+elementId+"").append("<option>Vuoto.</option>");

				$("#"+elementId+"").attr("disabled", "disabled");
			
				alert("Request: "+JSON.stringify(request));
			}
	});
	
}


function getCoordinate(top, address,city,prov,cap, fieldLat, fieldLong)
{
	var addresValue = document.getElementById(top).value + ' ' + document.getElementById(address).value;
	var cityValue   = document.getElementById(city).value;
	var provValue 	= document.getElementById(prov).value;
	var capValue 	= document.getElementById(cap).value;
	
	if (document.getElementById(city).value=='')
		{

		    	 alert('Controllare di aver inserito tutti i dati necessari.');
		}
	else
		{
				url = "GetCoordinate.do?command=Search&indirizzo=" + addresValue +"&citta="+cityValue+"&provincia="+provValue+"&cap="+capValue;
		
				var request = $.ajax({
					url : url,
					dataType : "json"
				});
		
				request.done(function(coordinateData) {
					coordinateJson = coordinateData;
					
					if (coordinateJson.status !='KO')
					{
						// latitudine
						$("#"+fieldLat+"").attr("value",coordinateJson.lat);
						document.getElementById(fieldLat).value=coordinateJson.lat;
						
						// longitudine
						$("#"+fieldLong+"").attr("value",coordinateJson.long);
						document.getElementById(fieldLong).value=coordinateJson.long;
						
						console.log(coordinateJson);
					}
					else
						{
							alert('Calcolo Coordinate non riuscito.');
						}
					
		
				});
				request.fail(function(jqXHR, textStatus) {
					console.log('Error');
					
				});
	}
			
}


// Age Validation
$(function(){
    var dtToday = new Date();
    
    var month = dtToday.getMonth() + 1;
    var day = dtToday.getDate();
    var year = dtToday.getFullYear()-18;
    if(month < 10)
        month = '0' + month.toString();
    if(day < 10)
        day = '0' + day.toString();
    
    var maxDate = year + '-' + month + '-' + day;
   // alert(maxDate);
    $('#data_nascita_rapp_leg').attr('max', maxDate);  //
}); 



// Controllo nazionalità Italiana
function sbloccoComune(nazione,comune,comuneText)
{

	
	if($("#"+nazione+" option:selected").text().trim()!='Italia' || $("#"+nazione+" option:selected").val()!=106 )
	{
				$("#"+comune).attr("style","display:none")
				$("#"+comuneText).show();
				$("#"+comuneText).attr('disabled', false);
		
	}
	else
	{
				$("#"+comune).show();
				$("#"+comuneText).attr('disabled', true);
				$("#"+comuneText).hide();
				
	}
}


function sbloccoProvincia(nazione,provincia,provinciaText,comune,comuneText,btnIndirizzo)
{
	if( $("#"+nazione+" option:selected").text().trim()!='Italia' || $("#"+nazione+" option:selected").val().trim()!=106 )
	{
					
				$("#"+provincia).attr("style","display:none")
				$("#"+provinciaText).show();
				$("#"+provinciaText).attr('disabled', false);
				$("#"+comune).attr("style","display:none")
				$("#"+comuneText).show();
				$("#"+comuneText).attr('disabled', false);
			    document.getElementById(btnIndirizzo).style.visibility = 'hidden';

		
	}
	else
	{
				$("#"+provincia).show();
				$("#"+provinciaText).attr('disabled', true);
				$("#"+provinciaText).hide();
				$("#"+comune).show();
				$("#"+comuneText).attr('disabled', true);
				$("#"+comuneText).hide();
	            document.getElementById(btnIndirizzo).style.visibility = 'visible';

	}			
}


function CalcolaCF(sessoField,nomeField,cognomeField,comuneNascitaField,dataNascitaField,cfId)
{
	var nomeCalc="";
	var cognomeCalc=""; 
	var comuneCalc=""; 
	var nascitaCalc ="";
	var giorno=""; 
	var mese=""; 
	var anno=""; 
	var comuneResidenza= "" ;
	var sesso = "";

	
	if ( document.getElementById(sessoField).value == 'M' )
		sesso = "M";
	else
		sesso = "F";
	
	// sesso = document.getElementById(sessoField).value;
	
	if ( document.getElementById(nomeField).value != "" ) 
	{
		nomeCalc =  document.getElementById(nomeField).value;
		nomeCalc=nomeCalc.replace(/^\s+|\s+$/g,"").replace(/'/g,"");
	}

	if ( document.getElementById(cognomeField).value  != "" ) 
	{
		cognomeCalc =  document.getElementById(cognomeField).value;
		cognomeCalc=cognomeCalc.replace(/^\s+|\s+$/g,"").replace(/'/g,"");
	}    

	// if ( document.getElementById(comuneNascitaField).value != "" )
	if($('#'+comuneNascitaField+' option:selected').val() != -1)
	{
		// comuneCalc = comuneNascitaField.value;
		comuneCalc= $('#'+comuneNascitaField+ ' option:selected').text();
		comuneCalc = removeDiacritics(comuneCalc);
	}  

	if ( document.getElementById(dataNascitaField).value != "" ) 
	{
		nascitaCalc = document.getElementById(dataNascitaField).value;
		anno = nascitaCalc.substring(0,4);
		mese = nascitaCalc.substring(5,7);
		giorno = nascitaCalc.substring(8,10);
	}  


	if (cognomeCalc!="" && nomeCalc!="" && giorno!= "" && mese!="" && anno!= "" && sesso!= "" && comuneCalc!="")
	{
		codCF= CalcolaCodiceFiscaleCompleto(cognomeCalc, nomeCalc, giorno, mese, anno, sesso, comuneCalc);
		if (codCF=='[Comune non presente in banca dati]')
				alert(codCF);
		else{
			document.getElementById(cfId).value=codCF ;
			var element = document.getElementById(cfId);
  			var event = new Event('change');
  			element.dispatchEvent(event);
		}
	}
else
	   {
	        
	    	 alert('Inserire tutti i campi necessari per il calcolo del codice fiscale.');

	    }
}

function SetAddress(checked) {  
    if (checked) 
    {  
              document.getElementById('prov').value = document.getElementById('prov_residenza').value;   
              document.getElementById('comune').value = document.getElementById('comune_residenza').value;   
              document.getElementById('toponimo').value = document.getElementById('toponimo_residenza').value;   
              document.getElementById('via').value = document.getElementById('via_residenza').value;   
              document.getElementById('civico').value = document.getElementById('civico_residenza').value;
              document.getElementById('cap').value = document.getElementById('cap_residenza').value;
              document.getElementById('provinciaId').value = document.getElementById('provinciaIdResidenza').value;
              document.getElementById('comuneId').value = document.getElementById('comuneIdResidenza').value;
              document.getElementById('topId').value = document.getElementById('topIdResidenza').value;

              document.getElementById('provincia_sede_leg_straniero').value = document.getElementById('province_residenza_rapp_leg_straniero').value;
              document.getElementById('comune_sede_leg_straniero').value = document.getElementById('comune_residenza_rapp_leg_straniero').value;
              
  			  $('#nazione_sede_leg').val($('#nazione_residenza_rapp_leg option:selected').val());
  			  var element = document.getElementById('nazione_sede_leg');
  			  var event = new Event('change');
  			  element.dispatchEvent(event);

    }
    else 
    {  
              document.getElementById('prov').value = '';   
              document.getElementById('comune').value = '';   
              document.getElementById('toponimo').value = '';   
              document.getElementById('via').value = '';   
              document.getElementById('civico').value = '';   
              document.getElementById('cap').value = '';   
              document.getElementById('provincia_sede_leg_straniero').value = '';
              document.getElementById('comune_sede_leg_straniero').value = '';
              document.getElementById('comuneId').value = '';
              document.getElementById('topId').value = '';
              document.getElementById('provinciaId').value='';
    }  

}  




// function per operatori abusivi


function popolaComuneByAsl(evt,elementId) {

	 var selectedAsl = evt.options[evt.selectedIndex].value;
	// alert("asl:" +selectedAsl);


	url = "GetComuneByAsl.do?command=Search&asl.code=" + selectedAsl;

	var request = $.ajax({
		url : url,
		dataType : "json"
	});

	request.done(function(comuneData) {
		
		$("#"+elementId+"> option").remove();

		currentComune = comuneData.comuni;

		var i = 0;
		
		//$("<option></option>").attr("value", '').append('').appendTo($("#"+elementId+""));
		$.each(currentComune, function(i, singleComueData) 
				{
					$("<option></option>").attr("value", singleComueData.id).append(singleComueData.nome).appendTo($("#"+elementId+""));
		});
		
		$("#provincia").val(currentComune[0].provincia.description);
		$("#"+elementId+"").trigger("change");
		
	});
	request.fail(function(jqXHR, textStatus) {

		// remove all options, empty the select
		$("#"+elementId+"> option").remove();

		// add one signle element, stating that the source isn't available
		$("#"+elementId+"").append(
				"<option>Vuoto.</option>");

		// diable the select
		$("#"+elementId+"").attr("disabled", "disabled");
		
		alert("Request: "+JSON.stringify(request));

	});
}