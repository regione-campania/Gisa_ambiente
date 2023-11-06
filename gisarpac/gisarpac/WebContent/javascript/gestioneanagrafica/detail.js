function setValore(key, value){
	var campoOld = $('#'+key);
	
	if (campoOld==null)
		return false;
	
	if (campoOld.attr('type') != 'hidden'){
			campoOld.replaceWith(value);
		}
		
}

function setExtra(key, value){
	
	var newRow = $("<tr>");
    newRow.append(value);
    newRow.insertAfter($('#trExtra'));
}

function setLinea(key, value){
	
	var newRow = $("<tr>");
    newRow.append(value);
    newRow.insertAfter($('#trLinee'));
}

function VisualizzaDettaglio(arrAnagrafica, arrExtra, arrLinee){
	
	document.getElementById("dettaglio").style = "display: block inline-block";
	var value;
	for (var key in arrAnagrafica) {
	    value = arrAnagrafica[key];
	   setValore(key, value);
	}
	
	for (var key in arrExtra) {
	    value = arrExtra[key];
    	setExtra(key, value);
	}
	
	for (var key in arrLinee) {
	    value = arrLinee[key];
    	setLinea(key, value);
	}
	
	$("div#dettaglio :input").each(function(){
		 var input = $(this); // This is the jquery object of the input, do what you will
		 if (input.attr('type') == 'button'){
			 input.hide();
		 }
		 else {
			input.prop('disabled', true);
            input.hide();
			}
		});
	$("#dati_impresa_id").hide();
	
	if(document.getElementById("tipo_attivita_stab_template").value == '1' && document.getElementById("codice_linea_template").value == "TEST-SCIA"){
		document.getElementById('coordinate_sede_legale').style = 'display: none';
	}
	
	if(document.getElementById("tipo_attivita_stab_template").value == '2'  && document.getElementById("codice_linea_template").value == "TEST-SCIA"){
		document.getElementById('tr_nazione_sede_legale').style = 'display: none'; 
		document.getElementById('tr_stabilimento_id_sezione').style = 'display: none';
		document.getElementById('indirizzo_stabilimento').style = 'display: none';
		document.getElementById('coordinate_stabilimento').style = 'display: none';
	}
	
}