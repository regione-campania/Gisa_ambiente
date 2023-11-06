


var idOperatoreTrovato = -1 ;
function ricercaImpresa(pIva)
{
	PopolaCombo.verificaImpresa(pIva,ricercaImpresaCallBack);
}

function ricercaImpresaCallBack (value)
{
	idOperatoreTrovato = value.idOperatore;
	if (value != null && parseInt(value.idOperatore)>0)
	{
if (document.getElementById('ragioneSociale')!=null)
{
	document.getElementById('ragioneSociale').value = value.ragioneSociale ;
}

if (document.getElementById('partitaIva')!=null)
{
	document.getElementById('partitaIva').value = value.partitaIva ;
}
if (document.getElementById('codFiscale')!=null)
{
	document.getElementById('codFiscale').value = value.codFiscale ;
}

ricercaSoggettoFisicoCallBack (value.rappLegale);




if (document.getElementById('searchcodeIdprovinciaSLinput')!=null)
{
	document.getElementById('searchcodeIdprovinciaSLinput').value = value.listaSediOperatore[0].descrizione_provincia ;
	document.getElementById('searchcodeIdprovinciaSL').appendChild(new Option(value.listaSediOperatore[0].descrizione_provincia,value.listaSediOperatore[0].idProvincia,true,true)) ;
}
else
if (document.getElementById('searchcodeIdprovinciainput')!=null)
{
	document.getElementById('searchcodeIdprovinciainput').value = value.listaSediOperatore[0].descrizione_provincia ;
	document.getElementById('searchcodeIdprovincia').appendChild(new Option(value.listaSediOperatore[0].descrizione_provincia,value.listaSediOperatore[0].idProvincia,true,true)) ;
}

if (document.getElementById('searchcodeIdComuneSLinput')!=null)
{
	document.getElementById('searchcodeIdComuneSLinput').value = value.listaSediOperatore[0].descrizioneComune ;
	
	document.getElementById('searchcodeIdComuneSL').appendChild(new Option(value.listaSediOperatore[0].descrizioneComune,value.listaSediOperatore[0].comune,true,true)) ;
}
else
if (document.getElementById('searchcodeIdComuneinput')!=null)
{
	document.getElementById('searchcodeIdComuneinput').value = value.listaSediOperatore[0].descrizioneComune ;
	
	document.getElementById('searchcodeIdComune').appendChild(new Option(value.listaSediOperatore[0].descrizioneComune,value.listaSediOperatore[0].comune,true,true)) ;
}
if (document.getElementById('viaSLinput')!=null)
{
	document.getElementById('viaSLinput').value = value.listaSediOperatore[0].via ;
	document.getElementById('viaSL').appendChild(new Option(value.listaSediOperatore[0].via,value.listaSediOperatore[0].idIndirizzo,true,true)) ;

}
else
if (document.getElementById('viainput')!=null)
{
	document.getElementById('viainput').value = value.listaSediOperatore[0].via ;
	document.getElementById('via').appendChild(new Option(value.listaSediOperatore[0].via,value.listaSediOperatore[0].idIndirizzo,true,true)) ;

}
if(window.opener==null)
	{
$("#dialog").dialog("open");
	}
else
	{
	alert('Impresa esistente'.toUpperCase());
	}
	}
	else
	{
		alert('Operatore non Esistente'.toUpperCase());
	}



}

function ricercaSoggettoFisico(cfSoggetto)
{
	PopolaCombo.verificaSoggetto(cfSoggetto,ricercaSoggettoFisicoCallBack);
}
function ricercaSoggettoFisicoStab(cfSoggetto)
{
	PopolaCombo.verificaSoggetto(cfSoggetto,ricercaSoggettoFisicoStabCallBack);
}

