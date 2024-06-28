$(function() {
	
	 $('#popupippc').dialog({
		title : 'AGGIUNGI CODICE IPPC',
         autoOpen: false,
         resizable: false,
         closeOnEscape: false,
         width:1200,
         height:550,
         draggable: false,
         modal: true,
	     buttons: {
			 'AGGIUNGI': function() {   
				var data_inizio_attivita = document.getElementById('data_inizio').value.toString();
				var data_fine_attivita = document.getElementById('data_fine').value.toString();
				var tipo_carat_id = document.getElementById('tipo_carattere').value.toString();
				var tipo_carat_testo;
				var principale = document.getElementById("principale").checked;
	
				if (document.getElementById('tipo_carattere').value == '1'){
					tipo_carat_testo = 'PERMANENTE';
				} else {
					tipo_carat_testo = 'TEMPORANEA';
				}
				var cod_univ_ml = document.getElementById("descrizione").value;
				var cun_popup = document.getElementById('cun_popup').value;
				var ok_insert_popup = verifica_inserimento_ippc(cod_univ_ml, data_inizio_attivita, data_fine_attivita, tipo_carat_id, cun_popup);
				if(ok_insert_popup){
					aggiungi_riga(tipo_carat_testo, data_inizio_attivita, data_fine_attivita, cod_univ_ml, tipo_carat_id,cun_popup,principale);
					loadModalWindowUnlock();
					$( this ).dialog('close');
				}
                
			},
			'ANNULLA': function() {
                                loadModalWindowUnlock();
				$( this ).dialog('close');
			}
      }
 });
	 
});

