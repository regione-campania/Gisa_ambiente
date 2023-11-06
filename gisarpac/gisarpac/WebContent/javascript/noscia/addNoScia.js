function getNumeroRegistrazioneStabilimento(comune, fieldNumReg)
{
	if(document.getElementById(comune).value==''){
		alert('Controllare di aver inserito indirizzo dello stabilimento');
	} else {
		var codComune = document.getElementById(comune).value;
		var url = "NumeroRegistrazione.do?command=Get&comune=" + codComune;
		
		var request = $.ajax({
			url : url,
			dataType : "json"
		});

		request.done(function(result) {
			document.getElementById(fieldNumReg).value = result.numero_registrazione;
		});
		request.fail(function(jqXHR, textStatus) {
			console.log('Error');
			
		});
	}
}

function verificaEsistenzaCun(field){
	
	return verificaEsistenzaCodiceNazionale(field);
}

var campoCodice;
var esitoCunInserito = false;
function verificaEsistenzaCodiceNazionale(field)
{
	campoCodice = field;
	var cuninserito = field.value
	if(cuninserito.trim()){
		loadModalWindowCustom('Verifica Esistenza cun. Attendere');
		SuapDwr.verificaEsistenzaCodiceNazionale(parseInt('0'),cuninserito.trim(),{callback: verificaEsistenzaCodiceNazionaleCallBack,async: false});
	} else {
		esitoCunInserito = true;
	}
	return esitoCunInserito;
}

function verificaEsistenzaCodiceNazionaleCallBack(value)
{

	if (value == false)
	{
		alert('Attenzione il CUN inserito è già utilizzato.');
		campoCodice.value="";
		loadModalWindowUnlock();
		esitoCunInserito = false;
	}else {
		loadModalWindowUnlock();
		esitoCunInserito = true;
	}
}

function recuperaAsl(idComuneField, campoAsl){
    var idComune = document.getElementById(idComuneField).value;
	if(idComune != ''){
		var url = "GetAslByComune.do?command=Search&idComune=" + idComune;
		
		var request = $.ajax({
			url : url,
			dataType : "json"
		});

		request.done(function(result) {
			document.getElementById(campoAsl).value = result.description;
		});
		request.fail(function(jqXHR, textStatus) {
			console.log('Error');
			
		});
	}
}

function getCoordinate(top, address,city,prov,cap, fieldLat, fieldLong)
{
	var idfieldcivico = top.replace("toponimo", "civico"); //supposto che id dei componenti variano solo per la parte prima del _
	var addresValue = document.getElementById(top).value + ' ' + document.getElementById(address).value + ' ' + document.getElementById(idfieldcivico).value;
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
	
	//sesso = document.getElementById(sessoField).value;
	
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
		anno = nascitaCalc.substring(6,10);
		mese = nascitaCalc.substring(3,5);
		giorno = nascitaCalc.substring(0,2);
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