function ricercaSoggettoFisicoStabCallBack( value )
{
if (parseInt(value.idSoggetto)>0)
{
	
	if (document.getElementById('nomeStab')!=null)
	{
		document.getElementById('nomeStab').value = value.nome ;
	}
	
	
	if (document.getElementById('cognomeStab')!=null)
	{
		document.getElementById('cognomeStab').value = value.cognome ;
	}
	if (document.getElementById('sesso1Stab')!=null && value.sesso=='M')
	{
		document.getElementById('sesso1Stab').checked=true;
	}
	else
	{
		if (document.getElementById('sesso2Stab')!=null && value.sesso=='F')
		{
			document.getElementById('sesso2Stab').checked=true;
		}
	}
	if (document.getElementById('dataNascitaStab')!=null)
	{
		document.getElementById('dataNascitaStab').value = value.dataNascitaString ;
	}
	if (document.getElementById('comuneNascitaStab')!=null)
	{
		document.getElementById('comuneNascitaStab').value = value.comuneNascita ;
	}
	if (document.getElementById('provinciaNascitaStab')!=null)
	{
		document.getElementById('provinciaNascitaStab').value = value.provinciaNascita ;
	}
	if (document.getElementById('addressLegaleCountryStabinput')!=null)
	{
		document.getElementById('addressLegaleCountryStabinput').value = value.indirizzo.descrizione_provincia ;
		document.getElementById('addressLegaleCountryStab').appendChild(new Option(value.indirizzo.descrizione_provincia,value.indirizzo.idProvincia,true,true)) ;

		
	}
	if (document.getElementById('addressLegaleCityStabinput')!=null)
	{
		document.getElementById('addressLegaleCityStabinput').value = value.indirizzo.descrizioneComune ;
		document.getElementById('addressLegaleCityStab').appendChild(new Option(value.indirizzo.descrizioneComune,value.indirizzo.comune,true,true)) ;

	}
	if (document.getElementById('addressLegaleLine1Stabinput')!=null)
	{
		document.getElementById('addressLegaleLine1Stabinput').value = value.indirizzo.via ;
		document.getElementById('addressLegaleLine1Stab').appendChild(new Option(value.indirizzo.via,value.indirizzo.idIndirizzo,true,true)) ;
	}
	
	if (document.getElementById('codFiscaleSoggettoStab')!=null)
	{
		document.getElementById('codFiscaleSoggettoStab').value = value.codFiscale ;
		
	}
	if (document.getElementById('documentoIdentitaStab')!=null)
	{
		document.getElementById('documentoIdentitaStab').value = value.documentoIdentita ;
		
	}

}
else
{
	alert('Soggetto Fisco con codice fiscale Non Esistente');	
}
}

function ricercaSoggettoFisicoCallBack( value )
{
if (parseInt(value.idSoggetto)>0)
{
	
	if (document.getElementById('nome')!=null)
	{
		document.getElementById('nome').value = value.nome ;
	}
	
	
	if (document.getElementById('cognome')!=null)
	{
		document.getElementById('cognome').value = value.cognome ;
	}
	if (document.getElementById('sesso1')!=null && value.sesso=='M')
	{
		document.getElementById('sesso1').checked=true;
	}
	else
	{
		if (document.getElementById('sesso2')!=null && value.sesso=='F')
		{
			document.getElementById('sesso2').checked=true;
		}
	}
	if (document.getElementById('dataNascita')!=null)
	{
		document.getElementById('dataNascita').value = value.dataNascitaString ;
	}
	if (document.getElementById('comuneNascita')!=null)
	{
		document.getElementById('comuneNascita').value = value.comuneNascita ;
	}
	if (document.getElementById('provinciaNascita')!=null)
	{
		document.getElementById('provinciaNascita').value = value.provinciaNascita ;
	}
	if (document.getElementById('addressLegaleCountryinput')!=null)
	{
		document.getElementById('addressLegaleCountryinput').value = value.indirizzo.descrizione_provincia ;
		document.getElementById('addressLegaleCountry').appendChild(new Option(value.indirizzo.descrizione_provincia,value.indirizzo.idProvincia,true,true)) ;

		
	}
	if (document.getElementById('addressLegaleCityinput')!=null)
	{
		document.getElementById('addressLegaleCityinput').value = value.indirizzo.descrizioneComune ;
		document.getElementById('addressLegaleCity').appendChild(new Option(value.indirizzo.descrizioneComune,value.indirizzo.comune,true,true)) ;

	}
	if (document.getElementById('addressLegaleLine1input')!=null)
	{
		document.getElementById('addressLegaleLine1input').value = value.indirizzo.via ;
		document.getElementById('addressLegaleLine1').appendChild(new Option(value.indirizzo.via,value.indirizzo.idIndirizzo,true,true)) ;
	}
	
	if (document.getElementById('codFiscaleSoggetto')!=null)
	{
		document.getElementById('codFiscaleSoggetto').value = value.codFiscale ;
		
	}
	if (document.getElementById('documentoIdentita')!=null)
	{
		document.getElementById('documentoIdentita').value = value.documentoIdentita ;
		
	}

}
else
{
	alert('Soggetto Fisco con codice fiscale Non Esistente'.toUpperCase());	
}
}


function verificaSoggetto(codiceFiscaleField)
{
	if (codiceFiscaleField != null && codiceFiscaleField.value != 'n.d')
	{
	cf = codiceFiscaleField.value ;
	if (cf!='' && codiceFiscaleField.id == 'codFiscaleSoggetto')
		PopolaCombo.verificaSoggetto(cf,verificaSoggettoImpresaCallback);
	else
		if (cf!='' && codiceFiscaleField.id == 'codFiscaleSoggettoStab')
			PopolaCombo.verificaSoggetto(cf,verificaSoggettoStabilimentoCallback);
		else
			
		checkForm(document.addticket);

	}else
	{
		checkForm(document.addticket);
		}
}