function aggiungi_ippc(){
	var htmlText='<br>';
	htmlText += '<fieldset>'+
					'<legend><b>INDICARE CODICE IPPC</b></legend>'+
					'<table style="width:100%;">'+
						'<tr>'+
							'<td colspan="2" width="100%" align="left">'+
								'<div style="width:100%;"></div>'+
							'</td>'+
						'</tr>';
	
	if(document.getElementById('tipo_linee_attivita').value == '1'){
		htmlText += '<tr id="tr_tipoattivita_popup">'+
						'<td style="width:10%" align="left">'+
							'<p>TIPO ATTIVITA</p>'+
						'</td>'+
						'<td style="width:80%" align="left">'+
							'<input type="hidden" id="tipoattivita" value="1"/>CON SEDE FISSA' +
						'</td>'+
					'</tr>';
	} else if (document.getElementById('tipo_linee_attivita').value == '2') {
		htmlText += '<tr id="tr_tipoattivita_popup">'+
						'<td style="width:10%" align="left">'+
							'<p>TIPO ATTIVITA</p>'+
						'</td>'+
						'<td style="width:80%" align="left">'+
							'<input type="hidden" id="tipoattivita" value="2"/>SENZA SEDE FISSA' +
						'</td>'+
					'</tr>';
	} else {
		htmlText += '<tr id="tr_tipoattivita_popup">'+
						'<td style="width:10%" align="left">'+
							'<p>TIPO ATTIVITA</p>'+
						'</td>'+
						'<td style="width:80%" align="left">'+
							'<select id="tipoattivita" >' +
								'<option value="1" selected="selected"> CON SEDE FISSA </option>' +
								'<option value="2"> SENZA SEDE FISSA </option>' +
							'</select>'+
						'</td>'+
					'</tr>';
	}
	
						
	htmlText += '<tr id="tr_categoria_popup">'+
							'<td style="width:10%" align="left">'+
								'<p>CATEGORIA IMPIANTO</p>'+
							'</td>'+
							'<td style="width:80%" align="left">'+
								'<select id="categoria"><option value="" selected="selected">SELEZIONA CATEGORIA IMPIANTO</option></select>'+
							'</td>'+
						'</tr>'+
						
						'<tr id="tr_ippc_popup">'+
							'<td style="width:10%" align="left">'+
								'<p>CODICE IPPC ATTIVITA</p>'+
								'</td>'+
								'<td style="width:80%" align="left">'+
									'<select id="ippc"><option value="" selected="selected">SELEZIONA CODICE IPPC ATTIVITA</option></select>'+
									'<input type="checkbox" id="principale" name="principale" checked />'+
								    '<label for="principale">Principale</label>'+
									'</td>'+
				
						'</tr>'+
						
						'<tr id="tr_descrizione_popup">'+
							'<td style="width:10%" align="left">'+
								'<p>DESCRIZIONE ATTIVITA</p>'+
							'</td>'+
							'<td style="width:80%" align="left">'+
								'<select id="descrizione"></select>'+
							'</td>'+
						'</tr>'+

						'<tr>'+
							'<td colspan="2" align="left">'+
								'<div></div>'+
							'</td>'+
						'</tr>'+
						
						'<tr id="tr_tipo_carattere_popup" STYLE="display:none">'+
							'<td style="width:10%" align="left">'+
								'<p>TIPO CARATTERE</p>'+
							'</td>'+
							'<td style="width:80%" align="left">'+
								'<select id="tipo_carattere">'+
									'<option value="1">PERMANENTE</option>' +
									'<option value="2">TEMPORANEA</option>' +
								'</select>'+
							'</td>'+
						'</tr>'+
						
						'<tr id="tr_data_inizio_popup">'+
							'<td style="width:15%" align="left">' +
								'<p>DATA INIZIO VALIDITA CODICE IPPC</p>' +
							'</td>'+
							'<td style="width:80%" align="left">' +
								'<input placeholder="DATA INIZIO VALIDITA CODICE IPPC" type="text" id="data_inizio" autocomplete="off">' +
							 '</td>' +
						 '</tr>' +
						 
						 '<tr id="tr_data_fine_popup">'+
							 '<td style="width:15%" align="left">' +
								'<p>DATA FINE ATTIVITA</p>' +
							'</td>'+
							'<td style="width:80%" align="left">' +
								'<input placeholder="DATA FINE ATTIVITA" type="text" id="data_fine" autocomplete="off">' +
							'</td>'+
						'</tr>'+
						
					'</table>'+
				'</fieldset>'+
				'<br><fieldset id="field_cun" STYLE="display:none">' +
				'<legend><b>DATI AGGIUNTIVI IPPC</b></legend>'+
					'<table style="width:100%;">'+
						'<tr>'+
							'<td colspan="2" align="left">'+
								'<div></div>'+
							'</td>'+
						'</tr>'+
						'<tr id="tr_data_cun" STYLE="display:none">'+
							'<td style="width:15%" align="left">' +
								'<p>CUN</p>' +
							'</td>'+
							'<td style="width:80%" align="left">' +
								'<input placeholder="CUN" type="text" id="cun_popup" autocomplete="off">' +
								'&emsp; <font color="red">' +
								'Attenzione! In caso di OSM RICONOSCIUTI il CUN va inserito senza il carattere ALFA poiche tale carattere viene automaticamente generato dal sistema' +
								'</font>' +
							 '</td>' +
						 '</tr>' +
					
					'</table>'+
				'</fieldset>';
	
	$('#popupippc').html(htmlText);
	$('#popupippc').dialog('open');
	$('#tr_ippc_popup').css({"visibility":"hidden"});
	$('#tr_descrizione_popup').css({"visibility":"hidden"});
	$('#tr_data_fine_popup').css({"visibility":"hidden"});
	popup_date('data_inizio','0');
	popup_date('data_fine','+3Y');
	$('#tipo_carattere').change(function(){
		if(document.getElementById('tipo_carattere').value == '2'){
			$('#data_fine').val(null);
			$('#tr_data_fine_popup').css({"visibility":"visible"});
		} else {
			$('#data_fine').val(null);
			$('#tr_data_fine_popup').css({"visibility":"hidden"});
		}
	});
	
	popola_select_popup('GestioneAnagraficaGetDatiCategoriaIppc.do?command=Search&tiporichiesta=categoria&tipoattivita=' +
			document.getElementById('tipoattivita').value, 'categoria'); 
	
	$('#tipoattivita').change(function(){
		if(document.getElementById('tipoattivita').value == '1'){ //sede fissa
			$('#categoria').children().remove();
			$('#categoria').append('<option value="" selected="selected">SELEZIONA CATEGORIA IMPIANTO</option>');
			$('#ippc').children().remove();
			$('#ippc').append('<option value="" selected="selected">SELEZIONA CODICE IPPC ATTIVITA</option>');
			$('#tr_ippc_popup').css({"visibility":"hidden"});
			$('#descrizione').children().remove();
			$('#descrizione').append('<option value="" selected="selected">SELEZIONA DESCRIZIONE ATTIVITA</option>');
			$('#tr_descrizione_popup').css({"visibility":"hidden"});
			popola_select_popup('GestioneAnagraficaGetDatiCategoriaIppc.do?command=Search&tiporichiesta=categoria&tipoattivita=' +
					document.getElementById('tipoattivita').value, 'categoria');
		}else{ //senza sede fissa
			$('#categoria').children().remove();
			$('#categoria').append('<option value="" selected="selected">SELEZIONA CATEGORIA IMPIANTO</option>');
			$('#ippc').children().remove();
			$('#ippc').append('<option value="" selected="selected">SELEZIONA CODICE IPPC ATTIVITA</option>');
			$('#tr_ippc_popup').css({"visibility":"hidden"});
			$('#descrizione').children().remove();
			$('#descrizione').append('<option value="" selected="selected">SELEZIONA DESCRIZIONE ATTIVITA</option>');
			$('#tr_descrizione_popup').css({"visibility":"hidden"});
			popola_select_popup('GestioneAnagraficaGetDatiCategoriaIppc.do?command=Search&tiporichiesta=categoria&tipoattivita=' +
					document.getElementById('tipoattivita').value, 'categoria');
		}		
	});
	
	$('#categoria').change(function(){
		if(document.getElementById('categoria').value != ''){
			$('#ippc').children().remove();
			$('#ippc').append('<option value="" selected="selected">SELEZIONA CODICE IPPC ATTIVITA</option>');
			$('#tr_ippc_popup').css({"visibility":"visible"});
			$('#descrizione').children().remove();
			$('#descrizione').append('<option value="" selected="selected">SELEZIONA DESCRIZIONE ATTIVITA</option>');
			$('#tr_descrizione_popup').css({"visibility":"hidden"});
			popola_select_popup('GestioneAnagraficaGetDatiCategoriaIppc.do?command=Search&tiporichiesta=ippc&idcategoria='+
					document.getElementById('categoria').value + '&tipoattivita=' +
						document.getElementById('tipoattivita').value, 'ippc');
		}else{
			$('#ippc').children().remove();
			$('#ippc').append('<option value="" selected="selected">SELEZIONA CODICE IPPC ATTIVITA</option>');
			$('#tr_ippc_popup').css({"visibility":"hidden"});
			$('#descrizione').children().remove();
			$('#descrizione').append('<option value="" selected="selected">SELEZIONA DESCRIZIONE ATTIVITA</option>');
			$('#tr_descrizione_popup').css({"visibility":"hidden"});
		}
	});
	
	$('#ippc').change(function(){
		if(document.getElementById('ippc').value != ''){
			$('#descrizione').children().remove();
			$('#descrizione').append('<option value="" selected="selected">SELEZIONA DESCRIZIONE ATTIVITA</option>');
			$('#tr_descrizione_popup').css({"visibility":"visible"});
			popola_select_popup('GestioneAnagraficaGetDatiCategoriaIppc.do?command=Search&tiporichiesta=descrizione&idippc='+
					document.getElementById('ippc').value + '&tipoattivita=' +
					document.getElementById('tipoattivita').value, 'descrizione');
		}else{
			$('#descrizione').children().remove();
			$('#descrizione').append('<option value="" selected="selected">SELEZIONA DESCRIZIONE ATTIVITA</option>');
			$('#tr_descrizione_popup').css({"visibility":"hidden"});
			
		}
	});
}


