
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

  