/*Usato per le volture*/
function verificaSoggettoStabilimentoCallback(value)
{
	
	if (value != null && value.idSoggetto>0)
	{
		
	nomeEsistente = value.nome;
	//alert('stop');
	cognomeEsistente = value.cognome;
	sessoEsistente = value.sesso;
	dataNascitaEsistente = value.dataNascitaString;
	comuneNascitaEsistente = value.comuneNascita;
	provinciaNascitaEsistente = value.provinciaNascita;
	documentoIdentitaEsistente = value.documentoIdentita;
//	telefono1Esistente = value.telefono1;
//	telefono2Esistente = value.telefono2;
//	emailEsistente = value.email;
//	faxEsistente = value.fax;
	comuneResidenzaEsistente = value.indirizzo.comune ; 
	provinciaResidenzaEsistente = value.indirizzo.provincia ; 
	indirizzoResidenzaEsistente = value.indirizzo.via ; 
	descrizioneComune = value.indirizzo.descrizioneComune ;
	
	idAsl = value.idAsl ;
	descrAsl = value.descrAsl ;
//alert('stop');
	
	nome = document.getElementById('nomeStab').value ;
	cognome = document.getElementById('cognomeStab').value ;
	if (document.getElementById('sesso1Stab').checked)
		sesso = document.getElementById('sesso1Stab').value ;
	else
		sesso = document.getElementById('sesso2Stab').value ;
	dataNascita = document.getElementById('dataNascitaStab').value ;
	comuneNascita = document.getElementById('comuneNascitaStab').value ;
	provinciaNascita = document.getElementById('provinciaNascitaStab').value ;
	documento = document.getElementById('documentoIdentitaStab').value ;
//	tel1 = document.getElementById('telefono1Stab').value ;
//	tel2 = document.getElementById('telefono2Stab').value ;
//	fax = document.getElementById('faxStab').value ;
	provinciaNascita = document.getElementById('emailStab').value ;
	comuneResidenza = document.getElementById('addressLegaleCityStabinput').value ;
	provinciaResidenza = document.getElementById('addressLegaleCountryStabinput').value ;
	indirizzoResidenza = document.getElementById('addressLegaleLine1Stabinput').value ;
	if (documentoIdentitaEsistente==null)
		documentoIdentitaEsistente='';
	

	if (nomeEsistente !=nome || cognomeEsistente != cognome || sessoEsistente != sesso ||
			dataNascitaEsistente != dataNascita || comuneNascitaEsistente != comuneNascita || provinciaNascitaEsistente !=provinciaNascita ||
			documentoIdentitaEsistente!= documento || // telefono1Esistente != tel1 || telefono2Esistente != tel2 ||
			 comuneResidenzaEsistente !=comuneResidenza ||provinciaResidenza !=provinciaResidenza || indirizzoResidenzaEsistente!=indirizzoResidenza  )
	{

		
			document.getElementById("intestazioneStab").innerHTML="ATTENZIONE : PER IL CF INSERITO (RAPPRESENTANTE STABILIMENTO) ESISTE UN SOGGETTO ANAGRAFATO CON I SEGUENTI DATI. VUOI SOVRASCRIVERE ?" ;
		
	document.getElementById('nomeSoggettoStab').innerHTML = nomeEsistente ; 
 	document.getElementById('cognomeSoggettoStab').innerHTML =cognomeEsistente ;

 		document.getElementById('sessoSoggettoStab').innerHTML = sessoEsistente ;
 		document.getElementById('dataNascitaSoggettoStab').innerHTML =dataNascitaEsistente ;
		document.getElementById('comuneNascitaSoggettoStab').innerHTML =comuneNascitaEsistente ; 
		document.getElementById('documentoSoggettoStab').innerHTML =documentoIdentitaEsistente ;
		document.getElementById('provinciaNascitaSoggettoStab').innerHTML =provinciaNascitaEsistente ;
//		document.getElementById('telefono1SoggettoStab').innerHTML =telefono1Esistente ;
//		document.getElementById('telefono2SoggettoStab').innerHTML =telefono2Esistente ;
//		document.getElementById('mailSoggettoStab').innerHTML = emailEsistente;
//		document.getElementById('faxSoggettoStab').innerHTML = faxEsistente;
		document.getElementById('comuneResidenzaSoggettoStab').innerHTML = descrizioneComune ;
		document.getElementById('provinciaResidenzaSoggettoStab').innerHTML = value.indirizzo.descrizione_provincia ;
		document.getElementById('indirizzoResidenzaSoggettoStab').innerHTML =indirizzoResidenzaEsistente ;	


			document.getElementById("azioneStab").style.display="";		
		
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		//Set heigth and width to mask to fill up the whole screen
		$('#mask').css({'width':maskWidth,'height':maskHeight});
		$('#mask').fadeIn(1000);	
		$('#mask').fadeTo("slow",0.8);	
		$('#mask').show();
		//Get the window height and width
		var winH = $(window).height();
		var winW = $(window).width();

		$('#dialog5').css('top',  winH/2-$('#dialog5').height()/2);
		$('#dialog5').css('left', winW/2-$('#dialog5').width()/2);
		$('#dialog5').fadeIn(2000);   
	}
	else
	{
		checkForm(document.addticket);
		}    
		 										
	}
	else
	{
		checkForm(document.addticket);
	}
	

}