function popola_select_popup(urlservice, id_elemento){
	
	loadModalWindow();
  	$.ajax({  	    
        url: urlservice,
        dataType: "text",
        async:false,
        success: function(dati) { 	 
	   	    var obj;
	   	    try {
				console.log(dati);
	       		obj = JSON.parse(dati);
			} catch (e) {
				//alert(e instanceof SyntaxError); // true
				loadModalWindowUnlock();
				return false;
			}
			
			obj = JSON.parse(dati);	  	
		  	for (var i = 0; i < obj.length; i++) {
		  		$('#'+id_elemento).append('<option value="'+obj[i].code+'">'+obj[i].description+'</option>');
		  	}
		  	loadModalWindowUnlock();
        },
        fail: function(xhr, textStatus, errorThrown){
        	alert('request failed');
       	}
          
  	});
  	
}

function popup_date(elemento_html_data,max_data){
	$( '#' + elemento_html_data ).datepicker({
		  dateFormat: 'dd-mm-yy',
		  changeMonth: true,
		  changeYear: true,
		  yearRange: '-100:+3',
		  maxDate: max_data,
		  dayNamesMin : [ 'do', 'lu', 'ma', 'me', 'gi', 've', 'sa' ],
		  monthNamesShort :['Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno', 'Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'],
		  beforeShow: function(input, inst) {
               setTimeout(function () {
                          var offsets = $('#' + elemento_html_data).offset();
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
                          var offsets = $('#' + elemento_html_data).offset();
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
function verifica_inserimento_ippc(cod_univ_ml, data_inizio_attivita, data_fine_attivita, tipo_carattere_id, cun_popup_inserito){
	var esito = true;
	var messaggioerrore = '';
	var esitocun = false;
	
	if(tipo_carattere_id == '1'){
		if(cod_univ_ml != '' && data_inizio_attivita != ''){
			esito = true;
		}else{
			messaggioerrore = 'selezionare i campi obbligatori';	
			esito = false;
		}
	}else if(tipo_carattere_id == '2'){
		if(cod_univ_ml != '' && data_inizio_attivita != '' && data_fine_attivita != ''){
			
			var arr1 = data_inizio_attivita.split("-");
			var arr2 = data_fine_attivita.split("-");
			
			var d1 = new Date(arr1[2],arr1[1]-1,arr1[0]);
			var d2 = new Date(arr2[2],arr2[1]-1,arr2[0]);
			
			var r1 = d1.getTime();
			var r2 = d2.getTime();
			
			var diff = r2 - r1;

			if(diff < 0){
				messaggioerrore = 'la data inizio validita codice ippc non puo essere successiva alla data fine attivita';
				esito = false;
			} 
			
		}else{
			messaggioerrore = 'selezionare i campi obbligatori';
			esito = false;
		}
	}
	
	
for( var i = 0; i < document.getElementsByName("check_descrizione_codice_univoco").length; i++){
		
		
		if(cod_univ_ml == document.getElementsByName("check_descrizione_codice_univoco")[i].value){
			messaggioerrore="Attenzione! Codice IPPC selezionato piu\' volte"
				esito = false;
		}
	}
	
	
	
	if(esito == false){
	alert(messaggioerrore)
	}else{
		
	if(document.getElementById("principale").checked){
		
		if(document.getElementById("principale_check").value=="true"){
			messaggioerrore = 'Esiste gia\' un codice IPPC principale';
			esito = false;
			alert(messaggioerrore)
		}
		document.getElementById("principale_check").value="true"
	}
	
		
		
	}
		
return esito;
}

function aggiungi_riga(tipo_carattere, data_inizio_attivita, data_fine_attivita, codice_univoco, tipo_carattere_id, cun,principale){
	var urlservice = "GestioneAnagraficaGetDatiCategoriaIppc.do?command=Search&tiporichiesta=datidescrizione&iddescrizione=" + document.getElementById("descrizione").value;
	loadModalWindow();
  	$.ajax({  	    
        url: urlservice,
        dataType: "text",
        async:false,
        success: function(dati) { 	 
	   	    var obj;
	   	    try {
				console.log(dati);
	       		obj = JSON.parse(dati);
			} catch (e) {
				//alert(e instanceof SyntaxError); // true
				loadModalWindowUnlock();
				return false;
			}
			
			obj = JSON.parse(dati);	  
		  	for (var i = 0; i < obj.length; i++) {
		  		aggiungi_riga_gui(
		  				obj[i].categoria, 
		  				obj[i].ippc, 
		  				obj[i].attivita, 
		  				tipo_carattere, 
		  				data_inizio_attivita, 
		  				data_fine_attivita, 
		  				obj[i].codice, 
		  				tipo_carattere_id,
		  				cun,
		  				principale)
		  				
		  	}
		  	loadModalWindowUnlock();
        },
        fail: function(xhr, textStatus, errorThrown){
        	alert('request failed');
       	}
          
  	});
}

function aggiungi_riga_gui(categoria, ippc, attivita, tipo_carattere, data_inizio_attivita, data_fine_attivita, codice_univoco, tipo_carattere_id, cun,principale){
		
	//aggiungo il componente tr
	var numero_ippc = document.getElementById('numero_ippc').value;					
	var n_descrizione = 'descrizione_' + numero_ippc;
	var td_button_elimina = 'td_button_elimina_' + + numero_ippc;
	
	var trfield = document.createElement('tr');
		trfield.setAttribute('id',n_descrizione);
		document.getElementById('tabella_linee').appendChild(trfield);
	//aggiungo i componenti td 
	var tdfield1 = document.createElement('td');
	    tdfield1.setAttribute('class', 'formLabel');
	    tdfield1.setAttribute('id','td1_'+n_descrizione);
		tdfield1.innerHTML = 'Codice IPPC';
		document.getElementById(n_descrizione).appendChild(tdfield1);
	//aggiungo i componenti td	
	var tdfield2 = document.createElement('td');
	var cuntext = '';
	if (cun != ''){
		cuntext = '<br><b>cun</b>: &emsp;'+cun;
	} 
	
	var tipo_attivita_label = '';
	if(document.getElementById('tipoattivita').value == '1'){
		tipo_attivita_label = 'con sede fissa';
	} else {
		tipo_attivita_label = 'senza sede fissa';
	}
	
	if(tipo_carattere_id == '2')
		{
		if(principale)
		{
		  var principale1 = 'SI'
		}
		else
		{
			var principale1 = 'NO'
			}
			tdfield2.innerHTML = '<span>'+categoria+
								'<br>->'+ippc+
								'<br>->'+attivita+
								'<br>PRINCIPALE: '+principale1+
								'<br><br><b>tipo attivita</b>: &emsp;'+tipo_attivita_label+
								'<br><b>tipo carattere</b>: &emsp;'+tipo_carattere+
								'<br><b>data inizio validita codice ippc</b>: &emsp;'+data_inizio_attivita+
								'<br><b>data fine attivita</b>: &emsp;'+data_fine_attivita+
								cuntext + '<br></span>';
		}else{

			if(principale)
			{
			  var principale1 = 'SI'
			}
			else
			{
				var principale1 = 'NO'
				}
			tdfield2.innerHTML = '<span>'+categoria+
								'<br>->'+ippc+
								'<br>->'+attivita+
								'<br>PRINCIPALE: '+principale1+
								'<br><br><b>tipo attivita</b>: &emsp;'+tipo_attivita_label+
								'<br><b>tipo carattere</b>: &emsp;'+tipo_carattere+
								'<br><b>data inizio validita codice ippc</b>: &emsp;'+data_inizio_attivita+
								cuntext + '<br></span>';
		}
		
		document.getElementById(n_descrizione).appendChild(tdfield2);

    var onclick_event = 'rimuovi_ippc(\''+ n_descrizione +'\')';	
	var buttonfield = document.createElement('input');
	    buttonfield.setAttribute('type','button');
	    buttonfield.setAttribute('value','elimina Ippc');
		buttonfield.setAttribute('onclick', onclick_event);
		document.getElementById('td1_'+n_descrizione).appendChild(buttonfield);
	//aggiungo i componenti hidden 
	var hiddenfield1 = document.createElement('input');
		hiddenfield1.setAttribute('type','hidden');
		hiddenfield1.setAttribute('id','descrizione_' + numero_ippc + '_codice_univoco');
		hiddenfield1.setAttribute('name', 'descrizione_' + numero_ippc + '_codice_univoco');
		hiddenfield1.setAttribute('value', codice_univoco);
		document.getElementById(n_descrizione).appendChild(hiddenfield1);
		
	var hiddenfield2 = document.createElement('input');
		hiddenfield2.setAttribute('type','hidden');
		hiddenfield2.setAttribute('id','descrizione_' + numero_ippc + '_data_inizio_attivita');
		hiddenfield2.setAttribute('name', 'descrizione_' + numero_ippc + '_data_inizio_attivita');
		hiddenfield2.setAttribute('value',data_inizio_attivita);
		document.getElementById(n_descrizione).appendChild(hiddenfield2);
	
	var hiddenfield3 = document.createElement('input');
		hiddenfield3.setAttribute('type','hidden');
		hiddenfield3.setAttribute('id','descrizione_' + numero_ippc + '_data_fine_attivita');
		hiddenfield3.setAttribute('name', 'descrizione_' + numero_ippc + '_data_fine_attivita');
		hiddenfield3.setAttribute('value',data_fine_attivita);
		document.getElementById(n_descrizione).appendChild(hiddenfield3);
	
	var hiddenfield4 = document.createElement('input');
		hiddenfield4.setAttribute('type','hidden');
		hiddenfield4.setAttribute('id','descrizione_' + numero_ippc + '_tipo_carattere_attivita');
		hiddenfield4.setAttribute('name', 'descrizione_' + numero_ippc + '_tipo_carattere_attivita');
		hiddenfield4.setAttribute('value',tipo_carattere_id);
		document.getElementById(n_descrizione).appendChild(hiddenfield4);
	
	var hiddenfield5 = document.createElement('input');
		hiddenfield5.setAttribute('type','hidden');
		hiddenfield5.setAttribute('id','descrizione_' + numero_ippc + '_num_riconoscimento');
		hiddenfield5.setAttribute('name', 'descrizione_' + numero_ippc + '_num_riconoscimento');
		hiddenfield5.setAttribute('value',cun);
		document.getElementById(n_descrizione).appendChild(hiddenfield5);
		
	var hiddenfield6 = document.createElement('input');
		hiddenfield6.setAttribute('type','hidden');
		hiddenfield6.setAttribute('id','descrizione_' + numero_ippc + '_tipo_attivita');
		hiddenfield6.setAttribute('name', 'descrizione_' + numero_ippc + '_tipo_attivita');
		hiddenfield6.setAttribute('value',document.getElementById('tipoattivita').value);
		document.getElementById(n_descrizione).appendChild(hiddenfield6);
		
		var hiddenfield7 = document.createElement('input');
		hiddenfield7.setAttribute('type','hidden');
		hiddenfield7.setAttribute('id','descrizione_' + numero_ippc + '_principale');
		hiddenfield7.setAttribute('name', 'descrizione_' + numero_ippc + '_principale');
		hiddenfield7.setAttribute('value',document.getElementById('principale').checked);
		document.getElementById(n_descrizione).appendChild(hiddenfield7);
		
		
		
		
		var hiddenfield9 = document.createElement('input');
		hiddenfield9.setAttribute('type','hidden');
		hiddenfield9.setAttribute('id','check_descrizione_' + numero_ippc + '_codice_univoco');
		hiddenfield9.setAttribute('name', 'check_descrizione_codice_univoco');
		hiddenfield9.setAttribute('value', codice_univoco);
		document.getElementById(n_descrizione).appendChild(hiddenfield9);
								
	numero_ippc = parseInt(numero_ippc) + 1;
	var linee_effettive = document.getElementById('numero_ippc_effettivo').value;
	document.getElementById('numero_ippc_effettivo').value = parseInt(linee_effettive) + 1;
	document.getElementById('numero_ippc').value = numero_ippc;
}
				

function rimuovi_ippc(idtr){
	var child = document.getElementById(idtr);
    if(document.getElementById(idtr+"_principale").value=="true")
    	document.getElementById("principale_check").value="false"
	child.parentNode.removeChild(child);
	var linee_effettive = document.getElementById('numero_ippc_effettivo').value;
	document.getElementById('numero_ippc_effettivo').value = parseInt(linee_effettive) - 1;
	
}