function verificaSoggettoImpresaCallback(value)
{
	
	if (value != null && value.idSoggetto>0)
	{
		
	nomeEsistente = value.nome;
	cognomeEsistente = value.cognome;
	sessoEsistente = value.sesso;
	dataNascitaEsistente = value.dataNascitaString;
	comuneNascitaEsistente = value.comuneNascita;
	provinciaNascitaEsistente = value.provinciaNascita;
	documentoIdentitaEsistente = value.documentoIdentita;
//	telefono1Esistente = value.telefono1;
//	telefono2Esistente = value.telefono2;
//	emailEsistente = value.email;
//	faxEsistente = value.fax;
	comuneResidenzaEsistente = value.indirizzo.comune ; 
	provinciaResidenzaEsistente = value.indirizzo.provincia ; 
	indirizzoResidenzaEsistente = value.indirizzo.via ; 
	descrizioneComune = value.indirizzo.descrizioneComune ;
	idAsl = value.idAsl ;
	descrAsl = value.descrAsl ;
	
	nome = document.getElementById('nome').value ;
	cognome = document.getElementById('cognome').value ;
	if (document.getElementById('sesso1').checked)
		sesso = document.getElementById('sesso1').value ;
	else
		sesso = document.getElementById('sesso2').value ;
	dataNascita = document.getElementById('dataNascita').value ;
	comuneNascita = document.getElementById('comuneNascita').value ;
	provinciaNascita = document.getElementById('provinciaNascita').value ;
	documento = document.getElementById('documentoIdentita').value ;
//	tel1 = document.getElementById('telefono1').value ;
//	tel2 = document.getElementById('telefono2').value ;
//	fax = document.getElementById('fax').value ;
//	email = document.getElementById('email').value ;
	comuneResidenza = document.getElementById('addressLegaleCity').value ;
	provinciaResidenza = document.getElementById('addressLegaleCountry').options[document.getElementById('addressLegaleCountry').selectedIndex ].text ;
	
	indirizzoResidenza = document.getElementById('addressLegaleLine1').options[document.getElementById('addressLegaleLine1').selectedIndex ].text ;
	
	if (documentoIdentitaEsistente==null)
		documentoIdentitaEsistente='';
	
	
	if (nomeEsistente !=nome || cognomeEsistente != cognome || sessoEsistente != sesso ||
			dataNascitaEsistente != dataNascita || comuneNascitaEsistente != comuneNascita || provinciaNascitaEsistente !=provinciaNascita ||
			documentoIdentitaEsistente!= documento  || comuneResidenzaEsistente !=comuneResidenza ||provinciaResidenzaEsistente !=provinciaResidenza || indirizzoResidenzaEsistente!=indirizzoResidenza  )
	{

		
			document.getElementById("intestazione").innerHTML="ATTENZIONE : PER IL CF INSERITO ESISTE UN SOGGETTO ANAGRAFATO CON I SEGUENTI DATI. VUOI SOVRASCRIVERE ?" ;
		
		document.getElementById('nomeSoggetto').innerHTML = nomeEsistente ; 
 		document.getElementById('cognomeSoggetto').innerHTML =cognomeEsistente ;
 		document.getElementById('sessoSoggetto').innerHTML = sessoEsistente ;
 		document.getElementById('dataNascitaSoggetto').innerHTML =dataNascitaEsistente ;
		document.getElementById('comuneNascitaSoggetto').innerHTML =comuneNascitaEsistente ; 
		document.getElementById('documentoSoggetto').innerHTML =documentoIdentitaEsistente ;
		document.getElementById('provinciaNascitaSoggetto').innerHTML =provinciaNascitaEsistente ;
		//document.getElementById('telefono1Soggetto').innerHTML =telefono1Esistente ;
		//document.getElementById('telefono2Soggetto').innerHTML =telefono2Esistente ;
		//document.getElementById('mailSoggetto').innerHTML = emailEsistente;
		//document.getElementById('faxSoggetto').innerHTML = faxEsistente;
		document.getElementById('comuneResidenzaSoggetto').innerHTML = descrizioneComune ;
		document.getElementById('provinciaResidenzaSoggetto').innerHTML = value.indirizzo.descrizione_provincia ;
		document.getElementById('indirizzoResidenzaSoggetto').innerHTML =indirizzoResidenzaEsistente ;	
		
			document.getElementById("azione").style.display="";		
		
		
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		//Set heigth and width to mask to fill up the whole screen
		$('#mask').css({'width':maskWidth,'height':maskHeight});
		$('#mask').fadeIn(1000);	
		$('#mask').fadeTo("slow",0.8);	
		$('#mask').show();
		//Get the window height and width
		var winH = $(window).height();
		var winW = $(window).width();

	 	$('#dialog4').css('top',  winH/2-$('#dialog4').height()/2);
		$('#dialog4').css('left', winW/2-$('#dialog4').width()/2);
		$('#dialog4').fadeIn(2000);   
	}
	else
	{
		if (document.getElementById('codFiscaleSoggettoStab')!= null)
			PopolaCombo.verificaSoggetto(document.getElementById('codFiscaleSoggettoStab'),verificaSoggettoStabilimentoCallback);
		else
			checkForm(document.addticket);

		}    
		 										
	}
	else
	{

		if (document.getElementById('codFiscaleSoggettoStab')!= null)
			PopolaCombo.verificaSoggetto(document.getElementById('codFiscaleSoggettoStab'),verificaSoggettoStabilimentoCallback);
		else
			checkForm(document.addticket);

	}
}


function pulisciCampo(input)
{
	//Inserire le prime 4 lettere
	
	if(input.value=='Inserire le prime 4 lettere')
	{
		input.value='';
	}
}
function ripristinaCampo(input)
{
	if(input.value=='')
	{
		input.value='Inserire le prime 4 lettere';
	}
}

function trim(stringa){
    while (stringa.substring(0,1) == ' '){
        stringa = stringa.substring(1, stringa.length);
    }
    while (stringa.substring(stringa.length-1, stringa.length) == ' '){
        stringa = stringa.substring(0,stringa.length-1);
    }
    return stringa;
}







var placeholder='';
var arrayItem ;    	
var text = '' ;
var trovato = false ;
    (function( $ ) {
        $.widget( "ui.combobox", {
            _create: function() {
                var input,
                    that = this,
                    select = this.element.hide(),
                    selected = select.children( ":selected" ),
                    value = selected.val() ? selected.text() : "",
                    wrapper = this.wrapper = $( "<span>" )
                        .addClass( "ui-combobox" )
                        .insertAfter( select );
 
                function removeIfInvalid(element) {
                    var value = $( element ).val(),
                        matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( value ) + "$", "i" ),
                        valid = false;
                   
                   
                    select.children( "option" ).each(function() {

                        //if ( $( this ).text().match( matcher.test(text) ) ) {
//                        if ( matcher.test(this.text) ) {
//                            
//                            this.selected = valid = true;
//                            return false;
//                        }
                    });
                    if ( valid==false ) {
                        // remove invalid value, as it didn't match anything
                        if( select[0].id =='viaStabinput' || select[0].id =='addressLegaleLine1' || select[0].id =='via' || select[0].id =='viaStab' || select[0].id =='viaSL')
                        {
                        	placeholder ="DENOMINAZIONE STRADA";
                        	
                       	 select[0].value='-1';
                       	 if (document.getElementById(select[0].id+'Testo')!=null)
                       		 document.getElementById(select[0].id+'Testo').value = value ;
						select.append('<option value=-1 selected>'+value+'</option>');
                    	return true ;
                        }
//                    }
                        else
                        {
                        	 if(  select[0].id =='addressLegaleLine1Stab')
                             {
                        		 placeholder ="DENOMINAZIONE STRADA";

                             
                            	 select[0].value='-1';
                        		document.getElementById(select[0].id+'Testo').value = value ;
     						select.append('<option value=-1 selected>'+value+'</option>');
                         	return true ;
//                             }
                         }


                            }
                       
                        
                        
                        if(select[0].id =='addressLegaleCity' && (document.getElementById('nazioneResidenza') == null || document.getElementById('nazioneResidenza').value=='106'))
                    	{
                        	placeholder ="DENOMINAZIONE COMUNE";
                    	document.getElementById('addressLegaleCityinput').value= "" ;
                	alert('COMUNE NON VALIDO PER LA PROVINCIA SELEZIONATA\n\n- Se l\'errore persiste controllare di aver selezionato la provincia della propria ASL di appartenenza.'.toUpperCase());
                    	}
                        else
                        	{
                        	if(select[0].id =='addressLegaleCity' && (document.getElementById('nazioneResidenza') != null ))
                        			{
                        		placeholder ="DENOMINAZIONE COMUNE";
                        			
                        		document.getElementById(select[0].id+'Testo').value = value ;
         						select.append('<option value=-1 selected>'+value+'</option>');
                             	return true ;
                        			}
                        	
                        	
                        	}
                        
                        
                        if(select[0].id =='comuneNascita' && (document.getElementById('nazioneNascita') == null || document.getElementById('nazioneNascita').value=='106'))
                    	{
                        	placeholder ="DENOMINAZIONE COMUNE";
                    	
                    	document.getElementById('comuneNascitainput').value= "" ;
                    	alert('COMUNE NON VALIDO');
                    	}
                        else
                        	{
                        	if(select[0].id =='comuneNascita' && (document.getElementById('nazioneNascita') != null ))
                        			{
                        		placeholder ="DENOMINAZIONE COMUNE";
                        		document.getElementById(select[0].id+'Testo').value = value ;
         						select.append('<option value=-1 selected>'+value+'</option>');
                             	return true ;
                        			}
                        	
                        	
                        	}
                        
                        if(select[0].id =='searchcodeIdComune' && (document.getElementById('nazioneSedeLegale') == null || document.getElementById('nazioneSedeLegale').value=='106') )
                        	{
                        	placeholder ="DENOMINAZIONE COMUNE";
                        	document.getElementById('searchcodeIdComuneinput').value= "" ;
                        	alert('COMUNE NON VALIDO PER LA PROVINCIA SELEZIONATA\n\n- Se l\'errore persiste controllare di aver selezionato la provincia della propria ASL di appartenenza.'.toUpperCase());
                        	}
                        else
                        	{
                        	 if(select[0].id =='searchcodeIdComune' && (document.getElementById('nazioneSedeLegale') != null))
                        			 {
                        		 placeholder ="DENOMINAZIONE COMUNE";
                        	document.getElementById(select[0].id+'Testo').value = value ;
                        	
                        			 }
                        	}
                        
                        if(select[0].id =='searchcodeIdComuneStab' )
                    	{
                        	placeholder ="DENOMINAZIONE COMUNE";
                    	document.getElementById('searchcodeIdComuneStabinput').value= "" ;
                    	alert('COMUNE NON VALIDO PER LA PROVINCIA SELEZIONATA\n\n- Se l\'errore persiste controllare di aver selezionato la provincia della propria ASL di appartenenza.'.toUpperCase());
                    	}
                        
                        if(select[0].id =='addressLegaleCountry' )
                    	{
                        	placeholder ="DENOMINAZIONE PROVINCIA";
                    	document.getElementById('addressLegaleCountryinput').value= "" ;
                    	alert('SCEGLIERE UNA PROVINCIA DALL\' ELENCO');
                    	}
                        
                        if(select[0].id =='searchcodeIdprovincia' )
                    	{
                        	placeholder ="DENOMINAZIONE PROVINCIA";
                    	document.getElementById('searchcodeIdprovinciainput').value= "" ;
                    	alert('SCEGLIERE UNA PROVINCIA DALL\' ELENCO');
                    	}
                        
                        if(select[0].id =='searchcodeIdprovinciaStab' )
                    	{
                        	placeholder ="DENOMINAZIONE PROVINCIA";
                    	document.getElementById('searchcodeIdprovinciaStabinput').value= "" ;
                    	alert('SCEGLIERE UNA PROVINCIA DALL \'ELENCO');
                    	}
                        
                        
                        
                    
                    }else{
                    	
                    }
                }
               
                if(select[0].id =='searchcodeIdComuneStab' ||  select[0].id =='searchcodeIdComune' || select[0].id =='addressLegaleCity' )
            	{
                	placeholder ="DENOMINAZIONE COMUNE";
            	
            	}
                
                if(select[0].id =='addressLegaleCountry' || select[0].id =='searchcodeIdprovincia' || select[0].id =='searchcodeIdprovinciaStab')
            	{
                	placeholder ="DENOMINAZIONE PROVINCIA";
            	
            	}
                
                if(select[0].id =='via' || select[0].id =='addressLegaleLine1'  || select[0].id =='viaStab' )
            	{
                	placeholder ="DENOMINAZIONE STRADA";
            	
            	}
                
              
                
                input = $( "<input type='text'  id='"+select[0].id+"input' class='"+select[0].className +"' name='"+select[0].id+"input' onclick='pulisciCampo(this)' onclick='ripristinaCampo(this)' placeholder='"+placeholder+"' size='50'>" )
                    .appendTo( wrapper )
                    .val( trim(value) )
                    .attr( "title", "" )
                   
                    .autocomplete({
                        delay: 0,
                        minLength: 0,
                        
                        source:  function( request, response ) {
                       	 
                        	idprovincia = '-1';
                        	toponimo = '-1';
                        	idcomune = '-1';
                        	idAsl  = '-1';
                        	nazione = '106'; //DEFAULT ITALIA
                    	if (document.getElementById('idAsl')!=null)
                    		idAsl = document.getElementById('idAsl').value;
                    	 
                    	 if(select[0].id =='searchcodeIdprovincia' || select[0].id =='searchcodeIdComune' || select[0].id =='via' )
                         {
                    		
                            

                    		 if ($("#searchcodeIdprovincia").length > 0){
                    			idprovincia = document.getElementById("searchcodeIdprovincia").value ;
                    		 }else{
                    			 idprovincia = document.getElementById("searchcodeIdprovinciaAsl").value ;
                    		 }
                    		 
                    		 toponimo=$("#toponimoSedeLegale").val();
                    		 
                    		 
                    		
                    		 if ($("#nazioneSedeLegale")!=null)
                				 nazione=$("#nazioneSedeLegale").val();
                        		
                    		 idcomune =  document.getElementById("searchcodeIdComune").value;
//                    		 inregione= document.forms[0].inregione.value;
                    		// alert(inregione);

                         }
                    	 else
                    		 if(select[0].id =='searchcodeIdprovinciaSL' || select[0].id =='searchcodeIdComuneSL' || select[0].id =='viaSL')
                    		 {
                    			 
                    			 if ($("#searchcodeIdprovinciaSL").length > 0){
                         			idprovincia = document.getElementById("searchcodeIdprovinciaSL").value ;
                         		 }else{
                         			 idprovincia = document.getElementById("searchcodeIdprovinciaAslSL").value ;
                         		 }
                         		
                    			 
                    			 
                         		 idcomune =  document.getElementById("searchcodeIdComuneSL").value;
//                         		 inregione= document.forms[0].inregioneSedeLegale.value;
                    		 }
                    	 else
                    	 if(select[0].id =='addressLegaleCity' || select[0].id =='addressLegaleCountry' || select[0].id =='addressLegaleLine1' )
                         {
                    		 
                    		 toponimo=$("#toponimoResidenza").val();
                			 
                    		 	
                			 if ($("#addressLegaleCountry").length > 0){
                				 idprovincia =document.getElementById("addressLegaleCountry").value ;
                     		 }else{
                     			 idprovincia =document.getElementById("addressLegaleCountryAsl").value ;
                     		 }
                			 
                			 if ($("#nazioneResidenza")!=null)
                				 nazione=$("#nazioneResidenza").val();
                     		
                		
                		 idcomune =  document.getElementById("addressLegaleCity").value;
        		
//                			var inregione = document.getElementById("inregione").value;
                			// alert(inregione);
                		 }
                    	 else
                    		 if(select[0].id =='comuneNascita'  )
                             {
                    			 
                    			 idprovincia=-1;
                    			 
                    		 idcomune =  document.getElementById("comuneNascita").value;
                    		 if ($("#nazioneNascita")!=null)
                				 nazione=$("#nazioneNascita").val();
//                    		
                    		 }
                    		 else
                    		 {
                    			 if(select[0].id =='addressLegaleCityStab' || select[0].id =='addressLegaleCountryStab' || select[0].id =='addressLegaleLine1Stab' )
                                 {

                        		 idprovincia =document.getElementById("addressLegaleCountryStab").value ;
                        		 idcomune =  document.getElementById("addressLegaleCityStab").value;
//                        		 inregione = document.forms[0].inregioneRappOperativoStab.value;
                        		 
                        		 
                        		 toponimo=$("#toponimoSedeOperativa").val();
                        		 
                                 }else
                                 {
                                	 
                                	 if(select[0].id =='addressLegaleCity' || select[0].id =='addressLegaleCountry' || select[0].id =='addressLegaleLine1' )
                                     {
                                		
                                		 
                                		 toponimoResidenza=$("#toponimoSedeOperativa").val();
                                		 

                            			 if ($("#addressLegaleCountry").length > 0){
                            				 idprovincia =document.getElementById("addressLegaleCountry").value ;
                                 		 }else{
                                 			 idprovincia =document.getElementById("addressLegaleCountryAsl").value ;
                                 		 }
                                 		
                            		
                            		 idcomune =  document.getElementById("addressLegaleCity").value;
                            		 var inregione= 'no';
//                            			var inregione = document.getElementById("inregione").value;
                            			// alert(inregione);
                            		 }
                                	 else
                                		 
                                		 {
                                		 
                                		 if(select[0].id =='searchcodeIdprovinciaStab' || select[0].id =='searchcodeIdComuneStab' || select[0].id =='viaStab' )
                                         {
                                    		
                                			 toponimo=$("#toponimoSedeOperativa").val();

                                    		 if ($("#searchcodeIdprovinciaStab").length > 0){
                                    			idprovincia = document.getElementById("searchcodeIdprovinciaStab").value ;
                                    		 }else{
                                    			 idprovincia = document.getElementById("searchcodeIdprovinciaAsl").value ;
                                    		 }
                                    		
                                        		inregione="si";
                                    		 idcomune =  document.getElementById("searchcodeIdComuneStab").value;
//                                    		 inregione= document.forms[0].inregione.value;
                                    		// alert(inregione);

                                         }
                                		 }
                                 }

                        		 }
                    		 
                        	 var asl='-1';
                        	 if (document.getElementById('asl_user')!=null)
                        		 asl=$('#asl_user').val();
                    	 
                    	 	var tipo_attivita='';
                    	 	if (document.getElementById('tipoAttivita')!=null)
                    	 		tipo_attivita= $('#tipoAttivita').val();
                    	 
                    	 	var tipo_impresa='';
                    	 	if (document.getElementById('tipo_impresa')!=null)
                    	 		tipo_impresa= $('#tipo_impresa').val();
                    	 
                    	 $.ajax(
                                    {	
                                    	                                 	
                                    	
                                        url:  "./ServletComuni?nazione="+nazione+"&nome="+request.term+"&toponimo="+toponimo+"&combo="+select[0].id+"&idProvincia="+idprovincia+"&idComune="+idcomune+"&inRegione="+inregione+"&idAsl="+asl+"&tipoAttivita="+tipo_attivita+"&tipo_impresa="+tipo_impresa,
                                      	dataType: "json",
                                		data: {
                                    			style: "full",
                                    			maxRows: 12,
                                    			name_startsWith: request.term
                                			   },
                                			   error: function (textStatus, errorThrown) {
                                                   alert('errore '+errorThrown +'----- '+errorThrown);
                                                  },
                                		success:function( data ) {
                                			 		
                                						arrayItem = new Array() ; 
														if(select[0].id=='viaSL' || select[0].id=='via'  || select[0].id== 'viaStab' || select[0].id== 'addressLegaleLine1'  ||  select[0].id== 'addressLegaleLine1Stab')
                                						{
    														response( $.map( data, function( item ) {
															select.append('<option value='+item.descrizionevia+'>'+ item.descrizionevia+'</option>');
                                       						 return {
                                            label: item.descrizionevia.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" +$.ui.autocomplete.escapeRegex(request.term) +")(?![^<>]*>)(?![^&;]+;)", "gi"),  "<strong>$1</strong>" ),
                                            value: item.descrizionevia ,
                                            nome: item.nome,
                                            cap: item.cap,
                                            latitudine:item.latitudine,
                                            longitudine:item.longitudine
                                           
                                            
                                        }
                                    }));
                                	}
                                	
                                    		else
                                    		{
                                    			if (select[0].id=='addressLegaleCity' || select[0].id=='addressLegaleCityStab')
    											{
    												response( $.map( data, function( item ) {
            											
    	            									select.append('<option value='+item.codice+'>'+item.descrizione+'</option>');
    	                                                return {
    	                                                    label: item.descrizione.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" +$.ui.autocomplete.escapeRegex(request.term) +")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>" ),
    	                                                    value: item.descrizione  ,
    	                                                    idAsl: item.idAsl ,
    	                                                    descrizioneAsl : item.descrizioneAsl
    	                                                  
    	                                                    
    	                                                }
    	                                            }));
    	                                        	

    												}
                                    	
                                    			else
                                    			{

                                        			
                    								response( $.map( data, function( item ) {
                											
                    									select.append('<option value='+item.codice+'>'+item.descrizione+'</option>');
                                                        return {
                                                            label: item.descrizione.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" +$.ui.autocomplete.escapeRegex(request.term) +")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>" ),
                                                            value: item.descrizione 
                                                          }
                                                    }));
                                            		}
                                     }
                                }
                            });
                         
                        },
                        select: function( event, ui ) {
                        	
                        	
                        	 select.children( "option" ).each(function() {
                                 
                        		
                                 if ( $( this ).text()==ui.item.value ) {
                                	
                                     trovato = true ;
                                     this.selected =  "true";
                                     return false;
                                 }
                                
                             }
                             

                             );
                        },
                       
                       
                        change: function( event, ui ) {
                            if ( !ui.item )
                                return removeIfInvalid( this );
                        }
                    })
                    .addClass( "ui-widget ui-widget-content ui-corner-left" );
 
                input.data( "autocomplete" )._renderItem = function( ul, item ) {
                    return $( "<li>" )
                        .data( "item.autocomplete", item )
                        .append( "<a>" + item.label + "</a>" )
                        .appendTo( ul );
                };
 
                $( "<a>" )
                    .attr( "tabIndex", -1 )
                    .attr( "title", "Mostra tutti" )
                    .tooltip()
                    .appendTo( wrapper )
                    .button({
                        icons: {
                            primary: "ui-icon-triangle-1-s"
                        },
                        text: false
                    })
                    .removeClass( "ui-corner-all" )
                    .addClass( "ui-corner-right ui-combobox-toggle" )
                    .click(function() {
                        // close if already visible
                        if ( input.autocomplete( "widget" ).is( ":visible" ) ) {
                            input.autocomplete( "close" );
                            removeIfInvalid( input );
                            return;
                        }
 
                        // work around a bug (likely same cause as #5265)
                        $( this ).blur();
 
                        // pass empty string as value to search for, displaying all results
                        input.autocomplete( "search", "" );
                        input.focus();
                    });
 
                    input
                        .tooltip({
                            position: {
                                of: this.button
                            },
                            tooltipClass: "ui-state-highlight"
                        });
            },
 
            destroy: function() {
                this.wrapper.remove();
                this.element.show();
                $.Widget.prototype.destroy.call( this );
            }
        });
    })( jQuery );
 
 
  
   
      


    $(function() {
    		var Return;
            $( "#dialog" ).dialog({
            	autoOpen: false,
                resizable: false,
                closeOnEscape: false,
                width:300,
                height:180,
                draggable: false,
                modal: true,
                buttons: {
                    "Si": function() {
            			
            				document.location.href='OperatoreAction.do?command=Details&stabId=-1&opId='+idOperatoreTrovato;
            			
                        $( this ).dialog( "close" );
                        return true;
                    },
                    "No": function() {
                        $( this ).dialog( "close" );
                        return false
                    }
                }
            });
        });
    
    $(document).ready(
    		function() {	
    			$('.window .close').click(function (e) 
    			{
    				e.preventDefault();
    				$('#mask').hide();
    				$('.window').hide();
    			});		
    		});

  